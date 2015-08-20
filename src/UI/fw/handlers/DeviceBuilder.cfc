<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <cfset listCustomerTypes = "upgrade,add,new" />

  <!--- Default Action --->
  <cffunction name="carrierLogin" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
      // rc.bBootStrapIncluded = true;
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/carrierlogin");
    </cfscript>
  </cffunction>


  <cffunction name="upgrade" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/upgrade");
    </cfscript>
  </cffunction>


  <cffunction name="plans" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/plans");
    </cfscript>
  </cffunction>


  <cffunction name="payment" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/payment");
    </cfscript>
  </cffunction>


  <cffunction name="accessories" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/accessories");
    </cfscript>
  </cffunction>


  <cffunction name="orderreview" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
      rc.deviceBuilderCssIncluded = true;
      rc.includeTallyBox = false;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/orderreview");
    </cfscript>
  </cffunction>


  <!--- Default Action --->
  <cffunction name="porting" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      if (NOT listFindNoCase(listCustomerTypes,rc.type)) {
        rc.type = "new";
      }
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/porting");
    </cfscript>
  </cffunction>


</cfcomponent>
