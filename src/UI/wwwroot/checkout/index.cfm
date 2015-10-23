<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
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
<cfparam name="request.p.resultCode" default="" type="string" />
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
	<cflocation url="https://#cgi.server_name#/index.cfm/#cgi.path_info#" addtoken="false" />
</cfif>

<cfif not structKeyExists(session, 'currentUser')>
	<cfset session.currentUser = createObject('component', 'cfc.model.User').init() />
</cfif>

<cfset request.layoutFile = 'checkout' />
<cfset request.validator = createobject('component', 'cfc.model.FormValidation').init() />
<cfset request.validatorView = createobject('component', 'cfc.view.FormValidation').init() />

<cfif not application.model.checkoutHelper.isCheckoutEnabled(session.cart.getCarrierId())>
	<cflocation url="/index.cfm/go/error/do/checkoutOffline/" addtoken="false" />
</cfif>

<!--- Update the timestamp on all soft reservations for this user with every step through checkout. --->
<cfset application.model.checkoutHelper.updateSoftReservationTimestamps() />

<cfswitch expression="#request.p.do#">
	<cfcase value="startCheckout">
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

		<cfset softReservationSuccess = application.model.CheckoutHelper.softReserveCartHardGoods() />
		<cfset request.p.bSoftReservationSuccess = variables.softReservationSuccess />

		<cfif not variables.softReservationSuccess>
			<!--- TODO: prevent the user from proceeding with the order at this point if the hard goods could not all be reserved --->

			<cfscript>
				local.MessageBox = "The device that you wish to purchase is no longer in stock and has been removed from your shopping cart. Please select another device.";
				application.model.Checkouthelper.setCheckoutMessageBox( local.MessageBox );
			</cfscript>

			<cflocation url="/index.cfm/go/cart/do/view/" addtoken="false" />
		</cfif>

		<cfif not application.model.checkoutHelper.isWirelessOrder()>
			<cfif session.cart.getPrepaid()>
				<cfset application.model.checkoutHelper.generateReferenceNumber() />
				<cflocation url="/index.cfm/go/checkout/do/requestAreaCode" addtoken="false" />
			<cfelse>
				<!--- Accessories and No-Contract phones --->
				<cflocation url="/index.cfm/go/checkout/do/billShip/bSoftReservationSuccess/1/" addtoken="false" />
			</cfif>
		</cfif>

		<cfif isDefined('url.regen')>
			<cfset application.model.checkoutHelper.clearReferenceNumber() />
		</cfif>

		<cfset application.model.checkoutHelper.generateReferenceNumber() />
		<cfset application.model.checkoutHelper.setCarrierConversationId('') /> <!--- Clear conversation ID --->

		<cfswitch expression="#application.model.checkoutHelper.getCheckoutType()#">
			<cfcase value="new">
				<cflocation url="/index.cfm/go/checkout/do/lnpRequest/bSoftReservationSuccess/1/" addtoken="false" />
			</cfcase>
			<cfcase value="add">
				<cflocation url="/index.cfm/go/checkout/do/wirelessAccountForm/bSoftReservationSuccess/1/" addtoken="false" />
			</cfcase>
			<cfcase value="upgrade">
				<cflocation url="/index.cfm/go/checkout/do/wirelessAccountForm/bSoftReservationSuccess/1/" addtoken="false" />
			</cfcase>
			<cfdefaultcase>

			</cfdefaultcase>
		</cfswitch>
	</cfcase>

	<cfcase value="wirelessAccountForm">
		<cfset request.p.authorizationDisplay = 'pin' />
		<cfset session.checkout.LookupByPinAttempts = 0 />

		<cfset request.currentTopNav = 'checkout.wirelessAccountForm' />
		<cfset application.model.checkoutHelper.setCurrentStep('wirelessAccount') />

		<cfif session.currentUser.getUserID() is not '' and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())
			and (application.model.checkoutHelper.isUpgrade() or application.model.checkoutHelper.getCheckoutType() is 'Add')>

			<cfinclude template="/views/checkout/dsp_orderAssistantMessageBox.cfm" />
		</cfif>

		<cfif application.model.checkoutHelper.isUpgrade() and arrayLen(session.cart.getLines()) gt 1>
			<cfinclude template="/views/checkout/dsp_wirelessMultiLineAccountForm.cfm" />
		<cfelse>
			<cfinclude template="/views/checkout/dsp_wirelessAccountForm.cfm" />
		</cfif>
	</cfcase>


	<cfcase value="processWirelessAccountForm">
		<cfset local = structNew() />
		<cfset local.isByPassOn = false />
		<cfset application.model.checkoutHelper.setWirelessAccountForm(request.p) />

<cftry>
		<!--- By-Pass with Order Assistance --->
		<cfif session.currentUser.getUserID() is not '' and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())>
			<cfset local.isByPassOn = true />
		</cfif>

		<cfset request.validator.clear() />

		<cfif trim(request.p['areacode']) is '' and trim(request.p['lnp']) is '' and trim(request.p['lastfour']) is ''>
			<cfset request.validator.addMessage('mdn', 'Wireless number is required.') />
		<cfelseif trim(request.p['areacode']) is '' or trim(request.p['lnp']) is '' or trim(request.p['lastfour']) is ''>
			<cfset request.validator.addMessage('mdn', 'Incomplete phone number entered.') />
		<cfelse>
			<cfset request.validator.addPhoneValidator('mdn', request.p['areacode'] & request.p['lnp'] & request.p['lastfour'], 'Wireless number is invalid.') />
		</cfif>

		<cfif request.p.AuthorizationType eq 'pin'>
			<cfset request.validator.addRequiredFieldValidator('pin', trim(request.p['pin']), 'Please enter a valid pin number for account access.') />

			<cfif application.model.CheckoutHelper.getCarrier() EQ 299>
				<cfset request.validator.AddFieldLengthValidator('pin', trim(request.p['pin']), 'Pin must be between 6 and ten digits.', 6, 10) />
				<cfset request.validator.AddIsNumericValidator('pin', trim(request.p['pin']), 'Pin must be between 6 and ten digits.') />
			<cfelse>
				<cfset request.validator.AddFieldLengthValidator('pin', trim(request.p['pin']), 'SSN must be 4 digits in length.', 4, 4) />
			</cfif>
		</cfif>

		<cfif request.p.AuthorizationType eq 'SecurityQuestion'>
			<cfset request.validator.addRequiredFieldValidator('SecurityQuestionAnswer', trim(request.p['SecurityQuestionAnswer']), 'Answer to security question is required') />
		</cfif>

		<cfif request.p.AuthorizationType eq 'LastFourSsn'>
			<cfset request.validator.addRequiredFieldValidator('LastFourSsn', trim(request.p['LastFourSsn']), 'Last four of your SSN is required') />
			<cfset request.validator.AddFieldLengthValidator('LastFourSsn', trim(request.p['LastFourSsn']), 'SSN must be 4 digits in length.', 4, 4) />
		</cfif>

		<cfif listFind('42,109', application.model.checkoutHelper.getCarrier())>
			<cfset request.validator.addRequiredFieldValidator('billingZip', request.p.billingZip, 'Please enter the account''s billing zip code.') />
			<cfset request.validator.addZipCodeValidator('billingZip', request.p.billingZip, 'Enter a valid Zip Code.') />
		</cfif>


		<cfif not request.validator.hasMessages()>
			<cfset request.mdn = trim(request.p['areacode']) & trim(request.p['lnp']) & trim(request.p['lastfour']) />

			<cfset application.model.checkoutHelper.setCurrentMDN(request.mdn) />

			<cfset local.lookupArgs = {
				carrier = trim(application.model.checkoutHelper.getCarrier()),
				mdn = trim(request.mdn),
				pin = '',
				referenceNumber = trim(application.model.checkoutHelper.getReferenceNumber()),
				resultCode = trim(request.p.resultCode),
				ServiceZipCode = session.cart.getZipCode()
			} />

			<cfif structKeyExists(request.p, 'pin')>
				<cfset local.lookupArgs.pin = request.p.pin />
			</cfif>

			<cfif structKeyExists(request.p, 'SecurityQuestionAnswer')>
				<cfset local.lookupArgs.SecurityQuestionAnswer = request.p.SecurityQuestionAnswer />
			</cfif>

			<cfif structKeyExists(request.p, 'LastFourSsn')>
				<cfset local.lookupArgs.LastFourSsn = request.p.LastFourSsn />
			</cfif>

			<cfif listFind('42,109', application.model.checkoutHelper.getCarrier())>
				<cfset local.lookupArgs.zipCode = left(trim(request.p.billingZip), 5) />
			<cfelse>
				<cfset local.lookupArgs.zipCode = left(trim(session.cart.getZipCode()), 5) />
			</cfif>

			<cfif listFind('42', application.model.checkoutHelper.getCarrier())>
				<cfset local.lookupArgs.accountPassword = trim(request.p.accountPassword) />
			</cfif>

			<cfif application.model.checkoutHelper.getCarrier() eq 109>
				<cfset local.lookupArgs.ActivationType = session.cart.getActivationType() />
				<cfset local.lookupArgs.NumberOfLinesRequested = application.model.checkoutHelper.getNumberOfLines() />
			</cfif>

			<cfif application.model.checkoutHelper.getCarrier() eq 299>
				<cfset local.lookupArgs.ActivationType = session.cart.getActivationType() />
			</cfif>

			<cfset accountLookups = [] />

			<cfset accountLookup = {
				lookupArgs = local.lookupArgs
			} />

			<cfset local.lookupResult = application.model.customerLookup.lookup(argumentCollection = local.lookupArgs) />



			<cfset accountLookup.lookupResult = local.lookupResult />
			<cfset arrayAppend(variables.accountLookups, variables.accountLookup) />

			<cfif local.lookupResult.getResultCode() is 'CL001'>
				
				<!--- Save conversation ID for AT&T --->
				<cfif application.model.checkoutHelper.getCarrier() eq 109 && StructKeyExists(local.lookupResult.getResult(), "CarrierConversationId")>					
					<cfset application.model.checkoutHelper.setCarrierConversationId( local.lookupResult.getResult().CarrierConversationId ) />
				</cfif>
	
				<cfif not local.isByPassOn>

					<cfif session.cart.getAddALineType() eq 'Family' && (local.lookupResult.getResult().wirelessAccountType neq 'Family' && local.lookupResult.getResult().wirelessAccountType neq 'Shared')>
						<cflocation url="/index.cfm/go/checkout/do/error/?code=322" addtoken="false" />
					</cfif>

					<!--- Check for invalid device & plan combinations for account look ups (Verizon said to hard code these plans for now)--->
					<cfif application.model.checkoutHelper.getCheckoutType() eq 'add' && application.model.CheckoutHelper.getCarrier() eq 42>
						<cfif session.cart.getDeviceTypeCount('MobileBroadband') && ListFind( '86487,86489', Left(local.lookupResult.getResult().CarrierPlanId, 5) ) >
							<cflocation url="/index.cfm/go/checkout/do/error/?code=325" addtoken="false" />
						</cfif>
					</cfif>

					<!--- Check that requested additional lines can be added to account --->
					<cfswitch expression="#application.model.checkoutHelper.getCheckoutType()#">
						<cfcase value="add">
							<cfif application.model.CheckoutHelper.getCarrier() eq 109 && Len(Trim(local.lookupResult.getResult().customerAccountPassword))>
								<cfset session.InvalidAccountPasswordAttempts = 0 />

								<cfset application.model.checkoutHelper.setCustomerLookupResult(variables.accountLookups) />
								<cfset application.model.checkoutHelper.setDepositAmount(0) />
								<cfset application.model.checkoutHelper.setAccountPin(local.lookupArgs.pin) />
								<cfif StructKeyExists( request.p, 'billingZip' )>
									<cfset application.model.checkoutHelper.setAccountZipCode(trim(request.p['billingZip'])) />
								</cfif>

								<cfset application.model.checkoutHelper.setCustomerAccountPassword( local.lookupResult.getResult().customerAccountPassword ) />
								<cfset application.model.checkoutHelper.setLinesApproved(local.lookupResult.getResult().user.getLinesApproved()) />
								<cfset application.model.checkoutHelper.setLinesActive(local.lookupResult.getResult().user.getLinesActive()) />

								<cflocation url="/index.cfm/go/checkout/do/carrierAccountPassword/" addtoken="false" />
							<cfelse>
								<cfif local.lookupResult.getResult().user.getLinesApproved() lt application.model.checkoutHelper.getNumberOfLines()>
									<cfset application.model.checkoutHelper.setLinesApproved(local.lookupResult.getResult().user.getLinesApproved()) />
									<cfset application.model.checkoutHelper.setLinesActive(local.lookupResult.getResult().user.getLinesActive()) />

									<cflocation url="/index.cfm/go/checkout/do/error/?code=320" addtoken="false" />
								</cfif>
							</cfif>

						</cfcase>
					</cfswitch>

					<!--- Check upgrade eligibility --->
					<cfswitch expression="#application.model.checkoutHelper.getCheckoutType()#">
						<cfcase value="upgrade">
							<cfif not local.lookupResult.getResult().canUpgradeEquipment>
								<cfif application.model.CheckoutHelper.getCarrier() eq 109 && Len(Trim(local.lookupResult.getResult().customerAccountPassword))>
									<cfset session.InvalidAccountPasswordAttempts = 0 />
									<cfset application.model.checkoutHelper.setCustomerAccountPassword( local.lookupResult.getResult().customerAccountPassword ) />
									<cfset application.model.checkoutHelper.setIsUpgradeEligible( local.lookupResult.getResult().canUpgradeEquipment ) />

									<cflocation url="/index.cfm/go/checkout/do/carrierAccountPassword/" addtoken="false" />
								<cfelse>
									<cflocation url="/index.cfm/go/checkout/do/error/?code=321" addtoken="false" />
								</cfif>
							</cfif>
						</cfcase>
					</cfswitch>

					<!--- Check for Verizon SmartPhone device cap --->
					<cfif application.model.checkoutHelper.getCheckoutType() eq 'add' && application.model.CheckoutHelper.getCarrier() eq 42 && local.lookupResult.getResult().DeviceCap neq 0>
						<cfif (session.cart.getDeviceTypeCount('SmartPhone') + local.lookupResult.getResult().DeviceCapUsed) gt local.lookupResult.getResult().DeviceCap>
							<cflocation url="/index.cfm/go/checkout/do/error/?code=324&cap=#local.lookupResult.getResult().DeviceCap#&used=#local.lookupResult.getResult().DeviceCapUsed#&sm=#session.cart.getDeviceTypeCount('SmartPhone')#" addtoken="false" />
						</cfif>
					</cfif>

					<!--- Check for Verizon device family upgrade restrictions --->
					<cfif application.model.CheckoutHelper.getCarrier() eq  42 && application.model.checkoutHelper.getCheckoutType() eq 'upgrade'>
						
						<cfset cartLines = session.cart.getLines() />
						<cfset deviceType = cartLines[1].getPhone().getDeviceServiceType() />
						<cfset deviceFamily = local.lookupResult.getResult().DeviceFamily  />
						<cfset currentMdn = local.lookupArgs.Mdn />
						
						<cfif !application.model.CheckoutHelper.IsDeviceFamilyCompatible( deviceType, deviceFamily )>
							<cflocation url="/index.cfm/go/checkout/do/error/code/327/mdn/#currentMdn#/CurrentDeviceFamily/#deviceFamily#" addtoken="false" />
						</cfif>
					</cfif>
				</cfif>

				<cfset application.model.checkoutHelper.markStepCompleted('wirelessAccount') />
				<cfset application.model.checkoutHelper.setCustomerLookupResult(variables.accountLookups) />
				<cfset application.model.checkoutHelper.setCustomerAccountNumber(local.lookupResult.getResult().customerAccountNumber) />
				<cfset application.model.checkoutHelper.setLinesApproved(local.lookupResult.getResult().user.getLinesApproved()) />
				<cfset application.model.checkoutHelper.setDepositAmount(0) />
				<cfset application.model.checkoutHelper.setAccountPin(local.lookupArgs.pin) />
				<cfif StructKeyExists( request.p, 'billingZip' )>
					<cfset application.model.checkoutHelper.setAccountZipCode(trim(request.p['billingZip'])) />
				</cfif>

				<cfif application.model.CheckoutHelper.getCarrier() eq 299>
					<cfif StructKeyExists( request.p, 'SecurityQuestionAnswer' )>
						<cfset application.model.checkoutHelper.setSecurityQuestionAnswer(trim(request.p['SecurityQuestionAnswer'])) />
					</cfif>
					<cfif StructKeyExists( request.p, 'LastFourSsn' )>
						<cfset application.model.checkoutHelper.setLastFourSsn(trim(request.p['LastFourSsn'])) />
					</cfif>
				</cfif>

				<!--- Handle AT&T Account Password --->
				<cfif application.model.CheckoutHelper.getCarrier() eq 109 && Len(Trim(local.lookupResult.getResult().customerAccountPassword))>
					<cfset session.InvalidAccountPasswordAttempts = 0 />
					<cfset application.model.checkoutHelper.setCustomerAccountPassword(local.lookupResult.getResult().customerAccountPassword) />
					<cfset application.model.checkoutHelper.setIsUpgradeEligible( local.lookupResult.getResult().canUpgradeEquipment ) />

					<cflocation url="/index.cfm/go/checkout/do/carrierAccountPassword/" addtoken="false" />
				<cfelse>
					<cflocation url="/index.cfm/go/checkout/do/extensionAuthProcess/" addtoken="false" />
				</cfif>

			<cfelseif local.lookupResult.getResultCode() is 'CL002'>
				<!--- Customer Not Found --->
				<cfif application.model.checkoutHelper.getCarrier() eq 299>

					<cfif local.lookupResult.getErrorCode() eq '404'>
						<!--- Account locked --->
						<cflocation url="/index.cfm/go/checkout/do/error/?code=326" addtoken="false" />

					<cfelseif local.lookupResult.getErrorCode() eq '406'>
						<!--- Account look up credentials invalid --->

						<cfif request.p.AuthorizationType eq 'pin'>

							<cfset errMessage = local.lookupResult.getErrorMessage() />
							<cfset session.checkout.LookupByPinAttempts++ />

							<!--- Parse question from message error --->
							<cfset aQuestions = REMatch('\[([^]]+)\]', errMessage ) />

							<!--- Show security question if it is set up on account --->
							<cfif ArrayLen(aQuestions)>
								<cfset request.p.securityQuestion = aQuestions[1] />
								<cfset request.p.authorizationDisplay = 'SecurityQuestion' />
							<!--- If no security question is on account then show Pin for a second time--->
							<cfelseif session.checkout.LookupByPinAttempts LT 2>
								<cfset request.p.authorizationDisplay = 'pin' />
							<!--- If Pin attempt fails twice then show Last Four of SSN --->
							<cfelse>
								<cfset request.p.authorizationDisplay = 'LastFourSsn' />
							</cfif>

							<cfinclude template="/views/checkout/dsp_wirelessAccountForm.cfm" />
						<cfelseif request.p.AuthorizationType eq 'SecurityQuestion'>
							<cfset request.p.authorizationDisplay = 'LastFourSsn' /> <!--- Override form field value --->


							<cfinclude template="/views/checkout/dsp_wirelessAccountForm.cfm" />
						<cfelseif request.p.AuthorizationType eq 'LastFourSsn'>
							<!--- If last 4 of SSN fails then send to error message page --->
							<cflocation url="/index.cfm/go/checkout/do/error/?code=401" addtoken="false" />
						<cfelse>
							<cflocation url="/index.cfm/go/checkout/do/error/?code=401" addtoken="false" />
						</cfif>

					<cfelse>
						<!--- TODO: Find customer not found --->
						<cflocation url="/index.cfm/go/checkout/do/error/?code=401" addtoken="false" />
					</cfif>
				<cfelse>
					<cflocation url="/index.cfm/go/checkout/do/error/?code=401" addtoken="false" />
				</cfif>

			<cfelseif local.lookupResult.getResultCode() is 'CL003'>
				<cflocation url="/index.cfm/go/checkout/do/error/?code=402" addtoken="false" />
			<cfelseif local.lookupResult.getResultCode() is 'CL004'>
				<!--- Customer account is delinquent --->
				<cflocation url="/index.cfm/go/checkout/do/error/?code=320" addtoken="false" />
			<cfelse>
				<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
			</cfif>
		<cfelse>
			<cfinclude template="/views/checkout/dsp_wirelessAccountForm.cfm" />
		</cfif>

        <cfcatch>
			<cfset local.errorUtil = createObject('component', 'cfc.model.Error').init() />
			<cfset local.errorUtil.sendErrorEmail( cfcatch ) />
        	<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
        </cfcatch>

        </cftry>
	</cfcase>


	<cfcase value="processWirelessMultiLineAccountForm">

		<cfset local = structNew() />
		<cfset local.isByPassOn = false />
		<cfset application.model.checkoutHelper.setWirelessAccountForm(request.p) />

		<cfif session.currentUser.getUserID() is not '' and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())>
			<cfset local.isByPassOn = true />
		</cfif>

		<cfset request.validator.clear() />

		<cfloop from="1" to="#arrayLen(session.cart.getLines())#" index="idx">
			<cfif trim(request.p['areacode' & idx]) is '' and trim(request.p['lnp' & idx]) is '' and trim(request.p['lastfour' & idx]) is ''>
				<cfset request.validator.addMessage('mdn', 'Wireless number is required.') />
			<cfelseif trim(request.p['areacode' & idx]) is '' or trim(request.p['lnp' & idx]) is '' or trim(request.p['lastfour' & idx]) eq "" >
	            <!--- partial number supplied --->
	            <cfset request.validator.AddMessage("mdn","Incomplete phone number entered.")>
	        <cfelse>
	            <!--- phone validation --->
	            <cfset request.validator.AddPhoneValidator("mdn",request.p["areacode" & idx]  & request.p["lnp" & idx] & request.p["lastfour" & idx], "Wireless number is invalid. ")>
	        </cfif>
		</cfloop>

		<!--- Check to see if duplicate MDNs were entered --->
		<cfif ArrayLen( session.cart.getLines() ) GTE 2>
			<cfset isDuplicateMDN = false />

			<cfloop from="1" to="#ArrayLen( session.cart.getLines() ) - 1#" index="i">
				<cfset baseMdn = trim(request.p["areacode" & i]) & trim(request.p["lnp" & i]) & trim(request.p["lastfour" & i]) />

				<cfloop from="#i+1#" to="#ArrayLen( session.cart.getLines() )#" index="j">
					<cfset compareMdn = trim(request.p["areacode" & j]) & trim(request.p["lnp" & j]) & trim(request.p["lastfour" & j]) />
					<cfif baseMdn eq compareMdn>
						<cfset isDuplicateMDN = true />
					</cfif>
				</cfloop>
			</cfloop>

			<cfif isDuplicateMDN>
				<cfset request.validator.AddMessage("mdn", "Duplicate phone number entered.")>
			</cfif>
		</cfif>

		<cfif request.p.AuthorizationType eq 'pin'>
			<cfset request.validator.AddRequiredFieldValidator("pin",request.p.pin, "Please enter a valid pin number for account access.")>

			<cfif application.model.CheckoutHelper.getCarrier() EQ 299>
				<cfset request.validator.addMaxRangeValidator('pin', trim(request.p['pin']), 'Pin must be between 6 and ten digits.', 10) />
			<cfelse>
				<cfset request.validator.addMaxRangeValidator('pin', trim(request.p['pin']), 'SSN must be 4 digits in length.', 4) />
			</cfif>
		</cfif>

		<cfif ListFind( "42,109", application.model.CheckoutHelper.getCarrier() )>
			<cfset request.validator.AddRequiredFieldValidator("billingZip", request.p.billingZip, "Please enter the account's billing zip code.") />
			<cfset request.validator.AddZipCodeValidator("billingZip", request.p.billingZip, "Enter a valid Zip Code.") />
		</cfif>

		<cfif not request.validator.HasMessages()>

			<cfif ListFind( '42,109', application.model.CheckoutHelper.getCarrier() )>
				<cfset local.zipCode = request.p.billingZip />
			<cfelse>
				<cfset local.zipCode = session.cart.getZipCode() />
			</cfif>

			<cfset accountLookups = [] />
			<cfset lookupResultCodes = [] />
			<cfset errorResultCodes = [] />

			<cfloop from="1" to="#ArrayLen( session.cart.getLines() )#" index="i">
				<cfset accountLookup = {} />

				<cfset accountLookup.lookupArgs = {
					carrier = application.model.CheckoutHelper.getCarrier()
					, mdn = trim(request.p["areacode" & i]) & trim(request.p["lnp" & i]) & trim(request.p["lastfour" & i])
					, pin = ''
					, referenceNumber = application.model.CheckoutHelper.getReferenceNumber()
					, resultCode = request.p.resultCode
					, zipCode = local.zipCode
					, ServiceZipCode = session.cart.getZipCode()
				} />

				<cfif structKeyExists(request.p, 'pin')>
					<cfset accountLookup.lookupArgs.pin = request.p.pin />
				</cfif>

				<cfif structKeyExists(request.p, 'SecurityQuestionAnswer')>
					<cfset accountLookup.lookupArgs.SecurityQuestionAnswer = request.p.SecurityQuestionAnswer />
				</cfif>

				<cfif structKeyExists(request.p, 'LastFourSsn')>
					<cfset accountLookup.lookupArgs.LastFourSsn = request.p.LastFourSsn />
				</cfif>

				<cfif listFind('42', application.model.checkoutHelper.getCarrier())>
					<cfset accountLookup.lookupArgs.accountPassword = trim(request.p.accountPassword) />
				</cfif>



				<cfif application.model.checkoutHelper.getCarrier() eq 109 || application.model.checkoutHelper.getCarrier() eq 299>
					<cfset accountLookup.lookupArgs.ActivationType = session.cart.getActivationType() />
				</cfif>

				<!--- see if the wireless account was verified --->
	            <cfset accountLookup.lookupResult = application.model.CustomerLookup.lookup( argumentCollection = accountLookup.lookupArgs ) /> <!--- TODO, fill in with form values --->

				<cfset ArrayAppend( accountLookups, accountLookup ) />
				<cfset ArrayAppend( lookupResultCodes, accountLookup.lookupResult.getResultCode() ) />

				<cfif accountLookup.lookupResult.getErrorCode() neq ''>
					<cfset ArrayAppend( errorResultCodes, accountLookup.lookupResult.getErrorCode() ) />
					<cfset errorMessage = accountLookup.lookupResult.getErrorMessage() />
				</cfif>
			</cfloop>

			<cfset resultCodeList = ArrayToList( lookupResultCodes ) />
			<cfset errorCodeList = ArrayToList( errorResultCodes ) />

			<cfif ListValueCount( resultCodeList, 'CL001' ) eq ArrayLen( accountLookups )>

				<cfif NOT local.isByPassOn>
					<!--- handle the customer not having a family plan --->
					<cfloop from="1" to="#ArrayLen( accountLookups )#" index="i">
						<cfif accountLookups[i].lookupResult.getResult().WirelessAccountType neq "Family" and session.cart.getAddALineType() eq "Family">
					    	<!--- incompatable plan with the family type line --->
					        <cflocation url="/index.cfm/go/checkout/do/error/?code=322" addtoken="false"/>
					    </cfif>
					</cfloop>
				</cfif>

				<cfif NOT local.isByPassOn>
					<!--- handle error code for non verizon --->
				    <cfif application.model.CheckoutHelper.getCarrier() neq 42> <!--- all but Verizon are validated here --->
				        <cfswitch expression="#application.model.checkoutHelper.getCheckoutType()#">
				            <cfcase value="add">
								<cfloop from="1" to="#ArrayLen( accountLookups )#" index="i">
									<cfif accountLookups[i].lookupResult.getResult().user.getLinesApproved() lt application.model.checkoutHelper.getNumberOfLines()>
				                    	<!--- dump them into lines approved message --->
				               			<cflocation url="/index.cfm/go/checkout/do/error/?code=320" addtoken="false"/>
								    </cfif>
								</cfloop>
				            </cfcase>
				        </cfswitch>
				    </cfif>
				</cfif>

				<cfif NOT local.isByPassOn>
					<!--- handle upgrade eligibility for all carriers. --->
					<cfswitch expression="#application.model.checkoutHelper.getCheckoutType()#">
						<cfcase value="upgrade">
							<cfloop from="1" to="#ArrayLen( accountLookups )#" index="i">
								<cfif accountLookups[i].lookupResult.getResult().CanUpgradeEquipment eq false || accountLookups[i].lookupResult.getResult().CanUpgradeEquipment eq 'NO'>

									<!--- Handle AT&T Account Password --->
									<cfif application.model.CheckoutHelper.getCarrier() eq 109 && Len(Trim(accountLookups[1].lookupResult.getResult().customerAccountPassword))>
										<cfset session.InvalidAccountPasswordAttempts = 0 />
										<cfset application.model.checkoutHelper.setCustomerAccountPassword( accountLookups[1].lookupResult.getResult().customerAccountPassword ) />
										<cfset application.model.checkoutHelper.setIsUpgradeEligible( accountLookups[i].lookupResult.getResult().canUpgradeEquipment ) />

										<cflocation url="/index.cfm/go/checkout/do/carrierAccountPassword/" addtoken="false" />
									<cfelse>
										<!--- dump them to not eligible for upgrade message --->
									    <cflocation url="/index.cfm/go/checkout/do/error/?code=321" addtoken="false"/>
									</cfif>

								</cfif>
							</cfloop>
						</cfcase>
					</cfswitch>
					
					<!--- Check for Verizon device family upgrade restrictions --->
					<cfif application.model.CheckoutHelper.getCarrier() eq  42 && application.model.checkoutHelper.getCheckoutType() eq 'upgrade'>
						<cfset cartLines = session.cart.getLines() />
						
						<cfloop from="1" to="#ArrayLen( accountLookups )#" index="i">
							<cfset deviceType = cartLines[i].getPhone().getDeviceServiceType() />
							<cfset deviceFamily = accountLookups[i].lookupResult.getResult().DeviceFamily  />
							<cfset currentMdn = accountLookups[i].lookupArgs.Mdn />
							
							<cfif !application.model.CheckoutHelper.IsDeviceFamilyCompatible( deviceType, deviceFamily )>
								<cflocation url="/index.cfm/go/checkout/do/error/code/327/mdn/#currentMdn#/CurrentDeviceFamily/#deviceFamily#" addtoken="false" />
							</cfif>
						</cfloop>
					</cfif>
				</cfif>

				<!--- mark step completed --->
				<cfset application.model.CheckoutHelper.markStepCompleted( 'wirelessAccount' ) />

				<!--- store the account number --->
				<cfset application.model.CheckoutHelper.setCustomerLookupResult( accountLookups ) />
				<cfset application.model.CheckoutHelper.setCustomerAccountNumber( accountLookups[1].lookupResult.getResult().CustomerAccountNumber ) />
				<cfset application.model.CheckoutHelper.setLinesApproved( accountLookups[1].lookupResult.getResult().user.getLinesApproved() ) />
				<cfset application.model.CheckoutHelper.setDepositAmount( 0 ) /> <!--- TODO: Is this the right amount, are there deposits on add a line. --->

				<cfif StructKeyExists( request.p, 'pin' )>
					<cfset application.model.CheckoutHelper.setAccountPin( request.p["pin"] ) />
				</cfif>

				<cfif StructKeyExists( request.p, 'billingZip' )>
					<cfset application.model.checkoutHelper.setAccountZipCode(trim(request.p['billingZip'])) />
				</cfif>
				
				<cfif application.model.CheckoutHelper.getCarrier() eq 299>
					<cfif StructKeyExists( request.p, 'SecurityQuestionAnswer' )>
						<cfset application.model.checkoutHelper.setSecurityQuestionAnswer(trim(request.p['SecurityQuestionAnswer'])) />
					</cfif>
					<cfif StructKeyExists( request.p, 'LastFourSsn' )>
						<cfset application.model.checkoutHelper.setLastFourSsn(trim(request.p['LastFourSsn'])) />
					</cfif>
				</cfif>				

				<!--- Handle AT&T Account Password --->
				<cfif application.model.CheckoutHelper.getCarrier() eq 109 && Len(Trim(accountLookups[1].lookupResult.getResult().customerAccountPassword))>
					<cfset session.InvalidAccountPasswordAttempts = 0 />
					<cfset application.model.checkoutHelper.setCustomerAccountPassword(accountLookups[1].lookupResult.getResult().customerAccountPassword) />
					<cflocation url="/index.cfm/go/checkout/do/carrierAccountPassword/" addtoken="false" />
				<cfelse>
					<cflocation url="/index.cfm/go/checkout/do/extensionAuthProcess/" addtoken="false" />
				</cfif>


			<cfelseif ListFindNoCase( resultCodeList, 'CL002' )>


				<!--- Customer Not Found --->
				<cfif application.model.checkoutHelper.getCarrier() eq 299>

					<cfif ListFindNoCase( errorCodeList, '404' )>
						<!--- Account locked --->
						<cflocation url="/index.cfm/go/checkout/do/error/?code=326" addtoken="false" />

					<cfelseif ListFindNoCase( errorCodeList, '406' )>
						<!--- Account look up credentials invalid --->

						<cfif request.p.AuthorizationType eq 'pin'>

							<cfset session.checkout.LookupByPinAttempts++ />

							<!--- Parse question from message error --->
							<cfset aQuestions = REMatch('\[([^]]+)\]', errorMessage ) />

							<!--- Show security question if it is set up on account --->
							<cfif ArrayLen(aQuestions)>
								<cfset request.p.securityQuestion = aQuestions[1] />
								<cfset request.p.authorizationDisplay = 'SecurityQuestion' />
							<!--- If no security question is on account then show Pin for a second time--->
							<cfelseif session.checkout.LookupByPinAttempts LT 2>
								<cfset request.p.authorizationDisplay = 'pin' />
							<!--- If Pin attempt fails twice then show Last Four of SSN --->
							<cfelse>
								<cfset request.p.authorizationDisplay = 'LastFourSsn' />
							</cfif>

						<cfelseif request.p.AuthorizationType eq 'SecurityQuestion'>
							<cfset request.p.authorizationDisplay = 'LastFourSsn' /> <!--- Override form field value --->

						<cfelseif request.p.AuthorizationType eq 'LastFourSsn'>
							<!--- If last 4 of SSN fails then send to error message page --->
							<cflocation url="/index.cfm/go/checkout/do/error/?code=401" addtoken="false" />
						<cfelse>
							<cflocation url="/index.cfm/go/checkout/do/error/?code=401" addtoken="false" />
						</cfif>

					<cfelse>
						<div class="form-errorsummary">
							<span>We were unable to locate your account based on the information entered. Please check the mobile number<cfif 1>s</cfif> and account information entered and try again.</span>
							<ol>
								<cfloop from="1" to="#ArrayLen( accountLookups )#" index="i">
									<cfif accountLookups[i].lookupResult.getResultCode() eq 'CL002'>
										<cfset mdn = accountLookups[i].lookupArgs.mdn />
										<li><cfoutput>(#Left( mdn, 3 )#) #Mid( mdn, 4, 3 )#-#Right( mdn, 4 )#</cfoutput><li>
									</cfif>
								</cfloop>
							</ol>
						</div>
					</cfif>
				</cfif>

			<cfelseif ListFindNoCase( resultCodeList, 'CL003' )>
				<cflocation url="/index.cfm/go/checkout/do/error/?code=402" addtoken="false"/>
			<cfelse>
				<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
			</cfif>

			<cfinclude template="/views/checkout/dsp_wirelessMultiLineAccountForm.cfm" />
		<cfelse>
			<cfinclude template="/views/checkout/dsp_wirelessMultiLineAccountForm.cfm" />
		</cfif>
	</cfcase>


    <cfcase value="carrierAccountPassword">
		<cfparam name="session.InvalidAccountPasswordAttempts" default="0" type="numeric" />
    	<cfinclude template="/views/checkout/dsp_CarrierAccountPassword.cfm" />
    </cfcase>


    <cfcase value="processCarrierAccountPassword">
		<cfif request.p.accountPassword eq application.model.checkoutHelper.getCustomerAccountPassword()>
			<cfif application.model.checkouthelper.isUpgrade()>
				<cfif application.model.checkoutHelper.getIsUpgradeEligible()>
					<cflocation url="/index.cfm/go/checkout/do/extensionAuthProcess/" addtoken="no" />
				<cfelse>
					<cflocation url="/index.cfm/go/checkout/do/error/?code=321" addtoken="false" />
				</cfif>
			<cfelseif application.model.checkoutHelper.isAddALine()>
				<cfif application.model.checkoutHelper.getLinesApproved() lt application.model.checkoutHelper.getNumberOfLines()>
					<cflocation url="/index.cfm/go/checkout/do/error/?code=320" addtoken="false" />
				<cfelse>
					<cflocation url="/index.cfm/go/checkout/do/extensionAuthProcess/" addtoken="no" />
				</cfif>
			<cfelse>
				<cflocation url="/index.cfm/go/checkout/do/extensionAuthProcess/" addtoken="no" />
			</cfif>
		<cfelse>
			<cfset session.InvalidAccountPasswordAttempts++ />
		</cfif>

		<cfif session.InvalidAccountPasswordAttempts gte 3>
			<cflocation url="/index.cfm/go/checkout/do/error/?code=323" addtoken="false"/>
		<cfelse>
			<cfset request.validator.addMessage('accountPassword', 'Account password provided is not valid.') />
			<cfinclude template="/views/checkout/dsp_CarrierAccountPassword.cfm" />
		</cfif>

    </cfcase>


	<cfcase value="extensionAuthProcess">
		<!--- The extensionAuth event was removed Q1 2014. This event merely saves copy/pasting the logic below --->
		<cfif application.model.checkoutHelper.getCheckoutType() is 'new' or application.model.checkoutHelper.getCheckoutType() is 'add'>
			<cflocation url="/index.cfm/go/checkout/do/lnpRequest/" addtoken="false" />
		<cfelse>
			<cflocation url="/index.cfm/go/checkout/do/billShip/" addtoken="false" />
		</cfif>
	</cfcase>


	<cfcase value="lnpRequest">
		<cfset application.model.checkoutHelper.setCurrentStep('lnp') />
		<cfset request.p.npaResponse = application.model.npaLookup.lookup(session.cart.getZipcode(), application.model.checkoutHelper.getCarrier(), application.model.checkoutHelper.getReferenceNumber(), application.model.checkoutHelper.getCarrierConversationId()) />
		<cfset request.p.npaList = request.p.npaResponse.NpaList />
		
		<!--- Save conversation ID for AT&T --->
		<cfif application.model.checkoutHelper.getCarrier() eq 109 && StructKeyExists(request.p.npaResponse, "CarrierConversationId")>					
			<cfset application.model.checkoutHelper.setCarrierConversationId( request.p.npaResponse.CarrierConversationId ) />
		</cfif>
		
		<cfinclude template="/views/checkout/dsp_lnpRequest.cfm" />
	</cfcase>


	<cfcase value="processLnpRequest">
		<cfset local = structNew() />
		<cfset local.mdnList = arrayNew(1) />

		<cfset application.model.checkoutHelper.setMdnForm(request.p) />
		<cfset request.validator.clear() />

		<cfloop from="1" to="#application.model.checkoutHelper.getNumberOfLines()#" index="i">
			<cftry>
				<cfset local.dd = request.p['selection' & i] />

				<cfif request.p['selection' & i] is 'port'>

					<cfif trim(request.p['areacode' & i]) is '' and trim(request.p['lnp' & i]) and '' and trim(request.p['lastfour' & i]) is ''>
						<cfset request.validator.addMessage('errorLnpPhone_#i#', 'Wireless number for line #i# is required.') />
					<cfelseif trim(request.p['areacode' & i]) is '' or trim(request.p['lnp' & i]) is '' or trim(request.p['lastfour' & i]) is ''>
						<cfset request.validator.addMessage('errorLnpPhone_#i#', 'Please enter the existing phone number your would like to port for line #i#.') />
					<cfelse>
						<cfset request.validator.addPhoneValidator('errorLnpPhone_#i#', request.p['areacode' & i] & request.p['lnp' & i] & request.p['lastfour' & i], 'Wireless number for line #i# is invalid.') />
					</cfif>

					<cfif trim(request.p['portInCurrentCarrier' & i]) is ''>
						<cfset request.validator.addMessage('errorCurrentCarrier_#i#', 'Please select your existing carrier for line #i#.') />
					</cfif>

					<cfif trim(request.p['portInCurrentCarrierPin#i#']) is ''>
						<cfset request.validator.addMessage('errorCurrentCarrierPin_#i#', 'Please enter your existing carrier pin for line #i#.') />
					</cfif>

					<cfif not len(trim(request.p['portInCurrentCarrierAccountNumber' & i]))>
						<cfset request.validator.addMessage('errorCurrentCarrierAccountNumber_#i#', 'Please enter the current account number for line #i#.') />
					</cfif>
				<cfelse>
					<cfif trim(request.p['newAreaCode' & i]) is ''>
						<cfset request.validator.addMessage('errorAreaCode_#i#', 'Please select the area code you would like for your new phone number on line #i#.') />
					</cfif>
				</cfif>

				<cfcatch type="any">
					<cfif structKeyExists(request.p, 'selection' & i) and request.p['selection' & i] is 'port'>
						<cfset request.validator.addMessage('GeneralLine#i#', 'Phone number for line #i# is required.') />
						<cfset request.validator.addMessage('errorLnpPhone_#i#', 'Required', false) />
					<cfelseif structKeyExists(request.p, 'selection' & i) and request.p['selection' & i] is 'newline'>
						<cfset request.validator.addMessage('GeneralLine#i#', 'Area code for line #i# is required.') />
						<cfset request.validator.addMessage('errorAreaCode_#i#', 'Required', false) />
					<cfelse>
						<cfset request.validator.addMessage('GeneralLine#i#', 'Please enter the wireless number for line #i# or select the new number wireless number option.') />
					</cfif>
				</cfcatch>
			</cftry>
		</cfloop>

		<cfif not request.validator.hasMessages()>
			<cfloop from="1" to="#application.model.checkoutHelper.getNumberOfLines()#" index="i">
				<cfset local.mdnList[i] = structNew() />

				<cfif request.p['selection' & i] is 'port'>
					<cfset local.mdnList[i].zip = session.cart.getZipcode() />
					<cfset local.mdnList[i].mdn = request.p['areacode' & i] & request.p['lnp' & i] & request.p['lastfour' & i] />
					<cfset local.mdnList[i].areaCode = '' />
					<cfset local.mdnList[i].portInCurrentCarrier = request.p['portInCurrentCarrier' & i] />
					<cfset local.mdnList[i].portInCurrentCarrierPin = request.p['portInCurrentCarrierPin#i#'] />
				<cfelse>
					<cfset local.mdnList[i].zip = session.cart.getZipcode() />
					<cfset local.mdnList[i].mdn = '' />
					<cfset local.mdnList[i].areaCode = request.p['newAreaCode#i#'] />
				</cfif>
			</cfloop>

			<cfset application.model.checkoutHelper.setMdnList(local.mdnList) />
			<cfset application.model.checkoutHelper.setMdnResult(application.model.portInValidation.validate(application.model.checkoutHelper.getCarrier(), local.mdnList, application.model.checkoutHelper.getReferenceNumber(), request.p.resultCode, session.cart.getZipCode(), application.model.checkoutHelper.getCarrierConversationId() )) />

			<cfif application.model.checkoutHelper.getMdnResult().getResultCode() eq 'PI002'>
				<cfloop from="1" to="#arrayLen(application.model.checkoutHelper.getMdnResult().getResult().mdnList)#" index="i">
					<cfif not application.model.checkoutHelper.getMdnResult().getResult().mdnList[i].isPortable>
						<cfset request.validator.addMessage('errorInvalidPortIn_#i#', 'We are having difficulty porting the number for line #i# as you requested. Please verify you entered the number correctly or please contact customer service for assistance.') />
					</cfif>
				</cfloop>
			<cfelseif application.model.checkoutHelper.getMdnResult().getResultCode() is not 'PI001'>

				<cfif application.model.checkoutHelper.getMdnResult().getErrorMessage() is not ''>
					<cfset request.p.errorMessage = application.model.checkoutHelper.getMdnResult().getErrorMessage() />
					<cfset request.p.errorMessage = replace(request.p.errorMessage, 'MDN', 'Wireless Number') />

					<cfif trim(request.p.errorMessage) is 'Requested Port In number is currently in VZW inventory and cannot be ported in'>
						<cfset request.p.errorMessage = 'Verizon indicates that you are a current customer. Please clear your cart and select upgrade or add-a-line when adding handsets to your cart.' />
					<cfelseif trim(request.p.errorMessage) is 'This Wireless Number is eligible to Port In to Verizon Wireless but not to the service zip requested'>
						<cfset request.p.errorMessage = 'Your service area zip code does not match the area code of the phone number you are trying to move to Verizon. Please clear your cart and change your service area zip code to match your existing billing zip code.' />
					</cfif>

					<cfset request.validator.addMessage('generalPortInError', request.p.errorMessage) />
				<cfelse>
					<cfset request.validator.addMessage('generalPortInError', 'We are having difficulty porting the number you requested. Please verify you entered the number correctly or please contact customer service at <strong>#channelConfig.getCustomerCarePhone()#</strong> for assistance.') />
				</cfif>
			<cfelseif application.model.checkoutHelper.getMdnResult().getResultCode() eq 'PI001'>
				<!--- Save conversation ID for AT&T --->
				<cfif application.model.checkoutHelper.getCarrier() eq 109 && StructKeyExists(application.model.checkoutHelper.getMdnResult().getResult(), "CarrierConversationId")>					
					<cfset application.model.checkoutHelper.setCarrierConversationId( application.model.checkoutHelper.getMdnResult().getResult().CarrierConversationId ) />
				</cfif>
			</cfif>
		</cfif>

		<cfif not request.validator.hasMessages()>
			<cfset application.model.checkoutHelper.markStepCompleted('lnp') />
			<cflocation url="/index.cfm/go/checkout/do/billShip/" addtoken="false" />
		<cfelseif request.validator.hasMessages()>
			<cfinclude template="/views/checkout/dsp_lnpRequest.cfm" />
		<cfelse>
			<cfset application.model.checkoutHelper.markStepCompleted('lnp') />
			<cflocation url="/index.cfm/go/checkout/do/billShip/" addtoken="false" />
		</cfif>
	</cfcase>

	<cfcase value="requestAreaCode">
		<cfset application.model.checkoutHelper.setCurrentStep('areaCode') />

		<cfinclude template="/views/checkout/dsp_areaCodeRequest.cfm" />
	</cfcase>

	<cfcase value="processRequestAreaCode">
		<cfset local = {} />
		<cfset local.mdnList = [] />

		<cfset application.model.checkoutHelper.setMdnForm(request.p) />
		<cfset request.validator.clear() />

		<cfloop from="1" to="#application.model.checkoutHelper.getNumberOfLines()#" index="i">

			<cfif request.p['newAreaCode#i#'] EQ ''>
				<cfset request.validator.addMessage( 'requiredAreaCodeError', 'Area code is required' ) />
			</cfif>

			<cfset local.mdnList[i] = structNew() />
			<cfset local.mdnList[i].zip = session.cart.getZipcode() />
			<cfset local.mdnList[i].mdn = '' />
			<cfset local.mdnList[i].areaCode = request.p['newAreaCode#i#'] />
		</cfloop>

		<cfset application.model.checkoutHelper.setMdnList(local.mdnList) />

		<cfif request.validator.hasMessages()>
			<cfinclude template="/views/checkout/dsp_areaCodeRequest.cfm" />
		<cfelse>
			<cfset application.model.checkoutHelper.markStepCompleted('areaCode') />
			<cflocation url="/index.cfm/go/checkout/do/billShip/bSoftReservationSuccess/1/" addtoken="false" />
		</cfif>
	</cfcase>

	<cfcase value="billShip">
		<cfset application.model.checkoutHelper.setCurrentStep('billShip') />

		<cfif len(trim(session.currentUser.getUserID())) and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())>
			<cfinclude template="/views/checkout/dsp_orderAssistantMessageBox.cfm" />
		</cfif>

		<cfinclude template="/views/checkout/dsp_billShip.cfm" />
	</cfcase>

	<cfcase value="processBillShip">

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
					<cfif structKeyExists(request, 'p') and not structKeyExists(request.p, 'emailAddress')>
						<cflocation url="/index.cfm/go/cart/do/view/" addtoken="false" />
					<cfelse>
						<cfset request.validator.addMessage('password', 'Incorrect password.') />
					</cfif>
				</cfif>
			</cfif>

			<cfparam name="request.p.sameAsBilling" default="0">

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
				<cfset request.p.shipEvePhone = trim(request.p.billEvePhone) />
				<cfset request.p.shipMilitaryBase = trim(request.p.selMilitaryBase) />
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
			<cfset request.checkout.billingAddress.setEvePhone(trim(request.p.billEvePhone)) />
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
			<cfset request.checkout.shippingAddress.setEvePhone(trim(request.p.shipEvePhone)) />
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

			<cfset request.validator.addRequiredFieldValidator('billDayPhone', trim(request.p.billDayPhone), 'Please enter the day time phone of the person this order is being billed to.') />
			<cfset request.validator.addPhoneValidator('billDayPhone', trim(request.p.billDayPhone), 'Please use the following format 206-555-1212.') />

			<cfset request.validator.addRequiredFieldValidator('billEvePhone', trim(request.p.billEvePhone), 'Please enter the evening phone of the person this order is being billed to.') />
			<cfset request.validator.addPhoneValidator('billEvePhone', trim(request.p.billEvePhone), 'Please use the following format 206-555-1212.') />

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

				<cfset request.validator.addRequiredFieldValidator('shipDayPhone', trim(request.p.shipDayPhone), 'Please enter the day time phone of the person this order is being shipped to.') />
				<cfset request.validator.addPhoneValidator('shipDayPhone', trim(request.p.shipDayPhone), 'Please use the following format 206-555-1212.') />

				<cfset request.validator.addRequiredFieldValidator('shipEvePhone', trim(request.p.shipEvePhone), 'Please enter the evening phone of the person this order is being shipped to.') />
				<cfset request.validator.addPhoneValidator('shipEvePhone', trim(request.p.shipEvePhone), 'Please use the following format 206-555-1212.') />

				<cfif request.config.allowAPOFPO AND listFindNoCase("APO,FPO",request.p.shipCity)>
					<cfif !StructKeyExists(request.p,"checkApoDislaimer")>
						<cfset request.validator.addMessage('checkApoDislaimer', 'Please acknowledge return restrictions for APO/FPO addresses') />
					</cfif>
				</cfif>
			</cfif>

			<cfif not local.isByPassOn>
				<!--- Handle PO validation on billing address only for T-Mobile. --->
				<cfset local.poBoxRegEx = "[PO.]*\s?B(ox)?.*\d+">

				<cfif application.model.checkoutHelper.isWirelessOrder() and application.model.checkoutHelper.getCarrier() eq 128>
					<cfif REFindNoCase(local.poBoxRegEx,request.p.billAddress1)>
						<cfset request.validator.addMessage('generalPortInError', 'In order to process your order please provide a billing address that is not a P.O. Box address.') />
					</cfif>
					<cfif REFindNoCase(local.poBoxRegEx,request.p.billAddress2)>
						<cfset request.validator.addMessage('generalPortInError', 'In order to process your order please provide a billing address that is not a P.O. Box address.') />
					</cfif>
				</cfif>

				<!--- Handle PO validation on shipping address. --->
				<cfif !(request.config.allowAPOFPO AND listFindNoCase("APO,FPO",request.p.shipCity))>
					<cfif REFindNoCase(local.poBoxRegEx,request.p.shipAddress1)>
						<cfset request.validator.addMessage('generalPortInError', 'In order to process your order please provide a shipping address that is not a P.O. Box address.') />
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
				<cfset application.model.checkoutHelper.getBillingAddress().setEvePhone(trim(request.p.billEvePhone)) />
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
				<cfset application.model.checkoutHelper.getShippingAddress().setEvePhone(trim(request.p.shipEvePhone)) />
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

				<cfinclude template="/views/checkout/dsp_billShip.cfm" />
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
					<cfset request.p.user.getBillingAddress().setEvePhone(trim(request.p.billEvePhone)) />
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
	            	<cfset request.p.user.getShippingAddress().setEvePhone(trim(request.p.shipEvePhone)) />
					<cfset request.p.user.getShippingAddress().setMilitaryBase(trim(request.p.selMilitaryBase)) />

	            	<cfset request.p.userDataUpdated = true />
	            </cfif>

	            <cfif request.p.userDataUpdated>
	            	<cfset request.p.user.save() />
	            </cfif>

	            <cfset application.model.checkoutHelper.markStepCompleted('billShip') />

	            <cfif application.model.checkoutHelper.isWirelessOrder()>
	            	<!--- If this is a new line, credit check. --->
	            	<cflocation url="/index.cfm/go/checkout/do/creditCheck/" addtoken="false" />
	            <cfelse>
	            	<!--- Otherwise, time to go to the order confirmation. --->
	            	<cflocation url="/index.cfm/go/checkout/do/orderConfirmation/" addtoken="false" />
	            </cfif>
			</cfif>

	</cfcase>

	<cfcase value="creditCheck">

    	<!--- if checkoutType is not new and not verizon, then skip credit check --->
        <cfif (application.model.checkouthelper.getCheckoutType() eq "upgrade") or (application.model.checkouthelper.getCheckoutType() neq "new" and application.model.checkoutHelper.getCarrier() neq "42") >
        	<!--- go to order confirmation step --->
            <cflocation url="/index.cfm/go/checkout/do/orderConfirmation/" addtoken="false"/>
        </cfif>

		<cfset application.model.CheckoutHelper.setCurrentStep("credit") />

        <!--- default first and last name from billing --->
		<cfif not IsDefined("session.checkout.creditCheckForm") and IsDefined("session.checkout.billShipForm")>
        	<cfset application.model.CheckoutHelper.getCreditCheckForm().fname = application.model.CheckoutHelper.getBillShipForm().billFirstName>
            <cfset application.model.CheckoutHelper.getCreditCheckForm().lname = application.model.CheckoutHelper.getBillShipForm().billLastName>
        </cfif>

		<cfif session.currentUser.getUserID() is not '' and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())>
			<cfinclude template="/views/checkout/dsp_orderAssistantMessageBox.cfm" />
		</cfif>

		<!--- show the page --->
		<cfinclude template="/views/checkout/dsp_creditCheck.cfm"/>
	</cfcase>

	<cfcase value="processCreditCheck">

		<cfset local = structNew() />

		<cfset local.billingCarrier = application.model.checkoutHelper.getCarrier() />

		<cfset application.model.checkoutHelper.setCreditCheckForm(request.p) />

		<cfscript>
			//Validate form inputs
			request.validator.clear();
			request.validator.addSSNValidator('ssn', request.p.ssn, 'Please enter your social security number in the following format XXX-XX-XXXX.');

			if (request.p.ssn eq '000-00-0000')
			{
				request.validator.addMessage('ssn', 'Please enter your valid social security number.');
			}

			request.validator.addRequiredFieldValidator('ssn', request.p.ssn, 'Please enter your social security number.');

			request.validator.addRequiredFieldValidator('dob', request.p.dob, 'Please enter your date of birth.');
			request.validator.addDateValidator('dob', request.p.dob, 'Please enter your date of birth in the following format mm/dd/yyyy.');
			request.validator.addMaxDateValidator('dob', request.p.dob, DateFormat(Now(), 'mm/dd/yy'), 'Please enter a valid date of birth.');

			request.validator.addRequiredFieldValidator('dln', request.p.dln, 'Please enter your #textDisplayRenderer.getCreditCheckCustomerIdText()# ##.');
			request.validator.addRequiredFieldValidator('dlExp', request.p.dlExp, 'Please enter #textDisplayRenderer.getCreditCheckCustomerIdText()# expiration date.');
			request.validator.addRequiredFieldValidator('dlState', request.p.dlState, 'Please select the state of issue.');
			request.validator.addDateValidator('dlExp', request.p.dlExp, 'Please enter your #textDisplayRenderer.getCreditCheckCustomerIdText()# expiration date in the following format of mm/dd/yyyy.');
			request.validator.addFutureDateValidator('dlExp', request.p.dlExp, '#textDisplayRenderer.getCreditCheckCustomerIdText()# expiration must be a date in the future.');
			request.validator.addMaxRangeValidator('dln', request.p.dln, '#textDisplayRenderer.getCreditCheckCustomerIdText()# can not exceed 20 characters', 20);
		</cfscript>

		<cfif not request.validator.hasMessages()>

			<cfset request.p.currentMDN = '' />
			<cfset request.p.CurrentAccountNumber = '' />
			<cfset local.isByPassOn = false />

			<!--- By-Pass with Order Assistance --->
			<cfif session.currentUser.getUserID() is not '' and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())>
				<cfset local.isByPassOn = true />
			</cfif>

			<cftry>
				<cfset request.p.currentMDN = application.model.checkoutHelper.getWirelessAccountForm().areaCode & application.model.checkoutHelper.getWirelessAccountForm().lnp & application.model.checkoutHelper.getWirelessAccountForm().lastFour />
				<cfset request.p.CurrentAccountNumber = application.model.checkoutHelper.getCustomerAccountNumber() />

				<cfcatch type="any">
					<!--- Do Nothing --->
				</cfcatch>
			</cftry>

				<cfset ccResult = application.model.creditCheck.checkCredit(
					local.billingCarrier,
					application.model.checkoutHelper.getReferenceNumber(),
					session.cart.getZipcode(),
					application.model.checkoutHelper.getBillShipForm().billFirstName,
					application.model.checkoutHelper.getBillShipForm().billLastName,
					application.model.checkoutHelper.getBillShipForm().billMiddleInitial,
					session.currentUser.getEmail(),
					request.p.ssn,
					request.p.dob,
					request.p.dln,
					request.p.dlState,
					request.p.dlExp,
					application.model.checkoutHelper.getBillingAddress(),
					application.model.checkoutHelper.getNumberOfLines(),
					request.p.currentMDN,
					request.p.CurrentAccountNumber,
					request.p.resultCode,
					session.cart.getActivationType(),
					application.model.checkoutHelper.getCarrierConversationId() ) />


			<cfset application.model.checkoutHelper.setCreditCheckResult(variables.ccResult) />

			<cfswitch expression="#session.checkout.creditCheckResult.getResultCode()#">
				<!--- Credit Approved --->
				<cfcase value="CC001">

					<cfset application.model.checkoutHelper.setDepositAmount(application.model.checkoutHelper.getCreditCheckResult().getResult().depositAmountRequired) />
					<cfset application.model.checkoutHelper.setLinesApproved(application.model.checkoutHelper.getCreditCheckResult().getResult().numberOfLinesApproved) />
					<cfset application.model.checkoutHelper.setApplicationReferenceNumber(application.model.checkoutHelper.getCreditCheckResult().getResult().applicationReferenceNumber) />
					<cfset application.model.checkoutHelper.setApprovalStatus(application.model.checkoutHelper.getCreditCheckResult().getResult().status) />

					<cfif len(application.model.checkoutHelper.getCreditCheckResult().getResult().customerAccountNumber) gt 0>
						<cfset application.model.checkoutHelper.setCustomerAccountNumber(application.model.checkoutHelper.getCreditCheckResult().getResult().customerAccountNumber) />
					</cfif>

					<!--- Save Verizon credit check info --->
					<cfif application.model.CheckoutHelper.getCarrier() eq 42>
						<cfset application.model.checkoutHelper.setCreditCheckInfo( application.model.checkoutHelper.getCreditCheckResult().getResult().CreditCheckInfo ) />
					</cfif>

					<!--- Save conversation ID for AT&T --->
					<cfif application.model.checkoutHelper.getCarrier() eq 109 && StructKeyExists(application.model.checkoutHelper.getCreditCheckResult(), "CarrierConversationId")>					
						<cfset application.model.checkoutHelper.setCarrierConversationId( application.model.checkoutHelper.getCreditCheckResult().getResult().CarrierConversationId ) />
					</cfif>

					<cfif not local.isByPassOn>
						<cfif application.model.checkoutHelper.getNumberOfLines() gt application.model.checkoutHelper.getLinesApproved()>
							<cfset request.validator.addMessage('errorCC001Lines', 'You were approved for ' & application.model.checkoutHelper.getLinesApproved() & ' lines, but you have ' & application.model.checkoutHelper.getNumberOfLines() & ' lines in your cart.') />
						</cfif>

	<!---
						<cfif application.model.checkoutHelper.getCreditCheckResult().getResult().depositAmountRequired gt 0>
							<cflocation url="/index.cfm/go/checkout/do/depositAuth/" addtoken="false" />
						</cfif>
	--->
					</cfif>

				</cfcase>
				<!--- Credit Denied --->
				<cfcase value="CC002">
					<cfif not local.isByPassOn>
						<cflocation url="/index.cfm/go/checkout/do/error/?code=320" addtoken="false" />
					</cfif>
				</cfcase>
				<!--- Existing Customer --->
				<cfcase value="CC003">
					<cfif not local.isByPassOn>
						<cfset request.validator.addMessage('errorCC003', 'Based on the information provided, it appears that you are an existing #application.model.CheckoutHelper.getCarrierName()# customer. To upgrade or add a line to your existing account, return to shopping and click on the word "upgrade" or "add-a-line" above the price of the phone before you add it to your cart.') />
					</cfif>
				</cfcase>
				<cfcase value="CC013">
					<cfif not local.isByPassOn>
						<cflocation url="/index.cfm/go/checkout/do/error/?code=102" addtoken="false" />
					</cfif>
				</cfcase>
				<!--- Invalid Request, Unable to Connect to Carrier Service, Service Timeout --->
				<cfcase value="CC010|CC011|CC012" delimiters="|">
					<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
				</cfcase>
				<!--- Credit Approved + Deposit Required  --->
				<cfcase value="CC015">
					<cfif not local.isByPassOn>
						<cflocation url="/index.cfm/go/checkout/do/depositAuth/" addtoken="false" />
					</cfif>
				</cfcase>
				<cfcase value="CC016">
					<cfif not local.isByPassOn>
						<cflocation url="/index.cfm/go/checkout/do/depositAuth/" addtoken="false" />
					</cfif>
				</cfcase>				
				<!--- Unknown error --->
				<cfdefaultcase>
					<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>

		<cfif request.validator.hasMessages()>
			<cfif session.currentUser.getUserID() is not '' and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())>
				<cfinclude template="/views/checkout/dsp_orderAssistantMessageBox.cfm" />
			</cfif>

			<cfinclude template="/views/checkout/dsp_creditCheck.cfm" />
		<cfelse>
			<cfset application.model.checkoutHelper.markStepCompleted('credit') />

			<!--- Display account question for new Sprint Activations --->
			<cfif application.model.CheckoutHelper.getCarrier() EQ 299 && application.model.CheckoutHelper.isNewActivation()>
				<cflocation url="/index.cfm/go/checkout/do/securityQuestion/" addtoken="false" />
			<cfelse>
				<cflocation url="/index.cfm/go/checkout/do/orderConfirmation/" addtoken="false" />
			</cfif>
		</cfif>
	</cfcase>

	<cfcase value="securityQuestion">
		<cfset request.currentTopNav = "checkout.securityQuestion" />
		<cfset application.model.CheckoutHelper.setCurrentStep("securityquestion") />
		<cfset request.p.qQuestions = application.model.SecurityQuestion.getSecurityQuestions() />

		<!--- show the page --->
		<cfinclude template="/views/checkout/dsp_accountQuestion.cfm" />
	</cfcase>

	<cfcase value="procesSecurityQuestion">
		<cfset request.currentTopNav = "checkout.securityQuestion" />

		<cfset application.model.CheckoutHelper.setAccountPin( request.p.accountPin ) />
		<cfif Len(request.p.securityQuestionId)>
			<cfset application.model.CheckoutHelper.setSelectedSecurityQuestionId( request.p.securityQuestionId ) />
		</cfif>
		<cfset application.model.CheckoutHelper.setSecurityQuestionAnswer( request.p.securityQuestionAnswer ) />

		<cfset request.validator.clear() />
		<cfset request.validator.addRequiredFieldValidator('accountpin', request.p.accountpin, 'PIN is required.') />
		<cfset request.validator.AddIsNumericValidator('accountpin', request.p.accountpin, 'PIN can only contain digits') />
		<cfset request.validator.AddFieldLengthValidator('accountpin', request.p.accountpin, 'PIN must be between 6 and 10 digits', 6 , 10) />
		<cfset request.validator.addRequiredFieldValidator('securityQuestionId', request.p.securityQuestionId, 'A selected question is required.') />
		<cfset request.validator.addRequiredFieldValidator('securityQuestionAnswer', request.p.securityQuestionAnswer, 'An answer to your security question is required.') />

		<!--- PIN cannot contain birthdate --->
		<cfif IsDefined('session.checkout.creditCheckForm.dob') && (request.p.accountpin contains DateFormat(session.checkout.creditCheckForm.dob, "mdyyyy") || request.p.accountpin contains DateFormat(session.checkout.creditCheckForm.dob, "mmddyyyy"))>
			<cfset request.validator.addMessage('accountpin', 'PIN cannot contain birthdate') />
		</cfif>

		<!--- PIN cannot contain SSN --->
		<cfif IsDefined('session.checkout.creditCheckForm.ssn') && Len(session.checkout.creditCheckForm.ssn)>
			<cfset request.p.cleanssn = Replace(session.checkout.creditCheckForm.ssn, '-', '', 'all') />

			<cfloop from="4" to="#Len(request.p.cleanssn)#" index="i">
				<cfif request.p.accountpin contains Left(request.p.cleanssn, i)>
					<cfset request.validator.addMessage('accountpin', 'PIN cannot contain sequences of your SSN') />
					<cfbreak />
				</cfif>
				<cfif request.p.accountpin contains Right(request.p.cleanssn, i)>
					<cfset request.validator.addMessage('accountpin', 'PIN cannot contain sequences of your SSN') />
					<cfbreak />
				</cfif>
			</cfloop>
		</cfif>

		<cfif request.validator.hasMessages()>

			<cfset request.p.qQuestions = application.model.SecurityQuestion.getSecurityQuestions() />

			<cfif session.currentUser.getUserID() is not '' and application.model.user.isUserOrderAssistanceOn(session.currentUser.getUserID())>
				<cfinclude template="/views/checkout/dsp_orderAssistantMessageBox.cfm" />
			</cfif>

			<!--- show the page --->
			<cfinclude template="/views/checkout/dsp_accountQuestion.cfm" />
		<cfelse>

			<cfset application.model.checkoutHelper.markStepCompleted('securityquestion') />

			<cflocation url="/index.cfm/go/checkout/do/orderConfirmation/" addtoken="false" />
		</cfif>

	</cfcase>

	<cfcase value="depositAuth">
		<cfset request.currentTopNav = "checkout.depositAuth">
		<!--- show the page --->
		<cfinclude template="/views/checkout/dsp_depositAuth.cfm"/>
	</cfcase>

	<cfcase value="processDeposit">
		<cfif request.p.s EQ "Authorize this deposit">
			<!--- add deposit amount to order --->
			<!--- application.model.CheckoutHelper.getCreditCheckResult().getResult().depositAmountRequired --->

            <cfset request.p.newItem = createObject("component","cfc.model.CartItem").init()>
            <cfset request.p.newItem.setType("deposit")>
            <cfset request.p.newItem.setTitle("Wireless Order Deposit")>
            <cfset request.p.newItem..getPrices().setDueToday(application.model.CheckoutHelper.getCreditCheckResult().getResult().depositAmountRequired)>

            <!--- must be only a single deposit line, so loop the lines and if there is already one, just updated it --->
            <cfset request.p.hasDepositItem = false>
            <cfset request.p.items = session.cart.getOtherItems()>
            <cfloop from="1" to="#ArrayLen(request.p.items)#" index="request.p.i">
            	<cfset request.p.item = request.p.items[request.p.i]>
            	<cfif request.p.item.getType() eq "deposit">
                	<cfset request.p.hasDepositItem = true>
                    <cfset request.p.item = request.p.newItem>
                    <cfbreak>
                </cfif>
            </cfloop>
            <cfif  request.p.hasDepositItem eq false>
            	<cfset session.cart.AddOtherItem(request.p.newItem)>
            </cfif>


			<cfset application.model.CheckoutHelper.markStepCompleted("deposit") />
			<cflocation url="/index.cfm/go/checkout/do/orderConfirmation/" addtoken="false"/>
		<cfelse>
			<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false"/>
		</cfif>
	</cfcase>

	<cfcase value="restrictedLines">
		<cfset request.currentTopNav = "checkout.restrictedLines">
		<cfinclude template="/views/checkout/dsp_restrictedLines.cfm" />
	</cfcase>

	<cfcase value="orderConfirmation">
		<cfset application.model.checkoutHelper.setCurrentStep('review') />
		<cfset session.cart.updateCartItemTaxes() />
		<cfset session.cart.updateAllTaxes() />

		<cfinclude template="/views/checkout/dsp_orderConfirmation.cfm" />
	</cfcase>

	<cfcase value="processOrderConfirmation">
		<cfif request.p.s is 'Cancel Order'>
			<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
		</cfif>

		<!--- If the user changed shipping, go back to order confirmation. --->
		<cfif session.checkout.shippingMethod.getShipMethodId() neq request.p.shipping>
			<cfset local.selectedShippingMethod = application.model.CheckoutHelper.getShippingMethod() />
			<cfset local.selectedShippingMethod.load(request.p.shipping) />
			<cfset application.model.CheckoutHelper.setShippingMethod(local.selectedShippingMethod) />

			<cfif ChannelConfig.getOfferShippingPromo() && application.model.CartHelper.isCartEligibleForPromoShipping()>
				<cfset session.cart.getShipping().setDueToday( application.model.checkoutHelper.getShippingMethod().getPromoPrice() ) />
			<cfelse>
				<cfset session.cart.getShipping().setDueToday( application.model.checkoutHelper.getShippingMethod().getDefaultFixedCost() ) />
			</cfif>
		</cfif>

		<cfset application.model.checkoutHelper.markStepCompleted('review') />

		<cfset order = createObject('component', 'cfc.model.order').init() />
		
		<cfset variables.order.populateFromCart(session.cart) />
		<cfset variables.order.populateFromCheckoutHelper() />
		
		<!--- add additional fields to support VFD/VSA --->
		<cfif isDefined('session.scenario.scenarioType') >
			<cfset variables.order.setScenarioId(listfind(application.scenarios,session.scenario.scenarioType)) />
		</cfif>

		<cfif session.currentUser.getUserID() NEQ "" AND application.model.user.isUserOrderAssistanceOn( session.currentUser.getUserID() )>
			<cfset order.setOrderAssistanceUsed( true ) />
		</cfif>

		<cfif len(trim(session.cart.getKioskEmployeeNumber()))>
			<cfset order.setKioskEmployeeNumber(session.cart.getKioskEmployeeNumber()) />
		</cfif>

		<cfset variables.order.save() />
		
		<cfif session.cart.hasPromotions()>
			<cfset PromotionService.applyPromotion( cart = session.cart, orderID = order.getOrderID(), userID = session.userID )>
			<cfset order.load(order.getOrderId())>
		</cfif>
		
		<cfset application.model.checkoutHelper.setOrderId(order.getOrderId()) />

		<!---<cfif application.model.checkouthelper.isUpgrade()>
			<cfset accountLookups = application.model.checkoutHelper.getCustomerLookupResult() />
			<cfset request.p.wirelessLines = order.getWirelessLines() />

			<cfif arrayLen(request.p.wirelessLines) gte 1>
				<cfloop from="1" to="#ArrayLen(request.p.wirelessLines)#" index="i">
					<cfset request.p.wirelessLine = request.p.wirelessLines[i] />
					<cfset request.p.wirelessLine.setCurrentMDN( accountLookups[i].lookupArgs.mdn ) />
					<cfset request.p.wirelessLine.setPlanType( accountLookups[i].lookupResult.getResult().WirelessLineType ) />
					<cfset request.p.wirelessLine.setCarrierPlanType( accountLookups[i].lookupResult.getResult().CarrierPlanType ) />
					<cfset request.p.wirelessLine.setCurrentImei( accountLookups[i].lookupResult.getResult().CurrentImei ) />

					<!--- Store old plan info for equipment only upgrade --->
					<cfif session.cart.getUpgradeType() eq 'equipment-only'>
						<cfset request.p.wirelessLine.setCarrierPlanId( accountLookups[i].lookupResult.getResult().CarrierPlanId ) />
					</cfif>
				</cfloop>

				<cfset order.save() />
			</cfif>

			<!--- Verizon requires a Credit check for upgrades --->
			<cfscript>
				if ( application.model.checkoutHelper.getCarrier() eq 42 && order.getCreditCheckKeyInfoId() eq 0)
				{
					order.load( order.getOrderId() );
					wirelessLines = order.getWirelessLines();
					orderBillingAddress = order.getBillAddress();

					requestHeader = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.CarrierRequestHeader').init( argumentCollection = request.config.VerizonRequestHeader );
					requestHeader.setServiceAreaZip( order.getServiceZipCode() );
					requestHeader.setReferenceNumber( order.getCheckoutReferenceNumber() );

					creditWriteRequest = CreateObject('component', 'cfc.model.carrierservice.Verizon.CreditWriteRequest').init();
					creditWriteRequest.setRequestHeader( requestHeader );

					creditWriteRequest.setServiceZipCode( order.getServiceZipCode() );
					creditWriteRequest.setNumberOfLines( ArrayLen( wirelessLines ) );
					creditWriteRequest.setActivationType( 'U' );
					creditWriteRequest.setEmail( order.getEmailAddress() );

					creditWriteAddress = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.Address').init();
					creditWriteAddress.setAddressLine1( orderBillingAddress.getAddress1() );
					creditWriteAddress.setAddressLine2( orderBillingAddress.getAddress2() );
					creditWriteAddress.setAddressLine3( orderBillingAddress.getAddress3() );
					creditWriteAddress.setAptNum( '' );
					creditWriteAddress.setCity( orderBillingAddress.getCity() );
					creditWriteAddress.setState( orderBillingAddress.getState() );
					creditWriteAddress.setCountry( '' );
					creditWriteAddress.setZipCode( orderBillingAddress.getZip() );

					creditWriteRequest.setAddress( creditWriteAddress );

					upgradeCustomerInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.UpgradeCustomerInfo').init();
					upgradeCustomerInfo.setAccountNumber( order.getWirelessAccount().getCurrentAcctNumber() );
					upgradeCustomerInfo.setMtn( wirelessLines[1].getCurrentMdn() ); //TODO: Find out how to populate

					creditWriteRequest.setUpgradeCustomerInfo( upgradeCustomerInfo );

					creditWriteRequest.setBillingNameFirstName( orderBillingAddress.getFirstName() );
					creditWriteRequest.setBillingNameMiddleInitial( '' );
					creditWriteRequest.setBillingNameLastName( orderBillingAddress.getLastName() );
					creditWriteRequest.setBillingNamePrefix( '' );
					creditWriteRequest.setBillingNameSuffix( '' );

					serviceBusRequest = CreateObject('component', 'cfc.model.carrierservice.ServiceBus.ServiceBusRequest').init( argumentCollection = request.config.ServiceBusRequest );
					serviceBusRequest.setCarrier( request.config.CarrierServiceBusTarget.Verizon );
					serviceBusRequest.setAction( 'CreditWrite' );
					serviceBusRequest.setRequestData( creditWriteRequest );

					serviceBusResponse = application.model.RouteService.Route( serviceBusRequest );

					if (serviceBusResponse.ResponseStatus.ErrorCode eq 0)
					{
						creditWriteReponse = deserializeJson(serviceBusResponse.ResponseData);
						creditCheckInfo = CreateObject('component', 'cfc.model.carrierservice.Verizon.common.CreditCheckKeyInfo').init();

						if ( creditWriteReponse.ResponseStatus.ErrorCode eq '000000' || creditWriteReponse.ResponseStatus.ErrorCode eq '02051')
						{
							creditCheckInfo.setBillingSystem( creditWriteReponse.OrderKeyInfo.BillingSystem );
							creditCheckInfo.setClusterInfo( creditWriteReponse.OrderKeyInfo.ClusterInfo);
							creditCheckInfo.setCreditApplicationNum( creditWriteReponse.OrderKeyInfo.CreditApplicationNum );
							creditCheckInfo.setLocation( creditWriteReponse.OrderKeyInfo.Location );
							creditCheckInfo.setOrderNum( creditWriteReponse.OrderKeyInfo.OrderNum );
							creditCheckInfo.setOutletId( creditWriteReponse.OrderKeyInfo.OutletId );
							creditCheckInfo.setSalesForceId( creditWriteReponse.OrderKeyInfo.SalesForceId );
						}

						creditCheckInfo.save();

						application.model.checkoutHelper.setCreditCheckInfo( creditCheckInfo );
					}
					else
					{
						//application.model.Util.cfdump( serviceBusResponse );
						//application.model.Util.cfabort();

						application.model.Error.sendErrorEmail( serviceBusResponse );
						application.model.Util.cfthrow('Technical difficulties communicating with Carrier.');
					}
				}
			</cfscript>
		</cfif>--->

		<!---<cfif application.model.checkouthelper.isAddALine()>
			<cfset accountLookups = application.model.checkoutHelper.getCustomerLookupResult() />
			<cfset request.p.wirelessLines = order.getWirelessLines() />

			<cfif arrayLen(request.p.wirelessLines) gte 1>
				<cfloop from="1" to="#ArrayLen(request.p.wirelessLines)#" index="i">
					<cfset request.p.wirelessLine = request.p.wirelessLines[i] />
					<cfset request.p.wirelessLine.setPlanType( accountLookups[1].lookupResult.getResult().WirelessLineType ) />
					<cfset request.p.wirelessLine.setCarrierPlanType( accountLookups[1].lookupResult.getResult().CarrierPlanType ) />
					<!--- Store old plan info for family plans --->
					<cfif session.cart.getAddALineType() eq 'Family'>
						<cfset request.p.wirelessLine.setCarrierPlanId( accountLookups[1].lookupResult.getResult().CarrierPlanId ) />
					</cfif>
				</cfloop>

				<cfset order.save() />
			</cfif>
		</cfif>--->


		<!--- Store credit check application info for Verizon --->
		<!---<cfif application.model.checkoutHelper.getCarrier() eq 42>
			<cfset local.CreditCheckInfo = application.model.checkoutHelper.getCreditCheckInfo() />
			<cfset local.CreditCheckInfo.save() />

			<cfset variables.order.setCreditCheckKeyInfoId( local.CreditCheckInfo.getCreditCheckKeyInfoId() ) />
			<cfset variables.order.save() />
		</cfif>--->

		<!--------------------------------------------------------------- 
			Add special SKUs to make reports commission reports correct 
		----------------------------------------------------------------->
		<cfif ( session.cart.getActivationType() is 'nocontract')
		   or (session.cart.getActivationType() is 'upgrade' and session.cart.getUpgradeType() eq 'equipment-only')
		   or (session.cart.getActivationType() is 'addaline' and session.cart.getAddaLineType() eq 'Family' )
		   or application.model.checkoutHelper.isPrepaidOrder()	>
			
			<cfset cartLines = session.cart.getLines() />
			<cfloop from="1" to="#arrayLen(order.getWirelessLines())#" index="i">			 	 
			 	 
			 	 <cfif session.cart.getActivationType() is 'nocontract'>
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
			 	<cfif session.cart.getActivationType() is 'upgrade'>
					<cfset CommissionSku = application.model.CheckoutHelper.GetKeepRateplanSKU( 
							application.model.checkoutHelper.getCarrier()
							, cartlines[i].getPhone().getGersSKU()
							, cartlines[i].getPhone().getDeviceServiceType()
							,session.cart.getActivationType()
							, i <!--- line number --->) />
					<cfset CommissionSkuTitle = "Keep current rateplan" />
				</cfif>
				  
				<cfif session.cart.getActivationType() is 'addaline'>
				 	 <cfset CommissionSku = application.model.CheckoutHelper.GetKeepRateplanSKU( 
							application.model.checkoutHelper.getCarrier()
							, cartlines[i].getPhone().getGersSKU()
							, cartlines[i].getPhone().getDeviceServiceType()
							,session.cart.getActivationType()
							, i <!--- line number --->) />
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

		<!---
		**
		* If wireless order, continue to coverage confirmation.
		**
		--->
		<cfif application.model.checkoutHelper.isPrepaidOrder()>
			<cflocation url="/index.cfm/go/checkout/do/customerInfo/" addtoken="false" />
		<cfelseif application.model.checkoutHelper.isWirelessOrder()>
			<cflocation url="/index.cfm/go/checkout/do/carrierTerms/" addtoken="false" />
		<cfelseif GatewayRegistry.hasMultipleRegistered()>
			<cflocation url="/index.cfm/go/checkout/do/paymentOptions" addtoken="false" />
		<cfelse>
			<cfinclude template="/views/checkout/dsp_payment.cfm" />
		</cfif>
		
	</cfcase>
	
	<cfcase value="carrierTerms">
		<cfset application.model.CheckoutHelper.setCurrentStep("carrierTerms") />
		<cfinclude template="/views/checkout/dsp_CarrierTerms.cfm" />
	</cfcase>

	<cfcase value="processCarrierTerms">
		<cfset application.model.CheckoutHelper.markStepCompleted("carrierTerms") />
		
		<cfif ChannelConfig.getDisplayPrePaymentGatewayPage()>
			<cflocation url="/index.cfm/go/checkout/do/prepaymentmessage" addtoken="false" />
		<cfelse>
			<cflocation url="/index.cfm/go/checkout/do/paymentOptions" addtoken="false" />
		</cfif>
	</cfcase>

	<cfcase value="prepaymentmessage">
		<cfset application.model.CheckoutHelper.setCurrentStep("PrePaymentGateway") />
		<cfinclude template="/views/checkout/dsp_prePaymentMessage.cfm"/>
	</cfcase>
	
	<cfcase value="customerInfo">
		<cfset application.model.CheckoutHelper.setCurrentStep("prepaidcustomerinfo") />
		<!--- show the page --->
		<cfinclude template="/views/checkout/dsp_prepaidterms.cfm"/>
	</cfcase>


   	<cfcase value="processCustomerInfo">

        <!--- clear validators --->
        <cfset request.validator.clear()>

        <!--- add form validations --->
        <cfparam name="request.p.coverage" default="">
        <cfset request.validator.AddRequiredFieldValidator("coverage",request.p.coverage, "Please agree to the prepaid customer letter to continue.")>
		<!--- end add form validations --->
        <!--- display errors or move on --->
        <cfif request.validator.HasMessages()>
        	<cfinclude template="/views/checkout/dsp_prepaidterms.cfm"/>
        <cfelse>
            <!--- go to payment --->
            <cfinclude template="/views/checkout/dsp_payment.cfm"/>

        </cfif>
	</cfcase>


	<cfcase value="coverageCheck">
		<cfset application.model.CheckoutHelper.setCurrentStep("coverage") />
		<cfinclude template="/views/checkout/dsp_coverageCheck.cfm"/>
	</cfcase>


	<cfcase value="processCoverageCheck">

		<!--- store all results in the session to be recalled --->
		<cfset application.model.CheckoutHelper.setCoverageAreaForm(request.p)>

        <!--- clear validators --->
        <cfset request.validator.clear()>

        <!--- add form validations --->
        <cfparam name="request.p.coverage" default="">
        <cfset request.validator.AddRequiredFieldValidator("coverage",request.p.coverage, "No coverage area selection provided.")>
		<cfset request.validator.AddEqualityValidator("coverage", request.p.coverage, "acknowledge", "Coverage area must be acknowledged.") />

        <!--- display errors or move on --->
        <cfif request.validator.HasMessages()>
        	<cfinclude template="/views/checkout/dsp_coverageCheck.cfm"/>
        <cfelse>
        	<!--- mark the step completed --->
            <cfset application.model.CheckoutHelper.markStepCompleted("coverage") />

            <!--- TODO: store approval --->

            <!--- go to next step --->
            <cflocation url="/index.cfm/go/checkout/do/termsConditions/" addtoken="false"/>
        </cfif>

	</cfcase>


	<cfcase value="payment">
		<cfset application.model.checkoutHelper.setCurrentStep('payment') />

		<cfinclude template="/views/checkout/dsp_payment.cfm" />
	</cfcase>

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
	<cfcase value="processPayment">

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
			<cfhttp url="http://#cgi.server_name#/asynclistner/paymentGatewayAsyncListener.cfm" throwonerror="yes" method="post" timeout="60" charset="utf-8">
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
					<cfif !channelConfig.getVfdEnabled()>
						<cfset order.setStatus(1) />
					<cfelse><!---Direct Delivery orders are captured --->
						<cfset order.setStatus(2) />
					</cfif>
				<cfelse>
					<cfset order.setStatus(2) />
				</cfif>
				
				<cfset order.save() />
			</cfif>

			<cfset application.model.checkoutHelper.markStepCompleted('WATC') />
			<cfset application.model.checkoutHelper.markStepCompleted('payment') />

			<cflocation url="/index.cfm/go/checkout/do/thanks/" addtoken="false" />
		<cfelse>
			<!--- todo: replace with payment declined page --->
			<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
		</cfif>
	</cfcase>

	<cfcase value="thanks">
		
		<!--- Redirect to account if session Order number is not present --->
		<cfif !application.model.checkoutHelper.getOrderId()>
			<cflocation url="/index.cfm/go/myAccount/do/view/" addtoken="false" />
		</cfif>

		<cfset order = createObject('component', 'cfc.model.order').init() />
		<cfset order.load(application.model.checkoutHelper.getOrderId()) />

		<cfset request.p.orderId = variables.order.getOrderId() />
		<cfset request.p.email = variables.order.getEmailAddress() />

		<cfif ChannelConfig.getTrackMercentAnalytics()>
			<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />
			<cfoutput>#mercentAnalyticsTracker.tagOrderConfirmation(variables.order)#</cfoutput>
		</cfif>

		<!---<cfif request.config.enableAnalytics>--->
			<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
			<cfoutput>#googleAnalyticsTracker.tagOrderConfirmation(variables.order)#</cfoutput>
		<!---</cfif>--->
		
		<!--- If this is a VFD transaction proceed to Carrier Activation --->
		<cfif channelConfig.getVfdEnabled()>
			<cflocation url="/CheckoutVFD/preCarrierActivation/" addtoken="false"/>
		</cfif>
		
		<cfinclude template="/views/checkout/dsp_thanks.cfm" />

		<cfset application.model.checkoutHelper.clearCart() />
		<cfset application.model.checkoutHelper.clearCheckOut() />
	</cfcase>

	<cfcase value="processPaymentRedirect">
		<cfset application.model.checkoutHelper.clearCheckout() />
		<cfset application.model.checkoutHelper.markStepCompleted('billShip') />
		<cfset application.model.checkoutHelper.setCurrentStep('review') />

		<cfinclude template="/views/checkout/dsp_orderPaymentRedirect.cfm" />
	</cfcase>

	<cfcase value="login">
		<cfparam name="request.p.loginCallBack" type="string">
		<cfset request.p.loginCallBack = replaceNoCase(request.p.loginCallBack,"~","/","all")>
		<cfset request.p.loginCallBack = replaceNoCase(request.p.loginCallBack,"!",".","all")>
		<cfset session.loginCallback = request.p.loginCallBack /> <!--- sets the redirect url after login --->
		<cflocation url="/index.cfm/go/myAccount/do/login/" addtoken="false"/>
	</cfcase>

	<cfcase value="billShipCheckEmailAddress">
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
			<cfinclude template="/views/checkout/dsp_billShip.cfm">
		<cfelse>
			<cflocation url="/index.cfm/go/checkout/do/billShip/" addtoken="false" />
		</cfif>
		
	</cfcase>

	<cfcase value="billShipAuthenticate">
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
			<cflocation addtoken="false" url="/index.cfm/go/checkout/do/billShip/">
		<cfelse>
			<!--- generate an error message --->
            <cfset request.validator.AddMessage("existingUserPassword","Incorrect password.")>
			<cfinclude template="/views/checkout/dsp_billShip.cfm">
		</cfif>
	</cfcase>

	<cfcase value="updatePassword">
		<cfparam name="request.p.password" type="string">
		<cfif len(trim(session.currentUser.getEmail())) and len(trim(request.p.password))>
			
	        <cfset request.validator.AddRequiredFieldValidator("email",REQUEST.p.username, "Email address is required.")>
	        <cfset request.validator.AddEmailValidator("email",REQUEST.p.username, "Email is not a valid email address format.")>
	        <cfset request.validator.AddRequiredFieldValidator("password",REQUEST.p.password, "Password is required.")>
			
	        <!--- custom validator password length--->
	    	<cfif Len(REQUEST.p.password) LT 6 OR Len(REQUEST.p.password) GT 8>
	            <cfset request.validator.AddValidator("password",REQUEST.p.password,"custom","Password length must be between 6 and 8.")>
	   		</cfif>
	
	        <cfset request.validator.AddRequiredFieldValidator("confpassword",REQUEST.p.password2, "Confirm Password is required.")>
	        <!--- custom validator password matching--->
	    	<cfif REQUEST.p.password NEQ REQUEST.p.password2>
	            <cfset request.validator.AddValidator("nomatch",REQUEST.p.password,"custom","Password and Confirm Password does not match.")>
	        </cfif>
	        <!--- custom validator confirm password length--->
	    	<cfif Len(REQUEST.p.password2) LT 6 OR Len(REQUEST.p.password2) GT 8>
	            <cfset request.validator.AddValidator("confpassword",REQUEST.p.password2,"custom","Confirm Password length must be between 6 and 8.")>
	   		</cfif>
	
	        <cfif request.validator.HasMessages()>
	        	<cfset signupHTML = application.view.MyAccount.signup()>
	            <cfinclude template="/views/myaccount/dsp_signup.cfm">
	        <cfelse>
				<!--- change the user's account using the supplied password --->
				<cfset session.currentUser.updatePassword(session.currentUser.getEmail(),request.p.password)>
				<!--- send the user to the "my account" section --->
				<cflocation addtoken="false" url="/index.cfm/go/myAccount/do/view/">
	        </cfif>
			
		</cfif>
	</cfcase>

	<cfcase value="customer-service">
		<cfset request.layoutFile = 'nolayout' />
		<cfset request.Title = ChannelConfig.getDisplayName() & ' Customer Service' />
		<cfset request.MetaDescription = ChannelConfig.getDisplayName() & ' Customer Service' />
		<cfset request.MetaKeywords = ChannelConfig.getDisplayName() & ', Customer Service' />
		<cfinclude template="/views/checkout/dsp_CustomerServiceContacUs.cfm" />
	</cfcase>

	<cfcase value="error">
		<cfset request.currentTopNav = "checkout.error">
		<!--- save the user's order, and display a friendly error --->
		<cfinclude template="/views/checkout/dsp_error.cfm"/>
	</cfcase>
	
	<cfcase value="checkoutError">
		<!---<cfset request.currentTopNav = "checkout.checkoutError">--->
		<cfset request.currentTopNav = "home">
		<!--- save the user's order, and display a friendly error --->
		<cfinclude template="/views/checkout/dsp_CheckoutError.cfm"/>
	</cfcase>

	<cfcase value="inventoryerror">
		<cfset request.currentTopNav = "checkout.error">
		<cfinclude template="/views/checkout/dsp_OutOfStock.cfm"/>
	</cfcase>

	<cfcase value="paymentOptions">
		<cfset application.model.checkoutHelper.markStepCompleted('CustLetter') />
		<cfset application.model.CheckoutHelper.setCurrentStep("payment") />
		<cfinclude template="/views/checkout/dsp_PaymentOptions.cfm" />
	</cfcase>

	<cfcase value="processPaymentOptions">
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
	</cfcase>

	<cfcase value="addPromotionToCart">
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
		
	</cfcase>
	
	<cfcase value="removePromotion">
		<cfparam name="request.p.code" default="" />
		
		<cfif session.Cart.hasPromotion( request.p.code ) >
			<cfset session.Cart.removePromotion( request.p.code )>
		</cfif>
		
		<cflocation addtoken="false" url="#returnURL#">
		
	</cfcase>
		
	<cfdefaultcase>
		<cflocation addtoken="false" url="/index.cfm/go/checkout/do/startCheckout/">
	</cfdefaultcase>

</cfswitch>
