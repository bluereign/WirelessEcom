<form id="OrderSearchForm" action="<cfoutput>#event.buildLink('TestFullAPI.account')#</cfoutput>" method="post" >
<table>
<tr><th align="right">Carrier:</th><td>
<select name="carrierId">
	<option value="109" selected>ATT</option>
	<option value="42">Verizon</option>
</select>		
</td></tr>	
<tr><th align="right">Phone Number:</th><td><input type="text" name="SubscriberNumber" value="2107097717"/></td></tr>
<tr><th align="right">Zip Code:</th><td><input type="text" name="ZipCode" value="78205"/></td></tr>
<tr><th align="right">Security Id:</th><td><input type="text" name="SecurityId" value="9999"/></td></tr>
<tr><th align="right">Passcode:</th><td><input type="text" name="Passcode" value="Robertph"/></td></tr>
<tr><td></td><td><button class="btn btn-primary" type="submit" Title="Perform a carrier api account request">Account Lookup...</button></td></tr>	
</table>	
</form>
