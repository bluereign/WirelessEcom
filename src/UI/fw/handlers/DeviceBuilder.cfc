<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="CarrierFacade" inject="id:CarrierFacade" />
  <cfproperty name="PlanService" inject="id:PlanService" />

  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <cfset this.preHandler_except = "planmodal" />

  <cfset listCustomerTypes = "upgrade,addaline,new,upgradex,addalinex,newx" /> <!--- x short for 'multi' or 'another' --->
  <cfset listCustomerTypesRequireLogin = "upgrade,addaline,upgradex,addalinex" />
  <cfset listActionsRequireLogin = "upgradeline,plans,protection,accessories,numberporting,orderreview" />

  <!--- preHandler --->
  <cffunction name="preHandler" returntype="void" output="false" hint="preHandler">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfset var thisNavIndex = "" />
    <cfset var nextNavIndex = "" />
    <cfset var prevNavIndex = "" />
    <cfset var nextAction = "" />
    <cfset var prevAction = "" />
    <cfset var argsPlan = {} />
    
    <cfscript>
      // KEEP THIS INCASE YOU NEED TO CLEAR CARRIER RESPONSE OBJECT AGAIN AFTER API CHANGES
      // carrierObjExists = structdelete(session, 'carrierObj', true);

      prc.browseDevicesUrl = "/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/";
      prc.AssetPaths = variables.AssetPaths;


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
      if (!structKeyExists(rc,"type") OR !listFindNoCase(listCustomerTypes,rc.type)) {
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


      // <PRODUCT CHECK
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
      // end product check
      

      // <NAVIATION
      switch(rc.type) {
        case "upgrade":
          prc.navItemsAction = ["carrierlogin","upgradeline","plans","protection","accessories","orderreview"];
          prc.navItemsText = ["Carrier Login","Upgrade","Plans and Data","Protection &amp; Services","Accessories","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.upgradeline') & '/pid/' & rc.pid & '/type/upgradex/';
          prc.tallyboxHeader = "Upgrading";
          break;
        case "addaline":
          prc.navItemsAction = ["carrierlogin","plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Carrier Login","Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/addalinex/';
          prc.tallyboxHeader = "Add a Line";
          break;
        case "new":
          prc.navItemsAction = ["plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/newx/';
          prc.tallyboxHeader = "New Customer";
          break;
        case "upgradex":
          prc.navItemsAction = ["upgradeline","protection","accessories","orderreview"];
          prc.navItemsText = ["Upgrade","Protection &amp; Services","Accessories","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.upgradeline') & '/pid/' & rc.pid & '/type/upgradex/';
          prc.tallyboxHeader = "Upgrading";
          break;
        case "addalinex":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/addalinex/';
          prc.tallyboxHeader = "Add a Line";
          break;
        case "newx":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/newx/';
          prc.tallyboxHeader = "New Customer";
          break;
        default:
          // same as 'upgrade'
          prc.navItemsAction = ["carrierlogin","upgradeline","plans","protection","accessories","orderreview"];
          prc.navItemsText = ["Carrier Login","Upgrade","Plans and Data","Protection &amp; Services","Accessories","Order Review"];
          break;
      }

      thisNavIndex = listFindNoCase(arrayToList(prc.navItemsAction), event.getCurrentAction());

      if (isNumeric(thisNavIndex) and thisNavIndex gt 1) {
        prevNavIndex = thisNavIndex - 1;
        prevAction = prc.navItemsAction[prevNavIndex];
        prc.prevStep = event.buildLink('devicebuilder.#prevAction#') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
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
        prc.nextStep = event.buildLink('devicebuilder.#nextAction#') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
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
          prc.planDataExisting = prc.subscriber.getRatePlan();
          prc.activetab = "existing";
          // TODO: Wrap the following in a phone number formatting function:
          prc.subscriber.phoneNumber = reReplace(prc.subscriber.getNumber(),"[{}\(\)\^$&%##!@=<>:;,~`'\'\*\?\/\+\|\[\\\\]|\]|\-",'','all');
          prc.subscriber.phoneNumber1 = left(prc.subscriber.phoneNumber, 3);
          prc.subscriber.phoneNumber2 = mid(prc.subscriber.phoneNumber, 4, 3);
          prc.subscriber.phoneNumber3 = right(prc.subscriber.phoneNumber, 4);
          prc.subscriber.phoneNumber = "(#prc.subscriber.phoneNumber1#) #prc.subscriber.phoneNumber2#-#prc.subscriber.phoneNumber3#";

          prc.tallyboxHeader = "Upgrading " & prc.subscriber.phoneNumber;
        }
        // TODO: Else if page is 'plans' and type is 'upgrade', send redirect the logged in user to the upgradeline page here...
      }
      // <end selected line


      // <SELECTED PLAN
      if (structKeyExists(rc,"plan") and isNumeric(rc.plan)) {
        argsPlan.carrierId = prc.productData.carrierId;
        argsPlan.zipCode = session.cart.getZipcode();
        argsPlan.idList = rc.plan;
        prc.planInfo = PlanService.getPlans(argumentCollection=argsPlan);
      }
      // <end selected plan


      // <CARRIER LOGO

      // <end carrier logo


      // <LAYOUT
      event.setLayout('devicebuilder');
      // <end layout
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


  <cffunction name="carrierLoginPost" returntype="void" output="false" hint="Carrier Login page">
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
    <!--- <cfdump var="#rc.nextAction#"><cfabort> --->

    <cfscript>
      // simple server-side validation
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
            AND
            len(rc.inputPin) gte 4 and len(rc.inputPin) lte 10
          )
        ) {
        rc.carrierResponseMessage = "There was an issue with the values you entered.  Please double check each value and then try again.";
        setNextEvent(
          event="devicebuilder.carrierLogin",
          persist="type,pid,carrierResponseMessage,inputPhone1,inputPhone2,inputPhone3,inputZip,inputSSN,inputPin");
      }
      // /simple validation


      switch (prc.productData.carrierId) {
        // AT&T carrierId = 109, VZW carrierId = 42
        case 109: case 42: {
          rc.PhoneNumber = rc.inputPhone1 & rc.inputPhone2 & rc.inputPhone3;
          prc.argsAccount = {
            carrierId = prc.productData.carrierId,
            SubscriberNumber = rc.PhoneNumber,
            ZipCode = rc.inputZip,
            SecurityId = rc.inputSSN,
            Passcode = rc.inputPin
          };

          // for testing purposes/development (carrierloginpost.cfm):
          rc.respObj = carrierFacade.Account(argumentCollection = prc.argsAccount);
          rc.message = rc.respObj.getHttpStatus();

          switch ( rc.respObj.getHttpStatus() ) {
            // Status of '200 OK' is success:
            case "200 OK": {
              session.carrierObj = rc.respObj;
              // session.zipCode = session.carrierObj.getAddress().getZipCode();
              session.cart.setZipcode(listFirst(session.carrierObj.getAddress().getZipCode(), '-'));

              if (prc.productData.carrierId eq 109) {
                session.carrierObj.carrierLogo = "#prc.assetPaths.common#images/carrierLogos/att_logo_25.png";
              } else if (prc.productData.carrierId eq 42) {
                session.carrierObj.carrierLogo = "#prc.assetPaths.common#images/carrierLogos/verizon_logo_25.png";
              }
              
              // we only set carrier when they've logged in.  But, do we need carrier in the session?
              // session.cart.setCarrierId(prc.productData.carrierId);

              // TODO: Change above line to set session.cart.setCarrierId() from the carrierObj response when the method has been developed and made available.

              // Relocate (comment out the next 3 lines to setview to carrierloginpost.cfm for debugging:)
              setNextEvent(
                event="#rc.nextAction#",
                persist="type,pid");
              break;
            }
            default: {
              rc.carrierResponseMessage = "We were unable to authenticate your wireless carrier information at this time.  Please try again.";
              setNextEvent(
                event="devicebuilder.carrierLogin",
                persist="type,pid,carrierResponseMessage,inputPhone1,inputPhone2,inputPhone3,inputZip,inputSSN,inputPin");
            }
          };
          break;
        }
        // Other carriers
        // TODO: Determine how to handle the off chance of a customer arriving here with a device that's not AT&T or Verizon
        default: {
          rc.carrierResponseMessage = "The phone you selected for testing is not an AT&T or Verizon device.  Please try again with an AT&T or Verizon device. (carrierId: #prc.productData.carrierId#)";
          setNextEvent(
            event="devicebuilder.carrierLogin",
            persist="type,pid,carrierResponseMessage,inputPhone1,inputPhone2,inputPhone3,inputZip,inputSSN,inputPin");
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
    <cfset var argsPlan = {} />

    <cfscript>
    // TODO: if type is 'upgrade', make sure a line is selected.  If rc.line does not exist, then send back to 'upgradealine'.

      argsPlan.carrierId = prc.productData.carrierId;
      argsPlan.zipCode = session.cart.getZipcode();
      
      prc.planData = PlanService.getPlans(argumentCollection=argsPlan);
      prc.planDataShared = PlanService.getSharedPlans(argumentCollection=argsPlan);
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
      </cfif>
    </cfif>


    <!--- debugging: --->
    <!--- <cfset prc.planDataShared = queryNew("id") /> --->
    <!--- <cfdump var="#prc.planDataShared#"><cfabort> --->
  </cffunction>


  <cffunction name="planmodal" returntype="void" output="false" hint="Plan modal">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var argsPlan = {} />

    <cfscript>
      if (structKeyExists(rc,"plan")) {
        argsPlan.idList = rc.plan;
        prc.planInfo = PlanService.getPlans(argumentCollection=argsPlan);
      }
      event.noLayout();
    </cfscript>

  </cffunction>


  <cffunction name="protection" returntype="void" output="false" hint="Protection and Services page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <!--- TODO: If rc.plan does not exist, then send back to "plans" --->

    <!--- <cfdump var="#rc#"><cfabort> --->

  </cffunction>


  <cffunction name="accessories" returntype="void" output="false" hint="Accessories page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var nextAction = "" />
    <cfset var prevAction = "" />

    <cfscript>
      prc.CatalogService = application.model.Catalog;
      prc.qAccessory = prc.CatalogService.getDeviceRelatedAccessories( event.getValue('pid', '') );
    </cfscript>
  </cffunction>


  <cffunction name="numberporting" returntype="void" output="false" hint="Number Porting page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      prc.includeTooltip = true;
      // event.setView("devicebuilder/numberporting");
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
      // TODO: Remove all items in the cart.

      // remove carrierObj from session: 
      carrierObjExists = structdelete(session, 'carrierObj', true);
      
      // TODO: Remove the following 2 lines after testing to comply with case 195
      // remove zipCode from session:
      // carrierObjExists = structdelete(session, 'zipCode', true);

      // create warningMessage
      flash.put("warningMessage","Your cart has been cleared. <a href='#prc.browseDevicesUrl#'>Click here to go to Browse Devices.</a>");
      flash.put("showNav", false);
      flash.put("showAddAnotherDeviceButton", false);
      flash.put("showCheckoutNowButton", false);
      flash.put("showClearCartLink", false);

      setNextEvent(
        event="devicebuilder.orderreview",
        persist="type,pid"
        );
      
    </cfscript>
  </cffunction>


</cfcomponent>
