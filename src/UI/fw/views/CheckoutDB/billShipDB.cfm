<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset ChannelConfig = application.wirebox.getInstance("ChannelConfig") />

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
	<!---<cfset session.checkout.billShipForm.billEvePhone = trim(session.currentUser.getBillingAddress().getEvePhone()) />--->
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
	<!---<cfset session.checkout.billShipForm.shipEvePhone = trim(session.currentUser.getShippingAddress().getEvePhone()) />--->
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
		
		function autotab(event,original,destination){
				var keyID = event.keyCode;
				if (keyID==37||keyID==39||event.shiftKey&&keyID==9||keyID==16||keyID==9){
					return false;
				}			
			if (original.getAttribute&&original.value.length==original.getAttribute("maxlength"))
			destination.focus()
		}
	</script>
</cfsavecontent>
<cfhtmlhead text="#trim(local.jsHead)#" />


<cfoutput>
	<div class="row main">
        <div class="col-md-12">
            <section class="content">
				<header class="main-header">
                    <h1>Billing and Shipping Information</h1>
                    <cfif session.cart.getActivationType() CONTAINS 'New' AND !request.config.allowDifferstShippingOnNewActivations>
						<p>To safeguard you, our customer, we only ship to your billing address.</p>
					</cfif>
		
					<cfif session.cart.getActivationType() CONTAINS 'Upgrade'>
						<p>If you are upgrading your device you must be the account holder or the authorized user.</p>
					</cfif>
		
					<cfif session.cart.getActivationType() CONTAINS 'addaline'>
						<p>If you are adding a line to your existing account you must be the account holder.</p>
					</cfif>
                </header>
				<form id="billShip" name="billShip" class="cmxform" action="#event.buildLink('/CheckoutDB/processBillShip')#" method="post">
					<div class="right">
                        <a href="/DeviceBuilder/orderReview">BACK</a>
                        <button type="submit" class="btn btn-primary" onclick="showProgress('Validating address, please wait.'); $('##billShip').submit()">Continue</button> <!--<span class="btn btn-primary"><a href="##" onclick="showProgress('Validating address, please wait.'); $('##billShip').submit()" style="color:##fff">Continue</a></span>-->
                    </div>

					<cfif structKeyExists(request, 'validator') and request.validator.hasMessages()>
						<div class="bs-callout bs-callout-error">#trim(request.validatorView.validationSummary(request.validator.getMessages(), 4))#</div>
					</cfif>
					<input type="hidden" id="returningCustomer" name="returningCustomer" value="#session.checkout.returningCustomer#" />
					<cfif request.config.allowDifferstShippingOnNewActivations OR session.cart.getActivationType() DOES NOT CONTAIN 'New'>
						<h3>Billing Address</h3>
					</cfif>
					<div id="billing">
						<div class="form-group form-inline emailAddress">
							<label for="txtEmailAddress">Email Address<strong>*</strong></label>
							<cfif not session.UserAuth.isLoggedIn()>
								<input class="form-control" id="txtEmailAddress" name="emailAddress" autocomplete="off" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))#" />
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
						</div>
                    
						<cfset displayReturningPassword = false />

						<cfif not session.UserAuth.isLoggedIn() and isDefined('session.checkout.returningCustomer') and session.checkout.returningCustomer>
							<cfset displayReturningPassword = true />
							<!--- see if this is a 3rd party auth situation --->
							<cfif request.config.thirdPartyAuth and structKeyExists(session,"authenticationId") and session.authenticationid is not "" and (structKeyExists(session,"newReturningAuthCust") is false or session.newReturningAuthCust is false)>
								<cfset displayReturningPassword = false />
							</cfif>
						</cfif>

						<div id="liExistingUserPassword" class="bs-callout bs-callout-warning" <cfif not variables.displayReturningPassword>style="display: none"</cfif>>
							<p>It appears you already have an account with us, please enter your existing account password.</p>
							<div class="form-group form-inline existingUserPassword has-error">
								<label for="txtExistingUserPassword">Password <strong>*</strong></label>
								<input class="form-control" id="txtExistingUserPassword" name="existingUserPassword" type="password" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.existingUserPassword'))#" onkeyup="$('##divIncorrectPassword').hide('slow')" style="width: 150px" autofocus />
								#trim(request.validatorView.validationElement(request.validator.getMessages(), 'existingUserPassword'))#
								
								<div style="margin-left: 250px; padding-top:10px;">
									<span ><a style="margin:0 15px;" onclick="cancelLogin()">Cancel</a></span>
									<button class="btn btn-primary btn-sm" onclick="event.preventDefault();showProgress('Validating email address and password.<br />Please wait.<br>'); $('##billShip').attr('action', '/CheckoutDB/billShipAuthenticate');$('##billShip').submit();" style="color:##fff; width:75px;">Ok</button>
									<div style="padding: 15px 0 0;font-size:10px;"><a href="/index.cfm/go/myAccount/do/forgotPassword/">I forgot my password.</a></div>
								</div>
							</div>
							
							<div id="divIncorrectPassword" style="display: none; color: ##f00">
								<br />
								The password you entered is incorrect. Please try again.
							</div>
						</div>
						<div id="liCorrectPassword" style="display: none">
							<div id="divCorrectPassword" style="color: ##090">
								<br />
								You have been authenticated.
							</div>
						</div>
						<div class="form-group form-inline firstName <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billFirstName'))>has-error</cfif>">
							<label for="txtBillingFirstName">First Name <strong>*</strong></label>
							<input class="form-control" id="txtBillingFirstName" name="billFirstName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billFirstName'))#" />

							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billFirstName'))#
						</div>
                    
					
					
						<div class="form-group form-inline middleInitial <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billMiddleInitial'))>has-error</cfif>">
							<label for="txtBillingMiddleInitial">Middle Initial</label>
							<input class="form-control" id="txtBillingMiddleInitial" name="billMiddleInitial" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billMiddleInitial'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billMiddleInitial'))#                        
						</div>



						<div class="form-group form-inline lastName <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billLastName'))>has-error</cfif>">
							<label for="txtBillingLastName">Last Name <strong>*</strong></label>
							<input class="form-control" id="txtBillingLastName" name="billLastName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billLastName'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billLastName'))#
						</div>

						<div class="form-group form-inline company <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billCompany'))>has-error</cfif>">
							<label for="txtBillingCompany">Company</label>
							<input class="form-control" id="txtBillingCompany" name="billCompany" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billCompany'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billCompany'))#
						</div>

						<div class="form-group form-inline address1 <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress1'))>has-error</cfif>">
							<label for="txtBillingAddress1">Address 1 <strong>*</strong></label>
							<input class="form-control" id="txtBillingAddress1" name="billAddress1" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billAddress1'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress1'))#
						</div>

						<div class="form-group form-inline address2 <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress2Error'))>has-error</cfif>">
							<label for="txtBillingAddress2">Address 2</label>
							<input class="form-control" id="txtBillingAddress2" name="billAddress2" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billAddress2'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress2Error'))#
						</div>

						<div class="form-group form-inline city <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billCity'))>has-error</cfif>">
							<label>City<strong>*</strong></label>
							<input class="form-control" id="txtBillingCity" name="billCity" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billCity'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billCity'))#
						</div>

						<div class="form-group form-inline billState <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billState'))>has-error</cfif>">
							<label>State<strong>*</strong></label>
							<select id="selBillingState" name="billState" class="form-control">
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
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billState'))#
						</div>
					
						<div class="form-group form-inline billZip <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billZip'))>has-error</cfif>">
							<label>Zip Code<strong>*</strong></label>
							<input class="form-control" id="txtBillingZip" name="billZip" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billZip'))#" maxlength="5" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billZip'))#
						</div>

						<!---<div class="form-group form-inline dayPhone <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billDayPhone'))>has-error</cfif>">
							<label for="txtBillingDayPhone">Contact Phone <strong>*</strong></label>
							<input class="form-control" id="txtBillingDayPhone" name="billDayPhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billDayPhone'))#
						</div>--->
						<div class="form-group form-inline phone contactPhone <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billDayPhone'))>has-error</cfif>">
							<label for="txtBillingDayPhone">Contact Phone<strong>*</strong></label>
							( <input class="form-control" id="txtBillingDayPhonePt1" name="billDayPhonePt1" value="#LEFT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone')),3)#" maxlength="3"  onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('txtBillingDayPhonePt2'))" style="text-align:center;"/> )
							<input class="form-control" id="txtBillingDayPhonePt2" name="billDayPhonePt2" value="#MID(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone')),5,3)#" maxlength="3"  onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('txtBillingDayPhonePt3'))" style="text-align:center;"/> - 
							<input class="form-control" id="txtBillingDayPhonePt3" name="billDayPhonePt3" value="#RIGHT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone')),4)#" maxlength="4" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" style="text-align:center;"/>
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billDayPhone'))#
						</div>
						<!---<div class="form-group form-inline eveningPhone <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'billEvePhone'))>has-error</cfif>">
							<label for="txtBillingEvePhone">Evening Phone <strong>*</strong></label>
							<input class="form-control" id="txtBillingEvePhone" name="billEvePhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billEvePhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billEvePhone'))#
						</div>--->


						<cfif request.config.allowAPOFPO>
							<div class="form-group form-inline allowAPO <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'selMilitaryBase'))>has-error</cfif>">
								<label for="txtMilitaryBase">Military Base <strong>*</strong></label>
								<select class="form-control" id="selMilitaryBase" name="selMilitaryBase">
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
							</div>
						<cfelse>
						<input type="hidden" name="selMilitaryBase" value=""/>
						</cfif>
						<div class="form-group form-inline allowAPO">
							<input type="checkbox" id="saveBilling" name="saveBilling" value="1"<cfif application.model.CheckoutHelper.formValue('session.checkout.billShipForm.saveBilling') eq 1> checked="checked"</cfif> />
							<label class="check" for="saveBilling">Save to my online account</label>
						</div>
						<input type="hidden" name="saveBilling" value="" />
					</div>
					

					<cfif request.config.allowDifferstShippingOnNewActivations OR session.cart.getActivationType() DOES NOT CONTAIN 'New'>
						<div id="shipping">
							
							<h3>Shipping Information</h3>


							<!--- Taxes and Shipping --->
							<cfscript>
								/*  shipping fix goes here */
								shipMethodArgs = {CarrierId=session.cart.getCarrierId(), 
														  IsAfoApoAddress=application.model.CheckoutHelper.getShippingAddress().isApoFpoAddress(),
														  IsCartEligibleForPromoShipping=false,
														  supressFreeText = request.config.channelName eq 'costco' };
		
								if(ChannelConfig.getOfferShippingPromo())
								{
									//Check to see if the cart meets the promo criteria
									shipMethodArgs.IsCartEligibleForPromoShipping = application.model.CartHelper.isCartEligibleForPromoShipping();
								}
		
								local.qShipMethods = application.model.ShipMethod.getShipMethods(argumentCollection=shipMethodArgs);
			
							</cfscript>
							
								
							<div class="form-group form-inline shippingMethod">
								<label for="txtShippingDetails">Shipping Method<strong>*</strong></label>
								<cfif local.qShipMethods.RecordCount eq 1>
									- 
									#local.qShipMethods.DisplayName#
									<input type="hidden" name="shipping" value="#local.qShipMethods.ShipMethodId#"/>
								<cfelse>
									<select class="form-control" name="shipping" id="shippingCostSelect">
										<cfloop query="local.qShipMethods">
											<option price="#DefaultFixedCost#" displayprice="#dollarFormat(DefaultFixedCost)#" 
													value="#ShipMethodId#" <cfif isDefined('session.checkout.shippingMethod') AND (trim(local.qShipMethods.ShipMethodId) eq trim(session.checkout.shippingMethod.getShipMethodId()))>selected</cfif>>
												#DisplayName#
												(
												#dollarFormat(DefaultFixedCost)#
												)
											</option>
									
										</cfloop>
									</select>
								</cfif>
							</div>
							




							
							<div class="form-group form-inline allowAPO">
								<cfparam name="session.checkout.billShipForm.sameAsBilling" default="1" />
								<input type="checkbox" name="sameAsBilling" id="sameAsBilling" value="1" <cfif application.model.checkoutHelper.formValue('session.checkout.billShipForm.sameAsBilling') eq 1> checked="checked"</cfif> /><label class="check" for="sameAsBilling">Shipping is the same as Billing</label>
							</div>
								
							<div id="shippingDetails" class="hidden">
								<div class="form-group form-inline shipFirstName <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipFirstName'))>has-error</cfif>">
									<label for="txtShippingFirstName">First Name <strong>*</strong></label>
									<input class="form-control" id="txtShippingFirstName" name="shipFirstName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipFirstName'))#" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipFirstName'))#
								</div>
								<div class="form-group form-inline shipMiddle <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipMiddleInitial'))>has-error</cfif>">
									<label for="txtShippingMiddleInitial">Middle Initial</label>
									<input class="form-control" id="txtShippingMiddleInitial" name="shipMiddleInitial" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipMiddleInitial'))#" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipMiddleInitial'))#
								</div>
								<div class="form-group form-inline shipLastName <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipLastName'))>has-error</cfif>">
									<label for="txtShippingLastName">Last Name <strong>*</strong></label>
									<input class="form-control" id="txtShippingLastName" name="shipLastName" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipLastName'))#" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipLastName'))#
								</div>
								<div class="form-group form-inline shipCompany <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipCompany'))>has-error</cfif>">
									<label for="txtShippingCompany">Company</label>
									<input class="form-control" id="txtShippingCompany" name="shipCompany" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipCompany'))#" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipCompany'))#
								</div>
								<div class="form-group form-inline shipAddress1 <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress1'))>has-error</cfif>">
									<label for="txtShippingAddress1">Address 1 <strong>*</strong></label>
									<input class="form-control" id="txtShippingAddress1" name="shipAddress1" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipAddress1'))#" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress1'))#
								</div>
								<div class="form-group form-inline shipAddress2 <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress2Error'))>has-error</cfif>">
									<label for="txtShippingAddress2">Address 2</label>
									<input class="form-control" id="txtShippingAddress2" name="shipAddress2" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipAddress2'))#" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress2Error'))#
								</div>
								<div class="form-group form-inline shipCity <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipCity'))>has-error</cfif>">
									<label>City<strong>*</strong></label>
									<input class="form-control" id="txtShippingCity" name="shipCity" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipCity'))#" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipCity'))#
								</div>
								<div class="form-group form-inline shipState <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipState'))>has-error</cfif>">
									<label>State<strong>*</strong></label>
									<select class="form-control" id="selShippingState" name="shipState">
										<option value=""></option>

										<cfset request.p.selected = '' />
										<cfloop query="request.p.shippingStates">
											<cfif trim(request.p.shippingStates.stateCode) is trim(application.model.checkoutHelper.getFormKeyValue(form = 'billShipForm', key = 'shipState')) or (isDefined('session.checkout.billShipForm.billState') and trim(request.p.shippingStates.stateCode) is trim(session.checkout.billShipForm.shipState))>
												<cfset request.p.selected = 'selected' />
											<cfelse>
												<cfset request.p.selected = '' />
											</cfif>

											<option value="#trim(request.p.shippingStates.stateCode)#" #trim(request.p.selected)#>#trim(request.p.shippingStates.state)#</option>
										</cfloop>

									</select>	
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipState'))#
								</div>
								<div class="form-group form-inline shipZip <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipZip'))>has-error</cfif>">
									<label>Zip Code<strong>*</strong></label>
									<input class="form-control" id="txtShippingZip" name="shipZip" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipZip'))#" maxlength="5" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipZip'))#
								</div>
								<cfif request.config.allowAPOFPO>
									<div class="form-group form-inline apoDisclaimer <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'checkApoDislaimer'))>has-error</cfif>">
										<input type="checkbox" name="checkApoDislaimer" value="1">
										By selecting an APO/FPO shipping address, you are agreeing to waive the option to return the device.  Manufacturer warranty for defects remains valid.
										#trim(request.validatorView.validationElement(request.validator.getMessages(), 'checkApoDislaimer'))#
									</div>
								</cfif>
								<!---<div class="form-group form-inline shipDayPhone <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipDayPhone'))>has-error</cfif>">
									<label for="txtShippingDayPhone">Contact Phone <strong>*</strong></label>
									<input class="form-control" id="txtShippingDayPhone" name="shipDayPhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipDayPhone'))#
								</div>--->
								<div class="form-group form-inline shipContactPhone phone <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipDayPhone'))>has-error</cfif>">
								<label for="txtShippingDayPhone">Contact Phone<strong>*</strong></label>
									( <input class="form-control" id="txtShippingDayPhonePt1" name="shipDayPhonePt1" value="#LEFT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone')),3)#" maxlength="3"  onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('txtShippingDayPhonePt2'))" style="text-align:center;"/> )
									<input class="form-control" id="txtShippingDayPhonePt2" name="shipDayPhonePt2" value="#MID(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone')),5,3)#" maxlength="3"  onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('txtShippingDayPhonePt3'))" style="text-align:center;"/> - 
									<input class="form-control" id="txtShippingDayPhonePt3" name="shipDayPhonePt3" value="#RIGHT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone')),4)#" maxlength="4" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" style="text-align:center;"/>
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipDayPhone'))#
								</div>
								<!---<div class="form-group form-inline shipEveningPhone <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'shipEvePhone'))>has-error</cfif>">
									<label for="txtShippingEvePhone">Evening Phone <strong>*</strong></label>
									<input class="form-control" id="txtShippingEvePhone" name="shipEvePhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipEvePhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
									#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipEvePhone'))#
								</div>--->
							</div>
						</div>
					</cfif>





					
					<cfif application.model.checkoutHelper.isPrepaidOrder()>
						<h3>Prepaid Phone Order Information</h3>

						<div class="form-group form-inline dateOfBirth <cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'dob'))>has-error</cfif>">
							<label for="txtDateOfBirth">Date of Birth</label>
							<input class="form-control" id="txtDateOfBirth" name="dob" width="100px" /><span class="req">*</span> mm/dd/yyyy
							#request.validatorView.validationElement(request.validator.getMessages(), 'dob')#
							<br />
							Must be 18 years old to purchase.
						</div>
							
					</cfif>

					<cfif request.config.showServiceCallResultCodes>
						<select name="resultCode" class="resultCode">
							<option value="AV003" selected="selected">Success</option>
							<option value="AV004">Billing not valid</option>
							<option value="AV002">Shipping not valid at all</option>
							<option value="AV001">Shipping not valid, suggested changes</option>
							<option value="AV010">Invalid Request</option>
							<option value="AV011">Unable to Connect to Carrier Service</option>
							<option value="AV012">Service Timeout</option>
							<option value="">Run for Real</option>
						</select>
					</cfif>
           




                    <div class="right">
                        <a href="/DeviceBuilder/orderReview">BACK</a>
                        <button type="submit" class="btn btn-primary btn-block" onclick="showProgress('Validating address, please wait.'); $('##billShip').submit()">Continue</button>
                    </div>
                </form>
            </section>
        </div>
		
		<div class="col-md-4">
			<div class="row"><img src="#assetPaths.common#images/content/checkout/CustomerServiceContact.png" /></div>
		</div>
		
	</div>
</cfoutput>




<cfajaxproxy cfc="ajax.User" jsclassname="User" />
<cfajaxproxy cfc="ajax.CheckoutHelper" jsclassname="CheckoutHelper" />

<script language="javascript" type="text/javascript">
	var $j = jQuery.noConflict();
	
	$j(document).ready(function($j){
			$j('#sameAsBilling').change(function() {
    			/*$j('#shippingDetails').toggle();*/
    			$( "#shippingDetails" ).toggle(
  					function() {
    					$('#shippingDetails').addClass( "hidden" );
  					}, function() {
    					$('#shippingDetails' ).removeClass( "hidden" );
  					}
				);
			});
			if($('#sameAsBilling').is(':checked')) {
				$('#shippingDetails').addClass( "hidden" );
			} else {
				$('#shippingDetails' ).removeClass( "hidden" );
			}
			if ($j('#txtEmailAddress').val()){
				$j('#txtBillingFirstName').focus();
			}

	});
	
	var user = new User();
	var checkoutHelper = new CheckoutHelper();

	checkEmailAddress = function (e)	{
		var emailAddress = e;
		var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);

		showProgress('Checking your email address against our database.<br />Please wait.<br />');

		if (validateEmailAddressFormat(e) && $.trim(e).length)	{
			$('#billShip').attr('action', '/CheckoutDB/billShipCheckEmailAddress/');
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
	checkCityAPO = function (e) {
		$('#txtShippingCity').val($('#txtShippingCity').val().toUpperCase());
		e=$.trim(e).toUpperCase();
		if ($.trim(e).length && (e == 'APO' || e == 'FPO')) {
			$('#apodislaimer').show();
		} else {
			$('#apodislaimer').hide();
		}
	}

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
