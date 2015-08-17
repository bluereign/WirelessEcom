<cfcomponent output="false" displayname="EmailManager">

	<cffunction name="init" returntype="EmailManager">
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="getEmailTemplateList" returntype="string">
		<cfargument name="filter" type="struct" default="#StructNew()#" />
		
    	<cfset var local = structNew()>
        <cfset local.filter = arguments.filter />
        <cfset local.dislayTitle = '' />

        <cfset local.templates = application.model.EmailManager.getEmailTemplates(local.filter) />
        
        <cfsavecontent variable="local.html">
        	<cfoutput>
				<table id="listTemplateAll" class="table-long gridview">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Active</th>
                        </tr>
                    </thead>
                    
                    <tbody>
                    	<cfloop query="local.templates">
                            <tr class="odd">
                                <td><a href="?c=865a95d0-4d3a-437b-8263-652917bd05e4&templateId=#local.templates.id#">#local.templates.Title#</a></td>
                                <td>#local.templates.Active#</td>
                            </tr>
  						</cfloop>
                    </tbody>
                </table>  
                <p>&nbsp;</p>
				<p>&nbsp;</p>
				<p>&nbsp;</p>
            </cfoutput>
        </cfsavecontent>
        
        <cfreturn local.html>
    </cffunction>

	<cffunction name="getEditEmailTemplateForm" returntype="string">
		<cfargument name="templateId" type="string" default="" />
		
		<cfset var local = {
				html = '',
				templateId = arguments.templateId,
				active = false,
				title = '',
				description = '',
				subject = '',
				body = '',
				defaultTo = '',
				defaultCC = '',
				defaultBCC = '',
				query = '',
				parameters = '',
				lastModified = '',
				lastModifiedBy = ''
			} />

		<cfif local.templateId NEQ "">
			<!--- set display --->
			<cfset local.templateDetails = application.model.EmailManager.getEmailTemplate(local.templateId) />
			<cfset local.active = local.templateDetails.active />
			<cfset local.title = local.templateDetails.title />
			<cfset local.description = local.templateDetails.description />
			<cfset local.subject = local.templateDetails.subject />
			<cfset local.body = local.templateDetails.body />
			<cfset local.defaultTo = local.templateDetails.defaultTo />
			<cfset local.defaultCC = local.templateDetails.defaultCC />
			<cfset local.defaultBCC = local.templateDetails.defaultBCC />
		    <cfset local.query = local.templateDetails.query />
		    <cfset local.parameters = local.templateDetails.parameters />
		    <cfset local.lastModified = local.templateDetails.lastModified />
		    <cfset local.lastModifiedBy = local.templateDetails.lastModifiedBy />
		</cfif>	
	
		<cfsavecontent variable="local.html">
		    <form  method="post" name="updateEmailTemplate" class="middle-forms">
			    <cfif local.templateId NEQ "">
			    	<a href="javascript: show('action=showTestEmailTemplateForm');" class="button" title="Test this email template"><span>Test this Template</span></a>
				</cfif>
		        <fieldset>
		            <legend>Fieldset Title</legend>
		            <ol>
		                <li class="odd">
		                    <label class="field-title" title="Check the box to make this email template active">Availability: </label> 
		                    <label> 
		                        <input type="checkbox" name="active" <cfif local.active eq true>checked="checked"</cfif> id="check_one" />
		                        Available Online 
		                    </label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="even">
		                    <label class="field-title" title="The title of the template">Title:</label>
		                    <label><input name="title" class="txtbox-long" value="<cfoutput>#local.title#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="The description of the template">Description:</label> 
		                    <label><input name="description" class="txtbox-long" value="<cfoutput>#local.description#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="The subject line of the email">Subject:</label> 
		                    <label><input name="subject" class="txtbox-long" value="<cfoutput>#local.subject#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="The body of the email">Body:</label> 
		                    <label>
		                        <textarea class="wysiwyg" name="body" rows="7"><cfoutput>#local.body#</cfoutput></textarea>
		                    </label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="The default value of the 'to' field">Default To:</label> 
		                    <label><input name="defaultTo" class="txtbox-long" value="<cfoutput>#local.defaultTo#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li onkeydown=""class="even">
		                <li class="odd">
		                    <label class="field-title" title="The CC value of the to field">Default CC:</label> 
		                    <label><input name="defaultCC" class="txtbox-long" value="<cfoutput>#local.defaultCC#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li onkeydown=""class="even">
		                <li class="even">
		                    <label class="field-title" title="The BCC value of the to field">Default BCC:</label> 
		                    <label><input name="defaultBCC" class="txtbox-long" value="<cfoutput>#local.defaultBCC#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li onkeydown=""class="odd">
		                    <label class="field-title" title="The query used to populate parameters in the email template">Query: </label> 
		                    <label>
		                        <textarea id="" name="query" rows="7"><cfoutput>#local.query#</cfoutput></textarea>
		                    </label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>	 
                         <li class="odd">
		                    <label class="field-title" title="The CC value of the to field">Parameters:</label> 
		                    <label><input name="parameters" class="txtbox-long" value="<cfoutput>#local.parameters#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>

                        
		            </ol><!-- end of form elements -->
		        </fieldset>
		     	<input type="hidden" name="templateId" value="<cfoutput>#local.templateId#</cfoutput>" />
		     	<input type="hidden" name="user" value="Scott" />
		     	<input type="hidden" name="action" value="updateEmailTemplate" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save changes made to this email template"><span>Save</span></a> <a href="javascript: show('action=cancelEmailTemplateEdit');" class="button" title="Cancel changes made to this email template"><span>Cancel</span></a>
		    </form>
		</cfsavecontent>
	
		<cfreturn local.html />
	</cffunction>    

	<cffunction name="getTestEmailTemplateForm" returntype="string">
		<cfargument name="templateId" type="string" />
				
		<cfset var local = {
				html = '',
				templateId = arguments.templateId
			} />
		
		<cfset local.emailTemplate = application.model.EmailManager.getEmailTemplate(local.templateId) />	
		<cfsavecontent variable="local.html">
			<form  method="post" name="testEmailTemplate" class="middle-forms">
				<fieldset>
			            <legend>Fieldset Title</legend>
			            <ol>
			                <li class="odd">
			                    <label class="field-title" title="Name of the template we're testing.">Template to Test: </label> 
			                    <label><cfoutput>#local.emailTemplate.title#</cfoutput></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
			                <li class="even">
			                    <label class="field-title" title="Email address of where you want to send the test email. Usually, this address should be yours.">To: </label> 
			                    <label><input name="to" class="txtbox-long" value="<cfoutput>#local.emailTemplate.defaultTo#</cfoutput>" /></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
			                <li class="odd">
			                    <label class="field-title" title="Email address of where the test email will come from">From: </label> 
								<label><input name="from" class="txtbox-long" value="test@membershipwireless.com" /></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
			                <li class="even">
			                    <label class="field-title" title="The query for this email template">Query: </label> 
								<label><cfoutput>#local.emailTemplate.query#</cfoutput></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
			                
                            
                            <!--- build parameters list --->
                            <cfset local.query = local.emailTemplate.query>
                            <cfset local.pos = 1>
                            <cfset local.i = 1>
                            <cfset parameterCounter = 0>
                            <cfloop condition="local.pos lt len(local.query) and local.i lt 30">
                            	<cfset local.occurs = refind("{[0-9]}",local.query,local.pos,"true")>
                                
                                <cfset local.pos = local.occurs.pos[1] + local.occurs.len[1]>
								<cfset local.i = local.i + 1>
                                <cfset parameterCounter = parameterCounter + 1>
                            </cfloop>
                            
                            <cfif parameterCounter gt 0>
                                <li class="even">
                                    <label class="field-title" title="List the values for the parameters used in the query above. Separate each value with |.">Parameters: </label> 
                                    <span class="clearFix">&nbsp;</span>
                                </li>
                                <cfloop from="1" to="#parameterCounter#" index="i">
                                    <cfoutput>
                                    <li class="even">
                                        <label class="field-title" title="Enter the value for the parameter:">{#i#} : </label> 
                                        <label><input name="parameters" class="txtbox-short" value="" /></label>
                                        <span class="clearFix">&nbsp;</span>
                                    </li>
                                    </cfoutput>
                                </cfloop>
                            </cfif>
                            <!--- end building paramters --->
			            </ol><!-- end of form elements -->
			        </fieldset>
			     	<input type="hidden" name="templateid" value="<cfoutput>#local.templateId#</cfoutput>" />
			     	<input type="hidden" name="action" value="testEmailTemplate" />
					<a href="javascript: void();" onclick="postForm(this);" class="button" title="Test this email template"><span>Send Test Message</span></a> <a href="javascript: show('action=cancelEmailTemplateTest');" class="button" title="Cancel the test of sending this email teamplate"><span>Cancel</span></a>
			    </form>
		    </cfsavecontent>			
		<cfreturn local.html />		
	</cffunction>


	<cffunction name="getOrderCancellationAlertTemplate" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="user" type="struct" required="true" />
		<cfargument name="cancellationReason" type="string" required="true" />
		<cfargument name="requestDate" type="date" default="#Now()#" required="false" />
		
		<cfset var templateAsHtml = "" />
		<cfset var payments = arguments.order.getPayments() />
		<cfset var authorizationNumber = "" />
		
		<!--- Get authorization number from last payment --->
		<cfif ArrayLen( payments )>
			<cfset authorizationNumber = payments[ArrayLen( payments )].getCreditCardAuthorizationNumber() />
		</cfif>
		
		<cfsavecontent variable="templateAsHtml">
			<cfoutput>
				<p>
				Request Date: #DateFormat( arguments.requestDate, "mm/dd/yyyy" )#<br />
				Online Sales Order Number: #arguments.order.getOrderId()#<br />
				Customer Name: #arguments.order.getBillAddress().getFirstName()# #arguments.order.getBillAddress().getLastName()#<br />
				Customer Number: #application.model.util.convertToGersId( arguments.order.getUserId() )#<br />
				Credit Card Authorization Number: #authorizationNumber#<br />
				Tax Transaction ID: #arguments.order.getSalesTaxTransactionId()#<br />

				</p>
				<p>Action required for:</p>
				<p>
				<!--- Cannot cancel an order unless the status 'Payment Complete' or 'Closed'--->
				__X__ Credit Card was charged <br/> 
				<!--- Cannot cancel when status is 'closed' and shipped --->
				__X__ Order not shipped <br/>
				<!--- Phones are fully activated when status is Success or Manual --->
				<cfif arguments.order.getWirelessAccount().getActivationStatus() NEQ 6 AND arguments.order.getWirelessAccount().getActivationStatus() NEQ 6>
					__X__ Phone never activated - order never downloaded to GERS <br/>
				<cfelse>
					_____ Phone never activated - order never downloaded to GERS <br/>
				</cfif>
				<!--- Tax transaction is refunded when a refund transaction --->
				<cfif arguments.order.getIsSalesTaxTransactionCommited()>
					<cfif Len( arguments.order.getSalesTaxRefundTransactionId() )>
						__X__ Tax Transaction Refunded at Exactor <br/>
					<cfelse>
						_____ Tax Transaction Refunded at Exactor <br/>
					</cfif>
				<cfelse>
					_N/A_ Tax Transaction Refunded at Exactor <br/>
				</cfif>
				</p>
				<p>This Online Order is cancelled and the payment needs to be returned to the customer.
				Return credit transaction listed above.</p>
				<p>Reason for cancelling sale: #arguments.cancellationReason#</p>
				<p>
				Requested by: #arguments.user.FirstName# #arguments.user.LastName# (#user.UserName#)<br />
				Authorized by: ______________________ <br />
				Refund Processed by: ______________________ <br />
				Date Completed: ______________________ <br />
				</p>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn templateAsHtml />
    </cffunction>





</cfcomponent>