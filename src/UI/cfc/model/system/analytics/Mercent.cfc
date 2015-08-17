<cfcomponent displayname="Mercent">

	<cffunction name="init" access="public" output="false" returntype="Mercent">
		<cfargument name="MerchantId" type="string" required="true" />
		<cfargument name="ClientId" type="string" required="true" />

		<cfscript>
			setMerchantId( arguments.MerchantId );
			setClientId( arguments.ClientId );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="tagPage" access="public" output="false" returntype="string">
		<cfset var local = structNew()>
		<cfparam name="request.MercentGenerated" type="boolean" default="false">
		<cfset local.return = "">

		<cfif not request.MercentGenerated>
			<cfsavecontent variable="local.return">
				<cfoutput>
					<script type="text/javascript"> 
					var mr_jsHost = (("https:" == document.location.protocol) ? "https://" : "http://"); 
					document.write(unescape("%3Cscript src='" + mr_jsHost + "cdn.mercent.com/js/tracker.js' type='text/javascript'%3E%3C/script%3E"));
					</script>

					<script type="text/javascript"> 
					try
					{ 
					mr_merchantID = "#getMerchantId()#";
					mr_Track(); 
					} catch(err) {}
					</script>

					<script type='text/javascript'>
					var _marinClientId = "#getClientId()#";
					var _marinProto = (("https:" == document.location.protocol) ? "https://" : "http://");
					document.write(unescape("%3Cscript src='" + _marinProto + "tracker.marinsm.com/tracker/" +
					_marinClientId + ".js' type='text/javascript'%3E%3C/script%3E"));
					</script>

					<script type='text/javascript'>
					try {
					_marinTrack.trackPage();
					} catch(err) {
					}

					</script>
					<noscript>
						<img src="http://tracker.marinsm.com/tp?act=1&cid=#getClientId()#&script=no" alt="" />
					</noscript>
				</cfoutput>
			</cfsavecontent>

			<cfset request.MercentGenerated = true>
		</cfif>
		<cfreturn local.return>
	</cffunction>


	<cffunction name="tagOrderConfirmation" access="public" output="false" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true">
		<cfset var local = arguments>

		<cfparam name="request.MercentGenerated" type="boolean" default="false">

		<cfset local.return = "">
		<cfset local.CarrierName = application.model.Carrier.getCarrierNameById(local.order.getCarrierId()) />

		<cfset local.orderDetails = local.order.getOrderDetail()>

		<cfsavecontent variable="local.return">
			<cfoutput>

				<form style='display:none;' name='utmform'>
				<textarea id='utmtrans'>
				UTM:T|#local.order.getOrderId()#|#local.CarrierName#|#local.order.getSubTotal()+0#|#local.order.getTaxTotal()+0#|#local.order.getShipCost()+0#|#local.order.getBillAddress().getCity()#|#local.order.getBillAddress().getState()#|USA
				UTM:I|#local.order.getOrderId()#|Sale|||#local.order.getSubTotal()+0#|
				</textarea>
				</form>

				<script type='text/javascript'>
					var _marinClientId = "#getClientId()#";
					var _marinProto = (("https:" == document.location.protocol) ? "https://" : "http://");
					document.write(unescape("%3Cscript src='" + _marinProto + "tracker.marinsm.com/tracker/" +
					_marinClientId + ".js' type='text/javascript'%3E%3C/script%3E"));
				</script>
				<script type='text/javascript'>
				try {
				_marinTrack.processOrders();
				} catch(err) {}
				</script>
				<noscript>
					<img src="https://tracker.marinsm.com/tp?act=2&cid=#getClientId()#&trans=UTM:T|#local.order.getOrderId()#|affiliation|#local.order.getSubTotal()+0#|#local.order.getTaxTotal()+0#|#local.order.getShipCost()+0#|#local.order.getBillAddress().getCity()#|#local.order.getBillAddress().getState()#|USA%0AUTM:I|#local.order.getOrderId()#|Sale|||#local.order.getSubTotal()+0#|" />
				</noscript>

				<script type="text/javascript">				

				mr_conv["type"] = "order";
				mr_conv["id"] = "#local.order.getOrderId()#";
				mr_conv["customerId"] = "";
				mr_conv["amount"] = "#local.order.getSubTotal()+0#";
				mr_conv["shipping"] = "#local.order.getShipCost()+0#";
				mr_conv["tax"] = "#local.order.getTaxTotal()+0#";
				mr_conv["discount"] = "";
				mr_conv["postalCode"] = "#local.order.getBillAddress().getZip()#";
				mr_conv["countryCode"] = "USA";

				<cfloop from="1" to="#arrayLen(local.orderDetails)#" index="iItem">

					<cfset local.thisItem = local.orderDetails[iItem]>

					<cfif #local.thisItem.getOrderDetailType()# is 'd' || #local.thisItem.getOrderDetailType()# is 'a'>
						mr_convOrderItem["sku"] = "#local.thisItem.getGersSku()#";
						mr_convOrderItem["title"] = "#local.thisItem.getProductTitle()#";
						mr_convOrderItem["url"] = "http://membershipwireless.com/#local.thisItem.getProductId()#/#local.thisItem.getProductTitle()#";
						mr_convOrderItem["qty"] = "#local.thisItem.getQty()#";
						mr_convOrderItem["extPrice"] = "#local.thisItem.getNetPrice()+0#";

						mr_addConvOrderItem(mr_convOrderItem);					
					</cfif>
				</cfloop>

				mr_sendConversion();
				</script>

			</cfoutput>
		</cfsavecontent>

		<cfreturn local.return>
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

    <cffunction name="getMerchantId" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.MerchantId />
    </cffunction>
    <cffunction name="setMerchantId" access="public" returntype="void" output="false">
    	<cfargument name="MerchantId" type="string" required="true" />
    	<cfset variables.instance.MerchantId = arguments.MerchantId />
    </cffunction>
    
    <cffunction name="getClientId" access="public" returntype="string" output="false">
    	<cfreturn variables.instance.ClientId />
    </cffunction>
    <cffunction name="setClientId" access="public" returntype="void" output="false">
    	<cfargument name="ClientId" type="string" required="true" />
    	<cfset variables.instance.ClientId = arguments.ClientId />
    </cffunction>    

</cfcomponent>