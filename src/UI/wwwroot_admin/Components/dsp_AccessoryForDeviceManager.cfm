<!--- get the properties --->
<cfparam name="url.productguid" default="" />
<cfparam name="accesoryId" default="" />

<cfif StructKeyExists(form, "accessories")>
	<cfset accesoryId = form.accessories />
</cfif>

<cfif url.productguid neq "">
	<!--- display logic --->
	<cfset message = "" />
	<cfset error = "" />
	<cfset result = "" />
	<cfset showEdit = false />
	<cfset showList = true />
	
	<cfif IsDefined("form.action")>
		<cfif form.action eq "showEditAccessoryForm">
	    	<cfset showEdit = true />
			<cfset showList = false />
			
	    <cfelseif form.action eq "cancelAccessoryEdit">
	    	<cfset showEdit = false />
			<cfset showList = true />
			
		<cfelseif form.action eq "addAccessoryForDevice">
			<!--- process image edit form here --->
			<cfset result = application.model.Catalog.insertAccessoryForDevice(form.accessories, url.productguid) />
			
			<cfif result eq "success">
				<cfset message = "Accessory has been added to this product" />
	    	<cfelse>
				<cfset error = result />
			</cfif>		
			
		<cfelseif form.action eq "deleteAccessory">
			<cfset result = application.model.Catalog.deleteAccessoryForDevice(accessoryId, url.productguid) />	
	        <cfset message = "Accessory removed from this product" />
	
		<cfelseif form.action eq "bulkAccessoryUpdate">
			<cfset result = application.model.DeviceAccessoryManager.bulkAccessoryUpdate(form) />
			<cfset message = "Accessories Updated" />
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
	        <cfset accessoryFormDisplay = application.view.DeviceAccessoryManager.getEditAccessoryForDeviceForm(url.productguid, imageId)>
	        <cfoutput>#accessoryFormDisplay#</cfoutput>
	    </div>
	</cfif>
	
	<cfif showList>
		<div>
			<cfset accessoryListDisplay = application.view.DeviceAccessoryManager.getAccessoryForDeviceDisplayList(url.productguid) />
			<cfoutput>#accessoryListDisplay#</cfoutput>
		</div>
	</cfif>
</cfif>