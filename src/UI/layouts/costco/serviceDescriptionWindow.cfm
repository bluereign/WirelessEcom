<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE"><!-- IE8 mode -->
    <title>Costco - Wireless Advocates</title>
<!--- 	<cfinclude template="_cssAndJs.cfm"> --->
</head>
<body>
	<div>
		#request.bodycontent#
	</div>
</body>
</html>
</cfoutput>
<cfset request.bodycontent = ""> <!--- TRV: adding this to prevent all the generated inner HTML from showing up in the debug output dump of request variables --->
