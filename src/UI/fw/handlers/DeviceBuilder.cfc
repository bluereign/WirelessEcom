<cfcomponent output="false" extends="BaseHandler">
  
  <cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
  <cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
  <cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
  <cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

  <!--- Default Action --->
  <cffunction name="carrierLogin" returntype="void" output="false" hint="Product details page">
    <cfargument name="event">
    <cfargument name="rc">
    <cfargument name="prc">

    <cfscript>
      // rc.bBootStrapIncluded = true;
      rc.deviceBuilderCssIncluded = true;
      event.setLayout('devicebuilder');
      event.setView("devicebuilder/carrier_login");
    </cfscript>
  </cffunction>

</cfcomponent>
