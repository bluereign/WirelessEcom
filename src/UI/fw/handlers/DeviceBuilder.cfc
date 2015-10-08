<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="CarrierFacade" inject="id:CarrierFacade" />
  <cfproperty name="PlanService" inject="id:PlanService" />

  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <cfset this.browseDevicesUrl = "/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/" />
  <cfset this.preHandler_except = "planmodal,protectionmodal,featuremodal,accessorymodal,clearcart" /> <!--- clearcart (?)--->

  <!--- TODO:  If the following lists are only needed in the preHandler, move to prc scope: --->
  <cfset listCustomerTypes = "upgrade,addaline,new,upgradex,addalinex,newx" /> <!--- x short for 'multi' or 'another' --->
  <cfset listCustomerTypesRequireLogin = "upgrade,addaline,upgradex,addalinex" />
  <cfset listActionsRequireLogin = "upgradeline,plans,protection,accessories,numberporting,orderreview" />
  <cfset listActivationTypes = "financed-24,financed-18,financed-12,new,upgrade,addaline" /> <!--- TODO: determine what to do with new, upgrade, addaline  --->


  <cffunction name="preHandler" returntype="void" output="false" hint="preHandler">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfset var thisNavIndex = "" />
    <cfset var nextNavIndex = "" />
    <cfset var prevNavIndex = "" />
    <cfset var nextAction = "" />
    <cfset var prevAction = "" />

    <!--- <cfdump var="#rc#"><cfabort> --->

    <cfscript>
      // KEEP THIS NEXT LINE INCASE YOU NEED TO CLEAR CARRIER RESPONSE OBJECT AGAIN AFTER API CHANGES
      // carrierObjExists = structdelete(session, 'carrierObj', true);

      // <CARRIER CONSTANTS
      prc.carrierIdAtt = 109;
      prc.carrierGuidAtt = "83d7a62e-e62f-4e37-a421-3d5711182fb0";
      prc.offerCategoryAtt = "NE";
      prc.carrierIdVzw = 42;
      prc.carrierGuidVzw = "263a472d-74b1-494d-be1e-ad135dfefc43";
      prc.offerCategoryVzw = "VZ";

      prc.resultStr = "";

      prc.browseDevicesUrl = this.browseDevicesUrl;
      prc.AssetPaths = variables.AssetPaths;
      // <end carrier constants

      // INSTANTIATE SESSION.CART
      if (!structKeyExists(session,"cart")) {
        session.cart = createObject('component','cfc.model.cart').init();
      }
      if (!structKeyExists(session,"cartHelper")) {
        session.cartHelper = createObject('component','cfc.model.carthelper').init();
      }
      
      
      // CARTLINENUMBER:
      prc.cartLines = session.cart.getLines();

      // if customer is new, cartLineNumber is always 1:
      
      if ( listFindNoCase("new,newx,addaline,addalinex", rc.type) ) {
        rc.cartLineNumber = 1;
      }
      // else if ( listFindNoCase("upgrade,upgradex", rc.type) ) {
      //   rc.cartLineNumber = rc.line;
      //   }
      // }

      // if cartLineNumber is unknown, use the arrayLen of session cart lines
      if (!structKeyExists(rc, "cartLineNumber")) {
        prc.cartLinesCount = arrayLen(prc.cartLines);
        rc.cartLineNumber = prc.cartLinesCount + 1;
      }

      // prc.getCurrentLineData = session.cart.getCurrentLineData();

      // <end instantiate session.cart


      // <FINANCE PLAN CHECK
      if ( !structKeyExists(rc,"finance") OR !len(trim(rc.finance)) OR !listFindNoCase(listActivationTypes,rc.finance) ) {
        relocate( prc.browseDevicesUrl );
      }
      
      // param available in CF9
      if ( !structKeyExists(rc,"paymentoption") OR !len(trim(rc.paymentoption)) ) {
        rc.paymentoption = "financed"; //financed, fullretail
      }
      // <end finance plan check


      // <WARRANTY OPTION CHECK
      if ( !structKeyExists(rc,"wid") OR !len(trim(rc.wid)) ) {
        rc.wid = 0; //financed, fullretail
      }

      if ( rc.wid eq 0 ) {
        prc.warrantyInfo.Price = 0;
        prc.warrantyInfo.SummaryTitle = "No Equipment Protection Plan";
        prc.warrantyInfo.ShortDescription = "No Equipment Protection Plan";
        prc.warrantyInfo.LongDescription = "No Equipment Protection Plan";
      } else {
        prc.warrantyInfo = application.model.Warranty.getById(rc.wid);
      }
      // <end warranty option check


      // <ZIP CHECK
      // if user has authenticated into carrier, make sure that the session zip is the carrier response object zip (unless they have logged out with Clear Entire Cart).
      // else if inputZip exists and is valid, then set session.zipCode (ONLY IF the user has not authenticated with a carrier login).
      if ( structKeyExists(session,"carrierObj") ) {
        session.cart.setZipcode(listFirst(session.carrierObj.getAddress().getZipCode(), '-'));
      } else if ( event.valueExists('inputZip') and len(event.getValue('inputZip')) eq 5 and isNumeric(event.getValue('inputZip'))  ) {
        session.cart.setZipcode(listFirst(event.getValue('inputZip'), '-'));
      }
      // <end zip check
      

      // <TYPE CHECK
      // Make sure customer type exists.  If it does not, set it to upgrade.
      if ( !structKeyExists(rc,"type") OR !listFindNoCase(listCustomerTypes,rc.type) ) {
        rc.type = "upgrade";
      }
      // <end type check

      
      // <AUTH CHECK
      // if customer type requires authentication on this action, send them to carrierlogin:
      if (  listFindNoCase(listActionsRequireLogin, event.getCurrentAction()) and listFindNoCase(listCustomerTypesRequireLogin, rc.type) and !structKeyExists(session, "carrierObj")  ) {
        setNextEvent(
          event="devicebuilder.carrierLogin",
          persist="type,pid");
      }
      // <end auth check


      // <PRODUCT/DEVICE CHECK
      // return customer to Browse all phones (no filter) if a product id is not found in the URL (or form field):
      if (!structKeyExists(rc,"pid") OR !isNumeric(rc.pid)) {
        relocate( prc.browseDevicesUrl );
      }
      if (!structKeyExists(prc,"productData")) {
        prc.productData = application.model.phone.getByFilter(idList = rc.pid, allowHidden = true);
      }
      // return customer to Browse all phones if product id is not found in the database:
      if (!isNumeric(prc.productData.productId)) {
        relocate( prc.browseDevicesUrl  );
      }
      if (!structKeyExists(prc,"productService")) {
        prc.productService = application.wirebox.getInstance( "ProductService" );
      }
      if (!structKeyExists(prc,"productImages")) {
       prc.productImages = prc.productService.displayImages(prc.productData.deviceGuid, prc.productData.summaryTitle, prc.productData.BadgeType);
      }


      // <NAVIATION
      switch(rc.type) {
        case "upgrade":
          prc.navItemsAction = ["carrierlogin","upgradeline","plans","protection","accessories","orderreview"];
          prc.navItemsText = ["Carrier Login","Upgrade","Plans and Data","Protection &amp; Services","Accessories","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.upgradeline') & '/pid/' & rc.pid & '/type/upgradex/';
          prc.tallyboxHeader = "Upgrading";
          prc.cartTypeId = 2;
          prc.activationType = "upgrade";
          break;
        case "addaline":
          prc.navItemsAction = ["carrierlogin","plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Carrier Login","Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/addalinex/';
          prc.tallyboxHeader = "Add a Line";
          prc.cartTypeId = 3;
          prc.activationType = "addaline";
          break;
        case "new":
          prc.navItemsAction = ["plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/newx/';
          prc.tallyboxHeader = "New Customer (" & session.cart.getZipcode() & ")";
          prc.cartTypeId = 1;
          prc.activationType = "new";
          break;
        case "upgradex":
          prc.navItemsAction = ["upgradeline","protection","accessories","orderreview"];
          prc.navItemsText = ["Upgrade","Protection &amp; Services","Accessories","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.upgradeline') & '/pid/' & rc.pid & '/type/upgradex/';
          prc.tallyboxHeader = "Upgrading";
          prc.cartTypeId = 2;
          prc.activationType = "upgrade";
          break;
        case "addalinex":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/addalinex/';
          prc.tallyboxHeader = "Add a Line";
          prc.cartTypeId = 3;
          prc.activationType = "addaline";
          break;
        case "newx":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/newx/';
          prc.tallyboxHeader = "New Customer";
          prc.cartTypeId = 1;
          prc.activationType = "new";
          break;
      }

      thisNavIndex = listFindNoCase(arrayToList(prc.navItemsAction), event.getCurrentAction());

      if (isNumeric(thisNavIndex) and thisNavIndex gt 1) {
        prevNavIndex = thisNavIndex - 1;
        prevAction = prc.navItemsAction[prevNavIndex];
        prc.prevStep = event.buildLink('devicebuilder.#prevAction#') & '/pid/' & rc.pid & '/type/' & rc.type & '/finance/' & rc.finance & '/';
        if (structKeyExists(rc,"line")) {
          prc.prevStep = prc.prevStep & 'line/' & rc.line & '/';
        }
        if (structKeyExists(rc,"plan")) {
          prc.prevStep = prc.prevStep & 'plan/' & rc.plan & '/';
        }
      } else {
        prc.prevStep = CGI.http_referer;
      }

      if (isNumeric(thisNavIndex) and thisNavIndex lt arrayLen(prc.navItemsAction)) {
        nextNavIndex = thisNavIndex + 1;
        nextAction = prc.navItemsAction[nextNavIndex];
        if (!isDefined("rc.nextAction")) {
          // don't overwrite a nextAction value that has been manually passed in (via Form, etc.):
          rc.nextAction = "devicebuilder.#nextAction#";
        }
        // prc.nextStep = event.buildLink('devicebuilder.#nextAction#') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
        prc.nextStep = event.buildLink('devicebuilder.#nextAction#') & '/';
      } else {
        prc.nextStep = "/index.cfm/go/checkout/do/billShip/";
      }
      // <end Navigation


      // <SELECTED LINE AND SUBSCRIBERS
      if (structKeyExists(session,"carrierObj")) {
        prc.subscribers = session.carrierObj.getSubscribers();
        // TODO: make sure a selected subscriber is handled (and required)
        if ( structKeyExists(rc,"line") and isValid("integer", rc.line) and arrayLen(prc.subscribers) gte rc.line  ) {
          prc.subscriber = prc.subscribers[rc.line];
          // you can't get the RatePlan without having selected a "line" (i.e. subscriber):
          prc.planDataExisting = prc.subscriber.getRatePlan();
          prc.activetab = "existing";
          // TODO: Wrap the following in a phone number formatting function:
          prc.subscriber.phoneNumber = reReplace(prc.subscriber.getNumber(),"[{}\(\)\^$&%##!@=<>:;,~`'\'\*\?\/\+\|\[\\\\]|\]|\-",'','all');
          prc.subscriber.phoneNumber1 = left(prc.subscriber.phoneNumber, 3);
          prc.subscriber.phoneNumber2 = mid(prc.subscriber.phoneNumber, 4, 3);
          prc.subscriber.phoneNumber3 = right(prc.subscriber.phoneNumber, 4);
          prc.subscriber.phoneNumber = "(#prc.subscriber.phoneNumber1#) #prc.subscriber.phoneNumber2#-#prc.subscriber.phoneNumber3#";

          prc.tallyboxHeader = "Configuring " & prc.subscriber.phoneNumber;
        }
        // TODO: Else if page is 'plans' and type is 'upgrade', send redirect the logged in user to the upgradeline page here...
      }
      // <end selected line


      // <SELECTED PLAN
      if (structKeyExists(rc,"plan") and isNumeric(rc.plan)) {
        
        prc.planArgs = {
          carrierId = prc.productData.carrierId,
          zipCode = session.cart.getZipcode(),
          idList = rc.plan
        };
        prc.planInfo = PlanService.getPlans(argumentCollection = prc.planArgs);

        // get down payment of plan for this subscriber:
        if (structKeyExists(prc,"subscriber")) {
          prc.subscriber.offerCategory = IIF(prc.productData.carrierId eq prc.carrierIdAtt, DE(prc.offerCategoryAtt), DE(prc.offerCategoryVzw));
          prc.subscriber.minimumCommitment = listLast(rc.finance, '-');
          prc.subscriber.downPaymentPercent = prc.subscriber.getUpgradeDownPaymentPercent(prc.subscriber.offerCategory,prc.subscriber.minimumCommitment);
          
          // TEST TESTING ONLY, DEBUGGING: seed with 10% downpayment:
          if (prc.subscriber.downPaymentPercent lt 1 and rc.paymentoption is 'financed') {
            prc.subscriber.downPaymentPercent = 10;
          }
          // <end test testing debugging


          prc.subscriber.downPayment = prc.subscriber.downPaymentPercent * prc.productData.FinancedFullRetailPrice / 100;
        }
      }
      // <end selected plan


      // <SELECTED SERVICES
      if ( structKeyExists(rc,"selectedServices") ) {
        prc.selectedServices = rc.selectedServices;
      }
      if ( !structKeyExists(prc,"selectedServices") ) {
        prc.selectedServices = "";
      }
      if ( !structKeyExists(prc,"aSelectedServices") ) {
        prc.aSelectedServices = [];
      }

      // handle form fields from Payment, Protection and Services:
      if ( structKeyExists(rc, "FieldNames") and findNoCase("chk_features_",rc.FieldNames) ) {
        prc.selectedServices = "";
        i = 0;
        Fields = ListToArray(rc.FieldNames);
        FieldName = "";
        for (i = 1; i lte arrayLen(Fields); i++) {
          FieldName = Fields[i];
          if ( findNoCase("chk_features_",FieldName) ) {
            prc.selectedServices = listAppend(prc.selectedServices, XmlFormat(rc[FieldName]) );
          }
        }
      }

      // convert to array with productId, price, label for Tallybox
      // prc.aSelectedServices = ListToArray(prc.selectedServices);
      i = 0;
      l = listLen(prc.selectedServices);

      for (i = 1; i lte l; i++) {
        thisService = structNew();
        // thisService.productId = listGetAt(prc.selectedServices,i);
        // thisServiceQry = application.model.serviceManager.getServiceByProductId(productId = listGetAt(prc.selectedServices,i));
        if ( isNumeric(listGetAt(prc.selectedServices,i)) ) { // is not '' or 'nothanks'
          thisServiceQry = application.model.feature.getByProductID(productID = listGetAt(prc.selectedServices,i));
          thisService.productId = thisServiceQry.productId;
          thisService.price = thisServiceQry.price;
          // thisService.FinancedPrice = thisServiceQry.FinancedPrice;
          thisService.Title = thisServiceQry.Title;
          arrayAppend(prc.aSelectedServices, thisService);
        }
      }      
      // <end selected services


      // <CART 
      // if device has not been added to this rc.cartLineNumber in the cart, ensure that it is.  Note: there are multiple entry points to the DeviceBuilder.
      prc.cartArgs = {
        productType = "phone:" & prc.activationType,
        product_id = rc.pid,
        qty = 1,
        price = prc.productData.FinancedFullRetailPrice,
        cartLineNumber = rc.cartLineNumber
      };

      if ( structKeyExists(rc,"line") and isValid("integer",rc.line) and rc.line gt 0) {
        prc.cartArgs.subscriberIndex = rc.line;
      }

      prc.resultStr = application.model.dBuilderCartFacade.addItem(argumentCollection = prc.cartArgs);

      // if plan has not been added to this cart cartLineNumber, add it.
      if ( structKeyExists(prc,"planInfo") ) {
        prc.cartArgs = {
          productType = "plan",
          product_id = prc.planInfo.productId,
          qty = 1,
          cartLineNumber = rc.cartLineNumber
        };
        prc.resultStr = prc.resultStr & " plan: " & application.model.dBuilderCartFacade.addItem(argumentCollection = prc.cartArgs);
      }
      
      // services:
      if ( listLen(prc.selectedServices) ) {
        prc.cartArgs = {
          productType = "plan",
          product_id = prc.planInfo.productId & ":" & prc.selectedServices,
          qty = 1,
          cartLineNumber = rc.cartLineNumber
        };
        prc.resultStr = prc.resultStr & " services:" & application.model.dBuilderCartFacade.addItem(argumentCollection = prc.cartArgs);
      }


      // warranty: rc.wid
      if ( structKeyExists(rc,"wid") and isNumeric(rc.wid) and rc.wid gt 0 and structKeyExists(prc,"warrantyInfo") ) {
        prc.cartArgs = {
          productType = "warranty",
          product_id = rc.wid,
          qty = 1,
          cartLineNumber = rc.cartLineNumber
        };
        prc.resultStr = prc.resultStr & " warranty:" & application.model.dBuilderCartFacade.addItem(argumentCollection = prc.cartArgs);
      }
      

      // <ACCESSORIES

      if ( structKeyExists(rc,"addaccessory") ) {
        if ( ! (structKeyExists(rc,"accessoryqty") and isValid("integer", rc.accessoryqty)) ) {
          rc.accessoryqty = 1;
        }
        prc.cartArgs = {
          productType = "accessory",
          product_id = addaccessory,
          qty = rc.accessoryqty,
          cartLineNumber = rc.cartLineNumber
        };
        prc.resultStr = prc.resultStr & " accessory:" & application.model.dBuilderCartFacade.addItem(argumentCollection = prc.cartArgs);
      }

      // if ( structKeyExists(rc,"removeaccessory") ) {
      //   prc.cartArgs = {
      //     line = rc.cartLineNumber,
      //     productid = removeaccessory
      //   };
      //   prc.resultStr = prc.resultStr & " removeaccessory:" & application.model.CartHelper.removeAccessory(argumentCollection = prc.cartArgs);
      // }

      if ( structKeyExists(rc,"removeaccessory") ) {
        prc.cartArgs = {
          cartLineNumber = rc.cartLineNumber,
          product_id = removeaccessory,
          qty = 0
        };
        application.model.dBuilderCartFacade.updateAccessoryQty(argumentCollection = prc.cartArgs);
      }

      // get cartline accessories
      prc.cartArgs = {
          line = rc.cartLineNumber,
          type = "accessory"
        };
      prc.aAccessories = session.cartHelper.lineGetAccessoriesByType(argumentCollection = prc.cartArgs);
      prc.selectedAccessories = "";
      if (arrayLen(prc.aAccessories)) {
        for (prc.iAccessory = 1; prc.iAccessory lte arrayLen(prc.aAccessories); prc.iAccessory++) {
          prc.thisAccessory = prc.aAccessories[prc.iAccessory];
          prc.selectedAccessory = application.model.accessory.getByFilter(idList = prc.thisAccessory.getProductID());
          prc.selectedAccessories = listAppend(prc.selectedAccessories, prc.selectedAccessory.productId);
        }
      }
      // <end accessories
      
      // <end cart



      // <TALLY BOX
      prc.financeproductname = prc.productService.getFinanceProductName(carrierid=#prc.productData.CarrierId#);
      prc.tallyboxDueNow = 0;
      prc.tallyboxDueMonthly = 0;

      // Payment Options: financed, fullretail
      switch(rc.paymentoption) {
        case "financed":
          
          if (structKeyExists(prc,"subscriber") and structKeyExists(prc.subscriber,"downPayment") and prc.subscriber.downPayment gt 0) {
            prc.tallyboxFinanceMonthlyDueToday = prc.subscriber.downPayment;
          } else {
            // prc.subscriber.downPayment = 1000;
            prc.tallyboxFinanceMonthlyDueToday = 0;
          }
          
          // AT&T carrierId = 109, VZW carrierId = 42
          if ( prc.productData.CarrierId eq prc.carrierIdAtt ) {

            switch(rc.finance) {
              case "financed-24":
                prc.tallyboxFinanceTitle = prc.financeproductname & " 24";
                prc.tallyboxFinanceMonthlyDueTitle = "Due Monthly for 30 Months";
                prc.tallyboxFinanceMonthlyDueAmount = prc.productData.FinancedMonthlyPrice24;
                break;
              case "financed-18":
                prc.tallyboxFinanceTitle = prc.financeproductname & " 18";
                prc.tallyboxFinanceMonthlyDueTitle = "Due Monthly for 24 Months";
                prc.tallyboxFinanceMonthlyDueAmount = prc.productData.FinancedMonthlyPrice18;
                break;
              case "financed-12":
                prc.tallyboxFinanceTitle = prc.financeproductname & " 12";
                prc.tallyboxFinanceMonthlyDueTitle = "Due Monthly for 20 Months";
                prc.tallyboxFinanceMonthlyDueAmount = prc.productData.FinancedMonthlyPrice12;
                break;
            }

          } else {
            prc.tallyboxFinanceTitle = prc.financeproductname;
            prc.tallyboxFinanceMonthlyDueTitle = "Due Monthly for 24 Months";
            prc.tallyboxFinanceMonthlyDueAmount = prc.productData.FinancedMonthlyPrice24;
          }

          break;
        
        case "fullretail":
          prc.tallyboxFinanceMonthlyDueToday = prc.productData.FinancedFullRetailPrice;
          prc.tallyboxFinanceTitle = "Full Retail";
          prc.tallyboxFinanceMonthlyDueTitle = "Due Monthly";
          prc.tallyboxFinanceMonthlyDueAmount = 0;
          break;
        default:
          break;
      }
      prc.tallyboxDueMonthly = prc.tallyboxDueMonthly + prc.tallyboxFinanceMonthlyDueAmount;
      prc.tallyboxDueNow = prc.tallyboxDueNow + prc.tallyboxFinanceMonthlyDueToday;
      // <end tally box


      event.setLayout('devicebuilder');
    </cfscript>

    <!--- update cart totals: --->
    <cfif application.model.cartHelper.hasSelectedFeatures()>
      <cfset prc.qRecommendedServices = application.model.ServiceManager.getRecommendedServices() />
    </cfif>
    <cfset session.cart.updateAllPrices() />
    <cfset session.cart.updateAllDiscounts() />
    <cfset session.cart.updateAllTaxes() />
  </cffunction>

  
  <cffunction name="carrierLogin" returntype="void" output="false" hint="Carrier Login page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfparam name="rc.nextAction" default="devicebuilder.carrierlogin" />
    <cfparam name="rc.carrierResponseMessage" default="" />

    <cfscript>
      // DON'T DELETE UNTIL CONFIRMATION on whether or not a customer can log into a different carrier account...
      // if user has already logged into their carrier, force to the next step. ??
      // if ( structKeyExists(session,'carrierObj') ) {
      //   setNextEvent(
      //     event="#rc.nextAction#",
      //     persist="type,pid");
      // }

      switch(rc.type) {
        case "upgrade":
          prc.inputSSNTooltipTitle = "Enter the last 4 numbers of the primary account holder's or authorized user's social security number to access account information to verify which phone numbers are eligible for upgrade.";
          break;
        case "addaline":
          prc.inputSSNTooltipTitle = "Enter the last four numbers of the primary account holder's or authorized user's social security number to access account information to verify a new line can be added to the account.";
          break;
        default:
          break;
      }
      
      prc.inputPinTooltipTitle = "This could be the last 4 numbers of the primary account holder's social security number or a unique number sequence the primary account holder created for the account. If you do not remember this number or have this number, please call the carrier.";
      prc.includeTooltip = true;
    </cfscript>
  </cffunction>


  <cffunction name="carrierLoginPost" returntype="void" output="false" hint="Carrier Login">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfparam name="rc.carrierResponseMessage" default="" />
    <cfparam name="rc.inputPhone1" default="" />
    <cfparam name="rc.inputPhone2" default="" />
    <cfparam name="rc.inputPhone3" default="" />
    <cfparam name="rc.inputZip" default="" />
    <cfparam name="rc.inputSSN" default="" />
    <cfparam name="rc.inputPin" default="" />

    <cfscript>
      // SIMPLE SERVER-SIDE VALIDATION
      // AND len(rc.inputPin) gte 4 and len(rc.inputPin) lte 10
      if ( 
          !(
            len(rc.inputPhone1) eq 3
            AND
            isNumeric(rc.inputPhone1)
            AND
            len(rc.inputPhone2) eq 3
            AND
            isNumeric(rc.inputPhone2)
            AND
            len(rc.inputZip) gte 5 and len(rc.inputZip) lte 10
            AND
            isNumeric(left(rc.inputZip, 5))
            AND
            isNumeric(right(rc.inputZip, 4))
          )
        ) {
        rc.carrierResponseMessage = "There was an issue with the values you entered.  Please double check each value and then try again.";
        setNextEvent(
          event="devicebuilder.carrierLogin",
          persist="type,pid,finance,carrierResponseMessage,inputPhone1,inputPhone2,inputPhone3,inputZip,inputSSN,inputPin,cartLineNumber");
        // cartLineNumber
      }
      // <end simple validation


      switch (prc.productData.carrierId) {
        // AT&T carrierId = 109, VZW carrierId = 42
        case 109: case 42: {
          rc.PhoneNumber = rc.inputPhone1 & rc.inputPhone2 & rc.inputPhone3;
          prc.accountArgs = {
            carrierId = prc.productData.carrierId,
            SubscriberNumber = rc.PhoneNumber,
            ZipCode = rc.inputZip,
            SecurityId = rc.inputSSN,
            Passcode = rc.inputPin
          };

          // for testing purposes/development (carrierloginpost.cfm):
          rc.respObj = carrierFacade.Account(argumentCollection = prc.accountArgs);
          rc.message = rc.respObj.getHttpStatus();

          if (rc.respObj.getResult() is 'true' or rc.respObj.getResult() is 'false') {
          // TODO: replace the previous line with the next line when the CarrierFacade login is working properly again.
          // if (rc.respObj.getResult() is 'true') {
            session.carrierObj = rc.respObj;
            session.cart.setZipcode(listFirst(session.carrierObj.getAddress().getZipCode(), '-'));
            session.cart.setCarrierId(session.carrierObj.getCarrierId());

            if (session.carrierObj.getCarrierId() eq prc.carrierIdAtt) {
              session.carrierObj.carrierLogo = "#prc.assetPaths.common#images/carrierLogos/att_logo_25.png";
            } else if (prc.productData.carrierId eq prc.carrierIdVzw) {
              session.carrierObj.carrierLogo = "#prc.assetPaths.common#images/carrierLogos/verizon_logo_25.png";
            }

            // Relocate (comment out the next 3 lines to setview to carrierloginpost.cfm for debugging:)
            setNextEvent(
              event="#rc.nextAction#",
              persist="type,pid,finance,cartLineNumber");

          } else {
            rc.carrierResponseMessage = "We were unable to authenticate your wireless carrier information at this time.  Please try again.";
            setNextEvent(
              event="devicebuilder.carrierLogin",
              persist="type,pid,finance,carrierResponseMessage,inputPhone1,inputPhone2,inputPhone3,inputZip,inputSSN,inputPin,cartLineNumber");
          }
          break;
        }
        // Other carriers
        // TODO: Determine how to handle the off chance of a customer arriving here with a device that's not AT&T or Verizon
        default: {
          rc.carrierResponseMessage = "The phone you selected for testing is not an AT&T or Verizon device.  Please try again with an AT&T or Verizon device. (carrierId: #prc.productData.carrierId#)";
          setNextEvent(
            event="devicebuilder.carrierLogin",
            persist="type,pid,finance,carrierResponseMessage,inputPhone1,inputPhone2,inputPhone3,inputZip,inputSSN,inputPin,cartLineNumber");
        }
      };
    </cfscript>
  </cffunction>


  <cffunction name="upgradeline" returntype="void" output="false" hint="Upgrade a Line page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      prc.subscribers = session.carrierObj.getSubscribers();
      prc.addalineStep = event.buildLink('devicebuilder.transfer') & '/pid/' & rc.pid & '/type/addaline/';     
      prc.includeTooltip = true;
    </cfscript>
  </cffunction>


  <cffunction name="plans" returntype="void" output="false" hint="Plans page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
    // TODO: if type is 'upgrade', make sure a line is selected.  If rc.line does not exist, then send back to 'upgradealine'.

      prc.planArgs = {
        carrierId = prc.productData.carrierId,
        zipCode = session.cart.getZipcode()
      };
      
      prc.planData = PlanService.getPlans(argumentCollection = prc.planArgs);
      prc.planDataShared = PlanService.getSharedPlans(argumentCollection = prc.planArgs);
    </cfscript>

    <!--- If an existing plan's productId exists, then see if it is eligible (i.e. in the Individual or Shared plans queries) --->
    <cfif isDefined("prc.planDataExisting.productId") and isNumeric(prc.planDataExisting.productId)>
      <cfquery dbtype="query" name="qryExistingAvailable">
        select productId from prc.planData where productId = #prc.planDataExisting.productId#
        union
        select productId from prc.planDataShared where productId = #prc.planDataExisting.productId#
      </cfquery>
      <cfif qryExistingAvailable.recordcount gt 0 >
        <cfset prc.existingPlanEligible = true />
        <cfset rc.plan = qryExistingAvailable.productId />
      </cfif>
    </cfif>
  </cffunction>


  <cffunction name="planmodal" returntype="void" output="false" hint="Plan modal">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      prc.nextStep = event.buildLink('devicebuilder.protection');
      if (structKeyExists(rc,"plan")) {
        prc.planArgs = {
          idList = rc.plan
        };
        prc.planInfo = PlanService.getPlans(argumentCollection = prc.planArgs);
      }
      event.noLayout();
    </cfscript>
  </cffunction>


  <cffunction name="protection" returntype="void" output="false" hint="Protection and Services page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (!structKeyExists(rc, "isDownPaymentApproved")) {
        rc.isDownPaymentApproved = 0;
      }

      prc.qWarranty = application.model.Warranty.getByDeviceId(rc.pid);

      prc.servicesArgs = {
        type = "O",
        deviceGuid = prc.productData.productGuid,
        HasSharedPlan = session.cart.getHasSharedPlan()
      };

      if (prc.productData.carrierId eq prc.carrierIdAtt) {
        prc.servicesArgs.carrierId = prc.carrierGuidAtt;
      } else if (prc.productData.carrierId eq prc.carrierIdVzw) {
        prc.servicesArgs.carrierId = prc.carrierGuidVzw;
      }

      prc.groupLabels = application.model.serviceManager.getServiceMasterGroups(argumentCollection = prc.servicesArgs);
    </cfscript>
  </cffunction>


  <cffunction name="protectionmodal" returntype="void" output="false" hint="Plan modal">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (structKeyExists(rc,"wid")) {
        prc.warrantyInfo = application.model.Warranty.getById(rc.wid);
      }
      event.noLayout();
    </cfscript>
  </cffunction>


  <cffunction name="featuremodal" returntype="void" output="false" hint="Plan modal">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (structKeyExists(rc,"fid")) {
        prc.featureInfo = application.model.Feature.getByProductID(rc.fid);
      }
      event.noLayout();
    </cfscript>
  </cffunction>


  <cffunction name="accessories" returntype="void" output="false" hint="Accessories page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var nextAction = "" />
    <cfset var prevAction = "" />

    <cfscript>
      prc.CatalogService = application.model.Catalog;
      prc.qAccessory = prc.CatalogService.getDeviceRelatedAccessories(rc.pid);
    </cfscript>
  </cffunction>


  <cffunction name="accessorymodal" returntype="void" output="false" hint="Plan modal">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (structKeyExists(rc,"aid")) {
        prc.accessoryInfo = application.model.Accessory.getByFilter(idList = rc.aid);
        prc.stcPrimaryImages = application.model.imageManager.getPrimaryImagesForProducts(valueList(prc.accessoryInfo.accessoryGuid));
        prc.accessoryImages = application.model.imageManager.getImagesForProducts(prc.accessoryInfo.accessoryGuid, true);
      }
      event.noLayout();
    </cfscript>
  </cffunction>


  <cffunction name="numberporting" returntype="void" output="false" hint="Number Porting page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      prc.includeTooltip = true;
    </cfscript>
  </cffunction>


  <cffunction name="orderreview" returntype="void" output="false" hint="Order Review/Cart page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var prevAction = "" />
    <cfparam name="prc.showAddAnotherDeviceButton" default="true" />
    <cfparam name="prc.showCheckoutnowButton" default="true" />
    <cfparam name="prc.showClearCartLink" default="true" />


    <!--- Remove empty cart lines --->
    <!--- <cfset application.model.CartHelper.removeEmptyCartLines() /> --->
    
    <!--- TODO:  apply rebates logic from cfc/model/LineService.cfc --->

    <!--- TODO: apply cart logic in cfc/view/Cart.cfc's "view" function --->
    <!--- <cfif application.model.cartHelper.hasSelectedFeatures()>
      <cfset prc.qRecommendedServices = application.model.ServiceManager.getRecommendedServices() />
    </cfif>

    <cfset session.cart.updateAllPrices() />
    <cfset session.cart.updateAllDiscounts() />
    <cfset session.cart.updateAllTaxes() /> --->




    <cfscript>
      prc.clearCartAction = event.buildLink('devicebuilder.clearcart') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      prc.includeTallyBox = false;
    </cfscript>
  </cffunction>


  <cffunction name="clearcart" returntype="void" output="false" hint="Order Review/Cart page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var carrierObjExists = false />

    <cfscript>

      // remove carrierObj from session: 
      carrierObjExists = structdelete(session, 'carrierObj', true);

      // reinitialize the cart
      session.cart = createObject('component','cfc.model.cart').init();
      
      // TODO: Remove the following 2 lines after testing to comply with case 195
      // remove zipCode from session:
      // carrierObjExists = structdelete(session, 'zipCode', true);

      // create warningMessage
      flash.put("warningMessage","Your cart has been cleared. <a href='#this.browseDevicesUrl#'>Click here to go to Browse Devices.</a>");
      flash.put("showNav", false);
      flash.put("showAddAnotherDeviceButton", false);
      flash.put("showCheckoutNowButton", false);
      flash.put("showClearCartLink", false);

      // event.setView("orderreview");
      
      setNextEvent(
        event="devicebuilder.orderreview",
        persist="type,pid,finance,line,plan"
        );
      
    </cfscript>
  </cffunction>


</cfcomponent>
