<!--- values needed for template --->
<cfparam name="orderId" />

<!--- load objects to get values for template --->
<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
<cfset theOrderAddress = CreateObject('component', 'cfc.model.OrderAddress').init() />
<!--- <cfset theUser = CreateObject('component', 'cfc.model.User').init() /> --->

<cfset theOrder.load(orderId) />
<!--- <cfset theUser.getUserById(theOrder.getUserId()) /> --->

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = theOrder.getEmailAddress() />
<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Your Device Order - Complete Payment" />

<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="wa_costcoHead.cfm" />
	
<!--- template body --->
	<cfoutput>
		<tr>
			<td colspan="2">
				<p>   
					<strong>Please click the link below to complete payment.</strong>
				</p>  
				<p>
					<a href="http://#request.config.emailTemplateDomain#/index.cfm/go/checkout/do/processPaymentRedirect/orderid/#theOrder.getOrderId()#">
						http://#request.config.emailTemplateDomain#/index.cfm/go/checkout/do/processPaymentRedirect/orderid/#theOrder.getOrderId()#
					</a>
				</p>  
				<p>Thank you.</p>  	
			</td>
		</tr>
	</cfoutput>
	</table>
		</body>
		</html>
	<!--- template foot --->
	<!--- <cfinclude template="wa_costcoFoot.cfm" /> --->
</cfsavecontent>

<!--- <cfoutput>
	#templateMessage#
</cfoutput>
<cfabort /> --->

<!--- mail the message --->
<cfmail to="#email#"
		bcc="shamilton@wirelessadvocates.com"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>


