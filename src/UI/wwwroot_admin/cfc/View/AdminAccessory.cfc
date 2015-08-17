<cfcomponent output="false" displayname="AdminAccessory">

	<cffunction name="init" returntype="AdminAccessory">
		<cfreturn this />
	</cffunction>

	<cffunction name="getAccessoryList" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />

		<cfset var local = structNew() />
		<cfset local.filter = arguments.filter />
		<cfset local.dislayTitle = '' />

		<!---<cfset local.carriers = application.model.Company.getAllCarriers() />--->
		<cfset local.accessories = application.model.AdminAccessory.getAccessories(local.filter) />

		
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
<!---						<label for="carrierIdFilter">Carrier:</label>
						<select id="carrierIdFilter" name="carrierId">
							<option value="">All</option>
							<cfloop query="local.carriers">
								<option value="#CarrierId#" <cfif structKeyExists(local.filter, 'carrierId') && local.filter.carrierId eq carrierId>selected="selected"</cfif>>#CompanyName#</option>
							</cfloop>
						</select>
--->						
						<label for="isActiveFilter" style="margin-left:15px;">Is Active:</label>
						<select id="isActiveFilter" name="isActive">
							<option value="">All</option>
							<option value="1" <cfif structKeyExists(local.filter, 'isActive') && local.filter.isActive eq 1>selected="selected"</cfif>>Yes</option>
							<option value="0" <cfif structKeyExists(local.filter, 'isActive') && local.filter.isActive eq 0>selected="selected"</cfif>>No</option>
						</select>
						
						<label for="isFreeFilter" style="margin-left:15px;">Is Free:</label>
						<select id="isFreeFilter" name="isFree">
							<option value="">All</option>
							<option value="1" <cfif structKeyExists(local.filter, 'isFree') && local.filter.isFree eq 1>selected="selected"</cfif>>Yes</option>
							<option value="0" <cfif structKeyExists(local.filter, 'isFree') && local.filter.isFree eq 0>selected="selected"</cfif>>No</option>
						</select>
						
						<label for="createDateFilter_start" style="margin-left:15px;">Created:</label>
						<input type="text" id="createDateFilter_start" name="createDate_start" size="10" value=""/> - 
						<input type="text" id="createDateFilter_end" name="createDate_end" size="10" value=""/>

						<input name="filterSubmit" type="submit" value="Filter" style="margin-left:25px;" />
					</form>
				</div>
				<table id="listAccessoryAll" class="table-long gridview-momt-accessories">
					<thead>
						<tr>
							<th class="hidden-col">MG</th>	<!--- hide column - we want it there for sorting but not displayed --->						
							<th>Channel</th>
							<th>Title</th>
							<th>Active</th>
							<!---<th>Carrier</th>--->
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
						<cfloop query="local.accessories">
							<cfif guidbreak is not trim(local.accessories.matchingGUID)>
								<cfset oddeven = oddeven xor 1 />
								<cfset guidbreak = local.accessories.matchingGUID />
								<cfset guidCount = guidCount+1 />
							</cfif>
							<tr class="<cfif oddeven is 1>momt-odd-group<cfelse>momt-even-group</cfif>">
								<cfif not len(trim(local.accessories.title[local.accessories.currentRow]))>
									<cfif len(trim(local.accessories.name[local.accessories.currentRow]))>
										<cfset local.displayTitle = trim(local.accessories.name[local.accessories.currentRow]) />
									<cfelse>
										<cfset local.displayTitle = 'No Title or Name Set' />
									</cfif>
								<cfelse>
									<cfset local.displayTitle = trim(local.accessories.title[local.accessories.currentRow]) />
								</cfif>
								
								<td class="hidden-col">#guidCount#</td>
								<td>#trim(local.accessories.channel)#</td>
								<td><a href="?c=6360f268-4e75-4cf7-a6a1-140958a61cb2&productguid=#local.accessories.accessoryGuid[local.accessories.currentRow]#">#trim(local.displayTitle)#</a></td>
								<td>#yesNoFormat(trim(local.accessories.active[local.accessories.currentRow]))#</td>
								<!---<td><!---#trim(local.accessories.carrier[local.accessories.currentRow])#--->&nbsp;</td>--->
								<td>#trim(local.accessories.upc[local.accessories.currentRow])#</td>
								<td>#trim(local.accessories.productId[local.accessories.currentRow])#</td>
								<td>#trim(local.accessories.gersSku[local.accessories.currentRow])#</td>
								<td>#dateformat(trim(local.accessories.createDate[local.accessories.currentRow]),"mm/dd/yyyy")#</td>
								<td class="hidden-col">#local.accessories.currentRow#</td>
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

	<cffunction name="getEditAccessoryForm" returntype="string">
		<cfargument name="accessoryId" type="string" default="" />

		<cfset var local = {
				html = '',
				accessoryId = arguments.accessoryId,
				active = false,
				name = '',
				upc = '',
				manufacturer = '',
				manufacturerGuid = '',
				title = '',
				shortDescription = '',
				longDescription = '',
				manufacturersQry = application.model.AdminCompany.getCompanies(),
				gersSku = 'MASTERCAT',
				ProductId = '',
				tags = arraynew(1),
				channelId = "1",
				SafteyStock = "0",
				masterData = {}
			} />

		<cfset var activeChannels = "" />
		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfif local.accessoryId NEQ "">
			<cfset activeChannels = application.model.AdminProduct.getProductChannels(local.accessoryId) />
			<!--- set display --->
			<cfset local.accessoryDetails = application.model.AdminAccessory.getAccessory(local.accessoryId) />
			<cfset local.tags = application.model.AdminProduct.getTags(local.accessoryId) />
			<cfset local.name = local.accessoryDetails.Name />
			<cfset local.upc = local.accessoryDetails.UPC />
			<cfset local.manufacturerGuid = local.accessoryDetails.ManufacturerGuid />
			<cfset local.manufacturer = local.accessoryDetails.Manufacturer />
			<cfset local.title = local.accessoryDetails.Title />
			<cfset local.shortDescription = local.accessoryDetails.ShortDescription />
			<cfset local.longDescription = local.accessoryDetails.LongDescription />
			<cfset local.active = local.accessoryDetails.Active />
			<cfset local.GersSku = local.accessoryDetails.GersSku />
			<cfset local.ProductId = local.accessoryDetails.ProductId />
			<cfset local.channelId = local.accessoryDetails.channelId />
			<cfset local.SafteyStock = local.accessoryDetails.SafteyStock>
			<cfif local.channelId neq 1>
				<cfset local.masterData = application.model.AdminAccessory.getMasterAccessory(local.ProductId) >
			</cfif>
		</cfif>

		<cfsavecontent variable="local.html">
		    <form  method="post" name="updateAccessory" class="middle-forms">
		        <fieldset>
		            <legend>Fieldset Title</legend>
		            <ol>
			            <cfif local.productId NEQ "">
			                <li class="even">
			                    <label class="field-title" title="The productId for this device">Product Id: </label>
								<label><cfoutput>#local.productId#</cfoutput></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
		                </cfif>
		                <li class="odd">
		                    <label class="field-title" title="Check the box to make this accessory viewable online">Availability: </label>
		                    <label>
		                        <input type="checkbox" name="active" <cfif local.active eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
		                        Available Online
		                    </label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Required: The manufacturer of the accessory">Manufacturer: <span class="required">*</span></label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
				                    <select name="manufacturers">
					                    <option value="">Select a Manufacturer</option>
										<cfloop query="local.manufacturersQry">
											<cfoutput><option value="#local.manufacturersQry.companyGuid#" <cfif local.manufacturerGuid EQ local.manufacturersQry.companyGuid> selected="selected"</cfif>>#local.manufacturersQry.companyName#</option></cfoutput>
										</cfloop>
									</select>
								<cfelse>
									<cfoutput>
										#local.manufacturer#
										<input type="hidden" name="manufacturers" value="#local.manufacturerGuid#">
									</cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="The name that identifies the accessory">Name:</label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
									<input name="name" class="txtbox-long" value="<cfoutput>#local.name#</cfoutput>" />
								<cfelse>
									<cfoutput>
										#local.name#
										<input type="hidden" name="name" value="#local.name#">
									</cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="even">
		                    <label class="field-title" title="Required: The title of the accessory">Title: <span class="required">*</span></label>
		                    <label><input name="title" class="txtbox-long" value="<cfoutput>#local.title#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="The UPC of the accessory">UPC:</label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
									<input name="upc" class="txtbox-long" maxlength="30" value="<cfoutput>#local.upc#</cfoutput>"/>
								<cfelse>
									<cfoutput>
										#local.upc#
										<input type="hidden" name="upc" value="#local.upc#"/>
									</cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="even">
							<label class="field-title" title="Required: Select Channel">Channel: <span class="required">*</span></label>
							<label>
								<select name="channelID">
									<cfif !len(trim(local.channelId)) OR find(local.channelId,"0,1")>
											<cfif (isQuery(activeChannels) && activeChannels.recordCount EQ 0) || !len(trim(local.accessoryId))>
												<option value="0">Unassigned</option>
											</cfif>
											<option value="1"<cfif local.channelId eq 1> selected</cfif>>Master</option>
										<cfelse>
											<cfloop query="channels">
												<cfoutput>
													<cfif channelID NEQ "0">
														<option value="#channelID#"<cfif local.channelId eq channels.channelId> selected</cfif>>#channel#</option>
													</cfif>
												</cfoutput>
											</cfloop>
										</cfif>
									</select>
								</select>
							</label>
							<span class="clearFix">&nbsp;</span>
						</li>
						<li class="odd">
							<label class="field-title" title="Active Channel">Active:</label>
							<label><cfif isQuery(activeChannels)><cfoutput query="activeChannels">#channel#, </cfoutput></cfif></label>
							<span class="clearFix">&nbsp;</span>
						</li>
		                <li class="even">
		                    <label class="field-title" title="The GERS SKU of the accessory">GERS SKU:</label>
		                    <label><input name="gersSku" class="txtbox-short" maxlength="9" value="<cfoutput>#local.gersSku#</cfoutput>" /></label>
		                    <label><!---<a rel="gersLookupLink" href="gersLookup.cfm">Look up GERS SKU</a>---></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>

						<li class="odd">
							<label class="field-title" title="Set Safety Stock">Set Safety Stock:</label>
							<label><input type="text" class="txtbox-short" id="SafteyStock" name="SafteyStock" value="<cfoutput>#local.SafteyStock#</cfoutput>"></label>
							<span class="clearFix">&nbsp;</span>
						</li>
						 <li class="even">
			                    <label class="field-title" title="The Master short description of the accessory">Master Short Description: </label>
							<label>
								<cfif structKeyExists(local.masterData,"shortDescription")>
									<span class="rawOutput"><cfoutput>#local.masterData.shortDescription#</cfoutput></span>
								</cfif>
							</label>
							<span class="clearFix">&nbsp;</span>
						</li>
		                <li class="even">
		                    <label class="field-title" title="A short description of the accessory">Short Description: </label>
		                    <label>
		                        <textarea id="shortDescriptionEditor" name="shortDescription" rows="7" cols="40"><cfoutput>#local.shortDescription#</cfoutput></textarea>
		                    </label>
		                 	<script>
			                 	var editor = CKEDITOR.replace( 'shortDescriptionEditor' );
			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );
		                 	</script>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
							<label class="field-title" title="The Master short description of the accessory">Master Long Description: </label>
							<label>
								<cfif structKeyExists(local.masterData,"longDescription")>
									<span class="rawOutput"><cfoutput>#local.masterData.longDescription#</cfoutput></span>
								</cfif>
							</label>
							<span class="clearFix">&nbsp;</span>
						</li>
		                <li class="odd">
		                    <label class="field-title" title="A long description of the accessory">Long Description: </label>
		                    <label>
		                    	<textarea id="longDescriptionEditor" name="longDescription" rows="7" cols="40" ><cfoutput>#local.longDescription#</cfoutput></textarea>
		                    </label>
		                 	<script>
			                 	var editor = CKEDITOR.replace( 'longDescriptionEditor' );
			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );
		                 	</script>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		            </ol><!-- end of form elements -->
		        </fieldset>
		     	<input type="hidden" name="accessoryId" value="<cfoutput>#local.accessoryId#</cfoutput>" />
		     	<input type="hidden" name="action" value="updateAccessoryDetails" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save this accessory to the database"><span>Save</span></a> <a href="javascript: show('action=cancelAccessoryEdit');" class="button" title="Cancel the changes made to this accessory and do not save"><span>Cancel</span></a>
		    </form>
			<script type="text/javascript">
				// colorbox: lightbox windows for the gers sku lookup
				$("a[rel^='gersLookupLink']").colorbox({fixedWidth:"600px", fixedHeight:"200px", iframe:true, href:"gersLookup.cfm"});
	    	</script>
		</cfsavecontent>
		<cfreturn local.html />
	</cffunction>

	<cffunction name="getCloneAccessoryForm" returntype="string">
    	<cfargument name="productGuid" type="string" default="" />

  		<cfset var local = {
  				html = '',
  				productGuid = arguments.productGuid,
  				productDetails = application.model.AdminAccessory.getAccessory(local.productGuid)
  		} />
		<cfset var channels = application.model.Channel.getAllChannels() />

    	<cfsavecontent variable="local.html">
    		<form  method="post" name="cloneAccessory" class="middle-forms">
    			<fieldset>
    			<legend>Fieldset Title</legend>
    				<ol>
						<li class="odd">
    			        	<label class="field-title">Channel: </label>
    			            <label>
    			            	<select name="channelID">
									<cfloop query="channels">
										<cfoutput><option value="#channelID#">#channel#</option></cfoutput>
									</cfloop>
								</select>
    			            </label>
    			            <span class="clearFix">&nbsp;</span>
    			       	</li>
						<li class="even">
    			        	<label class="field-title">GerSku: </label>
    			            <label><input name="accessoryGersSku" class="txtbox-long" maxlength="9" /></label>
    			            <span class="clearFix">&nbsp;</span>
    			       	</li>
						<li class="odd">
							<label class="field-title" title="Active Channel">Available Online:</label>
							<label> <input type="checkbox" name="active" value="1" id="active"/> </label>
							<span class="clearFix">&nbsp;</span>
						</li>
    			    </ol><!-- end of form elements -->
    			</fieldset>
				<input type="hidden" name="deviceUPC" value="<cfoutput>#local.productDetails.upc#</cfoutput>">
				<input type="hidden" name="productId" value="<cfoutput>#local.productDetails.productID#</cfoutput>">
    			<input type="hidden" name="acessoryGuid" value="<cfoutput>#local.productGuid#</cfoutput>" />
    			<input type="hidden" name="manufacturerGuid" value="<cfoutput>#local.productDetails.ManufacturerGuid#</cfoutput>" />
    			<input type="hidden" name="action" value="cloneAccessory" />
    			<a href="javascript: void();" onclick="postForm(this);" class="button" title="Check the uniqueness of the UPC and channelize this accessory"><span>Channelize Accessory</span></a> <a href="javascript: show('action=cancelAccessoryClone');" class="button" title="Cancel the channelizing of this accessory"><span>Cancel</span></a>
   			</form>
		</cfsavecontent>

    	<cfreturn local.html />
    </cffunction>

	<cffunction name="getMasterCloneAccessoryForm" returntype="string">
    	<cfargument name="productGuid" type="string" default="" />

  		<cfset var local = {
  				html = '',
  				productGuid = arguments.productGuid,
  				productDetails = application.model.AdminAccessory.getAccessory(local.productGuid)
  		} />
		<cfset var channels = application.model.Channel.getAllChannels() />

    	<cfsavecontent variable="local.html">
    		<form  method="post" name="cloneAccessory" class="middle-forms">
    			<fieldset>
    			<legend>Fieldset Title</legend>
    				<ol>
						<li class="odd">
    			        	<label class="field-title">Channel: </label>
    			            <label>
    			            	<select name="channelID">
									<option value="1" selected>Master Copy</option>
								</select>
    			            </label>
    			            <span class="clearFix">&nbsp;</span>
    			       	</li>
						<li class="even">
				        	<label class="field-title">Name: </label>
				            <label><input type="text" name="name" class="txtbox-long" maxlength="67" value="<cfoutput>#local.productDetails.name#</cfoutput>"></label>
				            <span class="clearFix">&nbsp;</span>
				       	</li>
						<li class="odd">
				        	<label class="field-title">UPC: </label>
				            <label><input type="text" name="newUPC" class="txtbox-long" maxlength="20" value="<cfoutput>#local.productDetails.upc#</cfoutput>"></label>
				            <span class="clearFix">&nbsp;</span>
				       	</li>
						<li class="even">
							<label class="field-title" title="Active Channel">Available Online:</label>
							<label> <input type="checkbox" name="active" value="1" id="active"/> </label>
							<span class="clearFix">&nbsp;</span>
						</li>
    			    </ol><!-- end of form elements -->
    			</fieldset>
				<input type="hidden" name="accessoryGersSku" value="MASTERCAT" />
				<input type="hidden" name="oldSku" value="<cfoutput>#local.productDetails.upc#</cfoutput>">
				<input type="hidden" name="productId" value="<cfoutput>#local.productDetails.productID#</cfoutput>">
    			<input type="hidden" name="acessoryGuid" value="<cfoutput>#local.productGuid#</cfoutput>" />
    			<input type="hidden" name="manufacturerGuid" value="<cfoutput>#local.productDetails.ManufacturerGuid#</cfoutput>" />
    			<input type="hidden" name="action" value="cloneAccessory" />
    			<a href="javascript: void();" onclick="postForm(this);" class="button" title="Check the uniqueness of the UPC and Copy this accessory"><span>Copy Accessory as New</span></a> <a href="javascript: show('action=cancelAccessoryClone');" class="button" title="Cancel the channelizing of this accessory"><span>Cancel</span></a>
   			</form>
		</cfsavecontent>

    	<cfreturn local.html />
    </cffunction>
</cfcomponent>