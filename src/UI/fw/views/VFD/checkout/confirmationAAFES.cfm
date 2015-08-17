<cfsetting showDebugOutput="No">
<!--- values needed for template --->
<cfset orderId = session.checkout.OrderId/>

<!--- load objects to get values for template --->
<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
<cfset theOrderView = CreateObject('component', 'cfc.view.Order').init() />
<cfset theOrderAddress = CreateObject('component', 'cfc.model.OrderAddress').init() />
<cfset theUser = CreateObject('component', 'cfc.model.User').init() />

<cfset theOrder.load(orderId) />
<cfset theUser.getUserById(theOrder.getUserId()) />
<cfset theShippingAddress = theOrder.getShipAddress() />

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->

<!---<cfset email = theOrder.getEmailAddress() />--->

<cfset sendFrom = "emcsupport@wirelessadvocates.com" />
<cfset phoneNumber = request.config.customerServiceNumber />
<cfset subject = "Order Confirmation" />
<!--- A clean way to handle differing servers and ports --->
<cfset domain = cgi.SERVER_NAME />
<cfif cgi.SERVER_PORT NEQ 80>
	<cfset domain &= ":" & cgi.SERVER_PORT />
</cfif>

<!---<cfsavecontent variable="templateMessage">--->
	<!--- template head --->
	<cfinclude template="/views/emailTemplate/aafes/emailHead.cfm" />
	
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
						Thank you for placing your Wireless Advocates order with Exchangemobilecenter.com. We appreciate your business 
						and are pleased that you chose to shop with us.
					</p>
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
						Below are the details of your order:
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
						You will receive an email with your tracking information once your order has been shipped.
					</p>   
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
						Remember to visit our <a href="http://#domain#/index.cfm/go/content/do/militaryDiscountPage">Military Discount Page</a> to view all discounts available to you.
					</p>   
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
						Thank you for your business.
					</p>   
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
						Exchangemobilecenter.com<br />
						Wireless Advocates<br /> 
						<a href="mailto:#sendFrom#" title="#sendFrom#">#sendFrom#</a>
					</p>
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
						If you have questions regarding your order please contact customer 
						service at #phoneNumber#.
					</p>    
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
						Orders take up to three business days to process before shipping
					</p>   
					<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
						Remember Exchangemobilecenter.com and Wireless Advocates for all your accessory shopping as well!<br />
					</p>  
				</div>  
		<p>   
			<input id="gwProxy" type="hidden" /><!--Session data-->
			<input id="jsProxy" onclick="jsCall();" type="hidden" />
		</p>  
		<div firebugversion="1.5.3" id="_firebugConsole" style="display: none"></div>  
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
<!---</cfsavecontent>--->

<!--- mail the message --->
<!---<cfmail to="#email#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>--->
