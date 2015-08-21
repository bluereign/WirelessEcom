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
    
    <cfscript>
      //TODO: rather than create default type and pid, should send user back to their CGI.http_referer/product detail page with alert to start over?
      
      // set Customer info in rc
      if (!structKeyExists(rc,"type") OR !listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
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
      // set Device info in rc
      if (!structKeyExists(rc,"pid") OR !isNumeric(rc.pid)) {
        rc.pid = "00000";
        // relocate( '/index.cfm' );
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

      // rc.bBootStrapIncluded = true;
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
    </cfscript>
  </cffunction>

  
  <!--- Default Action --->
  <cffunction name="carrierLogin" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.prevStep = CGi.http_referer;
      rc.nextStep = event.buildLink('devicebuilder.upgrade') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      event.setView("devicebuilder/carrierlogin");
    </cfscript>
  </cffunction>


  <cffunction name="upgrade" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var nextAction = "" />
    <cfset var prevAction = "" />

    <cfscript>
      switch(rc.type) {
        case "upgrade":
          prevAction = "devicebuilder.carrierLogin";
          nextAction = "devicebuilder.plans";
          break;
        case "addaline":
          prevAction = "devicebuilder.carrierLogin";
          nextAction = "devicebuilder.transfer";
          break;
        default: 
          prevAction = "devicebuilder.carrierLogin";
          nextAction = "devicebuilder.plans";
          break;
      }

      rc.prevStep = event.buildLink(prevAction) & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      rc.nextStep = event.buildLink(nextAction) & '/pid/' & rc.pid & '/type/' & rc.type & '/';

      event.setView("devicebuilder/upgrade");
    </cfscript>
  </cffunction>


  <cffunction name="plans" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      switch(rc.type) {
        case "upgrade":
          rc.prevStep = event.buildLink('devicebuilder.upgrade') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
          break;
        case "addaline":
          rc.prevStep = event.buildLink('devicebuilder.transfer') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
          break;
        case "new":
          rc.prevStep = CGI.http_referer;
          break;
        default: 
          rc.prevStep = CGI.http_referer;
          break;
      }
      
      rc.nextStep = event.buildLink('devicebuilder.payment') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      event.setView("devicebuilder/plans");
    </cfscript>
  </cffunction>


  <cffunction name="transfer" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.prevStep = event.buildLink('devicebuilder.upgrade') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      rc.nextStep = event.buildLink('devicebuilder.plans') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      event.setView("devicebuilder/transfer");
    </cfscript>
  </cffunction>


  <cffunction name="payment" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.prevStep = event.buildLink('devicebuilder.plans') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      rc.nextStep = event.buildLink('devicebuilder.accessories') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
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
      switch(rc.type) {
        case "upgrade":
          prevAction = "devicebuilder.plans";
          nextAction = "devicebuilder.orderreview";
          break;
        case "addaline":
          prevAction = "devicebuilder.payment";
          nextAction = "devicebuilder.orderreview";
          break;
        case "new":
          prevAction = "devicebuilder.payment";
          nextAction = "devicebuilder.porting";
          break;
        default: 
          prevAction = "devicebuilder.plans";
          nextAction = "devicebuilder.orderreview";
          break;
      }
      rc.prevStep = event.buildLink(prevAction) & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      rc.nextStep = event.buildLink(nextAction) & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      event.setView("devicebuilder/accessories");
    </cfscript>
  </cffunction>


  <cffunction name="orderreview" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var prevAction = "" />

    <cfscript>
      switch(rc.type) {
        case "upgrade":
          prevAction = "devicebuilder.accessories";
          break;
        case "addaline":
          prevAction = "devicebuilder.accessories";
          break;
        case "new":
          prevAction = "devicebuilder.porting";
          break;
        default: 
          prevAction = "devicebuilder.accessories";
          break;
      }
      rc.prevStep = event.buildLink(prevAction) & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      rc.nextStep = "/index.cfm/go/checkout/do/billShip/";
      rc.includeTallyBox = false;
      event.setView("devicebuilder/orderreview");
    </cfscript>
  </cffunction>


  <!--- Default Action --->
  <cffunction name="porting" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.prevStep = event.buildLink('devicebuilder.accessories') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      rc.nextStep = event.buildLink('devicebuilder.orderreview') & '/pid/' & rc.pid & '/type/' & rc.type & '/';
      event.setView("devicebuilder/porting");
    </cfscript>
  </cffunction>


</cfcomponent>
