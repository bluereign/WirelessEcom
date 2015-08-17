<cfcomponent name="Coupon" output="false">

	<cffunction name="init" access="public" returntype="Coupon" output="false">

		<cfset this.model = application.model.coupon />

		<cfreturn this />
	</cffunction>

	<cffunction name="displayCoupons" access="public" returntype="string" output="false">

		<cfset var displayCouponsReturn = '' />
		<cfset var qry_getCoupons = getCoupons() />

		<cfsavecontent variable="displayCouponsReturn">
			<h3>Coupon Codes</h3>
			<br />
			<cfif structKeyExists(url, 'add') and url.add>
				<p style="font-weight: bold; color: green; text-align: center">The coupon has been added successfully.</p>
			</cfif>
			<cfif structKeyExists(url, 'remove') and url.remove>
				<p style="font-weight: bold; color: green; text-align: center">The coupon has been removed successfully.</p>
			</cfif>
			<cfif structKeyExists(url, 'edit') and url.edit>
				<p style="font-weight: bold; color: green; text-align: center">The coupon has been updated successfully.</p>
			</cfif>
			<table width="100%" cellpadding="3" cellspacing="0" border="0">
				<cfoutput>
					<form action="index.cfm?c=#request.p.c#" method="post">
						<input type="hidden" name="GO" value="add" />
						<tr>
							<td style="text-align: right"><input type="submit" name="addCoupon" value="Add Coupon" style="width: 100px" /></td>
						</tr>
					</form>
				</cfoutput>
			</table>
			<br />
			<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="#cccccc">
				<tr>
					<td width="80" style="text-align: center; font-weight: bold; padding: 3px">Actions</td>
					<td style="font-weight: bold; padding: 3px">Code</td>
					<td width="130" style="text-align: center; font-weight: bold; padding: 3px">Start Date/Time</td>
					<td width="130" style="text-align: center; font-weight: bold; padding: 3px">End Date/Time</td>
					<td width="130" style="text-align: center; font-weight: bold; padding: 3px">Created</td>
					<td width="80" style="text-align: center; font-weight: bold; padding: 3px">Value</td>
				</tr>
				<cfif qry_getCoupons.recordCount>
					<cfoutput>
						<cfloop query="qry_getCoupons">
							<cfif isDate(qry_getCoupons.validStartDate[qry_getCoupons.currentRow]) and isDate(qry_getCoupons.validEndDate[qry_getCoupons.currentRow]) and qry_getCoupons.validEndDate[qry_getCoupons.currentRow] lte now()>
								<tr style="background-color: maroon; color: ##ffffff">
							<cfelse>
								<tr style="background-color: ###iif(qry_getCoupons.currentRow mod 2, de('ececec'), de('ffffff'))#">
							</cfif>
								<cfif isDate(qry_getCoupons.validStartDate[qry_getCoupons.currentRow]) and isDate(qry_getCoupons.validEndDate[qry_getCoupons.currentRow]) and qry_getCoupons.validEndDate[qry_getCoupons.currentRow] lte now()>
									<td width="80" style="text-align: center; padding: 3px; background-color: ##ffffff; color: maroon">
										Expired
										<cfif not couponHasBeenAssigned(couponId = qry_getCoupons.couponId[qry_getCoupons.currentRow], isRedeemed = true)>
											<a href="javascript:void(0)" onclick="if(confirm('Are you sure you would like to remove this coupon code?')){window.location='index.cfm?c=#url.c#&go=delete&couponId=#qry_getCoupons.couponId[qry_getCoupons.currentRow]#'}"><img src="assets/images/icon-delete.gif" alt="Remove Coupon" border="0" width="16" height="16" /></a>
										</cfif>
									</td>
								<cfelse>
									<td width="80" style="text-align: center; padding: 3px; background-color: ##ffffff">
										<a href="index.cfm?c=#url.c#&go=edit&couponId=#qry_getCoupons.couponId[qry_getCoupons.currentRow]#"><img src="assets/images/icon-edit.gif" alt="Edit Coupon" border="0" width="16" height="16" /></a>
										<cfif not couponHasBeenAssigned(couponId = qry_getCoupons.couponId[qry_getCoupons.currentRow], isRedeemed = true)>
											<a href="javascript:void(0)" onclick="if(confirm('Are you sure you would like to remove this coupon code?')){window.location='index.cfm?c=#url.c#&go=delete&couponId=#qry_getCoupons.couponId[qry_getCoupons.currentRow]#'}"><img src="assets/images/icon-delete.gif" alt="Remove Coupon" border="0" width="16" height="16" /></a>
										</cfif>
									</td>
								</cfif>
								<td style="padding: 3px">#ucase(trim(qry_getCoupons.couponCode[qry_getCoupons.currentRow]))#</td>
								<td width="130" style="text-align: center; padding: 3px"><cfif isDate(qry_getCoupons.validStartDate[qry_getCoupons.currentRow])>#dateFormat(qry_getCoupons.validStartDate[qry_getCoupons.currentRow], 'mm/dd/yyyy')# - #timeFormat(qry_getCoupons.validStartDate[qry_getCoupons.currentRow], 'hh:mm TT')#<cfelse>N/A</cfif></td>
								<td width="130" style="text-align: center; padding: 3px"><cfif isDate(qry_getCoupons.validEndDate[qry_getCoupons.currentRow])>#dateFormat(qry_getCoupons.validEndDate[qry_getCoupons.currentRow], 'mm/dd/yyyy')# - #timeFormat(qry_getCoupons.validEndDate[qry_getCoupons.currentRow], 'hh:mm TT')#<cfelse>N/A</cfif></td>
								<td width="130" style="text-align: center; padding: 3px"><cfif isDate(qry_getCoupons.dateCreated[qry_getCoupons.currentRow])>#dateFormat(qry_getCoupons.dateCreated[qry_getCoupons.currentRow], 'mm/dd/yyyy')# - #timeFormat(qry_getCoupons.dateCreated[qry_getCoupons.currentRow], 'hh:mm TT')#<cfelse>N/A</cfif></td>
								<td width="80" style="text-align: right; padding: 3px">#dollarFormat(val(qry_getCoupons.discountValue[qry_getCoupons.currentRow]))#&nbsp;</td>
							</tr>
						</cfloop>
					</cfoutput>
				<cfelse>
					<tr style="background-color: #ffffff">
						<td colspan="6" style="text-align: center; padding: 3px">No coupon codes currently exist.</td>
					</tr>
				</cfif>
			</table>
		</cfsavecontent>

		<cfreturn trim(displayCouponsReturn) />
	</cffunction>

	<cffunction name="displayCouponAddForm" access="public" returntype="string" output="false">

		<cfset var displayCouponAddReturn = '' />

		<cfsavecontent variable="displayCouponAddReturn">
			<script type="text/javascript">
				function randomString()	{
					var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ';
					var string_length = 10;
					var randomString = '';

					for (var i = 0; i < string_length; i++)	{
						var rNum = Math.floor(Math.random() * chars.length);
						randomString += chars.substring(rNum, (rNum + 1));
					}

					return randomString;
				}
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

					if(!theForm.couponCode.value.length)	{
						alert('Please enter a valid coupon code.');
						theForm.couponCode.focus();

						return false;
					} else if(!theForm.startDate.value.length || !validateUSDate(theForm.startDate.value))	{
						alert('Please enter a valid start date.');
						theForm.startDate.focus();

						return false;
					} else if(theForm.endDate.value.length > 0)	{
						if(new Date(theForm.startDate.value) >= new Date(theForm.endDate.value))	{
							alert('Please enter a start date less then the end date.');
							theForm.endDate.focus();

							return false;
						}
					/*} else if(!theForm.discountValue.value.length)	{
						alert('Please enter a valid coupon value.');
						theForm.discountValue.focus();

						return false;*/
					} else if(!theForm.minPurchase.value.length)	{
						alert('Please enter a minimum purchase value.');
						theForm.minPurchase.focus();

						return false;
					} else if(theForm.minPurchase.value < theForm.discountValue.options[theForm.discountValue.selectedIndex].value)	{
						alert('Please enter a minimum purchase value greater than or equal to the discount value.');
						theForm.minPurchase.focus();

						return false;
					} else {
						return true;
					}
				}
				function generateCouponCode()	{
					document.getElementById('couponCode').value = randomString();
					document.getElementById('generateCode').style.display = 'none'
				}
				$(function() {
					$("#startDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/images/icon-calendar.gif',
						buttonImageOnly: true
					});
					$("#endDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/images/icon-calendar.gif',
						buttonImageOnly: true
					});
				});
			</script>
			<cfoutput>
				<h3>Add Coupon</h3>
				<br />
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<form action="index.cfm?c=#url.c#" method="post" name="frmAddCoupon" onsubmit="return validateAdd(this.name)">
						<input type="hidden" name="GO" value="saveAdd" />
						<input type="hidden" name="C" value="#url.c#" />
						<input type="hidden" name="createdBy" value="#session.adminUser.adminUserId#" />
						<tr valign="top">
							<td width="100" style="padding: 3px">Coupon Code:</td>
							<td style="padding: 3px">
								<input type="text" id="couponCode" name="couponCode" style="width: 181px; background-color: ##ececec; border: 1px solid ##cccccc" readonly="true" />
								<a id="generateCode" href="javascript:void(0)" onclick="generateCouponCode()">Generate</a>
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
									cause the coupon to <strong>never expire</strong>.
								</div>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Coupon Value:</td>
							<td style="padding: 3px">
								<select id="discountValueSelection" name="discountValue" style="width: 86px" onchange="document.getElementById('mp').value = parseInt(this.options[this.selectedIndex].value).toFixed(2)">
									<option value="10">$10.00</option>
									<option value="15">$15.00</option>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Min. Purchase:</td>
							<td style="padding: 3px"><input type="text" id="mp" name="minPurchase" value="10.00" style="width: 50px; border: 0px" readonly="true" /></td>
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
				<script type="text/javascript">generateCouponCode();</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(displayCouponAddReturn) />
	</cffunction>

	<cffunction name="displayCouponEditForm" access="public" returntype="string" output="false">

		<cfset var displayCouponEditFormReturn = '' />
		<cfset var qry_getCoupon = getCoupon(couponId = url.couponId) />

		<cfsavecontent variable="displayCouponEditFormReturn">
			<script type="text/javascript">
				function randomString()	{
					var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZ';
					var string_length = 10;
					var randomString = '';

					for (var i = 0; i < string_length; i++)	{
						var rNum = Math.floor(Math.random() * chars.length);
						randomString += chars.substring(rNum, (rNum + 1));
					}

					return randomString;
				}
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

					if(!theForm.couponCode.value.length)	{
						alert('Please enter a valid coupon code.');
						theForm.couponCode.focus();

						return false;
					} else if(!theForm.startDate.value.length || !validateUSDate(theForm.startDate.value))	{
						alert('Please enter a valid start date.');
						theForm.startDate.focus();

						return false;
					} else if(theForm.endDate.value.length > 0)	{
						if(new Date(theForm.startDate.value) >= new Date(theForm.endDate.value))	{
							alert('Please enter a start date less then the end date.');
							theForm.endDate.focus();

							return false;
						}
					/*} else if(!theForm.discountValue.value.length)	{
						alert('Please enter a valid coupon value.');
						theForm.discountValue.focus();

						return false;*/
					} else if(!theForm.minPurchase.value.length)	{
						alert('Please enter a minimum purchase value.');
						theForm.minPurchase.focus();

						return false;
					} else if(theForm.minPurchase.value < theForm.discountValue.options[theForm.discountValue.selectedIndex].value)	{
						alert('Please enter a minimum purchase value greater than or equal to the discount value.');
						theForm.minPurchase.focus();

						return false;
					} else {
						return true;
					}
				}
				function generateCouponCode()	{
					document.getElementById('couponCode').value = randomString();
					document.getElementById('generateCode').style.display = 'none'
				}
				$(function() {
					$("#startDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/images/icon-calendar.gif',
						buttonImageOnly: true
					});
					$("#endDatePicker").datepicker({
						showOn: 'button',
						buttonImage: 'assets/images/icon-calendar.gif',
						buttonImageOnly: true
					});
				});
			</script>
			<cfoutput>
				<h3>Edit Coupon</h3>
				<br />
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<form action="index.cfm?c=#url.c#" method="post" name="frmEditCoupon" onsubmit="return validateEdit(this.name)">
						<input type="hidden" name="GO" value="saveEdit" />
						<input type="hidden" name="C" value="#url.c#" />
						<input type="hidden" name="updatedBy" value="#session.adminUser.adminUserId#" />
						<input type="hidden" name="couponId" value="#url.couponId#" />
						<tr valign="top">
							<td width="100" style="padding: 3px">Coupon Code:</td>
							<td style="padding: 3px"><input type="text" id="couponCode" name="couponCode" value="#ucase(trim(qry_getCoupon.couponCode))#" style="width: 181px; background-color: ##ececec; border: 1px solid ##cccccc" readonly="true" /></td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Start Date/Time:</td>
							<td style="padding: 3px">
								<input type="text" id="startDatePicker" name="startDate" value="<cfif isDate(qry_getCoupon.validStartDate)>#dateFormat(qry_getCoupon.validStartDate, 'mm/dd/yyyy')#</cfif>" style="width: 80px" />
								<select name="startTime">
									<cfloop from="0" to="23" index="idx">
										<option value="#idx#" #iif(hour(qry_getCoupon.validStartDate) eq idx, de('selected'), de(''))#>#timeFormat(createTime(idx, 0, 0), 'hh:mm TT')#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">End Date/Time:</td>
							<td style="padding: 3px">
								<input type="text" id="endDatePicker" name="endDate" value="<cfif isDate(qry_getCoupon.validEndDate) and qry_getCoupon.validEndDate neq '01/01/2099'>#dateFormat(qry_getCoupon.validEndDate, 'mm/dd/yyyy')#</cfif>" style="width: 80px" />
								<select name="endTime">
									<cfloop from="0" to="23" index="idx">
										<option value="#idx#" #iif(hour(qry_getCoupon.validEndDate) eq idx, de('selected'), de(''))#>#timeFormat(createTime(idx, 0, 0), 'hh:mm TT')#</option>
									</cfloop>
								</select>
								<br />
								<div style="margin-top: 3px; font-size: 8pt; color: maroon">
									<strong>NOTE:</strong> Leaving the End Date/Time field blank will<br />
									cause the coupon to <strong>never expire</strong>.
								</div>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Coupon Value:</td>
							<td style="padding: 3px">
								<select name="discountValue" style="width: 86px" onchange="document.getElementById('mp').value = parseInt(this.options[this.selectedIndex].value).toFixed(2)">
									<option value="10" #iif(listFirst(val(qry_getCoupon.discountValue), '.') eq 10, de('selected'), de(''))#>$10.00</option>
									<option value="15" #iif(listFirst(val(qry_getCoupon.discountValue), '.') eq 15, de('selected'), de(''))#>$15.00</option>
								</select>
							</td>
						</tr>
						<tr valign="top">
							<td width="100" style="padding: 3px">Min. Purchase:</td>
							<td style="padding: 3px"><input type="text" id="mp" name="minPurchase" value="#decimalFormat(val(qry_getCoupon.minPurchase))#" style="width: 50px; border: 0px" readonly="true" /></td>
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

		<cfreturn trim(displayCouponEditFormReturn) />
	</cffunction>

	<cffunction name="getCoupons" access="public" returntype="query" output="false">
		<cfreturn this.model.getCoupons() />
	</cffunction>

	<cffunction name="getCoupon" access="public" returntype="query" output="false">
		<cfargument name="couponId" required="false" type="string" />
		<cfargument name="couponCode" required="false" type="string" />

		<cfreturn this.model.getCoupon(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="insertCoupon" access="public" returntype="boolean" output="false">
		<cfargument name="c" required="true" type="string" />
		<cfargument name="couponCode" required="true" type="string" />
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="startTime" required="true" type="numeric" />
		<cfargument name="endDate" required="true" type="string" />
		<cfargument name="endTime" required="true" type="numeric" />
		<cfargument name="discountValue" required="true" type="numeric" />
		<cfargument name="createdBy" required="true" type="numeric" />
		<cfargument name="minPurchase" required="false" type="numeric" default="0" />

		<cfset var insertCouponReturn = false />
		<cfset var errorCode = 0 />

		<cfset arguments.startDateTime = createDateTime(year(arguments.startDate), month(arguments.startDate), day(arguments.startDate), arguments.startTime, 0, 0) />

		<cfif len(trim(arguments.endDate))>
			<cfset arguments.endDateTime = createDateTime(year(arguments.endDate), month(arguments.endDate), day(arguments.endDate), arguments.endTime, 0, 0) />
		<cfelse>
			<cfset arguments.endDateTime = createDateTime(2099, 1, 1, 0, 0, 0) />
		</cfif>

		<cfif not couponExists(couponCode = arguments.couponCode)>
			<cfset insertCouponReturn = this.model.insertCoupon(argumentCollection = arguments) />
		<cfelse>
			<cfset errorCode = 1 />
		</cfif>

		<cfif insertCouponReturn>
			<cflocation url="index.cfm?c=#arguments.c#&go=home&add=true" addtoken="false" />
		<cfelse>
			<cflocation url="index.cfm?c=#arguments.c#&go=add&error=#errorCode#" addtoken="false" />
		</cfif>

		<cfreturn  />
	</cffunction>

	<cffunction name="updateCoupon" access="public" returntype="boolean" output="false">
		<cfargument name="couponId" required="true" type="string" />
		<cfargument name="couponCode" required="true" type="string" />
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="startTime" required="true" type="numeric" />
		<cfargument name="endDate" required="true" type="string" />
		<cfargument name="endTime" required="true" type="numeric" />
		<cfargument name="discountValue" required="true" type="numeric" />
		<cfargument name="updatedBy" required="true" type="numeric" />
		<cfargument name="minPurchase" required="false" type="numeric" default="0" />

		<cfset var updateCouponReturn = false />

		<cfset arguments.startDateTime = createDateTime(year(arguments.startDate), month(arguments.startDate), day(arguments.startDate), arguments.startTime, 0, 0) />

		<cfif len(trim(arguments.endDate))>
			<cfset arguments.endDateTime = createDateTime(year(arguments.endDate), month(arguments.endDate), day(arguments.endDate), arguments.endTime, 0, 0) />
		<cfelse>
			<cfset arguments.endDateTime = createDateTime(2099, 1, 1, 0, 0, 0) />
		</cfif>

		<cfset updateCouponReturn = this.model.updateCoupon(argumentCollection = arguments) />

		<cfif updateCouponReturn>
			<cflocation url="index.cfm?c=#url.c#&go=home&edit=true" addtoken="false" />
		<cfelse>
			<cflocation url="index.cfm?c=#url.c#&go=edit&couponId=#arguments.couponId#&error=true" addtoken="false" />
		</cfif>

		<cfreturn updateCouponReturn />
	</cffunction>

	<cffunction name="removeCoupon" access="public" returntype="boolean" output="false">
		<cfargument name="couponId" required="true" type="string" />

		<cfset var removeCouponReturn = this.model.removeCoupon(argumentCollection = arguments) />

		<cfif removeCouponReturn>
			<cflocation url="index.cfm?c=#url.c#&go=home&remove=true" addtoken="false" />
		<cfelse>
			<cflocation url="index.cfm?c=#url.c#&go=home" addtoken="false" />
		</cfif>

		<cfreturn removeCouponReturn />
	</cffunction>

	<cffunction name="couponExists" access="public" returntype="boolean" output="false">
		<cfargument name="couponCode" required="true" type="string" />

		<cfreturn this.model.couponExists(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="couponHasBeenAssigned" access="public" returntype="boolean" output="false">
		<cfargument name="couponId" required="true" type="numeric" />
		<cfargument name="isRedeemed" required="false" type="boolean" />

		<cfreturn this.model.couponHasBeenAssigned(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="getError" access="public" returntype="string" output="false">
		<cfargument name="errorCode" required="true" type="numeric" />

		<cfreturn this.model.getError(argumentCollection = arguments) />
	</cffunction>
</cfcomponent>