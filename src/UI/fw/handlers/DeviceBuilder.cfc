<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="CarrierFacade" inject="id:CarrierFacade" />
  <cfproperty name="AttCarrier" inject="id:AttCarrier" />
  <cfproperty name="VzwCarrier" inject="id:VzwCarrier" />

  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

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
    
    <cfscript>
      prc.browseDevicesUrl = "/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0/";


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
          break;
        case "addaline":
          prc.navItemsAction = ["carrierlogin","plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Carrier Login","Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/addalinex/';
          break;
        case "new":
          prc.navItemsAction = ["plans","protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/newx/';
          break;
        case "upgradex":
          prc.navItemsAction = ["upgradeline","protection","accessories","orderreview"];
          prc.navItemsText = ["Upgrade","Protection &amp; Services","Accessories","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.upgradeline') & '/pid/' & rc.pid & '/type/upgradex/';
          break;
        case "addalinex":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/addalinex/';
          break;
        case "newx":
          prc.navItemsAction = ["protection","accessories","numberporting","orderreview"];
          prc.navItemsText = ["Protection &amp; Services","Accessories","Number Porting","Order Review"];
          prc.addxStep = event.buildLink('devicebuilder.protection') & '/pid/' & rc.pid & '/type/newx/';
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


      // <LAYOUT
      event.setLayout('devicebuilder');
      // <end layout


      // <TEMP dummy data:
      if (!structKeyExists(prc,"userData")) {
        prc.userData = {
          phoneLines = [
            {phoneNumber = "(206) 555 - 1111", isAvailable = true},
            {phoneNumber = "(206) 555 - 4545", isAvailable = true},
            {phoneNumber = "(206) 555 - 2222", isAvailable = true},
            {phoneNumber = "(206) 555 - 3333", isAvailable = false},
            {phoneNumber = "(206) 555 - 4444", isAvailable = false},
            {phoneNumber = "(206) 555 - 5555", isAvailable = false},
            {phoneNumber = "(206) 555 - 6666", isAvailable = false}
            ],
          username = "thedude",
          firstname = "The",
          middleinitial = "L",
          lastname = "Dude",
          company = "Self-employed",
          address1 = "Hey Bro St.",
          address2 = "",
          city = "Los Angelos",
          state = "CA",
          zip = "90210",
          homephone = "123-432-1231",
          workphone = ""
        };
      }
      // <end Temp dummy data


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
          prc.args_account = {
            carrierId = prc.productData.carrierId,
            PhoneNumber = rc.PhoneNumber,
            ZipCode = rc.inputZip,
            SecurityId = rc.inputSSN,
            Passcode = rc.inputPin
          };

          // for testing purposes/development (carrierloginpost.cfm):
          rc.respObj = carrierFacade.Account(argumentCollection = prc.args_account);
          rc.message = rc.respObj.getHttpStatus();

          switch ( rc.respObj.getHttpStatus() ) {
            // Status of '200 OK' is success:
            case "200 OK": {
              session.carrierObj = carrierFacade.Account(argumentCollection = prc.args_account);
              // session.zipCode = session.carrierObj.getAddress().getZipCode();
              session.cart.setZipcode(listFirst(session.carrierObj.getAddress().getZipCode(), '-'));
              // we only set carrier when they've logged in.  But, do we need carrier in the session?
              // session.cart.setCarrierId(prc.productData.carrierId);

              // TODO: Change above line to set session.cart.setCarrierId() from the carrierObj response when the method has been developed and made available.

              // Relocate (comment out the next 3 lines to setview to carrierloginpost.cfm:)
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
      prc.addalineStep = event.buildLink('devicebuilder.transfer') & '/pid/' & rc.pid & '/type/addaline/';     
      prc.includeTooltip = true;
    </cfscript>
  </cffunction>


  <cffunction name="plans" returntype="void" output="false" hint="Plans page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    
    <!--- 
    First attempts....
    <cfset prc.planData = application.model.plan.getByFilter(idList=rc.pid, sort="PriceAsc") />
    <cfset prc.planData = application.model.plan.getByFilter(sort="PriceAsc") />
    <cfquery name="prc.planData" dbtype="query">
      select * from prc.planData where carrierid = #prc.productData.carrierId# order by planprice
    </cfquery>
    --->
    
    <cfquery name="prc.planData" datasource="#application.dsn.wirelessAdvocates#">
      SELECT  p.RateplanGuid , p.ProductGuid , p.PlanId , p.ProductId , p.GersSku , p.CarrierBillCode , p.PlanName , p.PlanType , p.IsShared , p.PageTitle , p.SummaryTitle , p.DetailTitle , p.FamilyPlan , p.CompanyName , p.CarrierName , p.CarrierId , p.CarrierGuid , p.CarrierLogoSmall , p.CarrierLogoMedium , p.CarrierLogoLarge , p.SummaryDescription , p.DetailDescription , p.MetaKeywords , p.PlanPrice , p.MonthlyFee , p.IncludedLines , p.MaxLines , p.AdditionalLineFee , p.minutes_anytime , p.minutes_offpeak , p.minutes_mobtomob , p.minutes_friendsandfamily , p.unlimited_offpeak , p.unlimited_mobtomob , p.unlimited_friendsandfamily , p.unlimited_data , p.unlimited_textmessaging , p.free_longdistance , p.free_roaming , p.data_limit , p.DataLimitGB , p.additional_data_usage , IsNull( (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.ProductGuid = p.ProductGuid AND pp.Name = 'PLAID_DEVICE_CAP_INDICATOR'), 'N') HasPlanDeviceCap 
      FROM  catalog.dn_Plans AS p WITH (NOLOCK) 
      WHERE 1 = 1 
        AND p.carrierID IN ( #prc.productData.carrierId# ) 
        AND p.PlanPrice > 0 
        ORDER BY p.planPrice ASC, CAST(p.minutes_anytime AS integer) ASC, CAST(p.DataLimitGB AS DECIMAL(10,5)) ASC
    </cfquery>
  </cffunction>


  <cffunction name="protection" returntype="void" output="false" hint="Protection and Services page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
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
      prc.AssetPaths = variables.AssetPaths;
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


<!--- <cffunction name="aroundHandler" returntype="void" output="false" hint="Around handler">
    <cfargument name="event">
    <cfargument name="targetAction">
    <cfargument name="eventArguments">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var args = "">

    <cfscript>
      try{
        args = {
          event = arguments.event,
          rc    = arguments.rc,
          prc   = arguments.prc

        };
        structAppend(args,eventArguments);
        return arguments.targetAction(argumentCollection=args);
      }
      catch(Any e){
        log.error("Error executing #targetAction.toString()#: #e.message# #e.detail#", e);
        event.setValue("exception", e)
          .setView("devicebuilder/error");
      }
    </cfscript>
  
</cffunction> --->


</cfcomponent>
