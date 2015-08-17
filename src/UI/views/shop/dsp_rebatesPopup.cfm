<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfparam name="url.mapPrice" default="0" type="string" />
<cfparam name="url.productId" default="0" type="numeric" />
<cfparam name="url.planType" default="new" type="string" />
<cfparam name="url.carrierId" default="0" type="numeric" />
<html>
	<head>
		<title></title>
	</head>
	<body style="padding: 0px; margin: 0px">
		<cfif structKeyExists(url, 'productId') and url.productId gt 0>
			<cfset qry_getRebates = application.model.rebates.getProductInRebateFilter(productId = url.productId, type = url.planType) />

			<cfif qry_getRebates.recordCount>
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<tr valign="middle">
						<td width="1">
							<cfif url.carrierID eq 109>
								<cfoutput><img src="#assetPaths.common#images/carrierLogos/att_175.gif" alt="AT&T" /></cfoutput>
							<cfelseif url.carrierID eq 128>
								<cfoutput><img src="#assetPaths.common#images/carrierLogos/tmobile_175.gif" alt="T-Mobile" /></cfoutput>
							<cfelseif url.carrierID eq 42>
								<cfoutput><img src="#assetPaths.common#images/carrierLogos/verizon_175.gif" alt="Verizon" /></cfoutput>
							</cfif>
						</td>
						<td style="text-align: center"><h3 style="color: maroon"><cfoutput>#trim(application.model.phone.getProductTitle(productId = url.productId).title[1])#</cfoutput></h3></td>
					</tr>
				</table>
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><span style="font-size: 13pt">Potential Rebates and Special Pricing for this handset include the following:</span><br /></td>
					</tr>
					<tr valign="top">
						<td>
							<div style="float: right"><img src="#assetPaths.common#images/ui/iStock_000009827102XSmall_350.jpg" width="350" /></div>
							<div style="float: left; width: 380px">
								<br /><br />
								<table width="100%" cellpadding="3" cellspacing="0" border="0">
									<cfoutput query="qry_getRebates">
										<cfif trim(qry_getRebates.title) is not 'CLICK HERE FOR PRICE'>
											<tr>
												<td><span style="white-space: nowrap"><strong>#trim(qry_getRebates.title)#</strong></span></td>
												<td width="80" align="right"><strong style="color: maroon">#dollarFormat(qry_getRebates.amount)#</strong>&nbsp;</td>
											</tr>
										<cfelse>
											<tr>
												<td><span style="white-space: nowrap"><strong>BONUS DEAL!</strong></span></td>
												<td width="80" align="right"><strong style="color: maroon">#dollarFormat(url.mapPrice)#</strong>&nbsp;</td>
											</tr>
										</cfif>
										<cfif len(trim(qry_getRebates.description))>
											<tr>
												<td colspan="2"><span style="font-size: 8pt">#paragraphFormat(trim(qry_getRebates.description))#</span></td>
											</tr>
										</cfif>
										<cfif len(trim(qry_getRebates.specialInstructions))>
											<tr>
												<td colspan="2">
													<span style="color: maroon; font-weight: bold; font-size: 8pt">* Special Instructions</span>
													<br />
													<span style="font-size: 8pt">#paragraphFormat(trim(qry_getRebates.specialInstructions))#</span>
												</td>
											</tr>
										</cfif>
									</cfoutput>
								</table>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<hr style="border-bottom: 1px solid black dashed" />
							<p><strong>Rebate Eligibility &amp; Restrictions:</strong></p>
							<table width="100%" cellpadding="3" cellspacing="0" border="0">
								<tr valign="top">
									<td width="25" style="text-align: right; font-size: 8pt"><strong>--</strong>&nbsp;</td>
									<td style="font-size: 8pt">
										If a service is added by the customer by contacting the carrier directly, after the transaction
										has been processed online, the activation will not be eligible for the rebate offer.
										If a qualifying handset, service or plan is changed, cancelled
										or removed from the customers account through direct carrier contact within 16 weeks of the receipt
										of the handset, then the customer may no longer be eligible for the rebate.
									</td>
								</tr>
								<!--- <tr valign="top">
									<td width="25" style="text-align: right; font-size: 8pt"><strong>--</strong>&nbsp;</td>
									<td style="font-size: 8pt">
										If the customer receives their handset and the qualifying data service is not active, the customer
										will need to contact our Customer Service department directly to have the feature added in order to
										maintain their order's eligibility for the rebate.
									</td>
								</tr> --->
							</table>
							<p><strong>Terms &amp; Conditions</strong></p>
							<table width="100%" cellpadding="3" cellspacing="0" border="0">
								<tr valign="top">
									<td width="25" style="text-align: right; font-size: 8pt">1.&nbsp;</td>
									<td style="font-size: 8pt">
										Click, Print and submit a completed copy of the rebate form. A list of eligible rebates is viewable
										from your transaction receipt. Follow rebate instructions, listed on rebate, carefully. Please double
										check to make sure you have all the right forms. If you changed your cell phone number, please indicate
										your new cell phone number, and not your previous phone number on the rebate form.
									</td>
								</tr>
								<tr valign="top">
									<td width="25" style="text-align: right; font-size: 8pt">2.&nbsp;</td>
									<td style="font-size: 8pt">
										In addition to the rebate form, submit a copy of your online Costco.com receipt as proof of your purchase,
										and a copy of your carrier service agreement (unless this is an accessory only rebate).
									</td>
								</tr>
								<tr valign="top">
									<td width="25" style="text-align: right; font-size: 8pt">3.&nbsp;</td>
									<td style="font-size: 8pt">
										Your rebate submission must be postmarked before 30 days from the date the order was submitted or we will
										be unable to process your rebate request.
									</td>
								</tr>
								<tr valign="top">
									<td width="25" style="text-align: right; font-size: 8pt">4.&nbsp;</td>
									<td style="font-size: 8pt">
										Make copies of all your receipts and supporting documents for your own records before mailing the forms.
										Please submit multiple rebates individually.
									</td>
								</tr>
								<tr valign="top">
									<td width="25" style="text-align: right; font-size: 8pt">5.&nbsp;</td>
									<td style="font-size: 8pt">
										Please allow 12-16 weeks after Stuart Lee receives your rebate request submission for rebate processing.
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			<cfelse>
				<p style="padding: 10px">No rebates could be found.</p>
			</cfif>
		<cfelse>
			<p style="padding: 10px">Invalid Request</p>
		</cfif>
	</body>
</html>