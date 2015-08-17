<cfparam name="url.productguid" default="" />


<cfset message = "">
<cfset errormessage = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editTabletComponent = "" />
	<cfset listTabletsComponent = "" />
	<cfif !StructKeyExists(request.p,"active")>
		<cfset request.p.active = 0 >
	</cfif>
	<cfif form.action eq "cloneTablet">
		<cfset newTabletGuid = application.model.AdminTablet.cloneMasterTablet(request.p.productGuid, request.p.name, request.p.newUPC, request.p.oldSku, request.p.accessoryGersSku, request.p.channelId, request.p.active, request.p.productId) />
		<cfset message = "Tablet has been Cloned as Master" />
		<cflocation url="index.cfm?c=cab863f7-08da-4011-893e-12c2e12c64cd&productguid=#newTabletGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelTabletClone">
		<cflocation url="index.cfm?c=cab863f7-08da-4011-893e-12c2e12c64cd&productguid=#productGuid#" addtoken="false" />
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
 	<cfset cloneTabletFormDisplay = application.view.AdminTablet.getMasterCloneTabletForm(productGuid) />
	<cfoutput>#cloneTabletFormDisplay#</cfoutput>
</div>