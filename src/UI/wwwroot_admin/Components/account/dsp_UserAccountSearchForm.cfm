<cfparam name="request.p.username" default="" />
<cfparam name="request.p.firstname" default="" />
<cfparam name="request.p.lastname" default="" />
<cfparam name="request.p.zip" default="" />
<cfparam name="request.p.userId" default="" />
<cfparam name="request.p.phone" default="" />

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfsavecontent variable="js">
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.validate.min.js"></script>
</cfoutput>

<script>
$(document).ready(function() {

	$('#submit').click(function() {
		$("#searchForm").validate();
		
		if ( $("#searchForm").valid() )
		{
			$('#searchForm').submit();
		}
	});

	$.validator.setDefaults({
	   meta: "validate"
	   , errorElement: "em"
	});

});
</script>
</cfsavecontent>

<cfhtmlhead text="#js#">
<cfset searchForm = application.view.AccountManager.getAccountSearchForm() />
<cfoutput>#searchForm#</cfoutput>

<!--- TODO: Replace form submit with ajax call to get HTML list --->
<cfif StructKeyExists( form, "submitForm" )>
	<cfscript>
		searchArgs = {
			username = request.p.username
			, firstname = request.p.firstname
			, lastname = request.p.lastname
			, zip = request.p.zip
			, userId = request.p.userId
			, phone = request.p.phone
		};
		
		qUsers = application.model.User.getUsersBySearchCriteria( searchArgs );
		listView = application.view.AccountManager.getAccountListView( qUsers );
	</cfscript>

	<cfoutput>#listView#</cfoutput>
</cfif>