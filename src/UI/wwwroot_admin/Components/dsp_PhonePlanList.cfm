<cfparam name="form.planGuid" default="" />

<cfset planGuid = form.planGuid />
<cfset showList = true />
<cfset local = {} />

<cfif IsDefined("form.action")>
	<cfif form.action eq "updateDefaultPhone">	
		<cfset application.model.AdminPhone.updateDefaultDevicePlan( form.phoneGuid, form.isDefaultRateplanGuid ) />
	<cfelseif form.action eq "showAddAllActivePlans">
		<cfset local.phoneDetails = application.model.AdminPhone.getPhone(url.productGuid) />
		<cfset  application.view.AdminDevicePlan.getAddAllActivePlans(url.productguid,variables.channelId,local.phoneDetails.CarrierGuid) />
	<cfelseif form.action eq "showRemoveAllPlans">	
		<cfset local.phoneDetails = application.model.AdminPhone.getPhone(url.productGuid) />
		<cfset  application.view.AdminDevicePlan.getRemoveAllPlans(url.productguid,variables.channelId,local.phoneDetails.CarrierGuid) />
	<cfelseif form.action eq "showEditDevicePlan">
	    <div>
			<cfset devicePlanFormDisplay = application.view.AdminDevicePlan.getEditDevicePlanForm(url.productguid, planGuid)>
	      	<cfoutput>#devicePlanFormDisplay#</cfoutput>
	    </div>
	    <cfset showList = false />
	<cfelseif form.action eq "insertDevicePlan">
		<cfset result = application.model.AdminDevicePlan.insertDevicePlan(form) />
		<cfif result eq "success">
			<cfset message = "Plan has been added" />
    	<cfelse>
			<cfset error = result />
		</cfif>
	<cfelseif form.action eq "deleteDevicePlan">
		<cfset result = application.model.AdminDevicePlan.deleteDevicePlan(planGuid, url.productguid) />	
        <cfset message = "Plan removed" />			 	
	</cfif>
</cfif>

<cfif structkeyexists(url, "productguid") and showList >
	<cfset planListHTML = application.view.AdminDevicePlan.getDevicePlanList(url.productguid)>
	<cfoutput>
		#planListHTML#
	</cfoutput>
	
	<p>&nbsp;</p><p>&nbsp;</p>
</cfif>	