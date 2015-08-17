<cfcomponent extends="fw.model.BaseGateway" output="false">
	
	<!----------------- Constructor ---------------------->    
    	    
    <cffunction name="init" access="public" output="false" returntype="NotificationGateway">    
    	<cfscript>    
    		return this;
    	</cfscript>    
    </cffunction>    
    
    <!-------------------- Public ------------------------>

	<cffunction name="createCustomer" output="false" access="public" returntype="numeric">
    	<cfargument name="Email" type="string" required="true" />
		<cfargument name="SignUpDateTime" type="string" default="#Now()#" />
		<cfargument name="OptOutDateTime" type="string" default="" />
		<cfargument name="Active" type="boolean" default="true" />

		<cfset var qCustomer = '' />

		<cfquery result="qCustomer" datasource="#variables.dsn#">
			INSERT INTO notification.Customer
			(
				Email
				, SignUpDateTime
				, OptOutDateTime
				, Active
			)
			VALUES
			(
				<cfqueryparam value="#arguments.Email#" cfsqltype="cf_sql_varchar" null="#!Len(Trim(arguments.Email))#" />
				, <cfqueryparam value="#arguments.SignUpDateTime#" cfsqltype="cf_sql_timestamp" null="#!Len(Trim(arguments.SignUpDateTime))#" />
				, <cfqueryparam value="#arguments.OptOutDateTime#" cfsqltype="cf_sql_timestamp" null="#!Len(Trim(arguments.OptOutDateTime))#" />
				, <cfqueryparam value="#arguments.Active#" cfsqltype="cf_sql_bit" null="#!Len(Trim(arguments.Active))#" />
			)
		</cfquery>
		
		<cfreturn qCustomer.IDENTITYCOL />
    </cffunction>


	<cffunction name="createCustomerMarketingCampaign" output="false" access="public" returntype="void">
    	<cfargument name="CustomerId" type="numeric" required="true" />
		<cfargument name="MarketingCampaignId" type="numeric" required="true" />
		<cfargument name="SentDateTime" type="string" default="" />

		<cfquery datasource="#variables.dsn#">
			INSERT INTO notification.CustomerMarketingCampaign
			(
				CustomerId
				, MarketingCampaignId
				, SentDateTime
			)
			VALUES
			(
				<cfqueryparam value="#arguments.CustomerId#" cfsqltype="cf_sql_integer" null="#!Len(Trim(arguments.CustomerId))#" />
				, <cfqueryparam value="#arguments.MarketingCampaignId#" cfsqltype="cf_sql_integer" null="#!Len(Trim(arguments.MarketingCampaignId))#" />
				, <cfqueryparam value="#arguments.SentDateTime#" cfsqltype="cf_sql_timestamp" null="#!Len(Trim(arguments.SentDateTime))#" />
			)
		</cfquery>
    </cffunction>


	<cffunction name="getCustomerByEmail" output="false" access="public" returntype="query">
    	<cfargument name="Email" type="string" default="" />
		<cfset var qCustomer = '' />

		<cfquery name="qCustomer" datasource="#variables.dsn#">
			SELECT
				CustomerId
				, Email
				, SignUpDateTime
				, OptOutDateTime
				, Active
			FROM notification.Customer
			WHERE Email = <cfqueryparam value="#arguments.Email#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<cfreturn qCustomer />
    </cffunction>


	<cffunction name="getCustomerMarketingCampaign" output="false" access="public" returntype="query">
    	<cfargument name="CustomerId" type="numeric" required="true" />
		<cfargument name="MarketingCampaignId" type="numeric" required="true" />
		<cfset var qCustomer = '' />

		<cfquery name="qCustomer" datasource="#variables.dsn#">
			SELECT
				CustomerId
				, MarketingCampaignId
				, SentDateTime
			FROM notification.CustomerMarketingCampaign
			WHERE 
				CustomerId = <cfqueryparam value="#arguments.CustomerId#" cfsqltype="cf_sql_integer" />
				AND MarketingCampaignId = <cfqueryparam value="#arguments.MarketingCampaignId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn qCustomer />
    </cffunction>


	<cffunction name="getEligibleCampaignEmails" output="false" access="public" returntype="query">
		<cfset var qCustomerCampaigns = '' />

		<cfquery name="qCustomerCampaigns" datasource="#variables.dsn#">
			SELECT
				c.Email
				, c.CustomerId
				, mc.MarketingCampaignId
				, cmc.CustomerMarketingCampaignId
				, cmc.SentDateTime
				, mc.CampaignDateTime
				, mc.Name
				, *
			FROM notification.Customer c
			INNER JOIN notification.CustomerMarketingCampaign cmc ON cmc.CustomerId = c.CustomerId
			INNER JOIN notification.MarketingCampaign mc ON mc.MarketingCampaignId = cmc.MarketingCampaignId
			WHERE
				c.Active = 1
				AND SentDateTime IS NULL
				--CampaignDateTime >= GETDATE()
		</cfquery>
		
		<cfreturn qCustomerCampaigns />
    </cffunction>


	<cffunction name="markCampaignAsSent" output="false" access="public" returntype="void">
		<cfargument name="CustomerMarketingCampaignIds" type="string" required="true" />

		<cfquery datasource="#variables.dsn#">
			UPDATE notification.CustomerMarketingCampaign
			SET SentDateTime = GETDATE()
			WHERE 
				CustomerMarketingCampaignId IN ( <cfqueryparam value="#arguments.CustomerMarketingCampaignIds#" list="true" cfsqltype="cf_sql_integer" /> )
		</cfquery>
    </cffunction>


</cfcomponent>