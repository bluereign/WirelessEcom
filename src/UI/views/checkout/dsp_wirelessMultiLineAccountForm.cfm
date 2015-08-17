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
			} else if(which1.value.length == which1.maxLength)	{
				which2.focus();
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
					alert('Your secret pin must be between 6 to 10 digits in length.');
					$('#txtPin').focus();
				}
			<cfelse>
				else if(document.getElementById('txtPin').value.length != 4)	
				{
					alert('Your secret pin must be 4 digits in length.');
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

		function validateRequiredFields()
		{
			var numList = '';

			<cfloop from="1" to="#ArrayLen(session.cart.getLines())#" index="i">
				<cfoutput>
				numList = numList + <cfif i neq 1>',' +</cfif> document.getElementById('areacode#i#').value + document.getElementById('lnp#i#').value + document.getElementById('lastfour#i#').value
				</cfoutput>
			</cfloop>

			var errorMsg = '';

			if ( $('#billingZip').val() == '' )	{
				errorMsg = 'Billing zip code is required.';
				$('#billingZip').focus();
			}

			if(dedupe_list(numList) != numList)	{
				errorMsg = 'Upgrade numbers must be unique.';
			}

			<cfif request.p.authorizationDisplay eq 'pin'>
				if ( $('#txtPin').val() == '' )	{
					errorMsg = 'PIN is required.\n' + errorMsg;
					$('#txtPin').focus();
				}
				
				<cfif application.model.CheckoutHelper.getCarrier() EQ 299>
					if(document.getElementById('txtPin').value.length < 6 || document.getElementById('txtPin').value.length > 10)	
					{
						errorMsg = 'Your secret pin must be between six and ten digits in length.';
						$('#txtPin').focus();
					}
				<cfelse>
					if(document.getElementById('txtPin').value.length != 4)	
					{
						errorMsg = 'Your secret pin must be four digits in length.';
						$('#txtPin').focus();
					}
				</cfif>
			</cfif>			

			if (errorMsg != '')
			{
				alert( errorMsg );
				return false;
			}
			else
			{
				return true;
			}

			function dedupe_list(mainList)
			{
				var count = 0;
				var mainlist = mainList
				mainlist = mainlist.replace(/\r/gi, ",");
				mainlist = mainlist.replace(/\n+/gi, ",");

				var listvalues = new Array();
				var newlist = new Array();

				listvalues = mainlist.split(",");

				var hash = new Object();

				for (var i=0; i<listvalues.length; i++)
				{
					if (hash[listvalues[i].toLowerCase()] != 1)
					{
						newlist = newlist.concat(listvalues[i]);
						hash[listvalues[i].toLowerCase()] = 1
					}
					else { count++; }
				}
				return newlist;
			}
		}
	</script>
</cfsavecontent>
<cfhtmlhead text="#trim(variables.jsHead)#" />

<cfoutput>
	<form id="processWirelessMultiLineAccountForm" class="cmxform" action="/index.cfm/go/checkout/do/processWirelessMultiLineAccountForm/" method="post">
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
			<p>Please enter the mobile numbers you would like to upgrade.</p>
			<ol>
				<cfloop from="1" to="#ArrayLen(session.cart.getLines())#" index="i">
					<li>
						<label for="txtMdn#i#" class="long">Line #i# Number</label>
						( <input id="areacode#i#" name="areacode#i#" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.areacode' & i)#" class="areacode" maxlength="3" onkeyup="changeNext(this.name, 'lnp#i#')" /> )
						<input id="lnp#i#" name="lnp#i#" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.lnp' & i)#" class="lnp" maxlength="3" onkeyup="changeNext(this.name, 'lastfour#i#')" />
						-
						<input id="lastfour#i#" name="lastfour#i#" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.lastfour' & i)#" class="lastfour" maxlength="4" <cfif i eq ArrayLen(session.cart.getLines())>onkeyup="changeNext(this.name, 'txtPin')"<cfelse>onkeyup="changeNext(this.name, 'areacode#i+1#')"</cfif> />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'mdn' & i))#
					</li>
				</cfloop>
			</ol>
		</fieldset>
		<fieldset>
			<p>Please enter your #application.model.CheckoutHelper.getCarrierName()# account credentials.</p>
			<ol>
				<li>
					<input type="hidden" name="AuthorizationDisplay" value="#request.p.AuthorizationDisplay#" />
					<cfif request.p.authorizationDisplay eq 'pin'>
						<input type="hidden" name="AuthorizationType" value="pin" />

						<cfif application.model.CheckoutHelper.getCarrier() eq 299>
							<label for="txtPin" class="long">PIN (6-10 digits)</label>
						<cfelse>
							<label for="txtPin" class="long">Last 4 of Account Holder SSN</label>
						</cfif>

						<input id="txtPin" name="pin" type="password" value="#application.model.checkoutHelper.formValue('session.checkout.wirelessAccountForm.pin')#" style="margin-left:5px; width:85px;" maxlength="#request.maxpinlength#" />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'pin'))#						
					<cfelseif request.p.authorizationDisplay eq 'SecurityQuestion'>
						<input type="hidden" name="AuthorizationType" value="SecurityQuestion" />
						
						<label for="SecurityQuestionAnswer" class="long">Security Question Answer</label>				
						<input id="SecurityQuestionAnswer" name="SecurityQuestionAnswer" type="text" value="" style="margin-left:5px; width:85px;" maxlength="#request.maxpinlength#" />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'SecurityQuestion'))#						
					<cfelseif request.p.authorizationDisplay eq 'LastFourSsn'>
						<input type="hidden" name="AuthorizationType" value="LastFourSsn" />
						
						<label for="txtPin" class="long">Last 4 of Account Holder SSN</label>
						<input id="LastFourSsn" name="LastFourSsn" type="password" value="" style="margin-left:5px; width:85px;" maxlength="4" />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'LastFourSsn'))#
					</cfif>
				</li>
	          	<cfif ListFind( "42,109", application.model.CheckoutHelper.getCarrier() )>
					<li>
		          	    <label for="billingZip" class="long">Carrier Account Zip Code</label>
		                <input id="billingZip" name="billingZip" value="#application.model.CheckoutHelper.FormValue("session.checkout.wirelessAccountForm.billingZip")#" style="margin-left: 5px" maxlength="5" size="10" />
		                <img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
		                #request.validatorView.ValidationElement(request.validator.getMessages(), 'billingZip')#
					</li>
				</cfif>
				<cfif ListFind( "42", application.model.CheckoutHelper.getCarrier() )>
					<li>
		          	    <label for="accountPassword" class="long">Account PIN/Password (if set up)</label>
		                <input id="accountPassword" name="accountPassword" value="#application.model.CheckoutHelper.FormValue("session.checkout.wirelessAccountForm.accountPassword")#" type="password" style="margin-left:5px" maxlength="16" size="8" />
		           </li>
				</cfif>
			</ol>
		</fieldset>

		<cfif request.config.showServiceCallResultCodes>
			<select name="resultCode" class="resultCode">
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
				<a href="##" onclick="if (validateRequiredFields()) {showProgress('Processing customer lookup, please wait.'); $('##processWirelessMultiLineAccountForm').submit()}">Continue</a>
			</span>
		</div>
		<br />
		<script>document.getElementById('areacode1').focus();</script>
	</form>
	<p>
		We have the highest respect for your privacy; the information you provide will be kept secure.
		For further details, review our <a href="/index.cfm/go/content/do/privacy" target="_blank">Privacy Policy</a>.
	</p>	
</cfoutput>