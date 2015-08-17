<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="SprintActivationController">
		<cfargument name="SprintCarrierService" type="cfc.model.carrierservice.Sprint.SprintCarrierService" required="true" />

		<cfscript>
			setSprintCarrierService(arguments.SprintCarrierService);

			return this;
		</cfscript>
		
	</cffunction>

	<cffunction name="upgradeLine" output="false" access="public" returntype="struct">
		<cfargument name="wirelessLineID" type="numeric" required="true" />
		<cfargument name="lineNumber" type="numeric" required="true" />
		
		<cfscript>
			var rtn = { success = false, line = arguments.wirelessLineID, status = "Unknown", messages = [], accountStatus = "Unknown" };
			
			var ActivationRequest = getSprintCarrierService().getUpgradeRequest( wirelessLineID = arguments.wirelessLineID );
			var ActivationResponse = "";
			var Line = createObject("component","cfc.model.WirelessLine").init();
			
			Line.load(arguments.wirelessLineID);
			Line.setActivationStatus(1); //RequestSubmitted/Requested
			Line.save();
			
			try {
				ActivationResponse = getSprintCarrierService().upgrade( ActivationRequest = ActivationRequest );
			}
			catch( any e ) {
				Line.setActivationStatus(0); //None/Ready
				rtn.status = 'None';
				arrayAppend( rtn.messages, 'Error occurred contacting activation service. Please try again. If you continue to experience this error, contact wa-online@wirelessadvocates.com');
				arrayAppend( rtn.messages, e.message );
				return rtn;
			}
			
			Line.setActivationStatus( ActivationResponse.getActivationStatusID() );
			Line.save();
			
			// Translate the status returned from the upgrade into something Care is familiar with in OMT
			rtn.status = ActivationResponse.getActivationStatusForUI();
			
			if( ActivationResponse.isSuccess() ) {
				rtn.success = true;
				arrayAppend(rtn.messages, 'Line #arguments.lineNumber# successfully activated.');
			} else {
				arrayAppend(rtn.messages, 'Line #arguments.lineNumber# failed.');
				arrayAppend(rtn.messages, 'Error: #ActivationResponse.getErrorMessage()#');
				arrayAppend(rtn.messages, 'Detail:  #ActivationResponse.getErrorMessageDetail()#');
			}
			
			// Order is activated if all WirelessLines and WirelessAccount have been activated 
			rtn.accountStatus = getSprintCarrierService().activateAccount( orderID = Line.getOrderId() );
			
			return rtn;
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getSprintCarrierService" access="public" output="false" returntype="any">    
    	<cfreturn variables.instance["SprintCarrierService"]/>    
    </cffunction>    
    <cffunction name="setSprintCarrierService" access="public" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance["SprintCarrierService"] = arguments.theVar />    
    </cffunction>
	
</cfcomponent>
