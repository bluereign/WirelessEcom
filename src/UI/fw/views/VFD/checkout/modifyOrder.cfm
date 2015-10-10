
<cfoutput>    
	<input type="hidden" id="orderID" name="orderID" value="#rc.qWirelesslines.OrderId[1]#" />
	<div id="carrier" name="carrier">
		<cfset local.carrierID = rc.qWirelesslines.carrierID[1]>
		<cfif local.carrierId eq "109"><!--- ATT --->
			<img src="#assetPaths.common#images/content/rebatecenter/att.jpg" width="117" height="51">
		<cfelseif local.carrierId eq "128"><!--- TMOBILE --->
			<img src="#assetPaths.common#images/content/rebatecenter/TM_authdealerlogo.jpg" width="150" 
			     height="25">
		<cfelseif local.carrierId eq "42"><!--- VERIZON --->
			<img src="#assetPaths.common#images/carrierLogos/verizon_175.gif"/>
		<cfelseif local.carrierId eq "299"><!--- SPRINT --->
			<img src="#assetPaths.common#images/content/rebatecenter/sprint.jpg" width="117" height="51">
		</cfif>
	</div>
	<br/>
	<h2 style="color:red;">Please Make Sure the Device is Activated!</h2>


	
	
		<cfset local.line = 0 />
		<cfloop query="rc.qWirelesslines">
			<cfset local.line = local.line+1/>
        	<table id="confirmInfo" class="confirmInfo">
        	<tr>
        		<td style="font-weight:bold">
        			IMEI:
        		</td>
        		<td style="color:red;font-weight:bold">
        			#rc.qWirelesslines.IMEI#
        		</td>
        		<td style="margin:5px;">
        		</td>
        		<td style="font-weight:bold">
        			SIM:
        		</td>
        		<td style="color:red;font-weight:bold">
        			#rc.qWirelesslines.SIM#
        		</td>
        	</tr>
        	<tr>
        		<td style="margin:5px;">
        		</td>
        		
        		<td style="margin:5px;">
        			Phone ##
        		</td>
        		<td style="margin:5px;width:20px;">
        			&nbsp;
        		</td>
        		<td style="margin:5px;">
        			Agreement ##
        		</td>
        		
        		<td style="margin:5px;visibility:hidden;">
        		</td>
        		<td style="margin:5px;width:20px;">
        			&nbsp;
        		</td>
        	</tr>
			<tr>
				<td>
					Device 
					#local.line#
					<input type="hidden" id="wirelessLineID#local.line#" 
					       name="wirelessLineID#local.line#" 
					       value="#rc.qWirelesslines.WirelessLineId#"/>
				</td>
				<td>
					<div>
						( 
						<input id="Phone_#local.line#_NumPt1" name="Phone_#local.line#_NumPt1" 
						       onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('Phone_#local.line#_NumPt2'))" 
						       maxlength="3" style="width:40px;text-align:center;"/>
						)
						<input id="Phone_#local.line#_NumPt2" name="Phone_#local.line#_NumPt2" 
						       onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('Phone_#local.line#_NumPt3'))" 
						       maxlength="3" style="width:40px;text-align:center;"/>
						- 
						<input id="Phone_#local.line#_NumPt3" name="Phone_#local.line#_NumPt3" 
						       onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" 
						       maxlength="4" style="width:50px;text-align:center;"/>
					</div>
				</td>
				<td>
					&nbsp;
				</td>
				<td>
					<cfif rc.qWirelesslines.PurchaseType contains 'fp'>
						<input id="finance#local.line#" name="finance#local.line#" class="finance" 
						       type='text' style="margin:5px;width:120px"/>
					<cfelse>
						<input id="finance#local.line#" name="finance#local.line#" class="finance" 
						       type='text' style="margin:5px;width:120px" value="NA" readonly/>
					</cfif>
				</td>
				
				<td style="visibility:hidden;width:0px;">
					<input id="activationID#local.line#" name="activationID#local.line#" 
					       class="activation" type='text' style="margin:5px;"/>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
		</cfloop>
	</table>
	<a id="finishConfirm" href="##" onclick="if(checkAll()){closeModifyOrder();}"><button class="btn btn-default" type="button">Update Order</button></a>
	<a id="cancelConfirm" href="##" onclick="closeModifyOrder()"><button class="btn btn-default" type="button">Cancel</button></a>
</cfoutput>

<script type="text/javascript">
	var $j = jQuery.noConflict();
		var allValidNums = false;
		var allFinanceAgreement = false;
		
		$j(document).ready(function($j){
		    //Updates db with newMDN and activationNum
		    $j('#finishConfirm').click( function( event ) {
				event.preventDefault();	
				var inputs = document.getElementsByClassName("activation");
		    	var deviceCount = 0;
		    	for (i = 0; i < inputs.length; i++) {
		        	deviceCount++;
		        		
					var wirelessLineID = document.getElementById('wirelessLineID'+deviceCount).value;
					var value1 = document.getElementById('Phone_'+deviceCount+'_NumPt1').value;
					var value2 = document.getElementById('Phone_'+deviceCount+'_NumPt2').value;
					var value3 = document.getElementById('Phone_'+deviceCount+'_NumPt3').value;
					var newMDN = value1 + value2 + value3;
					var financeNum = document.getElementById('finance'+deviceCount).value;
					var orderID = document.getElementById('orderID').value;	
					$j.ajax({
						cache: false,
						type: "POST",
						url: "../CheckoutVFD/updateWirelessLine",
						data: {
							wirelessLineID: wirelessLineID,
							newMDN: newMDN,
							orderID: orderID,
							financeNum: financeNum
						},
						dataType: "json"						
					})
				}	
				return false;
			});	

		});
		
		//closes all popup windows that were created
		function closeModifyOrder(){
			window.opener.location.reload();
			window.close();		
		}
		//handles keyboard shortcuts with phone fields
		function autotab(event,original,destination){
				var keyID = event.keyCode;
				if (keyID==37||keyID==39||event.shiftKey&&keyID==9||keyID==16||keyID==9){
					return false;
				}			
			if (original.getAttribute&&original.value.length==original.getAttribute("maxlength"))
			destination.focus()
		}
		//Verifies that there are new phone numbers for each device
		function checkPhone(){
		    var inputs = document.getElementsByClassName("activation");
		    var deviceCount = 0;
		    for (i = 0; i < inputs.length; i++) {
		        deviceCount++;
		        var value1 = document.getElementById('Phone_'+deviceCount+'_NumPt1').value;
				var value2 = document.getElementById('Phone_'+deviceCount+'_NumPt2').value;
				var value3 = document.getElementById('Phone_'+deviceCount+'_NumPt3').value;
		        if (((value1.trim()).length)&&((value2.trim()).length)&&((value3.trim()).length)) {
		            allValidNums = true;
		        }
		        else {
		            alert("You must have a valid phone number for each device before you can print.");
		            allValidNums = false;
		            break;
		        }
		    }
		    return allValidNums;
		}
		//Verifies that there are finance agreements for each financed device
		function checkFinanceAgreement(){
		    var inputs = document.getElementsByClassName("finance");
		    var deviceCount = 0;
		    for (i = 0; i < inputs.length; i++) {
		        deviceCount++;
		        var value = document.getElementById('finance' + deviceCount).value;
		        if ((value.trim()).length) {
		            allFinanceAgreement = true;
		        }
		        else {
		            alert("You must have a finance agreement number for each financed device before you can print.");
		            allFinanceAgreement = false;
		            break;
		        }
		    }
		    return allFinanceAgreement;
		}
		
		//Checks to see if phone numbers are entered, then if all are valid, then if finance agreement is entered then allow to proceed
		function checkAll(){
			if(checkPhone()){
				if(checkFinanceAgreement()){
					if(allValidNums==true && allFinanceAgreement==true){
						alert("This order has been updated.  It may take a few minutes for the status to change in the listing.")
						return true;
					}
					return false;
		 		}
		 		return false;
		 	}
			return false;
		}
</script>