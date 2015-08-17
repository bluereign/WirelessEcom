<cfcomponent output="false" displayname="AdminPlan">

	<cffunction name="init" returntype="AdminPlan">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getClonePlanForm" returntype="string">
		<cfargument name="planGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				planGuid = arguments.planGuid,
				ratePlanDetails = application.model.AdminPlan.getPlan(local.planGuid)
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
		     	<input type="hidden" name="planGuid" value="<cfoutput>#local.planGuid#</cfoutput>" />
		     	<input type="hidden" name="carrierGuid" value="<cfoutput>#local.ratePlanDetails.CarrierGuid#</cfoutput>" />
				<input type="hidden" name="deviceUPC" value="0">
				<input type="hidden" name="productId" value="<cfoutput>#local.ratePlanDetails.productID#</cfoutput>">


		     	<input type="hidden" name="action" value="clonePlan" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Make sure to select a Channel and enter a GersSKU to channelize this plan"><span>Channelize Plan</span></a> <a href="javascript: show('action=cancelPlanClone');" class="button" title="Cancel changes made to this plan and do not save"><span>Cancel</span></a>
		    </form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getMasterClonePlanForm" returntype="string">
		<cfargument name="planGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				planGuid = arguments.planGuid,
				ratePlanDetails = application.model.AdminPlan.getPlan(local.planGuid)
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
				            <label><input type="text" name="name" class="txtbox-long" maxlength="255" value="<cfoutput>#local.ratePlanDetails.name#</cfoutput>"></label>
				            <span class="clearFix">&nbsp;</span>
				       	</li>
						<li class="odd">
							<label class="field-title" title="Active Channel">Available Online:</label>
							<label> <input type="checkbox" name="active" value="1" id="active"/> </label>
							<span class="clearFix">&nbsp;</span>
						</li>
		            </ol><!-- end of form elements -->
		        </fieldset>
				<input type="hidden" name="accessoryGersSku" value="MASTERCAT" />
		     	<input type="hidden" name="planGuid" value="<cfoutput>#local.planGuid#</cfoutput>" />
		     	<input type="hidden" name="carrierGuid" value="<cfoutput>#local.ratePlanDetails.CarrierGuid#</cfoutput>" />
				<input type="hidden" name="oldSKU" value="0">
				<input type="hidden" name="newUPC" value="0">
				<input type="hidden" name="productId" value="<cfoutput>#local.ratePlanDetails.productID#</cfoutput>">
		     	<input type="hidden" name="action" value="clonePlan" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Copy Plan as New"><span>Copy Plan as New</span></a> <a href="javascript: show('action=cancelPlanClone');" class="button" title="Cancel changes made to this plan and do not save"><span>Cancel</span></a>
		    </form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getEditPlanDeviceForm" returntype="string">
		<cfargument name="deviceGuid" type="string" default="" />
		<cfargument name="planGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				planGuid = arguments.planGuid,
				deviceGuid = arguments.deviceGuid,
				<!--- device = application.model.AdminPhone.getPhone(local.deviceGuid),
				carrierGuid = local.device.carrierGuid, --->
				filter = {
					active = true,
					device = local.deviceGuid,
					notPlan = local.planGuid
					<!--- ,
					carrierGuid = local.carrierGuid	 --->
				},
				buttonText = "Add Phone to Plan"
			} />

		<cfif local.deviceGuid NEQ "">
			<cfset local.devicePlan = application.model.AdminDevicePlan.getDevicePlan(local.planGuid, local.deviceGuid) />
			<cfset local.buttonText = "Update Plan for Phone" />
		</cfif>

		<!--- <cfset local.plansQry = application.model.AdminDevicePlan.getPlansList(local.filter) /> --->
		<cfset local.phonesQry = application.model.AdminDevicePlan.getPhonesList(local.filter) />

		<cfsavecontent variable="local.html">
			<form class="middle-forms" method="POST">
		    	<h3><cfoutput>#local.buttonText#</cfoutput></h3>
					<fieldset>
						<legend>Add New Phone</legend>
				        	<div>
					        	<ol>
					            	<li>
					                    <label class="field-title">Phones:</label>
					                    <label>
						                    <cfif local.deviceGuid NEQ "">
							                	<!--- <cfset local.plan = application.model..getPlan(local.planGuid) />
							                	<cfoutput>#local.service.Name#</cfoutput> --->
							                <cfelse>
							                    <select name="deviceGuid">
								                    <option value="">Select a Phone</option>
													<cfloop query="local.phonesQry">
														<cfoutput>
															<option value="#local.phonesQry.DeviceGuid#" <cfif local.deviceGuid EQ local.phonesQry.DeviceGuid> selected="selected"</cfif>>
																#local.phonesQry.name# <!--- (#local.phonesQry.CarrierBillCode#) --->
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

		                <input type="hidden" value="<cfoutput>#local.planGuid#</cfoutput>" name="planGuid" />
						<!--- TODO: implement user integration to get the creator --->
						<cfif local.deviceGuid EQ "">
							<input type="hidden" value="insertPlanDevice" name="action" />
						<cfelse>
			                <input type="hidden" value="<cfoutput>#local.planGuid#</cfoutput>" name="planGuid" />
							<input type="hidden" value="updatePlanDevice" name="action" />
						</cfif>
						<a href="javascript: void();" onclick="postForm(this);" class="button"><span><cfoutput>#local.buttonText#</cfoutput></span></a>
						<a href="javascript: show('action=cancelDevicePlanEdit');" class="button"><span>Cancel</span></a>
					</form>
				</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getEditPlanForm" returntype="string">
		<cfargument name="productId" type="string" default="" />

		<cfset var local = {
				html = '',
				productId = arguments.productId,
				active = false,
				name = '',
				carrier = '',
				billCode = '',
				contractTerm = '',
				includedLines = '',
				maxLines = '',
				monthlyFee = '',
				lineFee = '',
				carrierGuid = '',
				title = '',
				shortDescription = '',
				longDescription = '',
				DataLimitGb = '',
        		metaKeywords ='',
				filter = { isCarrier = true },
				carriersQry = application.model.AdminCompany.getCompanies(local.filter),
				gersSku = 'MASTERCAT',
				type = '',
				IsShared = 0,
				channelId = "1",
				primaryActivationFee = "",
				BasicFee = "",
				SmartphoneFee = "",
				MifiFee = "",
				masterData = {}
			} />

		<cfset var activeChannels = "" />
		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfif local.productId NEQ "">
			<cfset activeChannels = application.model.AdminProduct.getProductChannels(local.productId) />
			<!--- set display --->
			<cfset local.planDetails = application.model.AdminPlan.getPlan(local.productId) />
			<cfset local.name = local.planDetails.Name />
			<cfset local.carrierGuid = local.planDetails.CarrierGuid />
			<cfset local.carrier = local.planDetails.Carrier />
			<cfset local.billCode = local.planDetails.CarrierBillCode />
			<cfset local.contractTerm = local.planDetails.ContractTerm />
			<cfset local.includedLines = local.planDetails.IncludedLines />
			<cfset local.maxLines = local.planDetails.MaxLines />
			<cfset local.monthlyFee = local.planDetails.MonthlyFee />
			<cfset local.lineFee = local.planDetails.AdditionalLineFee />
			<cfset local.title = local.planDetails.Title />
		    <cfset local.shortDescription = local.planDetails.ShortDescription />
		    <cfset local.longDescription = local.planDetails.LongDescription />
			<cfset local.DataLimitGb = local.planDetails.DataLimitGb />
      		<cfset local.metaKeywords = local.planDetails.metaKeywords />
		    <cfset local.active = local.planDetails.Active />
		    <cfset local.gersSku = local.planDetails.GersSku />
		    <cfset local.type = local.planDetails.Type />
			<cfset local.channelId = local.planDetails.channelId>
			<cfset local.IsShared = local.planDetails.IsShared />
			<cfset local.primaryActivationFee = local.planDetails.primaryActivationFee />
			<cfset local.basicFee = local.planDetails.BasicFee >
			<cfset local.smartphoneFee = local.planDetails.SmartphoneFee >
			<cfset local.mifiFee = local.planDetails.MifiFee >

			<cfif local.channelId neq 1>
				<cfset local.masterData = application.model.AdminPlan.getMasterPlan(local.planDetails.productId) >
			</cfif>
		</cfif>

		<cfsavecontent variable="local.html">
		    <form  method="post" name="updatePhone" class="middle-forms">
		        <fieldset>
		            <legend>Fieldset Title</legend>
		            <ol>
			            <li class="odd">
			            	<label class="field-title" title="Indicates Required Field"><span class="required">* Required Field</span></label>
						</li>
						<cfif local.productId NEQ "">
			                <li class="even">
			                    <label class="field-title" title="The productId for this plan">Product Id: </label>
								<label><cfoutput>#local.planDetails.productId#</cfoutput></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
		                </cfif>
					    <li class="odd">
		                    <label class="field-title" title="Availability sets whether this plan is available to customers">Availability: </label>
		                    <label>
		                        <input type="checkbox" name="active" <cfif local.active eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
		                        Available Online
		                    </label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="Required: Select the carrier that offers this plan">Carrier: <span class="required">*</span></label>
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
						<li class="even">
		                    <label class="field-title" title="The name of the plan">Name:</label>
		                    <cfif local.name eq "" || find(local.channelId,"0,1")>
		                    	<label><input name="name" class="txtbox-long" /></label>
		                    <cfelse>
                    			<label><cfoutput>#local.name#</cfoutput></label>
							</cfif>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="Required: The title of the rate plan displayed on the site">Title to Display on Site: <span class="required">*</span></label>
		                    <label><input name="title" class="txtbox-long" value="<cfoutput>#local.title#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="even">
		                    <label class="field-title" title="Required: The bill code of the carrier">Carrier Bill Code:<span class="required">*</span></label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
									<input name="billCode" class="txtbox-long" maxlength="12" value="<cfoutput>#local.billCode#</cfoutput>" />
								<cfelse>
									<cfoutput>
										#local.billCode#
										<input type="hidden" name="billCode" value="#local.billCode#">
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
										<cfif (isQuery(activeChannels) && activeChannels.recordCount EQ 0) || !len(trim(local.productId))>
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
		                    <label class="field-title" title="The GERS SKU for this plan">GERS SKU:</label>
		                    <label><input name="gersSku" class="txtbox-short" maxlength="9" value="<cfoutput>#local.gersSku#</cfoutput>" /></label>
							<label><!---<a rel="gersLookupLink" href="gersLookup.cfm">Look up GERS SKU</a>---></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Select the type for this plan">Type:</label>
		                    <label>
			                    <cfif find(local.channelId,"0,1")>
									<select name="type">
					                    <option value="">Select a Type</option>
										<cfoutput>
											<option value="DAT" <cfif local.type EQ "DAT"> selected="selected"</cfif>>Data</option>
											<option value="IND" <cfif local.type EQ "IND"> selected="selected"</cfif>>Individual</option>
											<option value="FAM" <cfif local.type EQ "FAM"> selected="selected"</cfif>>Family</option>
										</cfoutput>
									</select>
								<cfelse>
									<cfswitch expression="#local.type#">
										<cfcase value="DAT">Data</cfcase>
										<cfcase value="IND">Individual</cfcase>
										<cfcase value="FAM">Family</cfcase>
									</cfswitch>
									<cfoutput><input type="hidden" name="type" value="#local.type#"></cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="Select the Share type for this plan">Is Shared:</label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
				                    <select name="IsShared">
										<cfoutput>
											<option value="0" <cfif !local.IsShared> selected="selected"</cfif>>No</option>
											<option value="1" <cfif local.IsShared> selected="selected"</cfif>>Yes</option>
										</cfoutput>
									</select>
								<cfelse>
									<cfif local.IsShared>Yes<cfelse>No</cfif>
									<cfoutput><input type="hidden" name="isShared" value="#local.isshared#"></cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="even">
		                    <label class="field-title" title="The length of contract for this plan">Contract Term:</label>
		                    <label>
		                    	<cfif find(local.channelId,"0,1")>
									<input name="contractTerm" class="txtbox-long" maxlength="12" value="<cfoutput>#local.contractTerm#</cfoutput>"/>
								<cfelse>
									<cfoutput>#local.contractTerm#<input type="hidden" name="contractTerm" value="#local.contractTerm#"/></cfoutput>
								</cfif>
							</label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="The number of lines included in this plan">Included Lines:</label>
		                    <label><input name="includedLines" class="txtbox-long" value="<cfoutput>#local.includedLines#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="The maximum number of lines allowed on this plan">Max Lines:</label>
		                    <label><input name="maxLines" class="txtbox-long" value="<cfoutput>#local.maxLines#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="The plan's monthly fee">Activation Fee:</label>
		                    <label><input name="primaryActivationFee" class="txtbox-long" value="<cfoutput>#local.primaryActivationFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="The plan's monthly fee">Monthly Fee:</label>
		                    <label><input name="monthlyFee" class="txtbox-long" value="<cfoutput>#local.monthlyFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="Additional line fee for this plan">Additional Line Fee:</label>
		                    <label><input name="lineFee" class="txtbox-long" value="<cfoutput>#local.lineFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Basic fee for this plan">Basic Fee:</label>
		                    <label><input name="basicFee" class="txtbox-long" value="<cfoutput>#local.basicFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="Smartphone fee for this plan">Smartphone Fee:</label>
		                    <label><input name="smartphoneFee" class="txtbox-long" value="<cfoutput>#local.smartphoneFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Mifi fee for this plan">Mifi Fee:</label>
		                    <label><input name="mifiFee" class="txtbox-long" value="<cfoutput>#local.mifiFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>

		                <li class="odd">
		                    <label class="field-title" title="Included Data limit in GB">Data Limit (GB):</label>
		                    <label><input name="DataLimitGb" class="txtbox-long" value="<cfoutput>#local.DataLimitGB#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						
 						<!---<li class="even">
			                    <label class="field-title" title="The Master short description of the plan">Master Short Description: </label>
							<label>
								<cfif structKeyExists(local.masterData,"shortDescription")>
									<span class="rawOutput"><cfoutput>#local.masterData.shortDescription#</cfoutput></span>
								</cfif>
							</label>
							<span class="clearFix">&nbsp;</span>
						</li>--->
						
						
					
						<!--- Don't show this for Master Records --->
						<cfif local.channelId neq 1>
   			                <li class="even">
   			                    <label for="masterShortDescription" class="field-title" title="The Master short description of the plan">Master Short Description: </label>
									<cfif structKeyExists(local.masterData,"shortDescription")>
										<div id="masterShortDescription" class="rawMasterOutput"><div><cfoutput>#local.masterData.shortDescription#</cfoutput></div></div>
									<cfelse>
										<div id="masterShortDescription" class="undefined"><div>Master Short Description Undefined</div></div>
									</cfif>
								<span class="clearFix">&nbsp;</span>
							</li>
						</cfif>

		                <li class="odd">
		                    <label class="field-title" title="Short description of this plan">Short Description: </label>
		                    <label>
		                        <textarea id="shortDescriptionEditor" name="shortDescription" rows="7" cols="40"><cfoutput>#local.shortDescription#</cfoutput></textarea>
		                    </label>
   			                 	<script>
   			                 	var editor = CKEDITOR.replace( 'shortDescriptionEditor' );
   			                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );

   			                 	</script>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						
					<!---	<li class="odd">
							<label class="field-title" title="The Master short description of the plan">Master Long Description: </label>
							<label>
								<cfif structKeyExists(local.masterData,"longDescription")>
									<span class="rawOutput"><cfoutput>#local.masterData.longDescription#</cfoutput></span>
								</cfif>
							</label>
							<span class="clearFix">&nbsp;</span>
						</li>--->

						
						<!--- Don't show this for Master Records --->
						<cfif local.channelId neq 1>
							<li class="odd">
								<label for="masterLongtDescription" class="field-title" title="The Master long description of the plan">Master Long Description: </label>
									<cfif structKeyExists(local.masterData,"longDescription")>
										<div id="masterLongDescription" class="rawMasterOutput"><div><cfoutput>#local.masterData.longDescription#</cfoutput></div></div>
									<cfelse>
										<div id="masterLongDescription" class="undefined"><div>Master Long Description Undefined</div></div>
									</cfif>
								<span class="clearFix">&nbsp;</span>
							</li>
						</cfif>
						
		                <li class="even">
		                    <label class="field-title" title="Long description of this plan">Long Description: </label>
		                    <label>
		                    	<textarea id="longDescriptionEditor" name="longDescription" rows="7" cols="40" ><cfoutput>#local.longDescription#</cfoutput></textarea>
		                    </label>
		                 	<script>
		                 	var editor = CKEDITOR.replace( 'longDescriptionEditor' );
		                 	CKFinder.setupCKEditor( editor, '/admin/ckfinder/' );

		                 	</script>
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
		     	<input type="hidden" name="planGuid" value="<cfoutput>#local.productId#</cfoutput>" />
		     	<input type="hidden" name="action" value="updatePlanDetails" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save changes made to this plan"><span>Save</span></a> <a href="javascript: show('action=cancelPlanEdit');" class="button" title="Cancel changes made to this plan and do not save"><span>Cancel</span></a>
		    </form>
			<script type="text/javascript">
				// colorbox: lightbox windows for the gers sku lookup
				$("a[rel^='gersLookupLink']").colorbox({fixedWidth:"600px", fixedHeight:"200px", iframe:true, href:"gersLookup.cfm"});
	    	</script>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getPlanList" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />

		<cfset var local = structNew() />
		<cfset local.filter = arguments.filter />
		<cfset local.dislayTitle = '' />

		<cfset local.carriers = application.model.Company.getAllCarriers() />
		<cfset local.plans = application.model.AdminPlan.getPlans(local.filter) />

		
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
				<table id="listPlansAll" class="table-long gridview-momt-plans">
					<thead>
						<tr>
							<th class="hidden-col">MG</th>	<!--- hide column - we want it there for sorting but not displayed --->						
							<th>Channel</th>
							<th>Title to Display on Site</th>
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
						<cfloop query="local.plans">
							<cfif guidbreak is not trim(local.plans.matchingGUID)>
								<cfset oddeven = oddeven xor 1 />
								<cfset guidbreak = local.plans.matchingGUID />
								<cfset guidCount = guidCount+1 />
							</cfif>
							<tr class="<cfif oddeven is 1>momt-odd-group<cfelse>momt-even-group</cfif>">
								<cfif not len(trim(local.plans.title[local.plans.currentRow]))>
									<cfif len(trim(local.plans.name[local.plans.currentRow]))>
										<cfset local.displayTitle = trim(local.plans.name[local.plans.currentRow]) />
									<cfelse>
										<cfset local.displayTitle = 'No Title or Name Set' />
									</cfif>
								<cfelse>
									<cfset local.displayTitle = trim(local.plans.title[local.plans.currentRow]) />
								</cfif>
								
								<td class="hidden-col">#guidCount#</td>
								<td>#trim(local.plans.channel)#</td>
								<td><a href="?c=37C8CA4D-DDBE-4E19-BEDA-AA49E85A4C68&productguid=#local.plans.RatePlanGuid[local.plans.currentRow]#">#trim(local.displayTitle)#</a></td>
								<td>#yesNoFormat(trim(local.plans.active[local.plans.currentRow]))#</td>
								<td>#trim(local.plans.carrier[local.plans.currentRow])#</td>
								<td>#trim(local.plans.carrierBillCode[local.plans.currentRow])#</td>
								<td>#trim(local.plans.productId[local.plans.currentRow])#</td>
								<td>#trim(local.plans.gersSku[local.plans.currentRow])#</td>
								<td>#dateformat(trim(local.plans.createDate[local.plans.currentRow]),"mm/dd/yyyy")#</td>
								<td class="hidden-col">#local.plans.currentRow#</td>
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
	
	<cffunction name="getMasterPlan" access="public" output="false" returntype="struct" hint="Returns the data for the Master Channel device pased on productID">
		<cfargument name="productId" type="any" required="true" />
		<cfset var masterData = "" />
		<cfset var local = structNew()>
		<cftry>
			<cfquery name="masterData" datasource="#application.dsn.wirelessadvocates#" >
				SELECT IsNull((select value from catalog.Property where Name = 'ShortDescription' and ProductGuid = rp.RatePlanGuid),'') ShortDescription
					, IsNull((select value from catalog.Property where Name = 'LongDescription' and ProductGuid = rp.RatePlanGuid),'') LongDescription
				FROM catalog.ratePlan rp
					INNER JOIN catalog.ProductGuid pg on pg.ProductGuid = rp.RatePlanGuid
					LEFT JOIN catalog.Product p on p.ProductGuid = pg.ProductGuid
				WHERE p.productId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.productId#"> and p.channelId = 1
			</cfquery>

			<cfloop query="masterData">
				<cfset local["ShortDescription"] = masterData.ShortDescription>
				<cfset local["LongDescription"] = masterData.LongDescription>
			</cfloop>

			<cfcatch type="any">
				<cfthrow message="#cfcatch.message# - #cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfreturn local />
	</cffunction>
	
    <cffunction name="getPlanPhoneList" returntype="string">
		<cfargument name="planGuid" type="String" required="true" />

    	<cfset var local = structNew()>
        <cfset local.planGuid = arguments.planGuid />
        <cfset local.phones = application.model.Catalog.getRateplanDevices(local.planGuid) />

        <cfsavecontent variable="local.html">
        	<cfoutput>
			   	<a href="javascript: show('action=showEditPlanDevice');" class="button" showPanel="" hidePanel="">
				   	<span>Add New Phone</span>
				</a>
			   	<a href="javascript: show('action=showAddAllActivePhones');" class="button" showPanel="" hidePanel="">
				   	<span>Add All Active Phones</span>
				</a>
			   	<a href="javascript: show('action=showRemoveAllPhones');" class="button" showPanel="" hidePanel="">
				   	<span>Remove All Phones</span>
				</a>

				<table id="listPhoneSmall" class="table-long gridview-10">
                    <thead>
                        <tr>
                            <th>Title</th>
							<th>Active</th>
                            <th>Carrier</th>
                            <th></th>
                        <!--->
                            <th>UPC</th>
                            <th>GERS SKU</th>
                        --->
						</tr>
                    </thead>

                    <tbody>
                    	<cfloop query="local.phones">
                            <tr class="odd">
                                <td>
									<a href="?c=cab863f7-08da-4011-893e-12c2e12c64cd&productguid=#local.phones.DeviceGuid#">
										#local.phones.DetailTitle#
									</a>
								</td>
								<td>#local.phones.Active#</td>
								<td>#local.phones.CarrierName#</td>
								<td>
									<a href="javascript: if(confirm('Are you sure you want to permanently delete this phone from this plan? This can not be undone.')) { show('action=deletePlanDevice|deviceGuid=<cfoutput>#local.phones.productGuid#</cfoutput>'); }" class="table-delete-link" title="Remove this phone from this plan">
										Delete
									</a>
								</td>
                           <!--->
							 	<td></td>
                                <td><!--- #local.phones.UPC# ---></td>
                                <td><!--- #local.phones.gersSku# ---></td>
                             --->
                            </tr>
  						</cfloop>
                    </tbody>
                </table>
                <p></p><p></p>
            </cfoutput>
        </cfsavecontent>

        <cfreturn local.html>

    </cffunction>	
	


 </cfcomponent>