<cfcomponent output="false" displayname="Order">

	<cffunction name="init" access="public" returntype="cfc.view.Order" output="false">
		<!--- Remove this when this component is added to CS --->
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfset setChannelConfig( application.wirebox.getInstance("ChannelConfig") ) />
		<cfreturn this />
	</cffunction>

	<cffunction name="getOrderEmailView" access="public" returntype="string" output="false"
				hint="Accepts and Order object and returns an HTML view of the order with inline styles for emails">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfset var local = structNew() />
		<cfset local.order = arguments.order />
		<cfset local.billAddress = local.order.getBillAddress() />
		<cfset local.shipAddress = local.order.getShipAddress() />
		<cfset local.lines = local.order.getWirelessLines() />
		<cfset local.otherItems = local.order.getOtherItems() />
		<cfset local.hardGoodsCost = local.order.getSubTotal() />
		<cfset local.shippingCost = local.order.getShipCost() />
		<cfset local.taxCost = local.order.getTaxTotal() />
		<cfset local.deposit = application.model.order.getWirelessAccount().getDepositAmount() />
		<cfset local.arrPaymentDetails = local.order.getPayments() />
		<cfset local.carrierObj = application.wirebox.getInstance("Carrier") />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<div id="wrapper" width="100%">
					<table cellpadding="0" cellspacing="0" border="0" style="100%">
						<tr>
							<td style="vertical-align: top; padding-right: 10px;" valign="top">
								<div style="margin-bottom: 10px; font-size: 1.2em; border: 1px solid ##cccccc; padding: 10px; height: 200px;">
									<span style="font-weight: bold; margin-bottom: 5px; display: block;">
										Order Information
									</span>
									<table>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top; width: 120px;" valign="top">
												Order ID:
											</td>
											<td style="font-weight: bold; padding: 5px 5px 2px; vertical-align: top;" valign="top">
												#local.order.getOrderId()#
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top; width: 120px;" valign="top">
												Order Date:
											</td>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												#dateFormat(local.order.getOrderDate(), 'mm/dd/yyyy')#
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top; width: 120px;" valign="top">
												Shipment Method:
											</td>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												#local.order.getShipMethod().getDisplayName()#
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												Payment Method:
											</td>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												<cfif arrayLen(local.arrPaymentDetails)>
													#local.arrPaymentDetails[1].getPaymentMethod().getName()#
												<cfelse>
													No payment
												</cfif>
											</td>
										</tr>
									</table>
								</div>
							</td>
							<td style="vertical-align: top; padding-right: 10px;" valign="top">
								<div style="margin-bottom: 10px; font-size: 1.2em; border: 1px solid ##cccccc; padding: 10px; height: 200px;">
									<span style="font-weight: bold; margin-bottom: 5px; display: block;">
										Billing Address
									</span>
									<table>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												#local.billAddress.getFirstName()# #local.billAddress.getLastName()#<br />
												<cfif len(trim(local.billAddress.getCompany()))>
													#local.billAddress.getCompany()#<br />
												</cfif>
												#local.billAddress.getAddress1()#<br />
                                            	<cfif len(trim(local.billAddress.getAddress2()))>
													#local.billAddress.getAddress2()#<br />
												</cfif>
												<cfif len(trim(local.billAddress.getAddress3()))>
													#local.billAddress.getAddress3()#<br />
												</cfif>
												#local.billAddress.getCity()#, #local.billAddress.getState()# #local.billAddress.getZip()#
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												#local.billAddress.formatPhone(local.billAddress.getDaytimePhone())# (Day)
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												#local.billAddress.formatPhone(local.billAddress.getEveningPhone())# (Eve)
											</td>
										</tr>
									</table>
								</div>
							</td>
							<td style="padding-right: 0px; vertical-align: top;" valign="top">
								<div style="margin-bottom: 10px; font-size: 1.2em; border: 1px solid ##cccccc; padding: 10px; height: 200px;">
									<span style="font-weight: bold; margin-bottom: 5px; display: block;">
										Shipping Address
									</span>
									<table>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												#local.shipAddress.getFirstName()# #local.shipAddress.getLastName()#<br />
												<cfif len(trim(local.shipAddress.getCompany()))>
													#local.shipAddress.getCompany()#<br />
												</cfif>
												#local.shipAddress.getAddress1()#<br />
												<cfif len(trim(local.shipAddress.getAddress2()))>
													#local.shipAddress.getAddress2()#<br />
												</cfif>
												<cfif len(trim(local.shipAddress.getAddress3()))>
													#local.shipAddress.getAddress3()#<br />
												</cfif>
												#local.shipAddress.getCity()#, #local.shipAddress.getState()# #local.shipAddress.getZip()#
											</td>
										</tr>
										<tr style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
											<td>#local.shipAddress.formatPhone(local.shipAddress.getDaytimePhone())# (Day)</td>
										</tr>
										<tr style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
											<td>#local.shipAddress.formatPhone(local.shipAddress.getEveningPhone())# (Eve)</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
					<div style="margin-bottom: 10px; font-size: 1.2em;">
						<span style="font-weight: bold; margin-bottom: 5px; display: block;">
							Order Details
						</span>

						<cfset local.dueTodayGrandTotal = 0 />
						<cfset local.estFirstBillGrandTotal = 0 />
						<cfset local.estMonthlyGrandTotal = 0 />
						<cfset local.totalTax = 0 />
						<cfset local.totalDiscount  = local.order.getOrderDiscountTotal() />
						<cfset local.totalDeposit = 0 />

						<cfif arrayLen(local.lines)>
							<cfloop from="1" to="#arrayLen(local.lines)#" index="local.iLine">
								<cfset local.dueTodayTotal = 0 />
								<cfset local.estFirstBillTotal = 0 />
								<cfset local.estMonthlyTotal = 0 />
								<cfset local.line = local.lines[local.iLine] />
								<cfset LineContainsKeepExistingService = false />

								<table cellpadding="2"cellspacing="0" border="0" width="100%"
										style="border-left-color: ##cccccc; border-left-style: solid; border-left-width: 1px; margin-bottom: 10px;">
									<tr class="sectionHeader lineHeader">
										<td width="59%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-bottom-width: 1px;
											border-bottom-style: solid; padding: 5px 5px 2px; border-bottom-color: ##cccccc; border-top-width: 1px; border-top-style: solid;
											vertical-align: top;"
											bgcolor="##EEEEEE" valign="top">
												Line #local.iLine#
										</td>
										<td width="15%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##DCDFF8 !important; border-bottom-width: 1px;
											border-bottom-style: solid; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; border-bottom-color: ##cccccc;
											border-top-width: 1px; border-top-style: solid; vertical-align: top; height: 10px; border-left-color: ##cccccc;"
											bgcolor="##DCDFF8 !important" valign="top">
											Due Today
										</td>
										<td width="13%"  style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; padding: 5px 5px 2px;
											border-left-width: 1px; border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid;
											border-top-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;"
											bgcolor="##EEEEEE" valign="top">
											Estimated<br />First Bill
										</td>
										<td width="13%" style="font-weight: bold; background-color: ##EEEEEE; border: 1px solid ##cccccc; padding: 5px 5px 2px; vertical-align: top;"
											bgcolor="##EEEEEE" valign="top">
											Estimated<br />Monthly
										</td>
									</tr>
									<tr>
										<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
											<span class="label">Device</span>
										</td>
										<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top;
											height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
											&nbsp;
										</td>
										<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
											valign="top">
											&nbsp;
										</td>
										<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
											vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
											&nbsp;
										</td>
									</tr>
									<tr>
										<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
														&nbsp;
													</td>
													<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
														#local.line.getLineDevice().getProductTitle()#
														<cfif local.line.getLineDevice().getRebate() gt 0>
															<br />
															<span style="color:##FF0000">Device qualified for special promotion which converted mail-in rebate to instant online savings.</span>
														</cfif>
														
													</td>
												</tr>
											</table>
										</td>

										<cfset local.dueTodayTotal = (local.dueTodayTotal + local.line.getLineDevice().getNetPrice()) />
										<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

										<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
											vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
											#dollarFormat(local.line.getLineDevice().getNetPrice() + local.line.getLineDevice().getRebate())#
											<cfif local.line.getLineDevice().getRebate() gt 0>
												<br />
												<span style="color:##FF0000">-#dollarFormat(local.line.getLineDevice().getRebate())#</span>
											</cfif>
										</td>
										<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
											valign="top">
											&nbsp;
										</td>
										<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
											vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
											&nbsp;
										</td>
									</tr>

									<cfif len(local.line.getLineRateplan().getProductTitle()) gt 0>
										<tr class="sectionHeader">
											<td style="font-weight: bold; border-bottom-width: 1px; border-bottom-style: solid; padding: 2px 2px 2px; border-bottom-color: ##cccccc;
												vertical-align: top;" valign="top">
												&nbsp;
											</td>
											<td style="font-weight: bold; background-color: ##DCDFF8 !important; padding: 2px 2px 2px; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc; height: 10px;
												vertical-align: top; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="font-weight: bold; padding: 2px 2px 2px; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
												border-bottom-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
											<td style="padding: 2px 2px 2px; font-weight: bold; border-right-width: 1px; border-right-style: solid; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												Plan
											</td>
											<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
												valign="top">
												&nbsp;
											</td>
											<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										 </tr>
										 <tr>
										 	<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
										 		<table cellpadding="0" cellspacing="0">
										 			<tr>
										 				<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
											 				&nbsp;
														</td>
										 				<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
											 				#local.line.getLineRateplan().getProductTitle()#
														</td>
										 			</tr>
										 		</table>
										 	</td>
										 	<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
										 		vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
											 	&nbsp;
											</td>

										 	<cfif local.order.getCarrierId() neq 42>
										 		<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.line.getMonthlyFee()) />
										 	<cfelse>
										 		<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
										 	</cfif>

										 	<cfset local.estMonthlyTotal = (local.estMonthlyTotal + local.line.getMonthlyFee()) />
										 	<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

										 	<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
										 		valign="top">
										 		<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										 			N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										 		<cfelseif local.order.getCarrierId() eq 42>
										 			N/A
										 		<cfelse>
										 			#dollarFormat(local.line.getMonthlyFee())#
										 		</cfif>
										 	</td>
										 	<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
										 		vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
										 		<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										 			N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										 		<cfelseif local.order.getCarrierId() eq 42>
										 			N/A
										 		<cfelse>
										 			#dollarFormat(local.line.getMonthlyFee())#
										 		</cfif>
										 	</td>
										 </tr>
									</cfif>
									<cfif local.order.getActivationTypeName() is not 'Upgrade' and local.order.getActivationTypeName() is not 'Exchange'>
										<cfif ListFind(getChannelConfig().getActivationFeeWavedByCarrier(),local.Order.getCarrierId())>
											<tr class="sectionHeader">
												<td style="font-weight: bold; border-bottom-width: 1px; border-bottom-style: solid; padding: 5px 5px 2px; border-bottom-color: ##cccccc;
													vertical-align: top;" valign="top">
													&nbsp;
												</td>
												<td style="font-weight: bold; background-color: ##DCDFF8 !important; padding: 5px 5px 2px; border-left-width: 1px;
													border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc; height: 10px;
													vertical-align: top; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
													&nbsp;
												</td>
												<td style="font-weight: bold; padding: 5px 5px 2px; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
													border-bottom-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">
													&nbsp;
												</td>
												<td class="totalRow borderright" style="padding: 5px 5px 2px; font-weight: bold; border-right-width: 1px; border-right-style: solid;
													border-left-width: 1px; border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px;
													border-bottom-color: ##cccccc; vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
													&nbsp;
												</td>
											</tr>
											<tr>
												<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
													Activation Fee
												</td>
												<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
													vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
													&nbsp;
												</td>
												<td  style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
													valign="top">
													&nbsp;
												</td>
												<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
													vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
													&nbsp;
												</td>
											</tr>
											<tr>
												<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
													<table cellpadding="0" cellspacing="0">
														<tr>
															<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">&nbsp;</td>
															<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
																<span class="activationFeeExplanation">(To be refunded by <cfif local.Order.getCarrierId() eq 42>Wireless Advocates, LLC<cfelse>your carrier</cfif> - see details below <sup><a href="##footnote4">4</a></sup>)</span>
															</td>
														</tr>
													</table>
												</td>
												<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
													vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
													&nbsp;
												</td>
												<cfif local.order.getCarrierId() neq 42>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.line.getActivationFee()) />
												<cfelse>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
												</cfif>
												<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
													valign="top">
													<a href="http://#cgi.server_name#/index.cfm/go/cart/do/explainActivationFee/carrierId/#local.order.getCarrierId()#"
														class="activationFeeExplanation" target="_blank">
															#dollarFormat(local.line.getActivationFee())#
													</a>
												</td>
												<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
													vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
													&nbsp;
												</td>
											</tr>
										</cfif>
									</cfif>

									<cfset local.services = local.line.getLineServices() />

									<cfif arrayLen(local.services)>
										<tr class="sectionHeader">
											<td style="font-weight: bold; border-bottom-width: 1px; border-bottom-style: solid; padding: 5px 5px 2px; border-bottom-color: ##cccccc;
												vertical-align: top;" valign="top">
												&nbsp;
											</td>
											<td style="font-weight: bold; background-color: ##DCDFF8 !important; padding: 5px 5px 2px; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc; height: 10px;
												vertical-align: top; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="font-weight: bold; padding: 5px 5px 2px; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
												border-bottom-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
											<td style="padding: 5px 5px 2px; font-weight: bold; border-right-width: 1px; border-right-style: solid; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">Services</td>
											<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
												valign="top">
												&nbsp;
											</td>
											<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										</tr>
										<cfloop from="1" to="#arrayLen(local.services)#" index="local.iService">
											<cfset local.service = local.services[local.iService] />
											<tr>
												<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
													<table cellpadding="0" cellspacing="0">
														<tr>
															<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
																&nbsp;
															</td>
															<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
																#local.service.getProductTitle()#
															</td>
														</tr>
													</table>
												</td>
												<cfif local.order.getCarrierId() neq 42>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.service.getEstimatedMonthly()) />
												<cfelse>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
												</cfif>

												<cfset local.estMonthlyTotal = (local.estMonthlyTotal + local.service.getEstimatedMonthly()) />
												<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

												<td class="totalRow today" style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px;
													padding: 5px 5px 2px; vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important"
													valign="top">
													&nbsp;
												</td>
												<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top;
													border-left-color: ##cccccc;" valign="top">
													<cfif local.order.getCarrierId() eq 42>
														N/A
													<cfelse>
														#dollarFormat(local.service.getEstimatedMonthly())#
													</cfif>
												</td>
												<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px;
													padding: 5px 5px 2px; vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
														#dollarFormat(local.service.getEstimatedMonthly())#
												</td>
											</tr>
										</cfloop>
									</cfif>

									<cfset local.accessories = local.line.getLineAccessories() />

									<cfif arrayLen(local.accessories)>
										<tr class="sectionHeader">
											<td style="font-weight: bold; border-bottom-width: 1px; border-bottom-style: solid; padding: 5px 5px 2px;
												border-bottom-color: ##cccccc; vertical-align: top;" valign="top">
												&nbsp;
											</td>
											<td style="font-weight: bold; background-color: ##DCDFF8 !important; padding: 5px 5px 2px; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;
												height: 10px; vertical-align: top; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="font-weight: bold; padding: 5px 5px 2px; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
												border-bottom-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
											<td style="padding: 5px 5px 2px; font-weight: bold; border-right-width: 1px; border-right-style: solid; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">Accessories</td>
											<td style="font-weight: bold; background-color: ##DCDFF8 !important; padding: 5px 5px 2px; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc; height: 10px;
												vertical-align: top; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="font-weight: bold; padding: 5px 5px 2px; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
												border-bottom-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
											<td style="padding: 5px 5px 2px; font-weight: bold; border-right-width: 1px; border-right-style: solid; border-left-width: 1px;
												border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										</tr>

										<cfloop from="1" to="#arrayLen(local.accessories)#" index="local.iAccessory">
											<cfset local.accessory = local.accessories[local.iAccessory] />
											<tr>
												<td style="font-weight: bold; border-bottom-width: 1px; border-bottom-style: solid; padding: 5px 5px 2px;
													border-bottom-color: ##cccccc; vertical-align: top;" valign="top">
													<table cellpadding="0" cellspacing="0">
														<tr>
															<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
																&nbsp;
															</td>
															<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
																#local.accessory.getProductTitle()#
															</td>
														</tr>
													</table>
												</td>

												<cfset local.dueTodayTotal = (local.dueTodayTotal + local.accessory.getNetPrice()) />
												<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

												<td style="font-weight: bold; background-color: ##DCDFF8 !important; padding: 5px 5px 2px; border-left-width: 1px;
													border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;
													height: 10px; vertical-align: top; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
													#dollarFormat(local.accessory.getNetPrice())#
												</td>
												<td style="font-weight: bold; padding: 5px 5px 2px; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
													border-bottom-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">
													&nbsp;
												</td>
												<td style="padding: 5px 5px 2px; font-weight: bold; border-right-width: 1px; border-right-style: solid; border-left-width: 1px;
													border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;
													vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
													&nbsp;
												</td>
											</tr>
										</cfloop>
									</cfif>

									<cfif local.line.getLineWarranty().getProductId() neq 0>
										<tr class="sectionHeader">
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
												&nbsp;
											</td>
											<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
												valign="top">
												&nbsp;
											</td>
											<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										</tr>
										<tr>
											<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">Protection Plan</td>
											<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
												&nbsp;
											</td>
											<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
												valign="top">
												&nbsp;
											</td>
											<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
												vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
												&nbsp;
											</td>
										</tr>
										<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
														&nbsp;
													</td>
													<td style="padding: 5px 5px 2px; vertical-align: top;" valign="top">
														#local.line.getLineWarranty().getProductTitle()# <sup>&Dagger;</sup>
													</td>
												</tr>
											</table>
										</td>

										<cfset local.dueTodayTotal = (local.dueTodayTotal + local.line.getLineWarranty().getNetPrice()) />
										<cfset local.totalTax = (local.totalTax + local.line.getLineWarranty().getTaxes()) />

										<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
											vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
											#dollarFormat(local.line.getLineWarranty().getNetPrice())#
										</td>
										<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
											valign="top">
											&nbsp;
										</td>
										<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
											vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
											&nbsp;
										</td>
									</cfif>

									<tr>
										<cfset local.dueTodayGrandTotal = (local.dueTodayGrandTotal + local.dueTodayTotal) />

										<cfif local.order.getCarrierId() neq 42>
											<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + local.estFirstBillTotal) />
										<cfelse>
											<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + 0) />
										</cfif>

										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + local.estMonthlyTotal) />

										<td style="font-weight: bold;border-top-color: ##CCCCCC; border-bottom-style: solid; border-bottom-width: 1px; padding: 5px 5px 2px; border-top-width: 1px;
											border-top-style: solid; border-bottom-color: ##cccccc; text-align: right !important; vertical-align: top;" valign="top"
											align="right !important">
											Line #local.iLine# Total
										</td>
										<td style="font-weight: bold !important; border-top-color: ##CCCCCC; background-color: ##DCDFF8 !important; border-bottom-style: solid;
											border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; border-bottom-color: ##cccccc;
											border-top-style: solid; border-top-width: 1px; vertical-align: top; height: 10px; border-left-color: ##cccccc;"
											bgcolor="##DCDFF8 !important" valign="top">
											#dollarFormat(local.dueTodayTotal)#
										</td>
										<td style="border-top-color: ##CCCCCC; border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid;
											border-left-width: 1px; padding: 5px 5px 2px; border-bottom-color: ##cccccc; border-top-style: solid; border-top-width: 1px;
											vertical-align: top; border-left-color: ##cccccc;" valign="top">
											<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
												N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
											<cfelseif local.order.getActivationType() is 'U' && LineContainsKeepExistingService>
												N/A
											<cfelseif local.order.getCarrierId() eq 42>
												N/A
											<cfelse>
												#dollarFormat(local.estFirstBillTotal)#
											</cfif>
										</td>
										<td style="border: 1px solid ##cccccc; padding: 5px 5px 2px; vertical-align: top;" valign="top">
											<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
												N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
											<cfelseif local.order.getActivationType() is 'U' && LineContainsKeepExistingService>
												N/A
											<cfelseif local.order.getCarrierId() eq 42>
												N/A
											<cfelse>
												#dollarFormat(local.estMonthlyTotal)#
											</cfif>
										</td>
									</tr>
								</table>
							</cfloop>
						</cfif>

						<cfif arrayLen(local.otherItems)>
							<cfset local.otherItemsTodayTotal = 0 />
							<cfset local.otherItemsFirstTotal = 0 />
							<cfset local.otherItemsMonthlyTotal = 0 />

							<table cellpadding="2" style="border-left-color: ##cccccc; border-left-style: solid; border-left-width: 1px; margin-bottom: 10px;" cellspacing="0"
									border="0" width="100%">
								<tr class="sectionHeader lineHeader">
									<td class="item" width="59%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-bottom-style: solid;
										border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; border-bottom-color: ##cccccc;" bgcolor="##EEEEEE">
										Additional Items
									</td>
									<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top;
										height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top" width="15%">
										Due Today
									</td>
									<td class="totalRow" width="13%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-left-width: 1px;
										border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;
										border-bottom-color: ##cccccc; border-left-color: ##cccccc;" bgcolor="##EEEEEE">
										Estimated<br />First Bill
									</td>
									<td class="totalRow borderright" width="13%" style="font-weight: bold; background-color: ##EEEEEE; border: 1px solid ##cccccc;"
										bgcolor="##EEEEEE">
										Estimated<br />Monthly</td>
								</tr>
								<tr>
									<td class="producttitle">Accessories</td>
									<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top;
										height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important" valign="top">
										&nbsp;
									</td>
									<td style="border-left-style: solid; border-left-width: 1px; border-left-color: ##cccccc;">
										&nbsp;
									</td>
									<td  style="border-right-width: 1px; border-right-style: solid; border-left-width: 1px; border-left-style: solid; border-right-color: ##cccccc;
										border-left-color: ##cccccc;">
										&nbsp;
									</td>
								</tr>
								<cfloop from="1" to="#arrayLen(local.otherItems)#" index="local.iAccessory">
									<cfset local.accessory = local.otherItems[local.iAccessory] />
									<tr>
										<td class="item">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<td>&nbsp;</td>
													<td>#local.accessory.getProductTitle()#</td>
												</tr>
											</table>
										</td>

										<cfset local.otherItemsTodayTotal = (local.otherItemsTodayTotal + local.accessory.getNetPrice()) />

										<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
											vertical-align: top; height: 10px; border-left-color: ##ccc;" bgcolor="##DCDFF8 !important" valign="top">
											#dollarFormat(local.accessory.getNetPrice())#
										</td>
										<td style="border-left-style: solid; border-left-width: 1px; border-left-color: ##cccccc;">&nbsp;</td>
										<td style="border-right-width: 1px; border-right-style: solid; border-left-width: 1px; border-left-style: solid;
											border-right-color: ##cccccc; border-left-color: ##cccccc;">
											&nbsp;
										</td>
									</tr>
								</cfloop>
								<tr class="sectionHeader">
									<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + local.otherItemsFirstTotal) />

									<cfif local.order.getCarrierId() neq 42>
										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + local.otherItemsMonthlyTotal) />
									<cfelse>
										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + 0) />
									</cfif>

									<cfset local.dueTodayGrandTotal = (local.dueTodayGrandTotal + local.otherItemsTodayTotal) />

									<td style="font-weight: bold; border-top-color: ##CCCCCC; border-bottom-style: solid; border-bottom-width: 1px; border-top-width: 1px;
										border-top-style: solid; border-bottom-color: ##cccccc; text-align: right !important;" align="right !important">
										Additional Items Total
									</td>
									<td style="font-weight: bold; border-top-color: ##CCCCCC; background-color: ##DCDFF8 !important; border-left-width: 1px;
										border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-width: 1px; border-top-style: solid;
										border-bottom-color: ##cccccc; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important">
										#dollarFormat(local.otherItemsTodayTotal)#
									</td>
									<td style="font-weight: bold; border-top-color: ##CCCCCC; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
										border-bottom-width: 1px; border-top-width: 1px; border-top-style: solid; border-bottom-color: ##cccccc; border-left-color: ##cccccc;">
										<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
											N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										<cfelseif local.order.getCarrierId() eq 42>
											N/A
										<cfelse>
											#dollarFormat(local.otherItemsFirstTotal)#
										</cfif>
									</td>
									<td style="font-weight: bold; border-top-color: ##CCC; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
										border-bottom-width: 1px; border-top-width: 1px; border-top-style: solid; border-bottom-color: ##cccccc; border-left-color: ##cccccc;">
										<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
											N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										<cfelseif local.order.getCarrierId() eq 42>
											N/A
										<cfelse>
											#dollarFormat(local.otherItemsMonthlyTotal)#
										</cfif>
									</td>
								</tr>
							</table>
						</cfif>
						<table cellpadding="2" class="local.orders checkout" cellspacing="0" border="0" width="100%">
							<colgroup />
							<colgroup class="fee today" style="height: 10px; background-color: ##DCDFF8 !important;" />
							<colgroup class="fee" />
							<colgroup class="fee" />

							<tr class="sectionHeader lineHeader">
								<td width="59%"  style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-bottom-width: 1px;
									border-bottom-style: solid; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; border-bottom-color: ##cccccc;
									border-top-width: 1px; border-top-style: solid; vertical-align: top; text-align: left !important; border-left-color: ##cccccc;"
									bgcolor="##EEEEEE" valign="top" align="left !important">
									Checkout
								</td>
								<td width="15%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##DCDFF8 !important; border-bottom-width: 1px;
									border-bottom-style: solid; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; border-bottom-color: ##cccccc;
									border-top-width: 1px; border-top-style: solid; vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8 !important"
									valign="top">
									Due Today
								</td>
								<td width="13%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; padding: 5px 5px 2px; border-left-width: 1px;
									border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;
									border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" bgcolor="##EEEEEE" valign="top">
									Estimated<br />First Bill
								</td>
								<td width="13%" style="font-weight: bold; background-color: ##EEEEEE; border: 1px solid ##cccccc; padding: 5px 5px 2px; vertical-align: top;"
									bgcolor="##EEEEEE" valign="top">
									Estimated<br />Monthly
								</td>
							</tr>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; text-align: right !important; vertical-align: top;
									border-left-color: ##cccccc;" valign="top" align="right !important">
									Sub-total
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									#dollarFormat(local.dueTodayGrandTotal)#
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
									<cfelseif local.order.getCarrierId() eq 42>
										N/A
									<cfelse>
										#dollarFormat(local.estFirstBillGrandTotal)#
									</cfif>
								</td>
								<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
									<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
									<cfelseif local.order.getCarrierId() eq 42>
										N/A
									<cfelse>
										#dollarFormat(local.estMonthlyGrandTotal)#
									</cfif>
								</td>
							</tr>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; text-align: right !important; vertical-align: top;
									border-left-color: ##ccc;" valign="top" align="right !important">
									Discount Total
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##ccc;" valign="top">
									<cfif local.order.getOrderDiscountTotal()>
										<span style="color:##FF0000">-#dollarFormat(local.order.getOrderDiscountTotal())#</span>
									<cfelse>
										N/A
									</cfif>
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
								<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
							</tr>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; text-align: right !important; vertical-align: top;
									border-left-color: ##cccccc;" valign="top" align="right !important">
									Taxes and fees
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									#dollarFormat(local.taxCost)#
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
								<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
							</tr>
							<cfif local.deposit gt 0>
								<tr>
									<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; text-align: right !important; vertical-align: top;
										border-left-color: ##cccccc;" valign="top" align="right !important">
											Deposit
									</td>
									<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
										valign="top">
											#dollarFormat(local.totalDeposit)#
									</td>
									<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;"
										valign="top">
											&nbsp;
									</td>
									<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
										vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
											&nbsp;
									</td>
								</tr>
							</cfif>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; text-align: right !important; vertical-align: top;
									border-left-color: ##ccc;" valign="top" align="right !important">
										#local.order.getShipMethod().getDisplayName()#
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									#dollarFormat(local.shippingCost)#
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
								<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
										&nbsp;
								</td>
							</tr>
							<tr>
								<td style="border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									border-bottom-color: ##cccccc; vertical-align: top; text-align: right !important; border-left-color: ##cccccc;" valign="top"
									align="right !important">
									<strong>Total</strong>
								</td>
								<td style="background-color: ##069; padding: 5px 5px 2px; color: ##FFFFFF; border-left-width: 1px; border-left-style: solid;
									border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;"
									bgcolor="##069" valign="top">
									#dollarFormat(((local.dueTodayGrandTotal - local.totalDiscount) + local.taxCost) + local.shippingCost)#
								</td>
								<td style="border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">&nbsp;</td>
								<td style="padding: 5px 5px 2px; border-right-width: 1px; border-right-style: solid; border-left-width: 1px; border-left-style: solid;
									border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##cccccc; vertical-align: top; border-right-color: ##cccccc;
									border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
							</tr>
						</table>
						<br /><br />
						<span style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
							<cfif local.order.getActivationType() eq 'U'>
								<cfif local.order.getActivationTypeName() is not 'Exchange'>
									* An Upgrade Fee of #local.carrierObj.getUpgradeFee(local.order.getCarrierId())# applies to each Upgrade Line.
									<cfif local.order.getCarrierId() neq 299>This fee will appear on your next billing statement<cfif local.order.getCarrierId() eq 299> and will be refunded to your account within three billing cycles</cfif>.</cfif><br />
								</cfif>
							</cfif>
							<cfif local.order.containsWarranty()>
								<cfset local.providerName = local.order.getWarrantyProvider() />
								<cfif local.providerName eq 'SquareTrade'>
									<sup>&Dagger;</sup> You will receive a separate email (within 3 business days) from SquareTrade with instructions to activate your device protection purchase.<br />
								<cfelseif local.providerName eq 'ServicePak'>
									<sup>&Dagger;</sup> You will receive the ServicePak Terms & Conditions via mail at the shipping address provided.<br />
								<cfelse>
									<sup>&Dagger;</sup> Reference warranty Terms & Conditions<br />
								</cfif>
							</cfif>
							<!---todo: --->
							<cfif ListFind(getChannelConfig().getActivationFeeWavedByCarrier(),local.Order.getCarrierId())>
								<cfif local.order.getActivationTypeName() neq 'Exchange' && local.order.getActivationType() neq 'U' && local.order.getActivationType() neq 'R'>
									<cfif local.order.getCarrierId() eq 109>
										AT&amp;T activation fees will be refunded through a Bill Credit on all qualifying activations.
									<cfelseif local.order.getCarrierId() eq 128>
										T-Mobile activation fees will be refunded through a Bill Credit on all qualifying activations.
									<cfelseif local.order.getCarrierId() eq 42>
										Customers will receive a mail-in rebate from Wireless Advocates to reimburse the activation fee
										on a new single line and/or Family Share 2-year Verizon service agreement. Upgrades do not qualify for this credit
									<cfelseif local.order.getCarrierId() eq 299>
										Sprint activation fees will be refunded through a Bill Credit on all qualifying activations.
									</cfif>
									Please <a href="http://#request.config.emailTemplateDomain#/index.cfm/go/cart/do/explainActivationFee/carrierId/#local.order.getCarrierId()#" target="_blank">click here</a> for details.
								</cfif>
							</cfif>
						</span>
						<br />
						<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
							<span style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
								<sup class="cartReview"><a name="footnote5">6</a></sup> First bill and estimated monthly charges for your new line(s) will be provided by your carrier.
							</span>
							<br />
						</cfif>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>


	<cffunction name="getOrderEmailView_costco" access="public" returntype="string" output="false"
				hint="Accepts and Order object and returns an HTML view of the order with inline styles for emails">
		<cfargument name="order" type="cfc.model.Order" required="true" />

		<cfset var local = structNew() />
		<cfset local.order = arguments.order />
		<cfset local.billAddress = local.order.getBillAddress() />
		<cfset local.shipAddress = local.order.getShipAddress() />
		<cfset local.lines = local.order.getWirelessLines() />
		<cfset local.otherItems = local.order.getOtherItems() />
		<cfset local.hardGoodsCost = local.order.getSubTotal() />
		<cfset local.shippingCost = local.order.getShipCost() />
		<cfset local.taxCost = local.order.getTaxTotal() />
		<cfset local.deposit = application.model.order.getWirelessAccount().getDepositAmount() />
		<cfset local.arrPaymentDetails = local.order.getPayments() />
		<cfset local.carrierObj = application.wirebox.getInstance("Carrier") />
		
		<cfset local.top = "border-top-style: solid; border-top-width: 1px; border-top-color: ##cccccc;" />
		<cfset local.bottom = "border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: ##cccccc;" />
		<cfset local.left  = "border-left-style: solid; border-left-width: 1px; border-left-color: ##cccccc;" />
		<cfset local.right  = "border-right-style: solid; border-right-width: 1px; border-right-color: ##cccccc;" />
		

		<cfsavecontent variable="local.html">
			<cfoutput>
				<div id="wrapper" width="100%">
					

						<cfset local.dueTodayGrandTotal = 0 />
						<cfset local.estFirstBillGrandTotal = 0 />
						<cfset local.estMonthlyGrandTotal = 0 />
						<cfset local.totalTax = 0 />
						<cfset local.totalDiscount  = local.order.getOrderDiscountTotal() />
						<cfset local.totalDeposit = 0 />

						<cfif arrayLen(local.lines)>
							<cfloop from="1" to="#arrayLen(local.lines)#" index="local.iLine">
								<cfset local.dueTodayTotal = 0 />
								<cfset local.estFirstBillTotal = 0 />
								<cfset local.estMonthlyTotal = 0 />
								<cfset local.line = local.lines[local.iLine] />
								<cfset LineContainsKeepExistingService = false />
								
								<cfset local.orderDetailID = local.line.getLineDevice().getOrderDetailId() />
								<cfset local.orderDetail = CreateObject('component', 'cfc.model.OrderDetail').init() /> 
								<cfset local.orderDetail.load(local.orderDetailID) />
								
								<cfset local.productDetail = CreateObject('component', 'cfc.model.Product').init() /> 
								<cfset local.productDetail.getProduct(productId=local.orderDetail.getProductID()) /> 
								
								<table cellpadding="2" cellspacing="0" border="0" width="800" class="tblData"
										style="border-collapse: collapse; border-left-color: ##cccccc; border-left-style: solid; border-left-width: 1px; margin-bottom: 10px;">
											
									<cfif local.iline is 1>			
										<tr><td colspan="4" class="tblHead">Your Order</td></tr>
									<cfelse>
										<tr><td colspan="4" class="tblHead" style="height:4px;">&nbsp;</td></tr>		
									</cfif>	
									<tr class="tblLabel">
										<td width="59%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-bottom-width: 1px;
											border-bottom-style: solid;  border-bottom-color: ##cccccc; border-top-width: 1px; border-top-style: solid;
											vertical-align: top;"
											bgcolor="##EEEEEE" valign="top">
												Line #local.iLine#
										</td>
										<td width="15%" style=" text-align:right;font-weight: bold; border-top-color: ##cccccc; background-color: ##DCDFF8 !important; border-bottom-width: 1px;
											border-bottom-style: solid; border-left-style: solid; border-left-width: 1px; border-bottom-color: ##cccccc;
											border-top-width: 1px; border-top-style: solid; vertical-align: top; height: 10px; border-left-color: ##cccccc;"
											bgcolor="##DCDFF8" valign="top">
											Due<br/>Today
										</td>
										<td width="13%"  style=" text-align:right;font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; 
											border-left-width: 1px; border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid;
											border-top-width: 1px; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;"
											bgcolor="##EEEEEE" valign="top">
											Estimated<br />First Bill
										</td>
										<td width="13%" style=" text-align:right;font-weight: bold; background-color: ##EEEEEE; border: 1px solid ##cccccc; vertical-align: top;"
											bgcolor="##EEEEEE" valign="top">
											Estimated<br />Monthly
										</td>
									</tr>
									
									
									<!---
										Device Info Row										
									 --->
									<tr>
										<td style="#local.left# #local.top# #local.right#" valign="top">
											<span class="label"><strong>Device</strong></span>
										</td>
										<td style="font-weight: bold; #local.top# #local.right#"  bgcolor="##DCDFF8" valign="top">
											&nbsp;
										</td>
										<td style="#local.top# #local.right#" valign="top">
											&nbsp;
										</td>
										<td style="#local.top# #local.right#" valign="top">
											&nbsp;
										</td>
									</tr>
									<tr>
										<td style="#local.left# #local.right#" valign="top">
											<table cellpadding="0" cellspacing="0" class="tblData">
												<tr>
													<td style="padding: 2px 2px 2px; vertical-align: top;" valign="top">
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													</td>
													<td style="padding: 2px 2px 2px; vertical-align: top;" valign="top">
														#local.line.getLineDevice().getProductTitle()# : <cfif local.orderDetail.getPurchaseType() eq "C2">
																											Contract
																										<cfelse>
																											Financed
																										</cfif> #local.line.getContractLength()# months 
																										<cfif local.order.getActivationType() eq "N">
																											New
																										<cfelseif local.order.getActivationType() eq "U">
																											Upgrade
																										<cfelse>
																											AddALine
																										</cfif>
																										
														<cfif local.line.getLineDevice().getRebate() gt 0>
															<br />
															<span style="color:##FF0000">Device qualified for special promotion which converted mail-in rebate to instant online savings.</span>
														</cfif>
														
													</td>
												</tr>
											</table>
										</td>

										<cfset local.dueTodayTotal = (local.dueTodayTotal + local.line.getLineDevice().getNetPrice() + local.line.getLineDevice().getDownPaymentReceived()) />
										<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

										<td style="font-weight: bold; text-align:right; #local.right#"  valign="top" bgcolor="##DCDFF8" >
											<cfif local.orderDetail.getPurchaseType() eq "C2">
												#dollarFormat(local.line.getLineDevice().getNetPrice() + local.line.getLineDevice().getRebate())#
												<cfif local.line.getLineDevice().getRebate() gt 0>
													<br />
													<span style="color:##FF0000">-#dollarFormat(local.line.getLineDevice().getRebate())#</span>
												</cfif>
											<cfelse> <!--- Financed phones are nothing due today unless it is a downpayment--->
												<cfif local.line.getLineDevice().getDownPaymentReceived() gt 0>#dollarFormat(local.line.getLineDevice().getDownPaymentReceived())#<cfelse>&nbsp;</cfif>
											</cfif>
										</td>
										<td style="#local.right# text-align:right;" valign="top">
											<cfif local.orderDetail.getPurchaseType() eq "FP">
												<cfif local.line.getContractLength() eq "12">
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice12())#
													<cfset local.estFirstBillTotal = local.estFirstBillTotal + local.productDetail.getFinancedMonthlyPrice12()/>												
												<cfelseif local.line.getContractLength() eq "18">
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice18())#
													<cfset local.estFirstBillTotal = local.estFirstBillTotal + local.productDetail.getFinancedMonthlyPrice18()/>												
												<cfelseif local.line.getContractLength() eq "24" >
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice24())#
													<cfset local.estFirstBillTotal = local.estFirstBillTotal + local.productDetail.getFinancedMonthlyPrice24()/>												
												<cfelse>
													&nbsp;
												</cfif>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td style="#local.right# text-align:right;" valign="top">
											<cfif local.orderDetail.getPurchaseType() eq "FP">
												<cfif local.line.getContractLength() eq "12">
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice12())#
													<cfset local.estMonthlyTotal = local.estMonthlyTotal + local.productDetail.getFinancedMonthlyPrice12()/>
												<cfelseif local.line.getContractLength() eq "18">
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice18())#
													<cfset local.estMonthlyTotal = local.estMonthlyTotal + local.productDetail.getFinancedMonthlyPrice18()/>
												<cfelseif local.line.getContractLength() eq "24" >
													#dollarFormat(local.productDetail.getFinancedMonthlyPrice24())#
													<cfset local.estMonthlyTotal = local.estMonthlyTotal + local.productDetail.getFinancedMonthlyPrice24()/>
												<cfelse>
													&nbsp;
												</cfif>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
									</tr>

									<cfif len(local.line.getLineRateplan().getProductTitle()) gt 0>
										
									<!---
										Plan Info Row										
									 --->

										<tr>
											<td style="#local.left# #local.top# #local.right#" valign="top">
												<strong>Plan</strong>
											</td>
											<td style="#local.top# #local.right# background-color: ##DCDFF8 !important;" bgcolor="##DCDFF8" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
										 </tr>
										 <tr>
										 	<td style="#local.left# #local.right#" valign="top">
										 		<table cellpadding="0" cellspacing="0" class="tblData">
										 			<tr>
										 				<td style="padding: 2px 2px 2px; vertical-align: top;" valign="top">
											 				&nbsp;
														</td>
										 				<td style="padding: 2px 2px 2px; vertical-align: top;" valign="top">
											 				#local.line.getLineRateplan().getProductTitle()#
														</td>
										 			</tr>
										 		</table>
										 	</td>
										 	<td style="background-color: ##DCDFF8 !important; #local.right#" bgcolor="##DCDFF8" valign="top">
											 	&nbsp;
											</td>

										 	<cfif local.order.getCarrierId() neq 42>
										 		<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.line.getMonthlyFee()) />
										 	<cfelse>
										 		<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
										 	</cfif>

										 	<cfset local.estMonthlyTotal = (local.estMonthlyTotal + local.line.getMonthlyFee()) />
										 	<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

										 	<td style="#local.right# text-align:right;" valign="top">
										 		<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										 			N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										 		<cfelseif local.order.getCarrierId() eq 42>
										 			See Carrier Account
										 		<cfelse>
										 			#dollarFormat(local.line.getMonthlyFee())#
										 		</cfif>
										 	</td>
										 	<td style="#local.right# text-align:right;" valign="top">
										 		<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										 			N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										 		<cfelseif local.order.getCarrierId() eq 42>
										 			See Carrier Account
										 		<cfelse>
										 			#dollarFormat(local.line.getMonthlyFee())#
										 		</cfif>
										 	</td>
										 </tr>
									</cfif>
									<cfif local.order.getActivationTypeName() is not 'Upgrade' and local.order.getActivationTypeName() is not 'Exchange'>
										<cfif ListFind(getChannelConfig().getActivationFeeWavedByCarrier(),local.Order.getCarrierId())>
											<tr>
												<td style="#local.left# #local.top# #local.right#" valign="top">
													Activation Fee
												</td>
												<td style="background-color: ##DCDFF8 !important;#local.top# #local.right#" bgcolor="##DCDFF8" valign="top">
													&nbsp;
												</td>
												<td  style="#local.top# #local.right#" valign="top">
													&nbsp;
												</td>
												<td style="#local.top# #local.right#" valign="top">
													&nbsp;
												</td>
											</tr>
											<tr>
												<td style="#local.left# #local.right#" valign="top">
													<table cellpadding="0" cellspacing="0" class="tblData">
														<tr>
															<td style="vertical-align: top;" valign="top">&nbsp;</td>
															<td style="vertical-align: top;" valign="top">
																<span class="activationFeeExplanation">(To be refunded by <cfif local.Order.getCarrierId() eq 42>Wireless Advocates, LLC<cfelse>your carrier</cfif> - see details below <sup><a href="##footnote4">4</a></sup>)</span>
															</td>
														</tr>
													</table>
												</td>
												<td style="background-color: ##DCDFF8 !important;  #local.right#" valign="top" bgcolor="##DCDFF8">  
													&nbsp;
												</td>
												<cfif local.order.getCarrierId() neq 42>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.line.getActivationFee()) />
												<cfelse>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
												</cfif>
												<td style="#local.right# text-align:right;" valign="top" >
													<a href="http://#cgi.server_name#/index.cfm/go/cart/do/explainActivationFee/carrierId/#local.order.getCarrierId()#"
														class="activationFeeExplanation" target="_blank">
															#dollarFormat(local.line.getActivationFee())#
													</a>
												</td>
												<td style="#local.right# text-align:right;" valign="top" >
													&nbsp;
												</td>
											</tr>
										</cfif>
									</cfif>

									<cfset local.services = local.line.getLineServices() />

									<cfif arrayLen(local.services)>

									<!---
										Services Row										
									 --->
										
										<tr>
											<td style="#local.left# #local.top# #local.right#" valign="top"><strong>Services</strong></td>
											<td style="background-color: ##DCDFF8 !important; #local.top# #local.right#" bgcolor="##DCDFF8" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
										</tr>
										<cfloop from="1" to="#arrayLen(local.services)#" index="local.iService">
											<cfset local.service = local.services[local.iService] />
											<tr>
												<td style="#local.left# #local.right#" valign="top">
													<table cellpadding="0" cellspacing="0" class="tblData">
														<tr>
															<td style="vertical-align: top;" valign="top">
																&nbsp;
															</td>
															<td style="vertical-align: top;" valign="top">
																#local.service.getProductTitle()#
															</td>
														</tr>
													</table>
												</td>
												<cfif local.order.getCarrierId() neq 42>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.service.getEstimatedMonthly()) />
												<cfelse>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
												</cfif>

												<cfset local.estMonthlyTotal = (local.estMonthlyTotal + local.service.getEstimatedMonthly()) />
												<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

												<td class="totalRow today" style="background-color: ##DCDFF8 !important;  #local.right#" bgcolor="##DCDFF8"
													valign="top">
													&nbsp;
												</td>
												<td style="#local.right# text-align:right;" valign="top">
													<cfif local.order.getCarrierId() eq 42 <!---or local.service.getProductId() eq request.config.keepExistingService.productId--->>
														<!---<cfset LineContainsKeepExistingService = true />--->
														See Carrier Account 
													<cfelse>
														<cfif (local.orderDetail.getPurchaseType() eq "FP") AND (getChannelConfig().getVfdEnabled()) AND (len(local.service.getEstimatedFinancedMonthly()))>
															#dollarFormat(local.service.getEstimatedFinancedMonthly())#
														<cfelse>
															#dollarFormat(local.service.getEstimatedMonthly())# 
														</cfif>
													</cfif>
												</td>
												<td style="#local.right# text-align:right;" valign="top">
													<!--- <cfif local.service.getProductId() eq request.config.keepExistingService.productId>
														N/A
													<cfelse> --->
													<cfif (local.orderDetail.getPurchaseType() eq "FP") AND (getChannelConfig().getVfdEnabled()) AND (len(local.service.getEstimatedFinancedMonthly()))>
														#dollarFormat(local.service.getEstimatedFinancedMonthly())#
													<cfelse>
														#dollarFormat(local.service.getEstimatedMonthly())# 
													</cfif>
													<!--- </cfif> --->
												</td>
											</tr>
										</cfloop>
									</cfif>

									<cfset local.accessories = local.line.getLineAccessories() />

									<cfif arrayLen(local.accessories)>

									<!---
										Accessories Row										
									 --->
										<tr>
											<td  style="#local.left# #local.top# #local.right#" valign="top"><strong>Accessories</strong></td>
											<td style="font-weight: bold; background-color: ##DCDFF8 !important; #local.top# #local.right#" bgcolor="##DCDFF8" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
										</tr>

										<cfloop from="1" to="#arrayLen(local.accessories)#" index="local.iAccessory">
											<cfset local.accessory = local.accessories[local.iAccessory] />
											<tr>
												<td style="#local.left# #local.right#" valign="top">
													<table cellpadding="0" cellspacing="0" class="tblData">
														<tr>
															<td style="vertical-align: top;" valign="top">
																&nbsp;
															</td>
															<td style="vertical-align: top;" valign="top">
																#local.accessory.getProductTitle()#
															</td>
														</tr>
													</table>
												</td>

												<cfset local.dueTodayTotal = (local.dueTodayTotal + local.accessory.getNetPrice()) />
												<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

												<td style="text-align:right; font-weight: bold; background-color: ##DCDFF8 !important;  #local.right#" bgcolor="##DCDFF8" valign="top">
													#dollarFormat(local.accessory.getNetPrice())#
												</td>
												<td style="font-weight: bold; #local.right#" valign="top">
													&nbsp;
												</td>
												<td style="font-weight: bold;#local.right#" valign="top">
													&nbsp;
												</td>
											</tr>
										</cfloop>
									</cfif>

									<cfif local.line.getLineWarranty().getProductId() neq 0>

									<!---
										Protection Plan Row										
									 --->
										
										<tr>
											<td style="#local.left# #local.top# #local.right#" valign="top"><strong>Protection Plan</strong></td>
											<td style="background-color: ##DCDFF8 !important;  #local.top# #local.right#" bgcolor="##DCDFF8" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
											<td style="#local.top# #local.right#" valign="top">
												&nbsp;
											</td>
										</tr>
										<tr>
										<td style="#local.left# #local.right#" valign="top">
											<table cellpadding="0" cellspacing="0" class="tblData">
												<tr>
													<td style="vertical-align: top;" valign="top">
														&nbsp;
													</td>
													<td style="vertical-align: top;" valign="top">
														#local.line.getLineWarranty().getProductTitle()# <sup>&Dagger;</sup>
													</td>
												</tr>
											</table>
										</td>

										<cfset local.dueTodayTotal = (local.dueTodayTotal + local.line.getLineWarranty().getNetPrice()) />
										<cfset local.totalTax = (local.totalTax + local.line.getLineWarranty().getTaxes()) />

										<td style="font-weight:bold; text-align:right; background-color: ##DCDFF8 !important;#local.right#" bgcolor="##DCDFF8" valign="top">
											#dollarFormat(local.line.getLineWarranty().getNetPrice())#
										</td>
										<td style="#local.right#" valign="top">
											&nbsp;
										</td>
										<td style="#local.right#" valign="top">
											&nbsp;
										</td>
									</cfif>

									<tr>
										<cfset local.dueTodayGrandTotal = (local.dueTodayGrandTotal + local.dueTodayTotal) />

										<cfif local.order.getCarrierId() neq 42>
											<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + local.estFirstBillTotal) />
										<cfelse>
											<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + 0) />
										</cfif>

										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + local.estMonthlyTotal) />

										<td style="font-weight:bold; #local.left# #local.top# #local.right#" valign="top"
											align="left">
											Line #local.iLine# Total
										</td>
										<td style="text-align:right; font-weight: bold; background-color: ##DCDFF8; #local.top# #local.right#" bgcolor="##DCDFF8" valign="top">
											#dollarFormat(local.dueTodayTotal)#
										</td>
										<td style="#local.top# #local.right# text-align:right;" valign="top">
											<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
												N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
											<cfelseif local.order.getActivationType() is 'U' && LineContainsKeepExistingService>
												N/A
											<cfelseif local.order.getCarrierId() eq 42>
												See Carrier Account
											<cfelse>
												#dollarFormat(local.estFirstBillTotal)#
											</cfif>
										</td>
										<td style="#local.top# #local.right# text-align:right;" valign="top">
											<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
												N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
											<cfelseif local.order.getActivationType() is 'U' && LineContainsKeepExistingService>
												N/A
											<cfelseif local.order.getCarrierId() eq 42>
												See Carrier Account
											<cfelse>
												#dollarFormat(local.estMonthlyTotal)#
											</cfif>
										</td>
									</tr>
								</table>
							</cfloop>
						</cfif>

						<cfif arrayLen(local.otherItems)>
							<cfset local.otherItemsTodayTotal = 0 />
							<cfset local.otherItemsFirstTotal = 0 />
							<cfset local.otherItemsMonthlyTotal = 0 />

							<table cellspacing="0" border="0" width="800" class="tblData"
								style="border-left-color: ##cccccc; border-left-style: solid; border-left-width: 1px; margin-bottom: 5px;font-size: 75%; font-weight: normal;">
								<tr><td colspan="4" class="tblHead">Your Order</td></tr>
								<tr class="sectionHeader lineHeader">
									<td class="item" width="59%" style="font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-bottom-style: solid;
										border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px; border-bottom-color: ##cccccc;" bgcolor="##EEEEEE">
										Additional Items
									</td>
									<td style=" text-align:right;font-weight: bold; background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top;
										height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8" valign="top" width="15%">
										Due<br/>Today
									</td>
									<td class="totalRow" width="13%" style=" text-align:right;font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-left-width: 1px;
										border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;
										border-bottom-color: ##cccccc; border-left-color: ##cccccc;" bgcolor="##EEEEEE">
										Estimated<br />First Bill
									</td>
									<td class="totalRow borderright" width="13%" style=" text-align:right;font-weight: bold; background-color: ##EEEEEE; border: 1px solid ##cccccc;"
										bgcolor="##EEEEEE">
										Estimated<br />Monthly</td>
								</tr>
								<tr>
									<td class="producttitle"><strong>Accessories</strong></td>
									<td style="background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px; vertical-align: top;
										height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8" valign="top">
										&nbsp;
									</td>
									<td style="border-left-style: solid; border-left-width: 1px; border-left-color: ##cccccc;">
										&nbsp;
									</td>
									<td  style="border-right-width: 1px; border-right-style: solid; border-left-width: 1px; border-left-style: solid; border-right-color: ##cccccc;
										border-left-color: ##cccccc;">
										&nbsp;
									</td>
								</tr>
								<cfloop from="1" to="#arrayLen(local.otherItems)#" index="local.iAccessory">
									<cfset local.accessory = local.otherItems[local.iAccessory] />
									<tr>
										<td class="item">
											<table cellpadding="0" cellspacing="0" class="tblData">
												<tr>
													<td>&nbsp;</td>
													<td>#local.accessory.getProductTitle()#</td>
												</tr>
											</table>
										</td>

										<cfset local.otherItemsTodayTotal = (local.otherItemsTodayTotal + local.accessory.getNetPrice()) />

										<td style="text-align:right; background-color: ##DCDFF8 !important; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
											vertical-align: top; height: 10px; border-left-color: ##ccc;" bgcolor="##DCDFF8" valign="top">
											#dollarFormat(local.accessory.getNetPrice())#
										</td>
										<td style="border-left-style: solid; border-left-width: 1px; border-left-color: ##cccccc;">&nbsp;</td>
										<td style="border-right-width: 1px; border-right-style: solid; border-left-width: 1px; border-left-style: solid;
											border-right-color: ##cccccc; border-left-color: ##cccccc;">
											&nbsp;
										</td>
									</tr>
								</cfloop>
								<tr class="sectionHeader">
									<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + local.otherItemsFirstTotal) />

									<cfif local.order.getCarrierId() neq 42>
										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + local.otherItemsMonthlyTotal) />
									<cfelse>
										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + 0) />
									</cfif>

									<cfset local.dueTodayGrandTotal = (local.dueTodayGrandTotal + local.otherItemsTodayTotal) />

									<td style="font-weight: bold; border-top-color: ##CCCCCC; border-bottom-style: solid; border-bottom-width: 1px; border-top-width: 1px;
										border-top-style: solid; border-bottom-color: ##cccccc; text-align: right !important;" align="right !important">
										Additional Items Total
									</td>
									<td style="text-align:right; font-weight: bold; border-top-color: ##CCCCCC; background-color: ##DCDFF8 !important; border-left-width: 1px;
										border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-width: 1px; border-top-style: solid;
										border-bottom-color: ##cccccc; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8">
										#dollarFormat(local.otherItemsTodayTotal)#
									</td>
									<td style=" text-align:right;font-weight: bold; border-top-color: ##CCCCCC; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
										border-bottom-width: 1px; border-top-width: 1px; border-top-style: solid; border-bottom-color: ##cccccc; border-left-color: ##cccccc;">
										<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
											N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										<cfelseif local.order.getCarrierId() eq 42>
											See Carrier Account
										<cfelse>
											#dollarFormat(local.otherItemsFirstTotal)#
										</cfif>
									</td>
									<td style=" text-align:right;font-weight: bold; border-top-color: ##CCC; border-left-width: 1px; border-left-style: solid; border-bottom-style: solid;
										border-bottom-width: 1px; border-top-width: 1px; border-top-style: solid; border-bottom-color: ##cccccc; border-left-color: ##cccccc;">
										<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
											N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
										<cfelseif local.order.getCarrierId() eq 42>
											See Carrier Account
										<cfelse>
											#dollarFormat(local.otherItemsMonthlyTotal)# 
										</cfif>
									</td>
								</tr>
							</table>
						</cfif>
						<table cellpadding="2" class="tblData" cellspacing="0" border="0" width="800" >
							<colgroup />
							<colgroup class="fee today" style="height: 10px; background-color: ##DCDFF8 !important;" />
							<colgroup class="fee" />
							<colgroup class="fee" />

							<tr class="sectionHeader lineHeader">
								<td width="59%"  style=" text-align:right;font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-bottom-width: 1px;
									border-bottom-style: solid; border-left-style: solid; border-left-width: 1px;  border-bottom-color: ##cccccc;
									border-top-width: 1px; border-top-style: solid; vertical-align: top; text-align: left !important; border-left-color: ##cccccc;"
									bgcolor="##EEEEEE" valign="top" align="left !important">
									Checkout
								</td>
								<td width="15%" style=" text-align:right;font-weight: bold; border-top-color: ##cccccc;  !important; border-bottom-width: 1px;
									border-bottom-style: solid; border-left-style: solid; border-left-width: 1px; border-bottom-color: ##cccccc;
									border-top-width: 1px; border-top-style: solid; vertical-align: top; height: 10px; border-left-color: ##cccccc;" bgcolor="##DCDFF8"
									valign="top">
									Due<br/>Today
								</td>
								<td width="13%" style=" text-align:right;font-weight: bold; border-top-color: ##cccccc; background-color: ##EEEEEE; border-left-width: 1px;
									border-left-style: solid; border-bottom-style: solid; border-bottom-width: 1px; border-top-style: solid; border-top-width: 1px;
									border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" bgcolor="##EEEEEE" valign="top">
									Estimated<br />First Bill
								</td>
								<td width="13%" style=" text-align:right;font-weight: bold; background-color: ##EEEEEE; border: 1px solid ##cccccc; vertical-align: top;"
									bgcolor="##EEEEEE" valign="top">
									Estimated<br />Monthly
								</td>
							</tr>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 2px 5px 2px; text-align: right !important; vertical-align: top;
									border-left-color: ##cccccc;" valign="top" align="right !important" class="tblLabel">
									Sub-total
								</td>
								<td style="background-color: ##ffff9e; font-weight:bold; text-align:right; border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									#dollarFormat(local.dueTodayGrandTotal)#
								</td>
								<td style=" text-align:right; border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
									<cfelseif local.order.getCarrierId() eq 42>
										See Carrier Account
									<cfelse>
										#dollarFormat(local.estFirstBillGrandTotal)#
									</cfif>
								</td>
								<td style=" text-align:right; border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; 
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
									<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										N/A <sup class="cartReview"><a href="##footnote5">6</a></sup>
									<cfelseif local.order.getCarrierId() eq 42>
										See Carrier Account
									<cfelse>
										#dollarFormat(local.estMonthlyGrandTotal)#
									</cfif>
								</td>
							</tr>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 2px 5px 2px; text-align: right !important; vertical-align: top;
									border-left-color: ##ccc;" valign="top" align="right !important"  class="tblLabel">
									Discount Total
								</td>
								<td style="background-color: ##ffff9e; font-weight:bold; text-align:right; border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##ccc;" valign="top">
									<cfif local.order.getOrderDiscountTotal()>
										<span style="color:##FF0000">-#dollarFormat(local.order.getOrderDiscountTotal())#</span>
									<cfelse>
										N/A
									</cfif>
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
								<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
							</tr>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; padding: 2px 5px 2px; text-align: right !important; vertical-align: top;
									border-left-color: ##cccccc;" valign="top" align="right !important"  class="tblLabel">
									Taxes and fees
								</td>
								<td style="background-color: ##ffff9e; font-weight:bold; text-align:right; border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									#dollarFormat(local.taxCost)#
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
								<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
							</tr>
							<cfif local.deposit gt 0>
								<tr>
									<td style="border-left-style: solid; border-left-width: 1px; padding: 2px 5px 2px; text-align: right !important; vertical-align: top;
										border-left-color: ##cccccc;" valign="top" align="right !important" class="tblLabel">
											Deposit
									</td>
									<td style="background-color: ##ffff9e; font-weight:bold; text-align:right; border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;"
										valign="top">
											#dollarFormat(local.totalDeposit)#
									</td>
									<td style="border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;"
										valign="top">
											&nbsp;
									</td>
									<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; 
										vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
											&nbsp;
									</td>
								</tr>
							</cfif>
							<tr>
								<td style="border-left-style: solid; border-left-width: 1px; text-align: right !important; vertical-align: top;
									border-left-color: ##ccc;" valign="top" align="right !important" class="tblLabel">
										#local.order.getShipMethod().getDisplayName()#
								</td>
								<td style="background-color: ##ffff9e; font-weight:bold; text-align:right; border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									#dollarFormat(local.shippingCost)#
								</td>
								<td style="border-left-style: solid; border-left-width: 1px; vertical-align: top; border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
								<td style="border-right-style: solid; border-right-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									vertical-align: top; border-right-color: ##cccccc; border-left-color: ##cccccc;" valign="top">
										&nbsp;
								</td>
							</tr>
							<tr>
								<td style="border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 2px 5px 2px;
									border-bottom-color: ##cccccc; vertical-align: top; text-align: right !important; border-left-color: ##cccccc;" valign="top"
									align="right !important" class="tblLabel">
									<strong>Order Total</strong>
								</td>
								<td style="background-color: ##ffff9e; font-weight:bold; text-align:right; color: ##000; border-left-width: 1px; border-left-style: solid;
									border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;"
									bgcolor="##069" valign="top">
									#dollarFormat(((local.dueTodayGrandTotal - local.totalDiscount) + local.taxCost) + local.shippingCost)#
								</td>
								<td style="border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; 
									border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">&nbsp;</td>
								<td style="padding: 5px 5px 2px; border-right-width: 1px; border-right-style: solid; border-left-width: 1px; border-left-style: solid;
									border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##cccccc; vertical-align: top; border-right-color: ##cccccc;
									border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
							</tr>
							<tr>
								<td colspan="4" style="background-color: ##ffff93; border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; border-right-style: solid; border-right-width: 1px; 
									border-bottom-color: ##cccccc; vertical-align: top; text-align: right !important; border-left-color: ##cccccc; border-right-color: ##cccccc;" valign="top">
								#local.order.getShipMethod().getDisplayName()#. <strong>The estimated delivery time will be approximately 5 - 7 business
								days from the time of order.</strong>							
								</td>
							</tr>
							<tr>
								<td colspan="4" style="border: none;" valign="top">
								<p><br/><strong>Shop Confidently</strong></p>		
								<p><strong>Membership:</strong> We will refund your membership fee in full at any time if you are dissatisfied.</p>		
								<p><strong>Merchandise:</strong> We guarantee your satisfaction on every product we sell with a full refund. The following must be
								returned within 90 days of purchase for a refund: televisions, projectors, computers, cameras, camcorders, touchscreen tablets, MP3 players and
								cellular phones.</p>		
								</td>
							</tr>
							<!---<tr>
								<td style="border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 2px 5px 2px;
									border-bottom-color: ##cccccc; vertical-align: top; text-align: right !important; border-left-color: ##cccccc;" valign="top"
									align="right !important" class="tblLabel">
									<strong>Payments -</strong>
												<cfif arrayLen(local.arrPaymentDetails)>
													#local.arrPaymentDetails[1].getPaymentMethod().getName()#
												<cfelse>
													No payment
												</cfif>
								</td>
								<td style="background-color: ##069; padding: 2px 5px 2px; color: ##FFFFFF; border-left-width: 1px; border-left-style: solid;
									border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;"
									bgcolor="##069" valign="top">
									#dollarFormat(((local.dueTodayGrandTotal - local.totalDiscount) + local.taxCost) + local.shippingCost)#
								</td>
								<td style="border-bottom-style: solid; border-bottom-width: 1px; border-left-style: solid; border-left-width: 1px; padding: 5px 5px 2px;
									border-bottom-color: ##cccccc; vertical-align: top; border-left-color: ##cccccc;" valign="top">&nbsp;</td>
								<td style="padding: 5px 5px 2px; border-right-width: 1px; border-right-style: solid; border-left-width: 1px; border-left-style: solid;
									border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: ##cccccc; vertical-align: top; border-right-color: ##cccccc;
									border-left-color: ##cccccc;" valign="top">
									&nbsp;
								</td>
							</tr>--->
							
							
							
						</table>
						<br /><br />
						<span style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
							<cfif local.order.getActivationType() eq 'U'>
								<cfif local.order.getActivationTypeName() is not 'Exchange'>
									* An Upgrade Fee of #local.carrierObj.getUpgradeFee(local.order.getCarrierId())# applies to each Upgrade Line.
									<cfif local.order.getCarrierId() neq 299>This fee will appear on your next billing statement<cfif local.order.getCarrierId() eq 299> and will be refunded to your account within three billing cycles</cfif>.</cfif><br />
								</cfif>
							</cfif>
							<cfif local.order.containsWarranty()>
								<cfset local.providerName = local.order.getWarrantyProvider() />
								<cfif local.providerName eq 'SquareTrade'>
									<sup>&Dagger;</sup> You will receive a separate email (within 3 business days) from SquareTrade with instructions to activate your device protection purchase.<br />
								<cfelseif local.providerName eq 'ServicePak'>
									<sup>&Dagger;</sup> You will receive the ServicePak Terms & Conditions via mail at the shipping address provided.<br />
								<cfelse>
									<sup>&Dagger;</sup> Reference warranty Terms & Conditions<br />
								</cfif>
							</cfif>
							<!---todo: --->
							<cfif ListFind(getChannelConfig().getActivationFeeWavedByCarrier(),local.Order.getCarrierId())>
								<cfif local.order.getActivationTypeName() neq 'Exchange' && local.order.getActivationType() neq 'U' && local.order.getActivationType() neq 'R'>
									<cfif local.order.getCarrierId() eq 109>
										AT&amp;T activation fees will be refunded through a Bill Credit on all qualifying activations.
									<cfelseif local.order.getCarrierId() eq 128>
										T-Mobile activation fees will be refunded through a Bill Credit on all qualifying activations.
									<cfelseif local.order.getCarrierId() eq 42>
										Customers will receive a mail-in rebate from Wireless Advocates to reimburse the activation fee
										on a new single line and/or Family Share 2-year Verizon service agreement. Upgrades do not qualify for this credit
									<cfelseif local.order.getCarrierId() eq 299>
										Sprint activation fees will be refunded through a Bill Credit on all qualifying activations.
									</cfif>
									Please <a href="http://#request.config.emailTemplateDomain#/index.cfm/go/cart/do/explainActivationFee/carrierId/#local.order.getCarrierId()#" target="_blank">click here</a> for details.
								</cfif>
							</cfif>
						</span>
						<br />
						<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
							<span style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
								<sup class="cartReview"><a name="footnote5">6</a></sup> First bill and estimated monthly charges for your new line(s) will be provided by your carrier.
							</span>
							<br />
						</cfif>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="getOrderFullView" access="public" returntype="string" output="false" hint="Accepts and Order object and returns an HTML view of the order.">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="emailFormat" type="boolean" default="false" required="false" />

		<cfset var local = structNew() />
		<cfset local.order = arguments.order />
		<cfset local.emailFormat = arguments.emailFormat />
		<cfset local.billAddress = local.order.getBillAddress() />
		<cfset local.shipAddress = local.order.getShipAddress() />
		<cfset local.lines = local.order.getWirelessLines() />
		<cfset local.otherItems = local.order.getOtherItems() />
		<cfset local.hardGoodsCost = local.order.getSubTotal() />
		<cfset local.shippingCost = local.order.getShipCost() />
		<cfset local.taxCost = local.order.getTaxTotal() />
		<cfset local.deposit = application.model.order.getWirelessAccount().getDepositAmount() />
		<cfset local.arrPaymentDetails = local.order.getPayments() />
		<cfset local.carrierObj = application.wirebox.getInstance("Carrier") />


		<cfsavecontent variable="local.html">
			<style type="text/css">
				.section	{
					margin-bottom: 10px;
					font-size: 1.2em;
				}
				.section .strong	{
					font-weight: bold;
				}
				.section span.title	{
					font-weight: bold;
					margin-bottom: 5px;
					display:block;
				}
				.section table td	{
					vertical-align:top;
					padding: 5px;
					padding-bottom: 2px;
				}
				.section table td.label	{
					width: 120px;
				}
				table.orderdetails	{
					border-left: solid 1px #ccc;
					margin-bottom: 10px;
				}
				.borderright	{
					border-right: solid 1px #ccc;
				}
				.borderbottom	{
					border-bottom: solid 1px #ccc;
				}
				.sectionHeader td	{
					font-weight:bold;
					border-bottom:solid 1px #ccc;
				}
				.totalRow	{
					border-left:solid 1px #ccc;
				}
				.lineHeader td	{
					border-top:solid 1px #ccc;
					font-weight:bold;
					background-color: #EEE;
				}
				.leftalign	{
					text-align:left !important;
				}
				.rightalign	{
					text-align:right !important;
				}
				.bordertop	{
					border-top:solid 1px #CCC;
				}
				.stong	{
					font-weight: bold !important;
				}
				.highlight	{
					background-color: #069;
					color: #FFF;
				}
				.today	{
					height:10px;
					background: #DCDFF8  !important;
				}
				.threeup	{
					width: 100%;
				}
				.threeup td	{
					vertical-align: top;
					padding-right: 10px;
				}
				.threeup td.right	{
					padding-right: 0px;
				}
				.threeup .section	{
					padding: 10px;
					height: 160px;
					border: solid 1px #ccc;
				}
				.note {
					font-size: 0.8em;
				}
			</style>

			<cfoutput>
				<div id="wrapper" width="100%">
					<table cellpadding="0" cellspacing="0" border="0" class="threeup">
						<tr>
							<td>
								<div class="section">
									<span class="title">Order Information</span>
									<table>
										<tr>
											<td class="label">Order ID:</td>
											<td class="strong">#local.order.getOrderId()#</td>
										</tr>
										<tr>
											<td class="label">Order Date:</td>
											<td>#dateFormat(local.order.getOrderDate(), 'mm/dd/yyyy')#</td>
										</tr>
										<tr>
											<td class="label">Shipment Method:</td>
											<td>#local.order.getShipMethod().getDisplayName()#</td>
										</tr>
										<tr>
											<td>Payment Method:</td>
											<td>
												<cfif arrayLen(local.arrPaymentDetails)>
													#local.arrPaymentDetails[1].getPaymentMethod().getName()#
												<cfelse>
													No payment
												</cfif>
											</td>
										</tr>
									</table>
								</div>
							</td>
							<td>
								<div class="section">
									<span class="title">Billing Address</span>
									<table>
										<tr>
											<td>
												#local.billAddress.getFirstName()# #local.billAddress.getLastName()#<br />
												<cfif len(trim(local.billAddress.getCompany()))>
													#local.billAddress.getCompany()#<br />
												</cfif>
												#local.billAddress.getAddress1()#<br />
                                            	<cfif len(trim(local.billAddress.getAddress2()))>
													#local.billAddress.getAddress2()#<br />
												</cfif>
												<cfif len(trim(local.billAddress.getAddress3()))>
													#local.billAddress.getAddress3()#<br />
												</cfif>
												#local.billAddress.getCity()#, #local.billAddress.getState()# #local.billAddress.getZip()#
											</td>
										</tr>
										<tr>
											<td>#local.billAddress.formatPhone(local.billAddress.getDaytimePhone())# (Day)</td>
										</tr>
										<tr>
											<td>#local.billAddress.formatPhone(local.billAddress.getEveningPhone())# (Eve)</td>
										</tr>
									</table>
								</div>
							</td>
							<td class="right">
								<div class="section">
									<span class="title">Shipping Address</span>
									<table>
										<tr>
											<td>
												#local.shipAddress.getFirstName()# #local.shipAddress.getLastName()#<br />
												<cfif len(trim(local.shipAddress.getCompany()))>
													#local.shipAddress.getCompany()#<br />
												</cfif>
												#local.shipAddress.getAddress1()#<br />
												<cfif len(trim(local.shipAddress.getAddress2()))>
													#local.shipAddress.getAddress2()#<br />
												</cfif>
												<cfif len(trim(local.shipAddress.getAddress3()))>
													#local.shipAddress.getAddress3()#<br />
												</cfif>
												#local.shipAddress.getCity()#, #local.shipAddress.getState()# #local.shipAddress.getZip()#
											</td>
										</tr>
										<tr>
											<td>#local.shipAddress.formatPhone(local.shipAddress.getDaytimePhone())# (Day)</td>
										</tr>
										<tr>
											<td>#local.shipAddress.formatPhone(local.shipAddress.getEveningPhone())# (Eve)</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
					<div class="section">
						<span class="title">Order Details</span>

						<cfset local.dueTodayGrandTotal = 0 />
						<cfset local.estFirstBillGrandTotal = 0 />
						<cfset local.estMonthlyGrandTotal = 0 />
						<cfset local.totalTax = 0 />
						<cfset local.totalDiscount  = local.order.getOrderDiscountTotal() />
						<cfset local.totalDeposit = 0 />

						<cfif arrayLen(local.lines)>
							<cfloop from="1" to="#arrayLen(local.lines)#" index="local.iLine">
								<cfset local.dueTodayTotal = 0 />
								<cfset local.estFirstBillTotal = 0 />
								<cfset local.estMonthlyTotal = 0 />
								<cfset local.line = local.lines[local.iLine] />
								<cfset LineContainsKeepExistingService = false />

								<table cellpadding="2" class="local.orders orderdetails" cellspacing="0" border="0" width="100%">
									<tr class="sectionHeader lineHeader">
										<td width="59%" class="item">Line #local.iLine#</td>
										<td width="15%" class="totalRow today">Due Today</td>
										<td width="13%" class="totalRow">Estimated<br />First Bill</td>
										<td width="13%" class="totalRow borderright">Estimated<br />Monthly</td>
									</tr>
									<tr>
										<td class="producttitle"><span class="label">Device</span></td>
										<td class="totalRow today">&nbsp;</td>
										<td class="totalRow">&nbsp;</td>
										<td class="totalRow borderright">&nbsp;</td>
									</tr>
									<tr>
										<td class="item">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<td>&nbsp;</td>
													<td>
														#local.line.getLineDevice().getProductTitle()#
														<cfif local.line.getLineDevice().getRebate() gt 0>
															<br />
															<span style="color:##FF0000">Device qualified for special promotion which converted mail-in rebate to instant online savings.</span>
														</cfif>
													</td>
												</tr>
											</table>
										</td>

										<cfset local.dueTodayTotal = (local.dueTodayTotal + local.line.getLineDevice().getNetPrice() + local.line.getLineDevice().getDownPaymentReceived()) />
										<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

										<td class="totalRow today">
											#dollarFormat(local.line.getLineDevice().getNetPrice() + local.line.getLineDevice().getRebate() + local.line.getLineDevice().getDownPaymentReceived())#
											<cfif local.line.getLineDevice().getRebate() gt 0>
												<br />
												<span style="color:##FF0000">-#dollarFormat(local.line.getLineDevice().getRebate())#</span>
											</cfif>
										</td>
										<td class="totalRow">&nbsp;</td>
										<td class="totalRow borderright">&nbsp;</td>
									</tr>

									<cfif len(local.line.getLineRateplan().getProductTitle()) gt 0>
										<tr class="sectionHeader">
											<td class="item">&nbsp;</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										</tr>
										<tr>
											<td class="producttitle">Plan</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										 </tr>
										 <tr>
										 	<td class="item">
										 		<table cellpadding="0" cellspacing="0">
										 			<tr>
										 				<td>&nbsp;</td>
										 				<td>#local.line.getLineRateplan().getProductTitle()#
														<cfif local.line.getLineRateplan().getGersSku() is "EXCHANGED">
															<br/>Deposit
														</cfif>
														</td>
										 			</tr>
										 		</table>
										 	</td>
										 	<td class="totalRow today">
										 		<cfif local.line.getLineRateplan().getGersSku() is "EXCHANGED"><br/>&nbsp;<br/>
												 	#DollarFormat( local.line.getLineRateplan().getNetPrice() )#
												 	<cfset local.dueTodayTotal = (local.dueTodayTotal + local.line..getLineRateplan().getNetPrice()) />
											 	<cfelse>&nbsp;</cfif>
											 </td>

										 	<cfif local.order.getCarrierId() neq 42>
										 		<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.line.getMonthlyFee()) />
										 	<cfelse>
										 		<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
										 	</cfif>

										 	<cfset local.estMonthlyTotal = (local.estMonthlyTotal + local.line.getMonthlyFee()) />
										 	<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

										 	<td class="totalRow">
										 		<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										 			TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
										 		<cfelseif local.order.getCarrierId() eq 42>
										 			See Carrier Account 
										 		<cfelse>
										 			#dollarFormat(local.line.getMonthlyFee())#
										 		</cfif>
										 	</td>
										 	<td class="totalRow borderright">
										 		<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										 			TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
										 		<cfelseif local.order.getCarrierId() eq 42>
										 			See Carrier Account 
										 		<cfelse>
										 			#dollarFormat(local.line.getMonthlyFee())#
										 		</cfif>
										 	</td>
										 </tr>
									</cfif>
									<cfif local.order.getActivationTypeName() is not 'Upgrade' and local.order.getActivationTypeName() is not 'Exchange'>
										<cfif ListFind(getChannelConfig().getActivationFeeWavedByCarrier(),local.Order.getCarrierId())>
											<tr class="sectionHeader">
												<td class="item">&nbsp;</td>
												<td class="totalRow today">&nbsp;</td>
												<td class="totalRow">&nbsp;</td>
												<td class="totalRow borderright">&nbsp;</td>
											</tr>
											<tr>
												<td class="producttitle">Activation Fee</td>
												<td class="totalRow today">&nbsp;</td>
												<td class="totalRow">&nbsp;</td>
												<td class="totalRow borderright">&nbsp;</td>
											</tr>
											<tr>
												<td class="item">
													<table cellpadding="0" cellspacing="0">
														<tr>
															<td>&nbsp;</td>
															<td><span class="activationFeeExplanation">(To be refunded by <cfif local.Order.getCarrierId() eq 42>Wireless Advocates, LLC<cfelse>your carrier</cfif> - see details below <sup><a href="##footnote4">4</a></sup>)</span></td>
														</tr>
													</table>
												</td>
												<td class="totalRow today">&nbsp;</td>
												<cfif local.order.getCarrierId() neq 42>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.line.getActivationFee()) />
												<cfelse>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
												</cfif>
												<td class="totalRow"><a href="http://#cgi.server_name#/index.cfm/go/cart/do/explainActivationFee/carrierId/#local.order.getCarrierId()#" class="activationFeeExplanation" target="_blank">#dollarFormat(local.line.getActivationFee())#</a></td>
												<td class="totalRow borderright">&nbsp;</td>
											</tr>
										</cfif>
									</cfif>

									<cfset local.services = local.line.getLineServices() />

									<cfif arrayLen(local.services)>
										<tr class="sectionHeader">
											<td class="item">&nbsp;</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										</tr>
										<tr>
											<td class="producttitle">Services</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										</tr>
										<cfloop from="1" to="#arrayLen(local.services)#" index="local.iService">
											<cfset local.service = local.services[local.iService] />
											<tr>
												<td class="item">
													<table cellpadding="0" cellspacing="0">
														<tr>
															<td>&nbsp;</td>
															<td>#local.service.getProductTitle()#</td>
														</tr>
													</table>
												</td>
												<cfif local.order.getCarrierId() neq 42>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + local.service.getEstimatedMonthly()) />
												<cfelse>
													<cfset local.estFirstBillTotal = (local.estFirstBillTotal + 0) />
												</cfif>

												<cfset local.estMonthlyTotal = (local.estMonthlyTotal + local.service.getEstimatedMonthly()) />
												<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

												<td class="totalRow today">&nbsp;</td>
												<td class="totalRow">
													<cfif local.order.getCarrierId() eq 42>
														<cfset LineContainsKeepExistingService = true />
														See Carrier Account
													<cfelse>
														#dollarFormat(local.service.getEstimatedMonthly())#
													</cfif>
												</td>
												<td class="totalRow borderright">
													#dollarFormat(local.service.getEstimatedMonthly())#
												</td>
											</tr>
										</cfloop>
									</cfif>

									<cfset local.accessories = local.line.getLineAccessories() />

									<cfif arrayLen(local.accessories)>
										<tr class="sectionHeader">
											<td class="item">&nbsp;</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										</tr>
										<tr>
											<td class="producttitle">Accessories</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										</tr>

										<cfloop from="1" to="#arrayLen(local.accessories)#" index="local.iAccessory">
											<cfset local.accessory = local.accessories[local.iAccessory] />
											<tr>
												<td class="item">
													<table cellpadding="0" cellspacing="0">
														<tr>
															<td>&nbsp;</td>
															<td>#local.accessory.getProductTitle()#</td>
														</tr>
													</table>
												</td>

												<cfset local.dueTodayTotal = (local.dueTodayTotal + local.accessory.getNetPrice()) />
												<cfset local.totalTax = (local.totalTax + local.line.getLineDevice().getTaxes()) />

												<td class="totalRow today">#dollarFormat(local.accessory.getNetPrice())#</td>
												<td class="totalRow">&nbsp;</td>
												<td class="totalRow borderright">&nbsp;</td>
											</tr>
										</cfloop>
									</cfif>

									<cfif local.line.getLineWarranty().getProductId() neq 0>
										<tr class="sectionHeader">
											<td class="item">&nbsp;</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										</tr>
										<tr>
											<td class="producttitle">Protection Plan</td>
											<td class="totalRow today">&nbsp;</td>
											<td class="totalRow">&nbsp;</td>
											<td class="totalRow borderright">&nbsp;</td>
										</tr>
										<td class="item">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<td>&nbsp;</td>
													<td>#local.line.getLineWarranty().getProductTitle()# <sup>&Dagger;</sup></td>
												</tr>
											</table>
										</td>

										<cfset local.dueTodayTotal = (local.dueTodayTotal + local.line.getLineWarranty().getNetPrice()) />
										<cfset local.totalTax = (local.totalTax + local.line.getLineWarranty().getTaxes()) />

										<td class="totalRow today">#dollarFormat(local.line.getLineWarranty().getNetPrice())#</td>
										<td class="totalRow">&nbsp;</td>
										<td class="totalRow borderright">&nbsp;</td>
									</cfif>

									<tr>
										<cfset local.dueTodayGrandTotal = (local.dueTodayGrandTotal + local.dueTodayTotal) />

										<cfif local.order.getCarrierId() neq 42>
											<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + local.estFirstBillTotal) />
										<cfelse>
											<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + 0) />
										</cfif>

										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + local.estMonthlyTotal) />

										<td class="item bordertop borderbottom rightalign">Line #local.iLine# Total</td>
										<td class="totalRow bordertop borderbottom stong  today">#dollarFormat(local.dueTodayTotal)#</td>
										<td class="totalRow bordertop borderbottom">
											<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
												TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
											<cfelseif local.order.getCarrierId() eq 42>
												See Carrier Account 
											<cfelse>
												#dollarFormat(local.estFirstBillTotal)#
											</cfif>
										</td>
										<td class="totalRow borderright bordertop borderbottom">
											<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
												TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
											<cfelseif local.order.getCarrierId() eq 42>
												See Carrier Account 
											<cfelse>
												#dollarFormat(local.estMonthlyTotal)#
											</cfif>
										</td>
									</tr>
								</table>
							</cfloop>
						</cfif>

						<cfif arrayLen(local.otherItems)>
							<cfset local.otherItemsTodayTotal = 0 />
							<cfset local.otherItemsFirstTotal = 0 />
							<cfset local.otherItemsMonthlyTotal = 0 />

							<table cellpadding="2" class="local.orders orderdetails" cellspacing="0" border="0" width="100%">
								<tr class="sectionHeader lineHeader">
									<td class="item" width="59%">Additional Items</td>
									<td class="totalRow today" width="15%">Due Today</td>
									<td class="totalRow" width="13%">Estimated<br />First Bill</td>
									<td class="totalRow borderright" width="13%">Estimated<br />Monthly</td>
								</tr>
								<tr>
									<td class="producttitle">Accessories</td>
									<td class="totalRow today">&nbsp;</td>
									<td class="totalRow">&nbsp;</td>
									<td class="totalRow borderright">&nbsp;</td>
								</tr>
								<cfloop from="1" to="#arrayLen(local.otherItems)#" index="local.iAccessory">
									<cfset local.accessory = local.otherItems[local.iAccessory] />
									<tr>
										<td class="item">
											<table cellpadding="0" cellspacing="0">
												<tr>
													<td>&nbsp;</td>
													<td>#local.accessory.getProductTitle()#</td>
												</tr>
											</table>
										</td>

										<cfset local.otherItemsTodayTotal = (local.otherItemsTodayTotal + local.accessory.getNetPrice()) />

										<td class="totalRow today">#dollarFormat(local.accessory.getNetPrice())#</td>
										<td class="totalRow">&nbsp;</td>
										<td class="totalRow borderright">&nbsp;</td>
									</tr>
								</cfloop>
								<tr class="sectionHeader">
									<cfset local.estFirstBillGrandTotal = (local.estFirstBillGrandTotal + local.otherItemsFirstTotal) />

									<cfif local.order.getCarrierId() neq 42>
										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + local.otherItemsMonthlyTotal) />
									<cfelse>
										<cfset local.estMonthlyGrandTotal = (local.estMonthlyGrandTotal + 0) />
									</cfif>

									<cfset local.dueTodayGrandTotal = (local.dueTodayGrandTotal + local.otherItemsTodayTotal) />

									<td class="item bordertop rightalign">Additional Items Total</td>
									<td class="totalRow bordertop today">#dollarFormat(local.otherItemsTodayTotal)#</td>
									<td class="totalRow bordertop">
										<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
											TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
										<cfelseif local.order.getCarrierId() eq 42>
											See Carrier Account 
										<cfelse>
											#dollarFormat(local.otherItemsFirstTotal)#
										</cfif>
									</td>
									<td class="totalRow borderright bordertop">
										<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
											TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
										<cfelseif local.order.getCarrierId() eq 42>
											See Carrier Account 
										<cfelse>
											#dollarFormat(local.otherItemsMonthlyTotal)#
										</cfif>
									</td>
								</tr>
							</table>
						</cfif>
						<table cellpadding="2" class="local.orders checkout" cellspacing="0" border="0" width="100%">
							<colgroup />
							<colgroup class="fee today" />
							<colgroup class="fee" />
							<colgroup class="fee" />

							<tr class="sectionHeader lineHeader">
								<td width="59%" class="item totalRow leftalign">Checkout</td>
								<td width="15%" class="totalRow today" >Due Today</td>
								<td width="13%" class="totalRow">Estimated<br />First Bill</td>
								<td width="13%" class="totalRow borderright">Estimated<br />Monthly</td>
							</tr>
							<tr>
								<td class="item totalRow rightalign">Sub-total</td>
								<td class="totalRow">#dollarFormat(local.dueTodayGrandTotal)#</td>
								<td class="totalRow">
									<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
									<cfelseif local.order.getCarrierId() eq 42>
										See Carrier Account 
									<cfelse>
										#dollarFormat(local.estFirstBillGrandTotal)#
									</cfif>
								</td>
								<td class="totalRow borderright">
									<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
										TBD <sup class="cartReview"><a href="##footnote5">6</a></sup>
									<cfelseif local.order.getCarrierId() eq 42>
										See Carrier Account 
									<cfelse>
										#dollarFormat(local.estMonthlyGrandTotal)#
									</cfif>
								</td>
							</tr>
							<tr>
								<td class="item totalRow rightalign">Discount Total</td>
								<td class="totalRow">
									<cfif local.order.getOrderDiscountTotal()>
										<span style="color:##FF0000">-#dollarFormat(local.order.getOrderDiscountTotal())#</span>
									<cfelse>
										N/A
									</cfif>
								</td>
								<td class="totalRow">&nbsp;</td>
								<td class="totalRow borderright">&nbsp;</td>
							</tr>
							<tr>
								<td class="item totalRow rightalign">Taxes and fees</td>
								<td class="totalRow">#dollarFormat(local.taxCost)#</td>
								<td class="totalRow">&nbsp;</td>
								<td class="totalRow borderright">&nbsp;</td>
							</tr>
							<cfif local.deposit gt 0>
								<tr>
									<td class="item totalRow rightalign">Deposit</td>
									<td class="totalRow">#dollarFormat(local.totalDeposit)#</td>
									<td class="totalRow">&nbsp;</td>
									<td class="totalRow borderright">&nbsp;</td>
								</tr>
							</cfif>
							<tr>
								<td class="item totalRow rightalign">#local.order.getShipMethod().getDisplayName()#</td>
								<td class="totalRow">#dollarFormat(local.shippingCost)#</td>
								<td class="totalRow">&nbsp;</td>
								<td class="totalRow borderright">&nbsp;</td>
							</tr>
							<tr>
								<td class="item totalRow borderbottom rightalign"><strong>Total</strong></td>
								<td class="totalRow borderbottom highlight">#dollarFormat(((local.dueTodayGrandTotal - local.totalDiscount) + local.taxCost) + local.shippingCost)#</td>
								<td class="totalRow borderbottom ">&nbsp;</td>
								<td class="totalRow borderright borderbottom">&nbsp;</td>
							</tr>
						</table>
						<br /><br />
						<span class="note">
							<cfif local.order.getActivationType() eq 'U'>
								<cfif local.order.getActivationTypeName() is not 'Exchange'>
									<sup>&diams;</sup> An Upgrade Fee of local.carrierObj.getUpgradeFee(f local.order.getCarrierId()) applies to each Upgrade Line.
									<cfif local.order.getCarrierId() neq 299>This fee will appear on your next billing statement<cfif local.order.getCarrierId() eq 299> and will be refunded to your account within three billing cycles</cfif>.</cfif><br />
								</cfif>
							</cfif>
							<cfif local.order.containsWarranty()>
								<cfset local.providerName = local.order.getWarrantyProvider() />
								<cfif local.providerName eq 'SquareTrade'>
									<sup>&Dagger;</sup> You will receive a separate email (within 3 business days) from SquareTrade with instructions to activate your device protection purchase.<br />
								<cfelseif local.providerName eq 'ServicePak'>
									<sup>&Dagger;</sup> You will receive the ServicePak Terms & Conditions via mail at the shipping address provided.<br />
								<cfelse>
									<sup>&Dagger;</sup> Reference warranty Terms & Conditions<br />
								</cfif>
							</cfif>
							<cfif ListFind(getChannelConfig().getActivationFeeWavedByCarrier(),local.Order.getCarrierId())>
								<cfif local.order.getActivationTypeName() neq 'Exchange' && local.order.getActivationType() neq 'U' && local.order.getActivationType() neq 'R'>
									<cfif local.order.getCarrierId() eq 109>
										AT&amp;T activation fees will be refunded through a Bill Credit on all qualifying activations.
									<cfelseif local.order.getCarrierId() eq 128>
										T-Mobile activation fees will be refunded through a Bill Credit on all qualifying activations.
									<cfelseif local.order.getCarrierId() eq 42>
										Customers will receive a mail-in rebate from Wireless Advocates to reimburse the activation fee
										on a new single line and/or Family Share 2-year Verizon service agreement. Upgrades do not qualify for this credit
									<cfelseif local.order.getCarrierId() eq 299>
										Sprint activation fees will be refunded through a Bill Credit on all qualifying activations.
									</cfif>
									Please <a href="http://#cgi.server_name#/index.cfm/go/cart/do/explainActivationFee/carrierId/#local.order.getCarrierId()#" target="_blank">click here</a> for details.
								</cfif>
							</cfif>
						</span>
						<br />
						<cfif local.order.getActivationType() is 'A' and local.order.getCarrierId() eq 128>
							<span class="note">
								<sup class="cartReview"><a name="footnote5">6</a></sup> First bill and estimated monthly charges for your new line(s) will be provided by your carrier.
							</span>
							<br />
						</cfif>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>


	<cffunction name="getOrderHtmlDocumentView" access="public" returntype="string" output="false" hint="Accepts and Order object and returns an HTML view of the order.">
		<cfargument name="order" type="cfc.model.Order" required="true" />
		<cfargument name="featureLists" type="cfc.model.carrierservice.Verizon.common.Features[]" default="false" required="false" />
		<cfargument name="emailFormat" type="boolean" default="false" required="false" />

		<cfset var htmlDocument = '' />
		<cfset var local = structNew() />
		<cfset local.order = arguments.order />
		<cfset local.billAddress = local.order.getBillAddress() />
		<cfset local.lines = local.order.getWirelessLines() />
		<cfset local.wirelessaccount = local.order.getWirelessAccount() />
		<cfset local.mdn = '' />

		<cfsavecontent variable="htmlDocument">
			<cfoutput>
				<html><head><meta content="text/html; charset=ISO-8859-1" http-equiv="content-type"><title>VERIZON WIRELESS CUSTOMER AGREEMENT</title></head>
				<body><div style="width: 600px"><h3 style="text-align: center;">VERIZON WIRELESS CUSTOMER AGREEMENT</h3><hr/></div>
				<div style="width: 600px">
					<b>Application ID No.:</b> #local.order.getCreditApplicationNumber()#

					<span style="position:absolute; left:310px"><b>Order Date: </b>#dateFormat(local.order.getOrderDate(), 'mm/dd/yyyy')#</span>
					<br/>
					<b>Bill Acct. No.:</b> #local.wirelessaccount.getCurrentAcctNumber()#

					<span style="position:absolute; left:310px"><b>Agent Name:</b> Wireless Advocates LLC</span>
					<br/>

					<b>Activation Type:</b> #local.order.getActivationTypeName()#
					<br/><br/>
					<b>Customer Information:</b><br/>
					#local.billAddress.getFirstName()# #local.billAddress.getLastName()#<br/>
					#local.billAddress.getAddress1()#<br/>
					#local.billAddress.getCity()#, #local.billAddress.getState()# #local.billAddress.getZip()#<br/><br/>
					<b>Home Phone:</b> #local.billAddress.formatPhone(local.billAddress.getDaytimePhone())#
				</div>
				<div style="width: 600px"><hr/>

					<cfif arrayLen(local.lines)>
						<cfloop from="1" to="#arrayLen(local.lines)#" index="local.iLine">

							<cfset local.line = local.lines[local.iLine] />

							<b>Line #local.iLine# Details</b><br/>
							<b>Mobile Number:</b>

							<cfif len(trim(local.line.getNewMDN()))>
							#local.line.getNewMDN()#
							<cfset local.mdn = '#local.line.getNewMDN()#' />
							<cfelse>
							#local.line.getCurrentMDN()#
							<cfset local.mdn = '#local.line.getCurrentMDN()#' />
							</cfif>
							<br/>

							<cfset local.services = local.line.getLineServices() />
							<cfif arrayLen(local.services)>
								<cfloop from="1" to="#arrayLen(local.services)#" index="local.iService">
									<cfset local.service = local.services[local.iService] />
									<b>Price Plan: </b> #local.service.getProductTitle()# <br>
									<b>Plan Access Fee: </b> <span>#dollarFormat(local.service.getEstimatedMonthly())#</span><br>
								</cfloop>
							</cfif>

							<b>ETF:</b> $350<br/><br>
							<b>Term: 24 months</b><br>

							<cfif local.line.getRequestedActivationDate() is "{ts '9999-01-01 00:00:00'}">
							<b>Effective Date: #DateFormat(local.order.getOrderDate(), "mm/dd/yyyy")#</b><br>
							<cfelse>
							<b>Effective Date: #DateFormat(local.line.getRequestedActivationDate(), "mm/dd/yyyy")#</b><br>
							</cfif>

							<cfif local.order.getActivationType() is 'U'>

								<b>Activation Fee: $0</b><br>
								<b>Upgrade Fee: $30</b><br>

							<cfelse>
								<b>Activation Fee: $35</b><br>
								<b>Upgrade Fee: $0</b><br>
							</cfif>
							<br>


							<b>Features:</b><br>
							<cfif arrayLen(arguments.featureLists)>
								<cfloop from="1" to="#arrayLen(arguments.featureLists)#" index="local.iFeature">
									<cfset local.feature = arguments.featureLists[local.iFeature] />

									<cfif local.feature.getMDN() eq '#local.mdn#'>
										#local.feature.getDescription()#
										<br>
									</cfif>
								</cfloop>
							</cfif>
							<br>

						</cfloop>
					</cfif>
					<hr/>
					<b>Security Deposit (per line): USD $0</b><br/><br/>
					<b>Customer Accepted:</b> #DateFormat(local.order.getOrderDate(),"mm/dd/yyyy")#<br/>
					<b>Customer Agreement version: 4GMB041211</b><br><br>
					<hr><br>
					By checking the box below, you are attaching your electronic signature to and agreeing to the terms and conditions of the Verizon Wireless Customer Agreement. THE CUSTOMER AGREEMENT SETS YOUR AND OUR RIGHTS CONCERNING PAYMENTS, CREDITS AND CHARGES, STARTING AND ENDING SERVICE, EARLY TERMINATION FEE OF UP TO $350, LIMITATIONS OF LIABILITY, SETTLEMENT OF DISPUTES BY NEUTRAL ARBITRATION AND OTHER MEANS INSTEAD OF JURY TRIALS, AND OTHER IMPORTANT TOPICS.<br><br>
					You understand that if you do not agree to the Verizon Wireless Customer Agreement Terms and Conditions, you should click on 'Reject' button and close this web page or your web browser to discontinue your order with Verizon Wireless.<br>
					X By checking this box, I acknowledge that I have read and agree to the Verizon Wireless Customer Agreement. <br>
					<hr><br>
					<hr/>
				</div>
				</body></html>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(htmlDocument) />
	</cffunction>

	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">
    	<cfreturn variables.instance.assetPaths />
    </cffunction>
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">
    	<cfargument name="theVar" required="true" />
    	<cfset variables.instance.assetPaths = arguments.theVar />
    </cffunction>

	<cffunction name="getChannelConfig" access="private" output="false" returntype="struct">
    	<cfreturn variables.instance.ChannelConfig />
    </cffunction>
    <cffunction name="setChannelConfig" access="private" output="false" returntype="void">
    	<cfargument name="ChannelConfig" required="true" />
    	<cfset variables.instance.ChannelConfig = arguments.ChannelConfig />
    </cffunction>

</cfcomponent>
