<cfscript>
  rc.NewcartLineNumber = arrayLen(session.cart.getLines()) + 1;
  cartArgs = {
      productType = "phone:upgrade",
      product_id = 27671,
      qty = 1,
      price = 299,
      cartLineNumber = rc.NewcartLineNumber
    };
    // session.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
    application.model.dBuilderCartFacade.addItem(argumentCollection = cartArgs);
    // session.cart.updateAllPrices();
    // session.cart.updateAllDiscounts();
    // session.cart.updateAllTaxes();
    // session.CartHelper.removeEmptyCartLines();
</cfscript>

<cfoutput>

  <cfset local.cartLines = session.cart.getLines()>

<table>
  <cfloop from="1" to="#arrayLen(local.cartLines)#" index="thisline">
    <cfset local.cartLine = local.cartLines[thisline]>
    <cfset local.lineFeatures = local.cartLine.getFeatures()>
    <tr><td colspan="2">Line: #thisline# productID: #local.cartLine.getPhone().getProductID()#</td></tr>
    <cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
      <cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID() />
      <cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
      <cfset local.thisServiceRecommended = false />
      <tr>
        <td>#local.thisFeature.summaryTitle#</td>
        <td class="price">#dollarFormat(local.lineFeatures[local.iFeature].getPrices().getMonthly())#/mo</td>
      </tr>
    </cfloop>
  </cfloop>
</table>

  <div class="col-md-12">
    <section class="content">
      <header class="main-header">
        <h1>Show Cart Type</h1>
      </header>

      <div>
        <p>session.cart.getActivationType(): #session.cart.getActivationType()#<br></p>
        <br>
        <cfif structKeyExists(application.model,"dBuilderCartFacade")>
          <p>application.model.dBuilderCartFacade.getPlan(): <cfdump var="#application.model.dBuilderCartFacade.getPlan()#">
          <br>
        </cfif>
        clearcart: <a href="#event.buildLink('devicebuilder.clearcart')#">Clear</a>
      </div>

    </section>
  </div>

</cfoutput>
