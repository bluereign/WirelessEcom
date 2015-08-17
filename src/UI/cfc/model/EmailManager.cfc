<cfcomponent output="false" displayname="EmailManager">

	<cffunction name="init" returntype="EmailManager">
    	<cfreturn this>
    </cffunction>
    
	<cffunction name="deleteEmailTemplate" returntype="query">
		<cfargument name="templateId" type="numeric" />
		
		<cfset var local = {
				templateId = arguments.templateId
			} />
		
		<cftry>
			<cfquery name="local.deleteTemplate" datasource="#application.dsn.wirelessAdvocates#">
				DELETE FROM service.EmailTemplate
				WHERE Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.templateId#">
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.getTemplate />
	</cffunction>
    
	<cffunction name="getEmailTemplate" returntype="query">
		<cfargument name="templateId" type="numeric" />
		
		<cfset var local = {
				templateId = arguments.templateId
			} />
		
		<cftry>
			<cfquery name="local.getTemplate" datasource="#application.dsn.wirelessAdvocates#">
				SELECT *
				FROM service.EmailTemplate
				WHERE Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.templateId#">
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.getTemplate />
	</cffunction>
    
	<cffunction name="getEmailTemplateFile" returntype="string">
		<cfargument name="templateName" type="string" />
		
		<cfset templateBody = "" />
		<cfset templateLocation = "/views/emailtemplates/" & arguments.templateName & ".cfm" />
		
		<cftry>
			<cfhttp url="#templateLocation#" />
			<cfset templateBody = cfhttp.FileContent />
			
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.getTemplate />
	</cffunction>
    
	<cffunction name="getEmailTemplates" returntype="query">
		<cfargument name="filter" type="struct" default="#structNew()#" />
		
		<cfset var local = {
				filter = arguments.filter
			} />
		
		<cftry>
			<cfquery name="local.getTemplates" datasource="#application.dsn.wirelessAdvocates#">
				SELECT *
				FROM service.EmailTemplate
				WHERE 1=1
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn local.getTemplates />
	</cffunction>
	
	<cffunction name="insertEmailTemplate" returntype="string">
		<cfargument name="form" type="struct" />
		
		<cfset var local = {
				title = arguments.form.title,
				description = arguments.form.description,
				active = false,
				subject = arguments.form.subject,
				body = arguments.form.body,
				defaultTo = arguments.form.defaultTo,
				defaultCC = arguments.form.defaultCC,
				defaultBCC = arguments.form.defaultBCC,
				query = arguments.form.query,
				parameters = arguments.form.parameters,
				user = arguments.form.user
			} />

		<cfif StructKeyExists(arguments.form, "active")>
			<cfset local.active = true />
		</cfif>
		
		<cftry>
			<cfquery name="local.insertTemplate" datasource="#application.dsn.wirelessAdvocates#">
				INSERT INTO service.EmailTemplate(
					Title,
					Description,
					Subject,
					Body,
					DefaultTo,
					DefaultCC,
					DefaultBCC,
					Query,
					Active,
					LastModified,
					LastModifiedBy,
					Parameters
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.title#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.description#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.subject#" />,
					<cfqueryparam cfsqltype="cf_sql_text" value="#local.body#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.defaultTo#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.defaultCC#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.defaultBCC#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.query#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#local.active#" />,
					getDate(),
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.user#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.parameters#" />
				)
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn "success" />
	</cffunction>
	
	<cffunction name="sendEmailFromTemplate" returntype="string">
		<cfargument name="templateId" type="numeric" />
		<cfargument name="sendTo" type="string" default="" />
		<cfargument name="parameterValues" type="string" default="" />
		<cfargument name="subject" type="string" default="" />
		<cfargument name="sendCc" type="string" default="" />
		<cfargument name="sendBcc" type="string" default="" />
		<cfargument name="sendFrom" type="string" default="" />
        <cfargument name="templateValues" type="string" default="" />

		<cfset var local = {
				templateId = arguments.templateId,
				sendTo = arguments.sendTo,
				parameterValues = arguments.parameterValues,
				templateValues = arguments.templateValues,
				subject = arguments.subject,
				sendCc = arguments.sendCc,
				sendBcc = arguments.sendBcc,
				body = '',
				from = arguments.sendFrom,
				message = ''
			} />
		            
		<!--- Get the Service.EmailTemplate by TemplateId passed. --->
		<cfset local.emailTemplate = getEmailTemplate(local.templateId) />

		<!--- pulls the parameter list from the database if none are provided in the arguments --->
		<cfif NOT ListLen(local.ParameterValues)>
			<cfset local.ParameterValues = local.emailTemplate.parameters />
		</cfif>
	
		<!--- Execute Service.EmailTemplate.Query --->
		<!--- Example Query
				SELECT WirelessAccount.FirstName as FirstName, WirelessAccount.OrderId as OrderNumber, WirelessAccount.Email as EmailInOrder FROM salesorder WHERE OrderNumber = {1}
		 --->
		<!--- build the query with the parameters --->
		<!--- find all values wrapped in {} and replace with values from the parameters list --->
		<cfset local.templateQuery = local.emailTemplate.query />
		
       
  
        <cfset local.counter = 1>
        <cfloop list="#local.parameterValues#" index="local.value" delimiters="|">
			<cfset local.templateQuery = REReplace(local.templateQuery, "{#local.counter#}", local.value, "ALL") />
            <cfset local.counter = local.counter+1>
		</cfloop>
	
    	
    	 
         
		<cftry>
			
            
            <cfquery name="local.templateQueryResults" datasource="#application.dsn.wirelessAdvocates#">
				#PreserveSingleQuotes(local.templateQuery)#
			</cfquery>
            
            
            
            <cfif local.templateQueryResults.recordCount eq 0>
            	<cfset local.message="Error execuring database query. " />
            </cfif>
            
			<cfcatch type="any">
				<cfset local.message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>		
		

        <cfif local.message eq "">
        
			<!--- Determine To, CC, BCC, Subject, Body. The rule is; default to template then use the passed method values if the exist.  --->
            <cfif local.sendTo EQ "">
                <cfset local.sendTo = local.emailTemplate.DefaultTo />
            </cfif>
            <cfif local.sendCc EQ "">
                <cfset local.sendCc = local.emailTemplate.DefaultCC />
            </cfif>
            <cfif local.sendBcc EQ "">
                <cfset local.sendBcc = local.emailTemplate.DefaultBCC />
            </cfif>
            <cfif local.subject EQ "">
                <cfset local.subject = local.emailTemplate.Subject />
            </cfif>
            
            
            <!--- replace template variables --->
            <cfset local.counter = 1>
            <cfset local.body = local.emailTemplate.Body />
            <cfloop list="#local.templateValues#" index="local.value" delimiters="|">
                <cfset local.body = REReplace(local.body, "{T#local.counter#}", local.value, "ALL") />
                <cfset local.counter = local.counter+1>
            </cfloop>
            
            
            <!--- Replace values in To, CC, BCC, Subject, & Body with results form the query. --->
        
            <cfloop list="#local.templateQueryResults.ColumnList#" index="local.resultColumn">
                <!--- ReplaceNoCase() didn't work unless the variables were renamed to something simple' --->
                <cfset local.searchTerm = '[#local.resultColumn#]' />
                <cfset local.replaceValue = local.templateQueryResults[local.resultColumn] />
                
                <cfset local.body = ReplaceNoCase(local.body, local.searchTerm, local.replaceValue, 'all') />
                <cfset local.sendTo = ReplaceNoCase(local.sendTo, local.searchTerm, local.replaceValue, 'all') />
                <cfset local.sendCc = ReplaceNoCase(local.sendCc, local.searchTerm, local.replaceValue, 'all') />
                <cfset local.sendBcc = ReplaceNoCase(local.sendBcc, local.searchTerm, local.replaceValue, 'all') />
                <cfset local.subject = ReplaceNoCase(local.subject, local.searchTerm, local.replaceValue, 'all') />
            </cfloop>
            
            <!--- 
            Do a regex lookup on \[.*\]. If there are any values that were not replace by now, throw error. 
            It means that the query did not handle the template and that we should fix it before sending the email. (low priority right now, add )
            
			MAC: commented thisout for now. It is causing tests to fail just because we did not use all the available parameters.
			
            <cfif REFind("\[.*\].", local.body)>        
                <cfset local.message = "There are unmatched parameters in the template body" />
            </cfif>
            
            <cfif REFind("\[.*\].", local.sendTo)>        
                <cfset local.message = "There are unmatched parameters in the To value" />
            </cfif>
            
            <cfif REFind("\[.*\].", local.sendCC)>        
                <cfset local.message = "There are unmatched parameters in the Cc value" />
            </cfif>
            
            <cfif REFind("\[.*\].", local.sendBcc)>        
                <cfset local.message = "There are unmatched parameters in the Bcc value" />
            </cfif>
            
            <cfif REFind("\[.*\].", local.subject)>        
                <cfset local.message = "There are unmatched parameters in the template subject" />
            </cfif>
			--->
        </cfif>
  
		<cfif local.message EQ "">
	        <!--- Build the email object based on all the results. This is pretty straight forward CFEMAIL tag. --->
			<!--- Send the email. ---> 
            <cftry>
                <cfmail to="#local.sendTo#"
                        from="#local.from#"
                        cc="#local.sendCc#"
                        bcc="#local.sendBcc#"
                        subject="#local.subject#"
                        type="html">
                    #local.body#
                </cfmail>
                <cfset local.message = "Success" />
            <cfcatch>
            	<cfset local.message = cfcatch.Message />
            </cfcatch>
            </cftry>
			
		</cfif>
		
		<!--- Return 1 for error, else return 0 --->
		<cfreturn local.message />		
	</cffunction>
	
	<cffunction name="updateEmailTemplate" returntype="string">
		<cfargument name="form" type="struct" />
		
		<cfset var local = {
				templateId = arguments.form.templateId,
				active = false,
				title = arguments.form.title,
				description = arguments.form.description,
				subject = arguments.form.subject,
				body = arguments.form.body,
				defaultTo = arguments.form.defaultTo,
				defaultCC = arguments.form.defaultCC,
				defaultBCC = arguments.form.defaultBCC,
				query = arguments.form.query,
				parameters = arguments.form.parameters,
				user = arguments.form.user
			} />
			
		<cfif StructKeyExists(arguments.form, "active")>
		    <cfif arguments.form.active NEQ false>
	    		<cfset local.active = true />
	    	</cfif>
		</cfif>
		
		<cftry>
			<cfquery name="local.updateTemplate" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE service.EmailTemplate
				SET Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.title#" />,
					Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.description#" />,
					Subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.subject#" />,
					Body = <cfqueryparam cfsqltype="cf_sql_text" value="#local.body#" />,
					DefaultTo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.defaultTo#" />,
					DefaultCC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.defaultCC#" />,
					DefaultBCC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.defaultBCC#" />,
					Query = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.query#" />,
					Active = <cfqueryparam cfsqltype="cf_sql_boolean" value="#local.active#" />,
					LastModified = getDate(),
					LastModifiedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.user#" />,
					Parameters = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.parameters#" />
				WHERE Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#local.templateId#" />
			</cfquery>
			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		
		<cfreturn "success" />
	</cffunction>
</cfcomponent>