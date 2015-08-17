<cfoutput>

			<ul class="breadcrumb">
				<li>
					<a href="/">Dashboard</a>
				</li>
				<li>
					<a href="#event.BuildLink( 'campaigns.main.index' )#">Campaign Manager</a>
				</li>
				<li class="active">
					#rc.mode# Campaign
				</li>
			</ul>

	<cfif structKeyExists(rc,'msg')>
		<div class="row clearfix">
			<div class="col-md-12 column">
				<div class="alert alert-dismissable alert-danger">
					 <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
					<h4>
						Error!
					</h4> #rc.msg#
				</div>
			</div>
		</div>		
	</cfif>

	<div class="row clearfix">
		<form class="form-horizontal" role="form" action="#event.BuildLink( 'campaigns.main.save' )#" method="post" enctype="multipart/form-data">
			<input type="hidden" name="campaignId" value="#rc.campaignObj.getCampaignId()#" />
			<input type="hidden" name="mode" value="#rc.mode#" />
		<div class="col-md-12 column">

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-primary">
						<div class="panel-heading">
							<h3 class="panel-title">
								Campaign Information
							</h3>
						</div>
					</div>
				</div>
			</div>		

			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="companyName" class="col-sm-4 control-label">Company Name</label>
						<div class="col-sm-8">
							<input class="form-control" id="companyName" name="companyName" value="#rc.campaignObj.getCompanyName()#" type="text" required />
						</div>
					</div>
					<div class="form-group">
						 <label for="startDateTime" class="col-sm-4 control-label">Start Datetime</label>
						<div class="col-sm-5">
							<div class="input-append date form_datetime">
								<input class="form-control dtpicker" name="startDateTime" id="startDateTime" size="16" type="text" value="#DateFormat( rc.campaignObj.getStartDateTime(), 'mm/dd/yyyy' )# #TimeFormat( rc.campaignObj.getStartDateTime(), 'hh:mm tt' )#" required />
								<span class="add-on"><i class="icon-th"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label for="isActive" class="col-sm-4 control-label">Active</label>
						<div class="col-sm-1">
							<div class="checkbox" style="margin-left:20px; margin-top:-9px;"><input class="form-control" id="isActive" name="isActive" type="checkbox" value="1"<cfif rc.campaignObj.getIsActive()> checked="checked"</cfif> />
							</div>
						</div>
					</div>
					<div class="form-group">
						 <label for="logo" class="col-sm-4 control-label">Campaign Logo</label>
						<div class="col-sm-8">
							<input class="form-control filepicker" id="logo" name="logo" value="" type="file" <cfif NOT isBinary( rc.campaignObj.getLogoImage() )>required</cfif> />
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="subdomain" class="col-sm-4 control-label">SubDomain</label>
						<div class="col-sm-5">
							<input class="form-control" id="subdomain" name="subdomain" value="#rc.campaignObj.getSubdomain()#" type="text" />
						</div>
					</div>
					<div class="form-group">
						 <label for="endDateTime" class="col-sm-4 control-label">End Datetime</label>
						<div class="col-sm-5">
							<div class="input-append date form_datetime">
								<input class="form-control dtpicker" name="endDateTime" id="endDateTime" size="16" type="text" value="#DateFormat( rc.campaignObj.getEndDateTime(), 'mm/dd/yyyy' )# #TimeFormat( rc.campaignObj.getEndDateTime(), 'hh:mm tt' )#" required />
								<span class="add-on"><i class="icon-th"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						 <label for="version" class="col-sm-4 control-label">Version</label>
						<div class="col-sm-2">
							<input class="form-control" id="version" name="version" value="#rc.campaignObj.getVersion()#" type="text" disabled />
						</div>
					</div>
					<div class="form-group">
						 <label class="col-sm-4 control-label">Current Logo</label>
						<div class="col-sm-5">				
						<cfif isBinary( rc.campaignObj.getLogoImage() )>	
							<!--- try --->
							<cftry>
								<!--- get the image data --->
								<cfimage source="#rc.campaignObj.getLogoImage()#" name="logoImage" />
								<!--- scale it to 25 pixels high --->
								<cfset imageScaleToFit( logoImage, '', 25 ) />
								<!--- write the logo to the browser --->
								<cfimage action="writeToBrowser" source="#logoImage#" />
							<!--- catch gracefully --->
							<cfcatch type="any">
								<span class="text-danger">Invalid Image</span>
							</cfcatch>
							</cftry>
						<cfelse>
							<span class="text-primary">N/A</span>
						</cfif>
						</div>
					</div>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-12 column">
					<div class="form-group">
						 <label for="smsMessage" class="col-sm-2 control-label">SMS Message</label>
						<div class="input-group col-sm-8">
							<textarea class="form-control" name="smsMessage" id="smsMessage" required>#rc.campaignObj.getSmsMessage()#</textarea>
							<p class="text-right" id="counter"></p>
						</div>
					</div>
					<div class="form-group">
						 <label for="disclaimer" class="col-sm-2 control-label">Disclaimer</label>
						<div class="input-group col-sm-8">
							<textarea class="form-control" name="disclaimer" id="disclaimer" required>#rc.campaignObj.getDisclaimer()#</textarea>
						</div>
					</div>
				</div>
			</div>
			<div class="row clearfix">&nbsp;
			</div>

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Top Navigation Bar
							</h3>
						</div>
					</div>
				</div>
			</div>			
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="topNavBarBg" class="col-sm-4 control-label">Background Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="topNavBarBg" name="topNavBarBg" type="text" value="#rc.campaignObj.getCssProps().topNavBarBg.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="topNavBarText" class="col-sm-4 control-label">Text Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="topNavBarText" name="topNavBarText" type="text" value="#rc.campaignObj.getCssProps().topNavBarText.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-6 column">&nbsp;
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="topNavBarTextActive" class="col-sm-4 control-label">Text Color (Active)</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="topNavBarTextActive" name="topNavBarTextActive" type="text" value="#rc.campaignObj.getCssProps().topNavBarTextActive.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row clearfix">				
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Header
							</h3>
						</div>
					</div>
				</div>
			</div>	
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="headerImage" class="col-sm-4 control-label">Image</label>
						<div class="col-sm-8">
							<div class="input-group">
    							<input class="form-control filepicker" id="headerImage" name="headerImage" value="" type="file" <cfif NOT isBinary( rc.campaignObj.getHeaderImage() )>required</cfif> />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label class="col-sm-4 control-label">Current Header</label>
						<div class="col-sm-5">				
						<cfif isBinary( rc.campaignObj.getheaderImage() )>	
							<!--- try --->
							<cftry>
								<!--- get the image data --->
								<cfimage source="#rc.campaignObj.getheaderImage()#" name="headerImage" />
								<!--- scale it to 25 pixels high --->
								<cfset imageScaleToFit( headerImage, '', 25 ) />
								<!--- write the logo to the browser --->
								<cfimage action="writeToBrowser" source="#headerImage#" />
							<!--- catch gracefully --->
							<cfcatch type="any">
								<span class="text-danger">Invalid Image</span>
							</cfcatch>
							</cftry>
						<cfelse>
							<span class="text-primary">N/A</span>
						</cfif>
						</div>
					</div>
				</div>
			</div>

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Menu Navigation
							</h3>
						</div>
					</div>
				</div>
			</div>	
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="menuNavBg" class="col-sm-4 control-label">Background Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="menuNavBg" name="menuNavBg" type="text" value="#rc.campaignObj.getCssProps().menuNavBg.getValue()#" required />					    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="menuNavText" class="col-sm-4 control-label">Text Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="menuNavText" name="menuNavText" type="text" value="#rc.campaignObj.getCssProps().menuNavText.getValue()#" required />				    
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="menuNavBgActive" class="col-sm-4 control-label">Background Color (Active)</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="menuNavBgActive" name="menuNavBgActive" type="text" value="#rc.campaignObj.getCssProps().menuNavBgActive.getValue()#" required />					    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="menuNavTextActive" class="col-sm-4 control-label">Text Color (Active)</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="menuNavTextActive" name="menuNavTextActive" type="text" value="#rc.campaignObj.getCssProps().menuNavTextActive.getValue()#" required />				    
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Product Grid - Product Title
							</h3>
						</div>
					</div>
				</div>
			</div>			
			<div class="row clearfix">
				<div class="col-md-6 column">&nbsp;
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="gridHdrText" class="col-sm-4 control-label">Text Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="gridHdrText" name="gridHdrText" type="text" value="#rc.campaignObj.getCssProps().gridHdrText.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>			
			<div class="row clearfix">
				<div class="col-md-6 column">&nbsp;
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="gridHoverText" class="col-sm-4 control-label">Text Color (Active)</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="gridHoverText" name="gridHoverText" type="text" value="#rc.campaignObj.getCssProps().gridHoverText.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>	

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Product Grid - Buy Button
							</h3>
						</div>
					</div>
				</div>
			</div>		
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="gridBtnBg" class="col-sm-4 control-label">Background Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="gridBtnBg" name="gridBtnBg" type="text" value="#rc.campaignObj.getCssProps().gridBtnBg.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="gridBtnText" class="col-sm-4 control-label">Text Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="gridBtnText" name="gridBtnText" type="text" value="#rc.campaignObj.getCssProps().gridBtnText.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>		
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="gridBtnBgActive" class="col-sm-4 control-label">Background Color (Active)</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="gridBtnBgActive" name="gridBtnBgActive" type="text" value="#rc.campaignObj.getCssProps().gridBtnBgActive.getValue()#" required />
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="gridBtnTextActive" class="col-sm-4 control-label">Text Color (Active)</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="gridBtnTextActive" name="gridBtnTextActive" type="text" value="#rc.campaignObj.getCssProps().gridBtnTextActive.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Campaign Background
							</h3>
						</div>
					</div>
				</div>
			</div>			
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="bgImage" class="col-sm-4 control-label">Image (Optional)</label>
						<div class="col-sm-8">
							<div class="input-group">
    							<input class="form-control filepicker" id="bgImage" name="bgImage" value="" type="file" />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label class="col-sm-4 control-label">Current Background</label>
						<div class="col-sm-5">				
						<cfif isBinary( rc.campaignObj.getBgImage() )>	
							<!--- try --->
							<cftry>
								<!--- get the image data --->
								<cfimage source="#rc.campaignObj.getBgImage()#" name="bgImage" />
								<!--- scale it to 25 pixels high --->
								<cfset imageScaleToFit( bgImage, '', 25 ) />
								<!--- write the logo to the browser --->
								<cfimage action="writeToBrowser" source="#bgImage#" />
							<!--- catch gracefully --->
							<cfcatch type="any">
								<span class="text-danger">Invalid Image</span>
							</cfcatch>
							</cftry>
						<cfelse>
							<span class="text-primary">N/A</span>
						</cfif>
						</div>
					</div>
				</div>
			</div>	
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="bgClr" class="col-sm-4 control-label">Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="bgClr" name="bgClr" type="text" value="#rc.campaignObj.getCssProps().bgClr.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">&nbsp;</div>
			</div>

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Advertising Banner
							</h3>
						</div>
					</div>
				</div>
			</div>			
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="adImage" class="col-sm-4 control-label">Image (Optional)</label>
						<div class="col-sm-8">
							<div class="input-group">
    							<input class="form-control filepicker" id="adImage" name="adImage" value="" type="file" />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label class="col-sm-4 control-label">Current Ad</label>
						<div class="col-sm-5">				
						<cfif isBinary( rc.campaignObj.getAdImage() )>	
							<!--- try --->
							<cftry>
								<!--- get the image data --->
								<cfimage source="#rc.campaignObj.getAdImage()#" name="adImage" />
								<!--- scale it to 25 pixels high --->
								<cfset imageScaleToFit( adImage, '', 25 ) />
								<!--- write the logo to the browser --->
								<cfimage action="writeToBrowser" source="#adImage#" />
							<!--- catch gracefully --->
							<cfcatch type="any">
								<span class="text-danger">Invalid Image</span>
							</cfcatch>
							</cftry>
						<cfelse>
							<span class="text-primary">N/A</span>
						</cfif>
						</div>
					</div>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="adUrl" class="col-sm-4 control-label">Link (Optional)</label>
						<div class="col-sm-8">
							<input class="form-control" id="adUrl" name="adUrl" placeholder="http://" value="#rc.campaignObj.getAdUrl()#" type="text" />
						</div>
					</div>
				</div>
				<div class="col-md-6 column">&nbsp;
				</div>
			</div>


			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Cart Dialog
							</h3>
						</div>
					</div>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="cartBg" class="col-sm-4 control-label">Background Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="cartBg" name="cartBg" type="text" value="#rc.campaignObj.getCssProps().cartBg.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="cartText" class="col-sm-4 control-label">Text Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="cartText" name="cartText" type="text" value="#rc.campaignObj.getCssProps().cartText.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>		
			<div class="row clearfix">
				<div class="col-md-6 column">&nbsp;
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="cartTextActive" class="col-sm-4 control-label">Text Color (Active)</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="cartTextActive" name="cartTextActive" type="text" value="#rc.campaignObj.getCssProps().cartTextActive.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row clearfix">
				<div class="col-md-12 column text-center">
					<div class="panel panel-info">
						<div class="panel-heading">
							<h3 class="panel-title">
								Footer Navigation Bar
							</h3>
						</div>
					</div>
				</div>
			</div>			
			<div class="row clearfix">
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="footerNavBarBg" class="col-sm-4 control-label">Background Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="footerNavBarBg" name="footerNavBarBg" type="text" value="#rc.campaignObj.getCssProps().footerNavBarBg.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 column">
					<div class="form-group">
						 <label for="footerNavBarText" class="col-sm-4 control-label">Text Color</label>
						<div class="col-sm-3">
							<div class="input-group">
							    <input class="form-control clrpicker" id="footerNavBarText" name="footerNavBarText" type="text" value="#rc.campaignObj.getCssProps().footerNavBarText.getValue()#" required />							    
							</div>
						</div>
					</div>
				</div>
			</div>

			<hr />
			
			<div class="row clearfix">
				<div class="col-md-12 column">
					<div class="form-group">
						<div class="input-group text-right col-sm-10">
							<input type="submit" name="btnSubmit" value="#rc.mode# Campaign" class="btn btn-primary" />
						</div>
					</div>
				</div>
			</div>
		</div>
		</form>		
	</div>
</cfoutput>
<script type="text/javascript">
$(function() {

	// limit and report chars remaining for sms message field
	$('#smsMessage').on("propertychange input textInput", function() {
		var left = 160 - $(this).val().length;
	    if (left < 0) {
	        left = 0;
	        $(this).val($(this).val().substring(0,159));
	    }
	    $('#counter').text(left + ' of 160 characters remaining');
	});

	$('#smsMessage').trigger('input');

	// add datetime picker to start/end datetime fields
	$('.dtpicker').datetimepicker({
		format: 'mm/dd/yyyy HH:ii P',
		showMeridian: true,
		autoclose: true,
		todayBtn: true
	});

	// add color picker to css fields
	$('.clrpicker').colorpicker({
		format: 'hex'
	}).on("hidePicker changeColor propertychange input textInput", function() {
		// change the background color
		$(this).css( "background-color", $(this).val() );
		// get the new background color
		var bg = $(this).css('background-color');
		// get the rgb value
		var rgb = bg.replace(/^(rgb|rgba)\(/,'').replace(/\)$/,'').replace(/\s/g,'').split(',');
		// convert to HSL
        var yiq = ((rgb[0]*299)+(rgb[1]*587)+(rgb[2]*114))/1000;
        // check if this is a light color (>=128) or dark color (<128) and set the foreground color black or white accordingly
        if(yiq >= 128) {
        	$(this).css( 'color', '#000000');
        } else {
        	$(this).css( 'color', '#FFFFFF');
        }
	});

	// trigger colorpicker to fire when loading an existing campaign
	$('.clrpicker').trigger('input');

	// style the file picker
	$(".filepicker").filestyle({
		buttonName: "btn-info",
		buttonText: "&nbsp;Select Image"
	});

});
</script>