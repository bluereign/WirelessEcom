<html>
<head>
</head>
<body>
Hello from hello.cfm.<br/>I am going to be calling hellowsource.cfm in a cfwindow.	
<cfdump var="#cgi#" />
<cfwindow source="https://local.costco.wa/test/hellosource.cfm" width="500" resizable="true" name="CFWINDOW SSL Test" initshow="true">
	This should be ignored
</cfwindow>
</body>
</html>