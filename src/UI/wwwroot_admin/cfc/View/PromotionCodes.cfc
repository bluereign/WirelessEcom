<cfcomponent name="PromotionCodes" output="false">

	<cffunction name="init" access="public" returntype="PromotionCodes" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getShipMethods" access="public" returntype="query" output="false">
		<cfreturn application.model.ShipMethod.getShipMethods( activeOnly = false ) />
	</cffunction>
	
	<cffunction name="displayPromotionCodes" access="public" returntype="string" output="false">

		<cfset var displayPromotionCodesReturn = '' />
		<cfset var qPromotionCodes = getPromotionGateway().getPromotions() />
		
		<cfsavecontent variable="displayPromotionCodesReturn">
			<style type="text/css">
				th {
					font-weight: bold
				}
				td, th {
					padding:5px 3px;
				}
				.date {
					text-align: center;
				}
				.numeric, .controls {
					text-align: right;
				}
				.integer {
					text-align: center;
				}
				.inactive {
					color: #939393;
					font-style: italic;
				}
				input[type='submit'] {
					padding: 3px 10px;
				}
				.msgbox {
					text-align:center;
					padding:10px;
					margin:20px;
				}
				.warn {
					color:red;
					background-color:#ecb3b3;
				}
				.success {
					color:green;
					background-color:#afcbae;
				}
			</style>
			<cfif !getChannelConfig().isPromotionCodeAvailable()>
				<p class="msgbox warn"><strong>WARNING: Promotions are not enabled for this channel.</strong></p>
			</cfif>
			<cfif structKeyExists(url, 'add') and url.add>
				<p class="msgbox success"><strong>The Promotion has been added successfully.</strong></p>
			</cfif>
			<cfif structKeyExists(url, 'remove') and url.remove>
				<p class="msgbox success"><strong>The Promotion has been removed successfully.</strong></p>
			</cfif>
			<cfif structKeyExists(url, 'edit') and url.edit>
				<p class="msgbox success"><strong>The Promotion has been updated successfully.</strong></p>
			</cfif>
			<form action="index.cfm?c=#request.p.c#" method="post">
			<table width="100%" cellpadding="3" cellspacing="0" border="0">
				<cfoutput>
					<input type="hidden" name="GO" value="add" />
						<tr>
							<td style="text-align: right"><input type="submit" name="addPromotionCode" value="Add Promotion" /></td>
						</tr>
				</cfoutput>
			</table>
			</form>
			<br />
			<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="#cccccc">
				<thead>
					<tr>
						<th>Name</th>
						<th>Status</th>
						<th>Code</th>
						<th class="integer">Quantity <br />Remaining</th>
						<th class="date">Start Date</th>
						<th class="date">End Date</th>
						<th class="date">Created</th>
						<th>Discount</th>
						<th class="controls">Actions</th>
					</tr>
				</thead>
				<tbody>
				<cfif qPromotionCodes.recordCount>
					<cfoutput query="qPromotionCodes">
						<tr class="<cfif qPromotionCodes.Status neq 'Active'>inactive</cfif>" style="background-color: ###iif(qPromotionCodes.currentRow mod 2, de('ececec'), de('ffffff'))#;">
							<td><a href="index.cfm?c=#url.c#&go=edit&promotionId=#qPromotionCodes.promotionId#">#qPromotionCodes.Name#</a></td>
							<td>#qPromotionCodes.Status#</td>
							<td><cfif qPromotionCodes.CodeCount eq 1 >#qPromotionCodes.Code#<cfelse><em>Multiple</em></cfif></td>
							<td class="integer"><cfif isNumeric(qPromotionCodes.QuantityRemaining)>#qPromotionCodes.QuantityRemaining#<cfelse>N/A</cfif></td>
							<td class="date"><cfif isDate(qPromotionCodes.startDate)>#dateFormat(qPromotionCodes.startDate, 'mm/dd/yyyy')# <br /> #timeFormat(qPromotionCodes.startDate, 'h:mm TT')#<cfelse>N/A</cfif></td>
							<td class="date"><cfif isDate(qPromotionCodes.endDate)>#dateFormat(qPromotionCodes.endDate, 'mm/dd/yyyy')# <br /> #timeFormat(qPromotionCodes.endDate, 'h:mm TT')#<cfelse>N/A</cfif></td>
							<td class="date"><cfif isDate(qPromotionCodes.createdDate)>#dateFormat(qPromotionCodes.createdDate, 'mm/dd/yyyy')# <br /> #timeFormat(qPromotionCodes.createdDate, 'h:mm TT')#<cfelse>N/A</cfif></td>
							<td class="numeric">
							<cfif qPromotionCodes.discountType eq 'percent'>
								#round(qPromotionCodes.discount)#%
							<cfelseif qPromotionCodes.discountType eq 'flat'>
								#dollarFormat(val(qPromotionCodes.discount))#
							<cfelse>
								Shipping
							</cfif>
							&nbsp;
							</td>
							<td class="controls">
								<a href="index.cfm?c=#url.c#&go=edit&promotionId=#qPromotionCodes.promotionId#"><img src="assets/common/images/icon-edit.gif" alt="Edit Promotion Code" border="0" width="16" height="16" /></a>
								<a href="javascript:void(0)" onclick="if(confirm('Are you sure you would like to remove this promotion code?')){window.location='index.cfm?c=#url.c#&go=delete&promotionId=#qPromotionCodes.promotionId#'}"><img src="assets/common/images/icon-delete.gif" alt="Remove Promotion Code" border="0" width="16" height="16" /></a>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr style="background-color: #ffffff">
						<td colspan="6" style="text-align: center; padding: 3px">No promotion codes currently exist.</td>
					</tr>
				</cfif>
				</tbody>
			</table>
		</cfsavecontent>

		<cfreturn trim(displayPromotionCodesReturn) />
	</cffunction>
	
	<cffunction name="displayPromotionCodeForm" access="public" returntype="string" output="false">
		
		<cfset var strOut = "">
		<cfset var items = getPromotionGateway().getSKUs()>
		<cfset var qShipMethods = getShipMethods() />
		<cfset var qPromotion = "">
		<cfset var qOrderSKUs = "">
		<cfset var qConditionSKUs = "">
		<cfset var conditionID = "">
		<cfset var qPromotionCodes = "">
		<cfset var AssetPaths = application.wirebox.getInstance("AssetPaths")>
		
		<cfparam name="URL.promotionID" default="-1" type="numeric">
		
		<cfset qPromotion = getPromotionGateway().getPromotion( promotionID = URL.promotionID )>
		<cfset qOrderSKUs = getPromotionGateway().getOrderSKUs( promotionID = URL.promotionID )>
		<cfset qPromotionCodes = getPromotionGateway().getCodesForPromotion( promotionID = URL.promotionID )>
		
		<cfif qPromotion.recordCount>
			<cfset conditionID = qPromotion.PromotionConditionId>
		<cfelse>
			<cfset conditionID = -1>
		</cfif>
		
		<cfset qConditionSKUs = getPromotionGateway().getConditionSKUS( conditionID = conditionID )>
		
		<cfsavecontent variable="strOut">
			<script type="text/javascript" src="assets/common/scripts/libs/chosen_v1.0.0/chosen.jquery.min.js"></script>
			<script type="text/javascript" src="assets/common/scripts/libs/jquery.validate.min.js"></script>
			<script type="text/javascript" src="assets/common/scripts/jquery.maskedinput.min.js"></script>
			<script type="text/javascript">
				jQuery(document).ready( function($) {
					
					$('input[name=cancelPromoCode]').click( function() {
						window.location = <cfoutput>'index.cfm?c=#url.c#'</cfoutput>
					});
					
					//Init datepicker and sku selects
					$('.datepicker').datepicker();
					$('.chosen').chosen({
						placeholder_text_multiple : "Choose items",
						search_contains : true,
						width : '450px'
					});
					
					//Setup discount type
					showDiscountTypeFields();
										
					//Change handlers
					$('#discountType').change( function() { 
						showDiscountTypeFields() 
					});
					
					$('#modal-generateCodes')
						.keypress(function(e) {
							if( e.keyCode == $.ui.keyCode.ENTER ) {
								$('.ui-dialog-buttonpane button:first').click();
								return false;
							}
						})
						.dialog({
							autoOpen: false,
							minHeight: 100,
							minWidth: 400,
							modal: true,
							buttons: {
								"Generate" : function() {
									if( $.isNumeric( $('#qtyOfCodes').val() ) )  {
										$.ajax({
											type: "GET",
											url: "proxy/AJAXProxy.cfc",
											data: {
												method: 'generatePromoCodes',
												quantity: $('#qtyOfCodes').val()
											},
											success: function(data) {
												var arr = JSON.parse(data);
												$('#promoCode').val(arr.join('\n'));
												$('#modal-generateCodes').dialog("close")
											}
										})
									} else {
										$('#qtyOfCodes').addClass('ui-state-error');
									}
								},
								Cancel : function() {
									$('#modal-generateCodes').dialog("close");
								}
							},
							close: function() {
								$('#qtyOfCodes').val(1).removeClass('ui-state-error');
							}
							
					});
					
					$('#generateCodes').click(function() {
							$('#modal-generateCodes').dialog("open");
							$('#qtyOfCodes').focus();
						});
					
					
					//Validation
					$.validator.addMethod("money", function(value, element) {
					    return this.optional(element) || /^(\d{1,4})(\.\d{2})$/.test(value);
					}, "Must be in US currency format 0.99");
					
					$.validator.addMethod("greaterThanOrEqual", function(value, element, params) {
						if (!/Invalid|NaN/.test(new Date(value))) 
							return new Date(value) >= new Date(params);
						return isNaN(value) && isNaN(params) || (Number(value) >= Number(params)); 
					},'Must be greater than {0}.');
					
					$.validator.addMethod("optGreaterThan", function(value, element, params) {
						if (value.length == 0) return true;
						if (!/Invalid|NaN/.test(new Date(value))) 
							return new Date(value) > new Date(params);
						return isNaN(value) && isNaN(params) || (Number(value) > Number(params)); 
					},'Must be greater than {0}.');
					
					$.validator.addMethod("isValidPromotionCode", function(value, element, params) {
						var isValid = true;
						var codes = value
									.replace(/\r\n/g, "\n")
									.split("\n") 
									.filter(function(n){return n}); //Strip empty lines
						var regex = /^[A-Za-z0-9]*[A-Za-z0-9][A-Za-z0-9]*$/;
						for( var i=0; i<codes.length; i++ ){
							if( !regex.test(codes[i]) || codes[i].length < 3 )
								isValid = false;
						}
						return isValid;
					},'Must be at least 3 characters and contain only letters and numbers.' );
					
					$('#frmAddPromotionCode').validate({
						ignore: ":hidden.not('.chosen')",
						rules: {
							promoName : {
								minlength: 6,
								required: true
							},
							startDate: {
								required: true,
								date: true,
								greaterThanOrEqual: function() {
									if($('input[name=createdDate]').length) {
										var createdDate = parseDate($('input[name=createdDate]').val());
										var day = createdDate.getDate();
										var month = createdDate.getMonth()+1;
										var year = createdDate.getFullYear();
									} else {
										var today = new Date();
										var day = today.getDate();
										var month = today.getMonth()+1;
										var year = today.getFullYear();	
									}
									var formattedDate = month + '/'+ day + '/' + year;
									return formattedDate;
								}
							},
							endDate: {
								optGreaterThan: function() {
									return new Date( $('#startDate').val() );
								}
							},
							qty: {
								digits: true
							},
							qtyPerUser: {
								digits: true
							},
							promoCode: {
								isValidPromotionCode: true,
								required:{
									depends : function(e) {
										return !$('input[name="promotionID"]').length;
									}
								}
							},
							amountOff: {
								required: {
									depends: function(e) {
										return $('input[name="discountType"]:checked').val() == "amountOff"
									}
								}
							},
							percentOff: {
								required: {
									depends: function(e) {
										return $('input[name="discountType"]:checked').val() == "percentOff"
									}
								}
							},
							shippingMethodID: {
								required: {
									depends: function(e) {
										return $('input[name="discountType"]:checked').val() == "shippingMethod"
									}
								}
							},
							items: {
								required: {
									depends: function(e) {
										return $('input[name="appliesTo"]:checked').val() == "items"
									}
								}
							},
							isCartOrderTotalOptional: {
								required: {
									depends: function(e) {
										return $(e).parent().prev('input[type="text"]').val().length;
									}
								}
							},
							isCartAccessoryTotalOptional: {
								required: {
									depends: function(e) {
										return $(e).parent().prev('input[type="text"]').val().length;
									}
								}
							},
							isCartQuantityOptional: {
								required: {
									depends: function(e) {
										return $(e).parent().prev('input[type="text"]').val().length;
									}
								}
							},
							isCartAccessoryQuantityOptional: {
								required: {
									depends: function(e) {
										return $(e).parent().prev('input[type="text"]').val().length;
									}
								}
							},
							isCartSKUsOptional: {
								required: {
									depends: function(e) {
										return $('#cartSKUs option:selected').length;
									}
								}
							}
						},
						messages: {
							promoName : {
								minlength: "Please provide a more descriptive name.",
								required: "Please provide a name."
							},
							startDate : {
								required: "When do you want to start this promo?",
								date: "Invalid date.",
								greaterThanOrEqual: "Start date must be greater than or equal to today."
							},
							endDate : {
								optGreaterThan: "End date must be after start date."
							},
							qty: {
								digits: "Must be a positive integer."
							},
							qtyPerUser: {
								digits: "Must be a positive integer."
							},
							items : {
								required: "Please select item(s)."
							},
							isCartOrderTotalOptional : {
								required: "Please select required or optional."
							},
							isCartAccessoryTotalOptional : {
								required: "Please select required or optional."
							},
							isCartQuantityOptional : {
								required: "Please select required or optional."
							},
							isCartAccessoryQuantityOptional : {
								required: "Please select required or optional."
							},
							isCartSKUsOptional : {
								required: "Please select required or optional."
							}
						},
						errorPlacement: function(error, element) {
							if( element.next('.chosen-container').length ) {
								error.insertAfter( element.next('.chosen-container') );	
							} else if ( element.attr('type') == 'radio' ) {
								error.css("margin-left","10px").appendTo( element.parent() );
							} else {
								error.insertAfter( element );
							}
						}
					});
								
					function showDiscountTypeFields() {
						$('.discountType').hide();
						var discTypeClass = $('#discountType').val();
						$('.' + discTypeClass).show();	
					}
					
					function parseDate(input) {
						var parts = input.split('/');
						return new Date( parts[0], parts[1]-1, parts[2]);
					}
					
					function actOnEachLine(textarea, func) {
						var lines = textarea.value.replace(/\r\n/g, "\n").split("\n");
						var newLines, newValue, i;
						
						// Use the map() method of Array where available 
						if (typeof lines.map != "undefined") {
							newLines = lines.map(func);
						} else {
							newLines = [];
							i = lines.length;
							while (i--) {
							    newLines[i] = func(lines[i]);
							}
						}
						textarea.value = newLines.join("\r\n");
					}

				})
				
								
			</script>
			<link type="text/css" rel="stylesheet" href="assets/common/scripts/libs/chosen_v1.0.0/chosen.min.css" />
			<style type="text/css">
				p {
					margin:5px;
					padding:5px;
				}
				label {
					display:inline-block;
					width:160px;
					font-weight:bold;
				}
				label.error {
					width:auto;
				}
				.fauxLabel {
					display:block;
					padding-left:165px
				}
				.error {
					color:#FF0000;
					font-weight bold;
				}
				span.ui-icon {
					top:0;
				}
				.msgbox {
					text-align:center;
					padding:10px;
					margin:20px;
				}
				.warn {
					color:red;
					background-color:#ecb3b3;
				}
			</style>
			<cfoutput>
				<form id="frmAddPromotionCode" action="index.cfm?c=#url.c#" method="post" class="middle-forms">
					
					<fieldset>
						<input type="hidden" name="GO" value="save" />
						<input type="hidden" name="C" value="#url.c#" />
						
						<cfif structKeyExists( URL, "promotionID" ) && URL.promotionID GT 0>
							<input type="hidden" name="promotionID" value="#URL.promotionID#" />
						</cfif>
						
						<cfif qPromotion.recordCount && isNumeric( qPromotion.promotionConditionID )>
							<input type="hidden" name="conditionID" value="#qPromotion.promotionConditionID#" />
						</cfif>
						
						<cfif qPromotion.recordCount && isDate(qPromotion.createdDate)>
							<input type="hidden" name="createdDate" value="#dateFormat(qPromotion.createdDate, 'dd/mm/yyyy')#" />
						</cfif>
						
						<h3>Add or Modify Promotion</h3>
						<br />
						
						<label for="promoName">Name/Description:</label>
						<input type="text" name="promoName" id="promoName" value="<cfif qPromotion.recordCount>#qPromotion.Name#</cfif>" />
						<br />
						
						<label for="startDate">Start Date:</label>
						<input type="text" name="startDate" id="startDate" class="datepicker" value="<cfif qPromotion.recordCount>#dateFormat(qPromotion.startDate,'mm/dd/yyyy')#</cfif>"/>
						<br />
						
						<label for="endDate">End Date:</label>
						<input type="text" name="endDate" id="endDate" class="datepicker" value="<cfif qPromotion.recordCount && isDate(qPromotion.endDate)>#dateFormat(qPromotion.endDate,'mm/dd/yyyy')#</cfif>"/>
						<br />
						<strong class="fauxLabel">Leaving the End Date/Time field blank will cause the promotion code to never expire.</strong>
						<br />
						
						<!---
						<label for="qty">Quantity:</label>
						
						We are puttnig qty 0 in here as the way we are using accessories is there is not limit.
						---->
						<input type="hidden" name="qty" id="qty" class="qty" value="<!---<cfif qPromotion.recordCount>#qPromotion.MaxQuantity#</cfif>---->" />
						
						<!----
						<br />
						<strong class="fauxLabel">Leaving Quantity blank will allow for unlimited use.</strong>
						<br />
						---->
						
						<!---<label for="qtyPerUser">Quantity Per User:</label>
						<input type="text" name="qtyPerUser" id="qtyPerUser" class="qty" value="<cfif qPromotion.recordCount>#qPromotion.MaxQuantityPerUser#</cfif>" />
						<br />
						<strong class="fauxLabel">Leaving Quantity Per User blank will allow for unlimited use for a single user.</strong>
						<br />--->
						
					</fieldset>
					
					<fieldset>
						
						<hr />
						
						<h3>Codes</h3>
						
						<label for="promoCode">Create Code(s):</label>
						<!----<input type="button" id="generateCodes" value="Generate" />
						<br />
						---->
						<div class="fauxLabel">
							<textarea name="promoCode" id="promoCode" cols="15" rows="5" style="overflow-x: hidden;"></textarea>
						</div>
						<strong class="fauxLabel">You can create multiple codes by separating them onto their own line. <em>Codes must be unique.</em></strong>
						<br />
						
						<cfif qPromotionCodes.recordCount>
							<label>Existing Code(s):</label>
							<div style="margin:10px">
								<cfloop query="qPromotionCodes">#trim(qPromotionCodes.Code)#<cfif qPromotionCodes.currentRow neq qPromotionCodes.recordCount>,</cfif>	</cfloop>
							</div>
						</cfif>
						
					</fieldset>
					
					<fieldset>
						
						<hr />
						
						<h3>Discount</h3>
						
						<label for="discountType">Type:</label>
						<select name="discountType" id="discountType">
							<option value="amountOff" <cfif qPromotion.recordCount && qPromotion.discountType eq 'flat'>selected="selected"</cfif>>Flat amount</option>
							<option value="percentOff" <cfif qPromotion.recordCount && qPromotion.discountType eq 'percent'>selected="selected"</cfif>>Percent</option>
							<!---<option value="shippingMethod" <cfif qPromotion.recordCount && qPromotion.discountType eq 'shipping'>selected="selected"</cfif>>Shipping</option>--->
						</select>
						<br />
						
						<div class="amountOff discountType">
							<label for="amountOff">Amount off:</label>
							<input name="amountOff" id="amountOff" class="money number" value="<cfif qPromotion.recordCount && qPromotion.discountType eq 'flat'>#qPromotion.discount#</cfif>" />
						</div>
						
						<div class="percentOff discountType">
							<label for="percentOff">Percent off:</label>
							<input name="percentOff" id="percentOff" value="<cfif qPromotion.recordCount && qPromotion.discountType eq 'percent'>#round(qPromotion.discount)#</cfif>" />
						</div>
						
						<div class="shippingMethod discountType">
							<label for="shippingMethodID">Shipping Type:</label>
							<select name="shippingMethodID" id="shippingMethodID">
								<cfloop query="qShipMethods">
									<option value="#qShipMethods.ShipMethodID#" <cfif qPromotion.recordCount && qPromotion.discountType eq 'shipping' && qPromotion.discount eq qShipMethods.ShipMethodID>selected="selected"</cfif>>
										#qShipMethods.DisplayName# <cfif !qShipMethods.isActive>(Inactive)</em></cfif>
									</option>
								</cfloop>
							</select>
						</div>
						
						<label for="appliesTo">Applies to:</label>
						<input type="radio" name="appliesTo" value="order" <cfif !qOrderSKUs.recordCount>checked="checked"</cfif>/> Order
						<input type="radio" name="appliesTo" value="items" <cfif qOrderSKUs.recordCount>checked="checked"</cfif>/> Item(s)
						<br />
			</cfoutput>		
			<!---
						<div class="items">
							<br />
							<label for="items">Select SKUs:</label>
							<select name="items" id="items" multiple style="width:350px" class="chosen required">
								<cfoutput query="items" group="type">
									<optgroup label="#items.type#"><cfoutput>
										<option value="#items.GERSSKU#" 
											<cfif qOrderSKUs.recordCount>
												<cfloop query="qOrderSKUs">
													<cfif qOrderSKUs.GERSSKU eq items.GERSSKU>
														selected="selected"
													</cfif>
												</cfloop>
											</cfif>>#items.Description# (#items.GersSKU#)</option>
									</cfoutput></optgroup>
								</cfoutput>
							</select>
						</div>
						--->
			<cfoutput>
						<br />
						
					</fieldset>
						
					<fieldset>
						
						<hr />
						
						<h3>Qualifying Conditions</h3>

						<p><strong>Order must meet or exceed the following thresholds. Blank fields will be ignored. If all criteria are optional, the system will require at least one of them must met for this code to apply.</strong></p>

<!----
						<label for="cartOrderTotal">Order Total:</label>
						--->
						
						<input type="hidden" name="cartOrderTotal" id="cartOrderTotal" class="money number" value="<cfif qPromotion.recordCount && isNumeric(qPromotion.orderTotal)>#numberFormat(qPromotion.orderTotal,"9.99")#</cfif>" />
						
						<!---
						<div class="fauxLabel conditionOptional">
							<input type="radio" name="isCartOrderTotalOptional" value="0" <cfif qPromotion.recordCount && len(qPromotion.orderTotalOptional) && !qPromotion.orderTotalOptional>checked="checked"</cfif>/> Required
							<input type="radio" name="isCartOrderTotalOptional" value="1" <cfif qPromotion.recordCount && len(qPromotion.orderTotalOptional) && qPromotion.orderTotalOptional>checked="checked"</cfif>/> Optional
						</div>
						<br />
						
						<label for="cartAccessoryTotal">Accessory Total:</label>
						---->
						<input type="hidden" name="cartAccessoryTotal" id="cartAccessoryTotal" class="money number" value="<cfif qPromotion.recordCount && isNumeric(qPromotion.accessoryTotal)>#numberFormat(qPromotion.accessoryTotal, "9.99")#</cfif>"/>
						
						<!---<div class="fauxLabel conditionOptional">
							<input type="radio" name="isCartAccessoryTotalOptional" value="0" <cfif qPromotion.recordCount && len(qPromotion.accessoryTotalOptional) && !qPromotion.accessoryTotalOptional>checked="checked"</cfif>/> Required
							<input type="radio" name="isCartAccessoryTotalOptional" value="1" <cfif qPromotion.recordCount && len(qPromotion.accessoryTotalOptional) && qPromotion.accessoryTotalOptional>checked="checked"</cfif>/> Optional
						</div>
						<br />
						
						<label for="cartQuantity">Quantity of Items:</label>
						---->
						<input type="hidden" name="cartQuantity" id="cartQuantity" class="qty" value="<cfif qPromotion.recordCount>#qPromotion.orderQuantity#</cfif>"/>
						<!----
						<div class="fauxLabel conditionOptional">
							<input type="radio" name="isCartQuantityOptional" value="0" <cfif qPromotion.recordCount && len(qPromotion.orderQuantityOptional) && !qPromotion.orderQuantityOptional>checked="checked"</cfif>/> Required
							<input type="radio" name="isCartQuantityOptional" value="1" <cfif qPromotion.recordCount && len(qPromotion.orderQuantityOptional) && qPromotion.orderQuantityOptional>checked="checked"</cfif>/> Optional
						</div>
						<br />
						----->
						<label for="cartAccessoryQuantity">Quantity of Accessories:</label>
						<input type="text" name="cartAccessoryQuantity" id="cartAccessoryQuantity" class="qty" value="<cfif qPromotion.recordCount>#qPromotion.accessoryQuantity#</cfif>"/>
						<div class="fauxLabel conditionOptional">
							<input type="radio" name="isCartAccessoryQuantityOptional" value="0" <cfif qPromotion.recordCount && len(qPromotion.accessoryQuantityOptional) && !qPromotion.accessoryQuantityOptional>checked="checked"</cfif>/> Required
							<input type="radio" name="isCartAccessoryQuantityOptional" value="1" <cfif qPromotion.recordCount && len(qPromotion.accessoryQuantityOptional) && qPromotion.accessoryQuantityOptional>checked="checked"</cfif>/> Optional
						</div>
						<br />
						
			</cfoutput>
			<!----
						<label for="cartSKUs">Select SKUs:</label>
						<select name="cartSKUs" id="cartSKUs" multiple style="width:450px" class="chosen">
							<cfoutput query="items" group="type">
								<optgroup label="#items.type#"><cfoutput>
								<option value="#items.GERSSKU#" 
									<cfif qConditionSKUs.recordCount>
										<cfloop query="qConditionSKUs">
											<cfif qConditionSKUs.GERSSKU eq items.GERSSKU>
												selected="selected"
											</cfif>
										</cfloop>
									</cfif>>#items.Description# (#items.GersSKU#)</option>
								</cfoutput></optgroup>
							</cfoutput>
						</select>
			---->
			<cfoutput>
				<!---
						<div class="fauxLabel conditionOptional">
							<input type="radio" name="isCartSKUsOptional" value="0" <cfif qPromotion.recordCount && len(qPromotion.OrderSKUsOptional) && !qPromotion.OrderSKUsOptional>checked="checked"</cfif>/> Required
							<input type="radio" name="isCartSKUsOptional" value="1" <cfif qPromotion.recordCount && len(qPromotion.OrderSKUsOptional) && qPromotion.OrderSKUsOptional>checked="checked"</cfif>/> Optional
						</div>
						<br />
					---->	
					</fieldset>
					
					<fieldset>
						<input type="submit" name="submitPromoCode" value="Save" />
						<input type="button" name="cancelPromoCode" value="Cancel" />
					</fieldset>
					
				</form>
				
				<div id="modal-generateCodes" title="Generate Promotion Codes">
					<form>
						<p>
							Please enter a numeric value less than 5,000.
						</p>
						<p>
							<label for="qtyOfCodes">Quantity:</label>
							<input type="text" name="qtyOfCodes" id="qtyOfCodes" value="1" />
						</p>
					</form>
				</div>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn strOut>
	</cffunction>
	
	<!---<cffunction name="displayPromotionCodeAddForm_" access="public" returntype="string" output="false">

		<cfset var displayPromotionCodeAddReturn = '' />
		<cfset var qry_getBundles = this.bundles.getBundles() />

		<cfsavecontent variable="displayPromotionCodeAddReturn">
			<script type="text/javascript">
				function validateUSDate( strValue ) {
					var objRegExp = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/

				  //check to see if in correct format
				  if(!objRegExp.test(strValue))
				    return false; //doesn't match pattern, bad date
				  else{
				    var strSeparator = strValue.substring(2,3)
				    var arrayDate = strValue.split(strSeparator);
				    //create a lookup for months not equal to Feb.
				    var arrayLookup = { '01' : 31,'03' : 31,
				                        '04' : 30,'05' : 31,
				                        '06' : 30,'07' : 31,
				                        '08' : 31,'09' : 30,
				                        '10' : 31,'11' : 30,'12' : 31}
				    var intDay = parseInt(arrayDate[1],10);

				    //check if month value and day value agree
				    if(arrayLookup[arrayDate[0]] != null) {
				      if(intDay <= arrayLookup[arrayDate[0]] && intDay != 0)
				        return true; //found in lookup table, good date
				    }

				    //check for February (bugfix 20050322)
				    //bugfix  for parseInt kevin
				    //bugfix  biss year  O.Jp Voutat
				    var intMonth = parseInt(arrayDate[0],10);
				    if (intMonth == 2) {
				       var intYear = parseInt(arrayDate[2]);
				       if (intDay > 0 && intDay < 29) {
				           return true;
				       }
				       else if (intDay == 29) {
				         if ((intYear % 4 == 0) && (intYear % 100 != 0) ||
				             (intYear % 400 == 0)) {
				              // year div by 4 and ((not div by 100) or div by 400) ->ok
				             return true;
				         }
				       }
				    }
				  }
				  return false; //any other values, bad date
				}
				function validateAdd(theForm)	{
					var theForm = document.forms[theForm];

					if(!theForm.promotionCode.value.length || theForm.promotionCode.value.length == 10)	{
						alert('Please enter a valid promotion code.\nThe promotion code must be less than or greater than 10 characters.');
						theForm.promotionCode.focus();

						return false;
					} else if(!theForm.startDate.value.length || !validateUSDate(theForm.startDate.value))	{
						alert('Please enter a valid start date.');
						theForm.startDate.focus();

						return false;
					} else if(theForm.endDate.value.length > 0 && new Date(theForm.startDate.value) >= new Date(theForm.endDate.value))	{
						alert('Please enter a start date less then the end date.');
						theForm.endDate.focus();

						return false;
					} else if(!theForm.discountValue.value.length)	{
						alert('Please enter a valid promotion code value.');
						theForm.discountValue.focus();

						return false;
					} else if(!theForm.minPurchase.value.length)	{
						alert('Please enter a minimum purchase value.');
						theForm.minPurchase.focus();

						return false;
					} else if(theForm.discountValue.value < theForm.minPurchase.value)	{
						alert('Please enter a minimum purchase value greater than or equal to the discount value.');
						theForm.minPurchase.focus();

						return false;
					} else if(theForm.bundleId.options[theForm.bundleId.selectedIndex].value == 0)	{
						alert('Please choose a Bundle.');
						theForm.bundleId.focus();

						return false;
					} else {
						return true;
					}
				}
				$(function() {
					$("#startDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/common/images/icon-calendar.gif',
						buttonImageOnly: true
					});
					$("#endDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/common/images/icon-calendar.gif',
						buttonImageOnly: true
					});
				});
			</script>
			<cfoutput>
				<h3>Add Promotion Code</h3>
				<br />
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<form action="index.cfm?c=#url.c#" method="post" name="frmAddPromotionCode" onsubmit="return validateAdd(this.name)">
						<input type="hidden" name="GO" value="save" />
						<input type="hidden" name="C" value="#url.c#" />
						<input type="hidden" name="createdBy" value="#session.adminUser.adminUserId#" />
						<tr valign="top">
							<td width="100" style="padding: 3px">Promotion Code:</td>
							<td style="padding: 3px">
								<input type="text" id="promotionCode" name="promotionCode" style="width: 181px" maxlength="30" />
								<cfif structKeyExists(url, 'error') and url.error eq 1>
									<br />
									<span style="color: maroon">#trim(getError(errorCode = url.error))#</span>
								</cfif>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Start Date/Time:</td>
							<td style="padding: 3px">
								<input type="text" id="startDatePicker" name="startDate" style="width: 80px" />
								<select name="startTime">
									<cfloop from="0" to="23" index="idx">
										<option value="#idx#">#timeFormat(createTime(idx, 0, 0), 'hh:mm TT')#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr id="endDateTimeRow" align="top">
							<td width="100" style="padding: 3px">End Date/Time:</td>
							<td style="padding: 3px">
								<input type="text" id="endDatePicker" name="endDate" style="width: 80px" />
								<select name="endTime">
									<cfloop from="0" to="23" index="idx">
										<option value="#idx#">#timeFormat(createTime(idx, 0, 0), 'hh:mm TT')#</option>
									</cfloop>
								</select>
								<br />
								<div style="margin-top: 3px; font-size: 8pt; color: maroon">
									<strong>NOTE:</strong> Leaving the End Date/Time field blank will<br />
									cause the promotion code to <strong>never expire</strong>.
								</div>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Code Value:</td>
							<td style="padding: 3px"><input type="text" id="dv" onkeyup="document.getElementById('mp').value = this.value" value="0" name="discountValue" style="width: 50px" /></td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Code Type:</td>
							<td style="padding: 3px">
								<select name="promotionType" style="width: 56px">
									<option value="$">$</option>
									<option value="%">%</option>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Min. Purchase:</td>
							<td style="padding: 3px"><input type="text" id="mp" onkeyup="document.getElementById('dv').value = this.value" name="minPurchase" value="0" style="width: 50px" /></td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Bundle:</td>
							<td style="padding: 3px">
								<select name="bundleId">
									<option value="0">Select Bundle</option>
									<cfloop query="qry_getBundles">
										<option value="#qry_getBundles.Id[qry_getBundles.currentRow]#">#trim(qry_getBundles.name[qry_getBundles.currentRow])#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding: 3px">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2" style="text-align: center; padding: 3px">
								<input type="submit" name="saveChanges" value="Save Changes" style="width: 100px" />
								<input type="button" name="cancel" value="Cancel" style="width: 100px" onclick="history.go(-1)" />
							</td>
						</tr>
					</form>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(displayPromotionCodeAddReturn) />
	</cffunction>--->

	<!---<cffunction name="displayPromotionCodeEditForm" access="public" returntype="string" output="false">

		<cfset var displayPromotionCodeEditFormReturn = '' />
		<cfset var qry_getPromotionCode = getPromotionCode(promotionId = url.promotionId) />
		<cfset var qry_getBundles = this.bundles.getBundles() />

		<cfsavecontent variable="displayPromotionCodeEditFormReturn">
			<script type="text/javascript">
				function validateUSDate( strValue ) {
					var objRegExp = /^\d{1,2}(\-|\/|\.)\d{1,2}\1\d{4}$/

				  //check to see if in correct format
				  if(!objRegExp.test(strValue))
				    return false; //doesn't match pattern, bad date
				  else{
				    var strSeparator = strValue.substring(2,3)
				    var arrayDate = strValue.split(strSeparator);
				    //create a lookup for months not equal to Feb.
				    var arrayLookup = { '01' : 31,'03' : 31,
				                        '04' : 30,'05' : 31,
				                        '06' : 30,'07' : 31,
				                        '08' : 31,'09' : 30,
				                        '10' : 31,'11' : 30,'12' : 31}
				    var intDay = parseInt(arrayDate[1],10);

				    //check if month value and day value agree
				    if(arrayLookup[arrayDate[0]] != null) {
				      if(intDay <= arrayLookup[arrayDate[0]] && intDay != 0)
				        return true; //found in lookup table, good date
				    }

				    //check for February (bugfix 20050322)
				    //bugfix  for parseInt kevin
				    //bugfix  biss year  O.Jp Voutat
				    var intMonth = parseInt(arrayDate[0],10);
				    if (intMonth == 2) {
				       var intYear = parseInt(arrayDate[2]);
				       if (intDay > 0 && intDay < 29) {
				           return true;
				       }
				       else if (intDay == 29) {
				         if ((intYear % 4 == 0) && (intYear % 100 != 0) ||
				             (intYear % 400 == 0)) {
				              // year div by 4 and ((not div by 100) or div by 400) ->ok
				             return true;
				         }
				       }
				    }
				  }
				  return false; //any other values, bad date
				}
				function validateEdit(theForm)	{
					var theForm = document.forms[theForm];

					if(!theForm.promotionCode.value.length || theForm.promotionCode.value.length == 10)	{
						alert('Please enter a valid promotion code.\nThe promotion code must be less than or greater than 10 characters.');
						theForm.promotionCode.focus();

						return false;
					} else if(!theForm.startDate.value.length || !validateUSDate(theForm.startDate.value))	{
						alert('Please enter a valid start date.');
						theForm.startDate.focus();

						return false;
					} else if(theForm.endDate.value.length > 0 && new Date(theForm.startDate.value) >= new Date(theForm.endDate.value))	{
						alert('Please enter a start date less then the end date.');
						theForm.endDate.focus();

						return false;
					} else if(!theForm.discountValue.value.length)	{
						alert('Please enter a valid promotion code value.');
						theForm.discountValue.focus();

						return false;
					} else if(!theForm.minPurchase.value.length)	{
						alert('Please enter a minimum purchase value.');
						theForm.minPurchase.focus();

						return false;
					} else if(theForm.discountValue.value < theForm.minPurchase.value)	{
						alert('Please enter a minimum purchase value greater than or equal to the discount value.');
						theForm.minPurchase.focus();

						return false;
					} else if(theForm.bundleId.options[theForm.bundleId.selectedIndex].value == 0)	{
						alert('Please choose a Bundle.');
						theForm.bundleId.focus();

						return false;
					} else {
						return true;
					}
				}
				$(function() {
					$("#startDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/common/images/icon-calendar.gif',
						buttonImageOnly: true
					});
					$("#endDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/common/images/icon-calendar.gif',
						buttonImageOnly: true
					});
				});
			</script>
			<cfoutput>
				<h3>Edit Promotion Code</h3>
				<br />
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<form action="index.cfm?c=#url.c#" method="post" name="frmEditPromotionCode" onsubmit="return validateEdit(this.name)">
						<input type="hidden" name="GO" value="saveEdit" />
						<input type="hidden" name="C" value="#url.c#" />
						<input type="hidden" name="updatedBy" value="#session.adminUser.adminUserId#" />
						<input type="hidden" name="promotionId" value="#url.promotionId#" />
						<tr valign="top">
							<td width="100" style="padding: 3px">Promotion Code:</td>
							<td style="padding: 3px"><input type="text" id="promotionCode" name="promotionCode" value="#ucase(trim(qry_getPromotionCode.promotionCode))#" style="width: 181px" maxlength="30" /></td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Start Date/Time:</td>
							<td style="padding: 3px">
								<input type="text" id="startDatePicker" name="startDate" value="<cfif isDate(qry_getPromotionCode.startDate)>#dateFormat(qry_getPromotionCode.startDate, 'mm/dd/yyyy')#</cfif>" style="width: 80px" />
								<select name="startTime">
									<cfloop from="0" to="23" index="idx">
										<option value="#idx#" #iif(hour(qry_getPromotionCode.startDate) eq idx, de('selected'), de(''))#>#timeFormat(createTime(idx, 0, 0), 'hh:mm TT')#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">End Date/Time:</td>
							<td style="padding: 3px">
								<input type="text" id="endDatePicker" name="endDate" value="<cfif isDate(qry_getPromotionCode.endDate) and qry_getPromotionCode.endDate neq '01/01/2099'>#dateFormat(qry_getPromotionCode.endDate, 'mm/dd/yyyy')#</cfif>" style="width: 80px" />
								<select name="endTime">
									<cfloop from="0" to="23" index="idx">
										<option value="#idx#" #iif(hour(qry_getPromotionCode.endDate) eq idx, de('selected'), de(''))#>#timeFormat(createTime(idx, 0, 0), 'hh:mm TT')#</option>
									</cfloop>
								</select>
								<br />
								<div style="margin-top: 3px; font-size: 8pt; color: maroon">
									<strong>NOTE:</strong> Leaving the End Date/Time field blank will<br />
									cause the promotion code to <strong>never expire</strong>.
								</div>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Code Value:</td>
							<td style="padding: 3px"><input type="text" id="dv" onkeyup="document.getElementById('mp').value = this.value" name="discountValue" value="#val(qry_getPromotionCode.discountValue)#" style="width: 50px" /></td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Code Type:</td>
							<td style="padding: 3px">
								<select name="promotionType" style="width: 56px">
									<option value="$" #iif(qry_getPromotionCode.promotionType is '$', de('selected'), de(''))#>$</option>
									<option value="%" #iif(qry_getPromotionCode.promotionType is '%', de('selected'), de(''))#>%</option>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Min. Purchase:</td>
							<td style="padding: 3px"><input type="text" id="mp" onkeyup="document.getElementById('dv').value = this.value" name="minPurchase" value="#val(qry_getPromotionCode.minPurchase)#" style="width: 50px" /></td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Bundle:</td>
							<td style="padding: 3px">
								<select name="bundleId">
									<option value="0">Select Bundle</option>
									<cfloop query="qry_getBundles">
										<option value="#qry_getBundles.Id[qry_getBundles.currentRow]#" #iif(qry_getPromotionCode.bundleId eq qry_getBundles.Id[qry_getBundles.currentRow], de('selected'), de(''))#>#trim(qry_getBundles.name[qry_getBundles.currentRow])#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding: 3px">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2" style="text-align: center; padding: 3px">
								<input type="submit" name="saveChanges" value="Save Changes" style="width: 100px" />
								<input type="button" name="cancel" value="Cancel" style="width: 100px" onclick="history.go(-1)" />
							</td>
						</tr>
					</form>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(displayPromotionCodeEditFormReturn) />
	</cffunction>--->
	

	<!---<cffunction name="updatePromotionCode" access="public" returntype="boolean" output="false">
		<cfargument name="promotionId" required="true" type="string" />
		<cfargument name="promotionCode" required="true" type="string" />
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="startTime" required="true" type="numeric" />
		<cfargument name="endDate" required="true" type="string" />
		<cfargument name="endTime" required="true" type="numeric" />
		<cfargument name="discountValue" required="true" type="numeric" />
		<cfargument name="updatedBy" required="true" type="numeric" />
		<cfargument name="minPurchase" required="false" type="numeric" default="0" />
		<cfargument name="bundleId" required="true" type="numeric" />
		<cfargument name="promotionType" required="true" type="string" />

		<cfset var updatePromotionCodeReturn = false />

		<cfset arguments.startDateTime = createDateTime(year(arguments.startDate), month(arguments.startDate), day(arguments.startDate), arguments.startTime, 0, 0) />

		<cfif len(trim(arguments.endDate))>
			<cfset arguments.endDateTime = createDateTime(year(arguments.endDate), month(arguments.endDate), day(arguments.endDate), arguments.endTime, 0, 0) />
		<cfelse>
			<cfset arguments.endDateTime = createDateTime(2099, 1, 1, 0, 0, 0) />
		</cfif>

		<cfset updatePromotionCodeReturn = this.model.updatePromotionCode(argumentCollection = arguments) />

		<cfif updatePromotionCodeReturn>
			<cflocation url="index.cfm?c=#url.c#&go=home&edit=true" addtoken="false" />
		<cfelse>
			<cflocation url="index.cfm?c=#url.c#&go=edit&promotionId=#arguments.promotionId#&error=true" addtoken="false" />
		</cfif>

		<cfreturn updatePromotionCodeReturn />
	</cffunction>

	<cffunction name="removePromotionCode" access="public" returntype="boolean" output="false">
		<cfargument name="promotionId" required="true" type="string" />

		<cfset var removePromotionCodeReturn = this.model.removePromotionCode(argumentCollection = arguments) />

		<cfif removePromotionCodeReturn>
			<cflocation url="index.cfm?c=#url.c#&go=home&remove=true" addtoken="false" />
		<cfelse>
			<cflocation url="index.cfm?c=#url.c#&go=home" addtoken="false" />
		</cfif>

		<cfreturn removePromotionCodeReturn />
	</cffunction>

	<cffunction name="promotionCodeExists" access="public" returntype="boolean" output="false">
		<cfargument name="promotionCode" required="true" type="string" />

		<cfreturn this.model.promotionCodeExists(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="promotionCodeHasBeenAssigned" access="public" returntype="boolean" output="false">
		<cfargument name="promotionId" required="true" type="numeric" />
		<cfargument name="isRedeemed" required="false" type="boolean" />
		
		<cfreturn false>
		<cfreturn this.model.promotionCodeHasBeenAssigned(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="getError" access="public" returntype="string" output="false">
		<cfargument name="errorCode" required="true" type="numeric" />

		<cfreturn this.model.getError(argumentCollection = arguments) />
	</cffunction>--->
	
	<cffunction name="getPromotionGateway" access="private" output="false" returntype="any">    
		<cfreturn application.wirebox.getInstance("PromotionGateway") />
    </cffunction>
    
    <cffunction name="getChannelConfig" access="private" output="false" returntype="any">
		<cfreturn application.wirebox.getInstance("ChannelConfig") />    
    </cffunction>    
    
    
</cfcomponent>