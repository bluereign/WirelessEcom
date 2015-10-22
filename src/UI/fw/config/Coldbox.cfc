<cfcomponent output="false" hint="My App Configuration">
	
<cfscript>
/**
structures/arrays to create for configuration

- coldbox (struct)
- settings (struct)
- conventions (struct)
- environments (struct)
- ioc (struct)
- debugger (struct)
- mailSettings (struct)
- i18n (struct)
- webservices (struct)
- datasources (struct)
- layoutSettings (struct)
- layouts (array of structs)
- cacheBox (struct)
- interceptorSettings (struct)
- interceptors (array of structs)
- modules (struct)
- logBox (struct)
- flash (struct)
- orm (struct)
- validation (struct)

Available objects in variable scope
- controller
- logBoxConfig
- appMapping (auto calculated by ColdBox)

Required Methods
- configure() : The method ColdBox calls to configure the application.
Optional Methods
- detectEnvironment() : If declared the framework will call it and it must return the name of the environment you are on.
- {environment}() : The name of the environment found and called by the framework.

*/

	// Configure ColdBox Application
	function configure(){
		
		var channelName = getChannelName();
		var binderFullName = getBinderFile();
		var testEnv = "";
		var stageEnv = "";
		var prodEnv = "";
		var pagemasterEnv = '';
		
		// coldbox directives
		coldbox = {
			
			//Application Setup
			appName 				= getChannelName() & "-ECOM",
	
			//Development Settings
			debugMode				= false,
			debugPassword			= "gQZZ7QmYjvYf22LMkVTB", //Override per environment
			reinitPassword			= "BdIsSAr2Te1zDTx4A8Pw", //Override per environment
			handlersIndexAutoReload = true,
	
			//Implicit Events
			defaultEvent			= "",
			requestStartHandler		= "",
			requestEndHandler		= "",
			applicationStartHandler = "",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "",
			missingTemplateHandler	= "Main.PageNotFound",
	
			//Error/Exception Handling
			exceptionHandler		= "Main.HandleException",
			onInvalidEvent			= "Main.PageNotFound",
			customErrorTemplate		= "",
	
			//Application Aspects
			handlerCaching 			= false,
			eventCaching			= false
			
		};
		
		conventions = {
			layoutsLocation = 'layouts/' & getChannelName()
		};
		
		// Email
		mailSettings = {
			type = 'html'
		};		
		
		// Interceptors 
		interceptors = [
			// SES URLs
			{	class="coldbox.system.interceptors.SES"  },
			{ 	class="coldbox.system.interceptors.ApplicationSecurity"},
			//ValidateThis
			{	class="validatethis.extras.coldbox.ColdBoxValidateThisInterceptor",
				properties = {
					// Tell VT that I want to use a customised version of ValidateThis.util.Result (optional)
					ResultPath="fw.model.ValidationResult",
					// Tell VT that I want to use a customised version of ValidateThis.core.BOValidator (optional)
					boValidatorPath="fw.model.BOValidator",
					// Turn on debugging so we can get information about which rules/conditions passed/failed (optional)
					debuggingMode="info",
					// Find validation definitions/directives
					definitionPath = "/fw/model/Validation/directives",
					defaultFailureMessagePrefix = ""
				}
			},
			{	class="cfc.model.system.utility.Deploy",
				properties={
					tagFile = "/fw/config/_deploy.tag",
					deployCommandObject = "cfc.model.system.utility.DeployCommand"
				}
			}
		];
		
		// Wirebox
		wirebox = {
			binder = binderFullName
		};
		
		// Flash persistence
		flash = {
			inflateToPRC = true
		};
		
		// Custom settings
		settings = {
			
			// Core configs
			filterQueryCacheSpan = CreateTimeSpan(0,0,10,0),
			//otherItemsLineNumber = "999",
			
			
			messagebox_style_override = true,
			
			channelName = channelName,
			dsn = "wirelessadvocates",
			
			// Email addresses
			errorMailAddresses = {
				from = 'support@wirelessadvocates.com',
				to = 'DL-WA ECOM SYS ERRORS <waecomsyserrors@wirelessadvocates.com>'
			},
			
			//Carrier Services

			CarrierServiceBus = {
				Endpoint = 'http://205.138.175.121/ServiceBus.DTS/json/syncreply',
				AuthSecretKey = 'tqkPA2yBGxxESl4hdtKJ+Q==',
				AuthUsername = '2SY8K/arWpfLS2vVyFZVoQ==', //'SANwZXTN3Kg=';
				AuthPassword = 'rTo0DGnwPuuq3Z2iilIQvw=='
			},

			
			// Payments
			asyncPayments = false,
			paymentReturnpath = "/CheckoutDB/processPayment",
			paymentReturnPathRequiresSSL = false,
	
			// InternetSecure
			internetSecure_ProcessingURL = "https://test.internetsecure.com/process.cgi",
			internetSecure_SendCustomerEmailReceipt = "Y", // N=None, A=Approvals only, D=Decines only, Y=all receipts
			internetSecure_SendMerchantEmailReceipt = "Y", // N=None, A=Approvals only, D=Decines only, Y=all receipts) -->
			internetSecure_AppID = "TESTUSER",
			
			internetSecure_Costco_GatewayID = 90051,
			InternetSecure_Costco_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1",
			
			internetSecure_AAFES_GatewayID = 90051,
			internetSecure_AAFES_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1",
			
			internetSecure_PageMaster_GatewayID = 90051,
			internetSecure_PageMaster_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1",
			
			// Taxes
			taxServiceUrl = 'http://taxrequest.exactor.com/request/xml',
			
			// The "from" shipping address for shipping & tax calculations (Set to SHQ Address)
			taxShipFromAddress = createobject('component', 'cfc.model.Address').init(
				AddressLine1 = '2101 4th Avenue ##1250',
				AddressLine2 = '',
				City = 'Seattle',
				State = 'WA',
				ZipCode = '98121',
				ZipCodeExtension = '2323',
				Country = 'US'
			),

	
			// VirtualMerchant
			virtualMerchant_ProcessingURL = "https://demo.myvirtualmerchant.com/VirtualMerchantDemo/process.do",
	
			// MilitarStar
			starCard_IsTestMode = true,
			starCard_FacilityID = 37891579,
	
			// USPS API
			usps_isProduction = true, // False is only to test the API communications - not to test actual address validations
			usps_isSecure = false,
			usps_uspsUserID = "792WIREL4727"
	
		};
		
		//Declare environments
		developmentEnv = [
			"^local\.aafes\.wa",
			"^local\.costco\.wa",
			"^local\.vfd\.aafes\.wa",
			"^local\.vfd\.costco\.wa",
			"^(.*)local\.pagemaster.wa",
			"^scott\.aafesmobile\.com",
			"^local\.vfd.\costco\.com",
			"^local\.vfd.\aafes\.com",
      "^local\.fullapi\.costco\.wa",
      		"^local\.fullapi\.wa",
			
			//DEV AT&T Next Branches
			"^local\.costco\.attnext\.wa",
			"^local\.aafes\.attnext\.wa",
			"^local\.pagemaster\.attnext\.wa"
		];
		
		testEnv = [
		  "^10\.7\.0\.140:9000$",			//Test AT&T Next Branch
		  "^10\.7\.0\.140$",				//Test AAFES
		  "^10\.7\.0\.141$",				//Test PageMaster
		  "^10\.7\.0\.142$",				// VFD AAFES
		  "^10\.7\.0\.143$",				// VFD Costco
		  "^10\.7\.0\.144$",				//Test Costco
		  "^10\.7\.0\.80$",					//Test Costco (alternate legacy ip for cms)
		  "^test\.aafesmobile\.com",		//Test AAFES
		  "^(.*)-demo\.wasvcs\.com",		//Test PageMaster
		  "^Costco\.Ecom-dev-test-1\.enterprise\.corp",		//Test Costco
		  "^Aafes\.Ecom-dev-test-1\.enterprise\.corp",		//Test AAFES
		  "^Pagemaster\.Ecom-dev-test-1\.enterprise\.corp",		//Test PageMaster
		  "^CostcoVfd\.Ecom-dev-test-1\.enterprise\.corp",		//Test CostcoVfd
		  "^AafesVfd\.Ecom-dev-test-1\.enterprise\.corp",		//Test AAFESVfd
		  "^PagemasterVfd\.Ecom-dev-test-1\.enterprise\.corp",		//Test PageMasterVfd
		  "^Costco\.Ecom-dev-test-2\.enterprise\.corp",		//Test Costco
		  "^Aafes\.Ecom-dev-test-2\.enterprise\.corp",		//Test AAFES
		  "^Pagemaster\.Ecom-dev-test-2\.enterprise\.corp",		//Test PageMaster
		  "^CostcoVfd\.Ecom-dev-test-2\.enterprise\.corp",		//Test CostcoVfd
		  "^AafesVfd\.Ecom-dev-test-2\.enterprise\.corp",		//Test AAFESVfd
		  "^PagemasterVfd\.Ecom-dev-test-2\.enterprise\.corp",		//Test PageMasterVfd
		  "^Costco\.Ecom-dev-test-3\.enterprise\.corp",		//Test Costco
		  "^Aafes\.Ecom-dev-test-3\.enterprise\.corp",		//Test AAFES
		  "^Pagemaster\.Ecom-dev-test-3\.enterprise\.corp",		//Test PageMaster
		  "^CostcoVfd\.Ecom-dev-test-3\.enterprise\.corp",		//Test CostcoVfd
		  "^AafesVfd\.Ecom-dev-test-3\.enterprise\.corp",		//Test AAFESVfd
		  "^PagemasterVfd\.Ecom-dev-test-3\.enterprise\.corp",		//Test PageMasterVfd
		  "^68\.64\.53\.109$"			//Test AAFES
  ];

  stageEnv = [
  "^10\.7\.0\.80:81$",
  "^10\.7\.0\.150$",
  "^demo.aafesmobile.com"
  ];

  prodEnv = [
  // Costco
  "^www.membershipwireless.com",	//Prod domain
  "^membershipwireless.com",		//Prod domain
  "^10\.7\.0\.90",				//Prod 1 Instance-Default
  "^10\.7\.0\.91",				//Prod 1 Instance-A
  "^10\.7\.0\.100",				//Prod 2 Instance-Default
  "^10\.7\.0\.101",				//Prod 2 Instance-A
  "^10\.7\.0\.110",				//Prod 3 Instance-Default
  "^10\.7\.0\.111",				//Prod 3 Instance-A
  "^10\.7\.0\.120",				//Prod 4 Instance-Default
  "^10\.7\.0\.121",				//Prod 4 Instance-A
  "^10\.7\.0\.85",				//Prod OMT
  "^10\.7\.0\.221:85",			//Prod OMT (Utility Box)
  "^10\.7\.0\.132",				//Prod 1 VFD_Costco_PROD_A
  "^10\.7\.0\.133",				//Prod 1 VFD_Costco_PROD_B
  "^10\.7\.0\.134",				//Prod 2 VFD_Costco_PROD_A
  "^10\.7\.0\.135",				//Prod 2 VFD_Costco_PROD_B
  "^10\.7\.0\.136",				//Prod 3 VFD_Costco_PROD_A
  "^10\.7\.0\.137",				//Prod 3 VFD_Costco_PROD_B
  "^10\.7\.0\.138",				//Prod 4 VFD_Costco_PROD_A
  "^10\.7\.0\.139",				//Prod 4 VFD_Costco_PROD_B

  // AAFES
  "^www.aafesmobile.com",			//Prod domain
  "^aafesmobile.com",				//Prod domain
  "^10\.7\.0\.171",				//Prod 1 Instance-A
  "^10\.7\.0\.172",				//Prod 1 Instance-B
  "^10\.7\.0\.181",				//Prod 2 Instance-A
  "^10\.7\.0\.182",				//Prod 2 Instance-B
  "^10\.7\.0\.191",				//Prod 3 Instance-A
  "^10\.7\.0\.192",				//Prod 3 Instance-B
  "^10\.7\.0\.201",				//Prod 4 Instance-A
  "^10\.7\.0\.202",				//Prod 4 Instance-B
  "^10\.7\.0\.220",				//Prod OMT
  "^10\.7\.0\.151",				//Prod 1 VFD_AAFES_PROD_A
  "^10\.7\.0\.152",				//Prod 1 VFD_AAFES_PROD_B
  "^10\.7\.0\.153",				//Prod 2 VFD_AAFES_PROD_A
  "^10\.7\.0\.154",				//Prod 2 VFD_AAFES_PROD_B
  "^10\.7\.0\.155",				//Prod 3 VFD_AAFES_PROD_A
  "^10\.7\.0\.156",				//Prod 3 VFD_AAFES_PROD_B
  "^10\.7\.0\.157",				//Prod 4 VFD_AAFES_PROD_A
  "^10\.7\.0\.158",				//Prod 4 VFD_AAFES_PROD_B
  // PageMaster
  "^(.*)^(?!demo)\.wasvcs\.com",	//Prod wildcard subdomain
  "^10\.7\.0\.207",				//Prod 1 Instance-A
  "^10\.7\.0\.208",				//Prod 1 Instance-B
  "^10\.7\.0\.211",				//Prod 2 Instance-A
  "^10\.7\.0\.212",				//Prod 2 Instance-B
  "^10\.7\.0\.215",				//Prod 3 Instance-A
  "^10\.7\.0\.216",				//Prod 3 Instance-B
  "^10\.7\.0\.218",				//Prod 4 Instance-A
  "^10\.7\.0\.219",				//Prod 4 Instance-B
  "^10\.7\.0\.221:86",			//Prod OMT
  // Master OMT
  "^10\.7\.0\.221"				//Prod MasterOMT
  ];

  pagemasterEnv = [
  ".*\.local\.pagemaster.wa",
  ".*\.local\.pagemaster\.pagemaster.wa",
  ".*\.wasvcs\.com",
  "^10\.7\.0\.220"
  ];

  environments = {
  //pagemaster		= arrayToList(pagemasterEnv), //TODO: Ask Denny what this is for and if can be removed?
  development		= arrayToList(developmentEnv),
  test 			= arrayToList(testEnv),
  staging 		= arrayToList(stageEnv),
  production 		= arrayToList(prodEnv)
  };

  }

  function development(){

  coldbox.debugMode = false;

  // Mail
  settings.errorMailAddresses.to = 'shamilton@wirelessadvocates.com';

  //Caching
  coldbox.reinitPassword = "1";
  settings.aafesAuthURL = "http://www.shopmyexchange.com/signin-redirect?loc=http://aafesmobile.com";
  //settings.aafesLogoffURL = "https://shop.aafes.com/shop/Logout.aspx";
  settings.aafesLogoffURL = "https://www.shopmyexchange.com/?DPSLogout=true";
  settings.aafesAuthCampaign = "utm_source=aafes&utm_medium=exchangelogin&utm_campaign=authenticationredirect";

	settings.internetSecure_Costco_GatewayID = 90051;
	settings.InternetSecure_Costco_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1";
				
	settings.internetSecure_AAFES_GatewayID = 90051;
	settings.internetSecure_AAFES_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1";
				
	settings.internetSecure_PageMaster_GatewayID = 90051;
	settings.internetSecure_PageMaster_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1";

  // MilitaryStar
  settings.starCard_ProcessingURL = "https://payment.aafesmobile.com/scinssdev/scinss";
  settings.starCard_SettleURL = "https://payment.aafesmobile.com/scinssdev/api/settle";

  // Core configs
  settings.filterQueryCacheSpan = CreateTimeSpan(0,0,0,0);
  
	//Carrier FULL API
	settings.Att_Carrier_Api_BaseUrl = "http://DEV-ECOM-SBUS-1.enterprise.corp/AttCarrierService/api";
	settings.Vzw_Carrier_Api_BaseUrl = "http://205.138.175.122/Wireless.test.Verizon/V1/api";

  }

  function test() {

  //Caching
  coldbox.reinitPassword = "test";
  settings.aafesAuthURL = "http://www.shopmyexchange.com/signin-redirect?loc=http://test.aafesmobile.com";
  settings.aafesLogoffURL = "https://www.shopmyexchange.com/?DPSLogout=true";
  settings.aafesAuthCampaign = "utm_source=aafes&utm_medium=exchangelogin&utm_campaign=authenticationredirect";
  
	settings.internetSecure_Costco_GatewayID = 90051;
	settings.InternetSecure_Costco_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1";
				
	settings.internetSecure_AAFES_GatewayID = 90051;
	settings.internetSecure_AAFES_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1";
				
	settings.internetSecure_PageMaster_GatewayID = 90051;
	settings.internetSecure_PageMaster_TransactionKey = "NTVCQkZGNzI2MDdFQzQwMDc1M0EzMDc1";

		
		// MilitaryStar
		settings.starCard_ProcessingURL = "https://payment.aafesmobile.com/scinssdev/scinss";
		settings.starCard_SettleURL = "https://payment.aafesmobile.com/scinssdev/api/settle";
		
		// Core configs
		settings.filterQueryCacheSpan = CreateTimeSpan(0,0,0,0);		
		
		//Carrier FULL API
	settings.Att_Carrier_Api_BaseUrl = "http://205.138.175.122/Wireless.test.ATT/V1/api";
	settings.Vzw_Carrier_Api_BaseUrl = "http://205.138.175.122/Wireless.test.Verizon/V1/api";
		
	}
	
	function staging() {
		
		//Caching
		coldbox.reinitPassword = "stage";
		settings.aafesAuthURL = "http://www.shopmyexchange.com/signin-redirect?loc=http://demo.aafesmobile.com";
		settings.aafesLogoffURL = "https://www.shopmyexchange.com/?DPSLogout=true";
		settings.aafesAuthCampaign = "utm_source=aafes&utm_medium=exchangelogin&utm_campaign=authenticationredirect";
		
		// MilitaryStar
		settings.starCard_ProcessingURL = "https://payment.aafesmobile.com/scinssqa/scinss";
		settings.starCard_SettleURL = "https://payment.aafesmobile.com/scinssqa/api/settle";
		
		// Core configs
		settings.filterQueryCacheSpan = CreateTimeSpan(0,0,10,0);
		
		//Carrier FULL API
	settings.Att_Carrier_Api_BaseUrl = "http://DEV-ECOM-SBUS-1.enterprise.corp/AttCarrierService/api";
	settings.Vzw_Carrier_Api_BaseUrl = "http://205.138.175.122/Wireless.test.Verizon/V1/api";
	}
	
	function production() {
		
		//Caching
		coldbox.reinitPassword = "T42ses}b.kNqe17UTRWgao";
	
		// Payment Gateways
		settings.asyncPayments = true; 
		settings.paymentReturnPathRequiresSSL = true;
	
		// InternetSecure
		settings.internetSecure_ProcessingURL = "https://secure.internetsecure.com/process.cgi";
		settings.internetSecure_SendCustomerEmailReceipt = "N"; 
		settings.internetSecure_AppID = "PRODUSER";
	
		settings.InternetSecure_Costco_GatewayID = 50725;
		settings.InternetSecure_Costco_TransactionKey = "OTQxNkI3M0I5QjZDNzlDQjM5MzVCQjI0";
	
		settings.InternetSecure_AAFES_GatewayID = 64449; 
		settings.InternetSecure_AAFES_TransactionKey = "NUYyM0IwQ0E2QjQwRUNFNDg0MjkwMzAz";
		
		settings.InternetSecure_PageMaster_GatewayID = 66762;
		settings.InternetSecure_PageMaster_TransactionKey = "NkMwMkE5RUJCQzg3MjgxOTc3NkE4REI5";
		
		// AAFES Authentication
		settings.aafesAuthUrl = "http://www.shopmyexchange.com/signin-redirect?loc=http://aafesmobile.com";
		settings.aafesLogoffURL = "https://www.shopmyexchange.com/?DPSLogout=true";
		settings.aafesAuthCampaign = "utm_source=aafes&utm_medium=exchangelogin&utm_campaign=authenticationredirect";
	
		// MilitarStar
		settings.StarCard_ProcessingURL = "https://payment.aafesmobile.com/scinss";
		settings.StarCard_SettleURL = "https://payment.aafesmobile.com/api/settle";
		settings.StarCard_IsTestMode = false;
		settings.StarCard_FacilityID = 37921597;
		
		// MilitaryStar (FOR TESTING ONLY)
		// settings.starCard_ProcessingURL = "https://payment.aafesmobile.com/scinssdev/scinss";
		// settings.starCard_SettleURL = "https://payment.aafesmobile.com/scinssdev/api/settle";
		// FOR TESTING ONLY
		
		
		// Core configs
		settings.filterQueryCacheSpan = CreateTimeSpan(0,0,10,0);		
		
		//Carrier FULL API
	settings.Att_Carrier_Api_BaseUrl = "http://DEV-ECOM-SBUS-1.enterprise.corp/AttCarrierService/api";
	settings.Vzw_Carrier_Api_BaseUrl = "http://205.138.175.122/Wireless.test.Verizon/V1/api";
		
	}

	function pagemaster() {

		// define the IsValidCampaign interceptor
		var pagemasterConfig = { class="fw.interceptors.IsValidCampaign" };
		// add the interceptor 
		arrayAppend( interceptors, pagemasterConfig );
		coldbox.reinitPassword = "pm";

	}

</cfscript>

	<cffunction name="getChannelName" access="private" output="false" returntype="string" hint="Returns a channel name used for paths and logic that is channel-specific">
		<cfscript>
			var configPath = expandPath('/wirelessadvocates_config');
			var channelNamePos = listLen(configPath,"\")-1;
			var channelName = listGetAt( configPath, channelNamePos, "\" );
			return channelName;
		</cfscript>
	</cffunction>
	
	<cffunction name="getBinderFile" access="private" output="false" returntype="string" hint="Returns a channel name used for paths and logic that is channel-specific">
		<cfset sf = CreateObject("java", "coldfusion.server.ServiceFactory")>
		<cfset mapping = "/binderFile">
		<cfset mappings = sf.runtimeService.getMappings()>
		
		<cfif structKeyExists(mappings, mapping)>
			<cfset binderPath = expandPath('/binderFile')>
			<cfset binderNamePos = listLen(binderPath,"\")>
			<cfset binderName = listGetAt( binderPath, binderNamePos, "\" )>
			<cfset bindernameLength = len(binderName)>
			<cfset binderName = Left(binderName,bindernameLength-4)>
			<cfset binderFullName = "fw.config.binders.#binderName#">
			<cfreturn binderFullName>
		<cfelse>	<!--- If 'binderFile' mapping does not exist, use default 'wirelessadvocates_config' --->
			<cfset configPath = expandPath('/wirelessadvocates_config')>
			<cfset channelNamePos = listLen(configPath,"\")-1>
			<cfset channelName = listGetAt( configPath, channelNamePos, "\" )>
			<cfset binderFullName = "fw.config.binders.#channelName#">
			<cfreturn binderFullName>
		</cfif>

	</cffunction>
	
</cfcomponent>
