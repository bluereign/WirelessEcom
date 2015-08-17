<cfset request.p.header = 'Technical Difficulties' />
<cfset request.p.message = '' />
<cfset textDisplayRenderer = application.wirebox.getInstance('TextDisplayRenderer') />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<cfparam name="url.code" default="" type="string" />
<cfparam name="url.errorMessage" default="" type="string" />

<cftry>
	<cfset url.errorMessage = session.checkout.creditCheckResult.getErrorMessage() />

	<cfcatch type="any">
		<cfset url.errorMessage = cfcatch.message />
	</cfcatch>
</cftry>

<cfswitch expression="#trim(url.code)#">
	<cfcase value="01">

	</cfcase>
	<cfcase value="50">
		<cfsavecontent variable="request.p.message">
			<p>
				The wireless carrier you selected has been temporarily disabled.
				Please check back at a later time.
			</p>
		</cfsavecontent>

		<cfset request.p.header = 'Important!' />
	</cfcase>
	<cfcase value="51">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					The order you have attempted to view does not belong to this account.
					Please contact Customer Service at #channelConfig.getCustomerCarePhone()# to review.
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Invalid Order Number' />
	</cfcase>
	<cfcase value="55">
		<cfset carrierName = application.model.Carrier.getCarrierNameById( session.cart.getCarrierId() ) />
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					<cfif len(carrierName)>#carrierName#<cfelse>Carrier</cfif> is unavailable due to technical difficulties. Please check back at a later time to 
					complete your order or call Customer Service at #channelConfig.getCustomerCarePhone()#.  Thank you
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Technical Difficulties' />
	</cfcase>	
	<cfcase value="300">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					We need to gather additional information in order to process
					your order. Please contact Customer Service at
					#channelConfig.getCustomerCarePhone()# to review.
				</p>
				<p>[Message: Records indicate that this is an existing account.]</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Additional Information Required' />
	</cfcase>
	<cfcase value="301">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					There were problems processing your credit request, please contact
					Customer Service at #channelConfig.getCustomerCarePhone()# so we
					may assist you with your order.
					<br />
					#url.errorMessage#
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Additional Information Required' />
	</cfcase>
	<cfcase value="102">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					There were problems processing your credit request, please contact
					Customer Service at #channelConfig.getCustomerCarePhone()# so we
					may assist you with your order.
					<br />
					#url.errorMessage#
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Additional Information Required' />
	</cfcase>
	<cfcase value="401">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>We were unable to locate your account based on the mobile number and pin provided.</p>
				<p><strong>Please click the back button to verify you entered the correct information.</strong></p>
				<p>If you are still receiving this error, please contact Customer Service at #channelConfig.getCustomerCarePhone()# so we may assist you with your order.</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Unable to Lookup Account' />
	</cfcase>

	<cfcase value="402">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>Unfortunately, at this time your existing carrier account type is not supported by this website.<br />Please visit your local #textDisplayRenderer.getKioskName()# or contact your carrier for further assistance.</p>
				<p>We can not guarantee that your account type can be supported by the #textDisplayRenderer.getKioskName()#.</p>
			</cfoutput>
		</cfsavecontent>

		<cfset requst.p.header = 'Unsupported Account Type' />
	</cfcase>

	<cfcase value="320">
		<cfset request.p.header = 'Service not approved' />
		
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					<cfif application.model.checkoutHelper.getCheckoutType() eq 'add' && application.model.checkoutHelper.getLinesActive() gt 0>
						At this time #application.model.checkoutHelper.getCarrierName()# is reporting that you have <b>#application.model.checkoutHelper.getLinesActive()#</b> active lines, 
						and that you are approved for <b>#application.model.checkoutHelper.getLinesApproved()#</b> additional lines. Your request for <b>#application.model.checkoutHelper.getNumberOfLines()#</b> additional lines would cause your account to 
						exceed the approved number of lines.  Please reduce the number of lines in your request or choose from our great
						assortment of <a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/">Prepaid handsets</a>.
					<cfelse>
						We're sorry, based on the information provided you are not approved for service at this time. 
						<cfif channelConfig.getDisplayPrepaidDevices()>
							As an alternative, please check out our selection of <a href="/index.cfm/go/shop/do/browsePrePaids/prePaidFilter.submit/1/filter.filterOptions/0/">Prepaid handsets</a>!
						</cfif>
					</cfif>

					<br />
					#url.errorMessage#
				</p>
			</cfoutput>
		</cfsavecontent>
	</cfcase>

	<cfcase value="321">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					Based on the information provided, it appears that you are not eligible for a wireless device upgrade through Wireless Advocates at this time. 
					Wireless Advocates can only process upgrades for lines of service that have fulfilled their 24 month carrier agreement.
				</p>				
				<cfswitch expression="#session.cart.getCarrierId()#">
					<cfcase value="42">
						<p>
							Please ensure that the account credentials that you entered are correct (e.g. The mobile number entered is the wireless number 
							eligible for upgrade, the secret pin entered is the last 4 digits of the primary account holder's social security number, and the 
							billing zip code entered matches the zip code on file with your wireless provider). If you have a Verizon Billing Password on your 
							account please enter the 4-5 digit password in the Account Password field.
						</p>
					</cfcase>
					<cfcase value="109">
						<p>
							Please ensure that the account credentials that you entered are correct (e.g. The mobile number entered is the wireless number eligible 
							for upgrade, the secret pin entered is the last 4 digits of the primary account holder's social security number, and the billing zip code 
							entered matches the zip code on file with your wireless provider).
						</p>
					</cfcase>
					<cfcase value="128">
						<p>
							Please ensure that the account credentials that you entered are correct (e.g. The mobile number entered is the wireless number eligible 
							for upgrade, the secret pin entered is the last 4 digits of the primary account holder's social security number, and the billing zip code 
							entered matches the zip code on file with your wireless provider).
						</p>
					</cfcase>
					<cfcase value="299">
						<p>
							Please ensure that the account credentials that you entered are correct (e.g. The mobile number entered is the wireless number 
							eligible for upgrade, the secret pin entered is the 6-10 digit password assigned to your wireless account, and the billing zip code 
							entered matches the zip code on file with your wireless provider).  
						</p>
					</cfcase>
					<cfdefaultcase>
						<p>
							Please ensure that the account credentials that you entered are correct (e.g. The mobile number entered is the wireless number 
							eligible for upgrade, the secret pin entered is the pin of the primary account holder's social security number, and the billing 
							zip code entered matches the zip code on file with your wireless provider).  
						</p>
					</cfdefaultcase>															
				</cfswitch>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Please Contact Customer Service' />
	</cfcase>
	<cfcase value="322">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					Based on the account information provided, it appears that you do not have a
					family plan with your carrier. Your current cart has a family add a line plan
					selected. There are a few ways to resolve this issue:
				</p>
				<p>1. Please contact Customer Service at #channelConfig.getCustomerCarePhone()# to review your order.</p>
				<p>2. Contact your carrier's customer service department to verify your current plan type.</p>
				<p>3. Clear <a href="/index.cfm/go/cart/do/view/">your cart</a> and select an individual family plan upgrade.</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Please Contact Customer Service' />
	</cfcase>
	
	<cfcase value="323">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					We are unable to verify the account password you have entered. Please call AT&T Customer Service (1-800-331-0500) for further assistance.
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Invalid Account Password' />
	</cfcase>

	<cfcase value="324">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					You are attempting to add #url.sm# smart phone<cfif url.sm neq 1>s</cfif> to your current plan. 
					You currently have #url.used# smart phone<cfif url.used neq 1>s</cfif> on a plan with a cap of #url.cap#.
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Smart phone device cap exceeded' />
	</cfcase>
	
	<cfcase value="325">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					You are attempting to add mobile broad band device that is incompatible with your current rate plan.
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Incompatible Device' />
	</cfcase>

	<cfcase value="326">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					Your account has been locked for 24 hours due to too many attempts with incorrect security information.  We cannot process 
					your purchase request while your account is locked.  Please contact Sprint Customer Care to verify your 6 to 10 digit account 
					PIN and try again in 24 hours.
				</p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Account Locked' />
	</cfcase>

	<cfcase value="327">
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>The device you are upgrading for #Left(request.p.mdn, 3)#-#Mid(request.p.mdn, 4, 3)#-#Right(request.p.mdn , 4)# must be a compatible #URLDecode(request.p.CurrentDeviceFamily)# device. </p>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Incompatible Device Upgrade' />
	</cfcase>

	<cfcase value="cartValidation">
		<cfparam name="cartValidationResponse" default="#application.model.cartHelper.validateCartForCheckout()#" />

		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					The following error(s) were encountered while attempting to validate
					your cart for checkout.
					<ul class="disc">
						<cfset errorLIs = cartValidationResponse.renderErrorLIs() />
						#trim(variables.errorLIs)#
					</ul>
				</p>
				<p>
					Please <a href="/index.cfm/go/cart/do/view/">correct these issues</a> before
					proceeding with Checkout.
				</p>

				<cfif request.config.allowCartValidationBypass>
					<p style="text-align: right"><input type="button" value="Bypass Cart Validation" onclick="location.href = '/index.cfm/go/checkout/do/startCheckout/bypassCartValidation/1/'" /></p>
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfset request.p.header = 'Invalid Cart' />
	</cfcase>

	<cfdefaultcase>
		<cfsavecontent variable="request.p.message">
			<cfoutput>
				<p>
					We are currently experiencing technical difficulties. So that we may help
					process your order, please call customer service at
					#channelConfig.getCustomerCarePhone()# to continue your order.
				</p>
			</cfoutput>
		</cfsavecontent>
	</cfdefaultcase>
</cfswitch>

<cfsavecontent variable="errorOutput">
	<cfoutput>
		<h2>#trim(request.p.header)#</h2>
		<div>#trim(request.p.message)#</div>
		<div>
			<cfif structKeyExists(url, 'code') and len(trim(url.code))>
				<p>Customer Service Error Code: #trim(url.code)#</p>
			</cfif>
			<!---
			<cfif len(trim(url.errorMessage))>
				<p style="font-size: 8pt">#trim(url.errorMessage)#</p>
			</cfif>
			--->
		</div>
	</cfoutput>
</cfsavecontent>

<cfoutput>#trim(variables.errorOutput)#</cfoutput>

<!---
<cfif structKeyExists(application, 'errorEmailList') and len(trim(application.errorEmailList)) and structKeyExists(application, 'errorFromAddress') and len(trim(application.errorFromAddress))>
	<cfmail to="#trim(application.errorEmailList)#" from="#trim(application.errorFromAddress)#" subject="WA-Online Checkout Error" type="html">
		#trim(variables.errorOutput)#
		<br />
		<cfdump var="#request.p#" expand="true" />
	
		<cfif structKeyExists(session, 'cart')>
			<br />
			<cfset cartLines = session.cart.getLines() />
	
			<cfloop from="1" to="#arrayLen(session.cart.getLines())#" index="idx">
				<cfset cartLine = variables.cartLines[idx] />
	
				<cfdump var="#variables.cartLine#" expand="true" />
				<br />
			</cfloop>
		</cfif>
	</cfmail>
</cfif>
--->


<cfif len(trim(url.code)) and trim(url.code) is 'AV999'>
	<cfmail to="#trim(application.bannedUserEmailList)#" from="#trim(application.errorFromAddress)#" server="#application.AlternativeSmtpServer#" subject="WA-Online Banned User (#SERVER_NAME#)" type="html">
		Sent from #SERVER_NAME#
		
		#trim(variables.errorOutput)#
		
		<cfif structKeyExists(session, 'bannedUser')>
			<br />
			<cfdump var="#session.bannedUser#" expand="true" />
		</cfif>
	</cfmail>
</cfif>