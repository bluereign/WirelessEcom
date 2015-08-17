<cfcomponent output="false">
	
	<cffunction name="init" output="false" access="public" returntype="cfc.model.carrierservice.CustomerAccountGateway">
		<cfreturn this />
	</cffunction>


	<cffunction name="createPlan" output="false" access="public" returntype="numeric">
		<cfargument name="CustomerAccountPlan" type="cfc.model.carrierservice.CustomerAccountPlan" required="true" />

		<cfquery name="qPlan" datasource="#application.dsn.wirelessadvocates#">
			INSERT INTO service.CustomerLookUpPlan
			(
				ReferenceNumber
				, CarrierId
				, Mdn
				, IsPrimary
				, CarrierBillCode
				, Title
			)
			VALUES
			(
				<cfqueryparam value="#arguments.CustomerAccountPlan.getReferenceNumber()#" cfsqltype="cf_sql_varchar" null="#NOT len(arguments.CustomerAccountPlan.getReferenceNumber())#" />
				, <cfqueryparam value="#arguments.CustomerAccountPlan.getCarrierId()#" cfsqltype="cf_sql_integer" null="#NOT len(arguments.CustomerAccountPlan.getCarrierId())#" />
				, <cfqueryparam value="#arguments.CustomerAccountPlan.getMdn()#" cfsqltype="cf_sql_varchar" null="#NOT len(arguments.CustomerAccountPlan.getMdn())#" />
				, <cfqueryparam value="#arguments.CustomerAccountPlan.getIsPrimary()#" cfsqltype="cf_sql_bit" null="#NOT len(arguments.CustomerAccountPlan.getIsPrimary())#" />
				, <cfqueryparam value="#arguments.CustomerAccountPlan.getCarrierBillCode()#" cfsqltype="cf_sql_varchar" null="#NOT len(arguments.CustomerAccountPlan.getCarrierBillCode())#" />
				, <cfqueryparam value="#arguments.CustomerAccountPlan.getTitle()#" cfsqltype="cf_sql_varchar" null="#NOT len(arguments.CustomerAccountPlan.getTitle())#" />
			)
			
			SELECT SCOPE_IDENTITY() AS CustomerLookUpPlanId
		</cfquery>
	
		<cfreturn qPlan.CustomerLookUpPlanId />
	</cffunction>


	<cffunction name="createFeatures" output="false" access="public" returntype="any">
		<cfargument name="CustomerAccountFeatures" type="cfc.model.carrierservice.CustomerAccountFeature[]" required="true" />
	
		<cfset var feature = '' />
		
		<cfquery datasource="#application.dsn.wirelessadvocates#">
			<cfloop array="#arguments.CustomerAccountFeatures#" index="feature">
				INSERT INTO service.CustomerLookUpService
				(
					CustomerLookUpPlanId
					, ReferenceNumber
					, CarrierId
					, CarrierBillCode
					, Title
				)
				VALUES
				(
					<cfqueryparam value="#feature.getCustomerLookUpPlanId()#" cfsqltype="cf_sql_integer" null="#NOT len(feature.getCustomerLookUpPlanId())#" />
					, <cfqueryparam value="#feature.getReferenceNumber()#" cfsqltype="cf_sql_varchar" null="#NOT len(feature.getReferenceNumber())#" />
					, <cfqueryparam value="#feature.getCarrierId()#" cfsqltype="cf_sql_integer" null="#NOT len(feature.getCarrierId())#" />
					, <cfqueryparam value="#feature.getCarrierBillCode()#" cfsqltype="cf_sql_varchar" null="#NOT len(feature.getCarrierBillCode())#" />
					, <cfqueryparam value="#feature.getTitle()#" cfsqltype="cf_sql_varchar" null="#NOT len(feature.getTitle())#" />
				)
			</cfloop>
		</cfquery>
	
		<cfreturn 1 />
	</cffunction>

	
	<cffunction name="getConflictingOrderSocCodes" output="false" access="public" returntype="query">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfset var qConflicts = '' />

		<cfquery name="qConflicts" datasource="#application.dsn.wirelessadvocates#">
			SELECT 
				OrderServices.OrderId
				, OrderServices.CheckoutReferenceNumber
				, OrderServices.OrderDetailId
				, OrderServices.ProductId
				, OrderServices.GroupName
				, OrderServices.ProductTitle				
				, AccountServices.MDN
				, AccountServices.ReferenceNumber
				, AccountServices.CarrierBillCode
				, AccountServices.Title 
			FROM
			(
				SELECT 
					o.OrderId
					, o.CheckoutReferenceNumber
					, od.OrderDetailId
					, od.ProductId
					, od.GroupName
					, (
						SELECT
							wl.CurrentMDN
						FROM salesorder.WirelessLine wl
						INNER JOIN salesorder.OrderDetail od2 ON od2.OrderDetailId = wl.OrderDetailId
						WHERE od2.GroupName = od.GroupName AND od2.OrderId = o.OrderId
					  ) MDN
					, ls.CarrierServiceId CarrierBillCode
					, od.ProductTitle
				FROM salesorder.[Order] o
				INNER JOIN salesorder.OrderDetail od ON od.OrderId = o.OrderId
				INNER JOIN salesorder.LineService ls ON ls.OrderDetailId = od.OrderDetailId
				WHERE o.OrderId = <cfqueryparam value="#arguments.order.getOrderId()#" cfsqltype="cf_sql_integer" />
			) AS OrderServices
			INNER JOIN
			(
				SELECT DISTINCT
					cp.MDN
					, cp.ReferenceNumber
					, cs.CarrierBillCode
					, cs.Title 
				FROM service.CustomerLookUpPlan cp 
				INNER JOIN service.CustomerLookUpService cs ON cs.CustomerLookUpPlanId = cp.CustomerLookUpPlanId
				WHERE cs.ReferenceNumber = <cfqueryparam value="#arguments.order.getCheckoutReferenceNumber()#" cfsqltype="cf_sql_varchar" />
			) AS AccountServices ON 
				AccountServices.MDN = OrderServices.MDN
				AND AccountServices.CarrierBillCode = OrderServices.CarrierBillCode
				AND AccountServices.ReferenceNumber = OrderServices.CheckoutReferenceNumber
		</cfquery>

		<cfreturn qConflicts />
	</cffunction>
	
	
	<cffunction name="getCustomerLookupResponses" output="false" access="public" returntype="query">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfscript>
			var qCarrierResponses = '';
			var carrierName = '';
			var responseName = '';
			
			switch( arguments.order.getCarrierId() )
			{
				case '42':
				{
					carrierName = 'Verizon';
					responseName = 'ServiceCustomerLookup';
					break;
				}
				case '109':
				{
					carrierName = 'ATT';
					responseName = 'CustomerLookupByMdn';
					break;
				}
				case '128':
				{
					carrierName = 'TMobile';
					responseName = 'ServiceCustomerLookup';
					break;
				}
			}
		</cfscript>

		<cfquery name="qCarrierResponses" datasource="#application.dsn.wirelessadvocates#">
			SELECT 
				l.Id
				, l.LoggedDateTime
				, l.ReferenceNumber
				, l.Carrier
				, l.Type
				, l.RequestType
				, l.Data 
			FROM service.CarrierInterfaceLog l WITH (NOLOCK) 
			WHERE 
				Carrier = <cfqueryparam value="#carrierName#" cfsqltype="cf_sql_varchar" />
				AND Type = 'Response'
				AND RequestType = <cfqueryparam value="#responseName#" cfsqltype="cf_sql_varchar" />
				AND ReferenceNumber = <cfqueryparam value="#arguments.order.getCheckoutReferenceNumber()#" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<cfreturn qCarrierResponses />
	</cffunction>
	
	
</cfcomponent>