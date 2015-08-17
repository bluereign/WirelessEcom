<!doctype html>
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig")	/>

<html>
<head>
		<title></title>Show Instance Configuration</title>
	
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
<!--- We only want this to work for local/private access --->	
<cfif left(cgi.server_name,3) is "10." or refindnocase("^(local\.)(.)*(\.wa)$",cgi.server_name )>
	
	<div style="font-size:200%;">
		<div>
		<cfoutput>#channelConfig.takeADump()#</cfoutput>
		</div>
		<div>
			<div>Application Scope:</div>
			<div><cfdump var="#application#" expand="no" label="Click to Expand"/></div>
		</div>
	</div>
</cfif>	
</body>
</html>