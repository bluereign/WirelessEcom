<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Address">
		<cfargument name="AddressLine1" type="string" default="" required="false" />
		<cfargument name="AddressLine2" type="string" default="" required="false" />
		<cfargument name="AddressLine3" type="string" default="" required="false" />
		<cfargument name="AptNum" type="string" default="" required="false" />
		<cfargument name="City" type="string" default="" required="false" />
		<cfargument name="State" type="string" default="" required="false" />
		<cfargument name="Country" type="string" default="" required="false" />
		<cfargument name="ZipCode" type="string" default="" required="false" />
		<cfargument name="ExtendedZipCode" type="string" default="" required="false" />

		<cfscript>
			setAddressLine1( arguments.AddressLine1 );
			setAddressLine2( arguments.AddressLine2 );
			setAddressLine3( arguments.AddressLine3 );
			setAptNum( arguments.AptNum );
			setCity( arguments.City );
			setState( arguments.State );
			setCountry( arguments.Country );
			setZipCode( arguments.ZipCode );
			setExtendedZipCode( arguments.ExtendedZipCode );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setAddressLine1" output="false" access="public" returntype="void">
		<cfargument name="AddressLine1" type="string" required="true" />
		<cfset this.AddressLine1 = ' ' & arguments.AddressLine1 />
	</cffunction>
	<cffunction name="getAddressLine1" output="false" access="public" returntype="string">
		<cfreturn this.AddressLine1 />
	</cffunction>
	
	<cffunction name="setAddressLine2" output="false" access="public" returntype="void">
		<cfargument name="AddressLine2" type="string" required="true" />
		<cfset this.AddressLine2 = ' ' & arguments.AddressLine2 />
	</cffunction>
	<cffunction name="getAddressLine2" output="false" access="public" returntype="string">
		<cfreturn this.AddressLine2 />
	</cffunction>
	
	<cffunction name="setAddressLine3" output="false" access="public" returntype="void">
		<cfargument name="AddressLine3" type="string" required="true" />
		<cfset this.AddressLine3 = ' ' & arguments.AddressLine3 />
	</cffunction>
	<cffunction name="getAddressLine3" output="false" access="public" returntype="string">
		<cfreturn this.AddressLine3 />
	</cffunction>
	
	<cffunction name="setAptNum" output="false" access="public" returntype="void">
		<cfargument name="AptNum" type="string" required="true" />
		<cfset this.AptNum = ' ' & arguments.AptNum />
	</cffunction>
	<cffunction name="getAptNum" output="false" access="public" returntype="string">
		<cfreturn this.AptNum />
	</cffunction>

	<cffunction name="setCity" output="false" access="public" returntype="void">
		<cfargument name="City" type="string" required="true" />
		<cfset this.City = ' ' & arguments.City />
	</cffunction>
	<cffunction name="getCity" output="false" access="public" returntype="string">
		<cfreturn this.City />
	</cffunction>
	
	<cffunction name="setState" output="false" access="public" returntype="void">
		<cfargument name="State" type="string" required="true" />
		<cfset this.State = ' ' & arguments.State />
	</cffunction>
	<cffunction name="getState" output="false" access="public" returntype="string">
		<cfreturn this.State />
	</cffunction>
	
	<cffunction name="setCountry" output="false" access="public" returntype="void">
		<cfargument name="Country" type="string" required="true" />
		<cfset this.Country = ' ' & arguments.Country />
	</cffunction>
	<cffunction name="getCountry" output="false" access="public" returntype="string">
		<cfreturn this.Country />
	</cffunction>
	
	<cffunction name="setZipCode" output="false" access="public" returntype="void">
		<cfargument name="ZipCode" type="string" required="true" />
		<cfset this.ZipCode = ' ' & arguments.ZipCode />
	</cffunction>
	<cffunction name="getZipCode" output="false" access="public" returntype="string">
		<cfreturn this.ZipCode />
	</cffunction>

	<cffunction name="setExtendedZipCode" output="false" access="public" returntype="void">
		<cfargument name="ExtendedZipCode" type="string" required="true" />
		<cfset this.ExtendedZipCode = ' ' & arguments.ExtendedZipCode />
	</cffunction>
	<cffunction name="getExtendedZipCode" output="false" access="public" returntype="string">
		<cfreturn this.ExtendedZipCode />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>