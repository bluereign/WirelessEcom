<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfparam name="request.p.cartCurrentLine" default="1" type="numeric" />

<cfset cartLine = request.p.cartCurrentLine />
<cfset cartLines = session.cart.getLines() />

<cfif not arrayLen(variables.cartLines)>
	<cflocation url="/index.cfm" addtoken="false" />
</cfif>

<cfset cartLine = variables.cartLines[variables.cartLine] />

<cfset thisDevice = variables.cartLine.getPhone() />
<cfset deviceId = variables.cartLine.getPhone().getProductId() />

<cfif not isNumeric(variables.deviceId)>
	<cflocation url="/index.cfm" addtoken="false" />
</cfif>

<cfswitch expression="#thisDevice.getDeviceServiceType()#">
	<cfcase value="Tablet">
		<cfset productGUID = application.model.tablet.getDeviceGuidByProductID(variables.deviceId) />
		<cfset carrierId = application.model.tablet.getCarrierIDbyProductID(variables.deviceId) />
		<cfset carrierGUID = application.model.tablet.getCarrierGUIDbyCarrierID(variables.carrierId) />
	</cfcase>	
	<cfdefaultcase>
		<cfset productGUID = application.model.phone.getDeviceGuidByProductID(variables.deviceId) />
		<cfset carrierId = application.model.phone.getCarrierIDbyProductID(variables.deviceId) />
		<cfset carrierGUID = application.model.phone.getCarrierGUIDbyCarrierID(variables.carrierId) />
	</cfdefaultcase>	
</cfswitch>


<cfset cartTypeFilters = [] />

<cfscript>
	// Add exclusive group options if rate plan is unknown for family Add-a-Line.
	if (variables.carrierId eq 128 and session.cart.getActivationType() is 'addaline' and session.cart.getAddALineType() is 'FAMILY')
	{
		if (session.cart.getHasUnlimitedPlan() is 'Yes')
		{
			arrayAppend(variables.cartTypeFilters, 7); //Add Unlimited options
		} 
		else if(session.cart.getHasUnlimitedPlan() is 'No')
		{
			arrayAppend(variables.cartTypeFilters, 8); //Add Non-Unlimited options
		}
	}
</cfscript>

<cfset optionalServicesHTML = application.view.serviceManager.getServices(carrierId = variables.carrierGUID,  deviceId = variables.productGUID, type = 'O', showSingleAddButton = true, cartTypeFilters = variables.cartTypeFilters, cartTypeId = application.model.cart.getCartTypeId(session.cart.getActivationType()), HasSharedPlan = session.cart.getHasSharedPlan()) />
<cfset workflowHTML = application.view.cart.renderWorkflowController() />

<cfsavecontent variable="serviceHTML">
	<cfoutput>
		<cfset local.thisLineSelectedFeatures = '' />

		<cfif structKeyExists(session, 'cart') and isStruct(session.cart) and session.cart.getCurrentLine()>
			<cfset local.cartLines = session.cart.getLines() />

			<cfif arrayLen(local.cartLines)>
				<cfset local.thisLineFeatures = local.cartLines[session.cart.getCurrentLine()].getFeatures() />

				<cfloop from="1" to="#arrayLen(local.thisLineFeatures)#" index="local.iFeature">
					<cfset local.thisLineSelectedFeatures = listAppend(local.thisLineSelectedFeatures, local.thisLineFeatures[local.iFeature].getProductID()) />
				</cfloop>
			</cfif>
		</cfif>

		<script language="javascript">
			var selectedFeatures = '#local.thisLineSelectedFeatures#';

			updateSelectedFeatures = function(o)	{
				selectedFeatures = '';

				var f = document.getElementById('form_planDetail');
				var e = f.elements;

				for (var i = 0; i < e.length; i++ ) {
					if(e[i].name.indexOf('chk_features',0) > -1 && e[i].checked == true)
                        selectedFeatures += e[i].value + ',';
				}

				if(selectedFeatures.charAt(selectedFeatures.length-1) == ',') {
					selectedFeatures = setCharAt(selectedFeatures, (selectedFeatures.length-1), '');
				}
			}
			function setCharAt(str,index,chr) {
			    if(index > str.length-1) return str;
			    return str.substr(0,index) + chr + str.substr(index+1);
			}			
		</script>

		<form name="form_planDetail" id="form_planDetail">
			<div class="sidebar left">
				<div id="prodImage" class="prodImage">
					<cfif variables.carrierId eq 109><!--- at&t --->
						<img src="#assetPaths.common#images/carrierLogos/att_175.gif" />
					<cfelseif variables.carrierId eq 128><!--- t-mobile --->
						<img src="#assetPaths.common#images/carrierLogos/tmobile_175.gif" />
					<cfelseif carrierId eq 42><!--- verizon --->
						<img src="#assetPaths.common#images/carrierLogos/verizon_175.gif" />
					<cfelseif carrierId eq 299><!--- Sprint --->
						<img src="#assetPaths.common#images/carrierLogos/sprint_175.gif" />
					</cfif>
				</div>
				<div class="icons">

				</div>
			</div>
			<div class="main plans" id="prodList">
				<div class="prodDetail noheight">
					<h2>Choose Services</h2>
				</div>
				<div class="prodSpecs noheight">
					<div class=" noheight" style="display: block" id="prodSpecs">
						#trim(variables.optionalServicesHTML)#
					</div>
				</div>
			</div>
		</form>
		<script type="text/javascript" language="javascript" src="#assetPaths.common#scripts/planFeatureWindow.js"></script>
	</cfoutput>
</cfsavecontent>

<cfoutput>
	#trim(variables.workflowHTML)#
	#trim(variables.serviceHTML)#
</cfoutput>