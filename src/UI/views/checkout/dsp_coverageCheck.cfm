<!--- get the company name --->
<cfset request.p.carrierName = application.model.CheckoutHelper.getCarrierName()>
<cfset request.p.carrierCoverageLink = application.model.CheckoutHelper.getCarrierCoverageAreaLink()>

<cfoutput>
<h1>#request.p.carrierName#'s Coverage Area</h1>

<p>
	Please review #request.p.carrierName#'s Wireless Coverage Area Map. 
</p>


<form id="coverage" class="cmxform" action="/index.cfm/go/checkout/do/processCoverageCheck/" method="post">

    <ul>
        <li>
            1. <a href="#request.p.carrierCoverageLink#" target="_blank">Click this link to view #request.p.carrierName#'s Wireless Coverage Area Map.</a>
        </li>
        <li>
            2. Within the map, enter your zipcode to review your coverage area.
        </li>
        <li>
            3. Return to this window and select the Acknowledge or decline coverage area option below.
        </li>

    </ul>


    <!--- show any errors --->
    <cfoutput>
        <cfif isDefined("request.validator") and  request.validator.HasMessages()>
            <div class="form-errorsummary">
                #request.validatorView.ValidationSummary(request.validator.getMessages())#
            </div>
        </cfif>
    </cfoutput>
    <!--- end show any errors --->

    <fieldset>
        <ol>
            
            <li class="full">
                <input type="radio" name="coverage" id="deny" value="decline"/><label for="deny" class="check">I do not accept the coverage area provided .</label>
            </li>
            <li class="full">
                <input type="radio" name="coverage" id="acknowledge" value="acknowledge"/><label for="acknowledge" class="check bold">I Acknowledge #request.p.carrierName#'s Coverage Area</label>
            </li>
        </ol>	
    </fieldset>
    <input type="hidden" value="att" name="carrier" />
    
    

    <div class="formControl">
    	<span class="actionButtonLow">
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/orderConfirmation/'">Back</a>
		</span>
        <span class="actionButton">
            <a href="##" onclick="$('##coverage').submit()">Continue</a>
        </span>
    </div>

</form>
</cfoutput>