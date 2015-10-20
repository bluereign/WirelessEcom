<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<h2>Thank You</h2>
<cfoutput>
	<p>Thank you for placing your Wireless Advocates order <strong>###request.p.orderid#</strong> with #channelConfig.getDisplayName()#.  We appreciate your business and are pleased you chose to shop with us.  An email confirming your order and providing additional details will be sent to <strong>#request.p.email#</strong> shortly.  Please save this for your records.</p>
	<p>If you have any questions regarding your order please contact our customer service team Monday through Friday 6AM to 6PM PST at #channelConfig.getCustomerCarePhone()#. <!---or via email at onlinesupport@wirelessadvocates.com---></p>
	<p>Your satisfaction is very important to us and we appreciate your business.</p>
	<cfif channelConfig.getDisplayCustomerSurveyLink()>
		<p>Please take a moment to tell us what you think and take our <a href="https://www.surveymonkey.com/s/2S8Y2FJ" target="_blank">online survey</a> <img src="/assets/common/images/ui/icon_feedback_24.png" alt="Online Survey" title="Online Survey" border="0" /></p>
	</cfif>
	<cfif isBoolean(application.model.checkoutHelper.getFormKeyValue('billShipForm', 'returningCustomer')) and not application.model.checkoutHelper.getFormKeyValue('billShipForm', 'returningCustomer')>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.min.js"></script>
		<script type="text/javascript">
			$(document).ready( function() {
				$('##createPassword').validate({
					errorElement: "em",
					rules : {
						username: "required",
						password: {
							required: true,
							minlength: 6,
							maxlength: 8
						},
						password2: {
							equalTo: "##password"
						}
					}
				})
				$('##createPasswordSubmit').click( function() {
					$('##createPassword').submit();
				});
			})
		</script>
		<h4>Check Your Order Status Online</h4>
		<p>If you'd like to be able to check your order status online, please provide a password below. <strong>Your password must be between 6 and 8 characters long.</strong></p>
		<form id="createPassword" class="cmxform" action="/index.cfm/go/checkout/do/updatePassword/" method="post">
			<fieldset>
				<ol>
					<li>
						<label for="username">Email Address</label>
						<input type="hidden" id="username" name="username" value="#session.currentUser.getEmail()#" />
						<span id="txtEmailAddress" style="font-size: 1.2em">#session.currentUser.getEmail()#</span>
					</li>
					<li>
						<label for="password">Password <span>*</span></label>
						<input id="password" name="password" type="password" maxlength="8" />
						#request.validatorView.validationElement(request.validator.getMessages(), 'password')#
					</li>
					<li>
						<label for="password2">Confirm Password <span>*</span></label>
						<input id="password2" name="password2" type="password" maxlength="8" />
						#request.validatorView.validationElement(request.validator.getMessages(), 'password2')#
						<br /><br />
						<div style="padding-left: 120px">
							<span class="actionButtonLow">
								<a onclick="location.href='/index.cfm/'">Cancel</a>
							</span>
							<span class="actionButton">
								<a id="createPasswordSubmit">Ok</a>
							</span>
							<div style="padding-left: 4px; padding-top: 6px; padding-bottom: 10px;">
								<a href="/index.cfm/go/myAccount/do/forgotPassword/">I forgot my password.</a>
							</div>
						</div>
					</li>
				</ol>
			</fieldset>
		</form>
	</cfif>
</cfoutput>
<cfif request.config.enableAnalytics>
	<!-- Google Website Optimizer Conversion Script -->
	<script type="text/javascript">
	if(typeof(_gat)!='object')document.write('<sc'+'ript src="http'+
	(document.location.protocol=='https:'?'s://ssl':'://www')+
	'.google-analytics.com/ga.js"></sc'+'ript>')</script>
	<script type="text/javascript">
	try {
	var gwoTracker=_gat._getTracker("UA-20996841-1");
	gwoTracker._trackPageview("/3761049109/goal");
	}catch(err){}</script>
	<!-- End of Google Website Optimizer Conversion Script -->
</cfif>