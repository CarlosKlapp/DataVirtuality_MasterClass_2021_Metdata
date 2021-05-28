/* Data Virtuality exported objects */
/* Created: 28.05.21  18:47:07.564 */
/* Server version: 2.4.5 */
/* Build: 758e469 */
/* Build date: 2021-05-11 */
/* Exported by Studio ver.2.4.5 (rev.3925037). Build date is 2021-05-11. */
/* Please set statement separator to ;; before importing */




/* Exported virtual schemas */
EXEC SYSADMIN.createVirtualSchema("name" => 'demos') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view demos.csv_SalesOrderHeader as
/*
call SYSADMIN.createConnection(name => ''csv_local_sales'', jbossCliTemplateName => ''ufile'', connectionOrResourceAdapterProperties => ''ParentDirectory=/mnt/hgfs/_DV_bin_linux/data_files/csv_sales,decompressCompressedFiles=false'', encryptedProperties => '''');;
call SYSADMIN.createDatasource(name => ''csv_local_sales'', translator => ''ufile'', modelProperties => ''importer.useFullSchemaName=false'', translatorProperties => '''', encryptedModelProperties => '''', encryptedTranslatorProperties => '''');;
*/
SELECT
	csv_table.*
FROM
csv_local_sales.getFiles(''./SalesOrderHeader.utf8.csv'') as f,
	TEXTTABLE(to_chars(f.file,''UTF-8'') 
		COLUMNS 
		"salesorderid" integer ,
		"customerid" STRING ,
		"salespersonid" STRING ,
		"territoryid" STRING ,
		"purchaseordernumber" STRING ,
		"currencycode" STRING ,
		"subtotal" STRING ,
		"taxamt" STRING ,
		"freight" STRING ,
		"orderdate" STRING ,
		"revisionnumber" STRING ,
		"status" STRING ,
		"billtoaddressid" STRING ,
		"shiptoaddressid" STRING ,
		"shipdate" STRING ,
		"shipmethodid" STRING ,
		"creditcardid" integer ,
		"creditcardnumber" STRING ,
		"creditcardexpmonth" STRING ,
		"creditcardexpyear" STRING ,
		"contactid" STRING ,
		"onlineorderflag" STRING ,
		"ordercomment" STRING ,
		"modifieddate" STRING ,
		"rowguid" STRING ,
		"duedate" STRING ,
		"salesordernumber" STRING ,
		"totaldue" STRING 
		DELIMITER '','' 
		QUOTE ''"'' 
		HEADER 1 
	) as csv_table') ;;

EXEC SYSADMIN.importView("text" => 'create view demos.ReverseDataTypeNames as
SELECT 
	"k.Name","x.Reversed"  
FROM 
	SYS.DataTypes AS "k", 
	OBJECTTABLE(       
		LANGUAGE ''javascript'' 
		''function reverse(s){ return s.split("").reverse().join(""); }                 
		reverse(tabname);''                  
		PASSING "k.Name" AS "tabname"                 
		COLUMNS  "Reversed" string ''dv_row'' 
	) AS x') ;;

EXEC SYSADMIN.importView("text" => 'create view demos.javascript_example as
SELECT x.* 
FROM ( OBJECTTABLE(    
	LANGUAGE ''javascript'' 
	''var rows = [];        
	firstrow = { "col1": "foo", "col2": "bar" };        
	rows.push( firstrow );        
	secondrow = { "col2": "foo", "col3": "bar" };        
	rows.push( secondrow );        
	rows;''         
	COLUMNS         
	"col1" string ''dv_row.col1'',        
	"col2" string ''dv_row.col2'',        
	"col3" string ''dv_row.col3'',        
	"col4" string ''dv_row.col4'' ) AS x)') ;;

EXEC SYSADMIN.importView("text" => 'create VIEW "demos.SalesForce_Account_Opportunity" AS SELECT
        *
    FROM
        "salesforce.Opportunity" INNER JOIN "salesforce.Account"
        ON "Opportunity.AccountId" = "Account.Id"') ;;

EXEC SYSADMIN.importProcedure("text" => 'Create Virtual Procedure demos.RegexReplace (
	IN initialString string not null,
	IN regex string not null,
	IN replacement string not null
	)
Returns (resultString string)
As
Begin
	Select
		resultString
	From 
		ObjectTable (language ''javascript'' ''
			(new java.lang.String(initialString)).replaceAll(regex, replacement)
			''Passing
			initialString as initialString,
			regex as regex,
			replacement as replacement
			Columns
			resultString string ''dv_row''
		) o;
End') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE VIRTUAL PROCEDURE demos.EndOfMonth(
	IN getdate date 
) 
returns (
	outdate date
) as
BEGIN
 
    DECLARE date monthlater =  timestampadd( SQL_TSI_MONTH, 1, getdate );
    select  timestampadd( SQL_TSI_DAY, - dayofmonth(monthlater), monthlater);
/*
Examples:
call demos.endofmonth( cast ( ''2012-02-07'' as date ) );;
 
call demos.endofmonth( curdate() );;
 
SELECT foo from table.bar WHERE column = ( call endofmonth( curdate() ) );;

*/
END') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE virtual procedure demos.dateaxis(
	IN startdate date,
	IN enddate date
) 
returns (
	xdate date
)
as
begin
	DECLARE date idate;
	idate=startdate;
	CREATE LOCAL TEMPORARY TABLE #x(xdate date);
	WHILE (idate<=enddate)
	BEGIN
		INSERT INTO #x(xdate) VALUES (idate);
		idate=timestampadd(SQL_TSI_DAY,1,idate);
	END
	SELECT * from #x;
end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure demos.update_db2_customer()
as
begin

	update "db2.S65C054A.DAVY1.CUSTOMER"
	set
		customertype = ''D'',
		modifieddate = now()
	where
		"customerid" in (1,2);

end') ;;

EXEC SYSADMIN.importProcedure("text" => 'CREATE procedure demos.createVirtualSchema(
    name string not null
) as
begin
    call "SYSADMIN.createVirtualSchema" (
        name => name
    );

	call "SYSADMIN.setPermissions" (
	    role_name => ''dv-developer-role''
	    ,resourceName => name
	    ,permissions => ''CRUDEAL''
	    ,condition => null
	    ,isConstraint => FALSE
	    ,mask => null
	    ,maskOrder => null
	);
end') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view demos.RegexReplaceExample
as

select
	k.Name,
	(call demos.RegexReplace(
		    "initialString" => k.Name,
		    "regex" => ''[aeiouAEIOU]'',
		    "replacement" => ''**''
	)) as regex_replacement
from
	SYS.DataTypes AS k') ;;

EXEC SYSADMIN.importView("text" => 'CREATE view demos.test_dateaxis as
select
	*
from
	demos.dateaxis(''2021-01-01'', ''2021-01-10'')') ;;








