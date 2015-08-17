

GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'ECOM\sqlservice';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'jprior';


GO
EXECUTE sp_addrolemember @rolename = N'db_ddladmin', @membername = N'synccatalog';






GO

GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'synccatalog';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'reports';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'nbritton';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'WALLC\113109';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'Palani';



GO



GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'synccatalog';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'WALLC\113109';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'Palani';


GO
EXECUTE sp_addrolemember @rolename = N'web_carrierservice', @membername = N'WebService_ATT';


GO
EXECUTE sp_addrolemember @rolename = N'web_carrierservice', @membername = N'WebService_TMO';


GO
EXECUTE sp_addrolemember @rolename = N'web_carrierservice', @membername = N'WebService_VZW';


GO
EXECUTE sp_addrolemember @rolename = N'web_ordermanagement', @membername = N'prodadmin';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'cfdbo';

