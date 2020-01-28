# 1. download ontop-cli
# 2. cp ~/.m2/repository/org/postgresql/postgresql/42.2.5/postgresql-42.2.5.jar ~/opt/ontop-cli-4.0.0-beta-1/jdbc
$HOME/opt/ontop-cli-4.0.0-beta-1/ontop endpoint --ontology=odh.ttl --mapping=odh.obda --properties=odh.properties --portal=odh.portal.toml --cors-allowed-origins=*
