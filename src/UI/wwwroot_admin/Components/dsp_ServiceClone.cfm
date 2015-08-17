<cfparam name="url.productguid" default="" />

<cfset productGuid = url.productguid />

<cfset message = "">
<cfset errormessage = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editServiceComponent = "73daf562-5070-444f-9c83-9063567776fe" />
	<cfset listServicesComponent = "abf6a5cf-8e4e-4cc1-ad0d-2812b2a733e1" />
	<cfif !StructKeyExists(request.p,"active")>
		<cfset request.p.active = 0 >
	</cfif>
	<cfif form.action eq "cloneService">
		<cfset newServiceGuid = application.model.ServiceManager.cloneService(request.p.serviceGuid, request.p.deviceUPC, request.p.accessoryGersSku, request.p.channelId, request.p.active, request.p.productId) />
		<cfset message = "Service has been cloned" />
		<cflocation url="index.cfm?c=#editServiceComponent#&productguid=#newServiceGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelServiceClone">
		<cflocation url="index.cfm?c=#editServiceComponent#&productguid=#productGuid#" addtoken="false" />
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
 	<cfset cloneServiceFormDisplay = application.view.ServiceManager.getCloneServiceForm(productGuid) />
	<cfoutput>#cloneServiceFormDisplay#</cfoutput>
</div>