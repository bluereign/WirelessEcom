
<!--- bandaid: page wouldn't run unless request.bodycontent was defined. --->
<cfset request.bodycontent = "" />

<!--- request.p.do tells the email controller to use the DelayNotification template --->
<cfset request.p.do = "TMONotification" />

<!--- call UpgradeNotification email template --->
<cfinclude template="/emailTemplate/index.cfm" />
