
<cfset verifyRequest = '{
    "AppleCareSalesDate" : "06/04/14",
    "PurchaseOrderNumber" : "0604141020",
    "CustomerRequest" : {
        "CustomerFirstName" : "Scott",
        "CustomerLastName" : "Hamilton",
        "CompanyName" : "Wireless Advocates",
        "CustomerEmailId" : "hamiltonscottb@gmail.com",
        "AddressLine1" : "13206 SE 57th Street",
        "AddressLine2" : "",
        "City" : "Bellevue",
        "StateCode" : "WA",
        "CountryCode" : "USA",
        "PrimaryPhoneNumber" : "4259987664",
        "ZipCode" : "98006"
    },
    "DeviceRequest" : [
        {
            "DeviceId" : "DNPL1637DTTA",
            "SecondarySerialNumber" : "",
            "HardwareDateOfPurchase" : "06/04/14"
        }
    ],
    "ReferenceId" : "123456789"
}' /> 

<cfset verifyRequestObject = {
    AppleCareSalesDate = "06/03/14",
    PurchaseOrderNumber = "0604141020",
    CustomerRequest = {
        CustomerFirstName = "Scott",
        CustomerLastName = "Hamilton",
        CompanyName = "Wireless Advocates",
        CustomerEmailId = "hamiltonscottb@gmail.com",
        AddressLine1 = "13206 SE 57th Street",
        AddressLine2 = "",
        City = "Bellevue",
        StateCode = "WA",
        CountryCode = "USA",
        PrimaryPhoneNumber = "4259987664",
        ZipCode = "98006"
    },
    DeviceRequest = [
        {
            DeviceId = "DNPL1637DTTA",
            SecondarySerialNumber = "",
            HardwareDateOfPurchase = "06/03/14"
        }
    ],
    ReferenceId = "123456789"
} /> 


<cfhttp url="http://10.7.0.80:9000/api/AppleCare/VerifyOrder"  method="post" >
	<cfhttpparam type="header" name="Content-Type" value="application/json" />
	<cfhttpparam type="body" value="#serializeJson(verifyRequestObject)#">
</cfhttp>

<cfoutput>
	<h1>AC - Test</h1>
	
	Request  : #serializeJson(verifyRequestObject)#  
		<p>
	Response : #cfhttp.filecontent#
	
</cfoutput>	