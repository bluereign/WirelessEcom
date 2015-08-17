<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">

	<cffunction name="setActivationType" output="false" access="public" returntype="void">
		<cfargument name="ActivationType" type="string" required="true" />
		<cfset this.RequestBody.ActivationType = ' ' & arguments.ActivationType />
	</cffunction>
	<cffunction name="getActivationType" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ActivationType />
	</cffunction>

	<cffunction name="setNumberOfLines" output="false" access="public" returntype="void">
		<cfargument name="NumberOfLines" type="string" required="true" />
		<cfset this.RequestBody.NumberOfLines = ' ' & arguments.NumberOfLines  />
	</cffunction>
	<cffunction name="getNumberOfLines" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.NumberOfLines />
	</cffunction>

	<cffunction name="setAddress" output="false" access="public" returntype="void">
		<cfargument name="Address" type="cfc.model.carrierservice.Verizon.common.Address" required="true" />
		<cfset this.RequestBody.Address = arguments.Address />
	</cffunction>
	<cffunction name="getAddress" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Address">
		<cfreturn this.RequestBody.Address />
	</cffunction>

	<cffunction name="setServiceZipCode" output="false" access="public" returntype="void">
		<cfargument name="ServiceZipCode" type="string" required="true" />
		<cfset this.RequestBody.ServiceZipCode = ' ' & arguments.ServiceZipCode />
	</cffunction>
	<cffunction name="getServiceZipCode" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.ServiceZipCode />
	</cffunction>

	<cffunction name="setEmail" output="false" access="public" returntype="void">
		<cfargument name="Email" type="string" required="true" />
		<cfset this.RequestBody.Email = ' ' & arguments.Email />
	</cffunction>
	<cffunction name="getEmail" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.Email />
	</cffunction>
	
	<cffunction name="setBillingNameFirstName" output="false" access="public" returntype="void">
		<cfargument name="BillingNameFirstName" type="string" required="true" />
		<cfset this.RequestBody.BillingName.FirstName = ' ' & arguments.BillingNameFirstName />
	</cffunction>
	<cffunction name="getBillingNameFirstName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.FirstName />
	</cffunction>
	
	<cffunction name="setBillingNameMiddleInitial" output="false" access="public" returntype="void">
		<cfargument name="BillingNameMiddleInitial" type="string" required="true" />
		<cfset this.RequestBody.BillingName.MiddleInitial = ' ' & arguments.BillingNameMiddleInitial />
	</cffunction>
	<cffunction name="getBillingNameMiddleInitial" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.MiddleInitial />
	</cffunction>

	<cffunction name="setBillingNameLastName" output="false" access="public" returntype="void">
		<cfargument name="BillingNameLastName" type="string" required="true" />
		<cfset this.RequestBody.BillingName.LastName = ' ' & arguments.BillingNameLastName />
	</cffunction>
	<cffunction name="getBillingNameLastName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.LastName />
	</cffunction>

	<cffunction name="setBillingNamePrefix" output="false" access="public" returntype="void">
		<cfargument name="BillingNamePrefix" type="string" required="true" />
		<cfset this.RequestBody.BillingName.Prefix = ' ' & arguments.BillingNamePrefix />
	</cffunction>
	<cffunction name="getBillingNamePrefix" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.Prefix />
	</cffunction>

	<cffunction name="setBillingNameSuffix" output="false" access="public" returntype="void">
		<cfargument name="BillingNameSuffix" type="string" required="true" />
		<cfset this.RequestBody.BillingName.Suffix = ' ' & arguments.BillingNameSuffix />
	</cffunction>
	<cffunction name="getBillingNameSuffix" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.BillingName.Suffix />
	</cffunction>
	
	<cffunction name="setEmployerDetailsName" output="false" access="public" returntype="void">
		<cfargument name="EmployerDetailsName" type="string" required="true" />
		<cfset this.RequestBody.EmployerDetails.Name = ' ' & arguments.EmployerDetailsName />
	</cffunction>
	<cffunction name="getEmployerDetailsName" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.EmployerDetails.Name />
	</cffunction>
	
	<cffunction name="setEmployerDetailsCity" output="false" access="public" returntype="void">
		<cfargument name="EmployerDetailsCity" type="string" required="true" />
		<cfset this.RequestBody.EmployerDetails.City = ' ' & arguments.EmployerDetailsCity />
	</cffunction>
	<cffunction name="getEmployerDetailsCity" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.EmployerDetails.City />
	</cffunction>
	
	<cffunction name="setEmployerDetailsState" output="false" access="public" returntype="void">
		<cfargument name="EmployerDetailsState" type="string" required="true" />
		<cfset this.RequestBody.EmployerDetails.State = ' ' & arguments.EmployerDetailsState />
	</cffunction>
	<cffunction name="getEmployerDetailsState" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.EmployerDetails.State />
	</cffunction>					

	<cffunction name="setNewCustomerInfo" output="false" access="public" returntype="void">
		<cfargument name="NewCustomerInfo" type="cfc.model.carrierservice.Verizon.common.NewCustomerInfo" required="true" />
		<cfset this.RequestBody.NewCustomerInfo = arguments.NewCustomerInfo />
	</cffunction>
	<cffunction name="getNewCustomerInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.NewCustomerInfo">
		<cfreturn this.RequestBody.NewCustomerInfo />
	</cffunction>
	
	<cffunction name="setUpgradeCustomerInfo" output="false" access="public" returntype="void">
		<cfargument name="UpgradeCustomerInfo" type="cfc.model.carrierservice.Verizon.common.UpgradeCustomerInfo" required="true" />
		<cfset this.RequestBody.UpgradeCustomerInfo = arguments.UpgradeCustomerInfo />
	</cffunction>
	<cffunction name="getUpgradeCustomerInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.UpgradeCustomerInfo">
		<cfreturn this.RequestBody.UpgradeCustomerInfo />
	</cffunction>	

	<cffunction name="setAddALineCustomerInfo" output="false" access="public" returntype="void">
		<cfargument name="AddALineCustomerInfo" type="cfc.model.carrierservice.Verizon.common.AddALineCustomerInfo" required="true" />
		<cfset this.RequestBody.AddALineCustomerInfo = arguments.AddALineCustomerInfo />
	</cffunction>
	<cffunction name="getAddALineCustomerInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.AddALineCustomerInfo">
		<cfreturn this.RequestBody.AddALineCustomerInfo />
	</cffunction>

	<cffunction name="toJson" output="false" access="public" returntype="string">
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>