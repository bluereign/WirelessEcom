<cfcomponent output="true" extends="coldbox.system.ioc.config.Binder">

<cfscript>
	function configure(){
		
		var assetPaths = {};
		var viewPaths = {};
		var channelConfigArgs = {};
		var textDisplayArgs = {};
		var accessoryConfigArgs = {};
		var internetSecurePaymentMethods = {};
		var sprintCarrierEndpoints = {};
		var googleAnalytics = {};
		var environment = getProperty("environment");
		var analyticsID = {};
		var analyticsDomainName = {};
				
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
			channel = "/assets/costco/",
			admin = {
				common = "/admin/assets/common/",
				channel = "/admin/assets/costco/"
			}
		};
		map("AssetPaths")
			.toValue( assetPaths )
			.asSingleton();
			
		// Channel config settings
		channelConfigArgs = {
			VfdEnabled = true,
			CarrierTwoYearRemoval = "109|6/1/2015",
			VFDMkey = '2pypk0NTjimlDmKCQhNF9w==',
			VFDIV = 'f+hYUyjprHt/6FhTKOmsew==',
			ScenarioDescription = 'Direct Delivery',
			ThirdPartyAuth = false,
			AllowAPOFPO = false,
			OfferWarrantyCoverage = false,
			DisplayFreeKit = true,
			OfferShippingPromo = false,
			OfferWarrantyPlan =  true,
			OfferPrepaidDeviceWarrantyPlan = false,
			TrackMercentAnalytics = true,
			DisplayOnlineValue = true,
			ActivationFeeWavedByCarrier = '',
			DisplayNoInventoryItems = true,
			DisplayZeroPricedItems = false,
			DisplayName = 'Costco Wireless',
			OfferNoContractDevices = true,		// Does this channel offer ANY no contract devices
			NoContractDevices = "tablet",		// If above is true, these device types offer no contract prices
			OfferPrepaidFreeShipping = true,
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
				development = 'http://costco.testcloud.com:8095',
				test = ' http://costco.testcloud.com:8095',
				staging = 'http://costco.cexchange.com',
				production = 'http://costco.cexchange.com'			
			},
			DomainNameMap = {
				development =  'http://#SERVER_NAME#',
				test = 'http://10.7.0.80',
				staging = 'http://10.7.0.80:81',
				production = 'http://www.membershipwireless.com'			
			},
			AppleCareEnabled = "true",
			AppleCarePrefix = "EC",
			AppleCareAPIMap = {
				development = {
					// url = 'http://demo-acservice.wasvcs.com/',
					url = 'http://aafes-uty-01.ecom.corp:9200',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				test = {
					url = 'http://aafes-uty-01.ecom.corp:9200',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				staging = {
					url = 'http://aafes-uty-01.ecom.corp:9200',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				},
				production = {
					url = 'http://acservice.wasvcs.com',
					username = 'testuser',
					password = 'testuser',
					enabled = true
				}		
			},
			DisplayCustomerSurveyLink = false,
			DisplayWarrantyDetailInCart = true,
			CustomerCareEmail = 'CostcoOnlineSupport@wirelessadvocates.com',
			CustomerCarePhone = '1 (888) 369-5931',
			DisplayPrepaidDevices = true,
			OfferFinancedDevices = true,
			DirectToRedesignDetailsPage = true,		//Temp for 6.5.0 release
			DefaultProductSort = 'Popular',
			TMORedirectEnabled = true ,
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
			BusinessName = 'Costco Wireless',
			StoreAliasName = 'Warehouse',
			KioskName = 'Costco Wireless Kiosk',
			CustomerAliasName = 'Costco Member',
			GersCustomerIdPreFix = 'EC',
			//CartDialogWarrantyTitle = '2-Year Drops &amp; Spills Protection for Cell Phones',
			CartDialogWarrantyTitle = 'Select a Protection Plan for Your Device',
			TmobilePriceBlockBonusOffer = '$25 Costco Cash Card via Mail-in Rebate with activation of a financed device.',
			OutOfStockButtonText = "Out of Stock",
			OutOfStockAlertText = "This item will be available soon",
			CreditCheckCustomerIdText = "State ID",
			PriceLabelText = "Price",
			Hide2YearFinancingButtonText = "Available in Select Warehouses Only - Learn More"
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
		viewPaths["content.home"] = "/views/content/costco/home/dsp_landing.cfm";
		viewPaths["content.phonesHome"] = "/views/content/costco/home/dsp_landing.cfm";
		viewPaths["content.plansHome"] = "/views/content/costco/home/dsp_landing.cfm";
		viewPaths["content.accessoriesHome"] = "/views/content/costco/home/dsp_landing.cfm";
		viewPaths["content.faq"] = "/views/content/costco/dsp_faq.cfm";
		viewPaths["content.returns"] = "/views/content/costco/dsp_returns.cfm";
		viewPaths["content.terms"] = "/views/content/costco/dsp_terms.cfm";
		viewPaths["content.privacy"] = "/views/content/costco/dsp_privacy.cfm";
		viewPaths["content.shipping"] = "/views/content/costco/dsp_shipping.cfm";
		viewPaths["content.serviceAgreement"] = "/views/content/costco/dsp_serviceAgreement.cfm";
		viewPaths["content.customerService"] = "/views/content/costco/dsp_customerService.cfm";
		viewPaths["content.customerServiceDetails"] = "/views/content/costco/dsp_customerServiceDetails.cfm";
		viewPaths["content.contact"] = "/views/content/costco/dsp_contact.cfm";
		viewPaths["content.howShop"] = "/views/content/costco/dsp_howShop.cfm";
		viewPaths["content.rebateCenter"] = "/views/content/costco/dsp_rebateCenter.cfm";
		viewPaths["content.displayDocument"] = "/views/content/costco/dsp_displayDocument.cfm";
		viewPaths["content.refunds"] = "/views/content/costco/dsp_refunds.cfm";
		viewPaths["content.aboutUs"] = "/views/content/costco/dsp_aboutUs.cfm";
		viewPaths["content.sitemap"] = "/views/content/costco/dsp_sitemap.cfm";
		viewPaths["content.viewVideo"] = "/views/content/costco/dsp_viewVideo.cfm";
		viewPaths["content.activatingPhone"] = "/views/content/costco/dsp_activatingPhone.cfm";
		viewPaths["content.summary"] = "/views/content/costco/dsp_summary.cfm";
		viewPaths["content.earlyTermination"] = "/views/content/costco/dsp_earlyTermination.cfm";
		viewPaths["content.serviceTypeOverview"] = "/views/content/costco/dsp_serviceTypeOverview.cfm";
		viewPaths["content.supplychain"] = "/views/content/costco/dsp_supplychain.cfm";
		viewPaths["content.militaryDeployment"] = "/views/content/costco/dsp_militaryDeployment.cfm";
		viewPaths["content.militaryDiscount"] = "/views/content/costco/dsp_militaryDiscount.cfm";
		viewPaths["content.storeLocator"] = "/views/content/costco/dsp_storeLocator.cfm";
		// Landing pages
		viewPaths["content.SamsungGalaxys4"] = "/views/content/costco/landingpages/dsp_GalaxyS4.cfm";
		viewPaths["content.TMobileInStoreOffers"] = "/views/content/costco/landingpages/dsp_tmobileInStoreOffers.cfm";
		viewPaths["content.SamsungGalaxyS5"] = "/views/content/common/dsp_GalaxyS5.cfm";	
		viewPaths["content.SamsungGalaxyS6"] = "/views/content/common/dsp_GalaxyS6.cfm";	
		viewPaths["content.SamsungGalaxyS6LP"] = "/views/content/costco/landingpages/dsp_GalaxyS6LP.cfm";	
		viewPaths["content.SamsungGalaxyS6Plus"] = "/views/content/common/dsp_GalaxyS6Plus.cfm";	
		viewPaths["content.SamsungGalaxyNote5"] = "/views/content/common/dsp_GalaxyNote5.cfm";	
		viewPaths["content.VerizonEdge"] = "/views/content/costco/landingpages/dsp_VerizonEdge.cfm";
		viewPaths["content.HTCOneM8"] = "/views/content/common/dsp_HTCOneM8.cfm";
		viewPaths["content.ATTNext"] = "/views/content/common/dsp_ATTNext.cfm";
		viewPaths["content.LGG3"] = "/views/content/common/dsp_LGG3.cfm";
		viewPaths["content.iPhone"] = "/views/content/common/dsp_iPhone.cfm";
		// emailTemplatePaths 
		viewPaths["emailTemplate.forgotPassword"] = "/views/emailTemplate/costco/ForgotPassword.cfm";
		viewPaths["emailTemplate.orderCancellation"] = "/views/emailTemplate/costco/OrderCancellation.cfm";
		viewPaths["emailTemplate.orderCancellationAlert"] = "/views/emailTemplate/costco/OrderCancellationAlert.cfm";
		viewPaths["emailTemplate.orderConfirmation"] = "/views/emailTemplate/costco/OrderConfirmation.cfm";
		viewPaths["emailTemplate.paymentExchange"] = "/views/emailTemplate/costco/PaymentExchange.cfm";
		viewPaths["emailTemplate.paymentOrder"] = "/views/emailTemplate/costco/PaymentOrder.cfm";		
		viewPaths["emailTemplate.returnAuthorization"] = "/views/emailTemplate/costco/ReturnAuthorization.cfm";
		viewPaths["emailTemplate.upgradeNotification"] = "/views/emailTemplate/costco/UpgradeNotification.cfm";
		viewPaths["emailTemplate.delayNotification"] = "/views/emailTemplate/costco/DelayNotification.cfm";
		viewPaths["emailTemplate.tmonotification"] = "/views/emailTemplate/costco/TMONotification.cfm";

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
			.initArg(name="MerchantId", value=10005056)
			.initArg(name="UserId", value="DougSalcedo")
			.initArg(name="TaxServiceUrl", value=getProperty("TaxServiceUrl"))
			.initArg(name="ShipFromAddress", value=getProperty("taxShipFromAddress"))
			.asSingleton();

		// Based on the environment set the appropriate Google Analytic's ID's
		// Note that domain name isn't used so don't worry about how we have IP addresses in there. We pass it in but it is not used
		switch(environment) {
	    case "development":
	         analyticsID = "UA-61932436-1";
	         analyticsDomainName = "local.costco.wa";
	         break;
	    case "test":
	         analyticsID = "UA-61908522-1";
	         analyticsDomainName = "10.7.0.80";
	         break;
	    case "stage":
	         analyticsID = "UA-61908522-1";
	         analyticsDomainName = "10.7.0.80";
	         break;
	    case "production":
	         analyticsID = "UA-20996841-1";
	         analyticsDomainName = "membershipwireless.com";
	         break;
		}
			
		// Analytics tracking
		map("GoogleAnalyticsTracker")
			.to("cfc.model.system.analytics.GoogleAnalytics")
			.initArg(name="GoogleAnalyticsId", value=analyticsID)
			.initArg(name="DomainName", value=analyticsDomainName)
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
			.initArg(name="domain", value="membershipwireless.com")	
			.asSingleton();
		map("RobotFileWriter")
			.to("cfc.model.system.utility.RobotFileWriter")
			.initArg(name="domain", value="membershipwireless.com")
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
			.initArg(name="gatewayID", value=getProperty("internetSecure_Costco_GatewayID"))
			.initArg(name="sendCustomerEmailReceipt", value=getProperty("internetSecure_SendCustomerEmailReceipt"))
			.initArg(name="sendMerchantEmailReceipt", value=getProperty("internetSecure_SendMerchantEmailReceipt"))
			.initArg(name="appID", value=getProperty("internetSecure_AppID"))
			.initArg(name="transactionKey", value=getProperty("internetSecure_Costco_TransactionKey"))
			.onDIComplete("register")
			.asEagerInit()
			.asSingleton();
			


			
		// Carrier integration
		sprintCarrierEndpoints = {
			development = "http://dev-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL",
			test = "http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL",
			stage = "http://test-ws.ecom.corp/api/sprintcarrierservice/costco/sprintservice.asmx?WSDL",
			production = "http://10.7.0.90/sprintcarrierinterface/sprintservice.asmx?WSDL"
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
