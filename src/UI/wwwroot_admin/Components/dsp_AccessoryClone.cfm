<cfparam name="url.productguid" default="" />
<cfparam name="url.errorMessage" default="" />


<cfset message = "">
<cfset errormessage = url.errorMessage />

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<!---<cfset editPhoneComponent = "" />
	<cfset listPhonesComponent = "" />--->
	<cfif !StructKeyExists(request.p,"active")>
		<cfset request.p.active = 0 >
	</cfif>
	<cfif form.action eq "cloneAccessory">
		<cfif verifyGersSku(request.p.accessoryGersSku)>
			<cfset newPhoneGuid = application.model.AdminAccessory.cloneAccessory(request.p.productGuid, request.p.deviceUPC, request.p.accessoryGersSku, request.p.channelId, request.p.active, request.p.productId) />
			<cfset message = "Accessory has been channelized" />
			<cflocation url="index.cfm?c=6360f268-4e75-4cf7-a6a1-140958a61cb2&productguid=#newPhoneGuid#" addtoken="false" />
		<cfelse>
			<cfset errormessage = URLEncodedFormat("Accessory NOT channelized. GersSku (#request.p.accessoryGersSku#) is not a valid SKU") />
			<cflocation url="index.cfm?c=C26EA5F7-978E-4C9C-9C93-9D61C5ECAD31&productguid=#request.p.productGuid#&errorMessage=#errorMessage#" addtoken="false" />
		</cfif>
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
 	<cfset cloneAccessoryFormDisplay = application.view.AdminAccessory.getCloneAccessoryForm(productGuid) />
	<cfoutput>#cloneAccessoryFormDisplay#</cfoutput>
</div>

<cffunction name="verifyGersSku" output="false" >
	<cfargument name="gerssku" type="string" required="true" />
	
	<cfquery name="qCheckSku" datasource="wirelessadvocates"  > 
		select count(*) as ct from catalog.GersItm where gersSku = '#arguments.gerssku#'
	</cfquery>
	
	<cfreturn qCheckSku.ct gt 0/>
	
</cffunction>