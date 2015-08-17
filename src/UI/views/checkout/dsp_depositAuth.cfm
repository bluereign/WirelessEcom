<cfset textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer") />
<!--- get the deposit from the checkout helper --->
<cfset request.p.depositAmount = application.model.CheckoutHelper.getDepositAmount()>
<cfset request.p.carrier = application.model.CheckoutHelper.getCarrier()>
<cfset request.p.message = "">
<cfset request.p.depositOk = false>


<!--- build the deposit message based on the carrier --->
<cfswitch expression="#request.p.carrier#">
	<cfcase value="109"> <!--- ATT --->
    	<cfsavecontent variable="request.p.message">
        	<p>The wireless carrier, AT&T is indicating that a deposit will be required in order to complete this transaction.</p>
           	<p><b>Please contact your carrier for more information.</b></p>
        </cfsavecontent>
    </cfcase>

    <cfcase value="128"> <!--- TMOBILE --->
    	<cfsavecontent variable="request.p.message">
            <p>The wireless carrier, T-Mobile is indicating that a deposit will be required in order to complete this transaction.</p>
           	<p><b>Please contact your carrier for more information.</b></p>
        </cfsavecontent>
    </cfcase>

    <cfcase value="42"> <!--- VERIZON --->
    	<cfsavecontent variable="request.p.message">
        	<p>A deposit is required to complete this transaction.  Please visit your local <cfoutput>#textDisplayRenderer.getStoreAliasName()#</cfoutput> to purchase this device.</p>
           	<p><b>Please contact your carrier for more information.</b></p>
        </cfsavecontent>
    </cfcase>

    <cfcase value="299"> <!--- Sprint --->
    	<cfsavecontent variable="request.p.message">
        	<p>The wireless carrier, Sprint is indicating that a deposit will be required in order to complete this transaction.</p>
           	<p><b>Please contact your carrier for more information.</b></p>
        </cfsavecontent>
    </cfcase>

</cfswitch>

<cfoutput>
    <h1>Deposit Required</h1>

    #request.p.message#

    <form id="deny" action="/index.cfm/go/checkout/do/processDeposit/" method="post">
        <input type="hidden" name="s" value="Do not authorize this deposit"/>
    </form>
    <form id="auth" action="/index.cfm/go/checkout/do/processDeposit/" method="post">
        <input type="hidden" name="s" value="Authorize this deposit"/>
    </form>

    <div class="formControl">

       	<span class="actionButtonLow">
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/creditCheck/'">Back</a>
		</span>
        <cfif request.p.depositOk eq true >
            <span class="actionButtonLow">
                <a href="##" onclick="$('##deny').submit()">Do Not Authorize</a>
            </span>
             <span class="actionButton">
                <a href="##" onclick="$('##auth').submit()">Authorize Deposit</a>
            </span>
        </cfif>
    </div>

</cfoutput>