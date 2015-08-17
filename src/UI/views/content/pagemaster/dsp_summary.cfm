<cfparam name="URL.action" default="main">
<cfoutput>
<ul class="summary">
  <cfswitch expression="#URL.action#">
    <cfcase value="main">
	    <li><a href="/index.cfm/go/content/do/FAQ">Frequently Asked Questions</a></li> 
	    <li><a href="/index.cfm/go/content/do/serviceTypeOverview">Service Type Overview</a></li>
	    <li><a href="/index.cfm/go/content/do/FAQ##Shipping">Tracking Your Package</a></li>
	    <li><a href="/index.cfm/go/content/do/FAQ##return_phone">Returns Policy</a></li>
	    <li><a href="/index.cfm/go/content/do/FAQ##billed">Sales Tax Information</a></li>
    </cfcase>
    <cfcase value="att">
	    <li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/att/" target="_blank">AT&amp;T Terms and Conditions</a></li>
	    <li><a href="/index.cfm/go/content/do/earlyTermination/carrier/att">AT&amp;T Early Termination Fee</a></li>
	    <li><a href="/index.cfm/go/content/do/activatingPhone/carrier/att">Activating Your Phone</a></li>
	    <li><a href="/index.cfm/go/content/do/rebateCenter">Rebates</a></li>
    </cfcase>
    <cfcase value="tmobile">
		<li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/tmobile/" target="_blank">T-Mobile Terms and Conditions</a></li>
	    <li><a href="/index.cfm/go/content/do/earlyTermination/carrier/tmobile">T-Mobile Early Termination Fee</a></li>
	    <li><a href="/index.cfm/go/content/do/activatingPhone/carrier/tmobile">Activating Your Phone</a></li>
	    <li><a href="/index.cfm/go/content/do/rebateCenter">Rebates</a></li>
    </cfcase>
    <cfcase value="verizon">
	    <li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/verizon/" target="_blank">Verizon Terms and Conditions</a></li>
	    <li><a href="/index.cfm/go/content/do/earlyTermination/carrier/verizon">Verizon Early Termination Fee</a></li>
	    <li><a href="/index.cfm/go/content/do/activatingPhone/carrier/verizon">Activating Your Phone</a></li>
	    <li><a href="/index.cfm/go/content/do/rebateCenter">Rebates</a></li>
    </cfcase>
    <cfcase value="sprint">
	    <li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/sprint/" target="_blank">Sprint Terms and Conditions</a></li>
	    <li><a href="/index.cfm/go/content/do/earlyTermination/carrier/sprint">Sprint Early Termination Fee</a></li>
	    <li><a href="/index.cfm/go/content/do/activatingPhone/carrier/sprint">Activating Your Phone</a></li>
	    <li><a href="/index.cfm/go/content/do/rebateCenter">Rebates</a></li>
    </cfcase>    
    <cfcase value="general">
	    <li><a href="/index.cfm/go/content/do/privacy">Privacy Policy</a></li>
	    <li><a href="/index.cfm/go/content/do/terms">Site Terms and Conditions</a></li>
	    <li><a href="/index.cfm/go/content/do/aboutus" target="_blank">About Us</a></li>
    </cfcase>
  </cfswitch>
</ul>
</cfoutput>