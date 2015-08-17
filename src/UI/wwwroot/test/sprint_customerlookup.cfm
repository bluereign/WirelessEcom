<h1>Sprint Customer Lookup</h1>

<cfscript>
	request.layoutFile = 'nolayout';
	request.bodycontent = '';
</cfscript>

<cfparam name="form.mdn1" default="" />
<cfparam name="form.pin" default="" />
<cfparam name="form.ActivationType" default="UPGRADE" />

<cfparam name="form.EndPoint" default="http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL" />

<cfoutput>
	<form name="testform" action="" method="post">
		MDN Line 1: <input name="mdn1" value="#form.mdn1#" /> <br />
		PIN: <input name="pin" value="#form.pin#" /> <br />
		
		Activation Type: 
		<select name="ActivationType">
			<option value="UPGRADE" <cfif form.endpoint eq 'UPGRADE'>selected</cfif>>Upgrade</option>
			<option value="ADD_ON" <cfif form.endpoint eq 'ADD_ON'>selected</cfif>>Add a Line</option>
		</select><br />
		
		Sprint End Point: 
		<select name="endpoint">
			<option value="http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL" <cfif form.endpoint eq 'http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL'>selected</cfif>>http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL</option>
			<option value="http://stg-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL" <cfif form.endpoint eq 'http://stg-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL'>selected</cfif>>http://stg-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL</option>
			<option value="http://10.7.0.120/sprintcarrierinterface/sprintservice.asmx?WSDL" <cfif form.endpoint eq 'http://10.7.0.120/sprintcarrierinterface/sprintservice.asmx?WSDL'>selected</cfif>>http://10.7.0.120/sprintcarrierinterface/sprintservice.asmx?WSDL</option>
		</select>
		<br />
		
		<input name="submit" type="submit" value="Submit">
	</form>
</cfoutput>

<cfif StructKeyExists(form, 'Submit')>

	<cfscript>
		local.request.referenceNumber = application.model.checkoutHelper.generateReferenceNumber();
		local.request.Mdn = form.mdn1;
		local.request.pin = form.pin;
		local.request.LastFourSsn = '';
		local.request.SecurityQuestionAnswer = '';
		local.request.sprintOrderType = form.ActivationType;
	</cfscript>

	<!--- invoke the request --->
	<cfinvoke
	     webservice="#request.config.SprintEndPoint#"
	     method="CustomerLookupByMDN"
	     returnvariable="local.resCustomerLookupByMDN">
	        <cfinvokeargument name="MDN" value="#local.request.mdn#" />
	        <cfinvokeargument name="SecretKey" value="#local.request.pin#" />
			<cfinvokeargument name="SSN" value="#local.request.LastFourSsn#" />
			<cfinvokeargument name="QuestionAnswer" value="#local.request.SecurityQuestionAnswer#" />
			<cfinvokeargument name="ReferenceNumber" value="#local.request.referenceNumber#" />
	        <cfinvokeargument name="OrderType" value="#local.request.sprintOrderType#" />
	</cfinvoke>
	
	<cfdump var="#local.request#">
	Endpoint: <cfoutput><p>#request.config.SprintEndPoint#</p></cfoutput>
	
	<cfdump var="#local.resCustomerLookupByMDN.getErrorCode()#">
	<cfdump var="#local.resCustomerLookupByMDN.getServiceResponseSubCode()#">
	<cfdump var="#local.resCustomerLookupByMDN#">


</cfif>