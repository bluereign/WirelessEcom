<cfparam name="userId" default="request.p.userId" />
<cfparam name="isOrderAssistanceOn" default="request.p.isOrderAssistanceOn" />

<cfif application.model.SecurityService.isFunctionalityAccessable( session.AdminUser.AdminUserId, '1B58DB73-CBE3-41B6-A69C-07200395E917' ) >
	<cfscript>
	
		user = CreateObject( "component", "cfc.model.User" ).init();
		user.getUserById( userId );	
		
		args = {
			user = user
			, isOrderAssistanceOn = isOrderAssistanceOn
		};
	</cfscript>
	
	<cfoutput>#application.view.AccountManager.getGeneralAccountView( argumentCollection = args )#</cfoutput>
<cfelse>
	<div class="accessDenied">
		<span class="form-error-inline">You do not have access to view this page</span>
	</div>
</cfif> 

