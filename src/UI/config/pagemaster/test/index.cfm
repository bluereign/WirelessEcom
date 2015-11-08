<cfscript>
  request.config = structNew();

  //Channel
  request.config.layout = 'pagemaster';
  request.config.skin = 'pagemaster';
  request.config.channelName = 'pagemaster';

  request.config.bFriendlyErrorPages = false;
  url.reinit = false; //TODO: Replace with config property

  // TRV: adding a reference to the fake line number value we'll use for the 'other items' portion of the cart
  request.config.otherItemsLineNumber = "999";

  // TRV: defining a "product_id" for shipping that will be referenced from the cart
  request.config.shipMethodProductID = "99999998";
  // TRV: setting a variable to control the site-wide line count limit (presently 5)
  request.config.maxLines = 5;
  // TRV: adding a variable to control the appearance of GERS SKU, QTY on-hand, UPC code, CarrierBillCode inventory data (should only be enabled on non-production environments
  request.config.debugInventoryData = true;
  // TRV: adding a variable to control whether inventory levels should be evaluated on the front-end in consideration of allowing the user to add an item to the cart
  request.config.enforceInventoryRestrictions = false;
  // TRV: adding variable to determine if bypassing pre-checkout cart validation should be allowed
  request.config.allowCartValidationBypass = false;

  // determine various OS-agnostic file system paths
  request.config.configPath = getDirectoryFromPath(getCurrentTemplatePath());
  request.config.pathDelim = application.pathDelim;
  request.config.trunkRoot = application.applicationRootPath; // set in Application.cfc
  request.config.webDocRoot = "#request.config.trunkRoot#wwwroot#request.config.pathDelim#";
  request.config.catalogImageRoot = "#request.config.webDocRoot#assets#request.config.pathDelim#common#request.config.pathDelim#images#request.config.pathDelim#Catalog#request.config.pathDelim#";
  request.config.marketingRoot = "#request.config.webDocRoot#marketing#request.config.pathDelim#";
  request.config.docsRoot = "#request.config.webDocRoot#assets/docs/#request.config.pathDelim#";

  //Image manager
  request.config.publicSitePathToCFC = "#request.config.trunkRoot#cfc#request.config.pathDelim#";
  request.config.imageFileDirectory = request.config.catalogImageRoot;
  request.config.imageFileCacheDirectory = "#request.config.imageFileDirectory#cached#request.config.pathDelim#";
  request.config.imagePath = "/assets/common/images/Catalog/";
  request.config.imageCachePath = "/assets/common/images/Catalog/cached/";

  //Customer service
  request.config.customerServiceNumber = "1 (888) 369-5931";
  request.config.customerServiceEmail = "wawirelesspromotions@wirelessadvocates.com";

  //Display configs
  request.config.CartReviewShippingDisplayName = 'FREE';

  //Tax service
  request.config.InvoiceNumberPrefix = "TEST - ";
  request.config.CommitTaxTransaction = false;

  //Google Analytics
  request.config.EnableAnalytics = false;

  //Carrier Plan Discounts Percentage
  request.config.PlanDiscount.Att = 0;
  request.config.PlanDiscount.Verizon = 0;
  request.config.PlanDiscount.Tmobile = 0;
  request.config.PlanDiscount.Sprint = 0; //.05;

  //MAC: Carrier Interface Local Endpoints
  request.config.TMobileEndPoint = "http://10.7.0.80/TMobileCarrierInterface/TMobileService.asmx?WSDL";
  request.config.SprintEndPoint =  "http://costco.ecom-dev-test-1.enterprise.corp/SprintCarrierInterface/SprintService.asmx?WSDL";


  //Carrier Service Bus
  request.config.CarrierServiceBus.Endpoint = 'http://205.138.175.121/ServiceBus.DTS/json/syncreply';
  request.config.CarrierServiceBus.AuthSecretKey = 'tqkPA2yBGxxESl4hdtKJ+Q==';
  request.config.CarrierServiceBus.AuthUsername = '2SY8K/arWpfLS2vVyFZVoQ==';
  request.config.CarrierServiceBus.AuthPassword = 'rTo0DGnwPuuq3Z2iilIQvw==';

  //Carrier Target environments
  request.config.CarrierServiceBusTarget.Verizon = 'Verizon.Dev';
  request.config.CarrierServiceBusTarget.ATT = 'ATT.Test';

  request.config.ServiceBusRequest.ChannelName = 'AAFESDOTCOM';

  //New Verizon EROS API
  request.config.VerizonErosEndPoint = 'http://205.138.175.121/Verizon/json/syncreply';
  request.config.VerizonRequestHeader.UserName = 'COSTCO1';
  request.config.VerizonRequestHeader.Password = 'Vct11812';
  request.config.VerizonRequestHeader.ClientAppName = 'AAFESDOTCOM';
  request.config.VerizonRequestHeader.ClientAppUserName = 'SUPPORT';
  request.config.VerizonRequestHeader.StoreID = '9999';

  //Activations settings
  request.config.ActivationSetting.Verizon.IsDeviceInfoFinal = 'false';

  //New AT&T Service Bus
	request.config.AttRequestHeader.APIVersion = 'COSTCO1';
	request.config.AttRequestHeader.ClientAppName = 'AAFESDOTCOM';
	request.config.AttRequestHeader.ClientAppUserName = 'SYSTEM';
	request.config.AttRequestHeader.ReferenceNumber = 'chrisgtest';

	//MAC: log files.
	request.config.logFileDirectory = "#request.config.trunkRoot#Logs#request.config.pathDelim#";
	
	//MAC: debug and testing config
	request.config.ShowServiceCallResultCodes = true;

	request.config.ActiveCarriers = "42|109|128|299";  // production is 42|109|128
	request.config.disablePaymentGateway = true; //true = test mode
	request.config.disableTestMode = false;
	request.config.disableCarrierCheckout = "";  //42|109|128|299
	
	//Admin
	request.config.reinitAdmin = false;
	
	//Video Convertor
	request.config.VideoConvertor.VideoFilePath = '#request.config.trunkRoot#media';
	request.config.VideoConvertor.VideoFolder = 'products';
	request.config.VideoConvertor.ThumbnailFolder = 'poster';
	
	request.config.disableSSL = true;

	// the domain value for emailTemplates 
	request.config.emailTemplateDomain = cgi.server_name;
</cfscript>

<!--- TRV: include our rateplanControl data for this environment --->
<cfinclude template="_rateplanControl.cfm">

<!--- TRV: include our carrierControl data for this environment --->
<cfinclude template="_carrierControl.cfm">

<!--- TRV: include our checkoutControl data for this environment --->
<cfinclude template="_checkoutControl.cfm">
