<cfcomponent displayname="AttCarrierHelper" hint="Interface to ATT Carrier API" extends="fw.model.CarrierApi.CarrierHelper" output="false">

	<cfproperty name="CarrierFacade" inject="id:CarrierFacade" />

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrierHelper">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
				
		<cfreturn this />
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->
	
	<cffunction name="getSubmitCompletedOrderRequest" output="false" access="public" returntype="struct">
		<cfset var local = structNew() />
		<cfset local.socr = structNew() />
		
		<cfquery name="qOrderSubmission" datasource="wirelessadvocates" maxrows="1">
			SELECT OrderEntry FROM [service].[OrderSubmissionLog] 
			WHERE orderid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderid#" > 
		</cfquery>
		
		<cfif qOrderSubmission.recordcount is not 0>
			<cfreturn carrierFacade.deserializeResponse(#qOrderSubmission.OrderEntry#) />
		<cfelse>
			<cfreturn structNew() />
		</cfif>			
		
	</cffunction>
			
	<cffunction name="getSubmitOrderRequest" output="false" access="public" returntype="struct">
		
		<cfset var local = structNew() />
		<cfset local.sor = structNew() />
		
		<cfif structKeyExists(session,"carrierFacade") is false>
			<cfset local.sor.errorMessage = "CarrierFacade is missing from session" />
			<cfreturn local.sor />
		</cfif>
		
		<cfif structKeyExists(session,"cartFacade") is false>
			<cfset local.sor.errorMessage = "CartFacade is missing from session" />
			<cfreturn local.sor />
		</cfif>
		<cfif structKeyExists(session.cartfacade,"subscriberIndices") is false>
			<cfset local.sor.errorMessage = "CartFacade.subscriberIndices is missing from session" />
			<cfreturn local.sor />
		</cfif>

		
		<!--- Verify the required carrier responses are store in the session --->
		<cfif structKeyExists(session.carrierFacade,"AccountResp") is false>
			<cfset local.sor.errorMessage = "AccountResp is missing from session.carrierFacade" />
			<cfreturn local.sor />
		</cfif>
		<cfif structKeyExists(session.carrierFacade,"FinanceAgreementResp") is false>
			<cfset local.sor.errorMessage = "FinanceAgreementResp is missing from session.carrierFacade" />
			<cfreturn local.sor />
		</cfif>
		<cfif structKeyExists(session,"Order") is false>
			<cfset local.sor.errorMessage = "Order is missing from session" />
			<cfreturn local.sor />
		</cfif>
		
		<!--- Build the request --->
		<cfset local.sor.carrierid = 109 />
		<cfset local.sor.channel = getChannelValue() />
		<cfset local.sor.account = session.carrierfacade.accountresp.account />
		<cfset local.sor.OrderItems = arrayNew(1) />
		<cfset local.i = 0 />
		<cfloop array="#session.carrierFacade.financeAgreementResp.AgreementItems#" index="faai">
			<cfset local.i = local.i+1 />
			<cfset arrayAppend(local.sor.orderItems, getOrderItem(faai,local.i)) />
		</cfloop>
		
		<!--- return the completed request --->
		<cfreturn local.sor/>
		
	</cffunction>
	
	<cffunction name="getOrderItem" output="false" access="public" returntype="struct">
		<cfargument name="faai" type="struct" required="true" />
		<cfargument name="LineNo" type="numeric" required="true" />
		<cfset var local = structNew() />
		<cfset local.orderItem = structNew() />
		<cfset local.wirelesslines = session.order.getWirelessLines() />
		
		<cfset local.uuid = createUUID() />
		<cfset local.orderItem.Identifier = left(local.uuid,19) & mid(local.uuid,20,4) & '-' & right(local.uuid,12) />
		<cfset local.orderitem.RequestType = getRequestType(session.order.getActivationTypeName()) />
		<cfset local.orderitem.FinanceAgreementItem = arguments.faai />
		<cfset local.orderItem.UpgradeQualification = arguments.faai.attDeviceOrderItem.subscriber.upgradeQualifications />
		<cfset local.Imei = local.wirelessLines[arguments.LineNo].getImei() />
		<cfset local.Sim = local.wirelessLines[arguments.LineNo].getSim() />
		<cfif local.Imei is "">
			<cfset local.Imei = "TestIMEI1234" />
		</cfif>
		<cfif local.Sim is "">
			<cfset local.Sim = "TestSIM4567" />
		</cfif>
		<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.deviceInfo.imei = local.Imei />
		<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.deviceInfo.sim = local.Sim />
		<cfreturn local.orderItem />
		
		
	</cffunction>
	
	<cffunction name="getRequestType" returnType="numeric" access="public" >
		<cfargument name="activationType" type="string" required="true" /> 
		
		<cfswitch expression="#arguments.activationType#">
			<cfcase value="New">
				<cfreturn 4 />
			</cfcase>
			<cfcase value="Upgrade">
				<cfreturn 1 />
			</cfcase>
			<cfcase value="Add a Line">
				<cfreturn 2 />
			</cfcase>
			<cfdefaultcase>
				<cfreturn 0 />
			</cfdefaultcase>			
		</cfswitch>
		
		<cfreturn 0 />
		
	</cffunction>
	
	<cffunction name="getFinanceAgreementRequest" output="false" access="public" returntype="struct">
		<cfset var local = structNew() />
		<cfset local.far = structNew() />
		<cfset local.far.OrderItems = arrayNew(1) />
		
		<cfif structkeyExists(session,"cart")>
			<cfset local.cartLines = session.cart.getLines() />
			<cfset local.LineNo = 0 />
			<cfloop array="#local.cartLines#" index="local.cl">
				<cfset local.lineNo = local.lineNo+1 />
				<cfset local.orderItem = structNew() />
				<cfset arguments.subscriberIndex = local.cl.getSubscriberIndex() />
				<cfset local.orderItem.SubscriberNumber = getSubscriberNumberInfo(argumentCollection=arguments) />
				<cfset local.orderItem.Subscriber = arguments.accountRespObj.getAccount().Subscribers[arguments.subscriberIndex] />
				<cfset local.orderItem.DeviceInfo = getDeviceInfo(local.lineNo) />
				<cfset local.deviceDetail = getDeviceDetail(local.lineNo) />
				<cfset local.orderItem.ContractTerm = local.deviceDetail.contractTerm />
				<cfset local.orderItem.MSRP = local.deviceDetail.MSRP />
				<cfset local.orderItem.DownPayment = local.deviceDetail.DownPayment />
				<cfset arrayAppend(local.far.OrderItems,local.orderItem) />
			</cfloop>	
			
			<cfset local.far.RequestedFormat = 1 /><!--- 0=HTML, 1=PDF --->
			<cfset local.far.Account = arguments.accountRespObj.getAccount() />
			<cfset local.far.Channel = arguments.channel/>
		</cfif> 
		
		<cfreturn local.far />		
	</cffunction>
	
	<cffunction name="getDeviceInfo" access="private" returnType="struct">
		<cfargument name="cartLineNo" type="numeric" required="true" />
		<cfset var local = structNew() />
		<cfset local.deviceInfo = structNew()/>
		<cfset local.device = application.model.dBuilderCartFacade.getDevice(arguments.cartLineNo) />
		<cfset local.deviceInfo.FullRetailPrice = local.device.productDetail.getRetailPrice() />
		<cfset local.deviceInfo.Family = local.device.productDetail.getManufacturerName() />
		<cfset local.deviceInfo.Identifier = local.device.productDetail.getItemId() />
		<cfset local.deviceInfo.Category =  local.device.productDetail.getImeiType() />
		<cfreturn local.deviceInfo />		
	</cffunction>
		
	<cffunction name="getDeviceDetail" access="private" returnType="struct">
		<cfargument name="cartLineNo" type="numeric" required="true" />
		<cfset var local = structNew() />
		<cfset local.cartLines = session.cart.getLines() />
		<cfset local.cartLine = local.cartLines[arguments.cartLineNo] />
		<cfset local.deviceDetail = structNew()/>
		<cfset local.device = application.model.dBuilderCartFacade.getDevice(arguments.cartLineNo) />
		<cfset local.deviceDetail.contractTerm = local.device.contractMonths />
		<cfset local.deviceDetail.MSRP = local.device.productDetail.getRetailPrice() />
		<cfset local.deviceDetail.DownPayment = local.cartLine.getPhone().getPrices().getDownPaymentAmount() /> 
		<cfreturn local.deviceDetail />
	</cffunction>
	
	<cffunction name="getSubscriberNumberInfo" access="private" returnType="struct">
		<cfset var local = structNew() />
		<cfset local.sni = structNew() />
		<cfset local.subscriber = arguments.accountRespObj.getAccount().Subscribers[arguments.subscriberIndex] />
		<cfset local.sni.NumberSource = 0 /> <!--- 0=SubscriberNumber, 1=ServiceArea, 2=SubscriberNumberPort --->
		<cfset local.sni.SubscriberNumber = local.subscriber.number />	
		<cfreturn local.sni />			
	</cffunction>	

	<cffunction name="convertPdf" access="public" output="yes" returntype="void">
		<cfargument name="pdfBinary" type="string" required="true" > 
		
		<cfcontent type="application/pdf"  > 
		<cfoutput>#base64ToBinary(pdfBinary)#</cfoutput>

	</cffunction>
	
	
	
</cfcomponent>	