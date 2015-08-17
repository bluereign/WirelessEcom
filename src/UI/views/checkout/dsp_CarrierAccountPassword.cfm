<cfset GeoService = application.wirebox.getInstance("GeoService") />
<cfset request.p.states = GeoService.getAllStates() />

<cfparam name="showSecurityPasscodeModal" default="false" />

<cfif session.InvalidAccountPasswordAttempts eq 1>
	<cfset showSecurityPasscodeModal = true>
</cfif>

<cfsavecontent variable="jsHead">
	<script>
		function isNumeric(sText)	{
			var validChars = '0123456789';
			var isNumber = true;
			var Char;

			for (i = 0; i < sText.length && isNumber == true; i++)	{
				Char = sText.charAt(i);

				if (validChars.indexOf(Char) == -1)	{
					isNumber = false;
				}
			}

			return isNumber;
		}
	</script>
</cfsavecontent>
<cfhtmlhead text="#trim(variables.jsHead)#" />

<cfoutput>
	<form id="processWirelessAccountForm" class="cmxform" action="/index.cfm/go/checkout/do/processCarrierAccountPassword/" method="post">
		<h1>#application.model.checkoutHelper.getCarrierName()# Wireless Security Passcode</h1>
		<cfoutput>
			<cfif structKeyExists(request, 'validator') and  request.validator.hasMessages()>
				<div class="form-errorsummary">
					#trim(request.validatorView.validationSummary(request.validator.getMessages()))#
				</div>
			</cfif>
		</cfoutput>

		<fieldset>
			<p>Please enter your #application.model.CheckoutHelper.getCarrierName()# security passcode:</p>
			<ol>
				<li>
					<div style="display:none;">
						<cfwindow name="WhatIsSecurityPasscode" center="true" modal="true" width="675" height="280" initshow="#showSecurityPasscodeModal#">
							<div style="padding:10px">
								<h2 style="margin-top:0">What is the #application.model.checkoutHelper.getCarrierName()# Wireless Security Passcode</h2>
								<p>The #application.model.checkoutHelper.getCarrierName()# Wireless Security Passcode (if you have one) provides an extra validation step to further guard your account and personal information. It should be a 4 to 8 digit number.</p>
								<p>If you do not remember your Security Passcode, you can:</p>
								<ol>
									<li>a) Change or Reset it by logging into myAT&T on ATT.com</li>
									<li>b) Call AT&amp;T Customer Service by dialing 611 from your AT&T phone or by calling (800)331-0500.</li>
								</ol>
							</div>
						</cfwindow>
					</div>
	          	    <label for="accountPassword" class="long">Wireless Security Passcode <br><a href="##" onclick="ColdFusion.Window.show('WhatIsSecurityPasscode')">What is this?</a></label>
	                <input id="accountPassword" name="accountPassword" value="#application.model.CheckoutHelper.FormValue("session.checkout.wirelessAccountForm.accountPassword")#" type="password" style="margin-left:5px" maxlength="8" size="15" />
	            </li>
			</ol>
		</fieldset>

		<cfif request.config.showServiceCallResultCodes>
			<select name="resultCode" class="resultCode">
				<option value="CL001">Success Account Password Valid</option>
	            <option value="CL002">Customer not Found</option>
				<option value="CL010">Invalid Request</option>
				<option value="CL011">Unable to Connect to Carrier Service</option>
				<option value="CL012">Service Timeout</option>
				<option value="" selected="selected">Run for Real</option>
			</select>
		</cfif>

		<div class="formControl">
			<span class="actionButton">
				<a href="##" onclick="showProgress('Processing customer lookup, please wait.'); $('##processWirelessAccountForm').submit()">Continue</a>
			</span>
		</div>
		<script>document.getElementById('accountPassword').focus();</script>
	</form>
</cfoutput>
