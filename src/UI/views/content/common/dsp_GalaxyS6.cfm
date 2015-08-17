<style>
	.gs5LandingPage /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
	{
		font-family:Helvetica, Arial, sans-serif;
	}

		/*.gs5Background use this class if we nolonger require two different looking landing pages for Costco and AAFES
		{
			background-image:url('/assets/common/images/content/gs6/notify_BG_962x660_aafes.jpg');
			height:680px;
			width:962px;
		}*/

		.aafesMobile .gs5Background
		{
			background-image:url('/assets/common/images/content/gs6/notify_BG2_962x840_aafes.jpg');
			height:840px;
			width:962px;
		}

		.membershipWireless .gs5Background
		{
			background-image:url('/assets/common/images/content/gs6/notify_BG2_962x840_costco.jpg');
			height:840px;
			width:962px;
		}

		/*.aafesMobile .gs5Background_aafes
		{
			background-image:url('/assets/common/images/content/gs6/notify_BG_962x660_aafes.jpg');
			height:680px;
			width:962px;
		}

		.membershipWireless .gs5Background_aafes,
		.aafesMobile .gs5Background_costco
		{
			display:none;
		}

		.membershipWireless .gs5Background_costco
		{
			background-image:url('/assets/common/images/content/gs6/notify_BG_962x660_costco.jpg');
			height:680px;
			width:962px;
		}*/

		/*.gs5Background use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
		{
			/*background-image:url('/assets/common/images/content/gs5/GS5_masthead_image.jpg');
			height:150px;
			width:960px;*/
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
				margin-left:185px;
				padding-top:615px;
				width:550px;
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
					/*border-radius: 5px;*/
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
								height:29px;
								width:130px;
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
									height:29px;
									width:130px;
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
									background-image:url('/assets/common/images/content/gs6/btn_sprite_PreReg.png');
									background-position:0px -0px;
								}
					
								a.button_container span.PreOrder:hover,
								a.button_container_aafes span.PreOrder:hover,
								a.button_container_costco span.PreOrder:hover
								{
									background-image:url('/assets/common/images/content/gs6/btn_sprite_PreReg.png');
									background-position:0px -30px;
								}
					
								a.button_container span.PreOrder:active,
								a.button_container_aafes span.PreOrder:active,
								a.button_container_costco span.PreOrder:active
								{
									background-image:url('/assets/common/images/content/gs6/btn_sprite_PreReg.png');
									background-position:0px -60px;
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
			<div class="gs5Content">
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
								<span class="PreOrder"></span>
							</a>
						</div>
					</div>	
					<span class="buttonLegal">This device has not been authorized as required by the rules of the Federal 
					Communications Commission. This device is not, and may not be, offered for sale or lease, or sold or 
					leased, until authorization is obtained.</span>
				</div>
			</div>
		</div>
				
	</div>
	
</form>
</cfoutput>	
