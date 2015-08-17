<cfcomponent output="false" extends="fw.model.BaseService">
	
	<cfproperty name="NotificationGateway" inject="id:NotificationGateway" />
	<cfproperty name="MailService" inject="coldbox:plugin:MailService" />
	
	<!----------------- Constructor ---------------------->
    	    
    <cffunction name="init" access="public" output="false" returntype="NotificationService">    
    	<cfscript>
    		return this;
    	</cfscript>
    </cffunction>

    <!-------------------- Public ------------------------>
	
	<cffunction name="signupCustomer" output="false" access="public" returntype="boolean" >
    	<cfargument name="Email" type="string" default="" />
		<cfargument name="SignUpDateTime" type="string" default="" />
		<cfargument name="CampaignId" type="string" default="" />

		<cfscript>
			var qCustomer = NotificationGateway.getCustomerByEmail(arguments.Email);
			var qCustomerCampaign = '';
			var customerId = 0;
			var isRecordAdded = true;
			
			//Check for existing customer email
			if (qCustomer.RecordCount)
			{
				//Check if email is already signed up for campaign
				qCustomerCampaign  = NotificationGateway.getCustomerMarketingCampaign(qCustomer.customerId, arguments.CampaignId);
				
				if (qCustomerCampaign.RecordCount)
					isRecordAdded = false;
				else
					NotificationGateway.createCustomerMarketingCampaign(qCustomer.customerId, arguments.CampaignId);
			}
			else
			{
				customerId = NotificationGateway.createCustomer( arguments.Email, arguments.SignUpDateTime );
				NotificationGateway.createCustomerMarketingCampaign( customerId, arguments.CampaignId );
			}	
		</cfscript>
		
		<cfreturn isRecordAdded />
	</cffunction>


	<cffunction name="sendCampaignNotifications" output="false" access="public" returntype="query" >


		<cfscript>
			var qCustomerCampaigns = NotificationGateway.getEligibleCampaignEmails();
			var email = '';
			var i = 0;
			
			if ( qCustomerCampaigns.RecordCount )
			{
				for (i=1; i <= qCustomerCampaigns.RecordCount; i++)
				{
				    email = variables.MailService.newMail();
				    email.config(
						  from 		= 'no-replay@membershipwireless.com '//getSetting('sendEmailFrom')
						, to		= 'rlinmark@wirelessadvocates.com '//qCustomerCampaigns.Email[1]
					);
					
				    email.setSubject( "Hello!" );
				    email.setBody( "<p>Test email from ColdBox MailService</p>" );        
			    	//variables.MailService.send( Email );
				}
				
				//Mark emails as sent
				NotificationGateway.markCampaignAsSent( ValueList(qCustomerCampaigns.CustomerMarketingCampaignId) );
			}
		</cfscript>
		
		<cfreturn qCustomerCampaigns />
	</cffunction>  

        
</cfcomponent>