<cfcomponent output="false" extends="cfc.model.carrierservice.ServiceBus.CarrierRequestBase">



	<cffunction name="setCreditCheckKeyInfo" output="false" access="public" returntype="void">
		<cfargument name="CreditCheckKeyInfo" type="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo" default="0" required="false" />
		<cfset this.RequestBody.OrderKeyInfo = arguments.CreditCheckKeyInfo />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo">
		<cfreturn this.RequestBody.OrderKeyInfo />
	</cffunction>
	
	<cffunction name="setAccountNumber" output="false" access="public" returntype="void">
		<cfargument name="AccountNumber" type="string" required="true" />
		<cfset this.RequestBody.AccountNumber = ' ' & arguments.AccountNumber />
	</cffunction>
	<cffunction name="getAccountNumber" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.AccountNumber />
	</cffunction>
	
	<cffunction name="setMDNPort" output="false" access="public" returntype="void">
		<cfargument name="MDNPort" type="boolean" required="true" />
		<cfset this.RequestBody.MDNPort = arguments.MDNPort />
	</cffunction>
	<cffunction name="getMDNPort" output="false" access="public" returntype="boolean">
		<cfreturn this.RequestBody.MDNPort />
	</cffunction>

	<cffunction name="setAccountSubNumber" output="false" access="public" returntype="void">
		<cfargument name="AccountSubNumber" type="string" required="true" />
		<cfset this.RequestBody.AccountSubNumber = ' ' & arguments.AccountSubNumber />
	</cffunction>
	<cffunction name="getAccountSubNumber" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.AccountSubNumber />
	</cffunction>
	
	<cffunction name="setAssignedMobileNumber" output="false" access="public" returntype="void">
		<cfargument name="AssignedMobileNumber" type="string" required="true" />
		<cfset this.RequestBody.AssignedMobileNumber = ' ' & arguments.AssignedMobileNumber />
	</cffunction>
	<cffunction name="getAssignedMobileNumber" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.AssignedMobileNumber />
	</cffunction>
	
	<cffunction name="setCreditApprovalStatus" output="false" access="public" returntype="void">
		<cfargument name="CreditApprovalStatus" type="string" required="true" />
		<cfset this.RequestBody.CreditApprovalStatus = ' ' & arguments.CreditApprovalStatus />
	</cffunction>
	<cffunction name="getCreditApprovalStatus" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.CreditApprovalStatus />
	</cffunction>
	
	<cffunction name="setMultiLineSeqNumber" output="false" access="public" returntype="void">
		<cfargument name="MultiLineSeqNumber" type="string" required="true" />
		<cfset this.RequestBody.MultiLineSeqNumber = ' ' & arguments.MultiLineSeqNumber />
	</cffunction>
	<cffunction name="getMultiLineSeqNumber" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.MultiLineSeqNumber />
	</cffunction>

	<cffunction name="setActivationDate" output="false" access="public" returntype="void">
		<cfargument name="ActivationDate" type="date" required="true" />
		<cfset this.RequestBody.ActivationDate = ' ' & arguments.ActivationDate />
	</cffunction>
	<cffunction name="getActivationDate" output="false" access="public" returntype="date">
		<cfreturn this.RequestBody.ActivationDate />
	</cffunction>

	<!---  NEW, UPGRADE, AAL --->
	<cffunction name="setOrderType" output="false" access="public" returntype="void">
		<cfargument name="OrderType" type="string" required="true" />
		<cfset this.RequestBody.OrderType = ' ' & arguments.OrderType />
	</cffunction>
	<cffunction name="getOrderType" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.OrderType />
	</cffunction>
		
	<cffunction name="setSecurityDepositAmount" output="false" access="public" returntype="void">
		<cfargument name="SecurityDepositAmount" type="string" required="true" />
		<cfset this.RequestBody.SecurityDepositAmount = ' ' & arguments.SecurityDepositAmount />
	</cffunction>
	<cffunction name="getSecurityDepositAmount" output="false" access="public" returntype="string">
		<cfreturn this.RequestBody.SecurityDepositAmount />
	</cffunction>
	
	<cffunction name="setPrimaryUserInfo" output="false" access="public" returntype="void">
		<cfargument name="PrimaryUserInfo" type="cfc.model.carrierservice.Verizon.common.User" required="true" />
		<cfset this.RequestBody.PrimaryUserInfo = arguments.PrimaryUserInfo />
	</cffunction>
	<cffunction name="getPrimaryUserInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.User">
		<cfreturn this.RequestBody.PrimaryUserInfo />
	</cffunction>
		
	<cffunction name="setNewEqptInfo" output="false" access="public" returntype="void">
		<cfargument name="DeviceInfo" type="cfc.model.carrierservice.Verizon.common.Device" required="true" />
		<cfset this.RequestBody.NewEqptInfo.DeviceInfo = arguments.DeviceInfo />
	</cffunction>
	<cffunction name="getNewEqptInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Device">
		<cfreturn this.RequestBody.NewEqptInfo.DeviceInfo />
	</cffunction>

	<cffunction name="setFeatures" output="false" access="public" returntype="void">
		<cfargument name="Features" type="cfc.model.carrierservice.Verizon.common.Feature[]" required="true" />
		<cfset this.RequestBody.SelectedFeatureList.Features = arguments.Features />
	</cffunction>
	<cffunction name="getFeatures" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Feature[]">
		<cfreturn this.RequestBody.SelectedFeatureList.Features />
	</cffunction>

	<cffunction name="setPricePlanInfo" output="false" access="public" returntype="void">
		<cfargument name="PricePlanInfo" type="cfc.model.carrierservice.Verizon.common.PricePlanInfo" required="true" />
		<cfset this.RequestBody.PricePlanInfo = arguments.PricePlanInfo />
	</cffunction>
	<cffunction name="getPricePlanInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.PricePlanInfo">
		<cfreturn this.RequestBody.PricePlanInfo />
	</cffunction>
	
	<cffunction name="setUpgradeOldDevice" output="false" access="public" returntype="void">
		<cfargument name="UpgradeOldDevice" type="cfc.model.carrierservice.Verizon.common.Device" required="true" />
		<cfset this.RequestBody.UpgCustInfo.OldEqptInfo.DeviceInfo = arguments.UpgradeOldDevice />
	</cffunction>
	<cffunction name="getUpgradeOldDevice" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Device">
		<cfreturn this.RequestBody.UpgCustInfo.OldEqptInfo.DeviceInfo />
	</cffunction>

	<cffunction name="setIsUpgradePhoneSwap" output="false" access="public" returntype="void">
		<cfargument name="IsUpgradePhoneSwap" type="boolean" required="true" />
		<cfset this.RequestBody.UpgCustInfo.PhoneSwap  = arguments.IsUpgradePhoneSwap />
	</cffunction>
	<cffunction name="getIsUpgradePhoneSwap" output="false" access="public" returntype="boolean">
		<cfreturn this.RequestBody.UpgCustInfo.PhoneSwap  />
	</cffunction>
	
	<cffunction name="setIsDeviceInfoFinal" output="false" access="public" returntype="void">
		<cfargument name="IsDeviceInfoFinal" type="boolean" required="true" />
		<cfset this.RequestBody.IsDeviceInfoFinal = arguments.IsDeviceInfoFinal />
	</cffunction>
	<cffunction name="getIsDeviceInfoFinal" output="false" access="public" returntype="boolean">
		<cfreturn this.RequestBody.IsDeviceInfoFinal />
	</cffunction>
		
	<cffunction name="toJson" output="false" access="public" returntype="string">		
		<cfreturn serializeJSON(this) />
	</cffunction>	

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>