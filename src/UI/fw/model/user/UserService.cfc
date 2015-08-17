<cfcomponent output="false" extends="fw.model.BaseService">
	
	<cfproperty name="UserProvider" inject="provider:User">
	<cfproperty name="UserGateway" inject="id:UserGateway">
	<cfproperty name="StringUtil" inject="id:StringUtil">
    
    <!-------------------- Public ------------------------>
   
	<cffunction name="newUser">
		<cfreturn UserProvider.get()>
	</cffunction>
	
	<cffunction name="usernameExists" access="public" output="false" returntype="boolean" hint="Checks if username exists">    
    	<cfargument name="username" type="string" required="true" />
		
		<cfset var qUser = variables.UserGateway.getUser( email = arguments.username )>
		
		<cfreturn yesNoFormat(qUser.recordCount)>		
    </cffunction>
    
    <cffunction name="getUserByLogin" access="public" output="false" returntype="any" hint="Returns User object if exists, else empty struct.">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		
		<cfscript>
			var qUser = variables.UserGateway.getUser(email=arguments.username, password=hash(arguments.password));
			
			if( qUser.recordCount ) {
				return getUserByID( qUser.User_ID );
			} else {
				return newUser();
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getUserByID" access="public" output="false" returntype="any" hint="Returns populated User, if exists. Else new User.">
		<cfargument name="userID" type="numeric" required="true" />
		
		<cfscript>
			var User = newUser();
			var props = {};
			var shipProps = {};
			var BillingAddress = User.getBillingAddress();
			var ShippingAddress = User.getShippingAddress();
			var qUser = variables.UserGateway.getUser( userID = arguments.userID );
			
			// Stop if no User was found
			if( !qUser.recordCount ) {
				return User;
			}
			
			// Create structure for populate()
			props = {
				userID = qUser.User_ID,
				firstName = qUser.FirstName,
				lastName = qUser.LastName,
				middleInitial = qUser.MiddleInitial,
				email = qUser.UserName,
				addressLine1 = qUser.Address1,
				addressLine2 = qUser.Address2,
				addressLine3 = '',
				city = qUser.City,
				state = qUser.State,
				zipCode = qUser.Zip,
				zipCodeExtension = '',
				country = qUser.Country,
				company = qUser.Company,
				name = trim(qUser.FirstName) & ' ' & trim(qUser.LastName),
				dayPhone = qUser.WorkPhone,
				evePhone = qUser.HomePhone,
				militaryBase = qUser.MilitaryBase,
				authenticationID = qUser.authenticationId
			};
			
			shipProps = {
				firstName = qUser.ShipFirstName,
				lastName = qUser.ShipLastName,
				middleInitial = qUser.ShipMiddleInitial,
				addressLine1 = qUser.ShipAddress1,
				addressLine2 = qUser.ShipAddress2,
				addressLine3 = '',
				city = qUser.ShipCity,
				state = qUser.ShipState,
				zipCode = qUser.ShipZip,
				zipCodeExtension = '',
				country = qUser.ShipCountry,
				company = qUser.ShipCompany,
				name = trim(qUser.ShipFirstName) & ' ' & trim(qUser.ShipLastName),
				dayPhone = qUser.ShipPhone,
				evePhone = qUser.ShipFax,
				militaryBase = qUser.ShipBase 
			};
			
			User.populate(props);
			BillingAddress.populate(props);
			ShippingAddress.populate(shipProps);

			User.setBillingAddress(BillingAddress);
			User.setShippingAddress(ShippingAddress);
			
			return User;
		</cfscript>
		
	</cffunction>
	
	<!--- Used in the AAFES (and any future 3rd party auth) environments to bypass passwords --->
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
	
	<cffunction name="updateAuthenticationId" returnType="void" >
		<cfargument name="user" type="fw.model.user.User" required="true">
		<cfargument name="authenticationId" type="string" />
		
		<cfset variables.UserGateway.saveAuthenticationId(arguments.user) />
		
	</cffunction>	


	
	<cffunction name="createUser" access="public" output="false" returntype="numeric" hint="Creates basic user record and returns the PK.">
		<cfargument name="username" type="string" default="">
		
		<cfreturn variables.UserGateway.createUser(username = arguments.username, password = generatePassword)>
	</cffunction>
	
	<cffunction name="saveUser" access="public" output="false" returntype="void" hint="Saves User.">    
    	<cfargument name="User" type="fw.model.user.User" required="true">
		
		<cfif arguments.User.getUserID() gt 0>
			<cfset variables.UserGateway.saveUser( User = arguments.User )>
		 <cfelse>
			<cfthrow message="Method saveUser() is not implemented for new user records. Only existing user records can be saved.">
		</cfif>
    </cffunction>
	
	<cffunction name="generatePassword" access="private" output="false" returntype="any" hint="Creates random secure password.">    
    	<cfreturn hash(StringUtil.createRandom(10))>
    </cffunction>
			
	<cffunction name="isUserOrderAssistanceOn" output="false" access="public" returntype="boolean">
		<cfargument name="userId" required="true" type="numeric">
		
		<cfset var status = variables.UserGateway.getOrderAssistanceStatus( userId = arguments.userId )>
		
		<cfif status.recordCount>
			<cfreturn yesNoFormat(status.IsOrderAssistanceOn)>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
</cfcomponent>