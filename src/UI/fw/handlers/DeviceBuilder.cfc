<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="CarrierFacade" inject="id:CarrierFacade" />
  <cfproperty name="AttCarrier" inject="id:AttCarrier" />
  <cfproperty name="VzwCarrier" inject="id:VzwCarrier" />

  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <cfset listCustomerTypes = "upgrade,addaline,new,upgradex,addalinex,newx" /> <!--- x short for 'multi' or 'another' --->

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

      //TODO: rather than create default type and pid, should send user back to their CGI.http_referer/product detail page with alert to start over?
      
      // set Customer info in rc
      //TODO: This should be a method call.  Possibly a good starting stub for the Wireless data access object proxy. 
      //TODO: The phoneLines object should include the device id so that the correct device image can be displayed on the Upgrade page.
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

      if (!structKeyExists(rc,"type") OR !listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "upgrade";
      }
      // set Device info in rc
      if (!structKeyExists(rc,"pid") OR !isNumeric(rc.pid)) {
        // rc.pid = "00000";
        relocate( '/index.cfm' );
      }
      if (!structKeyExists(prc,"productData")) {
        prc.productData = application.model.phone.getByFilter(idList = rc.pid, allowHidden = true);
      }
      if (!isNumeric(prc.productData.productId)) {
        relocate( '/index.cfm' );
      };
      if (!structKeyExists(prc,"productService")) {
        prc.productService = application.wirebox.getInstance( "ProductService" );
      }
      if (!structKeyExists(prc,"productImages")) {
       prc.productImages = prc.productService.displayImages(prc.productData.deviceGuid, prc.productData.summaryTitle, prc.productData.BadgeType);
      }
      
      // Navigation
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
          // don't overwrite one that has been passed in (via Form, etc.):
          rc.nextAction = "devicebuilder.#nextAction#";
        }
        prc.nextStep = event.buildLink('devicebuilder.#nextAction#') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      } else {
        prc.nextStep = "/index.cfm/go/checkout/do/billShip/";
      }
      // /Navigation

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
    
    <cfset var isValid = 0 />

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


      switch (prc.productData.carrierId) {
        case 109: {
          rc.PhoneNumber = rc.inputPhone1 & rc.inputPhone2 & rc.inputPhone3;
          prc.args_account = {
            carrierId = prc.productData.carrierId,
            PhoneNumber = rc.PhoneNumber,
            ZipCode = rc.inputZip,
            SecurityId = rc.inputSSN,
            Passcode = rc.inputPin
          };

          // for testing purposes/development:
          rc.respObj = carrierFacade.Account(argumentCollection = prc.args_account);
          rc.message = rc.respObj.getHttpStatus();
          // rc.nextAction = "";

          switch ( rc.respObj.getHttpStatus() ) {
            case "200 OK": {
              // Relocate (comment out the next 3 lines to setview to carrierloginpost.cfm:)
              session.carrierObj = carrierFacade.Account(argumentCollection = prc.args_account);
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
        default: {
          rc.carrierResponseMessage = "The phone you selected for testing is not an AT&T device.  Please try again with an AT&T device. (carrierId: #prc.productData.carrierId#)";
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

    <cfscript>
      prc.includeTallyBox = false;
    </cfscript>
  </cffunction>


<!--- <cffunction name="aroundHandler" returntype="void" output="false" hint="Around handler">
    <cfargument name="event">
    <cfargument name="targetAction">
    <cfargument name="eventArguments">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      try{
        var args = {
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
