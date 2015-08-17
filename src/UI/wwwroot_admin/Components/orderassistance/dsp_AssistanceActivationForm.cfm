<cfparam name="request.p.username" default="" />

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
		$("#assistanceForm").validate();
		
		if ( $("#assistanceForm").valid() )
		{
			$('#assistanceForm').submit();
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

<cfif StructKeyExists( form, "submitForm" )>
	<cfscript>
		user = CreateObject( "component" , "cfc.model.User" ).init();
		user.loadUserByUsername( request.p.Username );
		
		if ( user.getUserId() NEQ "" )
		{
			args = {
				UserId = user.getUserId()
				, IsOrderAssistanceOn = request.p.IsOrderAssistanceOn
			};
		
			application.model.user.updateOrderAssistance( argumentCollection = args );
		}
		
		
		
	</cfscript>
<!---	
	<cfdump var="#user.getUserId()#">
	<cfdump var="#user.getInstanceData()#" /><cfabort>--->
	
	<cfif user.getUserId() NEQ "">
		<div class="message">
			Order assistance has been turned <cfif form.isOrderAssistanceOn>on<cfelse>off</cfif> for <cfoutput>#user.getEmail()#</cfoutput>
		</div>
	<cfelse>
		<div class="message">
			Username was not found.
		</div>
	</cfif>
</cfif>

<form name="assistanceForm" action="" id="assistanceForm" class="middle-forms" method="post">
	<h3>Order Assistance</h3>
	<fieldset>
		<legend>Order Assistance</legend>
		<div>
			<label for="username">Username</label>
			<input name="username" id="username" type="input" class="{validate:{required:true, email:true}}" value="<cfoutput>#request.p.username#</cfoutput>" />
		</div>
		<div>
			<label for="isOrderAssistanceOn">Assistance Status</label>
			<select id="isOrderAssistanceOn" name="isOrderAssistanceOn">
				<option value="1">Turn On</option>
				<option value="0">Turn Off</option>
			</select>
		</div>
	</fieldset>
	<input name="submitForm" type="hidden" />
</form>
<button id="submit" name="submit">Update</button>