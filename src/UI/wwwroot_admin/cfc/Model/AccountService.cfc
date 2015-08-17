<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="any">
		<!--- TODO: Pass in User singleton --->
		<cfset variables.instance.userGateway = CreateObject( "component", "cfc.model.User" ).init() />
		<cfreturn this />
	</cffunction>


	<cffunction name="createUser" output="false" access="public" returntype="numeric">
		<cfargument name="user" type="cfc.model.User" required="true" />
		<cfargument name="password" type="string" default="" required="false" />

		<cfset var userPassword = "" />
		<cfset var newUserId = 0 />
		<cfset var qUser = "" />

		<cfif Len( arguments.password )>
			<cfset userPassword = arguments.password />
		<cfelse>
			<cfset userPassword = generatePassword() />
		</cfif>

		<cfif NOT isEmailInUse( arguments.user.getEmail() )>
			<!--- TODO: Update cfc.model.User --->
			<cfquery datasource="#application.dsn.ACBMasterDS#" result="qUser">
				INSERT INTO Users
				(
			 		UserName
					, Password
					, FirstName
					, LastName
					, Email
					, Company
					, Address1
					, Address2
					, City
					, State
					, ZIP
					, HomePhone
					, WorkPhone
					, ShipFirstName
					, ShipLastName
					, ShipCompany
					, ShipAddress1
					, ShipAddress2
					, ShipCity
					, ShipZip
					, ShipState
					, ShipPhone
					, TimeCreated
				)
				VALUES
				(
			 		<cfqueryparam value="#arguments.user.getEmail()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getEmail() )#" />
					, <cfqueryparam value="#userPassword#" cfsqltype="cf_sql_varchar" null="#NOT len( userPassword )#" />
					, <cfqueryparam value="#arguments.user.getFirstName()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getFirstName() )#" />
					, <cfqueryparam value="#arguments.user.getLastName()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getLastName() )#" />
					, <cfqueryparam value="#arguments.user.getEmail()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getEmail() )#"/>
					, <cfqueryparam value="#arguments.user.getBillingAddress().getCompany()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getCompany() )#" />
					, <cfqueryparam value="#arguments.user.getBillingAddress().getAddressLine1()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getAddressLine1() )#" />
					, <cfqueryparam value="#arguments.user.getBillingAddress().getAddressLine2()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getAddressLine2() )#" />
					, <cfqueryparam value="#arguments.user.getBillingAddress().getCity()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getCity() )#" />
					, <cfqueryparam value="#arguments.user.getBillingAddress().getState()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getState() )#" />
					, <cfqueryparam value="#arguments.user.getBillingAddress().getZipCode()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getZipCode() )#" />
					, <cfqueryparam value="#arguments.user.getBillingAddress().getDayPhone()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getDayPhone() )#" />
					, <cfqueryparam value="#arguments.user.getBillingAddress().getEvePhone()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getBillingAddress().getEvePhone() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getFirstname()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getFirstname() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getLastname()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getCompany() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getCompany()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getLastname() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getAddressLine1()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getAddressLine1() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getAddressLine2()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getAddressLine2() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getCity()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getCity() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getZipCode()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getZipCode() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getState()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getState() )#" />
					, <cfqueryparam value="#arguments.user.getShippingAddress().getDayPhone()#" cfsqltype="cf_sql_varchar" null="#NOT len( arguments.user.getShippingAddress().getDayPhone() )#" />
					, GetDate()
				)
			</cfquery>

			<cfset newUserId = qUser.IDENTITYCOL />
		</cfif>

		<cfreturn newUserId />
	</cffunction>


	<cffunction name="updatePassword" output="false" access="public" returntype="void">
		<cfargument name="user" type="cfc.model.User" required="true" />
		<cfargument name="password" type="string" default="" required="false" />

		<cfset var userPassword = "" />

		<cfif Len( arguments.password )>
			<cfset userPassword = arguments.password />
		<cfelse>
			<cfset userPassword = generatePassword() />
		</cfif>


		<!--- TODO: Update cfc.model.User --->
		<cfquery datasource="#application.dsn.ACBMasterDS#">
			UPDATE Users
			SET Password = <cfqueryparam value="#userPassword#" cfsqltype="cf_sql_varchar" />
			WHERE User_ID = <cfqueryparam value="#arguments.user.getUserId()#" cfsqltype="cf_sql_varchar" />
		</cfquery>


		<!--- TODO: Send email or add to email Queue --->

	</cffunction>


	<cffunction name="isEmailInUse" output="false" access="public" returntype="boolean">
		<cfargument name="username" type="string" required="true" />

		<cfscript>
			var isAvailable = variables.instance.userGateway.isEmailInUse( arguments.username );
		</cfscript>

		<cfreturn isAvailable />
	</cffunction>


	<cffunction name="generatePassword" output="false" access="public" returntype="string">
		<!--- TODO: add arguments --->

		<cfscript>
			/**
			* Generates a password the length you specify.
			* v2 by James Moberg.
			*
			* @param numberOfCharacters      Lengh for the generated password. Defaults to 8. (Optional)
			* @param characterFilter      Characters filtered from result. Defaults to O,o,0,i,l,1,I,5,S (Optional)
			* @return Returns a string.
			* @author Tony Blackmon (fluid@sc.rr.com)
			* @version 2, February 8, 2010
			*/
			var placeCharacter = "";
			var currentPlace=0;
			var group=0;
			var subGroup=0;
			var numberofCharacters = 8;
			var characterFilter = 'O,o,0,i,l,1,I,5,S';
			var characterReplace = repeatString(",", listlen(characterFilter)-1);
			if(arrayLen(arguments) gte 1) numberofCharacters = val(arguments[1]);
			if(arrayLen(arguments) gte 2) {
			characterFilter = listsort(rereplace(arguments[2], "([[:alnum:]])", "\1,", "all"),"textnocase");
			characterReplace = repeatString(",", listlen(characterFilter)-1);
			}
			while (len(placeCharacter) LT numberofCharacters) {
				group = randRange(1,4, 'SHA1PRNG');
				switch(group) {
					case "1":
						subGroup = rand();
						switch(subGroup) {
							case "0":
								placeCharacter = placeCharacter & chr(randRange(33,46, 'SHA1PRNG'));
								break;
							case "1":
								placeCharacter = placeCharacter & chr(randRange(58,64, 'SHA1PRNG'));
								break;
						}
					case "2":
						placeCharacter = placeCharacter & chr(randRange(97,122, 'SHA1PRNG'));
						break;
					case "3":
						placeCharacter = placeCharacter & chr(randRange(65,90, 'SHA1PRNG'));
						break;
					case "4":
						placeCharacter = placeCharacter & chr(randRange(48,57, 'SHA1PRNG'));
						break;
				}
				if (listLen(characterFilter)) {
					placeCharacter = replacelist(placeCharacter, characterFilter, characterReplace);
				}
			}

			return placeCharacter;
		</cfscript>
	</cffunction>

	<cffunction name="getUsername" access="public" returntype="string" output="false">
		<cfargument name="adminUserId" required="true" type="numeric" />

		<cfset var getUsernameReturn = 'N/A' />
		<cfset var qry_getUsername = '' />

		<cfquery name="qry_getUsername" datasource="#application.dsn.wirelessadvocates#">
			SELECT	u.username
			FROM	dbo.Users AS u WITH (NOLOCK)
			WHERE	u.User_Id	=	<cfqueryparam value="#trim(arguments.adminUserId)#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfif qry_getUsername.recordCount and len(trim(qry_getUsername.username))>
			<cfset getUsernameReturn = trim(qry_getUsername.username) />
		</cfif>

		<cfreturn getUsernameReturn />
	</cffunction>

</cfcomponent>