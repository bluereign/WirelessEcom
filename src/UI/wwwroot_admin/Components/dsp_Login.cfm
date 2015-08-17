<cfparam name="username" default="" />
<cfparam name="password" default="" />

<cfset message = "">
<cfset errormessage = "">

<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfset editPhoneComponent = "" />
	<cfset listPhonesComponent = "" />

	<cfif form.action eq "login">
		<cfif form.username EQ "" OR form.password EQ "">
			<cfset errormessage = "Username/Password can't be blank" />
		<cfelse>
			<cfset loginResult = application.model.User.getUserByLogin(form.username, form.password) />

			<cfif loginResult.RecordCount>
				<cfset user = CreateObject( "component", "cfc.model.User" ).init() />
				<cfset user.getUserById( loginResult.User_Id ) />
				<!--- log user in --->
				<!--- set the AdminUser session variable --->
				<cfset application.model.AdminUser.InitUser() />
				<cfset SESSION.AdminUser.UserName = form.username />
				<cfset SESSION.AdminUser.FirstName = user.getFirstName() />
				<cfset SESSION.AdminUser.LastName = user.getLastName() />
				<cfset SESSION.AdminUser.AdminUserId = loginResult.User_Id />
				<cfset SESSION.Adminuser.Roles = [] />

				<cfset roles = application.model.AdminUserRole.getAdminUserRoles(loginResult.User_ID) />
				<cfloop query="roles">
					<cfset userRole = { role = roles.Role, roleGuid = roles.RoleGuid } />
					<cfset ArrayAppend(SESSION.AdminUser.Roles, userRole) />
				</cfloop>
				<cfset homePage = "index.cfm?c=db97ce8a-9c7b-483c-8a55-1a49b4e2a079" />
				<!--- Set OMT index as home page for CSR Users --->
				<cfloop array="#SESSION.AdminUser.Roles#" index="role">
					<cfif role.RoleGuid EQ "96C5D0B1-A8B7-479E-876F-637CB8BD53E7">
						<cfset homePage = "index.cfm?c=7b186638-5bde-40d9-986e-6cadebf144a6" />
						<cfbreak />
					</cfif>
				</cfloop>
				<!--- sending the user to the Phone list of the Content Manger by default --->
				<cflocation url="#homePage#" addtoken="false" />
			<cfelse>
				<!--- keep out and display error message --->
				<cfset errormessage = "Username/password did not match any in the system" />
			</cfif>
		</cfif>
	</cfif>
</cfif>

<!--- show messages --->
<cfif len(message) gt 0>
	<div class="message">
    	<span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
    </div>
</cfif>

<cfif len(errormessage) gt 0>
	<div class="errormessage">
    	<span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
    </div>
</cfif>

<div>
 	<cfset loginFormDisplay = application.view.Login.getLoginForm() />
	<cfoutput>#loginFormDisplay#</cfoutput>
</div>