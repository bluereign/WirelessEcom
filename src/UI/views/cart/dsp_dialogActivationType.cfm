


<cf_cartbody mode="edit" DisplayCartHeader="false" DisplayCartFooter="false">
	<script>
		ValidateForm = function(activationType)
		{
			console.log( activationType );
			jQuery('#ActivationPriceOption').val(activationType);
			ActivationPriceOption
			jQuery('#AddToCartForm').submit();
		}
	</script>
	
	
	<style>
		
	</style>
	
	<cfoutput>
		<div id="dialogContent">
			<div class="cartBody">
				<div style="margin: 25px auto 0;">
					<div style="width: 320px; float:left; padding: 15px;">
						<h2>New AT&T wireless customer?</h2>
						<p>If you are not already an AT&T wireless customer, continue shopping here.</p>			
						<div class="button-container">
							<a class="ActionButton" onclick="ValidateForm('new'); return false;" href="##"><span>Continue</span></a>
						</div>
					</div>
					<div style="width: 320px; border-left: 2px solid ##0061ac; float:left; padding: 15px;">
						<h2>Existing AT&T wireless customer?</h2>
						<p>Already an AT&T wireless customer? To continue, tell us whether this device will be for a new line or if you want to upgrade your current device.</p>
						<div class="button-container">
							<a class="ActionButton" onclick="ValidateForm('upgrade'); return false;" href="##" style="width: 120px;"><span>Upgrade</span></a>
							<a class="ActionButton" onclick="ValidateForm('addaline'); return false;" href="##" style="width: 120px;"><span>Add A Line</span></a>
						</div>
					</div>
				</div>
			</div>
		
			<cfform class="wa-webform" method="post" action="#cgi.script_name#" id="AddToCartForm" name="formAddToCart">
				<input id="ActivationPriceOption" type="hidden" name="ActivationPriceOption" value="new" />
				<cfloop collection="#request.p#" item="thisVar">
					<!--- Do not duplicate new and _FormName fields --->
					<cfif trim(variables.thisVar) neq 'zipcode' && trim(variables.thisVar) neq 'ActivationPriceOption' && left(trim(variables.thisVar), 1) neq '_'>
						<input type="hidden" name="#trim(variables.thisVar)#" value="#htmlEditFormat(trim(request.p[trim(variables.thisVar)]))#" />
					</cfif>
				</cfloop>
			</cfform>
		</div>
	</cfoutput>
</cf_cartbody>