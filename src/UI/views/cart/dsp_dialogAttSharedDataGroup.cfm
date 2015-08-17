
<cfscript>
	//session.cart.getCartTypeId();
	qServices = application.model.ServiceManager.getServiceMasterLabelsByGroup(groupGUID = '1E43B970-1B2A-4C2D-AB17-13D2B18682EF', cartTypeId = 1);
</cfscript>

<cf_cartbody mode="edit" EnableCartReview="false">
	<cfoutput>
		<script language="javascript">
			validateForm = function ()
			{
				return true;
			}
		</script>		
		<div class="messages-box large-modal" style="overflow: auto; height: 330px; width: 540px">
			<div id="dialogContent" class="margin">
				<cfform method="post" action="#cgi.script_name#" id="formAddToCart" name="formAddToCart" onsubmit="return validateForm();">
					<input type="hidden" name="SharedDateGroupFeature" value="true" />
					<table border="0" cellpadding="0" cellspacing="0" width="550" align="center" style="width: 550px">
						<tr>
							<td>
								<cfloop collection="#request.p#" item="thisVar">
									<cfif variables.thisVar is not 'zipcode' and left(variables.thisVar, 1) is not '_'>
										<input type="hidden" name="#variables.thisVar#" value="#htmlEditFormat(request.p[variables.thisVar])#" />
									</cfif>
								</cfloop>

								<label for="zipCode"><span style="font-size: 12pt; font-weight: bold">Select a shared data package:</span></label>
								<br /><br />
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
								 	<tr>
										<td width="100%" style="padding-top: 4px; padding-left: 15px">	
											<table border="0" cellpadding="2" cellspacing="0" style="display: block">										
												<cfloop query="qServices">
													<tr>
														<td valign="top">
															<input type="radio" id="chk_features_#qServices.productId[qServices.currentRow]#" name="SelectedSharedDateGroupFeature" value="#qServices.productId[qServices.currentRow]#" <cfif qServices..currentRow eq 1>checked="checked"</cfif> />
															<label for="chk_features_#qServices.productId[qServices.currentRow]#">#qServices.Label# (#dollarFormat(qServices.monthlyFee[qServices.currentRow])#  / month)</label>
														</td>
													</tr>
												</cfloop>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td><br /><input type="submit" value="Next" /></td>
						</tr>
					</table>
				</cfform>
			</div>
		</div>			
	</cfoutput>
</cf_cartbody>
