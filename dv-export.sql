/* Data Virtuality exported objects */
/* Created: 27.05.21  13:27:54.389 */
/* Server version: 2.4.5 */
/* Build: 758e469 */
/* Build date: 2021-05-11 */
/* Exported by Studio ver.2.4.5 (rev.3925037). Build date is 2021-05-11. */
/* Please set statement separator to ;; before importing */




/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'metadata') ;;

EXEC SYSADMIN.importView("text" => 'create view "metadata"."DataLineage" as
SELECT * FROM "dwh.tblDataLineage"') ;;

EXEC SYSADMIN.importView("text" => 'create view "metadata"."ResourceDependencies" as
SELECT * FROM "dwh.tblResourceDependencies"') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure "metadata"."getDependencies"(resourceName string)
returns(
	dependentResourceName string, 
	dependentResourceType string, 
	parentResourceName string, 
	parentResourceType string
) as
begin

WITH cte AS 
(
	select distinct d.dependentResourceName, d.dependentResourceType, d.parentResourceName, d.parentResourceType
	from 
		dwh.tblResourceDependencies d
	where d.dependentResourceName = resourceName
	union
	select distinct d.dependentResourceName, d.dependentResourceType, d.parentResourceName, d.parentResourceType
	from 
		dwh.tblResourceDependencies d
		join cte c
			on c.parentResourceName = d.dependentResourceName
)
select dependentResourceName, dependentResourceType, parentResourceName, parentResourceType
from cte
order by dependentResourceName, dependentResourceType, parentResourceName, parentResourceType;

end') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawIndexes" as
SELECT
     k.VDBName as table_catalog
    ,k.SchemaName as table_schema
    ,k.TableName as table_name
    ,k.Name as index_name
    ,kc.Name as column_name
    ,kc.Position as ordinal_position
    ,k.Description as index_description
    ,k.NameInSource as name_in_source
    ,k.Type as index_type
    ,k.IsIndexed as is_indexed
    ,k.RefKeyUID as foreign_key_uid
    ,k.UID as index_uid
    ,kc.TableUID
FROM
    SYS.KeyColumns kc
	join SYS.Keys k
		on kc.UID = k.UID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawPermissions" as
SELECT
     U.id as user_id
    ,U.name as user_name
    ,U.roles as user_has_roles
    ,U.creationDate as user_creation_date
    ,U.lastModifiedDate as user_last_modified_date
    ,U.creator as user_creator
    ,U.modifier as user_modifier
    ,R.id as role_id
    ,R.name as role_name
    ,R.allowCreateTempTables as role_allow_create_temp_tables
    ,R.users as role_has_users
    ,R.creationDate as role_creation_date
    ,R.lastModifiedDate as role_last_modified_date
    ,R.creator as role_creator
    ,R.modifier as role_modifier
    ,UR.id as user_role_id
    --,UR.userName as user_role_name
    --,UR.roleName as user_role_name
    ,UR.creationDate as user_role_creation_date
    ,UR.lastModifiedDate as user_role_last_modified_date
    ,UR.creator as user_role_creator
    ,UR.modifier as user_role_modifier
    ,P.id as permission_id
    --,P.role as permission_role
    ,P.resource as permission_resource
    ,P.permission
    ,P.condition as permission_condition
    ,P.isConstraint as permission_is_constraint
    ,P.mask as permission_mask
    ,P.maskOrder as permission_mask_order
    ,P.creationDate as permission_creation_date
    ,P.lastModifiedDate as permission_last_modified_date
    ,P.creator as permission_creator
    ,P.modifier as permission_modifier
    ,case when P.permission like ''%C%'' then true else false end as permission_create
    ,case when P.permission like ''%R%'' then true else false end as permission_read
    ,case when P.permission like ''%U%'' then true else false end as permission_update
    ,case when P.permission like ''%D%'' then true else false end as permission_delete
    ,case when P.permission like ''%E%'' then true else false end as permission_execute
    ,case when P.permission like ''%A%'' then true else false end as permission_alter
    ,case when P.permission like ''%L%'' then true else false end as permission_language
FROM
    SYSADMIN.Users U 
    JOIN SYSADMIN.UserRoles UR
    	ON UR.userName = U.name 
    JOIN SYSADMIN.Roles R
    	ON R.name = UR.roleName 
    JOIN SYSADMIN.Permissions P
    	ON P.role = UR.roleName') ;;

EXEC SYSADMIN.importView("text" => 'create view "metadata"."_RawResourceDependencies"
as
select * from (call "SYSADMIN.getResourceDependencies"("resourceName" => ''*'')) as a') ;;

EXEC SYSADMIN.importView("text" => 'create view metadata."_RawViewDefinitions" as
SELECT
     vd.id
    ,vd.name as SchemaPlusName
    ,vd.definition
    ,vd.creationDate
    ,vd.lastModifiedDate
    ,vd.state
    ,vd.failureReason
    ,vd.inSyncWithSource
    ,vd.notInSyncReason
    ,vd.creator
    ,vd.modifier
    ,t.VDBName
    ,t.SchemaName
    ,t.Name
    ,t.Type
    ,t.NameInSource
    ,t.IsPhysical
    ,t.SupportsUpdates
    ,t.UID
    ,t.Cardinality
    ,t.Description
    ,t.IsSystem
    ,t.IsMaterialized
    ,t.SchemaUID
FROM
    SYS.Tables t
    join SYSADMIN.ViewDefinitions vd
    	on (t.SchemaName || ''.'' || t.Name) = vd.name
where
	t.Type = ''View''') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawColumns" as
SELECT
     icol.table_catalog
    ,icol.table_schema
    ,icol.table_name
    ,icol.column_name
    ,icol.ordinal_position
    ,icol.column_default
    ,icol.is_nullable
    ,icol.udt_name
    ,icol.character_maximum_length
    ,icol.character_octet_length
    ,icol.numeric_precision
    ,icol.numeric_precision_radix
    ,icol.numeric_scale
    ,icol.datetime_precision
    ,icol.character_set_catalog
    ,icol.character_set_schema
    ,icol.character_set_name
    ,icol.collation_catalog
    ,icol.is_updatable
	,scol.NameInSource
	,scol.IsLengthFixed
	,scol.SupportsSelect
	,scol.SupportsUpdates
	,scol.IsCaseSensitive
	,scol.IsSigned
	,scol.IsCurrency
	,scol.IsAutoIncremented
	,scol.SearchType
	,scol.Format
	,scol.DefaultValue
	,scol.Precision
	,scol.CharOctetLength
	,scol.Radix
	,scol.UID
	,scol.Description
	,t.SchemaUID
	,scol.TableUID
	,scol.ColumnSize
	,cast(to_chars(SHA2_512(lower(table_schema || ''].['' || table_name)),''HEX'') as string) as hashkey_schema_table
	,cast(to_chars(SHA2_512(lower(table_schema || ''].['' || table_name || ''].['' || column_name)),''HEX'') as string) as hashkey_schema_table_column	
FROM
    INFORMATION_SCHEMA.columns icol 
	join SYS.Columns scol
		on lower(icol.table_catalog) = lower(scol.VDBName) and
			lower(icol.table_schema) = lower(scol.SchemaName) and
			lower(icol.table_name) = lower(scol.TableName) and
			lower(icol.column_name) = lower(scol.Name)
	join SYS.Tables t
		on t.UID = scol.TableUID') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view metadata."_RawProcedureDefinitions" as
SELECT
     p.VDBName
    ,p.SchemaName
    ,p.Name
    ,p.NameInSource
    ,p.ReturnsResults
    ,p.UID
    ,p.Description
    ,p.SchemaUID
    ,pd.id
    ,pd.name
    ,pd.definition
    ,pd.creationDate
    ,pd.lastModifiedDate
    ,pd.state
    ,pd.failureReason
    ,pd.creator
    ,pd.modifier
FROM
    SYSADMIN.ProcDefinitions pd
    join SYS.Procedures p
		on (p.SchemaName || ''.'' || p.Name) = pd.name') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."_RawForeignKeys" as
/*
importedKeyCascade 	0
importedKeyRestrict 	1
importedKeySetNull 	2	
importedKeyNoAction 	3
importedKeySetDefault 	4
importedKeyInitiallyDeferred 	5
importedKeyInitiallyImmediate 	6
importedKeyNotDeferrable 	7
*/
SELECT
	 rkc.PKTABLE_CAT as pk_table_catalog
	,rkc.PKTABLE_SCHEM as pk_table_schema
	,rkc.PKTABLE_NAME as pk_table_name
	,rkc.PKCOLUMN_NAME as pk_column_name
	,rkc.PK_NAME as pk_index_name
	,pk.index_uid
	,pk.TableUID as pk_TableUID
		
	,rkc.FKTABLE_CAT as fk_table_catalog
	,rkc.FKTABLE_SCHEM as fk_table_schema
	,rkc.FKTABLE_NAME as fk_table_name
	,rkc.FKCOLUMN_NAME as fk_column_name
	,rkc.FK_NAME as fk_index_name
	,fk.index_uid as foreign_key_uid
	,fk.TableUID as fk_TableUID
	,rkc.KEY_SEQ as key_sequence
	
	,rkc.UPDATE_RULE as index_update_rule_key
	,coalesce(ur.key_name, ''undefined'') as index_update_rule_name
	,coalesce(ur.description, ''undefined'') as index_update_rule_description
	
	,rkc.DELETE_RULE as index_delete_rule_key
	,coalesce(dr.key_name, ''undefined'') as index_delete_rule_name
	,coalesce(dr.description, ''undefined'') as index_delete_rule_description
	
	,rkc.DEFERRABILITY as index_deferrability_key
	,coalesce(def.key_name, ''undefined'') as index_deferrability_name
	,coalesce(def.description, ''undefined'') as index_deferrability_description
FROM
	SYS.ReferenceKeyColumns rkc

	left join "metadata"."_RawIndexes" pk
		on lower(rkc.PKTABLE_CAT) = lower(pk.table_catalog) and
			lower(rkc.PKTABLE_SCHEM) = lower(pk.table_schema) and
			lower(rkc.PKTABLE_NAME) = lower(pk.table_name) and
			lower(rkc.PKCOLUMN_NAME) = lower(pk.column_name) and
			lower(rkc.PK_NAME) = lower(pk.index_name)

	left join "metadata"."_RawIndexes" fk
		on lower(rkc.FKTABLE_CAT) = lower(fk.table_catalog) and
			lower(rkc.FKTABLE_SCHEM) = lower(fk.table_schema) and
			lower(rkc.FKTABLE_NAME) = lower(fk.table_name) and
			lower(rkc.FKCOLUMN_NAME) = lower(fk.column_name) and
			lower(rkc.FK_NAME) = lower(fk.index_name)
	
	left join (
		-- From: http://man.hubwiz.com/docset/Mono.docset/Contents/Resources/Documents/api.xamarin.com/monodoc319d-6.html
		-- UPDATE_RULE - short - a value giving the rule for how to treat the foreign key when the corresponding primary key is updated:
		select ''importedKeyNoAction''   as key_name, 3 as key, ''don''''t allow the primary key to be updated if it is imported as a foreign key'' as description union all
		select ''importedKeyCascade''    as key_name, 0 as key, ''change the imported key to match the primary key update'' as description union all
		select ''importedKeySetNull''    as key_name, 2 as key, ''set the imported key to null'' as description union all
		select ''importedKeySetDefault'' as key_name, 4 as key, ''set the imported key to its default value'' as description union all
		select ''importedKeyRestrict''   as key_name, 1 as key, ''same as importedKeyNoAction: don''''t allow the primary key to be updated if it is imported as a foreign key'' as description
	) ur
		on rkc.UPDATE_RULE = ur.key

	left join (
		-- From: http://man.hubwiz.com/docset/Mono.docset/Contents/Resources/Documents/api.xamarin.com/monodoc319d-6.html
		-- DELETE_RULE - short - how to treat the foreign key when the corresponding primary key is deleted:
		select ''importedKeyNoAction''   as key_name, 3 as key, ''don''''t allow the primary key to be updated if it is imported as a foreign key'' as description union all
		select ''importedKeyCascade''    as key_name, 0 as key, ''change the imported key to match the primary key update'' as description union all
		select ''importedKeySetNull''    as key_name, 2 as key, ''set the imported key to null'' as description union all
		select ''importedKeySetDefault'' as key_name, 4 as key, ''set the imported key to its default value'' as description union all
		select ''importedKeyRestrict''   as key_name, 1 as key, ''same as importedKeyNoAction: don''''t allow the primary key to be updated if it is imported as a foreign key'' as description
	) dr
		on rkc.DELETE_RULE = dr.key

	left join (
		-- From: http://man.hubwiz.com/docset/Mono.docset/Contents/Resources/Documents/api.xamarin.com/monodoc319d-6.html
		-- DEFERRABILITY - short - defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions): 
		select ''importedKeyInitiallyDeferred''  as key_name, 5 as key, ''defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions)'' as description union all
		select ''importedKeyInitiallyImmediate'' as key_name, 6 as key, ''defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions)'' as description union all
		select ''importedKeyNotDeferrable''      as key_name, 7 as key, ''defines whether the foreign key constraints can be deferred until commit (see the SQL92 specification for definitions)'' as description
	) def
		on rkc.DEFERRABILITY = def.key') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."DataLineageSourceProperties" as
select 
	* 
from 
	dwh.tblDataLineage dl
	left join metadata."_RawColumns" cp
		on dl.hashkey_source_schema_table_column = cp.hashkey_schema_table_column') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."DataLineageTargetProperties" as
select 
	* 
from 
	dwh.tblDataLineage dl
	left join metadata."_RawColumns" cp
		on dl.hashkey_target_schema_table_column = cp.hashkey_schema_table_column') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view "metadata"."DataLineageWithColumnTypesSizes" as

SELECT
	 dl.data_lineage_table_schema
	,dl.data_lineage_table_name
	,dl.data_lineage_table_type
	,dl.depth
	,dl.source_table_schema
	,dl.source_table_name
	,dl.source_column_name
    ,src.is_nullable as source_column_name_is_nullable
    ,src.udt_name as source_column_name_udt_name
    ,src.character_maximum_length as source_column_name_character_maximum_length
	,dl.target_table_schema
	,dl.target_table_name
	,dl.target_column_name
    ,tgt.is_nullable as source_column_name_is_nullable
    ,tgt.udt_name as source_column_name_udt_name
    ,tgt.character_maximum_length as source_column_name_character_maximum_length
	,dl.default_order
	,dl.id
	,dl.parent_id
FROM
	dwh.tblDataLineage dl
    left join metadata."_RawColumns" src
		on dl.hashkey_source_schema_table_column = src.hashkey_schema_table_column
    left join metadata."_RawColumns" tgt
		on dl.hashkey_target_schema_table_column = tgt.hashkey_schema_table_column') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure metadata.searchMetadata(searchTerm string) 
returns(
	SchemaName string, 
	TableName string, 
	ColumnName string, 
	ProcedureName string, 
	Type string,
	Description string,
	SchemaUID string,
	TableUID string,
	ColumnUID string,
	ProcedureUID string
) as
begin
declare string srchTerm = lower(''%'' || searchTerm || ''%'');

SELECT distinct Name as SchemaName, null as TableName, null as ColumnName, null as ProcedureName,
	''Schema'' as Type, Description, UID as SchemaUID, null as TableUID, null as ColumnUID, null as ProcedureUID
FROM SYS.Schemas
where 
	lower(Name) like srchTerm or 
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, Name as TableName, null as ColumnName, null as ProcedureName,
	Type, Description, SchemaUID, UID as TableUID, null as ColumnUID, null as ProcedureUID
FROM metadata."_RawViewDefinitions"
where 
	lower(Name) like srchTerm or 
	lower(definition) like srchTerm or
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, Name as TableName, null as ColumnName, null as ProcedureName,
	Type, Description, SchemaUID, UID as TableUID, null as ColumnUID, null as ProcedureUID
FROM SYS.Tables
where
	Type = ''Table'' and (
		lower(Name) like srchTerm or 
		lower(Description) like srchTerm
	)

union

SELECT distinct table_schema as SchemaName, table_name as TableName, column_name as ColumnName, null as ProcedureName,
	''Column'' as Type, Description, SchemaUID, TableUID, UID as ColumnUID, null as ProcedureUID
FROM metadata."_RawColumns"
where
	lower(column_name) like srchTerm or 
	lower(Description) like srchTerm

union

SELECT distinct SchemaName, null as TableName, null as ColumnName, Name as ProcedureName,
	''Procedure'' as Type, Description, SchemaUID, null as TableUID, null as ColumnUID, UID as ProcedureUID
FROM metadata."_RawProcedureDefinitions"
where
	lower(name) like srchTerm or 
	lower(Description) like srchTerm
;

end') ;;








