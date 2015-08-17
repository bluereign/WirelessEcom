<!--- get the properties --->
<cfparam name="url.templateId" default="" />

<cfset templateId = url.templateId />

<!--- display logic --->
<cfset message = "" />
<cfset error = "" />
<cfset result = "" />
<cfset editTemplateComponent = "865a95d0-4d3a-437b-8263-652917bd05e4" />

<cfif IsDefined("form.action")>
    <cfif form.action eq "cancelEmailTemplateTest">
		<cfoutput>
			<cflocation url="index.cfm?c=#editTemplateComponent#&templateId=#templateId#" addtoken="false" />
		</cfoutput>
	
	<cfelseif form.action eq "testEmailTemplate">
		<cfif form.parameters EQ "" or form.to EQ "" or form.from eq "">
			<cfif form.parameters EQ "">
				<cfset error = "The test form needs parameters to run the email test.<br />" />
			</cfif>	
			<cfif form.to EQ "">
				<cfset error = "The test form needs an email address in the To box to run the email test.<br />" />
			</cfif>	
			<cfif form.from EQ "">
				<cfset error = "The test form needs an email address in the From box to run the email test.<br />" />
			</cfif>	
		<cfelse>
        	<cfset form.parametersPiped = replace(form.parameters,",","|","all")> <!--- convert the default comma delimited list to a pipe delimited list --->
			<cfset result = application.model.EmailManager.sendEmailFromTemplate(templateId=form.templateId, sendFrom=form.from, sendTo=form.to, parameterValues=form.parametersPiped) />	
	        <cfif result eq "Success">
		        <cfset message = "Test Email Sent" />
			<cfelse>
				<cfset error = result />
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfif len(message) gt 0>
	<div class="message">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfif len(error) gt 0>
	<div class="errormessage">
    	<span class="form-confirm-inline"><cfoutput>#error#</cfoutput></span>
    </div>
</cfif>

<div>
	<cfset emailTemplateTestDisplay = application.view.EmailManager.getTestEmailTemplateForm(templateId) />
	<cfoutput>#emailTemplateTestDisplay#</cfoutput>
</div>
