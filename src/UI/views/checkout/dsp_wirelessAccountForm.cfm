<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset GeoService = application.wirebox.getInstance("GeoService") />
<cfset request.p.states = GeoService.getAllStates() />

<cfsavecontent variable="jsHead">
	<script>
		function changeNext(which1, which2)	{
			var w2 = which2;
			var which1 = document.getElementById(which1);
			var which2 = document.getElementById(which2);

			if(!isNumeric(which1.value))	{
				alert('Please enter a numeric value.');
				which1.focus();
			} else if(which1.value.length == 3 && w2.length > 0)	{
				which2.focus();
			} else if(which1.value.length > 4)	{
				document.getElementById('txtPin').focus();
			}
		}
		function validatePin(which)	{
			var which = document.getElementById(which);

			if(!isNumeric(which.value))	{
				alert('Please enter a numeric value.');
				which.focus();
			} 

		<cfif application.model.CheckoutHelper.getCarrier() EQ 299>
		
			else if(document.getElementById('txtPin').value.length < 6 || document.getElementById('txtPin').value.length > 10)	
			{
				alert('Your secret pin must be between six and ten digits in length.');
				$('#txtPin').focus();
			}
		<cfelse>
			else if(document.getElementById('txtPin').value.length != 4)	
			{
				alert('Your secret pin must be four digits in length.');
				$('#txtPin').focus();
			}			
		</cfif>
	

		}
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
	<form id="processWirelessAccountForm" class="cmxform" action="/index.cfm/go/checkout/do/processWirelessAccountForm/" method="post">
		<h1>#application.model.CheckoutHelper.getCarrierName()# Account Lookup</h1>
		<cfoutput>
			<cfif structKeyExists(request, 'validator') and  request.validator.hasMessages()>
				<div class="form-errorsummary">
					#trim(request.validatorView.validationSummary(request.validator.getMessages()))#
				</div>
			<cfelseif StructKeyExists(request.p, 'AuthorizationType') && request.p.authorizationDisplay eq 'pin'>
				<div class="form-errorsummary">
					<p><span>Your secret PIN was invalid. Please try again.</span></p>
					<br />
				</div>				
			<cfelseif StructKeyExists(request.p, 'AuthorizationType') && request.p.authorizationDisplay eq 'SecurityQuestion'>
				<div class="form-errorsummary">
					<p><span>Your secret PIN was invalid. Please answer the account security question below.</span></p>
					<ul><li>#request.p.securityQuestion#</li></ul>
					<br />
				</div>
			<cfelseif StructKeyExists(request.p, 'AuthorizationType') && request.p.authorizationDisplay eq 'LastFourSsn'>	
				<div class="form-errorsummary"><span>Your look up attempt was invalid. Please enter the last four digits of your SSN.</span><br /></div>
			</cfif>
		</cfoutput>

		<fieldset>
			<cfif session.cart.getActivationType() CONTAINS 'upgrade'>
				<p>Please enter the number you would like to upgrade.</p>
			<cfelse>	
				<p>Please enter a wireless number from your existing account.</p>
			</cfif>
			<ol>
				<li>
					<cfif session.cart.getActivationType() CONTAINS 'upgrade'>
						<label for="txtMdn" class="long">Mobile Number to Upgrade <strong>*</strong></label>
					<cfelse>	
						<label for="txtMdn" class="long">Mobile Number <strong>*</strong></label>
					</cfif>
					( <input id="areacode" name="areacode" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.areacode')#" class="areacode" maxlength="3" onkeyup="changeNext(this.name, 'lnp')" tabindex="1" /> )
					<input id="lnp" name="lnp" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.lnp')#" class="lnp" maxlength="3" onkeyup="changeNext(this.name, 'lastfour')" tabindex="2" />
					-
					<input id="lastfour" name="lastfour" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.lastfour')#" class="lastfour" maxlength="4" onkeyup="changeNext(this.name, '')" tabindex="3" />
					#trim(request.validatorView.validationElement(request.validator.getMessages(), 'mdn'))#
				</li>
				<li>
					<input type="hidden" name="AuthorizationDisplay" value="#request.p.AuthorizationDisplay#" />
					<cfif request.p.authorizationDisplay eq 'pin'>
						<input type="hidden" name="AuthorizationType" value="pin" />
						
						<cfif application.model.CheckoutHelper.getCarrier() eq 299>
							<div style="display:none;">
								<cfwindow name="WhatIsSprintPIN" center="true" modal="true" width="550" height="320">
									<div style="padding:10px">
										<h2 style="margin-top:0">What is the Sprint Account PIN?</h2>
										<p>The Account PIN is a personal identification number used by Sprint to verify access to your account.</p>
										<p>Your PIN can be any combination of 6 to 10 digits, except all zeros.</p>
										<p>If you do not remember your PIN, you can get it by:</p>
										<ol>
											<li>a) Signing on to sprint.com and selecting My Preferences &gt; Update account PIN.</li>
											<li>b) Calling Sprint Customer Care by dialing *2 from  your Sprint phone or by calling (888)221-4727</li>
										</ol>
										<p><strong>Note:</strong> After the second incorrect pin attempt you will be asked to answer the security question that may be set up on your account with Sprint.  If you do not have a security question set up for your account then you will be asked for the last four digits of the account holder's social security number.  For your security, after a combination of 3 unsuccessful attempts Sprint will lock your account.  If this occurs, please call Sprint Customer Care to unlock your account and request your PIN.</p>
									</div>
								</cfwindow>
							</div>
							<label for="txtPin" class="long">PIN (6-10 digits) <a href="##" onclick="ColdFusion.Window.show('WhatIsSprintPIN')">What is this?</a> <strong>*</strong></label>
						<cfelse>
							<div style="display:none;">
								<cfwindow name="whyAskForSSN" center="true" modal="true" height="240">
									<div style="padding:10px">
										<h2 style="margin-top:0">Why do we ask for Primary Account Holder's SSN?</h2>
										<p>Your wireless carrier uses the last four digits of the primary account holder's Social Security number to authenticate you.</p>
									</div>
								</cfwindow>
							</div>
							<label for="txtPin" class="long" style="margin-top:0;">Primary Account Holder's Social Security Number (last 4 digits) <a href="##" onclick="ColdFusion.Window.show('whyAskForSSN')">Why?</a> <strong>*</strong></label>
						</cfif>
						
						<input id="txtPin" name="pin" type="password" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.pin')#" style="margin-left:5px; width:85px;" maxlength="#request.maxpinlength#"  tabindex="5"/>
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'pin'))#						
					<cfelseif request.p.authorizationDisplay eq 'SecurityQuestion'>
						<input type="hidden" name="AuthorizationType" value="SecurityQuestion" />
						
						<label for="SecurityQuestionAnswer" class="long">Security Question Answer</label>				
						<input id="SecurityQuestionAnswer" name="SecurityQuestionAnswer" type="text" value="" style="margin-left:5px; width:85px;" maxlength="#request.maxpinlength#"  tabindex="6" />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'SecurityQuestion'))#						
					<cfelseif request.p.authorizationDisplay eq 'LastFourSsn'>
						<input type="hidden" name="AuthorizationType" value="LastFourSsn" />
						
						<label for="txtPin" class="long">Last 4 of Account Holder SSN</label>
						<input id="LastFourSsn" name="LastFourSsn" type="password" value="" style="margin-left:5px; width:85px;" maxlength="4"  tabindex="7" />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'LastFourSsn'))#
					</cfif>
				</li>
				
	          	<cfif ListFind( "42,109", application.model.CheckoutHelper.getCarrier() )>
					<li>
		          	    <label for="billingZip" class="long">Billing Zip Code <strong>*</strong></label>
		                <input id="billingZip" name="billingZip" value="#application.model.CheckoutHelper.FormValue("session.checkout.wirelessAccountForm.billingZip")#" style="margin-left: 5px" maxlength="5" size="10"  tabindex="8" />
		                #request.validatorView.ValidationElement(request.validator.getMessages(), 'billingZip')#
					</li>
				</cfif>
				<cfif ListFind( "42", application.model.CheckoutHelper.getCarrier() )>
					<li>
						<div style="display:none;">
							<cfwindow name="WhatIsBillingPassword" center="true" modal="true" height="350">
								<div style="padding:10px">
									<h2 style="margin-top:0">What is the Billing Password?</h2>
									<p>The Billing Password (if you have one) is an additional way to validate you on Verizon Wireless and is different from the password used to log into verizonwirelesss.com.  It should be 4-5 characters using any combination of letters and/or numbers. It is not case sensitive.  This is the password you verbally verify if you call the Verizon Wireless customer service department.  Also called Billing System Password.</p>
									<p>If you do not remember your Billing Password, you can contact Verizon Customer Service by dialing *611 from your Verizon phone or by calling (800)922-0204.</p>
								</div>
							</cfwindow>
						</div>
		          	    <label for="accountPassword" class="long">Billing Password <a href="##" onclick="ColdFusion.Window.show('WhatIsBillingPassword')">What is this?</a></label>
		                <input id="accountPassword" name="accountPassword" value="#application.model.CheckoutHelper.FormValue("session.checkout.wirelessAccountForm.accountPassword")#" type="password" style="margin-left:5px" maxlength="16" size="8"  tabindex="9"/>
		            </li>
				</cfif>
			</ol>
		</fieldset>

		<cfif request.config.showServiceCallResultCodes>
			<select name="resultCode" class="resultCode"  tabindex="10">
				<option value="CL001">Success Customer Found</option>
				<option value="CL001-B">Success Customer Found - No Add-a-Line Available</option>
				<option value="CL001-C">Success Customer Found - Not Upgrade Eligible</option>
				<option value="CL001-D">Success Customer Found - On Family Plan but Service says Individual</option>
				<option value="CL001-E">Success Customer Found - Account Password Required</option>
	            <option value="CL002">Customer not Found</option>
				<option value="CL010">Invalid Request</option>
				<option value="CL011">Unable to Connect to Carrier Service</option>
				<option value="CL012">Service Timeout</option>
				<option value="" selected="selected">Run for Real</option>
			</select>
		</cfif>

		<div class="formControl">
			<span class="actionButton">
				<a href="##" onclick="showProgress('Processing customer lookup, please wait.'); $('##processWirelessAccountForm').submit()"  tabindex="11">Continue</a>
			</span>
		</div>
		<br />
		<script>document.getElementById('areacode').focus();</script>
	</form>
	<p>
		We have the highest respect for your privacy; the information you provide will be kept secure.
		For further details, review our <a href="/index.cfm/go/content/do/privacy" target="_blank">Privacy Policy</a>.
	</p>	
</cfoutput>
