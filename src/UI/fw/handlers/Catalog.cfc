<cfcomponent output="false" extends="BaseHandler">
	
	<cfproperty name="AssetPaths" inject="id:assetPaths" scope="variables" />
	<cfproperty name="channelConfig" inject="id:channelConfig" scope="variables" />
	<cfproperty name="textDisplayRenderer" inject="id:textDisplayRenderer" scope="variables" />
	<cfproperty name="stringUtil" inject="id:stringUtil" scope="variables" />

	<!--- Default Action --->
	<cffunction name="list" returntype="void" output="false" hint="I display phones with the dynamic skin.">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfscript>
			var ProductService = createObject('component', 'cfc.model.Phone').init();
			rc.PriceDisplayType = 'new';
			rc.CampaignService = wirebox.getInstance("CampaignService");
			rc.displayedProductCount = 0; //Number of items displayed after being filtered out

			if ( rc.CampaignService.doesCurrentCampaignSubdomainExist() )
			{
				//get the campaign from this subdomain
				rc.campaign = rc.CampaignService.getCampaignBySubdomain( rc.CampaignService.getCurrentSubdomain() );
		
				//check if we have a valid css file for this channel/branding
				if ( NOT fileExists(ExpandPath('#assetPaths.channel#/styles/campaigns/') & '#rc.CampaignService.getCurrentSubdomain()#_v#rc.campaign.getVersion()#.css') )
				{
					rc.CampaignService.generateCSS( rc.CampaignService.getCurrentSubdomain() );
				}
			}
		
			// Determine activation type pricing to display
			if (event.getValue('ActivationType', '') contains 'upgrade')
			{
				rc.PriceDisplayType = 'upgrade';
			}
			
			rc.data = ProductService.getByFilter(); //Get product list

			event.setView("product/deviceListing");
		</cfscript>
		
	</cffunction>

	<cffunction name="invalid" returntype="void" output="false" hint="I display phones with the dynamic skin.">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">

		<cfset event.setView("product/invalid")>
	</cffunction>

	<cffunction name="accessoryForDeviceList" returntype="void" output="false" hint="Partial view returning HTML snippet">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfscript>
			prc.CatalogService = application.model.Catalog;
			prc.qAccessory = prc.CatalogService.getDeviceRelatedAccessories( event.getValue('pid', '') );
			prc.AssetPaths = variables.AssetPaths;
			
			event.noLayout();
			event.setView("product/accessoryForDeviceList");
		</cfscript>

	</cffunction>

	<cffunction name="deviceSpecification" returntype="void" output="false" hint="Partial view returning HTML snippet">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfscript>
			prc.qDeviceSpecs = application.model.phone.getSpecs( event.getValue('pid', '') );
			
			event.noLayout();
			event.setView("product/deviceSpecification");
		</cfscript>

	</cffunction>

	<cffunction name="deviceForAccessoryList" returntype="void" output="false" hint="Partial view returning HTML snippet">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfscript>
			prc.CatalogService = application.model.Catalog;
			prc.qDevice = application.model.catalog.getAccessoryRelatedDevices( event.getValue('pid', '') );
			prc.AssetPaths = variables.AssetPaths;
			prc.stringUtil = variables.stringUtil;
			
			event.noLayout();
			event.setView("product/deviceForAccessoryList");
		</cfscript>

	</cffunction>

	<cffunction name="detail" returntype="void" output="false" hint="Product details page">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfset prc.filterType = "PhoneFilter" />
		<cfset prc.productClass = "Phone" />
		<cfset prc.productTag = "phone" />
		<cfset prc.label = "Phone" />
		<cfset prc.labelPlural = "Phones" />
		<cfset prc.filterSelections = "session.phoneFilterSelections" />
		<cfset prc.indexedViewName = "dn_Phones" />
		<cfset request.currentTopNav = 'phones.detail'>
		<cfset prc.priceModifier = StructNew()>

		<cfscript>
			rc.PriceDisplayType = 'new';

			// Determine activation type pricing to display
			if (event.getValue('ActivationType', '') contains 'upgrade') {
				rc.PriceDisplayType = 'upgrade';
			} else if (event.getValue('ActivationType', '') contains 'addaline') {
				rc.PriceDisplayType = 'addaline';
			}
			
			prc.allocation = createObject('component', 'cfc.model.Allocation').init();
			prc.channelConfig = application.wirebox.getInstance("ChannelConfig");
			prc.textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer");
			prc.productFilter = application.wirebox.getInstance( prc.filterType );
			prc.productService = application.wirebox.getInstance( "ProductService" );
			prc.ProductView = application.view.Phone;

			prc.productData = application.model.phone.getByFilter(idList = rc.pid, allowHidden = true);
			if ( !isNumeric( prc.productData.productId ) ) {
				relocate( '/index.cfm' );
			};
			prc.featuresData = application.model.phone.getFeatures( prc.productData.productId );
			prc.freeAccessories = application.model.phone.getFreeAccessories( prc.productData.productId );
			prc.AssetPaths = variables.AssetPaths;
			prc.financeproductname = prc.productService.getFinanceProductName(carrierid=#prc.productData.carrierid#);
			
			if(IsDefined("Session.VFD.access") and Session.VFD.access){
				local.AvailableQty = prc.productData.realQtyOnHand;
			}else{
				local.AvailableQty = prc.productData.QtyOnHand;
			}
			
			
			//Base Add-to-Cart view arguments
			prc.renderAddToCartArgs = {
				ProductClass = prc.productClass
				, PriceType = 'new' //Default
				, CarrierId = prc.productData.CarrierId
				, ProductId = prc.productData.ProductId
				, AvailableQty = local.AvailableQty
				, IsSmartPhone = prc.productData.IsSmartPhone
				, IsNoContractRestricted = prc.productData.IsNoContractRestricted
				, IsNewActivationRestricted = prc.productData.IsNewActivationRestricted
				, IsUpgradeActivationRestricted = prc.productData.IsUpgradeActivationRestricted
				, IsAddALineActivationRestricted = prc.productData.IsAddALineActivationRestricted
				, IsTMORedirect = false //TODO: Figure out where to get this
				, TMOBuyURL = '' //TODO: Figure out where to get this
				, IsAvailableInWarehouse = prc.productData.IsAvailableInWarehouse
				, IsProductCompatibleWithPlan = true //TODO: Figure out logic
			};

			//Price display string for 2-year price range
			if (prc.productData.price_new eq prc.productData.price_upgrade && prc.productData.price_upgrade eq prc.productData.price_addaline)
				prc.2yearPriceRangeDisplay = "#DollarFormat(prc.productData.price_new)#"; // All activations types share the same price
			else
			{
				prc.2yearPrices = ListToArray("#prc.productData.price_new#,#prc.productData.price_upgrade#,#prc.productData.price_addaline#");
				prc.2yearMinPrice = ArrayMin(prc.2yearPrices); //find min price
				prc.2yearMaxNum = ArrayMax(prc.2yearPrices); //find max price
				
				prc.2yearPriceRangeDisplay = "#DollarFormat(prc.2yearMinPrice)# to #DollarFormat(prc.2yearMaxNum)#"; //List min to max price
			}
			
			//Price display string for financed prices range
			if (prc.productData.FinancedMonthlyPrice12 eq prc.productData.FinancedMonthlyPrice18 && prc.productData.FinancedMonthlyPrice18 eq prc.productData.FinancedMonthlyPrice24)
				prc.FinancedPriceRangeDisplay = "#DollarFormat(prc.productData.FinancedMonthlyPrice12)#"; // All financed types share the same price
			else if ( ListFind("42,299,128", prc.productData.CarrierId))
				prc.FinancedPriceRangeDisplay = "#DollarFormat(prc.productData.FinancedMonthlyPrice24)#"; // Sprint and Verizon and TMO currently only have 24 month plans
			else
			{
				prc.financedPrices = ListToArray("#prc.productData.FinancedMonthlyPrice12#,#prc.productData.FinancedMonthlyPrice18#,#prc.productData.FinancedMonthlyPrice24#");
				prc.minFiancedPrice = ArrayMin(prc.financedPrices); //find min price
				prc.maxFinancedNum = ArrayMax(prc.financedPrices); //find max price
				
				prc.FinancedPriceRangeDisplay = "#DollarFormat(prc.minFiancedPrice)# to #DollarFormat(prc.maxFinancedNum)#"; //List min to max price
			}
			
			
//			check rebate pricing
			
			if(val(prc.productData.newPriceAfterRebate)){
				// has a new price after rebate
				prc.priceModifier.newPriceRebateAmount = prc.productData.price_new - prc.productData.newPriceAfterRebate;
				prc.priceModifier.price_new = prc.productData.newPriceAfterRebate;
			}
			
			if(val(prc.productData.upgradePriceAfterRebate)){
				// has a new price after rebate
				prc.priceModifier.upgradePriceRebateAmount = prc.productData.price_upgrade - prc.productData.upgradePriceAfterRebate;
				prc.priceModifier.price_upgrade = prc.productData.upgradePriceAfterRebate;
			}
			
			if(val(prc.productData.addalinePriceAfterRebate)){
				// has a new price after rebate
				prc.priceModifier.addalinePriceRebateAmount = prc.productData.price_addaline - prc.productData.addalinePriceAfterRebate;
				prc.priceModifier.price_addaline = prc.productData.addalinePriceAfterRebate;
			}				
		</cfscript>

		<cfset prc.workflowHTML = application.view.cart.renderWorkflowController()>
		<cfset prc.productImages = prc.productService.displayImages(prc.productData.deviceGuid, prc.productData.summaryTitle, prc.productData.BadgeType)>

		<cfscript>
			rc.bBootStrapIncluded = true;
			event.setLayout('main');
			if(prc.productData.carrierid == 128 AND channelConfig.getTmoRedirectEnabled() AND !channelConfig.getVFDEnabled()){
				event.setView("product/detail_tmo");
			} else {
				event.setView("product/detail_new");				
			}			
		</cfscript>

	</cffunction>

</cfcomponent>
