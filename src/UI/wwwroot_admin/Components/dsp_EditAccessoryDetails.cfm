<cfparam name="url.productguid" default="" />
<cfparam name="url.errorMessage" default="" />

<cfset accessoryId = url.productguid />

<cfset message = "">
<cfset errormessage = url.errorMessage />


<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfif form.action eq "updateAccessoryDetails">
		<!--- check if gersSku matches one in the gersItm table if not, set to blank set errormessage --->
		<cfif form.gersSku NEQ "">
			<cfset isGoodGersSku = application.model.Utility.checkGersSku(form.gersSku) />
			<cfif NOT isGoodGersSku>
				<cfset form.gersSku = "" />
				<cfset errormessage = "GERS SKU entered could not be found" />
			</cfif>
		</cfif>
		<!--- process accessory edit form here --->
		<cfif form.accessoryId EQ "">
			<cfset result = application.model.AdminAccessory.insertAccessory(form) />
			<cfif result neq "">
				<cfset message = "Accessory has been added" />

				<cfset accessoryId = result>
                <cflocation url="index.cfm?c=6360f268-4e75-4cf7-a6a1-140958a61cb2&productguid=#accessoryId#">
	    	<cfelse>
				<cfset error = result />
			</cfif>
		<cfelse>
			<cfset result = application.model.AdminAccessory.updateAccessory(form) />
			<cfif result eq "success">
				<cfset message = "Accessory details updated succesfully" />
	    	<cfelse>
				<cfset error = result />
			</cfif>
		</cfif>
	<cfelseif form.action eq "showCloneAccessoryForm">
		<cflocation url="index.cfm?c=C26EA5F7-978E-4C9C-9C93-9D61C5ECAD31&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "showMasterCloneAccessoryForm">
		<cflocation url="index.cfm?c=D73A8427-C0E2-450B-857C-CBF29FDB02BC&productguid=#productGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelAccessoryEdit">
		<cflocation url="index.cfm?c=399900ba-1837-48bc-8944-1f14195a9f37" addtoken="false" />
	</cfif>
</cfif>

<cfif len(trim(productGuid))>
	<cfset channelId = application.model.AdminPhone.getChannelId(productGuid)>
<cfelse>
	<cfset channelId = 0>
</cfif>

<!--- end handle forms actions --->
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
<cfif productGuid NEQ "" and channelId is 1>
	<div>
			<a href="javascript: if(confirm('Are you sure you want to channelize this Accessory?')) { show('action=showCloneAccessoryForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this accessory into a new entry"><span>Channelize Accessory</span></a>
			&nbsp;&nbsp;&nbsp;
		<cfif channelId eq 1>
			<a href="javascript: if(confirm('Are you sure you want to Clone this Accessory?')) { show('action=showMasterCloneAccessoryForm|productId=<cfoutput>#productGuid#</cfoutput>'); }" class="button" title="Copy everything about this accessory into a new Master entry"><span>Copy Accessory as New</span></a>
		</cfif>
	</div>
</cfif>
<div>
	<cfset accessoryFormDisplay = application.view.AdminAccessory.getEditAccessoryForm(accessoryId)>
	<cfoutput>#accessoryFormDisplay#</cfoutput>
</div>