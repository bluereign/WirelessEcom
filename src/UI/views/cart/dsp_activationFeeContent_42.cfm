<!--- Verizon Activation Fee Content Include --->

<!--- moving hard-coded upgrade fees to carrier component and calling them from here  --->
<cfset local = {} />
<cfset local.carrierObj = application.wirebox.getInstance("Carrier") />
<cfset local.activationFee = local.carrierObj.getActivationFee( 42 )>

<cfoutput>
	<p>
		A #dollarFormat(local.activationFee)# activation fee will appear on your first bill for every new service line activation.
	</p>
	<p>
		As an exclusive to our customers, you will receive a <a href="/Marketing/assets/PDF/Verizon_Activation_Rebate.pdf">mail-in rebate</a> to reimburse you for the
		activation fee on your new and/or Family Share 2- year service agreements.
	</p>
</cfoutput>
