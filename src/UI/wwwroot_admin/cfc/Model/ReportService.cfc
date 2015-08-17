<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="ReportService">
		<cfreturn this />
	</cffunction>

	<cffunction name="getReport" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />
		<cfargument name="reportId" type="numeric" required="true" />

		<cfset var report = {} />

		<cfscript>
			switch( arguments.reportId )
			{
				case 6:
				{
					report = getCancelledOrders( argumentCollection = arguments );
					break;
				}
				case 8:
				{
					report = getManualActivationOrders( argumentCollection = arguments );
					break;
				}
				case 13:
				{
					report = getFinanceOrders( argumentCollection = arguments );
					break;
				}
				case 14:
				{
					report = getOrders( argumentCollection = arguments );
					break;
				}
				case 15:
				{
					report = getOrderDetails( argumentCollection = arguments );
					break;
				}
				case 17:
				{
					report = getExchangeOrders( argumentCollection = arguments );
					break;
				}
				case 18:
				{
					report = getCustomerServiceActivations( argumentCollection = arguments );
					break;
				}
				case 19:
				{
					report = getAddressVariance( argumentCollection = arguments );
					break;
				}
				case 20:
				{
					report = getEnhancedServices( argumentCollection = arguments );
					break;
				}
				case 21:
				{
					report = getResolvedSocConflicts( argumentCollection = arguments );
					break;
				}
			}
		</cfscript>

		<cfreturn report />
	</cffunction>


	<cffunction name="getManualActivationOrders" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 24, "" );

			ArraySet( columnDataFormats, 1, 24, "" );
			columnDataFormats[2] = "m/d/yy h:mm";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				o.OrderId
				, o.OrderDate
				, o.Status
				, wa.ActivationStatus
			FROM salesorder.[Order] o
			INNER JOIN salesorder.WirelessAccount wa ON wa.OrderId = o.OrderId
			WHERE wa.ActivationStatus = 6 -- Manual
				AND o.OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND o.OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY o.OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>


	<cffunction name="getCancelledOrders" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 31, "" );
			columnDataTypes[4] = "numeric";
			columnDataTypes[27] = "numeric";

			ArraySet( columnDataFormats, 1, 31, "" );
			columnDataFormats[2] = "m/d/yy h:mm";
			columnDataFormats[26] = "m/d/yy h:mm";
			columnDataFormats[31] = "m/d/yy h:mm";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				o.OrderId
				, o.OrderDate
				, o.Status
				, SUM(od.NetPrice + od.Taxes) + o.ShipCost OrderTotal
				, o.UserId
				, ba.FirstName BillingFirstName
				, ba.LastName BillingLastName
				, ba.Address1 BillingAddress1
				, ba.City BillingCityState
				, ba.State Billing
				, ba.Zip BillingZip
				, ba.DaytimePhone BillingDaytimePhone
				, ba.EveningPhone BillingEveningPhone
				, sa.FirstName ShippingFirstName
				, sa.LastName ShippingLastName
				, sa.Address1 ShippingAddress1
				, sa.City ShippingCity
				, sa.State ShippingState
				, sa.Zip ShippingZip
				, sa.DaytimePhone ShippingDaytimePhone
				, sa.EveningPhone ShippingEveningPhone
				, o.SalesTaxTransactionId
				, o.IsSalesTaxTransactionCommited
				, o.SalesTaxRefundTransactionId
				, p.PaymentId
				, p.PaymentDate
				, ISNULL(p.PaymentAmount, 0) PaymentAmount
				, p.PaymentMethodId
				, p.CreditCardAuthorizationNumber ReceiptNumber
				, a.Description
				, a.Timestamp CancellationDateTime
			FROM salesorder.[Order] o
			INNER JOIN salesorder.Address ba ON ba.AddressGuid = o.BillAddressGuid
			INNER JOIN salesorder.Address sa ON sa.AddressGuid = o.BillAddressGuid
			INNER JOIN salesorder.OrderDetail od ON od.OrderId = o.OrderId
			LEFT JOIN salesorder.Payment p ON p.OrderId = o.OrderId
			LEFT JOIN salesorder.Activity a ON a.OrderId = o.OrderId
			WHERE
				o.Status = 4
				AND a.Name = 'Cancel Order'
				AND a.Timestamp >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND a.Timestamp < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			GROUP BY
				o.OrderId
				, o.OrderDate
				, o.Status
				, o.UserId
				, o.ShipCost
				, ba.FirstName
				, ba.LastName
				, ba.Address1
				, ba.City
				, ba.State
				, ba.Zip
				, ba.DaytimePhone
				, ba.EveningPhone
				, sa.FirstName
				, sa.LastName
				, sa.Address1
				, sa.City
				, sa.State
				, sa.Zip
				, sa.DaytimePhone
				, sa.EveningPhone
				, o.SalesTaxTransactionId
				, o.IsSalesTaxTransactionCommited
				, o.SalesTaxRefundTransactionId
				, p.PaymentId
				, p.PaymentDate
				, p.PaymentAmount
				, p.PaymentMethodId
				, p.CreditCardAuthorizationNumber
				, a.Description
				, a.Timestamp
			ORDER BY o.OrderId, p.PaymentId
		</cfquery>

		<cfreturn report />
	</cffunction>


	<cffunction name="getFinanceOrders" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 9, "" );

			ArraySet( columnDataFormats, 1, 9, "" );
			columnDataFormats[2] = "m/d/yy h:mm";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				OrderId
				, OrderDate
				, Type
				, Status
				, GERSStatus
				, [GERS SO]
				, ActivationStatus
				, Carrier
				, ShipMethodId
			FROM report.OrderStatus
			WHERE
				OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>


	<cffunction name="getOrders" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			arraySet(columnDataTypes, 1, 15, '');
			columnDataTypes[11] = 'numeric';
			columnDataTypes[12] = 'numeric';
			columnDataTypes[13] = 'numeric';
			columnDataTypes[14] = 'numeric';
			columnDataTypes[15] = 'numeric';

			arraySet(columnDataFormats, 1, 15, '');
			columnDataFormats[3] = 'm/d/yy h:mm';

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				od.UserId
				, od.CUST_CD
				, od.OrderDate
				, od.OrderStatus
				, od.OrderId
				, od.GERSRefNum
				, od.CompanyName
				, od.FirstName
				, od.LastName
				, od.OrderActivationStatus
				, od.PaymentAmount
				, od.PaymentDate
				, od.OrderItemSubtotal
				, od.OrderTaxes
				, od.ShipCost
			FROM		report.OrderDump AS od WITH (NOLOCK)
			WHERE		od.PaymentDate	>=	<cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND		od.PaymentDate	<	<cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY	od.OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>

	<cffunction name="getOrderDetails" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 20, "" );
			columnDataTypes[15] = "numeric";
			columnDataTypes[16] = "numeric";
			columnDataTypes[17] = "numeric";

			ArraySet( columnDataFormats, 1, 20, "" );
			columnDataFormats[2] = "m/d/yy  h:mm AM/PM";
			columnDataFormats[15] = "0.00";
			columnDataFormats[16] = "0.00";
			columnDataFormats[17] = "0.00";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				OrderId
				, OrderDate
				, OrderStatus
				, GersStatus
				, GERSRefNum
				, UserId
				, CUST_CD				
				, CompanyName
				, FirstName
				, LastName
				, OrderDetailId
				, GersSku
				, ProductTitle				
				, LineActivationStatus
				, Subtotal
				, Taxes
				, ISNULL(MonthlyAccessFee,0) MonthlyAccessFee
				, HandsetType
				, ActivatedPhoneNumber
				, ESN_IMEI
			FROM report.OrderDetailDump
			WHERE
				OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>


	<cffunction name="getExchangeOrders" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 16, "" );
			columnDataTypes[13] = "numeric";
			columnDataTypes[14] = "numeric";
			columnDataTypes[15] = "numeric";
			columnDataTypes[16] = "numeric";

			ArraySet( columnDataFormats, 1, 16, "" );
			columnDataFormats[3] = "m/d/yy h:mm";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				UserId
				, CUST_CD
				, OrderDate
				, OrderStatus
				, SortCode
				, OrderId
				, ParentOrderId
				, GERSRefNum
				, CompanyName
				, FirstName
				, LastName
				, OrderActivationStatus
				, PaymentAmount
				, OrderItemSubtotal
				, OrderTaxes
				, ShipCost
			FROM report.OrderDump
			WHERE
				ActivationType = 'E'
				AND OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>



	<cffunction name="getCustomerServiceActivations" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 21, "" );

			ArraySet( columnDataFormats, 1, 21, "" );
			columnDataFormats[1] = "m/d/yy h:mm";
			columnDataFormats[2] = "m/d/yy h:mm";
			columnDataFormats[8] = "m/d/yy h:mm";
			columnDataFormats[12] = "m/d/yy h:mm";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT * FROM report.CustomerServiceActivations
			WHERE OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>


	<cffunction name="getAddressVariance" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 17, "" );

			ArraySet( columnDataFormats, 1, 17, "" );
			columnDataFormats[2] = "m/d/yy h:mm";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT --*
				o.OrderId
				, o.OrderDate
				, CASE o.Status
					WHEN 0 THEN 'Pending'
					WHEN 1 THEN 'Submitted'
					WHEN 2 THEN 'Order Placed'
					WHEN 3 THEN
						CASE o.GERSStatus
							WHEN 2 THEN 'Packing'
							WHEN 3 THEN 'Shipped'
							ELSE 'Processing'
						END
					WHEN 4 THEN 'Cancelled'
					ELSE ''
				  END OrderStatus
				, CASE
					WHEN sbu.BannedUserId IS NULL THEN 'No'
					ELSE 'Yes'
				  END ShipBanned
				, sa.FirstName ShipFirstName
				, sa.LastName ShipLastName
				, sa.Address1 ShipAddress
				, sa.City ShipCity
				, sa.State ShipState
				, sa.Zip ShipZip
				, CASE
					WHEN bbu.BannedUserId IS NULL  THEN 'No'
					ELSE 'Yes'
				  END BillBanned
				, ba.FirstName BillFirstName
				, ba.LastName BillLastName
				, ba.Address1 BillAddress
				, ba.City BillCity
				, ba.State BillState
				, ba.Zip BillZip
			FROM salesorder.[Order] o
			INNER JOIN salesorder.Address ba ON ba.AddressGuid = o.BillAddressGuid
			LEFT JOIN websecurity.BannedUsers bbu
				ON bbu.Address1 = ba.Address1
				AND bbu.Address2 = ba.Address2
				AND bbu.City = ba.City
				AND bbu.State = ba.State
				AND bbu.Zip = ba.Zip
			INNER JOIN salesorder.Address sa ON sa.AddressGuid = o.ShipAddressGuid
			LEFT JOIN websecurity.BannedUsers sbu
				ON sbu.Address1 = sa.Address1
				AND sbu.Address2 = sa.Address2
				AND sbu.City = sa.City
				AND sbu.State = sa.State
				AND sbu.Zip = sa.Zip
			WHERE
				OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
				AND
				(
					ba.Address1 <> sa.Address1
					OR ba.Address2 <> sa.Address2
					OR ba.City <> sa.City
					OR ba.State <> sa.State
					OR ba.Zip <> sa.Zip
				)
			ORDER BY OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>


	<cffunction name="getEnhancedServices" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 10, "" );
			columnDataTypes[9] = "numeric";
			columnDataTypes[10] = "numeric";

			ArraySet( columnDataFormats, 1, 10, "" );
			columnDataFormats[2] = "m/d/yy h:mm";
			columnDataFormats[9] = "0.00";
			columnDataFormats[10] = "0.00";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
				SELECT
					o.GERSRefNum
					, wa.ActivationDate
					, o.OrderId
					, ba.FirstName
					, ba.LastName
					, od.GroupNumber
					, CASE od.OrderDetailType
						WHEN 'd' THEN 'Device'
						WHEN 'r' THEN 'Rateplan'
						WHEN 's' THEN 'Service'
						WHEN 'u' THEN 'Upgrade'
						ELSE ''
					  END OrderDetailType
					, od.ProductTitle
					, ISNULL(wl.MonthlyFee, 0) RatePlanFee
					, ISNULL(ls.MonthlyFee, 0) ServiceFee
				FROM salesorder.[Order] o
				INNER JOIN salesorder.WirelessAccount wa ON wa.OrderId = o.OrderId
				INNER JOIN salesorder.Address ba ON ba.AddressGuid = o.BillAddressGuid
				INNER JOIN salesorder.OrderDetail od ON od.OrderId = o.OrderId
				LEFT JOIN salesorder.WirelessLine wl ON wl.OrderDetailId = od.OrderDetailId
				LEFT JOIN salesorder.LineService ls ON ls.OrderDetailId = od.OrderDetailId
				WHERE
					od.OrderDetailType NOT IN ('a')
					AND o.Status >= 2
				AND o.OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND o.OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY
				o.OrderId
				, od.GroupNumber
				, od.OrderDetailId
		</cfquery>

		<cfreturn report />
	</cffunction>

	<cffunction name="getResolvedSocConflicts" output="false" access="public" returntype="struct">
		<cfargument name="startDate" type="date" required="true" />
		<cfargument name="endDate" type="date" required="true" />

		<cfscript>
			var report = {};
			var columnDataTypes = [];
			var columnDataFormats = [];

			ArraySet( columnDataTypes, 1, 11, "" );

			ArraySet( columnDataFormats, 1, 11, "" );
			columnDataFormats[2] = "m/d/yy h:mm";

			report.columnDataTypes = columnDataTypes;
			report.columnDataFormats = columnDataFormats;
		</cfscript>

		<cfquery name="report.qReport" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				o.OrderId
				, o.OrderDate
				, o.ActivationType
				, c.CompanyName
				, o.UserId
				, o.EmailAddress
				, o.Status
				, o.GERSStatus
				, o.CheckoutReferenceNumber
				, a.ActivityId
				, a.Description
			FROM logging.Activity a
			INNER JOIN salesorder.[Order] o ON o.OrderId = a.TypeReferenceId
			INNER JOIN catalog.Company c ON c.CarrierId = o.CarrierId
			WHERE
				o.ActivationType = 'U'
				AND o.CarrierId IN (109,128)
				AND PrimaryActivityType = 'Resolve SOC Code'
				AND a.Description <> 'Resolve SOC Code - Conflicts=0 |'
				AND o.OrderDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
				AND o.OrderDate < <cfqueryparam value="#DateAdd( 'd', 1, arguments.endDate )#" cfsqltype="cf_sql_date" />
			ORDER BY
				o.OrderId
		</cfquery>

		<cfreturn report />
	</cffunction>


</cfcomponent>