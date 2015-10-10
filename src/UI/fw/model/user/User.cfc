<cfcomponent output="false" extends="fw.model.BaseBusinessObject">
	
	<cfproperty name="GeoService" inject="id:GeoService" />
	
	<!----------------- Constructor ---------------------->    

	<cffunction name="init" access="public" output="false" returntype="User">
		<cfscript>
			setUserID(0);	
			setFirstName("");
			setMiddleInitial("");
			setLastName("");
			setEmail("");
			setCompany("");
			setDateOfBirth("");
			setLinesApproved(0);
			setLinesActive(0);
			setAuthenticationId("");
			
			setDateOfBirthRequired(false);
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="isDateOfBirthRequired" access="public" output="false" returntype="boolean">
		<cfreturn getDateOfBirthRequired()>
	</cffunction>
	
	<!----------------- Pseudo-Constructor after DI---------------------->    

	<cffunction name="onDIComplete" access="public" output="false" returntype="void">
		<cfscript>
			setBillingAddress(variables.GeoService.newAddress());
			setShippingAddress(variables.GeoService.newAddress());
		</cfscript>	
	</cffunction>
	
	<!----------------- PUBLIC ---------------------->
		
	<cffunction name="isLoggedIn" access="public" output="false" returntype="boolean" hint="Checks if user has logged in.">    
    	<cfreturn isNumeric(getUserID()) && getUserID() neq 0>
    </cffunction>
    
    <!----------------- GET/SET ---------------------->
		
    <cffunction name="getUserID" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["userID"]/>    
    </cffunction>    
    <cffunction name="setUserID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["userID"] = arguments.theVar />    
    </cffunction>
    
     <cffunction name="getAuthenticationID" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["authenticationID"]/>    
    </cffunction>    
    <cffunction name="setAuthenticationID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["authenticationID"] = arguments.theVar />    
    </cffunction>
   
	<cffunction name="getFirstName" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["firstName"]/>    
    </cffunction>    
    <cffunction name="setFirstName" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["firstName"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getMiddleInitial" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["middleInitial"]/>    
    </cffunction>    
    <cffunction name="setMiddleInitial" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["middleInitial"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getLastName" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["lastName"]/>    
    </cffunction>    
    <cffunction name="setLastName" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["lastName"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getEmail" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["email"]/>    
    </cffunction>    
    <cffunction name="setEmail" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["email"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getDateOfBirth" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["dob"]/>    
    </cffunction>    
    <cffunction name="setDateOfBirth" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["dob"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getCompany" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["company"]/>    
    </cffunction>    
    <cffunction name="setCompany" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["company"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getLinesApproved" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["linesApproved"]/>    
    </cffunction>    
    <cffunction name="setLinesApproved" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["linesApproved"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getLinesActive" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["linesActive"]/>    
    </cffunction>    
    <cffunction name="setLinesActive" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["linesActive"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getDateOfBirthRequired" access="public" output="false" returntype="boolean">    
    	<cfreturn variables.instance["dateOfBirthRequired"]/>    
    </cffunction>    
    <cffunction name="setDateOfBirthRequired" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["dateOfBirthRequired"] = arguments.theVar />    
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

    
    <!--- Relationships --->
		
	<cffunction name="getBillingAddress" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["BillingAddress"]/>    
    </cffunction>    
    <cffunction name="setBillingAddress" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["BillingAddress"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getShippingAddress" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["ShippingAddress"]/>    
    </cffunction>    
    <cffunction name="setShippingAddress" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["ShippingAddress"] = arguments.theVar />    
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
    
    
</cfcomponent>