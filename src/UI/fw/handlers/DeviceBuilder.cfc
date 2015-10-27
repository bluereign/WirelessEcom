<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="CarrierFacade" inject="id:CarrierFacade" />
  <cfproperty name="PlanService" inject="id:PlanService" />

  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <cfset this.preHandler_except = "planmodal,protectionmodal,featuremodal,accessorymodal,clearcart,showcarttype" /> <!--- clearcart (?)--->
  <cfset this.browseDevicesUrl = "/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/" />
  <cfset this.browseDevicesUrlAtt = "/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/" />
  <cfset this.browseDevicesUrlVzw = "/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/" />
  <cfset listCustomerTypes = "upgrade,addaline,new,upgradex,addalinex,newx" /> <!--- x short for 'multi' or 'another' --->
  <cfset listCustomerTypesRequireLogin = "upgrade,addaline,upgradex,addalinex" />
  <cfset listActionsRequireLogin = "upgradeline,plans,protection,accessories,numberporting" /> <!--- orderreview --->
  <cfset listActivationTypes = "financed-24,financed-18,financed-12,upgrade" /> <!--- upgrade=2-year contract. TODO: determine what to do with new, upgrade, addaline  --->


  <cffunction name="preHandler" returntype="void" output="false" hint="preHandler">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfset var thisNavIndex = "" />
    <cfset var nextNavIndex = "" />
    <cfset var prevNavIndex = "" />
    <cfset var nextAction = "" />
    <cfset var prevAction = "" />

    <cfset var planArgs = {} />
    <cfset var cartArgs = {} />

    <cfscript>
      // DEBUGGING: KEEP THIS NEXT LINE INCASE YOU NEED TO CLEAR CARRIER RESPONSE OBJECT AGAIN AFTER API CHANGES
      // carrierObjExists = structdelete(session, 'carrierObj', true);
      // session.cart = createObject('component','cfc.model.cart').init();



      // <CARRIER CONSTANTS
      prc.carrierIdAtt = 109;
      prc.carrierGuidAtt = "83d7a62e-e62f-4e37-a421-3d5711182fb0";
      prc.offerCategoryAtt = "NE";
      prc.carrierIdVzw = 42;
      prc.carrierGuidVzw = "263a472d-74b1-494d-be1e-ad135dfefc43";
      prc.offerCategoryVzw = "VZ";

      if ( session.cart.getCarrierId() eq prc.carrierIdAtt ) {
        prc.browseDevicesUrl = this.browseDevicesUrlAtt;
      } else if ( session.cart.getCarrierId() eq prc.carrierIdVzw ) {
        prc.browseDevicesUrl = this.browseDevicesUrlVzw;
      } else {
        prc.browseDevicesUrl = this.browseDevicesUrl;
      }
      
      prc.AssetPaths = variables.AssetPaths;

      prc.stringUtil = stringUtil;
      // <end carrier constants



      // <CHECK CART INSTANTIATED
      if (!structKeyExists(session,"cart")) {
        session.cart = createObject('component','cfc.model.cart').init();
      }
      if (!structKeyExists(session,"cartHelper")) {
        session.cartHelper = createObject('component','cfc.model.carthelper').init();
      }
      if (!structKeyExists(session,"dBuilderCartFacade")) {
        session.dBuilderCartFacade = createObject('component', 'fw.model.shopping.dbuilderCartFacade').init();
      }
      // <end check cart instantiated



      // <ADD DEVICE TO CART (FROM PRODUCT DETAIL PAGE)
      // if customer enters devicebuider with rc.pid, rc.type, rc.finance then they are adding to cart.
      if ( structKeyExists(rc,"pid") and structKeyExists(rc,"finance") and structKeyExists(rc,"type") ) {

        // 1. validate the finance.
        if ( !structKeyExists(rc,"finance") OR !len(trim(rc.finance)) OR !listFindNoCase(listActivationTypes,rc.finance) ) {
          relocate( prc.browseDevicesUrl );
        }

        

        // 2. validate the type.
        // Make sure customer type exists.  If it does not, set it to upgrade.
        if ( !listFindNoCase(listCustomerTypes,rc.type) ) {
          rc.type = "upgrade";
        }
        prc.customerType = rc.type;

        // 3. validate the pid.
        // return customer to Browse all phones (no filter) if a product id is not found in the URL (or form field):
        if (!structKeyExists(rc,"pid") OR !isNumeric(rc.pid)) {
          relocate( prc.browseDevicesUrl );
        }
        if (!structKeyExists(prc,"productData")) {
          prc.productData = application.model.phone.getByFilter(idList = rc.pid, allowHidden = true);
        }
        // return customer to Browse all phones if product id is not found in the database or there are no qty on hand:
        if ( !isNumeric(prc.productData.productId) or prc.productData.qtyOnHand lt 1 ) {
          relocate( prc.browseDevicesUrl  );
        }

        // 4. validate the CARRIER
        // if the cart already has at least one device in it, then check to ensure that this new device belongs to the same carrier.  If it does not, send user to the orderreview page and display a warning message that they can't add a device of two different carriers to their cart.
        // get the carrier id of first device in cart.
        if ( arrayLen(session.cart.getLines()) and session.cart.getCarrierId() neq 0 and session.cart.getCarrierId() neq prc.productData.carrierId ) {
          
          if ( session.cart.getCarrierId() eq prc.carrierIdAtt ) {
            prc.addxStep = this.browseDevicesUrlAtt;
          } else if ( session.cart.getCarrierId() eq prc.carrierIdVzw ) {
            prc.addxStep = this.browseDevicesUrlVzw;
          }

          flash.put("warningMessage","Your cart already has a device for a different carrier than the one you've selected.  You must first clear your cart.  <a href='#prc.addxStep#'>Click here to go to Browse Devices.</a>");
          setNextEvent(
            event="devicebuilder.orderreview",
            persist=""
            );
        }


        
        // 5. set cart and cartLine activationType (eg  financed-24-new).
        if (rc.finance is 'upgrade') {
          prc.activationType = "upgrade";
        } else {
          prc.activationType = rc.finance & "-" & rc.type;
        }
        session.cart.setActivationType(prc.activationType);

        // 6. set the cartLineNumber
        // if customer is new, cartLineNumber is always 1:
        if ( listFindNoCase("new,newx,addaline,addalinex", rc.type) ) {
          rc.cartLineNumber = 1;
        }
        // if cartLineNumber is unknown, use the arrayLen of session cart lines and add a new cart line for this Device
        if (!structKeyExists(rc, "cartLineNumber")) {
          prc.cartLines = session.cart.getLines();
          prc.cartLinesCount = arrayLen(prc.cartLines);
          rc.cartLineNumber = prc.cartLinesCount + 1;
        }

        // 7. add phone to cart.
        cartArgs = {
          productType = "phone:" & prc.activationType,
          product_id = rc.pid,
          qty = 1,
          price = prc.productData.FinancedFullRetailPrice,
          cartLineNumber = rc.cartLineNumber
        };
        // session.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
        application.model.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
      }
      // <end add device to cart



      // get cartline device:
      if ( !structKeyExists(rc,"cartLineNumber") ) {
        rc.cartLineNumber = 1;
      }
      
      prc.cartLines = session.cart.getLines();
      prc.customerType = listLast(session.cart.getActivationType(), '-');
      if (!structKeyExists(prc,"productService")) {
        prc.productService = application.wirebox.getInstance( "ProductService" );
      }

      

      // if not adding an accessory from the order review page
      if (rc.cartLineNumber neq request.config.otherItemsLineNumber) {

        if (arrayLen(prc.cartLines)) {
          prc.cartLine = prc.cartLines[rc.cartLineNumber];
          // prc.device = session.dBuilderCartFacade.getDevice(cartLineNo = rc.cartLineNumber).cartItem;
          prc.device = application.model.dBuilderCartFacade.getDevice(cartLineNo = rc.cartLineNumber).cartItem;
        } else {
          relocate( prc.browseDevicesUrl );
        }

        // GET CARTLINE DEVICE INFO
        // Phone details and images:
        // FIRST NEED TO PULL DEVICE FROM CARTLINE
        if (!structKeyExists(prc,"productData")) {
          prc.productData = application.model.phone.getByFilter(idList = prc.device.getProductId(), allowHidden = true);
        }
        if (!structKeyExists(prc,"productImages")) {
         prc.productImages = prc.productService.displayImages(prc.productData.deviceGuid, prc.productData.summaryTitle, prc.productData.BadgeType);
        }


        // UPDATE CUSTOMER TYPE FROM CART LINE ACTIVATION TYPE (FOR NAVIGATION, ETC):
        // financed-24-upgrade
        

        if (prc.cartLine.getCartLineActivationType() contains 'financed-') {
          prc.financed = left(prc.cartLine.getCartLineActivationType(), 11);
        } else {
          prc.financed = "fullretail";
        }


      }



      // UPDATE CARTLINE WITH SUBSCRIBER INDEX:
      if ( structKeyExists(rc,"subscriberIndex") and isValid("integer",rc.subscriberIndex) ) {
        
        // check to ensure no other cartlines have been assigned this subcriber index:
        local.isSubscriberIndexTaken = false;
        for (j = 1; j lte arrayLen(prc.cartLines); j++) {
          if ( prc.cartLines[j].getSubscriberIndex() eq rc.subscriberIndex ) {
            local.isSubscriberIndexTaken = true;
            break;
          }
        }

        if ( !local.isSubscriberIndexTaken ) {
          prc.cartLine.setSubscriberIndex(rc.subscriberIndex);
          // the refresh lines, etc.
          prc.cartLines = session.cart.getLines();
          prc.cartLine = prc.cartLines[rc.cartLineNumber];
          // prc.device = session.dBuilderCartFacade.getDevice(cartLineNo = rc.cartLineNumber).cartItem;
          prc.device = application.model.dBuilderCartFacade.getDevice(cartLineNo = rc.cartLineNumber).cartItem;

          // Set the session zipcode to the subscriber zipcide:
          // ... and because CF 8 doesn't allow functionReturnsArray()[index]:
          prc.subscribers = session.carrierObj.getSubscribers();
          prc.subscriber = prc.subscribers[rc.subscriberIndex];
          prc.subscriberZipcode = listFirst(prc.subscriber.getAddress().getZipCode(), '-');
          if ( isValid("zipcode",prc.subscriberZipcode) ) {
            session.cart.setZipcode(prc.subscriberZipcode);
          }
        } else {
          flash.put("warningMessage","Your cart already has a device assigned to this number.  You must first remove the other device from your cart.");
          setNextEvent(
            event="devicebuilder.upgradeline",
            persist="cartLineNumber"
            );
        }
        // TODO: Write an error message here and send back to devicebuilder.upgradeline

      }



      // UPDATE CARTLINE WITH PLAN PRODUCT ID
      if ( structKeyExists(rc,"planid") ) {
        cartArgs = {
          productType = "plan",
          product_id = rc.planid,
          qty = 1,
          cartLineNumber = rc.cartLineNumber
        };
        // session.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
        application.model.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
      }

      if ( structKeyExists(rc,"HasExistingPlan")  ) {
        // session.DBuilderCart.setHasExistingPlan(rc.HasExistingPlan);
        session.cart.HasExistingPlan = rc.HasExistingPlan;
      }

      // GET PLAN FROM CART
      // prc.cartPlan = session.dBuilderCartFacade.getPlan();
      prc.cartPlan = application.model.dBuilderCartFacade.getPlan();



      // PROTECTION AND SERVICES
      // update finance plan if rc.paymentoption exists (i.e. finance plan has changed):
      if ( structKeyExists(rc,"paymentoption") ) {

        if ( rc.paymentoption is 'financed' ) {
          prc.financed = rc.financed;
          prc.activationType = rc.financed & "-" & prc.customerType;
        } else if ( rc.paymentoption is 'fullretail' ) {
          // prc.activationType = rc.paymentoption & "-" & prc.customerType;
          prc.activationType = prc.customerType;
        } else if ( rc.paymentoption is '2yearcontract' ) {
          prc.activationType = prc.customerType;
        }

        session.cart.setActivationType(prc.activationType);
        prc.cartLine.setCartLineActivationType(prc.activationType);
        prc.paymentoption = rc.paymentoption;
      }

      if (  structKeyExists(prc,"cartLine") and  ( !structKeyExists(prc,"paymentoption") OR !len(trim(prc.paymentoption)) )  ) {
        
        if ( prc.cartLine.getCartLineActivationType() contains 'financed' ) {
          prc.paymentoption = "financed";
        } else {
         //financed, fullretail, 2yearcontract
         prc.paymentoption = IIF(prc.productData.carrierId eq prc.carrierIdAtt, DE("fullretail"), DE("2yearcontract"));
        }

      }

      // update Device Protection Options (warranty)
      if ( structKeyExists(rc,"warrantyid") ) {
        if ( isValid("integer", rc.warrantyid) and rc.warrantyid gt 0 ) {
          // if warrantyid exists and it is not zero, update the cartLine warranty
          cartArgs = {
            productType = "warranty",
            product_id = rc.warrantyid,
            qty = 1,
            cartLineNumber = rc.cartLineNumber
          };
          // session.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
          application.model.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
        } else if (rc.warrantyid eq 0) {
          // if warrantyid exists and it is zero, then remove the cartline warranty.
          session.cartHelper.removeWarranty(line = rc.cartLineNumber);
        }
      }

      // now, get the cartline warranty.
      // prc.warranty = session.dBuilderCartFacade.getWarranty(rc.cartLineNumber);
      prc.warranty = application.model.dBuilderCartFacade.getWarranty(rc.cartLineNumber);
      if (prc.warranty.recordcount) {
        prc.warrantyId = prc.warranty.productId;
      } else {
        prc.warrantyId = 0;
      }

      // Additional Services
      // <SELECTED SERVICES
      if ( structKeyExists(rc,"selectedServices") ) {
        prc.selectedServices = rc.selectedServices;
      } else if ( structKeyExists(prc,"cartLine") and listFindNoCase("devicebuilder.protection", event.getCurrentEvent()) ) {
        // load prc.selectedServices from session.cartLine
        prc.selectedServices = "";
        prc.lineFeatures = prc.cartLine.getFeatures();

        for (i = 1; i lte arrayLen(prc.lineFeatures); i++) {
          local.thisFeatureID = prc.lineFeatures[i].getProductID();
          prc.selectedServices = listAppend(prc.selectedServices, local.thisFeatureID );
        }

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

      for (i = 1; i lte listLen(prc.selectedServices); i++) {
        thisService = structNew();
        if ( isNumeric(listGetAt(prc.selectedServices,i)) ) { // is not '' or 'nothanks'
          thisServiceQry = application.model.feature.getByProductID(productID = listGetAt(prc.selectedServices,i));
          thisService.productId = thisServiceQry.productId;
          thisService.price = thisServiceQry.price;
          thisService.Title = thisServiceQry.Title;
          arrayAppend(prc.aSelectedServices, thisService);
        }
      }

      // add services to cart
      if ( listLen(prc.selectedServices) and isQuery(prc.cartPlan) and prc.cartPlan.recordcount ) {
        
        cartArgs = {
          productType = "plan",
          product_id = prc.cartPlan.productId & ":" & prc.selectedServices,
          qty = 1,
          cartLineNumber = rc.cartLineNumber
        };

        // session.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
        application.model.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
      }
      // <end selected services



      // <ACCESSORIES - add accessory
      if ( structKeyExists(rc,"addaccessory") and len(trim(rc.addaccessory)) ) {
        if ( ! (structKeyExists(rc,"accessoryqty") and isValid("integer", rc.accessoryqty)) ) {
          rc.accessoryqty = 1;
        }

        cartArgs = {
          cartLineNumber = rc.cartLineNumber,
          product_id = addaccessory,
          qty = rc.accessoryqty
        };

        // session.dBuilderCartFacade.updateAccessoryQty(argumentCollection = cartArgs);
        application.model.dBuilderCartFacade.updateAccessoryQty(argumentCollection = cartArgs);
      }

      // <ACCESSORIES - remove accessory
      if ( structKeyExists(rc,"removeaccessory")  and len(trim(rc.removeaccessory)) ) {
        cartArgs = {
          cartLineNumber = rc.cartLineNumber,
          product_id = removeaccessory,
          qty = 0
        };
        // session.dBuilderCartFacade.updateAccessoryQty(argumentCollection = cartArgs);
        application.model.dBuilderCartFacade.updateAccessoryQty(argumentCollection = cartArgs);
      }

      // get cartline accessories
      cartArgs = {
          line = rc.cartLineNumber,
          type = "accessory"
        };
      prc.aAccessories = session.cartHelper.lineGetAccessoriesByType(argumentCollection = cartArgs);
      prc.selectedAccessories = "";
      if (arrayLen(prc.aAccessories)) {
        for (prc.iAccessory = 1; prc.iAccessory lte arrayLen(prc.aAccessories); prc.iAccessory++) {
          prc.thisAccessory = prc.aAccessories[prc.iAccessory];
          prc.selectedAccessory = application.model.accessory.getByFilter(idList = prc.thisAccessory.getProductID());
          prc.selectedAccessories = listAppend(prc.selectedAccessories, prc.selectedAccessory.productId);
        }
      }
      // <end accessories



      // ORDER REVIEW: Remove Phone
      if ( structKeyExists(rc,"removephone") and len(trim(rc.removephone)) and isValid("integer",rc.removephone) and arrayLen(prc.cartLines) ) {
        // prc.removeCartLine = prc.cartLines[rc.removephone];
        // application.model.cartHelper.removePhone(line = rc.removephone);
        // application.model.cartHelper.removeAllLineFeatures(line = rc.removephone);
        // application.model.cartHelper.removeLineBundledAccessories(lineNumber = rc.removephone);
        // application.model.cartHelper.removeWarranty(line = rc.removephone);
        // prc.removeCartLine.setAccessories(accessories=arrayNew(1));
        
        session.cartHelper.deleteLine(lineNumber = rc.removephone);

        session.cartHelper.removeEmptyCartLines();

        // since that cartLineNumber does not exist, change active cartLineNumber to 999:
        rc.cartLineNumber = request.config.otherItemsLineNumber;

        // update prc.cartlines:
        prc.cartLines = session.cart.getLines();
      }



      // if not adding an accessory from the order review
      if (rc.cartLineNumber neq request.config.otherItemsLineNumber) {
        // <SELECTED LINE AND SUBSCRIBERS
        if (structKeyExists(session,"carrierObj")) {
          prc.subscribers = session.carrierObj.getSubscribers();
          prc.subscriberIndex = prc.cartLine.getSubscriberIndex();
          if ( isValid("integer", prc.subscriberIndex) and prc.subscriberIndex gt 0 and arrayLen(prc.subscribers) gte prc.subscriberIndex ) {
            prc.subscriber = prc.subscribers[prc.subscriberIndex];
            prc.planDataExisting = prc.subscriber.getRatePlan();
            // prc.activetab = "existing";
            // prc.activetab = "individual";
            prc.subscriber.phoneNumber = stringUtil.formatPhoneNumber(trim(prc.subscriber.getNumber()));
            prc.tallyboxHeader = "Configuring " & prc.subscriber.phoneNumber;
          } else {
            prc.tallyboxHeader = "Upgrading";
          }
        }
        // <end selected line and subscribers



        // <AUTH CHECK
        // if customer type requires authentication on this action, send them to carrierlogin:
        if (  listFindNoCase(listActionsRequireLogin, event.getCurrentAction()) and listFindNoCase(listCustomerTypesRequireLogin, prc.customerType) and !structKeyExists(session, "carrierObj")  ) {
          setNextEvent(
            event="devicebuilder.carrierLogin",
            persist="cartLineNumber");
        }
        // <end auth check
      }

      

      // <DOWN PAYMENT FOR THIS SUBSCRIBER:
      if (structKeyExists(prc,"subscriber")) {
        prc.subscriber.offerCategory = IIF(prc.productData.carrierId eq prc.carrierIdAtt, DE(prc.offerCategoryAtt), DE(prc.offerCategoryVzw));
        if ( prc.financed contains 'financed' ) {
          prc.subscriber.minimumCommitment = listLast(prc.financed, '-');
          prc.subscriber.downPaymentPercent = prc.subscriber.getUpgradeDownPaymentPercent(prc.subscriber.offerCategory,prc.subscriber.minimumCommitment);
          prc.subscriber.downPayment = prc.subscriber.downPaymentPercent * prc.productData.FinancedFullRetailPrice / 100;
        } 
      }
      // <end down payment



      // <ZIP CHECK
      // if user has authenticated into carrier, make sure that the session zip is the carrier response object zip (unless they have logged out with Clear Entire Cart).
      // else if inputZip exists and is valid, then set session.zipCode (ONLY IF the user has not authenticated with a carrier login).
      if ( structKeyExists(session,"carrierObj") and len(trim( session.carrierObj.getAddress().getZipCode() ) ) ) {
        session.cart.setZipcode(listFirst(session.carrierObj.getAddress().getZipCode(), '-'));
      } else if ( event.valueExists('inputZip') and len(event.getValue('inputZip')) eq 5 and isNumeric(event.getValue('inputZip'))  ) {
        session.cart.setZipcode(listFirst(event.getValue('inputZip'), '-'));
      }
      // <end zip check



  
      // <NAVIATION
      switch(prc.customerType) {
        case "upgrade":
          
          if ( rc.cartLineNumber gt 1 and structKeyExists(session,"carrierObj") and isArray(session.carrierObj.getSubscribers()) and arrayLen(session.carrierObj.getSubscribers()) and isQuery(prc.cartPlan)  ) {
            prc.navItemsAction = ["upgradeline","protection","accessories","orderreview"];
          prc.navItemsText = ["Upgrade","Protection &amp; Services","Accessories","Order Review"];
          } else {
            prc.navItemsAction = ["carrierlogin","upgradeline","plans","protection","accessories","orderreview"];
            prc.navItemsText = ["Carrier Login","Upgrade","Plans and Data","Protection &amp; Services","Accessories","Order Review"];
          }

          // prc.addxStep = event.buildLink('devicebuilder.upgradeline') & '/type/upgradex/';
          prc.addxStep = prc.browseDevicesUrl;

          if ( session.cart.getCarrierId() eq prc.carrierIdAtt ) {
            prc.addxStep = this.browseDevicesUrlAtt;
          } else if ( session.cart.getCarrierId() eq prc.carrierIdVzw ) {
            prc.addxStep = this.browseDevicesUrlVzw;
          }
          
          // prc.tallyboxHeader = "Upgrading";
          prc.cartTypeId = 2;
          break;
        case "addaline":
          prc.navItemsAction = ["carrierlogin","plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Carrier Login","Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/type/addalinex/';
          // prc.tallyboxHeader = "Add a Line";
          prc.cartTypeId = 3;
          break;
        case "new":
          prc.navItemsAction = ["plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/type/newx/';
          // prc.tallyboxHeader = "New Customer (" & session.cart.getZipcode() & ")";
          prc.cartTypeId = 1;
          break;
        case "upgradex":
          prc.navItemsAction = ["upgradeline","protection","accessories","orderreview"];
          prc.navItemsText = ["Upgrade","Protection &amp; Services","Accessories","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.upgradeline') & '/type/upgradex/';
          // prc.tallyboxHeader = "Upgrading";
          prc.cartTypeId = 2;
          break;
        case "addalinex":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/type/addalinex/';
          // prc.tallyboxHeader = "Add a Line";
          prc.cartTypeId = 3;
          break;
        case "newx":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/type/newx/';
          // prc.tallyboxHeader = "New Customer";
          prc.cartTypeId = 1;
          break;
        default:
          prc.navItemsAction = [];
          prc.navItemsText = [];
          prc.addxStep = prc.browseDevicesUrl;
          break;
      }

      thisNavIndex = listFindNoCase(arrayToList(prc.navItemsAction), event.getCurrentAction());

      if (isNumeric(thisNavIndex) and thisNavIndex gt 1) {
        prevNavIndex = thisNavIndex - 1;
        prevAction = prc.navItemsAction[prevNavIndex];
        prc.prevStep = event.buildLink('devicebuilder.#prevAction#');
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
        prc.nextStep = event.buildLink('devicebuilder.#nextAction#');
      } else {
        prc.nextStep = "/index.cfm/go/checkout/do/billShip/";
      }

      prc.clearCartAction = event.buildLink('devicebuilder.clearcart');

      // <end Navigation


      // Omit TallyBox logic If updating an accessory from orderreview
      if (rc.cartLineNumber neq request.config.otherItemsLineNumber) {
        // <TALLY BOX
        prc.financeproductname = prc.productService.getFinanceProductName(carrierid = prc.productData.CarrierId);
        prc.tallyboxDueNow = 0;
        prc.tallyboxDueMonthly = 0;

        // Payment Options: financed, fullretail
        switch(prc.paymentoption) {
          case "financed":
            
            if (structKeyExists(prc,"subscriber") and structKeyExists(prc.subscriber,"downPayment") and prc.subscriber.downPayment gt 0) {
              prc.tallyboxFinanceMonthlyDueToday = prc.subscriber.downPayment;
            } else {
              // prc.subscriber.downPayment = 1000;
              prc.tallyboxFinanceMonthlyDueToday = 0;
            }
            
            // AT&T carrierId = 109, VZW carrierId = 42
            if ( prc.productData.CarrierId eq prc.carrierIdAtt ) {

              switch(prc.financed) {
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

          case "2yearcontract":
            prc.tallyboxFinanceMonthlyDueToday = prc.productData.price_upgrade;
            prc.tallyboxFinanceTitle = "2 Year Contract";
            prc.tallyboxFinanceMonthlyDueTitle = "Due Monthly";
            prc.tallyboxFinanceMonthlyDueAmount = 0;
            break;

          default:
            break;
        }
        prc.tallyboxDueMonthly = prc.tallyboxDueMonthly + prc.tallyboxFinanceMonthlyDueAmount;
        prc.tallyboxDueNow = prc.tallyboxDueNow + prc.tallyboxFinanceMonthlyDueToday;

        // GET CART DETAILS FOR DISPLAY:
        if ( structKeyExists(prc,"cartLines") and arrayLen(prc.cartLines) gte rc.cartLineNumber ) {
          prc.cartLine = prc.cartLines[rc.cartLineNumber];
          prc.selectedPhone = application.model.phone.getByFilter(idList = prc.cartLine.getPhone().getProductID(), allowHidden = true);
          
          if ( !prc.selectedPhone.recordCount ) {
            prc.selectedPhone = application.model.tablet.getByFilter(idList = prc.cartLine.getPhone().getProductID(), allowHidden = true);
          }
          if ( !prc.selectedPhone.recordCount ) {
            prc.selectedPhone = application.model.dataCardAndNetbook.getByFilter(idList = prc.cartLine.getPhone().getProductID(), allowHidden = true);
          }
          if ( !prc.selectedPhone.recordCount ) {
            prc.selectedPhone = application.model.prePaid.getByFilter(idList = prc.cartLine.getPhone().getProductID(), allowHidden = true);
          }
          if ( !prc.selectedPhone.recordCount ) {
            prc.selectedPhone = application.model.prePaid.getByFilter(idList = prc.cartLine.getPhone().getProductID(), allowHidden = true);
          }
          
          prc.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(prc.selectedPhone.deviceGuid);

          if ( prc.cartLine.getPlan().hasBeenSelected() ) {
            prc.selectedPlan = application.model.plan.getByFilter(idList = prc.cartLine.getPlan().getProductID());
          }

          prc.lineBundledAccessories = session.cartHelper.lineGetAccessoriesByType(line = rc.cartLineNumber, type = 'bundled');
          prc.lineFeatures = prc.cartLine.getFeatures();
          // prc.lineAccessories = session.dBuilderCartFacade.getAccessories(rc.cartLineNumber);
          prc.lineAccessories = application.model.dBuilderCartFacade.getAccessories(rc.cartLineNumber);
        }
        // <end tally box
      }
      

      
      // UPDATE CART TOTALS:
      if ( session.cartHelper.hasSelectedFeatures() ) {
        prc.qRecommendedServices = application.model.ServiceManager.getRecommendedServices();
      }
      session.cart.updateAllPrices();
      // session.cart.updateAllDiscounts();
      // session.cart.updateAllTaxes();
      // session.CartHelper.removeEmptyCartLines();
      // <end update cart totals



      event.setLayout('devicebuilder');
    </cfscript>
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

      // switch(rc.type) {

      switch(prc.customerType) {
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
    <cfset var accountArgs = {} />

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
          accountArgs = {
            carrierId = prc.productData.carrierId,
            SubscriberNumber = rc.PhoneNumber,
            ZipCode = rc.inputZip,
            SecurityId = rc.inputSSN,
            Passcode = rc.inputPin
          };

          // for testing purposes/development (carrierloginpost.cfm):
          rc.respObj = carrierFacade.Account(argumentCollection = accountArgs);
          rc.message = rc.respObj.getHttpStatus();

          // if (rc.respObj.getResult() is 'true') {
          if (rc.respObj.getResultDetail() is 'success') {
          
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
      prc.addalineStep = event.buildLink('devicebuilder.transfer') & '/type/addaline/';     
      prc.includeTooltip = true;
    </cfscript>
  </cffunction>


  <cffunction name="plans" returntype="void" output="false" hint="Plans page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var planArgs = {} />

    <cfscript>
    // TODO: if type is 'upgrade', make sure a line is selected.  If subscriber has not been selected, then send back to 'upgradealine'.

      planArgs = {
        carrierId = prc.productData.carrierId,
        zipCode = session.cart.getZipcode()
      };
      
      prc.planData = PlanService.getPlans(argumentCollection = planArgs);
      prc.planDataShared = PlanService.getSharedPlans(argumentCollection = planArgs);
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
    <cfset var planArgs = {} />

    <cfscript>
      prc.nextStep = event.buildLink('devicebuilder.protection');
      if (structKeyExists(rc,"plan")) {
        planArgs = {
          idList = rc.plan
        };
        prc.planInfo = PlanService.getPlans(argumentCollection = planArgs);
      }
      event.noLayout();
    </cfscript>
  </cffunction>


  <cffunction name="protection" returntype="void" output="false" hint="Protection and Services page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var servicesArgs = {} />

    <cfscript>
      if (!structKeyExists(rc, "isDownPaymentApproved")) {
        rc.isDownPaymentApproved = 0;
      }

      // get all warranties for this device:
      prc.qWarranty = application.model.Warranty.getByDeviceId(prc.device.getProductId());

      servicesArgs = {
        type = "O",
        deviceGuid = prc.productData.productGuid,
        HasSharedPlan = session.cart.getHasSharedPlan()
      };

      if (prc.productData.carrierId eq prc.carrierIdAtt) {
        servicesArgs.carrierId = prc.carrierGuidAtt;
      } else if (prc.productData.carrierId eq prc.carrierIdVzw) {
        servicesArgs.carrierId = prc.carrierGuidVzw;
      }

      prc.groupLabels = application.model.serviceManager.getServiceMasterGroups(argumentCollection = servicesArgs);
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
      prc.qAccessory = prc.CatalogService.getDeviceRelatedAccessories(prc.device.getProductId());
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
    <cfscript>
      // case 394: If the customer has logged into a carrier account or there is a plan tied to their cart then an option to add another device should show in the cart:
      if ( ( structKeyExists(session,"carrierObj") and isArray(session.carrierObj.getSubscribers()) and arrayLen(session.carrierObj.getSubscribers()) )  or isQuery(prc.cartPlan)  ) {
        prc.showAddAnotherDeviceButton = true;
      } else {
        prc.showAddAnotherDeviceButton = false;
      }
      // don't show top nav if cart is empty
      if (!arrayLen(prc.cartLines)) {
        prc.showNav = false;
      }
      // prc.additionalAccessories = session.dBuilderCartFacade.getAccessories(request.config.otherItemsLineNumber);
      prc.additionalAccessories = application.model.dBuilderCartFacade.getAccessories(request.config.otherItemsLineNumber);
      prc.includeTallyBox = false;
    </cfscript>
  </cffunction>


  <cffunction name="clearcart" returntype="void" output="false" hint="Order Review/Cart page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var carrierObjExists = false />

    <cfscript>

      // first store the zipcode in prc.scope.
      prc.zipcode = session.cart.getZipcode();

      // remove carrierObj from session: 
      carrierObjExists = structdelete(session, 'carrierObj', true);

      // reinitialize the cart
      session.cart = createObject('component','cfc.model.cart').init();
      session.cartHelper = createObject('component','cfc.model.carthelper').init();
      session.dBuilderCartFacade = createObject('component', 'fw.model.shopping.dbuilderCartFacade').init();

      // reset the session zipcode
      session.cart.setZipcode(prc.zipcode);

      rc.cartLineNumber = request.config.otherItemsLineNumber;

      // create warningMessage
      flash.put("warningMessage","Your cart has been cleared. <a href='#this.browseDevicesUrl#'>Click here to go to Browse Devices.</a>");
      flash.put("showNav", false);
      flash.put("showAddAnotherDeviceButton", false);
      flash.put("showCheckoutNowButton", false);
      flash.put("showClearCartLink", false);

      // event.setView("orderreview");
      
      setNextEvent(
        event="devicebuilder.orderreview",
        persist="zipcode,cartLineNumber"
        );
      
    </cfscript>
  </cffunction>


  <cffunction name="tallybox" returntype="void" output="false">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      event.noLayout();
    </cfscript>

  </cffunction>


</cfcomponent>
