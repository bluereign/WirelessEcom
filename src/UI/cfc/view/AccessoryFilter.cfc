<cfcomponent output="false" displayname="AccessoryFilter">

	<cffunction name="init" returntype="AccessoryFilter">
		<cfreturn this />
	</cffunction>

	<cffunction name="renderFilterInterface" returntype="string">
		<cfargument name="filterData" type="any" required="true">
		<cfargument name="DeviceFilterData" type="any" required="true">
		
		<!--- todo: receive deviceFilterData --->
		<cfset var local = {} />

		<cfset local.filterSelections = session.accessoryFilterSelections>

		<!--- generate the HTML content for the filter control --->
		<cfsavecontent variable="local.returnHTML">
			<cfoutput>
				<script language="javascript">
					<!--//
					g_filterURL = "/index.cfm/go/shop/do/browseAccessoriesResults/?accessoryFilter.submit=true";
					//-->
				</script>
				<form id="filterForm" name="filterForm">
				<div id="filters" class="sidebar left filters">
					<h3>Filter Accessories</h3>
					<ul>
					<cfloop from="1" to="#arrayLen(arguments.filterdata)#" index="local.iGroup">
						<li>
							<h4>#arguments.filterData[local.iGroup].label#</h4>
							<cfif arguments.filterData[local.iGroup].fieldname EQ "device">
								<select style="width: 140px;" 
									id="accessoryDevices">
									<option value="0">All Devices</option>
									<cfloop query="arguments.DeviceFilterData">
										<option value="#arguments.DeviceFilterData.phoneId#"
												name="deviceIdFilter"
												<cfif structKeyExists(request.p, "filter.phoneId") and 
														request.p.filter.phoneId EQ arguments.DeviceFilterData.phoneId> 
														selected
													</cfif>>
											#arguments.DeviceFilterData.summaryTitle#
										</option>
									</cfloop>
								</select>
								<div id="univesalContainer" style="display: none; margin: 5px;">
									<input type="checkbox" id="isForDevice" name="isForDevice" filter="true">
									<label for="isForDevice">
										Made for Device
									</label>
								</div>
							<cfelse>
								<ul>
									<cfset local.thisRow = 1>
									<cfloop from="1" to="#arrayLen(arguments.filterData[local.iGroup].filterOptions)#" index="local.iOption">
										<li>
											<input type="<cfif arguments.filterData[local.iGroup].allowSelectMultiple>checkbox<cfelse>radio</cfif>" 
												id="filterOption_#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId#" 
												name="filter.#arguments.filterData[local.iGroup].fieldName#" 
												value="#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId#" 
												<cfif structKeyExists(local.filterSelections,"filterOptions") and 
														listFindNoCase(local.filterSelections['filterOptions'],arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId)> 
													checked="CHECKED"
												</cfif> filter="true">
											<label for="filter_#arguments.filterData[local.iGroup].fieldName#_#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionID#">
												#arguments.filterData[local.iGroup].filterOptions[local.iOption].label#
											</label>
										</li>
										<cfset local.thisRow = local.thisRow + 1>
									</cfloop>
								</ul>
							</cfif>
						</li>
					</cfloop>
					<input type="hidden" id="hiddenFilterOptions" name="filter.filterOptions" value="" />
					<input type="hidden" id="LogoutNow" name="LogoutNow" value="#request.LogoutNow#" />
					
					</ul>
					<script language="javascript">
						jQuery(document).ready(function($) {
							$('input[filter]').each(function() {
								$(this).bind('click', function() {
									updateHiddenFilterOptions();
									BeginUpdateFilter();
								});
							});
							
							$("##accessoryDevices").change(function() {
								updateHiddenFilterOptions();
								BeginUpdateFilter();
								
								if($(this).val() != 0){
									if($("##univesalContainer").is(":hidden")){
										$("##univesalContainer").fadeIn("slow");
									}
								} else {
									// uncheck isForDevice
									$("##isForDevice").prop("checked", false);
									$("##univesalContainer").fadeOut("slow");
								}						
							});
							
							// if accessoryDevices has phone selected show the universal checkbox.
							if($("##accessoryDevices").val() != 0){
								$("##univesalContainer").css("display", "block");
							}
						});

						updateHiddenFilterOptions = function() {
							var checkedFilterOptions = '0';
							
							jQuery('##hiddenFilterOptions').val(checkedFilterOptions);
							jQuery('input[filter]').each(function() {
								if (jQuery(this).attr('checked'))
									checkedFilterOptions = checkedFilterOptions + ',' + jQuery(this).val();
							});
							
							jQuery("##accessoryDevices").each(function() {
								checkedFilterOptions = checkedFilterOptions + ',' + jQuery(this).val();
							});
							
							jQuery('##hiddenFilterOptions').val(checkedFilterOptions);
						}
					</script>
				</div>
				</form>
				<!---<cfset AjaxOnLoad('InitDiv') />--->
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.returnHTML />
	</cffunction>

</cfcomponent>