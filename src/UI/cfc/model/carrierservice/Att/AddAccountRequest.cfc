<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">

	<cffunction name="setBillingAddress" output="false" access="public" returntype="void">
		<cfargument name="BillingAddress" type="cfc.model.carrierservice.Att.common.Address" required="true" />
		<cfset this.RequestBody.BillingAddress = arguments.BillingAddress />
	</cffunction>
	<cffunction name="getBillingAddress" output="false" access="public" returntype="cfc.model.carrierservice.Att.common.Address">
		<cfreturn this.RequestBody.BillingAddress />
	</cffunction>

	<!--- billingContactCredentials --->

	<cffunction name="setDOB" output="false" access="public" returntype="void">
		<cfargument name="DOB" type="string" required="true" />
		<cfset this.RequestBody.BillingContactCredentials.DOB = ' ' & arguments.DOB />
	</cffunction>
	<cffunction name="getDOB" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingContactCredentials.DOB />
	</cffunction>

	<cffunction name="setId" output="false" access="public" returntype="void">
		<cfargument name="Id" type="string" required="true" />
		<cfset this.RequestBody.BillingContactCredentials.Id = ' ' & arguments.Id />
	</cffunction>
	<cffunction name="getId" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingContactCredentials.Id />
	</cffunction>

	<cffunction name="setIdExpiration" output="false" access="public" returntype="void">
		<cfargument name="IdExpiration" type="string" required="true" />
		<cfset this.RequestBody.BillingContactCredentials.IdExpiration = ' ' & arguments.IdExpiration />
	</cffunction>
	<cffunction name="getIdExpiration" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingContactCredentials.IdExpiration />
	</cffunction>

	<cffunction name="setIdType" output="false" access="public" returntype="void">
		<cfargument name="IdType" type="string" required="true" />
		<cfset this.RequestBody.BillingContactCredentials.IdType = ' ' & arguments.IdType />
	</cffunction>
	<cffunction name="getIdType" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingContactCredentials.IdType />
	</cffunction>
	
	<cffunction name="setSSN" output="false" access="public" returntype="void">
		<cfargument name="SSN" type="string" required="true" />
		<cfset this.RequestBody.BillingContactCredentials.SSN = ' ' & arguments.SSN />
	</cffunction>
	<cffunction name="getSSN" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingContactCredentials.SSN />
	</cffunction>

	<cffunction name="setState" output="false" access="public" returntype="void">
		<cfargument name="State" type="string" required="true" />
		<cfset this.RequestBody.BillingContactCredentials.State = ' ' & arguments.State />
	</cffunction>
	<cffunction name="getState" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingContactCredentials.State />
	</cffunction>
	
	<!--- billingName --->
		
	<cffunction name="setFirstName" output="false" access="public" returntype="void">
		<cfargument name="FirstName" type="string" required="true" />
		<cfset this.RequestBody.BillingName.FirstName = ' ' & arguments.FirstName />
	</cffunction>
	<cffunction name="getFirstName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.FirstName />
	</cffunction>

	<cffunction name="setLastName" output="false" access="public" returntype="void">
		<cfargument name="LastName" type="string" required="true" />
		<cfset this.RequestBody.BillingName.LastName = ' ' & arguments.LastName />
	</cffunction>
	<cffunction name="getLastName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.LastName />
	</cffunction>
	
	<cffunction name="setMiddleInitial" output="false" access="public" returntype="void">
		<cfargument name="MiddleInitial" type="string" required="true" />
		<cfset this.RequestBody.BillingName.MiddleInitial = ' ' & arguments.MiddleInitial />
	</cffunction>
	<cffunction name="getMiddleInitial" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.MiddleInitial />
	</cffunction>

	<cffunction name="setPrefix" output="false" access="public" returntype="void">
		<cfargument name="Prefix" type="string" required="true" />
		<cfset this.RequestBody.BillingName.Prefix = ' ' & arguments.Prefix />
	</cffunction>
	<cffunction name="getPrefix" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.Prefix />
	</cffunction>
	
	<cffunction name="setSuffix" output="false" access="public" returntype="void">
		<cfargument name="Suffix" type="string" required="true" />
		<cfset this.RequestBody.BillingName.Suffix = ' ' & arguments.Suffix />
	</cffunction>
	<cffunction name="getSuffix" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.Suffix />
	</cffunction>
	
	<!--- contactInfo --->
		
	<cffunction name="setCellPhone" output="false" access="public" returntype="void">
		<cfargument name="CellPhone" type="string" required="true" />
		<cfset this.RequestBody.ContactInfo.CellPhone = ' ' & arguments.CellPhone />
	</cffunction>
	<cffunction name="getCellPhone" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ContactInfo.CellPhone />
	</cffunction>

	<cffunction name="setEmail" output="false" access="public" returntype="void">
		<cfargument name="Email" type="string" required="true" />
		<cfset this.RequestBody.ContactInfo.Email = ' ' & arguments.Email />
	</cffunction>
	<cffunction name="getEmail" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ContactInfo.Email />
	</cffunction>
		
	<cffunction name="setEveningPhone" output="false" access="public" returntype="void">
		<cfargument name="EveningPhone" type="string" required="true" />
		<cfset this.RequestBody.ContactInfo.EveningPhone = ' ' & arguments.EveningPhone />
	</cffunction>
	<cffunction name="getEveningPhone" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ContactInfo.EveningPhone />
	</cffunction>

	<cffunction name="setWorkPhone" output="false" access="public" returntype="void">
		<cfargument name="WorkPhone" type="string" required="true" />
		<cfset this.RequestBody.ContactInfo.WorkPhone = ' ' & arguments.WorkPhone />
	</cffunction>
	<cffunction name="getWorkPhone" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ContactInfo.WorkPhone />
	</cffunction>
			
	<cffunction name="setWorkPhoneExt" output="false" access="public" returntype="void">
		<cfargument name="WorkPhoneExt" type="string" required="true" />
		<cfset this.RequestBody.ContactInfo.WorkPhoneExt = ' ' & arguments.WorkPhoneExt />
	</cffunction>
	<cffunction name="getWorkPhoneExt" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ContactInfo.WorkPhoneExt />
	</cffunction>


	<cffunction name="setNumberOfLines" output="false" access="public" returntype="void">
		<cfargument name="NumberOfLines" type="string" required="true" />
		<cfset this.RequestBody.NumberOfLines = ' ' & arguments.NumberOfLines />
	</cffunction>
	<cffunction name="getNumberOfLines" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.NumberOfLines />
	</cffunction>

	<cffunction name="setServiceZipCode" output="false" access="public" returntype="void">
		<cfargument name="ServiceZipCode" type="string" required="true" />
		<cfset this.RequestBody.ServiceZipCode = ' ' & arguments.ServiceZipCode />
	</cffunction>
	<cffunction name="getServiceZipCode" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ServiceZipCode />
	</cffunction>


	<cffunction name="toJson" output="false" access="public" returntype="string">
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>