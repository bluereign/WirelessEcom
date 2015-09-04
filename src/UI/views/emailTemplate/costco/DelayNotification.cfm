<cfset allocation = createObject('component', 'cfc.model.Allocation').init() />
<cfset orderDetailLog = CreateObject( "component", "cfc.model.OrderDetailLog" ).init() />
<cfset sendFrom = application.wirebox.getInstance("ChannelConfig").getCustomerCareEmail() />
<cfset subject = "Your Order has Been Delayed" />

<cfset ResultEmailBody = "<b>Delay Notification Processing Results:</b><br/>"/>
<cfset ResultEmailBody = ResultEmailBody & "<br/>Server Name: #ucase(SERVER_NAME)#" />
<cfset ResultEmailBody = ResultEmailBody & "<br/>Date/Time Started: #dateformat(now(),'mm/dd/yy')# #timeformat(now(),'hh:mm:ss')#"/>

<cfset allDone = false />

<!--- get a list of all blocks that have had the processing date modified since the last run (processDate > prevProcessDate) --->
<cfset blockids = allocation.getModifiedProcessDateBlockIds() />
<cfif listlen(blockids) is 0>
	<cfset ResultEmailBody = ResultEmailBody & "<br/>There are no blocks with process date changes."> <!--- nothing to do, so stop --->
	<cfset allDone = true />
<cfelse>
	<cfset ResultEmailBody = ResultEmailBody & "<br/>Modified blocks: #blockids#" />
</cfif>

<!--- Find all of the orders --->
<cfif not allDone>
	<cfquery name="qOrders" datasource="wirelessAdvocates" >
		SELECT DISTINCT orderid from salesorder.orderdetail od JOIN catalog.gersstock gs
		ON od.orderdetailid = gs.orderdetailid 
		WHERE gs.blockid in (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="yes" value="#blockids#">)
	</cfquery>	
	<cfif qOrders.recordcount is 0>
		<cfset ResultEmailBody = ResultEmailBody & "<br/>There are no orders affected by process date changes"> <!--- nothing to do, so stop --->
		<cfset allDone = true />
	<cfelse>
		<cfset ResultEmailBody = ResultEmailBody & "<br/>Affected orders: #valuelist(qorders.orderid)#" />	
	</cfif>
</cfif>

<cfif not allDone>
	<cfloop query="qorders">
		
		<cfset doNotify = true />
		
		<!--- Get the orderid and orderdetailis for the order and the max orderdetailLogId --->
		<cfset orderid = qOrders.orderid />
		<cfset orderDetailIds = allocation.getAllocatedItems(orderid) />
		<cfset orderProcessDate = allocation.getLatestProcessDate(orderId) />
		<cfif isDate(orderProcessDate)>
			<cfset DelayDateMsg = dateformat(orderProcessDate,"mm/dd/yyyy") & " and " & dateformat(dateadd('d', 2, orderProcessDate),'mm/dd/yyyy') />
		<cfelse>
			<cfset DelayDateMsg = "" />
			<cfset doNotify = false />
		</cfif>
		<cfset logDate = "n/a" />
		
		<cfquery name="qOrderDetailLog" datasource="wirelessadvocates"  > 
			SELECT max(orderDetailLogId) as maxODId from service.orderDetailLog	
			where orderdetailId in (<cfqueryparam cfsqltype="cf_sql_integer" value="#orderDetailIds#" list="true" > )
			AND type = 'VI Notify'	
		</cfquery>
		<cfif isNumeric(qOrderDetailLog.maxODId)>
			<cftry>
				<cfquery name="qLogDate" datasource="wirelessadvocates"  > 
					SELECT [log].value('(/VIOrderItem/processDate/node())[1]', 'date') as processDate FROM service.orderdetailLog
					WHERE orderDetailLogId = #qOrderDetailLog.maxODId#
				</cfquery>		
				<cfif isDate(qLogDate.processDate)>
					<cfset logDate = dateformat(qLogDate.processDate,"mm/dd/yyyy") />
					<cfif datecompare(qLogDate.processDate,orderProcessDate,'d') is not -1>
						<cfset doNotify = false />
					</cfif>  
				</cfif>
				<cfcatch type="any">
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfoutput>Orderid=#orderid#(#orderdetailids#) orderDate=#dateformat(orderProcessDate,'mm/dd/yyyy')# <cfif isdate(logdate)>LogDate=#dateformat(logDate,'mm/dd/yyyy')#</cfif> DoNotify=#doNotify#<br/></cfoutput>
		
	<cfif doNotify is true>
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
		
		<!--- allocation related variables for pre-sale / backorder --->
		<cfset isAllocatedOrder = allocation.isAllocatedOrder(orderid) />
		
		<cfsavecontent variable="templateMessage">
			<!--- template head --->
			<cfinclude template="wa_costcoHead.cfm" />
			
		<!--- template body --->
			<cfoutput>
				<tr>
					<td colspan="2">
						<h1 style="font-family:Verdana, Geneva, sans-serif; color:##390;">Your Order has Been Delayed</h1>
						<div>
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
								Dear #theShippingAddress.getFirstName()# #theShippingAddress.getLastName()#,
							</p>  
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
								Thank you for your recent Costco.com/Wireless Advocates #application.wirebox.getInstance("ChannelConfig").getPresaleVerbiage()# order! 
								We are sorry to tell you that due to the high demand, your order has been delayed. 
								We are currently working to get you your device as quickly as possible and rest assured that 
								by ordering with us you are guaranteed the device you want!
							</p>
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
								What to Expect Now:
							</p>  
						</div>
						<div>
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333333;">
								Since your order contains a #application.wirebox.getInstance("ChannelConfig").getPresaleVerbiage()# device your order will be processed and shipped 
								between the following dates #DelayDateMsg#.  Once it ships, you will 
								receive an automated email confirmation containing the tracking number so that you 
								can monitor the progress of your shipment.
							</p>   
							<!---<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
								As an apology, please use this coupon to receive 10% off any accessories on our site, just enter 
								this code <enter code here> at checkout to receive your discount. Again, we are sorry for any 
								inconvenience and we will continue to update you on your order status.
							</p>--->   
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
								Thank you for shopping with Costco.com. 
							</p>   
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
								Costco.com<br />
								Wireless Advocates<br /> 
								<a href="mailto:#sendFrom#" title="#sendFrom#">#sendFrom#</a>
							</p>
							<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px; color:##333;">
								This is an automated email.  Please do not reply.  If you have questions or concerns, please email us 
								at  #application.wirebox.getInstance("ChannelConfig").getCustomerCareEmail()# or call toll-free at #application.wirebox.getInstance("ChannelConfig").getCustomerCarePhone()# 
								Mon-Fri 6am - 6pm Pacific Standard Time.
							</p>    
						</div>  
<!---				<p>   
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
				</p>  ---> 
				</td>
				</tr>
				
			</cfoutput>
			</table>
		</body>
		</html>
			<!--- template foot --->
			<!--- <cfinclude template="wa_costcoFoot.cfm" /> --->
		</cfsavecontent>
		
		 <!---<cfoutput>
			#templateMessage#
		</cfoutput>--->
	
			
		<!--- mail the message --->
		<cfmail to="#email#"
		        from="#sendFrom#"
		        subject="#subject#"
				bcc="shamilton@wirelessadvocates.com"
		        type="html">
		    #templateMessage#
		</cfmail>
		
		<!--- If this is an Allocated order, create an entry in the service.orderDetailLog --->
		<cfset xmlStr ='<?xml version="1.0" encoding="UTF-8"?>'  &
			 '<VIOrderItem>' &
			 '<notifyType>Delay Notification</notifyType>' &
			'<processDate>#dateformat(allocation.getLatestProcessDate(orderid),"mm/dd/yyyy")#</processDate>' &
			'</VIOrderItem>' />
			
		<cfset orderDetailIds = allocation.getAllocatedItems(orderid) />
		
		<cfloop list="#orderDetailIds#" index="od">
			<cfset orderDetailLog = CreateObject( "component", "cfc.model.OrderDetailLog" ).init(
				 	orderDetailId = #od#
			      , type = "VI Notify"
			      , log = xmlStr) />	
			<cfset orderDetailLog.save() />
		</cfloop>		
		<cfset ResultEmailBody = ResultEmailBody & "<br/>Notified: #email# - OrderId:#orderid#(#orderdetailids#) orderDate=#dateformat(orderProcessDate,'mm/dd/yyyy')#" />	

	</cfif>
	</cfloop>
</cfif>

<!--- Update the allocation.block table and set the prevProcessDate = processDate --->
<cfquery name="qUpdateBlocks" datasource="wirelessadvocates"  > 
	update allocation.block set prevProcessDate = processDate where prevProcessDate != processDate
</cfquery>

<!--- Send a job confirmation email --->
<cfset ResultEmailBody = ResultEmailBody & "<br/>Date/Time completed: #dateformat(now(),'mm/dd/yy')# #timeformat(now(),'hh:mm:ss')#"/>
<cfset ResultEmailBody = ResultEmailBody & "<br/><br/>Processing completed."/>

<cfset jobresultslist="shamilton@wirelessadvocates.com,smorrow@wirelessadvocates.com,AGiles@wirelessadvocates.com" />
<!---<cfset jobresultslist="shamilton@wirelessadvocates.com" />--->
<cfmail to="#jobresultslist#"
        from="#sendFrom#"
        subject="Delay Notification Results for #application.wirebox.getInstance('ChannelConfig').getDisplayName()#" 
        type="html">
    #ResultEmailBody#
</cfmail>
