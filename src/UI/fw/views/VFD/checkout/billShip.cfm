<cfset assetPaths = application.wirebox.getInstance("assetPaths") />



<cfif not isDefined('session.checkout.returningCustomer')>
	<cfif session.UserAuth.isLoggedIn()>
		<cfset session.checkout.returningCustomer = 1 />
	<cfelse>
		<cfset session.checkout.returningCustomer = 0 />
	</cfif>
</cfif>

<!---
Maintain data for when leaving page and returning
--->
<cfif structKeyExists(form, 'emailAddress') and
	structKeyExists(form, 'billFirstName') and
	structKeyExists(form, 'billLastName') and
	structKeyExists(form, 'billAddress1') and
	structKeyExists(form, 'billCity') and
	structKeyExists(form, 'billState') and
	structKeyExists(form, 'billZip') and
	structKeyExists(form, 'billEvePhone')>
	
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
	<cfset session.checkout.billShipForm.shipEvePhone = trim(session.currentUser.getShippingAddress().getEvePhone()) />
	<cfset session.checkout.billShipForm.billMilitaryBase = trim(session.currentUser.getShippingAddress().getMilitaryBase()) />
	<!---<cfset session.checkout.billShipForm.selMilitaryBase = trim(session.currentUser.getShippingAddress().getMilitaryBase()) />--->

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
			function showHide(divId){
    		var theDiv = document.getElementById(divId);
    		if(theDiv.style.display=="none"){
      			theDiv.style.display="";
   			}else{
        		theDiv.style.display="none";
    		}   
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


<style>
		.progressBtn {
   			background: linear-gradient(to bottom, #8bcd68 0%, #65b43c 5%, #518f30 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
   			border-radius: 2px;
			display: inline-block;
    		height: 42px;
    		line-height: 42px;
    		margin: 0 auto;
    		text-align: center;
    		text-decoration: none;
    		width: 180px;
			margin-left: 10px;
		}
		.waitForActionBtn {
   			background: linear-gradient(to bottom, #E3E3ED 0%, #DCDCDA 5%, #C7C7C1 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
   			border-radius: 2px;
			display: inline-block;
    		height: 42px;
    		line-height: 42px;
    		margin: 0 auto;
    		text-align: center;
    		text-decoration: none;
    		width: 180px;
			margin-left: 10px;
		}
		.waitForActionBtn span {
			font-size: 18px;
  			color: #ffffff;
  			text-shadow: #444444;
  			font-weight: bold;
		}
		.progressBtn span {
			font-size: 18px;
  			color: #ffffff;
  			text-shadow: #444444;
  			font-weight: bold;
		}
</style>
<cfhtmlhead text="#trim(local.jsHead)#" />

<cfif request.config.debugInventoryData>
	<div align=right>
		<!---<input type="button" onclick="showHide('debugDiv')" value="Debug Info"> --->
	</div>
	<div id="debugDiv" style="display: none">
		<div align=right>
			<h2>VFD State:</h2><input type="radio" id ="vfdOn" name="vfdOn" value="vfdOn" disabled=true <cfif (structKeyExists(session, 'VFD')) and (Session.VFD.Access eq true)>checked</cfif> />On  
			<input type="radio" id="vfdOff" name="vfdOff" value="vfdOff" disabled=true <cfif (not structKeyExists(session, 'VFD')) or (Session.VFD.Access neq true)>checked</cfif> />Off
		</div>
	</div>
</cfif>
<cfoutput>
<form id="billShip" name="billship" class="cmxform" action="#event.buildLink('CheckoutVFD/processBillShip')#" method="post">
	
		<h1>Billing and Shipping</h1>
		<cfif session.cart.getActivationType() contains 'New' AND !request.config.allowDifferstShippingOnNewActivations>
			<p>To safeguard you, our customer, we only ship to your billing address.</p>
		</cfif>
		<cfif session.cart.getActivationType() contains 'Upgrade'>
			<p>If you are upgrading your device you must be the account holder or the authorized user.</p>
		</cfif>
		<cfif session.cart.getActivationType() contains 'addaline'>
			<p>If you are adding a line to your existing account you must be the account holder.</p>
		</cfif>
		<hr size="4" Color="##3c5cb2">
		<cfif structKeyExists(request, 'validator') and request.validator.hasMessages()>
			<div class="form-errorsummary">#trim(request.validatorView.validationSummary(request.validator.getMessages(), 4))#</div>
		</cfif>
		<!---<input type="hidden" id="returningCustomer" name="returningCustomer" value="#session.checkout.returningCustomer#" />--->
		<div id="billing">
			<fieldset>
				<ol>
					<li>
						<label for="txtEmailAddress">Email Address <strong>*</strong></label>
						<!---<cfif not session.UserAuth.isLoggedIn()>--->
							<input id="txtEmailAddress" name="emailAddress" autocomplete="off" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))#" />
							<span id="spanEmailReq" class="req" <cfif session.UserAuth.isLoggedIn() and len(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress')))>style="display: none"</cfif>>
								<span id="spanAuthenticated" <cfif not session.UserAuth.isLoggedIn() or not len(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress')))>style="display: none"</cfif>>
									<img src="#assetPaths.common#images/ui/checkmark.png" width="12" height="10" alt="Validated" border="0" />
								</span>
							<cfajaxproxy bind="javascript:checkEmailAddress({emailAddress})" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'emailAddress'))#
						<!---<cfelse>
							<span id="txtEmailAddress" style="font-size: 1.2em">#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))#</span>
							<span id="spanAuthenticated">&nbsp;&nbsp;<img src="#assetPaths.common#images/ui/checkmark.png" width="12" height="10" alt="Validated" border="0" /></span>
							<input type="hidden" id="hiddenEmailAddress" autocomplete="off" name="emailAddress" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.emailAddress'))#" />
						</cfif>--->
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
						<input id="txtBillingAddress1" name="billAddress1" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billAddress1'))#" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress1'))#
					</li>

					<li>
						<label for="txtBillingAddress2">Address 2</label>
						<input id="txtBillingAddress2" name="billAddress2" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billAddress2'))#" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billAddress2Error'))#
					</li>

					<li>
						<label>City<strong>*</strong></label>
						<input id="txtBillingCity" name="billCity" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billCity'))#" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billCity'))#
					</li>
					
					<li>
						<label>State<strong>*</strong></label>
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
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billState'))#
					</li>
					
					<li>
						<label>Zip Code<strong>*</strong></label>
						<input id="txtBillingZip" name="billZip" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billZip'))#" maxlength="5" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billZip'))#
					</li>

					<!---<li>
						<label for="txtBillingDayPhone">Daytime Phone <strong>*</strong></label>
						<input id="txtBillingDayPhone" name="billDayPhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billDayPhone'))#
					</li>--->
					
					<li>
						<label for="txtBillingDayPhone">Daytime Phone<strong>*</strong></label>
						( <input id="txtBillingDayPhonePt1" name="billDayPhonePt1" value="#LEFT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone')),3)#" maxlength="3"  onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.billDayPhonePt2)" style="width:30px;text-align:center;"/> )
						<input id="txtBillingDayPhonePt2" name="billDayPhonePt2" value="#MID(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone')),5,3)#" maxlength="3"  onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.billDayPhonePt3)" style="width:30px;text-align:center;"/> - 
						<input id="txtBillingDayPhonePt3" name="billDayPhonePt3" value="#RIGHT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billDayPhone')),4)#" maxlength="4" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" style="width:40px;text-align:center;"/>
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billDayPhone'))#
					</li>

					<!---<li>
						<label for="txtBillingEvePhone">Evening Phone <strong>*</strong></label>
						<input id="txtBillingEvePhone" name="billEvePhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billEvePhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billEvePhone'))#
					</li>--->

					<li>
						<label for="txtBillingEvePhone">Evening Phone<strong>*</strong></label>
						( <input id="txtBillingEvePhonePt1" name="billEvePhonePt1" value="#LEFT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billEvePhone')),3)#" maxlength="3"   onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.billEvePhonePt2)" style="width:30px;text-align:center;"/> )
						<input id="txtBillingEvePhonePt2" name="billEvePhonePt2" value="#MID(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billEvePhone')),5,3)#" maxlength="3"  onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.billEvePhonePt3)" style="width:30px;text-align:center;"/> - 
						<input id="txtBillingEvePhonePt3" name="billEvePhonePt3" value="#RIGHT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billEvePhone')),4)#" maxlength="4" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" style="width:40px;text-align:center;"/>
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'billEvePhone'))#
					</li>
					
					<cfif request.config.allowAPOFPO>
						<li>
							<label for="txtMilitaryBase">Military Base <strong>*</strong></label>
							<select id="selMilitaryBase" name="selMilitaryBase">
								<option value="">-- Select Nearest Base --</option>
								<cfset request.p.selected = '' />
								<cfloop query="request.p.MilitaryBases">

									<cfif trim(request.p.MilitaryBases.completeName) is trim(application.model.checkoutHelper.getFormKeyValue(form = 'billShipForm', key = 'billMilitaryBase')) or (isDefined('session.checkout.billShipForm.billMilitaryBase') and trim(request.p.MilitaryBases.completeName) is trim(session.checkout.billShipForm.billMilitaryBase))>
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
				</ol>
			</fieldset>
		</div>
		<!---Still have to keep track of billing address for upgrades--->
		<cfif (request.config.allowDifferstShippingOnNewActivations) OR (session.cart.getActivationType() DOES NOT CONTAIN 'New')>	
			<div id="shipping">
				<fieldset>
					<span class="title">Shipping Information</span>
					<ol id="shippingCheck">
						<li class="full">
							<cfparam name="session.checkout.billShipForm.sameAsBilling" default="1" />
							<!---<input type="checkbox" name="sameAsBilling" id="sameAsBilling" value="1" checked="true" /><label class="check" for="sameAsBilling">Shipping is the same as Billing</label>--->
							<input type="checkbox" name="sameAsBilling" id="sameAsBilling" value="1" <cfif application.model.checkoutHelper.formValue('session.checkout.billShipForm.sameAsBilling') eq 1> checked="checked"</cfif> /><label class="check" for="sameAsBilling">Shipping is the same as Billing</label>
						</li>
					</ol>

					<ol id="shippingDetails" class="hidden">
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
							<input id="txtShippingAddress1" name="shipAddress1" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipAddress1'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress1'))#
						</li>
						<li>
							<label for="txtShippingAddress2">Address 2</label>
							<input id="txtShippingAddress2" name="shipAddress2" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipAddress2'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipAddress2Error'))#
						</li>
						<li>
							<label>City<strong>*</strong></label>
							<input id="txtShippingCity" name="shipCity" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipCity'))#" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipCity'))#
						</li>
						<li>
							<label>State<strong>*</strong></label>
							<select id="selShippingState" name="shipState">
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
						</li>
						<li>
							<label>Zip Code<strong>*</strong></label>						
							<input size="12" id="txtShippingZip" name="shipZip" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipZip'))#" maxlength="5" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipZip'))#
						</li>
						<cfif request.config.allowAPOFPO>
							<li id="apodislaimer">
								<input type="checkbox" name="checkApoDislaimer" value="1">
								By selecting an APO/FPO shipping address, you are agreeing to waive the option to return the device.  Manufacturer warranty for defects remains valid.
								#trim(request.validatorView.validationElement(request.validator.getMessages(), 'checkApoDislaimer'))#
							</li>
						</cfif>
						<!---<li>
							<label for="txtShippingDayPhone">Daytime Phone <strong>*</strong></label>
							<input id="txtShippingDayPhone" name="shipDayPhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipDayPhone'))#
						</li>
						<li>
							<label for="txtShippingEvePhone">Evening Phone <strong>*</strong></label>
							<input id="txtShippingEvePhone" name="shipEvePhone" value="#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipEvePhone'))#" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipEvePhone'))#
						</li>--->
						
						<li>
							<label for="txtShippingDayPhone">Daytime Phone<strong>*</strong></label>
							( <input id="txtShippingDayPhonePt1" name="shipDayPhonePt1" value="#LEFT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone')),3)#" maxlength="3" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.shipDayPhonePt2)"  style="width:30px;text-align:center;"/> )
							<input id="txtShippingDayPhonePt2" name="shipDayPhonePt2" value="#MID(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone')),5,3)#" maxlength="3" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.shipDayPhonePt3)"  style="width:30px;text-align:center;"/> - 
							<input id="txtShippingDayPhonePt3" name="shipDayPhonePt3" value="#RIGHT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipDayPhone')),4)#" maxlength="4" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" style="width:40px;text-align:center;"/>
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipDayPhone'))#
						</li>
						
						<li>
							<label for="txtShippingEvePhone">Evening Phone<strong>*</strong></label>
							( <input id="txtShippingEvePhonePt1" name="shipEvePhonePt1" value="#LEFT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipEvePhone')),3)#" maxlength="3" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.shipEvePhonePt2)" style="width:30px;text-align:center;"/> )
							<input id="txtShippingEvePhonePt2" name="shipEvePhonePt2" value="#MID(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipEvePhone')),5,3)#" maxlength="3" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.billship.shipEvePhonePt3)" style="width:30px;text-align:center;"/> - 
							<input id="txtShippingEvePhonePt3" name="shipEvePhonePt3" value="#RIGHT(trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.shipEvePhone')),4)#" maxlength="4" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" style="width:40px;text-align:center;"/>
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'shipEvePhone'))#
						</li>		
					</ol>

				</fieldset>
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
		<br/>
		<br/>
	
</form>
</cfoutput>
<hr size="2" Color="#0a94d6">
<div id="buttonDiv" class="formControl">
	<a id="backButton" href="##" onclick="window.location.href='/mainVFD/homepageVFD'">Back</a>
	<a id="continueButton" class="progressBtn" href="##" onclick="showProgress('Validating address, please wait.'); $j('#billShip').submit()"><span >Continue</span></a>
</div>

<!---<cfajaxproxy cfc="ajax.User" jsclassname="User" />
<cfajaxproxy cfc="ajax.CheckoutHelper" jsclassname="CheckoutHelper" />--->

<script language="javascript" type="text/javascript">
	//var user = new User();
	//var checkoutHelper = new CheckoutHelper();
	var $j = jQuery.noConflict();
	
	$j(document).ready(function($j){
			$j('#sameAsBilling').change(function() {
    			$j('#shippingDetails').toggle();
			});
			if($j('#sameAsBilling').is(':checked')) {
				$j('#shippingDetails').hide();
			} else {
				$j('#shippingDetails').show();
			}
			if ($j('#txtEmailAddress').val()){
				$j('#txtBillingFirstName').focus();
			}

	});
	
	checkEmailAddress = function (e)	{
		var emailAddress = e;
		var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);

		showProgress('Creating new account based on email.<br />Please wait.<br />');

		if (validateEmailAddressFormat(e) && $j.trim(e).length)	{
			$j('#billShip').attr('action', '/CheckoutVFD/billShipCheckEmailAddress');		
			$j('#billShip').submit();
		} else {
			requireEmailAddress();
			hideProgress();
		}
	}

	validateEmailAddress = function ()	{
		var e = $j('#txtEmailAddress').val();
		if (validateEmailAddressFormat(e))	{
			return true;
		} else {
			requireEmailAddress();
		}
	}

	validateEmailAddressFormat = function (e)	{
		var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);

		if ($j.trim(e).length && pattern.test(e))
			return true;
		else if (!$j.trim(e).length) // allow 0-length since it will be caught on server-side
			return true;
		else
			return false;
	}
	<cfif request.config.allowAPOFPO>
	checkCityAPO = function (e) {
		$j('#txtShippingCity').val($j('#txtShippingCity').val().toUpperCase());
		e=$j.trim(e).toUpperCase();
		if ($j.trim(e).length && (e == 'APO' || e == 'FPO')) {
			$('#apodislaimer').show();
		} else {
			$j('#apodislaimer').hide();
		}
	}
	</cfif>

	requireEmailAddress = function ()	{
		setTimeout('$j(\'#txtEmailAddress\').focus()', 1); // for some reason, this fails directly, but works with setTimeout()... weird
		alert('Please provide a valid email address.');
	}

	cancelLogin = function ()	{
		$j('#returningCustomer').val('0');
		$j('#liExistingUserPassword').hide('fast');
		$j('#liExistingUserPassword').val('');
		$j('#txtEmailAddress').val('');
		$j('#txtEmailAddress').focus();
	}

</script>
