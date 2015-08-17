<cfcomponent output="false" extends="BaseHandler">
	
	<cfproperty name="UserService" inject="id:UserService" />
	<cfproperty name="ValidateThis" inject="ocm:ValidateThis" />
	
	<cffunction name="preHandler" access="public" returntype="void" output="false">    
    	<cfargument name="event" required="true" type="coldbox.system.web.context.RequestContext" />    
    	<cfargument name="action" required="true" type="string" />    
    	<cfargument name="eventArguments" required="true" type="struct" />    
    	<cfscript> 
			super.preHandler(argumentCollection=arguments);   
    		event.setLayout('Checkout');		    
    	</cfscript>    
    </cffunction>
    
	<cffunction name="form" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfscript>
			event.paramValue("User", variables.UserService.newUser());
			event.paramValue( "ValidationResult", ValidateThis.newResult() );
			
			rc.UserValidator = ValidateThis.getValidator( objectType="User" );
			rc.AddressValidator = ValidateThis.getValidator( objectType="BillingAddress" );
			rc.validationContext = 'CheckoutBillShip';

			// Load client validation
			$htmlhead( ValidateThis.getInitializationScript(JSIncludes=false) );
			$htmlhead( ValidateThis.getValidationScript( objectType="User", context=rc.validationContext ) );
			$htmlhead( ValidateThis.getValidationScript( objectType="BillingAddress", context=rc.validationContext ) );
		</cfscript>
	</cffunction>
	
	<cffunction name="doForm" returntype="void" output="false">
		<cfargument name="event">
		<cfargument name="rc">
		<cfargument name="prc">
		<cfscript>
			rc.User = variables.UserService.newUser();		
			rc.User.populate(rc);

			rc.ValidationResult = ValidateThis.validate( theObject=rc.User, context="CheckoutBillShip" );
			
			rc.BillingAddress = rc.User.getBillingAddress();
			rc.BillingAddress.populate(rc);
			
			ValidateThis.validate( theObject=rc.BillingAddress, context="CheckoutBillShip", result=rc.ValidationResult );
			
			if( rc.ValidationResult.hasErrors() ) {
				// validation has failed so redirect preserving the user and validationresult
				getPlugin( "MessageBox" ).setMessage( type="error", message="Oops! Please correct the errors below." );
				setNextEvent( event="validateThis.form", persist="User,ValidationResult" );
			}
		</cfscript>
	</cffunction>

</cfcomponent>