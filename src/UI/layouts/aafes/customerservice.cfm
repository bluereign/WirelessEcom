<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<style>
body {
	font-size:62.5%;
	font-family:Arial, Tahoma, Sans-Serif;
	color:#6b6b6b;
	margin:0;
	padding:0;
}
#helpMenu {
	float: left;
	margin-top: -2px;
	padding: 0 0 0 32px;
	width: 236px;
}
#helpContent {
	float:left;
	margin-top: -2px;
    padding: 0 0 0 25px;
    width: 640px;
}
#helpContent p {
	text-align:justify;
}
.subtopic li {
	line-height: 150%;
	padding-bottom: 8px;
	list-style-position:inside;
	list-style-type:disc;
	font-size:11px;
}
div.topic {
	background-color: #fff;
	height: 30px;
	line-height: 30px;
	padding: 0 12px;
	margin: 10px 0;
	text-decoration: none;
	font-size: 10pt;
}
div.subtopic {
	padding: 5px 12px 0;
	border-left: 1px solid #D4D4D4;
	border-right: 1px solid #D4D4D4;
}

a, a:link, a:visited, a:hover, a:active {
	text-decoration:none;
}
.menushim {
	display:block;
	border-top: 1px solid #D4D4D4;
	height:20px;
}
#helpContent ul{list-style-type:disc;}
#helpContent ul ul{list-style-type:circle;}
#helpContent ul ul ul{list-style-type:square;}
#helpContent ul, #helpContent ul li {
	list-style-position: outside;
	/*list-style-type: disc;*/
	margin-left:15px;
	padding:0px;
	margin-bottom: 0px;
	/*font-size:1.1em;*/
	line-spacing:1.5em;
}
#helpContent ol, #helpContent ol li {
	list-style:decimal;
	font-size:1.1em;
	line-spacing:1.5em;
}
#helpContent h1 {
	color: #E1393D;
	font-size:1.8em;
	margin-bottom: 10px;
}
#helpContent h2, #helpContent h2 a {
	color: #000000;
	font-size:1.4em;
	line-height:1.6em;
	font-weight:bold;
}
#helpContent h3 {
	color: #6B6B6B;
	font-size:1.3em;
	line-height:1.5em;
	letter-spacing:normal;
	font-weight:normal;
}

#helpContent .summary li, #helpContent .summary ul {
	list-style:none;
	font-size: 1.4em;
	line-height: 1.8em;
}

#helpContent .showBullets li{
	list-style-type: disc;
}

#helpContent h3 {
	font-weight: bold;
	color:#6B6B6B;
}

#helpContent h4 {
	padding-left: 10px;	
	font-weight: bold;
	color: #6B6B6B;
	padding-left:30px;
}

#helpContent h4 + ul {
	padding-left: 10px;	
}

#helpContent ul, #helpContent ul li {
	margin-left: 10px !important;
	margin: 2px 0px;
}

#customerServiceBanner {
	border: 1px solid #D4D4D4;
	margin-bottom:20px;
	margin-left: 10px;
	width: 940px;
}

.topicIcon {
	display: inline;
	
}

.topicLabel {
	display: inline;
	margin-left: 10px;
	margin-bottom: 10px;
}

</style>
<cfset local.contentURL = '/index.cfm/go/content/do'>
<cfoutput>
	<cfif request.template.showall>  
		<cfif request.template.showheader>  
			<div>
				<img src="#assetPaths.channel#images/customer_service_banner.png" border="0" id="customerServiceBanner" width="940" />
			</div>
		</cfif>
	</cfif>
  <div class="helpContainer">
  <cfif request.template.showall>
	<div id="helpMenu">
    	<div class="topic">
			<a href="#local.contentURL#/summary/action/main">
				<div class="topicIcon">
					<img src="#assetPaths.channel#images/ordering_logo.png" />
				</div>
				<div class="topicLabel">
					Ordering
				</div>
				<div style="clear:both;"></div>
			</a>
		</div>
		<div class="topic">
			<a href="#local.contentURL#/summary/action/att">
				<div class="topicIcon">
					<img src="#assetPaths.channel#images/att_logo.png" />
				</div>
				<div class="topicLabel">
					AT&amp;T Customers
				</div>
				<div style="clear:both;"></div>
			</a>
		</div>
<!---		
		<div class="topic">
			<a href="#local.contentURL#/summary/action/tmobile">
				<div class="topicIcon">
					<img src="#assetPaths.channel#images/tmobile_logo.png" />
				</div>
				<div class="topicLabel">
					T-Mobile Customers
				</div>
				<div style="clear:both;"></div>
			</a>
		</div>
--->
		<div class="topic">
			<a href="#local.contentURL#/summary/action/verizon">
				<div class="topicIcon">
					<img src="#assetPaths.channel#images/verizon_logo.png" />
				</div>
				<div class="topicLabel">
					Verizon Wireless Customers
				</div>
				<div style="clear:both;"></div>
			</a>
		</div>
		<cfif application.model.Carrier.isEnabled(299)>
			<div class="topic">
				<a href="#local.contentURL#/summary/action/sprint">
					<div class="topicIcon">
						<img src="#assetPaths.channel#images/sprint_logo.png" />
					</div>
					<div class="topicLabel">
						Sprint Customers
					</div>
					<div style="clear:both;"></div>
				</a>
			</div>
		</cfif>
      	<div class="topic">
			<a href="#local.contentURL#/summary/action/general">
				<div class="topicIcon">
					<img src="#assetPaths.channel#images/security_logo.png" />
				</div>
				<div class="topicLabel">
					Security and Privacy
				</div>
				<div style="clear:both;"></div>
			</a>
		</div>
      	<div class="topic">
			<a href="#local.contentURL#/contact">
				<div class="topicIcon">
					<img src="#assetPaths.channel#images/contact_logo.png" />
				</div>
				<div class="topicLabel">
					Contact Us
				</div>
				<div style="clear:both;"></div>
			</a>
		</div>
	</div>	
  </cfif>
</cfoutput>
<div id="helpContent">


  <cfoutput>#trim(request.bodyContent)#</cfoutput>
</div>
<div style="clear:both"></div>
</div>
