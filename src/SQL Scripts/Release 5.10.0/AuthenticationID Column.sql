--Add new AuthenticationID column
ALTER TABLE dbo.Users
ADD AuthenticationId varchar(100)

--Ensure only unique values are entered when it is not null 
CREATE UNIQUE NONCLUSTERED INDEX idx_AuthenticationId
ON dbo.Users(AuthenticationId)
WHERE AuthenticationId IS NOT NULL;

--Running this statement will receive an error
UPDATE dbo.users
SET AuthenticationId = '2'
WHERE User_ID in ('25399377','25399379')