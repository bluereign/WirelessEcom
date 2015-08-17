<cfparam name="url.templateId" default="" />

<cfset templateId = url.templateId />
	
<cfset message = "">
<cfset errormessage = "">
	
<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editTemplateComponent = "865a95d0-4d3a-437b-8263-652917bd05e4" />
	<cfset listTemplatesComponent = "ab3fd99b-4e0f-4c42-b788-92dea172f31f" />
	<cfset testTemplateComponent = "3fe1754a-b697-4a43-b6fe-bcf6187bfdca" />
	
	<cfif form.action eq "updateEmailTemplate">
		<!--- process image edit form here --->
		<cfif form.templateId EQ "">
			<cfset result = application.model.EmailManager.insertEmailTemplate(form) />
			<cfif result eq "success">
				<cfset message = "Email Template has been added" />
	    	<cfelse>
				<cfset error = result />
			</cfif>		
		<cfelse>
			<cfset result = application.model.EmailManager.updateEmailTemplate(form) />
			<cfif result eq "success">
				<cfset message = "Email Template has been saved" />
	    	<cfelse>
				<cfset error = result />
			</cfif>
		</cfif>
	<cfelseif form.action eq "showTestEmailTemplateForm">
		<cflocation url="index.cfm?c=#testTemplateComponent#&templateId=#templateId#" addtoken="false" />
	<cfelseif form.action eq "cancelEmailTemplateEdit">
		<cflocation url="index.cfm?c=#listTemplatesComponent#" addtoken="false" />
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
<!--- end show messages --->
<div>
    <cfset emailTemplateFormDisplay = application.view.EmailManager.getEditEmailTemplateForm(templateId)>
    <cfoutput>#emailTemplateFormDisplay#</cfoutput>
</div>