<cfcomponent output="false" extends="BaseHandler">
	
	<!--- Use CFProperty to declare beans for injection.  By default, they will be placed in the variables scope --->
	<cfproperty name="assetPaths" inject="id:assetPaths" scope="variables" />

	<cfif cgi.server_port neq 443 and not request.config.disableSSL>
		<cflocation url="https://#cgi.HTTP_HOST##cgi.path_info#" addtoken="false" />
	</cfif>
	
	<cffunction name="searchOrders" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		
		<cfset var local = {} />
		<cfset currTime = now()>
		<cfset startDate = DateFormat(DateAdd('d', -31, currTime),'yyyy-mm-dd') >
		<cfset odfrom = startDate />	
		<cfset odto = "" />
		
		<cfscript>
			local.searchArgs = {
				kioskID = session.vfd.kioskNumber,
				orderDateFrom = odfrom,
				orderDateTo = odto
			};
			/*session.ddadmin.searchArgs = local.searchArgs;*/
			
			rc.qOrders = application.model.order.getDDOrderReprints(local.searchArgs);
			event.setLayout('CheckoutVFD');
			event.setView('VFD/omt/orderSearchVFD');
		</cfscript>
		
	</cffunction> 
	
	<cffunction name="orderConfirmationReprint" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfset session.checkout.OrderId = orderID/>
		<cfset event.setView(view='VFD/checkout/confirmationCostco',nolayout=true) />
	</cffunction>
	
	<cffunction name="modifyOrder" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<!---<cfset session.checkout.OrderId = orderID/>--->
		
		<cfset rc.qWirelesslines = application.model.WirelessLine.getWirelessLineByOrder(orderID)/>
		
		<cfset event.setLayout('CheckoutVFD') />
		<cfset event.setView(view='VFD/checkout/modifyOrder') />
	</cffunction>
	
	<cffunction name="printConfirmation" returntype="void" output="false">
    		<cfset event.setView(view='VFD/checkout/confirmationCostco',nolayout=true) />
    </cffunction>
	
</cfcomponent>