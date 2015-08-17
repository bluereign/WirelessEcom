<cfset assetPaths = application.wirebox.getInstance("assetPaths")/>
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig")/>
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker")/>
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker")/>
<!---<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>--->

<cfinclude template="/views/emailTemplate/costco/wa_costcoHead.cfm" />

<cfsetting showDebugOutput="No">

<cfset allocation = createObject('component', 'cfc.model.Allocation').init() />
<cfset local = {} />

<!--- values needed for template --->
<!---<cfparam name="orderId" default=session.checkout.OrderId/>--->
<cfset orderId = session.checkout.OrderId/>

<!--- load objects to get values for template --->
<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
<cfset theOrderView = CreateObject('component', 'cfc.view.Order').init() />
<cfset theOrderAddress = CreateObject('component', 'cfc.model.OrderAddress').init() />
<cfset theUser = CreateObject('component', 'cfc.model.User').init() />
<cfset theOrder.load(orderId) />
<cfset theUser.getUserById(theOrder.getUserId()) />
<cfset local.shipAddress = theOrder.getShipAddress() />
<cfset local.note = ""	/>

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = theOrder.getEmailAddress() />
<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Your Costco.com Order Was Received" />
	<style>
	table.tblData { font-size: 100%;}	
		.custletter { font-size: 100%;}
		
	</style>
<!--- template body --->
<cfoutput>					
<div id="main">

       	<tr colspan="2"><td>
       		<table width="800" cellpadding="0">
       		<tr>
       			<td align="left" valign="middle" width="25%"><h3>Order Received</h3></td>
				<td width="35%">&nbsp;</td>
				<td align="left" width="40%">
					<span class="bluetext" style="fontsize:80%; font-weight: bold; margin:0; padding:0;">STEPS FOR YOUR ORDER:</span>
					<hr style="margin:0; padding:0;"></hr>
					<span style="font-size: 75%; color:black;font-weight: bold;">1. Order Received&nbsp;&nbsp;&nbsp;&nbsp;</span><span color="##eee" style="font-size: 75%;">2. Sent to Fulfillment&nbsp;&nbsp;&nbsp;&nbsp;3. Shipped</span>
					<hr class="bluetext;font-size: 75%;"></hr><br/>
				</td>
			</tr>
			</table>
       		<table width="800" class="tblData" >
       			<tr>
       				<td width="10%" class="tblLabel">Order Number:</td>	
					<td width="15%"  class="tblData">#theOrder.getOrderid()#</td>	
					<td width="25%"  class="tblLabel">Shipping Address</td>
					<td width="25%"  class="tblLabel">Note:</td>					
       			</tr>
       			<tr>
       				<td class="tblLabel"><B>Date Placed:</B></td>	
					<td class="tblData">#dateFormat(theOrder.getOrderDate(), 'mm/dd/yyyy')#</td>	
					<td class="tblData" style="font-weight: bold;">												
						#local.shipAddress.getFirstName()# #local.shipAddress.getLastName()#<br />
						<cfif len(trim(local.shipAddress.getCompany()))>
							#local.shipAddress.getCompany()#<br />
						</cfif>
						#local.shipAddress.getAddress1()#<br />
						<cfif len(trim(local.shipAddress.getAddress2()))>
							#local.shipAddress.getAddress2()#<br />
						</cfif>
						<cfif len(trim(local.shipAddress.getAddress3()))>
							#local.shipAddress.getAddress3()#<br />
						</cfif>
						#local.shipAddress.getCity()#, #local.shipAddress.getState()# #local.shipAddress.getZip()#
					</td>
					<td class="tblData">#local.note#</td>					
       			</tr>				
       		</table>
		</td></tr>	
		
		<tr>
			<td colspan="2" class="custletter" style="padding:10px;">
				<p>Dear #local.shipAddress.getFirstName()# #local.shipAddress.getLastName()#,</p>
				Thank you for ordering from <a href="http://www.costco.com">Costco.com</a>. We have received the order and, after processing it, will send it to the fullfillment facility.
				<br/>Please keep this for your records.				 
			</td>
		</tr>
		<tr>	
			<td colspan="2"style="border-left-color: ##cccccc; border-left-style: solid; border-left-width: 1px; margin-bottom: 2px; padding:0;">
			<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
				#theOrderView.getOrderEmailView_costco(theOrder)#
			</p>	
			</td>				
		</tr>				
	</cfoutput>
	</table>
</body>
</html>