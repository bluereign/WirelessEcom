<cfparam name="url.productguid" default="" />


<cfset message = "">
<cfset errormessage = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<!---<cfset editPhoneComponent = "" />
	<cfset listPhonesComponent = "" />--->
	<cfif !StructKeyExists(request.p,"active")>
		<cfset request.p.active = 0 >
	</cfif>
	<cfif form.action eq "cloneAccessory">
		<cfset newPhoneGuid = application.model.AdminAccessory.cloneMasterAccessory(request.p.productGuid, request.p.name, request.p.newUPC, request.p.oldSku, request.p.accessoryGersSku, request.p.channelId, request.p.active, request.p.productId) />
		<cfset message = "Accessory has been channelized" />
		<cflocation url="index.cfm?c=6360f268-4e75-4cf7-a6a1-140958a61cb2&productguid=#newPhoneGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelAccessoryClone">
		<cflocation url="index.cfm?c=6360f268-4e75-4cf7-a6a1-140958a61cb2&productguid=#productGuid#" addtoken="false" />
	</cfif>
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

<div>
 	<cfset cloneAccessoryFormDisplay = application.view.AdminAccessory.getMasterCloneAccessoryForm(productGuid) />
	<cfoutput>#cloneAccessoryFormDisplay#</cfoutput>
</div>