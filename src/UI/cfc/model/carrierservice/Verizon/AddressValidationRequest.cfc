<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">
 
	<cffunction name="setAddressLine1" output="false" access="public" returntype="void">
		<cfargument name="AddressLine1" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.AddressLine1 = ' ' & arguments.AddressLine1 />
	</cffunction>
	<cffunction name="getAddressLine1" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.AddressLine1 />
	</cffunction>
	
	<cffunction name="setAddressLine2" output="false" access="public" returntype="void">
		<cfargument name="AddressLine2" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.AddressLine2 = ' ' & arguments.AddressLine2 />
	</cffunction>
	<cffunction name="getAddressLine2" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.AddressLine2 />
	</cffunction>
	
	<cffunction name="setAddressLine3" output="false" access="public" returntype="void">
		<cfargument name="AddressLine3" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.AddressLine3 = ' ' & arguments.AddressLine3 />
	</cffunction>
	<cffunction name="getAddressLine3" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.AddressLine3 />
	</cffunction>
	
	<cffunction name="setCity" output="false" access="public" returntype="void">
		<cfargument name="City" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.City = ' ' & arguments.City />
	</cffunction>
	<cffunction name="getCity" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.City />
	</cffunction>

	<cffunction name="setState" output="false" access="public" returntype="void">
		<cfargument name="State" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.State = ' ' & arguments.State />
	</cffunction>
	<cffunction name="getState" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.State />
	</cffunction>
	
	<cffunction name="setCountry" output="false" access="public" returntype="void">
		<cfargument name="Country" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Country = ' ' & arguments.Country />
	</cffunction>
	<cffunction name="getCountry" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Country />
	</cffunction>
	
	<cffunction name="setZipCode" output="false" access="public" returntype="void">
		<cfargument name="ZipCode" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.ZipCode = ' ' & arguments.ZipCode />
	</cffunction>
	<cffunction name="getZipCode" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.ZipCode />
	</cffunction>		

	<cffunction name="setExtendedZipCode" output="false" access="public" returntype="void">
		<cfargument name="ExtendedZipCode" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.ExtendedZipCode = ' ' & arguments.ExtendedZipCode />
	</cffunction>
	<cffunction name="getExtendedZipCode" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.ExtendedZipCode />
	</cffunction>

	<cffunction name="toJson" output="false" access="public" returntype="string">		
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>