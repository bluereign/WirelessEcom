<cfcomponent output="false" displayname="AdminDevicePlan">

	<cffunction name="init" returntype="AdminDevicePlan">
    	<cfreturn this>
    </cffunction>
    
	<cffunction name="getAddAllActivePlans" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_AddAllActiveRateplansToDevice">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>	
		
	<cffunction name="getRemoveAllPlans" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_RemoveAllActiveRateplansToDevice">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>		
	
	<cffunction name="getAddAllActiveDevices" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_AddAllActiveDevicesToRateplan">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>	
		
	<cffunction name="getRemoveAllDevices" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_RemoveAllActiveDevicesToRatePlan">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>		
	

	<cffunction name="getEditDevicePlanForm" returntype="string">
		<cfargument name="deviceGuid" type="string" default="" />
		<cfargument name="planGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				planGuid = arguments.planGuid,
				deviceGuid = arguments.deviceGuid,
				device = application.model.AdminPhone.getPhone(local.deviceGuid),
				carrierGuid = local.device.carrierGuid,
				filter = {
					active = true,
					notDevice = local.deviceGuid,
					carrierGuid = local.carrierGuid
				},
				buttonText = "Add Plan to Phone"
			} />

		<cfif local.planGuid NEQ "">
			<cfset local.devicePlan = application.model.AdminDevicePlan.getDevicePlan(local.planGuid, local.deviceGuid) />
			<cfset local.buttonText = "Update Plan for Phone" />
		</cfif>

		<cfset local.plansQry = application.model.AdminDevicePlan.getPlansList(local.filter) />

		<cfsavecontent variable="local.html">
			<form class="middle-forms" method="POST">
		    	<h3><cfoutput>#local.buttonText#</cfoutput></h3>
					<fieldset>
						<legend>Add New Plan</legend>
				        	<div>
					        	<ol>
					            	<li>
					                    <label class="field-title">Plan:</label>
					                    <label>
						                    <cfif local.planGuid NEQ "">
							                	<cfset local.plan = application.model.Plan.getService(local.serviceGuid) />
							                	<cfoutput>#local.service.Name#</cfoutput>
							                <cfelse>
							                    <select name="planGuid">
								                    <option value="">Select a Plan</option>
													<cfloop query="local.plansQry">
														<cfoutput>
															<option value="#local.plansQry.RatePlanGuid#" <cfif local.planGuid EQ local.plansQry.RatePlanGuid> selected="selected"</cfif>>
																#local.plansQry.name#
															</option>
														</cfoutput>
													</cfloop>
												</select>
											</cfif>
										</label>
					                    <span class="clearFix">&nbsp;</span>
					            	</li>
					            </ol>
							</div>
				    	</fieldset>

		                <input type="hidden" value="<cfoutput>#local.deviceGuid#</cfoutput>" name="deviceGuid" />
						<!--- TODO: implement user integration to get the creator --->
						<cfif local.planGuid EQ "">
							<input type="hidden" value="insertDevicePlan" name="action">
						<cfelse>
			                <input type="hidden" value="<cfoutput>#local.planGuid#</cfoutput>" name="planGuid" />
							<input type="hidden" value="updateDevicePlan" name="action">
						</cfif>
						<a href="javascript: void();" onclick="postForm(this);" class="button"><span><cfoutput>#local.buttonText#</cfoutput></span></a>
						<a href="javascript: show('action=cancelDevicePlanEdit');" class="button"><span>Cancel</span></a>
					</form>
				</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getDevicePlanList" returntype="string">
		<cfargument name="deviceGuid" type="string" />

		<cfset var local = {
				deviceGuid = arguments.deviceGuid
			 } />

        <cfset local.plans = application.model.Catalog.getDeviceRateplans(local.deviceGuid) />

        <cfsavecontent variable="local.html">
				<form method="POST">
		        	<a href="javascript: show('action=showEditDevicePlan');"  class="button" showPanel="" hidePanel="">
						<span>Add New Plan</span>
					</a>
		        	<a href="javascript: show('action=showAddAllActivePlans');"  class="button" showPanel="" hidePanel="">
						<span>Add All Active Plans</span>
					</a>
		        	<a href="javascript: show('action=showRemoveAllPlans');"  class="button" showPanel="" hidePanel="">
						<span>Remove All Plans</span>
					</a>
					<cfoutput>
	                <table id="listPlanSmall" class="table-long gridview-momt-phones4plans">
<!---	                    <thead>
	                        <tr>
							<th class="hidden-col">MG</th>	<!--- hide column - we want it there for sorting but not displayed --->						
							<th>Channel</th>
							<th>Title</th>
							<th>Active</th>
							<th>Carrier</th>
							<th>UPC</th>
							<th>Product ID</th>
							<th>GERS SKU</th>
							<th>Created</th>
							<th class="hidden-col">R</th> <!--- hide column, only there for debugging --->
	                        </tr>
	                    </thead>
						<tbody>
							<cfset guidbreak = "" />
							<cfset guidCount = 0 />
							<cfset oddeven = 0 />
							<cfloop query="local.plans">
								<cfif guidbreak is not trim(local.plans.matchingGUID)>
									<cfset oddeven = oddeven xor 1 />
									<cfset guidbreak = local.plans.matchingGUID />
									<cfset guidCount = guidCount+1 />
								</cfif>
								<tr class="<cfif oddeven is 1>momt-odd-group<cfelse>momt-even-group</cfif>">
									<cfif not len(trim(local.plans.title[local.plans.currentRow]))>
										<cfif len(trim(local.plans.name[local.plans.currentRow]))>
											<cfset local.displayTitle = trim(local.plans.name[local.plans.currentRow]) />
										<cfelse>
											<cfset local.displayTitle = 'No Title or Name Set' />
										</cfif>
									<cfelse>
										<cfset local.displayTitle = trim(local.plans.title[local.plans.currentRow]) />
									</cfif>
									
									<td class="hidden-col">#guidCount#</td>
									<td>#trim(local.plans.channel)#</td>
									<td><a href="?c=37c8ca4d-ddbe-4e19-beda-aa49e85a4c68&productguid=#local.plans.ratePlanGuid[local.plans.currentRow]#">#trim(local.displayTitle)#</a></td>
									<td>#yesNoFormat(trim(local.plans.active[local.plans.currentRow]))#</td>
									<td>#trim(local.plans.carrier[local.plans.currentRow])#</td>
									<td>#trim(local.plans.upc[local.plans.currentRow])#</td>
									<td>#trim(local.plans.productId[local.plans.currentRow])#</td>
									<td>#trim(local.plans.gersSku[local.plans.currentRow])#</td>
									<td>#dateformat(trim(local.plans.createDate[local.plans.currentRow]),"mm/dd/yyyy")#</td>
									<td class="hidden-col">#local.plans.currentRow#</td>
								</tr>
								
							</cfloop>
						</tbody>
--->
	                    <thead>
	                        <tr>
							<th>Title</th>
							<th>Active</th>
							<th>Carrier</th>
							<th>Bill Code</th>
							<th>Default</th>
							<th></th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                    	<cfloop query="local.plans">
	                            <tr>

									<td>
										<!--- dsp_EditPlanDetails.cfm --->
										<a href="?c=37c8ca4d-ddbe-4e19-beda-aa49e85a4c68&productguid=#local.plans.RatePlanGuid#">
											#local.plans.DetailTitle#
										</a>
									</td>
	                                <td class="center">#local.plans.Active#</td>
	                                <td>#local.plans.CompanyName#</td>
	                                <td>#local.plans.CarrierBillCode#</td>
	                                <td class="center">
		                                <input type="radio" name="isDefaultRateplanGuid" value="#local.plans.RatePlanGuid#" <cfif local.plans.IsDefaultRateplan>checked="checked"</cfif> />
										#local.plans.IsDefaultRateplan#
									</td>
									<td>
										<a href="javascript: if(confirm('Are you sure you want to permanently delete this plan from this phone? This can not be undone.')) { show('action=deleteDevicePlan|planGuid=<cfoutput>#local.plans.ratePlanGuid#</cfoutput>'); }" class="table-delete-link" title="Remove this plan from this phone">
											Delete
										</a>
									</td>
	                            </tr>
	  						</cfloop>
	                    </tbody>.
	                </table>
					<input type="hidden" name="phoneGuid" value="<cfoutput>#local.deviceGuid#</cfoutput>" />
	    			<input type="hidden" name="action" value="updateDefaultPhone" />
	    			<a href="javascript: void();" onclick="postForm(this);" class="button" title="Update Default Plan"><span>Update Default Plan</span></a>

				</form>
            </cfoutput>
        </cfsavecontent>

        <cfreturn local.html>

    </cffunction>

</cfcomponent>