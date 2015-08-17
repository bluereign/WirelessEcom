<!--- set a long timeout --->
<cfsetting requesttimeout="99999" />
<cfparam name="URL.days" type="integer" default="5" />
<cfset url.days = abs(url.days) * -1 />

<!--- Set up some variables for the results email --->
<cfset sendFrom = application.wirebox.getInstance("ChannelConfig").getCustomerCareEmail() />
<cfset ResultEmailBody = "<b>SMS Opt-In Order Processing Results:</b><br/>"/>
<cfset ResultEmailBody = ResultEmailBody & "<br/>Server Name: #ucase(SERVER_NAME)#" />
<cfset ResultEmailBody = ResultEmailBody & "<br/>Date/Time Started: #dateformat(now(),'mm/dd/yy')# #timeformat(now(),'hh:mm:ss')#"/>"
<cfset ResultEmailBody = ResultEmailBody & "</br>Days: #abs(url.days)#" />


<!--- the days variable specifies how many days backwards to look --->
<cfset startDate = dateformat(dateAdd("d",url.days,now()),"mm/dd/yyyy") />
<cfset ResultEmailBody = ResultEmailBody & "</br>Scanning orders from #startdate# - #dateformat(now(),'mm/dd/yyyy')#" />


<!--- Get a list of orders that have opted in AND have been activated --->
<cfquery name="qOptInOrders" datasource="wirelessadvocates"  > 
SELECT COALESCE(WL.NewMdn, WL.CurrentMdn) AS PhoneNumber
	   ,O.OrderId
	   ,O.ActivationType
       ,O.CarrierId
       ,O.OrderDate
       ,C.SmsMessage AS [Message]
       ,CONVERT(date, GETDATE()) AS RunDate
       ,'' AS SmsMessageId
       ,0 AS ResultCode
       ,'' AS Result
       ,OD.OrderDetailId
FROM salesorder.[Order] O
       INNER JOIN salesorder.OrderDetail OD
              ON O.OrderId = OD.OrderId
       INNER JOIN salesorder.WirelessLine WL
              ON OD.OrderDetailId = WL.OrderDetailId
       INNER JOIN campaign.Campaign C
              ON O.CampaignId = C.CampaignId
WHERE [Status] = 3
	   AND o.gersstatus = 3
	   AND o.orderdate > = '#startDate#'
       AND SmsOptIn = 1
       AND COALESCE(WL.NewMdn, WL.CurrentMdn) IS NOT NULL
       AND NOT EXISTS (SELECT * FROM campaign.SmsMessage WHERE OrderDetailId = OD.OrderDetailId)
</cfquery>	

<cfset ResultEmailBody = ResultEmailBody & "<br/>Query found #qOptInOrders.recordcount# orders for processing."/>

<cfif qOptInOrders.recordcount gt 0>
	<cfset ResultEmailBody = ResultEmailBody & "<br/>&nbsp;<br/><table border=1 cellpadding=2><tr bgcolor='eeeeee'>" & 
			"<th>Order</th>" & 
			"<th>OrderDetail</th>" & 
			"<th>Carrier</th>" &
			"<th>Phone Number</th>" & 
			"<th>OrderDate</th>" & 
			"<th>Activate Type</th>" & 
			"<th>Run Date</th>" & 
			"<th>Message</th>" & 
		"</tr>" />
</cfif>
		
<cfloop query="qOptInOrders">
	
	<!--- Set the run date and make sure it is now earlier than NOW --->
	<cfif ActivationType is "N">
		<cfset SendDate = dateadd("d",1,now()) />
	<cfelse>
		<cfset SendDate = dateadd("d",7,now()) />
	</cfif>	
	<cfset SendDate = dateformat(sendDate,"mm/dd/yyyy") />
	
	<!--- Make sure the phone number is not blank --->
	<cfif phoneNumber is "">
		<cfset phoneNumber = "MISSING" />
	</cfif>
	
	<!--- Format the results line for email --->
	<cfset ResultEmailBody = ResultEmailBody & "<tr>" & 
		"<td>#orderid#</td>" & 
		"<td>#OrderDetailId#</td>" & 
		"<td>#CarrierId#</td>" & 
		"<td><cfif len(phoneNumber)>#PhoneNumber#<cfelse></cfif></td>" & 
		"<td>#dateformat(orderDate,'mm/dd/yyyy')#</td>" & 
		"<td>#activationType#</td>" & 
		"<td>#sendDate#</td>" & 
		"<td>#message#</td>" & 
		"</tr>" />
		
		<!--- Insert the record into the sms table --->
		<cfif phoneNumber is not "MISSING">
			<cfscript>
				smsSvc = getSmsMessageService();
				smsMsg = createObject('component','cfc.model.system.sms.SmsMessage').init( 	
					"0"				// message id
				   	,phoneNumber 	// phone number
				   	,carrierid		// carrier id
					,message		// message
					,sendDate		// runDate
					);
					
				smsMsg.setOrderDetailId(orderDetailId);						
				smsSvc.createNewSmsMessage(smsMsg);						
			</cfscript>
		</cfif>	
</cfloop>

<cfif qOptInOrders.recordcount gt 0>
	<!--- Close up the table --->
	<cfset ResultEmailBody = ResultEmailBody & "</table>" />
</cfif>

<cfset jobresultslist="shamilton@wirelessadvocates.com,smorrow@wirelessadvocates.com,sgrant@wirelessadvocates.com" />
<!---<cfset jobresultslist="shamilton@wirelessadvocates.com" />--->
<cfmail to="#jobresultslist#"
        from="#sendFrom#"
        subject="SMS Opt-In Order Processing Results for #SERVER_NAME#" 
        type="html">
    #ResultEmailBody#
</cfmail>

<cffunction name="getSmsMessageService" access="public" output="false" returntype="cfc.model.system.sms.SmsMessageService">
		
		<cfscript>
			var smsMessageService = '';
						
			if ( application.wirebox.containsInstance('SmsMessageService') )
			{
				smsMessageService = application.wirebox.getInstance('SmsMessageService');
			}
			
			if (!IsDefined('smsMessageService'))
			{
				smsMessageService = CreateObject('component', 'cfc.model.system.sms.SmsMessageService').init();
			}
		</cfscript>
		
    	<cfreturn smsMessageService />
</cffunction>
