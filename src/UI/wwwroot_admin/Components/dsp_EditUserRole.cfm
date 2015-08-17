<cfset message = "">
<cfset errormessage = "">
<cfset result = "">
	
<!--- handle forms actions --->
<cfif IsDefined("form.action")>
	<cfif form.action eq "saveUserRole">
		<!--- make sure email entered exists in the Users table --->
		<cfset isGoodEmail = false />
		
		<cfset emailResult = application.model.AdminUserRole.getAdminUserIdByEmail(form.email) />
		<cfif emailResult.RecordCount>
			<cfset isGoodEmail = true />
		</cfif>
		
		<cfif isGoodEmail>
			<cfif form.roleAction EQ "AddRole">
				<!--- check if user role already exists --->
				<cfset roleResult = application.model.AdminUserRole.getAdminUserRole(form.email, form.roleGuid) />
				<!--- if no, add user to table --->
				<cfif roleResult.RecordCount>
					<cfset errormessage = "User Role already exists" />
				<cfelse>	
					<cfset result = application.model.AdminUserRole.addUserRole(form) />
				</cfif>
				
			<cfelseif form.roleAction EQ "RemoveRole">
				<cfset result = application.model.AdminUserRole.deleteUserRole(form) />
			<cfelse>
				<cfset errormessage = "An action must be selected for this User Role to be saved" />
			</cfif>
			
			<cfif result eq "Success">
				<cfset message = "User Role Changes Saved Successfully" />
	    	<cfelse>
				<cfset errormessage = result />
			</cfif>
		<cfelse>
			<cfset errormessage = "There are no users associated with email address" />
		</cfif>
	<cfelseif form.action eq "cancelPlanEdit">
		<cflocation url="index.cfm?c=##" addtoken="false" />
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
<!--- end show messages --->

<div>
 	<cfset userRoleFormDisplay = application.view.AdminUserRole.getSetUserRoleForm() />
	<cfoutput>#userRoleFormDisplay#</cfoutput>
</div>