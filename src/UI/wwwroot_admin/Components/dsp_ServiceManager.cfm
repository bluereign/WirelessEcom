<cfset message = '' />
<cfset errorMessage = '' />

<script type="text/javascript">
	$(document).ready(function()	{
		setEvents();
	});

	function setEvents()	{
		$(".connectedSortable").unbind();
		$(".group").unbind();
		$(".editable").unbind();
		$(".connectedSortable").sortable({
			connectWith: '.connectedSortable',
			placeholder: 'ui-state-highlight',
			dropOnEmpty: true,
			handle: '.sort-handle',
			cursor: 'crosshair'
		});
		$(".connected").sortable({
			connectWith: '.connectedSortable',
			placeholder: 'ui-state-highlight',
			dropOnEmpty: true,
			handle: '.sort-handle',
			cursor: 'crosshair',
			scroll: false
		});
		$(".group").sortable({
			connectWith: '.connectedSortableGroup',
			handle: '.sort-handle-group',
			cursor: 'crosshair'
		});
		$('.editable').editable('', {
			type     : 'text',
			submit   : 'Do it!',
			cssclass : 'text-editinplace',
			width    : 'none',
			cancel   : 'Nevermind',
			placeholder : '<i>Click to edit</i>',
			callback : function(value, settings)	{
				if(value.length == 0)	{
					$(this).html(settings.placeholder);
				}
				$(this).attr("labelValue", value);
			}
		});
		//set trash event
		$(".groupItem").find(".trash-icon:first").bind("click", function()	{
			var el = $(this).parents("li:first");
			var guid = $(this).parent().find(".editable").attr("guid");

			//check for any child elements.
			var labels = $(this).parent().find(".propertylist-holder").find("li");

			if(labels.length > 0)	{
				alert("Groups can not be deleted until all services are removed from the group.");

				return;
			}

			var ok = confirm("Are you sure you want to delete this Group?");

			if(ok)	{
				//get the parent element
				$(el).effect("explode",null,550);
				$(el).remove();

				//if there is a guid, add it to the label delete list.
				if(guid.length > 0)	{
					var form = document.getElementById("frmServiceManager");
					var hiddenId = document.createElement("input");

					$(hiddenId).attr("type","hidden");
					$(hiddenId).attr("name","deleteGroupList");
					$(hiddenId).attr("value",guid);
					$(form).append(hiddenId);
				}
			}
		}
	);

	$(".propertylist-holder").children().children().find(".trash-icon").show();

	$(".propertylist-holder").children().children().find(".trash-icon:first").bind("click", function()	{
		var el = $(this).parents("li:first");

		//check for guid. no guid is a delete
		var guid = $(el).children(".editable").attr("guid");
		var ok = true;

		if(guid.length > 0)	{
			ok = confirm("Are you sure you want to remove this Service? It will be moved back to the unasigned list and will not be available online.");
		}

		//remove the element
		if(ok)	{
			//add it to the unasigned list.
			$(".connected").append(el);
			//

			//if there is a guid, add it to the label delete list.
			if(guid.length > 0)	{
				var form = document.getElementById("frmServiceManager");
				var hiddenId = document.createElement("input");

				$(hiddenId).attr("type","hidden");
				$(hiddenId).attr("name","deleteLabelList");
				$(hiddenId).attr("value",guid);
				$(form).append(hiddenId);
			}
		}
		});
	}

	function insertGroup()	{
		//get the current tab id.
		var $tabs = $('#tabs').tabs();
		var selected = $tabs.tabs('option', 'selected');
		var type="I"; //default to included.

		if(selected == 0)	{
			type = "O";
		}

		var groupClone = $("#groupTemplate").contents().clone();

		//update the type of the template group
		var span = (groupClone).find(".group-label");

		$(span).attr("type",type);

		//add the group
		$("#tabs-" + (selected + 1)).find("#groups").prepend(groupClone);
		$(groupClone).find(".property-group").effect("pulsate", { times:1 }, 400);

		setEvents();
	}

	function saveChanges()	{
		var form = document.getElementById("frmServiceManager");

		//loop groups.
		var groups = $("#groups ul.group li.groupItem");

		for(var i = 0; i < groups.length; i++)	{
			//create group
			var groupGuid = $(groups[i]).find(".group-label").attr("guid");
			var label = $(groups[i]).find(".group-label").attr("labelValue");
			var type = $(groups[i]).find(".group-label").attr("type");
			var min = $(groups[i]).find(".group-label").attr("min");
			var max = $(groups[i]).find(".group-label").attr("max");

			//loop labels in this group
			var labels = $(groups[i]).children().find(".connectedSortable").children();

			for(var p = 0; p < labels.length; p++)	{
				//create label
				var labelGuid = $(labels[p]).children(".editable").attr("guid");
				var labelLabel = $(labels[p]).children(".editable").attr("labelValue");
				var labelServiceGUID = $(labels[p]).children(".editable").attr("serviceguid");
				var labelFieldName = "groupLabel_" + i + "_" + p;
				var labelFieldValue = "";
				var labelFieldValue = "groupGuid=" + groupGuid + "|labelGuid=" + labelGuid + "|label=" + labelLabel + "|serviceguid=" + labelServiceGUID;
				var hiddenId = document.createElement("input");

				$(hiddenId).attr("type","hidden");
				$(hiddenId).attr("name",labelFieldName);
				$(hiddenId).attr("value",labelFieldValue);
				$(form).append(hiddenId);
			}

			//build the group input
			var fieldName = "group_" + i;
			var fieldValue = "groupGuid=" + groupGuid + "|label=" + label + "|labelCount=" + labels.length + "|type=" + type + "|min=" + min + "|max=" + max;
			var hiddenId = document.createElement("input");

			$(hiddenId).attr("type","hidden");
			$(hiddenId).attr("name",fieldName);
			$(hiddenId).attr("value",fieldValue);
			$(form).append(hiddenId);
		}

		//set the number of groups.
		var hiddenGroupCount = document.createElement("input");

		$(hiddenGroupCount).attr("type","hidden");
		$(hiddenGroupCount).attr("name","GroupCount");
		$(hiddenGroupCount).attr("value",groups.length);
		$(form).append(hiddenGroupCount);

		var hiddenAction = document.createElement("input");
		$(hiddenAction).attr("type","hidden");
		$(hiddenAction).attr("name","action");
		$(hiddenAction).attr("value","saveServiceGroupChanges");
		$(form).append(hiddenAction);

		form.submit()();
	}
</script>

<cfif structKeyExists(form, 'action')>
	<cfif form.action is 'saveServiceGroupChanges'>
		<cfset groupCount = form.groupCount />
		<cfset groups = arrayNew(1) />

		<!--- delete from the delete lists --->
		<cfif structKeyExists(form, 'deleteLabelList')>
			<cfloop list="#form.deleteLabelList#" delimiters="," index="i">
				<cfset application.model.serviceManager.deleteLabel(i) />
			</cfloop>
		</cfif>

		<cfif structKeyExists(form, 'deleteGroupList')>
			<cfloop list="#form.deleteGroupList#" delimiters="," index="i">
				<cfset application.model.serviceManager.deleteGroup(i) />
			</cfloop>
		</cfif>

		<cfloop index="i" from="1" to="#variables.groupCount#">
			<cfset groups[i] = structNew() />
			<cfset groupValueString = form['group_' & (i - 1)] />
			<cfset groupGuid = '' />
			<cfset groupLabel = '' />
			<cfset groupLabelCount = 0 />
			<cfset attributeList = listToArray(variables.groupValueString, '|', true) />
			<cfset groupGuidA = listToArray(variables.attributeList[1], '=', true) />
			<cfset groupLabelA = listToArray(variables.attributeList[2], '=', true) />
			<cfset groupLabelCountA = listToArray(variables.attributeList[3], '=', true) />
			<cfset groupTypeA = listToArray(variables.attributeList[4], '=', true) />
			<cfset groupMinA = listToArray(variables.attributeList[5], '=', true) />
			<cfset groupMaxA = listToArray(variables.attributeList[6], '=', true) />
			<cfset groupGuid = variables.groupGuidA[2] />
			<cfset groupLabel = variables.groupLabelA[2] />
			<cfset groupLabelCount = variables.groupLabelCountA[2] />
			<cfset groupType = variables.groupTypeA[2] />
			<cfset groupMin = variables.groupMinA[2] />
			<cfset groupMax = variables.groupMaxA[2] />

			<cfif not len(trim(variables.groupMin))>
				<cfset groupMin = 0 />
			</cfif>

			<cfif not len(trim(variables.groupMax))>
				<cfset groupMax = 0 />
			</cfif>

			<cfset groups[i].Guid = variables.groupGuid />
			<cfset groups[i].Label = variables.groupLabel />
			<cfset groups[i].Type = variables.groupType />
			<cfset groups[i].Min = variables.groupMin />
			<cfset groups[i].Max = variables.groupMax />
			<cfset groups[i].labels = arrayNew(1) />

			<cfloop index="k" from="1" to="#variables.groupLabelCount#">
				<cfset labelValueString = form['groupLabel_' & (i - 1) & '_' & (k - 1)] />
				<cfset labelGroupGuid = '' />
				<cfset labelGuid = '' />
				<cfset labelLabel = '' />
				<cfset attributeList = listToArray(variables.labelValueString, '|', true) />
				<cfset labelGroupGuidA = listToArray(variables.attributeList[1], '=', true) />
				<cfset labelGuidA = listToArray(variables.attributeList[2], '=', true) />
				<cfset labelLabelA = listToArray(variables.attributeList[3], '=', true) />
				<cfset labelServiceGUIDA = listToArray(variables.attributeList[4], '=', true) />
				<cfset labelGroupGuid = variables.groupGuid />
				<cfset labelGuid = variables.labelGuidA[2] />
				<cfset labelLabel = variables.labelLabelA[2] />
				<cfset labelServiceGUID = variables.labelServiceGUIDA[2] />
				<cfset groups[i].labels[k] = structNew() />
				<cfset groups[i].labels[k].GroupGuid = variables.labelGroupGuid />
				<cfset groups[i].labels[k].Guid = variables.labelGuid />
				<cfset groups[i].labels[k].Label = variables.labelLabel />
				<cfset groups[i].labels[k].ServiceGUID = variables.labelServiceGUID />
			</cfloop>
		</cfloop>

		<cfloop index="i" from="1" to="#arrayLen(variables.groups)#">
			<cfif len(variables.groups[i].Guid) gt 0>
				<cfset application.model.serviceManager.updateGroup(carrierId, variables.groups[i].Type, variables.groups[i].Guid, variables.groups[i].Label, variables.groups[i].Min, variables.groups[i].Max, i) />
			<cfelse>
				<cfset groups[i].Guid = application.model.serviceManager.getGuid() />
				<cfset application.model.serviceManager.addGroup(form.carrierId, variables.groups[i].Type, variables.groups[i].Guid, variables.groups[i].Label, variables.groups[i].Min, variables.groups[i].Max, i) />
			</cfif>

			<cfset labels = variables.groups[i].labels />

			<cfloop index="l" from="1" to="#arrayLen(variables.labels)#">
				<cfif len(variables.labels[l].Guid) gt 0>
					<cfset application.model.serviceManager.updateLabel(variables.labels[l].Guid, variables.groups[i].Guid, variables.labels[l].Label, variables.labels[l].ServiceGUID, l) />
				<cfelse>
					<cfset variables.labels[l].Guid = application.model.serviceManager.getGuid() />
					<cfset application.model.serviceManager.addLabel(variables.labels[l].Guid, variables.groups[i].Guid, variables.labels[l].Label, variables.labels[l].ServiceGUID, l) />
				</cfif>
			</cfloop>

			<cfset message = 'Property groups and labels saved.' />
		</cfloop>
	<cfelseif form.action is 'cancelUpdateGroups'>
		<cfset errorMessage = 'Action canceled.' />
	</cfif>
</cfif>

<form class="select-product-form" name="loadCarrier" method="post">
	<label>
		<select name="carrierId">
			<option value="" selected="selected">select..</option>
			<option value="83D7A62E-E62F-4E37-A421-3D5711182FB0" <cfif structKeyExists(form, 'carrierId') and form.carrierId is '83D7A62E-E62F-4E37-A421-3D5711182FB0'> selected="selected"</cfif>>AT&T</option>
			<option value="84C15B47-C976-4403-A7C4-80ABA6EEC189" <cfif structKeyExists(form, 'carrierId') and form.carrierId is '84C15B47-C976-4403-A7C4-80ABA6EEC189'> selected="selected"</cfif>>TMobile</option>
			<option value="263A472D-74B1-494D-BE1E-AD135DFEFC43" <cfif structKeyExists(form, 'carrierId') and form.carrierId is '263A472D-74B1-494D-BE1E-AD135DFEFC43'> selected="selected"</cfif>>Verizon</option>
			<option value="C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D" <cfif structKeyExists(form, 'carrierId') and form.carrierId is 'C9791E1E-ABDA-4088-AEB5-FC5B943BBF5D'> selected="selected"</cfif>>Sprint</option>
		</select>
	</label>
	<a href="javascript:void(0)" onclick="postForm(this)" class="button"><span>Load</span></a>
	<span class="clearFix">&nbsp;</span>
</form>

<cfif structKeyExists(form, 'carrierId')>
	<cfset carrierId = form.carrierId />
<cfelse>
	<cfabort />
</cfif>

<form id="frmServiceManager" method="post">
	<input name="carrierId" type="hidden" value="<cfoutput>#variables.carrierId#</cfoutput>" />
</form>

<a href="javascript:insertGroup()" class="button"><span>Add New Service Group</span></a>

<div id="unasignedServices" style="float: right; position: absolute; left: 690px; width: 260px; padding: 5px">
	<p>Drag unassigned services into a service group.</p>
	<p>&nbsp;</p>

	<cfset filter = {} />

	<cfset unasignedServices = application.model.serviceManager.getUnasignedServicesFromCarrier(variables.carrierId) />

	<div class="propertylist-holder" style="overflow: scroll; width: 250px; height: 300px">
		<ul class="connected">
			<cfloop query="unasignedServices">
				<cfoutput>
					<li class="ui-state-default">
						<span class="sort-handle"></span>
						<span class="editable" labelValue="#trim(unasignedServices.title[unasignedServices.currentRow])#" guid="" serviceguid="#unasignedServices.serviceGuid[unasignedServices.currentRow]#">
							<span title="Hint: Included" style="font-size: 8pt">
								<cfif unasignedServices.includedCount[unasignedServices.currentRow] gt 0>
									<strong>#trim(unasignedServices.title[unasignedServices.currentRow])#</strong>
								<cfelse>
									#trim(unasignedServices.title[unasignedServices.currentRow])#
								</cfif>
							</span>
						</span>
						<span style="font-size: 8pt">
							- #trim(unasignedServices.carrierBillCode[unasignedServices.currentRow])#

							<cfif unasignedServices.deviceRelatedServices[unasignedServices.currentRow] gt 0>
								<img src="/images/ui/phone_icon.gif" title="This service has #unasignedServices.deviceRelatedServices[unasignedServices.currentRow]# device relationships." />
							</cfif>

							<cfif unasignedServices.ratePlanRelatedServices[unasignedServices.currentRow] gt 0>
								<img src="/images/ui/icon-plan.gif" title="This service has #unasignedServices.ratePlanRelatedServices[unasignedServices.currentRow]# rate plan relationships." />
							</cfif>
						</span>
						<span class="trash-icon"></span>
					</li>
				</cfoutput>
			</cfloop>
		</ul>
	</div>
</div>

<div style="width: 425px; font-size: 11px" id="serviceManager">
	<div id="tabs">
		<ul>
			<li style="font-size: 8pt"><a href="#tabs-1">Optional Services</a></li>
			<li style="font-size: 8pt"><a href="#tabs-2">Included Services</a></li>
			<li style="font-size: 8pt"><a href="#tabs-3">Required Services</a></li>
		</ul>
		<div id="tabs-1">

			<cfset args = {
				carrierId = variables.carrierId,
				type = 'O',
				filterOutCartTypeGroups = false
			} />

			<cfset groupLabels = application.model.serviceManager.getServiceMasterGroups(argumentCollection = variables.args) />

			<div id="groups">
				<cfloop query="groupLabels">
					<cfset serviceLabels = application.model.serviceManager.getServiceMasterLabelsByGroup(groupGUID = groupLabels.serviceMasterGroupGuid[groupLabels.currentRow], returnAllCartTypes = true)>

					<cfoutput>
						<ul id="group" class="group connectedSortableGroup">
							<li class="groupItem">
								<div class="property-group ui-state-default">
									<span class="trash-icon"></span>
									<span class="sort-handle-group"></span>
									<span class="group-label editable" type="#trim(groupLabels.type[groupLabels.currentRow])#" min="#groupLabels.minSelected[groupLabels.currentRow]#" max="#groupLabels.maxSelected[groupLabels.currentRow]#" guid="#groupLabels.serviceMasterGroupGuid[groupLabels.currentRow]#" labelValue="#trim(groupLabels.Label[groupLabels.currentRow])#" style="font-size: 8pt; white-space: nowrap; font-weight: bold">#trim(groupLabels.Label[groupLabels.currentRow])#</span>

									<div class="propertylist-holder">
										<ul class="connectedSortable">
											<cfloop query="serviceLabels">
												<li class="ui-state-default">
													<span class="sort-handle"></span>
													<span class="trash-icon"></span>
													<span style="white-space: nowrap">
														<cfif serviceLabels.deviceRelatedServices[serviceLabels.currentRow] gt 0>
															<img src="/images/ui/phone_icon.gif" title="This service has #serviceLabels.deviceRelatedServices[serviceLabels.currentRow]# device relationships." />
														</cfif>
	
														<cfif serviceLabels.ratePlanRelatedServices gt 0>
															<img src="/images/ui/icon-plan.gif" title="This service has #serviceLabels.ratePlanRelatedServices[serviceLabels.currentRow]# rate plan relationships." />
														</cfif>
													</span>
													<span style="font-size: 8pt; margin-left: 15px; font-weight: bold">#trim(serviceLabels.carrierBillCode[serviceLabels.currentRow])#</span>
													<br />
													<span class="editable" labelValue="#trim(serviceLabels.label[serviceLabels.currentRow])#" guid="#serviceLabels.serviceMasterGuid[serviceLabels.currentRow]#" serviceguid="#serviceLabels.serviceGUID[serviceLabels.currentRow]#" style="font-size: 8pt">#trim(serviceLabels.label[serviceLabels.currentRow])#</span>
												</li>
											</cfloop>
										</ul>
									</div>
								</div>
							</li>
						</ul>
					</cfoutput>
				</cfloop>
			</div>
		</div>
		<div id="tabs-2">
			<cfset groupLabels = application.model.serviceManager.getServiceMasterGroups(variables.carrierId, 'I') />

			<div id="groups">
				<cfloop query="groupLabels">
					<cfset serviceLabels = application.model.serviceManager.getServiceMasterLabelsByGroup(groupLabels.serviceMasterGroupGuid[groupLabels.currentRow]) />

					<cfset hasDeviceRelationship = false />
					<cfset hasRatePlanRelationship = false />

					<cfif serviceLabels.deviceRelatedServices[serviceLabels.currentRow] gt 0>
						<cfset hasDeviceRelationship = true />
					</cfif>

					<cfif serviceLabels.ratePlanRelatedServices[serviceLabels.currentRow] gt 0>
						<cfset hasRatePlanRelationship = true />
					</cfif>

					<cfoutput>
						<ul id="group" class="group connectedSortableGroup">
							<li class="groupItem">
								<div class="property-group ui-state-default">
									<span class="trash-icon"></span>
									<span class="sort-handle-group"></span>
									<span class="group-label editable" type="#groupLabels.Type[groupLabels.currentRow]#" min="#groupLabels.MinSelected[groupLabels.currentRow]#" max="#groupLabels.MaxSelected[groupLabels.currentRow]#" guid="#groupLabels.ServiceMasterGroupGuid[groupLabels.currentRow]#" labelValue="#trim(groupLabels.Label[groupLabels.currentRow])#" style="font-size: 8pt; font-weight: bold">#groupLabels.Label[groupLabels.currentRow]#</span>

									<div class="propertylist-holder">
										<ul class="connectedSortable">
											<cfloop query="serviceLabels">
												<li class="ui-state-default">
													<span class="sort-handle"></span>
													<span class="editable" labelValue="#trim(serviceLabels.label[serviceLabels.currentRow])#" guid="#serviceLabels.ServiceMasterGuid[serviceLabels.currentRow]#" serviceguid="#serviceLabels.ServiceGUID[serviceLabels.currentRow]#" style="font-size: 8pt">#serviceLabels.label[serviceLabels.currentRow]#</span>
													<span style="font-size: 8pt">
														- #serviceLabels.CarrierBillCode[serviceLabels.currentRow]#

														<cfif serviceLabels.DeviceRelatedServices[serviceLabels.currentRow] gt 0>
															<img src="/images/ui/phone_icon.gif" title="This service has #serviceLabels.DeviceRelatedServices[serviceLabels.currentRow]# device relationships." />
														</cfif>

														<cfif serviceLabels.RatePlanRelatedServices[serviceLabels.currentRow] gt 0>
															<img src="/images/ui/icon-plan.gif" title="This service has #serviceLabels.RatePlanRelatedServices[serviceLabels.currentRow]# rate plan relationships." />
														</cfif>
													</span>
													<span class="trash-icon"></span>
												</li>
											</cfloop>
										</ul>
									</div>
								</div>
							</li>
						</ul>
					</cfoutput>
				</cfloop>
			</div>
		</div>
		<div id="tabs-3">

			<cfset args = {
				carrierId = variables.carrierId,
				type = 'R',
				filterOutCartTypeGroups = false
			} />

			<cfset groupLabels = application.model.serviceManager.getServiceMasterGroups(argumentCollection = variables.args) />

			<div id="groups">
				<cfloop query="groupLabels">
					<cfset serviceLabels = application.model.serviceManager.getServiceMasterLabelsByGroup(groupGUID = groupLabels.serviceMasterGroupGuid[groupLabels.currentRow], returnAllCartTypes = true)>

					<cfoutput>
						<ul id="group" class="group connectedSortableGroup">
							<li class="groupItem">
								<div class="property-group ui-state-default">
									<span class="trash-icon"></span>
									<span class="sort-handle-group"></span>
									<span class="group-label editable" type="#trim(groupLabels.type[groupLabels.currentRow])#" min="#groupLabels.minSelected[groupLabels.currentRow]#" max="#groupLabels.maxSelected[groupLabels.currentRow]#" guid="#groupLabels.serviceMasterGroupGuid[groupLabels.currentRow]#" labelValue="#trim(groupLabels.Label[groupLabels.currentRow])#" style="font-size: 8pt; white-space: nowrap; font-weight: bold">#trim(groupLabels.Label[groupLabels.currentRow])#</span>

									<div class="propertylist-holder">
										<ul class="connectedSortable">
											<cfloop query="serviceLabels">
												<li class="ui-state-default">
													<span class="sort-handle"></span>
													<span class="trash-icon"></span>
													<span style="white-space: nowrap">
														<cfif serviceLabels.deviceRelatedServices[serviceLabels.currentRow] gt 0>
															<img src="/images/ui/phone_icon.gif" title="This service has #serviceLabels.deviceRelatedServices[serviceLabels.currentRow]# device relationships." />
														</cfif>
	
														<cfif serviceLabels.ratePlanRelatedServices gt 0>
															<img src="/images/ui/icon-plan.gif" title="This service has #serviceLabels.ratePlanRelatedServices[serviceLabels.currentRow]# rate plan relationships." />
														</cfif>
													</span>
													<span style="font-size: 8pt; margin-left: 15px; font-weight: bold">#trim(serviceLabels.carrierBillCode[serviceLabels.currentRow])#</span>
													<br />
													<span class="editable" labelValue="#trim(serviceLabels.label[serviceLabels.currentRow])#" guid="#serviceLabels.serviceMasterGuid[serviceLabels.currentRow]#" serviceguid="#serviceLabels.serviceGUID[serviceLabels.currentRow]#" style="font-size: 8pt">#trim(serviceLabels.label[serviceLabels.currentRow])#</span>
												</li>
											</cfloop>
										</ul>
									</div>
								</div>
							</li>
						</ul>
					</cfoutput>
				</cfloop>
			</div>
		</div>
		
	</div>
</div>

<p>&nbsp;</p>

<div class="clearFix"></div>

<cfif len(variables.message) gt 0>
	<div class="message">
		<span class="form-confirm-inline" style="font-size: 8pt"><cfoutput>#trim(variables.message)#</cfoutput></span>
	</div>
</cfif>

<cfif len(variables.errorMessage) gt 0>
	<div class="errormessage">
		<span class="form-error-inline" style="font-size: 8pt"><cfoutput>#trim(variables.errorMessage)#</cfoutput></span>
	</div>
</cfif>

<a href="javascript:saveChanges();" class="button"><span>Save Changes</span></a>
<a href="javascript:show('action=cancelUpdateGroups');" class="button"><span>Cancel</span></a>

<div id="groupTemplate">
	<ul id="group" class="group connectedSortableGroup">
		<li class="groupItem">
			<div class="property-group ui-state-default">
				<span class="trash-icon"></span>
				<span class="sort-handle-group"></span>
				<span class="group-label editable" guid="" type="O" min="0" max="0" labelValue="">Click to edit group</span>
				<div class="propertylist-holder">
					<ul class="connectedSortable">

					</ul>
				</div>
			</div>
		</li>
	</ul>
</div>