DECLARE @Date varchar(10)= '09/15/2013'

DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<h2>Accessories Orders per Day for ' + @Date + '</h2>' +
    N'<table border="1">' +
    N'<tr><th>Accessories</th>' +
    N'<th>GersSku</th>' +
    N'<th>Totals</th></tr>' +
      CAST ( ( SELECT	
		td = od.ProductTitle, ''
		,td = od.GersSku, ''
		,td = count(od.GersSku), ''
FROM	salesorder.[Order] o 
INNER JOIN salesorder.OrderDetail od ON o.OrderId=od.OrderId and od.OrderDetailType='a'
WHERE
convert(varchar(10), OrderDate,101) = @Date AND
o.Status IN (1,2,3) and od.netprice<>0 and od.ProductTitle is not null 
		and (o.ActivationType IS NULL OR o.ActivationType in ('n','u','a','r'))
GROUP BY o.orderid, od.ProductTitle,od.GersSku
order by 1

              FOR XML PATH('tr'), TYPE

    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;

DECLARE @table AS TABLE(Emp_Email NVARCHAR(100), ID int IDENTITY(1,1))

--populate the above table
INSERT @table (Emp_Email) VALUES('nhall@wirelessadvocates.com')
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
			@subject ='Accessories Orders Per Day Report for Orders on 09/15/2013',
			@profile_name ='Default'
            SET @count = @count + 1
            END 



