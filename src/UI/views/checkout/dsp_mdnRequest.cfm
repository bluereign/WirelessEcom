<form id="mdn" action="/index.cfm/go/checkout/do/processMdnRequest/" method="post">
	
	
	<cfif isDefined("request.p.resultCode")>
		<cfoutput><p class="error">error #request.p.resultCode# occured</p></cfoutput>
	</cfif>

	<h2>What <span>area code</span> would you like?</h2>
	
	<p>Please enter the area code you'd like for your new wireless number.</p>
	<fieldset>
		<label for="areaCode">Area Code</label><input id="areaCode" size="4"/><br/>
	</fieldset>
	
	<div class="formControl">
		<span class="actionButton"><a href="##" onclick="$('mdn').submit()">Assign me a number</a></span>
	</div>
	
	<div class="optional">
		<h2>Have a <span>phone number</span> in mind?</h2>
		
		<p>If there is a phone number you'd like to have, you can request that number here.  If you'd like to be assigned a number, just enter your 
		desired area code and click the "Assign me a number" button.</p>

		<fieldset>
			<label for="tryNumber">Wireless Number </label><input id="tryNumber" type="text" />			<br/>
		</fieldset>

		<div class="formControl">
			<span class="actionButton"><a href="##" onclick="$('mdn').submit()">Request this number</a></span>
		</div>

	</div>
		

	
</form>
<br/><br/>
