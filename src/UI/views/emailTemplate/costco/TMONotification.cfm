
<cfset local = {} />
<cfset xmlReturn = "" />
<cfset sendDebug = true />
<cfset bcc = "shamilton@wirelessadvocates.com;achappell@wirelessadvocates.com" />

<cfset debugTxt = 'TMONotification started #dateformat(now(),"mm/dd/yyyy")# at #timeformat(now(),"hh:mm:ss tt")#' />

<!---<cfstoredproc
dataSource = "TMOCommissions"
procedure = "[GetCustomerNotificationDetails]"
debug = "no"
result = "tmoOrders"
returnCode = "yes">--->

<cfquery name="tmoOrders" datasource="TMOCommissions">
	exec GetCustomerNotificationDetails
</cfquery>	
<cfset debugTxt = debugTxt & "<br/>Query tmoOrders return #tmoORders.recordcount# records" />

<cfloop query="tmoOrders">
	
<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = "#tmoOrders.emailAddress#" />

<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Order Received" />

<!--- Order specific info --->
<cfset thisOrder = "#tmoOrders.orderid#" />
<cfset dateplaced = #dateformat(tmoorders.orderDate, "mm/dd/yyyy")# />	
<cfset thisCustName = "#tmoOrders.firstName# #tmoorders.lastname#"/>
<cfset thisShipaddress = #tmoorders.address1# />
<cfif tmoOrders.address2 is not "">
	<cfset thisShipaddress = thisShipAddress & "<br/>" & tmoorders.address2 />
</cfif>	
<cfset thisShipaddress = thisShipAddress & "<br/>" & tmoorders.city  & "<br/>" & tmoorders.state & "  #tmoorders.zip#"/>

<cfset debugTxt = debugTxt & "<br/>Sending to #email# for #thisCustname# orderDate=#dateplaced#"/>


<cfset thisNote = "" />

<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="wa_costcoHead.cfm" />
<style type="text/css">
		td.tblHead { 
			background-color: #0099ff;
			color: white;
			font-weight: bold;
			padding: 5px;
		}	
		td.tblLabel { 
			background-color: lightblue;
			color: black;
			font-weight: bold;
			padding: 5px;
		}	
		td.tblData { 
			background-color: #eee;
			color: black;
			font-weight: normal;
			padding: 5px 5px 5px; 
			vertical-align: top;
		}
		div.custLetter {
			font-size:10pt;
			font-family:sans-serif;
		}

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
				</td>
			</tr>
			</table>
       		<table width="800" class="tblData" >
       			<tr>
       				<td width="10%" class="tblLabel">Order Number:</td>	
					<td width="15%"  class="tblData">#thisOrder#</td>	
					<td width="25%"  class="tblLabel">Shipping Address</td>
					<td width="25%"  class="tblLabel">Note:</td>					
       			</tr>
       			<tr>
       				<td class="tblLabel"><B>Date Placed:</B></td>	
					<td class="tblData">#datePlaced#</td>	
					<td class="tblData" style="font-weight: bold;">												
						#thisShipaddress#
					</td>
					<td class="tblData">#ThisNote#</td>					
       			</tr>				
       		</table>
		</td></tr>	
		
		<tr>
			<td colspan="2" class="custletter" style="padding:10px;">
<div class="custLetter">			
<p>Dear #thisCustName#,</p>

<p>Thank you for ordering your device from T-Mobile.  Estimated delivery for your device will be as indicated in your order 
confirmation and your device will be sent directly from T-Mobile.</p>

<p>As a Costco member, you are entitled to additional member benefits with your T-Mobile device purchase including:</p>

<p><b>Free Accessory Bonus Pack</b> - You will receive your free accessory bonus pack and $25 Costco Cash Card within 10 business 
days from Stuart Lee Rebates Processing Center.</p> 

<div style="marging:0 auto;">
<div style="margin-left: 50px">
<p>To check the status please visit StuartLeeRebates.com and follow these simple instructions:</p>
<ol>
<li>Enter company through which you made your purchase from T-Mobile: Costco</li>
<li>Enter billing zip code associated with your purchase.</li>
<li>Enter wireless number associated with your purchase.</li>
</ol>
</div>
</div>

<p>As a reminder, with any Costco wireless purchase you may exchange or return your device within 90 days from the 
original purchase date.  To take advantage of this benefit, please call (888)369-5931 to expedite your return or 
exchange.  Returns and exchanges should not be processed through T-Mobile</p>

<p>If you have additional questions or concerns, please call toll-free (888) 369-5931 or email us at 
CostcoOnlineSupport@wirelessadvocates.com. Customer Service representatives are available Monday through 
Friday 6:00am to 6:00pm Pacific Time.</p>

<p>Thank you for shopping with Costco and Wireless Advocates.</p>
</div>
</td>
</cfoutput>
</table>
</body>
</html>
</cfsavecontent>

<!---<cfoutput>#templateMessage#</cfoutput>---><!---Uncomment for debugging styling --->

<!--- mail the message --->
<cftry>
<cfmail to="#email#"
		bcc="#bcc#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>
<cfset xmlReturn = xmlReturn & '<Customer EmailAddress="#email#" OrderId="#thisOrder#" EmailSent="1" />' />
<cfcatch type="any">
	<cfset xmlReturn = xmlReturn & '<Customer EmailAddress="#email#" OrderId="#thisOrder#" EmailSent="0" />' />
</cfcatch>
</cftry>
</cfloop>

<!--- wrap the xml with a root tag --->
<cfset xmlReturn = "<root>" & xmlReturn & "</root>" />


<!--- send the results back to be logged --->
<cfstoredproc
dataSource = "TMOCommissions"
procedure = "[UpdateCustomerNotificationDetails]"
debug = "no"
result = "TMOEmailUpdate"
returnCode = "yes">
<cfprocparam variable="xml" type="in" cfsqltype="cf_sql_varchar" value='#xmlReturn#' />
</cfstoredproc>

<cfif sendDebug is true>
<cfmail from="#sendfrom#" type="html" to="#bcc#" subject="TMO Notification Debug Info for #dateformat(now(),'mm/dd/yyy')# #timeformat(now(),'hh:mm:ss tt')#" >
#debugTxt#	
</cfmail>	
</cfif>
