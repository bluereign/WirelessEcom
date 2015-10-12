<cfparam name="local.deviceGuidList" type="string" default="" />

<cfif application.model.cartHelper.hasSelectedFeatures()>
  <cfset qRecommendedServices = application.model.ServiceManager.getRecommendedServices() />
</cfif>

<!--- Following logic refactored from cfc/view/Cart.cfc Line 233 through 1419 --->
<cfloop from="1" to="#arrayLen(prc.cartLines)#" index="local.iCartLine">
  <cfset local.cartLine = prc.cartLines[local.iCartLine] />
  <cfset local.showAddServiceButton = false />
  <cfset local.selectedPhone = application.model.phone.getByFilter(idList = local.cartLine.getPhone().getProductID(), allowHidden = true) />
  
  <cfif not local.selectedPhone.recordCount>
    <cfset local.selectedPhone = application.model.tablet.getByFilter(idList = local.cartLine.getPhone().getProductID()) />
  </cfif>
  
  <cfif not local.selectedPhone.recordCount>
    <cfset local.selectedPhone = application.model.dataCardAndNetbook.getByFilter(idList = local.cartLine.getPhone().getProductID()) />
  </cfif>

  <cfif not local.selectedPhone.recordCount>
    <cfset local.selectedPhone = application.model.prePaid.getByFilter(idList = local.cartLine.getPhone().getProductID()) />
  </cfif>

  <cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPhone.deviceGuid) />

  <cfif session.cart.getUpgradeType() neq 'equipment-only' && not session.cart.getPrePaid() && session.cart.getAddALineType() neq 'family' && session.cart.getActivationType() neq 'nocontract'>  
    <cfif local.cartLine.getPlan().hasBeenSelected()>
      <cfset local.selectedPlan = application.model.plan.getByFilter(idList = local.cartLine.getPlan().getProductID()) />
      <cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedPlan.productGuid) />
    </cfif>
  </cfif>

  <!--- Bundled Accessories --->
  <cfset local.thisLineBundledAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.iCartLine, type = 'bundled') />
  
  <cfif arrayLen(local.thisLineBundledAccessories)> <!--- from cfc/view/Cart.cfc line 339 --->
    <cfloop from="1" to="#arrayLen(local.thisLineBundledAccessories)#" index="local.iAccessory">
      <cfset local.thisAccessory = local.thisLineBundledAccessories[local.iAccessory] />
      <cfset local.selectedAccessory = application.model.accessory.getByFilter(idList = local.thisAccessory.getProductID()) />
      <cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid) />
      <cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedAccessory.accessoryGuid) />
    </cfloop>
  </cfif>

  <!--- Plan --->
  <cfif local.cartLine.getPlan().hasBeenSelected()>
    
    <cfset local.carrierObj = application.wirebox.getInstance("Carrier") />  <!--- from cfc/view/Cart.cfc line 441 --->
    <!---- Upgrades do not have the activation fee waived --->
    <cfif session.cart.getActivationType() CONTAINS 'upgrade'>
      <cfset local.upgradeFee = local.carrierObj.getUpgradeFee( session.cart.getCarrierID() )>
    <cfelse>
      <cfset local.activationFee = local.carrierObj.getActivationFee( session.cart.getCarrierID() )>
    </cfif> <!--- end CONTAINS 'upgrade' --->
    
  </cfif> <!--- end local.cartLine.getPlan().hasBeenSelected() --->

  <!--- Services --->
  <cfset local.lineFeatures = local.cartLine.getFeatures() />

  <cfloop from="1" to="#arrayLen(local.lineFeatures)#" index="local.iFeature">
    <cfset local.thisFeatureID = local.lineFeatures[local.iFeature].getProductID() />
    <cfset local.thisFeature = application.model.feature.getByProductID(local.thisFeatureID) />
    <cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.thisFeature.serviceGuid) />
    <cfset local.thisServiceRecommended = false />

    <!--- Check if service is recommended --->
    <cfif qRecommendedServices.RecordCount>
      <cfloop query="qRecommendedServices">
        <cfif qRecommendedServices.productId eq local.thisFeatureId>
          <cfset local.thisServiceRecommended = true />
          <cfbreak />
        </cfif>
      </cfloop>
    </cfif>
  </cfloop>

  <!--- Line Accessories --->
  <cfif arrayLen(local.cartLine.getAccessories())>  <!--- from cfc/view/Cart.cfc line 705 --->
    <cfset local.selectedAccessories = application.model.cartHelper.lineGetAccessoriesByType(line = local.iCartLine, type = 'accessory') />
    <cfloop from="1" to="#arrayLen(local.selectedAccessories)#" index="local.iAccessory">
      <cfset local.thisAccessory = local.selectedAccessories[local.iAccessory] />
      <cfset local.selectedAccessory = application.model.accessory.getByFilter(idList = local.thisAccessory.getProductID()) />
      <cfset local.stcPrimaryImage = application.model.imageManager.getPrimaryImagesForProducts(local.selectedAccessory.accessoryGuid) />
      <cfset local.deviceGuidList = listAppend(local.deviceGuidList, local.selectedAccessory.accessoryGuid) />
    </cfloop>
  </cfif>

  <!--- Line warranty --->
  <cfif local.cartLine.getWarranty().hasBeenSelected()>
    <cfset local.selectedWarranty = application.model.Warranty.getById( local.cartLine.getWarranty().getProductId() ) />
  </cfif>

  <!--- Instant MIR --->
  <cfif local.cartLine.getInstantRebateAmount() gt 0>
    <cfset local.cartLine.getPrices().setDueToday( local.cartLine.getPrices().getDueToday() - local.cartLine.getInstantRebateAmount() )>
  </cfif>

</cfloop>
