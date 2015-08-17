<cfset GeoService = application.wirebox.getInstance("GeoService") />
<cfset request.p.states = GeoService.getAllStates()>

<cfoutput>
<form id="existingCustomer" class="cmxform" action="/index.cfm/go/checkout/do/processExistingCustomer/" method="post">
	<h1>Existing Account Lookup</h1>
	
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
        <p>
      		Please enter your wireless account credentials.
        </p>
        <ol>

            <li>
                <label for="txtMdn">Mobile Number</label>
                <input name="areacode" value="#application.model.CheckoutHelper.FormValue("session.checkout.mdnForm.areacode")#" class="areacode" maxlength="3" />
                <input name="lnp" value="#application.model.CheckoutHelper.FormValue("session.checkout.mdnForm.lnp")#" class="lnp" maxlength="3" />
                <input name="lastfour" value="#application.model.CheckoutHelper.FormValue("session.checkout.mdnForm.lastfour")#" class="lastfour" maxlength="4" /><span class="req">*</span>
                #request.validatorView.ValidationElement(request.validator.getMessages(),"mdn")#
            </li>
            <li>
                <label for="txtPin">Secret Pin **</label> 
                <input id="txtPin" name="pin" value="#application.model.CheckoutHelper.FormValue("session.checkout.customerForm.pin")#" /> <span class="req">*</span>
                #request.validatorView.ValidationElement(request.validator.getMessages(),"pin")#
            </li>
          
        </ol>
    </fieldset>
    
    <p>
    We have the highest respect for your privacy; the information you provide will be kept secure. For further details, review our <a href="/index.cfm/go/content/do/privacy" target="_blank">Privacy Policy</a>.
    </p>
    
    <p>
    	** Secret Pin is assigned by your current carrier. This is often times the last 4 digits of your Social Security Number.
    </p>
    
    <!--- testing tool --->
	<cfif request.config.ShowServiceCallResultCodes>
        <select name="resultCode" class="resultCode">
            <option value="CL001">Success Customer Found</option>
            <option value="CL002">Customer not Found</option>
            <option value="CL010">Invalid Request</option>
            <option value="CL011">Unable to Connect to Carrier Service</option>
            <option value="CL012">Service Timeout</option>
            <option value="" selected="selected">Run for Real</option>
        </select>
    
    
    </cfif>
    
    
    <div class="formControl">
    

        <span class="actionButton">
            <a href="##" onclick="showProgress('Processing customer lookup, please wait.'); $('processExistingCustomer').submit()">Continue</a>
        </span>
    </div>	

</form>
</cfoutput>