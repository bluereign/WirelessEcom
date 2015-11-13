<cfcomponent displayname="AttCarrierHelper" hint="Interface to ATT Carrier API" extends="fw.model.CarrierApi.CarrierHelper" output="false">

	<cfproperty name="CarrierFacade" inject="id:CarrierFacade" />
	<cfproperty name="BaseCarrier" inject="id:BaseCarrier" />

	<cffunction name="init" output="false" access="public" returntype="fw.model.carrierApi.Att.AttCarrierHelper">
		<cfargument name="ServiceURL" type="string" required="true" />
		
		<cfset variables.CarrierServiceURL = arguments.serviceURL />
				
		<cfreturn this />
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------------
		Helper Functions		
	 --------------------------------------------------------------------------------------------------->
	 
	<cffunction name="conflictsResolvable" output="false" access="public" returntype="boolean">
		<cfargument name="carrierid" type="numeric" required="true" > 
		<cfargument name="subscriberNumber" type="string" required="true" > 
		<cfargument name="productId" type="numeric" required="false" > 
		<cfargument name="imeitype" type="string" required="false" > 
		
		<cfset var local = structNew() />
		
		<!--- Used passed productid to retrieve the IMEI type --->
		<!---<cfif structKeyExists(arguments,"imeiType") >
			<cfset local.imeiType = arguments.ImeiType />
		<cfelseif structKeyExists(arguments,"productid") >
			<cfset local.qphone = application.model.Phone.getByFilter(idList = arguments.productid) />
			<cfif local.qphone.recordcount is 1 and local.qphone.ImeiType is not "">
					<cfset local.imeiType = local.qphone.ImeiType />
			</cfif>
		</cfif>--->
		
		<cfif structKeyExists(arguments,"imeiType")>
			<cfset local.imeiType = arguments.imeiType />
		</cfif>
		<cfif structKeyExists(arguments,"productInfo")>		
			<cfset local.productInfo = getGetProductInfo( argumentCollection = arguments ) />
			<cfset local.imeiType = local.productInfo.imeiType />
		</cfif>
		
		<cfif isdefined("session.carrierfacade.accountResp.IncompatibleOffers")>
			<cfloop array="#session.carrierfacade.accountResp.IncompatibleOffers#" index="local.io">
				<cfif local.io.subscriberNumber is arguments.subscriberNumber AND local.io.ImeiType is local.imeiType>
					<cfreturn local.io.conflictsResolvable />
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- If it's not found then there are no incompatibleOffers so they are resolveable --->
		<cfreturn true />
		
	</cffunction>
		
	<cffunction name="isGroupPlan" output="false" access="public" returntype="boolean">
		
		<cfif isdefined("session.carrierfacade.accountresp.account.subscribers")>
			<cfreturn session.carrierfacade.accountresp.account.subscribers[1].planInfo.IsGroupPlan is true />
		</cfif>
		<cfreturn false />
	</cffunction>	
	
	<cffunction name="getSubscriberPaymentPlan" output="false" access="public" returntype="struct">
		<cfargument name="carrierid" type="numeric" required="true" > 
		<cfargument name="subscriberNumber" type="string" required="true" > 
		<cfargument name="productId" type="numeric" required="false" > 
		<cfargument name="PlanIdentifier" type="string" required="false" > 
		
		<cfset var local = structNew() />

		<cfset local.subscriberPaymentPlans = getSubscriberPaymentPlans(argumentCollection = arguments )/>
		<cfif isArray(local.subscriberPaymentPlans)>
			<cfloop array="#local.subscriberPaymentPlans#" index="local.sp">
				<cfif local.sp.planIdentifier is arguments.planIdentifier>
					<cfreturn local.sp />
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn structNew() />
	</cffunction>
	
	<cffunction name="getSubscriberPaymentPlans" output="false" access="public" returntype="array">		
		<cfargument name="carrierid" type="numeric" required="true" > 
		<cfargument name="subscriberNumber" type="string" required="true" > 
		<cfargument name="productId" type="numeric" required="false" > 
		<cfargument name="imeitype" type="string" required="false" > 
		<cfset var local = structNew() />
		<cfset local.subscriberPaymentPlans = arrayNew(1) />

		<cfif structKeyExists(arguments,"imeiType")>
			<cfset local.imeiType = arguments.imeiType />
		</cfif>
		<cfif structKeyExists(arguments,"productId")>		
			<cfset local.productInfo = getProductInfo( argumentCollection = arguments ) />
			<cfset local.imeiType = local.productInfo.imeiType />
		</cfif>
		
		<cfset local.subscriber = findSubscriber(arguments.subscriberNumber) />
		<cfif not structIsEmpty(local.subscriber)>
			<cfloop array="#local.subscriber.UpgradeQualifications.QualificationDetails[1].BaseOfferQualificationDetails#" index="local.boqd">
				<!--- make sure the imeitype is valid for this plan --->
				<cfif listFindNoCase(local.boqd.imeiType,local.imeiType)>
					<cfset local.subscriberPaymentPlan = structNew() />
					<cfset local.subscriberPaymentPlan.PlanIdentifier = local.boqd.planIdentifier />
					<cfset local.subscriberPaymentPlan.MinimumCommitment = local.boqd.minimumCommitment />
					<cfset local.subscriberPaymentPlan.OfferType = local.boqd.offerType />
					<cfset local.subscriberPaymentPlan.DownPaymentPercent = local.boqd.DownPaymentPercent />
					<cfset local.subscriberPaymentPlan.OfferCategory = local.boqd.OfferCategory />
					<cfif structKeyExists(local,"productInfo") >
						<cfif local.boqd.minimumCommitment ge 1>
							<cfset local.subscriberPaymentPlan.monthlyPayment = (local.productInfo.FinancedFullRetailPrice - ((local.boqd.DownPaymentPercent*local.productInfo.FinancedFullRetailPrice)/100))/local.boqd.minimumCommitment />
						<cfelse>
							<cfset local.subscriberPaymentPlan.monthlyPayment = 0>
						</cfif>
					</cfif>
					<cfset arrayAppend(local.subscriberPaymentPlans,local.subscriberPaymentPlan) />
				</cfif>				
			</cfloop>
		</cfif>
		<cfreturn local.subscriberPaymentPlans />	
	</cffunction>
	
	<cffunction name="getSubmitCompletedOrderRequest" output="false" access="public" returntype="struct">
		<cfset var local = structNew() />
		<cfset local.socr = structNew() />
		
		<cfquery name="qOrderSubmission" datasource="wirelessadvocates" maxrows="1">
			SELECT OrderEntry FROM [service].[OrderSubmissionLog] 
			WHERE orderid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderid#" > 
		</cfquery>
		
		<cfif qOrderSubmission.recordcount is not 0>
			<cfreturn baseCarrier.deserializeResponse(#qOrderSubmission.OrderEntry#) />
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
	
	<!--- utility function used by getSubmitOrderRequest --->
	<cffunction name="getOrderItem" output="false" access="private" returntype="struct">
		<cfargument name="faai" type="struct" required="true" />
		<cfargument name="LineNo" type="numeric" required="true" />		
		
		<cfset var local = structNew() />
		<cfset local.orderItem = structNew() />
		<cfset local.wirelesslines = session.order.getWirelessLines() />
		<cfset local.cartlines = session.cart.getLines() />
		<cfset local.subscriberPaymentPlan = local.cartLines[arguments.LineNo].getPaymentPlanDetail() />
		<cfset local.subscriber = findSubscriber(faai.attdeviceorderitem.subscriber.Number) />
		
		<cfset local.orderItem.Identifier = createGUID() />
		<cfset local.orderitem.RequestType = getRequestType(session.order.getActivationTypeName()) />
		<cfset local.orderitem.FinanceAgreementItem = arguments.faai />
		
		<!--- This code executed when the user is changing data plans --->
		<cfif structKeyExists(local.subscriber,"WAFLAG_PLANHASCHANGED")>
			<cfset structDelete(local.orderITem.FinanceAgreementItem.AttDeviceOrderItem.subscriber,"planInfo") />
			<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.planInfo = structNew() />
			<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.planInfo.Identifier = "SDDVRP" />
			<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.planInfo.RecurringFee = 0 />
			<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.planInfo.ActionCode = "A" />
			<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.planInfo.IsGroupPlan = false />
			<cfif isdefined("session.carrierFacade.IncompatibleOfferResp.Items")>
				<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.AdditionalOfferings = session.carrierFacade.IncompatibleOfferResp.Items />
			<cfelse>
				<cfset local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.AdditionalOfferings = arrayNew(1) />
			</cfif>
			<cfif isdefined("session.carrierFacade.IncompatibleOfferRequest.additionalOffers")>
				<cfloop array="#session.carrierFacade.IncompatibleOfferRequest.additionalOffers#" index="local.ao">
					<cfif local.ao.action is "A">
						<cfset arrayAppend(local.orderItem.FinanceAgreementItem.AttDeviceOrderItem.subscriber.AdditionalOfferings,local.ao) />
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<!--- determine the appropriate upgradeQualificationDetails to use --->
		<cfloop array="#arguments.faai.attDeviceOrderItem.subscriber.upgradeQualifications.qualificationDetails[1].BaseOfferQualificationDetails#" index="local.boqd">
			<cfif local.boqd.planIdentifier is local.subscriberPaymentPlan.planIdentifier>
				<cfset local.orderItem.UpgradeQualification = local.boqd />
			</cfif>
		</cfloop>
		
		
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
	
	<cffunction name="loadEConsent" output="false" access="public" returntype="string">
		<cfargument name="orderid" type="numeric" required="true" > 
		<cfset var local = structNew() />
		
			<cfstoredproc datasource="wirelessadvocates" procedure="service.AttFinanceAgreementGet" result="local.results">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#arguments.orderid#" > 
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="2" > 
				<cfprocresult name="local.qEConsent" >
			</cfstoredproc>

			<cfif local.qEConsent.recordcount gt 0>
				<cfreturn base64ToString(local.qEConsent.AgreementEntry) />
			<cfelse>
				<cfreturn "" />
			</cfif>
	</cffunction>
	
	<cffunction name="saveEConsent" output="false" access="public" returntype="boolean">
		<cfset var local = structNew() />
		
		<!--- make sure we have the info stored in session --->
		<cfif not structKeyExists (session,"carrierFacade") >
			<cfreturn false />
		</cfif>
		<cfif not structKeyExists (session.carrierFacade,"AccountResp") >
			<cfreturn false />
		</cfif>
		<cfif not structKeyExists (session.carrierFacade,"FinanceAgreementResp") >
			<cfreturn false />
		</cfif>
		<cfif not structKeyExists (session.carrierFacade,"FinanceAgreementResp") >
			<cfreturn false />
		</cfif>
		<cfif not structKeyExists (session,"Order") >
			<cfreturn false />
		</cfif>
		
		<!--- Loop thru the Agreement Items and generate/save a document for each agreement --->
		<cfloop array="#session.carrierFacade.FinanceAgreementResp.AgreementItems#" index="local.fai">
			<cfset local.eConsentHtml = getEConsentHtml(local.fai) />
			<cfdocument format="pdf" name="local.eConsentPDF" orientation="portrait">
				<cfoutput>#local.eConsentHtml#</cfoutput>
			</cfdocument>
			<cfset local.Base64Pdf = ToBase64(local.eConsentPDF) />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="service.AttFinanceAgreementSave" result="local.result">
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#session.order.getOrderId()#" > 
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="109" > 
				<cfprocparam cfsqltype="CF_SQL_BIGINT" value="#trim(local.fai.installmentPlanId)#" > 
				<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(local.fai.AttDeviceOrderItem.subscriber.number)#" > 
				<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(session.carrierFacade.accountResp.Account.accountIdentifier)#" > 
				<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(session.carrierfacade.accountResp.Account.PrimaryAccountHolder)#" > 
				<cfprocparam cfsqltype="CF_SQL_DATE" value="#dateformat(now(),'mm/dd/yyyy')#" > 
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="#getChannelValue()#" > 
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="2" > <!---1=financeAgreement 2=eConsent --->
				<cfprocparam cfsqltype="CF_SQL_NVARCHAR" value="#trim(local.Base64Pdf)#" > 
				<cfprocparam cfsqltype="CF_SQL_INTEGER" value="1" > <!--- Processing Status, Always 1 --->
			</cfstoredproc>			
			
		</cfloop>
		
		<cfreturn true />
	</cffunction>
		
	<cffunction name="getEConsentHTML" output="false" access="public" returntype="string">
		<cfargument name="agreementItem" type="struct" required="true" />		
		<cfset var local = structNew() />
		<cfsavecontent variable="local.econsent">
			<cfoutput>
			#arguments.agreementItem.AttDeviceOrderItem.Subscriber.Number#<br/>
			#arguments.agreementItem.AttDeviceOrderItem.Subscriber.Contact.Contact.FirstName# #arguments.agreementItem.AttDeviceOrderItem.Subscriber.Contact.Contact.LastName#<br/>
			#dateformat(now(),"mm/dd/yyyy")#<br/>
			<p>
			I acknowledge that Wireless Advocates has on this date presented me with a printed and completed Retail Installment Sale 
			Agreement/Notice to Buyer (the "Agreement") and I was given an opportunity to review the terms, including 8.33 and my right 
			to cancel within 14 days. I understand that Wireless Advocates is not authorized to make or accept any changes to the Agreement 
			and that if there are any markings or strikeouts they are not binding on Wireless Advocates or its assignee AT&T.
			</p>
			<p>
			By signing my name on the Agreement under the Notice to Buyer and below, I acknowledge that I have read this Agreement and that 
			Wireless Advocates gave me a copy of my signed Agreement.	
			<p/>	
			#arguments.agreementItem.AttDeviceOrderItem.Subscriber.Contact.Contact.FirstName# #arguments.agreementItem.AttDeviceOrderItem.Subscriber.Contact.Contact.LastName# 
			#dateformat(now(),"mm/dd/yyyy")#<br/>
			</cfoutput>		
			
		</cfsavecontent>	
		
		<cfreturn local.econsent />
	</cffunction>			
	
	<cffunction name="getDeviceInfo" access="private" returnType="struct">
		<cfargument name="cartLineNo" type="numeric" required="true" />
		<cfset var local = structNew() />
		<cfset local.deviceInfo = structNew()/>
		<cfset local.device = application.model.dBuilderCartFacade.getDevice(arguments.cartLineNo) />
		<cfset local.deviceInfo.FullRetailPrice = local.device.productDetail.getFinancedFullRetailPrice() />
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
		<cfset local.paymentPlanDetail = local.cartLine.getPaymentPlanDetail() />
		<cfset local.deviceDetail = structNew()/>
		<cfset local.device = application.model.dBuilderCartFacade.getDevice(arguments.cartLineNo) />
		<!---<cfset local.deviceDetail.contractTerm = local.device.contractMonths />--->
		<cfset local.deviceDetail.contractTerm = local.paymentPlanDetail.minimumCommitment />
		<cfset local.deviceDetail.MSRP = local.device.productDetail.getFinancedFullRetailPrice() />
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
	
	<cffunction name="findSubscriber" access="public" returnType="struct">
		<cfargument name="subscriberNumber" type="string" required="true" />
		<cfset var local = structNew() />
		
		<cfif isDefined("session.carrierFacade.accountResp.account.subscribers") >
			<cfset local.subscriberIndex = 0>
			<cfloop array="#session.carrierFacade.accountResp.account.subscribers#" index="local.s" >
				<cfset local.subscriberIndex = local.subscriberIndex+1 />
				<cfif local.s.number is arguments.subscriberNumber>
					<cfset local.s.subscriberIndex = local.subscriberIndex />
					<cfreturn local.s/>
				</cfif>
			</cfloop>
		<cfelse>
			<cfreturn structNew() />
		</cfif> 
	</cffunction>
	
	<cffunction name="getProductInfo" access="public" returnType="query">
		<cfset var local = structNew() />
		
		<cfset local.imeiType = "" />
		<!--- Used passed productid to retrieve the IMEI type --->
		<cfif structKeyExists(arguments,"productid") >
			<cfset local.qphone = application.model.Phone.getByFilter(idList = arguments.productid) />
			<cfif local.qphone.recordcount is 1>
					<cfreturn local.qPhone />
			</cfif>
		</cfif>
		<cfreturn "" />
	</cffunction>
	
	<cffunction name="getSubmitCompletedOrderEntry" access="public" returnType="query">
		<cfargument name="orderId" type="numeric" required="true" />
		<cfset var local = structNew() />
		
		<cfstoredproc procedure="service.OrderSubmissionGet" datasource="wirelessadvocates" >
			<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.orderId#" />
			<cfprocparam cfsqltype="cf_sql_varchar" value="SubmitCompletedOrder" />
			<cfprocresult name="local.qSubmitOrderRequest" />
		</cfstoredproc>		
		<cfreturn local.qSubmitOrderRequest />
	</cffunction>	
	
</cfcomponent>	