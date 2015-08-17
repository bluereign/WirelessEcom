<cfcomponent output="false" extends="fw.model.BaseBusinessObject">
	
	<cfproperty name="GeoService" inject="id:GeoService">
	
	<!----------------- Constructor ---------------------->    
    	    
    <cffunction name="init" access="public" output="false" returntype="Address">   
    	<cfscript>    
    		setAddressLine1("");
			setAddressLine2("");
			setAddressLine3("");
			setCity("");
			setState("");
			setZipCode("");
			setZipCodeExtension("");
			setCountry("US");
			setCompany("");
			setFirstname("");
			setLastName("");
			setMiddleInitial("");
			setName("");
			setDayPhone("");
			setEvePhone("");
			setMilitaryBase("");
			
			return this;
		</cfscript>
	</cffunction>
	
	<!----------------- GET/SET ---------------------->
		
	<cffunction name="getAddressLine1" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["addressLine1"] />    
    </cffunction>    
    <cffunction name="setAddressLine1" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance["addressLine1"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getAddressLine2" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["addressLine2"]/>    
    </cffunction>    
    <cffunction name="setAddressLine2" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["addressLine2"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getAddressLine3" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["addressLine3"]/>    
    </cffunction>    
    <cffunction name="setAddressLine3" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["addressLine3"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getCity" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["city"]/>    
    </cffunction>    
    <cffunction name="setCity" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["city"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getState" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["state"]/>    
    </cffunction>    
    <cffunction name="setState" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["state"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getZipCode" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["zipCode"]/>    
    </cffunction>    
    <cffunction name="setZipCode" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["zipCode"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getZipCodeExtension" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["zipCodeExtension"]/>    
    </cffunction>    
    <cffunction name="setZipCodeExtension" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["zipCodeExtension"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getCountry" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["country"]/>    
    </cffunction>    
    <cffunction name="setCountry" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["country"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getCompany" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["company"]/>    
    </cffunction>    
    <cffunction name="setCompany" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["company"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getFirstName" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["firstName"]/>    
    </cffunction>    
    <cffunction name="setFirstName" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["firstName"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getLastName" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["lastName"]/>    
    </cffunction>    
    <cffunction name="setLastName" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["lastName"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getMiddleInitial" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["middleInitial"]/>    
    </cffunction>    
    <cffunction name="setMiddleInitial" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["middleInitial"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getName" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["name"]/>    
    </cffunction>    
    <cffunction name="setName" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["name"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getDayPhone" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["dayPhone"]/>    
    </cffunction>    
    <cffunction name="setDayPhone" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["dayPhone"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getEvePhone" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["evePhone"]/>    
    </cffunction>    
    <cffunction name="setEvePhone" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["evePhone"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getMilitaryBase" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["MilitaryBase"]/>    
    </cffunction>    
    <cffunction name="setMilitaryBase" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["MilitaryBase"] = arguments.theVar />    
    </cffunction>
    
</cfcomponent>