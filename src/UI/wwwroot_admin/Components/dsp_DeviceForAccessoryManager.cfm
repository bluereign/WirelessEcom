<!--- get the properties --->

<cfif structKeyExists(request.p,"productguid") && request.p.productguid neq "">
	<!--- display logic --->
	<cfset message = "" />
	<cfset error = "" />
	<cfset result = "" />
	<cfset showEdit = false />
	<cfset showList = true />

	<cfif structKeyExists(request.p,"action")>
		<cfswitch expression="#request.p.action#" >
			<cfcase value="showEditAccessoryDeviceForm">
		    	<cfset showEdit = true />
				<cfset showList = false />
			</cfcase>
		    <cfcase value="cancelAccessoryDeviceEdit">
		    	<cfset showEdit = false />
				<cfset showList = true />
			</cfcase>
			<cfcase value="addAccessoryDevice">
				<cfset result = application.model.AccessoryDeviceManager.insertAccessoryForDevice(request.p.productguid,request.p.deviceId) />

				<cfif result eq "success">
					<cfset message = "Phone has been added to this accessory" />
		    	<cfelse>
					<cfset error = result />
				</cfif>
			</cfcase>
			<cfcase value="deleteAccessoryDevice">
				<cfset result = application.model.AccessoryDeviceManager.deleteAccessoryDevice(request.p.productguid, request.p.deviceId) />
		        <cfset message = "Phone removed from this accessory" />
			</cfcase>
			<cfcase value="bulkAccessoryDeviceUpdate">
				<cfset result = application.model.AccessoryDeviceManager.bulkAccessoryDeviceUpdate(form) />
				<cfset message = "Phones Updated" />
			</cfcase>
		</cfswitch>
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
	        <cfset accessoryDeviceFormDisplay = application.view.AccessoryDeviceManager.getEditAccessoryDeviceForm(request.p.productguid)>
	        <cfoutput>#accessoryDeviceFormDisplay#</cfoutput>
	    </div>
	</cfif>

	<cfif showList>
		<div>
			<cfset accessoryDeviceListDisplay = application.view.AccessoryDeviceManager.getAccessoryDeviceDisplayList(request.p.productguid) />
			<cfoutput>#accessoryDeviceListDisplay#</cfoutput>
		</div>
	</cfif>
</cfif>