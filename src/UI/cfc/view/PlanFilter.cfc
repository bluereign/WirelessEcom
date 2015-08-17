<cfcomponent output="false" displayname="PlanFilter">

	<cffunction name="init" returntype="PlanFilter">
		<cfreturn this />
	</cffunction>

	<cffunction name="renderFilterInterface" returntype="string">
		<cfargument name="filterData" type="any" required="true">

		<cfset var local = structNew()>

		<cfset local.filterSelections = session.planFilterSelections>

		<!--- generate the HTML content for the filter control --->
		<cfsavecontent variable="local.returnHTML">
			<cfoutput>
				<script language="javascript">
					<!--//
					g_filterURL = "/index.cfm/go/shop/do/browsePlansResults/?planFilter.submit=true";
					//-->
				</script>
				<form id="filterForm" name="filterForm">
				<div id="filters" class="sidebar left filters">
					<h3>Filter Service Plans</h3>
					<ul>
					<cfloop from="1" to="#arrayLen(arguments.filterdata)#" index="local.iGroup">
						<li><h4>#arguments.filterData[local.iGroup].label#</h4>
							<ul>
								<cfset local.thisRow = 1>
								<cfloop from="1" to="#arrayLen(arguments.filterData[local.iGroup].filterOptions)#" index="local.iOption">
									<!--- Removing T-Mobile from non-VFD service plan filter --->
									<cfif ((arguments.filterData[local.iGroup].filterOptions[local.iOption].label) CONTAINS 'T-Mobile')AND(!getChannelConfig().getVfdEnabled())>
										<cfset local.thisRow = local.thisRow + 1>
									<cfelse>
										<li>
											<input type="<cfif arguments.filterData[local.iGroup].allowSelectMultiple>checkbox<cfelse>radio</cfif>" id="filterOption_#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId#" name="filter.#arguments.filterData[local.iGroup].fieldName#" value="#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId#" <cfif structKeyExists(local.filterSelections,"filterOptions") and listFindNoCase(local.filterSelections['filterOptions'],arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId)> checked="CHECKED"</cfif> filter="true"><label for="filter_#arguments.filterData[local.iGroup].fieldName#_#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionID#">#arguments.filterData[local.iGroup].filterOptions[local.iOption].label#</label>
										</li>
										<cfset local.thisRow = local.thisRow + 1>
									</cfif>
								</cfloop>
							</ul>
						</li>
					</cfloop>
					<input type="hidden" id="hiddenFilterOptions" name="filter.filterOptions" value="">
					</ul>
					<script language="javascript">
						jQuery(document).ready(function($) {
							$('input[filter]').each(function() {
								$(this).bind('click', function() {
									updateHiddenFilterOptions();
									BeginUpdateFilter();
								});
							});
						});

						updateHiddenFilterOptions = function() {
							var checkedFilterOptions = '0';
							jQuery('##hiddenFilterOptions').val(checkedFilterOptions);
							jQuery('input[filter]').each(function() {
								if (jQuery(this).attr('checked'))
									checkedFilterOptions = checkedFilterOptions + ',' + jQuery(this).val();
							});
							jQuery('##hiddenFilterOptions').val(checkedFilterOptions);
						}
					</script>
				</div>
				</form>
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.returnHTML />
	</cffunction>
	
	<cffunction name="getChannelConfig" output="false" access="private" returntype="any">
    	<cfreturn application.wirebox.getInstance("ChannelConfig") />
	</cffunction>

</cfcomponent>