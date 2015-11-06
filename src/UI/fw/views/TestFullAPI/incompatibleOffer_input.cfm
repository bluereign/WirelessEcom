<cfquery name="qproducts" datasource="wirelessadvocates">
	select * from catalog.dn_phones 
	where imeiType is not null 
	and carrierid = 109
</cfquery>	

<div style="padding-bottom:25px;">
<form id="OrderSearchForm" action="<cfoutput>#event.buildLink('TestFullAPI.IncompatibleOffer')#</cfoutput>" method="post" >
<table>
<tr><th align="right">Carrier:</th><td>
<select name="carrierId">
	<option value="109" selected>ATT</option>
	<option value="42">Verizon</option>
</select>		
</td></tr>	
<tr><th align="right">SubscriberNumber:</th><td><input type="text" name="SubscriberNumber" value="2107909469"/></td></tr>

<tr><th align="right">ProductId:</th><td>
<select name="productId">
	<cfoutput query="qproducts">
	<option value="#productid#">#productid# - #summaryTitle# (#imeiType#)</option>
	</cfoutput>
</select>
</td></tr>
<tr><th align="right">ImeiType:</th><td>
<select name="imeiType">
	<cfoutput query="qproducts">
	<option value="#imeiType#">#productid# - #summaryTitle# (#imeiType#)</option>
	</cfoutput>
</select>
</td></tr>

<tr><td></td><td><button class="btn btn-primary" type="submit" Title="Get Incompatible Offers">Get Incompatible Offers...</button></td></tr>	
</table>	
</form>
</div>
