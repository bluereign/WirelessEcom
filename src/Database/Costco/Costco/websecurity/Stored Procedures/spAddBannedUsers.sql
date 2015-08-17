
CREATE Procedure [websecurity].[spAddBannedUsers] 
	(@O1 int=0,@O2 int=0, @O3 int=0, @O4 int=0, @O5 int=0,@O6 int=0, @O7 int=0,@O8 int=0)
AS
SET NOCOUNT ON
DECLARE @Banned int

DECLARE @AddAddress TABLE 
(
	Address1 varchar(50),
	Address2 varchar(50),
	City varchar(50),
	State varchar(2),
	ZIP varchar(9)

)

INSERT INTO @AddAddress (Address1, Address2,City,State,Zip)
SELECT	a.Address1,a.Address2, a.City,a.State, a.Zip
FROM	salesorder.[Order] o
		inner join salesorder.Address a
ON		o.BillAddressGuid=a.AddressGuid
WHERE	o.OrderId in(@O1,@O2,@O3,@O4,@O5,@O6,@O7,@O8) 
		AND o.OrderId!=0;


INSERT INTO @AddAddress (Address1, Address2,City,State,Zip)
SELECT	a.Address1,a.Address2, a.City,a.State, a.Zip
FROM	salesorder.[Order] o
		inner join salesorder.Address a
ON		o.ShipAddressGuid=a.AddressGuid
WHERE	o.OrderId in(@O1,@O2,@O3,@O4,@O5,@O6,@O7,@O8) 
		AND o.OrderId!=0;


With 
	BadAddress AS
	(
		select distinct * from @AddAddress
	)	

Insert Into websecurity.BannedUsers 
(
	Address1,
	Address2,
	City,
	State,
	zip
)
SELECT	BA.Address1,
		BA.Address2,
		BA.City,
		BA.State,
		BA.ZIP
From	BadAddress BA
		LEFT OUTER JOIN websecurity.BannedUsers BU
On		BA.Address1=BU.Address1
		AND ISNULL(BA.Address2,0)=ISNULL(BU.Address2,0)
		AND ISNULL(BA.City,0)=ISNULL(BU.City,0)
		AND ISNULL(BA.State,0)=ISNULL(BU.State,0)
WHERE	BU.Address1 IS NULL
		AND BU.City IS NULL
SET		@Banned=@@ROWCOUNT

PRINT  CAST(@Banned	AS varchar(10))+ ' banned addresses added.'