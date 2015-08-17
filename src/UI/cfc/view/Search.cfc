<cfcomponent output="false" displayname="Search">

	<cffunction name="init" returntype="Search">
		<!--- Remove this when this component is added to CS --->        
        <cfset setAssetPaths( application.wirebox.getInstance("assetPaths") ) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="searchResults" returntype="string">
		<cfargument name="results" type="Struct" required="true">
		<cfargument name="suggestedSpelling" type="String" required="true">
		<cfset var local = arguments>

		<cfscript>
			// TRV: break the search results down by itemType so we can group them by like itemType to the user
			local.phone = application.view.Search.getItemTypeResultsFromResults(results=local.results.response.docs,itemType="Phone");
			local.tablet = application.view.Search.getItemTypeResultsFromResults(results=local.results.response.docs,itemType="tablet");
			local.dataCardAndNetbook = application.view.Search.getItemTypeResultsFromResults(results=local.results.response.docs,itemType="DataCardAndNetBook");
			local.prePaid = application.view.Search.getItemTypeResultsFromResults(results=local.results.response.docs,itemType="PrePaid");
			local.accessory = application.view.Search.getItemTypeResultsFromResults(results=local.results.response.docs,itemType="Accessory");
			local.plan = application.view.Search.getItemTypeResultsFromResults(results=local.results.response.docs,itemType="Plan");
			local.warranty = application.view.Search.getItemTypeResultsFromResults(results=local.results.response.docs,itemType="Warranty");

			// TRV: determing which itemTypes yielded the most matches, and order them from most matches to fewest matches
			local.stcItemTypes = structNew();
			local.aSortedItemTypes = [];

			if (arrayLen(local.phone))
			{
				local.stcItemTypes.phone = arrayLen(local.phone);
				arrayAppend(local.aSortedItemTypes, 'phone'); 
			}
				
			if (arrayLen(local.tablet))
			{
				local.stcItemTypes.tablet = arrayLen(local.tablet);
				arrayAppend(local.aSortedItemTypes, 'tablet'); 
			}
				
			if (arrayLen(local.prePaid))
			{
				local.stcItemTypes.prePaid = arrayLen(local.prePaid);	
				arrayAppend(local.aSortedItemTypes, 'prepaid'); 
			}
							
			if (arrayLen(local.dataCardAndNetbook))
			{
				local.stcItemTypes.dataCardAndNetbook = arrayLen(local.dataCardAndNetbook);
				arrayAppend(local.aSortedItemTypes, 'dataCardAndNetbook'); 
			}
				
			if (arrayLen(local.accessory))
			{
				local.stcItemTypes.accessory = arrayLen(local.accessory);
				arrayAppend(local.aSortedItemTypes, 'accessory'); 
			}
				
			if (arrayLen(local.plan))
			{
				local.stcItemTypes.plan = arrayLen(local.plan);
				arrayAppend(local.aSortedItemTypes, 'plan'); 
			}
			
			if (arrayLen(local.warranty))
			{
				local.stcItemTypes.warranty = arrayLen(local.warranty);
				arrayAppend(local.aSortedItemTypes, 'warranty'); 
			}			
		</cfscript>

		<!--- TRV: determine if we found any results --->
		<cfset local.countResults = 0>
		<cfloop from="1" to="#arrayLen(local.aSortedItemTypes)#" index="local.iType">
			<cfset local.data = application.model[local.aSortedItemTypes[local.iType]].getByFilter( idList=arrayToList(evaluate("local.#local.aSortedItemTypes[local.iType]#")), allowHidden = true )>
			<cfset local.countResults = local.countResults + local.data.recordCount>
		</cfloop>

		<cfsavecontent variable="local.html">
			<cfoutput>
			<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/filter.js" ></script>
			<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/compare_searchResults.js" ></script>
			<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/tooltip.js" ></script>
			<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/details.js" ></script>
			<script type="text/javascript" language="javascript" src="#getAssetPaths().common#scripts/searchTabs.js" ></script>
			<script type="text/javascript" language="javascript">
			<!--//
				itemsLoaded = function ()
				{
					var priceTabClass = 'new';
					InitPriceTabs();
					InitCompareCheckbox();
					InitTooltips();
				}
			//-->
			</script>

			<style> <!--- TRV: for some reason, placing these SAME CSS declarations in a .css file and including it at this point doesn't work, so injecting them inline on this page --->
				<!--//
					UL.tabNavigation
					{
						list-style: none;
						margin: 0;
						padding: 0;
					}
					
					UL.tabNavigation LI
					{
						display: inline;
					}
					
					UL.tabNavigation LI A
					{
						border:1px solid ##000;
						padding: 5px 8px;
						background-color: ##ddd;
						color: ##666;
						text-decoration: none;
						font-size: 1.2em;
					}
					
					UL.tabNavigation LI A.selected,
					UL.tabNavigation LI A:hover
					{
						background-color: ##2081CA;
						color: ##fff;
						padding-top: 10px;
						font-weight:bold;
					}
					
					UL.tabNavigation LI A:focus
					{
						outline: 0;
					}
					
					div##allResults
					{
						width: 785px;
					}
					
					div.tabs > div
					{
						padding: 5px;
						margin-top: 5px;
						border-top: 1px solid ##333;
						width: 785px;
					}
				//-->
			</style>

			<br />
			<br />
			<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
			<td align="center">
			<div id="allResults" style="text-align:left;">
				<cfif local.countResults>
					<div id="divTabs" class="tabs">
						<ul id="tabNavigation" class="tabNavigation">
							<cfloop from="1" to="#arrayLen(local.aSortedItemTypes)#" index="local.iType">
								<li>
									<cfset local.data = application.model[local.aSortedItemTypes[local.iType]].getByFilter( idList=arrayToList(evaluate("local.#local.aSortedItemTypes[local.iType]#")), allowHidden = true )>
									<!---<a href="###local.aSortedItemTypes[local.iType]#"><cfif local.aSortedItemTypes[local.iType] eq "phone">Phones<cfelseif local.aSortedItemTypes[local.iType] eq "tablet">Tablets<cfelseif local.aSortedItemTypes[local.iType] eq "dataCardAndNetbook">Mobile Hotspots<cfelseif local.aSortedItemTypes[local.iType] eq "prePaid">Prepaids<cfelseif local.aSortedItemTypes[local.iType] eq "accessory">Accessories<cfelseif local.aSortedItemTypes[local.iType] eq "plan">Plans<cfelseif local.aSortedItemTypes[local.iType] eq "warranty">Warranty</cfif> (#local.stcItemTypes[local.aSortedItemTypes[local.iType]]# match<cfif local.stcItemTypes[local.aSortedItemTypes[local.iType]] gt 1>es</cfif>)</span></a>--->
									<a href="###local.aSortedItemTypes[local.iType]#"><cfif local.aSortedItemTypes[local.iType] eq "phone">Phones<cfelseif local.aSortedItemTypes[local.iType] eq "tablet">Tablets<cfelseif local.aSortedItemTypes[local.iType] eq "dataCardAndNetbook">Mobile Hotspots<cfelseif local.aSortedItemTypes[local.iType] eq "prePaid">Prepaids<cfelseif local.aSortedItemTypes[local.iType] eq "accessory">Accessories<cfelseif local.aSortedItemTypes[local.iType] eq "plan">Plans<cfelseif local.aSortedItemTypes[local.iType] eq "warranty">Warranty</cfif> (#local.data.recordcount# match<cfif local.stcItemTypes[local.aSortedItemTypes[local.iType]] gt 1>es</cfif>)</span></a>
								</li>
							</cfloop>
						</ul>
						<cfloop from="1" to="#arrayLen(local.aSortedItemTypes)#" index="local.iType">
							<cfset local.data = application.model[local.aSortedItemTypes[local.iType]].getByFilter( idList=arrayToList(evaluate("local.#local.aSortedItemTypes[local.iType]#")), allowHidden = true )>
							<cfset local.resultOutput = application.view[local.aSortedItemTypes[local.iType]].browseSearchResults(data=local.data,bindAjaxOnLoad=false)>
							<cfset local.resultOutput = replaceNoCase(local.resultOutput,".compareForm.",".compareForm_#local.aSortedItemTypes[local.iType]#.","all")>
							<div id="###local.aSortedItemTypes[local.iType]#" class="tabContent">
								<div id="results_#local.aSortedItemTypes[local.iType]#" class="typeResults">
									<div class="main left <cfif local.aSortedItemTypes[local.iType] eq "phone">phones<cfelseif local.aSortedItemTypes[local.iType] eq "tablet">tablets<cfelseif local.aSortedItemTypes[local.iType] eq "dataCardAndNetbook">phones<cfelseif local.aSortedItemTypes[local.iType] eq "prepaid">phones<cfelseif local.aSortedItemTypes[local.iType] eq "accessory">accessories<cfelseif local.aSortedItemTypes[local.iType] eq "plan">plans</cfif>" style="width:755px;">
										<div id="resultsDiv">
											<form method="get" id="compareForm_#local.aSortedItemTypes[local.iType]#" name="compareForm_#local.aSortedItemTypes[local.iType]#" action="/index.cfm/go/shop/do/compare<cfif local.aSortedItemTypes[local.iType] eq "phone">Phones<cfelseif local.aSortedItemTypes[local.iType] eq "dataCardAndNetbook">DataCardsAndNetbooks<cfelseif local.aSortedItemTypes[local.iType] eq "prePaid">PrePaids<cfelseif local.aSortedItemTypes[local.iType] eq "accessory">Accessories<cfelseif local.aSortedItemTypes[local.iType] eq "plan">Plans</cfif>/">
											<input type="hidden" name="#local.aSortedItemTypes[local.iType]#Filter.submit" value="1"/>
											<cfif local.aSortedItemTypes[local.iType] eq "phone" or local.aSortedItemTypes[local.iType] eq "dataCardAndNetbook" or local.aSortedItemTypes[local.iType] eq "prePaid">
												<input type="hidden" id="formHidden_activationType" name="formHidden_activationType" value="new">
											</cfif>
											#local.resultOutput#
											</form>
										</div>
									</div>
								</div>
							</div>
						</cfloop>
					</div>
				<cfelse>
					<div style="min-height:200px;">
						<h4>
							No results found based on your search criteria (#htmlEditFormat(local.results.responseHeader.params.q)#).
						</h4>
					</div>
				</cfif>
			</div>
			</td>
			</tr>
			</table>
			<script language="javascript">
			<!--//
				window.onload = itemsLoaded;
			//-->
			</script>
			</cfoutput>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>

	<cffunction name="getItemTypeResultsFromResults" access="public" output="false" returntype="array">
		<cfargument name="results" type="array" required="true">
		<cfargument name="itemType" type="string" required="true">
		<cfset var local = structNew()>
		<cfset local.return = arrayNew(1)>

		<cfloop from="1" to="#arrayLen(arguments.results)#" index="local.i">
			<cfif arguments.results[local.i].itemType eq arguments.itemType>
				<cfset arrayAppend(local.return,arguments.results[local.i].productId)>
			</cfif>
		</cfloop>

		<cfreturn local.return>
	</cffunction>
	
	<cffunction name="getAssetPaths" access="private" output="false" returntype="struct">    
    	<cfreturn variables.instance.assetPaths />    
    </cffunction>    
    <cffunction name="setAssetPaths" access="private" output="false" returntype="void">    
    	<cfargument name="theVar" required="true" />    
    	<cfset variables.instance.assetPaths = arguments.theVar />    
    </cffunction>

</cfcomponent>