<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">
 
 <!---
 
    <addressToValidate xmlns:d3p1="http://schemas.datacontract.org/2004/07/WirelessAdvocates.Services.CarrierInterface.ATT.Common.Types">



      <d3p1:Contact>
        <d3p1:CellPhone>String</d3p1:CellPhone>
        <d3p1:Email>String</d3p1:Email>
        <d3p1:EveningPhone>String</d3p1:EveningPhone>
        <d3p1:WorkPhone>String</d3p1:WorkPhone>
        <d3p1:WorkPhoneExt>String</d3p1:WorkPhoneExt>
      </d3p1:Contact>

      <d3p1:ExtendedZipCode>String</d3p1:ExtendedZipCode>
      <d3p1:Name>
        <d3p1:FirstName>String</d3p1:FirstName>
        <d3p1:LastName>String</d3p1:LastName>
        <d3p1:MiddleInitial>String</d3p1:MiddleInitial>
        <d3p1:Prefix>String</d3p1:Prefix>
        <d3p1:Suffix>String</d3p1:Suffix>
      </d3p1:Name>

    </addressToValidate>
    <addressType>Shipping</addressType>
 
 --->
 
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

	<cffunction name="setCompanyName" output="false" access="public" returntype="void">
		<cfargument name="CompanyName" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.CompanyName = ' ' & arguments.CompanyName />
	</cffunction>
	<cffunction name="getCompanyName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.CompanyName />
	</cffunction>

	<cffunction name="setAddressType" output="false" access="public" returntype="void">
		<cfargument name="AddressType" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.AddressType = ' ' & arguments.AddressType />
	</cffunction>
	<cffunction name="getAddressType" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.AddressType />
	</cffunction>

	<!--- Name --->

	<cffunction name="setFirstName" output="false" access="public" returntype="void">
		<cfargument name="FirstName" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Name.FirstName = ' ' & arguments.FirstName />
	</cffunction>
	<cffunction name="getFirstName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Name.FirstName />
	</cffunction>

	<cffunction name="setLastName" output="false" access="public" returntype="void">
		<cfargument name="LastName" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Name.LastName = ' ' & arguments.LastName />
	</cffunction>
	<cffunction name="getLastName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Name.LastName />
	</cffunction>

	<cffunction name="setMiddleInitial" output="false" access="public" returntype="void">
		<cfargument name="MiddleInitial" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Name.MiddleInitial = ' ' & arguments.MiddleInitial />
	</cffunction>
	<cffunction name="getMiddleInitial" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Name.MiddleInitial />
	</cffunction>

	<cffunction name="setPrefix" output="false" access="public" returntype="void">
		<cfargument name="Prefix" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Name.Prefix = ' ' & arguments.Prefix />
	</cffunction>
	<cffunction name="getPrefix" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Name.Prefix />
	</cffunction>

	<cffunction name="setSuffix" output="false" access="public" returntype="void">
		<cfargument name="Suffix" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Name.Suffix = ' ' & arguments.Suffix />
	</cffunction>
	<cffunction name="getSuffix" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Name.Suffix />
	</cffunction>

	<!--- Contact --->

	<cffunction name="setCellPhone" output="false" access="public" returntype="void">
		<cfargument name="CellPhone" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Contact.CellPhone = ' ' & arguments.CellPhone />
	</cffunction>
	<cffunction name="getCellPhone" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Contact.CellPhone />
	</cffunction>

	<cffunction name="setEmail" output="false" access="public" returntype="void">
		<cfargument name="Email" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Contact.Email = ' ' & arguments.Email />
	</cffunction>
	<cffunction name="getEmail" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Contact.Email />
	</cffunction>

	<cffunction name="setEveningPhone" output="false" access="public" returntype="void">
		<cfargument name="EveningPhone" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Contact.EveningPhone = ' ' & arguments.EveningPhone />
	</cffunction>
	<cffunction name="getEveningPhone" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Contact.EveningPhone />
	</cffunction>
		
	<cffunction name="setWorkPhone" output="false" access="public" returntype="void">
		<cfargument name="WorkPhone" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Contact.WorkPhone = ' ' & arguments.WorkPhone />
	</cffunction>
	<cffunction name="getWorkPhone" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Contact.WorkPhone />
	</cffunction>

	<cffunction name="setWorkPhoneExt" output="false" access="public" returntype="void">
		<cfargument name="WorkPhoneExt" type="string" default="0" required="false" />
		<cfset this.RequestBody.Address.Contact.WorkPhoneExt = ' ' & arguments.WorkPhoneExt />
	</cffunction>
	<cffunction name="getWorkPhoneExt" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Address.Contact.WorkPhoneExt />
	</cffunction>


	<cffunction name="toJson" output="false" access="public" returntype="string">		
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>