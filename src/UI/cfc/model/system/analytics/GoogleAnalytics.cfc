<cfcomponent displayname="GoogleAnalytics">

	<cffunction name="init" access="public" output="false" returntype="GoogleAnalytics">
		<cfargument name="GoogleAnalyticsId" type="string" required="true" />
		<cfargument name="DomainName" type="string" required="true" />
		<cfargument name="UseUniversalAnalytics" type="boolean" required="true" />
		
		<cfscript>
			setGoogleAnalyticsId( arguments.GoogleAnalyticsId );
			setDomainName( arguments.DomainName );
			setUseUniversalAnalytics( arguments.UseUniversalAnalytics );
		</cfscript>
		
		<cfreturn this />
	</cffunction>


	<cffunction name="tagPage" access="public" output="false" returntype="string">
		<cfset var local = structNew()>
		<cfparam name="request.googleAnalyticsGenerated" type="boolean" default="false">
		<cfset local.return = "">

		<!---We use three variables to determine GA ID: environment, VFD flag, and channel (Costco, PM, AFFES)---->
		<cfif IsDefined("application.globalproperties.environmentid")>
			<cfset local.environment = application.globalproperties.environmentid>
		<cfelse>
			<cfset local.environment = "production">
		</cfif>
		
		<cftry>
			<cfset local.isVFD = application.wirebox.getInstance("ChannelConfig").getVfdEnabled()/>
			<cfcatch>
				<cfset local.isVFD = false>
			</cfcatch>
		</cftry>
				
		<cfset local.channelName = request.config.ChannelName>
				
		<cfswitch expression="#local.channelName#">
			<cfcase value="costco">
				<cfif local.isVFD>
					<cfswitch expression="#local.environment#">
						<cfcase value="development">
							<cfset googleAnalyticsID = "UA-62999104-2">
						</cfcase>
						
						<cfcase value="test">
							<cfset googleAnalyticsID = "UA-62999104-3">
						</cfcase>
						
						<cfcase value="production">
							<cfset googleAnalyticsID = "UA-62999104-1">
						</cfcase>
						
						<cfdefaultcase>
							<cfset googleAnalyticsID = "">
						</cfdefaultcase>

					</cfswitch>				
				<cfelse>
					<cfswitch expression="#local.environment#">
						<cfcase value="development">
							<cfset googleAnalyticsID = "UA-20996841-3">
						</cfcase>
						
						<cfcase value="test">
							<cfset googleAnalyticsID = "UA-20996841-2">						
						</cfcase>
						
						<cfcase value="production">
							<cfset googleAnalyticsID = "UA-20996841-1">
						</cfcase>
						
						<cfdefaultcase>
							<cfset googleAnalyticsID = "">
						</cfdefaultcase>

					</cfswitch>					
				</cfif>
			</cfcase>
			
			<cfcase value="aafes">
				<cfif local.isVFD>
					<cfswitch expression="#local.environment#">
						<cfcase value="development">
							<cfset googleAnalyticsID = "UA-62976397-2">
						</cfcase>
						
						<cfcase value="test">
							<cfset googleAnalyticsID = "UA-62976397-3">	
						</cfcase>
						
						<cfcase value="production">
							<cfset googleAnalyticsID = "UA-62976397-1">	
						</cfcase>
						
						<cfdefaultcase>
							<cfset googleAnalyticsID = "">
						</cfdefaultcase>

					</cfswitch>				
				<cfelse>
					<cfswitch expression="#local.environment#">
						<cfcase value="development">
							<cfset googleAnalyticsID = "UA-42001859-4">
						</cfcase>
						
						<cfcase value="test">
							<cfset googleAnalyticsID = "UA-42001859-3">		
						</cfcase>
						
						<cfcase value="production">
							<cfset googleAnalyticsID = "UA-42001859-1">
						</cfcase>
						
						<cfdefaultcase>
							<cfset googleAnalyticsID = "">
						</cfdefaultcase>

					</cfswitch>					
				</cfif>				
			</cfcase>

			<cfcase value="pagemaster">
				<!---This should never happen there is no Pagemaster VFD---->
				<cfif local.isVFD>
					<cfset googleAnalyticsID = "">			
				<cfelse>
					<cfswitch expression="#local.environment#">
						<cfcase value="development">
							<cfset googleAnalyticsID = "">	
						</cfcase>
						
						<cfcase value="test">
							<cfset googleAnalyticsID = "">	
						</cfcase>
						
						<cfcase value="production">
							<cfset googleAnalyticsID = "UA-53542232-1">	
						</cfcase>
						
						<cfdefaultcase>
							<cfset googleAnalyticsID = "">	
						</cfdefaultcase>

					</cfswitch>					
				</cfif>				
			</cfcase>
			
			<cfdefaultcase>
					<cfset googleAnalyticsID = "">
			</cfdefaultcase>
			
		</cfswitch>


		<cfif not request.googleAnalyticsGenerated>	
			<cfsavecontent variable="local.return">
				<cfoutput>
					<cfif getUseUniversalAnalytics()>
						<script>
							(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
							(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
							m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
							})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
							
							ga('create', '#googleAnalyticsID#', 'auto');
							ga('send', 'pageview');
						</script>
					<cfelse>
						<script type="text/javascript">
							var _gaq = _gaq || [];
							_gaq.push(['_setAccount', '#googleAnalyticsID#']);
							_gaq.push(['_setDomainName', 'none']);
							_gaq.push(['_setAllowLinker', true]);					  
							_gaq.push(['_trackPageview']);
							
							(function() {
							var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
							ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
							var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
							})();
						</script>
					</cfif>
				</cfoutput>
			</cfsavecontent>

			<cfset request.googleAnalyticsGenerated = true> <!--- TRV: ensures that we never call google analytics routines more than once in a single request --->
		</cfif>

		<cfreturn local.return>
	</cffunction>

	<cffunction name="tagOrderConfirmation" access="public" output="false" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true">
		<cfset var local = arguments>
		<cfparam name="request.googleAnalyticsGenerated" type="boolean" default="false">
		<cfset local.return = "">
		<cfset local.CarrierName = application.model.Carrier.getCarrierNameById(local.order.getCarrierId()) />

		<cfset local.orderDetails = local.order.getOrderDetail()>

		<cfsavecontent variable="local.return">
			<cfoutput>
				<cfif getUseUniversalAnalytics()>
					<script type="text/javascript">
						ga('require', 'ecommerce', 'ecommerce.js');
						
						ga('ecommerce:addTransaction', {
							'id': '#local.order.getOrderId()#',                 // Transaction ID. Required.
							'affiliation': '#local.CarrierName#',   			// Affiliation or store name.
							'revenue': '#local.order.getSubTotal()+0#',         // Grand Total.
							'shipping': '#local.order.getShipCost()+0#',        // Shipping.
							'tax': '#local.order.getTaxTotal()+0#'              // Tax.
						});

						<cfloop from="1" to="#arrayLen(local.orderDetails)#" index="iItem">
							<cfset local.thisItem = local.orderDetails[iItem]>
							ga('ecommerce:addItem', {
								'id': '#local.order.getOrderId()#',                 // Transaction ID. Required.
								'name': '#local.thisItem.getProductTitle()#',    	// Product name. Required.
								'sku': '#local.thisItem.getGersSku()#',             // SKU/code.
								'category': '#local.thisItem.getFullOrderDetailType(local.thisItem.getOrderDetailType())#',  // Category or variation.
								'price': '#local.thisItem.getNetPrice()+0#',        // Unit price.
								'quantity': '#local.thisItem.getQty()#'             // Quantity.
							});
						</cfloop>

						ga('ecommerce:send');
						ga('ecommerce:clear');
					</script>
				<cfelse>
					<script type="text/javascript">
				         _gaq.push(['_addTrans',      
				            '#local.order.getOrderId()#',           			// order ID - required
				            '#local.CarrierName#', 								// affiliation or store name
				            '#local.order.getSubTotal()+0#',          			// total - required
				            '#local.order.getTaxTotal()+0#',           			// tax
				            '#local.order.getShipCost()+0#',          			// shipping
				            '#local.order.getBillAddress().getCity()#',       	// city
				            '#local.order.getBillAddress().getState()#',     	// state or province
				            'USA'             									// country
				         ]);
	
						<cfloop from="1" to="#arrayLen(local.orderDetails)#" index="iItem">
							<cfset local.thisItem = local.orderDetails[iItem]>
							_gaq.push(['_addItem',
							   '#local.order.getOrderId()#',           			// order ID - necessary to associate item with transaction
							   '#local.thisItem.getGersSku()#',           		// SKU/code - required
							   '#local.thisItem.getProductTitle()#',        	// product name
							   '#local.thisItem.getFullOrderDetailType(local.thisItem.getOrderDetailType())#', 	// category or variation
							   '#local.thisItem.getNetPrice()+0#',          	// unit price - required
							   '#local.thisItem.getQty()#'               		// quantity - required
							]);
						</cfloop>
	
						_gaq.push(['_trackTrans']);
					</script>
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.return />
	</cffunction>




	<cffunction name="getCarrierAcronym" access="private" output="false" returntype="string">
		<cfargument name="carrierId" type="numeric" required="true">
		
			<cfscript>
				var carrierAcronym = "";
			
				switch( arguments.carrierId )
				{
					case 109:
					{
						carrierAcronym = "ATT";
						break;
					}
					case 128:
					{
						carrierAcronym = "TMO";
						break;
					}
					case 42:
					{
						carrierAcronym = "VZN";
						break;
					}
					case 299:
					{
						carrierAcronym = "SPT";
						break;
					}					
					default:
					{
						carrierAcronym = "";
						break;
					}
				}
			
			</cfscript>
		
		<cfreturn carrierAcronym />
	</cffunction>
    
    <cffunction name="getGoogleAnalyticsId" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.GoogleAnalyticsId />
    </cffunction>
    <cffunction name="setGoogleAnalyticsId" access="public" returntype="void" output="false">
    	<cfargument name="GoogleAnalyticsId" type="string" required="true" />
    	<cfset variables.instance.GoogleAnalyticsId = arguments.GoogleAnalyticsId />
    </cffunction>

    <cffunction name="getDomainName" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.DomainName />
    </cffunction>
    <cffunction name="setDomainName" access="public" returntype="void" output="false">
    	<cfargument name="DomainName" type="string" required="true" />
    	<cfset variables.instance.DomainName = arguments.DomainName />
    </cffunction>

    <cffunction name="getUseUniversalAnalytics" access="public" returntype="boolean" output="false">
    	<cfreturn variables.instance.UseUniversalAnalytics />
    </cffunction>
    <cffunction name="setUseUniversalAnalytics" access="public" returntype="void" output="false">
    	<cfargument name="UseUniversalAnalytics" type="boolean" required="true" />
    	<cfset variables.instance.UseUniversalAnalytics = arguments.UseUniversalAnalytics />
    </cffunction>
	<cffunction name="getChannelConfig" output="false" access="private" returntype="any">
    	<cfreturn application.wirebox.getInstance("ChannelConfig") />
	</cffunction>

</cfcomponent>