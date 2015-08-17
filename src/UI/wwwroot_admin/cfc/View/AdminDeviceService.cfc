<cfcomponent output="false" displayname="AdminDeviceService">

	<cffunction name="init" returntype="AdminDeviceService">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getAddAllActiveServices" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_AddAllActiveServicesToDevice">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>	
		
	<cffunction name="getRemoveAllServices" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_RemoveAllActiveServicesToDevice">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>		

	<cffunction name="getAddAllActiveServicesToRateplan" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_AddAllActiveServicesToRatePlan">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>	
		
	<cffunction name="getRemoveAllServicesToRatePlan" returntype="void">
			<cfargument name="deviceGuid" type="string" default="" />
			<cfargument name="channelId" type="numeric" default="" />
			<cfargument name="carrierGuid" type="string" default="" />
			
			<cfstoredproc datasource="wirelessadvocates" procedure="catalog.usp_RemoveAllActiveServicesToRatePlan">
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.deviceGuid#" />
				<cfprocparam cfsqltype="cf_sql_integer" value="#arguments.channelId#" />
				<cfprocparam cfsqltype="cf_sql_varchar" value="#arguments.carrierGuid#" />
			</cfstoredproc>		
	</cffunction>		

	<cffunction name="getEditDeviceServiceForm" returntype="string">
		<cfargument name="deviceGuid" type="string" default="" />
		<cfargument name="serviceGuid" type="string" default="" />
		
		<cfset var local = {} />
		<cfset var buttonText =  "Add Service to Phone" />
		<cfset var device = application.model.AdminPhone.getPhone(arguments.deviceGuid) />
		<cfif device.recordcount is 0>
			<cfset device = application.model.AdminTablet.getTablet(arguments.deviceGuid) />
			<cfset buttonText =  "Add Service to Tablet" />
		</cfif>

		<cfset local = {
				html = '',
				serviceGuid = arguments.serviceGuid,
				deviceGuid = arguments.deviceGuid,
				device = device,
				carrierGuid = local.device.carrierGuid,
				filter = {
					active = true,
					notDevice = local.deviceGuid,
					carrierGuid = local.carrierGuid
				},
				buttonText = buttonText
			} />

		<cfif local.serviceGuid NEQ "">
			<cfset local.deviceService = application.model.AdminDeviceService.getDeviceService(local.serviceGuid, local.deviceGuid) />
			<cfset local.buttonText = "Update Service for Phone" />
		</cfif>

		<cfset local.servicesQry = application.model.AdminDeviceService.getServicesList(local.filter) />

		<cfsavecontent variable="local.html">
			<form class="middle-forms" method="POST">
		    	<h3><cfoutput>#local.buttonText#</cfoutput></h3>
					<fieldset>
						<legend>Add New Service</legend>
				        	<div>
					        	<ol>
					            	<li>
					                    <label class="field-title">Service:</label>
					                    <label>
						                    <cfif local.serviceGuid NEQ "">
							                	<cfset local.service = application.model.ServiceManager.getService(local.serviceGuid) />
							                	<cfoutput>#local.service.Name#</cfoutput>
							                <cfelse>
							                    <select name="serviceGuid">
								                    <option value="">Select a Service</option>
													<cfloop query="local.servicesQry">
														<cfoutput>
															<option value="#local.servicesQry.serviceGuid#" <cfif local.serviceGuid EQ local.servicesQry.serviceGuid> selected="selected"</cfif>>
																#local.servicesQry.name#
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
						<cfif local.serviceGuid EQ "">
							<input type="hidden" value="insertDeviceService" name="action">
						<cfelse>
			                <input type="hidden" value="<cfoutput>#local.serviceGuid#</cfoutput>" name="serviceGuid" />
							<input type="hidden" value="updateDeviceService" name="action">
						</cfif>
						<a href="javascript: void();" onclick="postForm(this);" class="button"><span><cfoutput>#local.buttonText#</cfoutput></span></a>  <a href="javascript: show('action=cancelDeviceServiceEdit');" class="button"><span>Cancel</span></a>
					</form>
				</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getDeviceServiceList" returntype="string">
		<cfargument name="rateplanGuid" type="string" />

		<cfset var local = {
				rateplanGuid = arguments.rateplanGuid
			 } />

	    <cfset local.services = application.model.Catalog.getDeviceServices(local.rateplanGuid) />

        <cfsavecontent variable="local.html">
   			<a href="javascript: show('action=showEditDeviceService');"  class="button" showPanel="" hidePanel=""><span>Add New Service</span></a>
  			<a href="javascript: show('action=showAddAllActiveServices');"  class="button" showPanel="" hidePanel=""><span>Add All Active Services</span></a>
  			<a href="javascript: show('action=showRemoveServices');"  class="button" showPanel="" hidePanel=""><span>Remove All Services</span></a>

               <table id="listDeviceSmall" class="table-long gridview-10">
                   <thead>
                       <tr>
                           <th>Title</th>
                           <th>Active</th>
                           <th>Carrier</th>
                           <th>Bill Code</th>
						   <th><!--- delete button ---></th>
                          <!---  <th>GERS SKU</th> --->
                   	</tr>
                   </thead>

                   <tbody>
                   	<cfloop query="local.services">
						<cfset local.company = application.model.AdminCompany.getCompany(local.services.CarrierGuid) />
                        	<tr class="odd">
                              	<cfoutput>
									<td>#local.services.Title#</a></td>
									<td>#local.services.Active#</td>
                               		<td>#local.company.CompanyName#</td>
                               		<td>#local.services.CarrierBillCode#</td>
								</cfoutput>
								<td><a href="javascript: if(confirm('Are you sure you want to permanently delete this service from this phone? This can not be undone.')) { show('action=deleteDeviceService|serviceGuid=<cfoutput>#local.services.serviceGuid#</cfoutput>'); }" class="table-delete-link" title="Remove this service from this phone">Delete</a></td>
                               <!--- <td>#local.plans.gersSku#</td> --->
                           </tr>
 						</cfloop>
                   </tbody>
               </table>
        </cfsavecontent>

		<cfreturn local.html>
	</cffunction>

</cfcomponent>