<!--- get the properties --->
<cfparam name="form.accessoryId" default="" />

<cfset accessoryId = form.accessoryId />

<!--- display logic --->
<cfset message = "" />
<cfset error = "" />
<cfset result = "" />
<cfset showEdit = false />
<cfset showList = true />


<cfif IsDefined("form.action")>
	<cfif form.action eq "showEditAccessory">
    	<cfset showEdit = true />
		<cfset showList = false />
		
    <cfelseif form.action eq "cancelAccessoryEdit">
    	<cfset showEdit = false />
		<cfset showList = true />
		
	<cfelseif form.action eq "updateAccessoryDetails">
		<!--- process accessory edit form here --->
		<cfif form.accessoryId EQ "">
			<cfset result = application.model.AdminAccessory.insertAccessory(form) />
			<cfif result eq "success">
				<cfset message = "Accessory has been added" />
	    	<cfelse>
				<cfset error = result />
			</cfif>		
		<cfelse>
			<cfset result = application.model.AdminAccessory.updateAccessory(form) />
			<cfif result eq "success">
				<cfset message = "Accessory details updated succesfully" />
	    	<cfelse>
				<cfset error = result />
			</cfif>
		</cfif>
		
	<cfelseif form.action eq "deleteAccessory">
		<cfset result = application.model.AdminAccessory.deleteAccessory(accessoryId) />	
        <cfset message = "Accessory removed." />
	</cfif>
</cfif>

<!--- if the component is calling for the edit form, so the form --->
<cfif URL.c eq "4759aa37-7600-4da8-8b57-ab15d9cf2310">
	<cfset showEdit = true />
	<cfset showList = false />
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
        <cfset accessoryFormDisplay = application.view.AdminAccessory.getEditAccessoryForm(accessoryId)>
        <cfoutput>#accessoryFormDisplay#</cfoutput>
    </div>
</cfif>

<cfif showList>
	<div>
		<cfset accessoryListDisplay = application.view.AdminAccessory.getAccessoryList() />
		<cfoutput>#accessoryListDisplay#</cfoutput>
	</div>
</cfif>