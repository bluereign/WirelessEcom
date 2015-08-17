<!doctype html>
<cfparam name="action" default="" />
<cfparam name="orderid" default="" />
<cfparam name="forceIMEI" default="" />
<html>
<head>
		<title>SMS Unit Test Page</title>
	
		<link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css" type="text/css" media="all" /> 
		<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.5.min.js" type="text/javascript"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js" type="text/javascript"></script>
		<script>
		$( document ).ready(function() {
			$( "#accordion" ).accordion();
		});	
		</script>	
</head>

<body>
	
<cfif action is "createSMS">
	
	<cfscript>
		order = CreateObject('component', 'cfc.model.Order').init();
		order.load( orderId );
		if (application.wirebox.containsInstance("CampaignService")) {
			campaignService = application.wirebox.getInstance("CampaignService");
		}

		if (order.getSmsOptIn()) {
			wl = order.getWirelessLines();
			smsSvc = getSmsMessageService();
			acType = order.getActivationType();
			if (acType == 'N') {
				smsDateOffset = 1;
			} else {
				smsDateOffset = 5;
			}
			smsDate = dateAdd('d',smsDateOffset, now());
			campaign = campaignService.getCampaignById(order.getCampaignid());
			for (i=1; i<=arraylen(wl);i++) {
				smsMDN = wl[i].getCurrentMDN();
				if (smsMDN is "") {
					smsMDN = wl[i].getNewMDN();
				}
				if (smsMDN is "") {
					SMSResultCode = -1;
					SMSResult = "MDN Missing";
				}
				smsMsg = createObject('component','cfc.model.system.sms.SmsMessage').init( 	
										"0"												// message id
									   	,smsMDN 										// phone number
									   	,order.getCarrierId()							// carrier id
										,campaign.getSmsMessage()						// message
										,smsDate										// runDate
										);
				if (isdefined("SMSResult") and len(SMSResult)) {
					smsMsg.setResultCode(SMSResultCode);
					smsMsg.setResult(SMSResult);
				}
				smsMsg.setOrderDetailId(wl[i].getOrderDetailId());
				smsSvc.createNewSmsMessage(smsMsg);						
			}	
		}
	</cfscript> 	
	<cfoutput>
		Phone: #smsMdn#<br/>
		Carrier: #order.getCarrierId()#<br/>
		SmsMessage: #campaign.getSmsMessage()#<br/>
		Date: #dateformat(smsDate,"mm/dd/yyyy")#<br/>
		CampaignId: #order.getCampaignid()#
	</cfoutput>
</cfif>

<cfif action is "">
	<p/> 
	<br/>
	<form <form name="smsSubmitForm" action="sms.cfm" method="post">
		<input type="hidden" name="action" value="createSMS" />
		OrderId:<input type="text" name="orderid" value="<cfoutput>#orderid#</cfoutput>" />
		<input type="submit" />	
	</form>

</cfif>

<cffunction name="getCurrentCampaign" access="public" output="false" returntype="cfc.model.campaign.Campaign">
		<cfscript>
			var campaignService = '';
			var campaign = CreateObject('component', 'cfc.model.campaign.Campaign').init();
						
			if ( application.wirebox.containsInstance('CampaignService') )
			{
				campaignService = application.wirebox.getInstance('CampaignService');
				campaign = campaignService.getCampaignBySubdomain( campaignService.getCurrentSubdomain() );
			}
			
			if (!IsDefined('campaign'))
			{
				campaign = CreateObject('component', 'cfc.model.campaign.Campaign').init();
			}
		</cfscript>
		
    	<cfreturn campaign />
</cffunction>

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


