<!--- values needed for template --->
<cfparam name="orderId" />

<!--- load objects to get values for template --->
<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
<cfset theOrderView = CreateObject('component', 'cfc.view.Order').init() />
<cfset theOrderAddress = CreateObject('component', 'cfc.model.OrderAddress').init() />
<cfset theUser = CreateObject('component', 'cfc.model.User').init() />

<cfset theOrder.load(orderId) />
<cfset theUser.getUserById(theOrder.getUserId()) />
<cfset theShippingAddress = theOrder.getShipAddress() />

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = theOrder.getEmailAddress() />
<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Order Confirmation" />

<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="emailHead.cfm" />
	
<!--- template body --->
	<cfoutput>
		<tr>
			<td colspan="2">
				<h1 style="font-family:Verdana, Geneva, sans-serif; color:##390;">We've Received Your Order</h1>
				<div>
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
						Dear #theShippingAddress.getFirstName()# #theShippingAddress.getLastName()#,
					</p>  
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
						Thank you for your recent PageMaster order.
					</p>
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
						Orders can take up to 3-5 business days to process before shipping.  Once it ships, you will receive an automated
						 email confirmation containing the tracking number so that you can monitor the progress of your shipment.
					</p>  
				</div>
		
				<!--- ORDER DETAILS --->
				<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
					#theOrderView.getOrderEmailView(theOrder)#
				</p>
		
				<div>
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
						Today your payment is for all equipment related charges, such as phones, devices, accessories, & 
						protection plans. The wireless carrier you have selected will bill you for the monthly service 
						plan. We are unable to accept payment for your wireless service plan.
					</p>   
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
						This is an automated email.  Please do not reply.  If you have questions or concerns, 
						please call toll-free at #application.wirebox.getInstance("ChannelConfig").getCustomerCarePhone()# Monday through Friday 6:00am to 6:00pm Pacific Time.
					</p>   
				</div>  
		<p>   
			<input id="gwProxy" type="hidden" /><!--Session data-->
			<input id="jsProxy" onclick="jsCall();" type="hidden" />
		</p>  
		<div firebugversion="1.5.3" id="_firebugConsole" style="display: none">   �</div>  
		<p>   
			<input id="gwProxy" type="hidden" /><!--Session data-->
			<input id="jsProxy" onclick="jsCall();" type="hidden" />
		</p>  
		<p>
			<input id="gwProxy" type="hidden" /><!--Session data-->
			<input id="jsProxy" onclick="jsCall();" type="hidden" />
		</p>  
		<p>
			<input id="gwProxy" type="hidden" /><!--Session data-->
			<input id="jsProxy" onclick="jsCall();" type="hidden" />
		</p>   
		</td>
		</tr>
		
	</cfoutput>
	</table>
</body>
</html>
	<!--- template foot --->
	<!--- <cfinclude template="emailFoot.cfm" /> --->
</cfsavecontent>

<!--- <cfoutput>
	#templateMessage#
</cfoutput>
<cfabort /> --->

<!--- mail the message --->
<cfmail to="#email#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>


