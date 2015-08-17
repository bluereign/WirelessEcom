

<script type="text/javascript">
	$(document).ready(function(){
		
		setEvents();

	});

	function setEvents()
	{
		
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
		
		$(".group").sortable({
			connectWith: '.connectedSortableGroup',
			handle: '.sort-handle-group',
			cursor: 'crosshair'
		});
		
		
		$('.editable').editable('', { 
			 type     : 'text',
			 submit   : 'OK',
			 cssclass : 'text-editinplace',
			 width    : 'none',
			 cancel   : 'CANCEL',
			 placeholder : '<i>Click to edit</i>',
			 callback : function(value, settings) {
				 
				 if(value.length == 0)
				 {
					 $(this).html(settings.placeholder);
				 }
				 $(this).attr("labelValue",value);

			 }
		 });
		
		
		//set trash event
		$(".groupItem").find(".trash-icon:first").bind("click",
				function()
				{
					var el = $(this).parents("li:first");
					
					var guid = $(this).parent().find(".editable").attr("guid");
					
					
					//check for any child elements.
					var labels = $(this).parent().find(".propertylist-holder").find("li");
					if(labels.length > 0)
					{
						alert("Groups can not be deleted until all property labels are removed.");
						return;
					}
					
					var ok = confirm("Are you sure you want to delete this Group?");
					if(ok)
					{
						//get the parent element
						$(el).effect("explode",null,550);
						$(el).remove();
						
						//if there is a guid, add it to the label delete list.
						if(guid.length > 0)
						{
							var form = document.getElementById("frmPropertyManager");
							var hiddenId = document.createElement("input");
							$(hiddenId).attr("type","hidden");
							$(hiddenId).attr("name","deleteGroupList");
							$(hiddenId).attr("value",guid);
							$(form).append(hiddenId);
						}
					}
					
				}
			);
		
		$(".propertylist-holder").children().children().find(".trash-icon:first").bind("click",
				function()
				{
					var el = $(this).parents("li:first");
					
					//check for guid. no guid is a delete
					var guid = $(el).children(".editable").attr("guid");

					var ok = true;
					if(guid.length > 0)
					{
						ok = confirm("Are you sure you want to delete this Property? There may be one or more product properties attached.");	
					}
					
					
					//remove the element
					if(ok)
					{
						//get the parent element
						$(el).effect("explode",null,550);
						$(el).remove();
						
						//if there is a guid, add it to the label delete list.
						if(guid.length > 0)
						{
							var form = document.getElementById("frmPropertyManager");
							var hiddenId = document.createElement("input");
							$(hiddenId).attr("type","hidden");
							$(hiddenId).attr("name","deleteLabelList");
							$(hiddenId).attr("value",guid);
							$(form).append(hiddenId);
						}
					}
				}
			);
	}

	function insertGroup()
	{
		var groupClone = $("#groupTemplate").contents().clone();
		$("#groups").prepend(groupClone);
	
		$(groupClone).find(".property-group").effect("pulsate", { times:1 }, 400);
		
		setEvents();
	}
	
	function insertProperty()
	{
		//clone the template
		var labelClone = $("#labelTemplate").children().find("li").clone();
		
		$("#groups .connectedSortable:first").prepend(labelClone);
		$(labelClone).effect("pulsate", { times:1 }, 400);
		
		setEvents();

	}
	
	function saveChanges()
	{
		var form = document.getElementById("frmPropertyManager");
		
		
		//loop groups.
		var groups = $("#groups ul.group li.groupItem");
		for(var i = 0; i < groups.length; i++)
		{
			//create group
			var groupGuid = $(groups[i]).find(".group-label").attr("guid");
			var label = $(groups[i]).find(".group-label").attr("labelValue");
			
	
			
			//loop labels in this group
			var labels = $(groups[i]).children().find(".connectedSortable").children();
			for(var p = 0; p < labels.length; p++)
			{
				//create label
				var labelGuid = $(labels[p]).children(".editable").attr("guid");
				var labelLabel = $(labels[p]).children(".editable").attr("labelValue");

				

				var labelFieldName = "groupLabel_" + i + "_" + p;
				var labelFieldValue = "";
				var labelFieldValue = "groupGuid=" + groupGuid + "|labelGuid=" + labelGuid + "|label=" + labelLabel;
				
				var hiddenId = document.createElement("input");
				$(hiddenId).attr("type","hidden");
				$(hiddenId).attr("name",labelFieldName);
				$(hiddenId).attr("value",labelFieldValue);
				$(form).append(hiddenId);
			}
			
			//build the group input
			var fieldName = "group_" + i;
			var fieldValue = "groupGuid=" + groupGuid + "|label=" + label + "|labelCount=" + labels.length;
			
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
		$(hiddenAction).attr("value","savePropertyGroupChanges");
		$(form).append(hiddenAction);
		
		form.submit()();
		
	}
	
</script>


<!--- display logic --->
<cfset productType = "">
<cfset propertyType = "">

<cfset message = "">
<cfset errormessage = "">

<!--- set the current product / property type --->
<cfset currentPropertyType = application.model.AdminUser.getInterface().propertyGroupPropertyType>
<cfif len(currentPropertyType) gt 0>
	<cfset currentPropertyTypeArray = ListToArray(currentPropertyType,"|")>
    <cfset productType = currentPropertyTypeArray[1]>
    <cfset propertyType = currentPropertyTypeArray[2]>
</cfif>



<cfif IsDefined("form.action")>
	<cfif form.action eq "savePropertyGroupChanges">
   		<!--- create a structure of the groups passed --->
        <cfset groupCount = form.GroupCount>
		<cfset groups = arrayNew(1)>
        
        <!--- loop groups --->
        <cfloop index="i" from="1" to="#groupCount#">
        	
            <cfset groups[i] = structNew()>
            <cfset groupValueString = Evaluate("form.GROUP_#i-1#")>
            
            <!--- get the values that are needed from the groupValueString--->
            <cfset groupGuid = "">
            <cfset groupLabel = "">
            <cfset groupLabelCount = 0>
            <cfset attributeList = ListToArray(groupValueString,"|",true)>
            <cfset groupGuidA = ListToArray(attributeList[1],"=",true)>
            <cfset groupLabelA = ListToArray(attributeList[2],"=",true)>
            <cfset groupLabelCountA = ListToArray(attributeList[3],"=",true)>
            <cfset groupGuid = groupGuidA[2]>            
            <cfset groupLabel = groupLabelA[2]>
            <cfset groupLabelCount = groupLabelCountA[2]>
            
            <!--- set the values for the group --->
            <cfset groups[i].Guid = groupGuid>
            <cfset groups[i].Label = groupLabel>
            
            <!--- loop labels --->
            <cfset groups[i].labels = arrayNew(1)>
            <cfloop index="k" from="1" to="#groupLabelCount#">
            	<cfset labelValueString = Evaluate("form.GROUPLABEL_#i-1#_#k-1#")>
                <cfset labelGroupGuid = "">
				<cfset labelGuid = "">
                <cfset labelLabel = "">
                <cfset attributeList = ListToArray(labelValueString,"|",true)>
            	<cfset labelGroupGuidA = ListToArray(attributeList[1],"=",true)>
                <cfset labelGuidA = ListToArray(attributeList[2],"=",true)>
            	<cfset labelLabelA = ListToArray(attributeList[3],"=",true)>
                
                <cfset labelGroupGuid = groupGuid>
				<cfset labelGuid = labelGuidA[2]>
                <cfset labelLabel = labelLabelA[2]>
                
                <cfset groups[i].labels[k] = structNew()>
                <cfset groups[i].labels[k].GroupGuid = labelGroupGuid>
                <cfset groups[i].labels[k].Guid = labelGuid>
                <cfset groups[i].labels[k].Label = labelLabel>
            </cfloop>
            
        </cfloop>
        
      
        
        <!--- loop groups and update database --->
        <cfloop index="i" from="1" to="#ArrayLen(groups)#">
        	<cfif len(groups[i].Guid) gt 0>
            	<!--- update the group --->
            	<cfset application.model.PropertyManager.updateGroup(groups[i].Guid, groups[i].Label, i)>
            <cfelse>
            	<!--- add the group --->
                <cfset groups[i].Guid = application.model.PropertyManager.getGuid() >
				<cfset application.model.PropertyManager.addGroup(productType, propertyType, groups[i].Guid, groups[i].Label, i)>
            </cfif>
			
            <!--- loop the labels for this group --->
            <cfset labels = groups[i].labels>
            <cfloop index="l" from="1" to="#arrayLen(labels)#">
            	<cfif len(labels[l].Guid) gt 0>
                	<!--- update the label --->
                    <cfset application.model.PropertyManager.updateLabel(labels[l].Guid, groups[i].Guid, labels[l].Label, l)>
                <cfelse>
                	<!--- add the label --->
                    <cfset labels[l].Guid = application.model.PropertyManager.getGuid() >
                    <cfset application.model.PropertyManager.addLabel(labels[l].Guid, groups[i].Guid, labels[l].Label, l)>
                </cfif>
                
            </cfloop>
            
            <cfset message = "Property groups and labels saved.">
            
        </cfloop>
        
        
        <!--- delete from the delete lists --->
        <cfif IsDefined("form.deleteLabelList")>
        	<cfloop list="#form.deleteLabelList#" delimiters="," index="i">
            	<!--- delete the label property item --->
                <cfset application.model.PropertyManager.deleteLabel(i)>
            </cfloop>
        </cfif>
        <cfif IsDefined("form.deleteGroupList")>
        	<cfloop list="#form.deleteGroupList#" delimiters="," index="i">
            	<!--- delete the group item --->                
                <cfset application.model.PropertyManager.deleteGroup(i)>
            </cfloop>
        </cfif>
        
        
    <cfelseif form.action eq "loadPropertyGroup">
    	<cfset application.model.AdminUser.setInterfaceKey("propertyGroupPropertyType", form.productProperty)>
		<cfset currentPropertyType = application.model.AdminUser.getInterface().propertyGroupPropertyType>
		<cfif len(currentPropertyType) gt 0>
            <cfset currentPropertyTypeArray = ListToArray(currentPropertyType,"|")>
            <cfset productType = currentPropertyTypeArray[1]>
            <cfset propertyType = currentPropertyTypeArray[2]>
        </cfif>
        
    <cfelseif form.action eq "cancelUpdateGroups">
        <cfset errormessage = "Action canceled.">
  	</cfif>
</cfif>


<!--- end display logic --->



<form class="select-product-form" name="loadProperty" method="POST">
    <cfset propertyTypes = application.model.PropertyManager.getProductTypes()>
    <cfset currentPropertyType = application.model.AdminUser.getInterface().propertyGroupPropertyType>
    
    <label class="field-title"> </label> 
    <label> 
        <select name="productProperty">
        	<option value="" selected="selected">select..</option>	
        	<cfloop from="1" to="#ArrayLen(propertyTypes)#" index="i">
                <cfoutput>
                	<cfset selected = "">
                    <cfif currentPropertyType eq propertyTypes[i]>
                    	<cfset selected = "selected">
                    </cfif>
                	<option #selected# value="#propertyTypes[i]#">#Replace(propertyTypes[i],"|"," > ")#</option>	
                		
                </cfoutput>
            </cfloop>	
        </select>
        <input type="hidden" name="action" value="loadPropertyGroup" />
    </label>
     <a href="javascript: void(0);" onclick="postForm(this);" class="button"><span>Load</span></a>
    <span class="clearFix">&nbsp;</span>
</form>	

<cfif len(productType) gt 0>

    <a href="javascript: insertGroup();" class="button"  ><span>Add New Property Group</span></a>
    <a href="javascript: insertProperty();" class="button"  ><span>Add Property</span></a>
    
    <div class="clearFix"></div>
    
    <form id="frmPropertyManager" method="post">
        
    </form>
    
    <cfset groupLabels = application.model.PropertyManager.getPropertyMasterGroups(productType,propertyType)>
    
    <div id="groups">
        
        <cfloop query="groupLabels">  
            <!--- get property labels --->
            <cfset propertyLabels = application.model.PropertyManager.getPropertyMasterLabelsByGroup(groupLabels.PropertyMasterGroupGuid)>
            
            <cfoutput> 
            <ul id="group" class="group connectedSortableGroup">
                <li class="groupItem">
                    <div class="property-group ui-state-default">
                        <span class="trash-icon"></span>
                        <span class="sort-handle-group"></span>
                        <span class="group-label editable"  guid="#groupLabels.PropertyMasterGroupGuid#" labelValue="#groupLabels.GroupLabel#">#groupLabels.GroupLabel#</span>
                        
                        <div class="propertylist-holder">
                            <ul class="connectedSortable">
                                <cfloop query="propertyLabels">
                                    <li class="ui-state-default">
                                        <span class="sort-handle"></span>
                                        <span class="editable"  labelValue="#propertyLabels.label#" guid="#propertyLabels.PropertyMasterGuid#">#propertyLabels.label#</span>
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
    </div><!-- End groups -->
    
    
    <div class="clearFix"></div>
    
    <cfif len(message) gt 0>
        <div class="message">
            <span class="form-confirm-inline"><cfoutput>#message#</cfoutput></span>
        </div>
    </cfif>
    
    <cfif len(errormessage) gt 0>
        <div class="errormessage">
            <span class="form-error-inline"><cfoutput>#errormessage#</cfoutput></span>
        </div>
    </cfif>
    
    
    <a href="javascript: saveChanges();" class="button" ><span>Save Changes</span></a> 
    <a href="javascript: show('action=cancelUpdateGroups');" class="button" ><span>Cancel</span></a> 
     <p>
        Hints: Click a label to edit and use the <span class="sort-handle"></span> to Drag a label or group to re-order.
    </p>
   
    
    
   
</cfif>

<!--- helpers --->
<div id="groupTemplate">
	<ul id="group" class="group connectedSortableGroup">
        <li class="groupItem">
            <div class="property-group ui-state-default">
            	<span class="trash-icon"></span>
                <span class="sort-handle-group"></span>
                <span class="group-label editable" guid="" labelValue=""></span>                
                <div class="propertylist-holder">
                    <ul class="connectedSortable">
                        <li class="ui-state-default">
                        	<span class="sort-handle"></span>
                            <span class="editable"  labelValue="" guid=""></span>
                            <span class="trash-icon"></span>
                        </li>
                    </ul> 
                </div>
            </div>
        </li>
    </ul>
</div>

<div id="labelTemplate">
	<ul>
		<li class="ui-state-default">
        	<span class="sort-handle"></span>
            <span class="editable" labelValue="" guid=""></span>
            <span class="trash-icon"></span>
        </li>
    </ul>
</div>
