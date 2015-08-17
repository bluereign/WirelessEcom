<cfcomponent output="false" displayname="AdminPlanService">

	<cffunction name="init" returntype="AdminPlanService">
    	<cfreturn this>
    </cffunction>
    
	<cffunction name="getEditPlanServiceForm" returntype="string">
		<cfargument name="rateplanGuid" type="string" default="" />
		<cfargument name="serviceGuid" type="string" default="" />
		
		<cfset var local = {
				html = '',
				serviceGuid = arguments.serviceGuid,
				rateplanGuid = arguments.rateplanGuid,
				ratePlan = application.model.AdminPlan.getPlan(local.rateplanGuid),	
				carrierGuid = local.ratePlan.carrierGuid,
				filter = {
					active = true,
					notInPlan = local.rateplanGuid,
					carrierGuid = local.carrierGuid					
				},
				included = false,
				required = false,
				default = false,
				buttonText = "Add Service to Plan"
			} />

		<cfif local.serviceGuid NEQ "">
			<cfset local.planService = application.model.AdminPlanService.getPlanService(local.serviceGuid, local.rateplanGuid) />
			<cfset local.included = local.planService.isIncluded />
			<cfset local.required = local.planService.isRequired />
			<cfset local.default = local.planService.isDefault />
			<cfset local.buttonText = "Update Service for Plan" />
		</cfif>

		<cfset local.servicesQry = application.model.AdminPlanService.getServicesList(local.filter) />
		
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
																#local.servicesQry.name# (#local.servicesQry.CarrierBillCode#)
															</option>
														</cfoutput>												
													</cfloop>
												</select>
											</cfif>
										</label>
					                    <span class="clearFix">&nbsp;</span>
					            	</li>
					                <li class="even">
					                    <label class="field-title" title="Included sets whether this service is included with the plan">Included: </label> 
					                    <label> 
					                        <input type="checkbox" name="included" <cfif local.included eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
					                        Included with Plan 
					                    </label>
					                    <span class="clearFix">&nbsp;</span>
					                </li>					            	
					                <li class="odd">
					                    <label class="field-title" title="Required sets whether this service is required with the plan">Required: </label> 
					                    <label> 
					                        <input type="checkbox" name="required" <cfif local.required eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
					                        Required with Plan 
					                    </label>
					                    <span class="clearFix">&nbsp;</span>
					                </li>					            	
					                <li class="even">
					                    <label class="field-title" title="Default sets whether this service is default with the plan">Default: </label> 
					                    <label> 
					                        <input type="checkbox" name="default" <cfif local.default eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
					                        Required with Plan 
					                    </label>
					                    <span class="clearFix">&nbsp;</span>
					                </li>					            	
					            </ol>
							</div>
				    	</fieldset>
						
		                <input type="hidden" value="<cfoutput>#local.ratePlanGuid#</cfoutput>" name="rateplanGuid" />
						<!--- TODO: implement user integration to get the creator --->
						<cfif local.serviceGuid EQ "">
							<input type="hidden" value="insertPlanService" name="action">
						<cfelse>
			                <input type="hidden" value="<cfoutput>#local.serviceGuid#</cfoutput>" name="serviceGuid" />
							<input type="hidden" value="updatePlanService" name="action">
						</cfif>
						<a href="javascript: void();" onclick="postForm(this);" class="button"><span><cfoutput>#local.buttonText#</cfoutput></span></a>  <a href="javascript: show('action=cancelPlanServiceEdit');" class="button"><span>Cancel</span></a>		
					</form>		
				</cfsavecontent>
				
		<cfreturn local.html />
	</cffunction>
    
	
	<cffunction name="getPlanServiceList" returntype="string">
		<cfargument name="rateplanGuid" type="string" />
	
		<cfset var local = {
				rateplanGuid = arguments.rateplanGuid
			 } />
	         
	    <cfset local.services = application.model.Catalog.getRateplanServices(local.rateplanGuid) />
	
        <cfsavecontent variable="local.html">
   			<a href="javascript: show('action=showEditPlanService');" class="button" showPanel="" hidePanel="">
   				<span>Add New Service</span>
			</a>
		   	<a href="javascript: show('action=showAddAllActiveServicesToRateplan');" class="button" showPanel="" hidePanel="">
			   	<span>Add All Active Services</span>
			</a>
		   	<a href="javascript: show('action=showRemoveServicesToRateplan');" class="button" showPanel="" hidePanel="">
			   	<span>Remove All Services</span>
			</a>
          
               <table id="listPlanSmall" class="table-long gridview-10">
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
								<td><a href="javascript: show('action=showEditPlanService|serviceGuid=<cfoutput>#local.services.serviceGuid#</cfoutput>');" ><cfoutput>#local.services.Title#</cfoutput></a></td>
                              	<cfoutput>
									<td>#local.services.Active#</td>
                               		<td>#local.company.CompanyName#</td>
                               		<td>#local.services.CarrierBillCode#</td>
								</cfoutput>
								<td><a href="javascript: if(confirm('Are you sure you want to permanently delete this service from this plan? This can not be undone.')) { show('action=deletePlanService|serviceGuid=<cfoutput>#local.services.serviceGuid#</cfoutput>'); }" class="table-delete-link" title="Remove this service from this plan">Delete</a></td>
                               <!--- <td>#local.plans.gersSku#</td> --->
                           </tr>
 						</cfloop>
                   </tbody>
               </table>
        </cfsavecontent>
	        
		<cfreturn local.html>
	</cffunction>
	
<cffunction name="getPlanServiceListFiltered" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />

		<cfset var local = structNew() />
		<cfset local.filter = arguments.filter />
		<cfset local.dislayTitle = '' />

		<cfset local.carriers = application.model.Company.getAllCarriers() />
		<cfset local.planServices = application.model.AdminPlanService.getPlanServices(local.filter) />

		
		<cfsavecontent variable="local.js">
		<script>
		    $(function() {
		      $( "#createDateFilter_start" ).datepicker({ minDate: -1000, maxDate: "+0D" });
			  <cfif structKeyExists(local.filter,"createDate_start")>
			 	 $( "#createDateFilter_start" ).datepicker( "setDate", "<cfoutput>#local.filter.createDate_start#</cfoutput>");
			  </cfif>
		      $( "#createDateFilter_start" ).datepicker( "option", "dateFormat", "mm/dd/yy");			  
		      $( "#createDateFilter_end" ).datepicker({ minDate: -1000, maxDate: "+0D" });
			  <cfif structKeyExists(local.filter,"createDate_end")>
			 	 $( "#createDateFilter_end" ).datepicker( "setDate", "<cfoutput>#local.filter.createDate_end#</cfoutput>");
			  </cfif>
		      $( "#createDateFilter_end" ).datepicker( "option", "dateFormat", "mm/dd/yy");
		    });
		</script>	
		</cfsavecontent>
		
		<cfhtmlhead text="#local.js#" />		



		<cfsavecontent variable="local.html">
		<cfoutput>
				<div class="filter-container">
				<form name="filterForm" method="post">
						<label for="carrierIdFilter">Carrier:</label>
						<select id="carrierIdFilter" name="carrierId">
							<option value="">All</option>
							<cfloop query="local.carriers">
								<option value="#CarrierId#" <cfif structKeyExists(local.filter, 'carrierId') && local.filter.carrierId eq carrierId>selected="selected"</cfif>>#CompanyName#</option>
							</cfloop>
						</select>
						<label for="isActiveFilter" style="margin-left:15px;">Is Active:</label>
						<select id="isActiveFilter" name="isActive">
							<option value="">All</option>
							<option value="1" <cfif structKeyExists(local.filter, 'Active') && local.filter.Active eq 1>selected="selected"</cfif>>Yes</option>
							<option value="0" <cfif structKeyExists(local.filter, 'Active') && local.filter.Active eq 0>selected="selected"</cfif>>No</option>
						</select>
						
						<label for="createDateFilter_start" style="margin-left:15px;">Created:</label>
						<input type="text" id="createDateFilter_start" name="createDate_start" size="10" value=""/> - 
						<input type="text" id="createDateFilter_end" name="createDate_end" size="10" value=""/>

						<input name="filterSubmit" type="submit" value="Filter" style="margin-left:25px;" />
					</form>
				</div>
				<table id="listServicesAll" class="table-long gridview-momt-services">
					<thead>
						<tr>
							<th class="hidden-col">MG</th>	<!--- hide column - we want it there for sorting but not displayed --->						
							<th>Channel</th>
							<th>Title</th>
							<th>Active</th>
							<th>Carrier</th>
							<th>Bill Code</th>
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
						<cfloop query="local.planServices">
							<cfif guidbreak is not trim(local.planServices.matchingGUID)>
								<cfset oddeven = oddeven xor 1 />
								<cfset guidbreak = local.planServices.matchingGUID />
								<cfset guidCount = guidCount+1 />
							</cfif>
							<tr class="<cfif oddeven is 1>momt-odd-group<cfelse>momt-even-group</cfif>">
								<cfif not len(trim(local.planServices.title[local.planServices.currentRow]))>
									<cfif len(trim(local.planServices.name[local.planServices.currentRow]))>
										<cfset local.displayTitle = trim(local.planServices.name[local.planServices.currentRow]) />
									<cfelse>
										<cfset local.displayTitle = 'No Title or Name Set' />
									</cfif>
								<cfelse>
									<cfset local.displayTitle = trim(local.planServices.title[local.planServices.currentRow]) />
								</cfif>
								
								<td class="hidden-col">#guidCount#</td>
								<td>#trim(local.planServices.channel)#</td>
								<td><a href="?c=73daf562-5070-444f-9c83-9063567776fe&productGuid=#local.planServices.serviceGuid[local.planServices.currentRow]#">#trim(local.displayTitle)#</a></td>
								<td>#yesNoFormat(trim(local.planServices.active[local.planServices.currentRow]))#</td>
								<td>#trim(local.planServices.carrier[local.planServices.currentRow])#</td>
								<td>#trim(local.planServices.billingCode[local.planServices.currentRow])#</td>
								<td>#trim(local.planServices.productId[local.planServices.currentRow])#</td>
								<td>#trim(local.planServices.gersSku[local.planServices.currentRow])#</td>
								<td>#dateformat(trim(local.planServices.createDate[local.planServices.currentRow]),"mm/dd/yyyy")#</td>
								<td class="hidden-col">#local.planServices.currentRow#</td>
							</tr>
							
						</cfloop>
					</tbody>
				</table>
				<p>&nbsp;</p>
				<p>&nbsp;</p>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

</cfcomponent>