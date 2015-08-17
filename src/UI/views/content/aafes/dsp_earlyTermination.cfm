
<cfswitch expression="#url.carrier#">
	<cfcase value="att">
	<h1>AT&T Early Termination </h1>
	<p>AT&T gives all customers a 14 day (from date of purchase) trial period to try out the service without incurring an early termination fee. If the service is canceled after the 14 day trial period, AT&T will charge the subscriber an early termination fee per line of service as follows:</p>
	<p>Advanced Handset: $325 Early Termination Fee (Fee will be reduced by $10 for each full month completed toward the minimum term of the contract) Note: Visit www.att.com/equipment for details on AT&T handset types.</p>
	<p>Standard Handset: $150 Early Termination Fee (Fee will be reduced by $4 for each full month completed toward the minimum term of the contract) Note: Visit  www.att.com/equipment</a> for details on AT&T handset types. </p>
	</cfcase>
	<cfcase value="sprint">
		<h1>Sprint Early Termination</h1>
		<p>Sprint gives all customers a 14 day (from date of purchase) trial period to try out the service without incurring an early termination fee. If the service is canceled after the 14 day trial period, Sprint will charge the subscriber an early termination fee per line of service. Customers will be responsible for an early termination fee of up to $350 ("ETF") for each line/number terminated early.</p>
	</cfcase>
	<cfcase value="tmobile">
		<h1>T-Mobile  Early Termination</h1>
		<p>T-Mobile gives all customers a 14 day* (from date of purchase) trial period to try out the phone and T-Mobile service without incurring an early termination fee. If the service is canceled after the 14 day trial period, T-Mobile will charge the subscriber an early termination fee per line of service as follows:</p>
		<p>*For California customers there is 30 day (from date of purchase) trial period to try out the phone and T-Mobile service without incurring an early termination fee.</p>
		<p><ul>
		<li>$200.00 if service is canceled with more than 180 days remaining on the term </li>
		<li>$100.00 if service is canceled with 91 to 180 days remaining on the term </li>
		<li>$50.00 if service is canceled with 31 to 90 days remaining on the term </li>
		<li>$50.00 or the monthly recurring charges, whichever is less, if service is canceled within the last 30 days of the term</li>
		</ul></p>
	</cfcase>
	<cfcase value="verizon">
		<h1>Verizon Wireless Early Termination</h1>
		<p>
			You can <a href="/index.cfm/go/content/do/returns">try out</a> service for 14 days. Verizon 
			Wireless gives all customers a 14 day (from date of purchase) trial period to try out the 
			phone and Verizon service without incurring an early termination fee. If the service is 
			canceled after the 14 day trial period, you will remain responsible for your Activation Fee 
			unless you terminate service within three days of activation. Verizon will charge the 
			subscriber an early termination fee per line of service as follows: 
		</p>
		<p>
			Advanced Device: up to $350 Early Termination Fee. Note: Visit 
			<a href="http://www.verizonwireless.com/advanceddevices">www.verizonwireless.com/advanceddevices</a> 
			for details on Verizon device types.
		</p>
		<p>
			Standard Device: $175 Early Termination Fee (Fee will be reduced up to $5 for each full month 
			completed toward the minimum term of the contract) Note: Visit 
			<a href="http://www.verizonwireless.com/advanceddevices">www.verizonwireless.com/advanceddevices</a> 
			for details on Verizon device types. 
		</p>
	</cfcase>	
</cfswitch>