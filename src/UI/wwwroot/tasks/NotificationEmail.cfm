<cfset notification = CreateObject('component', 'cfc.model.Notification').init() />
<cfset emailMan = CreateObject('component', 'cfc.model.EmailManager').init() />
<cfset sentNotification = CreateObject('component', 'cfc.model.Notification').init() />

<!--- number of days before eligibilty date to send email --->
<cfset notificationDays = 7 />

<!--- pass the number of days --->
<cfif StructKeyExists(URL, "days")>
	<cfset notificationDays = URL.days />
</cfif>

<!--- query to get entries with EligibilityDate within "coming up" time 
	and SentDateTime is null --->	
<cfset upgrades = notification.getEligibleUpgradesComingUp(notificationDays) />

<!--- bandaid: page wouldn't run unless request.bodycontent was defined. --->
<cfset request.bodycontent = "" />

<!--- request.p.do tells the email controller to use the UpgradeNotification template --->
<cfset request.p.do = "upgradeNotification" />

<!--- loop entries --->
<cfloop query="upgrades">
	<!--- setting upgradeId to be used in UpgradeNotification.cfm template --->
	<cfset upgradeId = upgrades.UpgradeEligibilityId />
	
	<!--- call UpgradeNotification email template --->
	<cfinclude template="/emailTemplate/index.cfm" />

	<!--- update SentDateTime to currentDateTime 
	--->
	<cfset sentNotification.load(upgrades.UpgradeEligibilityId) />
	<cfset sentNotification.setSentDateTime(Now()) />
	<cfset sentNotification.save() />
</cfloop>