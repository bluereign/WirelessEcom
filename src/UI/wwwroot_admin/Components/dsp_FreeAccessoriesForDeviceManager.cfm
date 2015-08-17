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
		<cfif form.action eq "showEditFreeAccessoryForm">
	    	<cfset showEdit = true />
			<cfset showList = false />

	    <cfelseif form.action eq "cancelFreeAccessoryEdit">
	    	<cfset showEdit = false />
			<cfset showList = true />

		<cfelseif form.action eq "addFreeAccessoryForDevice">
			<!--- process image edit form here --->
			<cfset result = application.model.Catalog.insertAccessoryForDevice(form.accessories, url.productguid) />

			<cfif result eq "success">
				<cfset message = "Accessory has been added to this product" />
	    	<cfelse>
				<cfset error = result />
			</cfif>

		<cfelseif form.action eq "deleteFreeAccessory">
			<cfset result = application.model.Catalog.deleteAccessoryForDevice(accessoryId, url.productguid) />
	        <cfset message = "Accessory removed from this product" />

		<cfelseif form.action eq "bulkFreeAccessoryUpdate">
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
	        <cfset freeAccessoryFormDisplay = application.view.FreeDeviceAccessoryManager.getEditAccessoryForDeviceForm(url.productguid, imageId)>
	        <cfoutput>#freeAccessoryFormDisplay#</cfoutput>
	    </div>
	</cfif>

	<cfif showList>
		<div>
			<cfset freeAccessoryListDisplay = application.view.FreeDeviceAccessoryManager.getAccessoryForDeviceDisplayList(url.productguid) />
			<cfoutput>#freeAccessoryListDisplay#</cfoutput>
		</div>
	</cfif>
</cfif>