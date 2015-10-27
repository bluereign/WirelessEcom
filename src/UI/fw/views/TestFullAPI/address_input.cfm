<div style="padding-bottom:25px;">
<form id="OrderSearchForm" action="<cfoutput>#event.buildLink('TestFullAPI.address')#</cfoutput>" method="post" >
<table>
<tr><th align="right">Carrier:</th><td>
<select name="carrierId">
	<option value="109" selected>ATT</option>
	<option value="42">Verizon</option>
</select>		
</td></tr>	
<tr><th align="right">Address 1:</th><td><input type="text" name="Address1" value="13206 SE 57th Street"/></td></tr>
<tr><th align="right">Address 2:</th><td><input type="text" name="Address2" value=""/></td></tr>
<tr><th align="right">City:</th><td><input type="text" name="City" value="Bellevue"/></td></tr>
<tr><th align="right">State:</th><td><input type="text" name="State" value="WA"/></td></tr>
<tr><th align="right">Zip:</th><td><input type="text" name="Zip" value="98006"/></td></tr>
<tr><th align="right">Zip Ext:</th><td><input type="text" name="ZipExtension" value=""/></td></tr>
<tr><th align="right">Country:</th><td><input type="text" name="Country" value="US"/></td></tr>
<tr><td></td><td><button class="btn btn-primary" type="submit" Title="Perform an Address Validation">Validate Address...</button></td></tr>	
</table>	
</form>
</div>
<div>
<form id="OrderSearchForm" action="<cfoutput>#event.buildLink('TestFullAPI.address')#</cfoutput>" method="post" >
<table>
<tr><th align="right">Carrier:</th><td>
<select name="carrierId">
	<option value="109">ATT</option>
	<option value="42" selected>Verizon</option>
</select>		
</td></tr>	
<tr><th align="right">Address 1:</th><td><input type="text" name="Address1" value="13206 SE 57th Street"/></td></tr>
<tr><th align="right">Address 2:</th><td><input type="text" name="Address2" value=""/></td></tr>
<tr><th align="right">City:</th><td><input type="text" name="City" value="Bellevue"/></td></tr>
<tr><th align="right">State:</th><td><input type="text" name="State" value="WA"/></td></tr>
<tr><th align="right">Zip:</th><td><input type="text" name="Zip" value="98006"/></td></tr>
<tr><th align="right">Zip Ext:</th><td><input type="text" name="ZipExtension" value=""/></td></tr>
<tr><th align="right">Country:</th><td><input type="text" name="Country" value="US"/></td></tr>
<tr><td></td><td><button class="btn btn-primary" type="submit" Title="Perform an Address Validation">Validate Address...</button></td></tr>	
</table>	
</form>
</div>