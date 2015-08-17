<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<h1>Account Security</h1>

<form id="securityQuestionForm" class="cmxform" action="/index.cfm/go/checkout/do/procesSecurityQuestion/" method="post">
	<cfoutput>
	<cfif structKeyExists(request, 'validator') and request.validator.hasMessages()>
		<div class="form-errorsummary">#trim(request.validatorView.validationSummary(request.validator.getMessages(), 10))#</div>
	</cfif>
		<div id="accountpin">
			<fieldset>
				<span class="title">PIN</span>
				<ol>
					<li>
						<label for="accountpin">PIN</label>
						<input id="accountpin" name="accountpin" maxlength="10" value="#application.model.checkoutHelper.formValue('session.checkout.AccountPin')#" />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						<p>PIN must be 6-10 digits and cannot contain your social security number or birthdate.</p>
					</li>
				</ol>
			</fieldset>
		</div>
		<div id="qa">
			<fieldset>
				<span class="title">Security Question & Answer</span>
				<ol>
					<li>
						<label for="securityQuestionId">Question</label>
						<select id="securityQuestionId" name="securityQuestionId">
							<option value="">Select one ...</option>
							<cfloop query="request.p.qQuestions">
								<option value="#SecurityQuestionId#" <cfif application.model.checkoutHelper.formValue('session.checkout.SelectedSecurityQuestionId') eq SecurityQuestionId> selected="selected"</cfif>>#QuestionText#</option>
							</cfloop>
						</select>
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
					</li>
				</ol>
				<ol>
					<li>
						<label for="securityQuestionAnswer">Answer</label>
						<input id="securityQuestionAnswer" name="securityQuestionAnswer" maxlength="30" value="#application.model.checkoutHelper.formValue('session.checkout.SecurityQuestionAnswer')#" />
						<img src="#assetPaths.common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
					</li>
				</ol>
			</fieldset>
		</div>
	</cfoutput>
</form>

<div class="formControl">
	<span class="actionButtonLow">
		<cfif application.model.checkoutHelper.getCheckoutType() is 'new'>
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/creditCheck/'">Back</a>
		<cfelse>
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/wirelessAccountForm/'">Back</a>
		</cfif>
	</span>

	<span class="actionButton"><a href="##" onclick="showProgress('Validating account security, please wait.'); $('#securityQuestionForm').submit()">Continue</a></span>
</div>
