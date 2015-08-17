<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfparam name="request.zipCodeError" default="" type="string" />

<cf_cartbody mode="edit" DisplayCartHeader="false" DisplayCartFooter="false">
	<cfoutput>
		<script>
				/*  This was done to fix a bug where a small percent of the time the popup would
					show up as blank in Chrome.  It needs the smallest of timeouts to process the changes*/
				jQuery( document ).ready(function() {
	    			setTimeout(function(){jQuery('##zipcode-container').css({"position": "relative"});},30);
	    			setTimeout(function(){jQuery('##zipcode-container').css({"position": "absolute"});},50);
				});

			ToggleActivationPriceZip = function()
			{	
				//alert(jQuery('input[name=ActivationPriceOption]:checked').val());
				switch( jQuery('input[name=ActivationPriceOption]:checked').val() )
				{
					case 'New':
						jQuery('##zip-new-activation-container').show();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();
						jQuery('##zip-financed-activation-container').hide();
							
						break;
					case 'Upgrade':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').show();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();
						jQuery('##zip-financed-activation-container').hide();									
						break;
					case 'Addaline':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').show();
						jQuery('##zip-nocontract-activation-container').hide();			
						jQuery('##zip-financed-activation-container').hide();
						break;
					case 'NoContract':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').show();		
						jQuery('##zip-financed-activation-container').hide();
						break;
					case 'financed':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;
					case 'financed-12-new':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;	
					case 'financed-12-upgrade':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;	
					case 'financed-12-addaline':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;
					case 'financed-18-new':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;	
					case 'financed-18-upgrade':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;	
					case 'financed-18-addaline':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;
					case 'financed-24-new':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;	
					case 'financed-24-upgrade':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;	
					case 'financed-24-addaline':
						jQuery('##zip-new-activation-container').hide();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();		
						jQuery('##zip-financed-activation-container').show();
						break;												
					default:	
						jQuery('##zip-new-activation-container').show();
						jQuery('##zip-upgrade-activation-container').hide();
						jQuery('##zip-addaline-activation-container').hide();
						jQuery('##zip-nocontract-activation-container').hide();	
						jQuery('##zip-financed-activation-container').hide();
						break;
				}
			}

			ValidateForm  = function()
			{
				isInvalid = false;
				
				if (!jQuery("input:radio[name='ActivationPriceOption']").is(":checked")) {
   					jQuery("##contractType-error").show();
   					return false;
				}

				if ( jQuery.trim(jQuery("##zipCodeInput").val()).length != 5 || !jQuery.isNumeric(jQuery("##zipCodeInput").val()) )
				{
					isInvalid = true;
				}
				
				if (isInvalid)
				{
					jQuery("##zipCodeInput").focus();
					jQuery("##zipCodeInput").addClass("error");
					jQuery("##zipcode-error").show();
				}
				else
				{
					jQuery('##AddToCartForm').submit();
				}
				
				return false;
			}
		</script>
		<div id="zipcode-container" name="zipcode-container" class="zipcode-container">
			<cfif len(trim(request.zipCodeError))>
				<div class="cart-msg-box-error">
					#trim(request.zipCodeError)#
				</div>
			</cfif>
			<div id="dialogContent" >
				<style>
					.zipcode-label {
						font-size: 20px;
						padding-right: 10px;
						color: ##333;
					}
					
					span.header {
						font-size: 20px;
						padding-right: 10px;
						padding-top: 10px;
						color: ##333;
					}
					
					##product-title {
						font-size: 20px;
						line-height: 30px;
						color: ##0060A9;
					}

					##activation-container {
						padding-top: 20px;
					}
					
					##activation-options li {
						padding-left: 15px;
						font-size: 13px;
						line-height: 14px;
					}
					
					##zipcode-message {
						display:block;
						margin: 8px 0 5px 0;
					}
					
					##price-container .final-price-container {
						text-align: left;
						padding: 3px 0;
					}

					.x-dlg-dlg-body, .x-dlg-bd {
						box-sizing: content-box;
					}

					.x-dlg .x-dlg-dlg-body {
						background-color: ##eee;
					}
				</style>
				
				<div id="device-container">
					<p><span class="header">Your new wireless device</span> </p>

					<cfif Len(qDevice.ImageGuid)>
						<img src="#application.view.imageManager.displayImage(imageGuid = '#qDevice.ImageGuid#', height=125, width=0, BadgeType="#qDevice.BadgeType#")#" class="device-image" alt="#htmlEditFormat(qDevice.summaryTitle)#" title="#htmlEditFormat(qDevice.summaryTitle)#" height="125" border="0" />
					<cfelse>
						<img src="#assetPaths.common#images/Catalog/NoImage.jpg" height="125" class="device-image" alt="#htmlEditFormat(qDevice.summaryTitle)#" border="0" />
					</cfif>
					
					<cfif qDevice.CarrierId eq '42'>
						<img src="#assetPaths.common#images/carrierLogos/verizon_logo_20.png" height="20" /><br />
					<cfelseif qDevice.CarrierId eq '109'>
						<img src="#assetPaths.common#images/carrierLogos/att_logo_20.png" height="20" /><br />
					<cfelseif qDevice.CarrierId eq '128'>
						<img src="#assetPaths.common#images/carrierLogos/tmo_logo_20.png" height="20" /><br />
					<cfelseif qDevice.CarrierId eq '299'>
						<img src="#assetPaths.common#images/carrierLogos/sprint_logo_20.png" height="20" /><br />
					</cfif>

					<span id="product-title">#qDevice.summaryTitle#</span>
					<cfif request.p.productType neq 'prepaid'>
						
						
						
						<div id="price-container">
							<cfif request.p.ActivationType DOES NOT CONTAIN "financed">
								<cfif !qDevice.IsNewActivationRestricted>
									<div id="zip-new-activation-container" <cfif request.p.ActivationType neq 'new'>style="display:none"</cfif>>
										New account (2-year contract required)<br />
										<div class="final-price-container">#DollarFormat(qDevice.price_new)#<cfif request.config.debugInventoryData>N</cfif></div>
									</div>
								</cfif>
								<cfif !qDevice.IsUpgradeActivationRestricted>
									<div id="zip-upgrade-activation-container" <cfif request.p.ActivationType neq 'upgrade'>style="display:none"</cfif>>
										Upgrade my existing device <br />
										<div class="final-price-container">#DollarFormat(qDevice.price_upgrade)#<cfif request.config.debugInventoryData>U</cfif></div>
									</div>
								</cfif>
								<cfif !qDevice.IsAddALineActivationRestricted>
									<div id="zip-addaline-activation-container" <cfif request.p.ActivationType neq 'addaline'>style="display:none"</cfif>>
										Add a new device to my existing account <br />
										<div class="final-price-container">#DollarFormat(qDevice.price_addaline)#<cfif request.config.debugInventoryData>A</cfif></div>
									</div>
								</cfif>
								<cfif channelConfig.getOfferNoContractDevices() && !qDevice.IsNoContractRestricted && channelConfig.isNoContractDevice(request.p.productType)>
									<div id="zip-nocontract-activation-container" <cfif request.p.ActivationType neq 'nocontract'>style="display:none"</cfif>>
										Replace existing device (no contract extension) <br />
										<div class="final-price-container">#DollarFormat(qDevice.price_nocontract)#<cfif request.config.debugInventoryData>NC</cfif></div>
									</div>
								</cfif>
							<cfelse>
								<cfif session.scenario.scenarioType is 'VFD'>
									<div id="zip-financed-activation-container" <cfif request.p.ActivationType does not contain 'financed'>style="display:none"</cfif>>
										Financed Pricing (#channelConfig.getScenarioDescription()# Only) <br />
										<cfif request.p.ActivationType contains 12>
											<div class="final-price-container">#dollarFormat(qDevice.FINANCEDMONTHLYPRICE12)#/m (12m) <cfif request.config.debugInventoryData>F</cfif></div>										
										<cfelseif request.p.ActivationType contains 18>
											<div class="final-price-container">#dollarFormat(qDevice.FINANCEDMONTHLYPRICE18)#/m (18m) <cfif request.config.debugInventoryData>F</cfif></div>
										<cfelseif request.p.ActivationType contains 24>
											<div class="final-price-container">#dollarFormat(qDevice.FINANCEDMONTHLYPRICE24)#/m (24m) <cfif request.config.debugInventoryData>F</cfif></div>
										</cfif>	
									</div>
								</cfif>
							</cfif>
						</div>
					</cfif>
					<div style="clear:both"></div>
				</div>
				<cfform class="wa-webform" method="post" action="#cgi.script_name#" id="AddToCartForm" name="formAddToCart">
					<cfloop collection="#request.p#" item="thisVar">
						<!--- Do not duplicate new and _FormName fields --->
						<cfif trim(variables.thisVar) neq 'zipcode' && trim(variables.thisVar) neq 'ActivationPriceOption' && left(trim(variables.thisVar), 1) neq '_'>
							<input type="hidden" name="#trim(variables.thisVar)#" value="#htmlEditFormat(trim(request.p[trim(variables.thisVar)]))#" />
						</cfif>
					</cfloop>
					
					<cfif request.p.productType neq 'prepaid'>
						<div id="activation-container">
							<p><span class="header">Choose your contract type</span></p>
							<em id="contractType-error" style="display:none;" class="error">Please Select a Contract Type</em><br/>
							<ul id="activation-options">
								
								<cfif request.p.ActivationType contains 'financed-12' and session.scenario.scenarioType is 'VFD'>
									<cfif session.scenario.scenarioType is 'VFD'>
										
										
										<cfif !qDevice.IsNewActivationRestricted>
											<li>
												<input id="new-activation" name="ActivationPriceOption" type="radio" value="financed-12-new" <cfif session.cart.getActivationType() CONTAINS 'new'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="new-activation">New account (Financed 12)</label>
											</li>
										</cfif>
										<cfif !qDevice.IsUpgradeActivationRestricted>
											<li>
												<input id="upgrade-activation" name="ActivationPriceOption" type="radio" value="financed-12-upgrade" <cfif session.cart.getActivationType() CONTAINS 'upgrade'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="upgrade-activation">Upgrade my existing device (Financed 12)</label>
											</li>
										</cfif>
										<cfif !qDevice.IsAddALineActivationRestricted>
											<li>
												<input id="aal-activation" name="ActivationPriceOption" type="radio" value="financed-12-addaline" <cfif session.cart.getActivationType() CONTAINS 'Addaline'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="aal-activation">Add a new device to my existing account (Financed 12)</label>
											</li>
										</cfif>

									</cfif>	
									
								<cfelseif 	request.p.ActivationType contains 'financed-18' and session.scenario.scenarioType is 'VFD'>
										<cfif !qDevice.IsNewActivationRestricted>
											<li>
												<input id="new-activation" name="ActivationPriceOption" type="radio" value="financed-18-new" <cfif session.cart.getActivationType() CONTAINS 'new'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="new-activation">New account (Financed 18)</label>
											</li>
										</cfif>
										<cfif !qDevice.IsUpgradeActivationRestricted>
											<li>
												<input id="upgrade-activation" name="ActivationPriceOption" type="radio" value="financed-18-upgrade" <cfif session.cart.getActivationType() CONTAINS 'upgrade'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="upgrade-activation">Upgrade my existing device (Financed 18)</label>
											</li>
										</cfif>
										<cfif !qDevice.IsAddALineActivationRestricted>
											<li>
												<input id="aal-activation" name="ActivationPriceOption" type="radio" value="financed-18-addaline" <cfif session.cart.getActivationType() CONTAINS 'Addaline'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="aal-activation">Add a new device to my existing account (Financed 18)</label>
											</li>
										</cfif>								
								<cfelseif 	request.p.ActivationType contains 'financed-24' and session.scenario.scenarioType is 'VFD'>
										<cfif !qDevice.IsNewActivationRestricted>
											<li>
												<input id="new-activation" name="ActivationPriceOption" type="radio" value="financed-24-new" <cfif session.cart.getActivationType() CONTAINS 'new'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="new-activation">New account (Financed 24)</label>
											</li>
										</cfif>
										<cfif !qDevice.IsUpgradeActivationRestricted>
											<li>
												<input id="upgrade-activation" name="ActivationPriceOption" type="radio" value="financed-24-upgrade" <cfif session.cart.getActivationType() CONTAINS 'upgrade'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="upgrade-activation">Upgrade my existing device (Financed 24)</label>
											</li>
										</cfif>
										<cfif !qDevice.IsAddALineActivationRestricted>
											<li>
												<input id="aal-activation" name="ActivationPriceOption" type="radio" value="financed-24-addaline" <cfif session.cart.getActivationType() CONTAINS 'Addaline'>checked="checked"<cfelseif session.cart.getActivationType() eq ''> <cfelse>disabled</cfif> onclick="ToggleActivationPriceZip()" />
												<label for="aal-activation">Add a new device to my existing account (Financed 24)</label>
											</li>
										</cfif>						
								<cfelse>
									<cfif !qDevice.IsNewActivationRestricted>
										<li>
											<input id="new-activation" name="ActivationPriceOption" type="radio" value="New" <cfif request.p.ActivationType eq 'new'>checked="checked"</cfif> onclick="ToggleActivationPriceZip()" />
											<label for="new-activation">New account (2-year contract required)</label>
										</li>
									</cfif>
									<cfif !qDevice.IsUpgradeActivationRestricted>
										<li>
											<input id="upgrade-activation" name="ActivationPriceOption" type="radio" value="Upgrade" <cfif request.p.ActivationType eq 'upgrade'>checked="checked"</cfif> onclick="ToggleActivationPriceZip()" />
											<label for="upgrade-activation">Upgrade my existing device (2-year contract extension required)</label>
										</li>
									</cfif>
									<cfif !qDevice.IsAddALineActivationRestricted>
										<li>
											<input id="aal-activation" name="ActivationPriceOption" type="radio" value="Addaline" <cfif request.p.ActivationType eq 'addaline'>checked="checked"</cfif> onclick="ToggleActivationPriceZip()" />
											<label for="aal-activation">Add a new device to my existing account (2-year contract required)</label>
										</li>
									</cfif>
									<cfif channelConfig.getOfferNoContractDevices() && !qDevice.IsNoContractRestricted && channelConfig.isNoContractDevice(request.p.productType)>
										<li>
											<input id="nocontract-activation" name="ActivationPriceOption" type="radio" value="NoContract" <cfif request.p.ActivationType eq 'nocontract'>checked="checked"</cfif> onclick="ToggleActivationPriceZip()" />
											<label for="nocontract-activation">No contract renewal</label>
										</li>
									</cfif>	
								</cfif>
								
								
								
								
								
							</ul>
						</div>
					<cfelse>
						<input name="ActivationPriceOption" type="hidden" value="New" /> 
					</cfif>
					<div style="width: 400px">
						<label class="zipcode-label" for="zipCodeInput">Enter zip code:</label>
						<!--- Added onClick to reposition windown when input field is clicked.  This resolves bug that only happens in Chrome
						where in rare cases the input field would not allow/display any entries --->
						<input type="text" name="zipCode" id="zipCodeInput" onclick="centerWindow('dialog_addToCart')" class="textbox {validate:{required:true, zipcode:true}}" size="10" maxlength="5" />
						<em id="zipcode-error" style="display:none;" class="error">Enter a valid zip code.</em>
						<br />
						<span id="zipcode-message">Zip code where you will most frequently use your wireless device, or if <br />changing carriers use the zip code from your existing account.</span>
						<div class="button-container">
							<a class="ActionButton" onclick="ValidateForm(); return false;" href="##"><span>Continue</span></a>
						</div>
					</div>
				</cfform>
			</div>
		</div>	
	</cfoutput>
</cf_cartbody>