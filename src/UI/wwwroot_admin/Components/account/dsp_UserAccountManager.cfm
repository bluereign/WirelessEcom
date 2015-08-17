<cfset UserService = application.wirebox.getInstance("UserService") />
<cfparam name="userId" default="#request.p.userId#" />


<cfsavecontent variable="js">
<cfoutput>
<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
</cfoutput>
<script>
$(document).ready(function() {
	$('.toggleNoteDisplay').click(function() {

		//Toggle text of link
		if ($(this).text() == 'Show')
		{
			$(this).text( 'Hide' );
		}
		else
		{
			$(this).text( 'Show' );
		}

		var data = $(this).metadata();
		$('#' + 'noteRow-' + data.noteId).toggle();
	});

});
</script>


</cfsavecontent>

<cfhtmlhead text="#js#">

<cfscript>
	user = CreateObject( "component", "cfc.model.User").init(); 
	user.getUserById( userId ); //Loads user object
	
	isOrderAssistanceOn = UserService.isUserOrderAssistanceOn( userId );
	
	order = CreateObject( "component", "cfc.model.Order").init(); 
	orders = application.model.order.getOrderHistoryByUserId( userId );

	view = application.view.AccountManager.getAccountView( user, orders, isOrderAssistanceOn );
</cfscript>

<cfoutput>#view#</cfoutput>

