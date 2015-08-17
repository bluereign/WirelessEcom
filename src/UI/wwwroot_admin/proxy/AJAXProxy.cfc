<cfcomponent output="false">

	<cffunction name="generatePromoCodes" access="remote" output="false" returntype="array" returnformat="json">
		<cfargument name="quantity" type="numeric" default="1">
		
		<cfscript>
			var PromotionService = application.wirebox.getInstance('PromotionService');
			return PromotionService.generatePromoCodeBatch(arguments.quantity);
		</cfscript>
		
	</cffunction>
	<cffunction name="activateLine" access="remote" output="false" returntype="struct" returnformat="json">
		<cfargument name="activationType" type="string" required="true">    
    	<cfargument name="wirelessLineID" type="numeric" required="true">
		<cfargument name="carrierID" type="numeric" required="true">
		<cfargument name="lineNumber" type="numeric" required="true">
		
		<cfscript>
			var ActivationController = "";
			
			switch( arguments.carrierID ) {
				case "299" : {
					ActivationController = application.wirebox.getInstance('SprintActivationController');
					break;
				}
			} 
			
			switch( arguments.activationType ) {
				case "U" : {
					return ActivationController.upgradeLine( wirelessLineID = arguments.wirelessLineID, lineNumber = arguments.lineNumber );
					break;		
				}
			}
		</cfscript>

    </cffunction>
    
	
</cfcomponent>
