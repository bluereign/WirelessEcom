


create proc [maintenance].[Fraud_AddressAccount_usp]
as
begin

DECLARE @IP VARCHAR(50) = null
DECLARE @FirstName VARCHAR(255) = null
DECLARE @LastName VARCHAR(255) = null
DECLARE @Address1 VARCHAR(255) = '4506 80th St apt 2e'
DECLARE @Address2 VARCHAR(255) = null
DECLARE @City VARCHAR(255) = 'Elmhurst'
DECLARE @State VARCHAR(255) = 'NY'
DECLARE @Zip VARCHAR(255) = '11373'


INSERT INTO websecurity.BannedUsers ( IP ,FirstName, LastName, Address1, Address2, City, State, Zip )
VALUES ( @IP, @FirstName, @LastName, @Address1, @Address2, @City, @State, @Zip )

                                    
end

