<cfparam name="url.productguid" default="" />

<cfset productGuid = url.productguid />

<cfset message = "">
<cfset errormessage = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editPlanComponent = "37c8ca4d-ddbe-4e19-beda-aa49e85a4c68" />
	<cfset listPlansComponent = "c0a94124-ba7f-4de6-bab4-918aeb0e52b2" />

	<cfif form.action eq "clonePlan">
		<cfif !StructKeyExists(request.p,"active")>
			<cfset request.p.active = 0 >
		</cfif>
		<cfset newPlanGuid = application.model.AdminPlan.clonePlan(request.p.productGuid, request.p.deviceUPC, request.p.accessoryGersSku, request.p.channelId, request.p.active, request.p.productId) />
		<cfset message = "Plan has been channelized" />
		<cflocation url="index.cfm?c=#editPlanComponent#&productguid=#newPlanGuid#" addtoken="false" />
	<cfelseif form.action eq "cancelPlanClone">
		<cflocation url="index.cfm?c=#editPlanComponent#&productguid=#productGuid#" addtoken="false" />
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
 	<cfset clonePlanFormDisplay = application.view.AdminPlan.getClonePlanForm(productGuid) />
	<cfoutput>#clonePlanFormDisplay#</cfoutput>
</div>