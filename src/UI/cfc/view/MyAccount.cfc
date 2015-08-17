<cfcomponent output="false">

	<cffunction name="init" access="public" returntype="MyAccount" output="false">
		<!--- Remove this when this component is added to CS --->        
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfset setGeoService( application.wirebox.getInstance("GeoService") ) />
		<cfreturn this />
	</cffunction>

	<cffunction name="login" access="public" returntype="string" output="false">
		<cfargument name="loginFailed" default="false" type="boolean" />
		<cfargument name="message" default="" type="string" />

		<cfset var local = structNew() />
  		<cfset local.type = 'login' />

		<cfsavecontent variable="local.html">
			<cfoutput>
         		<script type="text/javascript">
					function submitForm(which)	{
						var theForm = document.forms[which];

						if(validateLogin())	{
							theForm.submit();
						}
					}

					function validateLogin()	{
						var objUsr = document.getElementById('txtUsername');
						var objPwd = document.getElementById('txtPassword');

						if(objUsr.value == '')	{
							alert('Please enter your Email Address.');
							objUsr.focus();

							return false;
						} else if(!isValidEmail(objUsr.value))	{
							alert('Please enter a valid Email Address.');
							objUsr.focus();

							return false;
						} else if(objPwd.value == '')	{
							alert('Please enter your Password.');
							objPwd.focus();

							return false;
						} else if(objPwd.value.length < 6)	{
							alert('Password too short!');
							objPwd.focus();

							return false;
						} else {
							return true;
						}
					}

					function isValidEmail(address) {
						if (address != '' && address.search) {
							if (address.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1) return true;
							else return false;
						}
						else return true;
					}

					function focusField(which, next)	{
						var theField = document.getElementById(which);
						var nextField = document.getElementById(next);

						if(theField.value.length == 0)	{
							theField.focus();
						} else {
							nextField.focus();
						}
					}

					function submitEnter(which)	{
						if(event.keyCode == 13)	{
							submitForm(which);
						}
					}
				</script>

				<cfif local.type is 'checkout'>
                	<h1>Checkout</h1>
               	<cfelse>
                	<h1>Login or Create a New Account</h1>
                </cfif>

				<div class="login">
					<form id="frmLogin" action="/index.cfm/go/myAccount/do/processLogin/" method="post">
						<h2>Log In</h2>
						<cfif len(trim(arguments.message))>
							<p class="message">#trim(arguments.message)#</p>
						</cfif>
						<cfif isDefined('successMsg')>
							<p class="message">Your password has been reset. Please log in.</p>
						</cfif>
						<cfif request.validator.hasMessages()>
                        	<p class="error">#request.validatorView.validationSummary(request.validator.getMessages(), 4)#</p>
                        <cfelseif arguments.loginFailed>
							<p class="error">Login failed, try again.</p>
                        </cfif>
						<label class="loginText" for="txtUsername">Email Address:</label>
						<input type="text" id="txtUsername" name="username" value="#trim(request.p.username)#" tabindex="1" />
						<img src="#getAssetPaths().common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						<br />
						#request.validatorView.validationElement(request.validator.getMessages(), 'email')#
						<br />
						<label class="loginText" for="txtPassword">Password:</label>
						<input type="password" id="txtPassword" name="password" autocomplete="off" value="#trim(request.p.password)#" maxlength="8" tabindex="2" onkeydown="submitEnter('frmLogin')" />
						<img src="#getAssetPaths().common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						<br />
						#request.validatorView.validationElement(request.validator.getMessages(), 'password')#
					</form>
					<div class="formControl"><span class="actionButton"><a onclick="submitForm('frmLogin')" tabindex="3">Log In</a></span></div>

					<form id="frmForgot" action="/index.cfm/go/myAccount/do/forgotPassword/" method="post">
						<input type="hidden" value="Forgot Password" />
						<a href="##" onclick="document.forms['frmForgot'].submit()" style="display: block; font-size: 1.2em; text-align: right;" tabindex="4">Forgot your password?</a>
					</form>
				</div>
				<div class="signUp">
					<form id="frmSignup" action="/index.cfm/go/myAccount/do/signup/" method="post">
						<h2>Create an Account</h2>

                        <div style="width: 275px; font-size: 1.2em">
							Creating an account speeds up your checkout by saving your billing and shipping address.
							You can also view your order history, order details and restore your saved cart.
						</div>
						<div class="formControl" style="float: left">
							<span class="actionButton">
								<a href="##" onclick="$('frmSignup').submit()" tabindex="5">Create an Account</a>
							</span>
						</div>
					</form>
				</div>
				<script type="text/javascript">focusField('txtUsername', 'txtPassword');</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="forgotPassword" access="public" returntype="string" output="false">
		<cfargument name="passwordError" default="" type="string" />

		<cfset var local = structNew() />

		<cfsavecontent variable="local.html">
			<script type="text/javascript">
				function submitForm(which)	{
					var theForm = document.forms[which];

					if(validateForm())	{
						theForm.submit();

						return true;
					} else {
						return false;
					}
				}

				function validateForm()	{
					var objUsr = document.getElementById('txtUsername');

					if(objUsr.value == '')	{
						alert('Please enter your Email Address.');
						objUsr.focus();

						return false;
					} else if(!isValidEmail(objUsr.value))	{
						alert('Please enter a valid Email Address.');
						objUsr.focus();

						return false;
					} else {
						return true;
					}
				}

				function isValidEmail(address) {
					if (address != '' && address.search) {
						if (address.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1) return true;
						else return false;
					}
					else return true;
				}

				function focusField(which)	{
					document.getElementById(which).focus();
				}

				function submitEnter(which)	{
					if(event.keyCode == 13)	{
						return submitForm(which);
					} else {
						return true;
					}
				}
			</script>
			<cfoutput>
				<div class="forgotPassword">
					<form id="frmForgot" action="/index.cfm/go/myAccount/do/processForgotPassword/" method="post">
						<h2>Forgot your Password?</h2>
                        <strong style="font-size: 1.2em">Enter your email address and we'll help you reset your forgotten password.</strong>
						<br />
						<cfif request.validator.hasMessages()>
                        	<p class="error">#trim(request.validatorView.validationSummary(request.validator.getMessages(), 4))#</p>
                        <cfelseif len(trim(arguments.passwordError))>
							<p class="error">#trim(arguments.passwordError)#</p>
						</cfif>
                        <br />
						<label class="loginText" for="txtUsername">Email Address:</label>
						<input type="text" id="txtUsername" name="username" value="#trim(request.p.username)#" tabindex="1" onkeydown="return submitEnter('frmForgot')" />
						<br />
						<div class="formControl" style="float: left"><span class="actionButton"><a onclick="return submitForm('frmForgot')" tabindex="2">Continue</a></span></div>
					</form>
				</div>
				<script type="text/javascript">focusField('txtUsername');</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="resetPassword" access="public" returntype="string" output="false">
		<cfargument name="passwordError" default="">
		<cfset var local = structNew()>
		<cfsavecontent variable="local.html">
			<cfoutput>
				<div class="resetPassword">
					<form id="frmReset" action="/index.cfm/go/myAccount/do/processResetPassword/username/#REQUEST.p.username#/code/#REQUEST.p.code#" method="post">
						<h2>Reset Password</h2>
                         <!--- Begin: Venkit: Neologix,09 March 2010 --->
                        <cfif request.validator.HasMessages()>
                        	<p class="error">#request.validatorView.ValidationSummary(request.validator.getMessages(), 4)#</p>
						<cfelseif len(ARGUMENTS.passwordError)>
							<p class="error">#ARGUMENTS.passwordError#</p>
						</cfif>
						<!--- End: Venkit: Neologix,09 March 2010 --->
						<p>
							Please select a new password for your account and enter it below.
						</p>

						<label form="txtUsername">Username:</label>
						<span>#REQUEST.p.username#</span><br><br>

						<label form="txtPassword">New Password:</label>
						<input type="password" maxlength="8" id="txtPassword" name="password" value="#REQUEST.p.password#"/> *
                        <br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"password")#
						<br/>

						<label form="txtConfirm">Confirm New Password:</label>
						<input type="password" maxlength="8" id="txtConfirm" name="password2" value="#REQUEST.p.password2#"/> *<br />
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"confpassword")#<br>
                        *Required
						<br/>

						<div class="formControl">
							<span class="actionButton">
								<a onclick="$('frmReset').submit()">Save new password</a>
							</span>
						</div>

						<input type="hidden" name="username" value="#REQUEST.p.username#"/>
						<input type="hidden" name="code" value="#REQUEST.p.code#"/>

					</form>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>

    <cffunction name="usernameCodeNotExists" access="public" returntype="string" output="false">
    	<cfargument name="passwordError" default="" type="string" />

    	<cfset var local = structNew() />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<div class="resetPassword">
                    <h2>Reset Password</h2>
                    <cfif len(trim(arguments.passwordError))>
                        <p class="error">#trim(arguments.passwordError)#</p>
                    </cfif>
                    <a href="/index.cfm/go/myAccount/do/signup/">Click here to create an account</a>
                </div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
    </cffunction>

	<cffunction name="signup" access="public" returntype="string" output="false">
		<cfargument name="signupError" default="">
		<cfset var local = structNew()>
		<cfsavecontent variable="local.html">
			<cfoutput>
            <!--- Begin: Neologix, 03-March 2010
				RMP: Client side validation: email/password validation
				  --->
         		<script type="text/javascript">
				//function to validate login details
					function validateAccount(){
						objUsr = document.getElementById('username');
						objPwd = document.getElementById('password');
						objCnfPwd = document.getElementById('password2');
						if(objUsr.value == ''){
							alert("Please enter your email.");
							objUsr.focus();
							return false;
						}
						else if(! isValidEmail(objUsr.value)){
							alert("Please enter a valid email.");
							objUsr.focus();
							return false;
						}
						if(objPwd.value == ''){
							alert("Please enter your Password.");
							objPwd.focus();
							return false;
						}
						else{
							if(objPwd.value.length < 6){
								alert("Password too short!");
								objPwd.focus();
								return false;
							}
						}
						if(objCnfPwd.value == ''){
							alert("Please enter your Confirm Password.");
							objCnfPwd.focus();
							return false;
						}
						else{
							if(objCnfPwd.value != objPwd.value){
								alert("Password and Confirm Password does not match!");
								objCnfPwd.focus();
								return false;
							}
						}

						return true;
					}


					// Check an email address conforms to standard email format (will allow blanks and addresses like postmaster@localhost)
					function isValidEmail(address) {
						if (address != '' && address.search) {
							if (address.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1) return true;
							else return false;
						}
						// allow empty strings to return true - screen these with either a 'required' test or a 'length' test
						else return true;
					}

				</script>
                <!--- End: Neologix, 03-March 2010
				RMP: Client side validation: email/password validation
				  --->
            	<!---<h1>Create a New Account</h1>--commented at Neologix as per spec--->
                <h1>Create an Account</h1>

				<div class="signUp">
					<form id="frmSignup" action="/index.cfm/go/myAccount/do/processSignup/" method="post">
						<!---<h2>Account Credentials</h2> --commented at Neologix as per spec--->
						<!---<cfif len(ARGUMENTS.signupError)>
							<p class="error">#ARGUMENTS.signupError#</p>
						</cfif> -- commented at neologix--->
                        <!--- RMP: Validation --->
						<cfif request.validator.HasMessages()>
                        	<p class="error">#request.validatorView.ValidationSummary(request.validator.getMessages(), 4)#</p>
                        <cfelseif len(ARGUMENTS.signupError)>
							<p class="error">#ARGUMENTS.signupError#</p>
                        </cfif>
						<!--- RMP: Validation --->
						<label for="">Email Address:</label>
						<input type="text" name="username" id="username" value="#REQUEST.p.username#"/>
						<img src="#getAssetPaths().common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						<br/>#request.validatorView.ValidationElement(request.validator.getMessages(),"email")#<br>

						<label for="">Password:</label>
						<input type="password" name="password" maxlength="8" id="password" autocomplete="off" value="#REQUEST.p.password#"/>
						<img src="#getAssetPaths().common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						<br/>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"password")#<br>

						<label for="">Confirm Password:</label>
						<input type="password" name="password2" maxlength="8" id="password2" autocomplete="off" value="#REQUEST.p.password2#"/>
						<img src="#getAssetPaths().common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						<br />
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"confpassword")#<br>
                        <br/>

						<!---<div class="formControl">
							<span class="actionButton">
								<a onclick="$('frmSignup').submit()">Sign Up</a>
							</span>
						</div> --commented at Neologix as per spec--->
                        <!--- Begin: Neologix, 03-March 2010
						RMP: Added new Save and Cancel button
						  --->
						<div class="formControl">
							<span class="actionButton">
								<a onclick="$('frmSignup').submit();">Save</a><!---<a onclick="if(validateAccount()){$('frmSignup').submit();}">Save</a>--->
							</span>
                            <span class="actionButton">
								<a onclick="location.href='/index.cfm/go/myAccount/do/login/'">Cancel</a>
							</span>
						</div>
						<!--- End: Neologix, 03-March 2010
						RMP: Added new Save and Cancel button
						  --->
					</form>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>
	
	<cffunction name="signup_3rdPartyAuth" access="public" returntype="string" output="false">
		<cfargument name="signupError" default="">
		<cfset var local = structNew()>
		<cfsavecontent variable="local.html">
			<cfoutput>
            <!--- Begin: Neologix, 03-March 2010
				RMP: Client side validation: email/password validation
				  --->
         		<script type="text/javascript">
				//function to validate login details
					function validateAccount(){
						objUsr = document.getElementById('username');
						if(objUsr.value == ''){
							alert("Please enter your email.");
							objUsr.focus();
							return false;
						}
						else if(! isValidEmail(objUsr.value)){
							alert("Please enter a valid email.");
							objUsr.focus();
							return false;
						}

						return true;
					}

					// Check an email address conforms to standard email format (will allow blanks and addresses like postmaster@localhost)
					function isValidEmail(address) {
						if (address != '' && address.search) {
							if (address.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1) return true;
							else return false;
						}
						// allow empty strings to return true - screen these with either a 'required' test or a 'length' test
						else return true;
					}

				</script>
                <h1>Create an Account</h1>

				<div class="signUp">
					<form id="frmSignup" action="/index.cfm/go/myAccount/do/processSignup_3rdPartyAuth/" method="post">
						<cfif request.validator.HasMessages()>
                        	<p class="error">#request.validatorView.ValidationSummary(request.validator.getMessages(), 4)#</p>
                        <cfelseif len(ARGUMENTS.signupError)>
							<p class="error">#ARGUMENTS.signupError#</p>
                        </cfif>
						<!--- RMP: Validation --->
						<label for="">Email Address:</label>
						<input type="text" name="username" id="username" value="#REQUEST.p.username#"/>
						<img src="#getAssetPaths().common#images/ui/red_asterisk.gif" width="11" height="11" alt="Required Field" />
						<br/>#request.validatorView.ValidationElement(request.validator.getMessages(),"email")#<br>

						<div class="formControl">
							<span class="actionButton">
								<a onclick="$('frmSignup').submit();">Save</a><!---<a onclick="if(validateAccount()){$('frmSignup').submit();}">Save</a>--->
							</span>
                            <span class="actionButton">
								<a onclick="location.href='/index.cfm/go/myAccount/do/login/'">Cancel</a>
							</span>
						</div>
						<!--- End: Neologix, 03-March 2010
						RMP: Added new Save and Cancel button
						  --->
					</form>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>

	<cffunction name="view" access="public" returntype="string" output="false">
		<cfset var local = structNew()>
		<!--- TODO: take this call out of the view method. It's only in here because we don't know what's on this page. --->
		<cfset local.thisUser = application.model.User.getUserByID(SESSION.userID)/>
		<cfset local.savedCart = false>
		<cfif len(trim(local.thisUser.wddxCart))>
			<cfset local.savedCart = true>
		</cfif>

		<cfsavecontent variable="local.html">
			<cfoutput>
				<h2>Logged in as: #local.thisUser.username#</h2>

				<div class="formControl" style="text-align:left;">
<!--- TRV: disabling this for Phase 1 release pending further troubleshooting
					<cfif local.savedCart>
						<span class="actionButtonLow">
							<a onclick="location.href='/index.cfm/go/cart/do/loadCart/'">Restore Saved Cart</a>
						</span>
					</cfif>
--->
					<span class="actionButtonLow">
						<a onclick="location.href='/index.cfm/go/myAccount/do/edit/'">Edit Account</a>
					</span>
					<span class="actionButtonLow">
						<a onclick="location.href='/index.cfm/go/myAccount/do/viewOrderHistory/'">Order History</a>
					</span>
					<span class="actionButtonLow">
						<a onclick="location.href='/index.cfm/go/myAccount/do/logout/'">Log Out</a>
					</span>
				</div>


			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>

	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="user" required="false" type="any" />
		<cfargument name="aErrors" required="false" type="array" default="#arrayNew(1)#" />
		<cfargument name="message" required="false" default="" type="string" />

		<cfset var local = structNew() />

		<cfsavecontent variable="local.html">
			<cfoutput>
            	<h1>Password Reset</h1>
				<br />
				<cfoutput>
					<cfif isDefined('request.validator') and request.validator.hasMessages()>
						<div class="form-errorsummary">#trim(request.validatorView.validationSummary(request.validator.getMessages()))#</div>
					</cfif>
				</cfoutput>

				<cfif len(trim(arguments.message))>
					<p class="message">#trim(arguments.message)#</p>
				</cfif>

				<form id="frmAccount" action="/index.cfm/go/myAccount/do/processEdit/" method="post">
					<div class="editAccount">
						<h2>Update your Email address</h2>

						<label for="txtUsername">Email Address:</label>
						<input type="text" id="txtUsername" name="username" value="#trim(request.p.username)#" tabindex="1" /><span class="req"> *</span>Required
						<cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'username'))>
							<br />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'username'))#
						</cfif>
						<br />
						<h2>Change your password</h2><br>
						<label for="txtPassword">New Password:</label>
						<input type="password" maxlength="8" id="txtPassword" name="password" value="#trim(request.p.password)#" tabindex="2" />
						<cfif len(request.validatorView.validationElement(request.validator.getMessages(), 'password'))>
							<br />
							#trim(request.validatorView.validationElement(request.validator.getMessages(), 'password'))#
						</cfif>
						<br />
						<label for="txtConfirm">Confirm Password:</label>
						<input type="password" maxlength="8" id="txtConfirm" name="password2" value="#trim(request.p.password2)#" tabindex="3" />
						<br />
						#trim(request.validatorView.validationElement(request.validator.getMessages(), 'confpassword'))#
					</div>

					<div class="formControl">
						<span class="actionButton"><a onclick="$('frmAccount').submit()" tabindex="5">Save</a></span>
                        <span class="actionButton"><a onclick="location.href='/index.cfm/go/myAccount/do/view/'" tabindex="6">Cancel</a></span>
					</div>
					<script type="text/javascript">
						document.getElementById('txtPassword').focus();
					</script>
				</form>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

    <cffunction name="getLeftMenu" access="public" returntype="string" output="false">

    	<cfset var local = structNew() />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<div class="leftMenu">
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td>
								<h1>Your Account</h1>
								<br />
								<strong>
									Welcome
									<cfif len(trim(application.model.user.getFirstName()))>
										<br />
										#left(trim(application.model.user.getFirstName()), 20)#
									<cfelse>
										<br />
										#left(trim(application.model.user.getEmail()), 20)#
									</cfif>
								</strong>
								<br /><br />
								<a href="/index.cfm/go/myAccount/do/view/">Account Summary</a>
								<br /><br />
								<a href="/index.cfm/go/myAccount/do/viewOrderHistory/">Order History</a>
								<br /><br />
								<a href="/index.cfm/go/myAccount/do/viewAccountInfo/">Your Account Info</a>
								<br /><br />
								<a href="/index.cfm/go/myAccount/do/edit/">Password Reset</a>
								<br /><br />
								<a href="/index.cfm/go/myAccount/do/logout/">Log out</a>
								<br /><br /><br />

								<cfset request.p.user = createObject('component', 'cfc.model.User').init() />
								<cfset request.p.user.getUserById(session.userId) />

								<cfif request.p.user.isAdmin()>
									<strong>Admin</strong>
									<br />
									<a href="/index.cfm/go/myAccount/do/bundle/">View Bundles</a>
								</cfif>
							</td>
						</tr>
					</table>
				</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

    <cffunction name="getAccSummary" access="public" returntype="string" output="false">

		<cfset var local = structNew() />

		<cfif not session.UserAuth.isLoggedIn() or not structKeyExists(session, 'userId')>
			<cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false" />
		</cfif>

		<cfset local.billingAddress = application.model.user.getBillingAddress() />
		<cfset local.shippingAddress = application.model.user.getShippingAddress() />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<h1>Account Summary</h1>
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<tr valign="top">
						<td width="33%" style="font-size: 12pt; font-weight: bold"><strong>Your Account</strong></td>
						<td style="font-size: 12pt; font-weight: bold"><strong>Billing Information</strong></td>
						<td width="33%" style="font-size: 12pt; font-weight: bold"><strong>Shipping Information</strong></td>
					</tr>
					<tr valign="top">
						<td style="font-size: 10pt"><a href="/index.cfm/go/myAccount/do/edit/">Edit</a></td>
						<td style="font-size: 10pt"><a href="/index.cfm/go/myAccount/do/manageBilling/"><cfif len(trim(local.billingAddress.getFirstName()))>Edit<cfelse>Add</cfif></a></td>
						<td style="font-size: 10pt"><a href="/index.cfm/go/myAccount/do/manageShipping/"><cfif len(trim(local.shippingAddress.getFirstName()))>Edit<cfelse>Add</cfif></a></td>
					</tr>
					<tr valign="top">
						<td style="font-size: 10pt">Email: #trim(application.model.user.getEmail())#</td>
						<td style="font-size: 10pt">
							<cfif len(trim(local.billingAddress.getFirstName()))>
								#trim(local.billingAddress.getFirstName())#
							</cfif>
							<cfif len(trim(local.billingAddress.getMiddleInitial()))>
								#trim(local.billingAddress.getMiddleInitial())#
							</cfif>
							<cfif len(trim(local.billingAddress.getLastName()))>
								#trim(local.billingAddress.getLastName())#
							</cfif>
							<br />
							<cfif len(trim(local.billingAddress.getAddressLine1()))>
								#trim(local.billingAddress.getAddressLine1())#
								<br />
							</cfif>
							<cfif len(trim(local.billingAddress.getCity()))>
								#trim(local.billingAddress.getCity())#,
							</cfif>
							<cfif len(trim(local.billingAddress.getState()))>
								#trim(local.billingAddress.getState())#
							</cfif>
							<cfif len(trim(local.billingAddress.getZipCode()))>
								#trim(local.billingAddress.getZipCode())#
							</cfif>
							<cfif len(trim(local.billingAddress.getDayPhone()))>
								<br /><br />
								Daytime: #trim(local.billingAddress.getDayPhone())#
								<br />
							</cfif>
							<cfif len(trim(local.billingAddress.getEvePhone()))>
								Evening: #trim(local.billingAddress.getEvePhone())#
							</cfif>
						</td>
						<td style="font-size: 10pt">
							<cfif len(trim(local.shippingAddress.getFirstName()))>
								#trim(local.shippingAddress.getFirstName())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getMiddleInitial()))>
								#trim(local.shippingAddress.getMiddleInitial())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getLastName()))>
								#trim(local.shippingAddress.getLastName())#
							</cfif>
							<br />
							<cfif len(trim(local.shippingAddress.getAddressLine1()))>
								#trim(local.shippingAddress.getAddressLine1())#
								<br />
							</cfif>
							<cfif len(trim(local.shippingAddress.getCity()))>
								#trim(local.shippingAddress.getCity())#,
							</cfif>
							<cfif len(trim(local.shippingAddress.getState()))>
								#trim(local.shippingAddress.getState())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getZipCode()))>
								#trim(local.shippingAddress.getZipCode())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getDayPhone()))>
								<br /><br />
								Daytime: #trim(local.shippingAddress.getDayPhone())#
								<br />
							</cfif>
							<cfif len(trim(local.shippingAddress.getEvePhone()))>
								Evening: #trim(local.shippingAddress.getEvePhone())#
							</cfif>
						</td>
					</tr>
				</table>
				<br />
				<hr />
				<br />

				<cfset userOrders = application.model.myAccount.getOrderHistory(userId = session.userId) />

				<h1>Current Orders</h1>
				<br />
				<table width="100%" cellpadding="3" cellspacing="0">
					<tr>
						<td width="100" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold; text-align: center">Order Date</td>
						<td width="100" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold">Order ID</td>
						<td width="100" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold">Total</td>
						<td style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold">Status</td>
						<td width="150" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold; text-align: center">Details</td>
					</tr>
					<tbody>
						<cfif arrayLen(variables.userOrders)>
							<cfloop from="1" to="#arrayLen(variables.userOrders)#" index="iOrder">
								<cfif variables.userOrders[variables.iOrder].getStatusName() is 'shipped'>
									<cfset qry_getShipmentTrackingNumber = application.model.myAccount.getShipmentTrackingNumber(orderId = variables.userOrders[variables.iOrder].getOrderId()) />
								</cfif>
								<tr>
									<td style="font-size: 10pt; text-align: center">#dateFormat(variables.userOrders[variables.iOrder].getOrderDate(), 'mm/dd/yyyy')#</td>
									<td style="font-size: 10pt">#variables.userOrders[variables.iOrder].getOrderId()#</td>
									<td style="font-size: 10pt">#dollarFormat(variables.userOrders[variables.iOrder].getOrderTotal() - variables.userOrders[variables.iOrder].getDiscountTotal())#&nbsp;</td>
									<td style="font-size: 10pt">
										<cfif variables.userOrders[variables.iOrder].getStatusName() is 'shipped'>
											<cfif qry_getShipmentTrackingNumber.recordCount and len(trim(qry_getShipmentTrackingNumber.trackingNumber))>
												<cfset trackingNumber = trim(qry_getShipmentTrackingNumber.trackingNumber) />
												<a href="http://wwwapps.ups.com/WebTracking/processInputRequest?sort_by=status&tracknums_displayed=1&TypeOfInquiryNumber=T&loc=en_US&InquiryNumber1=#trim(variables.trackingNumber)#&track.x=0&track.y=0" target="_blank">#variables.userOrders[variables.iOrder].getStatusName()#</a>
											<cfelse>
												#variables.userOrders[variables.iOrder].getStatusName()#
											</cfif>
										<cfelse>
											#variables.userOrders[variables.iOrder].getStatusName()#
										</cfif>
									</td>
									<td style="font-size: 10pt; text-align: center"><a href="/index.cfm/go/myAccount/do/viewOrderHistoryDetails/orderId/#variables.userOrders[variables.iOrder].getOrderId()#">View Order Details</a></td>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td colspan="5" align="center" style="font-size: 10pt; text-align: center">No orders found.</td>
							</tr>
						</cfif>
					</tbody>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="getOrderHistory" access="public" returntype="string" output="false">
		<cfset var local = structNew() />
		<cfset userOrders = application.model.myAccount.getOrderHistory(userId = session.userId) />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<h1>Order History</h1>
				<br />
				<table width="100%" cellpadding="3" cellspacing="0">
					<tr>
						<td width="100" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold; text-align: center">Order Date</td>
						<td width="100" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold">Order ID</td>
						<td width="100" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold">Total</td>
						<td style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold">Status</td>
						<td width="150" style="border-bottom: 1px solid black; font-size: 10pt; font-weight: bold; text-align: center">Details</td>
					</tr>
					<tbody>
						<cfif arrayLen(variables.userOrders)>
							<cfloop from="1" to="#arrayLen(variables.userOrders)#" index="iOrder">
								<tr>
									<td style="font-size: 10pt; text-align: center">#dateFormat(variables.userOrders[variables.iOrder].getOrderDate(), 'mm/dd/yyyy')#</td>
									<td style="font-size: 10pt">#variables.userOrders[variables.iOrder].getOrderId()#</td>
									<td style="font-size: 10pt">#dollarFormat(variables.userOrders[variables.iOrder].getOrderTotal() - variables.userOrders[variables.iOrder].getDiscountTotal())#&nbsp;</td>
									<td style="font-size: 10pt">#variables.userOrders[variables.iOrder].getStatusName()#</td>
									<td style="font-size: 10pt; text-align: center"><a href="/index.cfm/go/myAccount/do/viewOrderHistoryDetails/orderId/#variables.userOrders[variables.iOrder].getOrderId()#">View Order Details</a></td>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td colspan="5" align="center" style="font-size: 10pt; text-align: center">No orders found.</td>
							</tr>
						</cfif>
					</tbody>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getAccInfo" access="public" returntype="string" output="false">
		<cfset var local = structNew()>

		<cfset local.billingAddress = application.model.user.getBillingAddress() />
		<cfset local.shippingAddress = application.model.user.getShippingAddress() />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<h1>Your Account Information</h1>
				<br />
				<table width="100%" cellpadding="3" cellspacing="0" border="0">
					<tr valign="top">
						<td width="33%" style="font-size: 12pt; font-weight: bold"><strong>Your Account</strong></td>
						<td style="font-size: 12pt; font-weight: bold"><strong>Billing Information</strong></td>
						<td width="33%" style="font-size: 12pt; font-weight: bold"><strong>Shipping Information</strong></td>
					</tr>
					<tr valign="top">
						<td style="font-size: 10pt"><a href="/index.cfm/go/myAccount/do/edit/">Edit</a></td>
						<td style="font-size: 10pt"><a href="/index.cfm/go/myAccount/do/manageBilling/"><cfif len(trim(local.billingAddress.getFirstName()))>Edit<cfelse>Add</cfif></a></td>
						<td style="font-size: 10pt"><a href="/index.cfm/go/myAccount/do/manageShipping/"><cfif len(trim(local.shippingAddress.getFirstName()))>Edit<cfelse>Add</cfif></a></td>
					</tr>
					<tr valign="top">
						<td style="font-size: 10pt">Email: #trim(application.model.user.getEmail())#</td>
						<td style="font-size: 10pt">
							<cfif len(trim(local.billingAddress.getFirstName()))>
								#trim(local.billingAddress.getFirstName())#
							</cfif>
							<cfif len(trim(local.billingAddress.getMiddleInitial()))>
								#trim(local.billingAddress.getMiddleInitial())#
							</cfif>
							<cfif len(trim(local.billingAddress.getLastName()))>
								#trim(local.billingAddress.getLastName())#
							</cfif>
							<br />
							<cfif len(trim(local.billingAddress.getAddressLine1()))>
								#trim(local.billingAddress.getAddressLine1())#
								<br />
							</cfif>
							<cfif len(trim(local.billingAddress.getCity()))>
								#trim(local.billingAddress.getCity())#,
							</cfif>
							<cfif len(trim(local.billingAddress.getState()))>
								#trim(local.billingAddress.getState())#
							</cfif>
							<cfif len(trim(local.billingAddress.getZipCode()))>
								#trim(local.billingAddress.getZipCode())#
							</cfif>
							<cfif len(trim(local.billingAddress.getDayPhone()))>
								<br /><br />
								Daytime: #trim(local.billingAddress.getDayPhone())#
								<br />
							</cfif>
							<cfif len(trim(local.billingAddress.getEvePhone()))>
								Evening: #trim(local.billingAddress.getEvePhone())#
							</cfif>
						</td>
						<td style="font-size: 10pt">
							<cfif len(trim(local.shippingAddress.getFirstName()))>
								#trim(local.shippingAddress.getFirstName())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getMiddleInitial()))>
								#trim(local.shippingAddress.getMiddleInitial())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getLastName()))>
								#trim(local.shippingAddress.getLastName())#
							</cfif>
							<br />
							<cfif len(trim(local.shippingAddress.getAddressLine1()))>
								#trim(local.shippingAddress.getAddressLine1())#
								<br />
							</cfif>
							<cfif len(trim(local.shippingAddress.getCity()))>
								#trim(local.shippingAddress.getCity())#,
							</cfif>
							<cfif len(trim(local.shippingAddress.getState()))>
								#trim(local.shippingAddress.getState())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getZipCode()))>
								#trim(local.shippingAddress.getZipCode())#
							</cfif>
							<cfif len(trim(local.shippingAddress.getDayPhone()))>
								<br /><br />
								Daytime: #trim(local.shippingAddress.getDayPhone())#
								<br />
							</cfif>
							<cfif len(trim(local.shippingAddress.getEvePhone()))>
								Evening: #trim(local.shippingAddress.getEvePhone())#
							</cfif>
						</td>
					</tr>
				</table>
    		</cfoutput>
        </cfsavecontent>
        <cfreturn local.html/>
    </cffunction>

    <cffunction name="getBillingInfo" access="public" returntype="string" output="false">
    	<cfargument name="user">
		<cfargument name="message" default="" required="no">
    	<cfset var local = structNew()>
        <cfset local.billing = application.model.user.getBillingAddress() />
        <cfset local.state = getGeoService().getAllStates() />

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


        <cfsavecontent variable="local.html">
			<cfoutput>
             <h1>Billing Information</h1><br />
              <cfif request.validator.HasMessages()>
                    <p class="error">#request.validatorView.ValidationSummary(request.validator.getMessages(), 6)#</p>
              </cfif>
             <cfif Len(trim(arguments.message))>
             	<p class="error">#arguments.message#</p><br />
             </cfif>
               <form id="frmAccountBilling" name="frmAccountBilling" action="/index.cfm/go/myAccount/do/billingEdit/" method="post">
                <table width="100%" class="manageAddress" border="0">
                  <tr>
                    <td class="textAlignTop">
                        <label for="txtFirstname">First Name:</label>
                        <input type="text" id="txtFirstname" name="bill_firstname" value="#local.billing.getFirstName()#" maxlength="30" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"firstName")#<br>
						</td><!---Begin Venkit: New class added --->
                    <td width="10%" class="textAlignTop">
                        <label for="txtMiddle">MI:</label>
                        <input type="text" id="txtMiddle" name="bill_middleinitial" value="#local.billing.getMiddleInitial()#" size="2" maxLength="1" /></td><!---End Venkit: New class added --->
                    <td class="textAlignTop">
                        <label for="txtLastname">Last Name:</label>
                        <input type="text" id="txtLastname" name="bill_lastname" value="#local.billing.getLastName()#" maxlength="30" /> *<br>
						#request.validatorView.ValidationElement(request.validator.getMessages(),"lastName")#<br>
					</td>
                  </tr>
                  <tr>
                    <td>
                        <label for="txtCompany">Company:</label>
                        <input type="text" id="txtCompany" name="bill_company" value="#local.billing.getCompany()#" maxlength="50" /></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td>
                        <label for="txtAddress1">Address 1:</label>
                        <input type="text" id="txtAddress1" name="bill_address1" value="#local.billing.getAddressLine1()#" maxlength="60" /> *<br>
						#request.validatorView.ValidationElement(request.validator.getMessages(),"address1")#<br>
					</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td>
                        <label for="txtAddress2">Address 2:</label>
                        <input type="text" id="txtAddress2" name="bill_address2" value="#local.billing.getAddressLine2()#" maxlength="60" /></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="textAlignTop">
                        <label for="txtCity">City:</label>
                        <input type="text" id="txtCity" name="bill_city" value="#local.billing.getCity()#" maxlength="50" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"city")#<br>
					</td><!---Begin Venkit: New class added --->
                    <td class="textAlignTop">
                        <label for="txtState">State:</label><br>
                        <select name="bill_state">
                        	<option></option>
                        	<cfloop query="local.state">
                        		<option <cfif local.billing.getState() EQ local.state.StateCode>selected="selected"</cfif>>#local.state.StateCode#</option>
                            </cfloop>
                        </select> *<br>
						#request.validatorView.ValidationElement(request.validator.getMessages(),"state")#<br>
                    </td><!---End Venkit: New class added --->
                    <td class="textAlignTop">
                        <label for="txtZip">Zip Code:</label>
                        <input type="text" id="txtZip" name="bill_zip" value="#local.billing.getZipCode()#" maxlength="10" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"zip")#<br>
					</td>
                  </tr>
                  <tr>
                    <td class="textAlignTop">
                        <label for="txtDayPhone">Daytime Phone:</label>
                            <input type="text" id="txtDayPhone" name="bill_dayPhone" value="#local.billing.getDayPhone()#" maxlength="30" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" /> *<br>
                            #request.validatorView.ValidationElement(request.validator.getMessages(),"daytimePhone")#<br>
					</td>
                    <td>&nbsp;</td>
                    <td class="textAlignTop">
                        <label for="txtEvePhone">Evening Phone:</label>
                        <input type="text" id="txtEvePhone" name="bill_evePhone" value="#local.billing.getEvePhone()#" maxlength="30" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"eveningPhone")#<br>
					</td>
                  </tr>
                  <tr>
                    <td colspan="3">*Required</td>
                  </tr>
                  <tr>
                    <td colspan="2" align="left">
                        <div class="formControl" >
                            <span class="actionButton">
                                <a href="##" onclick="$('frmAccountBilling').submit()">Save</a>
                            </span>
                            <span class="actionButton">
                                <a href="##" onclick="location.href='/index.cfm/go/myAccount/do/view/'">Cancel</a>
                            </span>
                        </div>
                    </td>
                    <td>&nbsp;</td>
                  </tr>
                </table>
            </form>
    		</cfoutput>
        </cfsavecontent>
        <cfreturn local.html/>
    </cffunction>

    <cffunction name="getShippingInfo" access="public" returntype="string" output="false">
    	<cfargument name="user">
		<cfargument name="message" default="" required="no">
    	<cfset var local = structNew()>
        <cfset local.shipping = application.model.user.getShippingAddress() />
        <cfif REQUEST.p.sameAsBilling AND REQUEST.p.ship_isSame>
        	<cfset local.shipping = application.model.user.getBillingAddress() />
        </cfif>
        <cfset local.state = getGeoService().getAllStates() />

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

        <cfsavecontent variable="local.html">
			<cfoutput>
            <script type="text/javascript">
				function isSameAsBilling(obj){
					if(document.getElementById('sameAsBilling').checked==true){
						document.getElementById('ship_isSame').value = 1;
						obj.submit();
					}
				}
			</script>
             <h1>Shipping Information</h1><br />
             <cfif request.validator.HasMessages()>
                    <p class="error">#request.validatorView.ValidationSummary(request.validator.getMessages(), 6)#</p>
              </cfif>
             <cfif Len(trim(arguments.message))>
             	<p class="error">#arguments.message#</p><br />
             </cfif>
  			<form id="frmAccountShipping" name="frmAccountShipping" action="/index.cfm/go/myAccount/do/shippingEdit/" method="post">
               <input type="checkbox" onclick="isSameAsBilling(this.form);" name="sameAsBilling" id="sameAsBilling" value="1" style="width:20px;margin-left:0px;"<cfif REQUEST.p.sameAsBilling>checked="checked"</cfif>/><label class="check" for="sameAsBilling" style="width:180px;">Shipping is the same as Billing</label><br/>
               <input type="hidden" id="ship_isSame" name="ship_isSame" value="0" >
                <table width="100%" class="manageAddress" border="0">
                  <tr>
                    <td class="textAlignTop">
                        <label for="txtShipFirstName">First Name:</label>
                        <input type="text" id="txtShipFirstName" name="ship_firstname" value="#local.shipping.getFirstName()#" maxlength="30" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"firstName")#<br>
                        </td><!---Begin Venkit: New class added --->
                    <td width="10%" class="textAlignTop">
                        <label for="txtShipMiddle">MI:</label>
                        <input type="text" id="txtShipMiddle" name="ship_middleinitial" value="#local.shipping.getMiddleInitial()#" size="2" maxLength="1" /></td><!---End Venkit: New class added --->
                    <td class="textAlignTop">
                        <label for="txtShipLastName">Last Name:</label>
                        <input type="text" id="txtShipLastName" name="ship_lastname" value="#local.shipping.getLastName()#" maxlength="30" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"lastName")#<br>
                        </td>
                  </tr>
                  <tr>
                    <td>
                        <label for="txtShipCompany">Company:</label>
                        <input type="text" id="txtShipCompany" name="ship_company" value="#local.shipping.getCompany()#" maxlength="50" /></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td>
                        <label for="txtShipAddress">Address 1:</label>
                        <input type="text" id="txtShipAddress" name="ship_address1" value="#local.shipping.getAddressLine1()#" maxlength="70" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"address1")#<br>
                        </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td>
                        <label for="txtShipAddress2">Address 2:</label>
                        <input type="text" id="txtShipAddress2" name="ship_address2" value="#local.shipping.getAddressLine2()#" maxlength="70" /></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="textAlignTop">
                        <label for="txtShipCity">City:</label>
                        <input type="text" id="txtShipCity" name="ship_city" value="#local.shipping.getCity()#" maxlength="50" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"city")#<br>
                        </td><!---Begin Venkit: New class added --->
                    <td class="textAlignTop">
                        <label for="txtShipState">State:</label><br>
                        <select id="txtShipState" name="ship_state">
                        	<option></option>
                        	<cfloop query="local.state">
                        		<option <cfif local.shipping.getState() EQ local.state.StateCode>selected="selected"</cfif>>#local.state.StateCode#</option>
                            </cfloop>
                        </select> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"state")#<br>
                        </td><!---End Venkit: New class added --->
                    <td class="textAlignTop">
                        <label for="txtShipZip">Zip Code:</label>
                        <input type="text" id="txtShipZip" name="ship_zip" value="#local.shipping.getZipCode()#" maxlength="10" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"zip")#<br>
                        </td>
                  </tr>
                  <tr>
                    <td class="textAlignTop">
                        <label for="txShiptDayPhone">Daytime Phone:</label>
                            <input type="text" id="txShiptDayPhone" name="ship_dayPhone" value="#local.shipping.getDayPhone()#" maxlength="30" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"daytimePhone")#<br>
                        </td>
                    <td>&nbsp;</td>
                    <td class="textAlignTop">
                        <label for="txtShipEvePhone">Evening Phone:</label>
                        <input type="text" id="txtShipEvePhone" name="ship_evePhone" value="#local.shipping.getEvePhone()#" maxlength="30" onkeydown="javascript:backspacerDOWN(this,event);" onkeyup="javascript:backspacerUP(this,event);" /> *<br>
                        #request.validatorView.ValidationElement(request.validator.getMessages(),"eveningPhone")#<br>
                        </td>
                  </tr>
                  <tr>
                    <td colspan="3">*Required</td>
                  </tr>
                  <tr>
                    <td colspan="2" align="left">
                        <div class="formControl" >
                            <span class="actionButton">
                                <a href="##" onclick="$('frmAccountShipping').submit()">Save</a>
                            </span>
                            <span class="actionButton">
                                <a href="##" onclick="location.href='/index.cfm/go/myAccount/do/view/'">Cancel</a>
                            </span>
                        </div>
                    </td>
                    <td>&nbsp;</td>
                  </tr>
                </table>
            </form>
    		</cfoutput>
        </cfsavecontent>
        <cfreturn local.html/>
    </cffunction>
    
    <cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>
    
    <cffunction name="getGeoService" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["GeoService"]/>    
    </cffunction>    
    <cffunction name="setGeoService" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["GeoService"] = arguments.theVar />    
    </cffunction>

</cfcomponent>
