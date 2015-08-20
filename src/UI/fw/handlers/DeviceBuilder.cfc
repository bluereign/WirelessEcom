<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <cfset listCustomerTypes = "upgrade,add,new" />

  <!--- preHandler --->
  <cffunction name="preHandler" returntype="void" output="false" hint="preHandler">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfset rc.yohomey = 1>
    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
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
      rc.nextStep = event.buildLink('devicebuilder.upgrade') & '/type/' & rc.type;
      event.setView("devicebuilder/carrierlogin");
    </cfscript>
  </cffunction>


  <cffunction name="upgrade" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var nextAction = "" />

    <cfscript>
      switch(rc.type) {
        case "upgrade":
          nextAction = "devicebuilder.plans";
          break;
        case "add":
          nextAction = "devicebuilder.transfer";
          break;
        default: 
          nextAction = "devicebuilder.plans";
          break;
      }

      rc.prevStep = event.buildLink('devicebuilder.carrierLogin') & '/type/' & rc.type;
      rc.nextStep = event.buildLink(nextAction) & '/type/' & rc.type;
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
          rc.prevStep = event.buildLink('devicebuilder.upgrade') & '/type/' & rc.type;
          break;
        case "add":
          rc.prevStep = event.buildLink('devicebuilder.transfer') & '/type/' & rc.type;
          break;
        case "new":
          rc.prevStep = CGI.http_referer;
          break;
        default: 
          rc.prevStep = CGI.http_referer;
          break;
      }
      
      rc.nextStep = event.buildLink('devicebuilder.payment') & '/type/' & rc.type;
      event.setView("devicebuilder/plans");
    </cfscript>
  </cffunction>


  <cffunction name="transfer" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.prevStep = event.buildLink('devicebuilder.upgrade') & '/type/' & rc.type;
      rc.nextStep = event.buildLink('devicebuilder.plans') & '/type/' & rc.type;
      event.setView("devicebuilder/transfer");
    </cfscript>
  </cffunction>


  <cffunction name="payment" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      rc.prevStep = event.buildLink('devicebuilder.plans') & '/type/' & rc.type;
      rc.nextStep = event.buildLink('devicebuilder.accessories') & '/type/' & rc.type;
      event.setView("devicebuilder/payment");
    </cfscript>
  </cffunction>


  <cffunction name="accessories" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">
    <cfset var nextAction = "" />

    <cfscript>
      switch(rc.type) {
        case "upgrade":
          nextAction = "devicebuilder.orderreview";
          break;
        case "add":
          nextAction = "devicebuilder.orderreview";
          break;
        case "new":
          nextAction = "devicebuilder.porting";
          break;
        default: 
          nextAction = "devicebuilder.orderreview";
          break;
      }
      rc.prevStep = event.buildLink('devicebuilder.plans') & '/type/' & rc.type;
      rc.nextStep = event.buildLink(nextAction) & '/type/' & rc.type;
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
        case "add":
          prevAction = "devicebuilder.accessories";
          break;
        case "new":
          prevAction = "devicebuilder.porting";
          break;
        default: 
          prevAction = "devicebuilder.accessories";
          break;
      }
      rc.prevStep = event.buildLink(prevAction) & '/type/' & rc.type;
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
      rc.prevStep = event.buildLink('devicebuilder.accessories') & '/type/' & rc.type;
      rc.nextStep = event.buildLink('devicebuilder.orderreview') & '/type/' & rc.type;
      event.setView("devicebuilder/porting");
    </cfscript>
  </cffunction>


</cfcomponent>
