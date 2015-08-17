<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.PlanDetail">
		<cfargument name="MultiLineSeqNumber" type="string" default="" required="false" />
		<cfargument name="SaleType" type="string" default="" required="false" />
		<cfargument name="PlanType" type="string" default="" required="false" />
		<cfargument name="PricePlanId" type="string" default="" required="false" />
		<cfargument name="NafCode" type="string" default="" required="false" />
		<cfargument name="EqptInfo" type="cfc.model.carrierservice.Verizon.common.Device" default="#CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Device').init()#" required="false" />
		<cfargument name="DeviceType" type="string" default="" required="false" />
		<cfargument name="SelectedNpaNxx" type="string" default="" required="false" />
		<cfargument name="AssignedMobileNumber" type="string" default="" required="false" />

		<cfscript>
			variables.instance = {};

			setMultiLineSeqNumber( arguments.MultiLineSeqNumber );
			setSaleType( arguments.SaleType );
			setPlanType( arguments.PlanType );
			setPricePlanId( arguments.PricePlanId );
			setNafCode( arguments.NafCode );
			setEqptInfo( arguments.EqptInfo );
			setSelectedNpaNxx( arguments.SelectedNpaNxx );
			setAssignedMobileNumber( arguments.AssignedMobileNumber );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setMultiLineSeqNumber" output="false" access="public" returntype="void">
		<cfargument name="MultiLineSeqNumber" type="string" default="0" required="false" />
		<cfset this.MultiLineSeqNumber = ' ' & arguments.MultiLineSeqNumber />
	</cffunction>
	<cffunction name="getMultiLineSeqNumber" output="false" access="public" returntype="string">
		<cfreturn this.MultiLineSeqNumber />
	</cffunction>
	
	<cffunction name="setSaleType" output="false" access="public" returntype="void">
		<cfargument name="SaleType" type="string" default="0" required="false" />
		<cfset this.SaleType = ' ' & arguments.SaleType />
	</cffunction>
	<cffunction name="getSaleType" output="false" access="public" returntype="string">
		<cfreturn this.SaleType />
	</cffunction>
	
	<cffunction name="setPlanType" output="false" access="public" returntype="void">
		<cfargument name="PlanType" type="string" default="0" required="false" />
		<cfset this.PlanType = ' ' & arguments.PlanType />
	</cffunction>
	<cffunction name="getPlanType" output="false" access="public" returntype="string">
		<cfreturn this.PlanType />
	</cffunction>
	
	<cffunction name="setPricePlanId" output="false" access="public" returntype="void">
		<cfargument name="PricePlanId" type="string" default="0" required="false" />
		<cfset this.PricePlanId = ' ' & arguments.PricePlanId />
	</cffunction>
	<cffunction name="getPricePlanId" output="false" access="public" returntype="string">
		<cfreturn this.PricePlanId />
	</cffunction>
	
	<cffunction name="setNafCode" output="false" access="public" returntype="void">
		<cfargument name="NafCode" type="string" default="0" required="false" />
		<cfset this.NafCode = ' ' & arguments.NafCode />
	</cffunction>
	<cffunction name="getNafCode" output="false" access="public" returntype="string">
		<cfreturn this.NafCode />
	</cffunction>

	<cffunction name="setEqptInfo" output="false" access="public" returntype="void">
		<cfargument name="DeviceInfo" type="cfc.model.carrierservice.Verizon.common.Device" required="true" />
		<cfset this.EqptInfo = arguments.DeviceInfo />
	</cffunction>
	<cffunction name="getEqptInfo" output="false" access="public" returntype="cfc.model.carrierservice.Verizon.common.Device">
		<cfreturn this.EqptInfo />
	</cffunction>

	<cffunction name="setSelectedNpaNxx" output="false" access="public" returntype="void">
		<cfargument name="SelectedNpaNxx" type="string" default="0" required="false" />
		<cfset this.SelectedNpaNxx = ' ' & arguments.SelectedNpaNxx />
	</cffunction>
	<cffunction name="getSelectedNpaNxx" output="false" access="public" returntype="string">
		<cfreturn this.SelectedNpaNxx />
	</cffunction>

	<cffunction name="setAssignedMobileNumber" output="false" access="public" returntype="void">
		<cfargument name="AssignedMobileNumber" type="string" default="0" required="false" />
		<cfset this.AssignedMobileNumber = ' ' & arguments.AssignedMobileNumber />
	</cffunction>
	<cffunction name="getAssignedMobileNumber" output="false" access="public" returntype="string">
		<cfreturn this.AssignedMobileNumber />
	</cffunction>

	<!--- Using a leading space in strings because ColdFusion has a type casting limitation that converts the string to numeric values --->	
	<cffunction name="toJson" output="false" access="public" returntype="string">
	
		<cfscript>
			var jsonString = '';
			var jsonObject = '';
			
			jsonString = {
				MultiLineSeqNumber = " #getMultiLineSeqNumber()#"
				, SaleType = " #getSaleType()#"
				, PlanType = " #getPlanType()#"
				, PricePlanId = " #getPricePlanId()#"
				, NafCode = " #getNafCode()#"
				, EqptInfo = #getEqptInfo()#
				, SelectedNpaNxx = " #getSelectedNpaNxx()#"
				, AssignedMobileNumber = " #getAssignedMobileNumber()#"
			};
			
			jsonObject = serializeJSON(jsonObject);
		</cfscript>

		<cfreturn jsonObject />
	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn this />
	</cffunction>

</cfcomponent>