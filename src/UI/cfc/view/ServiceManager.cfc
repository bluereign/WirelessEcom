<cfcomponent output="false" displayname="ServiceManager">

	<cffunction name="init" returntype="ServiceManager">
    	<cfreturn this />
    </cffunction>

 	<cffunction name="getCloneServiceForm" returntype="string">
 		<cfargument name="serviceGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				serviceGuid = arguments.serviceGuid,
				carrierQry = application.model.ServiceManager.getServiceCarrier(local.serviceGuid),
				service = application.model.ServiceManager.getService(local.serviceGuid)
			} />

		<cfset var channels = application.model.Channel.getAllChannels() />

 		<cfsavecontent variable="local.html">
 			<form  method="post" name="cloneService" class="middle-forms">
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
				<input type="hidden" name="deviceUPC" value="notused">
				<input type="hidden" name="productId" value="<cfoutput>#local.service.productID#</cfoutput>">
				<input type="hidden" name="serviceGuid" value="<cfoutput>#local.serviceGuid#</cfoutput>" />
 			    <input type="hidden" name="action" value="cloneService" />
	 			<a href="javascript: void();" onclick="postForm(this);" class="button" title="Make sure the Carrier Bill Code is unique and channelize this service"><span>Channelize Service</span></a> <a href="javascript: show('action=cancelServiceClone');" class="button" title="Cancel changes made to this service and do not save"><span>Cancel</span></a>
 			</form>
 		</cfsavecontent>

 		<cfreturn local.html />
 	</cffunction>

	<cffunction name="getMasterCloneServiceForm" returntype="string">
 		<cfargument name="serviceGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				serviceGuid = arguments.serviceGuid,
				carrierQry = application.model.ServiceManager.getServiceCarrier(local.serviceGuid),
				service = application.model.ServiceManager.getService(local.serviceGuid)
			} />

		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfsavecontent variable="local.html">
			<form  method="post" name="cloneService" class="middle-forms">
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
							<label><input type="text" name="name" class="txtbox-long" maxlength="100" value="<cfoutput>#local.service.name#</cfoutput>"></label>
							<span class="clearFix">&nbsp;</span>
						</li>
						<li class="odd">
							<label class="field-title" title="Active Channel">Available Online:</label>
							<label><input type="checkbox" name="active" value="1" id="active"/></label>
							<span class="clearFix">&nbsp;</span>
						</li>
					</ol><!-- end of form elements -->
				</fieldset>
				<input type="hidden" name="accessoryGersSku" value="MASTERCAT" />
				<input type="hidden" name="oldSku" value="notused">
				<input type="hidden" name="newUPC" value="notused">
				<input type="hidden" name="productId" value="<cfoutput>#local.service.productID#</cfoutput>">
				<input type="hidden" name="serviceGuid" value="<cfoutput>#local.serviceGuid#</cfoutput>" />
				<input type="hidden" name="action" value="cloneService" />

				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Copy this service"><span>Copy Service as New</span></a> <a href="javascript: show('action=cancelServiceClone');" class="button" title="Cancel changes made to this service and do not save"><span>Cancel</span></a>
			</form>
		</cfsavecontent>

 		<cfreturn local.html />
 	</cffunction>

	<cffunction name="getEditServiceForm" returntype="string">
		<cfargument name="serviceGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				serviceGuid = arguments.serviceGuid,
				active = false,
				name = '',
				monthlyFee = '',
				financedPrice = '',
				carrierGuid = '',
				carrierBillCode = '',
				gersSku = 'MASTERCAT',
				productId = '',
				shortDescription = '',
				longDescription = '',
				filter = { isCarrier = true },
				carriersQry = application.model.AdminCompany.getCompanies(local.filter),
				cartTypeId	= '1,2,3',
				channelId = "1"
			} />

		<cfset var activeChannels = "" />
		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfif local.serviceGuid NEQ "">
			<cfset activeChannels = application.model.AdminProduct.getProductChannels(local.serviceGuid) />
			<!--- set display --->
			<cfset local.serviceDetails = application.model.ServiceManager.getService(local.serviceGuid) />
			<cfset local.cartTypeId = local.serviceDetails.cartTypeId />
			<cfset local.name = local.serviceDetails.Name />
			<cfset local.monthlyFee = local.serviceDetails.MonthlyFee />
			<cfset local.financedPrice = local.serviceDetails.FinancedPrice />
			<cfset local.carrier = local.serviceDetails.Carrier />
			<cfset local.carrierGuid = local.serviceDetails.CarrierGuid />
			<cfset local.carrierBillCode = local.serviceDetails.CarrierBillCode />
			<!---<cfset local.title = local.serviceDetails.Title />--->
		    <cfset local.shortDescription = local.serviceDetails.ShortDescription />
		    <cfset local.longDescription = local.serviceDetails.LongDescription />
		    <cfset local.active = local.serviceDetails.Active />
		    <cfset local.gersSku = local.serviceDetails.gersSku />
		    <cfset local.productId = local.serviceDetails.productId />
			<cfset local.channelId = local.serviceDetails.channelId>

		    <cfif not len(trim(local.cartTypeId))>
		    	<cfset local.cartTypeId = '1,2,3' />
		    </cfif>
		</cfif>
		
			<!--- Get the master record for this service --->
			<cfif local.channelId neq 1>
				<cfset local.masterData = application.model.AdminPlanService.getMasterPlanService(local.productId) >
			</cfif>

		<cfsavecontent variable="local.html">
		    <form  method="post" name="updateService" class="middle-forms">
		        <fieldset>
		            <legend>Fieldset Title</legend>
		            <ol>
		            	<li class="odd">
			            	<label class="field-title" title="Indicates Required Field"><span class="required">* Required Field</span></label>
						</li>
			            <cfif local.productId NEQ "">
			                <li class="even">
			                    <label class="field-title" title="The productId for this this service">Product Id: </label>
								<label><cfoutput>#local.productId#</cfoutput></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
		                </cfif>
		                <li class="odd">
		                    <label class="field-title" title="Check the box to make this phone available to customers">Availability: </label>
		                    <label>
		                        <input type="checkbox" name="active" <cfif local.active eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
		                        Available Online
		                    </label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Required: Select the carrier of this service">Carrier: <span class="required">*</span></label>
		                    <label>
			                    <cfif find(local.channelId,"0,1")>
									<select name="carrierGuid">
					                    <option value="">Select a Carrier</option>
										<cfloop query="local.carriersQry">
											<cfoutput><option value="#local.carriersQry.companyGuid#" <cfif local.carrierGuid EQ local.carriersQry.companyGuid> selected="selected"</cfif>>#local.carriersQry.companyName#</option></cfoutput>
										</cfloop>
									</select>
								<cfelse>
									<cfoutput>
										#local.carrier#
										<input type="hidden" name="carrierGuid" value="#local.carrierGuid#">
									</cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="Required: The name of the service">Name: <span class="required">*</span></label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
									<input name="name" class="txtbox-long" value="<cfoutput>#local.name#</cfoutput>" />
								<cfelse>
									<!---
										<cfoutput>
											#local.name#
											<input type="hidden" name="name" value="#local.name#">										
										</cfoutput>
									--->
									<input name="name" class="txtbox-long" value="<cfoutput>#local.name#</cfoutput>" />
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<!---<li class="odd">
		                    <label class="field-title" title="The title of the phone">Title:</label>
		                    <label><input name="title" class="txtbox-long" value="<cfoutput>#local.title#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>--->
		                <li class="even">
		                    <label class="field-title" title="Required: The carrier bill code of the service">Carrier Bill Code:<span class="required">*</span></label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
									<input name="billCode" class="txtbox-long" maxlength="12" value="<cfoutput>#local.carrierBillCode#</cfoutput>" />
								<cfelse>
									<cfoutput>
										#local.carrierBillCode#
										<input type="hidden" name="billCode" value="#local.carrierBillCode#" />
									</cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
							<label class="field-title" title="Required: Select Channel">Channel: <span class="required">*</span></label>
							<label>
								<select name="channelID">
									<cfif !len(trim(local.channelId)) OR find(local.channelId,"0,1")>
										<cfif (isQuery(activeChannels) && activeChannels.recordCount EQ 0) || !len(trim(local.serviceGuid))>
											<option value="0">Unassigned</option>
										</cfif>
										<option value="1"<cfif local.channelId eq channels.channelId> selected</cfif>>Master</option>
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
		                    <label class="field-title" title="The GERS SKU of the phone">GERS SKU:</label>
		                    <label><input name="gersSku" class="txtbox-short" maxlength="9" value="<cfoutput>#local.gersSku#</cfoutput>" /></label>
							<!---<label><a rel="gersLookupLink" href="gersLookup.cfm">Look up GERS SKU</a></label>--->
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="The monthly fee of the service">Monthly Fee:</label>
		                    <label><input name="monthlyFee" class="txtbox-long" value="<cfoutput>#local.monthlyFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="The monthly fee of the service for financed phones">Financed Price:</label>
		                    <label><input name="financedPrice" class="txtbox-long" value="<cfoutput>#local.financedPrice#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						
						<!--- Don't show this for Master Records --->
						<cfif local.channelId neq 1>
   			                <li class="even">
   			                    <label for="masterShortDescription" class="field-title" title="The Master short description of the phone">Master Short Description: </label>
									<cfif structKeyExists(local.masterData,"shortDescription")>
										<div id="masterShortDescription" class="rawMasterOutput"><div><cfoutput>#local.masterData.shortDescription#</cfoutput></div></div>
									<cfelse>
										<div id="masterShortDescription" class="undefined"><div>Master Short Description Undefined</div></div>
									</cfif>
								<span class="clearFix">&nbsp;</span>
							</li>
						</cfif>
						
							<li class="even">
								<label class="field-title" title="The short description of the service">Short Description:</label>
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
									<label for="masterLongtDescription" class="field-title" title="The Master long description of the service">Master Long Description: </label>
										<cfif structKeyExists(local.masterData,"longDescription")>
											<div id="masterLongDescription" class="rawMasterOutput"><div><cfoutput>#local.masterData.longDescription#</cfoutput></div></div>
										<cfelse>
											<div id="masterLongDescription" class="undefined"><div>Master Long Description Undefined</div></div>
										</cfif>
									<span class="clearFix">&nbsp;</span>
								</li>
							</cfif>
							
   			                <li class="odd">
   			                    <label class="field-title" title="The long description of the service">Long Description:</label>
   			                    <label>
   			                    	<textarea id="longDescriptionEditor" name="longDescription" rows="7" cols="40" ><cfoutput>#local.longDescription#</cfoutput></textarea>
   			                    </label>
   			                 	<script>
	   			                 	var editor = CKEDITOR.replace( 'longDescriptionEditor' );
	   			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );
   			                 	</script>
   			                    <span class="clearFix">&nbsp;</span>
   			                </li>
						

<!---		                <li class="odd">
		                    <label class="field-title" title="The short description of the service">Short Description: </label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
		                       		<textarea id="shortDescriptionEditor" name="shortDescription" rows="7" cols="40"><cfoutput>#local.shortDescription#</cfoutput></textarea>
		                        <cfelse>
									<cfoutput>#local.shortDescription#</cfoutput>
									<cfoutput><input type="hidden" name="shortDescription" value="#local.shortDescription#"></cfoutput>
								</cfif>
		                    </label>
		                 	<cfif find(local.channelId,"0,1")>
								<script>
			                 	var editor = CKEDITOR.replace( 'shortDescriptionEditor' );
			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );
			                 	</script>
							</cfif>
		                    <span class="clearFix">&nbsp;</span>
		                </li>--->
<!---		                <li class="even">
		                    <label class="field-title" title="The long description of the service">Long Description: </label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
		                    		<textarea id="longDescriptionEditor" name="longDescription" rows="7" cols="40" ><cfoutput>#local.longDescription#</cfoutput></textarea>
								<cfelse>
									<cfoutput>#local.longDescription#</cfoutput>
									<cfoutput><input type="hidden" name="longDescription" value="#local.longDescription#"></cfoutput>
								</cfif>
		                    </label>
		                 	<cfif find(local.channelId,"0,1")>
								<script>
			                 	var editor = CKEDITOR.replace( 'longDescriptionEditor' );
			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );
			                 	</script>
							 </cfif>
		                    <span class="clearFix">&nbsp;</span>
		                </li>--->
		                <li class="odd">
		                	<label class="field-title" title="Activation Type">Activation Types:</label>
		                	<label>
		                		<cfoutput>
			                		<select name="cartTypeId" size="3" multiple>
			                			<option value="1" #iif(listFind(local.cartTypeId, 1), de('selected'), de(''))#>New</option>
			                			<option value="2" #iif(listFind(local.cartTypeId, 2), de('selected'), de(''))#>Upgrade</option>
			                			<option value="3" #iif(listFind(local.cartTypeId, 3), de('selected'), de(''))#>Add-a-Line</option>
			                		</select>
			                	</cfoutput>
		                	</label>
		                	<span class="clearFix">&nbsp;</span>
		                </li>
		            </ol><!-- end of form elements -->
		        </fieldset>
		     	<input type="hidden" name="serviceGuid" value="<cfoutput>#local.serviceGuid#</cfoutput>" />
		     	<input type="hidden" name="action" value="updateService" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save changes made to this service"><span>Save</span></a> <a href="javascript: show('action=cancelServiceEdit');" class="button" title="Cancel changes made to this service"><span>Cancel</span></a>
		    </form>
			<script type="text/javascript">
			// colorbox: lightbox windows for the gers sku lookup
				$("a[rel^='gersLookupLink']").colorbox({fixedWidth:"600px", fixedHeight:"200px", iframe:true, href:"gersLookup.cfm"});
			</script>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

   	<cffunction name="getServiceList" returntype="string">
		<cfargument name="filter" type="struct" default="#StructNew()#" />

    	<cfset var local = structNew()>
        <cfset local.filter = arguments.filter />
        <cfset local.dislayTitle = '' />

		<cfset local.carriers = application.model.Company.getAllCarriers() />
     	<cfset local.services = application.model.ServiceManager.getServices(local.filter) />

        <cfsavecontent variable="local.html">
        	<cfoutput>

        		<table id="listPhoneAll" class="table-long gridview">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Active</th>
                            <th>Carrier</th>
                            <th>Bill Code</th>
                            <th>GERS SKU</th>
                        </tr>
                    </thead>
                    <tbody>
						<cfloop query="local.services">
                            <tr class="odd">
								<cfif local.services.Title EQ "">
									<cfif local.services.Name NEQ "">
										<cfset local.displayTitle = local.services.Name />
									<cfelse>
										<cfset local.displayTitle = "No Title or Name Set" />
									</cfif>
								<cfelse>
									<cfset local.displayTitle = local.services.Title />
								</cfif>

                                <td><a href="?c=73daf562-5070-444f-9c83-9063567776fe&productguid=#local.services.ServiceGuid#">#local.displayTitle#</a></td>
                                <td>#local.services.Active#</td>
                                <td>#local.services.Carrier#</td>
                                <td>#local.services.CarrierBillCode#</td>
                                <td>#local.services.gersSku#</td>
                            </tr>
  						</cfloop>
                    </tbody>
                </table>
                <p></p><p></p>
            </cfoutput>
        </cfsavecontent>

        <cfreturn local.html />

    </cffunction>

	<!--- Get services for when a selected rateplan is not present --->
    <cffunction name="getServices" output="false" access="public" returntype="string">
    	<cfargument name="carrierId" type="string" required="yes">
        <cfargument name="deviceId" type="string" required="false" default="">
   		<cfargument name="type" type="string" required="yes"> <!--- O = Optional, I = Included --->
        <cfargument name="showSingleAddButton" type="boolean" required="false" default="false">
		<cfargument name="cartTypeFilters" type="array" default="#ArrayNew(1)#" required="false" />
		<cfargument name="IsOnSharePlan" type="boolean" default="false" required="false" />

        <cfset var local = {} />
        <cfset local.carrierId = arguments.carrierId />
        <cfset local.deviceId = arguments.deviceId />
        <cfset local.rateplanId = "" />
        <cfset local.type = arguments.type />
        <cfset local.readOnly = false />
        <cfset local.alreadySelected = "" />

		<cfset local.showAddButtton = false />
		<cfset local.showSingleAddButton = arguments.showSingleAddButton />
		<cfset groupLabels = application.model.ServiceManager.getServiceMasterGroups(carrierId=local.carrierId, type=local.type, cartTypeFilters=arguments.cartTypeFilters, HasSharedPlan = session.cart.getHasSharedPlan()) />

        <cfsavecontent variable="local.html">
        	<cfoutput>

        	<cfset local.thisLineSelectedFeatures = "">
            <cfif isDefined("session.cart") and isStruct(session.cart) and session.cart.getCurrentLine()>
                <cfset local.cartLines = session.cart.getLines()>
                <cfif arrayLen(local.cartLines)>
                    <cfset local.thisLineFeatures = local.cartLines[session.cart.getCurrentLine()].getFeatures()>
                    <cfloop from="1" to="#arrayLen(local.thisLineFeatures)#" index="local.iFeature">
                        <cfset local.thisLineSelectedFeatures = listAppend(local.thisLineSelectedFeatures,local.thisLineFeatures[local.iFeature].getProductID())>
                    </cfloop>
                </cfif>
            </cfif>

            <cfset local.alreadySelected = local.thisLineSelectedFeatures >

            <script language="javascript">
            <!--
                var selectedFeatures = "#local.thisLineSelectedFeatures#";
            //-->
            </script>

            <table cellpadding="0" cellspacing="0">

                <cfloop query="groupLabels">
                    <!--- get service labels --->
                    <cfset serviceLabels = application.model.ServiceManager.getServiceMasterLabelsByGroup(groupGUID=groupLabels.ServiceMasterGroupGuid,deviceId=local.deviceId, cartTypeId = arguments.cartTypeId)>

                    <!--- define input type for the group --->
                    <cfset local.GroupInputType = "checkbox"> <!--- default to checkbox --->
                    <cfset local.HasNoneOption = false>
                    <cfset local.DefaultIndex = 0> <!--- 0 index in coldfusion means null, so default there is no default --->
                    <cfif groupLabels.MaxSelected eq 1>
                    	<cfset local.GroupInputType = "radio">
                    	<!--- define none option --->
                        <cfif groupLabels.MinSelected eq 0>
                        	<cfset local.HasNoneOption = true>
                        </cfif>
                    </cfif>
                    <!--- define default option --->
					<cfif groupLabels.MinSelected eq 1 and groupLabels.MaxSelected eq 1>
                        <cfset local.DefaultIndex = 1> <!--- set the default to the first element in te list --->
                    </cfif>



                    <!--- if there are some services in this group, show the group title and the services --->
                    <cfif serviceLabels.recordCount gt 0>
                        <thead>
                            <tr>
                                <th style="text-align: left;">#groupLabels.Label#</th>
                                <cfif local.type neq "I"> <!--- hide the monly fee column if the service is included --->
                                	<th nowrap="true">Monthly Fee</th>
                                </cfif>
                                <cfif not local.readOnly>
                                	<th></th>
                                </cfif>
                            </tr>
                        </thead>

                        <tbody>
                        <cfset local.i = 1>
                        <cfloop query="serviceLabels">
                            <tr>
                                <td class="featureLabel">
									<a href="##" class="serviceDescription" onclick="viewServiceDescription(#serviceLabels.productId#);return false;">#serviceLabels.label#</a>

									<cfif len(serviceLabels.recommendationId[serviceLabels.currentRow]) and NOT serviceLabels.HideMessage[serviceLabels.currentRow]>
										<div style="float: right">
											<span class="recommended">BEST VALUE</span>
										</div>
									</cfif>

									<cfif request.config.debugInventoryData>
										<div id="inventoryDebugIcon_#serviceLabels.productId#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#serviceLabels.productId#,this);document.body.style.cursor='pointer';"></div>
										<div id="inventoryDebugInfo_#serviceLabels.productId#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
											<div style="float:left;">GERS SKU:</div><div style="float:right;">#serviceLabels.GersSku#</div><br/>
											<div style="float:left;">Carrier Bill Code:</div><div style="float:right;">#serviceLabels.CarrierBillCode#</div><br/>
										</div>
									</cfif>
								</td>
								<cfif local.type neq "I"> <!--- hide the monly fee column if the service is included --->
                                	<td class="featurePrice">#DollarFormat(serviceLabels.MonthlyFee)#</td>
                                </cfif>
                                <cfif not local.readOnly>
                                	<td class="featureSelect">

                                    	<!--- TODO: add correct input and tie it to ajax calls like the current shopping --->
										<input type="#local.GroupInputType#"
                                        	id="chk_features_#serviceLabels.productId[serviceLabels.currentRow]#"
                                            name="chk_features_#groupLabels.ServiceMasterGroupGuid#"
                                            value="#serviceLabels.productId[serviceLabels.currentRow]#"
											<cfif listFind(local.alreadySelected,serviceLabels.productId[serviceLabels.currentRow])>
												checked="checked"
											<cfelseif len(serviceLabels.recommendationId[serviceLabels.currentRow])>
												checked="checked"
											<cfelseif local.i eq local.DefaultIndex>
                                            	checked="checked"
                                            </cfif>
                                        /> <!--- end input --->
                                    </td>
                                </cfif>
                            </tr>
                            <cfset local.i = local.i + 1>
                        </cfloop>
                        <cfif local.HasNoneOption and  not local.readOnly>
                        	<tr>
                            	<td></td>
                                <td class="featurePrice">No thanks</td>
                                <td>
                                	<input
                                    type="#local.GroupInputType#"
                                    name="chk_features_#groupLabels.ServiceMasterGroupGuid#"
                                	<cfif not listFind(local.alreadySelected,serviceLabels.productId[serviceLabels.currentRow])>
                                		checked
                                    </cfif>
                                    / >
                                </td>
                            </tr>
                        </cfif>

                        </tbody>
                    </cfif>
					<cfif not local.readOnly and serviceLabels.recordCount gt 0>
                    	<cfset showAddButtom = true>

                        <cfif not local.showSingleAddButton>
							<cfif local.rateplanId neq "">
                                <tr>
                                    <td colspan="3" style="text-align:right;font-size:1.2em;">
                                        <span class="actionButton"><a href="##" onclick="updateSelectedFeatures(); addToCart('plan','#application.model.Product.getProductIdByProductGuid(local.rateplanId)#:'+selectedFeatures,1);return false;">Add Selected Services</a></span>
                                    </td>
                                </tr>
                            <cfelse> <!--- no rateplan --->
                                 <tr>
                                    <td colspan="3" style="text-align:right;font-size:1.2em;">
                                        <span class="actionButton"><a href="##" onclick="updateSelectedFeatures();return false;">Add Selected Services</a></span>
                                    </td>
                                </tr>

                            </cfif>
                        </cfif>

					</cfif>
					<cfif serviceLabels.recordCount gt 0>
						<tr><td colspan="3">&nbsp;</td></tr>
					</cfif>
                </cfloop>

                <!--- if single add button show at the bottom --->
                <cfif local.showSingleAddButton>
					<cfif local.rateplanId neq "">
                        <tr>
                            <td colspan="3" style="text-align:right;font-size:1.2em;">
                                <span class="actionButton"><a href="##" onclick="updateSelectedFeatures(); addToCart('plan','#application.model.Product.getProductIdByProductGuid(local.rateplanId)#:'+selectedFeatures,1);return false;">Add Selected Services</a></span>
                            </td>
                        </tr>
                    <cfelse> <!--- no rateplan --->
                         <tr>
                            <td colspan="3" style="text-align:right;font-size:1.2em;">
                                <input type="hidden" name="activationType" value="">
                                <span class="actionButton"><a href="##" onclick="updateSelectedFeatures(); addToCart('service', 'service :' + selectedFeatures, 1); return false;">Add Selected Services</a></span>
                            </td>
                        </tr>

                    </cfif>
                </cfif>
            </table>

            </cfoutput>
        </cfsavecontent>

		<cfreturn local.html>

    </cffunction>

	<cffunction name="getServicesByRatePlan" access="public" returntype="string" output="false">
		<cfargument name="carrierId" type="string" required="true" />
		<cfargument name="ratePlanId" type="string" required="true" />
		<cfargument name="type" type="string" required="true" />
		<cfargument name="readOnly" type="boolean" required="false" default="true" />
		<cfargument name="deviceId" type="string" required="false" default="" />
		<cfargument name="alreadySelected" type="string" required="false" default="" />
		<cfargument name="showActiveOnly" type="boolean" required="false" default="false" />
		<cfargument name="cartTypeId" type="numeric" required="false" default="0" />

		<cfset var local = structNew() />

		<cfset local.carrierId = trim(arguments.carrierId) />
		<cfset local.ratePlanId = trim(arguments.ratePlanId) />
		<cfset local.type = trim(arguments.type) />
		<cfset local.readOnly = arguments.readOnly />
		<cfset local.deviceId = trim(arguments.deviceId) />
		<cfset local.alreadySelected = arguments.alreadySelected />
		<cfset local.cartTypeId = arguments.cartTypeId />
		<cfset local.ExcludeSharedGroup = false />
		<cfset local.sharedFeatureGuids = [] />
		
		<cfset cartLines = session.cart.getLines()>
		<cfif isdefined("request.p.cartCurrentLine")>
			<cfset cartLine = request.p.cartCurrentLine />
		<cfelse>
			<cfset cartLine = session.cart.getCurrentLine() />
		</cfif>
		<cfset local.deviceActivationType =  cartlines[cartLine].getCartLineActivationType()>
		
		<cfif local.type is 'I'>
			<cfset local.readOnly = true />
		</cfif>

		<!--- Account for AT&T Shared Data service parent-child relationship --->
		<cfif session.cart.getCarrierId() eq 109 && session.cart.getFamilyPlan().getIsShared()>

			<cfif ArrayLen(session.cart.getSharedFeatures())>
				<cfloop array="#session.cart.getSharedFeatures()#" index="cartItem" >

					<cfset qFeature = application.model.Feature.getByProductID( cartItem.getProductId() ) />

					<cfset ArrayAppend( local.sharedFeatureGuids, qFeature.ProductGuid ) />

				</cfloop>
			</cfif>
		</cfif>

		<cfset groupLabels = application.model.serviceManager.getServiceMasterGroups(carrierId = local.carrierId, type = local.type, deviceguid = arguments.deviceid, HasSharedPlan = session.cart.getHasSharedPlan() ) />

		<cfsavecontent variable="local.html">
			<cfoutput>
				<cfif not local.readOnly>
					<div style="width:100%; border: 0px solid black; text-align:right; padding-right:0px; padding-top: 5px; padding-bottom: 10px;">
						<span class="actionButton"><a href="##" onclick="updateSelectedFeatures(); addToCart('plan', '#application.model.product.getProductIdByProductGuid(local.rateplanId)#:' + selectedFeatures, 1); return false">Add Selected Services</a></span>
					</div>
				</cfif>

				<cfset sharedFeatures = session.cart.getSharedFeatures() />
				<cfif ArrayLen(sharedFeatures)>
					<cfset sharedDataGroupService = sharedFeatures[1] />
					<cfset sdgGuid = application.model.Product.getProductGuidByProductId( sharedDataGroupService.getProductId() ) />
					<cfset qService = application.model.ServiceManager.getDataFeaturesByDataGroup(sdgGuid, arguments.DeviceId) />
				</cfif>
				<!--- Data Group Feature for AT&T Shared Plans --->
				<cfif arguments.type eq 'O' && arguments.RatePlanId eq 'D9A8D356-00A1-4441-B121-21368E1C64CA' && Len(arguments.DeviceId) && ArrayLen(sharedFeatures) && qService.RecordCount>
					<table cellpadding="0" cellspacing="0">
						<thead>
							<tr>
								<th style="text-align: left">Shared Data Fee</th>
								<th nowrap="true">Monthly Fee</th>
								<th>&nbsp;</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="featureLabel">
									<a href="##" class="serviceDescription" onclick="viewServiceDescription(#qService.ProductId#);return false;">#qService.Title#</a>
									<cfif request.config.debugInventoryData>
										<div id="inventoryDebugIcon_#qService.productId#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#qService.productId#,this);document.body.style.cursor='pointer';"></div>
										<div id="inventoryDebugInfo_#qService.productId#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
											<div style="float:left;">GERS SKU:</div><div style="float:right;">#qService.GersSku#ss</div><br/>
											<div style="float:left;">Carrier Bill Code:</div><div style="float:right;">#qService.CarrierBillCode#</div><br/>
											<div style="float:left;">Financed Price:</div><div style="float:right;">#qService.FinancedPrice#</div><br/>
										</div>
									</cfif>
								</td>
								<td class="featurePrice">
									<cfif (local.deviceActivationType contains 'finance') and (len(qService.FinancedPrice))><!---Is a financed phone with a Financed Price--->
										#dollarFormat(qService.FinancedPrice)#
									<cfelse>
										#DollarFormat(qService.MonthlyFee)#
									</cfif>
								</td>
								<td>
									<input type="radio"
										name="chk_features_#qService.ProductId#"
										value="#qService.ProductId#"
										checked="checked" />
								</td>
							</tr>
						</tbody>
					</table>
				</cfif>

				<table cellpadding="0" cellspacing="0">
					<cfloop query="groupLabels">
						<cfset serviceLabels = application.model.serviceManager.getServiceMasterLabelsByGroup(groupGUID = groupLabels.serviceMasterGroupGuid[groupLabels.currentRow], rateplanId = local.ratePlanId, deviceId = local.deviceId, showActiveOnly = arguments.showActiveOnly, cartTypeId = local.cartTypeId) />

						<cfset local.groupInputType = 'checkbox' />
						<cfset local.hasNoneOption = false />
						<cfset local.defaultIndex = 0 />

						<cfif groupLabels.maxSelected eq 1>
							<cfset local.groupInputType = 'radio' />

							<cfif groupLabels.minSelected eq 0>
								<cfset local.hasNoneOption = true />
							</cfif>
						</cfif>

						<cfif groupLabels.minSelected eq 1 and groupLabels.maxSelected eq 1>
							<cfset local.defaultIndex = 1 />
						</cfif>

						<cfif serviceLabels.recordCount gt 0>
							<thead>
								<tr>
									<th style="text-align: left">#trim(groupLabels.label)#</th>
									<cfif local.type is not 'I'>
										<th nowrap="true">Monthly Fee</th>
									</cfif>
									<cfif not local.readOnly>
										<th>&nbsp;</th>
									</cfif>
								</tr>
							</thead>
							<tbody>
								<cfset local.i = 1 />

								<cfloop query="serviceLabels">
									<tr>
										<td class="featureLabel">
											<a href="##" class="serviceDescription" onclick="viewServiceDescription(#serviceLabels.productId#);return false;">#trim(serviceLabels.label)#</a>

											<cfif len(serviceLabels.recommendationId[serviceLabels.currentRow]) and NOT serviceLabels.HideMessage[serviceLabels.currentRow]>
												<div style="float: right">
													<span class="recommended">BEST VALUE</span>
												</div>
											</cfif>

											<cfif request.config.debugInventoryData>
												<div id="inventoryDebugIcon_#serviceLabels.productId#" class="inventoryDebugIcon" onmouseover="revealInventoryDebugInfo(#serviceLabels.productId#,this);document.body.style.cursor='pointer';"></div>
												<div id="inventoryDebugInfo_#serviceLabels.productId#" class="inventoryDebugInfo" onmouseout="hideInventoryDebugInfo(this);document.body.style.cursor='';">
													<div style="float:left;">GERS SKU:</div><div style="float:right;">#serviceLabels.GersSku#</div><br/>
													<div style="float:left;">Carrier Bill Code:</div><div style="float:right;">#serviceLabels.CarrierBillCode#</div><br/>
													<div style="float:left;">Financed Price:</div><div style="float:right;">#serviceLabels.FinancedPrice#</div><br/>
												</div>
											</cfif>
										</td>
										<cfif local.type is not 'I'>
											<td class="featurePrice">
												<cfif (local.deviceActivationType contains 'finance') and (len(serviceLabels.FinancedPrice))><!---Is a financed phone with a Financed Price--->
													#dollarFormat(serviceLabels.FinancedPrice)#
												<cfelse>
													#dollarFormat(serviceLabels.monthlyFee)#
												</cfif>
											</td>	
										</cfif>
										<cfif not local.readOnly>
											<td class="featureSelect">
												<input type="#local.groupInputType#"
													id="chk_features_#serviceLabels.productId[serviceLabels.currentRow]#"
													name="chk_features_#groupLabels.serviceMasterGroupGuid#"
													value="#serviceLabels.productId[serviceLabels.currentRow]#"
													<cfif listFind(local.alreadySelected, serviceLabels.productId[serviceLabels.currentRow]) or local.i eq local.defaultIndex or len(serviceLabels.recommendationId[serviceLabels.currentRow])>
														checked
													</cfif> />
											</td>
										</cfif>
									</tr>
									<cfset local.i = (local.i + 1) />
								</cfloop>

								<cfif local.hasNoneOption and not local.readOnly>
									<tr>
										<td>&nbsp;</td>
										<td class="featurePrice">No thanks</td>
										<td>
											<input type="#local.groupInputType#"
												name="chk_features_#groupLabels.serviceMasterGroupGuid#"
												<cfif not listFind(local.alreadySelected, serviceLabels.productId[serviceLabels.currentRow])>
													checked
												</cfif> />
										</td>
									</tr>
								</cfif>
							</tbody>
						</cfif>

						<cfif serviceLabels.recordCount gt 0>
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
						</cfif>
					</cfloop>
				</table>
				<cfif not local.readOnly>
					<div style="width:100%; border: 0px solid black; text-align:right; padding-right:0px; padding-top: 0px; padding-bottom: 10px;">
						<span class="actionButton"><a href="##" onclick="updateSelectedFeatures(); addToCart('plan', '#application.model.product.getProductIdByProductGuid(local.rateplanId)#:' + selectedFeatures, 1); return false">Add Selected Services</a></span>
					</div>
				</cfif>
			</cfoutput>
		</cfsavecontent>

		<cfreturn trim(local.html) />
	</cffunction>

</cfcomponent>
