<cfset local.requiredServices = application.model.ServiceManager.getDeviceMinimumRequiredServices(productId = request.p.product_id, cartTypeId = application.model.cart.getCartTypeId('upgrade')) />

<cf_cartbody mode="edit" EnableCartReview="false">
	<cfsavecontent variable="local.serviceHTML">
		<cfoutput query="local.requiredServices" group="GroupLabel">
			<cfset thisGroupRadioCount = 0 />
			<strong>#local.requiredServices.groupLabel[local.requiredServices.currentRow]#</strong>
			<p style="font-size:9pt;">
			The phone you have chosen requires one of the following data services. If the feature you choose is not compatible with your current plan we will notify you to change it.  Monthly fee and data amount may vary based on compatibility with your current rate plan.
			</p>
			<table border="0" cellpadding="2" cellspacing="0" style="display: block">
				<cfoutput>
					<cfset thisGroupRadioCount++ />
					<cfset qService = application.model.feature.getByProductId(local.requiredServices.productId[local.requiredServices.currentRow]) />
					<tr>
						<td valign="top"><input type="radio" id="chk_features_#local.requiredServices.productId[local.requiredServices.currentRow]#" name="chk_features_#local.requiredServices.serviceMasterGroupGuid[local.requiredServices.currentRow]#" value="#local.requiredServices.productId[local.requiredServices.currentRow]#" <cfif thisGroupRadioCount eq 1 or Len(qService.RecommendationId)>checked="checked"</cfif> /></td>
						<td style="padding-top: 5px; font-size: 9pt">
							#local.requiredServices.label[local.requiredServices.currentrow]#
							<br />
							(#dollarFormat(local.requiredServices.monthlyFee[local.requiredServices.currentRow])#  / month)&nbsp;
							<span id="showDetails_#local.requiredServices.productId[local.requiredServices.currentRow]#">[<a href="##" onclick="$('details_#local.requiredServices.productId[local.requiredServices.currentRow]#').toggle();$('showDetails_#local.requiredServices.productId[local.requiredServices.currentRow]#').toggle();$('hideDetails_#local.requiredServices.productId[local.requiredServices.currentRow]#').toggle();return false;" style="font-size: 10pt">Show Details</a>]</span>
							<span id="hideDetails_#local.requiredServices.productId[local.requiredServices.currentRow]#" style="display: none">[<a href="##" onclick="$('details_#local.requiredServices.productId[local.requiredServices.currentRow]#').toggle();$('showDetails_#local.requiredServices.productId[local.requiredServices.currentRow]#').toggle();$('hideDetails_#local.requiredServices.productId[local.requiredServices.currentRow]#').toggle();return false;" style="font-size: 10pt">Hide Details</a>]</span>							
							<cfif Len(qService.RecommendationId) and NOT qService.hidemessage >
								<span class="recommended">BEST VALUE</span>
							</cfif>
							<div id="details_#local.requiredServices.productId[local.requiredServices.currentRow]#" style="display: none; font-size: 10pt">
								<hr size="1" noshade="true" />
								<p style="font-size: 10pt">#reReplaceNoCase(trim(qService.summaryDescription), '</?[^>]*>', '', 'all')#</p>
								<hr size="1" noshade="true" />
							</div>
						</td>
					</tr>
				</cfoutput>
			</table>
			<br />
		</cfoutput>

		<cfset local.listRequiredServiceGroupGuids = '' />

		<cfif local.requiredServices.recordCount>
			<cfset local.listRequiredServiceGroupGuids = application.model.util.listDistinct(valueList(local.requiredServices.serviceMasterGroupGuid)) />
		</cfif>
	</cfsavecontent>

		<script language="javascript">
			
			chooseExistingPlanType = function(existingPlanType) 
			{
				if( existingPlanType == "individual" ) {
					allowNext();
					jQuery('#warnSharedUpgrade').hide();
				} else {
					disallowNext();
					jQuery('#warnSharedUpgrade').show();
				}				
			}
			
			function allowNext() {
				jQuery("#nextBtn").removeAttr("disabled")
					.addClass("glow")
					.focus()
					.fadeTo('slow', 1);
				jQuery("#btnCartReview").fadeTo('slow', 0.5);
				jQuery("#btnCartReview a").removeAttr("onclick");			
			}
			
			function disallowNext()	{
				jQuery("#nextBtn").attr("disabled","disabled");	
				jQuery("#nextBtn").removeClass("glow");
			}

			revealRequiredServices = function() {
				<cfif local.requiredServices.recordCount>
					$('divRequiredServices').show();
				</cfif>
				jQuery('#existingPlanType').hide();
				allowNext();
			}

			hideRequiredServices = function () {
				<cfif local.requiredServices.recordCount>
					$('divRequiredServices').hide();
				</cfif>
				disallowNext();
			}
			
			showExistingPlan = function() {
				hideRequiredServices();
				jQuery('#existingPlanType').show();
				if (jQuery('input[name="existingPlanType"]:checked').val() == "individual") {
					allowNext();
				} else {
					disallowNext();
				}
			}
			
			validateUpgradeForm = function() {
				updateSelectedFeatures();
				return true;
			}

			var selectedFeatures = '';

			updateSelectedFeatures = function(o) {
				selectedFeatures = '';
				var f = document.getElementById('formAddToCart');
				var e = f.elements;

				if ( $$('input:checked[type="radio"][name="upgradeType"]').pluck('value') == 'equipment-only' )
				{
					//Loop through the features
					for (var i = 0; i < e.length; i++ ) {
						if (e[i].name.indexOf('chk_features',0) > -1 && e[i].checked == true)
							selectedFeatures += e[i].value + ',';
					}
				}

				//Adds selected features to the hidden field holding all product IDs
				f.PRODUCT_ID.value = f.PRODUCT_ID.value + ':' + selectedFeatures;
			}
			
	
		</script>
	<cfoutput>
		<div class="messages-box large-modal" style="overflow: auto; height: 385px; width: 540px">
			<div id="dialogContent" class="margin">
				<cfform method="post" action="#cgi.script_name#" id="formAddToCart" name="formAddToCart" onsubmit="return validateUpgradeForm()">
					<table border="0" cellpadding="0" cellspacing="0" width="550" align="center" style="width: 540px">
						<tr>
							<td>
								<cfloop collection="#request.p#" item="thisVar">
									<cfif variables.thisVar is not 'zipcode' and left(variables.thisVar, 1) is not '_'>
										<input type="hidden" name="#variables.thisVar#" value="#htmlEditFormat(request.p[variables.thisVar])#" />
									</cfif>
								</cfloop>

								<label for="zipCode"><span style="font-size: 12pt; font-weight: bold">For the handset that you have selected you must choose from the following two options:</span></label>
								<br /><br />
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
								 	<tr>
								 		<td valign="top"><input type="radio" name="upgradeType" value="equipment-only" onclick="revealRequiredServices()" /></td>
										<td width="100%" style="padding-top: 4px; padding-left: 4px; font-size: 10pt">
											<strong>Upgrade your phone and keep your current rate plan.</strong><br /> 
											<div id="divRequiredServices" style="display: none">
												<br />
												#trim(local.serviceHTML)#
											</div>
										</td>
									</tr>
									<tr>
										<td valign="top"><input type="radio" name="upgradeType" value="equipment+plan" onclick="showExistingPlan()" /></td>
										<td valign="top" width="100%" style="padding-top: 4px; padding-left: 4px; font-size: 10pt">
											<strong>Upgrade your phone and change to a different rate plan than you are currently on.</strong><br /> 
											<div id="existingPlanType" style="display:none;">
												<br />
												<strong>Please select the type of your current plan:</strong> <br />
												<input type="radio" name="existingPlanType" value="individual" onclick="chooseExistingPlanType('individual')" /> Individual<br />
												<input type="radio" name="existingPlanType" value="shared" onclick="chooseExistingPlanType('shared')" /> Shared
												<div id="warnSharedUpgrade" style="display:none; padding:10px;">
													<em>Changing a shared or family plan is not currently supported on this site. If you wish to continue, please select "Upgrade your phone and keep your current rate plan" to upgrade only your device.</em>
												</div>
											</div>
										</td>
									 </tr>									
								</table>
							</td>
						</tr>
						<tr>
							<td><input id="nextBtn" type="submit" value="Next" disabled="disabled"  /></td>
						</tr>
					</table>
				</cfform>
				<div style="width:95%; margin-top: 25px; margin-right: 20px; border: 1px solid ##6B6B6B; background-color: ##fff799; padding: 10px; -moz-border-radius: 10px; -webkit-border-radius: 10px; -khtml-border-radius: 10px; font-size: 10pt;">
					<p style="line-height:1.2em; font-size: 10pt;">Thank you for selecting us to upgrade your phone.  Please be aware of the following in order to qualify for upgrade pricing:</p>
					<ul style="font-size: 10pt; color: ##6B6B6B;">
						<li style="list-style:disc outside none; margin-left: 25px;">
							You must have completed <cfif StructKeyExists(variables, "LOCAL_PHONE") && LOCAL_PHONE.CarrierId eq 299>22<cfelse>24</cfif> months of your current contract in order to qualify.
						</li>
						<li style="list-style:disc outside none; margin-left: 25px;">In order to get the price you have selected your carrier requires you to sign a new two year agreement.</li>
					</ul>
					<div style="clear:both;"></div>
				</div>
				<br />
			</div>
		</div>
	</cfoutput>
</cf_cartbody>
