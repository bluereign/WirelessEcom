<cfcomponent displayname="OrderDetail" output="false">

	<cfset variables.instance = StructNew() />
	<!--- Required for setStepInstance() --->
	<cfset variables.beanFieldArr = ListToArray("OrderDetailId|OrderDetailType|OrderId|GroupNumber|GroupName|ProductId|GersSku|ProductTitle|PartNumber|Qty|COGS|RetailPrice|NetPrice|Weight|TotalWeight|Taxable|TaxState|Taxes|Message|Shipment|LineService", "|") />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0)>

	<!--- INITIALIZATION / CONFIGURATION --->

	<cffunction name="init" access="public" returntype="cfc.model.OrderDetail" output="false">
		<cfargument name="OrderDetailId" type="numeric" required="false" default="0" />
		<cfargument name="OrderDetailType" type="string" required="false" default="" />
		<cfargument name="OrderId" type="numeric" required="false" default="0" />
		<cfargument name="GroupNumber" type="numeric" required="false" default="0" />
		<cfargument name="GroupName" type="string" required="false" default="" />
		<cfargument name="ProductId" type="numeric" required="false" default="0" />
		<cfargument name="GersSku" type="string" required="false" default="" />
		<cfargument name="ProductTitle" type="string" required="false" default="" />
		<cfargument name="PartNumber" type="string" required="false" default="" />
		<cfargument name="Qty" type="numeric" required="false" default="0" />
		<cfargument name="COGS" type="numeric" required="false" default="0" />
		<cfargument name="RetailPrice" type="numeric" required="false" default="0" />
		<cfargument name="NetPrice" type="numeric" required="false" default="0" />
		<cfargument name="Weight" type="numeric" required="false" default="0" />
		<cfargument name="TotalWeight" type="numeric" required="false" default="0" />
		<cfargument name="Taxable" type="boolean" required="false" default="false" />
		<cfargument name="Taxes" type="numeric" required="false" default="0" />
		<cfargument name="Message" type="string" required="false" default="" />
		<cfargument name="Shipment" type="cfc.model.Shipment" required="false" default="#createObject('component','cfc.model.Shipment').init()#" />
<!--- 		<cfargument name="WirelessLine" type="cfc.model.WirelessLine" required="false" default="#createObject('component','cfc.model.WirelessLine').init()#" /> --->
		<cfargument name="LineService" type="cfc.model.LineService" required="false" default="#createObject('component','cfc.model.LineService').init()#" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />
		<cfargument name="RmaNumber" type="string" required="false" default="" />
		<cfargument name="RmaStatus" type="numeric" required="false" default="0" />
		<cfargument name="RmaReason" type="string" required="false" default="" />
		<cfargument name="Rebate" type="numeric" required="false" default="0" />
		<cfargument name="DiscountTotal" type="numeric" required="false" default="0" />
		<cfargument name="PurchaseType" type="string" required="false" default="" />
		<cfargument name="DownPaymentReceived" type="numeric" required="false" default="0.00" />
		
		<!--- run setters --->
		<cfset setOrderDetailId(arguments.OrderDetailId) />
		<cfset setOrderDetailType(arguments.OrderDetailType) />
		<cfset setOrderId(arguments.OrderId) />
		<cfset setGroupNumber(arguments.GroupNumber) />
		<cfset setGroupName(arguments.GroupName) />
		<cfset setProductId(arguments.ProductId) />
		<cfset setGersSku(arguments.GersSku) />
		<cfset setProductTitle(arguments.ProductTitle) />
		<cfset setPartNumber(arguments.PartNumber) />
		<cfset setQty(arguments.Qty) />
		<cfset setCOGS(arguments.COGS) />
		<cfset setRetailPrice(arguments.RetailPrice) />
		<cfset setNetPrice(arguments.NetPrice) />
		<cfset setWeight(arguments.Weight) />
		<cfset setTotalWeight(arguments.TotalWeight) />
		<cfset setTaxable(arguments.Taxable) />
		<cfset setTaxes(arguments.Taxes) />
		<cfset setMessage(arguments.Message) />
		<cfset setShipment(arguments.Shipment) />
<!--- 		<cfset setWirelessLine(arguments.WirelessLine) /> --->
		<cfset setLineService(arguments.LineService) />
		<cfset setRmaNumber(arguments.RmaNumber) />
		<cfset setRmaStatus(arguments.RmaStatus) />
		<cfset setRmaReason(arguments.RmaReason) />
		<cfset setRebate(arguments.Rebate) />
		<cfset setDiscountTotal(arguments.DiscountTotal) />
		<cfset setPurchaseType(arguments.PurchaseType) />
		<cfset setDownPaymentReceived(arguments.DownPaymentReceived) />

		<cfset setIsDirty(arguments.IsDirty) /> <!--- TRV: this should ALWAYS be the last setter called in this init method --->
			
		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->



	<cffunction name="setMemento" access="public" returntype="cfc.model.OrderDetail" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>

	<cffunction name="getMemento" access="public"returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="setStepInstance" access="public" output="false" returntype="void"
		hint="Populates bean data. Useful to popluate the bean in steps.<br/>
		Throws: rethrows any caught exceptions"
	>
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
				OrderDetailId
			,	OrderDetailType
			,	OrderId
			,	GroupNumber
			,	GroupName
			,	ProductId
			,	GersSku
			,	ProductTitle
			,	PartNumber
			,	Qty
			,	COGS
			,	RetailPrice
			,	NetPrice
			,	Weight
			,	TotalWeight
			,	Taxable
			,	Taxes
			,	Message
			,	ShipmentId
			,	RmaNumber
			,	RmaStatus
			,	RmaReason
			,	Rebate
			,	DiscountTotal
			,	PurchaseType
			,	DownPaymentReceived
			FROM
				SalesOrder.OrderDetail
			WHERE
				OrderDetailId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
		</cfquery>
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.OrderDetailId))) this.setOrderDetailId(local.qLoad.OrderDetailId);
				if (len(trim(local.qLoad.OrderDetailType))) this.setOrderDetailType(local.qLoad.OrderDetailType);
				if (len(trim(local.qLoad.OrderId))) this.setOrderId(local.qLoad.OrderId);
				if (len(trim(local.qLoad.GroupNumber))) this.setGroupNumber(local.qLoad.GroupNumber);
				if (len(trim(local.qLoad.GroupName))) this.setGroupName(local.qLoad.GroupName);
				if (len(trim(local.qLoad.ProductId))) this.setProductId(local.qLoad.ProductId);
				if (len(trim(local.qLoad.GersSku))) this.setGersSku(local.qLoad.GersSku);
				if (len(trim(local.qLoad.ProductTitle))) this.setProductTitle(local.qLoad.ProductTitle);
				if (len(trim(local.qLoad.PartNumber))) this.setPartNumber(local.qLoad.PartNumber);
				if (len(trim(local.qLoad.Qty))) this.setQty(local.qLoad.Qty);
				if (len(trim(local.qLoad.COGS))) this.setCOGS(local.qLoad.COGS);
				if (len(trim(local.qLoad.RetailPrice))) this.setRetailPrice(local.qLoad.RetailPrice);
				if (len(trim(local.qLoad.NetPrice))) this.setNetPrice(local.qLoad.NetPrice);
				if (len(trim(local.qLoad.Weight))) this.setWeight(local.qLoad.Weight);
				if (len(trim(local.qLoad.TotalWeight))) this.setTotalWeight(local.qLoad.TotalWeight);
				if (len(trim(local.qLoad.Taxable))) this.setTaxable(local.qLoad.Taxable);
				if (len(trim(local.qLoad.Taxes))) this.setTaxes(local.qLoad.Taxes);
				if (len(trim(local.qLoad.Message))) this.setMessage(local.qLoad.Message);
				if (len(trim(local.qLoad.ShipmentId))) this.getShipment().load(local.qLoad.ShipmentId);
				if (len(trim(local.qLoad.RmaNumber))) this.setRmaNumber(local.qLoad.RmaNumber);
				if (len(trim(local.qLoad.RmaStatus))) this.setRmaStatus(local.qLoad.RmaStatus);
				if (len(trim(local.qLoad.RmaReason))) this.setRmaReason(local.qLoad.RmaReason);
				if (len(trim(local.qLoad.Rebate))) this.setRebate(local.qLoad.Rebate);
				if (len(trim(local.qLoad.DiscountTotal))) this.setDiscountTotal(local.qLoad.DiscountTotal);	
				if (len(trim(local.qLoad.PurchaseType))) this.setPurchaseType(local.qLoad.PurchaseType);
				if (len(trim(local.qLoad.DownPaymentReceived))) this.setDownPaymentReceived(local.qLoad.DownPaymentReceived);
			}
			else
			{
				this = createObject("component","cfc.model.OrderDetail").init();
			}
		</cfscript>

		<!--- get lineservice item --->
		<cfset local.ls = createObject('component','cfc.model.LineService').init() />
		<cfset local.ls = local.ls.getByOrderDetailId( this.getOrderDetailId() ) />
		
		<cfif local.ls.getLineServiceId()>
			<cfset this.setLineService(local.ls)>
		</cfif>

		<cfset this.setIsDirty(false)>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="void">
		<cfset var local = structNew()>

		<!--- save the shipment --->
		<cfset this.getShipment().save()>

		<cfif not this.getOrderDetailId() and this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				INSERT INTO SalesOrder.OrderDetail (
					OrderDetailType
				,	OrderId
				,	GroupNumber
				,	GroupName
				,	ProductId
				,	GersSku
				,	ProductTitle
				,	PartNumber
				,	Qty
				,	COGS
				,	RetailPrice
				,	NetPrice
				,	Weight
				,	TotalWeight
				,	Taxable
				,	Taxes
				,	Message
				,	ShipmentId
				,	RmaNumber
				,	RmaStatus
				,	RmaReason
				,	Rebate
				,	PurchaseType
				,	DownPaymentReceived
				) VALUES (
					<cfif len(trim(this.getOrderDetailType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getOrderDetailType()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getOrderId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getGroupNumber()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getGroupNumber()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getGroupName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getGroupName()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getProductId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getProductId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getGersSku()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getGersSku()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getProductTitle()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getProductTitle()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getPartNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPartNumber()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getQty()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getQty()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getCOGS()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getCOGS()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getRetailPrice()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getRetailPrice()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getNetPrice()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getNetPrice()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getWeight()))><cfqueryparam cfsqltype="cf_sql_float" value="#this.getWeight()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getTotalWeight()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getTotalWeight()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getTaxable()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getTaxable()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getTaxes()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getTaxes()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getMessage()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMessage()#"><cfelse>NULL</cfif>
				,	<cfif this.getShipment().getIsDirty()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getShipment().getShipmentId()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getRmaNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getRmaNumber()#"><cfelse>NULL</cfif>
				,	<cfif len(trim(this.getRmaStatus()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getRmaStatus()#"><cfelse>0</cfif>
				,	<cfif len(trim(this.getRmaReason()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getRmaReason()#"><cfelse>NULL</cfif>
				,	<cfqueryparam cfsqltype="cf_sql_money" value="#decimalFormat(this.getRebate())#" null="#!len(getRebate())#" /> 	
				,	<cfif len(trim(this.getPurchaseType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPurchaseType()#"><cfelse>NULL</cfif>		
				,	<cfif len(trim(this.getDownPaymentReceived()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDownPaymentReceived()#"><cfelse>NULL</cfif>		
				)
			</cfquery>
			<cfset this.setOrderDetailId(local.saveResult.identitycol)>
		<cfelseif this.getIsDirty()>
			<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
				UPDATE SalesOrder.OrderDetail SET
					OrderDetailType = <cfif len(trim(this.getOrderDetailType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getOrderDetailType()#"><cfelse>NULL</cfif>
				,	OrderId = <cfif len(trim(this.getOrderId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#"><cfelse>NULL</cfif>
				,	GroupNumber = <cfif len(trim(this.getGroupNumber()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getGroupNumber()#"><cfelse>NULL</cfif>
				,	GroupName = <cfif len(trim(this.getGroupName()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getGroupName()#"><cfelse>NULL</cfif>
				,	ProductId = <cfif len(trim(this.getProductId()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getProductId()#"><cfelse>NULL</cfif>
				,	GersSku = <cfif len(trim(this.getGersSku()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getGersSku()#"><cfelse>NULL</cfif>
				,	ProductTitle = <cfif len(trim(this.getProductTitle()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getProductTitle()#"><cfelse>NULL</cfif>
				,	PartNumber = <cfif len(trim(this.getPartNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPartNumber()#"><cfelse>NULL</cfif>
				,	Qty = <cfif len(trim(this.getQty()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getQty()#"><cfelse>NULL</cfif>
				,	COGS = <cfif len(trim(this.getCOGS()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getCOGS()#"><cfelse>NULL</cfif>
				,	RetailPrice = <cfif len(trim(this.getRetailPrice()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getRetailPrice()#"><cfelse>NULL</cfif>
				,	NetPrice = <cfif len(trim(this.getNetPrice()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getNetPrice()#"><cfelse>NULL</cfif>
				,	Weight = <cfif len(trim(this.getWeight()))><cfqueryparam cfsqltype="cf_sql_float" value="#this.getWeight()#"><cfelse>NULL</cfif>
				,	TotalWeight = <cfif len(trim(this.getTotalWeight()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getTotalWeight()#"><cfelse>NULL</cfif>
				,	Taxable = <cfif len(trim(this.getTaxable()))><cfqueryparam cfsqltype="cf_sql_bit" value="#this.getTaxable()#"><cfelse>NULL</cfif>
				,	Taxes = <cfif len(trim(this.getTaxes()))><cfqueryparam cfsqltype="cf_sql_money" value="#this.getTaxes()#"><cfelse>NULL</cfif>
				,	Message = <cfif len(trim(this.getMessage()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMessage()#"><cfelse>NULL</cfif>
				,	ShipmentId = <cfif this.getShipment().getIsDirty()><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getShipment().getShipmentId()#"><cfelse>NULL</cfif>
				,	RmaNumber = <cfif len(trim(this.getRmaNumber()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getRmaNumber()#"><cfelse>NULL</cfif>
				,	RmaStatus = <cfif len(trim(this.getRmaStatus()))><cfqueryparam cfsqltype="cf_sql_integer" value="#this.getRmaStatus()#"><cfelse>0</cfif>
				,	RmaReason = <cfif len(trim(this.getRmaReason()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getRmaReason()#"><cfelse>NULL</cfif>
				,	Rebate = <cfqueryparam cfsqltype="cf_sql_money" value="#decimalFormat(this.getRebate())#" null="#!len(getRebate())#" />
				,	PurchaseType = <cfif len(trim(this.getPurchaseType()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPurchaseType()#"><cfelse>NULL</cfif>
				,	DownPaymentReceived = <cfif len(trim(this.getDownPaymentReceived()))><cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDownPaymentReceived()#"><cfelse>NULL</cfif>
				WHERE
					OrderDetailId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderDetailId()#">
			</cfquery>
		</cfif>

		<!--- save the lineservice if needed (TRV: but only save the actual services, skip the null objects that might be there for non-services) --->
		<cfif this.getOrderDetailType() eq "s" and ( this.getIsDirty() or this.getLineService().getIsDirty() ) and this.getLineService().getOrderDetailId() neq this.getOrderDetailId()>
			<cfset this.getLineService().setOrderDetailId(this.getOrderDetailId()) />
		</cfif>
		<cfset this.getLineService().save()>

		<cfset this.load(this.getOrderDetailId())>
	</cffunction>

	<cffunction name="populateFromCartLineDevice" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="cfc.model.CartLine" required="true">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfset var local = structNew()>
		
		<!--- get the device --->
		<cfset local.d = arguments.cartLine.getPhone()>
		<cfset local.dProduct = application.model.Phone.getByFilter( idList=local.d.getProductId(), allowHidden = true ) />		
		<cfif not local.dProduct.recordCount>
			<cfset local.dProduct = application.model.Tablet.getByFilter( idList=local.d.getProductId(), allowHidden = true ) />
		</cfif>
		<cfif not local.dProduct.recordCount>
			<cfset local.dProduct = application.model.DataCardAndNetbook.getByFilter( idList=local.d.getProductId(), allowHidden = true ) />
		</cfif>
		<cfif not local.dProduct.recordCount>
			<cfset local.dProduct = application.model.PrePaid.getByFilter( idList=local.d.getProductId(), allowHidden = true) />
		</cfif>
		
		<!--- get the downpayment --->
		<cfset local.prices = arguments.cartLine.getPrices() />
		<cfset local.downPaymentReceived = local.prices.getDownPaymentAmount() /> 

		<cfif local.dProduct.recordCount>
			<!--- populate the object --->
			<cfset this.setOrderDetailType('d')>
			<cfset this.setGroupNumber(arguments.lineNumber)>
			<cfset this.setGroupName("Line #arguments.lineNumber#")>
			<cfif len(trim(arguments.cartLine.getAlias()))>
				<cfset this.setGroupName(arguments.cartLine.getAlias())>
			</cfif>
			<cfset this.setProductId(local.d.getProductId())>
			<cfset this.setGersSku(local.dProduct.GersSku)>
			<cfset this.setProductTitle(local.dProduct.detailTitle)>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setRebate( getInstantRebateService().getQualifyingAmt( cartLine = arguments.cartLine ) )>
			
			<cfset this.setCOGS(local.d.getPrices().getCOGS())>
			<cfset this.setRetailPrice(local.dProduct.price_retail)>
			<!--- Handling for financed phones --->
			<cfset deviceActivationType =  arguments.cartLine.getCartLineActivationType()>
			<cfif deviceActivationType contains 'financed'>			
				<cfset this.setPurchaseType("FP")/>
				<cfset this.setNetPrice(0)>
				<!--- Done Per ASeltzer to accomodate DD Gers DB issues --->
				<cfset product = createObject('component', 'cfc.model.product').init() />
				<cfset product.getProduct(local.d.getProductId())>
				<cfset this.setRetailPrice(product.getFinancedFullRetailPrice())/>
			<cfelse>
				<cfset this.setPurchaseType("C2")/>
				<cfset this.setNetPrice(local.d.getPrices().getDueToday() - this.getRebate())>
			</cfif>	
			<cfset this.setWeight(0)> <!--- TODO - set this using the specs available in the new catalog schema --->
			<cfset this.setTotalWeight(0)> <!--- TODO - set this using the specs available in the new catalog schema --->
			<cfset this.setTaxable(true)> <!--- TODO: Is everything taxable ? --->
			<cfset this.setTaxes( local.d.getTaxes().getDueToday() )> <!--- TODO - set this later based on the results from the 3rd party tax service --->
			<!---<cfset this.setMessage('')>---> <!--- TODO - not sure what value to populate this with --->
		</cfif>
	</cffunction>

	<cffunction name="populateFromCartLineRateplan" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="cfc.model.CartLine" required="true">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfset var local = structNew()>

		<!--- get the rateplan --->
		<cfset local.p = arguments.cartLine.getPlan() />
		<cfset local.pProduct = application.model.Plan.getByFilter(idList=local.p.getProductId()) />
		<cfset local.DeviceType = arguments.cartLine.getPhone().getDeviceServiceType() />
		<cfset local.Cart = arguments.cartLine.getCart() />
		
		<!--- get the device --->
		<cfset local.phone = arguments.cartLine.getPhone() />

		<cfif local.pProduct.recordCount>
			<!--- populate the object --->
			<cfset this.setOrderDetailType('r')>
			<cfset this.setGroupNumber(arguments.lineNumber)>
			<cfset this.setGroupName("Line #arguments.lineNumber#")>
			<cfif len(trim(arguments.cartLine.getAlias()))>
				<cfset this.setGroupName(arguments.cartLine.getAlias())>
			</cfif>
			<cfset this.setProductId(local.p.getProductId())>
			
			
			<!---translate activation types--->
			<cfset cartLineActivationType = arguments.cartLine.getCartLineActivationType() />
			<cfif cartLineActivationType contains 'financed'>
			
			<cfscript>
				
				switch(cartLineActivationType)
					{
					
						case 'financed-12-new':
							local.mappedActivationType = 'FNew';
							local.ratePlanLength = 12;
						break;	
						case 'financed-12-upgrade':
							local.mappedActivationType = 'FUpgrade';
							local.ratePlanLength = 12;
						break;							
						
						case 'financed-12-addaline':
							local.mappedActivationType = 'FAddaline';
							local.ratePlanLength = 12;
						break;
						case 'financed-18-new':
							local.mappedActivationType = 'FNew';
							local.ratePlanLength = 18;
						break;	
						case 'financed-18-upgrade':
							local.mappedActivationType = 'FUpgrade';
							local.ratePlanLength = 18;
						break;							
						
						case 'financed-18-addaline':
							local.mappedActivationType = 'FAddaline';
							local.ratePlanLength = 18;
						break;
						case 'financed-24-new':
							local.mappedActivationType = 'FNew';
							local.ratePlanLength = 24;
						break;	
						case 'financed-24-upgrade':
							local.mappedActivationType = 'FUpgrade';
							local.ratePlanLength = 24;
						break;							
						case 'financed-24-addaline':
							local.mappedActivationType = 'FAddaline';
							local.ratePlanLength = 24;
						break;											
					}
			</cfscript>	
			<cfelse>
						<cfset	local.mappedActivationType = arguments.cartline.getCartLineActivationType()>
						<cfset	local.ratePlanLength = 0>
			</cfif>	
			
			<cfset this.setGersSku(
				application.model.Plan.getPlanGersSku( 
					ProductId = local.p.getProductId(), 
					LineNumber = arguments.lineNumber, 
					DeviceType = local.DeviceType,
					CarrierId = local.pProduct.carrierId,
					CartPlanIdCount = arguments.cartLine.getPlanIDCount(),
					DeviceSKU = local.phone.getGersSKU(),
					ActivationType = local.mappedActivationType,
					RatePlanLength = local.ratePlanLength
					)
				)>
			<cfset this.setProductTitle(local.pProduct.detailTitle)>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setCOGS(0)> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setRetailPrice(0)> <!--- setting to 0 based on request from Doug/Ron --->
			<cfset this.setNetPrice(0)> <!--- setting to 0 based on request from Doug/Ron --->
			<cfset this.setWeight(0)>
			<cfset this.setTotalWeight(0)>
			<cfset this.setTaxable(true)>
			<cfset this.setTaxes(0)> <!--- TODO - set this later based on the results from the 3rd party tax service --->
			<!---<cfset this.setMessage('')>---> <!--- TODO - not sure what value to populate this with --->
		</cfif>
	</cffunction>

	<cffunction name="populateFromCartLineService" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="cfc.model.CartLine" required="true">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfargument name="serviceNumber" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartServices = arguments.cartLine.getFeatures()>
		<cfset local.cartService = local.cartServices[arguments.serviceNumber]>
		<cfset local.createOrderDetail = false />

		<!--- get the service --->
		<cfset local.s = local.cartService>

		<cfset local.sProduct = application.model.Feature.getByProductId(local.s.getProductId())>
		<cfif local.sProduct.recordCount>
			<cfset local.GersSku = local.sProduct.GersSku />
			<cfset local.ProductTitle = local.sProduct.summaryTitle />
			<cfset local.createOrderDetail = true />
		</cfif>

		<cfif local.createOrderDetail>
			<!--- populate the object --->
			<cfset this.setOrderDetailType('s')>
			<cfset this.setGroupNumber(arguments.lineNumber)>
			<cfset this.setGroupName("Line #arguments.lineNumber#")>
			<cfif len(trim(arguments.cartLine.getAlias()))>
				<cfset this.setGroupName(arguments.cartLine.getAlias())>
			</cfif>
			<cfset this.setProductId(local.s.getProductId())>
			<cfset this.setGersSku( local.GersSku )>
			<cfset this.setProductTitle( local.ProductTitle )>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setCOGS(0)> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setRetailPrice(0)> <!--- setting to 0 based on request from Doug/Ron --->
			<cfset this.setNetPrice(0)> <!--- setting to 0 based on request from Doug/Ron --->
			<cfset this.setWeight(0)>
			<cfset this.setTotalWeight(0)>
			<cfset this.setTaxable(true)>
			<cfset this.setTaxes(0)> <!--- TODO - set this later based on the results from the 3rd party tax service --->
			<!---<cfset this.setMessage('')>---> <!--- TODO - not sure what value to populate this with --->
	
			<cfset local.lineService = createObject('component','cfc.model.LineService').init()>
			<cfset local.lineService.populateFromCartLineService(cartLine=arguments.cartLine,lineNumber=arguments.lineNumber,serviceNumber=arguments.serviceNumber)>
			<cfif local.lineService.getIsDirty()>
				<cfset this.setLineService(local.lineService)>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="populateFromCartLineAccessory" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="cfc.model.CartLine" required="true">
		<cfargument name="lineNumber" type="numeric" required="true">
		<cfargument name="accessoryNumber" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartAccessories = arguments.cartLine.getAccessories()>
		<cfset local.cartAccessory = local.cartAccessories[arguments.accessoryNumber]>

		<!--- get the accessory --->
		<cfset local.a = local.cartAccessory>
		<cfset local.aProduct = application.model.Accessory.getByFilter(idList=local.a.getProductId())>

		<cfif local.aProduct.recordCount>
			<!--- populate the object --->
			<cfset this.setOrderDetailType('a')>
			<cfset this.setGroupNumber(arguments.lineNumber)>
			<cfset this.setGroupName("Line #arguments.lineNumber#")>
			<cfif len(trim(arguments.cartLine.getAlias()))>
				<cfset this.setGroupName(arguments.cartLine.getAlias())>
			</cfif>
			<cfset this.setProductId(local.a.getProductId())>
			<cfset this.setGersSku(local.aProduct.GersSku)>
			<cfset this.setProductTitle(local.aProduct.summaryTitle)>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setCOGS(local.a.getPrices().getCOGS())>
			<cfset this.setRetailPrice(local.aProduct.price)>
			<cfset this.setNetPrice(local.aProduct.price)>
			<cfset this.setWeight(0)>
			<cfset this.setTotalWeight(0)>
			<cfset this.setTaxable(true)>
			<cfset this.setTaxes( local.a.getTaxes().getDueToday() )>
			<!---<cfset this.setMessage('')>---> <!--- TODO - not sure what value to populate this with --->
		</cfif>
	</cffunction>

	<cffunction name="populateFromCartLineWarranty" access="public" output="false" returntype="void">
		<cfargument name="cartLine" type="cfc.model.CartLine" required="true" />
		<cfargument name="lineNumber" type="numeric" required="true" />
		<cfset var local = {}>

		<!--- get the Warranty --->
		<cfset local.w = arguments.cartLine.getWarranty() />
		<cfset local.wProduct = application.model.Warranty.getById( local.w.getProductId() ) />

		<cfif local.wProduct.recordCount>
			<!--- populate the object --->
			<cfset this.setOrderDetailType('w')>
			<cfset this.setGroupNumber(arguments.lineNumber)>
			<cfset this.setGroupName("Line #arguments.lineNumber#")>
			<cfif len(trim(arguments.cartLine.getAlias()))>
				<cfset this.setGroupName(arguments.cartLine.getAlias())>
			</cfif>
			<cfset this.setProductId(local.w.getProductId())>
			<cfset this.setGersSku(local.wProduct.GersSku)>
			<cfset this.setProductTitle(local.wProduct.SummaryTitle)>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setRetailPrice(local.wProduct.Price)>
			<cfset this.setNetPrice(local.w.getPrices().getDueToday())>
			<cfset this.setWeight(0)> <!--- TODO - set this using the specs available in the new catalog schema --->
			<cfset this.setTotalWeight(0)> <!--- TODO - set this using the specs available in the new catalog schema --->
			<cfset this.setTaxable(true)> <!--- TODO: Is everything taxable ? --->
			<cfset this.setTaxes( local.w.getTaxes().getDueToday() )> <!--- TODO - set this later based on the results from the 3rd party tax service --->
			<!---<cfset this.setMessage('')>---> <!--- TODO - not sure what value to populate this with --->
		</cfif>
	</cffunction>

	<cffunction name="populateFromCartOtherItems" access="public" output="false" returntype="void">
		<cfargument name="otherItemsIndex" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.cartItems = session.cart.getOtherItems()>
		<cfset local.cartItem = local.cartItems[arguments.otherItemsIndex]>

		<!--- get the item --->
		<cfset local.i = local.cartItem>
		
		<cfif local.i.getType() eq "accessory">
			<cfset local.iProduct = application.model.Accessory.getByFilter(idList=local.i.getProductId()) />
			<cfset this.setOrderDetailType('a') />
		<cfelseif local.i.getType() eq "prepaid">
			<cfset local.iProduct = application.model.PrePaid.getByFilter(idList=local.i.getProductId()) />
			<cfset this.setOrderDetailType('u') />
            <cfset this.setGersSku(local.i.getGersSKU()) />
			<cfset this.setProductTitle(local.i.getTitle()) />
        <cfelseif local.i.getType() eq "upgrade">
			<cfset local.iProduct = application.model.PrePaid.getByFilter(idList=local.i.getProductId())>
			<cfset this.setOrderDetailType('u')>
            <cfset this.setGroupNumber(request.config.otherItemsLineNumber)>
			<cfset this.setGroupName("Additional Items")>
			<cfset this.setProductId(0)>
            <cfset this.setGersSku(local.i.getGersSKU())>
			<cfset this.setProductTitle(local.i.getTitle())>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setCOGS(0)>
			<cfset this.setRetailPrice(0)>
			<cfset this.setNetPrice(local.i.getPrices().getDueToday())>
			<cfset this.setWeight(0)>
			<cfset this.setTotalWeight(0)>
			<cfset this.setTaxable(false)>
			<cfset this.setTaxes(0)>
			<!---<cfset this.setMessage('')>---> 
        <cfelseif local.i.getType() eq "addaline">
			<cfset local.iProduct = application.model.PrePaid.getByFilter(idList=local.i.getProductId())>
			<cfset this.setOrderDetailType('u')>
            <cfset this.setGroupNumber(request.config.otherItemsLineNumber)>
			<cfset this.setGroupName("Additional Items")>
			<cfset this.setProductId(0)>
            <cfset this.setGersSku(local.i.getGersSKU())>
			<cfset this.setProductTitle(local.i.getTitle())>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setCOGS(0)>
			<cfset this.setRetailPrice(0)>
			<cfset this.setNetPrice(local.i.getPrices().getDueToday())>
			<cfset this.setWeight(0)>
			<cfset this.setTotalWeight(0)>
			<cfset this.setTaxable(false)>
			<cfset this.setTaxes(0)>
			<!---<cfset this.setMessage('')>---> 
            
        <cfelseif local.i.getType() eq "deposit">
			<cfset this.setOrderDetailType('b')>
            <cfset this.setGroupNumber(request.config.otherItemsLineNumber)>
			<cfset this.setGroupName("Additional Items")>
			<cfset this.setProductId(0)>
            
            <cfquery name="local.getGERSDepositSKU" datasource="#application.dsn.wirelessAdvocates#">
                SELECT [catalog].[GetDepositGersSku] (128) as SKU
            </cfquery>
            <cfif local.getGERSDepositSKU.recordcount gt 0>
                <cfset this.setGersSku(local.getGERSDepositSKU.SKU)>
            <cfelse>
                <cfset this.setGersSku("")>
            </cfif>
            
			<cfset this.setProductTitle(local.i.getTitle())>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setCOGS(0)>
			<cfset this.setRetailPrice(0)>
			<cfset this.setNetPrice(local.i.getPrices().getDueToday())>
			<cfset this.setWeight(0)>
			<cfset this.setTotalWeight(0)>
			<cfset this.setTaxable(false)>
			<cfset this.setTaxes(0)>
			<!---<cfset this.setMessage('')>---> <!--- TODO - not sure what value to populate this with --->
		</cfif>
        
        
	
		<cfif isDefined("local.iProduct") and local.iProduct.recordCount>
        	
        
			<!--- populate the object --->
			<cfset this.setGroupNumber(request.config.otherItemsLineNumber)>
			<cfset this.setGroupName("Additional Items")>
			<cfset this.setProductId(local.i.getProductId())>
			<cfset this.setGersSku(local.iProduct.GersSku)>
			<cfset this.setProductTitle(local.iProduct.summaryTitle)>
			<cfset this.setPartNumber('000000000')> <!--- TODO - not sure what value to populate this with --->
			<cfset this.setQty(1)>
			<cfset this.setCOGS(local.i.getPrices().getCOGS())>
			<cfset this.setRetailPrice(local.i.getPrices().getRetailPrice())>
			<cfset this.setNetPrice(local.i.getPrices().getDueToday())>
			<cfset this.setWeight(0)>
			<cfset this.setTotalWeight(0)>
			<cfset this.setTaxable(true)>
			<cfset this.setTaxes( local.i.getTaxes().getDueToday() )>
			<!---<cfset this.setMessage('')>---> <!--- TODO - not sure what value to populate this with --->
		<cfelse>
       	
        </cfif>
	</cffunction>

	<cffunction name="initAsProduct" access="public" output="false" returntype="void">
    	<cfargument name="ProductId" type="numeric" required="true">
        
        <cfset var local = structNew()>
        <cfset local.productId = arguments.ProductId>
        <cfset local.product = createobject('component','cfc.model.Product').init()>
        <cfset local.product.getProduct(local.productId)>
        
        
        <cfset this.setProductId(local.productId)>
        <cfset this.setGersSku(this.getGersSkuByProductId(local.productId))>
        <cfset this.setProductTitle(local.product.getTitle())> 
        <cfset this.setOrderDetailType(local.product.getTypeCode())>
        <cfset this.setRetailPrice(local.product.getRetailPrice())>
    </cffunction>

	<cffunction name="getGersSkuByProductId" access="public" output="false" returntype="string">
		<cfargument name="ProductId" type="numeric" required="true">
		<cfset var local = structNew()>
		<cfset local.sku = "">

		<cfquery name="local.qGetProductGersSku" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				p.GersSku
			FROM
				catalog.Product p
			WHERE
				p.ProductId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ProductId#">
		</cfquery>
		<cfif local.qGetProductGersSku.recordCount>
			<cfset local.sku = local.qGetProductGersSku.GersSku>
		</cfif>

		<cfreturn local.sku>
	</cffunction>

	<cffunction name="getByWirelessLineIdAndOrderDetailType" access="public" output="false" returntype="cfc.model.OrderDetail[]">
		<cfargument name="WirelessLineId" type="numeric" required="true">
		<cfargument name="OrderDetailType" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.a = arrayNew(1)>
		
		<cfquery name="local.qGet" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				od.OrderDetailId
			FROM
				SalesOrder.OrderDetail od
			WHERE
				EXISTS (
					SELECT 1
					FROM
						SalesOrder.WirelessLine wl
						inner join SalesOrder.OrderDetail od2
							on wl.OrderDetailId = od2.OrderDetailId
					WHERE
						wl.WirelessLineId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WirelessLineId#">
					AND	od.OrderId = od2.OrderId
					AND	od.GroupNumber = od2.GroupNumber
				)
			AND	od.OrderDetailType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.OrderDetailType#">
			AND	od.GroupNumber <> <cfqueryparam cfsqltype="cf_sql_integer" value="#request.config.otherItemsLineNumber#">
		</cfquery>
		<cfloop query="local.qGet">
			<cfset local.o = createobject('component','cfc.model.OrderDetail').init()>
			<cfset local.o.load(local.qGet.OrderDetailId[local.qGet.currentRow])>
			<cfset arrayAppend(local.a,local.o)>
		</cfloop>
		<cfreturn local.a>
	</cffunction>

	<cffunction name="getFullOrderDetailType" access="public" output="false" returntype="string">
		<cfargument name="OrderDetailType" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.return = "">
		<cfset local.types = structNew()>
		<cfset local.types['a'] = "Accessory">
		<cfset local.types['b'] = "Deposit">
		<cfset local.types['d'] = "Device">
		<cfset local.types['r'] = "Plan">
		<cfset local.types['s'] = "Service">

		<cfif structKeyExists(local.types,arguments.OrderDetailType)>
			<cfset local.return = local.types[arguments.OrderDetailType]>
		</cfif>
		<cfreturn local.return>
	</cffunction>
	
	<cffunction name="getEstimatedMonthly" access="public" output="false" returntype="numeric">
		<cfif this.getOrderDetailType() eq "r">
			<cfreturn application.model.Plan.getMonthlyFeeByProductIdAndLineNumber(this.getProductId(),this.getGroupNumber())+0>
		<cfelseif this.getOrderDetailType() eq "s">
			<cfreturn application.model.Feature.getByProductId(this.getProductId()).price+0>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="getEstimatedFinancedMonthly" access="public" output="false" returntype="numeric">
		<cfset financedMonthly = application.model.Feature.getByProductId(this.getProductId()).financedPrice />
		<cfif (this.getOrderDetailType() eq "s") and (len(financedMonthly))>
			<cfreturn financedMonthly+0>
		<cfelse>
			<cfreturn application.model.Feature.getByProductId(this.getProductId()).price+0>
		</cfif>
	</cffunction>

	<cffunction name="getEstimatedFirstMonth" access="public" output="false" returntype="numeric">
		<cfreturn this.getEstimatedMonthly()>
	</cffunction>

	<!--- TODO: Get Carrier Bill Code --->
	<cffunction name="getCarrierBillCode" access="public" output="false" returntype="string">
		<cfif this.getOrderDetailType() eq "s">
			<cfreturn "Code">
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>

	<!--- ACCESSORS --->

	<cffunction name="setOrderDetailId" access="public" returntype="void" output="false">
		<cfargument name="OrderDetailId" type="numeric" required="true" />
		<cfset variables.instance.OrderDetailId = trim(arguments.OrderDetailId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderDetailId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderDetailId />
	</cffunction>

	<cffunction name="setOrderDetailType" access="public" returntype="void" output="false">
		<cfargument name="OrderDetailType" type="string" required="true" />
		<cfset variables.instance.OrderDetailType = trim(arguments.OrderDetailType) />
	</cffunction>
	<cffunction name="getOrderDetailType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.OrderDetailType />
	</cffunction>

	<cffunction name="setOrderId" access="public" returntype="void" output="false">
		<cfargument name="OrderId" type="numeric" required="true" />
		<cfset variables.instance.OrderId = trim(arguments.OrderId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderId />
	</cffunction>

	<cffunction name="setGroupNumber" access="public" returntype="void" output="false">
		<cfargument name="GroupNumber" type="numeric" required="true" />
		<cfset variables.instance.GroupNumber = trim(arguments.GroupNumber) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getGroupNumber" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.GroupNumber />
	</cffunction>

	<cffunction name="setGroupName" access="public" returntype="void" output="false">
		<cfargument name="GroupName" type="string" required="true" />
		<cfset variables.instance.GroupName = trim(arguments.GroupName) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getGroupName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.GroupName />
	</cffunction>

	<cffunction name="setProductId" access="public" returntype="void" output="false">
		<cfargument name="ProductId" type="numeric" required="true" />
		<cfset var local = structNew()>
		<cfset variables.instance.ProductId = trim(arguments.ProductId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getProductId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ProductId />
	</cffunction>

	<cffunction name="setGersSku" access="public" returntype="void" output="false">
		<cfargument name="GersSku" type="string" required="true" />
		<cfset variables.instance.GersSku = trim(arguments.GersSku) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getGersSku" access="public" returntype="string" output="false">
		<cfreturn variables.instance.GersSku />
	</cffunction>

	<cffunction name="setProductTitle" access="public" returntype="void" output="false">
		<cfargument name="ProductTitle" type="string" required="true" />
		<cfset variables.instance.ProductTitle = trim(arguments.ProductTitle) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getProductTitle" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ProductTitle />
	</cffunction>

	<cffunction name="setPartNumber" access="public" returntype="void" output="false">
		<cfargument name="PartNumber" type="string" required="true" />
		<cfset variables.instance.PartNumber = trim(arguments.PartNumber) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPartNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PartNumber />
	</cffunction>

	<cffunction name="setQty" access="public" returntype="void" output="false">
		<cfargument name="Qty" type="numeric" required="true" />
		<cfset variables.instance.Qty = trim(arguments.Qty) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getQty" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.Qty />
	</cffunction>

	<cffunction name="setCOGS" access="public" returntype="void" output="false">
		<cfargument name="COGS" type="numeric" required="true" />
		<cfset variables.instance.COGS = trim(arguments.COGS) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCOGS" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.COGS />
	</cffunction>

	<cffunction name="setRetailPrice" access="public" returntype="void" output="false">
		<cfargument name="RetailPrice" type="numeric" required="true" />
		<cfset variables.instance.RetailPrice = trim(arguments.RetailPrice) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getRetailPrice" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.RetailPrice />
	</cffunction>

	<cffunction name="setNetPrice" access="public" returntype="void" output="false">
		<cfargument name="NetPrice" type="numeric" required="true" />
		<cfset variables.instance.NetPrice = trim(arguments.NetPrice) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getNetPrice" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.NetPrice />
	</cffunction>

	<cffunction name="setWeight" access="public" returntype="void" output="false">
		<cfargument name="Weight" type="numeric" required="true" />
		<cfset variables.instance.Weight = trim(arguments.Weight) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getWeight" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.Weight />
	</cffunction>

	<cffunction name="setTotalWeight" access="public" returntype="void" output="false">
		<cfargument name="TotalWeight" type="numeric" required="true" />
		<cfset variables.instance.TotalWeight = trim(arguments.TotalWeight) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getTotalWeight" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.TotalWeight />
	</cffunction>

	<cffunction name="setTaxable" access="public" returntype="void" output="false">
		<cfargument name="Taxable" type="boolean" required="true" />
		<cfset variables.instance.Taxable = arguments.Taxable />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getTaxable" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.Taxable />
	</cffunction>

	<cffunction name="setTaxes" access="public" returntype="void" output="false">
		<cfargument name="Taxes" type="numeric" required="true" />
		<cfset var local = structNew()>
        <cfset local.taxes = arguments.Taxes>
		<cfset variables.instance.Taxes = local.taxes />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getTaxes" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.Taxes />
	</cffunction>

	<cffunction name="setMessage" access="public" returntype="void" output="false">
		<cfargument name="Message" type="string" required="true" />
		<cfset variables.instance.Message = trim(arguments.Message) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getMessage" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Message />
	</cffunction>

	<cffunction name="setShipment" access="public" returntype="void" output="false">
		<cfargument name="Shipment" type="cfc.model.Shipment" required="true" />
		<cfset variables.instance.Shipment = arguments.Shipment />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getShipment" access="public" returntype="cfc.model.Shipment" output="false">
		<cfreturn variables.instance.Shipment />
	</cffunction>
<!---
	<cffunction name="setWirelessLine" access="public" returntype="void" output="false">
		<cfargument name="WirelessLine" type="cfc.model.WirelessLine" required="true" />
		<cfset variables.instance.WirelessLine = arguments.WirelessLine />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getWirelessLine" access="public" returntype="cfc.model.WirelessLine" output="false">
		<cfreturn variables.instance.WirelessLine />
	</cffunction>
--->
	<cffunction name="setLineService" access="public" returntype="void" output="false">
		<cfargument name="LineService" type="cfc.model.LineService" required="true" />
		<cfset variables.instance.LineService = arguments.LineService />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getLineService" access="public" returntype="cfc.model.LineService" output="false">
		<cfreturn variables.instance.LineService />
	</cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>
	
	<cffunction name="setRmaNumber" access="public" returntype="void" output="false">
		<cfargument name="RmaNumber" type="string" required="true" />
		<cfset variables.instance.RmaNumber = arguments.RmaNumber />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getRmaNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.RmaNumber />
	</cffunction>
	
	<cffunction name="setRmaStatus" access="public" returntype="void" output="false">
		<cfargument name="RmaStatus" type="numeric" required="true" />
		<cfset variables.instance.RmaStatus = arguments.RmaStatus />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getRmaStatus" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.RmaStatus />
	</cffunction>
	
	<cffunction name="setRmaReason" access="public" returntype="void" output="false">
		<cfargument name="RmaReason" type="string" required="true" />
		<cfset variables.instance.RmaReason = arguments.RmaReason />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getRmaReason" access="public" returntype="string" output="false">
		<cfreturn variables.instance.RmaReason />
	</cffunction>

	<cffunction name="setRebate" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["rebate"] = arguments.theVar />
		<cfset this.setIsDirty(true) />    
    </cffunction>	
	<cffunction name="getRebate" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["rebate"]/>    
    </cffunction>
    
    <cffunction name="getDiscountTotal" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["discountTotal"]/>    
    </cffunction>    
    <cffunction name="setDiscountTotal" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["discountTotal"] = arguments.theVar />    
    </cffunction>
    
 	<cffunction name="setDownpaymentReceived" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["downPaymentReceived"] = arguments.theVar />
		<cfset this.setIsDirty(true) />    
    </cffunction>	
	<cffunction name="getDownPaymentReceived" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["downPaymentReceived"]/>    
    </cffunction>
   
    <cffunction name="setPurchaseType" access="public" returntype="void" output="false">
		<cfargument name="PurchaseType" type="string" required="true" />
		<cfset variables.instance.PurchaseType = arguments.PurchaseType />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPurchaseType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PurchaseType />
	</cffunction>
	
	<cffunction name="getFreeProducts" access="public" returnType="Array" output="false" description="returns an array of free productids associated with this item" > 
	
		<cfquery name="qfreebies" datasource="wirelessadvocates">
			SELECT ap.ProductID as freeProductId
			FROM catalog.Device d 
			INNER JOIN catalog.Product dp ON dp.ProductGuid = d.DeviceGuid
			INNER JOIN catalog.DeviceFreeAccessory da ON da.DeviceGuid = d.DeviceGuid
			INNER JOIN catalog.Accessory a ON a.AccessoryGuid = da.ProductGuid
			INNER JOIN catalog.Product ap ON ap.ProductGuid = a.AccessoryGuid
			INNER JOIN catalog.ProductTag pt on pt.ProductGuid = ap.ProductGuid
			WHERE dp.GersSku = '#getGersSku()#' and pt.Tag = 'freeaccessory' 
			ORDER BY ap.ProductID asc, ap.GersSku asc
		</cfquery>	
	
		<cfreturn listToArray(valuelist(qfreebies.freeProductId)) />
		
	</cffunction>
	
	<!--- TODO: Figure out RMA status names --->
	<cffunction name="getRmaStatusName" access="public" returntype="string" output="false">
		<cfscript>
			var rmaStatusName = "";
			
			switch( variables.instance.RmaStatus )
			{
				case 0:
				{
					rmaStatusName = "";
					break;
				}
				case 1:
				{
					rmaStatusName = "Open";
					break;
				}
				case 2:
				{
					rmaStatusName = "Complete";
					break;
				}											
				case 3:
				{
					rmaStatusName = "Cancelled";
					break;
				}
				default:
				{
					rmaStatusName = "";
					break;
				}
			}
		</cfscript>
	
	
		<cfreturn rmaStatusName />
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
	
	<!--- Beans --->
	
	<cffunction name="getInstantRebateService" access="private" output="false" returntype="any">
		<cfreturn application.wirebox.getInstance("InstantRebateService")>
	</cffunction>

</cfcomponent>