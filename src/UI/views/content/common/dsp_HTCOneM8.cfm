<style>
	.htcLandingPage /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
	{
		font-family:Helvetica, Arial, sans-serif;
	}

		.htcBackgroundShort /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
		{
			background-image:url('/assets/common/images/content/htc_m8/HTC-M8_Top-banner-short.jpg');
			height:250px;
			width:960px;
			margin-top:20px;
		}

		.htcBackground /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
		{
			background-image:url('/assets/common/images/content/htc_m8/HTC-M8_Top-banner_costco.jpg');
			height:430px;
			width:960px;
		}
		
			.aafesMobile .backgroundImage_aafes,
			.membershipWireless .backgroundImage_costco
			{
				display:block;
				margin-left:741px;
				padding-top:317px;
			}

			.membershipWireless .backgroundImage_aafes,
			.aafesMobile .backgroundImage_costco
			{
				display:none;
			}

			.htcContent /*use this class if we nolonger require two different looking landing pages for Costco and AAFES*/
			{
				margin-left:404px;
				padding-top:337px;
			}

		.htcDetails
		{
			/*padding:50px 0px;*/
			width:960px;
		}
		
			.detailsRow
			{
				border-bottom:1px solid #000;
				clear:both;
				display:block;
				margin-top:50px;
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
					text-align:right;
				}
				
					.titleContent
					{}
					
						.contentMasthead
						{
							color:#0667af;
							font-weight:bold;
							font-size:30px;
							font-style:normal;
							text-align:center;
						}
						
						.contentSubhead
						{
							color:#888;
							font-size:16px;
							font-weight:normal;
							text-align:center;
						}
						
						.aafesMobile .contentLogos_aafes
						{
							text-align:center;
						}
						
						.membershipWireless .contentLogos_aafes,
						.aafesMobile .contentLogos_costco
						{
							display:none;
						}
						
						.membershipWireless .contentLogos_costco
						{
							text-align:center;
						}
						
							.logosATT
							{
								background-image:url('/assets/common/images/carrierLogos/att_175.gif');
								background-repeat:no-repeat;
								display:inline-block;
								height:70px;
								width:150px;
								margin-right:10px;
							}
							
							.logosVZW
							{
								background-image:url('/assets/common/images/carrierLogos/verizon_175.gif');
								background-repeat:no-repeat;
								display:inline-block;
								height:94px;
								width:170px;
								margin-right:20px;
							}
						
							.logosTMO
							{
								background-image:url('/assets/common/images/carrierLogos/tmobile_175.gif');
								background-repeat:no-repeat;
								display:inline-block;
								height:70px;
								width:175px;
								margin-right:30px;
							}
						
							.logosSprint
							{
								background-image:url('/assets/common/images/carrierLogos/sprint_175b.gif');
								background-repeat:no-repeat;
								display:inline-block;
								height:92px;
								width:170px;
							}
						
					.imageCamera
					{
							background-image:url('/assets/common/images/content/htc_m8/M8-Horizontal-duo-camera.png');
							background-repeat:no-repeat;
							display:block;
							height:194px;
							width:401px;
							margin-bottom:50px;
							margin-left:50px;
					}
					
					.imageSound
					{
							background-image:url('/assets/common/images/content/htc_m8/M8-Horizontal.png');
							background-repeat:no-repeat;
							display:block;
							height:194px;
							width:401px;
							margin-bottom:50px;
					}
					
					.imageBlinkFeed
					{
							background-image:url('/assets/common/images/content/htc_m8/M8_cropped.png');
							background-repeat:no-repeat;
							display:block;
							height:323px;
							width:199px;
							margin-right:50px;
					}
					
					.imageAdvantages
					{
							background-image:url('/assets/common/images/content/htc_m8/Advantage-Shield.png');
							background-repeat:no-repeat;
							display:block;
							height:197px;
							width:227px;
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
					
						.titleHeader
						{
							color:#0667af;
							font-size:30px;
							font-weight:bolder;
							margin-bottom:20px;
						}
						
						.titleText
						{
							color:#0667af;
							font-size:24px;
							font-weight:bold;
						}
						
					.contentBlock
					{
						color:#666666;
						font-size:14px;
						font-weight:normal;
						line-height:20px;
					}
					
					.aafesMobile .contentPhones_aafes,
					.membershipWireless .contentPhones_costco
					{
						display:block;
						margin-top:50px;
						overflow:hidden;
					}
					
					.membershipWireless .contentPhones_aafes,
					.aafesMobile .contentPhones_costco
					{
						display:none;
					}
					
						.phonesImage_left
						{
							float:left;
							margin-left:232px;
						}
						
						.phonesImage_right
						{
							float:right;
							margin-right:232px;
						}
						
							.imageLeft
							{
								background-image:url('/assets/common/images/content/htc_m8/M8-GunMetal-Back.png');
								background-repeat:no-repeat;
								background-position:0px -0px;
								display:block;
								height:333px;
								width:161px;
								margin-left:4px;
							}
							
							.imageRight
							{
								background-image:url('/assets/common/images/content/htc_m8/M8-Silver-Back.png');
								background-repeat:no-repeat;
								background-position:0px -0px;
								display:block;
								height:333px;
								width:161px;
								margin-right:4px;
							}
							
							.imageTitle
							{
								font-size:18px;
								font-weight:bold;
								text-align:center;
								margin-top:20px;
								margin-bottom:20px;
							}
							
							.imageButton
							{
							}

							.phonesImage_left .imageButton
							{
								margin-left:16px;
							}

							.phonesImage_right .imageButton
							{
								margin-left:14px;
							}

								.button_container
								{
									display:block;
									height:48px;
									width:138px;
								}
						
									.BuyNow
									{
										display:block;
										height:48px;
										width:138px;
									}
						
									a.button_container span.BuyNow
									{
										background-image:url('/assets/common/images/content/htc_m8/htc_btn_sprite_BuyNow.png');
										background-repeat:no-repeat;
										background-position:0px -0px;
									}
						
									a.button_container span.BuyNow:hover
									{
										background-image:url('/assets/common/images/content/htc_m8/htc_btn_sprite_BuyNow.png');
										background-repeat:no-repeat;
										background-position:0px -50px;
									}
						
									a.button_container span.BuyNow:active
									{
										background-image:url('/assets/common/images/content/htc_m8/htc_btn_sprite_BuyNow.png');
										background-repeat:no-repeat;
										background-position:0px -100px;
									}
						
				.rowLegal
				{
					color:#808285;
					font-size:8px;
					margin-top:30px;
				}
</style>

	<div class="htcLandingPage">
		<!---<div class="htcBackgroundShort">
		</div>--->
		<div class="htcBackground">
			<div class="backgroundImage_aafes">
				<div class="imageButton">
					<a class="button_container" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=AAFESmobile&utm_medium=banner_btn&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8"> <!--- Link to HTC One m8 device details page --->
						<span class="BuyNow"></span>
					</a>
				</div>
			</div>
			<div class="backgroundImage_costco">
				<div class="imageButton">
					<a class="button_container" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=membershipWireless&utm_medium=banner_btn&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8"> <!--- Link to HTC One m8 device details page --->
						<span class="BuyNow"></span>
					</a>
				</div>
			</div>
		</div>
		
		<div class="htcDetails">
			<div class="detailsRow" style="margin-bottom:50px;">
				<div class="rowTitle">
					<div class="titleContent">
						<div class="contentMasthead">
							The all new HTC One is as beautiful to look at as it is to hold.
						</div>
						<div class="contentSubhead">
							Available from
						</div>
						<div class="contentLogos_costco"> <!--- These carrier logos link to Phone lists of available devices for a specific carrier --->
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,434/index?utm_source=membershipwireless&utm_medium=landing_page_carrierLogo&utm_term=PhonesList&utm_content=att&utm_campaign=HTC_One_m8"><span class="logosATT"></span></a>
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,434/index?utm_source=membershipwireless&utm_medium=landing_page_carrierLogo&utm_term=PhonesList&utm_content=vzw&utm_campaign=HTC_One_m8"><span class="logosVZW"></span></a>
							<!---<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,434/index?utm_source=membershipwireless&utm_medium=landing_page_carrierLogo&utm_term=PhonesList&utm_content=tmo&utm_campaign=HTC_One_m8"><span class="logosTMO"></span></a>--->
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,434/index?utm_source=membershipwireless&utm_medium=landing_page_carrierLogo&utm_term=PhonesList&utm_content=sprint&utm_campaign=HTC_One_m8"><span class="logosSprint"></span></a>
						</div>
						<div class="contentLogos_aafes"> <!--- These carrier logos link to Phone lists of available devices for a specific carrier --->
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,434/index?utm_source=AAFESmobile&utm_medium=landing_page_carrierLogo&utm_term=PhonesList&utm_content=att&utm_campaign=HTC_One_m8"><span class="logosATT"></span></a>
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,434/index?utm_source=AAFESmobile&utm_medium=landing_page_carrierLogo&utm_term=PhonesList&utm_content=vzw&utm_campaign=HTC_One_m8"><span class="logosVZW"></span></a>
							<!---<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,434/index?utm_source=AAFESmobile&utm_medium=landing_page_carrierLogo&utm_term=PhonesList&utm_content=tmo&utm_campaign=HTC_One_m8"><span class="logosTMO"></span></a>--->
						</div>
					</div>
				</div>
				<div class="rowContent">
					<div class="contentPhones_aafes"> <!--- ***** Device images and links for AAFES ***** --->
						<div class="phonesImage_left">
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=AAFESmobile&utm_medium=phone_image&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_gray"> <!--- Link to HTC One m8 device details page --->
								<span class="imageLeft"></span>
							</a>
							<div class="imageTitle">HTC One (m8)<br />Gunmetal Gray</div>
							<div class="imageButton">
								<a class="button_container" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=AAFESmobile&utm_medium=image_button&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_gray"> <!--- Link to HTC One m8 device details page --->
									<span class="BuyNow"></span>
								</a>
							</div>
						</div>
						<div class="phonesImage_right">
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=AAFESmobile&utm_medium=phone_image&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_silver"> <!--- Link to HTC One m8 device details page --->
								<span class="imageRight"></span>
							</a>
							<div class="imageTitle">HTC One (m8)<br />Glacial Silver</div>
							<div class="imageButton">
								<a class="button_container" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=AAFESmobile&utm_medium=image_button&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_silver"> <!--- Link to HTC One m8 device details page --->
									<span class="BuyNow"></span>
								</a>
							</div>
						</div>
					</div>
					<div class="contentPhones_costco"> <!--- ***** Device images and links for Costco ***** --->
						<div class="phonesImage_left">
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=membershipwireless&utm_medium=phone_image&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_gray"> <!--- Link to HTC One m8 device details page --->
								<span class="imageLeft"></span>
							</a>
							<div class="imageTitle">HTC One (m8)<br />Gunmetal Gray</div>
							<div class="imageButton">
								<a class="button_container" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=membershipwireless&utm_medium=image_button&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_gray"> <!--- Link to HTC One m8 device details page --->
									<span class="BuyNow"></span>
								</a>
							</div>
						</div>
						<div class="phonesImage_right">
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=membershipwireless&utm_medium=phone_image&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_silver"> <!--- Link to HTC One m8 device details page --->
								<span class="imageRight"></span>
							</a>
							<div class="imageTitle">HTC One (m8)<br />Glacial Silver</div>
							<div class="imageButton">
								<a class="button_container" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,434/index?utm_source=membershipwireless&utm_medium=image_button&utm_term=PhonesList&utm_content=all_carrier&utm_campaign=HTC_One_m8_silver"> <!--- Link to HTC One m8 device details page --->
									<span class="BuyNow"></span>
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="detailsRow right">
				<div class="rowImage">
					<div class="imageCamera"></div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleHeader">
							Key Features
						</div>
					</div>
					<div class="contentTitle">
						<div class="titleText">
							HTC DUO CAMERA<br />with Ultrapixels
						</div>
					</div>
					<div class="contentBlock">
						<p>Take brilliant day or night time shots with the HTC Duo camera. Add pro effects effortlessly, 
						automatically make mini movies in seconds, or flip to the 5MP front camera for the perfect selfie.</p>
					</div>
				</div>
			</div>
			
			<div class="detailsRow left">
				<div class="rowImage">
					<div class="imageSound"></div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleText">
							HTC BOOMSOUND&trade;<br />Really big sound
						</div>
					</div>
					<div class="contentBlock">
						<p>Bring your  music and movies to life with two stereo speakers cleverly placed on the front of the 
						phone that combine with dedicated amplifiers to deliver clear, balanced, powerful sound.</p>
					</div>
				</div>
			</div>
			
			<div class="detailsRow right" style="padding-top:50px;">
				<div class="rowImage">
					<div class="imageBlinkFeed"></div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleText">
							HTC BLINKFEED&trade;
						</div>
					</div>
					<div class="contentBlock">
						<p>Fill your home screen with all your favorite content from newsfeeds and social media pages. Updated 
						on demand. It's like a new magazine designed especially for you, every day.</p>
					</div>
				</div>
			</div>
			
			<div class="detailsRow left" style="padding-bottom:30px;">
				<div class="rowImage">
					<div class="imageAdvantages"></div>
				</div>
				<div class="rowContent">
					<div class="contentTitle">
						<div class="titleText">
							When you buy HTC, you're buying the best.
						</div>
					</div>
					<div class="contentBlock">
						<p>With high-end design, the most useful experiences, and now the additional value HTC gives you over 
						the life of the device, it's truly the most premium smartphone experience you can buy.</p>
						<p><a href="http://htc.com/advantage" target="_blank">htc.com/advantage</a></p>
					</div>
				</div>
			</div>
			
			<div class="detailsRowLast">
				<div class="rowLegal">
					<p>&copy; 2014 HTC Corporation. All rights reserved. HTC and HTC names herein are the trademarks of HTC Corporation.</p> 
				</div>
			</div>
		</div>
	</div>
	
