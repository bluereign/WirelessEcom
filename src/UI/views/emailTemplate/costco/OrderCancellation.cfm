<!--- values needed for template --->
<cfparam name="orderId" />

<!--- load objects to get values for template --->
<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
<cfset theOrderAddress = CreateObject('component', 'cfc.model.OrderAddress').init() />
<cfset theUser = CreateObject('component', 'cfc.model.User').init() />

<cfset theOrder.load(orderId) />
<cfset theUser.getUserById(theOrder.getUserId()) />
<cfset theShippingAddress = theOrder.getShipAddress() />


<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = theOrder.getEmailAddress() />
<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Order Cancellation" />

<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="wa_costcoHead.cfm" />
	
	<!--- template body --->
	<cfoutput>
		<tr>
			<td>
				<h1>
					<strong>Order Cancellation</strong>
				</h1>  
				<p>Dear #theShippingAddress.getFirstName()# #theShippingAddress.getLastName()#,</p>  
				<p>Thank you for your recent Costco.com purchase through Wireless Advocates.</p>  
				<p>
					This email is to let you know that your order <strong>#theOrder.getOrderId()#</strong> has been canceled and a credit will soon be issued to your credit card for the full amount of your 
					order. Processing time for your credit is dependant on the card processor and usually takes 2-3 business days. If you have any questions or concerns, please do not hesitate 
					to contact us at #application.wirebox.getInstance("ChannelConfig").getCustomerCarePhone()# Monday through Friday between 6:00 AM and 6:00 PM Pacific Standard Time.
				</p>  
				<p>We appreciate your business and look forward to assisting you in the future with your selection and purchase of a new phone and service plan.</p>  
				<p>Thank you for shopping with Wireless Advocates.</p>  
				<p>
					Costco.com<br />   
					Wireless Advocates<br />   
					<a href="mailto:#sendFrom#">#sendFrom#</a>
				</p>  
				<p>This is an automated e-mail. Please do not reply. If you have questions regarding your order please contact Customer Service at #application.wirebox.getInstance("ChannelConfig").getCustomerCarePhone()#.</p>  
				<p>
					<input id="gwProxy" type="hidden" /><!--Session data-->
					<input id="jsProxy" onclick="jsCall();" type="hidden" />
				</p>  
				<div firebugversion="1.5.4" id="_firebugConsole" style="display: none;">   &nbsp;</div>  
				<p><input id="gwProxy" type="hidden" /><!--Session data--><input id="jsProxy" onclick="jsCall();" type="hidden" /></p>  
				<p><input id="gwProxy" type="hidden" /><!--Session data--><input id="jsProxy" onclick="jsCall();" type="hidden" /></p>  
				<p><input id="gwProxy" type="hidden" /><!--Session data--><input id="jsProxy" onclick="jsCall();" type="hidden" /></p> 
			</td>
		</tr>
	</cfoutput>
	
	<!--- template foot --->
	<cfinclude template="wa_costcoFoot.cfm" />
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