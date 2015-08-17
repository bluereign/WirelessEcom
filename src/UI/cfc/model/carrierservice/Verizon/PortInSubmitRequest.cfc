<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">



	<cffunction name="setCreditCheckKeyInfo" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" default="0" required="false" />
		<cfset this.RequestBody.OrderKeyInfo = arguments.CreditCheckKeyInfo />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
		<cfreturn this.RequestBody.OrderKeyInfo />
	</cffunction>

	<cffunction name="setBussOrIndCustomer" output="false" access="public" returntype="void">
		<cfargument name="BussOrIndCustomer" type="string" default="0" required="false" />
		<cfset this.RequestBody.PortInDetails.BussOrIndCustomer = ' ' & arguments.BussOrIndCustomer />
	</cffunction>
	<cffunction name="getBussOrIndCustomer" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.PortInDetails.BussOrIndCustomer />
	</cffunction>

	<cffunction name="setCBRPhone" output="false" access="public" returntype="void">
		<cfargument name="CBRPhone" type="string" default="0" required="false" />
		<cfset this.RequestBody.PortInDetails.CBRPhone = ' ' & arguments.CBRPhone />
	</cffunction>
	<cffunction name="getCBRPhone" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.PortInDetails.CBRPhone />
	</cffunction>

	<cffunction name="setOSPAccountNum" output="false" access="public" returntype="void">
		<cfargument name="OSPAccountNum" type="string" default="0" required="false" />
		<cfset this.RequestBody.PortInDetails.OSPAccountNum = ' ' & arguments.OSPAccountNum />
	</cffunction>
	<cffunction name="getOSPAccountNum" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.PortInDetails.OSPAccountNum />
	</cffunction>

	<cffunction name="setAuthorizedSigner" output="false" access="public" returntype="void">
		<cfargument name="AuthorizedSigner" type="string" default="0" required="false" />
		<cfset this.RequestBody.PortInDetails.AuthorizedSigner = ' ' & arguments.AuthorizedSigner />
	</cffunction>
	<cffunction name="getAuthorizedSigner" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.PortInDetails.AuthorizedSigner />
	</cffunction>
	
	<cffunction name="setPasswordPin" output="false" access="public" returntype="void">
		<cfargument name="PasswordPin" type="string" default="0" required="false" />
		<cfset this.RequestBody.PortInDetails.PasswordPin = ' ' & arguments.PasswordPin />
	</cffunction>
	<cffunction name="getPasswordPin" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.PortInDetails.PasswordPin />
	</cffunction>	

	<cffunction name="setUserInfo" output="false" access="public" returntype="void">
		<cfargument name="UserInfo" type="cfc.model.carrierservice.Verizon.common.User" default="0" required="false" />
		<cfset this.RequestBody.PortInDetails.UserInfo = arguments.UserInfo />
	</cffunction>
	<cffunction name="getUserInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.User">
		<cfreturn this.RequestBody.PortInDetails.UserInfo />
	</cffunction>
	
	<cffunction name="setPortInItems" output="false" access="public" returntype="void">
		<cfargument name="PortInItems" type="cfc.model.carrierservice.Verizon.common.PortInItem[]" default="0" required="false" />
		<cfset this.RequestBody.PortInDetails.PortInItems = arguments.PortInItems />
	</cffunction>
	<cffunction name="getPortInItems" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.PortInItem[]">
		<cfreturn this.RequestBody.PortInDetails.PortInItems />
	</cffunction>
	
	
	<cffunction name="toJson" output="false" access="public" returntype="string">		
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>