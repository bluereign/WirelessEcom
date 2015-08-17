<cfcomponent output="false" displayname="User">

	<cffunction name="init" access="public" returntype="User" output="false">
		<cfargument name="firstName" type="string" default="" required="false" />
		<cfargument name="lastName" type="string" default="" required="false" />
		<cfargument name="linesApproved" type="numeric" default="0" required="false" />
		<cfargument name="shippingAddress" type="Address" required="false" />
		<cfargument name="billingAddress" type="Address" required="false" />

		<cfset variables.instance = structNew() />
		<cfset variables.instance.firstName = '' />
		<cfset variables.instance.lastName = '' />
		<cfset variables.instance.email = '' />
		<cfset variables.instance.linesApproved = '' />
		<cfset variables.instance.linesActive = '' />
		<cfset variables.instance.middleInitial = '' />
		<cfset variables.instance.authenticationId = '' />

		<cfreturn this />
	</cffunction>

    <cffunction name="getAuthenticationID" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["authenticationID"]/>    
    </cffunction>    
    <cffunction name="setAuthenticationID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["authenticationID"] = arguments.theVar />    
    </cffunction>
    
	<cffunction name="getUserByID" access="public" returntype="query" output="false">
		<cfargument name="user_id" type="numeric" required="true" />

		<cfset var local = structNew() />
		<cfset var qry_updateTime = '' />

		<cfquery name="local.getUser" datasource="#application.dsn.wirelessAdvocates#">
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
			WHERE	u.[user_id]	=	<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfif local.getUser.recordCount>
			<cfquery name="qry_updateTime" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE	Users
				SET		timeLastAuthenticated	=	GETDATE()
				WHERE	user_id	=	<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_numeric" />
			</cfquery>

			<cfset this.setUserId(local.getUser.User_Id) />
			<cfset this.setFirstName(trim(local.getUser.FirstName)) />
			<cfset this.setLastName(trim(local.getUser.LastName)) />
			<cfset this.setMiddleInitial(trim(local.getUser.MiddleInitial)) />
			<cfset this.setEmail(trim(local.getUser.UserName)) />
			<!---<cfset this.setAuthenticationId(trim(local.getUser.authenticationId)) />--->

			<cfset local.billingAddress = createobject('component', 'Address').init() />
			<cfset local.billingAddress.setFirstName(trim(local.getUser.FirstName)) />
			<cfset local.billingAddress.setMiddleInitial(trim(local.getUser.MiddleInitial)) />
			<cfset local.billingAddress.setLastName(trim(local.getUser.LastName)) />
			<cfset local.billingAddress.setAddressLine1(trim(local.getUser.Address1)) />
			<cfset local.billingAddress.setAddressLine2(trim(local.getUser.Address2)) />
			<cfset local.billingAddress.setAddressLine3('') />
			<cfset local.billingAddress.setCity(trim(local.getUser.City)) />
			<cfset local.billingAddress.setState(trim(local.getUser.State)) />
			<cfset local.billingAddress.setZipCode(trim(local.getUser.Zip)) />
			<cfset local.billingAddress.setZipCodeExtension('') />
			<cfset local.billingAddress.setCountry(trim(local.getUser.Country)) />
			<cfset local.billingAddress.setCompany(trim(local.getUser.Company)) />
			<cfset local.billingAddress.setName(trim(local.getUser.FirstName) & ' ' & trim(local.getUser.LastName)) />
			<cfset local.billingAddress.setDayPhone(trim(local.getUser.WorkPhone)) />
			<cfset local.billingAddress.setEvePhone(trim(local.getUser.HomePhone)) />
			<cfset local.billingAddress.setMilitaryBase(trim(local.getUser.militaryBase)) />
			<cfset this.setBillingAddress(local.billingAddress) />

			<cfset local.shippingAddress = createobject('component', 'Address').init() />
			<cfset local.shippingAddress.setFirstName(trim(local.getUser.ShipFirstName)) />
			<cfset local.shippingAddress.setMiddleInitial(trim(local.getUser.ShipMiddleInitial)) />
			<cfset local.shippingAddress.setLastName(trim(local.getUser.ShipLastName)) />
			<cfset local.shippingAddress.setAddressLine1(trim(local.getUser.ShipAddress1)) />
			<cfset local.shippingAddress.setAddressLine2(trim(local.getUser.ShipAddress2)) />
			<cfset local.shippingAddress.setAddressLine3('') />
			<cfset local.shippingAddress.setCity(trim(local.getUser.ShipCity)) />
			<cfset local.shippingAddress.setState(trim(local.getUser.ShipState)) />
			<cfset local.shippingAddress.setZipCode(trim(local.getUser.ShipZip)) />
			<cfset local.shippingAddress.setZipCodeExtension('') />
			<cfset local.shippingAddress.setCountry(trim(local.getUser.ShipCountry)) />
			<cfset local.shippingAddress.setCompany(trim(local.getUser.ShipCompany)) />
			<cfset local.shippingAddress.setName(trim(local.getUser.ShipFirstName) & ' ' & trim(local.getUser.ShipLastName)) />
			<cfset local.shippingAddress.setDayPhone(trim(local.getUser.ShipPhone)) />
			<cfset local.shippingAddress.setEvePhone(trim(local.getUser.ShipFax)) />
			<cfset local.shippingAddress.setMilitaryBase(trim(local.getUser.shipBase)) />
			<cfset this.setShippingAddress(local.shippingAddress) />
		<cfelse>
			<cfset local.user = {} />
		</cfif>

		<cfreturn local.getUser />
	</cffunction>

	<cffunction name="save" returntype="void">

        <cfset var local = structNew()>

        <cfif this.getUserId() gt 0>
        	<!--- do an update on this user record --->
            <cfquery name="local.UserSave" datasource="#application.dsn.wirelessAdvocates#">
            	UPDATE Users SET
					username = <cfqueryparam value="#this.getEmail()#" cfsqltype="cf_sql_varchar"/>
                    ,Email = <cfqueryparam value="#this.getEmail()#" cfsqltype="cf_sql_varchar"/>
					,firstname = <cfqueryparam value="#this.getBillingAddress().getFirstName()#" cfsqltype="cf_sql_varchar" />
					,middleinitial = <cfqueryparam value="#this.getBillingAddress().getMiddleInitial()#" cfsqltype="cf_sql_varchar" />
					,lastname = <cfqueryparam value="#this.getBillingAddress().getLastName()#" cfsqltype="cf_sql_varchar" />
					,company = <cfqueryparam value="#this.getBillingAddress().getCompany()#" cfsqltype="cf_sql_varchar" />
					,address1 = <cfqueryparam value="#this.getBillingAddress().getAddressLine1()#" cfsqltype="cf_sql_varchar" />
					,address2 = <cfqueryparam value="#this.getBillingAddress().getAddressLine2()#" cfsqltype="cf_sql_varchar" />
					,city = <cfqueryparam value="#this.getBillingAddress().getCity()#" cfsqltype="cf_sql_varchar" />
					,state = <cfqueryparam value="#this.getBillingAddress().getState()#" cfsqltype="cf_sql_varchar" />
					,zip = <cfqueryparam value="#this.getBillingAddress().getZipCode()#" cfsqltype="cf_sql_varchar" />
					,homephone = <cfqueryparam value="#this.getBillingAddress().getEvePhone()#" cfsqltype="cf_sql_varchar" />
					,workphone = <cfqueryparam value="#this.getBillingAddress().getDayPhone()#" cfsqltype="cf_sql_varchar" />
					,shipfirstname = <cfqueryparam value="#this.getShippingAddress().getFirstName()#" cfsqltype="cf_sql_varchar" />
					,shipmiddleinitial = <cfqueryparam value="#this.getShippingAddress().getMiddleInitial()#" cfsqltype="cf_sql_varchar" />
					,shiplastname = <cfqueryparam value="#this.getShippingAddress().getLastName()#" cfsqltype="cf_sql_varchar" />
					,shipcompany = <cfqueryparam value="#this.getShippingAddress().getCompany()#" cfsqltype="cf_sql_varchar" />
					,shipaddress1 = <cfqueryparam value="#this.getShippingAddress().getAddressLine1()#" cfsqltype="cf_sql_varchar" />
					,shipaddress2 = <cfqueryparam value="#this.getShippingAddress().getAddressLine2()#" cfsqltype="cf_sql_varchar" />
					,shipcity = <cfqueryparam value="#this.getShippingAddress().getCity()#" cfsqltype="cf_sql_varchar" />
					,shipstate = <cfqueryparam value="#this.getShippingAddress().getState()#" cfsqltype="cf_sql_varchar" />
					,shipzip = <cfqueryparam value="#this.getShippingAddress().getZipCode()#" cfsqltype="cf_sql_varchar" />
					,shipphone = <cfqueryparam value="#this.getShippingAddress().getDayPhone()#" cfsqltype="cf_sql_varchar" />
					,shipfax = <cfqueryparam value="#this.getShippingAddress().getEvePhone()#" cfsqltype="cf_sql_varchar" />
					,shipBase =	<cfif len(trim(this.getShippingAddress().getMilitaryBase()))>
									<cfqueryparam value="#this.getShippingAddress().getMilitaryBase()#" cfsqltype="cf_sql_varchar" />
								<cfelse>
									NULL
								</cfif>
					,militaryBase =	<cfif len(trim(this.getBillingAddress().getMilitaryBase()))>
										<cfqueryparam value="#this.getBillingAddress().getMilitaryBase()#" cfsqltype="cf_sql_varchar" />
									<cfelse>
										NULL
									</cfif>

					WHERE user_id = <cfqueryparam value="#this.getUserId()#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfelse>
        	<cfthrow message="Method User.Save() is not implemented for new user records. Only existing user records can be saved.">

        </cfif>



    </cffunction>

    <cffunction name="getUserByLogin" returntype="query">
		<cfargument name="username" type="String" default="">
		<cfargument name="password" type="String" default="">
		<cfset var local = structNew()>

		<cfquery name="local.getUser" datasource="#application.dsn.wirelessAdvocates#">
            SELECT [User_ID]
          	FROM Users WITH (NOLOCK)
          	WHERE username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">
          		AND password = <cfqueryparam value="#hashPassword(ARGUMENTS.password)#" cfsqltype="cf_sql_varchar">
		</cfquery>


		<cfif local.getUser.recordcount>
			<cfset getuserById(local.getUser.User_Id)>
        <cfelse>
        	<!--- no user found, return empty --->
        	<cfset local.user = {}>
		</cfif>

		<cfreturn local.getUser>
	</cffunction>
	
	<cffunction name="getUserByUserName" returntype="query">
		<cfargument name="username" type="String" default="">
		<cfset var local = structNew()>

		<cfquery name="local.getUser" datasource="#application.dsn.wirelessAdvocates#">
            SELECT [User_ID]
          	FROM Users WITH (NOLOCK)
          	WHERE username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">
 		</cfquery>


		<cfif local.getUser.recordcount>
			<cfset local.user = getuserById(local.getUser.User_Id)>
        <cfelse>
        	<!--- no user found, return empty --->
        	<cfset local.user = {}>
		</cfif>

		<cfreturn local.user>
	</cffunction>

	
	<!--- Used in the AAFES environment to bypass passwords --->
    <cffunction name="getUserByAuthenticationID" returntype="query">
		<cfargument name="AuthenticationID" type="String" default="">
		<cfset var local = structNew()>

		<cfquery name="local.getUser" datasource="#application.dsn.wirelessAdvocates#">
            SELECT [User_ID]
          	FROM Users WITH (NOLOCK)
          	WHERE authenticationID = <cfqueryparam value="#ARGUMENTS.authenticationId#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif local.getUser.recordcount>
			<cfset getuserById(local.getUser.User_Id)>
        <cfelse>
        	<!--- no user found, return empty --->
        	<cfset local.user = {}>
		</cfif>

		<cfreturn local.getUser>
	</cffunction>
	
	<cffunction name="isUserByAuthenticationID" returntype="boolean">
		<cfargument name="AuthenticationID" type="String" default="">
		<cfreturn getUserbyAuthenticationId(arguments.AuthenticationID).recordcount gt 0 />		
	</cffunction>
	
	

	<cffunction name="isEmailInUse" access="remote" returntype="boolean" output="false">
		<cfargument name="username" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.return = false />

		<cfquery name="local.tryUser" datasource="#application.dsn.wirelessAdvocates#">
			SELECT	u.user_id
			FROM	dbo.Users AS u WITH (NOLOCK)
			WHERE	u.username	=	<cfqueryparam value="#trim(arguments.username)#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfif local.tryUser.recordCount>
			<cfset local.return = true />
		</cfif>

		<cfreturn local.return />
	</cffunction>

	<cffunction name="isEmailPasswordValid" returntype="boolean" access="remote">
		<cfargument name="username" type="String">
		<cfargument name="password" type="String">
		<cfset var local = structNew()>
		<cfset local.return = false>

		<cfquery name="local.tryUsernameAndPassword" datasource="#application.dsn.wirelessAdvocates#">
			SELECT user_id
			FROM users WITH (NOLOCK)
			WHERE username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">
			AND password = <cfqueryparam value="#hashPassword(ARGUMENTS.password)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif local.tryUsernameAndPassword.recordCount>
			<cfset local.return = true>
		</cfif>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="login" access="remote" returntype="void" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var local = structNew()>

		<cfset session.currentUser = createObject('component','cfc.model.User').init()>
		<cfset session.currentUser.getUserByLogin(arguments.username,arguments.password)>
		<cfif session.currentUser.getUserId() neq "">
			<cfset session.userID = session.currentUser.getUserId()>
			<cfif structKeyExists(session,"authenticationId") and session.authenticationid is not "">
				<cfset updateAuthenticationId(session.currentUser.getUserId(),session.authenticationId) />
			</cfif>	
		</cfif>
	</cffunction>

	<cffunction name="CreateAuthenticatedUser" access="remote" returntype="void" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="authenticationid" type="string" required="true">
		<cfset var local = structNew()>

		<cfset session.currentUser = createObject('component','cfc.model.User').init()>
		<cfset session.currentUser.getUserByUsername(arguments.username)>
		<cfif session.currentUser.getUserId() neq "">
			<cfset session.userID = session.currentUser.getUserId()>
			<cfif structKeyExists(session,"authenticationId") and session.authenticationid is not "">
				<cfset updateAuthenticationId(session.currentUser.getUserId(),session.authenticationId) />
			</cfif>	
		</cfif>
	</cffunction>
	
	<cffunction name="loginByAuthenticationId" access="remote" returntype="void" output="false">
		<cfargument name="authenticationId" type="string" required="true">
		<cfset var local = structNew()>

		<cfset session.currentUser = createObject('component','cfc.model.User').init()>
		<cfset session.currentUser.getUserByAuthenticationId(arguments.authenticationId)>
		<cfif session.currentUser.getUserId() neq "">
			<cfset session.userID = session.currentUser.getUserId()>
		</cfif>
	</cffunction>


	<cffunction name="resetPassword" returntype="string">
		<cfargument name="username" type="String">
		<cfset var local = structNew()>
		<cfset local.ret = ""/>

		<cfquery name="local.tryUser" datasource="#application.dsn.wirelessAdvocates#">
		SELECT user_id
		FROM users WITH (NOLOCK)
		WHERE username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif local.tryUser.recordcount>
			<cfset local.ret = getRandString(10) />
			<cfquery name="setunlockstring" datasource="#application.dsn.wirelessAdvocates#">
			UPDATE users
			SET ssn = <cfqueryparam value="#local.ret#" cfsqltype="cf_sql_varchar">
			WHERE user_id = <cfqueryparam value="#local.tryUser.user_id#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>

		<cfreturn local.ret>
	</cffunction>

	<cffunction name="isResetCodeValid" returntype="boolean">
		<cfargument name="username" type="String">
		<cfargument name="code" type="String">
		<cfset var local = structNew()>

		<cfquery name="local.tryUser" datasource="#application.dsn.wirelessAdvocates#">
		SELECT user_id
		FROM users WITH (NOLOCK)
		WHERE username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">
			AND ssn = <cfqueryparam value="#ARGUMENTS.code#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn local.tryUser.recordcount>
	</cffunction>

	<cffunction name="changePassword">
		<cfargument name="username" type="String">
		<cfargument name="code" type="String">
		<cfargument name="password" type="String">

		<cfset var local = structNew()>
		<cfset local.ret = ""/>

		<cfquery name="setunlockstring" datasource="#application.dsn.wirelessAdvocates#">
		UPDATE users
		SET ssn = NULL,
			password = <cfqueryparam value="#hashPassword(ARGUMENTS.password)#" cfsqltype="cf_sql_varchar">
		WHERE username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">
			AND ssn = <cfqueryparam value="#ARGUMENTS.code#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn true>
	</cffunction>

	<cffunction name="updatePassword">
		<cfargument name="username" type="String">
		<cfargument name="password" type="String">

		<cfset var local = structNew()>
		<cfset local.ret = ""/>

		<cfquery name="local.setunlockstring" datasource="#application.dsn.wirelessAdvocates#">
			UPDATE users
			SET password = <cfqueryparam value="#hashPassword(ARGUMENTS.password)#" cfsqltype="cf_sql_varchar">
			WHERE username = <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateAuthenticationId" returnType="boolean">
		<cfargument name="userid" type="numeric" />
		<cfargument name="authenticationId" type="string" />
		<cfset UserService = application.wirebox.getInstance("UserService") />
		
		<!--- If authenticationId not already in use on another account add it to "this" account --->
		<cfif userService.isUserByAuthenticationId(arguments.authenticationId) is false>
			<cfquery name="local.setunlockstring" datasource="#application.dsn.wirelessAdvocates#">
				UPDATE users
				SET authenticationId = <cfqueryparam value="#arguments.authenticationid#" cfsqltype="cf_sql_varchar">
				WHERE user_id = <cfqueryparam value="#ARGUMENTS.userid#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfreturn true />
		<cfelse>
			<cfreturn false /> <!--- authentication already in use, so not updated --->
		</cfif>	
		
	</cffunction>	

	<cffunction name="createUser" returntype="query" access="remote">
		<cfargument name="username" type="String" default="">
		<cfargument name="password" type="String" default="">
		<cfset var local = structNew()>

		<!--- create the new user --->
		<cfquery name="local.qCreateUser" datasource="#application.dsn.wirelessAdvocates#" result="local.result">
			INSERT INTO Users (
				username,
                email,
				password,
				TimeCreated,
				TIMELASTAUTHENTICATED
			) 
			VALUES 
			(
				<cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#hashPassword(ARGUMENTS.password)#" cfsqltype="cf_sql_varchar">,
				getdate(),
				getdate()
			)
		</cfquery>

		<!--- now get the new user --->
		<cfset local.qUser = getUserByID( user_id = local.result.IDENTITYCOL )>

		<cfreturn local.qUser>
	</cffunction>
	
	<cffunction name="createUser_3rdPartyAuth" returntype="query" access="remote">
		<cfargument name="username" type="String" default="">
		<cfargument name="authenticationId" type="String" default="">
		<cfset var local = structNew()>

		<!--- create the new user --->
		<cftransaction>
			<cflock name="lock_createUser" type="exclusive" timeout="10">
				<cfquery name="local.qCreateUser" datasource="#application.dsn.wirelessAdvocates#">
					INSERT INTO Users (
						username,
                        email,
                        authenticationId,
						TimeCreated,
						TIMELASTAUTHENTICATED
					) VALUES (
						<cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#ARGUMENTS.username#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#ARGUMENTS.authenticationId#" cfsqltype="cf_sql_varchar">,
						getdate(),
						getdate()
					)
				</cfquery>
				<cfquery name="local.qGetThisUserID" datasource="#application.dsn.wirelessAdvocates#">
					SELECT
						max(user_id) as thisUserID
					FROM
						Users
				</cfquery>
			</cflock>
		</cftransaction>

		<!--- now get the new user --->
		<cfset local.qUser = getUserByID(user_id=local.qGetThisUserID.thisUserID)>

		<cfreturn local.qUser>
	</cffunction>

	<cffunction name="updateUser" returntype="query">
		<cfargument name="userID" type="numeric">
		<cfargument name="properties" type="struct">
		<cfset var local = structNew()>

		<!--- create the new user --->
		<cftransaction>
			<cflock name="lock_createUser" type="exclusive" timeout="10">
				<cfquery name="local.qCreateUser" datasource="#application.dsn.wirelessAdvocates#">
					UPDATE Users SET
					username = <cfqueryparam value="#ARGUMENTS.properties.username#" cfsqltype="cf_sql_varchar"/>
                    ,Email = <cfqueryparam value="#ARGUMENTS.properties.username#" cfsqltype="cf_sql_varchar"/>
					<cfif len(ARGUMENTS.properties.password) and len(ARGUMENTS.properties.password2)>
						,password = <cfqueryparam value="#hashPassword(ARGUMENTS.properties.password)#" cfsqltype="cf_sql_varchar"/>
					</cfif>
					,firstname = <cfqueryparam value="#ARGUMENTS.properties.bill_firstname#" cfsqltype="cf_sql_varchar" />
					,middleinitial = <cfqueryparam value="#ARGUMENTS.properties.bill_middleinitial#" cfsqltype="cf_sql_varchar" />
					,lastname = <cfqueryparam value="#ARGUMENTS.properties.bill_lastname#" cfsqltype="cf_sql_varchar" />
					,company = <cfqueryparam value="#ARGUMENTS.properties.bill_company#" cfsqltype="cf_sql_varchar" />
					,address1 = <cfqueryparam value="#ARGUMENTS.properties.bill_address1#" cfsqltype="cf_sql_varchar" />
					,address2 = <cfqueryparam value="#ARGUMENTS.properties.bill_address2#" cfsqltype="cf_sql_varchar" />
					,city = <cfqueryparam value="#ARGUMENTS.properties.bill_city#" cfsqltype="cf_sql_varchar" />
					,state = <cfqueryparam value="#ARGUMENTS.properties.bill_state#" cfsqltype="cf_sql_varchar" />
					,zip = <cfqueryparam value="#ARGUMENTS.properties.bill_zip#" cfsqltype="cf_sql_varchar" />
					,homephone = <cfqueryparam value="#ARGUMENTS.properties.bill_dayphone#" cfsqltype="cf_sql_varchar" />
					,workphone = <cfqueryparam value="#ARGUMENTS.properties.bill_evephone#" cfsqltype="cf_sql_varchar" />
					,shipfirstname = <cfqueryparam value="#ARGUMENTS.properties.ship_firstname#" cfsqltype="cf_sql_varchar" />
					,shipmiddleinitial = <cfqueryparam value="#ARGUMENTS.properties.ship_middleinitial#" cfsqltype="cf_sql_varchar" />
					,shiplastname = <cfqueryparam value="#ARGUMENTS.properties.ship_lastname#" cfsqltype="cf_sql_varchar" />
					,shipcompany = <cfqueryparam value="#ARGUMENTS.properties.ship_company#" cfsqltype="cf_sql_varchar" />
					,shipaddress1 = <cfqueryparam value="#ARGUMENTS.properties.ship_address1#" cfsqltype="cf_sql_varchar" />
					,shipaddress2 = <cfqueryparam value="#ARGUMENTS.properties.ship_address2#" cfsqltype="cf_sql_varchar" />
					,shipcity = <cfqueryparam value="#ARGUMENTS.properties.ship_city#" cfsqltype="cf_sql_varchar" />
					,shipstate = <cfqueryparam value="#ARGUMENTS.properties.ship_state#" cfsqltype="cf_sql_varchar" />
					,shipzip = <cfqueryparam value="#ARGUMENTS.properties.ship_zip#" cfsqltype="cf_sql_varchar" />
					,shipphone = <cfqueryparam value="#ARGUMENTS.properties.ship_dayphone#" cfsqltype="cf_sql_varchar" />
					,shipfax = <cfqueryparam value="#ARGUMENTS.properties.ship_evephone#" cfsqltype="cf_sql_varchar" />

					,shipBase = 	<cfif len(trim(this.getShippingAddress().getMilitaryBase()))>
										<cfqueryparam value="#this.getShippingAddress().getMilitaryBase()#" cfsqltype="cf_sql_varchar" />
									<cfelse>
										NULL
									</cfif>
					,MilitaryBase =  <cfif len(trim(this.getBillingAddress().getMilitaryBase()))>
										<cfqueryparam value="#this.getBillingAddress().getMilitaryBase()#" cfsqltype="cf_sql_varchar" />
									<cfelse>
										NULL
									</cfif>
					WHERE user_id = <cfqueryparam value="#ARGUMENTS.userID#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cflock>
		</cftransaction>

		<!--- now get the new user --->
		<cfset local.qUser = getUserByID(user_id=ARGUMENTS.userID)>

		<cfreturn local.qUser>
	</cffunction>

	<cffunction name="isAdmin" access="public" returntype="boolean" output="false">

		<cfset var local = structNew() />
		<cfset var isAdminReturn = false />

		<cfif isNumeric(this.getUserId())>
			<cfquery name="local.qGetIsAdmin" datasource="#application.dsn.wirelessAdvocates#">
				SELECT	ur.*, r.*
				FROM	account.UserRole AS ur WITH (NOLOCK)
				JOIN	account.Role AS r WITH (NOLOCK) ON r.RoleGuid = ur.RoleGuid
					AND	r.RoleGuid	=	'96C5D0B1-A8B7-479E-876F-637CB8BD53E7'
					AND	UserId		=	<cfqueryparam value="#this.getUserId()#" cfsqltype="cf_sql_integer" />
			</cfquery>

			<cfif local.qGetIsAdmin.recordCount gt 0>
				<cfset isAdminReturn = true />
			</cfif>
		</cfif>

		<cfreturn isAdminReturn />
	</cffunction>

	<cffunction name="getCountries" returntype="query">
		<cfset var local = structNew()>

		<cfquery name="local.qGetCountries" datasource="#application.dsn.wirelessAdvocates#">
			SELECT *
			FROM Countries WITH (NOLOCK)
			ORDER BY CountryName
		</cfquery>

		<cfreturn local.qGetCountries>
	</cffunction>

	<cffunction name="serializeCart" returntype="string">
		<cfargument name="cart" type="any" required="true">
		<cfset var local = structNew()>
		<cfset local.return = false>

		<cftry>
			<cfset local.byteOut = CreateObject("java", "java.io.ByteArrayOutputStream")>
			<cfset local.byteOut.init()>
			<cfset local.objOut = CreateObject("java", "java.io.ObjectOutputStream")>
			<cfset local.objOut.init(local.byteOut)>
			<cfset local.objOut.writeObject(arguments.cart)>
			<cfset local.objOut.close()>
			<cfset local.objSerialized = ToBase64(local.byteOut.toByteArray())>
			<cfset local.return = local.objSerialized>
			<cfcatch type="any">
				<cfset local.return = "">
			</cfcatch>
		</cftry>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="deserializeCart" returntype="any">
		<cfargument name="xmlCart" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.return = false>

		<cftry>
			<cfset local.byteIn = CreateObject("java", "java.io.ByteArrayInputStream")>
			<cfset local.byteIn.init(ToBinary( arguments.xmlCart ))>
			<cfset local.objIn = CreateObject("java", "java.io.ObjectInputStream")>
			<cfset local.objIn.init(local.byteIn)>
			<cfset local.objDeserialized = local.objIn.readObject()>
			<cfset local.objIn.close()>
			<cfset local.return = local.objDeserialized>

			<cfcatch type="any">
				<cfset local.return = "">
			</cfcatch>
		</cftry>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="saveCart" returntype="boolean">
		<cfargument name="userid" type="numeric" required="true">
		<cfargument name="cart" type="any" required="true">
		<cfset var local = structNew()>
		<cfset local.return = false>

		<cftry>
			<cfif session.UserAuth.isLoggedIn() and isStruct(session.cart)>
				<cfset local.cartSerialized = serializeCart(arguments.cart)>
				<cfquery name="local.qSaveUserCart" datasource="#application.dsn.wirelessAdvocates#">
					UPDATE Users SET
						wddxCart = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#local.cartSerialized#">
					WHERE
						user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
				</cfquery>
				<cfset local.return = true>
			</cfif>
			<cfcatch type="any">
				<cfset local.return = false>
			</cfcatch>
		</cftry>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="loadCart" returntype="boolean">
		<cfargument name="userid" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.return = false>

		<cftry>
			<cfif session.UserAuth.isLoggedIn()>
				<cfset local.qUser = getUserById(arguments.userid)>
				<cfif local.qUser.recordCount and len(trim(local.qUser.wddxCart))>
					<cfset local.cartDeserialized = deserializeCart(local.qUser.wddxCart)>
					<cfset session.cart = local.cartDeserialized>

					<cfset local.return = true>
				</cfif>
			</cfif>
			<cfcatch type="any">
				<cfset local.return = false>
			</cfcatch>
		</cftry>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="hasSavedCart" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.return = false>
		<cfif session.UserAuth.isLoggedIn()>
			<cfquery name="local.qCheckSavedCart" datasource="#application.dsn.wirelessAdvocates#">
				SELECT
					wddxCart
				FROM
					Users
				WHERE
					user_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.userid#">
			</cfquery>
			<cfif len(trim(local.qCheckSavedCart.wddxCart))>
				<cfset local.return = true>
			</cfif>
		</cfif>
		<cfreturn local.return>
	</cffunction>

	<cfscript>
		function hashPassword(password)	{
			return hash(trim(password));
		}

		function getRandString(stringLength)	{
			var tempAlphaList = 'a|b|c|d|e|f';
			var tempNumList = '1|2|3|4|5|6|7|8|9|0';
			var tempCompositeList = tempAlphaList & '|' & tempNumList;
			var tempCharsInList = listLen(tempCompositeList, '|');
			var tempCounter = 1;
			var tempWorkingString = '';

			while(tempCounter lte stringLength)	{
				tempWorkingString = tempWorkingString & listGetAt(tempCompositeList, randRange(1, tempCharsInList), '|');
				tempCounter = (tempCounter + 1);
			}

			return tempWorkingString;
		}
	</cfscript>

	<cffunction name="loadUserByUsername" output="false" access="public" returntype="void">
		<cfargument name="username" type="string" required="true" />
		<cfset var qUser = 0 />

		<cfquery name="qUser" datasource="#application.dsn.wirelessAdvocates#">
			SELECT User_ID UserId
			FROM Users WITH (NOLOCK)
			WHERE UserName = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfif qUser.RecordCount>
			<cfset getUserById( qUser.UserId ) />
		</cfif>
	</cffunction>


	<cffunction name="getUsersBySearchCriteria"  output="false" access="public" returntype="any">
		<cfargument name="searchCriteria" type="struct" required="true" />

		<cfset var qUsers = 0 />

		<cfquery name="qUsers" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				User_ID UserId
				, UserName
				, FirstName
				, LastName
				, HomePhone BillDayPhone
				, Zip BillZip
				, Address1 BillAddress1
			FROM Users WITH (NOLOCK)
			WHERE 1 = 1
				<cfif StructKeyExists( arguments.searchCriteria, "UserName" ) AND Len( Trim( arguments.searchCriteria.UserName ) )>
					AND UserName LIKE <cfqueryparam value="#arguments.searchCriteria.UserName#%" cfsqltype="cf_sql_varchar" />
				</cfif>
				<cfif StructKeyExists( arguments.searchCriteria, "FirstName" ) AND Len( Trim( arguments.searchCriteria.FirstName ) )>
					AND FirstName LIKE <cfqueryparam value="#arguments.searchCriteria.FirstName#%" cfsqltype="cf_sql_varchar" />
				</cfif>
				<cfif StructKeyExists( arguments.searchCriteria, "LastName" ) AND Len( Trim( arguments.searchCriteria.LastName ) )>
					AND LastName LIKE <cfqueryparam value="#arguments.searchCriteria.LastName#%" cfsqltype="cf_sql_varchar" />
				</cfif>
				<cfif StructKeyExists( arguments.searchCriteria, "Zip" ) AND Len( Trim( arguments.searchCriteria.Zip ) )>
					AND Zip LIKE <cfqueryparam value="#arguments.searchCriteria.Zip#%" cfsqltype="cf_sql_varchar" />
				</cfif>
				<cfif StructKeyExists( arguments.searchCriteria, "UserId" ) AND Len( Trim( arguments.searchCriteria.UserId ) )>
					AND User_ID LIKE <cfqueryparam value="#arguments.searchCriteria.UserId#%" cfsqltype="cf_sql_varchar" />
				</cfif>
				<cfif StructKeyExists( arguments.searchCriteria, "Phone" ) AND Len( Trim( arguments.searchCriteria.Phone ) )>
					AND
					(
						HomePhone LIKE <cfqueryparam value="#arguments.searchCriteria.Phone#%" cfsqltype="cf_sql_varchar" />
						OR WorkPhone LIKE <cfqueryparam value="#arguments.searchCriteria.Phone#%" cfsqltype="cf_sql_varchar" />
					)
				</cfif>
			ORDER BY FirstName, LastName
		</cfquery>

		<cfreturn qUsers />
	</cffunction>



    <!--- getters --->
    <cffunction name="getUserId" returntype="string">
		<cfif isDefined("variables.instance.userId")>
			<cfreturn variables.instance.userId />
		<cfelse>
			<cfreturn "" />
		</cfif>
	</cffunction>

    <cffunction name="getFirstName" returntype="string">
		<cfreturn variables.instance.firstName>
	</cffunction>

    <cffunction name="getLastName" returntype="string">
		<cfreturn variables.instance.lastName>
	</cffunction>

    <cffunction name="getMiddleInitial" returntype="string">
		<cfreturn variables.instance.middleInitial>
	</cffunction>

	<cffunction name="getEmail" access="public" returntype="string" output="false">
		<cfreturn trim(variables.instance.email) />
	</cffunction>

	<cffunction name="getLinesApproved" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.linesApproved />
	</cffunction>

	<cffunction name="getLinesActive" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.linesActive />
	</cffunction>

	<cffunction name="getBillingAddress" access="public" returntype="Address" output="false">

		<cfif not isDefined('variables.instance.billingAddress')>
			<cfset variables.instance.billingAddress = createobject('component', 'Address').init() />
		</cfif>

		<cfreturn variables.instance.billingAddress />
	</cffunction>

	<cffunction name="getShippingAddress" access="public" returntype="Address" output="false">

		<cfif not isDefined('variables.instance.shippingAddress')>
			<cfset variables.instance.shippingAddress = createobject('component', 'Address').init() />
		</cfif>

		<cfreturn variables.instance.shippingAddress />
	</cffunction>

	<!--- setters --->
     <cffunction name="setUserId" returntype="void">
		<cfargument name="userId" type="string" required="true">
		<cfset variables.instance.userId = arguments.userId>
	</cffunction>


    <cffunction name="setFirstName" returntype="void">
		<cfargument name="firstName" type="string" required="true">
		<cfset variables.instance.firstName = arguments.firstName>
	</cffunction>

    <cffunction name="setLastName" returntype="void">
		<cfargument name="lastName" type="string" required="true">
		<cfset variables.instance.lastName = arguments.lastName>
	</cffunction>

    <cffunction name="setMiddleInitial" returntype="void">
		<cfargument name="middleInitial" type="string" required="true">
		<cfset variables.instance.middleInitial = arguments.middleInitial>
	</cffunction>

	<cffunction name="setEmail" access="public" returntype="void" output="false">
		<cfargument name="setEmail" type="string" required="true" />

		<cfset variables.instance.email = trim(arguments.setEmail) />
	</cffunction>

	<cffunction name="setLinesApproved" access="public" returntype="void" output="false">
		<cfargument name="linesApproved" type="numeric" required="true" />

		<cfset variables.instance.linesApproved = arguments.linesApproved />
	</cffunction>

	<cffunction name="setLinesActive" access="public" returntype="void" output="false">
		<cfargument name="linesActive" type="numeric" required="true" />

		<cfset variables.instance.linesActive = arguments.linesActive />
	</cffunction>

    <cffunction name="setBillingAddress" returntype="void">
		<cfargument name="billingAddress" type="Address" required="true">
		<cfset variables.instance.billingAddress = arguments.billingAddress>
	</cffunction>

    <cffunction name="setShippingAddress" returntype="void">
		<cfargument name="shippingAddress" type="Address" required="true">
		<cfset variables.instance.shippingAddress = arguments.shippingAddress>
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>


    <!--- Begin: Neologix, 08 March 2010 --->

    <!--- RMP: function to update billing address --->
    <cffunction name="updateBilling" returntype="query" hint="function to update the billing address to user">
		<cfargument name="userID" type="numeric">
		<!---<cfargument name="properties" type="struct">--->
        <cfargument name="objBilling" type="struct">

		<cfset var local = structNew()>
		<!--- create the new user --->
        <cftransaction>
			<cflock name="lock_createBilling" type="exclusive" timeout="10">
				<cfquery name="local.qCreateUser" datasource="#application.dsn.wirelessAdvocates#">
					UPDATE Users SET
					firstname = <cfqueryparam value="#ARGUMENTS.objBilling.getFirstName()#" cfsqltype="cf_sql_varchar" />
					,middleinitial = <cfqueryparam value="#ARGUMENTS.objBilling.getMiddleInitial()#" cfsqltype="cf_sql_varchar" />
					,lastname = <cfqueryparam value="#ARGUMENTS.objBilling.getLastName()#" cfsqltype="cf_sql_varchar" />
					,company = <cfqueryparam value="#ARGUMENTS.objBilling.getCompany()#" cfsqltype="cf_sql_varchar" />
					,address1 = <cfqueryparam value="#ARGUMENTS.objBilling.getAddressLine1()#" cfsqltype="cf_sql_varchar" />
					,address2 = <cfqueryparam value="#ARGUMENTS.objBilling.getAddressLine2()#" cfsqltype="cf_sql_varchar" />
					,city = <cfqueryparam value="#ARGUMENTS.objBilling.getCity()#" cfsqltype="cf_sql_varchar" />
					,state = <cfqueryparam value="#ARGUMENTS.objBilling.getState()#" cfsqltype="cf_sql_varchar" />
					,zip = <cfqueryparam value="#ARGUMENTS.objBilling.getZipCode()#" cfsqltype="cf_sql_varchar" />
					,homephone = <cfqueryparam value="#ARGUMENTS.objBilling.getDayPhone()#" cfsqltype="cf_sql_varchar" />
					,workphone = <cfqueryparam value="#ARGUMENTS.objBilling.getEvePhone()#" cfsqltype="cf_sql_varchar" />
					WHERE user_id = <cfqueryparam value="#ARGUMENTS.userID#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cflock>
		</cftransaction>


    	<!--- now get the new user --->
		<cfset local.qUser = getUserByID(user_id=ARGUMENTS.userID)>

		<cfreturn local.qUser>
    </cffunction>


    <!--- RMP: function to update shipping address --->
    <cffunction name="updateShipping" returntype="query" hint="function to update the shipping address to user">
		<cfargument name="userID" type="numeric">
		<cfargument name="objShipping" type="struct">
		<cfset var local = structNew()>
		<!--- create the new user --->
        <cftransaction>
			<cflock name="lock_createShipping" type="exclusive" timeout="10">
				<cfquery name="local.qCreateUser" datasource="#application.dsn.wirelessAdvocates#">
					UPDATE Users SET
					shipfirstname = <cfqueryparam value="#ARGUMENTS.objShipping.getFirstName()#" cfsqltype="cf_sql_varchar" />
					,shipmiddleinitial = <cfqueryparam value="#ARGUMENTS.objShipping.getMiddleInitial()#" cfsqltype="cf_sql_varchar" />
					,shiplastname = <cfqueryparam value="#ARGUMENTS.objShipping.getLastName()#" cfsqltype="cf_sql_varchar" />
					,shipcompany = <cfqueryparam value="#ARGUMENTS.objShipping.getCompany()#" cfsqltype="cf_sql_varchar" />
					,shipaddress1 = <cfqueryparam value="#ARGUMENTS.objShipping.getAddressLine1()#" cfsqltype="cf_sql_varchar" />
					,shipaddress2 = <cfqueryparam value="#ARGUMENTS.objShipping.getAddressLine2()#" cfsqltype="cf_sql_varchar" />
					,shipcity = <cfqueryparam value="#ARGUMENTS.objShipping.getCity()#" cfsqltype="cf_sql_varchar" />
					,shipstate = <cfqueryparam value="#ARGUMENTS.objShipping.getState()#" cfsqltype="cf_sql_varchar" />
					,shipzip = <cfqueryparam value="#ARGUMENTS.objShipping.getZipCode()#" cfsqltype="cf_sql_varchar" />
					,shipphone = <cfqueryparam value="#ARGUMENTS.objShipping.getDayPhone()#" cfsqltype="cf_sql_varchar" />
					,shipfax = <cfqueryparam value="#ARGUMENTS.objShipping.getEvePhone()#" cfsqltype="cf_sql_varchar" />

					WHERE user_id = <cfqueryparam value="#ARGUMENTS.userID#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cflock>
		</cftransaction>


    	<!--- now get the new user --->
		<cfset local.qUser = getUserByID(user_id=ARGUMENTS.userID)>

		<cfreturn local.qUser>
    </cffunction>
    <!--- End: Neologix, 08 March 2010 --->

    <cffunction name="updateUserPwd" access="public" returntype="query" output="false">
		<cfargument name="userID" required="true" type="numeric" />
		<cfargument name="properties" required="true" type="struct" />

		<cfset var local = structNew() />

		<cftransaction>
			<cflock name="lock_createUser" type="exclusive" timeout="10">
				<cfquery name="local.qCreateUser" datasource="#application.dsn.wirelessAdvocates#">
					UPDATE			dbo.users
					SET				username	=	<cfqueryparam value="#trim(arguments.properties.username)#" cfsqltype="cf_sql_varchar" />,
									email		=	<cfqueryparam value="#trim(arguments.properties.username)#" cfsqltype="cf_sql_varchar" />
							<cfif len(trim(arguments.properties.password)) and len(trim(arguments.properties.password2))>
								,	password	=	<cfqueryparam value="#hashPassword(trim(arguments.properties.password))#" cfsqltype="cf_sql_varchar" />
							</cfif>
					WHERE			user_id		=	<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_numeric" />
				</cfquery>
			</cflock>
		</cftransaction>

		<cfset local.qUser = getUserByID(user_id = arguments.userId) />

		<cfreturn local.qUser />
	</cffunction>


    <cffunction name="updateOrderAssistance" output="false" access="public" returntype="void">
		<cfargument name="UserId" required="true" type="string" />
		<cfargument name="IsOrderAssistanceOn" required="true" type="boolean" />

		<cfquery datasource="#application.dsn.wirelessAdvocates#">
			UPDATE Users
			SET IsOrderAssistanceOn = <cfqueryparam value="#arguments.IsOrderAssistanceOn#" cfsqltype="cf_sql_bit" />
			WHERE User_Id = <cfqueryparam value="#arguments.UserId#" cfsqltype="cf_sql_integer" />
		</cfquery>

	</cffunction>

    <cffunction name="isUserOrderAssistanceOn" output="false" access="public" returntype="boolean">
		<cfargument name="UserId" required="true" type="string" />
		<cfset qUser = 0 />

		<cfquery name="qUser" datasource="#application.dsn.wirelessAdvocates#">
			SELECT IsOrderAssistanceOn
			FROM Users WITH (NOLOCK)
			WHERE User_Id = <cfqueryparam value="#arguments.UserId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfif qUser.RecordCount eq 0>
			<cfreturn false />
		<cfelse>	
			<cfreturn qUser.IsOrderAssistanceOn />
		</cfif>
	</cffunction>
	
	<cffunction name="isLoggedIn" access="public" output="false" returntype="boolean" hint="Checks if user has logged in.">    
    	<cfreturn isNumeric(getUserID()) && getUserID() neq 0>
    </cffunction>


</cfcomponent>