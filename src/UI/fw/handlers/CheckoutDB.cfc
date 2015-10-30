<cfcomponent name="CheckoutDB" output="false" extends="BaseHandler">
	<!--- Use CFProperty to declare beans for injection.  By default, they will be placed in the variables scope --->
	<cfproperty name="CarrierFacade" inject="id:CarrierFacade" />
	<cfproperty name="CarrierHelper" inject="id:CarrierHelper" />
	<cfproperty name="AttCarrier" inject="id:AttCarrier" />
	<cfproperty name="VzwCarrier" inject="id:VzwCarrier" />
	<cfproperty name="MockCarrier" inject="id:MockCarrier" />
	<cfproperty name="ChannelConfig" inject="id:ChannelConfig" />
	<cfproperty name="assetPaths" inject="id:assetPaths" scope="variables" />
	
	<cfsetting requesttimeout="1000" />

	<cfset ChannelConfig = application.wirebox.getInstance("ChannelConfig") />
	<cfset GatewayRegistry = application.wirebox.getInstance("PaymentProcessorRegistry") />
	<cfset PaymentService = application.wirebox.getInstance("PaymentService") />
	<cfset PromotionService = application.wirebox.getInstance("PromotionService") />
	<cfif application.wirebox.containsInstance("CampaignService")>
		<cfset CampaignService = application.wirebox.getInstance("CampaignService") />
	</cfif>
	<cfset textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer") />

	<cfparam name="request.config.disableSSL" default="false" type="boolean" />
	<cfparam name="request.config.activeCarriers" default="42|109|128" type="string" />
	<!---<cfparam name="request.p.resultCode" default="" type="string" />--->
	<!---<cfparam name="request.p.do" default="billShip" type="string" />--->
	<cfparam name="request.p.do" default="startCheckout" type="string" />
	<cfparam name="request.currentTopNav" default="checkout.startCheckout" type="string" />
	<cfparam name="request.p.bSoftReservationSuccess" type="boolean" default="false" />

	<cfif application.model.CheckoutHelper.getCarrier() EQ 299>
		<cfset request.maxpinlength = 10 />
	<cfelse>
		<cfset request.maxpinlength = 4 />
	</cfif>

	<cfif not listContains(application.model.carrier.getActiveCarrierIds(), application.model.checkoutHelper.getCarrier())>
		<cflocation url="/index.cfm/go/checkout/do/error/?code=50" addtoken="false" />
	</cfif>

	<cfif cgi.server_port neq 443 and not request.config.disableSSL>
		<cflocation url="https://#cgi.HTTP_HOST##cgi.path_info#" addtoken="false" />
	</cfif>

	<cfif not structKeyExists(session, 'currentUser')>
		<cfset session.currentUser = createObject('component', 'cfc.model.User').init() />
	</cfif>
	<cfset request.layoutFile = 'checkoutDB' />
	
	<cfscript>
		request.validator = createobject('component', 'cfc.model.FormValidation').init();
		request.validatorView = createobject('component', 'cfc.view.FormValidation').init();
	</cfscript>
	
	<cfif not application.model.checkoutHelper.isCheckoutEnabled(session.cart.getCarrierId())>
		<cflocation url="/index.cfm/go/error/do/checkoutOffline/" addtoken="false" />
	</cfif>

	<!--- Update the timestamp on all soft reservations for this user with every step through checkout. --->
	<cfset application.model.checkoutHelper.updateSoftReservationTimestamps() />
	
	<cffunction name="startCheckout" returntype="void" output="false" hint="">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfparam name="request.p.do" default="startCheckout" type="string" />
		
		<cfset session.cart.updateAllPrices() />
		<cfset session.cart.updateAllDiscounts() />
		<cfset session.cart.updateAllTaxes() />

		<cfif Len(request.config.disableCarrierCheckout) && ListFind(request.config.disableCarrierCheckout, session.cart.getCarrierId(), '|')>
			<cflocation url="/index.cfm/go/checkout/do/error/code/55" addtoken="false" />
		</cfif>

		<cfparam name="request.p.bypassCartValidation" type="boolean" default="false" />

		<cfif not request.p.bypassCartValidation>
			<cfset cartValidationResponse = application.model.cartHelper.validateCartForCheckout() />

			<cfif not variables.cartValidationResponse.getIsCartValid()>
				<cfset campaignId = '' />
				
				<!--- Get campaign ID if channel uses the campaign service --->
				<cfif StructKeyExists(variables, 'CampaignService')>
					<cfif CampaignService.doesCurrentCampaignSubdomainExist()>
						<cfset campaign = CampaignService.getCampaignBySubdomain( CampaignService.getCurrentSubdomain() ) />
						<cfset campaignId = campaign.getCampaignId() />
					</cfif>
				</cfif>

				<cfset application.model.Log.logInvalidCart( cartValidationResponse.getInvalidCartTypeId(), session.cart.getActivationType(), session.cart.getCarrierId(), Trim(cartValidationResponse.renderErrorLIs()), campaignId ) />

				<cfset url.code = 'cartValidation' />
				<cfset request.p.do = 'error' />

				<cfinclude template="index.cfm" />

				<cfexit method="exittag" />
			</cfif>
		</cfif>

		<cfif not application.model.checkoutHelper.isWirelessOrder()>
			<cfif session.cart.getPrepaid()>
				<cfset application.model.checkoutHelper.generateReferenceNumber() />
				<cflocation url="/index.cfm/go/checkout/do/requestAreaCode" addtoken="false" />
			<cfelse>
				<!--- Accessories and No-Contract phones --->
				<cfset setNextEvent('CheckoutVFD.billShip')>
				<!---<cflocation url="/index.cfm/go/checkout/do/billShip/bSoftReservationSuccess/1/" addtoken="false" />--->
			</cfif>
		</cfif>

		<cfif isDefined('url.regen')>
			<cfset application.model.checkoutHelper.clearReferenceNumber() />
		</cfif>

		<cfset application.model.checkoutHelper.generateReferenceNumber() />
		<cfset application.model.checkoutHelper.setCarrierConversationId('') /> <!--- Clear conversation ID --->

		<cfswitch expression="#application.model.checkoutHelper.getCheckoutType()#">
			<cfcase value="new">
				<cfset setNextEvent('CheckoutVFD.billShip')>
				<!---<cflocation url="/index.cfm/go/checkout/do/lnpRequest/bSoftReservationSuccess/1/" addtoken="false" />--->
			</cfcase>
			<cfcase value="add">
				<cfset setNextEvent('CheckoutVFD.billShip')>
				<!---<cflocation url="/index.cfm/go/checkout/do/wirelessAccountForm/bSoftReservationSuccess/1/" addtoken="false" />--->
			</cfcase>
			<cfcase value="upgrade">
				<cfset setNextEvent('CheckoutVFD.billShip')>
				<!---<cflocation url="/index.cfm/go/checkout/do/wirelessAccountForm/bSoftReservationSuccess/1/" addtoken="false" />--->
			</cfcase>
	<!---		<cfcase value="financed">
				<cfset setNextEvent('CheckoutVFD.billShip')>
				<!---<cflocation url="/index.cfm/go/checkout/do/wirelessAccountForm/bSoftReservationSuccess/1/" addtoken="false" />--->
			</cfcase>--->
			
			<cfdefaultcase>
				<!---The rest should all be "financed" so just adding it as the default--->
					<cfset setNextEvent('CheckoutVFD.billShip')>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="billShip" returntype="void" output="false" hint="">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfset event.setLayout('checkoutDB') />
		<cfset event.setView('CheckoutDB/billShipDB') />
	</cffunction>
	
	<cffunction name="billShipAuthenticate" returntype="void" output="false" hint="">
		<cfargument name="event">
		<cfargument name="prc">
		<cfset request.p = Event.getCollection()/>
		<!--- clear validators --->
        <cfset request.validator.clear()>

		<!--- place the supplied password into the checkout helper --->
		<cfset application.model.CheckoutHelper.setFormKeyValue("billShipForm","existingUserPassword",request.p.existingUserPassword)>

		<!--- determine if the email address and password are valid --->
		<cfset isEmailPasswordValid = application.model.User.isEmailPasswordValid(application.model.CheckoutHelper.getFormKeyValue("billShipForm","emailAddress"),application.model.CheckoutHelper.getFormKeyValue("billShipForm","existingUserPassword"))>
		<!--- if the combination is valid --->
		<cfif isEmailPasswordValid>
			<!--- authenticate the user --->
			<cfset session.currentUser.login(application.model.CheckoutHelper.getFormKeyValue("billShipForm","emailAddress"),application.model.CheckoutHelper.getFormKeyValue("billShipForm","existingUserPassword"))>
			<!--- send the user back to the bill/ship step --->
			<cfset setNextEvent('CheckoutDB/billShip')>
			<!---<cfset event.setLayout('checkoutDB') />
			<cfset event.setView('CheckoutDB/billShipDB') />--->
			<!---<cflocation addtoken="false" url="/index.cfm/go/checkout/do/billShip/">--->
		<cfelse>
			<!--- generate an error message --->
            <cfset request.validator.AddMessage("existingUserPassword","Incorrect password.")>
            <cfset event.setLayout('checkoutDB') />
			<cfset event.setView('CheckoutDB/billShipDB') />
		</cfif>
	</cffunction>
	
	<cffunction name="billShipCheckEmailAddress" returntype="void" output="false" hint="">
		<cfargument name="event">
		<cfargument name="prc">
		<cfset var local = structNew()>
		
		<cfset request.p = Event.getCollection()/>
		
		<cfparam name="url.emailAddress" default="#trim(request.p.emailAddress)#" type="string" />
		<cfset application.model.checkoutHelper.setFormKeyValue('billShipForm', 'emailAddress', trim(url.emailAddress)) />

		<cfset session.checkout.returningCustomer = application.model.User.isEmailInUse(trim(url.emailAddress)) />

		<cfif session.checkout.returningCustomer>
			<cfset session.checkout.returningCustomer = 1 />
		<cfelse>
			<cfset session.checkout.returningCustomer = 0 />
		</cfif>

		<!--- For third party auth make sure this account is not already used by another aafes customer id --->
		<cfif session.checkout.returningCustomer and request.config.thirdPartyAuth and structKeyExists(session,"authenticationId") and session.authenticationid is not "">
			<cfset thisuser = application.model.User.getUserByUserName(trim(url.emailAddress)) />
			<cfif thisUser.authenticationid is not "" and thisUser.authenticationid is not session.authenticationId>
				<cfset request.validator.AddValidator("email",session.checkout.billShipForm.emailAddress,"custom","This email address is already in use.")>
				<cfset session.checkout.returningCustomer = 0 />
			</cfif>
			<cfif thisUser.authenticationid is "">
				<cfset session.newReturningAuthCust = true />
			<cfelse>
				<cfset session.newReturningAuthCust = true />
			</cfif>
		</cfif>		
		
		<!--- If there are any errors we need to regen the page --->		
		<cfif request.validator.HasMessages()>
			<cfset event.setLayout('checkOutDB') />
			<cfset event.setView('checkoutDB/billShipDB') />
		<cfelse>
			<cfset event.setLayout('checkOutDB') />
			<cfset event.setView('checkoutDB/billShipDB') />
		</cfif>
	</cffunction>
	
	<cffunction name="processBillShip" returntype="void" output="false" hint="">
		<cfargument name="event">
		<cfargument name="prc">
		<cfset request.p = Event.getCollection()/>
		<cfparam name="request.p.resultCode" default="" type="string" />
		
		<cfset local = structNew() />
			<cfset local.isByPassOn = false />

			<cfif len(trim(session.currentUser.getUserID())) && application.model.user.isUserOrderAssistanceOn(trim(session.currentUser.getUserID()))>
				<cfset local.isByPassOn = true />
			</cfif>

			<cfset request.validator.clear() />

			<cfif not session.UserAuth.isLoggedIn()>
				<!--- If it appears the user is coming through as a new customer and not logged in yet. --->
				<cfif isDefined('session.checkout.returningCustomer') and not session.checkout.returningCustomer and structKeyExists(request, 'p') and structKeyExists(request.p, 'emailAddress') and len(trim(request.p.emailaddress)) and application.model.util.isEmail(trim(request.p.emailaddress))>
					<cfset randomPassword = session.currentUser.getRandString(10) />
					<cfset session.currentUser.createUser(request.p.emailAddress, variables.randomPassword) />
					<cfset session.currentUser.login(request.p.emailAddress, variables.randomPassword) />
				<cfelse>
					<!---<cfif structKeyExists(request, 'p') and not structKeyExists(request.p, 'emailAddress')>
						<cflocation url="/index.cfm/go/cart/do/view/" addtoken="false" />
					<cfelse>--->
						<cfset request.validator.addMessage('password', 'Incorrect password.') />
					<!---</cfif>--->
				</cfif>
			</cfif>

			<cfparam name="request.p.sameAsBilling" default="0">
			
			<cfset request.p.billdayPhone = request.p.billDayPhonePt1 & "-" & request.p.billDayPhonePt2 & "-" & request.p.billDayPhonePt3/>
			<!--- If phone is not of a valid length clear it out for another try --->	
			<cfif NOT len(request.p.billdayPhone) gt 11>
				<cfset request.p.billdayPhone = ""/>
			</cfif>
			<cfif (request.p.sameAsBilling) OR (!request.p.sameAsBilling AND session.cart.getActivationType() CONTAINS 'New' AND !request.config.allowDifferstShippingOnNewActivations)>
				<cfset request.p.shipFirstName = trim(request.p.billFirstName) />
				<cfset request.p.shipLastName = trim(request.p.billLastName) />
				<cfset request.p.shipMiddleInitial = trim(request.p.billMiddleInitial) />
				<cfset request.p.shipCompany = trim(request.p.billCompany) />
				<cfset request.p.shipAddress1 = trim(request.p.billAddress1) />
				<cfset request.p.shipAddress2 = trim(request.p.billAddress2) />
				<cfset request.p.shipCity = trim(request.p.billCity) />
				<cfset request.p.shipState = trim(request.p.billState) />
				<cfset request.p.shipZip = trim(request.p.billZip) />
				<cfset request.p.shipDayPhone = trim(request.p.billDayPhone) />
				<!---<cfset request.p.shipEvePhone = trim(request.p.billEvePhone) />--->
				<cfset request.p.shipMilitaryBase = trim(request.p.selMilitaryBase) />
			<cfelse>
				<cfset request.p.shipdayPhone = request.p.shipDayPhonePt1 & "-" & request.p.shipDayPhonePt2 & "-" & request.p.shipDayPhonePt3/>
				<!--- If phone is not of a valid length clear it out for another try --->	
			<cfif NOT len(request.p.shipdayPhone) gt 11>
				<cfset request.p.shipdayPhone = ""/>
			</cfif>
			</cfif>

			<cfset request.checkout.billingAddress = createobject('component', 'cfc.model.Address').init() />
			<cfset request.checkout.billingAddress.setAddressLine1(trim(request.p.billAddress1)) />
			<cfset request.checkout.billingAddress.setAddressLine2(trim(request.p.billAddress2)) />
			<cfset request.checkout.billingAddress.setCity(trim(request.p.billCity)) />
			<cfset request.checkout.billingAddress.setState(trim(request.p.billState)) />
			<cfset request.checkout.billingAddress.setZipCode(trim(request.p.billZip)) />
			<cfset request.checkout.billingAddress.setCompany(trim(request.p.billCompany)) />
			<cfset request.checkout.billingAddress.setFirstName(trim(request.p.billFirstName)) />
			<cfset request.checkout.billingAddress.setLastName(trim(request.p.billLastName)) />
			<cfset request.checkout.billingAddress.setMiddleInitial(trim(request.p.billMiddleInitial)) />
			<cfset request.checkout.billingAddress.setName(trim(request.p.billFirstName) & ' ' & trim(request.p.billLastName)) />
			<cfset request.checkout.billingAddress.setDayPhone(trim(request.p.billDayPhone)) />
			<!---<cfset request.checkout.billingAddress.setEvePhone(trim(request.p.billEvePhone)) />--->
			<cfset request.checkout.billMilitaryBase.setMilitaryBase = trim(request.p.selMilitaryBase) />

			<cfset request.checkout.shippingAddress = createobject('component', 'cfc.model.Address').init() />
			<cfset request.checkout.shippingAddress.setAddressLine1(trim(request.p.shipAddress1)) />
			<cfset request.checkout.shippingAddress.setAddressLine2(trim(request.p.shipAddress2)) />
			<cfset request.checkout.shippingAddress.setCity(trim(request.p.shipCity)) />
			<cfset request.checkout.shippingAddress.setState(trim(request.p.shipState)) />
			<cfset request.checkout.shippingAddress.setZipCode(trim(request.p.shipZip)) />
			<cfset request.checkout.shippingAddress.setCompany(trim(request.p.shipCompany)) />
			<cfset request.checkout.shippingAddress.setFirstName(trim(request.p.shipFirstName)) />
			<cfset request.checkout.shippingAddress.setLastName(trim(request.p.shipLastName)) />
			<cfset request.checkout.shippingAddress.setMiddleInitial(trim(request.p.shipMiddleInitial)) />
			<cfset request.checkout.shippingAddress.setName(trim(request.p.shipFirstName) & ' ' & trim(request.p.shipLastName)) />
			<cfset request.checkout.shippingAddress.setDayPhone(trim(request.p.shipDayPhone)) />
			<!---<cfset request.checkout.shippingAddress.setEvePhone(trim(request.p.shipEvePhone)) />--->
			<cfset request.checkout.shippingMilitaryBase.setMilitaryBase = trim(request.p.selMilitaryBase) />

			<cfset application.model.checkoutHelper.setBillShipForm(request.p) />

			<cfset request.validator.addRequiredFieldValidator('emailAddress', trim(request.p.emailAddress), 'Please supply a valid email address.') />
			<cfset request.validator.addEmailValidator('emailAddress', trim(request.p.emailAddress), 'Please supply a valid email address.') />

			<cfset request.validator.addRequiredFieldValidator('billFirstName', trim(request.p.billFirstName), 'Please enter first name of the person this order is being billed to.') />
			<cfset request.validator.addMaxRangeValidator('billFirstName', trim(request.p.billFirstName), 'Billing first name may not exceed 50 characters.', 50) />

			<cfset request.validator.addMaxRangeValidator('billMiddleInitial', trim(request.p.billMiddleInitial), 'Billing middle initial may not exceed 1 character, but is optional.', 1) />

			<cfset request.validator.addRequiredFieldValidator('billLastName', trim(request.p.billLastName), 'Please enter last name of the person this order is being billed to.') />
			<cfset request.validator.addMaxRangeValidator('billLastName', trim(request.p.billLastName), 'Billing last name may not exceed 50 characters.', 50) />

			<cfset request.validator.addMaxRangeValidator('billCompanyError', trim(request.p.billCompany), 'Billing company name may not exceed 50 characters.', 50) />

			<cfset request.validator.addRequiredFieldValidator('billAddress1', trim(request.p.billAddress1), 'Please enter address line 1 of the person this order is being billed to.') />
			<cfset request.validator.addMaxRangeValidator('billAddress1', trim(request.p.billAddress1), 'Billing address line 1 may not exceed 50 characters.', 50) />

			<cfset request.validator.addMaxRangeValidator('billAddress2Error', trim(request.p.billAddress2), 'Billing address line 2 may not exceed 50 characters.', 50) />

			<cfset request.validator.addRequiredFieldValidator('billCity', trim(request.p.billCity), 'Please enter city of the person this order is being billed to.') />
			<cfset request.validator.addMaxRangeValidator('billCity', trim(request.p.billCity), 'Billing city may not exceed 50 characters.', 50) />

			<cfset request.validator.addRequiredFieldValidator('billState', trim(request.p.billState), 'Please enter the state of the person this order is being billed to.') />

			<cfset request.validator.addRequiredFieldValidator('billZip', trim(request.p.billZip), 'Please enter the zip code of the person this order is being billed to.') />
			<cfset request.validator.addZipCodeValidator('billZip', trim(request.p.billZip), 'Enter a valid Zip Code.') />

			<cfset request.validator.addRequiredFieldValidator('billDayPhone', trim(request.p.billDayPhone), 'Please enter the contact phone of the person this order is being billed to.') />
			<cfset request.validator.addPhoneValidator('billDayPhone', trim(request.p.billDayPhone), 'Please use the following format 206-555-1212.') />

			<!---<cfset request.validator.addRequiredFieldValidator('billEvePhone', trim(request.p.billEvePhone), 'Please enter the evening phone of the person this order is being billed to.') />
			<cfset request.validator.addPhoneValidator('billEvePhone', trim(request.p.billEvePhone), 'Please use the following format 206-555-1212.') />--->

			<cfif request.config.allowAPOFPO>
				<cfset request.validator.addRequiredFieldValidator('selMilitaryBase', trim(request.p.selMilitaryBase), 'Please select the nearest Military Base') />
			</cfif>

			<cfif !request.p.sameAsBilling>
				<cfset request.validator.addRequiredFieldValidator('shipFirstName', trim(request.p.shipFirstName), 'Please enter the first name of the person this order is being shipped to.') />
				<cfset request.validator.addMaxRangeValidator('shipFirstName', trim(request.p.shipFirstName), 'Shipping first name may not exceed 50 characters.', 50) />

				<cfset request.validator.addMaxRangeValidator('shipMiddleInitial', trim(request.p.shipMiddleInitial), 'Shipping middle initial may not exceed 1 character, but is optional.', 1) />

				<cfset request.validator.addRequiredFieldValidator('shipLastName', trim(request.p.shipLastName), 'Please enter the last name of the person this order is being shipped to.') />
				<cfset request.validator.addMaxRangeValidator('shipLastName', trim(request.p.shipLastName), 'Shipping last name may not exceed 50 characters.', 50) />

				<cfset request.validator.addMaxRangeValidator('shipCompanyError', trim(request.p.shipCompany), 'Shipping company name may not exceed 50 characters.', 50) />

				<cfset request.validator.addRequiredFieldValidator('shipAddress1', trim(request.p.shipAddress1), 'Please enter address line 1 of the person this order is being shipped to.') />
				<cfset request.validator.addMaxRangeValidator('shipAddress1', trim(request.p.shipAddress1), 'Shipping address line 1 may not exceed 50 characters.', 50) />

				<cfset request.validator.addMaxRangeValidator('shipAddress2Error', trim(request.p.shipAddress2), 'Shipping Address 2 may not exceed 50 characters.', 50) />

				<cfset request.validator.addRequiredFieldValidator('shipCity', trim(request.p.shipCity), 'Please enter the city of the person this order is being shipped to.') />
				<cfset request.validator.addMaxRangeValidator('shipCity', trim(request.p.shipCity), 'Shipping city may not exceed 50 characters.', 50) />

				<cfset request.validator.addRequiredFieldValidator('shipState', trim(request.p.shipState), 'Please select the state of the person this order is being shipped to.') />

				<cfset request.validator.addRequiredFieldValidator('shipZip', trim(request.p.shipZip), 'Please enter the zip code of the person this order is being shipped to.') />
				<cfset request.validator.addZipCodeValidator('shipZip', trim(request.p.shipZip), 'Enter a valid Zip Code.') />

				<cfset request.validator.addRequiredFieldValidator('shipDayPhone', trim(request.p.shipDayPhone), 'Please enter the contact phone of the person this order is being shipped to.') />
				<cfset request.validator.addPhoneValidator('shipDayPhone', trim(request.p.shipDayPhone), 'Please use the following format 206-555-1212.') />

				<!---<cfset request.validator.addRequiredFieldValidator('shipEvePhone', trim(request.p.shipEvePhone), 'Please enter the evening phone of the person this order is being shipped to.') />
				<cfset request.validator.addPhoneValidator('shipEvePhone', trim(request.p.shipEvePhone), 'Please use the following format 206-555-1212.') />--->

				<cfif request.config.allowAPOFPO AND listFindNoCase("APO,FPO",request.p.shipCity)>
					<cfif !StructKeyExists(request.p,"checkApoDislaimer")>
						<cfset request.validator.addMessage('checkApoDislaimer', 'Please acknowledge return restrictions for APO/FPO addresses') />
					</cfif>
				</cfif>
			</cfif>

			<cfif not local.isByPassOn>
				<!--- Handle PO validation on billing address --->
				<cfset local.poBoxRegEx = "^(?:Post (?:Office )?|P[. ]?O\.? )?Box ">
					
				<cfif application.model.checkoutHelper.isWirelessOrder()>
					<cfif REFindNoCase(local.poBoxRegEx,request.p.billAddress1)>
						<cfset request.validator.addMessage('billAddress1', 'In order to process your order please provide an address that is not a P.O. Box address.') />
					</cfif>
					<cfif REFindNoCase(local.poBoxRegEx,request.p.billAddress2)>
						<cfset request.validator.addMessage('billAddress2Error', 'In order to process your order please provide an address that is not a P.O. Box address.') />
					</cfif>
				</cfif>

				<!--- Handle PO validation on shipping address. --->
				<cfif !(request.config.allowAPOFPO AND listFindNoCase("APO,FPO",request.p.shipCity))>
					<cfif REFindNoCase(local.poBoxRegEx,request.p.shipAddress1)>
						<cfset request.validator.addMessage('shipAddress1', 'We do not ship to P.O. Boxes. Enter a physical address.') />
					</cfif>
				</cfif>

				<!--- Check Address Line two --->
				<cfif !(request.config.allowAPOFPO AND listFindNoCase("APO,FPO",request.p.shipCity)) AND REFindNoCase(local.poBoxRegEx,request.p.shipAddress2)>
					<cfset request.validator.addMessage('generalPortInError', 'In order to process your order please provide a shipping address that is not a P.O. Box address.') />
				</cfif>
			</cfif>

			<!--- Prepaid validations ---> 
			<cfif application.model.checkoutHelper.isPrepaidOrder()>
				<cfset request.validator.addRequiredFieldValidator('dob', trim(request.p.dob), 'Please enter your date of birth.') />

				<cfset request.validator.addDateValidator('dob', trim(request.p.dob), 'Please enter your date of birth in the following format mm/dd/yyyy.') />
				<cfset request.validator.addAgeValidator('dob', trim(request.p.dob), 'You must be 18 or older.') />
			</cfif>

			<!--- Form validations passed --->
			<cfif not request.validator.hasMessages()>
			
				<!--- Check against banned user fraud Black Listing --->
				<cfif structKeyExists(request.p, 'emailAddress') and len(trim(request.p.emailAddress)) and structKeyExists(request.p, 'billAddress1') and len(trim(request.p.billAddress1))>
					<cfset SecurityService = application.wirebox.getInstance("SecurityService") />
	
					<cfset bannedUserBillingArgs = {
						address1 = request.p.billAddress1
						, city = request.p.billCity
						, state = request.p.billState
					} />

					<cfset bannedUserShippingArgs = {
						address1 = request.p.shipAddress1
						, city = request.p.shipCity
						, state = request.p.shipState
					} />
	
					<cfif SecurityService.isBannedUser(argumentCollection = bannedUserBillingArgs) || SecurityService.isBannedUser(argumentCollection = bannedUserShippingArgs)>
						<cfset session.bannedUser = request.p />
						<cflocation url="/index.cfm/go/checkout/do/error/?code=AV999" addtoken="false" />
					</cfif>
				</cfif>
			
				<cfset application.model.checkoutHelper.getBillingAddress().setFirstName(trim(request.p.billFirstName)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setLastName(trim(request.p.billLastName)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setMiddleInitial(trim(request.p.billMiddleInitial)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setName(trim(request.p.billFirstName) & ' ' & trim(request.p.billLastName)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setCompany(trim(request.p.billCompany)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setAddressLine1(trim(request.p.billAddress1)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setAddressLine2(trim(request.p.billAddress2)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setCity(trim(request.p.billCity)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setState(trim(request.p.billState)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setZipCode(trim(request.p.billZip)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setDayPhone(trim(request.p.billDayPhone)) />
				<!---<cfset application.model.checkoutHelper.getBillingAddress().setEvePhone(trim(request.p.billEvePhone)) />--->
				<cfset application.model.checkoutHelper.getBillingAddress().setMilitaryBase(trim(request.p.selMilitaryBase)) />
				<cfset application.model.checkoutHelper.getBillingAddress().setCountry('US') />

				<cfset application.model.checkoutHelper.getShippingAddress().setFirstName(trim(request.p.shipFirstName)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setLastName(trim(request.p.shipLastName)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setMiddleInitial(trim(request.p.shipMiddleInitial)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setName(trim(request.p.shipFirstName) & ' ' & trim(request.p.shipLastName)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setCompany(trim(request.p.shipCompany)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setAddressLine1(trim(request.p.shipAddress1)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setAddressLine2(trim(request.p.shipAddress2)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setCity(trim(request.p.shipCity)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setState(trim(request.p.shipState)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setZipCode(trim(request.p.shipZip)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setDayPhone(trim(request.p.shipDayPhone)) />
				<!---<cfset application.model.checkoutHelper.getShippingAddress().setEvePhone(trim(request.p.shipEvePhone)) />--->
				<cfset application.model.checkoutHelper.getShippingAddress().setMilitaryBase(trim(request.p.selMilitaryBase)) />
				<cfset application.model.checkoutHelper.getShippingAddress().setCountry('US') />

				<cfif application.model.checkoutHelper.isWirelessOrder() || application.model.checkoutHelper.isPrepaidOrder()>
					<!--- If this is a wireless order or prepaid, pass a carrier. --->
					<cfset local.billingCarrier = application.model.checkoutHelper.getCarrier() />
				<cfelse>
					<!--- We don't need to validate against a carrier, there is none. --->
					<cfset local.billingCarrier = '' />
				</cfif>

				<cfif not local.isByPassOn>
					<!--- Call the carrier / shipping validation services. --->
					<cfset local.billingResult = application.model.addressValidation.validateAddress(application.model.checkoutHelper.getBillingAddress(), 'Billing', application.model.checkoutHelper.getReferenceNumber(), local.billingCarrier, request.p.resultCode, session.cart.getZipCode(), application.model.checkoutHelper.getCarrierConversationId() ) />
					<cfset application.model.checkoutHelper.setBillingResult(local.billingResult) />

					<cfswitch expression="#trim(local.billingResult.getResultCode())#">
						<!--- Address failed third party address validation and returned alternates. --->
						<cfcase value="AV001">
							<cfset request.validator.addMessage('errorAV001', 'Your billing address could not be validated, but some alternatives are available. Select an alternative address or review and resubmit your billing address.') />
						</cfcase>

						<!---  Address failed third party address verification and no matching addresses are available. --->
						<cfcase value="AV002">
							<cfset request.validator.addMessage('errorAV002', 'The billing address provided could not be validated. Please review and resubmit.') />
						</cfcase>

						<!---  Address verified. --->
						<cfcase value="AV003">
							<!--- Do Nothing --->
						</cfcase>

						<!--- Address failed carrier address verification. --->
						<cfcase value="AV004">
							<cfset request.validator.AddMessage('errorAV004', 'The billing address provided could not be validated. Please review and resubmit.') />
						</cfcase>

						<!--- Invalid Request, Unable to Connect to Carrier Service, Service Timeout --->
						<cfcase value="AV010|AV011|AV012" delimiters="|">
							<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
						</cfcase>

						<cfcase value="AV999">
							<cflocation url="/index.cfm/go/checkout/do/error/?code=AV999" addtoken="false" />
						</cfcase>

						<cfdefaultcase>
							<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
						</cfdefaultcase>
					</cfswitch>
				</cfif>

				<!--- If it is prepaid, set the dob. --->
				<cfif application.model.checkoutHelper.isPrepaidOrder()>
					<cfset application.model.checkoutHelper.setPrepaidDOB(request.p.dob) />
				</cfif>

				<cfif not local.isByPassOn>
					<cfif request.config.allowAPOFPO AND listFindNoCase("APO,FPO",request.p.shipCity)>
						<cfset uspsObj = application.wirebox.getInstance("Usps")>
						<cfset local.resultCode = uspsObj.AddressValidate(Address2 = request.p.shipaddress1,City = request.p.shipCity ,State = request.p.shipState,zip5=request.p.shipzip)>

						<cfswitch expression="#local.resultCode#">

							<!--- Address failed third party address validation and returned alternates. --->
							<cfcase value="USPS001">
								<cfset request.validator.addMessage('errorAV001', 'Your shipping address could not be validated, but some alternatives are available. Select an alternative address or review and resubmit your shipping address.') />
							</cfcase>

							<!--- Address failed third party address verification and no matching addresses are available. --->
							<cfcase value="USPS002">
								<cfset request.validator.addMessage('errorAV002', 'The shipping address provided could not be validated. Please review and resubmit.') />
							</cfcase>

							<!--- Address verified --->
							<cfcase value="USPS003">
								<!--- Do Nothing --->
							</cfcase>

							<!--- Address failed carrier address verification. --->
							<cfcase value="USPS004">
								<!--- Does not apply to shipping validation. --->
							</cfcase>

							<!--- Invalid Request, Unable to Connect to Carrier Service, Service Timeout --->
							<cfcase value="USPS010|USPS011|USPS012" delimiters="|">
								<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
							</cfcase>

							<cfdefaultcase>
								<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
							</cfdefaultcase>
						</cfswitch>

					<cfelse>
						<!--- Call the carrier / shipping validation services. --->
						<cfset local.shippingResult = application.model.addressValidation.validateAddress(application.model.checkoutHelper.getShippingAddress(), 'Shipping', application.model.checkoutHelper.getReferenceNumber(), local.billingCarrier, request.p.resultCode, session.cart.getZipCode(), application.model.checkoutHelper.getCarrierConversationId() ) />
						<cfset application.model.checkoutHelper.setShippingResult(local.shippingResult) />

						<cfswitch expression="#trim(local.shippingResult.getResultCode())#">

							<!--- Address failed third party address validation and returned alternates. --->
							<cfcase value="AV001">
								<cfset request.validator.addMessage('errorAV001', 'Your shipping address could not be validated, but some alternatives are available. Select an alternative address or review and resubmit your shipping address.') />
							</cfcase>

							<!--- Address failed third party address verification and no matching addresses are available. --->
							<cfcase value="AV002">
								<cfset request.validator.addMessage('errorAV002', 'The shipping address provided could not be validated. Please review and resubmit.') />
							</cfcase>

							<!--- Address verified --->
							<cfcase value="AV003">
								<!--- Do Nothing --->
							</cfcase>

							<!--- Address failed carrier address verification. --->
							<cfcase value="AV004">
								<!--- Does not apply to shipping validation. --->
							</cfcase>

							<!--- Invalid Request, Unable to Connect to Carrier Service, Service Timeout --->
							<cfcase value="AV010|AV011|AV012" delimiters="|">
								<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
							</cfcase>

							<cfdefaultcase>
								<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
							</cfdefaultcase>
						</cfswitch>
					</cfif>
				</cfif>
			</cfif>

			<cfif request.validator.hasMessages()>
				<cfif len(trim(session.currentUser.getUserID())) and application.model.user.isUserOrderAssistanceOn(trim(session.currentUser.getUserID()))>
					<cfinclude template="/views/checkout/dsp_orderAssistantMessageBox.cfm" />
				</cfif>

				<cfset event.setLayout('checkOutDB') />
				<cfset event.setView('checkoutDB/billShipDB') />
			<cfelse>
				<cfset request.p.user = createObject('component', 'cfc.model.User').init() />
				<cfset request.p.user.getUserById(session.userId) />
				<cfset request.p.userDataUpdated = false />

				<cfif isDefined('request.p.saveBilling') and request.p.saveBilling eq 1>
					<!--- TODO: Save this back to the user. --->
					<cfset request.p.user.getBillingAddress().setFirstName(trim(request.p.billFirstName)) />
					<cfset request.p.user.getBillingAddress().setLastName(trim(request.p.billLastName)) />
					<cfset request.p.user.getBillingAddress().setMiddleInitial(trim(request.p.billMiddleInitial)) />
					<cfset request.p.user.getBillingAddress().setName(trim(request.p.billFirstName) & ' ' & trim(request.p.billLastName)) />
					<cfset request.p.user.getBillingAddress().setCompany(trim(request.p.billCompany)) />
					<cfset request.p.user.getBillingAddress().setAddressLine1(trim(request.p.billAddress1)) />
					<cfset request.p.user.getBillingAddress().setAddressLine2(trim(request.p.billAddress2)) />
					<cfset request.p.user.getBillingAddress().setCity(trim(request.p.billCity)) />
					<cfset request.p.user.getBillingAddress().setState(trim(request.p.billState)) />
					<cfset request.p.user.getBillingAddress().setZipCode(trim(request.p.billZip)) />
					<cfset request.p.user.getBillingAddress().setDayPhone(trim(request.p.billDayPhone)) />
					<!---<cfset request.p.user.getBillingAddress().setEvePhone(trim(request.p.billEvePhone)) />--->
					<cfset request.p.user.getBillingAddress().setMilitaryBase(trim(request.p.selMilitaryBase)) />

					<cfset request.p.userDataUpdated = true />
				</cfif>

	            <cfif isDefined('request.p.saveShipping') and request.p.saveShipping eq 1>
	            	<!--- TODO: save this back to the user --->
	            	<cfset request.p.user.getShippingAddress().setFirstName(trim(request.p.shipFirstName)) />
	            	<cfset request.p.user.getShippingAddress().setLastName(trim(request.p.shipLastName)) />
	            	<cfset request.p.user.getShippingAddress().setMiddleInitial(trim(request.p.shipMiddleInitial)) />
	            	<cfset request.p.user.getShippingAddress().setName(trim(request.p.shipFirstName) & ' ' & trim(request.p.shipLastName)) />
	            	<cfset request.p.user.getShippingAddress().setCompany(trim(request.p.shipCompany)) />
	            	<cfset request.p.user.getShippingAddress().setAddressLine1(trim(request.p.shipAddress1)) />
	            	<cfset request.p.user.getShippingAddress().setAddressLine2(trim(request.p.shipAddress2)) />
	            	<cfset request.p.user.getShippingAddress().setCity(trim(request.p.shipCity)) />
	            	<cfset request.p.user.getShippingAddress().setState(trim(request.p.shipState)) />
	            	<cfset request.p.user.getShippingAddress().setZipCode(trim(request.p.shipZip)) />
	            	<cfset request.p.user.getShippingAddress().setDayPhone(trim(request.p.shipDayPhone)) />
	            	<!---<cfset request.p.user.getShippingAddress().setEvePhone(trim(request.p.shipEvePhone)) />--->
					<cfset request.p.user.getShippingAddress().setMilitaryBase(trim(request.p.selMilitaryBase)) />

	            	<cfset request.p.userDataUpdated = true />
	            </cfif>

	            <cfif request.p.userDataUpdated>
	            	<cfset request.p.user.save() />
	            </cfif>
				<!--- Save shipping selection to session --->
				<cfset session.checkout.shippingMethod = request.p.shipping>
				<!--- Do Shipping stuff --->
				<cfset local.selectedShippingMethod = createObject('component', 'cfc.model.shipMethod').init() />
				<!---<cfset local.selectedShippingMethod = application.model.CheckoutHelper.getShippingMethod() />--->
				<cfset local.selectedShippingMethod.load(request.p.shipping) />
				<cfset application.model.CheckoutHelper.setShippingMethod(local.selectedShippingMethod) />
	
				<cfif ChannelConfig.getOfferShippingPromo() && application.model.CartHelper.isCartEligibleForPromoShipping()>
					<cfset session.cart.getShipping().setDueToday( application.model.checkoutHelper.getShippingMethod().getPromoPrice() ) />
				<cfelse>
					<cfset session.cart.getShipping().setDueToday( application.model.checkoutHelper.getShippingMethod().getDefaultFixedCost() ) />
				</cfif>
				
	            <cfset application.model.checkoutHelper.markStepCompleted('billShip') />
	            
	            <cfif application.model.checkoutHelper.isWirelessOrder()>
	            	<!--- If this is a new line, credit check. --->
	
	            	<cfset setNextEvent('checkoutDB/carrierAgreements') />
	            <cfelse>
	            	<!--- Otherwise, time to go to the Review. --->
	            	
	            	<!---For development only, go to carrierAgreements --->
	            	<cfset setNextEvent('checkoutDB/carrierAgreements') />
	            	
	            </cfif>
			</cfif>
	</cffunction>
	
	<cffunction name="carrierAgreements" returntype="void" output="false" hint="">
		<cfargument name="event">

		<cfset rc.accountRespObj = session.carrierObj>
		<cfset rc.carrierId = session.carrierObj.getCarrierId()>
		
		<cfswitch expression="#channelConfig.getDisplayName()#">
			<cfcase value="Costco">
				<cfset local.channel = 0>
				<cfbreak/>
			</cfcase>
			<cfcase value="AAfes">
				<cfset local.channel = 1>
				<cfbreak/>
			</cfcase>
			<cfdefaultcase>
				<cfset local.channel = 0>
			</cfdefaultcase>
		</cfswitch>
		
		<cfset local.args_getFinanceAgreementRequest = {
			carrierId = #rc.carrierId#,
			AccountRespObj = #rc.accountRespObj#,
			Channel = #local.channel#			
		} />
		
		<cfset local.args_financeAgreementRequest = carrierHelper.getFinanceAgreementRequest(argumentCollection=local.args_getFinanceAgreementRequest) />
		<cfset session.financeAgreementRequest = local.args_financeAgreementRequest />
		<cfset session.accountResp = rc.accountRespObj />
		<cfset local.args_financeAgreementRequest.carrierId = rc.carrierid />
		<cfset rc.financeAgreementRequest = local.args_financeAgreementRequest />
		<cfset rc.financeAgreementRequestJSON = AttCarrier.serializeJSonAddReferenceNumber(local.args_financeAgreementRequest) /><!--- for testing only --->
		<cfset rc.FinanceAgreementRespObj = carrierFacade.FinanceAgreement(argumentCollection = local.args_financeAgreementRequest) />	
		<cfset session.FinanceAgreementResp = rc.FinanceAgreementRespObj />
		<cfset rc.pdf = session.FinanceAgreementResp.getResponse().FinanceAgreement />

		<cfset event.setLayout('checkoutDB') />
		<cfset event.setView('CheckoutDB/carrierAgreementsDB') />
	</cffunction>
	
	<cffunction name="financeAgreement" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset rc.pdf = base64ToString(session.FinanceAgreementResp.getResponse().FinanceAgreement) />
		<cfset event.setLayout('viewPdf') />
		<cfset event.setView('TestFullAPI/ViewPDF') />
	</cffunction>
	
	<cffunction name="base64ToString" returntype="any">
		<cfargument name="base64Value" type="any" required="yes" />
        
        <cfset var binaryValue = binaryDecode(base64Value,'base64' ) />
		<cfset var stringValue = ToString(binaryValue,'iso-8859-1' ) />
        
        <cfreturn stringValue />
  
	</cffunction>
	
	<cffunction name="processCarrierAgreements" returntype="void" output="false" hint="">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset application.model.checkoutHelper.markStepCompleted('carrierAgreements') />
        
        <cfset setNextEvent('checkoutDB/orderReview') />
	</cffunction>
	
	
	<cffunction name="orderReview" returntype="void" output="false" hint="">
		<cfargument name="event">
	    <cfargument name="rc">
	    <cfargument name="prc">
	    <cfset var prevAction = "" />
	    <cfparam name="prc.showAddAnotherDeviceButton" default="true" />
	    <cfparam name="prc.showCheckoutnowButton" default="true" />
	    <cfparam name="prc.showClearCartLink" default="true" />
	    
	    <cfset rc.carrierName = application.model.checkoutHelper.getCarrierName()>
	    
	   <!--- MES FIX UP --->
	    <cfscript>
	    if (session.cart.getCarrierId() eq 109) {
              session.carrierObj.carrierLogo = "#assetPaths.channel#images/carrierLogos/att_logo_25.png";
            } else if (session.cart.getCarrierId() eq 42) {
              session.carrierObj.carrierLogo = "#assetPaths.channel#images/carrierLogos/verizon_logo_25.png";
            }
		</cfscript>
	    <!---GET PLAN FROM CART--->
      	<cfset prc.cartPlan = application.model.dBuilderCartFacade.getPlan()/>
		<cfset prc.showAddAnotherDeviceButton = false/>
		<cfset prc.additionalAccessories = application.model.dBuilderCartFacade.getAccessories(request.config.otherItemsLineNumber)/>
		<cfset prc.includeTallyBox = false/>
		<cfset prc.cartLines = session.cart.getLines()/>
		<cfset prc.customerType = listLast(session.cart.getActivationType(), '-')/>
		<cfset prc.showHeader = false/>
		
		<cfset session.cart.updateCartItemTaxes() />
		<cfset session.cart.updateAllTaxes() />
		
		<cfset event.setLayout('checkoutReviewDB') />
		<cfset event.setView('CheckoutDB/orderReviewDB') />
	</cffunction>
	
	<cffunction name="processOrderReview" returntype="void" output="false" hint="">
		<cfargument name="event">
	    <cfargument name="rc">
	    <cfargument name="prc">
		
		<cfset request.p = Event.getCollection()/>

		<cfset application.model.checkoutHelper.markStepCompleted('orderReview') />

		<cfset order = createObject('component', 'cfc.model.order').init() />	
		
		<cfset variables.order.populateFromCart(session.cart) />
		<cfset variables.order.populateFromCheckoutHelper() />

		<!---<cfif session.currentUser.getUserID() NEQ "" AND application.model.user.isUserOrderAssistanceOn( session.currentUser.getUserID() )>
			<cfset order.setOrderAssistanceUsed( true ) />
		</cfif>--->
		
		<cfset variables.order.save() />	
		
		<cfif session.cart.hasPromotions()>
			<cfset PromotionService.applyPromotion( cart = session.cart, orderID = order.getOrderID(), userID = session.userID )>
			<cfset order.load(order.getOrderId())>
		</cfif>
		
		<cfset application.model.checkoutHelper.setOrderId(order.getOrderId()) />

		<!--- Store credit check application info for Verizon --->
		<cfif application.model.checkoutHelper.getCarrier() eq 42>
			<cfset local.CreditCheckInfo = application.model.checkoutHelper.getCreditCheckInfo() />
			<cfset local.CreditCheckInfo.save() />

			<cfset variables.order.setCreditCheckKeyInfoId( local.CreditCheckInfo.getCreditCheckKeyInfoId() ) />
			<cfset variables.order.save() />
		</cfif>

		<!--------------------------------------------------------------- 
			Add special SKUs to make reports commission reports correct 
		----------------------------------------------------------------->
		<cfif ( session.cart.getActivationType() contains 'nocontract')
		   or (session.cart.getActivationType() contains 'upgrade' and session.cart.getUpgradeType() eq 'equipment-only')
		   or (session.cart.getActivationType() contains 'addaline' and session.cart.getAddaLineType() eq 'Family' )
		   or application.model.checkoutHelper.isPrepaidOrder()	>
			<!--- Temp for filling in rate plan length --->
			<!---<cfset ratePlanLength = 24 />--->				
			
			<cfset cartLines = session.cart.getLines() />
			<cfloop from="1" to="#arrayLen(order.getWirelessLines())#" index="i">	
				
				<cfset deviceActivationType =  cartlines[i].getCartLineActivationType()>
				<!---<cfif deviceActivationType contains 'financed'>
					<cfif deviceActivationType contains '12'>
						<cfset ratePlanLength = 12 />
					<cfelseif deviceActivationType contains '18' >
						<cfset ratePlanLength = 18 />
					<cfelse>
						<cfset ratePlanLength = 24 />
					</cfif>
				<cfelse>
					<cfset ratePlanLength = 24 />
				</cfif>	--->	 	 
			 	 
			 	 <!---translate activation types--->
				<cfset cartLineActivationType = cartlines[i].getCartLineActivationType() />
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
							<cfset	local.mappedActivationType = cartlines[i].getCartLineActivationType()>
							<cfset	local.ratePlanLength = 0>
				</cfif>	
			 	 
			 	 
			 	 <cfif cartlines[i].getCartLineActivationType() is 'nocontract'>
				 	<cfset CommissionSku = application.model.CheckoutHelper.GetNoActivationRateplanSKU( 
							application.model.checkoutHelper.getCarrier()
							, cartlines[i].getPhone().getGersSKU()
							, cartlines[i].getPhone().getDeviceServiceType()
							) />
					<cfset CommissionSkuTitle = "No activation sale" />
				 </cfif>
			 	 <cfif application.model.checkoutHelper.isPrepaidOrder()>
				 	 <cfset CommissionSku = application.model.CheckoutHelper.GetPrepaidRateplanSKU( 
							application.model.checkoutHelper.getCarrier()
							, cartlines[i].getPhone().getGersSKU()
							, cartlines[i].getPhone().getDeviceServiceType()
							) />
							<cfset CommissionSkuTitle = "Prepaid sale" />
				</cfif>
			 	<cfif cartlines[i].getCartLineActivationType() contains 'upgrade'>
					<cfset CommissionSku = application.model.CheckoutHelper.GetKeepRateplanSKU( 
							application.model.checkoutHelper.getCarrier()
							, cartlines[i].getPhone().getGersSKU()
							, cartlines[i].getPhone().getDeviceServiceType()
							, local.mappedActivationType
							, i <!--- line number --->
							, local.ratePlanLength
							) />
					<cfset CommissionSkuTitle = "Keep current rateplan" />
				</cfif>
				  
				<cfif cartlines[i].getCartLineActivationType() contains 'addaline'>
				 	 <cfset CommissionSku = application.model.CheckoutHelper.GetKeepRateplanSKU( 
							application.model.checkoutHelper.getCarrier()
							, cartlines[i].getPhone().getGersSKU()
							, cartlines[i].getPhone().getDeviceServiceType()
							, local.mappedActivationType
							, i <!--- line number --->
							, local.ratePlanLength
							) />
					<cfset CommissionSkuTitle = "Add a line to current rateplan" />
				</cfif>
			 	 
			 	<cfscript> 
				 	noContract_orderDetail = createobject('component','cfc.model.OrderDetail').init();				
					noContract_orderDetail.setGroupNumber(i);
					noContract_orderDetail.setGroupName("Line " & i);
					noContract_orderDetail.setOrderId(order.getOrderId());
					noContract_orderDetail.setOrderDetailType( 'r' );
					noContract_orderDetail.setGersSKU( CommissionSku );
					noContract_orderDetail.setProductId( 0 );
					noContract_orderDetail.setProductTitle(CommissionSkuTitle);
					noContract_orderDetail.setQty(1);
					noContract_orderDetail.setNetPrice(0);
					noContract_orderDetail.save();
				</cfscript>
			</cfloop>
		</cfif>


	
	
		<cfif structKeyExists(session, 'cart') and structKeyExists(session.cart, 'orderRebateGuidList')>
			<cfset rebates = createObject('component', 'cfc.model.rebates').init() />
			<cfset rebates.assignOrderToRebates(orderId = variables.order.getOrderId(), rebateGuidList = trim(session.cart.orderRebateGuidList)) />
		</cfif>

		<cfset application.model.checkoutHelper.setOrderTotal(order.getOrderTotal()) />

		
		<cfset application.model.checkoutHelper.markStepCompleted('review') />
		<!---
		**
		* If wireless order, continue to coverage confirmation.
		**
		--->
		<!---<cfif IsDefined("Session.VFD.access") and Session.VFD.access>
			<cfif GatewayRegistry.hasMultipleRegistered()>
				<cfset event.setLayout('checkoutVFD') />
				<cfset event.setView('VFD/checkout/paymentOptions') />
			<cfelse>
				<cfset setNextEvent('CheckoutVFD.payment')>
			</cfif>
		<cfelse>
			<cfif application.model.checkoutHelper.isPrepaidOrder()>
				<cflocation url="/index.cfm/go/checkout/do/customerInfo/" addtoken="false" />
			<cfelseif application.model.checkoutHelper.isWirelessOrder()>
				<cflocation url="/index.cfm/go/checkout/do/carrierTerms/" addtoken="false" />
			<cfelseif GatewayRegistry.hasMultipleRegistered()>
				<cflocation url="/index.cfm/go/checkout/do/paymentOptions" addtoken="false" />
			<cfelse>
				<cfinclude template="/views/checkout/dsp_payment.cfm" />
			</cfif>
		</cfif>--->
		
		<cfset setNextEvent('checkoutDB/payment') />
	</cffunction>
		
	<cffunction name="payment" returntype="void" output="false" hint="">
		<cfargument name="event">

		<cfset event.setLayout('checkoutDB') />
		<cfset event.setView('CheckoutDB/paymentBD') />
	</cffunction>
	
	<!---
	**
	* 	Get the results from the payment.
	*
	* 	NOTE: The final step of the payment process requires the user to submit a form on the payment gateway's website
	* 	in order to POST transaction details back to us. If the user didn't submit the form, we wouldn't be notified.
	* 	Therefore, InternetSecure provides an "export script" which is a separate HTTP POST directly to our paymentGatewayAsyncListner
	* 	that runs without user interaction.  The isAsync() method on AbstractPaymentGateway is used to configure the gateway to apply
	*	payments outside of the request that redirects a user back to our site.
	*
	* 	In dev/test/stage, our servers aren't publically available, therefore we cannot consume the export script and must rely
	* 	on 2 things:
	*		1. User must click "continue" (not actual button name) on the final step of InternetSecure's payment wizard
	*		2. request.config.disablePaymentGateway must be true
	**
	--->
	
	<cffunction name="processPayment" returntype="void" output="false" hint="">
		<cfif !structKeyExists( form, "gatewayName" )>
			<cfthrow type="CheckoutController.processPayment" message="Unable to locate gateway.">
		</cfif>

		<cfset PaymentService = application.wirebox.getInstance("PaymentService") />
		<cfset PaymentGateway = PaymentService.getPaymentGatewayByName( form.gatewayName ) />

		<cfset Response = PaymentGateway.processPaymentResult(form) />
		<cfset Result =  Response.getResult() />

		<cfset paymentLogArgs = {
			OrderId = Result.getSalesOrderNumber()
			, Type = 'Response'
			, RequestType = 'Postback'
			, Data = form.toString()
		} />

		<cfset application.model.Log.logPaymentGatewayResponse( argumentCollection = paymentLogArgs ) />

		<cfparam name="request.config.disablePaymentGateway" type="boolean" default="false" />

		<cfif !PaymentGateway.isAsync()>
			<!--- If payment gateway is not asynchronous, we will not recieve a separate HTTP request with transaction details. Call it to apply payments to the order. --->
			<cfhttp url="http://#cgi.server_name#/asynclistner/paymentGatewayAsyncListener.cfm" throwonerror="yes" method="post" timeout="30" charset="utf-8">
				<cfhttpparam type="header" name="Accept-Encoding" value="*" />
				<cfhttpparam type="Header" name="TE" value="deflate;q=0"> 
				<cfloop collection="#form#" item="key">
					<cfhttpparam name="#key#" type="formfield" value="#form[key]#" />
				</cfloop>
			</cfhttp>
		</cfif>

		<cfif Response.getResultCode() is 'PG001' or Response.getResultCode() is 'PG003'>
			<cfif application.model.checkoutHelper.getOrderId() eq 0>
				<!--- Error, No Order ID in session attached to this payment. --->
				<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" /><!--- TODO: Probably should log this error --->
			<cfelseif application.model.checkoutHelper.getOrderId() neq Result.getSalesOrderNumber() AND Result.getSalesOrderNumber() DOES NOT CONTAIN application.model.checkoutHelper.getOrderId()>
				<!--- Session sales order does not match sales order passed. --->
				<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" /><!--- TODO: Probably should log this error --->
			<cfelse>
				<!--- Update the order status 1=submitted, 2=payment captured --->
				<cfset order = createObject('component', 'cfc.model.Order').init() />
				<cfset order.load(application.model.checkoutHelper.getOrderId()) />

				<cfif application.model.checkoutHelper.isWirelessOrder() && order.getOrderTotal() lte 0>
					<cfset order.setStatus(2) />
				<cfelseif application.model.checkoutHelper.isWirelessOrder()>
					<cfset order.setStatus(1) />
				<cfelse>
					<cfset order.setStatus(2) />
				</cfif>
				
				<cfset order.save() />
			</cfif>

			<cfset application.model.checkoutHelper.markStepCompleted('payment') />
			
			<cfset setNextEvent('checkoutDB/thanks') />
		<cfelse>
			<!--- todo: replace with payment declined page --->
			<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
		</cfif>
	</cffunction>	
	
	<cffunction name="thanks" returntype="void" output="false" hint="">
		<cfargument name="event">
	    <cfargument name="rc">
	    <cfargument name="prc">
	    <cfset var prevAction = "" />
	    <cfparam name="prc.showAddAnotherDeviceButton" default="true" />
	    <cfparam name="prc.showCheckoutnowButton" default="true" />
	    <cfparam name="prc.showClearCartLink" default="true" />
	    
	    <cfset prc.showNav = false>
	    
	    <cfset application.model.checkoutHelper.markStepCompleted('thanks') />
	    
	   <!--- MES FIX UP --->
	    <cfscript>
	    if (session.cart.getCarrierId() eq 109) {
              session.carrierObj.carrierLogo = "#assetPaths.channel#images/carrierLogos/att_logo_25.png";
            } else if (session.cart.getCarrierId() eq 42) {
              session.carrierObj.carrierLogo = "#assetPaths.channel#images/carrierLogos/verizon_logo_25.png";
            }
		</cfscript>
	    <!---GET PLAN FROM CART--->
      	<cfset prc.cartPlan = application.model.dBuilderCartFacade.getPlan()/>
		<cfset prc.showAddAnotherDeviceButton = false/>
		<cfset prc.additionalAccessories = application.model.dBuilderCartFacade.getAccessories(request.config.otherItemsLineNumber)/>
		<cfset prc.includeTallyBox = false/>
		<cfset prc.cartLines = session.cart.getLines()/>
		<cfset prc.customerType = listLast(session.cart.getActivationType(), '-')/>
	    
	    <!--- Redirect to account if session Order number is not present --->
		<!---<cfif !application.model.checkoutHelper.getOrderId()>
			<cflocation url="/index.cfm/go/myAccount/do/view/" addtoken="false" />
		</cfif>--->

		<cfset order = createObject('component', 'cfc.model.order').init() />
		<cfset order.load(application.model.checkoutHelper.getOrderId()) />

		<cfset request.p.orderId = variables.order.getOrderId() />
		<cfset request.p.email = variables.order.getEmailAddress() />

		<!---<cfif ChannelConfig.getTrackMercentAnalytics()>
			<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />
			<cfoutput>#mercentAnalyticsTracker.tagOrderConfirmation(variables.order)#</cfoutput>
		</cfif>--->

		<!---<cfif request.config.enableAnalytics>--->
			<!---<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
			<cfoutput>#googleAnalyticsTracker.tagOrderConfirmation(variables.order)#</cfoutput>--->
		<!---</cfif>--->
		
		<!--- If this is a VFD transaction proceed to Carrier Activation --->
		<!---<cfif channelConfig.getVfdEnabled()>
			<cflocation url="/CheckoutVFD/preCarrierActivation/" addtoken="false"/>
		</cfif>--->
		
		<!---<cfinclude template="/views/checkout/dsp_thanks.cfm" />--->

		<!---<cfset application.model.checkoutHelper.clearCart() />
		<cfset application.model.checkoutHelper.clearCheckOut() />--->
		
		<cfset event.setLayout('checkoutReviewDB') />
		<cfset event.setView('CheckoutDB/thanksDB') />
	</cffunction>
	
	<cffunction name="emailPDF" returntype="void" access="remote" output="false">
		<cfargument name="urlPDF" type="string" required="yes" />
		<cfargument name="rc">
		<cfargument name="event">   
		
		<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
		<cfset theOrderAddress = CreateObject('component', 'cfc.model.OrderAddress').init() />
		<cfset theUser = CreateObject('component', 'cfc.model.User').init() />
		
		<cfset theOrder.load(session.checkout.OrderId) />
		<cfset theUser.getUserById(theOrder.getUserId()) />
		<cfset theShippingAddress = theOrder.getShipAddress() />
		
		<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
		<cfset email = theOrder.getEmailAddress() />
		<cfset sendFrom = request.config.customerServiceEmail />
		<cfset subject = "#channelConfig.getDisplayName()# Order Documents" />
		
		<!--- mail the message --->
		<cfmail to="#email#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
   		Please find attached your requested document.
   		<cfmailparam
                file="#urlPDF#"
                type="application/pdf"
                />
        
		</cfmail>
        <cfset event.noRender() />
	</cffunction>
	
	<cffunction name="customerservice" returntype="void" output="false" hint="">
		<cfset request.layoutFile = 'nolayout' />
		<cfset request.Title = ChannelConfig.getDisplayName() & ' Customer Service' />
		<cfset request.MetaDescription = ChannelConfig.getDisplayName() & ' Customer Service' />
		<cfset request.MetaKeywords = ChannelConfig.getDisplayName() & ', Customer Service' />
		<cfinclude template="/views/checkout/dsp_CustomerServiceContacUs.cfm" />
	</cffunction>
	
	<cffunction name="error" returntype="void" output="false" hint="">
		<cfset request.currentTopNav = "checkout.error">
		<!--- save the user's order, and display a friendly error --->
		<cfinclude template="/views/checkout/dsp_error.cfm"/>
	</cffunction>
	
	<cffunction name="checkoutError" returntype="void" output="false" hint="">
		<!---<cfset request.currentTopNav = "checkout.checkoutError">--->
		<cfset request.currentTopNav = "home">
		<!--- save the user's order, and display a friendly error --->
		<cfinclude template="/views/checkout/dsp_CheckoutError.cfm"/>
	</cffunction>
	
	<cffunction name="inventoryerror" returntype="void" output="false" hint="">
		<cfset request.currentTopNav = "checkout.error">
		<cfinclude template="/views/checkout/dsp_OutOfStock.cfm"/>
	</cffunction>
	
	<cffunction name="paymentOptions" returntype="void" output="false" hint="">
		<cfset application.model.checkoutHelper.markStepCompleted('CustLetter') />
		<cfset application.model.CheckoutHelper.setCurrentStep("payment") />
		<cfinclude template="/views/checkout/dsp_PaymentOptions.cfm" />
	</cffunction>
	
	<cffunction name="processPaymentOptions" returntype="void" output="false" hint="">
		<cfset application.model.CheckoutHelper.setCurrentStep("payment") />
		<cfset application.model.checkoutHelper.setPaymentMethod(form.paymentMethod)>
		<cfset PaymentGateway = GatewayRegistry.findGateway( application.model.checkoutHelper.getPaymentMethod() )>
				
		<cfset Order = createObject('component', 'cfc.model.Order').init()>
		<cfset Order.load( application.model.checkoutHelper.getOrderID() )>

		<!--- Associate gateway to order --->
		<cfset Order.setPaymentGatewayID( PaymentService.getPaymentGatewayIDByName( PaymentGateway.getName() ) )>
		<cfset Order.save()>
		
		<cfif structKeyExists( form, "paymentMethod" )>
			<cflocation url="/index.cfm/go/checkout/do/payment" addToken="false" />
		<cfelse>
			<cflocation url="/index.cfm/go/checkout/do/paymentOptions" addToken="false" />
		</cfif>
	</cffunction>
	
	<cffunction name="addPromotionToCart" returntype="void" output="false" hint="">
		<cfparam name="request.p.code" default="">
		<cfparam name="request.p.returnURL" default="">
				
		<cfscript>
			
			if( len( request.p.code ) &&  ChannelConfig.isPromotionCodeAvailable() ) {
				
				if( !session.cart.hasPromotion( request.p.code ) ) {
					
					Result = PromotionService.evaluatePromotion( 
								code = ucase(request.p.code), 
								userID = session.userID,
								cartPromotionCodeList = structKeyList(session.Cart.getPromotionCodes()),
								accessoryTotal = session.Cart.getAccessoriesAmtDueToday(),
								accessoryQuantity = arrayLen(session.Cart.getAccessories(includeFree=false)),
								orderTotal = session.Cart.getCartItemsAmtDueToday(),
								orderQuantity = arrayLen(session.Cart.getCartItems(includeFree=false)),
								orderSKUList = session.Cart.getCartSKUList()
							);
					
					PromotionService.addPromotionToCart( 
								cart = session.Cart, 
								result = Result, 
								shipMethod = application.model.checkoutHelper.getShippingMethod(),
								userID = session.userID,
								isNew = true
							);
							
					if( Result.passed() ) {
						session.cart.addPromotion( ucase(request.p.code), Result.getName(), Result.getPromotionID() );
					}
					
					application.model.CheckoutHelper.setCheckoutMessageBox( Result.getMessage() );
					
				} else {
					
					application.model.CheckoutHelper.setCheckoutMessageBox( "Promotion has already been applied." );
					
				}
				
			}
		</cfscript>

		<cflocation addtoken="false" url="#returnURL#">
	</cffunction>
	
	<cffunction name="removePromotion" returntype="void" output="false" hint="">
		<cfparam name="request.p.code" default="" />
		
		<cfif session.Cart.hasPromotion( request.p.code ) >
			<cfset session.Cart.removePromotion( request.p.code )>
		</cfif>
		
		<cflocation addtoken="false" url="#returnURL#">
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------
	 Capture payments
	 --------------------------------------------------------------------------------------------->
	 
	 <cffunction name="doCapturePayment" returntype="void" output="false" hint="">
	 	<cfargument name="orderId" type="numeric" required="true" />
	 	<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
		<cfset PaymentService = application.wirebox.getInstance("PaymentService") />
		<cfset session.adminuser.adminuserid = session.VFD.employeeNumber />
		<cftry>
		
		<cfset order = CreateObject( "component", "cfc.model.Order" ).init()>
		<cfset order.load(arguments.orderId)>

		<cfset PaymentGateway = PaymentService.getPaymentGatewayByID( order.getPaymentGatewayID() ) />
		<cfset Response = PaymentGateway.capturePayment( argumentCollection = form )>
		<cfset Result = Response.getResult()>

		<cfquery datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO service.PaymentGatewayLog
			(
				LoggedDateTime
				, OrderId
				, Type
				, RequestType
				, Data
			)
			VALUES
			(
				GETDATE()
				, <cfqueryparam value="#Result.getSalesOrderNumber()#" cfsqltype="cf_sql_integer" />
				, <cfqueryparam value="Response" cfsqltype="cf_sql_varchar" />
				, <cfqueryparam value="Capture" cfsqltype="cf_sql_varchar" />
				, <cfqueryparam value="#Response.getDetail()#" cfsqltype="cf_sql_longvarchar" />
			)
		</cfquery>
		
		<cfif Response.getResultCode() eq "PG001">
			
			<cfquery name="qry_getPaymentMethod" datasource="#application.dsn.wirelessadvocates#">
				SELECT PaymentMethodId FROM salesorder.PaymentMethod 
				WHERE [Name] = <cfqueryparam value="#Result.getCCType()#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			
			<cfif qry_getPaymentMethod.recordCount>
				<cfset payMethodId = qry_getPaymentMethod.paymentMethodId />
			<cfelse>
				<cfset payMethodId = 1 />
			</cfif>
						
			
			<cfquery name="qry_insertPayment" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO salesorder.Payment (
					OrderId,
					PaymentAmount,
					PaymentDate,
					CreditCardExpDate,
					CreditCardAuthorizationNumber,
					PaymentMethodId,
					BankCode,
					AuthorizationOrigId,
					RefundOrigId,
					ChargebackOrigId,
					PaymentToken
				)
				VALUES
				(
					<cfqueryparam value="#Result.getSalesOrderNumber()#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#Result.getTotalAmount()#" cfsqltype="cf_sql_money" />,
					GETDATE(),
					NULL,
					<cfqueryparam value="#Result.getReceiptNumber()#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#variables.payMethodId#" cfsqltype="cf_sql_integer" />,
					'DD',
					<cfqueryparam value="#Result.getGUID()#" cfsqltype="cf_sql_varchar" />,
					NULL,
					NULL,
					( 	
						SELECT TOP 1 PaymentToken 
						FROM salesorder.Payment 
						WHERE OrderId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Result.getSalesOrderNumber()#" />
							AND PaymentToken IS NOT NULL
						ORDER BY PaymentId DESC
					)
				)
			</cfquery>
			
			<cfscript>
				// Commit Tax Transaction
				args = {
					CommitDate 			=	order.getOrderDate()
					,InvoiceNumber 		=	request.config.InvoiceNumberPrefix & order.getOrderId()
					,PriorTransactionId	=	order.getSalesTaxTransactionId()
				};

				taxCalculator = application.wirebox.getInstance("TaxCalculator");
				taxCalculator.commitTaxTransaction(argumentCollection = variables.args);

				order.setIsSalesTaxTransactionCommited(true);
				
				order.setStatus( 2 ); //Update status to submitted
				order.setPaymentCapturedById( session.UserId ); //Log user that captured payment
				order.save();
			
				application.model.actionCaptures.insertActionCapture(adminUserId = session.UserId, actionId = 2, orderId = Result.getSalesOrderNumber(), message = '');
	
				// Add order note
				local.ticketStruct = StructNew();
				local.ticketStruct.NoteBody = 'Payment Capture Sucessful - Verbiage: #Result.getVerbiage()#';
				local.ticketStruct.OrderNoteSubjectId = 52;
				local.ticketStruct.OrderId = Result.getSalesOrderNumber();
				local.ticketStruct.CreatedById = session.userid;
				local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct);
			</cfscript>
			
			<div class="message">
				Payment has been captured
			</div>
			
		<cfelse>
			
			<cfquery datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO service.PaymentGatewayLog
				(
					LoggedDateTime
					, OrderId
					, Type
					, RequestType
					, Data
				)
				VALUES
				(
					GETDATE()
					, <cfqueryparam value="#arguments.orderID#" cfsqltype="cf_sql_integer" />
					, <cfqueryparam value="Response" cfsqltype="cf_sql_varchar" />
					, <cfqueryparam value="Capture" cfsqltype="cf_sql_varchar" />
					, <cfqueryparam value="#Response.getMessage()# - #Response.getDetail()#" cfsqltype="cf_sql_longvarchar" />
				)
			</cfquery>
						
			<!--- Add order note --->
			<cfset local.ticketStruct = StructNew()>
			<cfset local.ticketStruct.NoteBody = 'Payment Response: #Response.getMessage()#' />
			<cfset local.ticketStruct.OrderNoteSubjectId = 52 />
			<cfset local.ticketStruct.OrderId = arguments.orderId />
			<cfset local.ticketStruct.CreatedById = session.userid />
			<cfset local.void = application.model.TicketService.addOrderNote(argumentCollection = local.ticketStruct) />			
			
			<div class="message">
				Payment Response: <cfoutput>#Response.getMessage()#</cfoutput>
			</div>
		</cfif>	
	
		<cfcatch>
			

			<cfquery name="qry_insertError" datasource="#application.dsn.wirelessadvocates#">
				INSERT INTO service.PaymentGatewayListener
				(
					Content,
					CreatedDate
				)
				VALUES
				(
					<cfqueryparam value="Payment capture unsuccessful: #cfcatch.message# - #cfcatch.detail#" cfsqltype="cf_sql_longvarchar" />,
					GETDATE()
				)
			</cfquery>
			<cfdump var="#cfcatch.message#"><cfabort>
			
			<div class="message-sticky">
				<cfoutput>Payment capture unsuccessful: #cfcatch.message# - #cfcatch.detail#</cfoutput>
			</div>
		</cfcatch>

		</cftry>
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------
	 Call AppleCare Verify and store the results in the order detail for the applecare product
	 --------------------------------------------------------------------------------------------->
	 
	<cffunction name="doAppleCareVerify" returntype="void" output="false" hint="">
		<cfargument name="order" type="cfc.model.order" required="true" />
		<cfargument name="polist" type="any" required="true" />
		
		<cfset local = {} />
				
		<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
		<cfset local.order = arguments.order />
		<cfset local.wirelessLines = local.order.getWirelesslines() />
		<cfset local.AppleCareMessages = local.appleCare.getMessages(arguments.order.getOrderId()) />
		<!--- loop thru po's and attach each line --->
		<cfloop list="#arguments.polist#" index="local.po">
			<cfset local.verifyLine = listgetat(local.po,3,"-") />
			<cfif local.verifyLine is not "">			
				<cfset local.wOrderDetail = local.wirelesslines[local.verifyLine].getLineWarranty() />
				<cfset local.acVerifyResponse = deserializeJson(local.appleCare.sendVerifyOrderRequest(arguments.order.getOrderID(), local.verifyLine)) />
				
				<!--- Figure out which errors we have --->
				<cfset local.AcGeneralErrors = 0 />
				<cfset local.AcNonDeviceErrors = 0 />
				<cfset local.AcDeviceErrors = 0 />							
				<cfif isDefined("local.acVerifyResponse.Message")><cfset local.AcGeneralErrors = local.AcGeneralErrors+1 /></cfif>
				<cfif isdefined("local.acVerifyResponse.errorResponse") and arrayLen(local.acVerifyResponse.errorResponse) gt 0><cfset local.AcNonDeviceErrors = local.AcNonDeviceErrors+1 /></cfif>
				<cfif isdefined("local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.errorResponse") AND arraylen(local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.errorResponse) gt 0><cfset local.AcDeviceErrors = local.AcDeviceErrors+1 /></cfif>
				<cfset local.AcAllErrors = local.AcGeneralErrors + local.AcNonDeviceErrors + local.AcDeviceErrors />
				<cfset local.wOrderDetailMessage = {} />
				<cfset local.wOrderDetailMessage.op = "Verify" />
							
				<cfif local.AcAllErrors is 0>
				<!--- Update the order detail record with Verification info --->			
					<cfset local.wOrderDetailMessage.op_status = "Verified" /> 
					<cfset local.wOrderDetailMessage.TransactionId = local.acVerifyResponse.TransactionId />
					<cfset local.wOrderDetailMessage.po = local.acVerifyResponse.originalRequest.purchaseOrderNumber />
					<cfset local.wOrderDetailMessage.deviceid = local.acVerifyResponse.originalRequest.DeviceRequest[1].deviceid />
					<cfset local.wOrderDetailMessage.referenceid = local.acVerifyResponse.originalRequest.referenceid />
					<cfset local.wOrderDetail.setMessage(serializeJson(local.wOrderDetailMessage)) />
					<cfset local.wOrderDetail.save() />
					<div class="message-sticky">
						<cfoutput>AppleCare successfully verified line #local.verifyLine#.</cfoutput>
					</div>	
				<!--- Device specific errors --->	
				<cfelseif local.AcDeviceErrors gt 0 > 
					<cfset local.wOrderDetailMessage.op_status = "Device Failed" /> 
					<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorCode />
					<cfset local.wOrderDetailMessage.errorMessage = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse[1].errorMessage />
					<cfset local.wOrderDetailMessage.deviceid = local.acVerifyResponse.originalRequest.DeviceRequest[1].deviceid />
					<cfset local.wOrderDetailMessage.referenceid = local.acVerifyResponse.originalRequest.referenceid />
					<cfset local.wOrderDetailMessage.deviceid = local.acVerifyResponse.originalRequest.DeviceRequest[1].deviceid />
					<!--- Make sure we don't overflow the column size (currently 255) --->
					<cfset local.jsonLength =  len(serializeJson(local.wOrderDetailMessage))/>
					<cfif local.jsonLength gt 255>
						<!--- trim the length of the error message --->
						<cfset local.wOrderDetailMessage.errorMessage = left(local.wOrderDetailMessage.errorMessage,(len(local.wOrderDetailMessage.errorMessage)-(local.jsonLength-255)) ) />
					</cfif>
					<div class="message-sticky">
						<cfoutput>AppleCare verify device error: #local.wOrderDetailMessage.errorMessage# (#local.verifyLine#).</cfoutput>
					</div>	
	
				<!--- Non-Device Errors --->	
				<cfelseif local.AcNonDeviceErrors gt 0>
					<cfset local.wOrderDetailMessage.op_status = "General Error" />
					<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.errorResponse[1].errorCode />
					<cfset local.wOrderDetailMessage.errorMessage = local.acVerifyResponse.errorResponse[1].errorMessage />
					<div class="message-sticky">
						<cfoutput>AppleCare verify non-device error: #local.wOrderDetailMessage.errorMessage# (line #local.verifyLine#).</cfoutput>
					</div>	
				<!--- General errors --->
				<cfelse>
					<cfset local.wOrderDetailMessage.op_status = "General Error" /> 
					<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
					<cfset local.wOrderDetailMessage.errorCode = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorCode />
					<cfset local.wOrderDetailMessage.errorMessage = local.acVerifyResponse.OrderDetailsResponses.DeviceEligibility.ErrorResponse.errorMessage />
					<div class="message-sticky">
						<cfoutput>AppleCare verify general error: #local.wOrderDetailMessage.errorMessage# (line #local.verifyLine#).</cfoutput>
					</div>	
				</cfif>				
				<!--- Write the results to the order detail message column --->
				<cfset local.wOrderDetail.setMessage(serializeJson(local.wOrderDetailMessage)) />
				<cfset local.wOrderDetail.save() />
			</cfif>	
		</cfloop>	
	</cffunction>
	
	<!--------------------------------------------------------------------------------------------
	 Call AppleCare Attach and store the results in the order detail for the applecare product
	 --------------------------------------------------------------------------------------------->
	 
	<cffunction name="doAppleCareAttach" returntype="void" output="false" hint="">
		<cfargument name="order" type="cfc.model.order" required="true" />
		<cfargument name="polist" type="any" required="true" />

		<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
		<cfset local.order = arguments.order />
		<cfset local.wirelessLines = local.order.getWirelesslines() />

		<!--- loop thru po's and attach each line --->
		<cfloop list="#arguments.polist#" index="local.po">
			<cfset local.attachLine = listgetat(local.po,3,"-") />
			<cfif local.attachLine is not "">			
				<cfset local.wOrderDetail = local.wirelesslines[local.attachLine].getLineWarranty() />
				<cfset local.acAttachResponse = deserializeJson(local.appleCare.sendCreateOrderRequest(arguments.order.getOrderID(), local.attachLine)) />
				<cfif structKeyExists(local.acattachResponse,"ErrorResponse") and arrayLen(local.acattachResponse.ErrorResponse) is 0>
				<!--- Create the xml string to write to the orderDetailLog --->			
				<cfset local.xmlStr ='<?xml version="1.0" encoding="UTF-8"?>' &
					'<applecareattach>' &
						'<transactionid>#local.acattachResponse.transactionid#</transactionid>' &
						'<DeviceEligibility>' &
							'<DeviceDateOfPurchase>#local.acattachResponse.OrderDetailsResponses.DeviceEligibility.DeviceDateOfPurchase#</DeviceDateOfPurchase>' &
							'<SerialNumber>#local.acattachResponse.OrderDetailsResponses.DeviceEligibility.SerialNumber#</SerialNumber>' &
						'</DeviceEligibility>' &
						'<OrderConfirmation>' &
							'<AppleCareSalesDate>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AppleCareSalesDate#</AppleCareSalesDate>' &
							'<partNumber>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.PartNumber#</partNumber>' &
							'<AgreementNumber>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AgreementNumber#</AgreementNumber>' &
							'<PurchaseOrderNumber>#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.PurchaseOrderNumber#</PurchaseOrderNumber>' &
							'</OrderConfirmation>' &
					'</applecareattach>' />
	
					<cfset local.orderDetailLog = CreateObject( "component", "cfc.model.OrderDetailLog" ).init(
						 orderDetailId = local.wOrderDetail.getOrderDetailId()
					   , type = "AppleCare Attach"
					   , log = local.xmlStr
					)>
					<cfset local.orderDetailLog.save() />
					<div class="message-sticky">
						<cfoutput>AppleCare successfully attached line #local.attachLine#.</cfoutput>
					</div>	
					
					<!--- We also want to update the json in the orderdetail to indicate attached --->
					<cfset local.acjson = {} />
					<cfset local.acjson.op = "Create" />
					<cfset local.acjson.op_status = "Created" />
					<cfset local.acjson.acdate = "#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AppleCareSalesDate#" />
					<cfset local.acjson.IMEI = "#local.acattachResponse.OrderDetailsResponses.DeviceEligibility.SerialNumber#" />
					<cfset local.acjson.agreement = "#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.AgreementNumber#" />
					<cfset local.acjson.tranid = "#local.acattachResponse.transactionid#" />
					<cfset local.acjson.po = "#local.acattachResponse.OrderDetailsResponses.OrderConfirmation.PurchaseOrderNumber#" />			
					<cfset local.wOrderDetail.setMessage(serializeJson(local.acJson)) />
					<cfset local.wOrderDetail.save() />
	
				<cfelse>
					<!--- Attach error handling here --->
				</cfif>	
			</cfif>	
		</cfloop>	
		
	</cffunction>
	
	
	<cffunction name="doAppleCareProcess" returntype="void" output="false" hint="">
		<cfargument name="order" type="cfc.model.order" required="true" />

		<cfset var local = {} />
		<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
		<cfset local.appleCarePoList = "" />
		<!--- Make sure this order contains at least one applecare line --->
		<cfif local.appleCare.isAppleCareOrder(arguments.order.getOrderId()) >		
			<cfset local.AppleCareMessages = local.appleCare.getMessages(arguments.order.getOrderId()) />
			<cfset local.vCount = 0 />
			
			<!--- Loop thru the applecare messages and make sure at least one needs to be verified --->
			<cfloop array="#local.AppleCareMessages#" index="local.apm">
				<cfif structKeyExists(local.apm,"op") and local.apm.op is "Needs Verify" >
					<cfset local.vCount = local.vCount + 1 />
					<cfset local.appleCarePoList = ListAppend(local.appleCarePoList,local.apm.po) />
				</cfif> 
			</cfloop>
			<cfif local.vCount gt 0>
				<!---<cfset doAppleCareVerify(arguments.order,local.applecarePoList) />--->
				<cfset doAppleCareVerify(arguments.order,local.applecarePoList) />
			</cfif>
			<!--- do the applecare attach --->
			<cfset doAppleCareAttach(arguments.order,local.applecarePoList) />
		</cfif>

	</cffunction>
	
	
	
	<cffunction name="exitVFD" returntype="void" output="false" >
		<cfargument name="event">
		
		<cfset session.VFD.access = false/>
		<cfset Session.VFD.kioskNumber= 0/>
		<cfset Session.VFD.employeeNumber = 0/>
		<cfset application.model.checkoutHelper.clearCart() />
		<cfset application.model.checkoutHelper.clearCheckOut() />
		<cfset session.userID = 0 />
		
		<cfset event.setView('VFD/logoutVFD') />
	</cffunction>
	
</cfcomponent>