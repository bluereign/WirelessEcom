<cfoutput>
    <h1>Contract Extension</h1>
    
    <!--- TODO: replace this message --->
    <p>
    	By clicking the Authorize button you are agreeing to extend your contract for 24 months from the date of purchase on completion of this order process.
    </p>
    
    
    <form id="auth" action="/index.cfm/go/checkout/do/extensionAuthProcess/" method="post">
        <input type="hidden" name="s" value="Authorize this deposit"/>
    </form>
    
    
    <div class="formControl">
        
       	<span class="actionButtonLow">
			<a href="##" onclick="window.location.href='/index.cfm/go/checkout/do/wirelessAccountForm/'">Back</a>
		</span>

        <span class="actionButton">
            <a href="##" onclick="$('##auth').submit()">Authorize</a>
        </span>
        
    </div>
    
    
    
</cfoutput>