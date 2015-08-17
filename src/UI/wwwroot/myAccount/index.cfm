<cfparam name="request.p.do" default="view" />
<cfparam name="request.currentTopNav" default="myAccount.view">

<cfset SecurityService = application.wirebox.getInstance("SecurityService") />


<!--- MAC: make the SSL switch --->
<cfparam name="request.config.disableSSL" default="false">
<cfif cgi.server_port NEQ 443 and not request.config.disableSSL>
	<cflocation url="https://#cgi.SERVER_NAME##cgi.script_name##cgi.path_info#" addtoken="no" />
</cfif>


<!--- set up validators --->
<cfset request.validator = createobject('component','cfc.model.FormValidation').init() >
<cfset request.validatorView = createobject('component','cfc.view.FormValidation').init() >

<cfswitch expression="#request.p.do#">
	<cfcase value="login">
		<cfset request.currentTopNav = "myAccount.login">
		<cfparam name="REQUEST.p.username" default=""/>
		<cfparam name="REQUEST.p.password" default=""/>

		<cfset loginHTML = application.view.MyAccount.login()>

		<cfinclude template="/views/myaccount/dsp_login.cfm">
	</cfcase>


	<cfcase value="bundle">
    	<!--- Make sure that this is an admin user --->
		<cfset request.p.user = createobject('component','cfc.model.User').init() >
		<cfset request.p.user.getUserById(session.userid)>
        <cfif not request.p.user.isAdmin()>
       		<!--- not an admin user, redirect them --->
            <cflocation url="/index.cfm/go/myAccount/do/view/" addtoken="no">
        </cfif>

        <cfset bundle = createObject("component","cfc.model.bundle")>

        <!--- get a list of bundles --->
        <cfset request.p.bundles = bundle.GetBundles()>


        <!--- generate bundle view --->
        <cfinclude template="/views/myaccount/dsp_bundles.cfm">

    </cfcase>

    <cfcase value="saveBundle">

        <cfset request.p.user = createobject('component','cfc.model.User').init() >
		<cfset request.p.user.getUserById(session.userid)>

        <!--- store the bundle --->
        <cfset bundleName = request.p.bundleName>
        <cfset serializer = createObject("component","cfc.model.serialiser").init()>
		<cfset output = serializer.serialize(session.cart)>
        <cfset bundle = createObject("component","cfc.model.bundle")>
        <cfset dd = bundle.SaveBundleAs(bundleName, output, request.p.user.getFirstName(), true, session.cart)>

        <!--- get a list of bundles --->
        <cfset request.p.bundles = bundle.GetBundles()>

        <!--- generate bundle view --->
        <cfinclude template="/views/myaccount/dsp_bundles.cfm">
    </cfcase>

	<cfcase value="removeBundle">
		<cfset request.p.user = createObject('component', 'cfc.model.user').init() />
		<cfset request.p.user.getUserById(session.userID) />

		<cfset bundle = createObject('component', 'cfc.model.bundle').init() />
		<cfset bundle.removeBundle(id=request.p.bundleId) />

		<script>window.location='/index.cfm/go/myAccount/do/bundle/removeSuccess/true/';</script>
	</cfcase>

	<cfcase value="processLogin">
		<cfparam name="REQUEST.p.username" default=""/>
		<cfparam name="REQUEST.p.password" default=""/>

        <!--- Begin: Neologix, 06 March 2010 --->

        <!--- RMP: Form validation --->
        <cfset request.validator.AddRequiredFieldValidator("email",REQUEST.p.username, "Email address is required.")>
        <cfset request.validator.AddEmailValidator("email",REQUEST.p.username, "Email is not a valid email address format.")>
        <cfset request.validator.AddRequiredFieldValidator("password",REQUEST.p.password, "Password is required.")>
        <!--- custom validator password length--->
    	<cfif Len(REQUEST.p.password) LT 6 OR Len(REQUEST.p.password) GT 8>
            <cfset request.validator.AddValidator("password",REQUEST.p.password,"custom","Password length must be between 6 and 8.")>
   		</cfif>
        <cfif request.validator.HasMessages()>
        	<cfset loginHTML = application.view.MyAccount.login()>
            <cfinclude template="/views/myaccount/dsp_login.cfm">
        <cfelse>
        <!--- End: Neologix, 06 March 2010 --->
			<cfset variables.SecurityService.login( username=request.p.username, password=request.p.password )>
        	<cfif request.validator.HasMessages()>
	        	<cfset loginHTML = application.view.MyAccount.login()>
	            <cfinclude template="/views/myaccount/dsp_login.cfm">
			<cfelse>
	            <cfif session.CurrentUser.isLoggedIn()>
	                <cfif isDefined("session.loginCallback") AND len(session.loginCallback)>
	                    <cfset tmp = session.loginCallback />
	                    <cfset session.loginCallback = "" />
	                    <cflocation url="#tmp#" addToken="false"/>
	                <cfelse>
	                    <cflocation url="/index.cfm/go/myAccount/do/view/" addToken="false"/>
	                </cfif>
	            <cfelse>
	                <cfset loginHTML = application.view.MyAccount.login(true)>
	                <cfinclude template="/views/myaccount/dsp_login.cfm">
	            </cfif>
			</cfif>
        </cfif>
	</cfcase>

	<cfcase value="signup">
		<cfset request.currentTopNav = "myAccount.signup">
		<cfparam name="REQUEST.p.username" default=""/>
		<cfparam name="REQUEST.p.password" default=""/>
		<cfparam name="REQUEST.p.password2" default=""/>

		<!--- If a 3rd party is authorizing then all we need for a signup is an email address --->
		<cfif request.config.thirdPartyAuth and session.thirdPartyIsAuth and session.authenticationid>
			<cfset signupHTML = application.view.MyAccount.signup_3rdPartyAuth()>
		<cfelse>	
			<!--- Otherwise, we need an email and a password (twice) --->
			<cfset signupHTML = application.view.MyAccount.signup()>
		</cfif>

		<cfinclude template="/views/myaccount/dsp_signup.cfm">
	</cfcase>

	<!---                                                                            --->
	<!--- Handle signups where we (WA) is responsible for authentication             --->
	<!---                                                                            --->
	<cfcase value="processSignup">
		<cfparam name="REQUEST.p.username" default=""/>
		<cfparam name="REQUEST.p.password" default=""/>
		<cfparam name="REQUEST.p.password2" default=""/>
		<cfset error = ""/>
        <!--- Begin: Neologix, 06 March 2010 --->

        <!--- RMP: Form validation --->
        <cfset request.validator.AddRequiredFieldValidator("email",REQUEST.p.username, "Email address is required.")>
        <cfset request.validator.AddEmailValidator("email",REQUEST.p.username, "Email is not a valid email address format.")>
        <cfset request.validator.AddRequiredFieldValidator("password",REQUEST.p.password, "Password is required.")>
        <!--- custom validator password length--->
    	<cfif Len(REQUEST.p.password) LT 6 OR Len(REQUEST.p.password) GT 8>
            <cfset request.validator.AddValidator("password",REQUEST.p.password,"custom","Password length must be between 6 and 8.")>
   		</cfif>

        <cfset request.validator.AddRequiredFieldValidator("confpassword",REQUEST.p.password2, "Confirm Password is required.")>
        <!--- custom validator password matching--->
    	<cfif REQUEST.p.password NEQ REQUEST.p.password2>
            <cfset request.validator.AddValidator("nomatch",REQUEST.p.password,"custom","Password and Confirm Password does not match.")>
        </cfif>
        <!--- custom validator confirm password length--->
    	<cfif Len(REQUEST.p.password2) LT 6 OR Len(REQUEST.p.password2) GT 8>
            <cfset request.validator.AddValidator("confpassword",REQUEST.p.password2,"custom","Confirm Password length must be between 6 and 8.")>
   		</cfif>

        <cfif request.validator.HasMessages()>
        	<cfset signupHTML = application.view.MyAccount.signup()>
            <cfinclude template="/views/myaccount/dsp_signup.cfm">
        <cfelse>
		<!--- End: Neologix, 06 March 2010 --->
            <!--- See if the user has an account --->
            <cfif application.model.User.isEmailInUse(REQUEST.p.username)>
                <cfset error = "This email address is already in use. If you've forgotten your password, <a href=""/index.cfm/go/myAccount/do/forgotPassword/"">click here</a>." />
                <cfset signupHTML = application.view.MyAccount.signup(error)>
                <cfinclude template="/views/myaccount/dsp_signup.cfm">
            <cfelse>
				<!--- ok, create the user & send them on their way --->
                <cfset newUser = application.model.User.createUser(REQUEST.p.username,REQUEST.p.password) />
				<!--- If there is an authenticationId in their session addit to the user record --->
				<cfif structKeyExists(session,"authenticationId") && session.authenticationid is not "">
					<cfset application.model.user.updateAuthenticationId(newUser.user_id, session.authenticationId) />	
				</cfif>
				
                <!-- set this user to the seesion --->
                <cfset session.currentUser = application.model.User/>

                <cfset session.userID = newUser.user_id>
                 
                <cfif isDefined("session.loginCallback") AND len(session.loginCallback)>
                    <cfset tmp = session.loginCallback />
                    <cfset session.loginCallback = "" />
                    <cflocation url="#tmp#" addToken="false"/>
                <cfelse>
                    <cflocation url="/index.cfm/go/myAccount/do/view/" addToken="false"/>
                </cfif>
            </cfif>
        </cfif>
	</cfcase>
	
	<!---                                                                            --->
	<!--- Handle signups where a 3rd party (AAFES) is responsible for authentication --->
	<!---                                                                            --->
	<cfcase value="processSignup_3rdPartyAuth">
		<cfparam name="REQUEST.p.username" default=""/>
		<cfset error = ""/>
        <!--- Begin: Neologix, 06 March 2010 --->

        <!--- RMP: Form validation --->
        <cfset request.validator.AddRequiredFieldValidator("email",REQUEST.p.username, "Email address is required.")>
        <cfset request.validator.AddEmailValidator("email",REQUEST.p.username, "Email is not a valid email address format.")>
 
        <cfif request.validator.HasMessages()>
        	<cfset signupHTML = application.view.MyAccount.signup()>
            <cfinclude template="/views/myaccount/dsp_signup.cfm">
        <cfelse>
		<!--- End: Neologix, 06 March 2010 --->
            <!--- See if the user has an account --->
            <cfif application.model.User.isEmailInUse(REQUEST.p.username)>
                <cfset error = "This email address is already in use. If you've forgotten your password, <a href=""/index.cfm/go/myAccount/do/forgotPassword/"">click here</a>." />
                <cfset signupHTML = application.view.MyAccount.signup_3rdPartyAuth(error)>
                <cfinclude template="/views/myaccount/dsp_signup.cfm">
            <cfelse>
				<!--- ok, create the user & send them on their way --->
                <cfset newUser = application.model.User.createUser_3rdPartyAuth(REQUEST.p.username,session.authenticationId) />
				
                <!-- set this user to the session --->
                <cfset session.currentUser = application.model.User/>
                <cfset session.userID = newUser.user_id>
                 
                <cfif isDefined("session.loginCallback") AND len(session.loginCallback)>
                    <cfset tmp = session.loginCallback />
                    <cfset session.loginCallback = "" />
                    <cflocation url="#tmp#" addToken="false"/>
                <cfelse>
                    <cflocation url="/index.cfm/go/myAccount/do/view/" addToken="false"/>
                </cfif>
            </cfif>
        </cfif>
	</cfcase>

	<cfcase value="forgotPassword">
		<cfset request.currentTopNav = "myAccount.forgotPassword">
		<cfparam name="REQUEST.p.username" default=""/>

		<cfset loginHTML = application.view.MyAccount.forgotPassword()>

		<cfinclude template="/views/myaccount/dsp_forgotPassword.cfm">
	</cfcase>

	<cfcase value="processForgotPassword">
		<cfparam name="REQUEST.p.username" default=""/>
        <cfparam name="REQUEST.p.password" default=""/>
        <!--- Begin: Neologix, 09 March 2010 --->
        <!--- Venkit: Email validation starts --->
        <cfset request.validator.AddRequiredFieldValidator("email",REQUEST.p.username, "Email address is required.")>
        <cfset request.validator.AddEmailValidator("email",REQUEST.p.username, "Email is not a valid email address format.")>
		<cfif request.validator.HasMessages()>
        	<cfset loginHTML = application.view.MyAccount.forgotPassword()>
            <cfinclude template="/views/myaccount/dsp_forgotPassword.cfm">
        <cfelse>
        <!--- Venkit: Email validation ends--->
        <!--- End: Neologix, 09 March 2010 --->
			<cfset newString = application.model.User.resetPassword(REQUEST.p.username)>

			<cfif len(newString)>
				<!--- request.p.do tells the email controller to send a mail using the forgotPassword template --->
				<cfset request.p.go = "emailTemplate" />
				<cfset request.p.do = "forgotPassword" />
				
				<!--- 
					Setting values to be used in ForgotPassword.cfm template - which is called inside 
					'emailTemplate/index.cfm' 
				--->
				<cfset username = request.p.username />
				<cfset ssn = newString />
				<cfinclude template="/emailTemplate/index.cfm">

				<cfset loginHTML = application.view.MyAccount.login(false,"<font color=green><b>Please check your email for instructions on resetting your forgotten password.</b></font>")>
                <cfinclude template="/views/myaccount/dsp_login.cfm">
                <!--- End: Neologix, 11 March 2010 --->
            <cfelse>
                <cfset loginHTML = application.view.MyAccount.forgotPassword("That username does not exist. Please try again.")>

                <cfinclude template="/views/myaccount/dsp_forgotPassword.cfm">
            </cfif>
            <!--- End: Neologix, 09 March 2010 --->
		</cfif>
	</cfcase>

	<cfcase value="resetPassword">
		<cfset request.currentTopNav = "myAccount.forgotPassword">
		<cfparam name="REQUEST.p.username"/>
		<cfparam name="REQUEST.p.code"/>
		<cfparam name="REQUEST.p.password" default=""/>
		<cfparam name="REQUEST.p.password2" default=""/>
        <!--- Venkit: Added function to check username and code is valid--->

        <!--- Begin: Neologix, 09 March 2010 --->
		<!--- Make sure the code is valid --->
		<cfif NOT application.model.User.isResetCodeValid(REQUEST.p.username,REQUEST.p.code)>
			<!--- hacking attempt, just redirect --->
			<cfset loginHTML = application.view.MyAccount.usernameCodeNotExists("Invalid username or code.")>
		<cfelse>
			<cfset loginHTML = application.view.MyAccount.resetPassword()>
		</cfif>
        <!--- End: Neologix, 09 March 2010 --->
		<cfinclude template="/views/myaccount/dsp_resetPassword.cfm">
	</cfcase>
	<!--- commented at Neologix --->

	<!--- <cfcase value="processResetPassword">
		<cfparam name="REQUEST.p.username"/>
		<cfparam name="REQUEST.p.code"/>
		<cfparam name="REQUEST.p.password"/>
		<cfparam name="REQUEST.p.password2"/>

		<!--- Make sure the password has a length --->
		<cfif len(REQUEST.p.password) LT 5>
			<cfset error = "You must enter a password at least 6 characters long." />
			<cfset signupHTML = application.view.MyAccount.resetPassword(error)>
			<cfinclude template="dsp_signup.cfm">
		</cfif>

		<!--- Make sure the passwords match --->
		<cfif REQUEST.p.password NEQ REQUEST.p.password2>
			<cfset error = "Your passwords do not match." />
			<cfset signupHTML = application.view.MyAccount.resetPassword(error)>
			<cfinclude template="dsp_signup.cfm">
		</cfif>

		<!--- Make sure the code is valid --->
		<cfif NOT application.model.User.isResetCodeValid(REQUEST.p.username,REQUEST.p.code)>
			<!--- hacking attempt, just redirect --->
			<cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false">
		</cfif>

		<cfset doPasswordChange = application.model.User.changePassword(REQUEST.p.username,REQUEST.p.code,REQUEST.p.password) />

		<cfset REQUEST.p.password = ""/>

		<cfset loginHTML = application.view.MyAccount.login(false,"Your password has been reset. Please log in.")>
		<cfinclude template="dsp_login.cfm">
	</cfcase> --->
    <!--- End commented at Neologix --->

    <!--- This function is modified to perform the form validation --->

    <!--- Begin: Venkit: Neologix,09 March 2010 --->
	<cfcase value="processResetPassword">
		<cfparam name="REQUEST.p.username"/>
		<cfparam name="REQUEST.p.code"/>
		<cfparam name="REQUEST.p.password" default=""/>
		<cfparam name="REQUEST.p.password2" default=""/>
        <!--- Venkit: Form validation --->
        <cfset request.validator.AddRequiredFieldValidator("password",REQUEST.p.password, "Password is required.")>
        <!--- custom validator password length--->
    	<cfif Len(REQUEST.p.password) LT 6 OR Len(REQUEST.p.password) GT 8>
            <cfset request.validator.AddValidator("password",REQUEST.p.password,"custom","Password length must be between 6 and 8.")>
   		</cfif>

        <cfset request.validator.AddRequiredFieldValidator("confpassword",REQUEST.p.password2, "Confirm Password is required.")>
        <!--- custom validator password matching--->
    	<cfif REQUEST.p.password NEQ REQUEST.p.password2>
            <cfset request.validator.AddValidator("nomatch",REQUEST.p.password,"custom","Password and Confirm Password does not match.")>
        </cfif>
        <!--- custom validator confirm password length--->
    	<cfif Len(REQUEST.p.password2) LT 6 OR Len(REQUEST.p.password2) GT 8>
            <cfset request.validator.AddValidator("confpassword",REQUEST.p.password2,"custom","Confirm Password length must be between 6 and 8.")>
   		</cfif>
        <cfif NOT application.model.User.isResetCodeValid(REQUEST.p.username,REQUEST.p.code)>
			<!--- hacking attempt, just redirect --->
            <cfset loginHTML = application.view.MyAccount.usernameCodeNotExists("Invalid username or code.")>
            <cfinclude template="/views/myaccount/dsp_resetPassword.cfm">

        <cfelseif request.validator.HasMessages()>
        	<cfset loginHTML = application.view.MyAccount.resetPassword()>
            <cfinclude template="/views/myaccount/dsp_resetPassword.cfm">
        <cfelse>
			<cfset doPasswordChange = application.model.User.changePassword(REQUEST.p.username,REQUEST.p.code,REQUEST.p.password) />

            <cfset REQUEST.p.password = ""/>

           <!---  <cfset loginHTML = application.view.MyAccount.login(false,"Your password has been reset. Please log in.")> --->

            <cflocation url="/index.cfm/go/myAccount/do/login/successmsg" addToken="false">
        </cfif>
	</cfcase>
    <!--- End: Venkit: Neologix,09 March 2010 --->

	<cfcase value="logout">
		<!---If third parth is the authorizer we redirect to home page after logoff --->
		<cfif session.thirdPartyIsAuth>
			<cfset SESSION.userID = 0 />
			<cfset SESSION.thirdPartyIsAuth = false />
			<cfset SESSION.authorizationId = ""/>
			<cflocation url="#application.wirebox.getInstance("AAFESAuth").getLogoffURL()#" addToken="false"><!--- skip for now, url no longer valid --->
		<cfelse>
		<!---Not third party auth, so redirect to login after logoff --->
		<cfset SESSION.userID = 0 />		 
		<cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false">
		</cfif>
	</cfcase>

	<cfcase value="view">
		<cfif not session.UserAuth.isLoggedIn() or not structKeyExists(session, 'userId')>
			<cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false" />
		</cfif>

		<cfset request.currentTopNav = 'myAccount.view' />

		<cfset thisUser = application.model.user.getUserByID(session.userId) />

		<cfset leftMenuHTML = application.view.myAccount.getLeftMenu() />
		<cfset accountSummaryHTML = application.view.myAccount.getAccSummary() />

		<cfinclude template="/views/myaccount/dsp_view.cfm" />
	</cfcase>

	<cfcase value="edit">
		<cfif not session.UserAuth.isLoggedIn()>
			<cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false">
		</cfif>

		<cfset request.currentTopNav = 'myAccount.edit' />

		<cfset thisUser = application.model.user.getUserByID(session.userID) />

		<cfparam name="request.p.username" default="#variables.thisUser.username#" type="string" />
		<cfparam name="request.p.password" default="" type="string" />
		<cfparam name="request.p.password2" default="" type="string" />

		<cfset accountInfoHTML = application.view.myAccount.edit(variables.thisUser) />
		<cfset leftMenuHTML = application.view.myAccount.getLeftMenu() />

		<cfinclude template="/views/myaccount/dsp_edit.cfm" />
	</cfcase>

	<cfcase value="processEdit">
		<cfparam name="request.p.username" default="" type="string" />
		<cfparam name="request.p.password" default="" type="string" />
		<cfparam name="request.p.password2" default="" type="string" />

		<cfset aErrors = arrayNew(1) />

		<cfset request.validator.addRequiredFieldValidator('password', trim(request.p.password), 'Password is required.') />

		<cfif len(trim(request.p.password)) lt 6 or len(trim(request.p.password)) gt 8>
			<cfset request.validator.addValidator('password', trim(request.p.password), 'custom', 'Password length must be between 6 and 8.') />
		</cfif>

		<cfset request.validator.addRequiredFieldValidator('confpassword', trim(request.p.password2), 'Confirm Password is required.') />

		<cfif trim(request.p.password) is not trim(request.p.password2)>
			<cfset request.validator.addValidator('nomatch', trim(request.p.password), 'custom', 'The passwords you entered did not match. Please try again.') />
		</cfif>

		<cfif len(trim(request.p.password2)) lt 6 or len(trim(request.p.password2)) gt 8>
			<cfset request.validator.addValidator('confpassword', trim(request.p.password2), 'custom', 'Confirm Password length must be between 6 and 8.') />
		</cfif>

		<cfset request.validator.addRequiredFieldValidator('username', trim(request.p.username), 'Email Address required.') />
		<cfset request.validator.addEmailValidator('username', trim(request.p.username), 'A valid Email Address required.') />

		<cfset thisUser = application.model.user.getUserByID(session.userId) />

		<cfif request.validator.hasMessages()>
			<cfset leftMenuHTML = application.view.myAccount.getLeftMenu() />
			<cfset accountInfoHTML = application.view.myAccount.edit(variables.thisUser) />

			<cfinclude template="/views/myaccount/dsp_edit.cfm" />
		<cfelse>
			<cfset application.model.user.updateUserPwd(session.userId, request.p) />\

			<cfset session.currentUser = application.model.user />
			<cfset message = 'Account updated successfully.' />
			<cfset request.p.password = '' />
			<cfset request.p.password2 = '' />

			<cfset leftMenuHTML = application.view.myAccount.getLeftMenu() />
			<cfset accountInfoHTML = application.view.myAccount.edit(variables.thisUser, variables.aErrors, variables.message) />

			<cfinclude template="/views/myaccount/dsp_edit.cfm" />
		</cfif>
	</cfcase>

	<cfcase value="viewOrderHistory">
		<cfif not session.UserAuth.isLoggedIn()>
			<cflocation url="/index.cfm/go/myAccount/do/login/" addtoken="false" />
		</cfif>

		<cfset request.currentTopNav = 'myAccount.viewOrderHistory' />
		<cfset thisUser = application.model.user.getUserByID(session.userId) />

		<cfset leftMenuHTML = application.view.myAccount.getLeftMenu() />
		<cfset orderHistoryHTML = application.view.myAccount.getOrderHistory() />

		<cfinclude template="/views/myaccount/dsp_orderHistory.cfm" />
	</cfcase>

	<cfcase value="viewOrderHistoryDetails">
		<cfparam name="request.p.orderId" type="numeric" />

		<cfif not session.UserAuth.isLoggedIn()>
			<cflocation url="/index.cfm/go/myAccount/do/login/" addtoken="false" />
		</cfif>

		<cfset request.currentTopNav = 'myAccount.viewOrderHistoryDetails' />

		<cfset orderDetail = createObject('component', 'cfc.model.order').init() />
		<cfset variables.orderDetail.load(request.p.orderId) />

		<cfif variables.orderDetail.getUserId() neq session.userId>
			<cflocation url="/index.cfm/go/myAccount/do/viewOrderHistory/" addtoken="false" />
		</cfif>

		<cfinclude template="/views/myaccount/dsp_orderHistoryDetails.cfm" />
	</cfcase>

	<cfcase value="viewAccountInfo">
		<cfset request.currentTopNav = 'myAccount.viewAccountInfo' />
		<cfset thisUser = application.model.user.getUserByID(session.userId) />

		<cfset leftMenuHTML = application.view.myAccount.getLeftMenu() />
		<cfset accountInfoHTML = application.view.myAccount.getAccInfo() />

		<cfinclude template="/views/myaccount/dsp_accountInfo.cfm" />
	</cfcase>

	<cfcase value="manageBilling">
    	<cfif not session.UserAuth.isLoggedIn()><cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false"></cfif>
    	<cfset request.currentTopNav = "myAccount.manageBilling">
        <cfset thisUser = application.model.User.getUserByID(SESSION.userID)/>
		<cfset countryList = application.model.User.getCountries()/>

        <!---<cfset accountHTML = application.view.MyAccount.edit(thisUser,countryList)>--->

    	<cfset leftMenuHTML = application.view.MyAccount.getLeftMenu() />
        <cfset billingInfoHTML = application.view.MyAccount.getBillingInfo(thisUser) />
		<cfinclude template="/views/myaccount/dsp_billingInfo.cfm">
    </cfcase>

	<!--- RMP: Account Billing information --->
    <cfcase value="manageShipping">
    	<cfif not session.UserAuth.isLoggedIn()><cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false"></cfif>
    	<cfset request.currentTopNav = "myAccount.manageShipping">
        <cfset thisUser = application.model.User.getUserByID(SESSION.userID)/>
		<cfset countryList = application.model.User.getCountries()/>
        <cfparam name="REQUEST.p.sameAsBilling" default="0" />

        <!---<cfset accountHTML = application.view.MyAccount.edit(thisUser,countryList)>--->

    	<cfset leftMenuHTML = application.view.MyAccount.getLeftMenu() />
        <cfset shippingInfoHTML = application.view.MyAccount.getShippingInfo(thisUser) />
		<cfinclude template="/views/myaccount/dsp_shippingInfo.cfm">
    </cfcase>

     <!--- RMP: Account Billing information Edit --->
    <cfcase value="billingEdit">
    	<cfif not session.UserAuth.isLoggedIn()><cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false"></cfif>
    	<cfset request.currentTopNav = "myAccount.billingEdit">
        <cfset thisUser = application.model.User.getUserByID(SESSION.userID)/>
		<cfparam name="REQUEST.p.bill_firstname" default="" />
		<cfparam name="REQUEST.p.bill_middleinitial" default="" />
		<cfparam name="REQUEST.p.bill_lastname" default="" />
		<cfparam name="REQUEST.p.bill_company" default="" />
		<cfparam name="REQUEST.p.bill_address1" default="" />
		<cfparam name="REQUEST.p.bill_address2" default="" />
		<cfparam name="REQUEST.p.bill_city" default="" />
		<cfparam name="REQUEST.p.bill_state" default="" />
		<cfparam name="REQUEST.p.bill_zip" default="" />
		<cfparam name="REQUEST.p.bill_dayphone" default="" />
		<cfparam name="REQUEST.p.bill_evephone" default="" />
        <!--- Begin: set the form variables to user scope--->
        <!---<cfset objBillingAddress = createobject('component','cfc.model.Address').init() />--->
		<cfset application.model.Address.setFirstName(REQUEST.p.bill_firstname) />
        <cfset application.model.Address.setMiddleInitial(REQUEST.p.bill_middleinitial) />
        <cfset application.model.Address.setLastName(REQUEST.p.bill_lastname) />
        <cfset application.model.Address.setAddressLine1(REQUEST.p.bill_address1) />
        <cfset application.model.Address.setAddressLine2(REQUEST.p.bill_address2) />
        <cfset application.model.Address.setCity(REQUEST.p.bill_city) />
        <cfset application.model.Address.setState(REQUEST.p.bill_state) />
        <cfset application.model.Address.setZipCode(REQUEST.p.bill_zip) />
        <cfset application.model.Address.setCompany(REQUEST.p.bill_company) />
        <cfset application.model.Address.setdayphone(REQUEST.p.bill_dayphone) />
        <cfset application.model.Address.setevephone(REQUEST.p.bill_evephone) />
        <cfset application.model.user.setBillingAddress(application.model.Address)>

        <!--- End: set the form variables to user scope--->


        <!---<cfset accountHTML = application.view.MyAccount.edit(thisUser,countryList)>--->
        <!--- TO Do: set the form variable to user scope --->
        <!--- Begin: validation must go here --->
        <cfset request.validator.AddRequiredFieldValidator("firstName",REQUEST.p.bill_firstname, "First Name is required.")>
        <cfset request.validator.AddRequiredFieldValidator("lastName",REQUEST.p.bill_lastname, "Last Name is required.")>
        <cfset request.validator.AddRequiredFieldValidator("address1",REQUEST.p.bill_address1, "Address 1 is required.")>
        <cfset request.validator.AddRequiredFieldValidator("city",REQUEST.p.bill_city, "City is required.")>
        <cfset request.validator.AddRequiredFieldValidator("state",REQUEST.p.bill_state, "State is required.")>
        <cfset request.validator.AddRequiredFieldValidator("zip",REQUEST.p.bill_zip, "Zip Code is required.")>
        <cfset request.validator.AddZipCodeValidator("zip",REQUEST.p.bill_zip, "Enter a valid Zip Code.")>
        <cfset request.validator.AddRequiredFieldValidator("daytimePhone",REQUEST.p.bill_dayphone, "Daytime Phone is required.")>
		<cfset request.validator.AddPhoneValidator("daytimePhone",REQUEST.p.bill_dayphone, "Enter a valid Daytime Phone.")>
        <cfset request.validator.AddRequiredFieldValidator("eveningPhone",REQUEST.p.bill_evephone, "Evening Phone is required.")>
        <cfset request.validator.AddPhoneValidator("eveningPhone",REQUEST.p.bill_evephone, "Enter a valid Evening Phone.")>
        <!--- End: validation--->
        <!---if validation success--->
		<cfset message = "" />
        <cfif request.validator.HasMessages()>
        	<!--- <cfset thisUser = QueryNew("") /> --->

        <cfelse>
			<cfset message = "Billing Details Updated successfully" />
            <!---<cfset thisUser = application.model.User.updateBilling(SESSION.userID,REQUEST.p) />--->
            <cfset thisUser = application.model.User.updateBilling(SESSION.userID,application.model.Address) />

        </cfif>
		<!---<cfset thisUser = application.model.User.getUserByID(SESSION.userID)/>--->
		<!---<cfset countryList = application.model.User.getCountries()/>--->
        <cfset leftMenuHTML = application.view.MyAccount.getLeftMenu() />
        <cfset billingInfoHTML = application.view.MyAccount.getBillingInfo(thisUser,message) />
		<cfinclude template="/views/myaccount/dsp_billingInfo.cfm">
    </cfcase>

    <!--- RMP: Account Shipping information Edit --->
    <cfcase value="shippingEdit">
    	<cfif not session.UserAuth.isLoggedIn()><cflocation url="/index.cfm/go/myAccount/do/login/" addToken="false"></cfif>
    	<cfset request.currentTopNav = "myAccount.shippingEdit">
        <cfset thisUser = application.model.User.getUserByID(SESSION.userID)/>
        <cfparam name="REQUEST.p.sameAsBilling" default="0" />
        <cfparam name="REQUEST.p.ship_isSame" default="0" /><!--- variable used to check wheter the sameAsBilling/save button is clicked. if sameAsBilling is clicked this is set to 1 --->
		<cfparam name="REQUEST.p.ship_firstname" default="" />
		<cfparam name="REQUEST.p.ship_middleinitial" default="" />
		<cfparam name="REQUEST.p.ship_lastname" default="" />
		<cfparam name="REQUEST.p.ship_company" default="" />
		<cfparam name="REQUEST.p.ship_address1" default="" />
		<cfparam name="REQUEST.p.ship_address2" default="" />
		<cfparam name="REQUEST.p.ship_city" default="" />
		<cfparam name="REQUEST.p.ship_state" default="" />
		<cfparam name="REQUEST.p.ship_zip" default="" />
		<cfparam name="REQUEST.p.ship_dayphone" default="" />
		<cfparam name="REQUEST.p.ship_evephone" default="" />
        <!---<cfset accountHTML = application.view.MyAccount.edit(thisUser,countryList)>--->
        <!--- Begin: set the form variables to user scope--->
		<cfset application.model.Address.setFirstName(REQUEST.p.ship_firstname) />
        <cfset application.model.Address.setMiddleInitial(REQUEST.p.ship_middleinitial) />
        <cfset application.model.Address.setLastName(REQUEST.p.ship_lastname) />
        <cfset application.model.Address.setAddressLine1(REQUEST.p.ship_address1) />
        <cfset application.model.Address.setAddressLine2(REQUEST.p.ship_address2) />
        <cfset application.model.Address.setCity(REQUEST.p.ship_city) />
        <cfset application.model.Address.setState(REQUEST.p.ship_state) />
        <cfset application.model.Address.setZipCode(REQUEST.p.ship_zip) />
        <cfset application.model.Address.setCompany(REQUEST.p.ship_company) />
        <cfset application.model.Address.setdayphone(REQUEST.p.ship_dayphone) />
        <cfset application.model.Address.setevephone(REQUEST.p.ship_evephone) />
        <cfset application.model.user.setShippingAddress(application.model.Address)>

        <!--- End: set the form variables to user scope--->

        <!--- Begin: validation must go here --->

        <cfset message = "" />
        <cfset thisUser = QueryNew("") />

        <!--- End: validation--->
        <!---if validation success--->
        <cfif REQUEST.p.ship_isSame EQ 0><!--- update only if save button clicked --->
        	<!--- TO Do: set the form variable to user scope --->
				<!--- Begin: validation must go here --->
            <cfset request.validator.AddRequiredFieldValidator("firstName",REQUEST.p.ship_firstname, "First Name is required.")>
            <cfset request.validator.AddRequiredFieldValidator("lastName",REQUEST.p.ship_lastname, "Last Name is required.")>
            <cfset request.validator.AddRequiredFieldValidator("address1",REQUEST.p.ship_address1, "Address 1 is required.")>
            <cfset request.validator.AddRequiredFieldValidator("city",REQUEST.p.ship_city, "City is required.")>
            <cfset request.validator.AddRequiredFieldValidator("state",REQUEST.p.ship_state, "State is required.")>
            <cfset request.validator.AddRequiredFieldValidator("zip",REQUEST.p.ship_zip, "Zip Code is required.")>
            <cfset request.validator.AddZipCodeValidator("zip",REQUEST.p.ship_zip, "Enter a valid Zip Code.")>
            <cfset request.validator.AddRequiredFieldValidator("daytimePhone",REQUEST.p.ship_dayphone, "Daytime Phone is required.")>
            <cfset request.validator.AddPhoneValidator("daytimePhone",REQUEST.p.ship_dayphone, "Enter a valid Daytime Phone.")>
            <cfset request.validator.AddRequiredFieldValidator("eveningPhone",REQUEST.p.ship_evephone, "Evening Phone is required.")>
            <cfset request.validator.AddPhoneValidator("eveningPhone",REQUEST.p.ship_evephone, "Enter a valid Evening Phone.")>
            <!--- End: validation--->

            <cfif request.validator.HasMessages()>

            <cfelse>
				<!---<cfset thisUser = application.model.User.updateShipping(SESSION.userID,REQUEST.p) />--->
				<cfset thisUser = application.model.User.updateShipping(SESSION.userID,application.model.Address) />
                <cfset message = "Shipping Details Updated successfully" />
            </cfif>
        <cfelse>
        	<cfset thisUser = application.model.User.getUserByID(SESSION.userID)/>
        </cfif>
        <!---<cfset thisUser = application.model.User.getUserByID(SESSION.userID)/>
		<cfset countryList = application.model.User.getCountries()/>--->
    	<cfset leftMenuHTML = application.view.MyAccount.getLeftMenu() />
        <cfset shippingInfoHTML = application.view.MyAccount.getShippingInfo(thisUser,message) />
		<cfinclude template="/views/myaccount/dsp_shippingInfo.cfm">
    </cfcase>

    <!--- End: Neologix, 06 March 2010--->

	<cfdefaultcase>
		<cflocation addtoken="false" url="/index.cfm/go/myAccount/do/view/">
	</cfdefaultcase>

</cfswitch>
