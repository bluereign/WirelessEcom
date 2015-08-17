<cfcomponent output="false">

	<!--- TODO: Add default/required properties --->
	<cfproperty name="FullName" type="string" />
	<cfproperty name="Street1" type="string" />
	<cfproperty name="City" type="string" />
	<cfproperty name="StateOrProvince" type="string" />
	<cfproperty name="PostalCode" type="string" />
	<cfproperty name="Country" type="string" />

	<cfset instance = {} />

	<!--- TODO: Switch default and required --->
	<cffunction name="init" output="false" returntype="any">
		<cfargument name="fullName" required="false" default="" />
		<cfargument name="street1" required="false" default="" />
		<cfargument name="city" required="false"  default="" />
		<cfargument name="stateOrProvince" required="false"  default="" />
		<cfargument name="postalCode" required="false"  default="" />
		<cfargument name="country" required="false"  default="" />

		<cfscript>
			setFullName( arguments.fullName );
			setStreet1( arguments.street1 );
			setCity( arguments.city );
			setStateOrProvince( arguments.stateOrProvince );
			setPostalCode( arguments.postalCode );
			setCountry( arguments.country );
		</cfscript>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="getFullName" output="false" returntype="string">
		<cfreturn variables.instance.FullName />
	</cffunction>
	<cffunction name="setFullName" output="false" returntype="void">
		<cfargument name="fullName" type="string" required="true" />
		<cfset variables.instance.FullName = arguments.fullName />
	</cffunction>

	<cffunction name="getStreet1" output="false" returntype="string">
		<cfreturn variables.instance.Street1 />
	</cffunction>
	<cffunction name="setStreet1" output="false" returntype="void">
		<cfargument name="street1" type="string" required="true" />
		<cfset variables.instance.Street1 = arguments.street1 />
	</cffunction>
	
	<cffunction name="getCity" output="false" returntype="string">
		<cfreturn variables.instance.City />
	</cffunction>
	<cffunction name="setCity" output="false" returntype="void">
		<cfargument name="city" type="string" required="true" />
		<cfset variables.instance.City = arguments.city />
	</cffunction>
	
	<cffunction name="getStateOrProvince" output="false" returntype="string">
		<cfreturn variables.instance.StateOrProvince />
	</cffunction>
	<cffunction name="setStateOrProvince" output="false" returntype="void">
		<cfargument name="stateOrProvince" type="string" required="true" />
		<cfset variables.instance.StateOrProvince = arguments.stateOrProvince />
	</cffunction>
	
	<cffunction name="getPostalCode" output="false" returntype="string">
		<cfreturn variables.instance.PostalCode />
	</cffunction>
	<cffunction name="setPostalCode" output="false" returntype="void">
		<cfargument name="postalCode" type="string" required="true" />
		<cfset variables.instance.PostalCode = arguments.postalCode />
	</cffunction>
	
	<cffunction name="getCountry" output="false" returntype="string">
		<cfreturn variables.instance.Country />
	</cffunction>
	<cffunction name="setCountry" output="false" returntype="void">
		<cfargument name="country" type="string" required="true" />
		<cfset variables.instance.Country = arguments.country />
	</cffunction>
	
	<cffunction name="getMemento" output="false" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>