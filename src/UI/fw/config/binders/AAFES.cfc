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
		var militaryStarPaymentMethods = {};
		var authExemptURLs = [];
		var environment = getProperty("environment");
		var analyticsID = {};
		var analyticsDomainName = {};		
		
		/**************************** WIREBOX CONFIGURATION ****************************/
		
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
		
		/****************************** MODEL MAPPINGS **********************************/
		
		// Asset paths
		assetPaths = {
			common = "/assets/common/",
			channel = "/assets/aafes/",
			admin = {
				common = "/admin/assets/common/",
				channel = "/admin/assets/aafes/"
			}
		};
		map("AssetPaths")
			.toValue( assetPaths )
			.asSingleton();
			
		// Channel config settings
		channelConfigArgs = {
			VfdEnabled = false,
			CarrierTwoYearRemoval = "109|6/1/2015",
			VFDMkey = '2pypk0NTjimlDmKCQhNF9w==',
			VFDIV = 'f+hYUyjprHt/6FhTKOmsew==',
			ScenarioDescription = 'Direct Delivery',
			ThirdPartyAuth = true,
			AllowAPOFPO = true,
			OfferShippingPromo = true,
			DisplayFreeKit = false,
			OfferWarrantyPlan =  true,
			OfferPrepaidDeviceWarrantyPlan = false,
			DefaultWarrantyPlanId = '',
			TrackMercentAnalytics = false,
			DisplayOnlineValue = false,
			AllowDifferstShippingOnNewActivations = true,
			ActivationFeeWavedByCarrier = 128,
			DisplayNoInventoryItems = true,
			DisplayZeroPricedItems = false,
			DisplayName = 'Exchange Mobile Center',
			OfferNoContractDevices = false,       // Does this channel offer ANY no contract devices
			NoContractDevices = "phone,tablet",  // If above is true, these device types offer no contract prices
			InstantRebateOfferAvailable = false,
			OfferPrepaidFreeShipping = false,
			OrderProcessingTime = 2,
			PromotionCodeAvailable = true,
			Environment = getProperty("environment"),
			DdAdminReturnFilterEnabled = {  // if enabled then only orders with status = 3 are included
				development = "false",
				test = "false",
				staging = "false",
				production = "true"			
			},
			CEXCHANGEMap = {
				development = 'http:www.google.com',
				test = 'http:www.google.com',
				staging = 'http:www.google.com',
				production = 'http:www.google.com'			
			},
			DomainNameMap = {
				development = 'http://#SERVER_NAME#',
				test = 'http://test.aafesmobile.com',
				staging = 'http://demo.aafesmobile.com',
				production = 'http://www.aafesmobile.com'			
			},
			AppleCareEnabled = "false",
			AppleCarePrefix = "MM",
			AppleCareAPIMap = {
				development = {
					url = 'http://10.7.0.140:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				test = {
					url = 'http://10.7.0.140:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				staging = {
					url = 'http://10.7.0.140:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				production = {
					url = 'http://10.7.0.140:9000',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				}			
			},
			DisplayCustomerSurveyLink = false,
			DisplayWarrantyDetailInCart = true,
			CustomerCareEmail = 'emcsupport@wirelessadvocates.com',
			CustomerCarePhone = '1 (866) 374-0804',
			DisplayPrepaidDevices = true,
			DirectToRedesignDetailsPage = true,	//Temp for 6.5.0 release
			OfferFinancedDevices = true,		
			DefaultProductSort = 'Popular',
			PresaleVerbiage = 'Presale',
			WA2GOurl = 'http://wa2gopilot.wirelessadvocates.llc/'			
			// SearchIndexMethod = "GetAll" // method within cfc.model.product.cfm to use when creating the solr search index. GetAll=All Products. GetSearchable=excludes out of stock
		};
		
		
		map("ChannelConfig")
			.to("cfc.model.config.ChannelConfig")
			.initWith(argumentCollection=channelConfigArgs)
			.asSingleton();
		
		// Display text
		textDisplayArgs = {
			businessName = 'AAFES',
			storeAliasName = 'In-Store',
			kioskName = 'Exchange Mobile Center',
			customerAliasName = 'AAFES Customer',
			gersCustomerIdPreFix = 'MM',
			cartDialogWarrantyTitle = '2-Year Protection Plan for Cell Phones',
			tMobilePriceBlockBonusOffer = 'Exclusive Military discount of 15% off monthly recurring service charge.',
			OutOfStockButtonText = "Out of Stock",
			OutOfStockAlertText = "This item is currently out of stock",
			CreditCheckCustomerIdText = "State ID",
			PriceLabelText = "Retail Price",
			Hide2YearFinancingButtonText = "Available In Select Stores Only - Learn More"
		};
		map("TextDisplayRenderer")
			.to("cfc.model.system.render.TextDisplayRenderer")
			.initWith(argumentCollection=textDisplayArgs)
			.asSingleton();
		
		// Accessory config
		/* List of FilterOptionIds for each of the Filter Categories
			Cases = 56
			Chargers & Adapters = 57
			Bluetooth = 376
			Screen Protectors = 59
			Headphones & Speakers = 58
			Batteries = 377
			Docks & Mounts = 280 */
		accessoryConfigArgs = {
			categoryOrder = "56, 57, 376, 59, 58, 377, 280",
			homePageFilterTop = "250px",
			homePageFilterTileMargin = "11px",
			homePageFilterTileMarginIE = "7px\9"
		};
		map("AccessoryConfig")
			.toValue(accessoryConfigArgs)
			.asSingleton();
			
		//View paths for Dynamic view renderer
		viewPaths["content.home"] = "/views/content/aafes/home/dsp_landing.cfm";
		viewPaths["content.phonesHome"] = "/views/content/aafes/home/dsp_landing.cfm";
		viewPaths["content.faq"] = "/views/content/aafes/dsp_faq.cfm";
		viewPaths["content.returns"] = "/views/content/aafes/dsp_returns.cfm";
		viewPaths["content.terms"] = "/views/content/aafes/dsp_terms.cfm";
		viewPaths["content.privacy"] = "/views/content/aafes/dsp_privacy.cfm";
		viewPaths["content.shipping"] = "/views/content/aafes/dsp_shipping.cfm";
		viewPaths["content.serviceAgreement"] = "/views/content/aafes/dsp_serviceAgreement.cfm";
		viewPaths["content.customerService"] = "/views/content/aafes/dsp_customerService.cfm";
		viewPaths["content.customerServiceDetails"] = "/views/content/aafes/dsp_customerServiceDetails.cfm";
		viewPaths["content.contact"] = "/views/content/aafes/dsp_contact.cfm";
		viewPaths["content.howShop"] = "/views/content/aafes/dsp_howShop.cfm";
		viewPaths["content.rebateCenter"] = "/views/content/aafes/dsp_rebateCenter.cfm";
		viewPaths["content.displayDocument"] = "/views/content/aafes/dsp_displayDocument.cfm";
		viewPaths["content.refunds"] = "/views/content/aafes/dsp_refunds.cfm";
		viewPaths["content.aboutUs"] = "/views/content/aafes/dsp_aboutUs.cfm";
		viewPaths["content.sitemap"] = "/views/content/aafes/dsp_sitemap.cfm";
		viewPaths["content.viewVideo"] = "/views/content/aafes/dsp_viewVideo.cfm";
		viewPaths["content.activatingPhone"] = "/views/content/aafes/dsp_activatingPhone.cfm";
		viewPaths["content.summary"] = "/views/content/aafes/dsp_summary.cfm";
		viewPaths["content.earlyTermination"] = "/views/content/aafes/dsp_earlyTermination.cfm";
		viewPaths["content.serviceTypeOverview"] = "/views/content/aafes/dsp_serviceTypeOverview.cfm";
		viewPaths["content.supplychain"] = "/views/content/aafes/dsp_supplychain.cfm";
		viewPaths["content.militaryDeployment"] = "/views/content/aafes/dsp_militaryDeployment.cfm";
		viewPaths["content.militaryDiscount"] = "/views/content/aafes/dsp_militaryDiscount.cfm";
		viewPaths["content.storeLocator"] = "/views/content/aafes/dsp_storeLocator.cfm";
		//Landing pages
		viewPaths["content.toolsHome"] = "/views/content/aafes/landingpages/dsp_ToolsAndResources.cfm";
		viewPaths["content.iphoneComparison"] = "/views/content/aafes/landingpages/dsp_iphoneComparison.cfm";
		viewPaths["content.SamsungGalaxys4"] = "/views/content/aafes/landingpages/dsp_GalaxyS4.cfm";
		viewPaths["content.DeviceProtection"] = "/views/content/aafes/landingpages/dsp_DeviceProtection.cfm";
		viewPaths["content.TMobileInStoreOffers"] = "/views/content/aafes/landingpages/dsp_tmobileInStoreOffers.cfm";
		viewPaths["content.SamsungGalaxyS5"] = "/views/content/common/dsp_GalaxyS5.cfm";	
		viewPaths["content.SamsungGalaxyS6"] = "/views/content/common/dsp_GalaxyS6.cfm";	
		viewPaths["content.SamsungGalaxyS6LP"] = "/views/content/aafes/landingpages/dsp_GalaxyS6LP.cfm";	
		viewPaths["content.SamsungGalaxyS6Plus"] = "/views/content/common/dsp_GalaxyS6Plus.cfm";	
		viewPaths["content.SamsungGalaxyNote5"] = "/views/content/common/dsp_GalaxyNote5.cfm";
		viewPaths["content.VerizonEdge"] = "/views/content/aafes/landingpages/dsp_VerizonEdge.cfm";
		viewPaths["content.HTCOneM8"] = "/views/content/common/dsp_HTCOneM8.cfm";
		viewPaths["content.ATTNext"] = "/views/content/common/dsp_ATTNext.cfm";
		viewPaths["content.LGG3"] = "/views/content/common/dsp_LGG3.cfm";
		viewPaths["content.iPhone"] = "/views/content/common/dsp_iPhone.cfm";
		viewPaths["content.FisherHouseFoundation"] = "/views/content/aafes/landingpages/dsp_FisherHouseFoundation.cfm";
		// emailTemplatePaths
		viewPaths["emailTemplate.forgotPassword"] = "/views/emailTemplate/aafes/ForgotPassword.cfm";
		viewPaths["emailTemplate.orderCancellation"] = "/views/emailTemplate/aafes/OrderCancellation.cfm";
		viewPaths["emailTemplate.orderCancellationAlert"] = "/views/emailTemplate/aafes/OrderCancellationAlert.cfm";
		viewPaths["emailTemplate.orderConfirmation"] = "/views/emailTemplate/aafes/OrderConfirmation.cfm";
		viewPaths["emailTemplate.paymentExchange"] = "/views/emailTemplate/aafes/PaymentExchange.cfm";
		viewPaths["emailTemplate.paymentOrder"] = "/views/emailTemplate/aafes/PaymentOrder.cfm";
		viewPaths["emailTemplate.returnAuthorization"] = "/views/emailTemplate/aafes/ReturnAuthorization.cfm";
		viewPaths["emailTemplate.upgradeNotification"] = "/views/emailTemplate/aafes/UpgradeNotification.cfm";
		viewPaths["emailTemplate.delayNotification"] = "/views/emailTemplate/aafes/DelayNotification.cfm";

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
			.initArg(name="MerchantId", value=10005125)
			.initArg(name="UserId", value="Randolph.Linmark")
			.initArg(name="TaxServiceUrl", value=getProperty("TaxServiceUrl"))
			.initArg(name="ShipFromAddress", value=getProperty("taxShipFromAddress"))
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
			.initArg(name="gatewayID", value=getProperty("internetSecure_AAFES_GatewayID"))
			.initArg(name="sendCustomerEmailReceipt", value=getProperty("internetSecure_SendCustomerEmailReceipt"))
			.initArg(name="sendMerchantEmailReceipt", value=getProperty("internetSecure_SendMerchantEmailReceipt"))
			.initArg(name="appID", value=getProperty("internetSecure_AppID"))
			.initArg(name="transactionKey", value=getProperty("internetSecure_AAFES_TransactionKey"))
			.onDIComplete("register")
			.asEagerInit()
			.asSingleton();
			
		militaryStarPaymentMethods = ['MilitaryStar'];
		map("MilitaryStarPaymentGateway")
			.to("cfc.model.payment.MilitaryStarPaymentGateway")
			.initArg(name="GeoService", ref="GeoService")
			.initArg(name="name", value="MilitaryStar")
			.initArg(name="PaymentProcessorRegistry", ref="PaymentProcessorRegistry")
			.initArg(name="paymentReturnPath", value=getProperty("paymentReturnPath"))
			.initArg(name="paymentReturnPathRequiresSSL", value=getProperty("paymentReturnPathRequiresSSL"))
			.initArg(name="paymentMethods", value=militaryStarPaymentMethods)
			.initArg(name="async", value=getProperty("asyncPayments"))
			.initArg(name="processingURL", value=getProperty("starCard_ProcessingURL"))
			.initArg(name="settleURL", value=getProperty("starCard_SettleURL"))
			.initArg(name="merchantID", value=getProperty("starCard_FacilityID"))
			.initArg(name="isTestMode", value=getProperty("starCard_isTestMode"))
			.onDIComplete("register")
			.asEagerInit()
			.asSingleton();
			
		//3rd Party Authentication
		authExemptURLs = [
			"/asyncListner/PaymentGatewayAsyncListener.cfm" // Payment Gateway Async Listener
			,"/search/scheduled_searchindex.cfm" // Scheduled task
			,"/go/checkout/do/processPayment" // Process payment from gateway 
			,"/go/checkout/do/thanks" // Order Thank you page after payment processing
			,"/tasks/UptimeMonitor.cfm" // Ping page for monitoring tool
			,"/tasks/NotificationEmail.cfm" // Auto generated update notification emails
			,"/go/checkout/do/processPaymentRedirect" // payments for exchange
		];
		map("AAFESAuth")
			.to("cfc.model.authentication.AAFESAuth")
			.initArg(name="aafesAuthUrl", value=getProperty("aafesAuthUrl"))
			.initArg(name="aafesLogoffUrl", value=getProperty("aafesLogoffUrl"))
			.initArg(name="authExemptURLs", value=authExemptURLs)
			.initArg(name="wirelessAAFESId", value=239)
			.initArg(name="campaign", value=getProperty("aafesAuthCampaign"))
			.asSingleton();

		map("AppleCare")
			.to("cfc.model.warranty.AppleCare")
			.asSingleton();

		map("MilitaryBase")
			.to("cfc.model.payment.MilitaryBase")
			.asSingleton();
		
		// USPS
		map("USPS")
			.to("fw.model.geo.USPS")
			.initArg(name="isProduction", value=getProperty("usps_isProduction"))
			.initArg(name="isSecure", value=getProperty("usps_isSecure"))
			.initArg(name="uspsUserID", value=getProperty("usps_uspsUserID"))
			.asSingleton();
		
		// Based on the environment set the appropriate Google Analytic's ID's
		// Note that domain name isn't used so don't worry about how we have IP addresses in there. We pass it in but it is not used
		switch(environment) {
	    case "development":
	         analyticsID = "UA-62686803-1";
	         analyticsDomainName = "local.aafes.wa";
	         break;
	    case "test":
	         analyticsID = "UA-62704901-1";
	         analyticsDomainName = "10.7.0.140";
	         break;
	    case "stage":
	         analyticsID = "UA-62704901-1";
	         analyticsDomainName = "10.7.0.140";
	         break;
	    case "production":
	         analyticsID = "UA-42001859-1";
	         analyticsDomainName = "aafesmobile.com";
	         break;
		}
				
		// Analytics tracking
		map("GoogleAnalyticsTracker")
			.to("cfc.model.system.analytics.GoogleAnalytics")
			.initArg(name="GoogleAnalyticsId", value=analyticsID)
			.initArg(name="DomainName", value=analyticsDomainName)
			.initArg(name="UseUniversalAnalytics", value=true)
			.asSingleton();
		map("MercentAnalyticsTracker")
			.to("cfc.model.system.analytics.Mercent")
			.initArg(name="MerchantId", value="0")
			.initArg(name="ClientId", value="0")
			.asSingleton();

		// Site map
		map("SiteMap")
			.to("cfc.model.system.utility.SiteMap")
			.initArg(name="domain", value="aafesmobile.com")	
			.asSingleton();
		map("RobotFileWriter")
			.to("cfc.model.system.utility.RobotFileWriter")
			.initArg(name="domain", value="aafesmobile.com")
			.asSingleton();
					
		// Carrier integration
		sprintCarrierEndpoints = {
			development = "http://dev-ws.ecom.corp/api/sprintcarrierservice/aafes/sprintservice.asmx?WSDL",
			test = "http://test-ws.ecom.corp/api/sprintcarrierservice/aafes/sprintservice.asmx?WSDL",
			stage = "http://test-ws.ecom.corp/api/sprintcarrierservice/aafes/sprintservice.asmx?WSDL",
			production = "TBD"
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
	}	
</cfscript>
</cfcomponent>
