<style>
	.gs5LandingPage /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
	{
		font-family:Helvetica, Arial, sans-serif;
	}

		/*.gs5Background /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*//*
		{
			background-image:url('/assets/common/images/content/gs5/notify_BG_960x480.jpg');
			height:480px;
			width:960px;
		}*/

		.gs5Background /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
		{
			/*background-image:url('/assets/common/images/content/gs5/GS5_masthead_image.jpg');*/
			height:150px;
			width:960px;
		}
			.aafesMobile .backgroundMasthead_aafes
			{
				background-image:url('/assets/common/images/content/gs5/GS5_masthead_image_aafes.jpg');
				background-repeat:no-repeat;
				display:block;
				height:150px;
				width:960px;
			}
			
			.aafesMobile .backgroundMasthead_costco,
			.membershipWireless .backgroundMasthead_aafes
			{
				display:none;
				height:0px;
				width:0px;
			}

			.membershipWireless .backgroundMasthead_costco
			{
				background-image:url('/assets/common/images/content/gs5/GS5_masthead_image_costco.jpg');
				background-repeat:no-repeat;
				display:block;
				height:150px;
				width:960px;
			}

			.gs5Content
			{
				margin-left:404px;
				padding-top:247px;
			}

				.contentText > em
				{
					font-size: 14px;
					font-weight: bold;
					margin-left: 12px;
				}
				
				.contentText > input, .contentText > select {
				    -webkit-box-sizing: border-box;
				    -moz-box-sizing: border-box;
				    box-sizing: border-box;  
					border: 1px;
					font-size: 16px;
					height: 34px;
					line-height: normal;
					width: 225px;
					background-color: #fff;
					margin-bottom: 20px;
					border-radius: 5px;
					padding: 5px 5px;
				}			
					
				.contentButton
				{}
					
					.buttonContainer
					{
						float:left;
						margin-right:20px;
					}
					
						/* See buttons grouped below */

					.buttonLegal
					{
						color:#fff;
						font-size:8px;
						padding-right:20px;
					}
			
		.gs5Details
		{
			padding:50px 0px;
			width:960px;
		}
		
			.detailsRow
			{
				clear:both;
				display:block;
				margin-bottom:100px;
				overflow:hidden;
			}
			
			.detailsRowLast
			{
				clear:both;
				display:block;
				margin-bottom:0px;
				overflow:hidden;
			}
			
			.left{} /* used for positioning contents in a row where the image is on the left and the content on the right */
			.right{} /* used for positioning contents in a row where the image is on the right and the content on the left */
			
				.left .rowImage
				{
					float:left;
				}
				
				.right .rowImage
				{
					float:right;
				}
				
				.rowTitle
				{
					float:right;
					margin-right:10px;
				}
								
					.titleHeader
					{
						font-weight:lighter;
						font-size:42px;
						font-style:italic;
						margin-top:50px;
						text-transform:capitalize;
						text-align:center;
					}
					
					.titleLogo
					{}
				
					.imageGS5Lockup
					{
							background-image:url('/assets/common/images/content/gs5/GS5_lockup.png');
							background-repeat:no-repeat;
							display:block;
							height:432px;
							width:440px;
					}
					
					.imageBoldDisplay
					{
							background-image:url('/assets/common/images/content/gs5/GS5_boldDisplay.png');
							background-repeat:no-repeat;
							display:block;
							height:220px;
							width:462px;
					}
					
					.imageCamera
					{
							background-image:url('/assets/common/images/content/gs5/GS5_camera.png');
							background-repeat:no-repeat;
							display:block;
							height:211px;
							width:440px;
					}
					
					.imageHealth
					{
							background-image:url('/assets/common/images/content/gs5/GS5_health-fingerPrint.png');
							background-repeat:no-repeat;
							display:block;
							height:437px;
							margin-left:30px;
							width:392px;
					}
					
					.imageEmergency
					{
							background-image:url('/assets/common/images/content/gs5/GS5_EmergencyMode.png');
							background-repeat:no-repeat;
							display:block;
							height:412px;
							width:289px;
					}
					
				.rowBlock
				{
					float:left;
					margin-left:10px;
				}
					
				.rowContent
				{
					float:none;
					margin-bottom:50px;
				}
				
				.left .rowContent
				{
					margin-left:450px;
				}
				
				.right .rowContent
				{
					margin-left:0px;
				}
				
					.contentTitle
					{}
					
						.titleIcon
						{
							float:left;
							height:37px;
							width:37px;
						}
						
							.icon_diamond
							{
								background-image:url('/assets/common/images/content/gs5/GS5_icon_37_sprite.png');
								background-repeat:no-repeat;
								background-position:0px -0px;
								height:37px;
								width:37px;
							}
						
							.icon_camera
							{
								background-image:url('/assets/common/images/content/gs5/GS5_icon_37_sprite.png');
								background-repeat:no-repeat;
								background-position:0px -36px;
								height:37px;
								width:37px;
							}
						
							.icon_health
							{
								background-image:url('/assets/common/images/content/gs5/GS5_icon_37_sprite.png');
								background-repeat:no-repeat;
								background-position:0px -72px;
								height:37px;
								width:37px;
							}
						
							.icon_key
							{
								background-image:url('/assets/common/images/content/gs5/GS5_icon_37_sprite.png');
								background-repeat:no-repeat;
								background-position:0px -108px;
								height:37px;
								width:37px;
							}
						
							.icon_battery
							{
								background-image:url('/assets/common/images/content/gs5/GS5_icon_37_sprite.png');
								background-repeat:no-repeat;
								background-position:0px -144px;
								height:37px;
								width:37px;
							}
						
							.icon_emergency
							{
								background-image:url('/assets/common/images/content/gs5/GS5_icon_37_sprite.png');
								background-repeat:no-repeat;
								background-position:0px -180px;
								height:37px;
								width:37px;
							}
						
						.titleText
						{
							color:#231f20;
							float:none;
							font-size:23px;
							line-height:37px;
							margin-left:47px;
						}
						
					.contentBlock
					{
						color:#808285;
						font-size:14px;
						font-weight:lighter;
						line-height:24px;
					}
					
						.blockButton
						{}
						
							.button_container,
							.aafesMobile .button_container_aafes,
							.membershipWireless .button_container_costco
							{
								display:block;
								height:38px;
								width:173px;
							}
					
							.membershipWireless .button_container_aafes,
							.aafesMobile .button_container_costco
							{
								display:none;
							}
					
								.Notify,
								.PreOrder,
								.BuyNow
								{
									background-repeat:no-repeat;
									display:block;
									height:38px;
									width:173px;
								}
					
								a.button_container span.BuyNow,
								a.button_container_aafes span.BuyNow,
								a.button_container_costco span.BuyNow
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_BuyNow.png');
									background-position:0px -0px;
								}
					
								a.button_container span.BuyNow:hover,
								a.button_container_aafes span.BuyNow:hover,
								a.button_container_costco span.BuyNow:hover
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_BuyNow.png');
									background-position:0px -40px;
								}
					
								a.button_container span.BuyNow:active,
								a.button_container_aafes span.BuyNow:active,
								a.button_container_costco span.BuyNow:active
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_BuyNow.png');
									background-position:0px -80px;
								}
					
								a.button_container span.Notify,
								a.button_container_aafes span.Notify,
								a.button_container_costco span.Notify
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_NotifyMe.png');
									background-position:0px -0px;
								}
					
								a.button_container span.Notify:hover,
								a.button_container_aafes span.Notify:hover,
								a.button_container_costco span.Notify:hover
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_NotifyMe.png');
									background-position:0px -40px;
								}
					
								a.button_container span.Notify:active,
								a.button_container_aafes span.Notify:active,
								a.button_container_costco span.Notify:active
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_NotifyMe.png');
									background-position:0px -80px;
								}
					
								a.button_container span.PreOrder,
								a.button_container_aafes span.PreOrder,
								a.button_container_costco span.PreOrder
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_PreOrderNow.png');
									background-position:0px -0px;
								}
					
								a.button_container span.PreOrder:hover,
								a.button_container_aafes span.PreOrder:hover,
								a.button_container_costco span.PreOrder:hover
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_PreOrderNow.png');
									background-position:0px -40px;
								}
					
								a.button_container span.PreOrder:active,
								a.button_container_aafes span.PreOrder:active,
								a.button_container_costco span.PreOrder:active
								{
									background-image:url('/assets/common/images/content/gs5/btn_sprite_PreOrderNow.png');
									background-position:0px -80px;
								}
					
				.rowLegal
				{
					color:#808285;
					font-size:8px;
				}
</style>

<cfoutput>
	<script src="#prc.assetPaths.common#scripts/libs/jquery.validate.min.js"></script>
	<script src="#prc.assetPaths.common#scripts/libs/jquery.placeholder.js"></script>
</cfoutput>

<script>
	jQuery.noConflict();
	jQuery(document).ready(function( $ ) {

		//Set validation plugin defaults
		jQuery.validator.setDefaults({
		   ignore: ".ignore"
		   , errorElement: "em"
		});
		
		$('#email').placeholder();
	});

	function ValidateNotificationForm()
	{
		var validator = jQuery("#notificationform").validate();

		if ( jQuery("#notificationform").valid() )
		{
			jQuery('#notificationform').submit();
		}

		return false;
	}
</script>

<cfoutput>
<form id="notificationform" action="/notification/RegisterPresaleAlert/" method="post">
	<div class="gs5LandingPage">
		<div class="gs5Background">
			<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,433/index?utm_source=aafesMobile&utm_medium=GS5_LandingPageMasthead&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=gs5">
				<span class="backgroundMasthead_aafes"></span>
			</a>
			<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,433/index?utm_source=membershipWireless&utm_medium=GS5_LandingPageMasthead&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=gs5">
				<span class="backgroundMasthead_costco"></span>
			</a>
			<!---<div class="gs5Content">
				<div class="contentText">
					<select name="campaignId" required>
						<option value="" <cfif rc.CampaignId eq ''>selected</cfif>>Select your carrier</option>
						<option value="1" <cfif rc.CampaignId eq '1'>selected</cfif>>AT&T</option>
						<cfif application.model.Carrier.isEnabled(299)>
							<option value="3" <cfif rc.CampaignId eq '3'>selected</cfif>>Sprint</option>
						</cfif>
						<option value="2" <cfif rc.CampaignId eq '2'>selected</cfif>>T-Mobile</option>
						<option value="4" <cfif rc.CampaignId eq '4'>selected</cfif>>Verizon Wireless</option>
					</select>
				</div>
				<div class="contentText">
					<input id="email" type="email" name="email" value="#rc.Email#" maxlength="50" placeholder="Enter your email address" required>
				</div>
				<div class="contentButton">
					<div class="buttonContainer">
						<div class="blockButton">
							<a class="button_container" href="##" onclick="ValidateNotificationForm(); return false;" >
								<span class="Notify"></span>
							</a>
						</div>
					</div>	
					<span class="buttonLegal">This device has not been authorized as required by the rules of the Federal 
					Communications Commission. This device is not, and may not be, offered for sale or lease, or sold or 
					leased, until authorization is obtained.</span>
				</div>
			</div>--->
		</div>
		
		<div class="gs5Details">
			<div class="detailsRow" style="margin-bottom:50px;">
				<div class="rowTitle">
					<div class="titleLogo">
						<img src="/assets/common/images/content/gs5/Samsung_logo.png" />
					</div>
				</div>
				<!---<div class="rowBlock">
					<div class="blockButton">
						<a class="button_container_aafes" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,433/index?utm_source=AAFESmobile&utm_medium=GS5LandingPage&utm_term=PhonesList&utm_content=all_carriers&utm_campaign=gs5">
							<span class="PreOrder"></span> <!--- This class can be one of three pseudo classes: BuyNow, Notify, or PreOrder --->
						</a>
						<a class="button_container_costco" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,433/index?utm_source=membshipwireless&utm_medium=GS5LandingPage&utm_term=PhonesList&utm_content=all_carriers&utm_campaign=gs5">
							<span class="PreOrder"></span> <!--- This class can be one of three pseudo classes: BuyNow, Notify, or PreOrder --->
						</a>
					</div>
				</div>--->
				<div class="rowTitle" style="float:none; margin-top:80px;">
					<div class="titleHeader">THE NEXT BIG THING IS HERE</div>
				</div>
			</div>
			<div class="detailsRow left">
				<div class="rowImage">
					<div class="imageGS5Lockup"></div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleText" style="margin-left:0px;">
							<!-- [GS5 logo goes here] -->
							<img src="/assets/common/images/content/gs5/GS5_logo.png" />
						</div>
					</div>
					<div class="contentBlock">
						<p>Make split-second moments yours. Watch HD movies and games roar to life. Or track your life right down 
						to your heartbeat. Powered with innovation, the Galaxy S<sup>&reg;</sup> 5 is like no other mobile device 
						before it.</p>
					</div>
					<div class="contentBlock" style="margin-top:50px;">
						<div class="blockButton">
							<a class="button_container_aafes" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,433/index?utm_source=AAFESmobile&utm_medium=GS5LandingPage&utm_term=PhonesList&utm_content=all_carriers&utm_campaign=gs5">
								<span class="BuyNow"></span> <!--- This class can be one of three pseudo classes: BuyNow, Notify, or PreOrder --->
							</a>
							<a class="button_container_costco" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,433/index?utm_source=membshipwireless&utm_medium=GS5LandingPage&utm_term=PhonesList&utm_content=all_carriers&utm_campaign=gs5">
								<span class="BuyNow"></span> <!--- This class can be one of three pseudo classes: BuyNow, Notify, or PreOrder --->
							</a>
						</div>
					</div>
				</div>
			</div>
			<div class="detailsRow right">
				<div class="rowImage">
					<div class="imageBoldDisplay"></div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleIcon">
							<div class="icon_diamond"></div>
						</div>
						<div class="titleText">
							Big, Bold 5.1" HD Display.
						</div>
					</div>
					<div class="contentBlock">
						<p>We've put everything we know about HDTV on brilliant display. Movies come to life as they were meant to 
						be seen. Richer colors, darker shadows, faster response times&mdash;all on 62% more viewing area than the leading 
						competitor.</p>
					</div>
				</div>
			</div>
			<div class="detailsRow left">
				<div class="rowImage">
					<div class="imageCamera"></div>
				</div>
				<div class="rowContent" style="margin-left:480px;">
					<div class="contentTitle">
						<div class="titleIcon">
							<div class="icon_camera"></div>
						</div>
						<div class="titleText">
							Professional Quality 16 MP<br/>Camera with Faster Focus.
						</div>
					</div>
					<div class="contentBlock">
						<p>Capture moments as they happen with the only camera you'll ever need. With a lightning-fast autofocus, 
				you can frame, take and edit split-second shots like a pro.</p>
					</div>
				</div>
			</div>
			<div class="detailsRow right">
				<div class="rowImage">
					<div class="imageHealth"></div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleIcon">
							<div class="icon_health"></div>
						</div>
						<div class="titleText">
							Integrated Mobile S Health&trade; Partner.**
						</div>
					</div>
					<div class="contentBlock">
						<p>The first-ever built-in heart rate sensor that responds to your touch. Meet your perfect workout partner 
						as you track your steps, challenge friends, earn medals and get on-demand nutrition advice.</p>
					</div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleIcon">
							<div class="icon_key"></div>
						</div>
						<div class="titleText">
							Secure Fingerprint Scanner for Faster Access.
						</div>
					</div>
					<div class="contentBlock">
						<p>Unlock your phone with the touch of a finger. Quickly access your work, websites and more&mdash;all without 
						entering a password. Opening your phone has never been easier.</p>
					</div>
				</div>
				
				
			</div>
			<div class="detailsRow left" style="margin-bottom:0px;">
				<div class="rowImage">
					<div class="imageEmergency"></div>
				</div>
				<div class="rowContent" style="margin-left:330px;">
					<div class="contentTitle">
						<div class="titleIcon">
							<div class="icon_battery"></div>
						</div>
						<div class="titleText">
							Maximize Battery Power for When You Need It Most.
						</div>
					</div>
					<div class="contentBlock">
						<p>About to run out of power but can't miss an important call? Use Ultra Power Saving Mode to turn the 
						Galaxy S 5 screen to black and white and shut off nonessential apps, so you get the maximum battery 
						life for your device. That way, when you're down to 10% charge, you can still receive calls and texts 
						for up to 24 hours.<sup>&dagger;</sup></p>
					</div>
				</div>
				<div class="rowContent" style="margin-left:330px;">
					<div class="contentTitle">
						<div class="titleIcon">
							<div class="icon_emergency"></div>
						</div>
						<div class="titleText">
							Stylish Design that Stands Up to Every Day.
						</div>
					</div>
					<div class="contentBlock">
						<p>Form and style have never been more functional. Dustproof and water-resistant, the Galaxy S 5 is 
						engineered to withstand the rigors of everyday life.<sup>&dagger;&dagger;</sup></p>
					</div>
				</div>
			</div>
			<div class="detailsRow">
				<div class="rowContent left" style="margin:0px 0px 0px 330px;">
					<img src="/assets/common/images/content/gs5/bottom_divider.png" />
				</div>
			</div>
			<div class="detailsRowLast">
				<div class="rowLegal">
					<p>**This device and related software is not intended for use in the diagnosis of disease or other 
					conditions, or in the cure, mitigation, treatment or prevention of disease.</p>
					<p><sup>&dagger;</sup>Battery life: Battery power consumption depends on factors such as network configuration, signal 
					strength, operating temperature, features selected, vibrate mode, backlight settings, browser use, 
					frequency of calls and voice, data and other applications usage patterns.</p>
					<p><sup>&dagger;&dagger;</sup>Device has been tested and received an IP (Ingress Protection) rating of IP67, which 
					means that it is protected against dust intrusion and capable of withstanding water immersion of between 
					15 cm and one meter for 30 minutes.</p>
					<p>&copy; 2014 Samsung Telecommunications America, LLC. Samsung, Galaxy S, Samsung Gear and S Health are 
					all trademarks of Samsung Electronics Co., Ltd. Other company names, product names and marks mentioned 
					herein are the property of their respective owners and may be trademarks or registered trademarks. 
					Screen images simulated. Appearance of devices may vary.</p> 
				</div>
			</div>
		</div>
	</div>
	
</form>
</cfoutput>	
