DECLARE @OrderDate varchar(10)= '09/13/2013'

DECLARE @tableHTML  NVARCHAR(MAX) ;

DECLARE @Orders int;
DECLARE @Phones int;
SET @OrderDate =  CONVERT (VARCHAR(10),GETDATE()-1, 101)
SET NOCOUNT ON

SELECT	@Orders=COUNT(o.OrderId)
FROM	salesorder.[Order] o 
WHERE	CAST(o.OrderDate AS DATE)=@OrderDate
	AND o.Status IN (1,2,3,4);

SET NOCOUNT ON		
SELECT	@Phones=COUNT(od.OrderDetailId)
FROM	salesorder.[Order] o 
	INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='d'
WHERE	CAST(o.OrderDate AS DATE)=@OrderDate
	AND o.Status IN (1,2,3,4);


SET @tableHTML =
    N'<h2>AAFES Device Orders per Day for ' + @Orderdate + '</h2>' +
    N'<table border="1">' +
    N'<tr><th>Order Date</th>' +
    N'<th>Orders Count</th>' +
    N'<th>Phones</th>' +
    N'<th>Carrier</th>' +
    N'<th>Total Phones</th>' +
    N'<th>Sub Total</th></tr>' +
      CAST ( ( 
SELECT ISNULL((SELECT * FROM (SELECT CONVERT(varchar(10),@OrderDate ,101) OrderDate,		
		'TOTAL ORDERS: '+CAST(@Orders as nvarchar(50)) [Orders Count],
		'' Carrier,
		'GRAND TOTAL OF PHONES:' Phones,
		 @Phones TotalPhones
		, '' SubTotal

UNION	 


SELECT Top 500	td = '', ''
		,td = '', ''
		,td = case 
		when min(CarrierId) =299 then 'Sprint'
		when min(CarrierId) =109 then 'AT&amp;T'
		when min(CarrierId)=128 then 'T-Mobile'
		when min(CarrierId) =42 then 'Verizon Wireless'		
		when min(CarrierId) =81 then 'Boost'		
		end Carrier, ''
		,td = od.ProductTitle, ''
		,td = Count(od.GersSku)PhonesOrdered, ''
		
		,td = case when min(CarrierId)=42 then		
			( select Count(od.GersSku) FROM salesorder.[Order] o 
			INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='d'
			WHERE	CAST(o.OrderDate AS DATE)=@OrderDate and o.CarrierId=42 
			AND o.Status IN (1,2,3,4))	
			
			when min(CarrierId)=299 then		
			( select Count(od.GersSku) FROM salesorder.[Order] o 
			INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='d'
			WHERE	CAST(o.OrderDate AS DATE)=@OrderDate and o.CarrierId=299 
			AND o.Status IN (1,2,3,4))	

			when min(CarrierId)=81 then		
			( select Count(od.GersSku) FROM salesorder.[Order] o 
			INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='d'
			WHERE	CAST(o.OrderDate AS DATE)=@OrderDate and o.CarrierId=81
			AND o.Status IN (1,2,3,4))
			
				when min(CarrierId)=128 then		
			( select Count(od.GersSku) FROM salesorder.[Order] o 
			INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='d'
			WHERE	CAST(o.OrderDate AS DATE)=@OrderDate and o.CarrierId=128 
			AND o.Status IN (1,2,3,4))	
			
				when min(CarrierId)=109 then		
			( select Count(od.GersSku) FROM salesorder.[Order] o 
			INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='d'
			WHERE	CAST(o.OrderDate AS DATE)=@OrderDate and o.CarrierId=109 
			AND o.Status IN (1,2,3,4))	
						
		end  'sub total', ''
		
FROM	salesorder.[Order] o 
INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='d'
WHERE	CAST(o.OrderDate AS DATE)=@OrderDate
		AND o.Status IN (1,2,3,4)		
GROUP BY od.ProductTitle ) Sub order by 3, 5 desc

              FOR XML PATH('tr'), TYPE),0))  AS NVARCHAR(MAX) ) +
    N'</table>' ;

DECLARE @table AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

--populate the above table
INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')
/*
INSERT @table (Emp_Email) VALUES('wa-online@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('ghunter@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('aprenner@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('mgolden@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('dleung@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('mleepart@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('sfuller@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('snowak@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('ebelzer@wirelessadvocates.com')
INSERT @table (Emp_Email) VALUES('drothenstein@wirelessadvocates.com')
*/

DECLARE @count AS int
SET @count =1 --initialize the count parameter
DECLARE @Recepient_Email AS VARCHAR(100)
WHILE (@count <=(SELECT COUNT(*) FROM @table))
        BEGIN
        SET @Recepient_Email =(SELECT TOP(1) Emp_Email FROM @table WHERE ID=@count)
        EXEC msdb.dbo.sp_send_dbmail
            @recipients=@Recepient_Email,            
			@body= @tableHTML,
			@body_format = 'HTML',
			@subject ='AAFES Device Orders Per Day Report for Orders on 09/13/2013',
			@profile_name ='Default'
            SET @count = @count + 1
            END 



