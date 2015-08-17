
<cfset message = "">
<cfset errormessage = "">
<cfset viewMode = "list">
<cfif !StructKeyExists(request.p,"channelId")>
	<cfset request.p.channelId = 1>
</cfif>

<!--- handle forms actions --->
<cfif IsDefined("request.p.action")>
	<cfif request.p.action eq "showEditEditorsChoiceForm">
    	<cfset viewMode = 'Edit' />

	<cfelseif request.p.action eq "showEditEditorsChoiceList">
    	<cfset viewMode = 'List' />

	<cfelseif request.p.action eq "cancelEditorsChoiceEdit">
    	<cfset viewMode = 'List' />

	<cfelseif request.p.action eq "saveEditorChoices">

		<cfset result = application.model.AdminEditorsChoice.saveEditorsChoice(request.p.channelId,form) />

		<cfif result eq "success">
			<cfset message = "Accessory has been added to this product" />
    	<cfelse>
			<cfset error = result />
		</cfif>

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


<cfif viewMode eq "edit">
    <div>
        <cfset accessoryFormDisplay = application.view.AdminEditorsChoice.getEditorsChoiceForm(request.p.channelId)>
        <cfoutput>#accessoryFormDisplay#</cfoutput>
    </div>
</cfif>

<cfif viewMode eq "list">
	<div>
		<cfset editorsChoiceFormDisplay = application.view.AdminEditorsChoice.getEditorsChoiceList(request.p.channelId) />
		<cfoutput>#editorsChoiceFormDisplay#</cfoutput>
	</div>
</cfif>



