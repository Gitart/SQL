CREATE USER "INFORMATION_SCHEMA" IDENTIFIED BY "schema" ACCOUNT LOCK;

--------

CREATE VIEW INFORMATION_SCHEMA.SCHEMATA (CATALOG_NAME, SCHEMA_NAME,
SCHEMA_OWNER, DEFAULT_CHARACTER_SET_CATALOG, DEFAULT_CHARACTER_SET_SCHEMA,
DEFAULT_CHARACTER_SET_NAME)
as
SELECT CAST((SELECT property_value FROM database_properties WHERE
property_name='GLOBAL_DB_NAME') AS varchar2(30))
, username
, username
, CAST(null AS varchar2(30))
, CAST(null AS varchar2(30))
, CAST((SELECT property_value FROM database_properties WHERE
property_name='NLS_CHARACTERSET') AS varchar2(30))
FROM sys.all_users;

GRANT SELECT ON INFORMATION_SCHEMA.SCHEMATA TO PUBLIC WITH GRANT OPTION;

--------

CREATE VIEW INFORMATION_SCHEMA.TABLES (TABLE_CATALOG, TABLE_SCHEMA,
TABLE_NAME, TABLE_TYPE)
as
SELECT CAST((SELECT property_value FROM database_properties WHERE
property_name='GLOBAL_DB_NAME') AS varchar2(30))
, o.owner
, o.object_name
, case o.object_type
        when 'TABLE' then 'BASE TABLE'
        when 'VIEW' then 'VIEW'
        else null
end
FROM sys.all_objects o
WHERE (o.object_type='TABLE' or o.object_type='VIEW');

GRANT SELECT ON INFORMATION_SCHEMA.TABLES TO PUBLIC WITH GRANT OPTION;

--------

CREATE VIEW INFORMATION_SCHEMA.VIEWS (TABLE_CATALOG, TABLE_SCHEMA,
TABLE_NAME, VIEW_DEFINITION, CHECK_OPTION, IS_UPDATABLE)
as
SELECT CAST((SELECT property_value FROM database_properties WHERE
property_name='GLOBAL_DB_NAME') AS varchar2(30))
, o.owner
, o.view_name
, TEXT
, CAST(null AS varchar2(10))
, 'NO'
FROM sys.all_views o;

GRANT SELECT ON INFORMATION_SCHEMA.VIEWS TO PUBLIC WITH GRANT OPTION; 
