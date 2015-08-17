<cfcomponent output="false" displayname="FreeDeviceAccessoryManager">
	<cffunction name="init" returntype="FreeDeviceAccessoryManager">
    	<cfreturn this>
    </cffunction>


	<cffunction name="getEditAccessoryForDeviceForm" returntype="string" access="public">
    	<cfargument name="deviceId" type="string" required="true" />

		<cfset var local = {
        		productId = arguments.deviceId,
				filter = {},
				accessoriesQry = application.model.AdminAccessory.getFreeAccessories(local.filter)
			} />

		<!--- TODO: implement getAccessoriesNotForDevice to display all accessories except for the ones already chosen for the product. --->
		<cfsavecontent variable="local.html">
			<form class="middle-forms" method="POST">
                <h3>Add Accessory to Product</h3>
		    	<fieldset>
		        	<legend>Add New Accessory</legend>
		        	<div>
			        	<ol>
			            	<li>
			                    <label class="field-title">Accessory:</label>
			                    <label>
				                    <select name="accessories">
					                    <option value="">Select an Accessory</option>
										<cfloop query="local.accessoriesQry">
											<cfoutput><option value="#local.accessoriesQry.accessoryGuid#">#local.accessoriesQry.name#</option></cfoutput>
										</cfloop>
									</select>
								</label>
			                    <span class="clearFix">&nbsp;</span>
			            	</li>
			            </ol>
					</div>
		    	</fieldset>

                <input type="hidden" value="<cfoutput>#local.productId#</cfoutput>" name="productId" />
				<!--- TODO: implement user integration to get the creator --->
				<input type="hidden" value="addAccessoryForDevice" name="action">

				<a href="javascript: void();" onclick="postForm(this);" class="button"><span>Add Accessory to Product</span></a>  <a href="javascript: show('action=cancelAccessoryForDeviceEdit');" class="button"><span>Cancel</span></a>
			</form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getAccessoryForDeviceDisplayList" access="public" returntype="string">
		<cfargument name="productId" type="string" required="true" />

		<cfset var local = {
			productId = arguments.productId
		} />

		<cfset local.accessoryList = application.model.Catalog.getFreeDeviceAccessories(local.productId) />

		<cfsavecontent variable="local.html">
			<script type="text/javascript">
				$(function() {
					$("#sortableFreeAccessories").sortable({
						cursor: 'crosshair',
						placeholder: 'ui-state-highlight',
						handle: '.accessoryListSortHandle'
						}).disableSelection();
				});
			</script>

			<a href="javascript: show('action=showEditFreeAccessoryForm');" href="#" class="button"><span>Add New Accessory</span></a>
			<cfif local.accessoryList.RecordCount gt 0>
         	<form method="post" name="bulkFreeAccessoryUpdate" class="middle-forms">
				<div id="accessoryListHeader">
	                <span id="accessoryName">Accessory Name</span>
	                <div style="clear:both;"></div>
				</div>
			   	<div id="accessoryList">
					<ul id="sortableFreeAccessories">
						<cfset local.accessoryListCounter = 1 />
						<cfloop query="local.accessoryList">
					        <li class="ui-state-default">
					        	<span class="accessoryListSortHandle"></span>
					            <span class="accessoryListTitle">
					            	<cfoutput>
										<strong>#local.accessoryList.Name#</strong> <br />
										UPC: #local.accessoryList.UPC# <br />
										GERS SKU: #local.accessoryList.GersSku#
									</cfoutput>
								</span>
					            <span class="accessoryListEdit"><a href="javascript: if(confirm('Are you sure you want to permanently delete this accessory from this product? This can not be undone.')) { show('action=deleteAccessory|accessoryId=<cfoutput>#local.accessoryList.AccessoryGuid#</cfoutput>'); }" class="table-delete-link">Delete</a></span>
					        	<div style="clear:both;"></div>
					        	<input type="hidden" name="order" value="<cfoutput>#local.accessoryList.AccessoryGuid#</cfoutput>" />
							</li>
							<cfset local.accessoryListCounter += 1  />
				    	</cfloop>
					</ul>
				</div>
			    <input type="hidden" value="<cfoutput>#local.productId#</cfoutput>" name="productId" />
			    <input type="hidden" value="bulkFreeAccessoryUpdate" name="action">
			    <a href="javascript: void();" onclick="postForm(this);" class="button"><span>Save</span></a> <a href="javascript: show('action=cancelFreeAccessoryForDeviceEdit');" class="button"><span>Cancel</span></a>
			</form>
				<p>
            	<i>Hint: To reorder the accessories drag the grey box by the up and down arrows.</i>
                </p>
            <cfelse>
            	<p>
            	<i>No accessories for this product.</i>
                </p>
           	</cfif>
		</cfsavecontent>

		<cfreturn local.html>
	</cffunction>

</cfcomponent>