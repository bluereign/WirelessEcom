<!--- values needed for template --->
<cfparam name="orderId" />
<cfparam name="adminEmail" />
<cfparam name="cancellationReason" />

<!--- load objects to get values for template --->
<cfset theOrder = CreateObject('component', 'cfc.model.Order').init() />
<cfset theUser = CreateObject('component', 'cfc.model.User').init() />

<cfset theOrder.load(orderId) />
<cfset theUser.loadUserByUsername(adminEmail) />
<cfset authorizationNumber = "" />
<cfset payments = theOrder.getPayments() />

<cfif ArrayLen( payments )>
	<cfset authorizationNumber = payments[ArrayLen( payments )].getCreditCardAuthorizationNumber() />
</cfif>

<!--- setting email variable locally so that the footer is not dependent on a specific object for the email value --->
<cfset email = adminEmail />
<cfset sendFrom = request.config.customerServiceEmail />
<cfset subject = "Order Cancellation Alert" />

<cfsavecontent variable="templateMessage">
	<!--- template head --->
	<cfinclude template="wa_costcoHead.cfm" />
	
	<!--- template body --->
	<cfoutput>
		<tr>
			<td>
				<h1>
					<strong>Order Cancellation </strong>Alert
				</h1>  
			</td>
		</tr>
		<tr>
			<td>
				<p>
					Request Date: #DateFormat( Now(), "mm/dd/yyyy" )#<br />
					Online Sales Order Number: #theOrder.getOrderId()#<br />
					Customer Name: #theOrder.getBillAddress().getFirstName()# #theOrder.getBillAddress().getLastName()#<br />
					Customer Number: #application.model.util.convertToGersId( theOrder.getUserId() )#<br />
					Credit Card Authorization Number: #authorizationNumber#<br />
					Tax Transaction ID: #theOrder.getSalesTaxTransactionId()#<br />
				</p>
				<p>Action required for:</p>
				<p>
				<!--- Cannot cancel an order unless the status 'Payment Complete' or 'Closed'--->
				__X__ Credit Card was charged <br/> 
				<!--- Cannot cancel when status is 'closed' and shipped --->
				__X__ Order not shipped <br/>
				<!--- Phones are fully activated when status is Success or Manual --->
				<cfif theOrder.getWirelessAccount().getActivationStatus() NEQ 6 AND theOrder.getWirelessAccount().getActivationStatus() NEQ 6>
					__X__ Phone never activated - order never downloaded to GERS <br/>
				<cfelse>
					_____ Phone never activated - order never downloaded to GERS <br/>
				</cfif>
				<!--- Tax transaction is refunded when a refund transaction --->
				<cfif theOrder.getIsSalesTaxTransactionCommited()>
					<cfif Len( theOrder.getSalesTaxRefundTransactionId() )>
						__X__ Tax Transaction Refunded at Exactor <br/>
					<cfelse>
						_____ Tax Transaction Refunded at Exactor <br/>
					</cfif>
				<cfelse>
					_N/A_ Tax Transaction Refunded at Exactor <br/>
				</cfif>
				</p>
				<p>This Online Order is cancelled and the payment needs to be returned to the customer.
				Return credit transaction listed above.</p>
				<p>Reason for cancelling sale: #cancellationReason#</p>
				<p>
				Requested by: #theUser.getFirstName()# #theUser.getLastName()# (#theUser.getEmail()#)<br />
				Authorized by: ______________________ <br />
				Refund Processed by: ______________________ <br />
				Date Completed: ______________________ <br />
				</p>
			</td>
		</tr>
	</cfoutput>
	
	<!--- template foot 
	<cfinclude template="wa_costcoFoot.cfm" />
	--->
</cfsavecontent>

<!--- FOR TESTING 
<cfoutput>
	#templateMessage#
</cfoutput>
<cfabort />
--->

<!--- mail the message --->
<cfmail to="#email#"
        from="#sendFrom#"
        subject="#subject#"
        type="html">
    #templateMessage#
</cfmail>