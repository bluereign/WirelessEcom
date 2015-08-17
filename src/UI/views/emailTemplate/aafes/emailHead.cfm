<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<!-- ***********************************************************************************************************

HOW TO USE: Use these code examples as a guideline for formatting your HTML email. You may want to create your own template based on these snippets or just pick and choose the ones that fix your specific rendering issue(s). There are two main areas in the template: 1. The header (head) area of the document. You will find global styles, where indicated, to move inline. 2. The body section contains more specific fixes and guidance to use where needed in your design.

DO NOT COPY OVER COMMENTS AND INSTRUCTIONS WITH THE CODE to your message or risk spam box banishment :).

It is important to note that sometimes the styles in the header area should not be or don't need to be brought inline. Those instances will be marked accordingly in the comments.

************************************************************************************************************ -->

<!-- Using the xHTML doctype is a good practice when sending HTML email. While not the only doctype you can use, it seems to have the least inconsistencies. For more information on 
which one may work best for you, check out the resources below.

UPDATED: Now using xHTML strict based on the fact that gmail and hotmail uses it.  Find out more about that, and another great boilerplate, here: http://www.emailology.org/#1

More info/Reference on doctypes in email:
Campaign Monitor - http://www.campaignmonitor.com/blog/post/3317/correct-doctype-to-use-in-html-email/
Email on Acid - http://www.emailonacid.com/blog/details/C18/doctype_-_the_black_sheep_of_html_email_design
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<title>Upgrade Eligible</title>
</head>
<body style="background-color:#ffffff; font-family:Arial, Helvetica, sans-serif; font-size: 12px;">
<!-- Wrapper/Container Table: Use a wrapper table to control the width and the background color consistently of your email. Use this approach instead of setting attributes on the body tag. -->
<table cellpadding="0" cellspacing="0" border="0" id="backgroundTable">
	<tr>
		<td>

		<!-- Tables are the most common way to frmat your email consistently. Set your table widths inside cells and in most cases reset cellpadding, 
        cellspacing, and border to zero. Use nested tables as a way to space effectively in your message. -->
		<table cellpadding="10" cellspacing="0" border="0" align="left" bgcolor="#FFFFFF">
			<tr>
				<cfoutput>
					<cfset domain = cgi.SERVER_NAME />
					<cfif cgi.SERVER_PORT NEQ 80 && cgi.SERVER_PORT NEQ 443>
						<cfset domain &= ":" & cgi.SERVER_PORT />
					</cfif>
					
					<td width="50%" valign="top">
						<img src="http://#domain##assetPaths.common#images/email/wa_logo.gif" 
							alt="Wireless Advocates" width="143" height="38" />
					</td>
					<td width="50%" valign="top" align="right">
						<img src="http://#domain##assetPaths.channel#images/X_mobile_center_logo.png" 
							alt="Exchange Mobile Center" width="239" height="44" />
					</td>
				</cfoutput>
			</tr>












<!--->
<!doctype html>
<html>
<head></head>
<body style="background-color:#CCCCCC;">
<!--- Using tables as email programs render these more accurately  --->
<table cellpadding="0" cellspacing="0" border="0" id="backgroundTable" width="540" bgcolor="#FFFFFF">
	<tr>
		<td style="text-align: left;" width="250">
			<img src="http://membershipwireless.com/assets/style/costco/images/WirelessAdvocates_logosm.gif" alt="Wireless Advocates" />
		</td>
		<td style="text-align: right;" width="250">
			<img src="http://membershipwireless.com/assets/style/costco/images/costco_logosm.gif" alt="Costco.com" />
		</td>
	</tr>
	<tr>
		<td>
--->
