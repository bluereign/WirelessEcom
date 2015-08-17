


create proc [maintenance].[FindUnUsedTables_usp]
as
begin
SELECT DISTINCT   OBJECT_SCHEMA_NAME(t.[Object_ID])   AS 'SchemaName'
,OBJECT_NAME(t.[Object_ID])   AS 'Table Name'
, CASE  WHEN RW.Last_Read > 0 THEN RW.Last_Read END  AS 'Last Read' 
, RW.Last_Write   AS 'Last Write'  FROM sys.tables   AS t   LEFT JOIN sys.dm_db_index_usage_stats     AS us  
  ON us.[Object_ID]    = t.[Object_ID] AND us.Database_ID    = DB_ID() 
  LEFT JOIN  ( SELECT MAX(up.Last_User_Read)   AS 'Last_Read' 
 , MAX(up.Last_User_Update) AS 'Last_Write' 
 , up.[Object_ID]  FROM (SELECT Last_User_Seek
                                    , Last_User_Scan
                                    , Last_User_Lookup
                                    , [Object_ID] 
                                    , Database_ID 
                                          , Last_User_Update
                                    , COALESCE(Last_User_Seek, Last_User_Scan, Last_User_Lookup,0) AS null_indicator     FROM sys.dm_db_index_usage_stats) AS sus  
                                     UNPIVOT(Last_User_Read FOR read_date IN(Last_User_Seek, Last_User_Scan, Last_User_Lookup, null_indicator)) AS up 
                                     WHERE Database_ID = DB_ID() GROUP BY up.[Object_ID]) AS RW  ON RW.[Object_ID] = us.[Object_ID]
                                    ORDER BY [Last Read] , [Last Write] , [Table Name]; 
                                    
                                    
                                    end