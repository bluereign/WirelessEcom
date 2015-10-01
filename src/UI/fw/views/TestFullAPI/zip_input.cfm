<div style="padding-bottom:25px;">
<form id="ZipInputForm" action="<cfoutput>#event.buildLink('TestFullAPI.areaCode')#</cfoutput>" method="post" >
<table>
<tr><th align="right">Carrier:</th><td>
<select name="carrierId">
	<option value="109" selected>ATT</option>
	<option value="42">Verizon</option>
</select>		
</td></tr>	<tr><th align="right">Zip Code:</th><td><input type="text" name="ZipCode" value="78205"/></td></tr>
<tr><td></td><td><button class="btn btn-primary" type="submit" Title="Perform an area code loop">Area Code Lookup...</button></td></tr>	
</table>	
</form>
</div>
