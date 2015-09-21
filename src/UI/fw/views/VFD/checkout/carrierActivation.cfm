<cfset assetPaths = application.wirebox.getInstance("assetPaths")/>
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig")/>
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker")/>
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker")/>
<cfsetting showdebugoutput="No">

<cfset cartLines = session.cart.getLines()/>
<cfloop from="1" to="#arrayLen(variables.cartLines)#" index="iLine">
	<cfset thisLine = variables.cartLines[variables.iLine]/>
	<cfset thisPlan = variables.thisLine.getPlan()/>
	<cfset selectedPlan = application.model.plan.getByFilter(idList=variables.thisPlan.getProductID())/>
</cfloop>
<cfoutput>
	<style>
		@media print { 
		body {
			-webkit-print-color-adjust: exact;
		}
		## header { 
			display: none; 
		} 
		##footer 
		{ 
			display: none; 
		} 
		}
		.pane {
		    height: 90%;
		    float: left;
		    width: 200px;
		    margin-left: 10px;
		}
		.floatRight {
		    vertical-align: text-top;
		    width: auto;
		    float: right;
		    display: inline-block;
		}
		.bootstrap .progressBtn {
		    background: linear-gradient(to bottom, ##8bcd68 0%, ##65b43c 5%, ##518f30 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 180px;
				}
				.bootstrap .progressBtnLarge {
		   			background: linear-gradient(to bottom, ##8bcd68 0%, ##65b43c 5%, ##518f30 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 250px;
				}
				.bootstrap .waitForActionBtn {
		   			background: linear-gradient(to bottom, ##E3E3ED 0%, ##DCDCDA 5%, ##C7C7C1 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 180px;
				}
				.bootstrap .waitForActionBtn span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap .waitForActionBtnLarge {
		   			background: linear-gradient(to bottom, ##E3E3ED 0%, ##DCDCDA 5%, ##C7C7C1 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 250px;
				}
				.bootstrap .waitForActionBtnLarge span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap .progressBtn span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap .progressBtnLarge span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap div.carrier-box {
			   		border: 1px solid ##808080;
					width: 200px;
					height: 300px;
			 	  	padding-top: 10px;
			 	  	padding-bottom: 10px;
			 	  	margin-bottom: 15px;
			  	  /* CSS3 For Various Browsers*/
			 	   	border-radius: 5px;
					position: relative;
					left:10px;
					top:10px;
				}
				.bootstrap img.carrier {
		   		 	margin: 0;
		    		position: absolute;
		    		top: 50%;
		    		left: 50%;
		    		margin-right: -50%;
		    		transform: translate(-50%, -50%) ;
				}
				.bootstrap h3.carrier {
		   		 	margin-top:150px;
				}
				.bootstrap iframe.carrier {
		   		 	margin-top:20px;
					margin-bottom:20px;
					height:100%;
					width:100%;
				}
				.bootstrap .modal-custom{
					width:700px
				}
	</style>
	
	<cfset local.cartLines = session.cart.getLines()/>
	<cfset local.hasActivationItems = application.model.CartHelper.cartContainsActivationItems() />

	<form id="carrierActivation" name="carrierActivation" class="cmxform" action=""
	      method="post">
	<input type="hidden" id="numberOfDevices" name="numberOfDevices" value="#arrayLen(variables.cartLines)#" />
	<input type="hidden" id="orderID" name="orderID" value="#session.checkout.OrderId#" />
	<input type="hidden" id="isActivation" name="isActivation" value="#application.model.CartHelper.cartContainsActivationItems()#"  />
	<cfset local.carrierID = application.model.checkoutHelper.getCarrier()/>
	<!---<cfif local.carrierId eq "109"><!--- ATT --->
		<input type="hidden" id="carrierAuthWording" name="carrierAuthWording" value="Activation Number" />
	<cfelseif local.carrierId eq "128"><!--- TMOBILE --->
		<input type="hidden" id="carrierAuthWording" name="carrierAuthWording" value="Activation Code" />
	<cfelseif local.carrierId eq "42"><!--- VERIZON --->
		<input type="hidden" id="carrierAuthWording" name="carrierAuthWording" value="Authorization Code" />
	<cfelseif local.carrierId eq "299"><!--- SPRINT --->
		<input type="hidden" id="carrierAuthWording" name="carrierAuthWording" value="MSID" />
	</cfif>--->
	<div class="bootstrap">
		<div>
			<cfif local.hasActivationItems>
				<h2>
					You MUST Activate in the Carrier Portal 
				</h2>
				<h3>
					Please use the information below to activate the device:
				</h3>
				<br/>
				<br/>
			<cfelse>
				<h2>
					Confirmation Processing 
				</h2>
			</cfif>
		</div>
		
		<div class="pane">
			<cfif ( local.hasActivationItems)>
				<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iCartLine">
					<cfset local.cartLine = local.cartLines[local.iCartLine]/>
					<cfset local.selectedPhone = application.model.phone.getByFilter(idList=local.cartLine.getPhone().getProductID(), 
					                                                                 allowHidden=true)/>
					<cfset OrderDetail = application.model.WirelessLine.getByOrderID(session.checkout.OrderId)/>
					<div>
						<span style="font-size:18">
							Device 
							#local.iCartLine#
							: 
						</span>
						#local.selectedPhone.summaryTitle# : #local.cartline.getCartLineActivationType()#
					</div>
					<div>
						<label class="floatLeft" for="txtActivationIMEI" style="font-size:x-large;font-weight:bold;color:red">
							IMEI:
						</label>
						<input style="font-size:larger;font-weight:bold;color:red" id="txtActivationIMEI#local.iCartLine#" name="activationIMEI#local.iCartLine#" 
						       onclick="this.select();" value="#OrderDetail[local.iCartLine].getIMEI()#" readonly/>
					</div>
					<div>
						<label class="floatLeft" for="txtActivationSIM" style="font-size:x-large;font-weight:bold;color:red">
							SIM:
						</label>
						<input style="font-size:larger;font-weight:bold;color:red" id="txtActivationSIM#local.iCartLine#" name="txtActivationSIM#local.iCartLine#" 
						       onclick="this.select();" value="#OrderDetail[local.iCartLine].getSim()#" readonly/>
					</div>
				</cfloop>
				<div>
					<h4>
						Plan
					</h4>
				</div>
				<div>
					<label for="txtActivationProductName">
						Name:
					</label>
					<textarea id="txtActivationProductName" readonly cols="17" rows="2" class="floatLeft" onclick="this.select();" style="overflow:auto;resize:none;text-align:left"><cfif len(#trim(selectedPlan.summaryTitle)#) gt 0>#trim(selectedPlan.summaryTitle)#<cfelse>2-year contract extension required</cfif></textarea>
				</div>
			</cfif>
			<div>
				<h4>
					Customer Information
				</h4>
			</div>
			<div>
				<label for="nameInput">
					Name:
				</label>
				<input id="nameInput" name="nameInput" onclick="this.select();" type='text'
				       value='#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billFirstName'))# #trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billLastName'))#' 
				       readonly/>
			</div>
			<div>
				<label for="streetInput">
					Street:
				</label>
				<input id="streetInput" name="streetInput" onclick="this.select();" type='text'
				       value='#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billAddress1'))#' 
				       readonly/>
			</div>
			<div>
				<label for="cityInput">
					City:
				</label>
				<input id="cityInput" name="cityInput" onclick="this.select();" type='text'
				       value='#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billCity'))#' 
				       readonly/>
			</div>
			<div>
				<label for="stateInput">
					State:
				</label>
				<input id="stateInput" name="stateInput" onclick="this.select();" type='text'
				       value='#trim(session.checkout.billShipForm.billState)#' readonly/>
			</div>
			<div>
				<label for="zipInput">
					Zip:
				</label>
				<input id="zipInput" name="zipInput" onclick="this.select();" type='text'
				       value='#trim(application.model.checkoutHelper.formValue('session.checkout.billShipForm.billZip'))#' 
				       readonly/>
			</div>
			<div id="buttonDiv" class="formControl" style="float:left;cursor:pointer;">
				<a id="continueButton" data-toggle="modal" data-target="##confirmation" class="progressBtn" style="text-decoration: none">
				<span>Continue</span></a>
			</div>
		</div>
		<!---<div id="containerDiv" name="containerDiv" style="position:relative;height:100%;margin-left:230px;width:100%;margin-bottom:auto;">
			<cfset local.carrierID = application.model.checkoutHelper.getCarrier()/>
			 <cfif local.carrierId eq "109"><!--- ATT --->
			 	<div style="width:100%;height:500px">
					<div class="carrier-box">
						<div style="position:absolute;">
			            <a rel="external-new-window" href="https://pdct.cingular.com/v2/Login.html">
			                <img class="carrier" src="#assetPaths.common#images/content/rebatecenter/att.jpg"
							 width="117" height="51"><br/><h3 align="center" class="carrier">Click for AT&T Activation</h3>
			            </a>
			        </div>
					</div>
				</div>
			 <cfelseif local.carrierId eq "128"><!--- TMOBILE --->
			 	<div style="margin-right:auto;position:absolute;width:100%;height:490px;">
					<iframe class="carrier" src="https://business.t-mobile.com/" id="carrierActivationSite" scrolling="yes"></iframe>
				</div>
			 <cfelseif local.carrierId eq "42"><!--- VERIZON --->
			 	<div style="margin-right:auto;position:absolute;width:100%;height:490px;">
					<iframe class="carrier" src="https://cim.verizonwireless.com/cimPreAuth/?mode=friendly&destinationURL=https://eroes-ss.west.verizonwireless.com/eroes/eROES.jsp" 
			     	  	id="carrierActivationSite" scrolling="yes"></iframe>
				</div>
			 <cfelseif local.carrierId eq "299"><!--- SPRINT --->
			 	<div style="margin-right:auto;position:absolute;width:100%;height:490px;">
					<iframe class="carrier" src="https://indirect.sprint.com/indrestricted/nrgen" 
			     	  	id="carrierActivationSite" scrolling="yes">
					</iframe>
				</div>
			 </cfif>	
		</div>--->
		<div id="containerDiv" name="containerDiv" style="position:relative;height:100%;margin-left:230px;width:100%;margin-bottom:auto;">
			<cfif local.carrierId eq "299"><!--- SPRINT --->
				<div style="margin-right:auto;position:absolute;width:100%;height:490px;">
					<iframe class="carrier" src="https://indirect.sprint.com/public_docs/login.jsp?TYPE=33554433&REALMOID=06-00097e03-f8e8-1430-81ca-d05a90e54057&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=$SM$IPT6JNv2Nyob5wa3FzytkOp01Cp7hGFrEf5Gy%2bnGLcoBW8im4xglgba6IEPA3D6J&TARGET=$SM$https://indirect.sprint.com/indrestricted/nrgen" 
			     	  	id="carrierActivationSite" scrolling="yes">
					</iframe>
				</div>
			<cfelse>
				
			<div class="carrier-box">
				<cfset local.carrierID = application.model.checkoutHelper.getCarrier()/>
				<cfif local.carrierId eq "109"><!--- ATT --->
					<div style="position:absolute;top:10px;font-size:larger;font-weight:bold;text-align:center;font-size:x-large;color:red">
						Click to Proceed to Activation Portal
					</div>
					<div style="position:absolute;">
						<a rel="external-new-window"  href="http://opusld.att.com/opus/findhome.do">
							<img class="carrier" src="#assetPaths.common#images/content/rebatecenter/att.jpg" width="117" height="51"><br/><h3 align="center" class="carrier">Click for AT&T Activation</h3>
						</a>
					</div>
				<cfelseif local.carrierId eq "128"><!--- TMOBILE --->
					<div style="position:absolute;top:10px;font-size:larger;font-weight:bold;text-align:center;font-size:x-large;color:red">
						Click to Proceed to Activation Portal
					</div>
					<div style="position:absolute;">
						<a class="carrier" rel="external-new-window" href="https://quikview.t-mobile.com/mosaic/##/applications/QuikViewWeb">
							<img class="carrier" src="#assetPaths.common#images/content/rebatecenter/TM_authdealerlogo.jpg" width="150" height="25"><br/><h3 align="center" class="carrier">Click for T-Mobile</h3>
						</a>
					</div>
				<cfelseif local.carrierId eq "42"><!--- VERIZON --->
						<div style="position:absolute;top:10px;font-size:larger;font-weight:bold;text-align:center;font-size:x-large;color:red">
							Follow Below Instructions to Proceed to Activation Portal
						</div>
						<div>
							<img class="carrier" src="#assetPaths.common#images/carrierLogos/verizon_175.gif" /><br/>
						</div>
						<div style="position:absolute;bottom:10px;font-size:larger;font-weight:bold;text-align:center;">
							To activate customers for Verizon, copy and paste the link in the textbox into Internet Explorer
							<input onclick="this.select();" style="color:red" value="https://cim.verizonwireless.com/cimPreAuth/?mode=friendly&destinationURL=https://eroes-ss.west.verizonwireless.com/eroes/eROES.jsp" readonly/>
						</div>
				</cfif>
			</div>
		</cfif>
	</div>
			
	</form>
	
	
	<!-- Modal -->
	<div class="modal fade" id="confirmation" tabindex="-1" role="dialog"
	     aria-labelledby="confirmationLabel" aria-hidden="true">
		<div class="modal-dialog modal-custom">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">
							&times;
						</span>
					</button>
					<cfif local.hasActivationItems>
						<h2>
							Confirmation - <span style="font-size:x-large;font-weight:bold;color:red"> Make Sure the Device is ACTIVATED!</span>
						</h2>
					<cfelse>
						<h2>
							Confirmation
						</h2>
					</cfif>
				</div>
				<div class="modal-body">
					<table id="confirmInfo" class="confirmInfo">
						<tr>
							<td>
								Emp ID:
							</td>
							<td>
								<input id="employeeNumberInput" name="employeeNumberInput" onclick="this.select();" 
								       type='text' value='#session.VFD.employeeNumber#' style="margin:5px;" readonly/>
							</td>
							<td></td>
						</tr>
						<tr>
							<td>
								Kiosk ##:
							</td>
							<td>
								<input id="kioskNumberInput" name="kioskNumberInput" onclick="this.select();" type='text'
								       value='#session.VFD.kioskNumber#' style="margin:5px;" readonly/>
							</td>
							<td></td>
						</tr>
					<cfif ( local.hasActivationItems)>
						<tr>
							<td style="margin:5px;"></td>
							
							<td style="margin:5px;">Phone ##</td>
							<td style="margin:5px;width:20px;">&nbsp;</td>
							<td style="margin:5px;">Agreement ##</td>
							
							<td style="margin:5px;visibility:hidden;">
								<!---<cfset local.carrierID = application.model.checkoutHelper.getCarrier()/>
								<cfif local.carrierId eq "109"><!--- ATT --->
									Activation ##<a href="##" data-toggle="tooltip" title="This is AT&T's' Activation number returned on activation completion"><span class="glyphicon glyphicon-info-sign"></a>
								<cfelseif local.carrierId eq "128"><!--- TMOBILE --->
									Activation Code<a href="##" data-toggle="tooltip" title="This is T-Mobile's Activation code returned on activation completion"><span class="glyphicon glyphicon-info-sign"></a>
								<cfelseif local.carrierId eq "42"><!--- VERIZON --->
									Authorization Code<a href="##" data-toggle="tooltip" title="This is Verizon's' Authorization code returned on activation completion"><span class="glyphicon glyphicon-info-sign"></a>
								<cfelseif local.carrierId eq "299"><!--- SPRINT --->
									MSID<a href="##" data-toggle="tooltip" title="This is Sprint's Mobile Station ID returned on activation completion"><span class="glyphicon glyphicon-info-sign"></a>
								</cfif>--->
							</td>
							<td style="margin:5px;width:20px;">&nbsp;</td>
						</tr>
						<cfloop from="1" to="#arrayLen(local.cartLines)#" index="local.iCartLine">
							<cfset local.cartLine = local.cartLines[local.iCartLine]/>
							<cfset local.selectedPhone = application.model.phone.getByFilter(idList=local.cartLine.getPhone().getProductID(), 
							                                                                 allowHidden=true)/>
							<cfset OrderDetail = application.model.WirelessLine.getByOrderID(session.checkout.OrderId)/>                                                      
                                                            
							<tr>
								<td>
									Device 
									#local.iCartLine#  
									<input type="hidden" id="wirelessLineID#local.iCartLine#" name="wirelessLineID#local.iCartLine#" value="#OrderDetail[local.iCartLine].getWirelessLineId()#" />
								</td>
								
								<td>
									<div>
									( <input id="Phone_#local.iCartLine#_NumPt1" name="Phone_#local.iCartLine#_NumPt1" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('Phone_#local.iCartLine#_NumPt2'))" maxlength="3" style="width:40px;text-align:center;"/> )
									<input id="Phone_#local.iCartLine#_NumPt2" name="Phone_#local.iCartLine#_NumPt2" onKeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'');autotab(event, this, document.getElementById('Phone_#local.iCartLine#_NumPt3'))" maxlength="3" style="width:40px;text-align:center;"/> - 
									<input id="Phone_#local.iCartLine#_NumPt3" name="Phone_#local.iCartLine#_NumPt3" onkeyup="if (/\D/g.test(this.value)) this.value = this.value.replace(/\D/g,'')" maxlength="4" style="width:50px;text-align:center;"/>
									</div>
								</td>
								<td>&nbsp;</td>
								<td>
									<cfif local.cartline.getCartLineActivationType() contains 'financed'>
										<input id="finance#local.iCartLine#" name="finance#local.iCartLine#" 
									       class="finance" type='text' style="margin:5px;width:120px"/>
									<cfelse>
										<input id="finance#local.iCartLine#" name="finance#local.iCartLine#" 
									       class="finance" type='text' style="margin:5px;width:120px" value="NA" readonly/>
									</cfif>
								</td>
								
								<td style="visibility:hidden;width:0px;">
									<input id="activationID#local.iCartLine#" name="activationID#local.iCartLine#" 
									       class="activation" type='text' style="margin:5px;"/>
								</td>
								<td>&nbsp;</td>
							</tr>
						</cfloop>
					</cfif>
					</table>
					<br/>
					<!---<p>
						Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent et lorem suscipit sapien
						laoreet eleifend. Fusce tincidunt enim eu nibh venenatis tempor.
						Cras ultrices fermentum condimentum. Duis sit amet efficitur neque, sed vulputate augue. Sed
						interdum finibus pulvinar. Praesent leo odio, convallis eu
						massa quis, ornare maximus elit. Maecenas scelerisque in mi id consequat.
					</p>--->
				</div>
				<div id="buttonDiv" class="formControl">
					<a id="printConfirm" href="##" class="progressBtnLarge" style="text-decoration: none"
					   onclick="javascript: if(checkAll()){printConfirmation();setFinishVar();};printClicked();">
						<span>
							Print Order Confirmation
						</span>
					</a>
					<a id="finishConfirm" href="##" class="waitForActionBtn" style="text-decoration: none"
					   onclick="javascript: if(checkFinish()){var ok=confirm('This will complete the current transaction and clear all of the user and cart information. Are you sure you want to proceed?'); if(ok){closeCarrier(); location.href='/checkoutVFD/exitVFD'; }}">
						<span>
							Finish
						</span>
					</a>
				</div>
			</div>
		</div>
	</div>	
</div>
	<iframe src="#event.buildLink('checkoutVFD/printConfirmation')#" style="display: none" 
	        id="confirmationPrint">
	</iframe>
	
	<script type="text/javascript" src="#assetPaths.common#scripts/footerContentWindows.js">

	</script>
	
	<cfset cartDialogHTML = application.view.cart.addToCartDialogWindow()/>#trim(variables.cartDialogHTML)#
	<script type="text/javascript">
		function showProgress(message){
		    var msg = 'Processing, please wait.';
		    
		    try {
		        if (message.length > 0) {
		            msg = message;
		        }
		    } 
		    catch (e) {
		    }
		    
		    var messageEl = document.getElementById('progressLabel');
		    messageEl.innerHTML = msg;
		    var ldiv = document.getElementById('LoadingDiva');
		    ldiv.style.display = 'block';
		}
		function hideProgress(){
		    var ldiv = document.getElementById('LoadingDiva');
		    ldiv.style.display = 'none';
		}
	</script>
	<script type="text/javascript">
		var $j = jQuery.noConflict();
		var allowFinish = false;
		var allowPrint = false;
		var openModalClicked = false;
		var allActivated = true;
		var allFinanceAgreement = false;
		var allValidNums = false;
		var hasActivations = document.getElementById('isActivation').value;
		
		$j(document).ready(function($j){
		    $j('a[rel=external-new-window]').click(function(){
		        var h = $j(window).height();
		        var w = $j(window).width();
		        var posW = 1.1 * w;
		        carrierActivationWin = window.open(this.href, 'carrierActivationWin', 'width=' + w + ', height=' + h + ', top=0, left=' + posW + ', menubar=yes, toolbar=yes, resizable=1, scrollbars=1, personalbar=1');
		        return false;
		    });
		    //Updates db with newMDN and activationNum
		    $j('##finishConfirm').click( function( event ) {
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

		//Changes states of Print Order Confirmation and Finish Buttons
		function printClicked(){
		    if ((allValidNums==true && allActivated==true && allFinanceAgreement==true)||(!(hasActivations == "true"))) {
		        document.getElementById('printConfirm').classList.remove('progressBtnLarge');
		        document.getElementById('printConfirm').classList.add('waitForActionBtnLarge');
		        document.getElementById('finishConfirm').classList.remove('waitForActionBtn');
		        document.getElementById('finishConfirm').classList.add('progressBtn');
		    }
		};
		//Prints out confirmation on local printer.  Also checks to see if browser is IE and then executes IE specific print command 
		function printConfirmation(){
			var ms_ie = false;
   			var ua = window.navigator.userAgent;
    		var old_ie = ua.indexOf('MSIE ');
    		var new_ie = ua.indexOf('Trident/');

    		if ((old_ie > -1) || (new_ie > -1)) {
        		ms_ie = true;
   			 }
    		if ( ms_ie ) {
    			var iframe = document.getElementById('confirmationPrint');
        		iframe.contentWindow.document.execCommand('print', false, null);
    		}
    		else {
    			parent.document.getElementById('confirmationPrint').contentWindow.print();
    		}
		    
		};
		//Verifies that there are activations for each device
		function checkActivation(){
		    return allActivated;
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
		function setFinishVar(){
		    allowFinish = true;
		}
		//Prevents clicking on finish until order confirmation is printed
		function checkFinish(){
		    if (allowFinish == true) {
		        return true;
		    }
		    else {
		        alert("You must Print Order Confirmation before you can complete the process.");
		        return false;
		    }
		}
		//closes all popup windows that were created
		function closeCarrier(){
			window.close();
			winref = window.open('', 'carrierActivationWin', '', true);
 			winref.close();			
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
		//Checks to see if not accessory, then if activation numbers are entered, then if phone numbers are entered, then if all are valid, then if finance agreement is entered then allow to proceed
		function checkAll(){
			if(hasActivations == "true"){
				if(checkActivation()){	
					if(checkPhone()){
						if(checkFinanceAgreement()){
							if(allValidNums==true && allActivated==true && allFinanceAgreement==true){
							return true;
							}
							return false;
		 				}
		 				return false;
		 			}
		 			return false;
				}
				return false;
			}
			return true;
		}
	</script>
</cfoutput>