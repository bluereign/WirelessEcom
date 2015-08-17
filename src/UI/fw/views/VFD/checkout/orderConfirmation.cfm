<cfoutput>
	<script type="text/javascript">
		function showHide(divId){
    		var theDiv = document.getElementById(divId);
    		if(theDiv.style.display=="none"){
      			theDiv.style.display="";
   			}else{
        		theDiv.style.display="none";
    		}   
		}
	</script>
	<!--- For Debug Information --->
	<cfif request.config.debugInventoryData>
		<div align=right>
			<input type="button" onclick="showHide('debugDiv')" value="Debug Info"> 
		</div>
		<div id="debugDiv" style="display: none">
			<div align=right>
				<h2>VFD State:</h2><input type="radio" id="vfdon" name="vfdOn" value="vfdOn" disabled=true <cfif (structKeyExists(session, 'VFD')) and (Session.VFD.Access eq true)>checked</cfif> />On  
				<input type="radio" id="vfdoff" name="vfdOff" value="vfdOff" disabled=true <cfif (not structKeyExists(session, 'VFD')) or (Session.VFD.Access neq true)>checked</cfif> />Off
			</div>
		</div>
	</cfif>

	<h1>VFD Review Your Order</h1>

	<cfif application.model.checkoutHelper.isWirelessOrder()>
	<cfelse>
		<p><strong>Please review your order and shipping selection below, then click continue.</strong></p>
	</cfif>

	<form id="reviewOrder" name="reviewOrder" action="/checkoutVFD/processOrderConfirmation" method="post">
		<cfoutput>#trim(application.view.cart.view(false))#</cfoutput>
		<input type="hidden" name="s" value="Submit Order" />
	</form>

	<form id="cancelOrder" name="cancelOrder" action="/index.cfm/go/checkout/do/processOrderCancel/" method="post">
		<input type="hidden" name="s" value="Cancel Order" />
	</form>

	<div id="buttonDiv" name="buttonDiv" class="formControl">
		<span id="backButton" class="actionButtonLow">
			<a href="##" onclick="window.location.href = '#event.buildLink('checkoutVFD.billShip')#'">Back</a>
			<!---<a href="##" onclick="window.location.href = '/index.cfm/go/checkout/do/billShip/'">Back</a>--->
		</span>
		<span id="shoppingButton" class="actionButtonLow">
			<a href="##" onclick="var ok=confirm('Are you sure you want to exit the checkout process without completing your order?'); if(ok){ location.href='/index.cfm/'; }">Return to Shopping</a>
		</span>
		<span id="continueButton" class="actionButton">
			<cfif application.model.checkoutHelper.isPrepaidOrder()>
				<a href="##" onclick="showProgress('Updating order, proceeding to prepaid customer information.'); $('##reviewOrder').submit()">Continue</a>
			<cfelseif application.model.checkoutHelper.isWirelessOrder()>
				<a href="##" onclick="showProgress('Updating order, proceeding to terms & conditions.'); $('##reviewOrder').submit()">Continue</a>
			<cfelse>
				<a href="##" onclick="showProgress('Updating order.'); $('##reviewOrder').submit()">Proceed to Payment</a>
			</cfif>
		</span>
	</div>
</cfoutput>