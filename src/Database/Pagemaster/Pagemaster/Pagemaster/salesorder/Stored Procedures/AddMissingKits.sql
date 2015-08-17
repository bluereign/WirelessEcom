

CREATE PROCEDURE [salesorder].[AddMissingKits]
As

/*

AUTHOR: Greg Montague
DATE: 03/07/2011
DESCRIPTION: The process will add missing kits to orders and reset 

*/



DECLARE @Id int;
DECLARE @OrderId int;
DECLARE @GroupNumber varchar(5);
DECLARE @FreeKitSku varchar(25);
DECLARE @MissingKits Table 


(

Id smallint,
OrderId INT,
GroupNumber varchar(5),
FreeKitSku varchar(25),
IsAdded bit

)

INSERT INTO @MissingKits
SELECT ROW_NUMBER() OVER (Order By OrderId, GroupNumber) Id,
OrderId,GroupNumber,FreeKitSku, 0 IsAdded FROM salesorder.vMissingKits WHERE AvailableStock>0


DECLARE MissingKits CURSOR FOR
	SELECT Id,OrderId,GroupNumber,FreeKitSku  
	FROM @MissingKits
OPEN MissingKits
FETCH NEXT FROM  MissingKits
	INTO @Id,@OrderId,@GroupNumber,@FreeKitSku
WHILE @@FETCH_STATUS = 0
BEGIN

	exec salesorder.AddItemOrderDetail  @OrderId, @GroupNumber, @FreeKitSku

FETCH NEXT FROM  MissingKits
	INTO @Id,@OrderId,@GroupNumber,@FreeKitSku
END 
CLOSE	MissingKits           
DEALLOCATE  MissingKits