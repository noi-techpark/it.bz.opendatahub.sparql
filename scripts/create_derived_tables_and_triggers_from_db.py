#!/usr/bin/python3

from itertools import chain
from typing import List, Any, Dict, TypeVar
import getopt
import sys
from functools import reduce

import psycopg2

T = TypeVar('T')  # Declare type variable

PG_MAX_IDENTIFIER_LENGTH = 63


class AttrPath:
    def __init__(self, path):
        super().__init__()
        self._path = path

    def __str__(self):
        return "->".join(self._path)

    def __repr__(self):
        return self.__str__()

    def __eq__(self, other):
        return isinstance(other, AttrPath) and self._path == other._path

    def __hash__(self):
        return hash(str(self))

    def add(self, e: str):
        lc = self._path.copy()
        lc.append(e)
        return AttrPath(lc)

    def is_empty(self):
        return len(self._path) == 0

    def as_json_path(self):
        return "\"data\"" \
               + ("->" if len(self._path) > 1 else "") \
               + "->".join(["'{}'".format(p) for p in self._path[0:-1]]) \
               + "->>'{}'".format(self._path[-1])

    def as_column_name(self):
        i = 0
        length = sum([len(p) for p in self._path]) + len(self._path) - 1

        # this might be still not enough
        while length > PG_MAX_IDENTIFIER_LENGTH:
            i += 1
            length -= len(self._path[i]) - 1

        els = [e[0] for e in self._path[0:i]]
        els.extend(self._path[i:])

        return "-".join(els)


class TablePath:
    def __init__(self, path: List[AttrPath]):
        super().__init__()
        self._path = path

    def __str__(self):
        return "[" + "/".join([str(e) for e in self._path]) + "]"

    def __eq__(self, other):
        return isinstance(other, TablePath) and self._path == other._path

    def __hash__(self):
        return hash(str(self))

    def __repr__(self):
        return self.__str__()

    def extend(self, p: 'TablePath'):
        lc = self._path.copy()
        lc.extend(p._path)
        return TablePath(lc)

    def add(self, e: AttrPath):  # ->Table
        # Path
        lc = self._path.copy()
        lc.append(e)
        return TablePath(lc)

    def is_empty(self):
        return len(self._path) == 0

    def as_table_name(self):
        return "_".join([c.as_column_name() for c in self._path])

    @classmethod
    def root(cls):
        return cls([])


def is_atomic(val):
    return type(val) in (int, float, bool, str)


def immutable_extend(l: List[T], e: T) -> List:
    lc = l.copy()
    lc.append(e)
    return lc


def flat(list_of_list: List[List[Any]]) -> List[Any]:
    return list(chain.from_iterable(list_of_list))


def extract_model(data: Any, table_path: TablePath) \
        -> Dict[TablePath, Dict[AttrPath, Any]]:
    columns = extract_columns(data, AttrPath([]))

    model = {table_path: columns}

    literal_array_models = extract_array_model(data, table_path)

    nested_models = extract_nested_model(data, table_path)

    model.update(literal_array_models)
    model.update(nested_models)

    return model


def extract_array_model(data, table_path):
    literal_array_models: Dict[TablePath, Any] = {
        table_path.add(AttrPath([k]).add('$literal')): data.get(k)[0]
        for k in data.keys()
        if data.get(k) is not None
           and isinstance(data.get(k), list)
           and len(data.get(k)) > 0
           and is_atomic((data.get(k)[0]))
    }
    return literal_array_models


def extract_nested_model(data, table_path):
    nested_models: Dict[TablePath, Any] = {
        table_path.add(AttrPath([k])): extract_model(data.get(k)[0], TablePath([]))
        for k in data.keys()
        if data.get(k) is not None
           and isinstance(data.get(k), list)
           and len(data.get(k)) > 0
           and not is_atomic((data.get(k)[0]))
    }
    pairs = []
    for (p, v1) in nested_models.items():
        for (k, v2) in v1.items():
            if k.is_empty():
                pairs.append((p, v2))
            else:
                pairs.append((p.extend(k), v2))
    nested_models = dict(pairs)
    return nested_models


def extract_columns(data: Any, attr_path: AttrPath) -> Dict[AttrPath, Any]:
    columns: Dict[AttrPath, Any] = {
        attr_path.add(k): data.get(k)
        for k in data.keys()
        if data.get(k) is not None
           and not isinstance(data.get(k), list)
           and not isinstance(data.get(k), dict)
    }

    more_columns: List[Dict[AttrPath, Any]] = [
        extract_columns(data.get(k), attr_path.add(k))
        for k in data.keys()
        if data.get(k) is not None and isinstance(data.get(k), dict)
    ]

    for cs in more_columns:
        columns.update(cs)

    return columns


def extract_model_from_table(cursor, table_name: str):
    # global model
    cursor.execute("SELECT data FROM \"{}\" TABLESAMPLE BERNOULLI(50) LIMIT 100".format(table_name))
    samples = cursor.fetchall()
    models = [extract_model(r[0], TablePath.root()) for r in samples]
    return reduce(merge_models, models, {})


def merge_models(m1, m2):
    m3 = {**m1, **m2}
    for key, value in m3.items():
        if key in m1 and key in m2 and isinstance(value, dict):
            # Merge values (when they are also dicts)
            other_value = m1[key]
            if isinstance(other_value, dict):
                m3[key] = {**value, **(m1[key])}
    return m3


def get_all_table_names(cursor) -> List[str]:
    sql_all_tables = """
    SELECT table_name FROM information_schema.tables
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    """
    cursor.execute(sql_all_tables)
    table_names = [table[0] for table in cursor.fetchall()]
    return table_names


simple_drop_view_sql_template = """
DROP MATERIALIZED VIEW IF EXISTS  "v_{table_name}";
"""

simple_create_view_sql_template = """
CREATE MATERIALIZED VIEW "v_{table_name}" AS
SELECT {projections}
FROM {table_name};
"""

drop_view_sql_template = """
DROP MATERIALIZED VIEW IF EXISTS "{view_name}";
"""

# TODO: cast is missing
array_create_view_sql_template = """
CREATE MATERIALIZED VIEW "{view_name}" AS
        SELECT CAST("data"->>'Id' As varchar) AS "Id", jsonb_array_elements_text("data" -> '{col_name}') AS "data"
        FROM {table_name}
        WHERE data -> '{col_name}' != 'null';
 """

nested_create_view_sql_template = """
CREATE MATERIALIZED VIEW "{view_name}" AS
    WITH t ("Id", "data") AS (
        SELECT CAST("data"->>'Id' As varchar) AS "Id", jsonb_array_elements("data" -> '{col_name}') AS "Feature"
        FROM {table_name}
        WHERE data -> '{col_name}' != 'null')
    SELECT "Id" AS "{parent_Id}", {projections}
    FROM t;
"""

simple_create_unique_index_sql_template = """
CREATE UNIQUE INDEX "{view_name}_pk" ON "{view_name}"("Id");
"""

nested_create_unique_index_sql_template = """
CREATE UNIQUE INDEX "{view_name}_pk" ON "{view_name}"("{parent_Id}","Id");
"""


def sql_view(table_name: str, table_path: TablePath, attr_paths: Dict[AttrPath, Any]):
    if table_path.is_empty():
        view_name = "v_" + table_name
        projections = ",\n".join([
            "{0} AS \"{1}\"".format(cast(c.as_json_path(), v), c.as_column_name())
            for c, v in attr_paths.items()
        ])
        # drop_view_sql = simple_drop_view_sql_template.format(table_name=table_name)
        create_view_sql = simple_create_view_sql_template.format(table_name=table_name, projections=projections)
        create_unique_index_sql = simple_create_unique_index_sql_template.format(view_name=view_name)
        return create_view_sql + create_unique_index_sql
    elif table_path._path[-1]._path[-1] == '$literal':
        real_table_path = TablePath([AttrPath(
            tp._path[:-1] if tp._path[-1] == '$literal' else tp._path)
            for tp in table_path._path
        ])
        view_name = "v_" + table_name + "_" + real_table_path.as_table_name()
        # drop_view_sql = drop_view_sql_template.format(view_name=view_name)
        col_name = real_table_path.as_table_name()
        create_view_sql = array_create_view_sql_template \
            .format(view_name=view_name, table_name=table_name, col_name=col_name)
        # create_unique_index_sql = simple_create_unique_index_sql_template.format(view_name=view_name)
        return create_view_sql
    else:
        view_name = "v_" + table_name + "_" + table_path.as_table_name()
        # drop_view_sql = drop_view_sql_template.format(view_name=view_name)
        projections = ",\n".join([
            cast(c.as_json_path(), v) +
            " AS \"" + c.as_column_name() + "\""
            for c, v in attr_paths.items()
        ])
        col_name = table_path.as_table_name()
        ## TODO: in the multi nesting case (array of array) we need more id columns
        parent_Id = table_name + "_Id"
        create_view_sql = nested_create_view_sql_template \
            .format(view_name=view_name, table_name=table_name, col_name=col_name,
                    projections=projections, parent_Id=parent_Id)
        # create_unique_index_sql = nested_create_unique_index_sql_template.format(view_name=view_name,parent_Id=parent_Id)
        return create_view_sql


simple_create_trigger_sql_template = """
DROP TABLE IF EXISTS "v_{table_name}";

CREATE TABLE "v_{table_name}" (
{columns}
);

ALTER TABLE "v_{table_name}" ADD PRIMARY KEY ("Id");

DROP FUNCTION IF EXISTS v_{table_name}_fn CASCADE;

CREATE FUNCTION v_{table_name}_fn()
RETURNS TRIGGER
AS $$
BEGIN
INSERT INTO public.v_{table_name}
SELECT
{projections};
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER t_v_{table_name}
    BEFORE INSERT
    ON {table_name}
    FOR EACH ROW
    EXECUTE PROCEDURE v_{table_name}_fn();

ALTER TABLE {table_name}
    ENABLE ALWAYS TRIGGER t_v_{table_name};
"""

array_create_trigger_sql_template = """
DROP TABLE IF EXISTS "{view_name}";

CREATE TABLE  "{view_name}" (
"Id" varchar,
"data" varchar
);

DROP FUNCTION IF EXISTS {view_name}_fn CASCADE;

CREATE FUNCTION {view_name}_fn()
RETURNS TRIGGER
AS $$
BEGIN
INSERT INTO public."{view_name}"
        SELECT CAST(NEW."data"->>'Id' As varchar) AS "Id",
            jsonb_array_elements_text(NEW."data" -> '{col_name}') AS "data"
        WHERE NEW."data" -> '{col_name}' != 'null';
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER t_{view_name}
    BEFORE INSERT
    ON {table_name}
    FOR EACH ROW
    EXECUTE PROCEDURE {view_name}_fn();

ALTER TABLE {table_name}
    ENABLE ALWAYS TRIGGER t_{view_name};
 """

nested_create_trigger_sql_template = """
DROP TABLE IF EXISTS "{view_name}";

CREATE TABLE "{view_name}" (
"{parent_Id}" varchar,
{columns}
);

DROP FUNCTION IF EXISTS {view_name}_fn CASCADE;

CREATE FUNCTION {view_name}_fn()
RETURNS TRIGGER
AS $$
BEGIN
INSERT INTO public."{view_name}"
WITH t ("Id", "data") AS (
        SELECT CAST(NEW."data"->>'Id' As varchar) AS "Id",
            jsonb_array_elements(NEW."data" -> '{col_name}') AS "data"
        WHERE NEW."data" -> '{col_name}' != 'null')
    SELECT "Id" AS "{parent_Id}", {projections}
    FROM t;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER t_{view_name}
    BEFORE INSERT
    ON {table_name}
    FOR EACH ROW
    EXECUTE PROCEDURE {view_name}_fn();

ALTER TABLE {table_name}
    ENABLE ALWAYS TRIGGER t_{view_name};

"""


def sql_trigger(table_name: str, table_path: TablePath, attr_paths: Dict[AttrPath, Any]):
    if table_path.is_empty():
        view_name = "v_" + table_name
        columns = ",\n".join([
            "\"{0}\" {1}".format(c.as_column_name(), sql_type_of(v))
            for c, v in attr_paths.items()
        ])
        projections = ",\n".join([
            "{0} AS \"{1}\"".format(cast("NEW." + c.as_json_path(), v), c.as_column_name())
            for c, v in attr_paths.items()
        ])
        create_trigger_sql = simple_create_trigger_sql_template \
            .format(table_name=table_name, columns=columns, projections=projections)
        return create_trigger_sql
    elif table_path._path[-1]._path[-1] == '$literal':
        real_table_path = TablePath([AttrPath(
            tp._path[:-1] if tp._path[-1] == '$literal' else tp._path)
            for tp in table_path._path
        ])
        view_name = "v_" + table_name + "_" + real_table_path.as_table_name()
        # drop_view_sql = drop_view_sql_template.format(view_name=view_name)
        col_name = real_table_path.as_table_name()
        create_trigger_sql = array_create_trigger_sql_template \
            .format(view_name=view_name, table_name=table_name, col_name=col_name)
        # create_unique_index_sql = simple_create_unique_index_sql_template.format(view_name=view_name)
        return create_trigger_sql
    else:
        view_name = "v_{0}_{1}".format(table_name, table_path.as_table_name())
        # drop_view_sql = drop_view_sql_template.format(view_name=view_name)
        columns = ",\n".join([
            "\"{0}\" {1}".format(c.as_column_name(), sql_type_of(v))
            for c, v in attr_paths.items()
        ])
        projections = ",\n".join([
            cast(c.as_json_path(), v) +
            " AS \"" + c.as_column_name() + "\""
            for c, v in attr_paths.items()
        ])
        col_name = table_path.as_table_name()
        ## TODO: in the multi nesting case (array of array) we need more id columns
        parent_Id = table_name + "_Id"
        create_trigger_sql = nested_create_trigger_sql_template \
            .format(view_name=view_name, table_name=table_name, col_name=col_name, columns=columns,
                    projections=projections, parent_Id=parent_Id)
        # create_unique_index_sql = nested_create_unique_index_sql_template.format(view_name=view_name,parent_Id=parent_Id)
        return create_trigger_sql


def cast(col, sample_value):
    t = sql_type_of(sample_value)
    return "CAST({} As {})".format(col, t)


def sql_type_of(value):
    if isinstance(value, bool):
        t = 'bool'
    elif isinstance(value, int):
        t = 'integer'
    elif isinstance(value, float):
        t = 'float'
    else:
        t = 'varchar'
    return t


def usage():
    print(
        'create_derived_tables_and_triggers_from_db.py all -u <user> -p <password> -h <hostname> -d <database> --port=<port>')
    print(
        'create_derived_tables_and_triggers_from_db.py regenerate -t <source-table> -u <user> -p <password> -h <hostname> -d <database> --port=<port>')


def generate_all(cursor, tables):
    create_trigger_file = "triggers_and_derived_tables.sql"
    with open(create_trigger_file, "w+") as ft:
        for table_name in tables:
            generate(cursor, table_name, ft)


def generate(cursor, table_name, ft):
    # DEBUG ONLY
    # if table_name != 'accommodationroomsopen':
    #     continue
    if table_name.startswith("v_") or table_name == "spatial_ref_sys":
        return
    model = extract_model_from_table(cursor, table_name)
    for table_path, attrs in model.items():
        trigger = sql_trigger(table_name, table_path, attrs)
        if trigger is not None:
            ft.write(trigger)


def pause_resume_subscription(enable, ft):
    action = "ENABLE" if enable else "DISABLE"

    ft.write("ALTER SUBSCRIPTION ${subscription_name} " + action + ";")


def regenerate(cursor, source_table):
    regen_file = "regen-" + source_table + ".sql"
    with open(regen_file, "w+") as ft:
        pause_resume_subscription(False, ft)
        generate(cursor, source_table, ft)
        repopulate(cursor, source_table, ft)
        pause_resume_subscription(True, ft)


simple_repopulate_sql_template = """
INSERT INTO v_{table_name}
SELECT
{projections}
FROM {table_name};
"""

array_repopulate_sql_template = """
INSERT INTO "{view_name}"
        SELECT CAST("data"->>'Id' As varchar) AS "Id",
            jsonb_array_elements_text("data" -> '{col_name}') AS "data"
        FROM {table_name}
        WHERE "data" -> '{col_name}' != 'null';
"""

nested_repopulate_sql_template = """
INSERT INTO "{view_name}"
WITH t ("Id", "data") AS (
        SELECT CAST("data"->>'Id' As varchar) AS "Id",
            jsonb_array_elements("data" -> '{col_name}') AS "data"
        FROM {table_name}
        WHERE "data" -> '{col_name}' != 'null')
    SELECT "Id" AS "{parent_Id}", {projections}
    FROM t;
"""


def repopulate(cursor, table_name, ft):
    model = extract_model_from_table(cursor, table_name)
    for table_path, attr_paths in model.items():
        if table_path.is_empty():
            projections = ",\n".join([
                "{0} AS \"{1}\"".format(cast(c.as_json_path(), v), c.as_column_name())
                for c, v in attr_paths.items()
            ])
            sql = simple_repopulate_sql_template.format(table_name=table_name, projections=projections)
            ft.write(sql)
        elif table_path._path[-1]._path[-1] == '$literal':
            real_table_path = TablePath([AttrPath(
                tp._path[:-1] if tp._path[-1] == '$literal' else tp._path)
                for tp in table_path._path
            ])
            view_name = "v_" + table_name + "_" + real_table_path.as_table_name()
            col_name = real_table_path.as_table_name()
            sql = array_repopulate_sql_template \
                .format(view_name=view_name, table_name=table_name, col_name=col_name)
            ft.write(sql)
        else:
            view_name = "v_{0}_{1}".format(table_name, table_path.as_table_name())
            projections = ",\n".join([
                cast(c.as_json_path(), v) +
                " AS \"" + c.as_column_name() + "\""
                for c, v in attr_paths.items()
            ])
            col_name = table_path.as_table_name()
            parent_Id = table_name + "_Id"
            sql = nested_repopulate_sql_template \
                .format(view_name=view_name, table_name=table_name, col_name=col_name,
                        projections=projections, parent_Id=parent_Id)
            ft.write(sql)


if __name__ == '__main__':

    argv = sys.argv
    if len(argv) < 2:
        print("command is required")
        usage()
        exit(2)

    command = argv[1]

    try:
        opts, args = getopt.getopt(argv[2:], "t:u:p:h:d:", ["port=", "subscription="])
    except getopt.GetoptError:
        usage()
        exit(2)

        if len(opts) == 0:
            usage()
            exit(2)

    source_table = None
    user = None
    password = None
    host = None
    db = None
    port = None
    for opt, arg in opts:
        if opt == '-t':
            source_table = arg
        elif opt == '-u':
            user = arg
        elif opt == '-p':
            password = arg
        elif opt == '-h':
            host = arg
        elif opt == '-d':
            db = arg
        elif opt == '--port':
            port = arg

    # print(opts)

    if user is None:
        print("user is required")
        usage()
        exit(2)

    if password is None:
        print("password is required")
        usage()
        exit(2)

    if host is None:
        print("hostname is required")
        usage()
        exit(2)

    if db is None:
        print("database is required")
        usage()
        exit(2)

    if port is None:
        print("port is required")
        usage()
        exit(2)

    connection = psycopg2.connect(user=user,
                                  password=password,
                                  host=host,
                                  port=port,
                                  database=db)

    cursor = connection.cursor()
    # Print PostgreSQL Connection properties
    print(connection.get_dsn_parameters(), "\n")

    # Print PostgreSQL version
    # cursor.execute("SELECT version();")
    # record = cursor.fetchone()
    # print("You are connected to - ", record, "\n")

    tables = get_all_table_names(cursor)
    tables.sort()

    # tables = ['accommodationsopen']

    if command == 'all':
        generate_all(cursor, tables)
    else:
        if source_table is None:
            print("source-table is required")
            exit(3)
        if source_table not in tables:
            print("source-table not found")
            exit(4)
        if source_table.startswith('v_'):
            print("The source table must not start with \"v_\"")
            exit(5)
        if command == 'regenerate':
            regenerate(cursor, source_table)
        else:
            print("Unknown command: " + command)
            exit(6)
