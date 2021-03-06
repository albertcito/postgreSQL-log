CREATE OR REPLACE FUNCTION audit_table(
	connname VARCHAR,
	conn_data VARCHAR,
    name_schema VARCHAR,
    name_table VARCHAR
)
	RETURNS VARCHAR
	AS $func$
BEGIN
	RAISE NOTICE '%', (SELECT dblink_exec(
		connname,
		FORMAT('CREATE SCHEMA IF NOT EXISTS %I;', name_schema)
	));
	RAISE NOTICE '---------------- audit_table_copy ------------------------';
	RAISE NOTICE '%', (SELECT audit_table_copy(connname, name_schema, name_table));
	RAISE NOTICE '---------------- audit_table_column_added ------------------------';
	RAISE NOTICE '%', (SELECT audit_table_column_added(connname, name_schema, name_table));
	RAISE NOTICE '---------------- audit_table_column_updated ------------------------';
	RAISE NOTICE '%', (SELECT audit_table_column_updated(connname, name_schema, name_table));
	RAISE NOTICE '---------------- audit_table_triggers ------------------------';
	RAISE NOTICE '%', (SELECT audit_table_triggers(conn_data, name_schema, name_table));
	RETURN 'audit_table done';
END
$func$
LANGUAGE plpgsql;