<!doctype html>
<cfparam name="action" default="" />
<cfparam name="orderid" default="" />
<cfparam name="forceIMEI" default="" />
<html>
<head>
		<title></title>Allocation Unit Test Page</title>
	
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
	
<cfif action is "getOrderMessage">
	<cfset allocation = createObject('component', 'cfc.model.Allocation').init() />
	<cfset isAllocatedOrder = allocation.isAllocatedOrder(orderid) />
	
	<cfoutput>
		isAllocatedOrder = #isAllocatedOrder#<br/>
		Latest Date Msg = #allocation.getLatestProcessDateMessage(orderid)#<br/>
	</cfoutput>	
</cfif>

<cfif action is "">
	<p/> 
	<br/>
	<form <form name="alloctestform" action="alloc.cfm" method="post">
		<input type="hidden" name="action" value="getOrderMessage" />
		OrderId:<input type="text" name="orderid" value="<cfoutput>#orderid#</cfoutput>" />
		<input type="submit" />	
	</form>

</cfif>


