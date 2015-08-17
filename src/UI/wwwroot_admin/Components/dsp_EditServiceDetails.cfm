<cfparam name="url.productguid" default="" />

<cfset serviceGuid = url.productguid />

<cfset message = "">
<cfset errormessage = "">
<cfset billCodeExists = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editServiceComponent = "73daf562-5070-444f-9c83-9063567776fe" />
	<cfset listServicesComponent = "abf6a5cf-8e4e-4cc1-ad0d-2812b2a733e1" />
	<cfset cloneServiceComponent = "74eda0a1-f614-4624-abea-807ef77d99a2" />
	<cfset masterCloneServiceComponent = "3BDFEE66-8E7B-467E-BCD4-A2BBF98656BA" />

	<cfif form.action eq "updateService">
		<!--- check for required fields to be filled --->
		<cfif form.billCode EQ "">
			<cfset errormessage = "Carrier Bill Code is required" />
		<cfelseif form.name EQ "">
			<cfset errormessage = "Name is required" />
		<cfelse>
			<!--- check if gersSku matches one in the gersItm table if not, set to blank set errormessage --->
			<cfif form.gersSku NEQ "">
				<cfset isGoodGersSku = application.model.Utility.checkGersSku(form.gersSku) />
				<cfif NOT isGoodGersSku>
					<cfset form.gersSku = "" />
					<cfset errormessage = "GERS SKU entered could not be found" />
				</cfif>
			</cfif>
			<cfif form.serviceGuid EQ "">
				<cfset result = application.model.ServiceManager.insertService(form) />
				<cfif result eq "success">
					<cfset message = "Service has been added" />
		    	<cfelse>
					<cfset errormessage = result />
				</cfif>
			<cfelse>
				<cfset result = application.model.ServiceManager.updateService(form) />
				<cfif result eq "success">
					<cfset message = "Service updated succesfully" />
		    	<cfelse>
					<cfset errormessage = result />
				</cfif>
			</cfif>
		</cfif>
	<cfelseif form.action EQ "showCloneServiceForm">
		<cflocation url="index.cfm?c=#cloneServiceComponent#&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action EQ "showMasterCloneServiceForm">
		<cflocation url="index.cfm?c=#masterCloneServiceComponent#&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelServiceEdit">
		<cflocation url="index.cfm?c=#listPlansComponent#" addtoken="false" />
	</cfif>
</cfif>

<cfif len(trim(productGuid))>
	<cfset channelId = application.model.AdminPhone.getChannelId(productGuid)>
<cfelse>
	<cfset channelId = 0>
</cfif>

<!--- show messages --->
<cfif len(message) gt 0>
	<div class="message">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfif len(errormessage) gt 0>
	<div class="errormessage">
    	<span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
    </div>
</cfif>

<!--- end show messages --->
<cfif serviceGuid NEQ "" and channelId is 1>
	<div>
			<a href="javascript: if(confirm('Are you sure you want to channelize this service?')) { show('action=showCloneServiceForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this plan into a new service entry"><span>Channelize Service</span></a>
			&nbsp;&nbsp;&nbsp;
		<cfif channelId eq 1>
			<a href="javascript: if(confirm('Are you sure you want to Clone this service?')) { show('action=showMasterCloneServiceForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this plan into a new Master service entry"><span>Copy Service as New</span></a>
		</cfif>
	</div>
</cfif>
<div>
 	<cfset serviceFormDisplay = application.view.ServiceManager.getEditServiceForm(serviceGuid) />
	<cfoutput>#serviceFormDisplay#</cfoutput>
</div>