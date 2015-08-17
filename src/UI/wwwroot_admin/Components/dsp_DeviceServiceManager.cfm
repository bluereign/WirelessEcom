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
	<cfif form.action eq "showEditDeviceService">
    	<cfset showEdit = true />
		<cfset showList = false />
    <cfelseif form.action eq "showAddAllActiveServices">
		<cfset phoneDetails = application.model.AdminPhone.getPhone(url.productGuid) />
		<cfif phoneDetails.recordcount is not 0>
			<cfset  application.view.AdminDeviceService.getAddAllActiveServices(url.productguid,variables.channelId,phoneDetails.CarrierGuid) />
		<cfelse>
			<cfset tabletDetails = application.model.AdminTablet.getTablet(url.productGuid) />
			<cfif tabletDetails.recordcount is not 0>			
				<cfset  application.view.AdminDeviceService.getAddAllActiveServices(url.productguid,variables.channelId,tabletDetails.CarrierGuid) />
			</cfif>
		</cfif>
    <cfelseif form.action eq "showRemoveAllServices">		
		<cfset phoneDetails = application.model.AdminPhone.getPhone(url.productGuid) />
		<cfif phoneDetails.recordcount>
			<cfset  application.view.AdminDeviceService.getRemoveAllServices(url.productguid,variables.channelId,phoneDetails.CarrierGuid) />
		<cfelse>
			<cfset tabletDetails = application.model.AdminTablet.getTablet(url.productGuid) />
			<cfif tabletDetails.recordcount>
				<cfset  application.view.AdminDeviceService.getRemoveAllServices(url.productguid,variables.channelId,tabletDetails.CarrierGuid) />
			</cfif>
		</cfif>
	<cfelseif form.action eq "cancelDeviceServiceEdit">
    	<cfset showEdit = false />
		<cfset showList = true />
		
	<cfelseif form.action eq "updateDeviceService">
		<!--- process accessory edit form here --->
		<cfset result = application.model.AdminDeviceService.updateDeviceService(form) />
		<cfif result eq "success">
			<cfset message = "Service details updated succesfully" />
    	<cfelse>
			<cfset error = result />
		</cfif>		
	<cfelseif form.action eq "insertDeviceService">	
		<cfset result = application.model.AdminDeviceService.insertDeviceService(form) />
		<cfif result eq "success">
			<cfset message = "Service has been added" />
    	<cfelse>
			<cfset error = result />
		</cfif>
		
	<cfelseif form.action eq "deleteDeviceService">
		<cfset result = application.model.AdminDeviceService.deleteDeviceService(serviceGuid, url.productguid) />	
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
        <cfset deviceServiceFormDisplay = application.view.AdminDeviceService.getEditDeviceServiceForm(url.productguid, serviceGuid)>
        <cfoutput>#deviceServiceFormDisplay#</cfoutput>
    </div>
</cfif>

<cfif showList>
	<div>
		<cfset deviceServiceListDisplay = application.view.AdminDeviceService.getDeviceServiceList(url.productGuid) />
		<cfoutput>#deviceServiceListDisplay#</cfoutput>
		<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
	</div>
</cfif>