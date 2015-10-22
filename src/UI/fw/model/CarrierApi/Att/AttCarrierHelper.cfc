<cfcomponent displayname="AttCarrierHelper" hint="Interface to ATT Carrier API" extends="fw.model.CarrierApi.CarrierHelper" output="false">
	
	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrierHelper">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
		
		<cfreturn this />
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->
	
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