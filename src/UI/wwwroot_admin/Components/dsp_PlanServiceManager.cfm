<!--- get the properties --->
<cfparam name="form.serviceGuid" default="" />

<cfset serviceGuid = form.serviceGuid />

<!--- display logic --->
<cfset message = "" />
<cfset error = "" />
<cfset result = "" />
<cfset showEdit = false />
<cfset showList = true />


<cfif IsDefined("form.action")>
	<cfif form.action eq "showAddAllActiveServicesToRateplan">
			<cfset local.planDetails = application.model.AdminPlan.getPlan(url.productGuid) />
			<cfset  application.view.AdminDeviceService.getAddAllActiveServicesToRateplan(url.productguid,variables.channelId,local.planDetails.CarrierGuid) />
	<cfelseif form.action eq "showRemoveServicesToRateplan">
			<cfset local.planDetails = application.model.AdminPlan.getPlan(url.productGuid) />
			<cfset  application.view.AdminDeviceService.getRemoveAllServicesToRateplan(url.productguid,variables.channelId,local.planDetails.CarrierGuid) />
	<cfelseif form.action eq "showEditPlanService">
    	<cfset showEdit = true />
		<cfset showList = false />
		
    <cfelseif form.action eq "cancelPlanServiceEdit">
    	<cfset showEdit = false />
		<cfset showList = true />
		
	<cfelseif form.action eq "updatePlanService">
		<!--- process accessory edit form here --->
		<cfset result = application.model.AdminPlanService.updatePlanService(form) />
		<cfif result eq "success">
			<cfset message = "Service details updated succesfully" />
    	<cfelse>
			<cfset error = result />
		</cfif>		
	<cfelseif form.action eq "insertPlanService">	
		<cfset result = application.model.AdminPlanService.insertPlanService(form) />
		<cfif result eq "success">
			<cfset message = "Service has been added" />
    	<cfelse>
			<cfset error = result />
		</cfif>
		
	<cfelseif form.action eq "deletePlanService">
		<cfset result = application.model.AdminPlanService.deletePlanService(serviceGuid, url.productguid) />	
        <cfset message = "Service removed" />
	</cfif>
</cfif>

<cfif len(message) gt 0>
	<div class="message">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfif len(error) gt 0>
	<div class="errormessage">
    	<span class="form-confirm-inline"><cfoutput>#errormessage#</cfoutput></span>
    </div>
</cfif>

<cfif showEdit eq true>
    <div>
        <cfset planServiceFormDisplay = application.view.AdminPlanService.getEditPlanServiceForm(url.productguid, serviceGuid)>
        <cfoutput>#planServiceFormDisplay#</cfoutput>
    </div>
</cfif>

<cfif showList>
	<div>
		<!---<cfset planServiceListDisplay = application.view.AdminPlanService.getPlanServiceList(url.productguid) />--->
		<cfset planServiceListDisplay = application.view.AdminPlanService.getPlanServiceList(url.productguid) />
		<cfoutput>#planServiceListDisplay#</cfoutput>
		<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
	</div>
</cfif>