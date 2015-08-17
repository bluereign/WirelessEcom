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
									* An Upgrade Fee of <cfif local.order.getCarrierId() eq 109 >$40.00<cfelseif  local.order.getCarrierId() eq 299>$36.00<cfelseif local.order.getCarrierId() eq 42>$30.00<cfelse>$18.00</cfif> applies to each Upgrade Line.
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
