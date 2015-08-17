<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.Notification">
		<cfargument name="UpgradeEligibilityId" type="numeric" default="0" required="false" />
		<cfargument name="Email" type="numeric" default="0" required="false" />
		<cfargument name="SignUpDateTime" type="string" default="" required="false" />
		<cfargument name="EligibilityDate" type="string" default="" required="false" />
		<cfargument name="EligibleMdn" type="string" default="" required="false" />
		<cfargument name="CarrierId" type="numeric" default="0" required="false" />
		<cfargument name="SentDateTime" type="string" default="" required="false" />

		<cfscript>
			variables.instance = {};
			
			setUpgradeEligibilityId( arguments.UpgradeEligibilityId );
			setEmail( arguments.Email );
			setSignUpDateTime( arguments.SignUpDateTime );
			setEligibleMdn( arguments.EligibleMdn );
			setEligibilityDate( arguments.EligibilityDate );
			setCarrierId( arguments.CarrierId );
			setSentDateTime( arguments.SentDateTime );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setUpgradeEligibilityId" output="false" access="public" returntype="void">
		<cfargument name="UpgradeEligibilityId" type="numeric" default="0" required="false" />
		<cfset variables.instance.UpgradeEligibilityId = arguments.UpgradeEligibilityId />
	</cffunction>
	<cffunction name="getUpgradeEligibilityId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.UpgradeEligibilityId />
	</cffunction>

	<cffunction name="setEmail" output="false" access="public" returntype="void">
		<cfargument name="Email" type="string" default="0" required="false" />
		<cfset variables.instance.Email = arguments.Email />
	</cffunction>
	<cffunction name="getEmail" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Email />
	</cffunction>
	
	<cffunction name="setSignUpDateTime" output="false" access="public" returntype="void">
		<cfargument name="SignUpDateTime" type="string" default="0" required="false" />
		<cfset variables.instance.SignUpDateTime = arguments.SignUpDateTime />
	</cffunction>
	<cffunction name="getSignUpDateTime" output="false" access="public" returntype="string">
		<cfreturn variables.instance.SignUpDateTime />
	</cffunction>

	<cffunction name="setEligibleMdn" output="false" access="public" returntype="void">
		<cfargument name="EligibleMdn" type="string" default="0" required="false" />
		<cfset variables.instance.EligibleMdn = arguments.EligibleMdn />
	</cffunction>
	<cffunction name="getEligibleMdn" output="false" access="public" returntype="string">
		<cfreturn variables.instance.EligibleMdn />
	</cffunction>

	<cffunction name="setEligibilityDate" output="false" access="public" returntype="void">
		<cfargument name="EligibilityDate" type="string" default="0" required="false" />
		<cfset variables.instance.EligibilityDate = arguments.EligibilityDate />
	</cffunction>
	<cffunction name="getEligibilityDate" output="false" access="public" returntype="string">
		<cfreturn variables.instance.EligibilityDate />
	</cffunction>

	<cffunction name="setCarrierId" output="false" access="public" returntype="void">
		<cfargument name="CarrierId" type="numeric" default="true" required="false" />
		<cfset variables.instance.CarrierId = arguments.CarrierId />
	</cffunction>
	<cffunction name="getCarrierId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.CarrierId />
	</cffunction>

	<cffunction name="setSentDateTime" output="false" access="public" returntype="void">
		<cfargument name="SentDateTime" type="string" default="" required="false" />
		<cfset variables.instance.SentDateTime = arguments.SentDateTime />
	</cffunction>
	<cffunction name="getSentDateTime" output="false" access="public" returntype="string">
		<cfreturn variables.instance.SentDateTime />
	</cffunction>

	<cffunction name="save" output="false" access="public" returntype="void">
		<cfset var result = '' />
		
		<cfif !Trim(getUpgradeEligibilityId())>
			<cfquery datasource="#application.dsn.wirelessAdvocates#" result="result">
				INSERT INTO notification.UpgradeEligibility
				(
					Email
					, SignUpDateTime
					, EligibleMdn
					, EligibilityDate
					, CarrierId
					, SentDateTime
				)
				VALUES
				(
					<cfqueryparam value="#Trim( getEmail() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getEmail()))#" />
					, <cfqueryparam value="#Trim( getSignUpDateTime() )#" cfsqltype="cf_sql_timestamp" null="#!len(trim(getSignUpDateTime()))#" />
					, <cfqueryparam value="#Trim( getEligibleMdn() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getEligibleMdn()))#" />
					, <cfqueryparam value="#Trim( getEligibilityDate() )#" cfsqltype="cf_sql_date" null="#!len(trim(getEligibilityDate()))#" />
					, <cfqueryparam value="#Trim( getCarrierId() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getCarrierId()))#" />
					, <cfqueryparam value="#Trim( getSentDateTime() )#" cfsqltype="cf_sql_timestamp" null="#!len(trim(getSentDateTime()))#" />
				)
			</cfquery>
			
			<cfset setUpgradeEligibilityId( result.IdentityCol ) />
		<cfelse>
			<cfquery datasource="#application.dsn.wirelessAdvocates#">
				UPDATE notification.UpgradeEligibility
				SET	Email = <cfqueryparam value="#Trim( getEmail() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getEmail()))#" />
					, SignUpDateTime = <cfqueryparam value="#Trim( getSignUpDateTime() )#" cfsqltype="cf_sql_timestamp" null="#!len(trim(getSignUpDateTime()))#" />
					, EligibleMdn = <cfqueryparam value="#Trim( getEligibleMdn() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getEligibleMdn()))#" />
					, EligibilityDate = <cfqueryparam value="#Trim( getEligibilityDate() )#" cfsqltype="cf_sql_date" null="#!len(trim(getEligibilityDate()))#" />
					, CarrierId = <cfqueryparam value="#Trim( getCarrierId() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getCarrierId()))#" />
					, SentDateTime = <cfqueryparam value="#Trim( getSentDateTime() )#" cfsqltype="cf_sql_timestamp" null="#!len(trim(getSentDateTime()))#" />
				WHERE UpgradeEligibilityId = <cfqueryparam value="#Trim( getUpgradeEligibilityId() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getUpgradeEligibilityId()))#" />
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="load" output="false" access="public" returntype="void">
		<cfargument name="UpgradeEligibilityId" type="numeric" required="true" />
		<cfset var qNotification = '' />

		<cfquery name="qNotification" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				UpgradeEligibilityId
				, Email
				, EligibleMdn
				, SignUpDateTime
				, EligibilityDate
				, CarrierId
				, SentDateTime
			FROM notification.UpgradeEligibility
			WHERE UpgradeEligibilityId = <cfqueryparam value="#arguments.UpgradeEligibilityId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfscript>
			if (qNotification.recordCount)
			{
				setUpgradeEligibilityId( qNotification.UpgradeEligibilityId );
				setEmail( qNotification.Email );
				setSignUpDateTime( qNotification.SignUpDateTime );
				setEligibleMdn( qNotification.EligibleMdn );
				setEligibilityDate( qNotification.EligibilityDate );
				setCarrierId( qNotification.CarrierId );
				setSentDateTime( qNotification.SentDateTime );
			}
		</cfscript>

	</cffunction>


	<cffunction name="getEligibleUpgrades" output="false" access="public" returntype="void">
		<cfargument name="UpgradeEligibilityId" type="numeric" required="true" />
		<cfset var qNotifications = '' />

		<cfquery name="qNotifications" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				UpgradeEligibilityId
				, Email
				, EligibleMdn
				, SignUpDateTime
				, EligibilityDate
				, CarrierId
				, SentDateTime
			FROM notification.UpgradeEligibility
			WHERE UpgradeEligibilityId = <cfqueryparam value="#arguments.UpgradeEligibilityId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn qNotifications />
	</cffunction>

	<cffunction name="getEligibleUpgradesComingUp" output="false" access="public" returntype="query">
		<cfargument name="notificationDays" type="numeric" required="true" />
		
		<cfset var qNotifications = '' />

		<cfquery name="qNotifications" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				UpgradeEligibilityId
				, Email
				, EligibleMdn
				, SignUpDateTime
				, EligibilityDate
				, CarrierId
				, SentDateTime
			FROM notification.UpgradeEligibility
			WHERE EligibilityDate <= DateAdd(day, <cfqueryparam value="#arguments.notificationDays#" cfsqltype="cf_sql_integer" />, getdate()) AND 
				SentDateTime IS NULL
		</cfquery>

		<cfreturn qNotifications />
	</cffunction>

	<cffunction name="getEligibleMdnFormatted" output="false" access="public" returntype="string">
		<cfset var cleanMdn = REReplace(variables.instance.EligibleMdn, "[^0-9A-Za-z ]", "", "all")  />
		<cfset var area = Left(cleanMdn, 3) />
		<cfset var prefix = Mid(cleanMdn, 4, 3) />
		<cfset var lastFour = Right(cleanMdn, 4) />
		<cfset var formattedMdn = "(" & area &") "& prefix &"-"& lastFour />
		
		<cfreturn formattedMdn />
	</cffunction>
	
	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>