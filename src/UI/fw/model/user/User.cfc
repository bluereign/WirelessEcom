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
    
</cfcomponent>