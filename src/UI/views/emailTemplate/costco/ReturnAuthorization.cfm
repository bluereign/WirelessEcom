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
	<cfinclude template="wa_costcoHead.cfm" />
	
	<!--- template body --->
	<cfoutput>
		<tr>
			<td colspan="2">
			<h1>
				<strong>Return Authorization Form</strong>
			</h1>  
			<div>
				<p>Dear #theShippingAddress.getFirstName()# #theShippingAddress.getLastName()#,</p>
				<p>Please return this form for each item you are returning. 
				Returns and contract reversals may take up to 2 weeks to process once the shipment has been received. 
				If you have any questions, contact customer service at  #phoneNumber#.</p>  
				<!---<p>Please return this form for each item you are returning. Returns may take up to 2 weeks to process once the shipment has been received. 
					If you have any questions, contact customer service at 1-888-369-5931.</p> ---> 
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
		<tr>
			<td colspan="2">
				<div>
					<p>Thank you for your business.</p>   
					<p>
						Costco.com<br />
						Wireless Advocates<br /> 
						<a href="mailto:#sendFrom#" title="mailto:#sendFrom#">#sendFrom#</a>
					</p>  
				</div>
				<p>Please do not reply to this email. If you have questions regarding your order please contact customer at #phoneNumber#.</p>  
			</td>
		</tr>
	</cfoutput>
	
	<!--- template foot --->
	<!--- <cfinclude template="wa_costcoFoot.cfm" /> --->
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
