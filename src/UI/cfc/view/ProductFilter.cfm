	<cffunction name="renderFilterInterface" returntype="string" output="false" access="public">
		<cfargument name="filterData" type="any" required="true" />
		<cfargument name="productClass" type="string" default="#variables.productClass#" />
		<cfset var local = structNew() />
		<cfset local.resultsMethod = "browse#variables.productClass#Results" />
		<cfset local.filterLabel = variables.labelPlural />
		<cfset local.filterSelections = evaluate("session.#variables.filterType#Selections") />

		<!--- TRV: adding logic to get the various pricing counts for all planTypes --->
		<cfset local.pricing_new = variables.filter.getProductPricing(productClass=arguments.productClass,planType="new") />
		<cfset local.pricing_upgrade = variables.filter.getProductPricing(productClass=arguments.productClass,planType="upgrade") />
		<cfset local.pricing_addaline = variables.filter.getProductPricing(productClass=arguments.productClass,planType="addaline") />

		<!--- generate the HTML content for the filter control --->
		<cfsavecontent variable="local.returnHTML">
			<cfoutput>
				<script language="javascript">
					// Noah 3/4/11 updatePriceCounts function is called on checkbox click for filter
					g_filterURL = '/index.cfm/go/shop/do/#local.resultsMethod#/?#arguments.productClass#Filter.submit=true';

					// create arrays to store the various planType pricing counts
					var pricing_new = new Array();
						pricing_new[0] = 0; // array placeholder to compensate for CF 1-based arrays and JS 0-based arrays
						<cfloop query="local.pricing_new">pricing_new[#local.pricing_new.filterOrder[local.pricing_new.currentRow]#] = #local.pricing_new.filterItemCount[local.pricing_new.currentRow]#;</cfloop>

					var pricing_upgrade = new Array();
						pricing_upgrade[0] = 0; // array placeholder to compensate for CF 1-based arrays and JS 0-based arrays
						<cfloop query="local.pricing_upgrade">pricing_upgrade[#local.pricing_upgrade.filterOrder[local.pricing_upgrade.currentRow]#] = #local.pricing_upgrade.filterItemCount[local.pricing_upgrade.currentRow]#;</cfloop>

					var pricing_addaline = new Array();
						pricing_addaline[0] = 0; // array placeholder to compensate for CF 1-based arrays and JS 0-based arrays
						<cfloop query="local.pricing_addaline">pricing_addaline[#local.pricing_addaline.filterOrder[local.pricing_addaline.currentRow]#] = #local.pricing_addaline.filterItemCount[local.pricing_addaline.currentRow]#;</cfloop>

					updatePriceCounts = function(planType) {
						var pricingArray;
						var i = 0;

						if (planType == 32)	{
							pricingArray = pricing_new;
						}
						else if (planType == 33)	{
							pricingArray = pricing_upgrade;
						}
						else if (planType == 34)	{
							pricingArray = pricing_addaline;
						}

						for (i in pricingArray)
						{
							if (i > 0 && pricingArray[i] && document.getElementById('5_itemCount_'+i))	{ // skip the array placeholder we created
								document.getElementById('5_itemCount_' + i).innerHTML = pricingArray[i];
							}
						}
					}
				</script>

				<form id="filterForm" name="filterForm">
				<div id="filters" class="sidebar left filters">
					<h3>Filter #local.filterLabel#</h3>
					<ul>
					<cfloop from="1" to="#arrayLen(arguments.filterdata)#" index="local.iGroup">
						<li>
							<h4 style="padding-bottom: 3px">#arguments.filterData[local.iGroup].label#</h4>
							<ul>
								<cfset local.thisRow = 1>
								<cfloop from="1" to="#arrayLen(arguments.filterData[local.iGroup].filterOptions)#" index="local.iOption">
									<li>
										<span style="padding-bottom: 3px"><input type="<cfif arguments.filterData[local.iGroup].allowSelectMultiple>checkbox<cfelse>radio</cfif>" id="filterOption_#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId#" name="filter.#arguments.filterData[local.iGroup].fieldName#" value="#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId#" <cfif structKeyExists(local.filterSelections,"filterOptions") and listFindNoCase(local.filterSelections['filterOptions'],arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionId)> checked="CHECKED"</cfif> filter="true" /><label for="filter_#arguments.filterData[local.iGroup].fieldName#_#arguments.filterData[local.iGroup].filterOptions[local.iOption].filterOptionID#" style="margin: 0px; padding: 0px"><span style="vertical-align: top">#arguments.filterData[local.iGroup].filterOptions[local.iOption].label#</span></label></span>
									</li>
									<cfset local.thisRow = local.thisRow + 1>
								</cfloop>
							</ul>
						</li>
					</cfloop>

					<input type="hidden" id="hiddenFilterOptions" name="filter.filterOptions" value="" />
					<input type="hidden" id="LogoutNow" name="LogoutNow" value="#request.LogoutNow#" />

					</ul>
					<script language="javascript">				
						jQuery(document).ready(function($) {

							$('input[filter]').each(function() {

								$(this).bind('click', function() {

									if (jQuery(this).val() == '35' && jQuery(this).attr('checked'))
									{
										window.location.href = '/index.cfm/go/shop/do/browsePrepaids/';
										return;
									}

									updateHiddenFilterOptions();

									<cfif listFindNoCase("phone,dataCardAndNetbook",arguments.productClass)>
										updatePriceCounts($(this).val());
									</cfif>

									BeginUpdateFilter();

									if ( $(this).attr('name') == 'filter.carrier' )
									{
										updateProductListingBanner();
									}
								});

								if ((jQuery(this).val() == '32' || jQuery(this).val() == '33' || jQuery(this).val() == '34') && jQuery(this).attr('checked'))
									updatePriceCounts(jQuery(this).val());
							});
							
							updateProductListingBanner();
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
						
						updateProductListingBanner  = function() {

							if (jQuery("input[name='filter.carrier']:checked").attr('checked', true).length == 1)
							{
								var filterId = jQuery("input[name='filter.carrier']:checked").attr('checked', true).get(0).value;
								var carrierFilterId = 0;
								
								switch (filterId)
								{
									case '1':
										carrierFilterId = 109; //AT&T
										break;
									case '2':
										carrierFilterId = 128; //T-Mobile
										break;
									case '3':
										carrierFilterId = 42; //Verizon Wirless
										break;
									case '230':
										carrierFilterId = 299; //Sprint
										break;
								}
								
								jQuery.ajax({
									url: <cfoutput>'http://#CGI.server_name#:#CGI.server_port#/Content-asp/ShowContent.aspx?l=df97a80e-e13a-442b-ae02-b7775aa9fd65&filterCarrier=' + carrierFilterId</cfoutput>,
									context: document.body,
									success: function(data) {
										jQuery('##banner-container').html(data);
										jQuery('##banner-container').slideDown('slow');
									},
									cache: false
								});
							}
							else
							{
									jQuery.ajax({
									url: <cfoutput>'http://#CGI.server_name#:#CGI.server_port#/Content-asp/ShowContent.aspx?l=e7fab9b5-37a3-4de1-a211-7870254c738f'</cfoutput>,
									context: document.body,
									success: function(data) {
										jQuery('##banner-container').html(data);
										jQuery('##banner-container').slideDown('slow');
									},
									cache: false
								});
							}
						}
					</script>
				</div>
				</form>
				<!---<cfset AjaxOnLoad('InitDiv') />--->
			</cfoutput>
		</cfsavecontent>
		<cfreturn local.returnHTML />
	</cffunction>
