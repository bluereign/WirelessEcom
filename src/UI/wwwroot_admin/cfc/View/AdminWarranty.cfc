<cfcomponent output="false" displayname="AdminWarranty">

	<cffunction name="init" returntype="AdminWarranty">
    	<cfreturn this>
    </cffunction>

	<cffunction name="getCloneWarrantyForm" returntype="string">
		<cfargument name="warrantyGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				warrantyGuid = arguments.warrantyGuid,
				WarrantyDetails = application.model.AdminWarranty.getWarranty(local.warrantyGuid)
			} />
		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfsavecontent variable="local.html">
		    <form  method="post" name="cloneWarranty" class="middle-forms">
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
		     	<input type="hidden" name="warrantyGuid" value="<cfoutput>#local.warrantyGuid#</cfoutput>" />
		     	<input type="hidden" name="carrierGuid" value="<cfoutput>#local.rateWarrantyDetails.CarrierGuid#</cfoutput>" />
				<input type="hidden" name="deviceUPC" value="0">
				<input type="hidden" name="productId" value="<cfoutput>#local.WarrantyDetails.productID#</cfoutput>">


		     	<input type="hidden" name="action" value="cloneWarranty" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Make sure to select a Channel and enter a GersSKU to channelize this warranty"><span>Channelize Warranty</span></a> <a href="javascript: show('action=cancelWarrantyClone');" class="button" title="Cancel changes made to this warranty and do not save"><span>Cancel</span></a>
		    </form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getMasterCloneWarrantyForm" returntype="string">
		<cfargument name="warrantyGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				warrantyGuid = arguments.warrantyGuid,
				rateWarrantyDetails = application.model.AdminWarranty.getWarranty(local.warrantyGuid)
			} />
		<cfset var channels = application.model.Channel.getAllChannels() />

		<cfsavecontent variable="local.html">
		    <form  method="post" name="cloneWarranty" class="middle-forms">
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
				            <label><input type="text" name="name" class="txtbox-long" maxlength="255" value="<cfoutput>#local.rateWarrantyDetails.name#</cfoutput>"></label>
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
		     	<input type="hidden" name="warrantyGuid" value="<cfoutput>#local.warrantyGuid#</cfoutput>" />
		     	<input type="hidden" name="carrierGuid" value="<cfoutput>#local.rateWarrantyDetails.CarrierGuid#</cfoutput>" />
				<input type="hidden" name="oldSKU" value="0">
				<input type="hidden" name="newUPC" value="0">
				<input type="hidden" name="productId" value="<cfoutput>#local.rateWarrantyDetails.productID#</cfoutput>">
		     	<input type="hidden" name="action" value="cloneWarranty" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Copy Warranty as New"><span>Copy Warranty as New</span></a> <a href="javascript: show('action=cancelWarrantyClone');" class="button" title="Cancel changes made to this warranty and do not save"><span>Cancel</span></a>
		    </form>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getEditWarrantyDeviceForm" returntype="string">
		<cfargument name="deviceGuid" type="string" default="" />
		<cfargument name="warrantyGuid" type="string" default="" />

		<cfset var local = {
				html = '',
				warrantyGuid = arguments.warrantyGuid,
				deviceGuid = arguments.deviceGuid,
				<!--- device = application.model.AdminPhone.getPhone(local.deviceGuid),
				carrierGuid = local.device.carrierGuid, --->
				filter = {
					active = true,
					device = local.deviceGuid,
					notWarranty = local.warrantyGuid
					<!--- ,
					carrierGuid = local.carrierGuid	 --->
				},
				buttonText = "Add Phone to Warranty"
			} />

		<cfif local.deviceGuid NEQ "">
			<cfset local.deviceWarranty = application.model.AdminDeviceWarranty.getDeviceWarranty(local.warrantyGuid, local.deviceGuid) />
			<cfset local.buttonText = "Update Warranty for Phone" />
		</cfif>

		<!--- <cfset local.warrantiesQry = application.model.AdminDeviceWarranty.getwarrantiesList(local.filter) /> --->
		<cfset local.phonesQry = application.model.AdminDeviceWarranty.getPhonesList(local.filter) />

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
							                	<!--- <cfset local.warranty = application.model..getWarranty(local.warrantyGuid) />
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

		                <input type="hidden" value="<cfoutput>#local.warrantyGuid#</cfoutput>" name="warrantyGuid" />
						<!--- TODO: implement user integration to get the creator --->
						<cfif local.deviceGuid EQ "">
							<input type="hidden" value="insertWarrantyDevice" name="action" />
						<cfelse>
			                <input type="hidden" value="<cfoutput>#local.warrantyGuid#</cfoutput>" name="warrantyGuid" />
							<input type="hidden" value="updateWarrantyDevice" name="action" />
						</cfif>
						<a href="javascript: void();" onclick="postForm(this);" class="button"><span><cfoutput>#local.buttonText#</cfoutput></span></a>
						<a href="javascript: show('action=cancelDeviceWarrantyEdit');" class="button"><span>Cancel</span></a>
					</form>
				</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getEditWarrantyForm" returntype="string">
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
			<cfset local.warrantyDetails = application.model.AdminWarranty.getWarranty(local.productId) />
			<cfset local.name = local.warrantyDetails.Name />
			<cfset local.carrierGuid = local.warrantyDetails.CarrierGuid />
			<cfset local.carrier = local.warrantyDetails.Carrier />
			<cfset local.billCode = local.warrantyDetails.CarrierBillCode />
			<cfset local.contractTerm = local.warrantyDetails.ContractTerm />
			<cfset local.includedLines = local.warrantyDetails.IncludedLines />
			<cfset local.maxLines = local.warrantyDetails.MaxLines />
			<cfset local.monthlyFee = local.warrantyDetails.MonthlyFee />
			<cfset local.lineFee = local.warrantyDetails.AdditionalLineFee />
			<cfset local.title = local.warrantyDetails.Title />
		    <cfset local.shortDescription = local.warrantyDetails.ShortDescription />
		    <cfset local.longDescription = local.warrantyDetails.LongDescription />
			<cfset local.DataLimitGb = local.warrantyDetails.DataLimitGb />
      		<cfset local.metaKeywords = local.warrantyDetails.metaKeywords />
		    <cfset local.active = local.warrantyDetails.Active />
		    <cfset local.gersSku = local.warrantyDetails.GersSku />
		    <cfset local.type = local.warrantyDetails.Type />
			<cfset local.channelId = local.warrantyDetails.channelId>
			<cfset local.IsShared = local.warrantyDetails.IsShared />
			<cfset local.primaryActivationFee = local.warrantyDetails.primaryActivationFee />
			<cfset local.basicFee = local.warrantyDetails.BasicFee >
			<cfset local.smartphoneFee = local.warrantyDetails.SmartphoneFee >
			<cfset local.mifiFee = local.warrantyDetails.MifiFee >

			<cfif local.channelId neq 1>
				<cfset local.masterData = application.model.AdminWarranty.getMasterWarranty(local.warrantyDetails.productId) >
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
			                    <label class="field-title" title="The productId for this warranty">Product Id: </label>
								<label><cfoutput>#local.warrantyDetails.productId#</cfoutput></label>
			                    <span class="clearFix">&nbsp;</span>
			                </li>
		                </cfif>
					    <li class="odd">
		                    <label class="field-title" title="Availability sets whether this warranty is available to customers">Availability: </label>
		                    <label>
		                        <input type="checkbox" name="active" <cfif local.active eq true>checked</cfif> name="check_one" value="check1" id="check_one"/>
		                        Available Online
		                    </label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="Required: Select the carrier that offers this warranty">Carrier: <span class="required">*</span></label>
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
		                    <label class="field-title" title="The name of the warranty">Name:</label>
		                    <cfif local.name eq "" || find(local.channelId,"0,1")>
		                    	<label><input name="name" class="txtbox-long" /></label>
		                    <cfelse>
                    			<label><cfoutput>#local.name#</cfoutput></label>
							</cfif>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="Required: The title of the phone">Title: <span class="required">*</span></label>
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
		                    <label class="field-title" title="The GERS SKU for this warranty">GERS SKU:</label>
		                    <label><input name="gersSku" class="txtbox-short" maxlength="9" value="<cfoutput>#local.gersSku#</cfoutput>" /></label>
							<label><!---<a rel="gersLookupLink" href="gersLookup.cfm">Look up GERS SKU</a>---></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Select the type for this warranty">Type:</label>
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
		                    <label class="field-title" title="Select the Share type for this warranty">Is Shared:</label>
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
		                    <label class="field-title" title="The length of contract for this warranty">Contract Term:</label>
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
		                    <label class="field-title" title="The number of lines included in this warranty">Included Lines:</label>
		                    <label><input name="includedLines" class="txtbox-long" value="<cfoutput>#local.includedLines#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="The maximum number of lines allowed on this warranty">Max Lines:</label>
		                    <label><input name="maxLines" class="txtbox-long" value="<cfoutput>#local.maxLines#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
						<li class="odd">
		                    <label class="field-title" title="The warranty's monthly fee">Activation Fee:</label>
		                    <label><input name="primaryActivationFee" class="txtbox-long" value="<cfoutput>#local.primaryActivationFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="The warranty's monthly fee">Monthly Fee:</label>
		                    <label><input name="monthlyFee" class="txtbox-long" value="<cfoutput>#local.monthlyFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="Additional line fee for this warranty">Additional Line Fee:</label>
		                    <label><input name="lineFee" class="txtbox-long" value="<cfoutput>#local.lineFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Basic fee for this warranty">Basic Fee:</label>
		                    <label><input name="basicFee" class="txtbox-long" value="<cfoutput>#local.basicFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="odd">
		                    <label class="field-title" title="Smartphone fee for this warranty">Smartphone Fee:</label>
		                    <label><input name="smartphoneFee" class="txtbox-long" value="<cfoutput>#local.smartphoneFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
		                <li class="even">
		                    <label class="field-title" title="Mifi fee for this warranty">Mifi Fee:</label>
		                    <label><input name="mifiFee" class="txtbox-long" value="<cfoutput>#local.mifiFee#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>

		                <li class="odd">
		                    <label class="field-title" title="Included Data limit in GB">Data Limit (GB):</label>
		                    <label><input name="DataLimitGb" class="txtbox-long" value="<cfoutput>#local.DataLimitGB#</cfoutput>" /></label>
		                    <span class="clearFix">&nbsp;</span>
		                </li>
 						<li class="even">
			                    <label class="field-title" title="The Master short description of the warranty">Master Short Description: </label>
							<label>
								<cfif structKeyExists(local.masterData,"shortDescription")>
									<span class="rawOutput"><cfoutput>#local.masterData.shortDescription#</cfoutput></span>
								</cfif>
							</label>
							<span class="clearFix">&nbsp;</span>
						</li>
		                <li class="odd">
		                    <label class="field-title" title="Short description of this warranty">Short Description: </label>
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
							<label class="field-title" title="The Master short description of the warranty">Master Long Description: </label>
							<label>
								<cfif structKeyExists(local.masterData,"longDescription")>
									<span class="rawOutput"><cfoutput>#local.masterData.longDescription#</cfoutput></span>
								</cfif>
							</label>
							<span class="clearFix">&nbsp;</span>
						</li>
		                <li class="even">
		                    <label class="field-title" title="Long description of this warranty">Long Description: </label>
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
		     	<input type="hidden" name="warrantyGuid" value="<cfoutput>#local.productId#</cfoutput>" />
		     	<input type="hidden" name="action" value="updateWarrantyDetails" />
				<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save changes made to this warranty"><span>Save</span></a> <a href="javascript: show('action=cancelWarrantyEdit');" class="button" title="Cancel changes made to this warranty and do not save"><span>Cancel</span></a>
		    </form>
			<script type="text/javascript">
				// colorbox: lightbox windows for the gers sku lookup
				$("a[rel^='gersLookupLink']").colorbox({fixedWidth:"600px", fixedHeight:"200px", iframe:true, href:"gersLookup.cfm"});
	    	</script>
		</cfsavecontent>

		<cfreturn local.html />
	</cffunction>

	<cffunction name="getWarrantyList" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#structNew()#" />

		<cfset var local = structNew() />
		<cfset local.filter = arguments.filter />
		<cfset local.dislayTitle = '' />

		<!---<cfset local.carriers = application.model.Company.getAllCarriers() />--->
		<cfset local.warranties = application.model.AdminWarranty.getwarranties(local.filter) />

		
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
							<option value="1" <cfif structKeyExists(local.filter, 'Active') && local.filter.Active eq 1>selected="selected"</cfif>>Yes</option>
							<option value="0" <cfif structKeyExists(local.filter, 'Active') && local.filter.Active eq 0>selected="selected"</cfif>>No</option>
						</select>
						
						<label for="createDateFilter_start" style="margin-left:15px;">Created:</label>
						<input type="text" id="createDateFilter_start" name="createDate_start" size="10" value=""/> - 
						<input type="text" id="createDateFilter_end" name="createDate_end" size="10" value=""/>

						<input name="filterSubmit" type="submit" value="Filter" style="margin-left:25px;" />
					</form>
				</div>
				<table id="listWarrantyAll" class="table-long gridview-momt-warranties">
					<thead>
						<tr>
							<th class="hidden-col">MG</th>	<!--- hide column - we want it there for sorting but not displayed --->						
							<th>Channel</th>
							<th>Title</th>
							<th>Active</th>
							<!---<th>Carrier</th>
							<th>Bill Code</th>--->
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
						<cfloop query="local.warranties">
							<cfif guidbreak is not trim(local.warranties.matchingGUID)>
								<cfset oddeven = oddeven xor 1 />
								<cfset guidbreak = local.warranties.matchingGUID />
								<cfset guidCount = guidCount+1 />
							</cfif>
							<tr class="<cfif oddeven is 1>momt-odd-group<cfelse>momt-even-group</cfif>">
								<cfif not len(trim(local.warranties.title[local.warranties.currentRow]))>
									<cfif len(trim(local.warranties.name[local.warranties.currentRow]))>
										<cfset local.displayTitle = trim(local.warranties.name[local.warranties.currentRow]) />
									<cfelse>
										<cfset local.displayTitle = 'No Title or Name Set' />
									</cfif>
								<cfelse>
									<cfset local.displayTitle = trim(local.warranties.title[local.warranties.currentRow]) />
								</cfif>
								
								<td class="hidden-col">#guidCount#</td>
								<td>#trim(local.warranties.channel)#</td>
	 							<td><a href="?c=a64b3c63-0051-4d8e-9b79-08d67d2da255&productguid=#local.warranties.WarrantyGuid[local.warranties.currentRow]#">#trim(local.displayTitle)#</a></td>
								<td>#yesNoFormat(trim(local.warranties.active[local.warranties.currentRow]))#</td>
								<!---<td>#trim(local.warranties.carrier[local.warranties.currentRow])#</td>
								<td>#trim(local.warranties.carrierBillCode[local.warranties.currentRow])#</td>--->
								<td>#trim(local.warranties.productId[local.warranties.currentRow])#</td>
								<td>#trim(local.warranties.gersSku[local.warranties.currentRow])#</td>
								<td>#dateformat(trim(local.warranties.createDate[local.warranties.currentRow]),"mm/dd/yyyy")#</td>
								<td class="hidden-col">#local.warranties.currentRow#</td>
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

    <cffunction name="getWarrantyPhoneList" returntype="string">
		<cfargument name="warrantyGuid" type="String" required="true" />

    	<cfset var local = structNew()>
        <cfset local.warrantyGuid = arguments.warrantyGuid />
        <cfset local.phones = application.model.Catalog.getWarrantyDevices(local.warrantyGuid) />

        <cfsavecontent variable="local.html">
        	<cfoutput>
			   	<a href="javascript: show('action=showEditWarrantyDevice');"  class="button" showPanel="" hidePanel="">
				   	<span>Add New Phone</span>
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
									<a href="javascript: if(confirm('Are you sure you want to permanently delete this phone from this warranty? This can not be undone.')) { show('action=deleteWarrantyDevice|deviceGuid=<cfoutput>#local.phones.productGuid#</cfoutput>'); }" class="table-delete-link" title="Remove this phone from this warranty">
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