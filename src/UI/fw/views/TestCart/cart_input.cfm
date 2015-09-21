<cfparam name="zipCode" default="#session.cart.getZipCode()#" />

<!---input fixups for empty data --->
<cfif zipcode is "00000"><cfset zipcode = "78205"></cfif>

<cfoutput>

<div style="padding-bottom:25px;">
<form name="ApplyZipForm" action="#event.buildLink('TestCart.ApplyZip')#" method="post" >
Zip Code: <input type="text" name="ZipCode" value="#zipcode#"/> <button class="btn btn-primary" type="submit" Title="Apply entries to the shopping cart">Apply ZipCode to Cart</button>	
</form>
</div>
</cfoutput>