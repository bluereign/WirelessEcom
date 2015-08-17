
CREATE proc dbo.LookupCarrierLog
	 @MDN varchar(10)
as

SELECT  top 1 l.LoggedDateTime, @MDN as MDN, l.Data as Request,
 (select top 1 Data from CarrierInterfaceLog where RequestType = 'Response' and
 Type = 'MISC.CUSTLOOKUP' and ReferenceNumber = l.ReferenceNumber
  Order by LoggedDateTime DESC) as Response
FROM CarrierInterfaceLog l WITH (NOLOCK) 
where l.data like '%' + @MDN + '%' and l.RequestType='Request' and l.Type = 'MISC.CUSTLOOKUP'
ORDER BY LoggedDateTime desc