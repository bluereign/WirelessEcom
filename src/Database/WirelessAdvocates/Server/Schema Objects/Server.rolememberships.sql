EXECUTE sp_addrolemember @rolename = N'RSExecRole', @membername = N'ECOM\rptsvc_test';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'noah';

