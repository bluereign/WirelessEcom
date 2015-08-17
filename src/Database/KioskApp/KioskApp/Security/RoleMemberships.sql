EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'kioskapp';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'kioskapp';

