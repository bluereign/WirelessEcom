<!--- Sprint Activation Fee Content Include --->

<!--- moving hard-coded upgrade fees to carrier component and calling them from here  --->
<cfset local = {} />
<cfset local.carrierObj = application.wirebox.getInstance("Carrier") />
<cfset local.activationFee = local.carrierObj.getActivationFee( 299 )>

<cfoutput>
	<p>
		A #dollarFormat(local.activationFee)# activation fee will appear on your first bill for every new service line activation.
	</p>
	<p>
		As an exclusive to our customers,
		you will receive a service activation credit to reimburse you for the activation fee on your new 2-year service
		agreements. The #dollarFormat(local.activationFee)# service activation credit appears on your bill 2-3 months after initial service is
		established. 
	</p>
</cfoutput>