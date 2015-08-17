<!--- values needed for template --->
<cfparam name="orderDetailId" />

<!--- load objects to get values for template --->
<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
<cfset theOrderDetail = CreateObject('component', 'cfc.model.OrderDetail').init() />
<cfset theOrderAddress = CreateObject('component', 'cfc.model.OrderAddress').init() />
<cfset theUser = CreateObject('component', 'cfc.model.User').init() />
<cfset theUtil = CreateObject('component', 'cfc.model.Util').init() />
<cfset theWirelessLine = CreateObject('component', 'cfc.model.WirelessLine').init() />

<cfset theOrderDetail.load(orderDetailId) />
<cfset theOrder.load(theOrderDetail.getOrderId()) />
<cfset theUser.getUserById(theOrder.getUserId()) />
<cfset theShippingAddress = theOrder.getShipAddress() />
<cfset theWirelessLineOrder = theWirelessLine.getByOrderId(theOrderDetail.getOrderId()) />

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = theOrder.getEmailAddress() />
<cfset bcc = sendBcc />
<cfset phoneNumber = request.config.customerServiceNumber />
<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Return Authorization Form" />

<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="emailHead.cfm" />
	
	<!--- template body --->
	<cfoutput>
		<tr>
			<td colspan="2">
			<h1>
				<strong>Return Authorization Form</strong>
			</h1>  
			<div>
				<p>Dear #theShippingAddress.getFirstName()# #theShippingAddress.getLastName()#,</p>
				<p>Greetings from PageMaster.</p>
				<p>We are sorry to hear you are not fully satisfied with your recent purchase.  Please print and return this form with the item you are returning. 
				Once received at our distribution center, we will refund the full purchase price to your credit card.  Once the shipment has been received, returns may take up to 2 weeks to process.</p>
				<p>Thank you,</p>
				<p>Order Processing</p> 
				<p>This is an automated email. Please do not reply. If you have questions or concerns, please call toll-free at #application.wirebox.getInstance("ChannelConfig").getCustomerCarePhone()# Monday through Friday 6:00am to 6:00pm Pacific Time.</p> 				
			</div>  
			<table border="0" cellpadding="0">
				<tbody>
					<tr>
						<td>
							<p>Order Number:</p>     
						</td>     
						<td>
							<p>#theOrder.getOrderId()#</p>     
						</td>    
					</tr>    
					<tr>
						<td>
							<p>Order Date:</p>     
						</td>     
						<td>      
							<p>#DateFormat(theOrder.getOrderDate(), "mm/dd/yyyy")#</p>
						</td>    
					</tr>   
				</tbody>  
			</table>
			<table border="0" cellpadding="0" style="width: 990px;" width="990">
				<tbody>
					<tr>     
						<td style="width: 980px;">      
							<p><strong><strong>RMA: #theOrderDetail.getRmaNumber()#</strong></strong></p>
						</td>    
					</tr>    
					<tr>     
						<td>      
							<p>Phone Type: #theOrderDetail.getProductTitle()# </p>     
						</td>    
					</tr>    
					<tr>     
						<td>      
							<p>Customer Service Representative: #theOrder.getUserId()#</p>     
						</td>    
					</tr>
					<cfif theOrderDetail.getOrderDetailType() eq 'd'>
						<tr>     
							<td>      
								<p>Hardware Number: #theWirelessLineOrder[1].getIMEI()#</p>
							</td>    
						</tr>  
					</cfif>  
					<tr>     
						<td>
							<p>Delivery Document Number SO##: #theOrder.getGERSRefNum()#</p>     
						</td>    
					</tr>    
					<tr>     
						<td>      
							<p>       
								GERS ID: #theUtil.convertToGersId(theOrder.getUserId())#
							</p>     
						</td>    
					</tr>   
					<tr>     
						<td>      
							<p>Customer Address</p>
						</td>    
					</tr>    
					<tr>
						<td>
							<p>#theShippingAddress.getFirstName()# #theShippingAddress.getLastName()#</p>
						</td>    
					</tr>    
					<tr>     
						<td>      
							<p>#theShippingAddress.getAddress1()#</p>     
						</td>
					</tr>
					<tr>
						<td>
							<p>#theShippingAddress.getCity()#, #theShippingAddress.getState()# #theShippingAddress.getZip()#</p>
						</td>    
					</tr>    
					<tr>     
						<td>      
							<p>#theShippingAddress.getDaytimePhone()#</p>     
						</td>    
					</tr>    
					<tr>
						<td>      
							<p></p>     
						</td>    
					</tr>
					<tr>     
						<td>      
							<p>Reason For Return: #theOrderDetail.getRMAReason()#</p>
						</td>    
					</tr>  
				</tbody>  
			</table>  
			</td>
		</tr>
	</cfoutput>
	
	<!--- template foot --->
	<!--- <cfinclude template="emailFoot.cfm" /> --->
</cfsavecontent>

<!--- FOR TESTING 
<cfoutput>
	<P>EMAIL: #email#</P>
	#templateMessage#
</cfoutput>
<cfabort />
--->


<!--- mail the message --->
<cfmail to="#email#"
		bcc="#bcc#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>
