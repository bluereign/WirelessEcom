<cfcomponent output="false" displayname="AdminTablet">

	<cffunction name="init" returntype="AdminTablet">
    	<cfreturn this>
    </cffunction>

    <cffunction name="getCloneTabletForm" returntype="string">
    	<cfargument name="tabletGuid" type="string" default="" />

  		<cfset var local = {
  				html = '',
  				tabletGuid = arguments.tabletGuid,
  				tabletDetails = application.model.AdminTablet.getTablet(local.tabletGuid)
  		} />
		<cfset var channels = application.model.Channel.getAllChannels() />

    	<cfsavecontent variable="local.html">
    		<form  method="post" name="clonePlan" class="middle-forms">
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
				<input type="hidden" name="deviceUPC" value="<cfoutput>#local.tabletDetails.upc#</cfoutput>">
				<input type="hidden" name="productId" value="<cfoutput>#local.tabletDetails.productID#</cfoutput>">
    			<input type="hidden" name="tabletGuid" value="<cfoutput>#local.tabletGuid#</cfoutput>" />
    			<input type="hidden" name="manufacturerGuid" value="<cfoutput>#local.tabletDetails.ManufacturerGuid#</cfoutput>" />
    			<input type="hidden" name="action" value="cloneTablet" />
    			<a href="javascript: void();" onclick="postForm(this);" class="button" title="Check the uniqueness of the UPC and channelize this tablet"><span>Channelize Tablet</span></a> <a href="javascript: show('action=cancelTabletClone');" class="button" title="Cancel the channelizing of this tablet"><span>Cancel</span></a>
   			</form>
		</cfsavecontent>

    	<cfreturn local.html />
    </cffunction>

	<cffunction name="getMasterCloneTabletForm" returntype="string">
		<cfargument name="tabletGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				tabletGuid = arguments.tabletGuid,
				tabletDetails = application.model.AdminTablet.getTablet(local.tabletGuid)
		} />
		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfsavecontent variable="local.html">
			<form  method="post" name="clonePlan" class="middle-forms">
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
				            <label><input type="text" name="name" class="txtbox-long" maxlength="67" value="<cfoutput>#local.tabletDetails.name#</cfoutput>"></label>
				            <span class="clearFix">&nbsp;</span>
				       	</li>
						<li class="odd">
				        	<label class="field-title">UPC: </label>
				            <label><input type="text" name="newUPC" class="txtbox-long" maxlength="20" value="<cfoutput>#local.tabletDetails.upc#</cfoutput>"></label>
				            <span class="clearFix">&nbsp;</span>
				       	</li>
						<li class="even">
							<label class="field-title" title="Active Channel">Available Online:</label>
							<label><input type="checkbox" name="active" value="1" id="active"/> </label>
							<span class="clearFix">&nbsp;</span>
						</li>
				    </ol><!-- end of form elements -->
				</fieldset>
				<input type="hidden" name="accessoryGersSku" value="MASTERCAT" />
				<input type="hidden" name="oldSKU" value="<cfoutput>#local.tabletDetails.upc#</cfoutput>">
				<input type="hidden" name="productId" value="<cfoutput>#local.tabletDetails.productID#</cfoutput>">
				<input type="hidden" name="tabletGuid" value="<cfoutput>#local.tabletGuid#</cfoutput>" />
				<input type="hidden" name="manufacturerGuid" value="<cfoutput>#local.tabletDetails.ManufacturerGuid#</cfoutput>" />
				<input type="hidden" name="action" value="cloneTablet" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Check the uniqueness of the UPC and Copy this tablet"><span>Copy Tablet as New</span></a> <a href="javascript: show('action=cancelTabletClone');" class="button" title="Cancel the channelizing of this tablet"><span>Cancel</span></a>
			</form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

  	<cffunction name="getEditTabletForm" returntype="string">
  		<cfargument name="productGuid" type="string" default="" />

		<cfset var activeChannels = "" />
  		<cfset var local = {
 					html = '',
  					productGuid = arguments.productGuid,
  					active = false,
  					name = '',
  					upc = '',
  					carrier = '',
  					carrierGuid = '',
  					manufacturer = '',
  					manufacturerGuid = '',
  					title = '',
  					ReleaseDate = '',
  					shortDescription = '',
  					longDescription = '',
  					filter = { isCarrier = true },
  					carriersQry = application.model.AdminCompany.getCompanies(local.filter),
  					manFilter = {},
  					manufacturersQry = application.model.AdminCompany.getCompanies(local.manFilter),
  					gersSku = 'MASTERCAT',
  					productId = '',
  					metaDescription = "",
  					metaKeywords = "",
  					ReleaseDate = "",
  					channelId = "1",
  					SafteyStock = "",
  					masterData = {}
  				} />

		<cfset var channels = application.model.Channel.getAllChannels() />
		<cfset var masterData = "" />
   		<cfif local.productGuid NEQ "">
   			<cfset activeChannels = application.model.AdminProduct.getProductChannels(local.productGuid) />
   			<!--- set display --->
   			<cfset local.tabletDetails = application.model.AdminTablet.getTablet(local.productGuid) />
  			<cfset local.name = local.tabletDetails.Name />
  			<cfset local.upc = local.tabletDetails.UPC />
   			<cfset local.carrierGuid = local.tabletDetails.CarrierGuid />
   			<cfset local.carrier = local.tabletDetails.Carrier />
   			<cfset local.manufacturerGuid = local.tabletDetails.ManufacturerGuid />
 			<cfset local.manufacturer = local.tabletDetails.Manufacturer />
   			<cfset local.title = local.tabletDetails.Title />
			<cfset local.ReleaseDate = local.tabletDetails.ReleaseDate />
   		    <cfset local.shortDescription = local.tabletDetails.ShortDescription />
  		   	<cfset local.longDescription = local.tabletDetails.LongDescription />
   		    <cfset local.active = local.tabletDetails.Active />
   		    <cfset local.gersSku = local.tabletDetails.gersSku />
   		    <cfset local.productId = local.tabletDetails.productId />
			<cfset local.metaDescription = local.tabletDetails.metaDescription />
			<cfset local.metaKeywords = local.tabletDetails.metaKeywords />
			<cfset local.ReleaseDate = local.tabletDetails.ReleaseDate />
			<cfset local.channelId = local.tabletDetails.channelId>
			<cfset local.SafteyStock = local.tabletDetails.SafteyStock>

			<cfif local.channelId neq 1>
				<cfset local.masterData = application.model.AdminTablet.getMasterTablet(local.productId) >
			</cfif>
   		</cfif>

   			<cfsavecontent variable="local.html">
   			    <form  method="post" name="updateTablet" class="middle-forms">
   			        <fieldset>
   			            <legend>Fieldset Title</legend>
   			            <ol>
   			            	<li class="odd">
   			            		<label class="field-title" title="Indicates Required Field"><span class="required">* Required Field</span></label>
							</li>
   				            <cfif local.productId NEQ "">
   				                <li class="even">
   				                    <label class="field-title" title="The productId for this device">Product Id: </label>
   									<label><cfoutput>#local.productId#</cfoutput></label>
   				                    <span class="clearFix">&nbsp;</span>
   				                </li>
   			                </cfif>
   			                <li class="odd">
   			                    <label class="field-title" title="Check the box to make this tablet available to customers">Availability: </label>
   			                    <label>
   			                        <input type="checkbox" name="active" <cfif local.active eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
   			                        Available Online
   			                    </label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
   			                <li class="even">
   			                    <label class="field-title" title="Required: Select the carrier of this tablet">Carrier: <span class="required">*</span></label>
   			                    <label>
   			                    	<cfif find(local.channelId,"0,1")>
	   				                    <select name="carriers">
	   					                    <option value="">Select a Carrier</option>
	   										<cfloop query="local.carriersQry">
	   											<cfoutput><option value="#local.carriersQry.companyGuid#" <cfif local.carrierGuid EQ local.carriersQry.companyGuid> selected="selected"</cfif>>#local.carriersQry.companyName#</option></cfoutput>
	   										</cfloop>
	   									</select>
									<cfelse>
										<cfoutput>
											#local.carrier#
											<input type="hidden" name="carriers" value="#local.carrierGuid#">
										</cfoutput>
					   				</cfif>
   								</label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
   			                <li class="odd">
   			                    <label class="field-title" title="Required: Select the manufacturer of this tablet">Manufacturer: <span class="required">*</span></label>
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
   							<li class="even">
   			                    <label class="field-title" title="The name of the tablet">Name:</label>
   			                    <cfif local.name eq "">
   			                    	<label><input name="name" class="txtbox-long" /></label>
   			                    <cfelse>
   	                    			<label><cfoutput>#local.name#</cfoutput></label>
   								</cfif>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
							<li class="odd">
   			                    <label class="field-title" title="Required: The title of the tablet">Title: <span class="required">*</span></label>
   			                    <label><input name="title" class="txtbox-long" value="<cfoutput>#local.title#</cfoutput>" /></label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
   							<li class="even">
   			                    <label class="field-title" title="The UPC of the tablet">UPC:</label>
   			                    <label><input name="upc" class="txtbox-long" maxlength="12" value="<cfoutput>#local.upc#</cfoutput>" /></label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
							<li class="odd">
								<label class="field-title" title="Required: Select Channel">Channel: <span class="required">*</span></label>
								<label>
									<select name="channelID">
										<cfif !len(trim(local.channelId)) OR find(local.channelId,"0,1")>
											<cfif (isQuery(activeChannels) && activeChannels.recordCount EQ 0) || !len(trim(local.productGuid))>
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
								</label>
								<span class="clearFix">&nbsp;</span>
							</li>
							<li class="even">
								<label class="field-title" title="Active Channel">Active:</label>
								<label><cfif isQuery(activeChannels)><cfoutput query="activeChannels">#channel#, </cfoutput></cfif></label>
								<span class="clearFix">&nbsp;</span>
							</li>
   			                <li class="odd">
   			                    <label class="field-title" title="The GERS SKU of the tablet">GERS SKU:</label>
   			                    <label><input name="gersSku" class="txtbox-short" maxlength="9" value="<cfoutput>#local.gersSku#</cfoutput>" /></label>
   				                <label><!---<a rel="gersLookupLink" href="gersLookup.cfm">Look up GERS SKU</a>---></label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>

   			                <li class="even">
   			                    <label class="field-title" title="The date of live release">Release Date:</label>
   			                    <label><input id="ReleaseDate" name="ReleaseDate" class="txtbox-short datepicker" value="<cfoutput>#local.ReleaseDate#</cfoutput>" /></label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
							<li class="odd">
								<label class="field-title" title="Set Safety Stock">Set Safety Stock:</label>
								<label><input type="text" class="txtbox-short" id="SafteyStock" name="SafteyStock" value="<cfif !len(trim(local.SafteyStock))>3<cfelse><cfoutput>#local.SafteyStock#</cfoutput></cfif>"></label>
								<span class="clearFix">&nbsp;</span>
							</li>
							
							<!--- Don't show this for Master Records --->
							<cfif local.channelId neq 1>
	   			                <li class="even">
	   			                    <label for="masterShortDescription" class="field-title" title="The Master short description of the tablet">Master Short Description: </label>
										<cfif structKeyExists(local.masterData,"shortDescription")>
											<div id="masterShortDescription" class="rawMasterOutput"><div><cfoutput>#local.masterData.shortDescription#</cfoutput></div></div>
										<cfelse>
											<div id="masterShortDescription" class="undefined"><div>Master Short Description Undefined</div></div>
										</cfif>
									<span class="clearFix">&nbsp;</span>
								</li>
							</cfif>
							
							
							<li class="even">
								<label class="field-title" title="The short description of the tablet">Short Description:</label>
								<label>
   			                        <textarea id="shortDescriptionEditor" name="shortDescription" rows="7" cols="40"><cfoutput>#local.shortDescription#</cfoutput></textarea>
   			                    </label>
   	   			                 <script>
   	   			                 	var editor = CKEDITOR.replace( 'shortDescriptionEditor' );
   	   			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );
   	   			                 </script>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
							
							
							<!--- Don't show this for Master Records --->
							<cfif local.channelId neq 1>
								<li class="odd">
									<label for="masterLongtDescription" class="field-title" title="The Master long description of the tablet">Master Long Description: </label>
										<cfif structKeyExists(local.masterData,"longDescription")>
											<div id="masterLongDescription" class="rawMasterOutput"><div><cfoutput>#local.masterData.longDescription#</cfoutput></div></div>
										<cfelse>
											<div id="masterLongDescription" class="undefined"><div>Master Long Description Undefined</div></div>
										</cfif>
									<span class="clearFix">&nbsp;</span>
								</li>
							</cfif>
							
   			                <li class="odd">
   			                    <label class="field-title" title="The long description of the tablet">Long Description:</label>
   			                    <label>
   			                    	<textarea id="longDescriptionEditor" name="longDescription" rows="7" cols="40" ><cfoutput>#local.longDescription#</cfoutput></textarea>
   			                    </label>
   			                 	<script>
	   			                 	var editor = CKEDITOR.replace( 'longDescriptionEditor' );
	   			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );
   			                 	</script>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
   			                <li class="even">
   			                    <label class="field-title" title="Description for Search Engines">Meta Description:</label>
   			                    <label>
   			                    	<cfif find(local.channelId,"0,1")>
										<textarea name="metaDescription" class="txtbox-long"><cfoutput>#local.metaDescription#</cfoutput></textarea>
									<cfelse>
										<cfoutput>#local.metaDescription#</cfoutput>
										<cfoutput><input type="hidden" name="metaDescription" value="#local.metaDescription#"></cfoutput>
									</cfif>
								</label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
   			                <li class="odd">
   			                    <label class="field-title" title="Keywords for Search Engines">Meta Keywords:</label>
   			                    <label>
   			                    	<cfif find(local.channelId,"0,1")>
										<textarea name="metaKeywords" class="txtbox-long"><cfoutput>#local.metaKeywords#</cfoutput></textarea>
									<cfelse>
										<cfoutput>#local.metaKeywords#</cfoutput>
										<cfoutput><input type="hidden" name="metaKeywords" value="#local.metaKeywords#"></cfoutput>
									</cfif>
									</label>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
   			            </ol><!-- end of form elements -->
   			        </fieldset>
   			     	<input type="hidden" name="productGuid" value="<cfoutput>#local.productGuid#</cfoutput>" />
   			     	<input type="hidden" name="action" value="updateTabletDetails" />
   					<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save changes made to this tablet"><span>Save</span></a> <a href="javascript: show('action=cancelTabletEdit');" class="button" title="Cancel changes made to this tablet"><span>Cancel</span></a>
   			    </form>
   				<script type="text/javascript">
   					// colorbox: lightbox windows for the gers sku lookup
   					$("a[rel^='gersLookupLink']").colorbox({fixedWidth:"600px", fixedHeight:"200px", iframe:true, href:"gersLookup.cfm"});
   		    	</script>
   			</cfsavecontent>

   			<cfreturn local.html />
   		</cffunction>

   	<cffunction name="getEditTabletServiceForm" returntype="string">
   			<cfargument name="productGuid" type="string" default="" />

   			<cfset var local = {
   					html = ''
   				} />

   				<cfsavecontent variable="local.html">
   				    <form  method="post" name="updateDeviceService" class="middle-forms">
   				        <fieldset>
   				            <legend>Fieldset Title</legend>
   				            <ol>
   				                <li class="odd">
   				                    <label class="field-title" title="Check the box to make this accessory viewable online">Availability: </label>
   				                    <label>
   				                        <input type="checkbox" name="active" <cfif local.active eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
   				                        Available Online
   				                    </label>
   				                    <span class="clearFix">&nbsp;</span>
   				                </li>
   				                <li class="even">
   				                    <label class="field-title" title="The manufacturer of the accessory">Manufacturer:</label>
   				                    <label>
   					                    <select name="manufacturers">
   						                    <option value="">Select a Manufacturer</option>
   											<cfloop query="local.manufacturersQry">
   												<cfoutput><option value="#local.manufacturersQry.companyGuid#" <cfif local.manufacturerGuid EQ local.manufacturersQry.companyGuid> selected="selected"</cfif>>#local.manufacturersQry.companyName#</option></cfoutput>
   											</cfloop>
   										</select>
   									</label>
   				                    <span class="clearFix">&nbsp;</span>
   				                </li>
   								<li class="odd">
   				                    <label class="field-title" title="The name that identifies the accessory">Name:</label>
   				                    <label><input name="name" class="txtbox-long" value="<cfoutput>#local.name#</cfoutput>" /></label>
   				                    <span class="clearFix">&nbsp;</span>
   				                </li>
   								<li class="even">
   				                    <label class="field-title" title="The UPC of the accessory">UPC:</label>
   				                    <label><input name="upc" class="txtbox-long" maxlength="12" value="<cfoutput>#local.upc#</cfoutput>" /></label>
   				                    <span class="clearFix">&nbsp;</span>
   				                </li>
   				                <li class="odd">
   				                    <label class="field-title" title="The title of the accessory">Title:</label>
   				                    <label><input name="title" class="txtbox-long" value="<cfoutput>#local.title#</cfoutput>" /></label>
   				                    <span class="clearFix">&nbsp;</span>
   				                </li>
   				                <li onkeydown=""class="even">
   				                    <label class="field-title" title="A short description of the accessory">Short Description: </label>
   				                    <label>
   				                        <textarea class="wysiwyg" name="shortDescription" rows="7"><cfoutput>#local.shortDescription#</cfoutput></textarea>
   				                    </label>
   				                    <span class="clearFix">&nbsp;</span>
   				                </li>
   				                <li class="odd">
    				            <label class="field-title" title="A long description of the accessory">Long Description: </label>
    				            <label>
    				            	<textarea class="wysiwyg" name="longDescription" rows="7"><cfoutput>#local.longDescription#</cfoutput></textarea>
    				            </label>
    				        	<span class="clearFix">&nbsp;</span>
    				   		</li>
    					</ol><!-- end of form elements -->
    				</fieldset>
    				<input type="hidden" name="accessoryId" value="<cfoutput>#local.accessoryId#</cfoutput>" />
    				<input type="hidden" name="action" value="updateAccessoryDetails" />
    				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save this accessory to the database"><span>Save</span></a> <a href="javascript: show('action=cancelAccessoryEdit');" class="button" title="Cancel the changes made to this accessory and do not save"><span>Cancel</span></a>
    			</form>
    		</cfsavecontent>
    	<cfreturn local.html />
    </cffunction>

	<cffunction name="getTabletList" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />

		<cfset var local = structNew() />
		<cfset local.filter = arguments.filter />
		<cfset local.dislayTitle = '' />

		<cfset local.carriers = application.model.Company.getAllCarriers() />
		<cfset local.tablets = application.model.AdminTablet.getTablets(local.filter) />

		
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
				<table id="listTabletAll" class="table-long gridview-momt-tablets">
					<thead>
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
						<cfloop query="local.tablets">
							<cfif guidbreak is not trim(local.tablets.matchingGUID)>
								<cfset oddeven = oddeven xor 1 />
								<cfset guidbreak = local.tablets.matchingGUID />
								<cfset guidCount = guidCount+1 />
							</cfif>
							<tr class="<cfif oddeven is 1>momt-odd-group<cfelse>momt-even-group</cfif>">
								<cfif not len(trim(local.tablets.title[local.tablets.currentRow]))>
									<cfif len(trim(local.tablets.name[local.tablets.currentRow]))>
										<cfset local.displayTitle = trim(local.tablets.name[local.tablets.currentRow]) />
									<cfelse>
										<cfset local.displayTitle = 'No Title or Name Set' />
									</cfif>
								<cfelse>
									<cfset local.displayTitle = trim(local.tablets.title[local.tablets.currentRow]) />
								</cfif>
								
								<td class="hidden-col">#guidCount#</td>
								<td>#trim(local.tablets.channel)#</td>
								<td><a href="?c=98195743-6AEE-4BC8-975A-030025760B9C&productguid=#local.tablets.tabletGuid[local.tablets.currentRow]#">#trim(local.displayTitle)#</a></td>
								<td>#yesNoFormat(trim(local.tablets.active[local.tablets.currentRow]))#</td>
								<td>#trim(local.tablets.carrier[local.tablets.currentRow])#</td>
								<td>#trim(local.tablets.upc[local.tablets.currentRow])#</td>
								<td>#trim(local.tablets.productId[local.tablets.currentRow])#</td>
								<td>#trim(local.tablets.gersSku[local.tablets.currentRow])#</td>
								<td>#dateformat(trim(local.tablets.createDate[local.tablets.currentRow]),"mm/dd/yyyy")#</td>
								<td class="hidden-col">#local.tablets.currentRow#</td>
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
