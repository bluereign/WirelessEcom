<!--- Get the NPAs by zipcode, return empty array if it fails. --->
<cfparam name="request.p.npaList" default="#arraynew(1)#" type="array" />
<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset nameOfChannel = application.wirebox.getInstance("TextDisplayRenderer").GetBusinessName() />

<cfsavecontent variable="jsHead">
	<cfoutput>
		<script language="javascript" type="text/javascript">
			function toggleActive(on, off, el)	{
				var els = Ext.get(on).query('input,select');

				for(var i = 0; i < els.length; i++)	{
					Ext.get(els[i]).dom.removeAttribute('disabled');
				}

				var els = Ext.get(off).query('input,select');

				for(var i = 0; i < els.length; i++)	{
					Ext.get(els[i]).set({disabled: "disabled"});
				}

				var idName = el.id.split('_');
					idName = idName[0];

				var idRow = el.id.split('_');
					idRow = idRow[1];

				if(idName == 'newNumber')	{
					document.getElementById('areacode' + idRow).value = '';
					document.getElementById('lnp' + idRow).value = '';
					document.getElementById('lastfour' + idRow).value = '';
					document.getElementById('portInCurrentCarrier' + idRow).selectedIndex = 0;
					document.getElementById('portInCurrentCarrierPin' + idRow).value = '';
					document.getElementById('txtNewNumber_' + idRow).selectedIndex = 1;
				} else {
					document.getElementById('txtNewNumber_' + idRow).selectedIndex = 0;
				}
			}

			var sameNumbers = Ext.query(".sameNumber");

			for(var i = 0; i < sameNumbers.length; i++)	{
				if(sameNumbers[i].checked)	{
					toggleActive('lnpPhone_' + (i + 1),'lnpAreaCode_' + (i+1), null);
				} else {
					toggleActive('lnpAreaCode_' + (i + 1),'lnpPhone_' + (i+1), null);
				}
			}

			function validateForm()	{
				if(1 == 2)	{
				<cfloop from="1" to="#application.model.checkoutHelper.getNumberOfLines()#" index="i">
				} else if (document.getElementById('sameNumber_#i#').checked && document.getElementById('areacode#i#').value.length != 3)	{
					alert('Please enter your area code for line #i#.');
					document.getElementById('areacode#i#').focus();
					return false;
				} else if (document.getElementById('sameNumber_#i#').checked && document.getElementById('lnp#i#').value.length != 3)	{
					alert('Please enter your telephone number prefix for line #i#.');
					document.getElementById('lnp#i#').focus();
					return false;
				} else if (document.getElementById('sameNumber_#i#').checked && document.getElementById('lastfour#i#').value.length != 4)	{
					alert('Please enter your telephone number suffix for line #i#.');
					document.getElementById('lastfour#i#').focus();
					return false;
				} else if (document.getElementById('sameNumber_#i#').checked && document.getElementById('portInCurrentCarrier#i#').selectedIndex == 0)	{
					alert('Please select your existing carrier for line #i#.');
					document.getElementById('portInCurrentCarrier#i#').focus();
					return false;
					
				} else if (document.getElementById('sameNumber_#i#').checked && !validatePin( 'portInCurrentCarrierPin#i#', 'portInCurrentCarrier#i#' ))	{
					document.getElementById('portInCurrentCarrierPin#i#').focus();
					return false;	
				} else if (document.getElementById('sameNumber_#i#').checked && document.getElementById('portInCurrentCarrier#i#').selectedIndex > 3 && document.getElementById('portInCurrentCarrierAccountNumber#i#').value.length == 0)	{
					if(confirm('Failing to enter an existing Carrier Account number will result in a new phone number being assigned.\nTo port your existing phone number, you will have to contact your carrier after receiving your order.'))	{
						showProgress('Checking for availability, please wait.');
						$('##lnp').submit();
						return true;
					} else {
						document.getElementById('portInCurrentCarrierAccountNumber#i#').focus();
						return false;
					}
				} else if(document.getElementById('newNumber_#i#').checked && document.getElementById('txtNewNumber_#i#').selectedIndex == 0)	{
					alert('Please choose an area code for your new wireless number for line #i#.');
					document.getElementById('txtNewNumber_#i#').focus();
					return false;
				</cfloop>

				} else {
					showProgress('Checking for availability, please wait.');
					$('##lnp').submit();
					return true;
				}
			}
			
			function changeNext(which1, which2, lastFocusTo, lastFocusToType)	{
				var w2 = which2;
				var which1 = document.getElementById(which1);
				var which2 = document.getElementById(which2);

				if (!isNumeric(which1.value))	{
					alert('Please enter a numeric value.');
					which1.focus();
				}
				else if (which1.value.length == 3 && w2.length > 0)
				{
					which2.focus();
				}
				else if (which1.value.length == 4 && lastFocusTo.length > 0)
				{
					if (lastFocusToType == 'select')	{
						document.getElementById(lastFocusTo).enabled = true;
						document.getElementById(lastFocusTo).focus();
					} else {
						document.getElementById(lastFocusTo).focus();
					}
				}
			}
			
			function validatePin( portInPinId, portInCarrierId ) {
				var isValid = true;
				var portInPin = document.getElementById( portInPinId ).value;
				var carrier = document.getElementById( portInCarrierId ).value;

				if ( carrier == 'Verizon Wireless' || carrier == 'AT&T' || carrier == 'T-Mobile' )
				{
					if( !isNumeric(portInPin) || portInPin.length != 4 )	
					{
						isValid = false;
						alert('Pin must be 4 digits');
					}
				}
				else if ( carrier == 'Sprint' )
				{
					if( !isNumeric(portInPin) || (portInPin.length < 6 || portInPin.length > 10) )	
					{
						isValid = false;
						alert('Pin must be 6 to 10 digits');
					}
				}
				
				return isValid;
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
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#trim(variables.jsHead)#" />

<!--- Create carrier port-in list --->
<cfscript>
	switch (session.cart.getCarrierId())
	{
		case '42':
			carrierList = 'AT&amp;T,T-Mobile,Sprint,Alltel Wireless,Amp''d Mobile,Boost Mobile,Cellular One,Cricket Communications,Nextel,Virgin Mobile USA,OTHER';
			break;
		case '109':
			carrierList = 'T-Mobile,Verizon Wireless,Sprint,Alltel Wireless,Amp''d Mobile,Boost Mobile,Cellular One,Cricket Communications,Nextel,Virgin Mobile USA,OTHER';
			break;
		case '128':
			carrierList = 'AT&amp;T,Verizon Wireless,Sprint,Alltel Wireless,Amp''d Mobile,Boost Mobile,Cellular One,Cricket Communications,Nextel,Virgin Mobile USA,OTHER';
			break;
		case '299':
			carrierList = 'AT&amp;T,T-Mobile,Verizon Wireless,Alltel Wireless,Amp''d Mobile,Boost Mobile,Cellular One,Cricket Communications,Nextel,Virgin Mobile USA,OTHER';
			break;									
		default:
			carrierList = 'AT&amp;T,T-Mobile,Verizon Wireless,Sprint,Alltel Wireless,Amp''d Mobile,Boost Mobile,Cellular One,Cricket Communications,Nextel,Virgin Mobile USA,OTHER';
			break;
	}
</cfscript>

<form id="lnp" class="cmxform" action="/index.cfm/go/checkout/do/processlnpRequest/" method="post">
	<cfif application.model.checkoutHelper.getNumberOfLines() gt 1>
		<h1>Keep Your Current Numbers?</h1>
	<cfelse>
		<h1>Keep Your Current Number?</h1>
	</cfif>

	<cfif application.model.checkoutHelper.getNumberOfLines() gt 1>
		<p>
			If you would like to keep your existing wireless numbers,
			please enter them in the field below. Otherwise, select I
			would like a new number for each line.
		</p>
	<cfelse>
		<p>
			If you would like to keep your existing wireless number,
			please enter it in the field below. Otherwise, select I
			would like a new number.
		</p>
	</cfif>

	<cfoutput>
		<cfif structKeyExists(request, 'validator') and  request.validator.hasMessages()>
			<div class="form-errorsummary">
				#trim(request.validatorView.validationSummary(request.validator.getMessages()))#
			</div>
		</cfif>
	</cfoutput>

	<cfoutput>
		<cfset request.p.cartLines = session.cart.getLines() />

		<cfloop from="1" to="#application.model.checkoutHelper.getNumberOfLines()#" index="i">
			<cfparam name="request.p.selection#i#" default="port" />
			<cfparam name="request.p.numberToPort#i#" default="" />
			<cfparam name="request.p.newAreaCode#i#" default="" />

			<cfset request.p.cartLine = request.p.cartLines[i] />

			<div style="margin-bottom: 2em">
				<fieldset>
					<span class="title">Line #i# <cfif len(request.p.cartLine.getAlias()) gt 0> : #request.p.cartLine.getAlias()#</cfif></span>
					<ol>
						<!--- Modified on 02/09/2015 by Denard Springle (denard.springle@cfwebtools.com) --->
						<!--- Track #: 7196 - PageMaster: Cart Review Default [ Switch order and default selection for PageMaster ] --->

						<!--- save the first original list item (port) as a variable --->
						<cfsavecontent variable="portHTML">
						<li class="full">
							<input type="radio" name="selection#i#" class="btnLine sameNumber" value="port" onclick="toggleActive('lnpPhone_#i#', 'lnpAreaCode_#i#', this);" id="sameNumber_#i#"<cfif request.p['selection' & i] is 'port' AND nameOfChannel is not "Pagemaster"> checked="checked"</cfif> />
							<label for="sameNumber_#i#" class="check">Keep an existing wireless number for this line.</label>
							<ol id="lnpPhone_#i#">
								<li>
									( <input id="areacode#i#" name="areacode#i#" value="#application.model.checkoutHelper.formValue('session.checkout.mdnForm.areacode#i#')#" class="areacode" maxlength="3" onkeyup="changeNext(this.name, 'lnp#i#', '', '')" /> )
									<input id="lnp#i#" name="lnp#i#" value="#application.model.checkoutHelper.formValue('session.checkout.mdnForm.lnp#i#')#" class="lnp" maxlength="3" onkeyup="changeNext(this.name, 'lastfour#i#', '', '')" />
									<input id="lastfour#i#" name="lastfour#i#" value="#application.model.checkoutHelper.formValue('session.checkout.mdnForm.lastfour#i#')#" class="lastfour" maxlength="4" onkeyup="changeNext(this.name, '', 'portInCurrentCarrier#i#', 'select')" />
									<a class="infoTip" title="Enter the number of your current wireless line. On successful activation, we will transfer this number to your new phone & plan."></a>
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'errorLnpPhone_#i#'))#
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'errorInvalidPortIn_#i#', 'Review number'))#
								</li>
								<li>
									<div>
										<ul>
											<li>
												Existing Carrier
												<br />
												<select id="portInCurrentCarrier#i#" name="portInCurrentCarrier#i#">
													<option value="">Select Existing Carrier</option>
													<cfloop list="#trim(variables.carrierList)#" index="p">
														<cfset selected = '' />

														<cfif application.model.checkoutHelper.formValue('session.checkout.mdnForm.portInCurrentCarrier#i#') is p>
															<cfset selected = 'selected' />
														</cfif>

														<option value="#trim(variables.p)#" #trim(variables.selected)#>#trim(variables.p)#</option>
													</cfloop>
												</select>
												<a class="infoTip" title="Select the carrier this mobile number is currently associated with."></a>
												#trim(request.validatorView.validationElement(request.validator.getMessages(), 'errorCurrentCarrier_#i#'))#
											</li>
											<li id="extAccNum#i#">
												Existing Carrier Account Number
												<br />
												<input type="text" maxlength="49" value="#application.model.checkoutHelper.formValue('session.checkout.mdnForm.portInCurrentCarrierAccountNumber#i#')#" name="portInCurrentCarrierAccountNumber#i#" id="portInCurrentCarrierAccountNumber#i#" />
												<a class="infoTip" title="The Billing Account Number for the current carrier of this mobile number. Failure to provide accurate information may result in a new number being assigned"></a>
												#trim(request.validatorView.validationElement(request.validator.getMessages(), 'errorCurrentCarrierAccountNumber_#i#'))#
											</li>
											<li>
												Existing Carrier Pin
												<br />
												<input type="password" class="pin" maxlength="10" value="#application.model.checkoutHelper.formValue('session.checkout.mdnForm.portInCurrentCarrierPin#i#')#" name="portInCurrentCarrierPin#i#" id="portInCurrentCarrierPin#i#" />
												<a class="infoTip" title="This is usually the last 4 digits of the account owner's social security number."></a>
												#trim(request.validatorView.validationElement(request.validator.getMessages(), 'errorCurrentCarrierPin_#i#'))#
											</li>
										</ul>
									</div>
								</li>
							</ol>
						</li>
						</cfsavecontent>
						<!--- save the second original list item (newLine) as a variable --->
						<cfsavecontent variable="newLineHTML">							
						<li class="full">
							<input type="radio" name="selection#i#" class="btnLine newNumber" onclick="toggleActive('lnpAreaCode_#i#', 'lnpPhone_#i#', this);" value="newLine" id="newNumber_#i#"<cfif request.p['selection' & i] is 'newLine' OR nameOfChannel is "Pagemaster"> checked="checked"</cfif> />
							<label for="newNumber_#i#" class="check">I would like a new wireless number.</label>
							<ol id="lnpAreaCode_#i#">
								<li>
									<label>Select the desired area code for your new number:</label>
									<div>
										<select name="newAreaCode#i#" id="txtNewNumber_#i#">
											<option></option>

											<cfset request.p.selected = '' />

											<cfif arrayLen(request.p.npaList)>
												<cfloop from="1" to="#arrayLen(request.p.npaList)#" index="request.p.i">
													<cfif isDefined('session.checkout.mdnForm.newAreaCode#i#') and request.p.npaList[request.p.i] eq evaluate('session.checkout.mdnForm.newAreaCode#i#')>
														<cfset request.p.selected = 'selected' />
													<cfelse>
														<cfset request.p.selected = '' />
													</cfif>

													<cfoutput>
														<cfif application.model.checkoutHelper.getCarrier() eq 42>
															<option #request.p.selected# value="#request.p.npaList[request.p.i]#">(#Left(request.p.npaList[request.p.i], 3)#) #Right(request.p.npaList[request.p.i], 3)#</option>
														<cfelse>
															<option #request.p.selected# value="#request.p.npaList[request.p.i]#">#request.p.npaList[request.p.i]#</option>
														</cfif>
													</cfoutput>
												</cfloop>
											<cfelse>
												<cflocation url="/index.cfm/go/checkout/do/error/" addtoken="false" />
											</cfif>
										</select> * <a class="infoTip" title="Use this option if you would like to receive a new number. A new number will be created for you by the wireless carrier."></a>
										#trim(request.validatorView.validationElement(request.validator.getMessages(), 'errorAreaCode_#i#'))#
									</div>
								</li>
							</ol>
						</li>
						</cfsavecontent>

						<!--- determine if we're in the pagemaster channel --->
						<cfif nameOfChannel is "Pagemaster">	
							<!--- we are, show the new line list item first and the port list item second --->
							#newLineHTML#
							#portHTML#
						<cfelse>
							<!--- we are not in pagemaster, display port list item first and new line list item second as originally intended --->
							#portHTML#
							#newLineHTML#
						</cfif>

					</ol>
				</fieldset>
			</div>
		</cfloop>
	</cfoutput>

	<cfif request.config.showServiceCallResultCodes>
		<select name="resultCode" class="resultCode">
			<option value="PI001">Success</option>
			<option value="PI002">Port in denied for 1 or more MDN in list</option>
			<option value="PI010">Invalid Request</option>
			<option value="PI011">Unable to Connect to Carrier Service</option>
			<option value="PI012">Service Timeout</option>
			<option value="" selected="selected">Run for Real</option>
		</select>
	</cfif>

	<div class="formControl">
		<span class="actionButtonLow">
			<a href="##" onclick="window.location.href='/index.cfm/go/cart/do/view/'">Back</a>
		</span>
		<span class="actionButton">
			<a href="##" onclick="validateForm()">Continue</a>
		</span>
	</div>

	<cfif arrayLen(request.p.npaList)>
		<p style="font-size: 8pt;">
			<img src="<cfoutput>#assetPaths.common#</cfoutput>images/ui/1285180071_information.png" align="texttop" />
			Area code options are based on the zip code (<strong><cfoutput>#session.cart.getZipcode()#</cfoutput></strong>) you entered while shopping.
		</p>
			<!--- Wording provided by Verizon Legal Team --->
		<p style="font-size: 8pt;">
			<cfif application.model.CheckoutHelper.getCarrier() eq 42>
				By porting your number you are ending service with your current wireless provider. If you have not completed your minimum contract term, you may be subject to an early termination fee.
			</cfif>
		</p>
	</cfif>
</form>