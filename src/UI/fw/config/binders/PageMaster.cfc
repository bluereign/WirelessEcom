<cfcomponent output="false" extends="coldbox.system.ioc.config.Binder">

<cfscript>
	function configure(){
		
		var assetPaths = {};
		var viewPaths = {};
		var channelConfigArgs = {};
		var textDisplayArgs = {};
		var accessoryConfigArgs = {};
		var internetSecurePaymentMethods = {};
		var sprintCarrierEndpoints = {};
				
		/*************** WIREBOX CONFIGURATION ***************/
		
		wireBox = {
			
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			// By default it registeres itself on application scope
			scopeRegistration = {
				enabled = true,
				scope   = "application", // server, cluster, session, application
				key		= "wirebox"
			},
			
			// Parent Injector to assign to the configured injector, this must be an object reference
			parentInjector = createObject("component","coldbox.system.ioc.Injector").init(binder="fw.config.binders._Common", coldbox=application.cbController, properties=getProperties()),			
			
			// This prevents wirebox from trying to resolve dependencies on legacy code
			scanLocations = ['fw.model']
		
		};
		
		/*************** MODEL MAPPINGS ***************/
				
		// Asset paths
		assetPaths = {
			common = "/assets/common/",
			channel = "/assets/pagemaster/",
			admin = {
				common = "/admin/assets/common/",
				channel = "/admin/assets/pagemaster/"
			}
		};
		map("AssetPaths")
			.toValue( assetPaths )
			.asSingleton();
			
		// Channel config settings
		channelConfigArgs = {
			VfdEnabled = false,
			VFDMkey = '',
			VFDIV = '',
			ScenarioDescription = '',
			CarrierTwoYearRemoval = "109|6/1/2015",
			ThirdPartyAuth = false,
			AllowAPOFPO = false,
			OfferWarrantyCoverage = false,
			DisplayFreeKit = false,
			OfferShippingPromo = false,
			OfferWarrantyPlan =  true,
			OfferPrepaidDeviceWarrantyPlan = false,
			TrackMercentAnalytics = true,
			DisplayOnlineValue = false,
			ActivationFeeWavedByCarrier = '',			
			DisplayNoInventoryItems = false,
			DisplayZeroPricedItems = true,			
			ActivationFeeWavedByCarrier = '',
			DisplayName = 'Wireless',
			OfferNoContractDevices = true,		// Does this channel offer ANY no contract devices
			NoContractDevices = "tablet",		// If above is true, these device types offer no contract prices
			OfferPrepaidFreeShipping = true,
			OrderProcessingTime = 3,
			PromotionCodeAvailable = true,
			Environment = getProperty("environment"),
			DdAdminReturnFilterEnabled = {  // if enabled then only orders with status = 3 are included
				development = "false",
				test = "false",
				staging = "false",
				production = "true"			
			},
			CEXCHANGEMap = {
				development = 'http://costco.testcloud.com:8095',
				test = ' http://costco.testcloud.com:8095',
				staging = 'http://costco.cexchange.com',
				production = 'http://costco.cexchange.com'			
			},
			DomainNameMap = {
				development = 'http://costco.testcloud.com:8095/online/home/index.rails',
				test = 'http://costco.testcloud.com:8095/online/home/index.rails',
				staging = 'http://costco.testcloud.com:8095/online/home/index.rails',
				production = 'http://costco.testcloud.com:8095/online/home/index.rails'			
			},
			AppleCareEnabled = "false",
			AppleCarePrefix = "",			
			AppleCareAPIMap = {
				development = {
					url = 'http://10.7.0.80:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				test = {
					url = 'http://10.7.0.80:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				staging = {
					url = 'http://10.7.0.80:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				production = {
					url = 'http://10.7.0.80:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				}		
			},
			DisplayCustomerSurveyLink = false,
			DisplayWarrantyDetailInCart = true,
			CustomerCareEmail = 'wawirelesspromotions@wirelessadvocates.com',
			CustomerCarePhone = '1-844-460-5643',
			DisplayProductRebates = false,
			DisplayCarrierCustomerLetter = false,
			DisplaySmsOptIn = true,
			DisplayPrepaidDevices = false,
			DisplayPrePaymentGatewayPage = true,
			OfferFinancedDevices = false,
			DirectToRedesignDetailsPage = false,		//Temp for 6.5.0 release
			DefaultProductSort = 'PriceDesc'
		};
		
		map("ChannelConfig")
			.to("cfc.model.config.ChannelConfig")
			.initWith(argumentCollection=channelConfigArgs)
			.asSingleton();

		// Display text
		textDisplayArgs = {
			BusinessName = 'Pagemaster',
			StoreAliasName = 'Pagemaster',
			KioskName = 'Pagemaster',
			CustomerAliasName = 'Customer',
			GersCustomerIdPreFix = 'PG',
			//CartDialogWarrantyTitle = '2-Year Drops &amp; Spills Protection for Cell Phones',
			CartDialogWarrantyTitle = 'Select a Protection Plan for Your Device',
			TmobilePriceBlockBonusOffer = '$25 Costco Cash Card via Mail-in Rebate with activation of a financed device.',
			OutOfStockButtonText = "Out of Stock",
			OutOfStockAlertText = "This item will be availble soon",
			CreditCheckCustomerIdText = "Driver's License",
			PriceLabelText = "Retail Price",
			Hide2YearFinancingButtonText = "Learn More"
		};
		map("TextDisplayRenderer")
			.to("cfc.model.system.render.TextDisplayRenderer")
			.initWith(argumentCollection=textDisplayArgs)
			.asSingleton();

		// Accessory config
		/* List of FilterOptionIds for each of the Filter Categories
			Cases = 56
			Chargers = 57
			Bluetooth = 376
			Screen Protectors = 59
			Audio = 58
			Batteries = 377
			Docks = 280 */
		accessoryConfigArgs = {
			categoryOrder = "56, 57, 58, 59",
			homePageFilterTop = "273px",
			homePageFilterTileMargin = "7px",
			homePageFilterTileMarginIE = "7px\9"
		};
		map("AccessoryConfig")
			.toValue(accessoryConfigArgs)
			.asSingleton();
			
		/* emailTemplateDomain has been moved to the environment configs for now.
		leaving code in place in case we want to use it in the future.
		
		map("EmailTemplateDomain")
			.toFactoryMethod( factory="FactoryHelper", method="buildStruct" )
			.methodArg( name="local", value=${localServer} )
			.asSingleton();
		*/
		
		//View paths for Dynamic view renderer
		viewPaths["content.home"] = "/views/content/pagemaster/home/dsp_landing.cfm";
		viewPaths["content.phonesHome"] = "/views/content/pagemaster/home/dsp_landing.cfm";
		viewPaths["content.plansHome"] = "/views/content/pagemaster/home/dsp_landing.cfm";
		viewPaths["content.accessoriesHome"] = "/views/content/pagemaster/home/dsp_landing.cfm";
		viewPaths["content.faq"] = "/views/content/pagemaster/dsp_faq.cfm";
		viewPaths["content.returns"] = "/views/content/pagemaster/dsp_returns.cfm";
		viewPaths["content.terms"] = "/views/content/pagemaster/dsp_terms.cfm";
		viewPaths["content.privacy"] = "/views/content/pagemaster/dsp_privacy.cfm";
		viewPaths["content.shipping"] = "/views/content/pagemaster/dsp_shipping.cfm";
		viewPaths["content.serviceAgreement"] = "/views/content/pagemaster/dsp_serviceAgreement.cfm";
		viewPaths["content.customerService"] = "/views/content/pagemaster/dsp_customerService.cfm";
		viewPaths["content.customerServiceDetails"] = "/views/content/pagemaster/dsp_customerServiceDetails.cfm";
		viewPaths["content.contact"] = "/views/content/pagemaster/dsp_contact.cfm";
		viewPaths["content.howShop"] = "/views/content/pagemaster/dsp_howShop.cfm";
		viewPaths["content.rebateCenter"] = "/views/content/pagemaster/dsp_rebateCenter.cfm";
		viewPaths["content.displayDocument"] = "/views/content/pagemaster/dsp_displayDocument.cfm";
		viewPaths["content.refunds"] = "/views/content/pagemaster/dsp_refunds.cfm";
		viewPaths["content.aboutUs"] = "/views/content/pagemaster/dsp_aboutUs.cfm";
		viewPaths["content.sitemap"] = "/views/content/pagemaster/dsp_sitemap.cfm";
		viewPaths["content.viewVideo"] = "/views/content/pagemaster/dsp_viewVideo.cfm";
		viewPaths["content.activatingPhone"] = "/views/content/pagemaster/dsp_activatingPhone.cfm";
		viewPaths["content.summary"] = "/views/content/pagemaster/dsp_summary.cfm";
		viewPaths["content.earlyTermination"] = "/views/content/pagemaster/dsp_earlyTermination.cfm";
		viewPaths["content.serviceTypeOverview"] = "/views/content/pagemaster/dsp_serviceTypeOverview.cfm";
		viewPaths["content.supplychain"] = "/views/content/pagemaster/dsp_supplychain.cfm";
		// Landing pages
		viewPaths["content.SamsungGalaxys4"] = "/views/content/pagemaster/landingpages/dsp_GalaxyS4.cfm";
		viewPaths["content.TMobileInStoreOffers"] = "/views/content/pagemaster/landingpages/dsp_tmobileInStoreOffers.cfm";
		viewPaths["content.SamsungGalaxyS5"] = "/views/content/common/dsp_GalaxyS5.cfm";	
		viewPaths["content.VerizonEdge"] = "/views/content/pagemaster/landingpages/dsp_VerizonEdge.cfm";
		viewPaths["content.HTCOneM8"] = "/views/content/common/dsp_HTCOneM8.cfm";
		viewPaths["content.ATTNext"] = "/views/content/common/dsp_ATTNext.cfm";
		// emailTemplatePaths 
		viewPaths["emailTemplate.forgotPassword"] = "/views/emailTemplate/pagemaster/ForgotPassword.cfm";
		viewPaths["emailTemplate.orderCancellation"] = "/views/emailTemplate/pagemaster/OrderCancellation.cfm";
		viewPaths["emailTemplate.orderCancellationAlert"] = "/views/emailTemplate/pagemaster/OrderCancellationAlert.cfm";
		viewPaths["emailTemplate.orderConfirmation"] = "/views/emailTemplate/pagemaster/OrderConfirmation.cfm";
		viewPaths["emailTemplate.paymentExchange"] = "/views/emailTemplate/pagemaster/PaymentExchange.cfm";
		viewPaths["emailTemplate.paymentOrder"] = "/views/emailTemplate/pagemaster/PaymentOrder.cfm";		
		viewPaths["emailTemplate.returnAuthorization"] = "/views/emailTemplate/pagemaster/ReturnAuthorization.cfm";
		viewPaths["emailTemplate.upgradeNotification"] = "/views/emailTemplate/pagemaster/UpgradeNotification.cfm";
		viewPaths["emailTemplate.delayNotification"] = "/views/emailTemplate/pagemaster/DelayNotification.cfm";
				
		map("AppleCare")
			.to("cfc.model.warranty.AppleCare")
			.asSingleton();

		map("ViewPaths")
			.toValue(viewPaths)
			.asSingleton();

		map("DynamicViewRenderer")
			.to("cfc.model.system.render.DynamicViewRenderer")
			.initArg(name="ViewPaths", ref="ViewPaths")
			.asSingleton();
		
		// Taxes
		map("TaxCalculator")
			.to("cfc.model.finance.TaxCalculator")
			.initArg(name="MerchantId", value=10005331)
			.initArg(name="UserId", value="R.Linmark")
			.initArg(name="TaxServiceUrl", value=getProperty("TaxServiceUrl"))
			.initArg(name="ShipFromAddress", value=getProperty("taxShipFromAddress"))
			.asSingleton();
		
		// Analytics tracking
		map("GoogleAnalyticsTracker")
			.to("cfc.model.system.analytics.GoogleAnalytics")
			.initArg(name="GoogleAnalyticsId", value="UA-53542232-1")
			.initArg(name="DomainName", value="wasvcs.com")
			.initArg(name="UseUniversalAnalytics", value=false)
			.asSingleton();
		map("MercentAnalyticsTracker")
			.to("cfc.model.system.analytics.Mercent")
			.initArg(name="MerchantId", value="WirelessAdvocat")
			.initArg(name="ClientId", value="3293la221804")
			.asSingleton();

		// Site map
		map("SiteMap")
			.to("cfc.model.system.utility.SiteMap")
			.initArg(name="domain", value="wasvcs.com")	
			.asSingleton();
		map("RobotFileWriter")
			.to("cfc.model.system.utility.RobotFileWriter")
			.initArg(name="Domain", value="")
			.initArg(name="DisallowBots", value="true")
			.asSingleton();
					
		// Payment gateways
		/*	These values are used to register this gateway with PaymentProcessorRegistry. They can be any string, but were originally
			designed to be payment methods. "DEFAULT" can only belong to one gateway per Injector instance and is used when the
			application automatically assigned a gateway without the user selecting	a payment method. */		
		internetSecurePaymentMethods = ['DEFAULT','VISA','Mastercard','Amex','Discover'];
		map("InternetSecurePaymentGateway")
			.to("cfc.model.payment.InternetSecurePaymentGateway")
			.initArg(name="name", value="InternetSecure")
			.initArg(name="PaymentProcessorRegistry", ref="PaymentProcessorRegistry")
			.initArg(name="paymentReturnPath", value=getProperty("paymentReturnPath"))
			.initArg(name="paymentReturnPathRequiresSSL", value=getProperty("paymentReturnPathRequiresSSL"))
			.initArg(name="paymentMethods", value=internetSecurePaymentMethods)
			.initArg(name="async", value=getProperty("asyncPayments"))
			.initArg(name="processingURL", value=getProperty("internetSecure_ProcessingURL"))
			.initArg(name="gatewayID", value=getProperty("InternetSecure_PageMaster_GatewayID"))
			.initArg(name="sendCustomerEmailReceipt", value=getProperty("internetSecure_SendCustomerEmailReceipt"))
			.initArg(name="sendMerchantEmailReceipt", value=getProperty("internetSecure_SendMerchantEmailReceipt"))
			.initArg(name="appID", value=getProperty("internetSecure_AppID"))
			.initArg(name="transactionKey", value=getProperty("InternetSecure_PageMaster_TransactionKey"))
			.onDIComplete("register")
			.asEagerInit()
			.asSingleton();
			
		// Carrier integration
		//sprintCarrierEndpoints = {
		//	development = "http://dev-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL",
		//	test = "http://#HTTP_HOST#/SprintCarrierInterface/sprintservice.asmx?WSDL",
		//	stage = "http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL",
		//	production = "http://10.7.0.90/sprintcarrierinterface/sprintservice.asmx?WSDL"
		//};
		
		sprintCarrierEndpoints = {
			development = "http://#HTTP_HOST#/SprintCarrierInterface/sprintservice.asmx?WSDL",
			test = "http://#HTTP_HOST#/SprintCarrierInterface/sprintservice.asmx?WSDL",
			stage = "http://#HTTP_HOST#/SprintCarrierInterface/sprintservice.asmx?WSDL",
			production = "http://10.7.0.207/sprintcarrierinterface/sprintservice.asmx?WSDL"
		};

		map("SprintCarrierService")
			.to("cfc.model.carrierservice.Sprint.SprintCarrierService")
			.initArg(name="environment", value=getProperty("environment"))
			.initArg(name="endpointSourceMap", value=sprintCarrierEndpoints)
			.asSingleton();

		map("SprintActivationController")
			.to("admin.cfc.Controller.SprintActivationController")
			.initArg(name="SprintCarrierService", ref="SprintCarrierService")
			.asSingleton();
			
		//Page Master Campaigns
		map("CampaignService")
			.to("cfc.model.campaign.CampaignService")
			.asSingleton();
			
		// SMS
		map("SmsMessageService")
			.to("cfc.model.system.sms.SmsMessageService")
			.asSingleton();
	}
</cfscript>
</cfcomponent>
