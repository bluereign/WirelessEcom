<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<cfsavecontent variable="headerContent" >
	<cfoutput>
		<link href="#assetPaths.common#scripts/videojs/video-js.css" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="#assetPaths.common#scripts/bxslider/bx_styles/bx_styles.css" type="text/css" media="screen" />
		
		<script src="#assetPaths.common#scripts/videojs/video.js"></script>	
		<script src="#assetPaths.common#scripts/libs/jquery.bxSlider.min.js" language="javascript" type="text/javascript"></script>
	
		<!-- Unless using the CDN hosted version, update the URL to the Flash SWF -->
		<script>
			_V_.options.flash.swf = "#assetPaths.common#scripts/videojs/video-js.swf";
		</script>
		
		<script language="javascript" type="text/javascript">
			
			jQuery(document).ready(function() {
				
			    var marketingSlider = jQuery('##MarketingSlider').bxSlider({
					infiniteLoop: false,
					controls: false,
					pager: true,
					startingSlide: 0
			    });
				
			    var videoSlider = jQuery('##VideoSlider').bxSlider({
					infiniteLoop: false,
					controls: false,
					pager: false,
					startingSlide: 0
			    });
	
				// assign a click event to the external thumbnails
				jQuery('.thumbs a').click(function(){
					var thumbIndex = jQuery('.thumbs a').index(this);
					// call the "goToSlide" public function
					videoSlider.goToSlide(thumbIndex);
					
					// remove all active classes
					jQuery('.thumbs a').removeClass('pager-active');
					// assisgn "pager-active" to clicked thumb
					jQuery(this).addClass('pager-active');
					// very important! you must kill the links default behavior
					return false;
				});
				
				// assign "pager-active" class to the first thumb
				jQuery('.thumbs a:first').addClass('pager-active');
	
			});
		</script>
	</cfoutput>
</cfsavecontent>


<cfhtmlhead text="#headerContent#" />

<style type="text/css">
	h1.windows8 {
		font-size: 32px;
		color: #00bcf2;
		margin: 25px;
	}
	
	.row-container {
		width:auto; 
		text-align: center;
		/*
border: 1px red solid;
*/
	}

	.product-list-container {
		width: 760px;
		margin: 0px auto;
	}
	
	.product-container {
		width: 170px;
		font-size: 12px;
		color: #666;
		margin-left: 141px;
		float: left;
	}

	.product-container a:link 
	, .product-container a:visited {
		color: #ff8800;
		text-decoration: none;
	}
	
	.product-container a:hover {
		color: #ff8800;
		text-decoration: underline;
	}	
	
	.product-header {
		font-size: 18px;
		color: #ff8800;
		text-decoration: none;
	}

	.product-button {
		margin-top: 10px;
		border: 0;
	}
	
	#MarketingSlider {
		width: 750px;
		height: 350px;
		margin: 0px auto;
	}

	#VideoSlider {
		width: 750px;
		height: 350px;
		margin: 0px auto;
	}
	
	.bx-wrapper {
		margin: 0px auto;
		margin-bottom: 15px;
	}
</style>
<cfoutput>
	<!--- Header --->
	<div class="row-container">
		<img src="#assetPaths.common#images/content/windows8/head_banner.jpg" />
	</div>
	<div style="clear:all;"></div>
	
	<!--- Title Bar --->
	<div class="row-container">
		<h1 class="windows8">Why you'll love the new Windows Phone</h1>
	</div>
	<div style="clear:both"></div>
	
	<!--- Slider --->
	<div class="row-container">
	
		<div id="MarketingSlider">
			<div>
				<img src="#assetPaths.common#images/content/windows8/slides/slide1.jpg" />
			</div>
			<div>
				<img src="#assetPaths.common#images/content/windows8/slides/slide2.jpg" />
			</div>
			<div>
				<img src="#assetPaths.common#images/content/windows8/slides/slide3.jpg" />
			</div>
			<div>
				<img src="#assetPaths.common#images/content/windows8/slides/slide4.jpg" />
			</div>
			<div>
				<img src="#assetPaths.common#images/content/windows8/slides/slide5.jpg" />
			</div>		
		</div>
		
	</div>
	<div style="clear:both"></div>
	
	<!--- Title Bar --->
	<div class="row-container">
		<h1 class="windows8">Explore new Windows Phone Devices</h1>
	</div>
	<div style="clear:both"></div>
	
	<!--- Product List --->
	<div class="row-container">
		
		<div class="product-list-container">
			<div class="product-container">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,400/index?utm_source=membershipWireless&utm_medium=WinPhone_LandingPage&utm_campaign=NokiaLumia1020_att">
					<img src="#assetPaths.common#images/content/windows8/phones/Lumia1020.png" alt="Nokia Lumia 1020" title="Nokia Lumia 1020" border="0" />
				</a>
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,400/index?utm_source=membershipWireless&utm_medium=WinPhone_LandingPage&utm_campaign=NokiaLumia1020_att">
					<h2 class="product-header">Nokia<br />Lumia 1020</h2>
				</a>			
				4G LTE Blazing Fast Windows&copy; Phone
				<br />
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,400/index?utm_source=membershipWireless&utm_medium=WinPhone_LandingPage&utm_campaign=NokiaLumia1020_att">
					<img class="product-button" src="#assetPaths.common#images/content/windows8/buy_button.jpg" />			
				</a>
			</div>
			<div class="product-container">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,399/index?utm_source=membershipWireless&utm_medium=WinPhone_LandingPage&utm_campaign=NokiaLumia928_vzw">
					<img src="#assetPaths.common#images/content/windows8/phones/Lumia928.png" alt="Nokia Lumia 928" title="Nokia Lumia 928" border="0" />
				</a>
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,399/index?utm_source=membershipWireless&utm_medium=WinPhone_LandingPage&utm_campaign=NokiaLumia928_vzw">
					<h2 class="product-header">Nokia<br />Lumia 928</h2>
				</a>
				4G LTE Blazing Fast Windows&copy; Phone
				<br />
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,399/index?utm_source=membershipWireless&utm_medium=WinPhone_LandingPage&utm_campaign=NokiaLumia928_vzw">
					<img class="product-button" src="#assetPaths.common#images/content/windows8/buy_button.jpg" />
				</a>
			</div>	
			<div style="clear:both;"></div>
		</div>
		
	</div>
	<div style="clear:all;"></div>
	
	<!--- Title Bar --->
	<div class="row-container">
		<h1 class="windows8">See Windows Phone in action</h1>
	</div>
	<div style="clear:both"></div>
	
	<!--- Video --->
	<div class="row-container">
		
		<div id="VideoSlider">
			<div>
				<video id="video-player-1" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
					   poster="#assetPaths.common#images/content/windows8/videos/attract_loop_poster.jpg" width="740" height="420">
					<source src="/media/videos/content/windows8/VO_AttractLoop.mp4" type='video/mp4' />
					<source src="/media/videos/content/windows8/VO_AttractLoop.webm" type='video/webm' />
					<source src="/media/videos/content/windows8/VO_AttractLoop.ogv" type='video/ogg' />
					<track kind="captions" src="captions.vtt" srclang="en" label="English" />
				</video>		
			</div>
			<div>
				<video id="video-player-2" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
					   poster="#assetPaths.common#images/content/windows8/videos/ltla_poster.jpg" width="740" height="420">
					<source src="/media/videos/content/windows8/VO_LTLA.mp4" type='video/mp4' />
					<source src="/media/videos/content/windows8/VO_LTLA.webm" type='video/webm' />
					<source src="/media/videos/content/windows8/VO_LTLA.ogv" type='video/ogg' />
					<track kind="captions" src="captions.vtt" srclang="en" label="English" />
				</video>		
			</div>
			<div>
				<video id="video-player-3" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
					   poster="#assetPaths.common#images/content/windows8/videos/people_hub_poster.jpg" width="740" height="420">
					<source src="/media/videos/content/windows8/VO_PeopleHub.mp4" type='video/mp4' />
					<source src="/media/videos/content/windows8/VO_PeopleHub.webm" type='video/webm' />
					<source src="/media/videos/content/windows8/VO_PeopleHub.ogv" type='video/ogg' />
					<track kind="captions" src="captions.vtt" srclang="en" label="English" />
				</video>		
			</div>
			<div>
				<video id="video-player-4" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
					   poster="#assetPaths.common#images/content/windows8/videos/sky_drive_poster.jpg" width="740" height="420">
					<source src="/media/videos/content/windows8/VO_SkyDrive.mp4" type='video/mp4' />
					<source src="/media/videos/content/windows8/VO_SkyDrive.webm" type='video/webm' />
					<source src="/media/videos/content/windows8/VO_SkyDrive.ogv" type='video/ogg' />
					<track kind="captions" src="captions.vtt" srclang="en" label="English" />
				</video>		
			</div>
		</div>	
		<div class="thumbs">
			<a href=""><img src="#assetPaths.common#images/content/windows8/videos/attract_loop_thumb.jpg" /></a>
			<a href=""><img src="#assetPaths.common#images/content/windows8/videos/ltla_thumb.jpg" /></a>
			<a href=""><img src="#assetPaths.common#images/content/windows8/videos/people_hub_thumb.jpg" /></a>
			<a href=""><img src="#assetPaths.common#images/content/windows8/videos/sky_drive_thumb.jpg" /></a>
		</div>
	</div>
	<div style="clear:both"></div>
</cfoutput>