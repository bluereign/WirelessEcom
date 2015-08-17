<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Wireless Advocates, LLC</title>
<link rel="shortcut icon" href="favicon.ico" type="image/vnd.microsoft.icon"/>
<link rel="icon" href="favicon.ico" type="image/vnd.microsoft.icon"/>
<style>
	.aboutUsHeader
	{
		font-family: Tahoma,Arial,Verdana,Helvetica;
		font-size: 18px;
		color: #006600;
		font-weight: bold;
	}

	P.aboutUs
	{
		font-family: Tahoma,Arial,Verdana,Helvetica;
		font-size: 13px;
		color: #000000;
	}
</style>
</head>
<body>
<div id="container">
<!--- 	<div id="header"></div> --->
	<div id="page-graphic"><img src="/Marketing/aboutUs/images/Header.gif" alt="Company Profile Header Image" width="675" /></div>
	<div id="page-graphic"><img src="/Marketing/aboutUs/images/Hdr-aboutus-Gb.jpg" alt="About Us" width="675" /></div>
	<div id="page-content">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="center">
					<div id="Content2" style="padding-top:10px;text-align:left;">
						<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=5c6721a0-9d26-4c46-be83-7ea65403a8e2'>
	            		<cfoutput>#cfhttp.filecontent#</cfoutput>
					</div>
				</td>
			</tr>
		</table>
		<div class="clear"><!--Clear Styles --></div>
	</div>
<!--- 	<div id="footer"></div> --->
</div>
</body>
</html>
