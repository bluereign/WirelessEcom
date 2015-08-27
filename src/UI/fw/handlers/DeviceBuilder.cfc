<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <cfset listCustomerTypes = "upgrade,addaline,new" />

  
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
      if (!structKeyExists(rc,"userData")) {
        rc.userData = {
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
          rc.navItemsAction = ["carrierlogin","upgrade","plans","payment","accessories","orderreview"];
          rc.navItemsText = ["Carrier Login","Upgrade/Add a Line","Plans and Data","Protection &amp; Services","Accessories","Order Review"];
          break;
        case "addaline":
          rc.navItemsAction = ["carrierlogin","upgrade","numberporting","plans","payment","accessories","orderreview"];
          rc.navItemsText = ["Carrier Login","Upgrade/Add a Line","Keep or Transfer Number","Plans and Data","Protection &amp; Services","Accessories","Order Review"];
          break;
        case "new":
          rc.navItemsAction = ["plans","payment","accessories","numberporting","orderreview"];
          rc.navItemsText = ["Plans and Data","Protection &amp; Services","Accessories","Number Porting","Order Review"];
          break;
        default:
          // same as 'upgrade'
          rc.navItemsAction = ["carrierlogin","upgrade","plans","payment","accessories","orderreview"];
          rc.navItemsText = ["Carrier Login","Upgrade/Add a Line","Plans and Data","Protection &amp; Services","Accessories","Order Review"];
          break;
      }

      thisNavIndex = listFindNoCase(arrayToList(rc.navItemsAction), listGetAt(rc.event,2,'.'));

      if (isNumeric(thisNavIndex) and thisNavIndex gt 1) {
        prevNavIndex = thisNavIndex - 1;
        prevAction = rc.navItemsAction[prevNavIndex];
        rc.prevStep = event.buildLink('devicebuilder.#prevAction#') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      } else {
        rc.prevStep = CGI.http_referer;
      }

      if (isNumeric(thisNavIndex) and thisNavIndex lt arrayLen(rc.navItemsAction)) {
        nextNavIndex = thisNavIndex + 1;
        nextAction = rc.navItemsAction[nextNavIndex];
        rc.nextStep = event.buildLink('devicebuilder.#nextAction#') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      } else {
        rc.nextStep = "/index.cfm/go/checkout/do/billShip/";
      }

      // /Navigation

      event.setLayout('devicebuilder');
    </cfscript>
  </cffunction>

  
  <!--- Default Action --->
  <cffunction name="carrierLogin" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      switch(rc.type) {
        case "upgrade":
          rc.inputSSNTooltipTitle = "Enter the last 4 numbers of the primary account holder's or authorized user's social security number to access account information to verify which phone numbers are eligible for upgrade.";
          break;
        case "addaline":
          rc.inputSSNTooltipTitle = "Enter the last four numbers of the primary account holder's or authorized user's social security number to access account information to verify a new line can be added to the account.";
          break;
        default:
          break;
      }
      
      rc.inputPinTooltipTitle = "This could be the last 4 numbers of the primary account holder's social security number or a unique number sequence the primary account holder created for the account. If you do not remember this number or have this number, please call the carrier.";
      rc.includeTooltip = true;

      event.setView("devicebuilder/carrierlogin");
    </cfscript>
  </cffunction>


  <cffunction name="upgrade" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.addalineStep = event.buildLink('devicebuilder.transfer') & '/pid/' & rc.pid & '/type/addaline/';     
      rc.includeTooltip = true;
      event.setView("devicebuilder/upgrade");
    </cfscript>
  </cffunction>


  <cffunction name="plans" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      event.setView("devicebuilder/plans");
    </cfscript>
  </cffunction>


  <cffunction name="payment" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      event.setView("devicebuilder/payment");
    </cfscript>
  </cffunction>


  <cffunction name="accessories" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var nextAction = "" />
    <cfset var prevAction = "" />

    <cfscript>
      prc.CatalogService = application.model.Catalog;
      prc.qAccessory = prc.CatalogService.getDeviceRelatedAccessories( event.getValue('pid', '') );
      prc.AssetPaths = variables.AssetPaths;

      event.setView("devicebuilder/accessories");
    </cfscript>
  </cffunction>


  <cffunction name="orderreview" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var prevAction = "" />

    <cfscript>
      rc.includeTallyBox = false;
      event.setView("devicebuilder/orderreview");
    </cfscript>
  </cffunction>


  <!--- Default Action --->
  <cffunction name="numberporting" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.includeTooltip = true;
      event.setView("devicebuilder/numberporting");
    </cfscript>
  </cffunction>


</cfcomponent>
