<cfparam name="form.deviceGuid" default="" />

<cfset deviceGuid = form.deviceGuid />

	<cfif structkeyexists(url, "productguid")>
		<cfset showList = true />
	</cfif>

	<cfif IsDefined("form.action")>
		
		<cfif form.action eq "showAddAllActivePhones">
			<cfset local.planDetails = application.model.AdminPlan.getPlan(url.productGuid) />
			<cfset  application.view.AdminDevicePlan.getAddAllActiveDevices(url.productguid,variables.channelId,local.planDetails.CarrierGuid) />
		<cfelseif form.action eq "showRemoveAllPhones">
			<cfset local.planDetails = application.model.AdminPlan.getPlan(url.productGuid) />
			<cfset  application.view.AdminDevicePlan.getRemoveAllDevices(url.productguid,variables.channelId,local.planDetails.CarrierGuid) />
		<cfelseif form.action eq "showEditPlanDevice">
		    <div>
				<cfset planDeviceFormDisplay = application.view.AdminPlan.getEditPlanDeviceForm(deviceGuid, url.productguid)>
		      	<cfoutput>#planDeviceFormDisplay#</cfoutput>
		    </div>
		    <cfset showList = false />		
	    <cfelseif form.action eq "insertPlanDevice">
			<cfset result = application.model.AdminDevicePlan.insertDevicePlan(form) />
			<cfif result eq "success">
				<cfset message = "Phone has been added" />
	    	<cfelse>
				<cfset error = result />
			</cfif>
		<cfelseif form.action eq "deletePlanDevice">
			<cfset result = application.model.AdminDevicePlan.deleteDevicePlan(url.productguid, deviceGuid) />	
	        <cfset message = "Phone removed" />			 	
		</cfif>
		
	</cfif>
	
	<cfif showList>
		<cfset phoneListHTML = application.view.AdminPlan.getPlanPhoneList(url.productguid)>
		<cfoutput>
			#phoneListHTML#
		</cfoutput>
		<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
	</cfif>
	
