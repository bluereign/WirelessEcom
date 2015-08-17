<cfcomponent extends="fw.model.BaseGateway" output="false">
	
	<!----------------- Constructor ---------------------->    
    	    
    <cffunction name="init" access="public" output="false" returntype="UserGateway">    
    	<cfreturn this>    
    </cffunction>    
    
    <!-------------------- Public ------------------------>
		
	<!--- BEGIN || CRUD --->
	<cffunction name="createUser" access="package" output="false" returntype="numeric" hint="Creates a user.">    
    	<cfargument name="username" type="string" default="">
		<cfargument name="password" type="string" default="">
		
		<cfset var qUser = "">

		<cftransaction>
			<cflock name="lock_createUser" type="exclusive" timeout="10">
				<cfquery name="qUser" datasource="#variables.dsn#">
					INSERT INTO Users (
						username,
                        email,
						password,
						TimeCreated,
						TIMELASTAUTHENTICATED
					) VALUES (
						<cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#ARGUMENTS.password#" cfsqltype="cf_sql_varchar">,
						getdate(),
						getdate()
					)
					SELECT SCOPE_IDENTITY() AS UserID
				</cfquery>
			</cflock>
		</cftransaction>
		
		<cfreturn qUser.UserID>
    </cffunction>
    
    <cffunction name="saveUser" access="public" returntype="void" output="false">
		<cfargument name="User" type="fw.model.user.User" required="true">

		<cfquery datasource="#variables.dsn#">
			UPDATE Users SET
				username = <cfqueryparam value="#arguments.User.getEmail()#" cfsqltype="cf_sql_varchar"/>
                ,Email = <cfqueryparam value="#arguments.User.getEmail()#" cfsqltype="cf_sql_varchar"/>
				,firstname = <cfqueryparam value="#arguments.User.getBillingAddress().getFirstName()#" cfsqltype="cf_sql_varchar" />
				,middleinitial = <cfqueryparam value="#arguments.User.getBillingAddress().getMiddleInitial()#" cfsqltype="cf_sql_varchar" />
				,lastname = <cfqueryparam value="#arguments.User.getBillingAddress().getLastName()#" cfsqltype="cf_sql_varchar" />
				,company = <cfqueryparam value="#arguments.User.getBillingAddress().getCompany()#" cfsqltype="cf_sql_varchar" />
				,address1 = <cfqueryparam value="#arguments.User.getBillingAddress().getAddressLine1()#" cfsqltype="cf_sql_varchar" />
				,address2 = <cfqueryparam value="#arguments.User.getBillingAddress().getAddressLine2()#" cfsqltype="cf_sql_varchar" />
				,city = <cfqueryparam value="#arguments.User.getBillingAddress().getCity()#" cfsqltype="cf_sql_varchar" />
				,state = <cfqueryparam value="#arguments.User.getBillingAddress().getState()#" cfsqltype="cf_sql_varchar" />
				,zip = <cfqueryparam value="#arguments.User.getBillingAddress().getZipCode()#" cfsqltype="cf_sql_varchar" />
				,homephone = <cfqueryparam value="#arguments.User.getBillingAddress().getEvePhone()#" cfsqltype="cf_sql_varchar" />
				,workphone = <cfqueryparam value="#arguments.User.getBillingAddress().getDayPhone()#" cfsqltype="cf_sql_varchar" />
				,shipfirstname = <cfqueryparam value="#arguments.User.getShippingAddress().getFirstName()#" cfsqltype="cf_sql_varchar" />
				,shipmiddleinitial = <cfqueryparam value="#arguments.User.getShippingAddress().getMiddleInitial()#" cfsqltype="cf_sql_varchar" />
				,shiplastname = <cfqueryparam value="#arguments.User.getShippingAddress().getLastName()#" cfsqltype="cf_sql_varchar" />
				,shipcompany = <cfqueryparam value="#arguments.User.getShippingAddress().getCompany()#" cfsqltype="cf_sql_varchar" />
				,shipaddress1 = <cfqueryparam value="#arguments.User.getShippingAddress().getAddressLine1()#" cfsqltype="cf_sql_varchar" />
				,shipaddress2 = <cfqueryparam value="#arguments.User.getShippingAddress().getAddressLine2()#" cfsqltype="cf_sql_varchar" />
				,shipcity = <cfqueryparam value="#arguments.User.getShippingAddress().getCity()#" cfsqltype="cf_sql_varchar" />
				,shipstate = <cfqueryparam value="#arguments.User.getShippingAddress().getState()#" cfsqltype="cf_sql_varchar" />
				,shipzip = <cfqueryparam value="#arguments.User.getShippingAddress().getZipCode()#" cfsqltype="cf_sql_varchar" />
				,shipphone = <cfqueryparam value="#arguments.User.getShippingAddress().getDayPhone()#" cfsqltype="cf_sql_varchar" />
				,shipfax = <cfqueryparam value="#arguments.User.getShippingAddress().getEvePhone()#" cfsqltype="cf_sql_varchar" />
				,shipBase =	<cfif len(trim(arguments.User.getShippingAddress().getMilitaryBase()))>
								<cfqueryparam value="#arguments.User.getShippingAddress().getMilitaryBase()#" cfsqltype="cf_sql_varchar" />
							<cfelse>
								NULL
							</cfif>
				,militaryBase =	<cfif len(trim(arguments.User.getBillingAddress().getMilitaryBase()))>
									<cfqueryparam value="#arguments.User.getBillingAddress().getMilitaryBase()#" cfsqltype="cf_sql_varchar" />
								<cfelse>
									NULL
								</cfif>
				,authenticationID = <cfif len(trim(arguments.User.getAuthenticationid()))>
										<cfqueryparam value="#arguments.User.getAuthenticationID()#" cfsqltype="cf_sql_varchar" />
									<cfelse>
										NULL
									</cfif>

				WHERE user_id = <cfqueryparam value="#arguments.User.getUserId()#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
	</cffunction>
	
    <cffunction name="saveAuthenticationId" access="public" returntype="void" output="false">
		<cfargument name="User" type="fw.model.user.User" required="true">

		<cfquery datasource="#variables.dsn#">
			UPDATE Users SET
				authenticationID = <cfif len(trim(arguments.User.getAuthenticationid()))>
										<cfqueryparam value="#arguments.User.getAuthenticationID()#" cfsqltype="cf_sql_varchar" />
									<cfelse>
										NULL
									</cfif>

				WHERE user_id = <cfqueryparam value="#arguments.User.getUserId()#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
	</cffunction>
    
    <cffunction name="getUser" access="public" returntype="query" output="false">
		<cfargument name="userID" type="numeric" />
		<cfargument name="email" type="string" />
		<cfargument name="password" type="string" />

		<cfset var qUser = "">

		<cfquery name="qUser" datasource="#variables.dsn#">			
			SELECT	u.[User_ID], u.[st], u.[st2], u.[st3], u.[SID], u.[UserName], u.[Password], u.[TimeLastSessionBegan],
					u.[TimePreviousSessionBegan], u.[TimeLastAuthenticated], u.[VisitingObject_ID], u.[IP], u.[Host],
					u.[Browser], u.[HttpFrom], u.[FirstName], u.[MiddleInitial], u.[LastName], u.[Company], u.[Title],
					u.[Address1], u.[Address2], u.[City], u.[ZIP], u.[State], u.[Country], u.[YEARS_AT_ADDR], u.[MONTHS_AT_ADDr],
					u.[Email], u.[HomePhone], u.[WorkPhone], u.[Gender], u.[DateCreated], u.[ShipFirstName], u.[ShipMiddleInitial],
					u.[ShipLastName], u.[ShipCompany], u.[ShipAddress1], u.[ShipAddress2], u.[ShipCity], u.[ShipState],
					u.[ShipCountry], u.[ShipZip], u.[ShipPhone], u.[ShipFax], u.[SelectedPaymentMethod], u.[AF_ID], u.[AF_COUNT],
					u.[st_id], u.[restrictiongroup_id], u.[lang_id], u.[country_id], u.[Shoppernumber], u.[exported], u.[SSN],
					u.[CarId], u.[receive_email], u.[receive_newsletter], u.[CarYear], u.[CUST_CD], u.[TimeCreated], u.[wddxCart],
					u.[shipBase],u.[militaryBase],u.[authenticationId]
			FROM	dbo.Users AS u WITH (NOLOCK)
			WHERE	1=1 
				<cfif structKeyExists(arguments, "userID")>
					AND u.[user_id] = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
				</cfif>
				<cfif structKeyExists(arguments, "email")>
					AND u.[email] = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
				</cfif>
				<cfif structKeyExists(arguments, "password")>
					AND u.[password] = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar" />
				</cfif>
		</cfquery>
		
		<cfreturn qUser>
	
	</cffunction>
	
	<!--- END || CRUD --->
	
	<!--- BEGIN ||  Order Assistance --->
		
	<cffunction name="getOrderAssistanceStatus" output="false" access="public" returntype="query">
		<cfargument name="userId" required="true" type="numeric" />
		<cfset var qUser = "">

		<cfquery name="qUser" datasource="#variables.dsn#">
			SELECT IsOrderAssistanceOn
			FROM Users WITH (NOLOCK)
			WHERE User_Id = <cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn qUser />
	</cffunction>
	
	<!--- END ||  Order Assistance --->
		
	<!--- BEGIN ||  Banned Users --->
		
	<cffunction name="getBannedUser" access="public" output="false" returntype="query" hint="Checks if user is banned.">    
    	<cfargument name="IP" required="false" type="string" default="" />
		<cfargument name="address1" required="false" type="string" default="" />
		<cfargument name="city" required="false" type="string" default="" />
		<cfargument name="state" required="false" type="string" default="" />
		
		<cfset var qBannedUser = "">
		
		<cfquery name="qBannedUser" datasource="#variables.dsn#">
			SELECT bu.BannedUserId
			FROM websecurity.bannedUsers AS bu WITH (NOLOCK)
			WHERE
				address1 = <cfqueryparam value="#trim(arguments.address1)#" cfsqltype="cf_sql_varchar">
				AND	city = <cfqueryparam value="#trim(arguments.city)#" cfsqltype="cf_sql_varchar">
				AND	state = <cfqueryparam value="#trim(arguments.state)#" cfsqltype="cf_sql_varchar">
			<cfif len(trim(arguments.ip))>
				AND	ip = <cfqueryparam value="#trim(arguments.ip)#" cfsqltype="cf_sql_varchar">
			</cfif>
		</cfquery>
		
		<cfreturn qBannedUser>
    </cffunction>
    
    <cffunction name="createBannedUser" access="public" output="false" returntype="void" hint="Creates banned user.">    
    	<cfargument name="IP" required="false" type="string" default="" />
		<cfargument name="firstName" required="false" type="string" default="" />
		<cfargument name="lastName" required="false" type="string" default="" />
		<cfargument name="address1" required="false" type="string" default="" />
		<cfargument name="address2" required="false" type="string" default="" />
		<cfargument name="city" required="false" type="string" default="" />
		<cfargument name="state" required="false" type="string" default="" />
		<cfargument name="zip" required="false" type="string" default="" />
		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO websecurity.BannedUsers
			(
				IP 
				, FirstName
				, LastName
				, Address1
				, Address2
				, City
				, State
				, Zip
			)
			VALUES
			(
				<cfqueryparam value="#arguments.IP#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.IP) )#" />
				, <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.firstName) )#" />
				, <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.lastName) )#" />
				, <cfqueryparam value="#arguments.address1#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.address1) )#" />
				, <cfqueryparam value="#arguments.address2#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.address2) )#" />
				, <cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.city) )#" />
				, <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.state) )#" />
				, <cfqueryparam value="#arguments.zip#" cfsqltype="cf_sql_varchar" null="#NOT len( trim(arguments.zip) )#" />
			)
		</cfquery>
		
    </cffunction>
    
    <cffunction name="getBannedUsers" output="false" access="public" returntype="query">
		<cfset var qUsers = ''>
		
		<cfquery name="qUsers" datasource="#variables.dsn#">
			SELECT 
				u.BannedUserId
				, u.IP
				, u.FirstName
				, u.LastName
				, u.Address1
				, u.Address2
				, u.City
				, u.State
				, u.Zip 
			FROM websecurity.BannedUsers u WITH (NOLOCK)
		</cfquery>
		
		<cfreturn qUsers>
	</cffunction>
	
	<cffunction name="deleteBannedUser" output="false" access="public" returntype="void">
		<cfargument name="bannedUserId" type="string" required="true" />
		
		<cfquery datasource="#variables.dsn#">
			DELETE FROM websecurity.BannedUsers
			WHERE BannedUserId = <cfqueryparam value="#arguments.bannedUserId#" cfsqltype="cf_sql_integer">
		</cfquery>
		
	</cffunction>
		
	<!--- END ||  Banned Users --->
		
</cfcomponent>