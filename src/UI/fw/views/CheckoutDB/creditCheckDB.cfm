<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset GeoService = application.wirebox.getInstance("GeoService") />
<cfset textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer") />
<cfset request.p.states = GeoService.getAllStates() />

<cfoutput>
	<form id="creditCheck" class="cmxform" action="/index.cfm/go/checkout/do/processCreditCheck/" method="post">
		<h1>Carrier Application</h1>

		<cfif structKeyExists(request, 'validator') and request.validator.hasMessages()>
			<div class="form-errorsummary">
				#trim(request.validatorView.validationSummary(request.validator.getMessages()))#
			</div>
		</cfif>

		<fieldset>
			<!--- Wording request by Verizon Legal Team --->
			<cfif application.model.checkoutHelper.getCarrier() eq 42>
				<p>
					Verizon Wireless requires a credit check. Your private identification information, such as Social Security number and 
					date of birth, is required to perform this credit check. This information will not be disclosed to anyone other than 
					Verizon Wireless. For your Verizon Wireless order, we will share with Verizon Wireless the email address you provided 
					us. If Verizon Wireless needs additional information in order to successfully complete your credit check, it may contact 
					you directly. The credit check may take more than 24 hours, and may delay the shipment of your order.
				</p>
				<p><strong>Please enter the information of the Primary Account Holder.</strong></p>
			<cfelse>
				<p>
					Your billing information is used to process a credit check with #application.model.checkoutHelper.getCarrierName()#. 
					To confirm service eligibility and complete your order, #application.model.checkoutHelper.getCarrierName()# will need to submit a credit check or use your 
					existing credit information on file with other #application.model.checkoutHelper.getCarrierName()# companies. If there is a deposit required you will be 
					contacted by Customer Care.
				</p>
			</cfif>

			<ol>
				<li>
					<label for="txtDOB">Name</label>
					<label>#trim(session.checkout.billShipForm.billFirstName)# #trim(session.checkout.billShipForm.billLastName)#</label>
				</li>
				
					<li>
						<label for="txtDOB">Date of Birth <strong>*</strong></label>
						<input id="txtDOB" name="dob" autocomplete="off" value="#application.model.checkoutHelper.formValue('session.checkout.creditCheckForm.dob')#" />
						#request.validatorView.validationElement(request.validator.getMessages(), 'dob')#
						<br />
						<span style="color: maroon; font-size: 8pt; margin-left: 123px">(mm/dd/yyyy)</span>
					</li>

				
				<li>
					<label for="txtSSN">Social Security <strong>*</strong></label>
					<input id="txtSSN" name="ssn" autocomplete="off" value="#application.model.checkoutHelper.formValue('session.checkout.creditCheckForm.ssn')#" />
					#request.validatorView.validationElement(request.validator.getMessages(), 'ssn')#
					<br />
					<span style="color: maroon; font-size: 8pt; margin-left: 123px">555-55-5555</span>
				</li>
				

					<li>
						<label for="txtDriver">#textDisplayRenderer.getCreditCheckCustomerIdText()# ## <strong>*</strong></label>
						<input id="txtDriver" name="dln" autocomplete="off" value="#application.model.checkoutHelper.formValue('session.checkout.creditCheckForm.dln')#" />
						#request.validatorView.validationElement(request.validator.getMessages(), 'dln')#
					</li>
					<li>
						<label for="txtDriver">#textDisplayRenderer.getCreditCheckCustomerIdText()# Expire Date <strong>*</strong></label>
						<input id="txtDLExp" name="dlexp" autocomplete="off" value="#application.model.checkoutHelper.formValue('session.checkout.creditCheckForm.dlexp')#" />
						#request.validatorView.validationElement(request.validator.getMessages(), 'dlexp')#
						<br />
						<span style="color: maroon; font-size: 8pt; margin-left: 123px">(mm/dd/yyyy)</span>
					</li>
					<li>
						<label for="ddlState">State of Issue <strong>*</strong></label>
						<select name="dlState" style="width: 155px">
							<option value="">Select Issuing State</option>
							<cfloop query="request.p.states">
								<option value="#request.p.states.stateCode[request.p.states.currentRow]#"<cfif application.model.checkoutHelper.getFormKeyValue('creditCheckForm', 'dlState') eq request.p.states.stateCode[request.p.states.currentRow]> selected</cfif>>#request.p.states.state[request.p.states.currentRow]#</option>
							</cfloop>
						</select>
						#request.validatorView.validationElement(request.validator.getMessages(), 'dlstate')#
					</li>				
			</ol>
		</fieldset>

		<cfif request.config.showServiceCallResultCodes>
			<select name="resultCode" class="resultCode">
				<option value="CC001">Success Credit Approved</option>
				<option value="CC002">Credit Denied</option>
				<option value="CC001-B">Credit Status Unkown</option>
				<option value="CC010">Invalid Request</option>
				<option value="CC011">Unable to Connect to Carrier Service</option>
				<option value="CC012">Service Timeout</option>
				<option value="CC015">Success Credit Approved + Deposit Required</option>
				<option value="" selected="selected">Run for Real</option>
			</select>

			<div>Note, to test things like too many lines, add more than 2 lines to the cart.</div>
		</cfif>

		<div class="formControl">
			<span class="actionButtonLow">
				<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/billShip/'">Back</a>
			</span>
			<span class="actionButton">
				<a href="##" onclick="showProgress('Processing credit check, please wait.'); $('##creditCheck').submit()">Continue</a>
			</span>
		</div>
	</form>
	<p>
		We have the highest respect for your privacy; the information you provide will be kept secure.
		For further details, review our <a href="/index.cfm/go/content/do/privacy" target="_blank">Privacy Policy</a>.
	</p>	
</cfoutput>
