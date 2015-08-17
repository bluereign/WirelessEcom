<h1>Sprint Credit Check</h1>

<cfscript>
	request.layoutFile = 'nolayout';
	request.bodycontent = '';
</cfscript>

<cfparam name="form.firstname" default="John" />
<cfparam name="form.lastname" default="Doe" />
<cfparam name="form.dob" default="1/1/1980" />
<cfparam name="form.ssn" default="555550064" />
<cfparam name="form.EndPoint" default="http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL" />

<cfoutput>
	<form name="testform" action="" method="post">
		First Name: <input name="firstName" value="#form.firstname#" /> <br />
		Last Name: <input name="lastName" value="#form.lastName#" /> <br />
		DOB: <input name="dob" value="#form.dob#" /> <br />
		SSN: <input name="ssn" value="#form.ssn#" /> <br />
		Sprint End Point: 
		<select name="endpoint">
			<option value="http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL" <cfif form.endpoint eq 'http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL'>selected</cfif>>http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL</option>
			<option value="http://stg-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL" <cfif form.endpoint eq 'http://stg-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL'>selected</cfif>>http://stg-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL</option>
		</select>
		<br />
		
		<input name="submit" type="submit" value="Submit">
	</form>
</cfoutput>

<cfif StructKeyExists(form, 'Submit')>

<cfscript>	
	local.referenceNumber = application.model.checkoutHelper.generateReferenceNumber();
	local.numberOfLinesRequested = 1;
	
	local.request.addressToValidate = structNew();
	local.request.addressToValidate.addressLine1 = '2911 2nd Ave';
	local.request.addressToValidate.addressLine2 = '';
	local.request.addressToValidate.addressLine3 = '';
	local.request.addressToValidate.city = 'Seattle';
	local.request.addressToValidate.state = 'WA';
	local.request.addressToValidate.country = '';
	local.request.addressToValidate.zipcode = '98121';
	local.request.addressToValidate.extendedZipCode = '';
	local.request.addressToValidate.name = structNew();
	local.request.addressToValidate.name.firstName = form.firstname;
	local.request.addressToValidate.name.middleInitial = '';
	local.request.addressToValidate.name.lastName = form.lastName;
	local.request.addressToValidate.name.prefix = '';
	local.request.addressToValidate.name.suffix = '';
	local.request.addressToValidate.contact = structNew();
	local.request.addressToValidate.contact.workPhone = '2055554444';
	local.request.addressToValidate.contact.eveningPhone = '2055554444';
	local.request.addressToValidate.contact.cellPhone = '';
	local.request.addressToValidate.contact.workPhoneExt = '';
	local.request.addressToValidate.contact.email = '';
	local.request.addressToValidate.companyName = '';
	
	local.addressType = 'Billing';
</cfscript>

<cfinvoke webservice="#trim(request.config.sprintEndPoint)#" method="ValidateAddress" returnvariable="local.resValidateAddress" refreshwsdl="true">
	<cfinvokeargument name="addressToValidate" value="#local.request.addressToValidate#" />
	<cfinvokeargument name="addressType" value="#local.addressType#" />
	<cfinvokeargument name="referenceNumber"  value="#local.referenceNumber#" />
</cfinvoke>


<cfscript>
	request.config.SprintEndPoint =  form.Endpoint;
	
    local.request.billingName = structNew();
    local.request.billingName.firstName = form.firstname;
    local.request.billingName.middleInitial = '';
    local.request.billingName.lastName = form.lastname;
    local.request.billingName.prefix = '';
    local.request.billingName.suffix = '';

    local.request.contact = structNew();
    local.request.contact.workPhone = '2065554444';
    local.request.contact.eveningPhone = '2065554444';
    local.request.contact.cellPhone = '';
    local.request.contact.workPhoneExt = '';
    local.request.contact.email = 'rlinmark@wirelessadvocates.com';

    local.request.credentials = structNew();
    local.request.credentials.ssn = form.ssn;
    local.request.credentials.idType = 'DL';
    local.request.credentials.id = 'WA2134';
    local.request.credentials.idExpiration = '1/1/2020';
    local.request.credentials.state = 'WA';
    local.request.credentials.dob = '1/1/1980';
	

</cfscript>

<cfdump var="#local.request#">
Endpoint: <cfoutput><p>#request.config.SprintEndPoint#</p></cfoutput>


<cfinvoke webservice="#trim(request.config.sprintEndPoint)#" method="CheckCredit" returnvariable="local.resCheckCredit" refreshwsdl="true">
    <cfinvokeargument name="billingName" value="#local.request.billingName#" />
    <cfinvokeargument name="serviceZipCode" value="98121" />
    <cfinvokeargument name="contactInfo" value="#local.request.contact#" />
    <cfinvokeargument name="billingContactCredentials" value="#local.request.credentials#" />
    <cfinvokeargument name="numberOfLines" value="#local.numberOfLinesRequested#" />
	<cfinvokeargument name="Question" value="" />
	<cfinvokeargument name="Answer" value="" />
    <cfinvokeargument name="referenceNumber" value="#local.referenceNumber#" />
</cfinvoke>



<cfdump var="#local.resCheckCredit.getErrorCode()#">
<cfdump var="#local.resCheckCredit.getServiceResponseSubCode()#">
<cfdump var="#local.resCheckCredit#">


</cfif>