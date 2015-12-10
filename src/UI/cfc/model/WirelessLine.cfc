<cfcomponent displayname="WirelessLine" output="false">

	<cfset variables.instance = StructNew() />
	<!--- Required for setStepInstance() --->
	<cfset variables.beanFieldArr = ListToArray("WirelessLineId|OrderId|OrderDetailId|PlanId|CarrierPlanId|PlanType|NewMDN|ESN|IMEI|CurrentMDN|CurrentCarrier|IsMDNPort|PortRequestId|PortResponse|PortStatus|NPArequested|UpgradeEligible|RequestedActivationDate|CarrierReferenceId1|CarrierReferenceId2|CarrierReferenceId3|PortInDueDate|ContractLength|MonthlyFee|MarketCode|LineDevice|LineRateplan|LineServices|LineAccessories", "|") />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0)>

	<!--- INITIALIZATION / CONFIGURATION --->

	<cffunction name="init" access="public" returntype="cfc.model.WirelessLine" output="false">
    
		<cfargument name="WirelessLineId" type="numeric" required="false" default="0" />
		<cfargument name="OrderId" type="numeric" required="false" default="0" />
		<cfargument name="OrderDetailId" type="numeric" required="false" default="0" />
		<cfargument name="PlanId" type="numeric" required="false" default="0" />
		<cfargument name="CarrierPlanId" type="string" required="false" default="" />
		<cfargument name="PlanType" type="string" required="false" default="" />
		<cfargument name="CarrierPlanType" type="string" required="false" default="" />
		<cfargument name="NewMDN" type="string" required="false" default="" />
		<cfargument name="ESN" type="string" required="false" default="" />
		<cfargument name="IMEI" type="string" required="false" default="" />
		<cfargument name="CurrentMDN" type="string" required="false" default="" />
		<cfargument name="CurrentCarrier" type="numeric" required="false" default="0" />
		<cfargument name="IsMDNPort" type="boolean" required="false" default="false" />
		<cfargument name="PortRequestId" type="string" required="false" default="" />
		<cfargument name="PortResponse" type="string" required="false" default="" />
		<cfargument name="PortStatus" type="string" required="false" default="" />
		<cfargument name="IsNPArequested" type="boolean" required="false" default="false" />
        <cfargument name="NPArequested" type="string" required="false" default="" />
		<cfargument name="UpgradeEligible" type="boolean" required="false" default="false" />
		<cfargument name="RequestedActivationDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="CarrierReferenceId1" type="string" required="false" default="" />
		<cfargument name="CarrierReferenceId2" type="string" required="false" default="" />
		<cfargument name="CarrierReferenceId3" type="string" required="false" default="" />
		<cfargument name="PortInDueDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="ContractLength" type="numeric" required="false" default="0" />
		<cfargument name="MonthlyFee" type="numeric" required="false" default="0" />
		<cfargument name="MarketCode" type="string" required="false" default="" />
		<cfargument name="LineDevice" type="cfc.model.OrderDetail" required="false" default="#createObject('component','cfc.model.OrderDetail').init()#" />
		<cfargument name="LineRateplan" type="cfc.model.OrderDetail" required="false" default="#createObject('component','cfc.model.OrderDetail').init()#" />
		<cfargument name="LineServices" type="cfc.model.OrderDetail[]" required="false" default="#arrayNew(1)#" />
		<cfargument name="LineAccessories" type="cfc.model.OrderDetail[]" required="false" default="#arrayNew(1)#" />
		<cfargument name="LineWarranty" type="cfc.model.OrderDetail" required="false" default="#createObject('component','cfc.model.OrderDetail').init()#" />
		<cfargument name="Sim" type="string" required="false" default="" />
		<cfargument name="ActivationStatus" type="numeric" required="false" default="0" />
		<cfargument name="ActivationFee" type="numeric" required="false" default="0" />
        <cfargument name="PortInCurrentCarrier" type="string" required="false" default="" />
        <cfargument name="PortInCurrentCarrierPin" type="string" required="false" default="" />      
        <cfargument name="PortInCurrentCarrierAccountNumber" type="string" required="false" default="" />
		<cfargument name="PrepaidAccountNumber" type="string" required="false" default="" />
		<cfargument name="IsPrepaid" type="boolean" required="false" default="false" />
		<cfargument name="CurrentImei" type="string" required="false" default="" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />

		<!--- run setters --->
		<cfset setWirelessLineId(arguments.WirelessLineId) />
		<cfset setOrderId(arguments.OrderId) />
		<cfset setOrderDetailId(arguments.OrderDetailId) />
		<cfset setPlanId(arguments.PlanId) />
		<cfset setCarrierPlanId(arguments.CarrierPlanId) />
		<cfset setPlanType(arguments.PlanType) />
		<cfset setCarrierPlanType(arguments.CarrierPlanType) />
		<cfset setNewMDN(arguments.NewMDN) />
		<cfset setESN(arguments.ESN) />
		<cfset setIMEI(arguments.IMEI) />
		<cfset setCurrentMDN(arguments.CurrentMDN) />
		<cfset setCurrentCarrier(arguments.CurrentCarrier) />
		<cfset setIsMDNPort(arguments.IsMDNPort) />
		<cfset setPortRequestId(arguments.PortRequestId) />
		<cfset setPortResponse(arguments.PortResponse) />
		<cfset setPortStatus(arguments.PortStatus) />
		<cfset setNPArequested(arguments.NPArequested) />
        <cfset setIsNPArequested(arguments.IsNPArequested) />
		<cfset setUpgradeEligible(arguments.UpgradeEligible) />
		<cfset setRequestedActivationDate(arguments.RequestedActivationDate) />
		<cfset setCarrierReferenceId1(arguments.CarrierReferenceId1) />
		<cfset setCarrierReferenceId2(arguments.CarrierReferenceId2) />
		<cfset setCarrierReferenceId3(arguments.CarrierReferenceId3) />
		<cfset setPortInDueDate(arguments.PortInDueDate) />
		<cfset setContractLength(arguments.ContractLength) />
		<cfset setMonthlyFee(arguments.MonthlyFee) />
		<cfset setMarketCode(arguments.MarketCode) />
		<cfset setLineDevice(arguments.LineDevice) />
		<cfset setLineRateplan(arguments.LineRateplan) />
		<cfset setLineServices(arguments.LineServices) />
		<cfset setLineAccessories(arguments.LineAccessories) />
		<cfset setLineWarranty(arguments.LineWarranty) />
		<cfset setSim(arguments.Sim) />
		<cfset setActivationStatus(arguments.ActivationStatus) />
		<cfset setActivationFee(arguments.ActivationFee) />
		<cfset setPortInCurrentCarrier(arguments.PortInCurrentCarrier)>
        <cfset setPortInCurrentCarrierPin(arguments.PortInCurrentCarrierPin)>
        <cfset setPortInCurrentCarrierAccountNumber(arguments.PortInCurrentCarrierAccountNumber)>
        <cfset setPrepaidAccountNumber(arguments.PrepaidAccountNumber)>
		<cfset setCurrentImei(arguments.CurrentImei)>
		<cfset setIsPrepaid(arguments.IsPrepaid)>

		<cfset setIsDirty(arguments.IsDirty) /> <!--- TRV: this should ALWAYS be the last setter called in this init method --->
		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->

	<cffunction name="setMemento" access="public" returntype="cfc.model.WirelessLine" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public"returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setStepInstance" access="public" output="false" returntype="void"
		hint="Populates bean data. Useful to popluate the bean in steps.<br/>
		Throws: rethrows any caught exceptions">
		<cfargument name="data" type="struct" required="true" />
		<cfset var i = "" />

		<cftry>
			<cfloop from="1" to="#arrayLen(variables.beanFieldArr)#" index="i">
				<cfif StructKeyExists(arguments.data, variables.beanFieldArr[i])>
					<cfinvoke method="set#variables.beanFieldArr[i]#">
						<cfinvokeargument name="#variables.beanFieldArr[i]#" value="#arguments.data[variables.beanFieldArr[i]]#" />
					</cfinvoke>
				</cfif>
			</cfloop>
			<cfcatch type="any">
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="validate" access="public" returntype="errorHandler" output="false">
	</cffunction>

	<cffunction name="isDateNull" access="public" output="false" returntype="boolean">
		<cfargument name="date" type="date" required="true">
		<cfif dateFormat(arguments.date,"mmddyyyy") eq dateFormat(variables.nullDateTime,"mmddyyyy")>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="load" access="public" output="false" returntype="void">
		<cfargument name="id" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				WirelessLineId
			,	OrderDetailId
			,	PlanId
			,	CarrierPlanId
			,	PlanType
			,	CarrierPlanType
			,	NewMDN
			,	ESN
			,	IMEI
			,	CurrentMDN
			,	CurrentCarrier
			,	IsMDNPort
			,	PortRequestId
			,	PortResponse
			,	PortStatus
			,	IsNPArequested
            ,	NPArequested
			,	UpgradeEligible
			,	RequestedActivationDate
			,	CarrierReferenceId1
			,	CarrierReferenceId2
			,	CarrierReferenceId3
			,	PortInDueDate
			,	ContractLength
			,	MonthlyFee
			,	MarketCode
			,	Sim
			,	ActivationStatus
			,	ActivationFee
            ,   PortInCurrentCarrier
            ,   PortInCurrentCarrierPin
            ,   PortInCurrentCarrierAccountNumber
			,	PrepaidAccountNumber
			, 	IsPrepaid
			, 	CurrentImei
			FROM SalesOrder.WirelessLine
			WHERE WirelessLineId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
		</cfquery>
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.WirelessLineId))) this.setWirelessLineId(local.qLoad.WirelessLineId);
				if (len(trim(local.qLoad.OrderDetailId))) this.setOrderDetailId(local.qLoad.OrderDetailId);
				if (len(trim(local.qLoad.PlanId))) this.setPlanId(local.qLoad.PlanId);
				if (len(trim(local.qLoad.CarrierPlanId))) this.setCarrierPlanId(local.qLoad.CarrierPlanId);
				if (len(trim(local.qLoad.PlanType))) this.setPlanType(local.qLoad.PlanType);
				if (len(trim(local.qLoad.CarrierPlanType))) this.setCarrierPlanType(local.qLoad.CarrierPlanType);
				if (len(trim(local.qLoad.NewMDN))) this.setNewMDN(local.qLoad.NewMDN);
				if (len(trim(local.qLoad.ESN))) this.setESN(local.qLoad.ESN);
				if (len(trim(local.qLoad.IMEI))) this.setIMEI(local.qLoad.IMEI);
				if (len(trim(local.qLoad.CurrentMDN))) this.setCurrentMDN(local.qLoad.CurrentMDN);
				if (len(trim(local.qLoad.CurrentCarrier))) this.setCurrentCarrier(local.qLoad.CurrentCarrier);
				if (len(trim(local.qLoad.IsMDNPort))) this.setIsMDNPort(local.qLoad.IsMDNPort);
				if (len(trim(local.qLoad.PortRequestId))) this.setPortRequestId(local.qLoad.PortRequestId);
				if (len(trim(local.qLoad.PortResponse))) this.setPortResponse(local.qLoad.PortResponse);
				if (len(trim(local.qLoad.PortStatus))) this.setPortStatus(local.qLoad.PortStatus);
				if (len(trim(local.qLoad.IsNPArequested))) this.setIsNPArequested(local.qLoad.IsNPArequested);
				if (len(trim(local.qLoad.NPArequested))) this.setNPArequested(local.qLoad.NPArequested);
				if (len(trim(local.qLoad.UpgradeEligible))) this.setUpgradeEligible(local.qLoad.UpgradeEligible);
				if (len(trim(local.qLoad.RequestedActivationDate))) this.setRequestedActivationDate(local.qLoad.RequestedActivationDate);
				if (len(trim(local.qLoad.CarrierReferenceId1))) this.setCarrierReferenceId1(local.qLoad.CarrierReferenceId1);
				if (len(trim(local.qLoad.CarrierReferenceId2))) this.setCarrierReferenceId2(local.qLoad.CarrierReferenceId2);
				if (len(trim(local.qLoad.CarrierReferenceId3))) this.setCarrierReferenceId3(local.qLoad.CarrierReferenceId3);
				if (len(trim(local.qLoad.PortInDueDate))) this.setPortInDueDate(local.qLoad.PortInDueDate);
				if (len(trim(local.qLoad.ContractLength))) this.setContractLength(local.qLoad.ContractLength);
				if (len(trim(local.qLoad.MonthlyFee))) this.setMonthlyFee(local.qLoad.MonthlyFee);
				if (len(trim(local.qLoad.MarketCode))) this.setMarketCode(local.qLoad.MarketCode);
				if (len(trim(local.qLoad.Sim))) this.setSim(local.qLoad.Sim);
				if (len(trim(local.qLoad.ActivationStatus))) this.setActivationStatus(local.qLoad.ActivationStatus);
				if (len(trim(local.qLoad.ActivationFee))) this.setActivationFee(local.qLoad.ActivationFee);
				if (len(trim(local.qLoad.PortInCurrentCarrier))) this.setPortInCurrentCarrier(local.qLoad.PortInCurrentCarrier);
				if (len(trim(local.qLoad.PortInCurrentCarrierPin))) this.setPortInCurrentCarrierPin(local.qLoad.PortInCurrentCarrierPin);				
				if (len(trim(local.qLoad.PortInCurrentCarrierAccountNumber))) this.setPortInCurrentCarrierAccountNumber(local.qLoad.PortInCurrentCarrierAccountNumber);				
				if (len(trim(local.qLoad.PrepaidAccountNumber))) this.setPrepaidAccountNumber(local.qLoad.PrepaidAccountNumber);
				if (len(trim(local.qLoad.IsPrepaid))) this.setIsPrepaid(local.qLoad.IsPrepaid);
				if (len(trim(local.qLoad.CurrentImei))) this.setCurrentImei(local.qLoad.CurrentImei);
				
				local.OrderId = this.getParentOrderIdByWirelessLineId(WirelessLineId=this.getWirelessLineId());
				if (local.OrderId) this.setOrderId(local.OrderId);
			}
			else
			{
				this = createObject("component","cfc.model.WirelessLine").init();
			}
		</cfscript>

		<cfset local.od = createObject('component','cfc.model.OrderDetail').init()>
		<cfset local.aDevice = local.od.getByWirelessLineIdAndOrderDetailType(WirelessLineId=this.getWirelessLineId(),OrderDetailType="d")>
		<cfif arrayLen(local.aDevice)>
			<cfset this.setLineDevice(local.aDevice[1])>
			<!--- TRV: moving this here so we'll now associate the WirelessLine record to the device instead of the rateplan (since there isn't always a rateplan) --->
			<cfset this.setOrderDetailId(this.getLineDevice().getOrderDetailId())>
		</cfif>

		<cfset local.od2 = createObject('component','cfc.model.OrderDetail').init()>
		<cfset local.aRateplan = local.od2.getByWirelessLineIdAndOrderDetailType(WirelessLineId=this.getWirelessLineId(), OrderDetailType="r")>
		<cfif arrayLen(local.aRateplan)>
			<cfset this.setLineRateplan(local.aRateplan[1])>
		</cfif>

		<cfset this.setLineServices(local.od.getByWirelessLineIdAndOrderDetailType(WirelessLineId=this.getWirelessLineId(), OrderDetailType="s"))>
		<cfset this.setLineAccessories(local.od.getByWirelessLineIdAndOrderDetailType(WirelessLineId=this.getWirelessLineId(), OrderDetailType="a"))>

		<cfset local.aWarranty = local.od2.getByWirelessLineIdAndOrderDetailType(WirelessLineId=this.getWirelessLineId(), OrderDetailType="w")>
		<cfif arrayLen(local.aWarranty)>
			<cfset this.setLineWarranty(local.aWarranty[1]) />
		</cfif>

		<cfset this.setIsDirty(false) />
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var channelConfig = application.wirebox.getInstance("ChannelConfig") >
		<cfset var local = structNew()>
		
		<!--- save linedevice --->
		<cfif this.getLineDevice().getIsDirty() and this.getLineDevice().getOrderId() neq this.getOrderId()>
			<cfset this.getLineDevice().setOrderId(this.getOrderId())>
		</cfif>
		<cfset this.getLineDevice().save()>
		<!--- TRV: moving this here to associate the WirelessLine to the device instead of to the rateplan --->
		<cfif this.getOrderDetailId() neq this.getLineDevice().getOrderDetailId()>
			<cfset this.setOrderDetailId(this.getLineDevice().getOrderDetailId())>
		</cfif>

		<!--- save linerateplan --->
		<cfif this.getLineRateplan().getIsDirty() and this.getLineRateplan().getOrderId() neq this.getOrderId()>
			<cfset this.getLineRateplan().setOrderId(this.getOrderId())>
		</cfif>
		<cfset this.getLineRateplan().save()>

		<!--- save lineservices --->
		<cfif arrayLen(this.getLineServices())>
			<cfset local.a = this.getLineServices()>
			<cfloop from="1" to="#arrayLen(local.a)#" index="local.i">
				<cfif local.a[local.i].getIsDirty() and local.a[local.i].getOrderId() neq this.getOrderId()>
					<cfset local.a[local.i].setOrderId(this.getOrderId())>
				</cfif>
				<!--- Check for whether TMO and if so, go through  GetDataCommissionSku to update service--->
				<cfif application.model.checkoutHelper.getCarrier() eq 128 and (isDefined('variables.deviceActivationType'))><!---Preventing second save of same service and potentially messing up commission sku--->
					<cfset local.serviceGersSku=local.a[local.i].getGersSku()>
					<cfset local.deviceGersSku=this.getLineDevice().getGersSku() >
					<cfset local.deviceActivation = variables.deviceActivationType >
					<cfif local.deviceActivation contains "New">
						<cfset local.deviceActivation = "FNew">
					<cfelseif local.deviceActivation contains "Upgrade">
						<cfset local.deviceActivation = "FUpgrade">
					<cfelse>
						<cfset local.deviceActivation = "FAddaline">
					</cfif>				
				 	<cfset CommissionSku = application.model.CheckoutHelper.GetDataCommissionSku( 
						application.model.checkoutHelper.getCarrier()
						, local.deviceGersSku
						, local.serviceGersSku
						, local.deviceActivation
						) />
					<cfset local.a[local.i].setGersSku(CommissionSku) />
				</cfif>
				<cfset local.a[local.i].save()>
			</cfloop>
		</cfif>

		<!--- save lineaccessories --->
		<cfif arrayLen(this.getLineAccessories())>
			<cfset local.a = this.getLineAccessories()>
			<cfloop from="1" to="#arrayLen(local.a)#" index="local.i">
				<cfif local.a[local.i].getIsDirty() and local.a[local.i].getOrderId() neq this.getOrderId()>
					<cfset local.a[local.i].setOrderId(this.getOrderId())>
				</cfif>
				<cfset local.a[local.i].save()>            
			</cfloop>
		</cfif>

		<!--- save warranty --->
		<cfif this.getLineWarranty().getIsDirty() and this.getLineWarranty().getOrderId() neq this.getOrderId()>
			<cfset this.getLineWarranty().setOrderId(this.getOrderId()) />
		</cfif>
		<cfset this.getLineWarranty().save() />
        
		<cfif not this.getWirelessLineId() and this.getIsDirty()>
            
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO SalesOrder.WirelessLine (
					OrderDetailId
				,	PlanId
				,	CarrierPlanId
				,	PlanType
				,	CarrierPlanType
				,	NewMDN
				,	ESN
				,	IMEI
				,	CurrentMDN
				,	CurrentCarrier
				,	IsMDNPort
				,	PortRequestId
				,	PortResponse
				,	PortStatus
                ,	IsNPArequested
				,	NPArequested
				,	UpgradeEligible
				,	RequestedActivationDate
				,	CarrierReferenceId1
				,	CarrierReferenceId2
				,	CarrierReferenceId3
				,	PortInDueDate
				,	ContractLength
				,	MonthlyFee
				,	MarketCode
                ,	SIM
                ,	ActivationStatus
                ,	ActivationFee
                , 	PortInCurrentCarrier
                ,   PortInCurrentCarrierPin
                ,   PortInCurrentCarrierAccountNumber
				,	PrepaidAccountNumber
				,	IsPrepaid
				,	CurrentImei
				) 
				VALUES
				(
					<cfif len(trim(this.getOrderDetailId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderDetailId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getPlanId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getPlanId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCarrierPlanId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierPlanId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getPlanType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPlanType()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCarrierPlanType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierPlanType()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getNewMDN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getNewMDN()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getESN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getESN()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getIMEI()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getIMEI()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCurrentMDN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCurrentMDN()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCurrentCarrier()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getCurrentCarrier()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getIsMDNPort()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsMDNPort()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getPortRequestId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortRequestId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getPortResponse()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortResponse()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getPortStatus()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortStatus()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getIsNPArequested()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsNPArequested()#"><cfelse>NULL</cfif>
                ,	<cfif len(trim(this.getNPArequested()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getNPArequested()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getUpgradeEligible()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getUpgradeEligible()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getRequestedActivationDate())) and not isDateNull(this.getRequestedActivationDate())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getRequestedActivationDate())#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCarrierReferenceId1()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierReferenceId1()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCarrierReferenceId2()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierReferenceId2()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCarrierReferenceId3()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierReferenceId3()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getPortInDueDate())) and not isDateNull(this.getPortInDueDate())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getPortInDueDate())#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getContractLength()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getContractLength()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getMonthlyFee()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getMonthlyFee()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getMarketCode()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMarketCode()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getSim()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSim()#"><cfelse>NULL</cfif>
				,	<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getActivationStatus()#">
				,	<cfif len(trim(this.getActivationFee()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getActivationFee()#"><cfelse>NULL</cfif>
                ,	<cfif len(trim(this.getPortInCurrentCarrier()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortInCurrentCarrier()#"><cfelse>NULL</cfif>
                ,	<cfif len(trim(this.getPortInCurrentCarrierPin()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortInCurrentCarrierPin()#"><cfelse>NULL</cfif>                
                ,	<cfif len(trim(this.getPortInCurrentCarrierAccountNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortInCurrentCarrierAccountNumber()#"><cfelse>NULL</cfif>                
                ,	<cfif len(trim(this.getPrepaidAccountNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPrepaidAccountNumber()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getIsPrepaid()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsPrepaid()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCurrentImei()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCurrentImei()#"><cfelse>NULL</cfif>
				)
			</cfquery>
			<cfset this.setWirelessLineId(local.saveResult.identitycol)>
                        
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE SalesOrder.WirelessLine
				SET
					OrderDetailId = <cfif len(trim(this.getOrderDetailId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderDetailId()#"><cfelse>NULL</cfif>
					,	PlanId = <cfif len(trim(this.getPlanId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getPlanId()#"><cfelse>NULL</cfif>
					,	CarrierPlanId = <cfif len(trim(this.getCarrierPlanId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierPlanId()#"><cfelse>NULL</cfif>
					,	PlanType = <cfif len(trim(this.getPlanType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPlanType()#"><cfelse>NULL</cfif>
					,	CarrierPlanType = <cfif len(trim(this.getCarrierPlanType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierPlanType()#"><cfelse>NULL</cfif>
					,	NewMDN = <cfif len(trim(this.getNewMDN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getNewMDN()#"><cfelse>NULL</cfif>
					,	ESN = <cfif len(trim(this.getESN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getESN()#"><cfelse>NULL</cfif>
					,	IMEI = <cfif len(trim(this.getIMEI()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getIMEI()#"><cfelse>NULL</cfif>
					,	CurrentMDN = <cfif len(trim(this.getCurrentMDN()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCurrentMDN()#"><cfelse>NULL</cfif>
					,	CurrentCarrier = <cfif len(trim(this.getCurrentCarrier()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getCurrentCarrier()#"><cfelse>NULL</cfif>
					,	IsMDNPort = <cfif len(trim(this.getIsMDNPort()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsMDNPort()#"><cfelse>NULL</cfif>
					,	PortRequestId = <cfif len(trim(this.getPortRequestId()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortRequestId()#"><cfelse>NULL</cfif>
					,	PortResponse = <cfif len(trim(this.getPortResponse()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortResponse()#"><cfelse>NULL</cfif>
					,	PortStatus = <cfif len(trim(this.getPortStatus()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortStatus()#"><cfelse>NULL</cfif>
					,	IsNPArequested = <cfif len(trim(this.getIsNPArequested()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsNPArequested()#"><cfelse>NULL</cfif>
	                ,	NPArequested = <cfif len(trim(this.getNPArequested()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getNPArequested()#"><cfelse>NULL</cfif>
					,	UpgradeEligible = <cfif len(trim(this.getUpgradeEligible()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getUpgradeEligible()#"><cfelse>NULL</cfif>
					,	RequestedActivationDate = <cfif len(trim(this.getRequestedActivationDate())) and not isDateNull(this.getRequestedActivationDate())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getRequestedActivationDate())#"><cfelse>NULL</cfif>
					,	CarrierReferenceId1 = <cfif len(trim(this.getCarrierReferenceId1()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierReferenceId1()#"><cfelse>NULL</cfif>
					,	CarrierReferenceId2 = <cfif len(trim(this.getCarrierReferenceId2()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierReferenceId2()#"><cfelse>NULL</cfif>
					,	CarrierReferenceId3 = <cfif len(trim(this.getCarrierReferenceId3()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCarrierReferenceId3()#"><cfelse>NULL</cfif>
					,	PortInDueDate = <cfif len(trim(this.getPortInDueDate())) and not isDateNull(this.getPortInDueDate())><cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDateTime(this.getPortInDueDate())#"><cfelse>NULL</cfif>
					,	ContractLength = <cfif len(trim(this.getContractLength()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getContractLength()#"><cfelse>NULL</cfif>
					,	MonthlyFee = <cfif len(trim(this.getMonthlyFee()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getMonthlyFee()#"><cfelse>NULL</cfif>
					,	MarketCode = <cfif len(trim(this.getMarketCode()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMarketCode()#"><cfelse>NULL</cfif>
					,	SIM = <cfif len(trim(this.getSim()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSim()#"><cfelse>NULL</cfif>
					,	ActivationStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getActivationStatus()#">
					,	ActivationFee = <cfqueryparam cfsqltype="cf_sql_money" value="#this.getActivationFee()#">
					,	PortInCurrentCarrier = <cfif len(trim(this.getPortInCurrentCarrier()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortInCurrentCarrier()#"><cfelse>NULL</cfif>
	                ,	PortInCurrentCarrierPin = <cfif len(trim(this.getPortInCurrentCarrierPin()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortInCurrentCarrierPin()#"><cfelse>NULL</cfif>
	                ,	PortInCurrentCarrierAccountNumber = <cfif len(trim(this.getPortInCurrentCarrierAccountNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPortInCurrentCarrierAccountNumber()#"><cfelse>NULL</cfif>
					,	PrepaidAccountNumber = <cfif len(trim(this.getPrepaidAccountNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPrepaidAccountNumber()#"><cfelse>NULL</cfif>
					,	IsPrepaid = <cfif len(trim(this.getIsPrepaid()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsPrepaid()#"><cfelse>NULL</cfif>
					,	CurrentImei = <cfif len(trim(this.getCurrentImei()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCurrentImei()#"><cfelse>NULL</cfif>
				WHERE
					WirelessLineId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getWirelessLineId()#" />
			</cfquery>
		</cfif>

		<cfset this.load(this.getWirelessLineId())>
	</cffunction>

	<cffunction name="populateFromCartLine" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="cfc.model.CartLine" required="true" />
		<cfargument name="lineNumber" type="numeric" required="true" />
        <cfargument name="zipCode" type="string" required="true" />
		<cfargument name="isPrepaid" type="boolean" default="false" required="false" />
		<cfargument name="carrierId" type="numeric" default="0" required="false" />
		<cfargument name="cartPlanIdCount" type="numeric" default="1" required="false" />

		<cfset var local = {} />
		<cfset local.zipcode = arguments.zipcode />
		
		<cfset local.phone = arguments.cartLine.getPhone() />
		
		<!--- get the plan for this cart line --->
		<cfset local.p = arguments.cartLine.getPlan() />
		<cfset local.pProduct = application.model.Plan.getByFilter(idList=local.p.getProductId()) /> 
	
		<cfif local.pProduct.recordCount>
			<!--- populate the WirelessLine object --->
			<cfset this.setPlanId( local.p.getProductId() ) />
			<cfset this.setPlanType( local.pProduct.planType ) />
			<cfset this.setIsPrepaid( arguments.IsPrepaid ) />
            
            <!--- MAC: get the Carrier BillCode from the plan, doing this as a query because Zipcode is introduced and I do not want to break plan.getByFilter() --->
            <cfquery name="local.GetCarrierRatePlanBillingCode" datasource="#application.dsn.wirelessAdvocates#">
				SELECT [catalog].[GetWirelessLineCarrierPlanId]( 
							'#local.phone.getDeviceServiceType()#'
							,'#local.phone.getGersSku()#'
							,#local.p.getProductID()# 
						) AS carrierbillcode
            </cfquery>

            <cfif local.GetCarrierRatePlanBillingCode.RecordCount gt 0>
            	<cfset this.setCarrierPlanId(local.GetCarrierRatePlanBillingCode.carrierbillcode)>
            </cfif>
            
            <!--- set the market --->
            <cfquery name="local.GetWirelessLineMarket" datasource="#application.dsn.wirelessAdvocates#">
                select m.CarrierMarketCode
                from catalog.Market m
                join catalog.ZipCodeMarket zm on zm.MarketGuid = m.MarketGuid
                where
                    zm.ZipCode = '#local.zipcode#'
                    and m.CarrierGuid = '#local.pProduct.CarrierGUID#'
            </cfquery>

            <cfif local.GetWirelessLineMarket.recordcount gt 0>
            	<cfset this.setMarketCode(local.GetWirelessLineMarket.CarrierMarketCode)>
            </cfif>
			<!--- end set the market --->

			<!--- <cfset this.setCurrentCarrier(local.pProduct.carrierName)>  TODO: Delete this? Data type conflict? --->

			<cfset mrcArgs = {
					productId = getPlanId(),
					lineNumber = arguments.lineNumber,
					carrierId = arguments.carrierId,
					cartPlanIDCount = arguments.cartPlanIdCount
				}>		
			<cfset this.setMonthlyFee(application.model.Plan.getMonthlyFee(argumentCollection = mrcArgs))>
			
			
			<!--- create and populate the rateplan OrderDetail object --->
			<cfset local.odDevice = createObject('component','cfc.model.OrderDetail').init()>
			<cfset local.odDevice.populateFromCartLineRateplan(cartLine=arguments.cartLine,lineNumber=arguments.lineNumber)>
			<cfset this.setLineRateplan(local.odDevice)>
		</cfif>

		<cfset this.setRequestedActivationDate(now())> <!--- TODO - verify that this it correct --->
		
		<cfset deviceActivationType =  arguments.cartLine.getCartLineActivationType()>
		<cfif deviceActivationType contains 'financed'>
			<cfif deviceActivationType contains '12'>
				<cfset this.setContractLength(12)>
			<cfelseif deviceActivationType contains '18' >
				<cfset this.setContractLength(18)>
			<cfelse>
				<cfset this.setContractLength(24)>
			</cfif>
		<cfelse>
			<cfset this.setContractLength(24)>
		</cfif>
		
		<cfset this.setActivationFee( application.model.Carrier.getActivationFee( arguments.CarrierId, arguments.lineNumber ))>

		<!--- TRV: moving the following out of the condition above on local.pProduct.recordCount --->
		<!--- this is to allow equipment-only upgrade to have required services without an associated rate plan --->

		<!--- create and populate the array of service OrderDetail objects --->
		<cfset local.aServices = arrayNew(1)>
		<cfloop from="1" to="#arrayLen(arguments.cartLine.getFeatures())#" index="local.i">
			<cfset local.odService = createObject('component','cfc.model.OrderDetail').init()>
			<cfset local.odService.populateFromCartLineService(cartLine=arguments.cartLine,lineNumber=arguments.lineNumber,serviceNumber=local.i)>
			<cfif local.odService.getIsDirty()>
				<cfset arrayAppend(local.aServices,local.odService)>
			</cfif>
		</cfloop>
		<cfset this.setLineServices(local.aServices)>

		<!--- TRV: moving the following out of the condition above on local.pProduct.recordCount --->
		<!--- this might have been the culprit in prepaid orders since there's no rateplan --->

		<!--- create and populate the device OrderDetail object --->
		<cfset local.odDevice = createObject('component','cfc.model.OrderDetail').init()>
		<cfset local.odDevice.populateFromCartLineDevice(cartLine=arguments.cartLine,lineNumber=arguments.lineNumber)>
		<cfset this.setLineDevice(local.odDevice)>


		<!--- create and populate the warranty OrderDetail object --->
		<cfset local.odWarranty = createObject('component','cfc.model.OrderDetail').init()>
		<cfset local.odWarranty.populateFromCartLineWarranty(cartLine=arguments.cartLine,lineNumber=arguments.lineNumber)>
		<cfset this.setLineWarranty(local.odWarranty)>

		<!--- TRV: in order to address issues with the WirelessLine object when there's no rateplan, we'll associated the WirelessLine to the Device record instead (since we know that one always exists) --->
		<cfset this.setOrderDetailId(local.odDevice.getOrderDetailId())>


		<!--- create and populate the array of accessory OrderDetail objects --->
		<cfset local.aAccessories = arrayNew(1)>
		<cfloop from="1" to="#arrayLen(arguments.cartLine.getAccessories())#" index="local.i">
			<cfset local.odAccessory = createObject('component','cfc.model.OrderDetail').init()>
			<cfset local.odAccessory.populateFromCartLineAccessory(cartLine=arguments.cartLine,lineNumber=arguments.lineNumber,accessoryNumber=local.i)>
			<cfif local.odAccessory.getIsDirty()>
				<cfset arrayAppend(local.aAccessories,local.odAccessory)>
			</cfif>
		</cfloop>
		<cfset this.setLineAccessories(local.aAccessories)>

	</cffunction>

	<cffunction name="getByOrderId" access="public" output="false" returntype="cfc.model.WirelessLine[]">
		<cfargument name="OrderId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.a = arrayNew(1)>
		
		<cfquery name="local.qGet" datasource="#application.dsn.wirelessAdvocates#">
			SELECT DISTINCT
				wl.WirelessLineId
			,	od.GroupNumber
			,	od.OrderDetailId
			FROM
				SalesOrder.OrderDetail od
				inner join SalesOrder.WirelessLine wl
					on od.OrderDetailId = wl.OrderDetailId
			WHERE
				od.OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OrderId#">
			ORDER BY
				od.GroupNumber, od.OrderDetailId asc
		</cfquery>
		<cfloop query="local.qGet">
			<cfset local.o = createobject('component','cfc.model.WirelessLine').init()>
			<cfset local.o.load(local.qGet.WirelessLineId[local.qGet.currentRow])>
			<cfset arrayAppend(local.a,local.o)>
		</cfloop>
		<cfreturn local.a>
	</cffunction>

	<cffunction name="getParentOrderIdByWirelessLineId" access="public" output="false" returntype="numeric">
		<cfargument name="WirelessLineId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.OrderId = 0>
		
		<cfquery name="local.qGet" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				od.OrderId
			FROM
				SalesOrder.OrderDetail od
				inner join SalesOrder.WirelessLine wl
					on od.OrderDetailId = wl.OrderDetailId
			WHERE
				wl.WirelessLineId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WirelessLineId#">
		</cfquery>
		<cfif local.qGet.recordCount>
			<cfset local.OrderId = local.qGet.OrderId>
		</cfif>
		<cfreturn local.OrderId>
	</cffunction>


	<cffunction name="getActivationStatusName" access="public" output="false" returntype="string">
		<cfscript>
			var activationStatusName = "";		
			
			switch( variables.instance.ActivationStatus )
			{
				case 0:
				{
					activationStatusName = "Ready";
					break;
				}
				case 1:
				{
					activationStatusName = "Requested";
					break;
				}
				case 2:
				{
					activationStatusName = "Success";
					break;
				}
				case 3:
				{
					activationStatusName = "Partial Success";
					break;
				}
				case 4:
				{
					activationStatusName = "Failure";
					break;
				}
				case 5:
				{
					activationStatusName = "Error";
					break;
				}
				case 6:
				{
					activationStatusName = "Manual";
					break;
				}
				case 7:
				{
					activationStatusName = "Canceled";
					break;
				}											
				default:
				{
					activationStatusName = "";
					break;
				}
			}
		</cfscript>	

		<cfreturn activationStatusName />
	</cffunction>
	
	<cffunction name="getWirelessLineByOrder" output="false" access="public" returntype="query">
		<cfargument name="orderId" type="numeric" required="true" />
		<cfset var channelConfig = application.wirebox.getInstance("ChannelConfig") />
		<cfset var qWirelesslines = '' />

		<cfquery name="qWirelesslines" datasource="#application.dsn.wirelessAdvocates#">
			SELECT o.orderid
				, wl.IMEI
				, wl.SIM
				, wa.FirstName
				, wa.LastName
				, wl.CurrentMDN
				, o.orderDate
				, wl.WirelessLineId
				, wl.NewMDN
				, od.PurchaseType
				,o.CarrierId
			FROM [salesorder].[order] o
			INNER JOIN [salesorder].[orderdetail] od ON o.orderid = od.orderid
			INNER JOIN [salesorder].[wirelessAccount] wa ON o.orderid = wa.orderid
			LEFT OUTER JOIN [salesorder].[wirelessLine] wl ON od.orderDetailId = wl.orderDetailId
			WHERE o.ScenarioId = 2
			AND WirelessLineId IS NOT NULL 
			AND o.OrderID = <cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_integer" />
			ORDER BY WirelessLineId
		</cfquery>

		<cfreturn qWirelesslines />
	</cffunction>

	<!--- ACCESSORS --->

	<cffunction name="setWirelessLineId" access="public" returntype="void" output="false">
		<cfargument name="WirelessLineId" type="numeric" required="true" />
		<cfset variables.instance.WirelessLineId = trim(arguments.WirelessLineId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getWirelessLineId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.WirelessLineId />
	</cffunction>

	<cffunction name="setOrderId" access="public" returntype="void" output="false">
		<cfargument name="OrderId" type="numeric" required="true" />
		<cfset variables.instance.OrderId = trim(arguments.OrderId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderId />
	</cffunction>

	<cffunction name="setOrderDetailId" access="public" returntype="void" output="false">
		<cfargument name="OrderDetailId" type="numeric" required="true" />
		<cfset variables.instance.OrderDetailId = trim(arguments.OrderDetailId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderDetailId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderDetailId />
	</cffunction>

	<cffunction name="setPlanId" access="public" returntype="void" output="false">
		<cfargument name="PlanId" type="numeric" required="true" />
		<cfset variables.instance.PlanId = trim(arguments.PlanId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPlanId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.PlanId />
	</cffunction>

	<cffunction name="setCarrierPlanId" access="public" returntype="void" output="false">
		<cfargument name="CarrierPlanId" type="string" required="true" />
		<cfset variables.instance.CarrierPlanId = trim(arguments.CarrierPlanId) />
        
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierPlanId" access="public" returntype="string" output="false">      
        <cfreturn variables.instance.CarrierPlanId />
	</cffunction>
    
    

	<cffunction name="setPlanType" access="public" returntype="void" output="false">
		<cfargument name="PlanType" type="string" required="true" />
		<cfset variables.instance.PlanType = trim(arguments.PlanType) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPlanType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PlanType />
	</cffunction>

	<cffunction name="setCarrierPlanType" access="public" returntype="void" output="false">
		<cfargument name="CarrierPlanType" type="string" required="true" />
		<cfset variables.instance.CarrierPlanType = trim(arguments.CarrierPlanType) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierPlanType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierPlanType />
	</cffunction>

	<cffunction name="setNewMDN" access="public" returntype="void" output="false">
		<cfargument name="NewMDN" type="string" required="true" />
		<cfset variables.instance.NewMDN = trim(arguments.NewMDN) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getNewMDN" access="public" returntype="string" output="false">
		<cfreturn variables.instance.NewMDN />
	</cffunction>

	<cffunction name="setESN" access="public" returntype="void" output="false">
		<cfargument name="ESN" type="string" required="true" />
		<cfset variables.instance.ESN = trim(arguments.ESN) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getESN" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ESN />
	</cffunction>

	<cffunction name="setIMEI" access="public" returntype="void" output="false">
		<cfargument name="IMEI" type="string" required="true" />
		<cfset variables.instance.IMEI = trim(arguments.IMEI) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getIMEI" access="public" returntype="string" output="false">
		<cfreturn variables.instance.IMEI />
	</cffunction>

	<cffunction name="setCurrentMDN" access="public" returntype="void" output="false">
		<cfargument name="CurrentMDN" type="string" required="true" />
		<cfset variables.instance.CurrentMDN = trim(arguments.CurrentMDN) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCurrentMDN" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CurrentMDN />
	</cffunction>


	<cffunction name="setCurrentCarrier" access="public" returntype="void" output="false">
		<cfargument name="CurrentCarrier" type="numeric" required="true" />
		<cfset variables.instance.CurrentCarrier = trim(arguments.CurrentCarrier) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCurrentCarrier" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.CurrentCarrier />
	</cffunction>


	<cffunction name="setIsMDNPort" access="public" returntype="void" output="false">
		<cfargument name="IsMDNPort" type="boolean" required="true" />
		<cfset variables.instance.IsMDNPort = trim(arguments.IsMDNPort) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getIsMDNPort" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsMDNPort />
	</cffunction>

	<cffunction name="setPortRequestId" access="public" returntype="void" output="false">
		<cfargument name="PortRequestId" type="string" required="true" />
		<cfset variables.instance.PortRequestId = trim(arguments.PortRequestId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPortRequestId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PortRequestId />
	</cffunction>

	<cffunction name="setPortResponse" access="public" returntype="void" output="false">
		<cfargument name="PortResponse" type="string" required="true" />
		<cfset variables.instance.PortResponse = trim(arguments.PortResponse) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPortResponse" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PortResponse />
	</cffunction>

	<cffunction name="setPortStatus" access="public" returntype="void" output="false">
		<cfargument name="PortStatus" type="string" required="true" />
		<cfset variables.instance.PortStatus = trim(arguments.PortStatus) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPortStatus" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PortStatus />
	</cffunction>

	<cffunction name="setIsNPArequested" access="public" returntype="void" output="false">
		<cfargument name="IsNPArequested" type="boolean" required="true" />
		<cfset variables.instance.IsNPArequested = trim(arguments.IsNPArequested) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getIsNPArequested" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsNPArequested />
	</cffunction>
    
    <cffunction name="setNPArequested" access="public" returntype="void" output="false">
		<cfargument name="NPArequested" type="string" required="true" />
		<cfset variables.instance.NPArequested = trim(arguments.NPArequested) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getNPArequested" access="public" returntype="string" output="false">
		<cfreturn variables.instance.NPArequested />
	</cffunction>

	<cffunction name="setUpgradeEligible" access="public" returntype="void" output="false">
		<cfargument name="UpgradeEligible" type="boolean" required="true" />
		<cfset variables.instance.UpgradeEligible = trim(arguments.UpgradeEligible) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getUpgradeEligible" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.UpgradeEligible />
	</cffunction>

	<cffunction name="setRequestedActivationDate" access="public" returntype="void" output="false">
		<cfargument name="RequestedActivationDate" type="date" required="true" />
		<cfset variables.instance.RequestedActivationDate = trim(arguments.RequestedActivationDate) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getRequestedActivationDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.RequestedActivationDate />
	</cffunction>

	<cffunction name="setCarrierReferenceId1" access="public" returntype="void" output="false">
		<cfargument name="CarrierReferenceId1" type="string" required="true" />
		<cfset variables.instance.CarrierReferenceId1 = trim(arguments.CarrierReferenceId1) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierReferenceId1" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierReferenceId1 />
	</cffunction>

	<cffunction name="setCarrierReferenceId2" access="public" returntype="void" output="false">
		<cfargument name="CarrierReferenceId2" type="string" required="true" />
		<cfset variables.instance.CarrierReferenceId2 = trim(arguments.CarrierReferenceId2) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierReferenceId2" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierReferenceId2 />
	</cffunction>

	<cffunction name="setCarrierReferenceId3" access="public" returntype="void" output="false">
		<cfargument name="CarrierReferenceId3" type="string" required="true" />
		<cfset variables.instance.CarrierReferenceId3 = trim(arguments.CarrierReferenceId3) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierReferenceId3" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierReferenceId3 />
	</cffunction>

	<cffunction name="setPortInDueDate" access="public" returntype="void" output="false">
		<cfargument name="PortInDueDate" type="date" required="true" />
		<cfset variables.instance.PortInDueDate = trim(arguments.PortInDueDate) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPortInDueDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.PortInDueDate />
	</cffunction>

	<cffunction name="setContractLength" access="public" returntype="void" output="false">
		<cfargument name="ContractLength" type="numeric" required="true" />
		<cfset variables.instance.ContractLength = trim(arguments.ContractLength) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getContractLength" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ContractLength />
	</cffunction>

	<cffunction name="setMonthlyFee" access="public" returntype="void" output="false">
		<cfargument name="MonthlyFee" type="numeric" required="true" />
		<cfset variables.instance.MonthlyFee = trim(arguments.MonthlyFee) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getMonthlyFee" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.MonthlyFee />
	</cffunction>

	<cffunction name="setMarketCode" access="public" returntype="void" output="false">
		<cfargument name="MarketCode" type="string" required="true" />
		<cfset variables.instance.MarketCode = trim(arguments.MarketCode) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getMarketCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.MarketCode />
	</cffunction>

	<cffunction name="setLineDevice" access="public" returntype="void" output="false">
		<cfargument name="LineDevice" type="cfc.model.OrderDetail" required="true" />
		<cfset variables.instance.LineDevice = arguments.LineDevice />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLineDevice" access="public" returntype="cfc.model.OrderDetail" output="false">
		<cfreturn variables.instance.LineDevice />
	</cffunction>

	<cffunction name="setLineRateplan" access="public" returntype="void" output="false">
		<cfargument name="LineRateplan" type="cfc.model.OrderDetail" required="true" />
		<cfset variables.instance.LineRateplan = arguments.LineRateplan />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLineRateplan" access="public" returntype="cfc.model.OrderDetail" output="false">
		<cfreturn variables.instance.LineRateplan />
	</cffunction>

	<cffunction name="setLineServices" access="public" returntype="void" output="false">
		<cfargument name="LineServices" type="cfc.model.OrderDetail[]" required="true" />
		<cfset variables.instance.LineServices = arguments.LineServices />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLineServices" access="public" returntype="cfc.model.OrderDetail[]" output="false">
		<cfreturn variables.instance.LineServices />
	</cffunction>

	<cffunction name="setLineAccessories" access="public" returntype="void" output="false">
		<cfargument name="LineAccessories" type="cfc.model.OrderDetail[]" required="true" />
		<cfset variables.instance.LineAccessories = arguments.LineAccessories />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLineAccessories" access="public" returntype="cfc.model.OrderDetail[]" output="false">
		<cfreturn variables.instance.LineAccessories />
	</cffunction>

	<cffunction name="setLineWarranty" access="public" returntype="void" output="false">
		<cfargument name="LineWarranty" type="cfc.model.OrderDetail" required="true" />
		<cfset variables.instance.LineWarranty = arguments.LineWarranty />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLineWarranty" access="public" returntype="cfc.model.OrderDetail" output="false">
		<cfreturn variables.instance.LineWarranty />
	</cffunction>
	
	<cffunction name="setSim" access="public" returntype="void" output="false">
		<cfargument name="Sim" type="string" required="true" />
		<cfset variables.instance.Sim = arguments.Sim />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getSim" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Sim />
	</cffunction>
	
	<cffunction name="setActivationStatus" access="public" returntype="void" output="false">
		<cfargument name="ActivationStatus" type="string" required="true" />
		<cfset variables.instance.ActivationStatus = arguments.ActivationStatus />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivationStatus" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ActivationStatus />
	</cffunction>

	<cffunction name="setActivationFee" access="public" returntype="void" output="false">
		<cfargument name="ActivationFee" type="numeric" required="true" />
		<cfset variables.instance.ActivationFee = arguments.ActivationFee />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivationFee" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ActivationFee />
	</cffunction>
    
    
    
    <cffunction name="setPortInCurrentCarrier" access="public" returntype="void" output="false">
		<cfargument name="PortInCurrentCarrier" type="string" required="true" />
		<cfset variables.instance.PortInCurrentCarrier = arguments.PortInCurrentCarrier />
	</cffunction>
	<cffunction name="getPortInCurrentCarrier" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PortInCurrentCarrier />
	</cffunction>
    
    <cffunction name="setPortInCurrentCarrierPin" access="public" returntype="void" output="false">
		<cfargument name="PortInCurrentCarrierPin" type="string" required="true" />
		<cfset variables.instance.PortInCurrentCarrierPin = arguments.PortInCurrentCarrierPin />
	</cffunction>
	<cffunction name="getPortInCurrentCarrierPin" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PortInCurrentCarrierPin />
	</cffunction>
    
    
    <cffunction name="setPortInCurrentCarrierAccountNumber" access="public" returntype="void" output="false">
		<cfargument name="PortInCurrentCarrierAccountNumber" type="string" required="true" />
		<cfset variables.instance.PortInCurrentCarrierAccountNumber = arguments.PortInCurrentCarrierAccountNumber />
	</cffunction>
	<cffunction name="getPortInCurrentCarrierAccountNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PortInCurrentCarrierAccountNumber />
	</cffunction>

    <cffunction name="setPrepaidAccountNumber" access="public" returntype="void" output="false">
		<cfargument name="PrepaidAccountNumber" type="string" required="true" />
		<cfset variables.instance.PrepaidAccountNumber = arguments.PrepaidAccountNumber />
	</cffunction>
	<cffunction name="getPrepaidAccountNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PrepaidAccountNumber />
	</cffunction>
	
    <cffunction name="setCurrentImei" access="public" returntype="void" output="false">
		<cfargument name="CurrentImei" type="string" required="true" />
		<cfset variables.instance.CurrentImei = arguments.CurrentImei />
	</cffunction>
	<cffunction name="getCurrentImei" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CurrentImei />
	</cffunction>	
	
    <cffunction name="setIsPrepaid" access="public" returntype="void" output="false">
		<cfargument name="IsPrepaid" type="string" required="true" />
		<cfset variables.instance.IsPrepaid = arguments.IsPrepaid />
	</cffunction>
	<cffunction name="getIsPrepaid" access="public" returntype="string" output="false">
		<cfreturn variables.instance.IsPrepaid />
	</cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>

	<!--- DUMP --->

	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="FALSE" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

	<!--- GETINSTANCE --->

	<cffunction name="getInstanceData" access="public" output="false" return="struct">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfset var local = structNew()>
		<cfset local.instance = duplicate(variables.instance)>

		<cfif arguments.recursive>
			<cfloop collection="#local.instance#" item="local.key">
				<cfif not isSimpleValue(local.instance[local.key])>
					<cfif isArray(local.instance[local.key])>
						<cfloop from="#1#" to="#arrayLen(local.instance[local.key])#" index="local.ii">
							<cfset local.instance[local.key][local.ii] = local.instance[local.key][local.ii].getInstanceData(arguments.recursive)>
						</cfloop>
					<cfelseif structKeyExists(local.instance[local.key],"getInstanceData")>
						<cfset local.instance[local.key] = local.instance[local.key].getInstanceData(arguments.recursive)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>

		<cfreturn local.instance>
	</cffunction>

</cfcomponent>