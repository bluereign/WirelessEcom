<cfcomponent output="false" displayname="CarrierServiceLog">

	<cffunction name="init" returntype="CarrierServiceLog">
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="getRecent" returntype="string">
    	<cfset var local = structNew()>
        
        <cfset local.recent = application.model.CarrierServiceLog.getRecent()>

        <!--- build the table --->
        <cfsavecontent variable="local.html">
        	<table id="listServiceList" class="table-long clear">
            	<thead>
                	<tr>
                    	<th>Reference Number</th>
                    	<th>Carrier</th>
                    	<th>Timestamp</th>
                	</tr>
            	</thead>
           		<tbody>     
                <cfset local.lastReference = "">
                <cfset local.data = "">
                
                <cfloop query="local.recent">
                	<cfset local.thisReference = local.recent.referenceNumber>

                    <cfif local.thisReference neq local.lastReference>
                    	<cfif local.data neq "">
                        	<cfset local.lastTR = Replace(local.lastTR, "[data]", "<ul>" & local.data & "</ul>", "all")>
                            <cfset local.data = "">
                            <cfoutput>#local.lastTR#</cfoutput>
                        </cfif>
                        
                        <cfsavecontent variable="local.lastTR">
                        	<cfoutput>
                            <tr>
                                <td>
									#local.recent.referenceNumber#
                                    <div class="data">
                                        [data]
                                    </div>
                                </td>
                                <td>#local.recent.carrier#</td>
                                <td>#local.recent.loggedDateTime#</td>
                            </tr>
                            </cfoutput>
                        </cfsavecontent>
						<cfset local.data &= "<li><a rel='carrierLogLightBox[#local.recent.Id#]' href='carrierServiceLogXml.cfm?entryId=#local.recent.Id#'>#local.recent.RequestType# - #local.recent.Type#</a></li>" />
					<cfelse>
						<cfset local.data &= "<li><a rel='carrierLogLightBox[#local.recent.Id#]' href='carrierServiceLogXml.cfm?entryId=#local.recent.Id#'>#local.recent.RequestType# - #local.recent.Type#</a></li>" />
                    </cfif>
                    
                    <cfset local.lastReference = local.thisReference>
                </cfloop>
            	</tbody>
          	</table>
			<p>&nbsp;</p>
        </cfsavecontent>
        
        <cfreturn local.html>
        
    </cffunction>
    
</cfcomponent>