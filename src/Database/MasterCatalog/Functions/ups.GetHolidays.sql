SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION ups.GetHolidays (@GetYear int)
	RETURNS @GetHolidays TABLE 
(
    -- Columns returned by the function
	[Day] date, 
	IsAirPickupDay bit,
	IsAirDeliveryDay bit,
	IsPickupDay bit, 
	IsDeliveryDay bit
)
AS

BEGIN



declare @Year varchar(4)=CAST(@GetYear as varchar(4));
declare @GetDay int;
declare @Memorial date;
declare @Independence date;
declare @Labor date;
declare @Thanksgiving date;


SET @GetDay=DATEPART(weekday,Cast('5/31/'+@Year as date))

SELECT	@Memorial = CASE
		WHEN @GetDay=2 THEN '5/31/'+@Year
		WHEN @GetDay=1 THEN '5/25/'+@Year
		ELSE '5/'+CAST((31-(@GetDay-2)) AS CHAR(2))+'/'+@Year
		END  
		
SET	@Independence='7/4/'+@Year
SET @Getday=DATEPART(weekday,@Independence)

SELECT @Independence=CASE
		WHEN @Getday=7 THEN DATEADD(d,-1,@Independence)
		WHEN @GetDay=1 THEN DATEADD(d,1,@Independence)
		ELSE @Independence end

SET	@Labor='9/1/'+@Year
SET @Getday=DATEPART(weekday,@Labor)

SELECT	@Labor= CASE
		WHEN @GetDay=1 THEN DATEADD(d,1,@Labor)
		WHEN @GetDay>2 THEN DATEADD(d,(9-@Getday),@Labor) END
WHERE  @Getday<>2	


SET @GetDay=DATEPART(weekday,Cast('11/1/'+@year as date))
SELECT @Thanksgiving = CASE
		WHEN @GetDay=7 THEN '11/27/'+@Year
		ELSE '11/'+CAST((27-@GetDay) AS CHAR(2))+'/'+@Year
		END  

Insert Into @GetHolidays

Select @Memorial [Day], 0 IsAirPickupDay, 0 IsAirDeliveryDay, 0 IsPickupDay, 0 IsDeliveryDay
Union
Select @Independence, 0, 0, 0, 0
Union
Select @Labor, 0, 0, 0, 0
Union
Select @Thanksgiving, 0 , 0, 0, 0
Union
Select DATEADD(d,1,@Thanksgiving),1,1,0,0
Union
Select	CAST('12/24/'+@Year as Date),1,1,0,1
Union
Select	CAST('12/25/'+@Year as Date),0,0,0,0
Union
Select	CAST('12/31/'+@Year as Date),1,1,0,0
Union
Select	DATEADD(d,1,CAST('12/31/'+(@Year) as Date)),0,0,0,0






	RETURN
END




/*




*/

GO
