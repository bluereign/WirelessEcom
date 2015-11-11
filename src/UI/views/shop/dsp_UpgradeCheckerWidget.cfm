<cfsetting showdebugoutput="false" />
<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfparam name="request.p.carrierId" type="numeric" default="0" />
<cfparam name="request.p.mdn" type="string" default="" />
<cfparam name="request.p.zipcode" type="string" default="" />
<cfparam name="request.p.ssn" type="string" default="" />
<cfparam name="request.p.accountpassword" type="string" default="" />


<cfsavecontent variable="htmlhHeader">
	<cfoutput>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.metadata.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.maskedinput-1.3.min.js"></script>
	</cfoutput>

	<script>
		$(document).ready(function() {

			//Set up mask
			$("#mdn").mask("?999-999-9999", {placeholder:""});

			//Set validation plugin defaults
			$.validator.setDefaults({
			   meta: "validate"
			   , ignore: ".ignore"
			   , errorElement: "em"
			});

			//Add Rules

			$.validator.addMethod("phoneFormat", function(value, element) {
				if ( /^(\d{3})[-](\d{3})[-](\d{4})$/.test(value) && value.length == 12)
					return true;
				else
					return false;

			}, "Invalid Phone number");

			$.validator.addMethod("last4ssn", function(value, element) {
				if ( /^\d+$/.test(value) && value.length == 4)
					return true;
				else
					return false;

			}, "Enter the last 4 digits of the SSN");

			$.validator.addMethod("zipcode", function(value, element) {
				if ( /^\d+$/.test(value) && value.length == 5)
					return true;
				else
					return false;

			}, "Enter a valid zip code");

			//Prevent enter key on form
			$('input').keypress(function(event) { return event.keyCode != 13; });

			//Set up inputs based on carrier
			switch( $('input[name=carrierId]:checked').val() )
			{
				case '42':
					DisplayCarrierFields('VZN');
					break;
				case '109':
					DisplayCarrierFields('ATT');
					break;
				case '128':
					DisplayCarrierFields('TMO');
					break;
				case '299':
					DisplayCarrierFields('SPT');
					break;
				default:
					$('#mdn-container').hide();
					$('#ssn-container').hide();
					$('#zipcode-container').hide();
					$('#accountpassword-container').hide();
					$('#submit-container').hide();
					break;
			}

			<!--- Fire GA event tracker for eligible look ups --->
			<cfif local.isUpgradeEligible>

				try	{ _gaq.push(['_trackEvent', 'UpgradeChecker', 'Eligible for Upgrade', $('input[name=carrierId]:checked').next('label').children('span').text() ]); }
				catch (e) { }
			</cfif>
		});

		function DisplayCarrierFields( carrierName )
		{
			$('#mdn-container').show();
			$('#submit-container').show();

			switch( carrierName )
			{
				case 'ATT':
					$('#ssn-container').show();
					$('#ssn').removeClass('ignore');
					$('#zipcode-container').show();
					$('#zipcode').removeClass('ignore');
					$('#accountpassword-container').hide();
					$('#accountpassword').addClass('ignore');
					break;
				case 'TMO':
					$('#ssn-container').show();
					$('#ssn').removeClass('ignore');
					$('#zipcode-container').show();
					$('#zipcode').removeClass('ignore');
					$('#accountpassword-container').hide();
					$('#accountpassword').addClass('ignore');
					break;
				case 'SPT':
					$('#ssn-container').hide();
					$('#ssn').addClass('ignore');
					$('#zipcode-container').show();
					$('#zipcode').removeClass('ignore');
					$('#accountpassword-container').show();
					$('#accountpassword').removeClass('ignore');
					break;
				case 'VER':
					$('#ssn-container').show();
					$('#ssn').removeClass('ignore');
					$('#zipcode-container').show();
					$('#zipcode').removeClass('ignore');
					$('#accountpassword-container').show();
					$('#accountpassword').removeClass('ignore');
					break;
			}
		}

		function ValidateUpgradeForm()
		{
			$("#upgradeform").validate();

			if ( $("#upgradeform").valid() )
			{
				//Fire GA event tracker
				try	{ _gaq.push(['_trackEvent', 'UpgradeChecker', 'Submit Form', $('input[name=carrierId]:checked').next('label').children('span').text() ]); }
				catch (e) { }

				$('#form-container').hide();
				$('#message-box').hide();
				$('#loading-container').show();

				$('#upgradeform').submit();
			}

			return false;
		}

		function ValidateNotificationForm()
		{
			$("#notificationform").validate();

			if ( $("#notificationform").valid() )
			{
				$('#notificationform').submit();
			}

			return false;
		}

		function DisplayForm()
		{
			$('#success-container').hide();
			$('#form-container').show();
		}

		function DirectShoppingUrl()
		{
			top.location.href = <cfoutput>'#local.phoneListUrl#'</cfoutput>;
		}
	</script>

	<style>
		body {
			margin: 0 auto;
			color: #333;
			font-family: Arial, Helvetica, sans-serif;
			min-width:500px;
		}

		#upgradeform  {
			font-size: 12px;
			font-weight: bold;
			line-height: 38px;
			padding: 5px 25px;
		}

		.textbox-label {
			width: 250px;
			display:inline-block;
		}

		.textbox-label-short {
			width: 45px;
			display:inline-block;
		}

		.textbox-label span {
			font-size: 10px;
			color: #888;
		}

		.notification-label {
			font-size: 12px;
			font-weight: bold;
			width: 45px;
		}

		#widget-container {
			background: #efefef;
			background-image: url('<cfoutput>#assetPaths.common#</cfoutput>images/upgradechecker/upgrade-checker-bg.png');
			background-repeat: repeat-x;
			margin: auto;
			height: 500px;
			border-radius: 5px 5px 5px 5px;
			font-size: 100%;
		}

		#widget-title-bar {
			height: 40px;
			margin: auto;
			padding: 15px 30px;
			/*<cfoutput>background-image: url('<cfoutput>#assetPaths.channel#</cfoutput>images/costco_logosm.gif');</cfoutput>*/
			background-repeat:no-repeat;
			background-position: 500px 20px;
		}

		#widget-title-bar h1 {
			font-size: 22px;
			font-weight: 900;
			color: #0060a9;
		}


		#carrier-container input[type='text'] {
			padding-top:30px;
		}

		.textbox {
			/*display:block;*/
			border: 1px solid #999;
			line-height: 22px;
			height: 22px;
			padding: 3px 8px;
			-moz-border-radius: 3px;
			border-radius: 3px;
		}

		.textbox-long {
			width: 180px;
		}

		.textbox-short {
			width: 85px;
		}

		input:focus {
			border: 1px solid #09C;
			-webkit-box-shadow: 0px 0px 5px #09C;
			-moz-box-shadow: 0px 0px 5px #09C;
			box-shadow: 0px 0px 5px #09C;
		}

		input.error:focus {
			-webkit-box-shadow: 0px 0px 5px #D8000C;
			-moz-box-shadow: 0px 0px 5px #D8000C;
			box-shadow: 0px 0px 5px #D8000C;
		}

		.submit-container {
			margin-top: 25px;
			margin-bottom: 10px;
		}


		#submitUpgradeForm {
			height: 50px;
			font-size: 18px;
		}

		#message-box {
			width: auto;
			margin: 20px 35px 5px;
			padding: 8px 15px;
			border: 1px solid #4256cf;
			font-size: 12px;
			background: #BDE5F8;
			color: #00529B;
		}

		input.error {
			border: 2px solid #D8000C;
			background-color: #FFBABA;
		}

		em.error {
			font-size: 12px;
			font-weight: bold;
			color: #D8000C;
			margin-left: 10px;
			font-style: normal;
		}

		.carrier-radio, .carrier-radio:focus {
			vertical-align: middle;
			border: 0px none;
			background: transparent;
		}

		.carrier-logo-label {
			background-repeat: no-repeat;
			width: 115px;
			height: 50px;
			display: inline-block;
			text-indent: -999em;
			cursor: pointer;
		}

		#loading-container {
			display: none;
			margin-left: 35px;
			margin-top: 35px;
			width: 400px;
			color: #333;
		}

		#success-container {
			padding: 25px 25px;
		}

		#shoppingBtn {
		    background-image: url('<cfoutput>#assetPaths.common#</cfoutput>images/upgradechecker/shopping_btn.png');
		    background-color: transparent;
		    background-repeat: no-repeat;
			height: 47px;
			width: 164px;
			border: none;
			cursor: pointer;
		}

		#toggle-form-link {
			color: #333;
		}

		#email-notification-container {
			margin-top: 10px;
			border-top: #ccc solid 1px;
		}
	</style>

</cfsavecontent>

<cfhtmlhead text="#htmlhHeader#" />



<cfoutput>

<div id="widget-container">
	<div id ="widget-title-bar">
		<h1>UPGRADE ELIGIBILITY CHECKER</h1>
	</div>

	<cfif !local.isAccountLookupSuccessful && Len(local.message)|| validator.hasMessages()>
		<div id="message-box">
			#local.message#

			<cfloop array="#validator.getMessages()#" index="m">
				#m.Message# <br />
			</cfloop>
		</div>
	</cfif>

	<div id="loading-container">
		<h2>Checking upgrade eligibility ...</h2>
		<img src="#assetPaths.common#images/upgradechecker/ajax-loader.gif" />
	</div>



	<div id="form-container" <cfif local.isAccountLookupSuccessful>style="display: none;"</cfif>>

		<form id="upgradeform" name="upgradeform" method="post" action="" autocomplete="off">
			<input type="hidden" name="upgradeFormSubmit" value="" />
		    <div id="carrier-container">
		        Select a carrier: <br />
				<cfif application.model.Carrier.isEnabled(109) AND NOT ListFind(channelConfig.getCarrierTwoYearRemoval(), 109)>
			        <input type="radio" class="carrier-radio" id="attCarrier" name="carrierId" value="109" onclick="DisplayCarrierFields('ATT')" <cfif request.p.carrierId eq 109>checked="checked"</cfif> />
					<label for="attCarrier">
						<span class="carrier-logo-label" style="background-image: url('#assetPaths.common#images/upgradechecker/att_logo.png');">AT&T</span>
					</label>
				</cfif>
				<cfif application.model.Carrier.isEnabled(299) AND NOT ListFind(channelConfig.getCarrierTwoYearRemoval(), 299)>
			        <input type="radio" class="carrier-radio" id="sprintCarrier" name="carrierId" value="299" onclick="DisplayCarrierFields('SPT')" <cfif request.p.carrierId eq 299>checked="checked"</cfif> />
					<label for="sprintCarrier">
						<span class="carrier-logo-label" style="background-image: url('#assetPaths.common#images/upgradechecker/sprint_logo.png');">Sprint</span>
					</label>
				</cfif>
				<!---
					<cfif application.model.Carrier.isEnabled(128) AND NOT ListFind(channelConfig.getCarrierTwoYearRemoval(), 128)>
				    <input type="radio" class="carrier-radio" id="tmobileCarrier" name="carrierId" value="128" onclick="DisplayCarrierFields('TMO')" <cfif request.p.carrierId eq 128>checked="checked"</cfif> />
					<label for="tmobileCarrier">
						<span class="carrier-logo-label" style="background-image: url('#assetPaths.common#images/upgradechecker/tmo_logo.png');">T-Mobile</span>
					</label>
				</cfif>
				--->
				<cfif application.model.Carrier.isEnabled(42) AND NOT ListFind(channelConfig.getCarrierTwoYearRemoval(), 42)>
					<input type="radio" class="carrier-radio" id="verizonCarrier" name="carrierId" value="42" onclick="DisplayCarrierFields('VER')" <cfif request.p.carrierId eq 42>checked="checked"</cfif> />
					<label for="verizonCarrier">
						<span class="carrier-logo-label" style="background-image: url('#assetPaths.common#images/upgradechecker/verizon_logo.png');">Verizon</span>
					</label>
				</cfif>
		    </div>
			<div id="mdn-container">
				<label for="mdn" class="textbox-label">Check eligibility for this phone number</label>
				<input type="text" class="textbox textbox-long {validate:{required:true, phoneFormat:true}}" id="mdn" name="mdn" maxlength="12" value="#request.p.mdn#" autocomplete="off" />
			</div>
			<div id="zipcode-container">
				<label for="zipcode" class="textbox-label">Billing Zip Code</label>
				<input type="text" class="textbox textbox-short {validate:{required:true, zipcode:true}}" id="zipcode" name="zipcode" maxlength="5" value="#request.p.zipcode#" autocomplete="off" />
			</div>
			<div id="ssn-container">
				<label for="ssn" class="textbox-label">Social Security Number <span>(Last 4 digits)</span></label>
				<input type="password" class="textbox textbox-short {validate:{required:true, last4ssn:true}}" id="ssn" name="ssn" maxlength="4" value="#request.p.ssn#" autocomplete="off" />
			</div>
			<div id="accountpassword-container">
				<label for="accountpassword" class="textbox-label">PIN/Password <span>(Required if set up on account)</span></label>
				<input type="password" class="textbox textbox-short" id="accountpassword" name="accountpassword" maxlength="15" value="#request.p.accountpassword#" autocomplete="off" />
			</div>
			<div id="submit-container" class="submit-container textbox-label">
				<a class="ActionButton" href="##" onclick="ValidateUpgradeForm();">
					<span>Check Eligibility</span>
				</a>
			</div>
		</form>
	</div>

	<cfif local.isAccountLookupSuccessful>
		<div id="success-container">
			<cfswitch expression="#request.p.CarrierId#">
				<cfcase value="109">
					<img src="#assetPaths.common#images/upgradechecker/att_logo.png" />
				</cfcase>
				<cfcase value="299">
					<img src="#assetPaths.common#images/upgradechecker/sprint_logo.png" />
				</cfcase>
				<cfcase value="128">
					<img src="#assetPaths.common#images/upgradechecker/tmo_logo.png" />
				</cfcase>
				<cfcase value="42">
					<img src="#assetPaths.common#images/upgradechecker/verizon_logo.png" />
				</cfcase>
			</cfswitch>

			<h2>#local.message#</h2>
			<p>Mobile number: <b>#local.formattedMdn#</b></p>

			<p><a id="toggle-form-link" href="" onclick="DisplayForm(); return false;">Check another phone number</a></p>

			<cfif local.isUpgradeEligible>
				<a class="ActionButtonLargeGreen" href="##" onclick="DirectShoppingUrl();">
					<span>Shop for my Upgrade</span>
				</a>
			<cfelse>
				<div id="email-notification-container">
					<p>Would you like us to notify you when <b>#local.formattedMdn#</b> becomes eligible to upgrade?</p>
					<form id="notificationform" method="post" action="">
						<input type="hidden" name="EmailNotificationSubmit" />
						<input type="hidden" name="Mdn" value="#local.formattedMdn#" />
						<input type="hidden" name="EligibilityDate" value="#local.EligibilityDate#" />
						<input type="hidden" name="CarrierId" value="#request.p.CarrierId#" />
						<div id="zipcode-container">
							<label for="emailNotification" class="textbox-label notification-label">Email</label>
							<input id="emailNotification" name="emailNotification" class="textbox textbox-long {validate:{required:true, email:true}}" value="" />
						</div>
						<div class="submit-container textbox-label">
							<a class="ActionButton" href="##" onclick="ValidateNotificationForm(); return false;">
								<span>Notify Me</span>
							</a>
						</div>
					</form>
				</div>
			</cfif>
		</div>
	</cfif>
</div>
</cfoutput>
