<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<style>
		body {
			font-family: Arial, Helvetica, "Nimbus Sans L", sans-serif;
			font-size: 1em;
			color: black;
			font-size:medium;
		}
		td.tblHead { 
			background-color: #0099ff !important;
			color: white;
			font-weight: bold;
			padding: 2px;
		}	
		td.tblLabel { 
			background-color: lightblue !important;
			color: black;
			font-weight: bold;
			padding: 5px;
		}	
		td.tblData { 
			background-color: #eee !important;
			color: black;
			font-weight: normal;
			padding: 2px 2px 2px; 
			vertical-align: top;
		}
		tr.tblData {
			margin: 0;
			padding: 0;
		}
		
		td.topBorder {
			 border-top-style: solid !important; 
			 border-top-width: 1px !important; 
			 border-top-color: #cccccc !important;
		}  
		td.rightBorder {
			 border-right-style: solid !important; 
			 border-right-width: 1px !important; 
			 border-right-color: #cccccc !important;
		}
		td.leftBorder {
			 border-left-style: solid !important; 
			 border-left-width: 1px !important; 
			 border-left-color: #cccccc !important;
		}
		td.bottomBorder {
			 border-bottom-style: solid !important; 
			 border-bottom-width: 1px !important; 
			 border-bottom-color: #cccccc !important;
		}

		
		table.tblData { font-size: 75%; padding-left: 5px;padding-right: 5px;}	
		.custletter { font-size: 75%; font-weight: normal;  }
		.bluetext { color:#1c6699;}
		
	</style>
	
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<title>Direct Delivery Return Summary</title>
</head>
<body style="background-color:#ffffff; font-family:Arial, Helvetica, sans-serif; font-size: 12px;">

<cfoutput>
	<div class="bootstrap">
		<div id="container">
		<div class="row headingImage">
			<div class="col-sm-12" style="clear:both;" >
				<img src="http://#server_name#/#assetPaths.channel#images/costco.gif" alt="Costco/Wireless Advocates" />
			</div>							
		</div>	
		
</cfoutput>