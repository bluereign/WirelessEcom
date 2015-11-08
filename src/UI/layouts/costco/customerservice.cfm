<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<style>
body {
	font-size:62.5%;
	font-family:Arial, Tahoma, Sans-Serif;
	color:#6b6b6b;
	margin:0;
	padding:0;
}
#howToShop
{}
#howToShop ul
{
	font-size:11px;
}
#helpMenu {
	float: left;
	margin-top: -2px;
    padding: 0 0 0 10px;
    width: 255px;
}
#helpContent {
	float:left;
	margin-top: -2px;
	padding: 0 0 0 27px;
	width: 650px;
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
	background-color: #F9F9F9;
	border-bottom: 1px solid #D4D4D4;
	border-top: 1px solid #D4D4D4;
	border-left: 1px solid #D4D4D4;
	border-right: 1px solid #D4D4D4;
	font-weight: bold;
	height: 22px;
	line-height: 22px;
	padding: 0 12px;
}
div.subtopic {
	padding: 5px 12px 0;
	border-left: 1px solid #D4D4D4;
	border-right: 1px solid #D4D4D4;
}
.topic {
	text-decoration:none;
	font-size:120%;
}
a, a:link, a:visited, a:hover, a:active {
	text-decoration:none;
}
.menushim {
	display:block;
	border-top: 1px solid #D4D4D4;
	height:20px;
}
#helpContent ul, #helpContent ul li {
	list-style-position: outside;
	margin-left:15px;
	padding:0px;
	margin-bottom: 2px;
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

#customerServiceBanner {
	border: 1px solid #D4D4D4;
	margin-bottom:20px;
	
}
</style>

</style>
<cfset local.contentURL = '/index.cfm/go/content/do'>
<cfoutput>
  <div class="helpContainer">
  <cfif request.template.showall>
    <div id="helpMenu">
      <div class="topic"><a href="#local.contentURL#/summary/action/main">Ordering on Costco.com</a></div>
      <div class="subtopic">
        <li><a href="#local.contentURL#/FAQ">Frequently Asked Questions</a></li>
      </div>
      <div class="subtopic">
        <li><a href="#local.contentURL#/serviceTypeOverview">Service Type Overview</a></li>
      </div>
      <div class="subtopic">
        <li><a href="#local.contentURL#/FAQ##Shipping">Tracking Your Package</a></li>
      </div>
      <div class="subtopic">
        <li><a href="#local.contentURL#/shipping">Shipping Policy</a></li>
      </div>	  
      <div class="subtopic">
        <li><a href="#local.contentURL#/FAQ##return_phone">Returns Policy</a></li>
      </div>  
      <div class="subtopic">
        <li><a href="#local.contentURL#/FAQ##billed">Sales Tax Information</a></li>
      </div>
      <div class="menushim"></div>

		<cfif ListFind(request.config.ActiveCarriers, "109", "|")>
			<div class="topic"><a href="#local.contentURL#/summary/action/att">AT&amp;T Customers</a></div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/displayDocument/?doc=termsandconditions/att/" target="_blank">AT&amp;T Terms and Conditions</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/earlyTermination/carrier/att">AT&amp;T Early Termination Fee</a></li>
			</div>
			<div class="subtopic">
				<li><a href="/index.cfm/go/content/do/displayDocument/?doc=customerletters/att/" target="_blank">AT&amp;T Costco Customer Letter</a></li>
			</div>			
			<div class="subtopic">
				<li><a href="http://www.att.com/maps/wireless-coverage.html" target="_blank" >Coverage Map</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/activatingPhone/carrier/att">Activating Your Phone</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/rebateCenter">Rebates</a></li>
			</div>
		</cfif>
<!---
		<cfif ListFind(request.config.ActiveCarriers, "42", "|")>
			<div class="menushim"></div>
			<div class="topic"><a href="#local.contentURL#/summary/action/tmobile">T-Mobile Customers</a></div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/displayDocument/?doc=termsandconditions/tmobile/" target="_blank">T-Mobile Terms and Conditions</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/earlyTermination/carrier/tmobile">T-Mobile Early Termination Fee</a></li>
			</div>
			<div class="subtopic">
				<li><a href="/index.cfm/go/content/do/displayDocument/?doc=customerletters/tmobile/" target="_blank">T-Mobile Costco Customer Letter</a></li>
			</div>			
			<div class="subtopic">
				<li><a href="#local.contentURL#/activatingPhone/carrier/tmobile">Activating Your Phone</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/rebateCenter">Rebates</a></li>
			</div>
		</cfif>
--->
		<cfif ListFind(request.config.ActiveCarriers, "128", "|")>
			<div class="menushim"></div>
			<div class="topic"><a href="#local.contentURL#/summary/action/verizon">Verizon  Customers</a></div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/displayDocument/?doc=termsandconditions/verizon/" target="_blank">Verizon Terms and Conditions</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/earlyTermination/carrier/verizon">Verizon Early Termination Fee</a></li>
			</div>
			<div class="subtopic">
				<li><a href="/index.cfm/go/content/do/displayDocument/?doc=customerletters/verizon/" target="_blank">Verizon Costco Customer Letter</a></li>
			</div>			
			<div class="subtopic">
				<li><a href="http://vzwmap.verizonwireless.com/dotcom/coveragelocator/" target="_blank" >Coverage Map</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/activatingPhone/carrier/verizon">Activating Your Phone</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/rebateCenter">Rebates</a></li>
			</div>
		</cfif>

		<cfif ListFind(request.config.ActiveCarriers, "299", "|")>
			<div class="menushim"></div>
			<div class="topic"><a href="#local.contentURL#/summary/action/sprint">Sprint  Customers</a></div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/displayDocument/?doc=termsandconditions/sprint/" target="_blank">Sprint Terms and Conditions</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/earlyTermination/carrier/sprint">Sprint Early Termination Fee</a></li>
			</div>
			<div class="subtopic">
				<li><a href="/index.cfm/go/content/do/displayDocument/?doc=customerletters/sprint/" target="_blank">Sprint Costco Customer Letter</a></li>
			</div>
			<div class="subtopic">
				<li><a href="https://coverage.sprint.com/IMPACT.jsp?" target="_blank" >Coverage Map</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/activatingPhone/carrier/sprint">Activating Your Phone</a></li>
			</div>
			<div class="subtopic">
				<li><a href="#local.contentURL#/rebateCenter">Rebates</a></li>
			</div>
		</cfif>
      
      <div class="menushim"></div>
      <div class="topic"><a href="#local.contentURL#/summary/action/general">Security and Privacy</a></div>
      <div class="subtopic">
        <li><a href="#local.contentURL#/privacy">Privacy Policy</a></li>
      </div>
	<div class="subtopic">
        <li><a href="#local.contentURL#/terms">Site Terms and Conditions</a></li>
      </div>
      <div class="subtopic">
        <li><a href="#local.contentURL#/aboutus" target="_blank">About Us</a></li>
      </div>
      <div class="topic"><a href="#local.contentURL#/supplychain">Supply Chain Disclosure</a></div>
      <div class="menushim"></div>
      <div class="topic"><a href="#local.contentURL#/contact">Contact Us</a></div>
      <div class="subtopic">
        <li style="list-style:none;">Customer Service Email:<br />
          <a href="mailto:#channelConfig.getCustomerCareEmail()#">#channelConfig.getCustomerCareEmail()#</a>
		  </li>
      </div>
      <div class="subtopic">
        <li style="list-style:none;">Customer Service Phone:#channelConfig.getCustomerCarePhone()#<br />
          Mon-Fri 6am - 6pm<br />
          Pacific Standard Time</li>
      </div>
      <div class="menushim"></div>
    </div>
  </cfif>
</cfoutput>
<div id="helpContent">
	<cfif request.template.showall>  
		<cfif request.template.showheader>  
			<div align="right">
			<cfoutput><img src="#assetPaths.channel#images/customer_service_banner_665.png" border="0" id="customerServiceBanner" /></div></cfoutput>
		</cfif>
	</cfif>

  <cfoutput>#trim(request.bodyContent)#</cfoutput>
</div>
<div style="clear:both"></div>
</div>