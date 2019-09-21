import itertools
from abc import abstractmethod
from itertools import chain

import psycopg2

from typing import List, Any, Dict, Tuple, TypeVar, Type

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
    cursor.execute("SELECT data FROM {} LIMIT 1".format(table_name))
    r = cursor.fetchone()
    sample = r[0]
    model = extract_model(sample, TablePath.root())
    return model


def get_all_table_names(cursor):
    sql_all_tables = """
    SELECT table_name FROM information_schema.tables
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
    """
    cursor.execute(sql_all_tables)
    table_names = [table[0] for table in cursor.fetchall()]
    return table_names



simple_drop_view_sql_template = """
DROP VIEW IF EXISTS  "v_{table_name}";
"""

simple_create_view_sql_template = """
CREATE OR REPLACE VIEW "v_{table_name}" AS
SELECT {projections}
FROM {table_name};
"""

drop_view_sql_template = """
DROP VIEW IF EXISTS "{view_name}";
"""

# TODO: cast is missing
array_create_view_sql_template="""
CREATE OR REPLACE VIEW "{view_name}" AS
        SELECT id, jsonb_array_elements_text("data" -> '{col_name}') AS "data"
        FROM {table_name}
        WHERE data -> '{col_name}' != 'null';
 """

nested_create_view_sql_template = """
CREATE OR REPLACE VIEW "{view_name}" AS
    WITH t (id, "data") AS (
        SELECT id, jsonb_array_elements("data" -> '{col_name}') AS "Feature"
        FROM {table_name}
        WHERE data -> '{col_name}' != 'null')
    SELECT id AS "{parent_Id}", {projections}
    FROM t;
"""

def sql_view(table_name: str, table_path: TablePath, attr_paths: Dict[AttrPath, Any]):
    if table_path.is_empty():
        projections = ",\n".join([
            cast(c.as_json_path(), v) +
            " AS \"" + c.as_column_name() + "\""
            for c, v in attr_paths.items()
        ])
        drop_view_sql = simple_drop_view_sql_template.format(table_name=table_name)
        create_view_sql = simple_create_view_sql_template.format(table_name=table_name, projections=projections)
        return drop_view_sql + create_view_sql
    elif table_path._path[-1]._path[-1] == '$literal':
        real_table_path = TablePath([AttrPath(
            tp._path[:-1] if tp._path[-1] == '$literal' else tp._path)
            for tp in table_path._path
        ])
        view_name = "v_" + table_name +  "_" + real_table_path.as_table_name()
        drop_view_sql = drop_view_sql_template.format(view_name=view_name)
        col_name = real_table_path.as_table_name()
        create_view_sql = array_create_view_sql_template \
            .format(view_name=view_name, table_name=table_name, col_name=col_name)
        return drop_view_sql + create_view_sql
    else:
        view_name = "v_" + table_name +  "_" + table_path.as_table_name()
        drop_view_sql = drop_view_sql_template.format(view_name=view_name)
        projections = ",\n".join([
            cast(c.as_json_path(), v) +
            " AS \"" + c.as_column_name() + "\""
            for c, v in attr_paths.items()
        ])
        col_name = table_path.as_table_name()
        ## TODO: in the multi nesting case (array of array) we need more id columns
        parent_Id = table_name + "_Id"
        create_view_sql = nested_create_view_sql_template\
            .format(view_name=view_name, table_name=table_name, col_name=col_name, projections=projections, parent_Id=parent_Id)
        return drop_view_sql + create_view_sql


def cast(arg0, sample_value):
    if isinstance(sample_value, bool):
        t = 'bool'
    elif isinstance(sample_value, int):
        t = 'integer'
    elif isinstance(sample_value, float):
        t = 'float'
    else:
        t = 'varchar'

    return "CAST({} As {})".format(arg0, t)


if __name__ == '__main__':

    connection = psycopg2.connect(user="xiao",
                                  password="",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="st_tourism")

    cursor = connection.cursor()
    # Print PostgreSQL Connection properties
    print(connection.get_dsn_parameters(), "\n")

    # Print PostgreSQL version
    # cursor.execute("SELECT version();")
    # record = cursor.fetchone()
    # print("You are connected to - ", record, "\n")


    tables = get_all_table_names(cursor)

    # tables = ['accommodationsopen']

    with open("create_views.sql", "w+") as f:
        for table_name in tables:
            model = extract_model_from_table(cursor, table_name)
            for table_path, attrs in model.items():
                view = sql_view(table_name, table_path, attrs)
                if view is not None:
                    f.write(view)
                # print(view)
                # print()
