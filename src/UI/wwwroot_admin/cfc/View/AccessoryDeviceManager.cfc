<cfcomponent output="false" displayname="AccessoryDeviceManager">
	<cffunction name="init" returntype="AccessoryDeviceManager">
    	<cfreturn this>
    </cffunction>


	<cffunction name="getEditAccessoryDeviceForm" returntype="string" access="public">
    	<cfargument name="accessoryId" type="string" required="true" />

		<cfset var local = {
        		accessoryId = arguments.accessoryId,
				filter = {},
				devicesQry = application.model.AccessoryDeviceManager.getPhonesList(local.filter)
			} />

		<!--- TODO: implement getAccessoriesNotForDevice to display all accessories except for the ones already chosen for the product. --->
		<cfsavecontent variable="local.html">
			<form class="middle-forms" method="POST">
                <h3>Add Phones to Accessory</h3>
		    	<fieldset>
		        	<legend>Add New Phone</legend>
		        	<div>
			        	<ol>
			            	<li>
			                    <label class="field-title">Phone:</label>
			                    <label>
				                    <select name="deviceId">
					                    <option value="">Select an Phone</option>
										<cfloop query="local.devicesQry">
											<cfoutput><option value="#local.devicesQry.deviceGuid#">#local.devicesQry.name#</option></cfoutput>
										</cfloop>
									</select>
								</label>
			                    <span class="clearFix">&nbsp;</span>
			            	</li>
			            </ol>
					</div>
		    	</fieldset>

                <input type="hidden" value="<cfoutput>#local.accessoryId#</cfoutput>" name="productId" />
				<!--- TODO: implement user integration to get the creator --->
				<input type="hidden" value="addAccessoryDevice" name="action">

				<a href="javascript: void();" onclick="postForm(this);" class="button"><span>Add Phone to Accessory</span></a>  <a href="javascript: show('action=cancelDeviceForAccessoryEdit');" class="button"><span>Cancel</span></a>
			</form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getAccessoryDeviceDisplayList" access="public" returntype="string">
		<cfargument name="accessoryId" type="string" required="true" />

		<cfset var local = {
			accessoryId = arguments.accessoryId
		} />

		<cfset local.accessoryDeviceList = application.model.AccessoryDeviceManager.getDevicesForAccessory(local.accessoryId) />

		<cfsavecontent variable="local.html">
			<script type="text/javascript">
				$(function() {
					$("#sortableAccessoryDevices").sortable({
						cursor: 'crosshair',
						placeholder: 'ui-state-highlight',
						handle: '.accessoryDeviceListSortHandle'
						}).disableSelection();
				});
			</script>

			<a href="javascript: show('action=showEditAccessoryDeviceForm');" href="#" class="button"><span>Add New Phone</span></a>
			<cfif local.accessoryDeviceList.RecordCount gt 0>
         	<form method="post" name="bulkAccessoryDeviceUpdate" class="middle-forms">
				<div id="accessoryDeviceListHeader">
	                <span id="accessoryDeviceName">Phone Name</span>
	                <div style="clear:both;"></div>
				</div>
			   	<div id="accessoryDeviceList">
					<ul id="sortableAccessoryDevices">
						<cfset local.accessoryDeviceListCounter = 1 />
						<cfloop query="local.accessoryDeviceList">
					        <li class="ui-state-default">
					        	<span class="accessoryDeviceListSortHandle"></span>
<!---
								<span class="accessoryListPreview">
						        	<cfoutput>
							        	<!--- display thumbnail of image --->
										<cfset local.displayHeight = 120 />
										<cfset local.displayWidth = 0 />
				                        <img src="image_proxy.cfm?img=#local.imageList.ImageGuid#&height=#local.displayHeight#" height="#local.displayHeight#" alt="#local.imageList.Alt#" />
									</cfoutput>
								</span>
--->
					            <span class="accessoryDeviceListTitle"><cfoutput>#local.accessoryDeviceList.name#</cfoutput></span>
					            <span class="accessoryDeviceListEdit"><a href="javascript: if(confirm('Are you sure you want to permanently delete this phone from this accessory? This can not be undone.')) { show('action=deleteAccessoryDevice|deviceId=<cfoutput>#local.accessoryDeviceList.DeviceGuid#</cfoutput>'); }" class="table-delete-link">Delete</a></span>
					        	<div style="clear:both;"></div>
					        	<input type="hidden" name="order" value="<cfoutput>#local.accessoryDeviceList.DeviceGuid#</cfoutput>" />
							</li>
							<cfset local.accessoryDeviceListCounter += 1  />
				    	</cfloop>
					</ul>
				</div>
			    <input type="hidden" value="<cfoutput>#local.accessoryId#</cfoutput>" name="accessoryId" />
			    <input type="hidden" value="bulkAccessoryDeviceUpdate" name="action">
			    <a href="javascript: void();" onclick="postForm(this);" class="button"><span>Save</span></a> <a href="javascript: show('action=cancelDeviceAccessoryEdit');" class="button"><span>Cancel</span></a>
			</form>
				<p>
            		<i>Hint: To reorder the phones drag the grey box by the up and down arrows.</i>
                </p>
            <cfelse>
            	<p>
            		<i>No phones for this accessory.</i>
                </p>
           	</cfif>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>

</cfcomponent>