<cfcomponent output="false" displayname="PropertyManager">

	<cffunction name="init" access="public" returntype="PropertyManager" output="false">

		<cfreturn this />
	</cffunction>

	<cffunction name="formatProperty" access="public" returntype="string" output="false">
		<cfargument name="value" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.value = trim(arguments.value) />

		<cfif not len(arguments.value)>
			<cfset local.value = 'N/A' />
		<cfelseif local.value is 'true' or local.value is 'false'>
			<cfif local.value is 'true'>
				<cfset local.value = 'Yes' />
			<cfelse>
				<cfset local.value = 'No' />
			</cfif>
		</cfif>

		<cfreturn local.value />
	</cffunction>

	<cffunction name="getPropertyTable" access="public" returntype="string" output="false">
		<cfargument name="properties" required="true" type="query" />
		<cfargument name="formwrap"	required="false" type="boolean" default="true" />

		<cfset var local = structNew() />
		<cfset local.properties = arguments.properties />
		<cfset local.propertiesList = valueList(local.properties.propertyGuid) />

		<cfsavecontent variable="local.html">
			<cfif local.properties.recordCount>
				<!--- If arguments.formwrap is true then we wrap = tab in it's own form (legacy logic). 
				      If arguments.formwrap is false then the caller will do the wrapping
				--->
				<cfif arguments.formwrap><form method="post"><input type="hidden" name="action" value="bulkUpdateAssigned" /></cfif>	
				<!---End of formwrap logic --->	
								
					<input type="hidden" name="allProperties" value="<cfoutput>#local.propertiesList#</cfoutput>" />
					<table class="table-long">
						<thead>
							<tr>
								<td>Group</td>
								<td>Label</td>
								<td>Value</td>
								<td class="center">Active</td>
								<td>Auto Update</td>
								<td>&nbsp;</td>
							</tr>
						</thead>
						<tfoot>
							<tr>
								<td colspan="3">&nbsp;</td>
								<td class="center"><a href="javascript:void();" onclick="postForm(this);" class="button"><span>Update</span></a></td>
								<td colspan="2">&nbsp;</td>
							</tr>
						</tfoot>
						<tbody>
							<cfset local.lastGroupName = '' />
							<cfset local.rowClass = 'odd' />

							<cfloop query="local.properties">
								<cfset local.groupLabel = trim(local.properties.groupLabel) />

								<cfif local.properties.groupLabel is local.lastGroupName>
									<cfset local.groupLabel = '' />
								</cfif>

								<cfif local.rowClass is 'odd'>
									<cfset local.rowClass = '' />
								<cfelse>
									<cfset local.rowClass = 'odd' />
								</cfif>

								<cfif len(local.groupLabel) gt 0>
									<cfoutput>
										<tr class="group">
											<td colspan="6">#trim(local.groupLabel)#</td>
										</tr>
									</cfoutput>
								</cfif>

								<cfoutput>
									<tr>
										<td>&nbsp;</td>
										<td class="col-second">#trim(local.properties.propertyLabel)#</td>
										<cfset local.tmpval = formatProperty(local.properties.value) />
										<cfif local.tmpval is "N/A"><cfset local.tmpval = ""/></cfif>
										<input type="hidden" name="origvalue_#local.properties.propertyGuid#" value="#local.properties.value#" />
										<td class="col-second"><textarea name="newvalue_#local.properties.propertyGuid#" placeholder="enter value..." class="autosizeme">#local.tmpval#</textarea></td>
										<!---<td class="col-second"><input name="newvalue_#local.properties.propertyGuid#" type="text" size="25" value="#local.tmpval#" placeholder="enter value..."></td>--->
										<td class="center"><input type="checkbox" name="active" <cfif local.properties.active eq true>checked</cfif> value="#local.properties.propertyGuid#" /></td>
										<td><input type="checkbox" <cfif local.properties.lastModifiedBy is 'catalog'>checked</cfif> disabled="disabled" name="images" /></td>
										<td class="row-nav"><a href="javascript:show('action=showEditProperty|propertyId=#local.properties.propertyGuid#');" class="table-edit-link">Edit</a> <span class="hidden"> | </span> <a href="javascript:if(confirm('Are you sure you want to permanently delete this property. This can not be undone.')) { show('action=deleteProperty|propertyId=#local.properties.propertyGuid#'); }" class="table-delete-link">Delete</a></td>
									</tr>
								</cfoutput>

								<cfset local.lastGroupName = trim(local.properties.groupLabel) />
							</cfloop>
						</tbody>
					</table>
				<!--- if formwrap --->
				<cfif arguments.formwrap></form></cfif>
				<!--- end of form wrapping logic --->
			<cfelse>
				<p>No properties within this property type.</p>
				<p>&nbsp;</p>
			</cfif>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="getPropertyTableTab" access="public" returntype="string" output="false">
		<cfargument name="properties" required="true" type="query" />

		<cfset var local = structNew() />
		<cfset local.properties = arguments.properties />
		<cfset local.propertiesList = valueList(local.properties.propertyGuid) />

		<cfsavecontent variable="local.html">
			<cfoutput query="local.properties" group="groupLabel">
				<table cellpadding="0" cellspacing="0" border="0" style="margin-left: auto; margin-right: auto">
					<thead>
						<tr>
							<th colspan="3">#trim(groupLabel)#</th>
						</tr>
					</thead>
					<cfoutput>
						<tr valign="top">
							<td class="dataPoint" style="width: 25px">&nbsp;</td>
							<td style="text-align: left">#trim(propertyLabel)#</td>
							<td width="200" style="text-align: right">#formatProperty(trim(value))#&nbsp;</td>
						</tr>
					</cfoutput>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="getStrayPropertyTable" access="public" returntype="string" output="false">
		<cfargument name="properties" required="true" type="query" />

		<cfset var local = structNew() />
		<cfset local.properties = arguments.properties />

		<cfset local.aliases = application.model.propertyManager.getPropertyMasterLabels() />

		<cfsavecontent variable="local.html">
			<cfif local.properties.recordCount>
				<table class="table-long">
					<thead>
						<tr>
							<td>Label</td>
							<td>Value</td>
							<td>Auto Update</td>
							<td>&nbsp;</td>
						</tr>
					</thead>
					<tbody>
						<cfset local.rowClass = 'odd' />

						<cfloop query="local.properties">
							<cfif local.rowClass is 'odd'>
								<cfset local.rowClass = '' />
							<cfelse>
								<cfset local.rowClass = 'odd' />
							</cfif>

							<cfoutput>
								<tr class="#local.rowClass#">
									<td class="col-second">#trim(local.properties.name)#</td>
									<td class="col-second">#formatProperty(trim(local.properties.value))#</td>
									<td><input type="checkbox" <cfif local.properties.lastModifiedBy is 'catalog'>checked</cfif> disabled="disabled" /></td>
									<td class="row-nav"><a href="javascript:show('action=showEditProperty|propertyId=#local.properties.propertyGuid#');" class="table-edit-link">Edit</a> <span class="hidden"> | </span> <a href="javascript:if(confirm('Are you sure you want to permanently delete this property. This can not be undone.')) { show('action=deleteProperty|propertyId=#local.properties.propertyGuid#'); }" class="table-delete-link">Delete</a></td>
								</tr>
							</cfoutput>
						</cfloop>
					</tbody>
				</table>
			<cfelse>
				<p>No unnasigned properties.</p>
			</cfif>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

	<cffunction name="getEditPropertyForm" access="public" returntype="string" output="false">
		<cfargument name="propertyId" required="false" type="string" default="" />

		<cfset var local = structNew() />
		<cfset local.propertyId = arguments.propertyId />

		<cfset local.aliases = application.model.propertyManager.getPropertyMasterLabels() />

		<cfset local.property = structNew() />
		<cfset local.property.name = '' />
		<cfset local.property.value = '' />
		<cfset local.property.isActive = false />
		<cfset local.property.propertyMasterGuid = '' />

		<cfif len(local.propertyId) gt 0>
			<cfset local.propertyDetails = application.model.propertyManager.getPropertyByPropertyId(local.propertyId) />
			<cfset local.property.name = local.propertyDetails.name />
			<cfset local.property.value = local.propertyDetails.value />
			<cfset local.property.propertyMasterGuid = local.propertyDetails.propertyMasterGuid />
			<cfset local.property.isActive = local.propertyDetails.active />
		</cfif>

		<cfsavecontent variable="local.html">
			<cfoutput>
				<form class="middle-forms" name="updateProperty" method="post">
					<cfif len(local.propertyId) eq 0>
						<h3>New Property</h3>
					<cfelse>
						<h3>Edit Property</h3>
					</cfif>

					<fieldset>
						<legend>Edit Property</legend>
						<ol>
							<li>
								<label class="field-title">Label: </label>
								<label>
									<select name="propertyMasterGuid">
										<option value="" selected="selected">Unnasigned</option>
										<cfloop query="local.aliases">
											<cfoutput>
												<cfset local.selected = '' />

												<cfif local.property.propertyMasterGuid eq local.aliases.propertyMasterGuid>
													<cfset local.selected = 'selected' />
												</cfif>

												<option value="#local.aliases.propertyMasterGuid#" #local.selected#>#local.aliases.productType# > #local.aliases.propertyType# > #local.aliases.label#</option>
											</cfoutput>
										</cfloop>
									</select>
								</label>
								<span class="clearFix">&nbsp;</span>
							</li>
							<li>
								<label class="field-title">Value: </label>
								<label>
									<cfset local.rows = 3 />

									<cfif len(local.property.value) gt 200>
										<cfset local.rows = 7 />
									</cfif>

									<textarea name="propertyValue" class="property-input" id="propertyValue">#local.property.value#</textarea>
								</label>
								<span class="clearFix">&nbsp;</span>
							</li>
							<li>
								<label class="field-title"></label>
								<label><div>Note: Enter True or False for boolean values.</div></label>
								<span class="clearFix">&nbsp;</span>
							</li>
							<li class="even">
								<label class="field-title">Active: </label>
								<label>
									<input type="checkbox" <cfif local.property.isActive eq true>checked</cfif> name="isActive" id="isActive" />
								</label>
								<span class="clearFix">&nbsp;</span>
							</li>
						</ol>
					</fieldset>
					<input type="hidden" value="#local.propertyId#" name="propertyId" />
					<input type="hidden" value="updateProperty" name="action" />

					<a href="javascript:void();" onclick="postForm(this);" class="button"><span>Save Property</span></a> <a href="javascript:show('action=cancelPropertyEdit');" class="button"><span>Cancel</span></a>
				</form>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>
</cfcomponent>