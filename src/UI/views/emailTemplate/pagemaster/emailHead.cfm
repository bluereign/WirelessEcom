<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<title>Email Template</title>
</head>
<body style="background-color:#ffffff; font-family:Arial, Helvetica, sans-serif; font-size: 12px;">
<table cellpadding="0" cellspacing="0" border="0" id="backgroundTable">
	<tr>
		<td>
			<table cellpadding="10" cellspacing="0" border="0" align="left" bgcolor="#FFFFFF" style="table-layout:fixed;">
				<tr>
					<cfoutput>
						<td valign="top" align="left">
							<a href="##">
								<img src="http://#request.config.emailTemplateDomain##assetPaths.channel#images/WirelessAdvocates_logosm.gif" 
									alt="Wireless Advocates" width="143" height="38" />
							</a>
						</td>
					</cfoutput>
					<td></td>
				</tr>