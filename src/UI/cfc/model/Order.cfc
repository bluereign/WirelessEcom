<cfcomponent output="false" displayname="Order">

	<cfset variables.instance = StructNew() />
	<!--- Required for setStepInstance() --->
	<cfset variables.beanFieldArr = ListToArray("OrderId|OrderDate|PcrDate|UserId|CarrierId|ShipAddress|BillAddress|EmailAddress|ShipMethod|ShipCost|ActivationType|Message|IPAddress|Status|GERSStatus|GERSRefNum|TimeSentToGERS|WirelessAccount|Payments|WirelessLines", "|") />
	<cfset variables.nullDateTime = createDateTime(9999,1,1,0,0,0)>

	<!--- INITIALIZATION / CONFIGURATION --->

	<cffunction name="init" access="public" returntype="cfc.model.Order" output="false">
		<cfargument name="OrderId" type="numeric" required="false" default="0" />
		<cfargument name="PcrDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="OrderDate" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="UserId" type="numeric" required="false" default="0" />
		<cfargument name="CarrierId" type="numeric" required="false" default="0" />
		<cfargument name="ShipAddress" type="cfc.model.OrderAddress" required="false" default="#createObject('component','cfc.model.OrderAddress').init()#" />
		<cfargument name="BillAddress" type="cfc.model.OrderAddress" required="false" default="#createObject('component','cfc.model.OrderAddress').init()#" />
		<cfargument name="EmailAddress" type="string" required="false" default="" />
		<cfargument name="ShipMethod" type="cfc.model.ShipMethod" required="false" default="#createObject('component','cfc.model.ShipMethod').init()#" />
		<cfargument name="ShipCost" type="numeric" required="false" default="0" />
		<cfargument name="ActivationType" type="string" required="false" default="" />
		<cfargument name="Message" type="string" required="false" default="" />
		<cfargument name="IPAddress" type="string" required="false" default="" />
		<cfargument name="Status" type="numeric" required="false" default="0" />
		<cfargument name="GERSStatus" type="numeric" required="false" default="0" />
		<cfargument name="GERSRefNum" type="string" required="false" default="" />
		<cfargument name="TimeSentToGERS" type="date" required="false" default="#variables.nullDateTime#" />
		<cfargument name="WirelessAccount" type="cfc.model.WirelessAccount" required="false" default="#createObject('component','cfc.model.WirelessAccount').init()#" />
		<cfargument name="Payments" type="cfc.model.Payment[]" required="false" default="#arrayNew(1)#" />
		<cfargument name="WirelessLines" type="cfc.model.WirelessLine[]" required="false" default="#arrayNew(1)#" />
		<cfargument name="OtherItems" type="cfc.model.OrderDetail[]" required="false" default="#arrayNew(1)#" />
        <cfargument name="SalesTaxTransactionId" type="string" required="false" default="" />
        <cfargument name="SalesTaxRefundTransactionId" type="string" required="false" default="" />
		<cfargument name="CheckoutReferenceNumber" type="string" required="false" default="" />
		<cfargument name="IsSalesTaxTransactionCommited" type="boolean" required="false" default="false" />
        <cfargument name="ParentOrderId" type="numeric" required="false" default="0" />
        <cfargument name="SortCode" type="string" required="false" default="" />
		<cfargument name="IsDirty" type="boolean" required="false" default="false" />
		<cfargument name="discountTotal" required="false" type="string" default="0" />
		<cfargument name="OrderAssistanceUsed" required="false" type="boolean" default="false" />
		<cfargument name="IsCreditCheckPending" required="false" type="boolean" default="false" />
		<cfargument name="CreditApplicationNumber" required="false" type="string" default="" />
		<cfargument name="CreditCheckStatusCode" required="false" type="string" default="" />
		<cfargument name="ServiceZipCode" required="false" type="string" default="" />
		<cfargument name="KioskEmployeeNumber" required="false" type="string" default="" />
		<cfargument name="ShipmentDeliveryDate" required="false" type="string" default="" />
		<cfargument name="LockDateTime" type="string" required="false" default="" />
		<cfargument name="LockedById" type="numeric" required="false" default="0" />
		<cfargument name="PaymentCapturedById" type="numeric" required="false" default="0" />
		<cfargument name="PaymentCapturedByUserName" type="string" required="false" default="" />
		<cfargument name="ActivatedById" type="numeric" required="false" default="0" />
		<cfargument name="CreditCheckKeyInfoId" type="numeric" required="false" default="0" />
		<cfargument name="PaymentGatewayId" type="numeric" required="false" default="0" />
		<cfargument name="InstantRebateAmount" type="numeric" required="false" default="0" />
		<cfargument name="CarrierConversationId" type="string" required="false" default="" />
		<cfargument name="CampaignId" type="numeric" required="false" default="0" />
		<cfargument name="SmsOptIn" type="boolean" required="false" default="false" />
		<cfargument name="ScenarioId" type="numeric" required="false" default="1" />
		<cfargument name="KioskId" type="numeric" required="false" default="0" />
		<cfargument name="AssociateId" type="numeric" required="false" default="0" />

		<cfscript>
			variables.instance.log = CreateObject( "component", "cfc.model.ActivityLog" ).init( type="Order" );

			variables.instance.OrderId = arguments.OrderId;
			variables.instance.ParentOrderId = arguments.ParentOrderId;
			variables.instance.SortCode = arguments.SortCode;
			variables.instance.OrderDate = arguments.OrderDate;
			variables.instance.PcrDate = arguments.PcrDate;
			variables.instance.UserId = arguments.UserId;
			variables.instance.CarrierId = arguments.CarrierId;
			variables.instance.ShipAddress = arguments.ShipAddress;
			variables.instance.BillAddress = arguments.BillAddress;
			variables.instance.EmailAddress = arguments.EmailAddress;
			variables.instance.ShipMethod = arguments.ShipMethod;
			variables.instance.ShipCost = arguments.ShipCost;
			variables.instance.ActivationType = arguments.ActivationType;
			variables.instance.Message = arguments.Message;
			variables.instance.IPAddress = arguments.IPAddress;
			variables.instance.Status = arguments.Status;
			variables.instance.GERSStatus = arguments.GERSStatus;
			variables.instance.GERSRefNum = arguments.GERSRefNum;
			variables.instance.TimeSentToGERS = arguments.TimeSentToGERS;
			variables.instance.WirelessAccount = arguments.WirelessAccount;
			variables.instance.Payments = arguments.Payments;
			variables.instance.WirelessLines = arguments.WirelessLines;
			variables.instance.OtherItems = arguments.OtherItems;
			variables.instance.SalesTaxTransactionId = arguments.SalesTaxTransactionId;
			variables.instance.IsSalesTaxTransactionCommited = arguments.IsSalesTaxTransactionCommited;
	        variables.instance.SalesTaxRefundTransactionId = arguments.SalesTaxRefundTransactionId;
			variables.instance.CheckoutReferenceNumber = arguments.CheckoutReferenceNumber;
			variables.instance.discountTotal = arguments.discountTotal;
			variables.instance.OrderAssistanceUsed = arguments.OrderAssistanceUsed;
			variables.instance.IsCreditCheckPending = arguments.IsCreditCheckPending;
			variables.instance.CreditApplicationNumber = arguments.CreditApplicationNumber;
			variables.instance.CreditCheckStatusCode = arguments.CreditCheckStatusCode;
			variables.instance.ServiceZipCode = arguments.ServiceZipCode;
			variables.instance.kioskEmployeeNumber = arguments.kioskEmployeeNumber;
			variables.instance.ShipmentDeliveryDate = arguments.ShipmentDeliveryDate;
			variables.instance.LockDateTime = arguments.LockDateTime;
			variables.instance.LockedById = arguments.LockedById;
			variables.instance.PaymentCapturedById = arguments.PaymentCapturedById;
			variables.instance.PaymentCapturedByUserName = arguments.PaymentCapturedByUserName;
			variables.instance.ActivatedById = arguments.ActivatedById;
			variables.instance.CreditCheckKeyInfoId = arguments.CreditCheckKeyInfoId;
			variables.instance.PaymentGatewayId = arguments.PaymentGatewayId;
			variables.instance.InstantRebateAmount = arguments.InstantRebateAmount;
			variables.instance.CarrierConversationId = arguments.CarrierConversationId;
			variables.instance.CampaignId = arguments.CampaignId;
			variables.instance.SmsOptIn = arguments.SmsOptIn;
			variables.instance.ScenarioId = arguments.ScenarioId;
			variables.instance.KioskId = arguments.KioskId;
			variables.instance.AssociateId = arguments.AssociateId;
		</cfscript>

		<cfset setIsDirty(arguments.IsDirty) /> <!--- TRV: this should ALWAYS be the last setter called in this init method --->
		<cfreturn this />
 	</cffunction>

	<!--- PUBLIC FUNCTIONS --->

	<cffunction name="getTotalAfterDiscount" access="public" returntype="string" output="false">
		<cfif isNumeric(getDiscountTotal())>
			<cfreturn getOrderTotal() - val( getDiscountTotal() )>
		<cfelse>
			<cfreturn getOrderTotal()>
		</cfif>
	</cffunction>
	
	<cffunction name="setMemento" access="public" returntype="cfc.model.Order" output="false">
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
		<cfargument name="recursive" type="boolean" required="false" default="true">
		<cfset var local = structNew()>
		<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				OrderId
            , 	ParentOrderId
            , 	SortCode
			,	OrderDate
			,   PcrDate
			,	UserId
			,	CarrierId
			,	ShipAddressGuid
			,	BillAddressGuid
			,	EmailAddress
			,	ShipMethodId
			,	ShipCost
			,	ActivationType
			,	Message
			,	IPAddress
			,	Status
			,	GERSStatus
			,	GERSRefNum
			,	TimeSentToGERS
            , 	CheckoutReferenceNumber
			, 	SalesTaxTransactionId
			,	IsSalesTaxTransactionCommited
			,	SalesTaxRefundTransactionId
			,	DiscountTotal
			,	OrderAssistanceUsed
			,	IsCreditCheckPending
			,	CreditApplicationNumber
			,	CreditCheckStatusCode
			,	ServiceZipCode
			,	KioskEmployeeNumber
			,	ShipmentDeliveryDate
			,	LockDateTime
			,	LockedById
			,	PaymentCapturedById
			,	ActivatedById
			,	CreditCheckKeyInfoId
			,	PaymentGatewayId
			,	CarrierConversationId
			,	CampaignId
			,	SmsOptIn
			,	ScenarioId
			,	KioskId
			,	AssociateId
			FROM SalesOrder.[Order] WITH (NOLOCK)
			WHERE OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
		</cfquery>
		<cfscript>
			if (local.qLoad.recordCount)
			{
				if (len(trim(local.qLoad.OrderId))) variables.instance.OrderId = local.qLoad.OrderId;
				if (len(trim(local.qLoad.ParentOrderId))) variables.instance.ParentOrderId = local.qLoad.ParentOrderId;
				if (len(trim(local.qLoad.SortCode))) variables.instance.SortCode = local.qLoad.SortCode;
				if (len(trim(local.qLoad.OrderDate))) variables.instance.OrderDate = local.qLoad.OrderDate;
				if (len(trim(local.qLoad.PcrDate))) variables.instance.PcrDate = local.qLoad.PcrDate;
				if (len(trim(local.qLoad.UserId))) variables.instance.UserId = local.qLoad.UserId;
				if (len(trim(local.qLoad.CarrierId))) variables.instance.CarrierId = local.qLoad.CarrierId;
				if (len(trim(local.qLoad.ShipAddressGuid))) this.getShipAddress().load(local.qLoad.ShipAddressGuid);
				if (len(trim(local.qLoad.BillAddressGuid))) this.getBillAddress().load(local.qLoad.BillAddressGuid);
				if (len(trim(local.qLoad.EmailAddress))) variables.instance.EmailAddress = local.qLoad.EmailAddress;
				if (len(trim(local.qLoad.ShipMethodId))) this.getShipMethod().load(local.qLoad.ShipMethodId);
				if (len(trim(local.qLoad.ShipCost))) variables.instance.ShipCost = local.qLoad.ShipCost;
				if (len(trim(local.qLoad.ActivationType))) variables.instance.ActivationType = local.qLoad.ActivationType;
				if (len(trim(local.qLoad.Message))) variables.instance.Message = local.qLoad.Message;
				if (len(trim(local.qLoad.IPAddress))) variables.instance.IPAddress = local.qLoad.IPAddress;
				if (len(trim(local.qLoad.Status))) variables.instance.Status = local.qLoad.Status;
				if (len(trim(local.qLoad.GERSStatus))) variables.instance.GERSStatus = local.qLoad.GERSStatus;
				if (len(trim(local.qLoad.GERSRefNum))) variables.instance.GERSRefNum = local.qLoad.GERSRefNum;
				if (len(trim(local.qLoad.TimeSentToGERS))) variables.instance.TimeSentToGERS = local.qLoad.TimeSentToGERS;
				if (len(trim(local.qLoad.CheckoutReferenceNumber))) variables.instance.CheckoutReferenceNumber = local.qLoad.CheckoutReferenceNumber;
				if (len(trim(local.qLoad.SalesTaxTransactionId))) variables.instance.SalesTaxTransactionId = local.qLoad.SalesTaxTransactionId;
				if (len(trim(local.qLoad.IsSalesTaxTransactionCommited))) variables.instance.IsSalesTaxTransactionCommited = local.qLoad.IsSalesTaxTransactionCommited;
				if (len(trim(local.qLoad.SalesTaxRefundTransactionId))) variables.instance.SalesTaxRefundTransactionId = local.qLoad.SalesTaxRefundTransactionId;
				if (len(trim(local.qLoad.DiscountTotal))) variables.instance.DiscountTotal = local.qLoad.DiscountTotal;
				if (len(trim(local.qLoad.OrderAssistanceUsed))) variables.instance.OrderAssistanceUsed = local.qLoad.OrderAssistanceUsed;
				if (len(trim(local.qLoad.IsCreditCheckPending))) variables.instance.IsCreditCheckPending = local.qLoad.IsCreditCheckPending;
				if (len(trim(local.qLoad.CreditApplicationNumber))) variables.instance.CreditApplicationNumber = local.qLoad.CreditApplicationNumber;
				if (len(trim(local.qLoad.CreditCheckStatusCode))) variables.instance.CreditCheckStatusCode = local.qLoad.CreditCheckStatusCode;
				if (len(trim(local.qLoad.ServiceZipCode))) variables.instance.ServiceZipCode = local.qLoad.ServiceZipCode;
				if (len(trim(local.qLoad.KioskEmployeeNumber))) variables.instance.KioskEmployeeNumber = local.qLoad.KioskEmployeeNumber;
				if (len(trim(local.qLoad.ShipmentDeliveryDate))) variables.instance.ShipmentDeliveryDate = local.qLoad.ShipmentDeliveryDate;
				if (len(trim(local.qLoad.LockDateTime))) variables.instance.LockDateTime = local.qLoad.LockDateTime;
				if (len(trim(local.qLoad.LockedById))) variables.instance.LockedById = local.qLoad.LockedById;
				if (len(trim(local.qLoad.PaymentCapturedById))) variables.instance.PaymentCapturedById = local.qLoad.PaymentCapturedById;
				if (isNumeric((len(trim(local.qLoad.PaymentCapturedById)))) ) {
					setPaymentCapturedByID(variables.instance.PaymentCapturedById); // force the user name to be loaded as well
				}
				if (len(trim(local.qLoad.ActivatedById))) variables.instance.ActivatedById = local.qLoad.ActivatedById;
				if (len(trim(local.qLoad.CreditCheckKeyInfoId))) variables.instance.CreditCheckKeyInfoId = local.qLoad.CreditCheckKeyInfoId;
				if (len(trim(local.qLoad.paymentGatewayId))) variables.instance.paymentGatewayId = local.qLoad.paymentGatewayId;
				if (len(trim(local.qLoad.CarrierConversationId))) variables.instance.CarrierConversationId = local.qLoad.CarrierConversationId;
				if (len(trim(local.qLoad.CampaignId))) variables.instance.CampaignId = local.qLoad.CampaignId;
				if (len(trim(local.qLoad.SmsOptIn))) variables.instance.SmsOptIn = local.qLoad.SmsOptIn;
				if (len(trim(local.qLoad.ScenarioId))) variables.instance.ScenarioId = local.qLoad.ScenarioId;
				if (len(trim(local.qLoad.KioskId))) variables.instance.KioskId = local.qLoad.KioskId;
				if (len(trim(local.qLoad.AssociateId))) variables.instance.AssociateId = local.qLoad.AssociateId;
			}
			else
			{
				this = createObject("component","cfc.model.Order").init();
			}
		</cfscript>

		<!--- if we're getting the recursive order data --->
		<cfif arguments.recursive>

			<!--- get wireless account --->
			<cfset local.wa = createObject('component','cfc.model.WirelessAccount').init()>
			<cfset this.setWirelessAccount(local.wa.getByOrderId(this.getOrderId()))>

			<!--- get wireless lines --->
			<cfset local.wl = createObject('component','cfc.model.WirelessLine').init()>
			<cfset this.setWirelessLines(local.wl.getByOrderId(this.getOrderId()))>

			<!--- get other items/accessories --->
			<cfset this.setOtherItems(this.getOtherItemsForThisOrder())>

			<!--- get payments --->
			<cfquery name="local.qLoad" datasource="#application.dsn.wirelessAdvocates#">
				SELECT PaymentId
				FROM SalesOrder.[Payment] WITH (NOLOCK)
				WHERE OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
			</cfquery>
			
			<cfset local.payments = [] />
			
			<cfloop query="local.qLoad">
				<cfset local.thisSubObj = createObject("component","cfc.model.Payment").init()>
				<cfset local.thisSubObj.load(local.qLoad.PaymentId[local.qLoad.currentRow])>
				<cfset arrayAppend(local.payments,local.thisSubObj)>
			</cfloop>
			<cfset this.setPayments( local.payments ) />
		</cfif>

		<cfset this.setIsDirty(false)>
	</cffunction>


	<cffunction name="save" access="public" output="false" returntype="void">
		<cfargument name="userId" type="numeric" default="0" required="false" />
		<cfargument name="d" type="boolean" required="false" default="false" />

		<cfset var local = structNew() />

		<cfif arguments.d>
			<cfdump var="#variables.instance#" />
			<cfabort />
		</cfif>

		<cftransaction>
			<!--- <cftry> --->
				<cfset this.getShipAddress().save() />
				<cfset this.getBillAddress().save() />

				<cfif not this.getOrderId()>

					<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
						INSERT INTO		salesOrder.[order]
						(				
							orderDate
							,	parentOrderId
							, 	sortCode
							,	userId
							,	carrierId
							,	shipAddressGuid
							,	billAddressGuid
							,	emailAddress
							,	shipMethodId
							,	shipCost
							,	activationType
							,	message
							,	ipAddress
							,	status
							,	gersStatus
							,	gersRefNum
							,	timeSentToGERS
							, 	checkoutReferenceNumber
							,	salesTaxTransactionId
							,	isSalesTaxTransactionCommited
							,	salesTaxRefundTransactionId
							,	discountTotal
							,	OrderAssistanceUsed
							,	IsCreditCheckPending
							,	CreditApplicationNumber
							,	CreditCheckStatusCode
							,	ServiceZipCode
							,	ShipmentDeliveryDate
							,	KioskEmployeeNumber
							,	LockDateTime
							,	LockedById
							,	PaymentCapturedById
							,	ActivatedById	
							,	CreditCheckKeyInfoId
							,	paymentGatewayId
							,	CarrierConversationId
							,	CampaignId
							,	SmsOptIn
							,	ScenarioId
							,	KioskId
							,	AssociateId
						)
						VALUES
						(				
										<cfif len(trim(this.getOrderDate())) and not isDateNull(this.getOrderDate())>
											<cfqueryparam value="#createODBCDateTime(this.getOrderDate())#" cfsqltype="cf_sql_timestamp" />
										<cfelse>
											<cfqueryparam value="#createODBCDateTime(now())#" cfsqltype="cf_sql_timestamp" />
										</cfif>
									,	<cfif len(trim(this.getParentOrderId()))>
											<cfqueryparam value="#this.getParentOrderId()#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getSortCode()))>
											<cfqueryparam value="#this.getSortCode()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getUserId()))>
											<cfqueryparam value="#this.getUserId()#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getCarrierId()))>
											<cfqueryparam value="#this.getCarrierId()#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getShipAddress().getAddressGuid()))>
											<cfqueryparam value="#this.getShipAddress().getAddressGuid()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getBillAddress().getAddressGuid()))>
											<cfqueryparam value="#this.getBillAddress().getAddressGuid()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getEmailAddress()))>
											<cfqueryparam value="#this.getEmailAddress()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif this.getShipMethod().getShipMethodId()>
											<cfqueryparam value="#this.getShipMethod().getShipMethodId()#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getShipCost()))>
											<cfqueryparam value="#this.getShipCost()#" cfsqltype="cf_sql_money" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getActivationType()))>
											<cfqueryparam value="#this.getActivationType()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getMessage()))>
											<cfqueryparam value="#this.getMessage()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getIPAddress()))>
											<cfqueryparam value="#this.getIPAddress()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getStatus()))>
											<cfqueryparam value="#this.getStatus()#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getGERSStatus()))>
											<cfqueryparam value="#this.getGERSStatus()#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getGERSRefNum()))>
											<cfqueryparam value="#this.getGERSRefNum()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getTimeSentToGERS())) and not isDateNull(this.getTimeSentToGERS())>
											<cfqueryparam value="#createODBCDateTime(this.getTimeSentToGERS())#" cfsqltype="cf_sql_timestamp" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getCheckoutReferenceNumber()))>
											<cfqueryparam value="#this.getCheckoutReferenceNumber()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getSalesTaxTransactionId()))>
											<cfqueryparam value="#this.getSalesTaxTransactionId()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getIsSalesTaxTransactionCommited()))>
											<cfqueryparam value="#this.getIsSalesTaxTransactionCommited()#" cfsqltype="cf_sql_bit" />
										<cfelse>
											false
										</cfif>
									,	<cfif len(trim(this.getSalesTaxRefundTransactionId()))>
											<cfqueryparam value="#this.getSalesTaxRefundTransactionId()#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfqueryparam value="#val(this.getDiscountTotal())#" cfsqltype="cf_sql_money" />
									,	<cfif len(trim(this.getOrderAssistanceUsed()))>
											<cfqueryparam value="#trim(this.getOrderAssistanceUsed())#" cfsqltype="cf_sql_bit" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getIsCreditCheckPending()))>
											<cfqueryparam value="#trim(this.getIsCreditCheckPending())#" cfsqltype="cf_sql_bit" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getCreditApplicationNumber()))>
											<cfqueryparam value="#trim(this.getCreditApplicationNumber())#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getCreditCheckStatusCode()))>
											<cfqueryparam value="#trim(this.getCreditCheckStatusCode())#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getServiceZipCode()))>
											<cfqueryparam value="#trim(this.getServiceZipCode())#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif this.getShipMethod().getShipMethodId() eq 1>
											<!--- Next Day --->
											<cfqueryparam value="#application.model.shipment.getDeliveryDate(now(), 1)#" cfsqltype="cf_sql_date" />
										<cfelseif this.getShipMethod().getShipMethodId() eq 2>
											<!--- FREE Shipping --->
											<cfqueryparam value="#application.model.shipment.getDeliveryDate(now(), 0)#" cfsqltype="cf_sql_date" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getKioskEmployeeNumber()))>
											<cfqueryparam value="#trim(this.getKioskEmployeeNumber())#" cfsqltype="cf_sql_varchar" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getLockDateTime()))>
											<cfqueryparam value="#trim(this.getLockDateTime())#" cfsqltype="cf_sql_timestamp" />
										<cfelse>
											NULL
										</cfif>
									,	<cfif len(trim(this.getLockedById()))>
											<cfqueryparam value="#trim(this.getLockedById())#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									,	<cfqueryparam value="#trim(this.getPaymentCapturedById())#" cfsqltype="cf_sql_integer" null="#!len(trim(this.getPaymentCapturedById()))#" />
									,	<cfqueryparam value="#trim(this.getActivatedById())#" cfsqltype="cf_sql_integer" null="#!len(trim(this.getActivatedById()))#" />
									, 	<cfqueryparam value="#trim(this.getCreditCheckKeyInfoId())#" cfsqltype="cf_sql_integer" null="#!len(trim(this.getCreditCheckKeyInfoId()))#" />
									,	<cfif isNumeric(this.getPaymentGatewayId()) AND this.getPaymentGatewayID() gt 0 >
											<cfqueryparam value="#this.getPaymentGatewayID()#" cfsqltype="cf_sql_integer" />
										<cfelse>
											NULL
										</cfif>
									, 	<cfqueryparam value="#trim(this.getCarrierConversationId())#" cfsqltype="cf_sql_varchar" null="#!len(trim(this.getCarrierConversationId()))#" />
									, 	<cfqueryparam value="#trim(this.getCampaignId())#" cfsqltype="cf_sql_varchar" null="#!this.getCampaignId()#" />
									,	<cfqueryparam value="#trim(this.getSmsOptIn())#" cfsqltype="cf_sql_bit"  null="#!len(this.getSmsOptIn())#"/>
									, 	<cfqueryparam value="#trim(this.getScenarioId())#" cfsqltype="cf_sql_varchar" null="#!this.getScenarioId()#" />
									, 	<cfqueryparam value="#trim(this.getKioskId())#" cfsqltype="cf_sql_varchar" null="#!this.getKioskId()#" />
									, 	<cfqueryparam value="#trim(this.getAssociateId())#" cfsqltype="cf_sql_varchar" null="#!this.getAssociateId()#" />
																		
						)
					</cfquery>

					<cfset this.setOrderId(local.saveResult.identityCol) />
				<cfelseif this.getIsDirty()>

					<cfquery name="local.qSave" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
						UPDATE		salesOrder.[order]
						SET			orderDate						=	<cfif len(trim(this.getOrderDate())) and not isDateNull(this.getOrderDate())>
																			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(this.getOrderDate())#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	parentOrderId					=	<cfif len(trim(this.getParentOrderId()))>
																			<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getParentOrderId()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	sortCode						=	<cfif len(trim(this.getSortCode()))>
																			<cfqueryparam cfsqltype="cf_sql_char" value="#this.getSortCode()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	userId							=	<cfif len(trim(this.getUserId()))>
																			<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getUserId()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	carrierId						=	<cfif len(trim(this.getCarrierId()))>
																			<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getCarrierId()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	shipAddressGuid					=	<cfif len(trim(this.getShipAddress().getAddressGuid()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getShipAddress().getAddressGuid()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	billAddressGuid					=	<cfif len(trim(this.getBillAddress().getAddressGuid()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getBillAddress().getAddressGuid()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	emailAddress					=	<cfif len(trim(this.getEmailAddress()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getEmailAddress()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	shipMethodId					=	<cfif len(trim(this.getShipMethod().getShipMethodId())) and this.getShipMethod().getShipMethodId() neq 0>
																			<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getShipMethod().getShipMethodId()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	shipCost						=	<cfif len(trim(this.getShipCost()))>
																			<cfqueryparam cfsqltype="cf_sql_money" value="#this.getShipCost()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	activationType					=	<cfif len(trim(this.getActivationType()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getActivationType()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	message							=	<cfif len(trim(this.getMessage()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMessage()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	ipAddress						=	<cfif len(trim(this.getIPAddress()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getIPAddress()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	status							=	<cfif len(trim(this.getStatus()))>
																			<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getStatus()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	gersStatus						=	<cfif len(trim(this.getGERSStatus()))>
																			<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getGERSStatus()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	gersRefNum						=	<cfif len(trim(this.getGERSRefNum()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getGERSRefNum()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	timeSentToGERS					=	<cfif len(trim(this.getTimeSentToGERS())) and not isDateNull(this.getTimeSentToGERS())>
																			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(this.getTimeSentToGERS())#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	checkoutReferenceNumber			=	<cfif len(trim(this.getCheckoutReferenceNumber()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCheckoutReferenceNumber()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	salesTaxTransactionId			=	<cfif len(trim(this.getSalesTaxTransactionId()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSalesTaxTransactionId()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	isSalesTaxTransactionCommited	=	<cfif len(trim(this.getIsSalesTaxTransactionCommited()))>
																			<cfqueryparam cfsqltype="cf_sql_bit" value="#this.getIsSalesTaxTransactionCommited()#" />
																		<cfelse>
																			false
																		</cfif>
								,	salesTaxRefundTransactionId		=	<cfif len(trim(this.getSalesTaxRefundTransactionId()))>
																			<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSalesTaxRefundTransactionId()#" />
																		<cfelse>
																			NULL
																		</cfif>
								,	discountTotal					=	<cfqueryparam value="#val(this.getDiscountTotal())#" cfsqltype="cf_sql_money" />
								,	OrderAssistanceUsed				=	<cfif len(trim(this.getOrderAssistanceUsed()))>
																			<cfqueryparam value="#trim(this.getOrderAssistanceUsed())#" cfsqltype="cf_sql_bit" />
																		<cfelse>
																			NULL
																		</cfif>
								,	IsCreditCheckPending			=	<cfif len(trim(this.getIsCreditCheckPending()))>
																			<cfqueryparam value="#trim(this.getIsCreditCheckPending())#" cfsqltype="cf_sql_bit" />
																		<cfelse>
																			NULL
																		</cfif>
								,	CreditApplicationNumber			=	<cfif len(trim(this.getCreditApplicationNumber()))>
																			<cfqueryparam value="#trim(this.getCreditApplicationNumber())#" cfsqltype="cf_sql_varchar"  />
																		<cfelse>
																			NULL
																		</cfif>
								,	CreditCheckStatusCode			=	<cfif len(trim(this.getCreditCheckStatusCode()))>
																			<cfqueryparam value="#trim(this.getCreditCheckStatusCode())#" cfsqltype="cf_sql_varchar"  />
																		<cfelse>
																			NULL
																		</cfif>
								,	ServiceZipCode					=	<cfif len(trim(this.getServiceZipCode()))>
																			<cfqueryparam value="#trim(this.getServiceZipCode())#" cfsqltype="cf_sql_varchar"  />
																		<cfelse>
																			NULL
																		</cfif>
								<cfif not len(trim(this.getShipmentDeliveryDate()))>
									,	ShipmentDeliveryDate		= 	<cfif this.getShipMethod().getShipMethodId() eq 1>
																			<!--- Next Day --->
																			<cfqueryparam value="#application.model.shipment.getDeliveryDate(now(), 1)#" cfsqltype="cf_sql_date" />
																		<cfelseif this.getShipMethod().getShipMethodId() eq 2>
																			<!--- FREE Shipping --->
																			<cfqueryparam value="#application.model.shipment.getDeliveryDate(now(), 0)#" cfsqltype="cf_sql_date" />
																		<cfelse>
																			NULL
																		</cfif>
								</cfif>
								,	KioskEmployeeNumber				=	<cfif len(trim(this.getKioskEmployeeNumber()))>
																			<cfqueryparam value="#trim(this.getKioskEmployeeNumber())#" cfsqltype="cf_sql_varchar" />
																		<cfelse>
																			NULL
																		</cfif>
								,	LockDateTime					=	<cfif len(trim(this.getLockDateTime()))>
																			<cfqueryparam value="#trim(this.getLockDateTime())#" cfsqltype="cf_sql_timestamp" />
																		<cfelse>
																			NULL
																		</cfif>
								,	LockedById						=	<cfif len(trim(this.getLockedById()))>
																			<cfqueryparam value="#trim(this.getLockedById())#" cfsqltype="cf_sql_integer" />
																		<cfelse>
																			NULL
																		</cfif>
								,	PaymentCapturedById				=	<cfqueryparam value="#trim(this.getPaymentCapturedById())#" cfsqltype="cf_sql_integer" null="#!len(trim(this.getPaymentCapturedById()))#" />
								
								,	ActivatedById					=	<cfqueryparam value="#trim(this.getActivatedById())#" cfsqltype="cf_sql_integer" null="#!len(trim(this.getActivatedById()))#" />
								,	CreditCheckKeyInfoId			=	<cfqueryparam value="#trim(this.getCreditCheckKeyInfoId())#" cfsqltype="cf_sql_integer" null="#!len(trim(this.getCreditCheckKeyInfoId()))#" />
								,	PaymentGatewayId				=	<cfif isNumeric(this.getPaymentGatewayId()) AND this.getPaymentGatewayID() gt 0 >
																			<cfqueryparam value="#this.getPaymentGatewayID()#" cfsqltype="cf_sql_integer" />
																		<cfelse>
																			NULL
																		</cfif>
								,	CarrierConversationId			=	<cfqueryparam value="#trim(this.getCarrierConversationId())#" cfsqltype="cf_sql_varchar" null="#!len(trim(this.getCarrierConversationId()))#" />
								,	CampaignId						=	<cfqueryparam value="#trim(this.getCampaignId())#" cfsqltype="cf_sql_integer" null="#!this.getCampaignId()#" />
								,	SmsOptIn						=	<cfqueryparam value="#trim(this.getSmsOptIn())#" cfsqltype="cf_sql_bit"  null="#!len(this.getSmsOptIn())#"/>
								,	ScenarioId						=	<cfqueryparam value="#trim(this.getScenarioId())#" cfsqltype="cf_sql_integer" null="#!this.getScenarioId()#" />
								,	KioskId							=	<cfqueryparam value="#trim(this.getKioskId())#" cfsqltype="cf_sql_integer" null="#!this.getKioskId()#" />
								,	AssociateId						=	<cfqueryparam value="#trim(this.getAssociateId())#" cfsqltype="cf_sql_integer" null="#!this.getAssociateId()#" />
						WHERE	OrderId								=	<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#" />
					</cfquery>

					<cfset variables.instance.log.setTypeReferenceId(this.getOrderId()) />
					<cfset variables.instance.log.setUserId(arguments.userId) />
					<cfset variables.instance.log.save() />
				</cfif>

				<cfif this.getWirelessAccount().getOrderId() neq this.getOrderId()>
					<cfset this.getWirelessAccount().setOrderId(this.getOrderId()) />
				</cfif>

				<cfset this.getWirelessAccount().save() />

				<cfset local.a = this.getPayments() />

				<cfloop from="1" to="#arrayLen(local.a)#" index="local.i">
					<cfif local.a[local.i].getOrderId() neq this.getOrderId()>
						<cfset local.a[local.i].setOrderId(this.getOrderId()) />
					</cfif>

					<cfset local.a[local.i].save() />
				</cfloop>

				<cfset local.a = this.getWirelessLines() />

				<cfloop from="1" to="#arrayLen(local.a)#" index="local.i">
					<cfif local.a[local.i].getOrderId() neq this.getOrderId()>
						<cfset local.a[local.i].setOrderId(this.getOrderId()) />
					</cfif>

					<cfset local.a[local.i].save() />
					<!---<cfdump var="#local.a[local.i].getLineDevice().getInstanceData()#">--->
				</cfloop>
<!---<cfabort>--->
				<cfset local.a = this.getOtherItems() />

				<cfloop from="1" to="#arrayLen(local.a)#" index="local.i">
					<cfif local.a[local.i].getOrderId() neq this.getOrderId()>
						<cfset local.a[local.i].setOrderId(this.getOrderId()) />
					</cfif>

					<cfif local.a[local.i].getGroupNumber() neq request.config.otherItemsLineNumber>
						<cfset local.a[local.i].setGroupNumber(request.config.otherItemsLineNumber) />
					</cfif>

					<cfif local.a[local.i].getGroupName() neq "Additional Items">
						<cfset local.a[local.i].setGroupName("Additional Items") />
					</cfif>

					<cfset local.a[local.i].save() />
				</cfloop>

				<cfset this.load(this.getOrderId()) />

				<!--- <cfcatch type="any">
					<cftransaction action="rollback" />
					<cfthrow message="#cfcatch#" />
				</cfcatch>
			</cftry> --->
		</cftransaction>
	</cffunction>

	<cffunction name="populateFromCart" access="public" output="false" returntype="void">
		<cfargument name="cart" type="cfc.model.Cart" required="true" />

		<cfset var local = structNew() />

		<cfif session.cart.hasCart()>
			<cfset this.setOrderDate( now() ) />
			<cfset this.setUserId( session.userid ) />
			<!---Old way, just look in remote_addr --->
			<!--- <cfset this.setIPAddress( cgi.remote_addr ) /> --->
				
			<!--- Modified to check for http_x_forwarded_for header to record true client ip after it goes thru the load balancer --->	
			<cfif isdefined("CGI.HTTP_X_Forwarded_For") and CGI.HTTP_X_Forwarded_For is not ""> <!--- ColdFusion will provide the header values with Underbars in the name instead of dashes to be language friendly --->
				<cfset this.setIPAddress(CGI.HTTP_X_Forwarded_For)/>
			<cfelse>
				<cfset this.setIPAddress( cgi.remote_addr ) /> 
			</cfif>
				
			<cfset this.setActivationType( application.model.CartHelper.getActivationTypeAcronym() ) />
			<cfset this.setSalesTaxTransactionId( session.cart.getSalesTaxTransactionId() ) />
			<cfset this.setServiceZipCode( session.cart.getZipCode() ) />
			<cfset this.setShipCost( session.cart.getShipping().getDueToday() ) />

			<cfset local.aWirelessLines = arrayNew(1) />
			<cfset local.cartLines = session.cart.getLines() />

			<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iLine">
								
				<cfset local.wl = createObject('component', 'cfc.model.wirelessLine').init() />
				
				<cfset local.lineArgs = {
					cartLine = local.cartLines[local.iLine], 
					lineNumber = local.iLine, 
					zipCode = session.cart.getZipCode(), 
					carrierId = session.cart.getCarrierId(),
					cartPlanIDCount = local.cartLines[local.iLine].getPlanIDCount()
				}>
				
				<cfset local.wl.populateFromCartLine( argumentCollection = local.lineArgs ) />

				<cfset arrayAppend(local.aWirelessLines, local.wl) />
			</cfloop>

			<cfif arrayLen(local.aWirelessLines)>
				<cfset this.setWirelessLines(local.aWirelessLines) />
			</cfif>

			<cfset local.aOtherItems = arrayNew(1) />
			<cfset local.otherItems = session.cart.getOtherItems() />

			<cfloop from="1" to="#arrayLen(local.otherItems)#" index="local.iItem">
				<cfset local.od = createObject('component', 'cfc.model.orderDetail').init() />
				<cfset local.od.populateFromCartOtherItems(otherItemsIndex = local.iItem) />
				<cfset arrayAppend(local.aOtherItems, local.od) />
			</cfloop>

			<cfif arrayLen(local.aOtherItems)>
				<cfset this.setOtherItems(local.aOtherItems) />
			</cfif>

			<cfset this.setCarrierId(session.cart.getCarrierId()) />
		</cfif>
	</cffunction>

	<cffunction name="populateFromCheckoutHelper" access="public" output="false" returntype="void">
		<cfset var local = {} />

		<cfset local.bAddress = createObject('component', 'cfc.model.orderAddress').init() />
		<cfset local.bAddress.populateFromAddress(application.model.checkoutHelper.getBillingAddress()) />
		<cfset this.setBillAddress(local.bAddress) />

		<cfset local.sAddress = createObject('component', 'cfc.model.orderAddress').init() />
		<cfset local.sAddress.populateFromAddress(application.model.checkoutHelper.getShippingAddress()) />
		<cfset this.setShipAddress(local.sAddress) />

		<cfset local.sm = createObject('component', 'cfc.model.shipMethod').init() />
		<cfset local.sm.load(application.model.checkoutHelper.getShippingMethod().getShipMethodId()) />
		<cfset this.setShipMethod(local.sm) />

		<cfset setCheckoutReferenceNumber( application.model.checkoutHelper.getReferenceNumber() ) />
		<cfset setIsCreditCheckPending( application.model.checkoutHelper.getIsCreditCheckPending() ) />
		<cfset setCreditApplicationNumber( application.model.checkoutHelper.getApplicationReferenceNumber() ) />
		<cfset setCreditCheckStatusCode( application.model.checkoutHelper.getCreditCheckStatusCode() ) />
		<cfset setCarrierConversationId( application.model.checkoutHelper.getCarrierConversationId() ) />

		<!--- Record PageMaster Campaign ID --->
		<cfset setCampaignId( application.model.checkoutHelper.getCurrentCampaign().getCampaignId() ) />

		<cfset local.wirelessLines = getWirelessLines() />

		<cfif not application.model.checkoutHelper.isUpgrade() and not application.model.checkoutHelper.isPrepaidOrder() && not application.model.checkoutHelper.isNoContract()>
			<cfloop from="1" to="#arrayLen(local.wirelessLines)#" index="local.iLine">
				<cfset local.wl = local.wirelessLines[local.iLine] />

				<cfif application.model.checkoutHelper.getMdnResult().getResult().mdnList[local.iLine].mdn neq ''>
					<cfset local.wl.setISMDNPort(true) />
					<cfset local.wl.setNewMDN(application.model.checkoutHelper.getMdnResult().getResult().mdnList[local.iLine].mdn) />
					<cfset local.wl.setIsNPARequested(false) />
					<cfset local.wl.setNPARequested('') />

					<cfset local.portInCurrentCarrier = evaluate('application.model.checkoutHelper.getMdnForm().portInCurrentCarrier#local.iLine#') />
					<cfset local.portInCurrentCarrierPin = evaluate('application.model.checkoutHelper.getMdnForm().portInCurrentCarrierPin#local.iLine#') />
					<cfset local.portInCurrentCarrierAccountNumber = evaluate('application.model.checkoutHelper.getMdnForm().portInCurrentCarrierAccountNumber#local.iLine#') />
					<cfset local.wl.setPortInCurrentCarrier(local.portInCurrentCarrier) />
					<cfset local.wl.setPortInCurrentCarrierPin(local.portInCurrentCarrierPin) />
					<cfset local.wl.setPortInCurrentCarrierAccountNumber(local.portInCurrentCarrierAccountNumber) />
				<cfelse>
					<cfset local.wl.setIsMDNPort(false) />
					<cfset local.wl.setNPARequested(application.model.checkoutHelper.getMdnResult().getResult().mdnList[local.iLine].areaCode) />
					<cfset local.wl.setIsNPARequested(true) />
				</cfif>
			</cfloop>
		<cfelseif application.model.checkoutHelper.isPrepaidOrder()>
			<cfloop from="1" to="#arrayLen(local.wirelessLines)#" index="local.iLine">
				<cfset local.wl = local.wirelessLines[local.iLine] />
				<cfset local.mdnList = application.model.checkoutHelper.getMdnList() />
				<cfset local.wl.setNPARequested( local.mdnList[local.iLine].AreaCode )/>
				<cfset local.wl.setIsPrepaid( true ) />
			</cfloop>
		</cfif>

		<cfif application.model.checkoutHelper.isUpgrade()>
			<!--- Update rateplans information --->
		</cfif>

		<cfset this.getWirelessAccount().populateFromCheckoutHelper() />
	</cffunction>

	<cffunction name="populateFromCheckoutHelperVFD" access="public" output="false" returntype="void">
		<cfset var local = {} />

		<cfset local.bAddress = createObject('component', 'cfc.model.orderAddress').init() />
		<cfset local.bAddress.populateFromAddress(application.model.checkoutHelper.getBillingAddress()) />
		<cfset this.setBillAddress(local.bAddress) />

		<cfset local.sAddress = createObject('component', 'cfc.model.orderAddress').init() />
		<cfset local.sAddress.populateFromAddress(application.model.checkoutHelper.getShippingAddress()) />
		<cfset this.setShipAddress(local.sAddress) />

		<cfset local.sm = createObject('component', 'cfc.model.shipMethod').init() />
		<cfset local.sm.load(application.model.checkoutHelper.getShippingMethod().getShipMethodId()) />
		<cfset this.setShipMethod(local.sm) />

		<cfset setCheckoutReferenceNumber( application.model.checkoutHelper.getReferenceNumber() ) />
		<cfset setIsCreditCheckPending( application.model.checkoutHelper.getIsCreditCheckPending() ) />
		<cfset setCreditApplicationNumber( application.model.checkoutHelper.getApplicationReferenceNumber() ) />
		<cfset setCreditCheckStatusCode( application.model.checkoutHelper.getCreditCheckStatusCode() ) />
		<cfset setCarrierConversationId( application.model.checkoutHelper.getCarrierConversationId() ) />

		<!--- Record PageMaster Campaign ID --->
		<cfset setCampaignId( application.model.checkoutHelper.getCurrentCampaign().getCampaignId() ) />

		<cfset local.wirelessLines = getWirelessLines() />

		<cfif application.model.checkoutHelper.isUpgrade()>
			<!--- Update rateplans information --->
		</cfif>

		<cfset this.getWirelessAccount().populateFromCheckoutHelper() />
	</cffunction>
	
	<!---
	  - Transfers IMEI and SIM to the wirelessline.
	  --->
	<cffunction name="magic" access="public" output="false" returntype="void">
		<cfargument name="type" type="string" required="true" />
		<cfset var local = structNew() />

		<cfswitch expression="#arguments.type#">
			<cfcase value="upgrade">
				<cfset local.wirelessLines = this.getWirelessLines() />
				<cfset local.wirelessLine = "" />
				<cfset local.otherItems = this.getOtherItems() />
				<cfset local.groupNumber = 0 />

				<cfloop array="#local.wirelessLines#" index="local.wirelessLine">
					<!--- get the SKU and SIM from inventory. --->
					<cfquery name="local.getInventory" datasource="#application.dsn.wirelessAdvocates#">
						SELECT
							IMEI
							, SIM
						FROM catalog.GersStock
						WHERE OrderDetailId = <cfqueryparam value="#local.wirelessLine.getLineDevice().getOrderDetailId()#" cfsqltype="cf_sql_integer" />
					</cfquery>

					<!--- Update wireless line info if we found the matching inventory --->
					<cfif local.getInventory.recordCount>
						<!--- place this information along with the currentmdn into the wireless line --->
						<cfset local.wirelessLine.setIMEI( local.getInventory.IMEI ) />
						<cfset local.wirelessLine.setSIM( local.getInventory.SIM ) />
					</cfif>
				</cfloop>

            </cfcase> <!--- end upgrade --->
        </cfswitch>

		<!--- after we're done with all that, we need to save() the order to apply the changes --->
		<cfset this.save() />
	</cffunction>

	<cffunction name="getOrderHistoryByUserId" access="public" output="false" returntype="cfc.model.Order[]">
		<cfargument name="userId" type="numeric" required="true" />
		<cfargument name="recursive" type="boolean" required="false" default="true" />

		<cfset var local = structNew() />
		<cfset local.a = arrayNew(1) />

		<cfquery name="local.qGetUserOrders" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		o.orderId
			FROM		salesorder.[order] AS o WITH (NOLOCK)
			WHERE		o.userId	=	<cfqueryparam value="#arguments.userId#" cfsqltype="cf_sql_integer" />
				AND		o.status	>	0
			ORDER BY	o.orderDate DESC, o.orderId DESC
		</cfquery>

		<cfif local.qGetUserOrders.recordCount>
			<cfloop query="local.qGetUserOrders">
				<cfset local.o = createObject('component', 'cfc.model.Order').init() />
				<cfset local.o.load(local.qGetUserOrders.orderId[local.qGetUserOrders.currentRow], arguments.recursive) />

				<cfset arrayAppend(local.a, local.o) />
			</cfloop>
		</cfif>

		<cfreturn local.a />
	</cffunction>

	<cffunction name="getOtherItemsForThisOrder" access="public" output="false" returntype="cfc.model.OrderDetail[]">
		<cfset var local = structNew()>
		<cfset local.a = arrayNew(1)>

		<cfquery name="local.qGet" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				od.OrderdetailId
			FROM
				SalesOrder.OrderDetail od
			WHERE
				od.OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#getOrderId()#">
			AND	od.GroupNumber = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.config.otherItemsLineNumber#">
		</cfquery>
		<cfloop query="local.qGet">
			<cfset local.o = createobject('component','cfc.model.OrderDetail').init()>
			<cfset local.o.load(local.qGet.OrderDetailId[local.qGet.currentRow])>
			<cfset arrayAppend(local.a,local.o)>
		</cfloop>
		<cfreturn local.a>
	</cffunction>

	<cffunction name="getSubTotal" access="public" output="false" returntype="numeric">
		<cfset var local = structNew()>
		<cfset local.total = 0>

		<cfquery name="local.qHardGoods" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				SUM(od.NetPrice * qty) as sumNetPrice
			FROM
				SalesOrder.OrderDetail od
			WHERE
				od.OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#">
		</cfquery>

		<cfif  local.qHardGoods.sumNetPrice gt 0>
			<cfset local.total = local.total + local.qHardGoods.sumNetPrice>
		</cfif>
		<cfreturn local.total>
	</cffunction>

	<cffunction name="getTaxTotal" access="public" output="false" returntype="numeric">
		<cfset var local = structNew()>
		<cfset local.total = 0>

		<cfquery name="local.qTaxes" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				SUM(od.Taxes) as sumTaxes
			FROM
				SalesOrder.OrderDetail od
			WHERE
				od.OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#">
		</cfquery>

		<cfif len(trim(local.qTaxes.sumTaxes))>
			<cfset local.total = local.qTaxes.sumTaxes>
		</cfif>

		<cfreturn local.total>
	</cffunction>

	<cffunction name="hardReserveAllHardGoods" access="public" output="false" returntype="boolean">
		<cfset var local = structNew()>
		<cfset local.success = true>
		<cfset local.oCatalog = createObject('component','cfc.model.Catalog').init()>

<!--- 		<cftry> --->
			<!--- first, get all the hard goods that exist in this order --->
			<cfquery name="local.qGetOrderHardGoods" datasource="#application.dsn.wirelessAdvocates#">
				SELECT
					OrderDetailId
				,	GroupNumber
				,   GroupName
				,	ProductId
				,	OrderDetailType
				FROM
					salesorder.OrderDetail
				WHERE
					OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#">
				AND	OrderDetailType IN ( 'd', 'a' )
			</cfquery>

			<!--- loop through the hard goods and make our hard reservations --->
			<cfloop query="local.qGetOrderHardGoods">
				<!--- make a hard reservation for this item --->
                <!--- Modified on 01/06/2015 by Denard Springle (denard.springle@gmail.com) --->
                <!--- Track #: 7084 - Orders: Deprecate dbo.OldProdToNewProd table and remove dependent code [ Deprecate getNewProductIdFromOldProductId function ] --->
				<cfquery name="local.qHardReserve" datasource="#application.dsn.wirelessAdvocates#">
					EXEC salesorder.ReserveStock
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sessionid#">
					,	<cfqueryparam cfsqltype="cf_sql_integer" value="#local.qGetOrderHardGoods.GroupNumber[local.qGetOrderHardGoods.currentRow]#">
					,	<cfqueryparam cfsqltype="cf_sql_integer" value="#local.qGetOrderHardGoods.OrderDetailId[local.qGetOrderHardGoods.currentRow]#">
					,	<cfqueryparam cfsqltype="cf_sql_integer" value="#local.qGetOrderHardGoods.ProductId[local.qGetOrderHardGoods.currentRow]#">
					,	1
				</cfquery>
				<!--- END EDITS on 01/06/2015 by Denard Springle --->
				<!--- secondarily, if this orderdetail record happens to be a device, let's get the IMEI number and tag our corresponding WirelessLine with it --->
				<cfif local.qGetOrderHardGoods.OrderDetailType[local.qGetOrderHardGoods.currentRow] eq "d">
					<cfquery name="local.qTagWirelessLineWithIMEI" datasource="#application.dsn.wirelessAdvocates#">
						EXEC salesorder.AssignIMEIToWirelessLine
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.qGetOrderHardGoods.OrderDetailId[local.qGetOrderHardGoods.currentRow]#">
					</cfquery>
				</cfif>
			</cfloop>

			<!--- when the calls above have completed, we'll have made database-side changes to the order, so let's reload the order to reflect the database changes --->
			<cfset this.load(this.getOrderId())>	
			
	
			<!--- Apple Care related work --->
			<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
			<cfif local.appleCare.isAppleCareOrder(this.getOrderId())>
				<cfset local.wirelessLines = this.getWirelessLines() />
				<cfloop from="1" to="#arraylen(local.wirelessLines)#" index="local.i">
					<cfset local.acDone = false />
					<cfset local.acTries = 0 />
					<cfloop condition="not local.acDone and local.acTries lt 2">
						<cfset local.acTries = local.acTries + 1 />
						<cfset local.wOrderDetail = local.wirelessLines[local.i].getLineWarranty() />
						<cfset local.dOrderDetail = local.wirelessLines[local.i].getLineDevice() />
						<cfset local.warrantyId =local.wOrderDetail.getProductId() />
						<cfset local.qWarranty = application.model.Warranty.getById( local.warrantyId ) />
						<cfif local.qWarranty.recordcount and local.qWarranty.companyname is "Apple">
							<cfset local.wOrderDetailMessage = {} />
							<cfset local.wOrderDetailMessage.op = "Verify" />
							<cfset local.acVerify = deserializeJson(local.appleCare.sendVerifyOrderRequest(this.getOrderId(),local.i)) />

							<!--- Figure out which errors we have --->
							<cfset local.AcGeneralErrors = 0 />
							<cfset local.AcNonDeviceErrors = 0 />
							<cfset local.AcDeviceErrors = 0 />							
							<cfif isDefined("local.acVerify.Message")><cfset local.AcGeneralErrors = local.AcGeneralErrors+1 /></cfif>
							<cfif isdefined("local.acVerify.errorResponse") and arrayLen(local.acVerify.errorResponse) gt 0><cfset local.AcNonDeviceErrors = local.AcNonDeviceErrors+1 /></cfif>
							<cfif isdefined("local.acVerify.OrderDetailsResponses.DeviceEligibility.errorResponse") AND arraylen(local.acVerify.OrderDetailsResponses.DeviceEligibility.errorResponse) gt 0><cfset local.AcDeviceErrors = local.AcDeviceErrors+1 /></cfif>
							<cfset local.AcAllErrors = local.AcGeneralErrors + local.AcNonDeviceErrors + local.AcDeviceErrors />

							<!--- No errors --->
							<cfif local.AcAllErrors is 0 >
								<cfset local.wOrderDetailMessage.op_status = "Verified" /> 
								<cfset local.wOrderDetailMessage.TransactionId = local.acVerify.TransactionId />
								<cfset local.wOrderDetailMessage.po = local.acVerify.originalRequest.purchaseOrderNumber />
								<cfset local.wOrderDetailMessage.deviceid = local.acVerify.originalRequest.DeviceRequest[1].deviceid />
								<cfset local.wOrderDetailMessage.referenceid = local.acVerify.originalRequest.referenceid />
								<cfset local.acDone = true />

							<!--- Device specific errors --->	
							<cfelseif local.AcDeviceErrors gt 0 > 
									<cfset local.wOrderDetailMessage.op_status = "Device Failed" /> 
									<cfset local.wOrderDetailMessage.errorCode = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorCode />
									<cfset local.wOrderDetailMessage.errorMessage = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorMessage />
									<cfset local.wOrderDetailMessage.deviceid = local.acVerify.originalRequest.DeviceRequest[1].deviceid />
									<cfset local.wOrderDetailMessage.referenceid = local.acVerify.originalRequest.referenceid />
									<cfset local.wOrderDetailMessage.deviceid = local.acVerify.originalRequest.DeviceRequest[1].deviceid />
									<!--- Make sure we don't overflow the column size (currently 255) --->
									<cfset local.jsonLength =  len(serializeJson(local.wOrderDetailMessage))/>
									<cfif local.jsonLength gt 255>
										<!--- trim the length of the error message --->
										<cfset local.wOrderDetailMessage.errorMessage = left(local.wOrderDetailMessage.errorMessage,(len(local.wOrderDetailMessage.errorMessage)-(local.jsonLength-255)) ) />
									</cfif>
									<!--- If we have a bad IMEI we will attempt to fix it (but only once) --->
									<!---<cfif local.wOrderDetailMessage.errorCode is "GRX-30020" and local.acTries is 1>
										<cfset SwapOutBadApplecareIMEI(local.wirelessLines[local.i]) />		
										<cfset local.acDone = false />							
									<cfelse>
										<cfset local.acDone = true />
									</cfif>--->

							<!--- Non-Device Errors --->	
							<cfelseif local.AcNonDeviceErrors gt 0>
								<cfset local.wOrderDetailMessage.op_status = "General Error" />
								<cfset local.wOrderDetailMessage.errorCode = local.acverify.errorResponse[1].errorCode />
								<cfset local.wOrderDetailMessage.errorMessage = local.acverify.errorResponse[1].errorMessage />
								<cfset local.acDone = true />
	
							<!--- General errors --->
							<cfelse>
								<cfset local.wOrderDetailMessage.op_status = "General Error" /> 
								<cfset local.wOrderDetailMessage.errorCode = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
								<cfset local.wOrderDetailMessage.errorCode = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
								<cfset local.wOrderDetailMessage.errorMessage = local.acVerify.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorMessage />
								<cfset local.acDone = true />	
							</cfif>
						</cfif>
					</cfloop>
					<cfset local.wOrderDetail.setMessage(serializeJson(local.wOrderDetailMessage)) />
					<cfset local.wOrderDetail.save() />
				</cfloop>			
			</cfif>	
			<!--- end of Apple Care related work --->
				
		<cfreturn local.success>
	</cffunction>

	<cffunction name="SwapOutBadApplecareIMEI" output="false" access="public" returntype="query">
		<cfargument name="wirelessLine" type="cfc.model.WirelessLine" required="yes" hint="OrderDetailId of the record with the bad IMEI" />

		<cfset local = {} />
		<cfset local.newIMEI = "" />
			
		<!--- Get the orderDetailId of the device for this line --->
		<cfset local.orderDetailId = arguments.wirelessLine.getOrderDetailId() />
		
		<!--- Call the SwapDevice Sproc --->
		<cfstoredproc procedure="allocation.SwapDevice" datasource="#application.dsn.wirelessAdvocates#" >
			<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#local.orderDetailId#" />
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" value="-30002" /> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" type="out" variable="local.newIMEI">
		</cfstoredproc>

		<!--- Remove the IMEI/SIM from the WirelessLines --->
		<cfset arguments.wirelessLine.setIMEI(local.newIMEI) />
		<cfset arguments.wirelessLine.save() />
		
	</cffunction>
	
	<cffunction name="getOrdersBySearchCriteria" output="false" access="public" returntype="query">
		<cfargument name="searchCriteria" type="struct" required="true" />

		<cfset var qOrders = '' />

		<cfquery name="qOrders" datasource="#application.dsn.wirelessAdvocates#">
			SELECT		distinct o.OrderId, o.OrderDate, o.Status, o.GERSStatus, CASE o.Status
						WHEN 0 THEN 'Pending'
						WHEN 1 THEN 'Submitted'
						WHEN 2 THEN 'Order Placed'
						WHEN 3 THEN
							CASE o.GERSStatus
								WHEN 2 THEN 'Packing'
								WHEN 3 THEN 'Shipped'
							ELSE 'Processing'
							END
						WHEN 4 THEN 'Cancelled'
						ELSE ''
						END StatusName, ba.FirstName AS BillingFirstName, ba.LastName AS BillingLastName,
							u.UserName, u.FirstName AS AccountFirstName, u.LastName AS AccountLastName,
							CASE
							WHEN wa.ActivationStatus IS NULL THEN 'Ready'
							WHEN wa.ActivationStatus = 0 THEN 'Ready'
							WHEN wa.ActivationStatus = 1 THEN 'Requested'
							WHEN wa.ActivationStatus = 2 THEN 'Success'
							WHEN wa.ActivationStatus = 3 THEN 'Partial Success'
							WHEN wa.ActivationStatus = 4 THEN 'Failure'
							WHEN wa.ActivationStatus = 5 THEN 'Error'
							WHEN wa.ActivationStatus = 6 THEN 'Manual'
							WHEN wa.ActivationStatus = 7 THEN 'Canceled'
						ELSE ''
						END ActivationStatusName,
						ISNULL(c.companyName, 'N/A') AS companyName, o.activationType
			FROM		salesorder.[Order] AS o WITH (NOLOCK)
			INNER JOIN salesorder.Orderdetail od WITH (NOLOCK)  ON o.orderid = od.orderid
			LEFT OUTER JOIN salesorder.wirelessline wl WITH (NOLOCK) ON od.orderdetailid = wl.orderdetailid
			INNER JOIN	salesorder.Address AS ba WITH (NOLOCK) ON ba.AddressGuid = o.BillAddressGuid
			INNER JOIN	salesorder.WirelessAccount AS wa WITH (NOLOCK) ON wa.OrderId = o.OrderId
			INNER JOIN	dbo.Users AS u WITH (NOLOCK) ON u.User_ID = o.UserId
			LEFT JOIN	catalog.company AS c WITH (NOLOCK) ON c.carrierId = o.carrierId
			WHERE		1 = 1
						<cfif structKeyExists(arguments.searchCriteria, 'orderId') and len(trim(arguments.searchCriteria.orderId))>
							AND	o.orderId							LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.orderId)#%" cfsqltype="cf_sql_varchar" />
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'username') and len(trim(arguments.searchCriteria.username))>
							AND	u.username							LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.username)#%" cfsqltype="cf_sql_varchar" />
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'firstName') and len(trim(arguments.searchCriteria.firstName))>
							AND	(
								u.firstName							LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.firstName)#%" cfsqltype="cf_sql_varchar" />
								OR
								ba.firstName						LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.firstName)#%" cfsqltype="cf_sql_varchar" />
							)
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'lastName') and len(trim(arguments.searchCriteria.lastName))>
							AND	(
								u.lastName							LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.lastName)#%" cfsqltype="cf_sql_varchar" />
								OR
								ba.LastName							LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.lastName)#%" cfsqltype="cf_sql_varchar" />
							)
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'email') and len(trim(arguments.searchCriteria.email))>
							AND	(
								u.email								LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.email)#%" cfsqltype="cf_sql_varchar" />
							)
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'mdn') and len(trim(arguments.searchCriteria.mdn))>
							AND	(
								wl.currentMDN						LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.mdn)#%" cfsqltype="cf_sql_varchar" />
								OR
								wl.newMDN							LIKE	<cfqueryparam value="#trim(arguments.searchCriteria.mdn)#%" cfsqltype="cf_sql_varchar" />
							)	
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'orderStatus') and len(trim(arguments.searchCriteria.orderStatus))>
							AND	ISNULL(o.status, '0')				=		<cfqueryparam value="#trim(arguments.searchCriteria.orderStatus)#" cfsqltype="cf_sql_varchar" />
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'activationStatus') and len(trim(arguments.searchCriteria.activationStatus))>
							AND	ISNULL(wa.ActivationStatus, '0')	=		<cfqueryparam value="#trim(arguments.searchCriteria.activationStatus)#" cfsqltype="cf_sql_varchar" />
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'carrierId') and trim(arguments.searchCriteria.carrierId) neq 0>
							AND	o.carrierId							=		<cfqueryparam value="#trim(arguments.searchCriteria.carrierId)#" cfsqltype="cf_sql_integer" />
						</cfif>
						<cfif structKeyExists(arguments.searchCriteria, 'activationType') and len(trim(arguments.searchCriteria.activationType))>
							AND	o.activationType					=		<cfqueryparam value="#trim(arguments.searchCriteria.activationType)#" cfsqltype="cf_sql_varchar" />
						</cfif>
			ORDER BY	o.OrderId DESC
		</cfquery>

		<cfreturn qOrders />
	</cffunction>


	<cffunction name="getOrderActivationLines"  output="false" access="public" returntype="query">
		<cfargument name="orderId" type="numeric" required="true" />

		<cfset var qOrders = 0 />

		<cfquery name="qOrders" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				o.OrderId
				, o.ActivationType
				, c.CompanyName
				, od.OrderDetailId
				, od.ProductTitle
				, wl.WirelessLineId
				, wl.ActivationStatus
				, CASE
					WHEN wl.ActivationStatus IS NULL THEN 'Ready'
					WHEN wl.ActivationStatus = 0 THEN 'Ready'
					WHEN wl.ActivationStatus = 1 THEN 'Requested'
					WHEN wl.ActivationStatus = 2 THEN 'Success'
					WHEN wl.ActivationStatus = 4 THEN 'Failure'
					WHEN wl.ActivationStatus = 5 THEN 'Error'
					WHEN wl.ActivationStatus = 6 THEN 'Manual'
					WHEN wl.ActivationStatus = 7 THEN 'Canceled'
					ELSE ''
				  END ActivationStatusDescription
			FROM salesorder.[Order] o WITH (NOLOCK)
			INNER JOIN salesorder.OrderDetail od WITH (NOLOCK) ON od.OrderId = o.OrderId
			INNER JOIN salesorder.WirelessLine wl WITH (NOLOCK) ON wl.OrderDetailId = od.OrderDetailId
			LEFT JOIN catalog.Company c WITH (NOLOCK) ON c.CarrierId = o.CarrierId
			WHERE
				o.OrderId = <cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_integer" />
				AND o.ActivationType NOT IN ('R')
		</cfquery>

		<cfreturn qOrders />
	</cffunction>

	<cffunction name="getStatusName" access="public" returntype="string" output="false">
		<cfreturn this.getStatusNameByValue(this.getStatus())>
	</cffunction>

	<cffunction name="getStatusNameByValue" access="public" returntype="string" output="false">
		<cfargument name="status" type="numeric" required="true" />

		<cfscript>
			var statusName = "";

			//0 = Pending, 1 = Submitted, 2 = Payment Complete, 3 = Closed, 4 = Cancelled;
			switch( arguments.Status )
			{
				case 0:
				{
					statusName = "Pending";
					break;
				}
				case 1:
				{
					statusName = "Submitted";
					break;
				}
				case 2:
				{
					statusName = "Order Placed";
					break;
				}
				case 3:
				{
					switch( this.getGersStatus() )
					{
						case 2:
						{
							statusName = "Packing";
							break;
						}
						case 3:
						{
							statusName = "Shipped";
							break;
						}
						default:
						{
							// GERS Status = -1, 0, 1
							statusName = "Processing";
							break;
						}
					}
					break;
				}
				case 4:
				{
					statusName = "Cancelled";
					break;
				}
				default:
				{
					statusName = "";
					break;
				}
			}
		</cfscript>

		<cfreturn statusName />
	</cffunction>

	<cffunction name="getGersStatusName" output="false" access="public" returntype="string">
		
		<cfset var qStatus = 0 />

		<cfquery name="qStatus" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				os.OrderStatus
				, os.OrderStatusId
				, os.OrderType
			FROM salesorder.OrderStatus os
			WHERE 
				os.OrderType = 'GERS'
				AND os.OrderStatusId = <cfqueryparam value="#this.getGersStatus()#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		
		<cfreturn qStatus.OrderStatus />
	</cffunction>

	<cffunction name="getActivationTypeName" access="public" returntype="string" output="false">
		<cfargument name="type" required="false" type="string" />

		<cfset var activationTypeName = '' />
		<cfset var switchWith = variables.instance.activationType />

		<cfif structKeyExists(arguments, 'type')>
			<cfset switchWith = trim(arguments.type) />
		</cfif>

		<cfscript>
			// N = New, U = Upgrade, A = AddALine (New Multiline is still a value of N)
			switch(switchWith)	{
				case 'N':	{
					activationTypeName = 'New';
					break;
				}
				case 'U':	{
					activationTypeName = 'Upgrade';
					break;
				}
				case 'A':	{
					activationTypeName = 'Add a Line';
					break;
				}
				case 'E':	{
					activationTypeName = 'Exchange';
					break;
				}
				case 'R':	{
					activationTypeName = 'No-Contract';
					break;
				}
				default:	{
					activationTypeName = '';
					break;
				}
			}
		</cfscript>

		<cfreturn trim(activationTypeName) />
	</cffunction>


	<cffunction name="getPendingActivations" access="public" returntype="query" output="false">
		<cfset var qActivations = 0 />

		<cfquery name="qActivations" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				OrderId
				, OrderDate
				, EmailAddress
				, ActivationType
				, CarrierId
				, CompanyName
				, CheckoutReferenceNumber
				, CurrentAcctNumber
				, PhantomInventoryCount
				, OrderAssistanceUsed
				, CASE
					WHEN ActivationStatus IS NULL THEN 'Ready'
					WHEN ActivationStatus = 0 THEN 'Ready'
					WHEN ActivationStatus = 1 THEN 'Requested'
					WHEN ActivationStatus = 2 THEN 'Success'
					WHEN ActivationStatus = 3 THEN 'Partial Success'
					WHEN ActivationStatus = 4 THEN 'Failure'
					WHEN ActivationStatus = 5 THEN 'Error'
					WHEN ActivationStatus = 6 THEN 'Manual'
					WHEN ActivationStatus = 7 THEN 'Canceled'
					ELSE ''
				  END ActivationStatusDescription					
			FROM salesOrder.ActivationsWaiting
			ORDER BY OrderDate, OrderId ASC
		</cfquery>

		<cfreturn qActivations />
	</cffunction>


	<cffunction name="getPendingCaptures" access="public" returntype="query" output="false">
		<cfset var qCaptures = 0 />

		<cfquery name="qCaptures" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				OrderId
				, OrderDate
				, EmailAddress
				, ActivationType
				, CarrierId
				, CompanyName
				, ShippingMethod
				, PhantomInventoryCount
				, OrderAssistanceUsed
			FROM salesOrder.CapturesWaiting
			ORDER BY OrderDate, OrderId ASC
		</cfquery>

		<cfreturn qCaptures />
	</cffunction>


	<cffunction name="getPendingCreditChecks" access="public" returntype="query" output="false">
		<cfset var qActivations = 0 />

		<cfquery name="qActivations" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				o.OrderId
				, o.OrderDate
				, o.CreditApplicationNumber
				, o.CreditCheckStatusCode
				, CASE o.Status
					WHEN 0 THEN 'Pending'
					WHEN 1 THEN 'Submitted'
					WHEN 2 THEN 'Order Placed'
					WHEN 3 THEN
						CASE o.GERSStatus
							WHEN 2 THEN 'Packing'
							WHEN 3 THEN 'Shipped'
							ELSE 'Processing'
						END
					WHEN 4 THEN 'Cancelled'
					ELSE ''
				  END StatusName
			FROM salesOrder.[Order] o WITH (NOLOCK)
			WHERE o.IsCreditCheckPending = 1
			ORDER BY OrderDate, OrderId ASC
		</cfquery>

		<cfreturn qActivations />
	</cffunction>


	<cffunction name="getOrderIdByCheckoutReferenceNumber" access="public" returntype="query" output="false">
		<cfargument name="CheckoutReferenceNumber" type="string" required="true" />
		<cfset var qOrder = 0 />

		<cfquery name="qOrder" datasource="#application.dsn.wirelessAdvocates#">
			SELECT o.OrderId
			FROM salesOrder.[Order] o WITH (NOLOCK)
			WHERE o.CheckoutReferenceNumber = <cfqueryparam value="#arguments.CheckoutReferenceNumber#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn qOrder />
	</cffunction>


	<cffunction name="cancel" access="public" returntype="any" output="false">
		<cfargument name="reason" type="string" required="true" />

		<cfstoredproc procedure="salesorder.CancelOrder" dataSource="#application.dsn.wirelessAdvocates#">
			<cfprocparam value="#this.getOrderId()#" cfsqltype="cf_sql_integer" />
			<cfprocparam value="#arguments.reason#" cfsqltype="cf_sql_varchar" />
		</cfstoredproc>
	</cffunction>


	<!--- ACCESSORS --->

	<cffunction name="setOrderId" access="public" returntype="void" output="false">
		<cfargument name="OrderId" type="numeric" required="true" />
		<cfset variables.instance.OrderId = trim(arguments.OrderId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.OrderId />
	</cffunction>

    <cffunction name="setParentOrderId" access="public" returntype="void" output="false">
		<cfargument name="ParentOrderId" type="numeric" required="true" />
		<cfset variables.instance.ParentOrderId = trim(arguments.ParentOrderId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getParentOrderId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ParentOrderId />
	</cffunction>

    <cffunction name="setSortCode" access="public" returntype="void" output="false">
		<cfargument name="SortCode" type="string" required="true" />
		<cfset variables.instance.SortCode = trim(arguments.SortCode) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getSortCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SortCode />
	</cffunction>


	<cffunction name="setOrderDate" access="public" returntype="void" output="false">
		<cfargument name="OrderDate" type="date" required="true" />
		<cfset variables.instance.OrderDate = arguments.OrderDate />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.OrderDate />
	</cffunction>

	<cffunction name="setPcrDate" access="public" returntype="void" output="false">
		<cfargument name="PcrDate" type="date" required="true" />
		<cfset variables.instance.PcrDate = arguments.PcrDate />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPcrDate" access="public" returntype="date" output="false">
		<cfreturn variables.instance.PcrDate />
	</cffunction>


	<cffunction name="setUserId" access="public" returntype="void" output="false">
		<cfargument name="UserId" type="numeric" required="true" />
		<cfset variables.instance.UserId = trim(arguments.UserId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getUserId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.UserId />
	</cffunction>

	<cffunction name="setCarrierId" access="public" returntype="void" output="false">
		<cfargument name="CarrierId" type="numeric" required="true" />
		<cfset variables.instance.CarrierId = trim(arguments.CarrierId) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.CarrierId />
	</cffunction>

	<cffunction name="setShipAddress" access="public" returntype="void" output="false">
		<cfargument name="ShipAddress" type="cfc.model.OrderAddress" required="true" />
		<cfset variables.instance.ShipAddress = arguments.ShipAddress />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getShipAddress" access="public" returntype="cfc.model.OrderAddress" output="false">
		<cfreturn variables.instance.ShipAddress />
	</cffunction>

	<cffunction name="setBillAddress" access="public" returntype="void" output="false">
		<cfargument name="BillAddress" type="cfc.model.OrderAddress" required="true" />
		<cfset variables.instance.BillAddress = arguments.BillAddress />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getBillAddress" access="public" returntype="cfc.model.OrderAddress" output="false">
		<cfreturn variables.instance.BillAddress />
	</cffunction>

	<cffunction name="setEmailAddress" access="public" returntype="void" output="false">
		<cfargument name="EmailAddress" type="string" required="true" />
		<cfset variables.instance.EmailAddress = trim(arguments.EmailAddress) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getEmailAddress" access="public" returntype="string" output="false">
		<!--- TRV: modifying so that we only eat the cost of this query when we've got a non-zero (non-default) userid --->
		<cfif variables.instance.userid AND NOT Len( Trim(variables.instance.EmailAddress) )>
	        <!--- MAC: set the users email based on the user id. --->
	        <cfquery name="getEmailAddress" datasource="#application.dsn.wirelessAdvocates#">
	        	select email from users where user_id = #variables.instance.userid#
	        </cfquery>
	        <cfif getEmailAddress.recordCount gt 0>
	        	<cfset this.SetEmailAddress(getEmailAddress.email)>
	        </cfif>
		</cfif>

		<cfreturn variables.instance.EmailAddress />
	</cffunction>

	<cffunction name="setShipMethod" access="public" returntype="void" output="false">
		<cfargument name="ShipMethod" type="cfc.model.ShipMethod" required="true" />
		<cfset variables.instance.ShipMethod = arguments.ShipMethod />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getShipMethod" access="public" returntype="cfc.model.ShipMethod" output="false">
		<cfreturn variables.instance.ShipMethod />
	</cffunction>

	<cffunction name="setShipCost" access="public" returntype="void" output="false">
		<cfargument name="ShipCost" type="numeric" required="true" />
		<cfset variables.instance.ShipCost = trim(arguments.ShipCost) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getShipCost" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ShipCost />
	</cffunction>

	<!--- TODO: Replace this order total with new order totals that Tyson created --->
    <cffunction name="getOrderTotal" access="public" returntype="numeric" output="false">
    	<!--- TODO: This does not account for QTY.--->
		<cfset var local = structNew()>
        <cfif this.getOrderId() gt 0>
            <cfquery name="local.getTotal" datasource="#application.dsn.wirelessAdvocates#">
                select (SUM(NetPrice + Taxes)) + (select sum(ShipCost) from salesorder.[Order] where OrderId = od.OrderId) as total from salesorder.OrderDetail od
                group by od.OrderId
                having od.OrderId = #this.getorderId()#
            </cfquery>
            <cfif local.getTotal.recordCount gt 0>
            	<cfreturn local.getTotal.total>
            <cfelse>
            	<cfreturn 0>
            </cfif>

        <cfelse>

        </cfif>
    </cffunction>

	<cffunction name="setActivationType" access="public" returntype="void" output="false">
		<cfargument name="ActivationType" type="string" required="true" />
		<cfset variables.instance.ActivationType = trim(ucase(arguments.ActivationType)) />
		<cfif len(variables.instance.ActivationType) gt 1>
			<cfset variables.instance.ActivationType = left(variables.instance.ActivationType,1) />
		</cfif>
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivationType" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ActivationType />
	</cffunction>

	<cffunction name="setMessage" access="public" returntype="void" output="false">
		<cfargument name="Message" type="string" required="true" />
		<cfset variables.instance.Message = trim(arguments.Message) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getMessage" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Message />
	</cffunction>

	<cffunction name="setIPAddress" access="public" returntype="void" output="false">
		<cfargument name="IPAddress" type="string" required="true" />
		<cfset variables.instance.IPAddress = trim(arguments.IPAddress) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getIPAddress" access="public" returntype="string" output="false">
		<cfreturn variables.instance.IPAddress />
	</cffunction>

	<cffunction name="setStatus" access="public" returntype="void" output="false">
		<cfargument name="Status" type="numeric" required="true" />
		<cfset variables.instance.log.addEvent( "Status Change", "Status", getStatusNameByValue( variables.instance.Status ) , getStatusNameByValue( arguments.Status ) ) />
		<cfset variables.instance.Status = trim(arguments.Status) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getStatus" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.Status />
	</cffunction>

	<cffunction name="setGERSStatus" access="public" returntype="void" output="false">
		<cfargument name="GERSStatus" type="numeric" required="true" />
		<cfset variables.instance.GERSStatus = trim(arguments.GERSStatus) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getGERSStatus" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.GERSStatus />
	</cffunction>

	<cffunction name="setGERSRefNum" access="public" returntype="void" output="false">
		<cfargument name="GERSRefNum" type="string" required="true" />
		<cfset variables.instance.GERSRefNum = trim(arguments.GERSRefNum) />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getGERSRefNum" access="public" returntype="string" output="false">
		<cfreturn variables.instance.GERSRefNum />
	</cffunction>

	<cffunction name="setTimeSentToGERS" access="public" returntype="void" output="false">
		<cfargument name="TimeSentToGERS" type="date" required="true" />
		<cfset variables.instance.TimeSentToGERS = arguments.TimeSentToGERS />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getTimeSentToGERS" access="public" returntype="date" output="false">
		<cfreturn variables.instance.TimeSentToGERS />
	</cffunction>

	<cffunction name="setWirelessAccount" access="public" returntype="void" output="false">
		<cfargument name="WirelessAccount" type="cfc.model.WirelessAccount" required="true" />
		<cfset variables.instance.WirelessAccount = arguments.WirelessAccount />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getWirelessAccount" access="public" returntype="cfc.model.WirelessAccount" output="false">
		<cfreturn variables.instance.WirelessAccount />
	</cffunction>

	<cffunction name="setPayments" access="public" returntype="void" output="false">
		<cfargument name="payments" type="cfc.model.payment[]" required="true" />

		<cfset variables.instance.payments = arguments.payments />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getPayments" access="public" returntype="cfc.model.payment[]" output="false">
		<cfreturn variables.instance.payments />
	</cffunction>

	<cffunction name="addPayment" access="public" returntype="void" output="false">
		<cfargument name="payment" type="cfc.model.payment" required="true" />

		<cfset variables.instance.payments[arrayLen(variables.instance.payments) + 1] = arguments.payment />

		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getOrderDetail" access="public" returntype="cfc.model.OrderDetail[]" output="false">
		<!--- returns a list of Order --->
		<cfset var local = structNew()>
		<!--- query all orders --->
        <cfquery name="local.qGetOrderDetails" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
        	select OrderDetailId
            from salesorder.OrderDetail
            where
            	OrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#">
        </cfquery>

        <cfset local.orderDetails = arrayNew(1)>

        <cfset counter = 1>
        <cfloop query="local.qGetOrderDetails">
        	<cfset local.orderDetails[counter] = createObject("component","cfc.model.OrderDetail").init()>
			<cfset local.orderDetails[counter].load(local.qGetOrderDetails.OrderDetailId)>
			<cfset counter = counter + 1>
        </cfloop>

        <cfreturn local.OrderDetails>

	</cffunction>


	<cffunction name="hasRatePlan" access="public" returntype="boolean" output="false">
		<cfset var orderDetails = getOrderDetail() />
		<cfset var orderDetail = '' />
		<cfset var hasRatePlan = false />

		<cfif ArrayLen( orderDetails )>
	        <cfloop array="#orderDetails#" index="orderDetail">
	        	<cfif orderDetail.getOrderDetailType() eq 'r'>
					<cfset hasRatePlan = true />
					<cfbreak />
				</cfif>
	        </cfloop>
		</cfif>

		<cfreturn hasRatePlan />
	</cffunction>


	<cffunction name="setWirelessLines" access="public" returntype="void" output="false">
		<cfargument name="WirelessLines" type="cfc.model.WirelessLine[]" required="true" />
		<cfset variables.instance.WirelessLines = arguments.WirelessLines />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getWirelessLines" access="public" returntype="cfc.model.WirelessLine[]" output="false">
		<cfreturn variables.instance.WirelessLines />
	</cffunction>

	<cffunction name="setOtherItems" access="public" returntype="void" output="false">
		<cfargument name="OtherItems" type="cfc.model.OrderDetail[]" required="true" />
		<cfset variables.instance.OtherItems = arguments.OtherItems />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOtherItems" access="public" returntype="cfc.model.OrderDetail[]" output="false">
		<cfreturn variables.instance.OtherItems />
	</cffunction>

	<cffunction name="setSalesTaxTransactionId" access="public" returntype="void" output="false">
		<cfargument name="SalesTaxTransactionId" type="string" required="true" />
		<cfset variables.instance.SalesTaxTransactionId = arguments.SalesTaxTransactionId />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getSalesTaxTransactionId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SalesTaxTransactionId />
	</cffunction>

	<cffunction name="setIsSalesTaxTransactionCommited" access="public" returntype="void" output="false">
		<cfargument name="IsSalesTaxTransactionCommited" type="string" required="true" />
		<cfset variables.instance.IsSalesTaxTransactionCommited = arguments.IsSalesTaxTransactionCommited />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getIsSalesTaxTransactionCommited" access="public" returntype="string" output="false">
		<cfreturn variables.instance.IsSalesTaxTransactionCommited />
	</cffunction>

	<cffunction name="setSalesTaxRefundTransactionId" access="public" returntype="void" output="false">
		<cfargument name="SalesTaxRefundTransactionId" type="string" required="true" />
		<cfset variables.instance.SalesTaxRefundTransactionId = arguments.SalesTaxRefundTransactionId />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getSalesTaxRefundTransactionId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.SalesTaxRefundTransactionId />
	</cffunction>

	<cffunction name="setCheckoutReferenceNumber" access="public" returntype="void" output="false">
		<cfargument name="checkoutReferenceNumber" type="string" required="true" />
		<cfset variables.instance.checkoutReferenceNumber = arguments.checkoutReferenceNumber />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCheckoutReferenceNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.checkoutReferenceNumber />
	</cffunction>

	<cffunction name="setOrderAssistanceUsed" access="public" returntype="void" output="false">
		<cfargument name="OrderAssistanceUsed" type="boolean" required="true" />
		<cfset variables.instance.OrderAssistanceUsed = arguments.OrderAssistanceUsed />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getOrderAssistanceUsed" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.OrderAssistanceUsed />
	</cffunction>

	<cffunction name="setIsCreditCheckPending" access="public" returntype="void" output="false">
		<cfargument name="IsCreditCheckPending" type="boolean" required="true" />
		<cfset variables.instance.IsCreditCheckPending = arguments.IsCreditCheckPending />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getIsCreditCheckPending" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsCreditCheckPending />
	</cffunction>

	<cffunction name="setCreditApplicationNumber" access="public" returntype="void" output="false">
		<cfargument name="CreditApplicationNumber" type="string" required="true" />
		<cfset variables.instance.CreditApplicationNumber = arguments.CreditApplicationNumber />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCreditApplicationNumber" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CreditApplicationNumber />
	</cffunction>

	<cffunction name="setCreditCheckStatusCode" access="public" returntype="void" output="false">
		<cfargument name="CreditCheckStatusCode" type="string" required="true" />
		<cfset variables.instance.log.addEvent( "Credit Check Status Change", "CreditCheckStatusCode", variables.instance.CreditCheckStatusCode, arguments.CreditCheckStatusCode ) />
		<cfset variables.instance.CreditCheckStatusCode = arguments.CreditCheckStatusCode />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCreditCheckStatusCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CreditCheckStatusCode />
	</cffunction>

	<cffunction name="setServiceZipCode" access="public" returntype="void" output="false">
		<cfargument name="ServiceZipCode" type="string" required="true" />
		<cfset variables.instance.ServiceZipCode = arguments.ServiceZipCode />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getServiceZipCode" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ServiceZipCode />
	</cffunction>

	<cffunction name="setIsDirty" access="public" returntype="void" output="false">
		<cfargument name="IsDirty" type="boolean" required="true" />
		<cfset variables.instance.IsDirty = arguments.IsDirty />
	</cffunction>
	<cffunction name="getIsDirty" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.IsDirty />
	</cffunction>

    <cffunction name="ConvertOrderAddressToAddress" access="public" returntype="cfc.model.Address" output="false">
		<cfargument name="OrderAddress" type="cfc.model.OrderAddress" required="true" />
		<cfset var local = structnew()>

        <cfset local.orderAddress = arguments.OrderAddress>

        <!--- convert this orderAddress to a standard Address --->
        <cfscript>
        	local.address = createobject('component','cfc.model.Address').init();
        	local.address.setAddressLine1(local.orderAddress.getAddress1());
       		local.address.setAddressLine2(local.orderAddress.getAddress2());
        	local.address.setAddressLine3(local.orderAddress.getAddress3());
        	local.address.setCity(local.orderAddress.getCity());
        	local.address.setState(local.orderAddress.getState());
        	local.address.setZipCode(local.orderAddress.getZip());
        	local.address.setZipCodeExtension(""); //not implemented
        	local.address.setCountry("US"); //default to US
        	local.address.setCompany(local.orderAddress.getCompany());
        	local.address.setFirstName(local.orderAddress.getFirstName());
        	local.address.setLastName(local.orderAddress.getLastName());
        	local.address.setMiddleInitial(""); //not implemented
        	local.address.setDayPhone(local.orderAddress.getDaytimePhone());
        	local.address.setEvePhone(local.orderAddress.getEveningPhone());

		</cfscript>

        <cfreturn local.address>

	</cffunction>

	<!--- returns a list of order objects for this order. --->
	<cffunction name="GetChildOrders" access="public" returntype="cfc.model.Order[]" output="false">
		<cfset var local = structNew()>
        <cfset local.childOrders = arrayNew(1)>

        <cfquery name="local.qGetChildOrders" datasource="#application.dsn.wirelessAdvocates#" result="local.saveResult">
        	select OrderId
            from salesorder.[Order] WITH (NOLOCK)
            where ParentOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getOrderId()#">
        </cfquery>

        <cfloop query="local.qGetChildOrders">
        	<cfset local.myOrder = createObject("component","cfc.model.Order").init()>
            <cfset local.myOrder.load(local.qGetChildOrders.orderId)>

            <cfset arrayAppend(local.childOrders, local.myOrder)>

        </cfloop>

        <cfreturn local.childOrders>


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

	<cffunction name="getUnlockDateTime" access="public" returntype="string" output="false">
		<cfscript>
			var unlockDateTime = '';
		
			if (Len(variables.instance.LockDateTime))
			{
				unlockDateTime = DateAdd('n', 10, variables.instance.LockDateTime); //Lock time is 10 minutes
			}
		</cfscript>

		<cfreturn unlockDateTime />
	</cffunction>

	<cffunction name="containsWarranty" access="public" returntype="boolean" output="false">

		<cfscript>
			var wirelessLines = this.getWirelessLines();
			var containsWarranty = false;
			var i = 0;
		
			for (i=1; i <= ArrayLen(wirelessLines); i++)
			{
				if (wirelessLines[i].getLineWarranty().getProductId() neq 0)
				{
					containsWarranty = true;
					break;
				}
			}
		</cfscript>

		<cfreturn containsWarranty />
	</cffunction>

	<cffunction name="getWarrantyProvider" access="public" returntype="string" output="false">

		<cfscript>
			var wirelessLines = this.getWirelessLines();
			var providerName = '';
			var qWarranty = '';
			var i = 0;
			var warrantyId = 0;
		
			for (i=1; i <= ArrayLen(wirelessLines); i++)
			{
				warrantyId = wirelessLines[i].getLineWarranty().getProductId();
				qWarranty = application.model.Warranty.getById( warrantyId );
				
				if (warrantyId neq 0)
				{
					providerName = qWarranty.CompanyName;
					break;
				}
			}
		</cfscript>

		<cfreturn providerName />
	</cffunction>
	
	<cffunction name="getOrderDiscountTotal" access="public" returntype="numeric" output="false" hint="Returns combined total of discounts on order and order detail records.">
		<cfscript>
			var totalDiscount = 0;
			var orderDiscount = getDiscountTotal();
			var orderDetails = getOrderDetail();
			var orderDetail = "";
			var i = "";
			
			if( isNumeric( orderDiscount ) )
				totalDiscount += orderDiscount;
			
			for( i=1; i <= arrayLen(orderDetails); i++ ) {
				OrderDetail = orderDetails[i];
				if( isNumeric(OrderDetail.getDiscountTotal()))
					totalDiscount += OrderDetail.getDiscountTotal();
			}
			
			return totalDiscount;
		</cfscript>
	</cffunction>
	
	<cffunction name="getPromotionCodeList" access="public" output="false" returntype="string" hint="Returns list of codes applied to this order.">    
		<cfreturn getPromotionService().getCodeListForOrder( orderID = getOrderID() )>
	</cffunction>

	<cffunction name="setDiscountTotal" access="public" returntype="void" output="false">
		<cfargument name="discountTotal" required="true" type="numeric" />

		<cfset variables.instance.discountTotal = arguments.discountTotal />
	</cffunction>

	<cffunction name="getDiscountTotal" access="public" returntype="numeric" output="false">

		<cfreturn variables.instance.discountTotal />
	</cffunction>

	<cffunction name="setKioskEmployeeNumber" access="public" returntype="void" output="false">
		<cfargument name="employeeNumber" required="true" type="string" />

		<cfset variables.instance.kioskEmployeeNumber = arguments.employeeNumber />
	</cffunction>

	<cffunction name="getKioskEmployeeNumber" access="public" returntype="string" output="false">

		<cfreturn variables.instance.kioskEmployeeNumber />
	</cffunction>

	<cffunction name="setShipmentDeliveryDate" access="public" returntype="void" output="false">
		<cfargument name="ShipmentDeliveryDate" required="true" type="string" />
		<cfset variables.instance.ShipmentDeliveryDate = arguments.ShipmentDeliveryDate />
	</cffunction>

	<cffunction name="getShipmentDeliveryDate" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ShipmentDeliveryDate />
	</cffunction>

	<cffunction name="setLockDateTime" access="public" returntype="void" output="false">
		<cfargument name="LockDateTime" required="true" type="string" />
		<cfset variables.instance.LockDateTime = arguments.LockDateTime />
		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getLockDateTime" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LockDateTime />
	</cffunction>
	
	<cffunction name="setLockedById" access="public" returntype="void" output="false">
		<cfargument name="LockedById" required="true" type="string" />
		<cfset variables.instance.LockedById = arguments.LockedById />
		<cfset this.setIsDirty(true) />
	</cffunction>

	<cffunction name="getLockedById" access="public" returntype="string" output="false">
		<cfreturn variables.instance.LockedById />
	</cffunction>

	<cffunction name="setPaymentCapturedById" access="public" returntype="void" output="false">
		<cfargument name="PaymentCapturedById" required="true" type="numeric" />
		<cfset variables.instance.PaymentCapturedById = arguments.PaymentCapturedById />
		<cfset setPaymentCapturedByUserName(arguments.PaymentCapturedById) /><!--- get the actual user name stored as well --->
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getPaymentCapturedById" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.PaymentCapturedById />
	</cffunction>
	<cffunction name="setPaymentCapturedByUserName" access="public" returntype="void" output="false">
		<cfargument name="PaymentCapturedById" required="true" type="numeric" />
		<cfif arguments.PaymentCapturedById gt 0>
			<cfquery name="qCapturedByUser" datasource="wirelessadvocates" >
				select UserName from dbo.Users where User_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PaymentCapturedById#" /> 	
			</cfquery>
			<cfif qCapturedByUser.recordcount gt 0>
				<cfset variables.instance.PaymentCapturedByUserName = qCapturedByUser.UserName />
			 </cfif>	
		</cfif>
	</cffunction>
	<cffunction name="getPaymentCapturedByUserName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.PaymentCapturedByUserName />
	</cffunction>

	<cffunction name="setActivatedById" access="public" returntype="void" output="false">
		<cfargument name="ActivatedById" required="true" type="numeric" />
		<cfset variables.instance.ActivatedById = arguments.ActivatedById />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getActivatedById" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.ActivatedById />
	</cffunction>	

	<cffunction name="setCreditCheckKeyInfoId" access="public" returntype="void" output="false">
		<cfargument name="CreditCheckKeyInfoId" required="true" type="numeric" />
		<cfset variables.instance.CreditCheckKeyInfoId = arguments.CreditCheckKeyInfoId />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCreditCheckKeyInfoId" access="public" returntype="numeric" output="false">
		<cfreturn variables.instance.CreditCheckKeyInfoId />
	</cffunction>
	
	<cffunction name="setPaymentGatewayID" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["paymentGatewayID"] = arguments.theVar />
		<cfset this.setIsDirty(true) />    
	</cffunction>
	<cffunction name="getPaymentGatewayID" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["paymentGatewayID"]/>    
    </cffunction>    

	<cffunction name="setCarrierConversationId" access="public" returntype="void" output="false">
		<cfargument name="CarrierConversationId" required="true" type="string" />
		<cfset variables.instance.CarrierConversationId = arguments.CarrierConversationId />
		<cfset this.setIsDirty(true) />
	</cffunction>
	<cffunction name="getCarrierConversationId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.CarrierConversationId />
	</cffunction>
		
	<cffunction name="getInstantRebateAmount" access="public" output="false" returntype="numeric">    
    	<cfreturn variables.instance["instantRebateAmount"]/>
		<cfset this.setIsDirty(true) />     
    </cffunction>    
    <cffunction name="setInstantRebateAmount" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["instantRebateAmount"] = arguments.theVar />    
    </cffunction>

	<cffunction name="setCampaignId" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["CampaignId"] = arguments.theVar />
		<cfset this.setIsDirty(true) />    
	</cffunction>
	<cffunction name="getCampaignId" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["CampaignId"]/>    
    </cffunction>   

	<cffunction name="setSmsOptIn" access="public" output="false" returntype="void">    
    	<cfargument name="SmsOptIn" required="true" />    
    	<cfset variables.instance["SmsOptIn"] = arguments.SmsOptIn />
		<cfset this.setIsDirty(true) />    
	</cffunction>
	<cffunction name="getSmsOptIn" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["SmsOptIn"] />
    </cffunction>  
    
    <cffunction name="setScenarioId" access="public" output="false" returntype="void">    
    	<cfargument name="ScenarioId" required="true" />    
    	<cfset variables.instance["ScenarioId"] = arguments.ScenarioId />
		<cfset this.setIsDirty(true) />    
	</cffunction>
	<cffunction name="getScenarioId" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["ScenarioId"] />
    </cffunction>
    
    <cffunction name="setKioskId" access="public" output="false" returntype="void">    
    	<cfargument name="KioskId" required="true" />    
    	<cfset variables.instance["KioskId"] = arguments.KioskId />
		<cfset this.setIsDirty(true) />    
	</cffunction>
	<cffunction name="getKioskId" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["KioskId"] />
    </cffunction>
    
    <cffunction name="setAssociateId" access="public" output="false" returntype="void">    
    	<cfargument name="AssociateId" required="true" />    
    	<cfset variables.instance["AssociateId"] = arguments.AssociateId />
		<cfset this.setIsDirty(true) />    
	</cffunction>
	<cffunction name="getAssociateId" access="public" output="false" returntype="string">    
    	<cfreturn variables.instance["AssociateId"] />
    </cffunction>
    <!--- Beans --->
    
    <cffunction name="getPromotionService" access="public" output="false" returntype="any">    
    	<cfreturn application.wirebox.getInstance("PromotionService") />
    </cffunction>    

</cfcomponent>
