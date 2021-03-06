<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfif not isDefined('session.checkout.returningCustomer')>
	<cfif session.UserAuth.isLoggedIn()>
		<cfset session.checkout.returningCustomer = 1 />
	<cfelse>
		<cfset session.checkout.returningCustomer = 0 />
	</cfif>
</cfif>

<!---
**
* If the user is not logged in but we have an emailAddress and password.
**
--->
<cfif not session.UserAuth.isLoggedIn() and len(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))) and len(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.existingUserPassword')))>
	<!--- Authenticate the User --->
	<cfset session.currentUser = createObject('component', 'cfc.model.User').init() />
	<cfset session.currentUser.login(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'), application.model.checkoutHelper.formValue('session.checkout.billShipForm.existingUserPassword')) />
</cfif>

<!---
**
* Get "Your Account Info" from signed in user, if this form has not yet been submitted.
**
--->
<cfif not application.model.checkoutHelper.isStepCompleted('billShip') and not structKeyExists(form, 'billFirstName') and session.UserAuth.isLoggedIn()>

	<cfset application.model.User.getUserByID(session.userId) />

	<cfset session.checkout.billShipForm.emailAddress = trim(session.currentUser.getEmail()) />

	<cfset session.checkout.billShipForm.billFirstName = trim(session.currentUser.getFirstName()) />
	<cfset session.checkout.billShipForm.billLastName = trim(session.currentUser.getLastName()) />
    <cfset session.checkout.billShipForm.billMiddleInitial = trim(session.currentUser.getMiddleInitial()) />
	<cfset session.checkout.billShipForm.billCompany = trim(session.currentUser.getBillingAddress().getCompany()) />
	<cfset session.checkout.billShipForm.billAddress1 = trim(session.currentUser.getBillingAddress().getAddressLine1()) />
	<cfset session.checkout.billShipForm.billAddress2 = trim(session.currentUser.getBillingAddress().getAddressLine2()) />
	<cfset session.checkout.billShipForm.billCity = trim(session.currentUser.getBillingAddress().getCity()) />
	<cfset session.checkout.billShipForm.billState = trim(session.currentUser.getBillingAddress().getState()) />
	<cfset session.checkout.billShipForm.billZip = trim(session.currentUser.getBillingAddress().getZipCode()) />
	<cfset session.checkout.billShipForm.billDayPhone = trim(session.currentUser.getBillingAddress().getDayPhone()) />
	<cfset session.checkout.billShipForm.billEvePhone = trim(session.currentUser.getBillingAddress().getEvePhone()) />
	<cfset session.checkout.billShipForm.shipEvePhone = trim(session.currentUser.getShippingAddress().getMilitaryBase()) />
	<cfset session.checkout.billShipForm.billMilitaryBase = trim(session.currentUser.getShippingAddress().getMilitaryBase()) />

	<cfset session.checkout.billShipForm.shipFirstName = trim(session.currentUser.getFirstName()) />
	<cfset session.checkout.billShipForm.shipLastName = trim(session.currentUser.getLastName()) />
    <cfset session.checkout.billShipForm.shipMiddleInitial = trim(session.currentUser.getMiddleInitial()) />
	<cfset session.checkout.billShipForm.shipCompany = trim(session.currentUser.getShippingAddress().getCompany()) />
	<cfset session.checkout.billShipForm.shipAddress1 = trim(session.currentUser.getShippingAddress().getAddressLine1()) />
	<cfset session.checkout.billShipForm.shipAddress2 = trim(session.currentUser.getShippingAddress().getAddressLine2()) />
	<cfset session.checkout.billShipForm.shipCity = trim(session.currentUser.getShippingAddress().getCity()) />
	<cfset session.checkout.billShipForm.shipState = trim(session.currentUser.getShippingAddress().getState()) />
	<cfset session.checkout.billShipForm.shipZip = trim(session.currentUser.getShippingAddress().getZipCode()) />
	<cfset session.checkout.billShipForm.shipDayPhone = trim(session.currentUser.getShippingAddress().getDayPhone()) />
	<cfset session.checkout.billShipForm.shipEvePhone = trim(session.currentUser.getShippingAddress().getEvePhone()) />
	<cfset session.checkout.billShipForm.shipMilitaryBase = trim(session.currentUser.getShippingAddress().getMilitaryBase()) />
</cfif>

<cfif request.validator.fieldHasMessages('hiddenUserAuthenticated')>
	<cfset session.checkout.billShipForm.emailAddress = '' />
</cfif>

<cfset GeoService = application.wirebox.getInstance("GeoService") />
<cfset request.p.states = GeoService.getAllStates() />
<cfif request.config.allowAPOFPO>
	<cfset request.p.shippingStates = GeoService.getAllStatesAPO() />
	<cfset request.p.MilitaryBase = application.wirebox.getInstance("MilitaryBaseGateway") />
	<cfset request.p.MilitaryBases = request.p.MilitaryBase.getAllBases() />
<cfelse>
	<cfset request.p.shippingStates = request.p.states >
</cfif>

<!---
**
* If this isn't a wireless order, don't validate against the carrier.
**
--->
<cfsavecontent variable="local.jsHead">
	<script>
		var zChar = new Array(' ', '(', ')', '-', '.');
		var maxphonelength = 13;
		var phonevalue1;
		var phonevalue2;
		var cursorposition;
		var origcursorposition;

		function ParseForNumber1(object){
			phonevalue1 = ParseChar(object.value, zChar);
			GetOrigCursorPosition(object);
		}
		function ParseForNumber2(object){
			phonevalue2 = ParseChar(object.value, zChar);
		}

		function backspacerUP(object,e) {
			if(e){
				e = e;
			} else {
				e = window.event;
			}
			if(e.which){
				var keycode = e.which;
			} else {
				var keycode = e.keyCode;
			}

			ParseForNumber1(object);

			if(keycode > 48){
				ValidatePhone(object);
			}
		}

		function backspacerDOWN(object,e) {
			if(e){
				e = e;
			} else {
				e = window.event;
			}
			if(e.which){
				var keycode = e.which;
			} else {
				var keycode = e.keyCode;
			}
			ParseForNumber2(object);
		}

		function GetCursorPosition(){

			var t1 = phonevalue1;
			var t2 = phonevalue2;
			var bool = false;
		  for (i=0; i<t1.length; i++){
		  	if (t1.substring(i,1) != t2.substring(i,1)) {
		  		if(!bool) {
		  			cursorposition=i;
		  			bool=true;
		  		}
		  	}
		  }
		}

		function GetOrigCursorPosition(object) {
			if (object.selectionStart){
				//Gecko DOM
				origcursorposition = object.selectionStart;
			}
		}

		function ValidatePhone(object){
			var p = phonevalue1;

			p = p.replace(/[^\d]*/gi,"");
			if (p.length < 3) {
				object.value=p;
			} else if(p.length==3){
				pp=p;
				d4=p.indexOf('(');
				d5=p.indexOf(')');
				if(d4==-1){
					pp=" "+pp;
				}
				if(d5==-1){
					pp=pp+"-";
				}
				object.value = pp.replace(' ', '');
			} else if(p.length>3 && p.length < 6){
				p =" " + p;
				l30=p.length;
				p30=p.substring(0,4);
				p30=p30+"-";

				p31=p.substring(4,l30);
				pp=p30+p31;

				object.value = pp.replace(' ', '');

			} else if(p.length >= 6){
				p =" " + p;
				l30=p.length;
				p30=p.substring(0,4);
				p30=p30+"-";

				p31=p.substring(4,l30);
				pp=p30+p31;

				l40 = pp.length;
				p40 = pp.substring(0,8);
				p40 = p40 + "-";

				p41 = pp.substring(8,l40);
				ppp = p40 + p41;

				object.value = ppp.substring(0, maxphonelength).replace(' ', '');
			}

			GetCursorPosition();
			if(cursorposition >= 0 || true){
				if (object.selectionStart){
					//Gecko DOM
					if (origcursorposition == null) {
						//if this function is called onChange, assume end of value
						origcursorposition = object.value.length;
					}
					if (object.value.substr(origcursorposition-1,1) == '-' || object.value.substr(origcursorposition-1,1) == ')' || object.value.substr(origcursorposition,1) == '-' || object.value.substr(origcursorposition,1) == ')') {
						cursorposition = origcursorposition + 1;
					} else {
						cursorposition = origcursorposition;
					}

					object.selectionStart = cursorposition;
					object.selectionEnd = cursorposition;
				} else if (document.selection) {
					//IE
					if (cursorposition == 0) {
						cursorposition = 2;
					} else if (cursorposition <= 2) {
						cursorposition = cursorposition + 1;
					} else if (cursorposition <= 5) {
						cursorposition = cursorposition + 2;
					} else if (cursorposition == 6) {
						cursorposition = cursorposition + 2;
					} else if (cursorposition == 7) {
						cursorposition = cursorposition + 4;
						e1=object.value.indexOf(')');
						e2=object.value.indexOf('-');
						if (e1>-1 && e2>-1){
							if (e2-e1 == 4) {
								cursorposition = cursorposition - 1;
							}
						}
					} else if (cursorposition < 11) {
						cursorposition = cursorposition + 3;
					} else if (cursorposition == 11) {
						cursorposition = cursorposition + 1;
					} else if (cursorposition >= 12) {
						cursorposition = cursorposition;
					}
					var txtRange = object.createTextRange();
					txtRange.moveStart( "character", cursorposition);
					txtRange.moveEnd( "character", cursorposition - object.value.length);
					txtRange.select();
				} else {
					//unsupported
				}
			}
		}

		function ParseChar(sStr, sChar){
			if (sChar.length == null){
				zChar = new Array(sChar);
			} else {
				zChar = sChar;
			}

			for (i=0; i<zChar.length; i++){
				sNewStr = "";

				var iStart = 0;
				var iEnd = sStr.indexOf(sChar[i]);

				while (iEnd != -1){
					sNewStr += sStr.substring(iStart, iEnd);
					iStart = iEnd + 1;
					iEnd = sStr.indexOf(sChar[i], iStart);
				}
				sNewStr += sStr.substring(sStr.lastIndexOf(sChar[i]) + 1, sStr.length);

				sStr = sNewStr;
			}

			return sNewStr;
		}
	</script>
</cfsavecontent>
<cfhtmlhead text="#trim(local.jsHead)#" />

<h1>Billing and Shipping</h1>

<cfif session.cart.getActivationType() CONTAINS 'New' AND !request.config.allowDifferstShippingOnNewActivations>
	<p>To safeguard you, our customer, we only ship to your billing address.</p>
</cfif>

<cfif session.cart.getActivationType() CONTAINS 'Upgrade'>
	<p>If you are upgrading your device you must be the account holder or the authorized user.</p>
</cfif>

<cfif session.cart.getActivationType() CONTAINS 'addaline'>
	<p>If you are adding a line to your existing account you must be the account holder.</p>
</cfif>

<form id="billShip" class="cmxform" action="/index.cfm/go/checkout/do/processBillShip/" method="post">
	<cfoutput>
		<cfif structKeyExists(request, 'validator') and request.validator.hasMessages()>
			<div class="form-errorsummary">#trim(request.validatorView.validationSummary(request.validator.getMessages(), 4))#</div>
		</cfif>
		<input type="hidden" id="returningCustomer" name="returningCustomer" value="#session.checkout.returningCustomer#" />
		<div id="billing">
			<fieldset>
				<cfif request.config.allowDifferstShippingOnNewActivations OR session.cart.getActivationType() DOES NOT CONTAIN 'New'>
					<span class="title">Billing Address</span>
				</cfif>
				<ol>
					<li>
						<label for="txtEmailAddress">Email Address <strong>*</strong></label>
						<cfif not session.UserAuth.isLoggedIn()>
							<input id="txtEmailAddress" name="emailAddress" autocomplete="off" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))#" />
							<span id="spanEmailReq" class="req" <cfif session.UserAuth.isLoggedIn() and len(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress')))>style="display: none"</cfif>>
								<span id="spanAuthenticated" <cfif not session.UserAuth.isLoggedIn() or not len(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress')))>style="display: none"</cfif>>
									<img src="#assetPaths.common#images/ui/checkmark.png" width="12" height="10" alt="Validated" border="0" />
								</span>
							<cfajaxproxy bind="javascript:checkEmailAddress({emailAddress})" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'emailAddress'))#
						<cfelse>
							<span id="txtEmailAddress" style="font-size: 1.2em">#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))#</span>
							<span id="spanAuthenticated">&nbsp;&nbsp;<img src="#assetPaths.common#images/ui/checkmark.png" width="12" height="10" alt="Validated" border="0" /></span>
							<input type="hidden" id="hiddenEmailAddress" autocomplete="off" name="emailAddress" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))#" />
						</cfif>
					</li>

					<cfset displayReturningPassword = false />

					<cfif not session.UserAuth.isLoggedIn() and isDefined('session.checkout.returningCustomer') and session.checkout.returningCustomer>
						<cfset displayReturningPassword = true />
						<!--- see if this is a 3rd party auth situation --->
						<cfif request.config.thirdPartyAuth and structKeyExists(session,"authenticationId") and session.authenticationid is not "" and (structKeyExists(session,"newReturningAuthCust") is false or session.newReturningAuthCust is false)>
							<cfset displayReturningPassword = false />
						</cfif>
					</cfif>

					<li id="liExistingUserPassword" <cfif not variables.displayReturningPassword>style="display: none"</cfif>>
						It appears you already have an account with us, please enter your existing account password.
						<br /><br />
						<label for="txtExistingUserPassword">Password <strong>*</strong></label>
						<input id="txtExistingUserPassword" name="existingUserPassword" type="password" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.existingUserPassword'))#" onkeyup="$('##divIncorrectPassword').hide('slow')" style="width: 150px" autofocus />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'existingUserPassword'))#
						<br /><br />
						<div style="padding-left: 120px">
							<span class="actionButtonLow"><a onclick="cancelLogin()">Cancel</a></span>
							<span class="actionButton"><a onclick="showProgress('Validating email address and password.<br />Please wait.<br>'); $('##billShip').attr('action', '/index.cfm/go/checkout/do/billShipAuthenticate/'); $('##billShip').submit()">Ok</a></span>
							<div style="padding-left: 4px; padding-top: 6px; padding-bottom: 10px"><a href="/index.cfm/go/myAccount/do/forgotPassword/">I forgot my password.</a></div>
						</div>
						<div id="divIncorrectPassword" style="display: none; color: ##f00">
							<br />
							The password you entered is incorrect. Please try again.
						</div>
					</li>

					<li id="liCorrectPassword" style="display: none">
						<div id="divCorrectPassword" style="color: ##090">
							<br />
							You have been authenticated.
						</div>
					</li>

					<li>
						<label for="txtBillingFirstName">First Name <strong>*</strong></label>
						<input id="txtBillingFirstName" name="billFirstName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billFirstName'))#" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billFirstName'))#
					</li>

					<li>
						<label for="txtBillingMiddleInitial">Middle Initial</label>
						<input id="txtBillingMiddleInitial" name="billMiddleInitial" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billMiddleInitial'))#" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billMiddleInitial'))#
					</li>

					<li>
						<label for="txtBillingLastName">Last Name <strong>*</strong></label>
						<input id="txtBillingLastName" name="billLastName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billLastName'))#" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billLastName'))#
					</li>

					<li>
						<label for="txtBillingCompany">Company</label>
						<input id="txtBillingCompany" name="billCompany" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billCompany'))#" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billCompany'))#
					</li>

					<li>
						<label for="txtBillingAddress1">Address 1 <strong>*</strong></label>
						<input id="txtBillingAddress1" name="billAddress1" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billAddress1'))#" maxlength="30"/>
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress1'))#
					</li>

					<li>
						<label for="txtBillingAddress2">Address 2</label>
						<input id="txtBillingAddress2" name="billAddress2" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billAddress2'))#" maxlength="30"/>
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress2Error'))#
					</li>

					<li>
						<label>City/State/Zip <strong>*</strong></label>
						<input id="txtBillingCity" name="billCity" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billCity'))#" />
						<select id="selBillingState" name="billState">
							<option value=""></option>

							<cfset request.p.selected = '' />

							<cfloop query="request.p.states">
								<cfif trim(request.p.states.stateCode) is trim(application.model.checkoutHelper.getFormKeyValue(form = 'billShipForm', key = 'billState')) or (isDefined('session.checkout.billShipForm.billState') and trim(request.p.states.stateCode) is trim(session.checkout.billShipForm.billState))>
									<cfset request.p.selected = 'selected' />
								<cfelse>
									<cfset request.p.selected = '' />
								</cfif>

								<option value="#trim(request.p.states.stateCode)#" #trim(request.p.selected)#>#trim(request.p.states.state)#</option>
							</cfloop>
						</select>
						<input size="12" id="txtBillingZip" name="billZip" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billZip'))#" maxlength="5" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billCity|billState|billZip'))#
					</li>

					<li>
						<label for="txtBillingDayPhone">Daytime Phone <strong>*</strong></label>
						<input id="txtBillingDayPhone" name="billDayPhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billDayPhone'))#
					</li>

					<li>
						<label for="txtBillingEvePhone">Evening Phone <strong>*</strong></label>
						<input id="txtBillingEvePhone" name="billEvePhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billEvePhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billEvePhone'))#
					</li>


					<cfif request.config.allowAPOFPO>
						<li>
							<label for="txtMilitaryBase">Military Base <strong>*</strong></label>
							<select id="selMilitaryBase" name="selMilitaryBase">
								<option value="">-- Select Nearest Base --</option>
								<cfset request.p.selected = '' />
								<cfloop query="request.p.MilitaryBases">

									<cfif trim(request.p.MilitaryBases.completeName) is trim(application.model.checkoutHelper.getFormKeyValue(form = 'billShipForm', key = 'selMilitaryBase')) or (isDefined('session.checkout.billShipForm.selMilitaryBase') and trim(request.p.MilitaryBases.completeName) is trim(session.checkout.billShipForm.selMilitaryBase))>
										<cfset request.p.selected = 'selected' />
									<cfelse>
										<cfset request.p.selected = '' />
									</cfif>
									<option value="#completeName#" #trim(request.p.selected)#>#completeName#</option>
								</cfloop>
							</select>
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'selMilitaryBase'))#
						</li>
					<cfelse>
					<input type="hidden" name="selMilitaryBase" value=""/>
					</cfif>
					<li class="full">
						<input type="checkbox" id="saveBilling" name="saveBilling" value="1"<cfif application.model.CheckoutHelper.formValue('session.checkout.billShipForm.saveBilling') eq 1> checked="checked"</cfif> />
						<label class="check" for="saveBilling">Save to my online account</label>
						<br />
					</li>
				</ol>
				<input type="hidden" name="saveBilling" value="" />
			</fieldset>
		</div>

		<cfif request.config.allowDifferstShippingOnNewActivations OR session.cart.getActivationType() DOES NOT CONTAIN 'New'>
			<div id="shipping">
				<fieldset>
					<span class="title">Shipping Information</span>
					<ol>
						<li class="full">
							<cfparam name="session.checkout.billShipForm.sameAsBilling" default="1" />
							<input type="checkbox" name="sameAsBilling" id="sameAsBilling" value="1" onclick="toggleActive('shipping', this)" id="shippingSame"<cfif application.model.checkoutHelper.formValue('session.checkout.billShipForm.sameAsBilling') eq 1> checked="checked"</cfif> /><label class="check" for="sameAsBilling">Shipping is the same as Billing</label>
							<br />
							<input type="hidden" name="shippingSame" value="" />
						</li>
					</ol>

					<ol id="shippingDetails">
						<li>
							<label for="txtShippingFirstName">First Name <strong>*</strong></label>
							<input id="txtShippingFirstName" name="shipFirstName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipFirstName'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipFirstName'))#
						</li>
						<li>
							<label for="txtShippingMiddleInitial">Middle Initial</label>
							<input id="txtShippingMiddleInitial" name="shipMiddleInitial" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipMiddleInitial'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipMiddleInitial'))#
						</li>
						<li>
							<label for="txtShippingLastName">Last Name <strong>*</strong></label>
							<input id="txtShippingLastName" name="shipLastName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipLastName'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipLastName'))#
						</li>
						<li>
							<label for="txtShippingCompany">Company</label>
							<input id="txtShippingCompany" name="shipCompany" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipCompany'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipCompany'))#
						</li>
						<li>
							<label for="txtShippingAddress1">Address 1 <strong>*</strong></label>
							<input id="txtShippingAddress1" name="shipAddress1" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipAddress1'))#" maxlength="30" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress1'))#
						</li>
						<li>
							<label for="txtShippingAddress2">Address 2</label>
							<input id="txtShippingAddress2" name="shipAddress2" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipAddress2'))#" maxlength="30"/>
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress2Error'))#
						</li>
						<li>
							<label>City<cfif request.config.allowAPOFPO> or APO</cfif>/State/Zip <strong>*</strong></label>
							<input id="txtShippingCity" name="shipCity" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipCity'))#" />
							<cfif request.config.allowAPOFPO><cfajaxproxy bind="javascript:checkCityAPO({txtShippingCity})" /></cfif>
							<select id="selShippingState" name="shipState">
								<option value=""></option>

								<cfset request.p.selected = '' />
								<cfloop query="request.p.shippingStates">
									<cfif trim(request.p.shippingStates.stateCode) is trim(application.model.checkoutHelper.getFormKeyValue(form = 'billShipForm', key = 'shipState')) or (isDefined('session.checkout.billShipForm.shipState') and trim(request.p.shippingStates.stateCode) is trim(session.checkout.billShipForm.shipState))>
										<cfset request.p.selected = 'selected' />
									<cfelse>
										<cfset request.p.selected = '' />
									</cfif>

									<option value="#trim(request.p.shippingStates.stateCode)#" #trim(request.p.selected)#>#trim(request.p.shippingStates.state)#</option>
								</cfloop>

							</select>
							<input size="12" id="txtShippingZip" name="shipZip" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipZip'))#" maxlength="5" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipCity|shipState|shipZip'))#
						</li>
						<cfif request.config.allowAPOFPO>
							<li id="apodislaimer">
								<input type="checkbox" name="checkApoDislaimer" value="1">
								By selecting an APO/FPO shipping address, you are agreeing to waive the option to return the device.  Manufacturer warranty for defects remains valid.
								#trim(request.validatorView.validationElement(request.validator.getMessages(), 'checkApoDislaimer'))#
							</li>
						</cfif>
						<li>
							<label for="txtShippingDayPhone">Daytime Phone <strong>*</strong></label>
							<input id="txtShippingDayPhone" name="shipDayPhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipDayPhone'))#
						</li>
						<li>
							<label for="txtShippingEvePhone">Evening Phone <strong>*</strong></label>
							<input id="txtShippingEvePhone" name="shipEvePhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipEvePhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipEvePhone'))#
						</li>
					</ol>

					<!---<ol>
						<li class="full">
							<input type="checkbox" id="saveShipping" name="saveShipping" value="1"<cfif application.model.checkoutHelper.formValue('session.checkout.billShipForm.saveShipping') eq 1> checked="checked"</cfif> />
							<label class="check" for="saveShipping">Save as Default Shipping</label>
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'saveShipping'))#
						</li>
					</ol>--->
				</fieldset>
			</div>
		</cfif>

		<cfif application.model.checkoutHelper.isPrepaidOrder()>
			<fieldset>
				<span class="title">Prepaid Phone Order Information</span>

				<ol>
					<li>
						<label for="txtDateOfBirth">Date of Birth</label>
						<input id="txtDateOfBirth" name="dob" width="100px" /><span class="req">*</span> mm/dd/yyyy
						#request.validatorView.validationElement(request.validator.getMessages(), 'dob')#
						<br />
						Must be 18 years old to purchase.
					</li>
				</ol>
			</fieldset>
		</cfif>

		<cfif request.config.showServiceCallResultCodes>
			<select name="resultCode" class="resultCode">
				<option value="AV003">Success</option>
				<option value="AV004">Billing not valid</option>
				<option value="AV002">Shipping not valid at all</option>
				<option value="AV001">Shipping not valid, suggested changes</option>
				<option value="AV010">Invalid Request</option>
				<option value="AV011">Unable to Connect to Carrier Service</option>
				<option value="AV012">Service Timeout</option>
				<option value="" selected="selected">Run for Real</option>
			</select>
		</cfif>
	</cfoutput>
</form>

<div class="formControl">
	<span class="actionButtonLow">
		<cfif application.model.checkoutHelper.getCheckoutType() is 'new'>
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/lnpRequest/'">Back</a>
		<cfelse>
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/wirelessAccountForm/'">Back</a>
		</cfif>
	</span>

	<span class="actionButton"><a href="##" onclick="showProgress('Validating address, please wait.'); $('#billShip').submit()">Continue</a></span>
</div>

<script language="javascript" type="text/javascript">
	var shippingContainerHeight = Ext.get('shippingDetails').getHeight();

	function toggleActive(on, el)	{
		if(el.checked)	{
			// Enable the field
			var els = Ext.get(on).query('input,select');

			for(var i =1; i < els.length; i++)	{
				Ext.get(els[i]).set({readonly: "disabled"});
			}

			Ext.get('shippingDetails').setHeight(0);
			Ext.get('shippingDetails').setVisibilityMode(Ext.Element.DISPLAY);
			Ext.get('shippingDetails').hide();
			checkCityAPO();
		} else {
			// Disable the fields

			var els = Ext.get(on).query('input,select');

			for(var i = 1; i < els.length; i++)	{
				Ext.get(els[i]).dom.removeAttribute('readonly');
			}

			Ext.get('shippingDetails').setVisibilityMode(Ext.Element.DISPLAY);
			Ext.get('shippingDetails').show();
			Ext.get('shippingDetails').setHeight( shippingContainerHeight );
			checkCityAPO();
		}
	}

	if(Ext.get('sameAsBilling').dom.checked)	{
		Ext.get('shippingDetails').setVisibilityMode(Ext.Element.DISPLAY);
		Ext.get('shippingDetails').setHeight(0);
		Ext.get('shippingDetails').hide();
	}
</script>

<cfajaxproxy cfc="ajax.User" jsclassname="User" />
<cfajaxproxy cfc="ajax.CheckoutHelper" jsclassname="CheckoutHelper" />

<script language="javascript" type="text/javascript">
	var user = new User();
	var checkoutHelper = new CheckoutHelper();

	checkEmailAddress = function (e)	{
		var emailAddress = e;
		var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);

		showProgress('Checking your email address against our database.<br />Please wait.<br />');

		if (validateEmailAddressFormat(e) && $.trim(e).length)	{
			$('#billShip').attr('action', '/index.cfm/go/checkout/do/billShipCheckEmailAddress/');
			$('#billShip').submit();
		} else {
			requireEmailAddress();
			hideProgress();
		}
	}

	validateEmailAddress = function ()	{
		var e = $('#txtEmailAddress').val();
		if (validateEmailAddressFormat(e))	{
			return true;
		} else {
			requireEmailAddress();
		}
	}

	validateEmailAddressFormat = function (e)	{
		var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);

		if ($.trim(e).length && pattern.test(e))
			return true;
		else if (!$.trim(e).length) // allow 0-length since it will be caught on server-side
			return true;
		else
			return false;
	}
	<cfif request.config.allowAPOFPO>
	checkCityAPO = function (e) {
		$('#txtShippingCity').val($('#txtShippingCity').val().toUpperCase());
		e=$.trim(e).toUpperCase();
		if ($.trim(e).length && (e == 'APO' || e == 'FPO')) {
			$('#apodislaimer').show();
		} else {
			$('#apodislaimer').hide();
		}
	}
	</cfif>

	requireEmailAddress = function ()	{
		setTimeout('$(\'#txtEmailAddress\').focus()', 1); // for some reason, this fails directly, but works with setTimeout()... weird
		alert('Please provide a valid email address.');
	}

	cancelLogin = function ()	{
		$('#returningCustomer').val('0');
		$('#liExistingUserPassword').hide('fast');
		$('#liExistingUserPassword').val('');
		$('#txtEmailAddress').val('');
		$('#txtEmailAddress').focus();
	}

</script>
