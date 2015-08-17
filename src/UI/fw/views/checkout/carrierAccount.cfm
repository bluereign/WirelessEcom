<cfsilent>
	<cfscript>
		WirelessAccount = prc.WirelessAccount;
		ValidationResult = prc.ValidationResult;
		validateContext = prc.validateContext;
		cartLineCount = prc.CartLineCount;
		WirelessLineValidator = prc.WirelessLineValidator;
		WirelessAccountValidator = prc.WirelessAccountValidator;
	</cfscript>
</cfsilent>

<cfoutput>
	<div id="form-container" class="highlight-container gradient">
		<h1>UPGRADE NUMBER LOOKUP</h1>
		<p>Please enter the number you would like to upgrade.</p>
		
		<form id="#formID#" name="#formID#" class="form-horizontal" action="#event.buildLink('checkout.doCarrierAccount')#" method="post">
			<cfloop from="1" to="#CartLineCount#" index="i">
				<div class="form-group">
					<label for="mdn#i#" class="col-sm-5 control-label">Mobile Number to Upgrade</label>
					<div class="col-sm-8">
						<input type="text" id="mdn#i#" name="mdn#i#" class="form-control phonenumber #WirelessLineValidator.getClassIfRequired( 'mdn' & i, validateContext )#" value="#prc['WirelessLine' & i].getCurrentMdn()#" placeholder="(     )     -        ">
						#ValidationResult.renderErrorByField("mdn" & i)#
					</div>
				</div>
			</cfloop>
			<div class="form-group">
				<label for="ssn" class="col-sm-5 control-label">Last 4 of Account Holder Social Security Number</label>
				<div class="col-sm-6">
					<input type="password" id="ssn" name="ssn" class="form-control #WirelessAccountValidator.getClassIfRequired( 'ssn', validateContext )#" maxlength="4" value="#WirelessAccount.getSsn()#">
					#ValidationResult.renderErrorByField("ssn")#
				</div>
			</div>
			<div class="form-group">
				<label for="accountZipCode" class="col-sm-5 control-label">Carrier Account Zip Code</label>
				<div class="col-sm-6">
					<input type="text" id="accountZipCode" name="accountZipCode" class="form-control #WirelessAccountValidator.getClassIfRequired( 'accountZipCode', validateContext )#" maxlength="5" value="#WirelessAccount.getAccountZipCode()#">
					#ValidationResult.renderErrorByField("accountZipCode")#
				</div>
			</div>
			<cfif prc.DisplayPasswordField>
				<div class="form-group">
					<label for="accountPassword" class="col-sm-5 control-label">#prc.PasswordField.Label#</label>
					<div class="col-sm-6">
						<input type="password" id="accountPassword" name="accountPassword" class="form-control" maxlength="#prc.PasswordField.MaxLength#" value="">
					</div>
				</div>
			</cfif>
			
			<cfif request.config.showServiceCallResultCodes>
				<div class="form-group">
					<div class="col-sm-8">
						<select name="resultCode" class="form-control">
							<option value="CL001">Success Customer Found - Upgrade Eligible</option>
							<option value="CL001-B">Success Customer Found - Not Upgrade Eligible</option>
							<!---<option value="CL001-B">Success Customer Found - No Add-a-Line Available</option>--->
<!---							<option value="CL001-D">Success Customer Found - On Family Plan but Service says Individual</option>
							<option value="CL001-E">Success Customer Found - Account Password Required</option>
				            <option value="CL002">Customer not Found</option>
							<option value="CL010">Invalid Request</option>
							<option value="CL011">Unable to Connect to Carrier Service</option>
							<option value="CL012">Service Timeout</option>--->
							<option value="" selected="selected">Run for Real</option>
						</select>
					</div>
				</div>
			</cfif>
		</form>
		
	</div>
</cfoutput>

<script>
	$(document).ready(function(){
		//Set up input masks
		$(".phonenumber").mask("?(999) 999-9999");
	});
</script>

