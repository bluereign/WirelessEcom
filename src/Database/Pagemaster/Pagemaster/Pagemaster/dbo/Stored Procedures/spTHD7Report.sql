

CREATE procedure [dbo].[spTHD7Report] (@startdt datetime='10/29/2010', @enddt datetime='12/31/2054')
as

/*
AUTHOR: Greg Montague
CREATED: 11/04/2010
DESCRIPTON: Report on THD7 items pre-sold for sales staff commisson

*/

SELECT	a.OrderId,
		ISNULL(C.District,'Invalid')[Wa District], 
		'Costco ' +
		case
		when C.Location = 'WA1 Headquarters' then ' '
		else C.Kiosk+' ' end +
		ISNULL(C.Location,'Invalid')[Wa Store Name], 
		c.EmplId,
		a.GERSRefNum,
		d.GersSku [Del_Doc_Number],
		(CONVERT(varchar(10),a.OrderDate,101)) [Dt],
		SUM(b.Qty)sumQty
FROM	salesorder.[Order] a 
		inner join salesorder.OrderDetail b
ON		a.OrderId=b.OrderId				 
		left outer join KioskStaff c
ON		Left(Replace(Replace(a.KioskEmployeeNumber,'WA',''),' ',''),6)=c.EmplID	
		Left Outer Join salesorder.OrderDetail d
ON		a.OrderId=d.OrderId and
		d.OrderDetailType='r'		
WHERE	b.GersSku='THD7' and 
		a.KioskEmployeeNumber is not null  
		and a.OrderId=16408
		--and a.OrderDate between @startdt and @enddt
GROUP BY a.OrderId, 
		ISNULL(C.District,'Invalid'), 
		ISNULL(C.Location,'Invalid'), 
		'Costco ' +
		case
		when C.Location = 'WA1 Headquarters' then ' '
		else C.Kiosk+' ' end +
		ISNULL(C.Location,'Invalid'), 
		c.EmplID,
		a.GERSRefNum,
		d.GersSku, 
		(CONVERT(varchar(10),a.OrderDate,101))