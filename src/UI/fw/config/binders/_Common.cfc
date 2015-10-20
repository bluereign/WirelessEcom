<cfcomponent output="false" extends="coldbox.system.ioc.config.Binder">
<cfscript>
	
	function configure(){
		
		var channelConfigArgs = "";
		
		//DSN
		map("dsn")
			.toValue(application.dsn.wirelessAdvocates)
			.asSingleton();
		
		// Utilities/helpers
		map("StringUtil")
			.to("cfc.model.system.utility.StringUtil")
			.asSingleton();
			
		// Channel config settings
		channelConfigArgs = {
			thirdPartyAuth = false,
			allowAPOFPO = false,
			offerWarrantyCoverage = false,
			displayFreeKit = false,
			offerShippingPromo = false,
			offerWarrantyPlan =  false,
			trackMercentAnalytics = false,
			displayOnlineValue = false,
			allowDifferstShippingOnNewActivations = false,
			activationFeeWavedByCarrier = 128,
			displayName = ''
		};
		map("ChannelConfig")
			.to("cfc.model.config.ChannelConfig")
			.initWith(argumentCollection=channelConfigArgs)
			.asSingleton();
		
		// Payments
		map("PaymentProcessorRegistry")
			.to("cfc.model.payment.PaymentProcessorRegistry")
			.asEagerInit()
			.asSingleton();
		map("PaymentService")
			.to("cfc.model.payment.PaymentService")
			.asSingleton();
		
		// Promotions
		map("PromotionService")
			.to("cfc.model.promotions.PromotionService")
			.initArg(name="PromotionGateway", ref="PromotionGateway")
			.initArg(name="StringUtil", ref="StringUtil")
			.asSingleton();
		map("PromotionGateway")
			.to("cfc.model.promotions.PromotionGateway")
			.initArg(name="dsn", ref="dsn")
			.asSingleton();
		
		// Instant Rebates
		map("InstantRebateService")
			.to("cfc.model.promotions.InstantRebateService")
			.initArg(name="accessoryMinPurchaseAmt", value=29.99)
			.initArg(name="ChannelConfig", ref="ChannelConfig")
			.initArg(name="InstantRebateGateway", ref="InstantRebateGateway")
			.asSingleton();
		map("InstantRebateGateway")
			.to("cfc.model.promotions.InstantRebateGateway")
			.initArg(name="dsn", ref="dsn")
			.asSingleton();
			
		// Carrier Services

		map("RouteService")
			.to("cfc.model.carrierservice.ServiceBus.RouteService")
			.initArg(name="EndPoint", value=getProperty("CarrierServiceBus").EndPoint)
			.initArg(name="AuthSecretKey", value=getProperty("CarrierServiceBus").AuthSecretKey)
			.initArg(name="AuthPassword", value=getProperty("CarrierServiceBus").AuthPassword)
			.initArg(name="AuthUsername", value=getProperty("CarrierServiceBus").AuthUsername)
			.asSingleton();

		map("CarrierService")
			.to("fw.model.carrier.CarrierService")
			.initArg(name="endpointSourceMap", ref="RouteService")
			.asSingleton();	

		map("Carrier")
			.to("cfc.model.Carrier")
			.asSingleton();
			
		// FullAPI Carrier Services			
		
		map("CarrierFacade")
			.to("fw.model.carrierApi.CarrierFacade")
			.asSingleton();	
			
		map("AttCarrier")
			.to("fw.model.carrierApi.Att.AttCarrier")
			.initArg(name="ServiceURL", value=getProperty("Att_Carrier_Api_BaseUrl"))
			.asSingleton();	
			
		map("VzwCarrier")
			.to("fw.model.carrierApi.Verizon.VzwCarrier")
			.initArg(name="ServiceURL", value=getProperty("Vzw_Carrier_Api_BaseUrl"))
			.asSingleton();	
		
		map("MockCarrier")
			.to("fw.model.carrierApi.Mock.MockCarrier")
			.asSingleton();	
			
		map("CarrierHelper")
			.to("fw.model.carrierApi.CarrierHelper")
			.asSingleton();	
			
		map("AttCarrierHelper")
			.to("fw.model.carrierApi.Att.AttCarrierHelper")
			.initArg(name="ServiceURL", value=getProperty("Att_Carrier_Api_BaseUrl"))
			.asSingleton();	
			
		map("VzwCarrierHelper")
			.to("fw.model.carrierApi.Verizon.VzwCarrierHelper")
			.initArg(name="ServiceURL", value=getProperty("Vzw_Carrier_Api_BaseUrl"))
			.asSingleton();	
			
		map("MockCarrierHelper")
			.to("fw.model.carrierApi.Mock.MockCarrierHelper")
			.initArg(name="ServiceURL", value=getProperty("ATT_Carrier_Api_BaseUrl"))
			.asSingleton();	
		
		
			
	// Device Builder Shopping Cart		
		
		map("dBuilderCart")
			.to("fw.model.shopping.dBuilderCart")
			.asSingleton();
	
		map("dBuilderCartHelper")
			.to("fw.model.shopping.dBuilderCartHelper")			
			.asSingleton();
							
		map("dBuilderCartItem")
			.to("fw.model.shopping.dBuilderCartItem")			
			.asSingleton();

		map("dBuilderCartPriceBlock")
			.to("fw.model.shopping.dBuilderCartPriceBlock")			
			.asSingleton();

			
		map("dBuilderCartValidationResponse")
			.to("fw.model.shopping.dBuilderCartValidationResponse")			
			.asSingleton();

	// Carrier Plans
		map("PlanService")
			.to("fw.model.plan.PlanService")
			.asSingleton();	

		// Geographic
		map("GeoService")
			.to("fw.model.geo.GeoService")
			.initArg(name="AddressProvider", dsl="provider:Address")
			.initArg(name="AddressValidation", ref="AddressValidationService")
			.initArg(name="MilitaryBaseGateway", ref="MilitaryBaseGateway")
			.asSingleton();
		map("GeoGateway")
			.to("fw.model.geo.GeoGateway")
			.initArg(name="dsn", ref="dsn")
			.asSingleton();
		map("MilitaryBaseGateway")
			.to("fw.model.geo.MilitaryBaseGateway")
			.initArg(name="dsn", ref="dsn")
			.asSingleton();
		map("Address")
			.to("fw.model.geo.Address")
			.initArg(name="GeoService", ref="GeoService");
		map("AddressValidationService")
			.to("fw.model.geo.AddressValidationService")
			.asSingleton();
		map("USPS")
			.to("fw.model.geo.USPS")
			.initArg(name="isProduction", value=getProperty('usps_isProduction'))
			.initArg(name="isSecure", value=getProperty('usps_isSecure'))
			.initArg(name="uspsUserID", value=getProperty('usps_uspsUserID'))
			.asSingleton();
				
		// Security
		map("SecurityService")
			.to("fw.model.security.SecurityService")
			.initArg(name="dsn", ref="dsn")
			.initArg(name="UserGateway", ref="UserGateway")
			.asSingleton();
			
		// User
		map("User")
			.to("fw.model.user.User")
			.initArg(name="GeoService", ref="GeoService");
		map("UserService")
			.to("fw.model.user.UserService")
			.initArg(name="UserProvider", dsl="provider:User")
			.initArg(name="UserGateway", ref="UserGateway")
			.asSingleton();
		map("UserGateway")
			.to("fw.model.user.UserGateway")
			.initArg(name="dsn", ref="dsn")
			.asSingleton();

		// Notification
		map("NotificationGateway")
			.to("fw.model.notification.NotificationGateway")
			.initArg(name="dsn", ref="dsn")
			.asSingleton();
			
		map("NotificationService")
			.to("fw.model.notification.NotificationService")
			.initArg(name="NotificationGateway", ref="NotificationGateway")
			.asSingleton();
		// Products
		
		map("ProductService")
			.to("fw.model.product.ProductService")
			.initArg(name="dsn", ref="dsn")
			.asSingleton();	
			
			
		//Filters
		map("PhoneFilter")
			.to("cfc.model.filter.PhoneFilter")
			.initArg(name="queryCacheSpan", value=getProperty('filterQueryCacheSpan'))
			.asSingleton();

		map("PrepaidFilter")
			.to("cfc.model.filter.PrepaidFilter")
			.asSingleton();	

		map("TabletFilter")
			.to("cfc.model.filter.TabletFilter")
			.asSingleton();

		map("DataCardAndNetBookFilter")
			.to("cfc.model.filter.DataCardAndNetBookFilter")
			.asSingleton();
			
		map("PlanFilter")
			.to("cfc.model.filter.PlanFilter")
			.initArg(name="queryCacheSpan", value=getProperty('filterQueryCacheSpan'))
			.asSingleton();

		map("AccessoryFilter")
			.to("cfc.model.filter.AccessoryFilter")
			.asSingleton();
			
		map("FilterHelper")
			.to("cfc.model.filter.FilterHelper")
			.asSingleton();
			
		map("FilterOption")
			.to("cfc.model.filter.FilterOption")
			.asSingleton();			
			
	}
</cfscript>
</cfcomponent>
