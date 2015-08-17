<cfparam name="request.p.FirstName" default="" />
<cfparam name="request.p.LastName" default="" />
<cfparam name="request.p.Address1" default="" />
<cfparam name="request.p.Address2" default="" />
<cfparam name="request.p.City" default="" />
<cfparam name="request.p.State" default="" />
<cfparam name="request.p.Zip" default="" />

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset SecurityService = application.wirebox.getInstance("SecurityService") />
<cfset GeoService = application.wirebox.getInstance("GeoService") />

<cfset qStates = GeoService.getAllStates() />

<cfif structKeyExists(form, 'bannedUserSubmit')>
	<cfscript>
		args = {
			FirstName = request.p.FirstName
			, LastName = request.p.LastName
			, Address1 = request.p.Address1
			, Address2 = request.p.Address2
			, City = request.p.City
			, State = request.p.State
			, Zip = request.p.Zip
		};

		SecurityService.createBannedUser( argumentcollection = args );
	</cfscript>
	<div class="message">
		<cfoutput>
			User information has been added to Fraud listing.
		</cfoutput>
	</div>	
</cfif>


<cfsavecontent variable="htmlHead">
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#assetPaths.admin.common#styles/customerservice.css" />
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.metadata.js"></script>
	<script type="text/javascript" src="#assetPaths.admin.common#scripts/libs/jquery.validate.min.js"></script>
</cfoutput>


<script>
$(document).ready(function() {
	//Set validation plugin defaults
	$.validator.setDefaults({
	   meta: "validate"
	   , errorElement: "em"
	});
	
	//Bind click event to submit button
	$('#submitButton').click(function(event) {
		$("#bannedUserForm").validate();

		if ( $("#bannedUserForm").valid() )
		{
			$('#bannedUserForm').submit();
		}
	});	
});
</script>
</cfsavecontent>
<cfhtmlhead text="#htmlHead#">

<cfoutput>

<form id="bannedUserForm" action="" class="middle-forms" method="post">
	<fieldset>
		<h3>Fraud Information</h3>
		<div class="field-display">
			<div>
				<label>First Name:</label>
				<input id="firstName" name="firstName" type="text" maxlength="50" value="#request.p.FirstName#" />
			</div>
			<div>
				<label>Last Name:</label>
				<input id="lastName" name="lastName" type="text" maxlength="50" value="#request.p.LastName#" />
			</div>
			<div>
				<label>Address 1:</label>
				<input id="address1" name="address1" type="text" class="{validate:{required:true}}" maxlength="50" value="#request.p.Address1#" />
			</div>
			<div>
				<label>Address 2:</label>
				<input id="address2" name="address2" type="text" maxlength="50" value="#request.p.Address2#" />
			</div>
			<div>
				<label>City:</label>
				<input id="city" name="city" type="text" class="{validate:{required:true}}" maxlength="50" value="#request.p.City#" />
			</div>
			<div>
				<label for="state">State</label>
			    <select name="state" id="state">
			    	<cfloop query="qStates">
			    		<option value="#StateCode#" <cfif request.p.state EQ StateCode>selected="selected"</cfif>>#State#</option>
					</cfloop>
				</select>
			</div>
			<div>
				<label>Zip Code:</label>
				<input id="zip" name="zip" type="text" class="{validate:{digits:true, required:true}}" maxlength="10" value="#request.p.Zip#" />
			</div>
		</div>
	</fieldset>
	<input name="bannedUserSubmit" type="hidden" />
</form>

<div class="buttonContainer">
	<button id="submitButton" name="submitButton">Add to Fraud Listing</button>
</div>
</cfoutput>
