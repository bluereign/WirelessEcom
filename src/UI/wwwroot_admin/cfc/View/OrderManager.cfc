<cfcomponent output="false" displayname="OrderManager">
	
	<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
	<cfset PaymentService = application.wirebox.getInstance("PaymentService") />
	<cfset carrierFacade = application.wirebox.getInstance("CarrierFacade") />
	<cfset AttCarrier = application.wirebox.getInstance("AttCarrier") />
	<cfset VzwCarrier = application.wirebox.getInstance("VzwCarrier") />
	<cfset carrierHelper = application.wirebox.getInstance("CarrierHelper") />
	<cfset AttCarrierHelper = application.wirebox.getInstance("AttCarrierHelper") />
	<cfset VzwCarrierHelper = application.wirebox.getInstance("VzwCarrierHelper") />

	<cffunction name="init" output="false" returntype="OrderManager">
		<!--- Remove these when this component is added to CS --->        
        <cfset setPaymentProcessorRegistry ( application.wirebox.getInstance("PaymentProcessorRegistry") )>
		<cfset setPaymentService( application.wirebox.getInstance("PaymentService") )>
		<cfset setChannelConfig( application.wirebox.getInstance("ChannelConfig") )> 
		<!---<cfset variables.instance.assetPaths =  application.wirebox.getInstance("assetPaths")  />--->
		<!--- default military base changed flag to false --->
		<!---<cfset variables.bIsCurrentMilitaryBase = false /> --->
    	<cfreturn this />
    </cffunction>

	<cffunction name="getOrderSearchFormView" output="false" access="public" returntype="string">

		<cfset var local = structNew() />
		<cfset var qry_getCarriers = application.model.AdminCompany.getCompanies(carrierId = 0) />

		<cfsavecontent variable="local.content">
			<cfoutput>
				<form name="searchForm" action="" id="searchForm" class="middle-forms" method="post">
					<h3>Order Search</h3>
					<fieldset>
						<legend>Fieldset Title</legend>
						<div>
							<label for="orderId">Order ##</label>
							<input name="orderId" id="orderId" type="input" class="{validate:{digits:true}}" value="#request.p.orderId#" onkeypress="handleKeyPress(event,this.form)" />
						</div>
						<div>
							<label for="firstname">First Name</label>
							<input name="firstname" id="firstname" type="input" value="#request.p.firstname#" onkeypress="handleKeyPress(event,this.form)" />
						</div>
						<div>
							<label for="lastname">Last Name</label>
							<input name="lastname" id="lastname" type="input" value="#request.p.lastname#" onkeypress="handleKeyPress(event,this.form)" />
						</div>
						<div>
							<label for="email">Email</label>
							<input name="email" id="email" type="input" value="#request.p.email#" onkeypress="handleKeyPress(event,this.form)" />
						</div>
						<div>
							<label for="mdn">MDN</label>
							<input name="mdn" id="mdn" type="input" value="#request.p.mdn#" onkeypress="handleKeyPress(event,this.form)" />
						</div>
						<div>
							<label for="orderStatus">Order Status</label>
							<select id="orderStatus" name="orderStatus">
								<option value="">All</option>
								<option value="0" <cfif request.p.orderStatus EQ 0>selected="selected"</cfif>>Pending</option>
								<option value="1" <cfif request.p.orderStatus EQ 1>selected="selected"</cfif>>Submitted</option>
								<option value="2" <cfif request.p.orderStatus EQ 2>selected="selected"</cfif>>Payment Complete</option>
								<option value="3" <cfif request.p.orderStatus EQ 3>selected="selected"</cfif>>Closed</option>
								<option value="4" <cfif request.p.orderStatus EQ 4>selected="selected"</cfif>>Canceled</option>
							</select>
						</div>
						<div>
							<label for="fraud">Fraud</label>
							<select id="fraud" name="fraud">
								<option value="">All</option>
								<option value="P" <cfif request.p.FraudStatus EQ 'P'>selected="selected"</cfif>>Pending</option>
								<option value="Y" <cfif request.p.FraudStatus EQ 'Y'>selected="selected"</cfif>>Yes</option>
								<option value="N" <cfif request.p.FraudStatus EQ 'N'>selected="selected"</cfif>>No</option>
							</select>
						</div>
						<div>
							<label for="activationStatus">Activation Status</label>
							<select id="activationStatus" name="activationStatus">
								<option value="">All</option>
								<option value="0" <cfif request.p.activationStatus EQ 0>selected="selected"</cfif>>Ready</option>
								<option value="1" <cfif request.p.activationStatus EQ 1>selected="selected"</cfif>>Requested</option>
								<option value="2" <cfif request.p.activationStatus EQ 2>selected="selected"</cfif>>Success</option>
								<option value="3" <cfif request.p.activationStatus EQ 3>selected="selected"</cfif>>Partial Success</option>
								<option value="4" <cfif request.p.activationStatus EQ 4>selected="selected"</cfif>>Failure</option>
								<option value="5" <cfif request.p.activationStatus EQ 5>selected="selected"</cfif>>Error</option>
								<option value="6" <cfif request.p.activationStatus EQ 6>selected="selected"</cfif>>Manual</option>
								<option value="7" <cfif request.p.activationStatus EQ 7>selected="selected"</cfif>>Canceled</option>
							</select>
						</div>
						<div>
							<label for="activationType">Order Type</label>
							<select id="activationType" name="activationType">
								<option value="">All</option>
								<option value="N" <cfif request.p.activationType is 'N'>selected="selected"</cfif>>New</option>
								<option value="A" <cfif request.p.activationType is 'A'>selected="selected"</cfif>>Add a Line</option>
								<option value="U" <cfif request.p.activationType is 'U'>selected="selected"</cfif>>Upgrade</option>
								<option value="R" <cfif request.p.activationType is 'R'>selected="selected"</cfif>>No Contract</option>
								<option value="E" <cfif request.p.activationType is 'E'>selected="selected"</cfif>>Exchange</option>
							</select>
						</div>
						<div>
							<label for="carrierId">Carrier</label>
							<select id="carrier" name="carrierId">
								<option value="0">All</option>
								<cfloop query="qry_getCarriers">
									<option value="#qry_getCarriers.carrierId[qry_getCarriers.currentRow]#" #iif(request.p.carrierId eq qry_getCarriers.carrierId[qry_getCarriers.currentRow], de('selected'), de(''))#>#trim(qry_getCarriers.companyName[qry_getCarriers.currentRow])#</option>
								</cfloop>
							</select>
						</div>
					</fieldset>
					<input name="submitForm" type="hidden" />
				</form>
				
				<div align="center">
					<a href="http://10.7.0.220/Reports/Pages/Report.aspx?ItemPath=%2fGeneral+Reporting%2fT-Mobile+Commission+Junction+Order+Details" target="_blank" title="Click for TMO Direct Order Details report"><img src="/assets/common/images/carrierLogos/tmobile_175.gif"></a>
				</div>
				
				<!--- <button id="submit" name="submit">Search</button> --->
				<input type="button" id="submit" name="submit" value="Search" style="width: 100px" />
				<script>
					function handleKeyPress(e, form)	{
						var key=e.keyCode || e.which;
						if (key==13)	{
							form.submit();
						}
					}
				</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.content) />
	</cffunction>

	<cffunction name="getOrderListView" output="false" access="public" returntype="string">
		<cfargument name="orders" type="query" required="true" />
		
		<cfset var local = structNew() />
		<cfset allocation = createObject('component', 'cfc.model.Allocation').init() />
		
		<cfsavecontent variable="local.content">
			<cfoutput>
				<div class="customer-service">
					<h3>Search Results</h3>
					<cfif arguments.orders.recordCount>
						<table id="orderList" class="table-long">
							<thead>
								<tr>
									<th>Order ID</th>
									<th>Date</th>
									<th>Status</th>
									<th>Activation Status</th>
									<th>Type</th>
									<th>Account Name</th>
									<th>Order Name</th>
									<th>Carrier</th>
								</tr>
							</thead>
							<tbody>
								<cfloop query="arguments.orders">
									<cfset local.orderid = arguments.orders.orderId[arguments.orders.currentRow] />
									<cfset local.orderid_suffix = "" />
									<cfset local.missingIMEIct = 0 />
									<cfset local.deviceCt = 0 />
									<cfif allocation.isAllocatedOrder(local.orderid)>
										<cfset local.order = createObject('component', 'cfc.model.Order').init()/>
										<cfset local.order.load(local.orderid) />
										<cfset local.deviceCt = arraylen(local.order.getWirelessLines())>
										<cfloop index="wl" array="#local.order.getWirelessLines()#">
											<cfif wl.getCurrentIMEI() is "">
												<cfset local.missingIMEIct = local.missingIMEIct +1 />
											</cfif>
										</cfloop>
										<cfif local.missingIMEIct gt 0>
											<cfset local.orderid_suffix = local.orderid_suffix & "&nbsp;(" & local.deviceCt & "L/"  & local.missingIMEIct & "I)" />
											<cfset local.orderid_suffix = '<a title="#local.deviceCt# line(s)/#local.missingIMEIct# missing IMEI(s)">' & local.orderid_suffix& '</a>' />										</cfif>
									</cfif>
									<tr>
										<td><a href="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#local.orderid#">#trim(local.orderid)#</a>#local.orderid_suffix#</td>
										<td>#dateFormat(arguments.orders.orderDate[arguments.orders.currentRow], 'mm/dd/yyyy')#</td>
										<td>#trim(arguments.orders.statusName[arguments.orders.currentRow])#</td>
										<td>#trim(arguments.orders.activationStatusName[arguments.orders.currentRow])#</td>
										<td>#trim(application.model.order.getActivationTypeName(type = trim(arguments.orders.activationType[arguments.orders.currentRow])))#</td>
										<td>#trim(arguments.orders.accountFirstName[arguments.orders.currentRow])# #trim(arguments.orders.accountLastName[arguments.orders.currentRow])#</td>
										<td>#trim(arguments.orders.billingFirstName[arguments.orders.currentRow])# #trim(arguments.orders.billingLastName[arguments.orders.currentRow])#</td>
										<td>#trim(arguments.orders.companyName[arguments.orders.currentRow])#</td>
									</tr>
								</cfloop>
							</tbody>
						</table>
					<cfelse>
						<p>There were no orders found with your search criteria.</p>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.content) />
	</cffunction>

	<cffunction name="getManagerView" output="false" access="public" returntype="string">
        <cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="user" type="cfc.model.User" required="true" />

		<cfscript>
			var content = "";
			var items = [];

			var lines = order.getWirelessLines();
			var otherItems = order.getOtherItems();
			var qActivationLines = application.model.order.getOrderActivationLines( order.getOrderId() );
			var wirelessLines = application.model.WirelessAccount.getByOrderId( order.getOrderId() );
			var UserService = application.wirebox.getInstance("UserService");
			var isOrderAssistanceOn = false;
			
			if (user.getUserId() neq '')
			{
				isOrderAssistanceOn = UserService.isUserOrderAssistanceOn( user.getUserId() );
			}
		</cfscript>

		<cfsavecontent variable="content">
			<cfoutput>
			<div class="customer-service">
				<cfif arguments.order.getOrderAssistanceUsed()>
					<!--- TODO: Relocate query --->
					<cfquery name="qCommissionSku" datasource="#application.dsn.wirelessAdvocates#">
						SELECT *
						FROM salesorder.OrderDetail od
						WHERE
							od.OrderDetailType = 'U'
							AND od.GersSku IS NULL
							AND od.OrderId = <cfqueryparam value="#arguments.order.getOrderId()#" cfsqltype="cf_sql_integer" />
					</cfquery>

					<cfif qCommissionSku.RecordCount>
						<div style="margin-bottom:15px; padding:15px; border:1px solid red;">
							#getUpgradeCommissionSkuView( arguments.order, qCommissionSku )#
						</div>
					</cfif>
				</cfif>
				<div class="headerContent">
					<div class="head">
						Order ##: #arguments.order.getOrderId()#
					</div>
					<div class="body">
						<div class="left">
							<cfif arguments.order.getStatus() neq 3>
								Order Status: #arguments.order.getStatusName()#
							<cfelse>
								<cfif arguments.order.getGersStatus() lt 0>
									Order Status: Processing (<span class="flag">#arguments.order.getGersStatusName()#</span>)
								<cfelse>
									Order Status: #arguments.order.getGersStatusName()#
								</cfif>
							</cfif>
						</div>
						<div class="right">Order Date: #DateFormat( arguments.order.getOrderDate(), "mm/dd/yyy" )# #TimeFormat( arguments.order.getOrderDate(), "hh:mm tt" )#</div>
						<div class="middle">Activation Status: <span class="wirelessAccountActivationStatus">#arguments.order.getWirelessAccount().getActivationStatusName()#</span></div>
					</div>
					<div style="clear:both"></div>
					<div class="body">
						<div class="left">Billed to: <a href="index.cfm?c=d46c6001-3f33-4989-adab-32fdb2a5eed4&userId=#arguments.user.getUserId()#" <!---target="_blank"--->>#arguments.order.getBillAddress().getFirstName()# #arguments.order.getBillAddress().getLastName()#</a></div>
						<div class="right">
                        	Order Type: #arguments.order.getActivationTypeName()#
                        	<cfif arguments.order.getParentOrderId() gt 0>
                            	| <a href="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#arguments.order.getParentOrderId()#">#arguments.order.getParentOrderId()#</a>
                            </cfif>
                        </div>
						<div class="middle">Daytime Phone: #arguments.order.getBillAddress().getDaytimePhone()#</div>
					</div>
					<div style="clear:both; margin-bottom:10px;"></div>
				</div>
				
				<!--- Work around for No-Contract orders getting stuck --->
				<cfif arguments.order.getActivationType() eq 'R' && arguments.order.getStatus() eq '2'>
					<div style="width:300px; height: 35px; margin: 0 auto; padding: 10px; text-align: center;">
						<form action="" method="post">
							<input type="hidden" name="passManualFraudCheck" value="true" />
							<input type="hidden" name="status" value="3" />
							<button onclick="passManualFraudCheck();">Manual Fraud Check Successful</button>
						</form>
					</div>
				</cfif>	
				
			    <div id="tabs">
			        <ul>
			            <li><a href="##tabs-1">General</a></li>
			            <li><a href="##tabs-2">Details</a></li>
			            <li><a href="##tabs-3">Activations (#qActivationLines.RecordCount#)</a></li>
			            <li><a href="##tabs-4">Notes</a></li>
			            <li><a id="rma-tab" href="components/order/dsp_RmaDetails.cfm?orderId=#arguments.order.getOrderId()#">RMA</a></li>
			            <li><a id="account-tab" href="components/order/dsp_AccountDetails.cfm?userId=#arguments.order.getUserId()#&isOrderAssistanceOn=#isOrderAssistanceOn#">Account</a></li>
                        <li><a id="exchange-tab" href="components/order/dsp_ExchangeDetails.cfm?orderId=#arguments.order.getOrderId()#">Exchanges</a></li>
                        <li><a id="debug-tab" href="components/order/dsp_OrderDebug.cfm?orderId=#arguments.order.getOrderId()#">Debug</a></li>
			        </ul>
			        <div id="tabs-1">
			            <!--- General --->
						#getGeneralTabView( order )#
			        </div>
			        <div id="tabs-2">
			        	<!--- Details --->
						#getOrderDetailsTabView( order )#
			        </div>
			        <div id="tabs-3">
			            <!--- Activation  --->
						#getActivationTabView( order, qActivationLines )#
			        </div>
			        <div id="tabs-4">
			            <!--- Notes --->
						#getTicketsTabView(application.model.TicketService.getOrderNotesByOrderId( orderId = order.getOrderId() ))#
			        </div>
					<cfif arguments.order.getCarrierId() eq 42>
  						<div id="tabs-cats">
				            <!--- Verizon CATS --->
				        </div>
					</cfif>
			        <div id="tabs-5"><!--- RMA---></div>
			        <div id="tabs-6"><!--- Account ---></div>
                    <div id="tabs-7"><!--- Exchange ---></div>
                    <div id="tabs-8"><!--- Debug ---></div>
					
			    </div>
			</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>

	<cffunction name="getGeneralTabView" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		
		<cfscript>
			var local = {};
			var content = "";
			var isShippingUpdatable = false;
			var isOrderStatusUpdatable = false;
			var isUserRoleValid = false;
			var i = 0;
			var isLocked = false;
			var newBaseName = "";
			var currentAcct = arguments.order.getWirelessAccount().getCurrentAcctNumber();
			var newAcct = arguments.order.getWirelessAccount().getNewAccountNo();

			var qry_getMilitaryBases = "";
			
			var wirelessLines = application.model.WirelessAccount.getByOrderId( order.getOrderId() );
			

			//Order is sent to GERS when activation status is success or manual
			if (
				arguments.order.getStatus() NEQ 3 //Closed
				AND arguments.order.getStatus() NEQ 4 //Cancelled
				AND arguments.order.getWirelessAccount().getActivationStatus() NEQ 2 //Success
				AND arguments.order.getWirelessAccount().getActivationStatus() NEQ 6 //Manual
			)
			{
				isShippingUpdatable = true;
			}

			if ( Len(arguments.order.getUnlockDateTime()) && arguments.order.getUnlockDateTime() gte Now() && arguments.order.getLockedById() neq session.AdminUser.AdminUserId)
			{
				isLocked = true;
			}

			//Cancel only Payment Complete orders that do not have any activated lines and order is not locked by another user
			if ( ( arguments.order.getStatus() EQ 2 OR arguments.order.getStatus() EQ 1 )AND arguments.order.getWirelessAccount().getActivationStatus() NEQ 3 AND !isLocked )
			{
				isOrderStatusUpdatable = true;
			}
			
			
		</cfscript>

		<cfsavecontent variable="content">
			<cfoutput>
				<div id="dialog-confirm" title="Cancel Order ###arguments.order.getOrderId()#?">
					<p>The order will be canceled and cannot be recovered. Are you sure?</p>
				</div>

				<div id="dialog-confirm-delete-note" title="Delete Note">
					<p>The note will be deleted and cannot be recovered. Are you sure?</p>
				</div>

				<h3>Order Information</h3>
				<div class="buttonContainer">
					<button id="toggleOrderUpdateButton">Edit</button>
				</div>
				
				<div class="field-display">
					<div>
						<strong>Order ID:</strong> #arguments.order.getOrderId()#
					</div>
					<div>
						<strong>Order Date:</strong> #dateFormat(arguments.order.getOrderDate(), "mm/dd/yyyy")# #timeFormat(arguments.order.getOrderDate(), "hh:mm:ss tt")#
					</div>
					<div>
						<strong>Order Scenario:</strong> <cfif arguments.order.getScenarioId() eq 1>ECOM<cfelseif arguments.order.getScenarioId() eq 2>DD<cfelse>Unknown</cfif>
					</div>
					
					<cfif arguments.order.getScenarioId() eq 2>
							<div>
							<strong>Kiosk ##:</strong>#arguments.order.getKioskNumber(arguments.order.getKioskID())#
						</div>
						<div>
							<strong>Employee:</strong>#arguments.order.getEmployeeName(arguments.order.getAssociateID())#
						</div>
					</cfif>
					
					<!--- Show Campaign Info if Available --->
					<cfif arguments.order.getCampaignId() is not 0>
					<div>
						<strong>Campaign:</strong> #application.wirebox.getInstance('CampaignService').getCampaignById(arguments.order.getCampaignId()).getCompanyName()# (#arguments.order.getCampaignId()#)
					</div>
					
					</cfif>

					<!--- show account number information --->
					<cfif len(currentAcct)>
						<div>
							<strong>Current Acct ##:</strong> #currentAcct#
						</div>
					</cfif>
					<cfif len(newAcct)>
						<div>
							<strong>New Acct ##:</strong> #newAcct#
						</div>
					</cfif>
					
					<cfif isOrderStatusUpdatable AND application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, 'c54772bb-c405-4c53-a3b4-10d92739941e' ) >
						<div class="clear">
							<form id="cancelOrderForm" action="" method="post">
								<div>
									<label for="orderStatus">Status:</label>
									<select id="orderStatus" name="orderStatus">
										<option value="2" <cfif arguments.order.getStatus() EQ 2>selected="selected"</cfif>>Payment Complete</option>
										<option value="4" <cfif arguments.order.getStatus() EQ 4>selected="selected"</cfif>>Canceled</option>
									</select>
								</div>
								<div class="cancel_field hidden clear">
									<label for="cancelationReason">Reason:</label>
									<input id="cancelationReason" name="cancelationReason" type="text" maxlength="200" class="{validate:{required:true}}" value="" />
								</div>
								<input name="cancelOrderSubmit" type="hidden" />
							</form>
						</div>
						<div class="cancel_field hidden buttonContainer clear">
							<button id="cancelOrderSubmit" name="cancelOrderSubmit">Cancel Order</button>
						</div>
					<cfelse>
						<div>
							<strong>Order Status:</strong> #arguments.order.getStatusName()#
						</div>
					</cfif>
					<div>
						<strong>GERS ID:</strong>
							<cfif arguments.order.getScenarioId() eq 2>
								DD#RemoveChars(Trim(arguments.order.getUserId()),2,1)#<!---Using DD version of customer ID --->
							<cfelse>
								#Trim(application.model.util.convertToGersId( arguments.order.getUserId() ))#
							</cfif>
					</div>
					<div>
						<strong>Order Assistance:</strong> #YesNoFormat(arguments.order.getOrderAssistanceUsed())#
					</div>
					<div>
						<strong>Activation Status:</strong> <span class="wirelessAccountActivationStatus">#arguments.order.getWirelessAccount().getActivationStatusName()#</span>
					</div>
					<div>
						<strong>Activation Date:</strong> <cfif NOT arguments.order.getWirelessAccount().isDateNull( arguments.order.getWirelessAccount().getActivationDate() )>#DateFormat( arguments.order.getWirelessAccount().getActivationDate(), "mm/dd/yyyy" )# #TimeFormat( arguments.order.getWirelessAccount().getActivationDate(), "hh:mm tt" )#</cfif>
					</div>
					<div>
						<strong>Shipment Method:</strong> <cfif arguments.order.getShipMethod().getShipMethodId() EQ 1><span class="flag">#arguments.order.getShipMethod().getDisplayName()#</span><cfelse>#arguments.order.getShipMethod().getDisplayName()#</cfif>
					</div>
					<div>
						<strong>Shipment Cost:</strong> #dollarFormat( arguments.order.getShipCost() )#
					</div>
					<div>
						<strong>Est. Shipment Date:</strong> #DateFormat( arguments.order.getShipmentDeliveryDate(), 'm/dd/yyyy')#
					</div>
					<div>
						<strong>Tracking Number:</strong>
						<cfif arguments.order.getStatusName() eq 'shipped'>
							<cfset qShipmentTrackingNumber = application.model.myAccount.getShipmentTrackingNumber(orderId = arguments.order.getOrderId()) />
							<cfif Len(Trim(qShipmentTrackingNumber.TrackingNumber)) >
								<a href="http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=#trim(qShipmentTrackingNumber.TrackingNumber)#&track.x=0&track.y=0" target="_blank">#qShipmentTrackingNumber.TrackingNumber#</a>
							</cfif>
						</cfif>
					</div>
					<div>
						<strong>Discount Total:</strong> #dollarFormat( arguments.order.getOrderDiscountTotal() )#
					</div>
					<div>
						<strong>Promotion Codes:</strong> #arguments.order.getPromotionCodeList()#
					</div>
					<div>
						<strong>Taxes:</strong> #dollarFormat( arguments.order.getTaxTotal() )#
					</div>
					<div>
						<strong>"Due Today" Total:</strong> #dollarFormat( arguments.order.getSubTotal() + arguments.order.getShipCost() + arguments.order.getTaxTotal() - arguments.order.getOrderDiscountTotal() )# (includes Taxes & Shipping)
					</div>
					<div>
						<strong>Kiosk Employee:</strong> <cfif len(trim(arguments.order.getKioskEmployeeNumber()))>#arguments.order.getKioskEmployeeNumber()#<cfelse>N/A</cfif>
					</div>
					<div class="order_data">
						<strong>Order Email:</strong> #arguments.order.getEmailAddress()#
					</div>
					<div>
						<strong>Payment Captured by:</strong> #arguments.order.getPaymentCapturedByUserName()#
					</div>
					<div class="order_field hidden">
						<form id="orderUpdateSubmitForm" action="" method="post">
							<div class="field-display">
								<div>
									<label>Kiosk Employee:</label>
									<input id="kioskEmployeeNumber" name="kioskEmployeeNumber" type="text" maxlength="50" value="#arguments.order.getKioskEmployeeNumber()#" />
								</div>
								<div>
									<label>Order Email:</label>
									<input id="emailAddress" name="emailAddress" type="text" class="{validate:{email:true}}" maxlength="50" value="#arguments.order.getEmailAddress()#" />
								</div>
							</div>
							<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
							<input name="orderUpdateSubmit" type="hidden" />
						</form>
					</div>
					<div class="order_field hidden buttonContainer">
						<button id="orderUpdateSubmit" name="orderUpdateSubmit">Update</button>
					</div>
					
				<form id="orderPaymentForm" action="" method="post">
					<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
					<input name="orderPaymentSubmit" type="hidden" />
				</form>
				
				<cfset local.pCt = 0 />	
				<cfset local.pAmt = 0 />
				<cfloop array="#arguments.order.getPayments()#" index="local.p">
					<cfif local.p.getPaymentMethod().getPaymentMethodId() is not 4 and local.p.getPaymentMethod().getPaymentMethodId() is not 7>
						<cfset local.pCt = local.pCt+1 />
						<cfset local.pAmt = local.pAmt + local.p.getPaymentAmount() />
					</cfif>			
				</cfloop>	
				<cfif  local.pCt lte 1 >
					<div class="buttonContainer">
						<cfif local.pCt is 0><button id="togglePaymentAuthButton">Add Missing Auth Record</button></cfif>					
						<cfif local.pAmt is 0><button id="orderPaymentSubmit" name="orderPaymentSubmit">Send Order Payment Email</button></cfif>
					</div>
				</cfif>

					<!--- Hidden form to update payment information --->
					<div class="payment_field hidden">
						<div class="field-display">
						<form id="paymentAuthSubmitForm" action="" method="post">
							<!---<div>
								<label>Payment Amount:</label>
								<input id="paymentAmount" name="paymentAmount" type="text" maxlength="50" value="#decimalFormat( arguments.order.getSubTotal() + arguments.order.getShipCost() + arguments.order.getTaxTotal() - arguments.order.getOrderDiscountTotal() )#" /> (Due Today Total)
							</div>--->							
							<div>
								<label>Authorization Orig Id:</label>
								<input id="AuthorizationOrigId" name="AuthorizationOrigId" type="text" maxlength="50" value="" /> 
							</div>
							<div>
								<label>Credit Card Auth ##:</label>
								<input id="creditCardAuthorizationNumber" name="creditCardAuthorizationNumber" type="text" maxlength="50" value="" /> 
							</div>
							<div>
								<label>Payment Token:</label>
								<input id="paymentToken" name="paymentToken" type="text" maxlength="50" value="" /> 
							</div>
							
								<input name="paymentAmount" type="hidden" value="0" />						
								<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
								<input name="paymentMethodId" type="hidden" value="1" />
								<input name="bankCode" type="hidden" value="manual" />
								<input name="paymentAuthSubmit" type="hidden" />
							</div>							
							<div class="buttonContainer">
								<button id="paymentAuthSubmit" name="paymentAuthSubmit">Insert Payment Authorization Record</button>
							</div>
						</form>
					</div>	
				</div>
				
				<h3>Billing Information</h3>
				<div class="field-display">
					<div>
						<strong>First Name:</strong> #arguments.order.getBillAddress().getFirstName()#
					</div>
					<div>
						<strong>Last Name:</strong> #arguments.order.getBillAddress().getLastName()#
					</div>
					<div>
						<strong>Company:</strong> #arguments.order.getBillAddress().getCompany()#
					</div>
					<div>
						<strong>Address 1:</strong> #arguments.order.getBillAddress().getAddress1()#
					</div>
					<div>
						<strong>Address 2:</strong>	#arguments.order.getBillAddress().getAddress2()#
					</div>
					<div>
						<strong>City:</strong> #arguments.order.getBillAddress().getCity()#
					</div>
					<div>
						<strong>State:</strong>	#arguments.order.getBillAddress().getState()#
					</div>
					<div>
						<strong>Zip Code:</strong> #arguments.order.getBillAddress().getZip()#
					</div>
					<div>
						<strong>Day Phone:</strong> #arguments.order.getBillAddress().getDaytimePhone()#
					</div>
					<div>
						<strong>Evening Phone:</strong> #arguments.order.getBillAddress().getEveningPhone()#
					</div>
					<cfif arguments.order.getBillAddress().getMilitaryBase() is not "">
						<div>
							<strong>Military Base:</strong> #arguments.order.getBillAddress().getMilitaryBase()#
						</div>
					</cfif>
				</div>

				<!--- TODO: Add validate validation --->

				<h3>Shipping Information</h3>
			
				<div class="buttonContainer">
					<button id="bannedUserSubmit" name="bannedUserSubmit">Mark as Fraud</button>
					<cfif isShippingUpdatable>
						<button id="toggleShippingButton">Edit</button>
					</cfif>
				</div>

				<div class="field-display shipping_data">
					<div>
						<strong>First Name:</strong> #arguments.order.getShipAddress().getFirstName()#
					</div>
					<div>
						<strong>Last Name:</strong> #arguments.order.getShipAddress().getLastName()#
					</div>
					<div>
						<strong>Company:</strong> #arguments.order.getShipAddress().getCompany()#
					</div>
					<div>
						<strong>Address 1:</strong> #arguments.order.getShipAddress().getAddress1()#
					</div>
					<div>
						<strong>Address 2:</strong>	#arguments.order.getShipAddress().getAddress2()#
					</div>
					<div>
						<strong>City:</strong> #arguments.order.getShipAddress().getCity()#
					</div>
					<div>
						<strong>State:</strong>	#arguments.order.getShipAddress().getState()#
					</div>
					<div>
						<strong>Zip Code:</strong> #arguments.order.getShipAddress().getZip()#
					</div>
					<div>
						<strong>Day Phone:</strong> #arguments.order.getShipAddress().getDaytimePhone()#
					</div>
					<div>
						<strong>Evening Phone:</strong> #arguments.order.getShipAddress().getEveningPhone()#
					</div>
					<cfif arguments.order.getShipAddress().getMilitaryBase() is not "">
						<div <!---<cfif variables.bIsCurrentMilitaryBase is false>style="color:red;"</cfif>--->>
							<strong>Military Base:</strong> #arguments.order.getShipAddress().getMilitaryBase()#
						</div>
					</cfif>
				</div>
				<div class="shipping_field hidden">
					<form id="orderShippingForm" action="" method="post">
						<div class="field-display">
							<div>
								<label>First Name:</label>
								<input id="firstName" name="firstName" type="text" maxlength="50" value="#arguments.order.getShipAddress().getFirstName()#" />
							</div>
							<div>
								<label>Last Name:</label>
								<input id="lastName" name="lastName" type="text" maxlength="50" value="#arguments.order.getShipAddress().getLastName()#" />
							</div>
							<div>
								<label>Company:</label>
								<input id="company" name="company" type="text" maxlength="50" value="#arguments.order.getShipAddress().getCompany()#" />
							</div>
							<div>
								<label>Address 1:</label>
								<input id="address1" name="address1" type="text" maxlength="50" value="#arguments.order.getShipAddress().getAddress1()#" />
							</div>
							<div>
								<label>Address 2:</label>
								<input id="address2" name="address2" type="text" maxlength="50" value="#arguments.order.getShipAddress().getAddress2()#" />
							</div>
							<div>
								<label>City:</label>
								<input id="city" name="city" type="text" maxlength="50" value="#arguments.order.getShipAddress().getCity()#" />
							</div>
							<div>
								<label>State:</label> #arguments.order.getShipAddress().getState()#
							</div>
							<div>
								<label>Zip Code:</label>
								<input id="zip" name="zip" type="text" maxlength="10" value="#arguments.order.getShipAddress().getZip()#" />
							</div>
							<div>
								<label>Day Phone:</label>
								<input id="daytimePhone" name="daytimePhone" type="text" maxlength="10" value="#arguments.order.getShipAddress().getDaytimePhone()#" />
							</div>
							<div>
								<label>Evening Phone:</label>
								<input id="eveningPhone" name="eveningPhone" type="text" maxlength="10" value="#arguments.order.getShipAddress().getEveningPhone()#" />
							</div>
							</cfoutput>
							<cfif arguments.order.getShipAddress().getMilitaryBase() is not ""&& isShippingUpdatable>
							<div>
								<cfset qry_getMilitaryBases = application.model.AdminMilitaryBase.getMilitaryBases() />
								<label>Military Base:</label>
								<select id="militaryBase" name="militaryBase">  
									<cfoutput query="qry_getMilitaryBases">
										<option value="#completeName#" <cfif qry_getMilitaryBases.completeName is arguments.order.getShipAddress().getMilitaryBase()>selected</cfif>>#qry_getMilitaryBases.completeName#</option>
									</cfoutput>
								</select>
							</div>
							<cfelse>
								<div>
								<input id="militaryBase" name="militaryBase" type="hidden"  value="" />
								</div>
							</cfif>
							<cfoutput>
						</div>
						<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
						<input name="orderShippingSubmit" type="hidden" />
					</form>
				</div>
				<div class="shipping_field hidden buttonContainer">
					<button id="orderShippingSubmit" name="orderShippingSubmit">Update</button>
				</div>
				<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, '46948291-d6b5-4446-b39c-fba144934d70' )>
					<h3>Additional Information</h3>
					<div class="field-display">
						<div>
							<strong>Tax Transaction ID:</strong> #arguments.order.getSalesTaxTransactionId()#
						</div>
						<div>
							<strong>Was Tax Commited?:</strong> #YesNoFormat( arguments.order.getIsSalesTaxTransactionCommited() )#
						</div>
						<div>
							<strong>Tax Refund ID:</strong> #arguments.order.getSalesTaxRefundTransactionId()#
						</div>
					</div>
				</cfif>
				<form id="orderConfirmationForm" action="" method="post">
					<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
					<input name="orderConfirmationSubmit" type="hidden" />
				</form>
				<form id="exchangePaymentForm" action="" method="post">
					<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
					<input name="exchangePaymentSubmit" type="hidden" />
				</form>
				<form id="bannedUserForm" action="" method="post">
					<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
					<input name="bannedUserSubmit" type="hidden" />
				</form>				
				<div style="margin-top:20px; text-align:center; width:100%; border: 1 solid black;">
					<button id="orderConfirmationSubmit" name="orderConfirmationSubmit">Send Order Confirmation</button>

					<cfif arguments.order.getActivationType() eq 'E'>
						<button id="exchangePaymentSubmit" name="exchangePaymentSubmit">Send Exchange Payment</button>
					</cfif>
					
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>


	<cffunction name="getOrderDetailsTabView" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfscript>
			var content = "";
			var lines = arguments.order.getWirelessLines();
			var otherItems = arguments.order.getOtherItems();
			var line = "";
			var service = "";
			var isMissingImei = false;
			var missingImeiCount = 0;
			var local = {};
			var monthlyDue = 0;
			
			//Check if any devices are missing an IMEI
			for (i=1; i <= ArrayLen(lines); i++)
			{
				if ( lines[i].getImei() eq '')
				{
					isMissingImei = true;
					missingImeiCount++;
				}
			}
		</cfscript>

		<cfsavecontent variable="content">
			<cfoutput>
				<h3>Order Details</h3>
				<cfif isMissingImei>
					<div class="errormessage-sticky">
						<cfif missingImeiCount eq 1>
							1 device is missing an IMEI/ESN
						<cfelse>
							#missingImeiCount# devices are missing an IMEI/ESN
						</cfif>
					</div>
				</cfif>
				<div class="order-detail">
					<!--- TODO: Loop through lines --->
					<!---<cfloop array="#lines#" index="line">--->
					<cfloop from="1" to="#ArrayLen(lines)#" index="i">
						<div class="section">
							<div class="section-title">
								<cfif Len(lines[i].getLineRateplan().getGroupName())>#lines[i].getLineRateplan().getGroupName()#<cfelse>Line #i#</cfif>
							</div>
							<div class="section-body">
								<div>Device:</div>
								<div class="item">
									<div class="item-name">#lines[i].getLineDevice().getProductTitle()#</div>
									<cfif lines[i].getLineDevice().getRebate() GT 0>
										<div style="color:##FF0000">An instant rebate of #DollarFormat( lines[i].getLineDevice().getRebate() )# was applied to this device.</div>
									</cfif>
									<cfswitch expression="#order.getCarrierId()#">
										<cfcase value="109,128,299">
											<div>IMEI: #lines[i].getImei()#</div>
											<div>SIM: #lines[i].getSim()#</div>
										</cfcase>
										<cfcase value="42">
											<div>ESN: #lines[i].getImei()#</div>
											<div>SIM: #lines[i].getSim()#</div>
										</cfcase>
										<cfdefaultcase>
											<div>IMEI/ESN: #lines[i].getImei()#</div>
											<div>SIM: #lines[i].getSim()#</div>
										</cfdefaultcase>
									</cfswitch>
									<cfif order.getCarrierId() eq 42>
										<div>SIM: #lines[i].getSim()#</div>
									</cfif>
									<div class="price">
										Retail Price: <span>#DollarFormat( lines[i].getLineDevice().getRetailPrice() )#</span><br />
										<!--- Only non-financed phones have online discount --->
										<cfif lines[i].getLineDevice().getPurchaseType() neq "FP" >
											Online Discount: <span>#DollarFormat( lines[i].getLineDevice().getRetailPrice() - lines[i].getLineDevice().getNetPrice() )#</span><br />
										</cfif>
										Net Price: <span>#DollarFormat( lines[i].getLineDevice().getNetPrice() )#</span ><br />
										Tax: <span>#DollarFormat( lines[i].getLineDevice().getTaxes() )#</span><br />
										<!---Checking for Financed --->
										<cfif lines[i].getLineDevice().getPurchaseType() eq "FP" >
											Down Payment: <span>#DollarFormat(lines[i].getLineDevice().getDownPaymentReceived())#</span><br />
											<cfset monthlyDue = monthlyDue + lines[i].GetMonthlyFee() />
											Monthly Payment: <span>#DollarFormat(lines[i].GetMonthlyFee())#</span><br />
											Term Length: <span>#lines[i].getcontractlength()#</span><br />
											Total Financed: <span>#DollarFormat( (lines[i].getLineDevice().getRetailPrice()) - (lines[i].getLineDevice().getDownPaymentReceived()))#</span><br />
										</cfif>
										Total: <span>#DollarFormat( lines[i].getLineDevice().getNetPrice() + lines[i].getLineDevice().getTaxes() )#</span><br />
									</div>
								</div>
								<!--- Check if line has an associated rate plan --->
								<cfif lines[i].getLineRateplan().getOrderDetailId() NEQ 0>
									<div>Plan:</div>
									<div class="item">
										<div class="item-name">#lines[i].getLineRateplan().getProductTitle()#</div>	
										<cfif lines[i].getLineRateplan().getGersSku() is "EXCHANGED">
											<div class="price">
											Deposit: <span>#DollarFormat( lines[i].getLineRateplan().getNetPrice() )#</span><br />
											</div>
										</cfif>							
										<div class="price">
											<!---Monthly Fee: <span>#DollarFormat( lines[i].getMonthlyFee() )#</span><br />--->
											<cfset monthlyDue = monthlyDue + lines[i].getLineRateplan().getNetPrice() />
											Monthly Fee: <span>#DollarFormat( lines[i].getLineRateplan().getNetPrice() )#</span><br />
										</div>
									</div>
								</cfif>
								<cfif ArrayLen( lines[i].getLineServices() )>
									<div>Services:</div>									
									<cfloop array="#lines[i].getLineServices()#" index="service">
										<div class="item">		
											<div class="item-name">#service.getProductTitle()#</div>																			
											<div class="price">
												<cfset monthlyDue = monthlyDue + service.getLineService().getMonthlyFee() />
												Monthly Fee: <span>#DollarFormat( service.getLineService().getMonthlyFee() )#</span><br />
											</div>
										</div>
									</cfloop>
								</cfif>
								<cfif ArrayLen( lines[i].getLineAccessories() )>
									<div>Accessories:</div>
									<cfloop array="#lines[i].getLineAccessories()#" index="accessory">
										<div class="item">
											<div class="item-name">#accessory.getProductTitle()#</div>
											<div class="price">
												Retail Price: <span>#DollarFormat( accessory.getRetailPrice() )#</span><br />
												Online Discount: <span>#DollarFormat( accessory.getRetailPrice() - accessory.getNetPrice() )#</span><br />
												Net Price: <span>#DollarFormat( accessory.getNetPrice() )#</span ><br />
												Tax: <span>#DollarFormat( accessory.getTaxes() )#</span><br />
												Total: <span>#DollarFormat( accessory.getNetPrice() + accessory.getTaxes() )#</span><br />
											</div>
										</div>
									</cfloop>
								</cfif>
								<!--- Warranty --->
								<cfif lines[i].getLineWarranty().getOrderDetailId() NEQ 0>
									<cfset local.msg =  lines[i].getLineWarranty().getMessage() />
									<div>Protection Plan:</div>
									<div class="item">
										<div class="item-name">#lines[i].getLineWarranty().getProductTitle()#</div>
											<cfif isJSON(local.msg)>												
												<cfset local.msgobj = deserializeJson(local.msg) />
												<cfif structKeyExists(local.msgobj,"op_status") >
													<cfif local.msgobj.op_status is "Created">
														<cfset local.msgobj.op_status = "Attached" />
													</cfif>
										<div class="subitem">
											AC Status: #local.msgobj.op_status#
											<cfif local.msgobj.op_status is "Cancelled">
												<br/>Cancel Date: #local.msgobj.cancellationDate#
												<br/>Device Id: #local.msgobj.deviceid#
												<br/>Agreement: #local.msgobj.agreement#
												<br/>Tran Id: #local.msgobj.tranid#
												<br/>PO: #local.msgobj.po#
											</cfif>
											<cfif local.msgobj.op_status is "Device Failed">
												<br/>Op: #local.msgobj.op#
												<br/>Device Id: #local.msgobj.deviceid#
												<br/>RefId: #local.msgobj.referenceid#
												<br/>Error Code: #local.msgobj.errorcode#
												<br/>Error Msg: #local.msgobj.errormessage#
											</cfif>
											<cfif local.msgobj.op_status is "General Error">
												<br/>Error Code: #local.msgobj.errorcode#
												<br/>Error Msg: #local.msgobj.errormessage#
											</cfif>
											<cfif local.msgobj.op_status is "Attached">
											<br/>Agreement: #local.msgobj.agreement#
											<br/>AC Date: #local.msgobj.acdate#
											<br/>Tran Id: #local.msgobj.tranid#
											<br/>PO: #local.msgobj.po#
											</cfif>													
										</div>													
												</cfif>
											</cfif>
																
										<div class="price">
											Net Price: <span>#DollarFormat( lines[i].getLineWarranty().getNetPrice() )#</span><br />
											Tax: <span>#DollarFormat( lines[i].getLineWarranty().getTaxes() )#</span><br />
											Total: <span>#DollarFormat( lines[i].getLineWarranty().getNetPrice() + lines[i].getLineWarranty().getTaxes() )#</span><br />											
										</div>
									</div>
								</cfif>								
							</div>
						</div>
					</cfloop>
					<cfif ArrayLen( otherItems )>
						<div class="section">
							<div class="section-title">Additional Items</div>
							<div class="section-body">
								<cfloop array="#otherItems#" index="item">
									<div>
										#item.getProductTitle()# <span class="price">#DollarFormat( item.getNetPrice() )#</span>
									</div>
								</cfloop>
							</div>
						</div>
					</cfif>
					<div class="section">
						<div class="section-title">Checkout</div>
						<div class="section-body">
							<div>
								Shipment Cost (#order.getShipMethod().getDisplayName()#): <span class="price">#dollarFormat( order.getShipCost() )#</span>
							</div>
							<div>
								Discount Total: <span class="price">#dollarFormat(order.getOrderDiscountTotal())#</span>
							</div>
							<div>
								<strong>Promotion Codes:</strong> #arguments.order.getPromotionCodeList()#
							</div>
							<div>
								Taxes: <span class="price">#dollarFormat( order.getTaxTotal() )#</span>
							</div>
							<div>
								Due Monthly: <span class="price">#dollarFormat( monthlyDue )#</span> 
							</div>
							<div>
								"Due Today" Total  (includes Taxes & Shipping): <span class="price">#dollarFormat( order.getSubTotal() + order.getShipCost() + order.getTaxTotal() - order.getOrderDiscountTotal() )#</span>
							</div>
						</div>
					</div>
				</div>
				
			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>

	<cffunction name="getActivationTabView" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="qActivationLines" type="query" required="true" />
		<cfargument name="activationMessages" type="array" required="false" default="#arrayNew(1)#"/>
		
		<cfscript>
			var content = '';
			var lines = order.getWirelessLines();
			var isMissingImei = false;
			var isVerizonCreditApproved = false;
			var isLocked = false;
			var lockedByUser = '';
			var PaymentGateway = '';
			var canActivate = false;
			var canActivatePerLine = false;
			var assetPaths = application.wirebox.getInstance('assetPaths');
			var local = {};
			
			//Check of order is locked by another user
			if ( Len(arguments.order.getUnlockDateTime()) && arguments.order.getUnlockDateTime() gte Now() && arguments.order.getLockedById() neq session.AdminUser.AdminUserId)
			{
				isLocked = true;
				lockedByUser = CreateObject( "component", "cfc.model.User" ).init();
				lockedByUser.getUserByID( order.getLockedById() );
				unlockDateTime = arguments.order.getUnlockDateTime();				
			}

			//Check if any devices are missing an IMEI
			for (i=1; i <= ArrayLen(lines); i++)
			{
				if ( lines[i].getImei() eq '')
				{
					isMissingImei = true;
					break;
				}
			}

			//Check if Verizon New Activation has received a AP from CATS
			if (arguments.order.getCarrierId() eq 42 and arguments.order.getActivationType() eq 'N' and (arguments.order.getCreditCheckStatusCode() eq 'AP' or application.model.CatsFileManager.isCreditApproved( arguments.order )) )
			{
				isVerizonCreditApproved = true;
			}
			
			//Check if model permits single line activation for carrier
			if( arguments.order.getCarrierId() == 299 ) {
				canActivatePerLine = true;
			}
		</cfscript>

		<cfsavecontent variable="content">
			
			<script type="text/javascript">
				jQuery(document).ready( function($){
					$('.activateLine').click( function( event ) {
						event.preventDefault();
						
						var preloader = $('<img>').addClass('ajax-loader').attr('src','<cfoutput>#assetPaths.admin.common#</cfoutput>images/ajax-loader_40x15.gif');
						
						var activateBtn = $(this);
						activateBtn.hide().after(preloader);
						
						var wirelessLineID = $(this).closest('tr').attr('data-wirelessLineID');
						var lineNumber = $(this).closest('tr').attr('data-lineNumber');
						var carrierID = $(this).closest('tr').attr('data-carrierID');
						var activationType = $(this).closest('tr').attr('data-activationType'); 
						
						$.ajax({
							cache: false,
							type: "GET",
							url: "proxy/AJAXProxy.cfc",
							data: {
								method: 'activateLine',
								activationType: activationType,
								carrierID:  carrierID,
								wirelessLineID: wirelessLineID,
								lineNumber: lineNumber
							},
							success: function(data) {
								var result = JSON.parse(data);
								addActivationMessage( result.SUCCESS, lineNumber, result.MESSAGES );
								updateActivationStatus( wirelessLineID, result.STATUS, result.ACCOUNTSTATUS );
								if (result.STATUS == 'Ready') {
									activateBtn.show();
								} 
								activateBtn.next('.ajax-loader').remove();
								
							}							
						})
						
						return false;
					});	
						
					function addActivationMessage( success, lineNumber, messages ) {
						var html = "";
						var containerID = success ? 'activationMessage' : 'activationError';
						var container = $('#' + containerID).clone().attr("id",'activationMessage-' + lineNumber );
						$.each(messages, function(idx, val) {
							if( html.length )
								html += '<br />';
							html += val;
						})
						container.insertAfter($('#' + containerID));
						container.find('span').html(html);
						container.show('slow');
					}
					
					function updateActivationStatus( wirelessLineID, status, accountStatus ) {
						$('tr[data-wirelessLineID=' + wirelessLineID + ']').find('.status:first span')
							.html('<em>' + status + '</em>')
							.effect("pulsate");
						$('.wirelessAccountActivationStatus')
							.html('<em>' + accountStatus + '</em>')
							.effect("pulsate");
					}
						
					
				});
			</script>
			<cfoutput>
				<h3>Activations</h3>	
				
				<!--- Error/Success messages from calls to ajax proxy --->
				<div id="activationMessage" class="message-sticky" style="display:none;">
			    	<span class="form-confirm-inline"></span>
			    </div>
				<div id="activationError" class="errormessage-sticky" style="display:none;">
			    	<span class="form-error-inline" style="height:auto;"></span>
			    </div>

				<cfif isLocked>
					<div style="margin-bottom: 10px; margin-right:auto; border: 1px solid rgb(204, 204, 204); padding: 10px; background: none repeat scroll 0% 0% rgb(238, 238, 238);">
						<p>
							Order has been locked by #lockedByUser.getFirstName()# #lockedByUser.getLastName()# until 
							#DateFormat( unlockDateTime, 'm/d/yyyy')# #TimeFormat( unlockDateTime, 'h:mm:ss tt')#.
						</p>
						
						<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, 'D5FE5E41-48CE-437A-92A5-B33ED5016C10' ) >
							<form  name="unlockForm" id="unlockForm" action="" class="middle-forms" method="post">
								<div align="center">
									<input type="hidden" name="orderId" value="#order.getOrderId()#" />
									<input type="submit" name="unlockOrderSubmit" value="Unlock Order" style="width:150px;" />
								</div>
							</form>
						</cfif>
					</div>
				</cfif>
				
				<cfif arguments.qActivationLines.recordCount>

					<!--- Is activation allowed? --->
					<cfif application.model.securityService.isFunctionalityAccessable(session.adminUser.adminUserId, '1a48a57a-c1ba-4cd8-a649-5e602359e37e')
						and arguments.order.getWirelessAccount().getActivationStatus() neq 2
						and arguments.order.getWirelessAccount().getActivationStatus() neq 6
						and !isMissingImei
						and !isLocked>	
						<cfset canActivate = true>
					</cfif>
					
					<cfset local.PcrDisabled = true>

					<cfif year(arguments.order.getPcrDate()) EQ 9999>
						<cfset local.PcrDisabled = false>
					</cfif>

					<cfif local.PcrDisabled>
						<div style="float:right;color:red;padding:10px 5px;;">
						PCR started #DateFormat(arguments.order.getPcrDate())# #TimeFormat(arguments.order.getPcrDate())#
						</div>
					<cfelse>
					<form action="" id="pcrForm" class="middle-forms" method="post" style="float:right;">

						<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
						<input name="carrier" type="hidden" value="#arguments.order.getCarrierId()#" />
						<input name="wirelessAccountId" type="hidden" value="#arguments.order.getWirelessAccount().getWirelessAccountId()#" />
						<input name="pcrSubmit" type="submit" style="width:100px;" value="Start PCR" onclick="return confirm('Are you sure you wish to convert this order to PCR?')" />
					</form>
					</cfif>
					<table class="table-long">
						<tr>
							<th>Line ##</th>
							<th>Plan</th>
							<th>Carrier</th>
							<th>Activation Status</th>
							<cfif canActivatePerLine>
								<th width="80"></th>
							</cfif>
						</tr>
						<cfloop query="arguments.qActivationLines">
							<tr data-wirelessLineID="#arguments.qActivationLines.wirelessLineID#" data-lineNumber="#arguments.qActivationLines.currentRow#" data-carrierID="#arguments.order.getCarrierID()#" data-activationType="#arguments.qActivationLines.activationType#">
								<cfif application.model.securityService.isFunctionalityAccessable(session.adminUser.adminUserId, '57796BE4-B2AC-4AD2-B87E-8E688CE47521')>
									<td><a href="##" class="activationListing {wirelessLineId:#arguments.qActivationLines.wirelessLineId[arguments.qActivationLines.currentRow]#, lineNumber:#arguments.qActivationLines.currentRow#}">Line #arguments.qActivationLines.currentRow#</a></td>
								<cfelse>
									<td>Line #arguments.qActivationLines.currentRow#</td>
								</cfif>
								<td>#trim(arguments.qActivationLines.productTitle[arguments.qActivationLines.currentRow])#</td>
								<td>#trim(arguments.qActivationLines.companyName[arguments.qActivationLines.currentRow])#</td>
								<td class="status"><span>#trim(arguments.qActivationLines.activationStatusDescription[arguments.qActivationLines.currentRow])#</span></td>
								<cfif canActivatePerLine>
									<cfif canActivate 
										and arguments.order.getStatus() eq 2 
										and listContainsNoCase( 'Ready,Failure', arguments.qActivationLines.activationStatusDescription ) 
										and arguments.qActivationLines.activationType eq 'U'>
										<td class="activate" style="text-align:center;"><button class="activateLine">Activate</button></td>
									<cfelse>
										<td><button disabled="true">Activate</button></td>
									</cfif>
								</cfif>
							</tr>
						</cfloop>
					</table>

					<cfif canActivate>					

						<cfswitch expression="#arguments.order.getCarrierId()#">
							<cfcase value="42"><!--- Verizon --->
								<form action="" id="fullActivationForm" class="middle-forms" method="post">
									<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
									<input name="carrier" type="hidden" value="#arguments.order.getCarrierId()#" />
									<input name="wirelessAccountId" type="hidden" value="#arguments.order.getWirelessAccount().getWirelessAccountId()#" />
									<input name="activationFullSubmit" type="hidden" />
									Requested Activation Date (used to activate all lines): <input name="requestedActivationDate" value = "#DateFormat( DateAdd( 'd', Now(), 2), 'mm/dd/yyyy' )#" style="width:100px">
								</form>
								<div id="progressbar" style="width:220px;"></div>
								<div align="center" style="text-align: center; white-space: nowrap">
									<cfif arguments.order.getStatus() eq 1>
										#buildFormForPaymentCapture( arguments.Order )#
									<cfelse>
										<button name="capture" style="width: 150px" disabled="true" />Payment Captured</button>
									</cfif>
									<cfif arguments.order.getStatus() eq 2 and !isMissingImei>
										<button name="autoActivationSubmit" id="autoActivationSubmit" style="width: 150px">Activate All</button>
									<cfelse>
										<button name="autoActivationSubmit" style="width: 150px" disabled="true">Activate All</button>
									</cfif>
	
								</div>
							</cfcase>
							<cfcase value="109"><!--- AT&T --->
								<form action="" id="fullActivationForm" class="middle-forms" method="post">
									<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
									<input name="carrier" type="hidden" value="#arguments.order.getCarrierId()#" />
									<input name="wirelessAccountId" type="hidden" value="#arguments.order.getWirelessAccount().getWirelessAccountId()#" />
									<input name="purchaseType" type="hidden" value="#qActivationLines.PurchaseType#" />
									<input name="activationFullSubmit" type="hidden" />
									Requested Activation Date (used to activate all lines): <input name="requestedActivationDate" value = "#DateFormat( DateAdd( 'd', Now(), 2), 'mm/dd/yyyy' )#" style="width:100px">
								</form>
								<div id="progressbar" style="width:220px;"></div>
								<div align="center" style="text-align: center; white-space: nowrap">
									<cfif arguments.order.getStatus() eq 1>
										#buildFormForPaymentCapture( arguments.Order )#
									<cfelse>
										<button name="capture" style="width: 150px" disabled="true" />Payment Captured</button>
									</cfif>
									<cfif arguments.order.getStatus() eq 2>
										<button name="autoActivationSubmit" id="autoActivationSubmit" style="width: 150px">Activate All</button>
									<cfelse>
										<button name="autoActivationSubmit" style="width: 150px" disabled="true">Activate All</button>
									</cfif>
								</div>
							</cfcase>
							<cfcase value="128"><!--- T-Mobile --->
								<form action="" id="fullActivationForm" class="middle-forms" method="post">
									<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
									<input name="carrier" type="hidden" value="#arguments.order.getCarrierId()#" />
									<input name="wirelessAccountId" type="hidden" value="#arguments.order.getWirelessAccount().getWirelessAccountId()#" />
									<input name="activationFullSubmit" type="hidden" />
								</form>
								<div id="progressbar" style="width:220px;"></div>
								<div align="center" style="text-align: center; white-space: nowrap">
									<cfif arguments.order.getStatus() eq 1>
										#buildFormForPaymentCapture( arguments.Order )#
									<cfelse>
										<button name="capture" style="width: 150px" disabled="true" />Payment Captured</button>
									</cfif>
									<cfif arguments.order.getStatus() eq 2>
										<button name="autoActivationSubmit" id="autoActivationSubmit" style="width: 150px">Activate All</button>
									<cfelse>
										<button name="autoActivationSubmit" style="width: 150px" disabled="true">Activate All</button>
									</cfif>
								</div>
							</cfcase>
							<cfcase value="299"><!--- Sprint --->
								<form action="" id="fullActivationForm" class="middle-forms" method="post">
									<input name="orderId" type="hidden" value="#arguments.order.getOrderId()#" />
									<input name="carrier" type="hidden" value="#arguments.order.getCarrierId()#" />
									<input name="wirelessAccountId" type="hidden" value="#arguments.order.getWirelessAccount().getWirelessAccountId()#" />
									<input name="activationFullSubmit" type="hidden" />
								</form>
								<div id="progressbar" style="width:220px;"></div>
								<div align="center" style="text-align: center; white-space: nowrap">
									<cfif arguments.order.getStatus() eq 1>
										#buildFormForPaymentCapture( arguments.Order )#
									<cfelse>
										<button name="capture" style="width: 150px" disabled="true" />Payment Captured</button>
									</cfif>
								</div>
							</cfcase>                            
						</cfswitch>
					</cfif>
				<cfelse>
					<p>There are no activations associated with this order.</p>
				</cfif>

				<!--- Create the applecare object --->
				<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
				
				<!--- see if we need to verify AppleCare for any lines in this order --->
				<cfset local.appleCare = application.wirebox.getInstance("AppleCare") />
				<cfset local.appleCarePoList = "" />
				<cfif local.appleCare.isAppleCareOrder(arguments.order.getOrderId())>
					<cfset local.AppleCareMessages = local.appleCare.getMessages(arguments.order.getOrderId()) />
					<cfset local.vCount = 0 />
					<!--- Loop thru the applecare messages and make sure at least one needs to be verified --->
					<cfloop array="#local.AppleCareMessages#" index="local.apm">
						<cfif structKeyExists(local.apm,"op") and local.apm.op is "Needs Verify" >
							<cfset local.vCount = local.vCount + 1 />
							<cfset local.appleCarePoList = ListAppend(local.appleCarePoList,local.apm.po) />
						</cfif> 
					</cfloop>
					<cfif local.vCount gt 0>
						<div align="center" style="text-align: center; white-space: nowrap">
							<form action="" id="fullAppleCareVerifyForm" class="middle-forms" method="post">
								<input type="hidden" name="orderId" value="#arguments.order.getOrderId()#" />
								<input type="hidden" name="poList" value="#local.applecarePoList#" />
								<button name="verifyAppleCareSubmit" id="VerifyAppleCareSubmit" style="width: 150px">Verify AppleCare (#local.vCount#)</button>
							</form>
						</div>	
					</cfif>
				</cfif>
		

				<!--- see if we need to attach AppleCare to any lines in this order --->
				<cfset local.appleCarePoList = "" />
				<cfif local.appleCare.isAppleCareOrder(arguments.order.getOrderId())>
					<cfset local.AppleCareMessages = local.appleCare.getMessages(arguments.order.getOrderId()) />
					<cfset local.vCount = 0 />
					<!--- Loop thru the applecare messages and make sure at least one has been verified --->
					<cfloop array="#local.AppleCareMessages#" index="local.apm">
						<cfif structKeyExists(local.apm,"op") 
							and local.apm.op is "Verify"
							and structKeyExists(local.apm,"op_status")
							and local.apm.op_status is "Verified" >
							<cfset local.vCount = local.vCount + 1 />
							<cfset local.appleCarePoList = ListAppend(local.appleCarePoList,local.apm.po) />
						</cfif> 
					</cfloop>
					<cfif local.vCount gt 0>
						<div align="center" style="text-align: center; white-space: nowrap">
							<form action="" id="fullAppleCareAttachForm" class="middle-forms" method="post">
								<input type="hidden" name="orderId" value="#arguments.order.getOrderId()#" />
								<input type="hidden" name="poList" value="#local.applecarePoList#" />
								<button name="attachAppleCareSubmit" id="AttachAppleCareSubmit" style="width: 150px">Attach AppleCare (#local.vCount#)</button>
							</form>
						</div>	
					</cfif>
				</cfif>

			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(content) />
	</cffunction>

	<cffunction name="getDebugTabView" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfset var local = structNew() />
		
		
		<cfif arguments.order.getCarrierId() is 109 >	
			<cfquery name="qOrderTypes" datasource="wirelessadvocates"  > 
				select distinct orderType from [service].[OrderSubmissionLog] where orderid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order.getOrderId()#">
				order by orderType
			</cfquery>	
			<cfsavecontent variable="content">	
				<cfif qOrderTypes.recordcount is 0>
					There are currently no OrderSubmissionLog records for this order.
				</cfif>		
				<cfloop query="qOrderTypes">
					<cfstoredproc procedure="service.OrderSubmissionGet" datasource="wirelessadvocates" >
						<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.order.getOrderId()#" />
						<cfprocparam cfsqltype="cf_sql_varchar" value="#qOrderTypes.orderType#" />
						<cfprocresult name="local.qSubmitOrderRequest" />
					</cfstoredproc>		
					<br/><cfoutput>#qOrderTypes.orderType#</cfoutput> OrderEntry:<br/>
					<cfdump var="#deserializeJson(local.qSubmitOrderRequest.orderentry)#" expand="false" />	
					<cfif local.qSubmitOrderRequest.orderResult is not "">
						<br/><cfoutput>#qOrderTypes.orderType#</cfoutput> OrderResult:<br/>
						<cfdump var="#deserializeJson(local.qSubmitOrderRequest.orderResult)#" expand="false" />	
					</cfif>
					<cfif qOrderTypes.orderType is "SubmitOrder">
						<form  name="resubmitOrderForm" id="resubmitOrderForm" action="" class="middle-forms" method="post">
							<div align="center">
								<input type="hidden" name="orderId" value="<cfoutput>#arguments.order.getOrderId()#</cfoutput>" />
								<input type="submit" name="resubmitOrder" value="Resubmit Order" style="width:150px;" />
							</div>
						</form>							
					</cfif>

				</cfloop>
			</cfsavecontent>	
		
		<cfelse>
			<cfsavecontent variable="content">
				Debug tab currently supports only ATT orders.
			</cfsavecontent>
		</cfif>
		
		
		
        <cfreturn content>

   	</cffunction>

	<cffunction name="getExchangeTabView" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />

        <cfset var local = structNew() />
        <!---<cfset qProducts = application.model.product.getExchangableProducts(arguments.order.getCarrierId()) />--->

       	<cfset local.childOrders = order.GetChildOrders()>

       	<!--- get the current line items in the order that have an RMA --->
        <cfset local.orderDetails = order.getOrderDetail() />
        <cfset local.RMAOrders = arrayNew(1) />
  
        <cfloop from="1" to="#arraylen(local.orderDetails)#" index="i">
        	<cfif trim(local.orderDetails[i].getRMANumber()) neq "" >
            	<cfset arrayAppend(local.RMAOrders, local.orderDetails[i]) />
            </cfif>
			<!---<cfset local.orderDetails[i].dump()>--->
        </cfloop>

        <cfsavecontent variable="content">
        	<cfoutput>

            <!--- get the list of exchange orders for this order --->

            <h3>Exchanges</h3>
            <cfif arrayLen(local.childOrders) gt 0>
            	<table class="table-long">
                    <tr>
                        <th>Order ##</th>
                        <th>Status</th>
                        <th>Type</th>
                        <th>Total</th>
                        <th></th>
                    </tr>
                    <cfloop from="1" to="#arrayLen(local.childOrders)#" index="i">
                        <tr>
                        	<td><a href="/admin/index.cfm?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#local.childOrders[i].getOrderId()#">#local.childOrders[i].getOrderId()#</a></td>
                            <td>#local.childOrders[i].getStatusNameByValue(local.childOrders[i].getStatus())#</td>
                            <td>#local.childOrders[i].getSortCode()#</td>
                            <td>#dollarFormat(local.childOrders[i].getOrderTotal())#</td>
                            <td>
                            	<cfif local.childOrders[i].getStatus() lt 2>
									<!--- mostly for test environments (account for non-port 80 configs) --->
									<cfif cgi.server_port is not 80>
										<cfset local.server_port = ":#server_port#" />
									<cfelse>
										<cfset local.server_port = "" />
									</cfif>
									<!--- Bug 6241: replace hardcoded url below with one derived from Environment/Channel (see channelBeans.xml.cfm). Scott H 12/19/13 --->
                            		<!---<a href="http://membershipwireless.com/index.cfm/go/checkout/do/processPaymentRedirect/orderid/#local.childOrders[i].getOrderId()#" target="_blank">proceed to payment ></a>--->
									<a href="#variables.instance["ChannelConfig"].getDomainName()##local.server_port#/index.cfm/go/checkout/do/processPaymentRedirect/orderid/#local.childOrders[i].getOrderId()#" target="_blank">proceed to payment ></a>
                                </cfif>
                            </td>
                        </tr>
                    </cfloop>
                </table>
            <cfelse>
            	<p>
                    <i>no exchange orders created</i>
                </p>
            </cfif>



            <h3>Generate New Exchange Order</h3>

            <form name="exhangeForm" id="exchangeForm" method="post" action="">
                <ul style="margin-bottom: 20px; margin-left: 10px;">
                    <li>
                        <input type="radio" onclick="setSortCode();" name="SortCodeType" id="SortCode" style="width: 20px;" value="EXX" checked="checked"> Deposit Exchange - No delay for customer, full price.
                    </li>
                    <li>
                        <input type="radio" onclick="setSortCode(); " name="SortCodeType" id="SortCode" style="width: 20px;" value="DEF"> Value Exchange - Short delay for customer while we receive the original.
                    </li>
                </ul>

                <table class="table-long">
                    <tr>
                        <th width="10px">&nbsp;</th>
                        <th>Original Item</th>
						<th>New Item</th>
                        <th>Retail Cost</th>
                        <th>
                        	Original Price <cfif order.getActivationTypeName() neq "">*</cfif>
                        </th>
                    </tr>
                    <!---= loop each of the RMA order line items --->
                    <cfloop from="1" to="#arrayLen(local.RMAOrders)#" index="i">
						<cfset qProducts = application.model.product.getExchangableProducts(carrierid=arguments.order.getCarrierId(),orderDetailType=local.RMAOrders[i].getOrderDetailType()) />
                        <cfset local.product = createobject('component','cfc.model.Product').init()>
                        <cfset local.product.getProduct(local.RMAOrders[i].getProductId())>
						
                        <tr>
                            <td width="20px">
                                <input type="checkbox" id="exchangeOption_#i#"name="exchangeOption" class="exchangeOption" style="width: 20px;" value="#local.RMAOrders[i].getOrderDetailId()#" <cfif local.RMAOrders[i].getOrderDetailType() is 'd'>onclick="toggleExchangedInfo(#i#)"</cfif>/>
                            </td>
                            <td>
                            	<cfif len(local.product.getTitle()) gt 0>
                            		#local.product.getTitle()#
                                <cfelse>
                                	#local.product.getGersSKU()#
                                </cfif>
                            </td>						
							<td>
								<select id="exchangeDevice_#i#" originalSKU="#local.RMAOrders[i].getProductId()#" name="exchangeDevice" class="exchangeDevice" line="#i#" onchange="setPrice(this, '#order.getActivationType()#');" style="width:150px;">
                                    <cfset local.thisPrice = 0>
                                    <cfloop query="qProducts">

                                        <cfset selected = "">
                                        <cfif qProducts.GersSku EQ local.product.getGersSKU()>
                                            <cfset local.thisPrice = qProducts.RetailPrice>
                                            <cfset selected = "selected">
                                        </cfif>

                                        <option #selected# sku="#qProducts.productId#" value="#qProducts.productId#" newPrice="#DollarFormat(qProducts.NewPrice)#" upgradePrice="#DollarFormat(qProducts.UpgradePrice)#" addALinePrice="#DollarFormat(qProducts.AddALinePrice)#" price="#DollarFormat(qProducts.RetailPrice)#" cogs="#qProducts.CogsPrice#">#left(qProducts.name, 75)# - #qProducts.gerssku#</option>
                                    </cfloop>
                                </select>
							</td>
                            <td>
                                <span id="retailPrice_html_#i#" class="retailPriceHtml green">#DollarFormat(local.thisPrice)#</span>
                            </td>
                            <td>
                                <span id="originalPrice_html_#i#" class="originalPrice_html">#DollarFormat(local.RMAOrders[i].getNetPrice())#</span>
								<input type="hidden" id="retailPrice_#i#" class="retailPrice" value="#DollarFormat(local.thisPrice)#" />
								<input type="hidden" id="originalPrice_#i#" class="originalPrice" value="#DollarFormat(local.RMAOrders[i].getNetPrice())#" />
	                        	<input type="hidden" id="originalCogsPrice_#i#" class="originalCogsPrice" value="#DollarFormat(local.RMAOrders[i].getCOGS())#" />
								<input type="hidden" id="exchangeCogsPrice_#i#" class="exchangeCogsPrice" value="#DollarFormat(local.RMAOrders[i].getCOGS())#" />							
							</td>
                        </tr>
						
					<!--- for each item also create and EXCHANGED SKU item --->	
                       <tr id="EXCHANGED_#i#" style="display:none;">
                       		<td>&nbsp;</td>
                            <td colspan="4">
                           		Additional Info Required: <span style="float: right;margin-right:10px;">
								Deposit Amount:&nbsp;<input type="text" name="Exchanged_NetPrice_#i#" id="exchanged_NetPrice_#i#" class="exchanged_NetPrice" style="width:5em;" placeholder="9.99" <cfif local.RMAOrders[i].getOrderDetailType() is not 'd'>value="9.99"</cfif> /></span>
							</td>
                        </tr>

                    </cfloop>

                    <tr>
                        <td>
                            <input type="checkbox" name="sendExchangePaymentEmail" style="width: 10px;">
                        </td>
                        <td colspan="2">
                            <b>Send customer payment link</b>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>

                </table>
                <div>
                	<input type="hidden" id="exchangeLineItems" name="exchangeLineItems" value="" />
                    <input type="hidden" id="exchangeDevices" name="exchangeDevices" value="" />
                    <input type="hidden" id="exchangePrices" name="exchangePrices" value="" />
                    <input type="hidden" id="originalPrices" name="originalPrices" value="" />
					<input type="hidden" id="exchangeCogsPrices" name="exchangeCogsPrices" value="" />
					<input type="hidden" id="originalCogsPrices" name="originalCogsPrices" value="" />
					<input type="hidden" id="exchangedNetPrices" name="exchangedNetPrices" value="" />

                    <input type="hidden" id="sortCode" name="sortCode" value="EXX">

                	<input type="hidden" name="orderId" value="#arguments.order.getOrderId()#" />
                    <button id="exchangeSubmit" name="exchangeSubmit" onClick="return validateForm();">Generate Exchange Order</button> <br>
                </div>
           	</form>


            <cfif order.getActivationTypeName() neq "">
            	<p>
                	* Original price is based on the original order type of #order.getActivationTypeName()#.
                </p>
            </cfif>

            </cfoutput>
            <script language="javascript">
            	
				function toggleExchangedInfo(i) {
					var selectedVal = "";
					var selected = $("input[type='radio'][name='SortCodeType']:checked");
					if (selected.length > 0) {
					    selectedVal = selected.val();
					}
										
					if($('#exchangeOption_'+i).attr('checked') && selectedVal == 'EXX' ) {
    						$('#EXCHANGED_'+i).show();
					} else {
    					$('#EXCHANGED_'+i).hide();
					}
				}
				
				function setSortCode()
				{
					sortCode = $('input[name=SortCodeType]:checked').val();
					$(".retailPriceHtml").removeClass("green");
					$(".originalPrice_html").removeClass("green");

					if(sortCode == "EXX")
					{
						$(".retailPriceHtml").addClass("green");
						$("#sortCode").attr("value", "EXX");
					}
					else
					{
						$(".originalPrice_html").addClass("green");
						$("#sortCode").attr("value", "DEF");
					}
				}

				function setPrice(el, originalOrderType)
				{
					var selIndex = el.selectedIndex;
					var selOption = el.options[selIndex];
					var price = $(selOption).attr("price");
					var upgradePrice = $(selOption).attr("upgradePrice");
					var addALinePrice = $(selOption).attr("addALinePrice");
					var newPrice = $(selOption).attr("newPrice");
					var exchangeCogsPrice = $(selOption).attr("cogs");
					var line = $(el).attr("line");

					//based on the original order, we will set the correct retail price for an exchange.
					if(originalOrderType == "U")
					{
						$("#originalPrice_html_" + line).html(upgradePrice);
						$("#originalPrice_" + line).val(upgradePrice);
					}
					else if(originalOrderType == "N")
					{
						$("#originalPrice_html_" + line).html(newPrice);
						$("#originalPrice_" + line).val(newPrice);
					}
					else if(originalOrderType == "A")
					{
						$("#originalPrice_html_" + line).html(addALinePrice);
						$("#originalPrice_" + line).val(addALinePrice);
					}
					else
					{
						$("#originalPrice_html_" + line).html(price);
						$("#originalPrice_" + line).val(price);
					}

					$("#exchangeCogsPrice_" + line).val(exchangeCogsPrice);

					//set the retail price					
					$("#retailPrice_html_" + line).html(price);
					$("#retailPriceField_" + line).val(price);
				}


				function validateForm()
				{
					var checks = $(".exchangeOption:checked");
					var checkboxes = $(".exchangeOption");
					var processedCt = 0;
					
					// determine the type of exchange order
					var sortCodeTypeVal = "";
					var sortCodeTypeSelected = $("input[type='radio'][name='SortCodeType']:checked");
					if (sortCodeTypeSelected.length > 0) {
					    sortCodeTypeVal = sortCodeTypeSelected.val();
					}

					
					// make sure at least one device was checked
					if(checks.length < 1)
					{
						alert("Select at least one device from the list.");
						return false;
					}
					
					// make sure the exchanged info is completed for each checked item
					if (checks.length > 0)
					{
						
						for(var i = 1; i <= checkboxes.length; i++)
						{
							// find and validate the options that ARE checked and have additional information (EXCHANGED_i)
							if ($('#exchangeOption_'+i).is(":checked") && $("#EXCHANGED_"+i).is(':visible') ) {
								
								if (!(/^\d+\.\d{2}$/.test($('#exchanged_NetPrice_'+i).val()))) {
									alert("Invalid amount (" + $('#exchanged_NetPrice_'+i).val() + ") in Additional Info Deposit Amount entry for line " +i + ". Use 9.99 format.");
									return false;
								}
							}
						}
					}
					
					//set the hidden variables
					var exchangeLineItems = "";
					var exchangeDevices = "";
					var exchangePrices = "";
					var exchangeCogsPrices = "";
					var originalCogsPrices = "";
					var originalPrices = "";
					var exchangedNetPrices = "";

					for(var i = 1; i <= checkboxes.length; i++)
					{
						if ($('#exchangeOption_' + i).is(":checked")) {
						
							//device
							var device = $("#exchangeDevice_"+i);
							if (processedCt) {
								exchangeDevices += ",";
							}
							exchangeDevices += device.attr("value");
							
							//price
							exchangePrice = $("#retailPrice_"+i).val();
							if (processedCt) {
								exchangePrices += ",";
							}
							exchangePrices += exchangePrice;
							
							originalPrice = $("#originalPrice_"+i).val();
							if (processedCt) {
								originalPrices += ",";
							}
							originalPrices += originalPrice;
							
							originalCogsPrice = $("#originalCogsPrice_"+i).val();
							if (processedCt) {
								originalCogsPrices += ",";
							}
							originalCogsPrices += originalCogsPrice;
							
							exchangeCogsPrice = $("#exchangeCogsPrice_"+i).val();
							if (processedCt) {
								exchangeCogsPrices += ",";
							}
							exchangeCogsPrices += exchangeCogsPrice;
							
							// additional Info for EXCHANGED SKU
							if (processedCt) {
								exchangedNetPrices += ",";
							}
							if (sortCodeTypeVal == 'EXX') {
								exchangedNetPrice = $("#exchanged_NetPrice_" + (i)).val();
								exchangedNetPrices += exchangedNetPrice;
							} else {
								exchangedNetPrices += '0.00';
							}
							
							//line items
							if (processedCt) {
								exchangeLineItems += ",";
							}
							exchangeLineItems += $(checkboxes[i-1]).attr("value");
							
							// increment the processed Count
							processedCt++;

						}
					}

					$("#exchangeLineItems").attr("value", exchangeLineItems);
					$("#exchangeDevices").attr("value", exchangeDevices);
					$("#exchangeCogsPrices").attr("value", exchangeCogsPrices);
					$("#originalCogsPrices").attr("value", originalCogsPrices);
					$("#exchangePrices").attr("value", exchangePrices);
					$("#originalPrices").attr("value", originalPrices);
					$("#exchangedNetPrices").attr("value", exchangedNetPrices);
					
					return true;
				}
			</script>
        </cfsavecontent>

        <cfreturn content>

   	</cffunction>


	<cffunction name="getRmaTabView" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfscript>
			var content = "";
			var lines = arguments.order.getWirelessLines();
			var otherItems = arguments.order.getOtherItems();
			var line = "";
			var accessories = [];
			var warranty = "";
			var rmaItems = [];
			var i = 0;
			var j = 0;

			//Add lines items to RMA list
			for (i=1; i <= ArrayLen( lines ); i++)
			{
				ArrayAppend( rmaItems, lines[i].getLineDevice() );
				accessories = lines[i].getLineAccessories();
				warranty = lines[i].getLineWarranty();
				for (j=1; j <= ArrayLen(accessories); j++)
				{
					ArrayAppend( rmaItems, accessories[j] );
				}
				if (warranty.getGroupNumber() > 0) {
					ArrayAppend( rmaItems, warranty );
				}
			}

			//Add other items to RMA list
			for (i=1; i <= ArrayLen( otherItems ); i++)
			{
				ArrayAppend( rmaItems, otherItems[i] );
			}
		</cfscript>

		<cfsavecontent variable="content">				
				<script>
					<!---
					EnableSendRMA = function(val){
					    var rmaSubmit = document.getElementById("returnAuthorizationSubmit");
					    var theForm = document.getElementById("rmaForm");
					    var inputArray = theForm.getElementsByTagName("input");
						var enableButton = 1;
	
					    for(i=0; i < inputArray.length; i++){
							if(inputArray[i].checked == true){
								rmaSubmit.disabled = false;
								enableButton = 0;
							}
						}
	
					    if (enableButton == 1){
					        rmaSubmit.disabled = true;
					    }
					} 
					--->
					$('#rmaForm input:checkbox').change(function(){
						$("#returnAuthorizationSubmit").prop("disabled", $('#rmaForm input:checkbox:checked').length ===0);
					});
				</script>
			<cfoutput>
				<h3>RMA</h3>
				<div class="buttonContainer">
					<button id="toggleRmaButton">Edit</button>
				</div>
				<form id="rmaForm" action="" method="post">
					<table class="table-long">
						<tr>
							<th>RA Form?</th>
							<th>L##</th>
							<th>Product</th>
							<th>GERS SKU</th>
							<th>RMA ##</th>
							<th>RMA Status</th>
							<th>Reason</th>
						</tr>
						<cfloop array="#rmaItems#" index="item">
							<tr>
								<td>
									<cfif (item.getOrderDetailType() eq 'd' || item.getOrderDetailType() eq 'a' || item.getOrderDetailType() eq 'w')  and Len(item.getRmaNumber()) and Len(item.getRmaReason())>
										<div class="rma_data">
											<input id="rmaItem_#item.getOrderDetailId()#" name="returnAuthorizationItem" type="checkbox" style="width:20px" value="#item.getOrderDetailId()#"
												/>
										</div>
									</cfif>
								</td>
								<td><cfif item.getGroupNumber() is not request.config.otherItemsLineNumber>#item.getGroupNumber()#</cfif></td>
								<td>#item.getProductTitle()#</td>
								<td>#item.getGersSku()#</td>
								<td>
									<div class="rma_data">
										#item.getRmaNumber()#
									</div>
									<div class="rma_field hidden">
										<input id="rmaNumber_#item.getOrderDetailId()#" name="rmaNumber_#item.getOrderDetailId()#" type="text" style="width:40px" maxlength="15" class="rma_field" value="#item.getRmaNumber()#" />
									</div>
								</td>
								<td>
									<div class="rma_data">
										#item.getRmaStatusName()#
									</div>
									<div class="rma_field hidden">
										<select name="rmaStatus_#item.getOrderDetailId()#">
											<option value="0" <cfif item.getRmaStatus() EQ 0>selected="selected"</cfif>></option>
											<option value="1" <cfif item.getRmaStatus() EQ 1>selected="selected"</cfif>>Open</option>
											<option value="2" <cfif item.getRmaStatus() EQ 2>selected="selected"</cfif>>Complete</option>
											<option value="3" <cfif item.getRmaStatus() EQ 3>selected="selected"</cfif>>Cancelled</option>
										</select>
									</div>
								</td>
								<td>
									<div class="rma_data">
										#item.getRmaReason()#
									</div>
									<div class="rma_field hidden">
										<select name="rmaReason_#item.getOrderDetailId()#">
											<option value="" <cfif item.getRmaReason() EQ ''>selected="selected"</cfif>></option>
											<option value="Defective" <cfif item.getRmaReason() EQ 'Defective'>selected="selected"</cfif>>Defective</option>
											<option value="Damaged" <cfif item.getRmaReason() EQ 'Damaged'>selected="selected"</cfif>>Damaged</option>
											<option value="Doesn't Like" <cfif item.getRmaReason() EQ 'Doesn''t Like'>selected="selected"</cfif>>Doesn't Like</option>
											<option value="Audio Issues" <cfif item.getRmaReason() EQ 'Audio Issues'>selected="selected"</cfif>>Audio Issues</option>
											<option value="Battery Issues" <cfif item.getRmaReason() EQ 'Battery Issues'>selected="selected"</cfif>>Battery Issues</option>
											<option value="Camera Issues" <cfif item.getRmaReason() EQ 'Camera Issues'>selected="selected"</cfif>>Camera Issues</option>
											<option value="Display Issues" <cfif item.getRmaReason() EQ 'Display Issues'>selected="selected"</cfif>>Display Issues</option>
											<option value="Keypad Issues" <cfif item.getRmaReason() EQ 'Keypad Issues'>selected="selected"</cfif>>Keypad Issues</option>
											<option value="Charging Issues" <cfif item.getRmaReason() EQ 'Charging Issues'>selected="selected"</cfif>>Charging Issues</option>
											<option value="Poor / No Service" <cfif item.getRmaReason() EQ 'Poor / No Service'>selected="selected"</cfif>>Poor / No Service</option>
											<option value="Power Issues" <cfif item.getRmaReason() EQ 'Power Issues'>selected="selected"</cfif>>Power Issues</option>
											<option value="Receive / Transmit Issues" <cfif item.getRmaReason() EQ 'Receive / Transmit Issues'>selected="selected"</cfif>>Receive / Transmit Issues</option>
											<option value="Return" <cfif item.getRmaReason() EQ 'Return'>selected="selected"</cfif>>Return</option>
										</select>
									</div>
								</td>
							</tr>
						</cfloop>
					</table>
					<input id="rmaFormAction" name="rmaFormAction" type="hidden" value="rmaSubmit" />
					<input type="hidden" name="orderId" value="#arguments.order.getOrderId()#" />

				</form>
				<div class="rma_field hidden buttonContainer">
					<button id="rmaSubmit" name="rmaSubmit">Update</button>
				</div>

                <div class="rma_data" style="margin-top:20px; text-align:center; width:100%;">
					<button id="returnAuthorizationSubmit" name="returnAuthorizationSubmit" disabled="true">Send Return Authorization Form</button>
                </div>

			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>


	<cffunction name="getTicketsTabView" access="public" returntype="string" output="false">
		<cfargument name="qTickets" required="true" type="query" />

		<cfset var getTicketsTabViewReturn = '' />

		<cfsavecontent variable="getTicketsTabViewReturn">
			<cfoutput>
				<h3>Order Notes</h3>

				<cfif arguments.qTickets.recordCount>
					<table class="table-long" style="padding-right: 20px;">
						<tr>
							<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, 'E4A50133-3C60-46AB-B441-B6E9EE785AE4' )>
								<th>Delete</th>
							</cfif>
							<th>Date</th>
							<th>Subject</th>
							<th>Created By</th>
							<th>Details</th>
						</tr>

						<cfloop query="arguments.qTickets">
							<tr>
								<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, 'E4A50133-3C60-46AB-B441-B6E9EE785AE4' )>
									<td><a href="#cgi.script_name#?c=#url.c#&orderId=#url.orderId#&OrderNoteId=#arguments.qTickets.OrderNoteId#&deleteNoteSubmit=1">Delete</a></td>
								</cfif>
								<td>#dateFormat(qTickets.DateCreated, 'mm/dd/yyyy')# #TimeFormat(qTickets.DateCreated, 'h:mm tt')#</td>
								<td>#trim(qTickets.Name)#</td>
								<td>
									<cfif Len(qTickets.FirstName) or Len(qTickets.LastName)>
										#trim(qTickets.FirstName)# #trim(qTickets.LastName)#
									<cfelse>
										Unknown
									</cfif>
								</td>
								<td><a href="javascript: void();" class="toggleNoteDisplay {noteId: '#arguments.qTickets.OrderNoteId#'}">Show</a></td>
							</tr>
							<tbody id="noteRow-#arguments.qTickets.OrderNoteId#" style="display: none;">
								<td colspan="4" style="border: 1px; border-style: dashed; background-color: ##eee">#qTickets.NoteBody#</td>
							</tbody>
						</cfloop>
					</table>
				<cfelse>
					<p>There are no notes associated with this order.</p>
				</cfif>

				<h3>Add Note</h3>
				<cfset addTicketView = trim(application.view.TicketService.getAddTicketView()) />
				#trim(variables.addTicketView)#

			</cfoutput>
		</cfsavecontent>

		<cfreturn getTicketsTabViewReturn />
	</cffunction>

	<cffunction name="getCallNotesView" access="public" returntype="string" output="false">
		<cfargument name="qNotes" required="true" type="query" />

		<cfset var getCallNotesViewReturn = '' />

		<cfsavecontent variable="getCallNotesViewReturn">
			<h3>Add Call Note</h3>
			<cfset addNoteView = trim(application.view.ticketService.getAddNoteView()) />

			<div style="text-align: center">
				<cfoutput>#trim(variables.addNoteView)#</cfoutput>
			</div>

			<h3>Call Notes</h3>
			<cfoutput>
				<cfif arguments.qNotes.recordCount>
					<table class="table-long" style="padding-right: 20px;">
						<tr>
							<th width="120">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Date</strong></th>
							<th><strong>Email Address</strong></th>
							<th width="120"><strong>Created By</strong></th>
							<th width="50" style="text-align: center"><strong>Details</strong></th>
						</tr>
						<cfloop query="arguments.qNotes">
							<cfset qry_callSubject = application.model.ticketService.getCallNoteSubjects(subjectId = arguments.qNotes.subjectId[arguments.qNotes.currentRow]) />
							<cfset callSubject = qry_callSubject.subject />
							<tr>
								<td width="120" style="text-align: center"><a href="#cgi.script_name#?c=#url.c#&on=true&noteId=#arguments.qNotes.noteId[arguments.qNotes.currentRow]#">#dateFormat(arguments.qNotes.dateCreated[arguments.qNotes.currentRow], 'mm/dd/yyyy')# #TimeFormat(arguments.qNotes.dateCreated[arguments.qNotes.currentRow], 'h:mm tt')#</a></td>
								<td>
									<cfif len(trim(trim(arguments.qNotes.emailAddress[arguments.qNotes.currentRow])))>
										#trim(arguments.qNotes.emailAddress[arguments.qNotes.currentRow])#
										<cfif len(trim(variables.callSubject))>
											<br />
											<em>#trim(variables.callSubject)#</em>
										</cfif>
									<cfelse>
										N/A
										<cfif len(trim(variables.callSubject))>
											<br />
											<em>#trim(variables.callSubject)#</em>
										</cfif>
									</cfif>
								</td>
								<td width="120">#trim(application.model.accountService.getUsername(adminUserId = arguments.qNotes.adminUserId[arguments.qNotes.currentRow]))#</td>
								<td width="50" style="text-align: center"><a href="javascript: void();" class="toggleNoteDisplay {noteId: '#arguments.qNotes.noteId[arguments.qNotes.currentRow]#'}">Show</a></td>
							</tr>
							<tbody id="noteRow-#arguments.qNotes.noteId[arguments.qNotes.currentRow]#" style="display: none;">
								<td colspan="4" style="border: 1px; border-style: dashed; background-color: ##eee">#qNotes.message#</td>
							</tbody>
						</cfloop>
					</table>
				<cfelse>
					<p>No call note currently exist.</p>
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfreturn getCallNotesViewReturn />
	</cffunction>

	<cffunction name="getUpgradeCommissionSkuView" output="false" access="public" returntype="string">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="qCommissionSku" type="query" required="true" />
		<cfset var content = "" />

		<cfsavecontent variable="content">
			<cfoutput>
				<form name="commissionSkuForm" action="" id="commissionSkuForm" class="middle-forms" method="post">
					<h3>Commission SKU</h3>
					<fieldset>
						<legend>Fieldset Title</legend>
						<div>
							<label for="ratePlanType">Rate Plan Type</label>
							<select id="ratePlanType" name="ratePlanType">
								<option value=""></option>
								<option value="IND">Individual</option>
								<option value="IND">Multiline</option>
								<option value="FAM">Family</option>
							</select>
						</div>
						<div>
							<label for="lineType">Line Type</label>
							<select id="lineType" name="lineType">
								<option value=""></option>
								<option value="PRI">Primary</option>
								<option value="ADD">Secondary</option>
							</select>
						</div>
						<div>
							<label for="monthlyFee">Existing Monthly Charge</label>
							<input name="monthlyFee" id="monthlyFee" type="input" class="{validate:{required:true, number:true}}" value="" />
						</div>
					</fieldset>
					<input name="submitCommissionSkuForm" type="hidden" />
					<input name="carrierId" type="hidden" value="#order.getCarrierId()#"/>
					<input name="orderDetailId" type="hidden" value="#qCommissionSku.OrderDetailId#"/>
				</form>
				<button id="commissionSkuSubmit" name="commissionSkuSubmit">Update Commission SKU</button>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>


	<cffunction name="getActivationListView" output="false" access="public" returntype="string">
		<cfargument name="qActivations" type="query" required="true" />
		<cfset var content = "" />

		<cfsavecontent variable="content">
			<cfoutput>
				<div class="customer-service">
					<h3>Search Results</h3>
					<cfif arguments.qActivations.RecordCount>
						<table id="orderList" class="table-long gridview-10">
		                    <thead>
		                        <tr>
		                            <th>Order ID</th>
		                            <th>Date</th>
		                            <th>Order Type</th>
									<th>Carrier</th>
									<th>Current Account ##</th>
									<th>Order<br />Assisted?</th>
									<th>Activation<br />Status</th>
									<th>Scenario</th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                    	<cfloop query="arguments.qActivations">
		                            <tr>
		                                <td><a href="?c=8edd9b84-6a06-4cd0-b88a-2a27765f88ff&orderId=#OrderId#" target="_blank">#OrderId#</a></td>
		                                <td>#DateFormat( OrderDate, "mm/dd/yyyy" )#</td>
		                                <td>#trim(application.model.order.getActivationTypeName(type = trim(activationType[arguments.qActivations.currentRow])))#</td>
										<td>#CompanyName#</td>
										<td>#CurrentAcctNumber#</td>
										<td>#YesNoFormat( OrderAssistanceUsed )#</td>
										<td>#ActivationStatusDescription#</td>
										<td><cfif scenarioID eq 1>ECOM<cfelseif scenarioID eq 2>DD<cfelse>Unknown</cfif></td>
		                            </tr>
		  						</cfloop>
		                    </tbody>
		                </table>
					<cfelse>
						<p>There were no pending Activations found with your search criteria.</p>
					</cfif>
				</div>
				<div class="clear"></div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content />
	</cffunction>
	
	<cffunction name="buildFormForPaymentCapture" access="private" returntype="string" output="false">
		<cfargument name="Order" type="cfc.model.Order" required="true">
		
		<cfscript>
			var htmlOut = "";
			var formFields = "";
			var PaymentGateway = getPaymentService().getPaymentGatewayByID( arguments.Order.getPaymentGatewayID() );
			var actionURL = PaymentGateway.buildGatewayFormAction();
			var args = getPaymentService().getOrderPaymentData( arguments.Order );
				args.returnURL = 'http://' & cgi.http_host & cgi.script_name & '?c=' & url.c & '&orderId=' & arguments.Order.getOrderId() & '&selectedTab=2';
				
			formFields = PaymentGateway.buildGatewayFormElements(argumentCollection = args);				
		</cfscript>
		
		<cfsavecontent variable="htmlOut">
			<cfoutput>
            	<button id="capture" name="capture" style="width: 150px">Capture Payment</button>
				<form id="paymentForm1" class="middle-forms" action="#trim(actionURL)#" method="post" style="display: none">
					<input type="hidden" name="doCapture" value="true" />
					<input type="hidden" value="#arguments.Order.getOrderId()#" name="orderId" />
					#trim(formFields)#
				</form>
            </cfoutput>
		</cfsavecontent>
		
		<cfreturn htmlOut>
	</cffunction>
	
	<!--------------------- GETTERS/SETTERS ------------------------->
		
	<cffunction name="getPaymentProcessorRegistry" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["PaymentProcessorRegistry"]/>    
    </cffunction>    
    <cffunction name="setPaymentProcessorRegistry" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["PaymentProcessorRegistry"] = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getPaymentService" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["PaymentService"]/>    
    </cffunction>    
    <cffunction name="setPaymentService" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["PaymentService"] = arguments.theVar />    
    </cffunction>    
    
    <cffunction name="getChannelConfig" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["ChannelConfig"]/>    
    </cffunction>    
    <cffunction name="setChannelConfig" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["ChannelConfig"] = arguments.theVar />    
    </cffunction>
    
</cfcomponent>
