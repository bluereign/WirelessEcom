<cfparam name="request.p.username" default="" />
<cfparam name="request.p.billing_firstname" default="" />
<cfparam name="request.p.billing_lastname" default="" />
<cfparam name="request.p.billing_company" default="" />
<cfparam name="request.p.billing_address1" default="" />
<cfparam name="request.p.billing_address2" default="" />
<cfparam name="request.p.billing_city" default="" />
<cfparam name="request.p.billing_state" default="" />
<cfparam name="request.p.billing_zipcode" default="" />
<cfparam name="request.p.billing_dayphone" default="" />
<cfparam name="request.p.billing_workphone" default="" />
<cfparam name="request.p.shipping_firstname" default="" />
<cfparam name="request.p.shipping_lastname" default="" />
<cfparam name="request.p.shipping_company" default="" />
<cfparam name="request.p.shipping_address1" default="" />
<cfparam name="request.p.shipping_address2" default="" />
<cfparam name="request.p.shipping_city" default="" />
<cfparam name="request.p.shipping_state" default="" />
<cfparam name="request.p.shipping_zipcode" default="" />
<cfparam name="request.p.shipping_dayphone" default="" />
<cfparam name="request.p.shipping_workphone" default="" />

<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset GeoService = application.wirebox.getInstance("GeoService") />

<cfif StructKeyExists( form, "Submit" )>

	<cfscript>	
		user = CreateObject( "component", "cfc.model.User" ).init();
		user.setFirstName( request.p.billing_firstname );
		user.setLastName( request.p.billing_lastname );
		user.setEmail( request.p.username );
		
		billAddress = CreateObject( "component", "cfc.model.Address" ).init();
	    billAddress.setFirstName( request.p.billing_firstname );
	    billAddress.setLastName( request.p.billing_lastname );
		billAddress.setCompany( request.p.billing_company );
	    billAddress.setAddressLine1( request.p.billing_address1 );
	    billAddress.setAddressLine2( request.p.billing_address2 );
	    billAddress.setCity( request.p.billing_city );
	    billAddress.setState( request.p.billing_state );
	    billAddress.setZipCode( request.p.billing_zipcode );
	    billAddress.setDayPhone( request.p.billing_dayphone );
	    billAddress.setEvePhone( request.p.billing_workphone );
		user.setBillingAddress( billAddress );
		
		if ( StructKeyExists( form, "isShippingSameAsBilling" ) )
		{
		    request.p.shipping_firstname = request.p.billing_firstname;
		    request.p.shipping_lastname = request.p.billing_lastname;
			request.p.shipping_company = request.p.billing_company;
		    request.p.shipping_address1 = request.p.billing_address1;
		    request.p.shipping_address2 = request.p.billing_address2;
		    request.p.shipping_city = request.p.billing_city;
		    request.p.shipping_state = request.p.billing_state;
		    request.p.shipping_zipcode = request.p.billing_zipcode;
		    request.p.shipping_dayphone = request.p.billing_dayphone;
		    request.p.shipping_workphone = request.p.billing_workphone;
		}

		shipAddress = CreateObject( "component", "cfc.model.Address" ).init();
	    shipAddress.setFirstName( request.p.shipping_firstname );
	    shipAddress.setLastName( request.p.shipping_lastname );
		shipAddress.setCompany( request.p.shipping_company );		
	    shipAddress.setAddressLine1( request.p.shipping_address1 );
	    shipAddress.setAddressLine2( request.p.shipping_address2 );
	    shipAddress.setCity( request.p.shipping_city );
	    shipAddress.setState( request.p.shipping_state );
	    shipAddress.setZipCode( request.p.shipping_zipcode );
	    shipAddress.setDayPhone( request.p.shipping_dayphone );
	    shipAddress.setEvePhone( request.p.shipping_workphone );
		user.setShippingAddress( shipAddress );	

	
		newUserId = application.model.AccountService.createUser( user );
	</cfscript>
	
	
	<cfif newUserId NEQ 0>
		<cflocation url="?c=d46c6001-3f33-4989-adab-32fdb2a5eed4&userId=#newUserId#" addtoken="false" />
	<cfelse>
		<div class="message">
			Username already in use. Please select another username.
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
	
	function toggleShippingDisplay( element )
	{
		if ( $(element).attr('checked') ) 
		{
			$('#shippingFields').hide(); 
			$( '#shippingFields :input').attr("disabled","disabled");
		}
		else 
		{
			$('#shippingFields').show();
			$( '#shippingFields :input').removeAttr("disabled");
		}		
	}
	
	
	$('#isShippingSameAsBilling').change(function(){
		toggleShippingDisplay( this );
	});
	
	
	toggleShippingDisplay( $('#isShippingSameAsBilling') ); //Needed for page refreshes
	
	$.validator.setDefaults({
	   meta: "validate"
	   , errorElement: "em"

	});
	
	$("#accountForm").validate();

});
</script>
</cfsavecontent>

<cfhtmlhead text="#js#">

<cfset qStates = GeoService.getAllStates() />
<cfset accountForm = application.view.AccountManager.getAccountForm( qStates ) />
<cfoutput>#accountForm#</cfoutput>