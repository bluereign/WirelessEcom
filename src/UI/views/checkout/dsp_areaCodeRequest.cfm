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
			function updateExisting(whichRow, whichValue)	{
				if(whichValue != 'AT&T' && whichValue != 'T-Mobile' && whichValue != 'Verizon Wireless')	{
					document.getElementById(whichRow).style.display = '';
				} else {
					document.getElementById(whichRow).style.display = 'none';
					document.getElementById('portInCurrentCarrierAccountNumber' + whichRow.replace('extAccNum', '')).value = '';
				}
			}
			function validateForm()	{
				if (1 == 2) {
				}
				<cfloop from="1" to="#application.model.checkoutHelper.getNumberOfLines()#" index="i">
				/*else if( document.getElementById('txtNewNumber_#i#').selectedIndex == 0 )
				{
					alert('Please choose an area code for your new wireless number for line #i#.');
					document.getElementById('txtNewNumber_#i#').focus();
					return false;
				}*/
				</cfloop>
				else
				{
					showProgress('Checking for availability, please wait.');
					$('##lnp').submit();
					return true;
				}
			}
		</script>
	</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#trim(variables.jsHead)#" />

<form id="lnp" class="cmxform" action="/index.cfm/go/checkout/do/processRequestAreaCode/" method="post">
	<cfif application.model.checkoutHelper.getNumberOfLines() gt 1>
		<h1>Select Area Codes</h1>
	<cfelse>
		<h1>Select Area Code</h1>
	</cfif>

	<cfif application.model.checkoutHelper.getNumberOfLines() gt 1>
		<p>Please select your preferred area codes.</p>
	<cfelse>
		<p>Please select your preferred area code.</p>
	</cfif>

	<cfoutput>
		<cfif structKeyExists(request, 'validator') and  request.validator.hasMessages()>
			<div class="form-errorsummary">
				#trim(request.validatorView.validationSummary(request.validator.getMessages()))#
			</div>
		</cfif>
	</cfoutput>

	<!---  Get the NPAs by zipcode, return empty array if it fails. --->
	<cfparam name="request.p.npaList" default="#arraynew(1)#" type="array" />

	<cftry>
		<cfset request.p.npaResponse = application.model.npaLookup.lookup(session.cart.getZipcode(), application.model.checkoutHelper.getCarrier(), application.model.checkoutHelper.getReferenceNumber()) />
		<cfset request.p.npaList = request.p.npaResponse.NpaList />

		<cfcatch>
			<cfset ArrayAppend(request.p.npaList, '000') />
		</cfcatch>
	</cftry>

	<cfoutput>
		<cfset request.p.cartLines = session.cart.getLines() />

		<cfloop from="1" to="#application.model.checkoutHelper.getNumberOfLines()#" index="i">
			<cfparam name="request.p.selection#i#" default="port" />
			<cfparam name="request.p.newAreaCode#i#" default="" />

			<cfset request.p.cartLine = request.p.cartLines[i] />

			<div style="margin-botom: 2em">
				<fieldset>
					<span class="title">Line #i#</span>
					<ol>
						<li class="full">
							<ol id="lnpAreaCode_#i#">
								<li>
									<label>Area code:</label>
									<div>
										<select name="newAreaCode#i#" id="txtNewNumber_#i#">
											<option></option>

											<cfset request.p.selected = '' />

											<cfloop from="1" to="#arrayLen(request.p.npaList)#" index="request.p.i">
												<cfif isDefined('session.checkout.mdnForm.newAreaCode#i#') and request.p.npaList[request.p.i] eq evaluate('session.checkout.mdnForm.newAreaCode#i#')>
													<cfset request.p.selected = 'selected' />
												<cfelse>
													<cfset request.p.selected = '' />
												</cfif>

												<cfoutput>
													<option #request.p.selected# value="#request.p.npaList[request.p.i]#">#request.p.npaList[request.p.i]#</option>
												</cfoutput>
											</cfloop>
										</select> *
										#trim(request.validatorView.validationElement(request.validator.getMessages(), 'errorAreaCode_#i#'))#
									</div>
								</li>
							</ol>
						</li>
					</ol>
				</fieldset>
			</div>
		</cfloop>
	</cfoutput>

	<div class="formControl">
		<span class="actionButtonLow">
			<a href="##" onclick="window.location.href='/index.cfm/go/cart/do/view/'">Back</a>
		</span>
		<span class="actionButton">
			<a href="##" onclick="validateForm()">Continue</a>
		</span>
	</div>

	<cfif arrayLen(request.p.npaList)>
		<p>
			* Area code options are based on the zip code you entered while shopping of
			<cfoutput>#session.cart.getZipcode()#</cfoutput>
		</p>
	</cfif>
</form>