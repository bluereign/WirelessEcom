<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfparam name="request.p.username" default="" />
<cfparam name="request.p.password" default="" />

<cfif StructKeyExists( form, "submitUpdatePassword" )>
	<cfscript>
		isPasswordReset = false;
		
		if ( application.model.user.isEmailInUse( request.p.username ) )
		{
			user = CreateObject( "component", "cfc.model.User" ).init();
			user.loadUserByUsername( request.p.username ); 
			userId = user.getUserId();

			properties = {
				Username = request.p.username
				, Password = form.password
				, Password2 = form.password
			};

			user.updateUserPwd( userId, properties );
			isPasswordReset = true;
		}
	</cfscript>
	
	<cfif isPasswordReset>
		<div class="message">
			Password has been reset.
		</div>
	<cfelse>
		<div class="message">
			Customer does not exist in system.
		</div>	
	</cfif>
</cfif>


<cfsavecontent variable="js">
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.validate.min.js"></script>
</cfoutput>
<script>
$(document).ready(function() {
	
	$.validator.setDefaults({
	   meta: "validate"
	   , errorElement: "em"

	});
	
	$("#resetForm").validate();


	//Bind click event to
	$('#submitUpdatePassword').click(function(event) {

		$("#updatePasswordForm").validate();

		if ( $("#updatePasswordForm").valid() )
		{
			$('#updatePasswordForm').submit();
		}
	});

});
</script>
</cfsavecontent>

<cfhtmlhead text="#js#">

<cfset resetPasswordView = application.view.AccountManager.getResetPasswordForm() />
<cfoutput>#resetPasswordView#</cfoutput>