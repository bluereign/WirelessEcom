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

<cfoutput>
	<style type="text/css">
		##wrapper {
			width: 765px;
			margin: auto;
		}
		
		h1.blackberry10 {
			font-size: 32px;
			color: ##222;
			margin: 25px 0 25px 25px;;
			text-align: left;
			font-family: Slate,sans-serif;
			text-indent: -10000px;
		}
		
		##meet-bb-header {
			background: url('#assetPaths.common#images/content/blackberry10/meet_the_new_blackberry.png') no-repeat;
			height: 80px;
		}
	
		##highlights-header {
			background: url('#assetPaths.common#images/content/blackberry10/highlights.png') no-repeat;
		}
		
		##features-header {
			background: url('#assetPaths.common#images/content/blackberry10/features.png') no-repeat;
		}		
		
		.row-container {
			margin: auto;
		}
	
		.product-list-container {
			width: 700px;
			margin: 0px auto;
			text-align: center;
		}
		
		.product-container {
			width: 325px;
			font-size: 12px;
			color: ##666;
			margin-left: 10px;
			float: left;
		}
	
		.product-container a:link {
			text-decoration: none;
		}
		
		.product-container a:hover {
			color: ##222;
			text-decoration: underline;
		}	
		
		.product-header {
			font-size: 18px;
			color: ##222;
			text-decoration: none;
		}
	
		.product-button {
			margin-top: 10px;
			border: 0;
		}
		
		##MarketingSlider {
			width: 750px;
			height: 350px;
			margin: 0px auto;
		}
	
		##VideoSlider {
			width: 750px;
			height: 350px;
			margin: 0px auto;
		}
		
		.bx-wrapper {
			margin: 0px auto;
			margin-bottom: 15px;
		}
		
	
	
		ul.highlights {
			margin: auto;
			width: 900px;
		}
		
		ul.highlights li {
		    display: inline;
			float:left;
			margin: 5px 25px;
			height: 320px;
			width: 300px;
			color: ##222;
		}
	
		ul.highlights li img {
			float: right;
			margin-left: 15px;
		}
	
		ul.highlights li span {
			font-size: 24px;
		}
	
		ul.features {
			margin: auto;
			width: 815px;
		}
		
		ul.features li {
		    display: inline;
		    float: left;
			margin: 5px 10px;
			width: 239px;
			font-size: 9px;
			height: 175px;
		}	
	</style>
	
	<div id="wrapper">
		<!--- Header --->
		<div class="row-container" style="padding-top: 10px; width:765px;">
			<img src="#assetPaths.common#images/content/blackberry10/Blackberry_home_banner.jpg" />
		</div>
		
		<!--- Title Bar --->	
		<h1 id="meet-bb-header" class="blackberry10">MEET THE NEW BLACKBERRY</h1>
		
		<!--- Product List --->
		<div class="row-container">
			
			<div class="product-list-container">
				<div class="product-container">
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,398/index?utm_source=common_aafes-costco&utm_medium=landing_page&utm_term=phone_image&utm_content=all_carriers&utm_campaign=BlackBerry_Q10">
						<img src="#assetPaths.common#images/content/blackberry10/BB_Q10_BLACK_Front-phone.png" alt="BlackBerry Q10" title="BlackBerry Q10" border="0" />
					</a>
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,398/index?utm_source=common_aafes-costco&utm_medium=landing_page&utm_term=phone_name&utm_content=all_carriers&utm_campaign=BlackBerry_Q10">
						<h2 class="product-header">BLACKBERRY<br />Q10</h2>
					</a>
					Do More,<br />
					every day.
					<br />
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,398/index?utm_source=common_aafes-costco&utm_medium=landing_page&utm_term=buy_now_button&utm_content=all_carriers&utm_campaign=BlackBerry_Q10">
						<img class="product-button" src="#assetPaths.common#images/content/blackberry10/buyNow_btn.png" />
					</a>
				</div>

				<div class="product-container">
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,370/index?utm_source=common_aafes-costco&utm_medium=landing_page&utm_term=phone_image&utm_content=all_carriers&utm_campaign=BlackBerry_Z10">
						<img src="#assetPaths.common#images/content/blackberry10/Z10.png" alt="BlackBerry Z10" title="BlackBerry Z10" border="0" />
					</a>
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,370/index?utm_source=common_aafes-costco&utm_medium=landing_page&utm_term=phone_name&utm_content=all_carriers&utm_campaign=BlackBerry_Z10">
						<h2 class="product-header">BLACKBERRY<br />Z10</h2>
					</a>
					Intelligent, intuitive,<br />
					and totally reinvented.
					<br />
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,370/index?utm_source=common_aafes-costco&utm_medium=landing_page&utm_term=buy_now_button&utm_content=all_carriers&utm_campaign=BlackBerry_Z10">
						<img class="product-button" src="#assetPaths.common#images/content/blackberry10/buyNow_btn.png" />
					</a>
				</div>
	
				<div style="clear:both;"></div>
			</div>
		</div>
		
		<h1 id="highlights-header" class="blackberry10">HIGHLIGHTS</h1>
		
		<ul class="highlights">
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/phone_hub.png" />
				<span>BlackBerry Hub</span>
				<p>Peek into the BlackBerry&copy; Hub from any app, to see your messages and conversations.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/phone_keyboard.png" />
				<span>BlackBerry Keyboard</span>
				<p>Type faster and move more accurately on a touchscreen keyboard that learns how you write.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/phone_screen_share.png" />
				<span>BBM Video with Screen Share</span>
				<p>Catch up face-to-face and share what's on your screen with BBM&trade; Video with Screen Share.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/phone_time_shift.png" />
				<span>Camera with Time Shift Mode</span>
				<p>Create the perfect shot by moving parts of your picture backwards and forwards in time.</p>
			</li>
		</ul>
		
		<div style="clear:both;"></div>
		<h1 id="features-header" class="blackberry10">FEATURES</h1>
		
		<ul class="features">
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_remember.jpg" />
				<p>Group your interests, ideas and projects in one handy location.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_balance.jpg" />
				<p>Take your BlackBerry&copy; Z10&trade; to the office - BlackBerry&copy; Balance keeps your professional and private information separate.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_calendar.jpg" />
				<p>Spend less time managing schedules and tasks - let BlackBerry&copy; Calendar handle the details for you.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_browsing.jpg" />
				<p>Discover more, share more - with web pages that load incredibly fast, render beautifully and make sharing on social networks a breeze.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_security.jpg" />
				<p>Stay worry free with the renowned BlackBerry security you know and trust.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_sharing.jpg" />
				<p>BlackBerry&copy; Tag with NFC technology makes exchanging data easier than ever.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_voice.jpg" />
				<p>Send a BBM&trade; message, schedule a meeting or update Facebook - using voice alone.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_editing.jpg" />
				<p>Crop, enhance and style your photos - then share in an instant.</p>
			</li>
			<li>
				<img src="#assetPaths.common#images/content/blackberry10/bb_display.jpg" />
				<p>Sleek, sharp and responsive - see life in brilliant detail.</p>
			</li>		
		</ul>
		
		
		<h1 class="blackberry10">EXPERIENCE THE <br />NEW BLACKBERRY</h1>
		
		<!--- Video --->
		<div class="row-container">
			
			<div id="VideoSlider">
				<div>
					<video id="video-player-1" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
						   poster="#assetPaths.common#images/content/blackberry10/videos/BlackBerry_10_ BlackBerry Keyboard Close-up_small_x264.png" width="740" height="420">
						<source src="/media/videos/content/blackberry10/BlackBerry_10_ BlackBerry Keyboard Close-up_small_x264.mp4" type='video/mp4' />
						<source src="/media/videos/content/blackberry10/BlackBerry_10_ BlackBerry Keyboard Close-up_small_x264.webm" type='video/webm' />
						<source src="/media/videos/content/blackberry10/BlackBerry_10_ BlackBerry Keyboard Close-up_small_x264.ogv" type='video/ogg' />
						<track kind="captions" src="captions.vtt" srclang="en" label="English" />
					</video>		
				</div>
				<div>
					<video id="video-player-2" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
						   poster="#assetPaths.common#images/content/blackberry10/videos/BlackBerry_10_BlackBerry_Browser_x264.png" width="740" height="420">
						<source src="/media/videos/content/blackberry10/BlackBerry_10_BlackBerry_Browser_x264.mp4" type='video/mp4' />
						<source src="/media/videos/content/blackberry10/BlackBerry_10_BlackBerry_Browser_x264.webm" type='video/webm' />
						<source src="/media/videos/content/blackberry10/BlackBerry_10_BlackBerry_Browser_x264.ogv" type='video/ogg' />
						<track kind="captions" src="captions.vtt" srclang="en" label="English" />
					</video>		
				</div>
				<div>
					<video id="video-player-3" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
						   poster="#assetPaths.common#images/content/blackberry10/videos/BlackBerry_10_BlackBerry_Remember_small_x264.png" width="740" height="420">
						<source src="/media/videos/content/blackberry10/BlackBerry_10_BlackBerry_Remember_small_x264.mp4" type='video/mp4' />
						<source src="/media/videos/content/blackberry10/BlackBerry_10_BlackBerry_Remember_small_x264.webm" type='video/webm' />
						<source src="/media/videos/content/blackberry10/BlackBerry_10_BlackBerry_Remember_small_x264.ogv" type='video/ogg' />
						<track kind="captions" src="captions.vtt" srclang="en" label="English" />
					</video>		
				</div>
				<div>
					<video id="video-player-4" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
						   poster="#assetPaths.common#images/content/blackberry10/videos/BlackBerry_Z10_Camera_Time_Shift_Mode_small_x264.png" width="740" height="420">
						<source src="/media/videos/content/blackberry10/BlackBerry_Z10_Camera_Time_Shift_Mode_small_x264.mp4" type='video/mp4' />
						<source src="/media/videos/content/blackberry10/BlackBerry_Z10_Camera_Time_Shift_Mode_small_x264.webm" type='video/webm' />
						<source src="/media/videos/content/blackberry10/BlackBerry_Z10_Camera_Time_Shift_Mode_small_x264.ogv" type='video/ogg' />
						<track kind="captions" src="captions.vtt" srclang="en" label="English" />
					</video>		
				</div>
				<div>
					<video id="video-player-5" class="video-js vjs-default-skin" controls preload="none" data-setup="{}"
						   poster="#assetPaths.common#images/content/blackberry10/videos/BlackBerry_Z10_Keep_Moving_Commercial_small_x264.png" width="740" height="420">
						<source src="/media/videos/content/blackberry10/BlackBerry_Z10_Keep_Moving_Commercial_small_x264.mp4" type='video/mp4' />
						<source src="/media/videos/content/blackberry10/BlackBerry_Z10_Keep_Moving_Commercial_small_x264.webm" type='video/webm' />
						<source src="/media/videos/content/blackberry10/BlackBerry_Z10_Keep_Moving_Commercial_small_x264.ogv" type='video/ogg' />
						<track kind="captions" src="captions.vtt" srclang="en" label="English" />
					</video>		
				</div>			
			</div>	
			<div class="thumbs">
				<a href=""><img src="#assetPaths.common#images/content/blackberry10/videos/thumb-BlackBerry_10_ BlackBerry Keyboard Close-up_small_x264.png" /></a>
				<a href=""><img src="#assetPaths.common#images/content/blackberry10/videos/thumb-BlackBerry_10_BlackBerry_Browser_x264.png" /></a>
				<a href=""><img src="#assetPaths.common#images/content/blackberry10/videos/thumb-BlackBerry_10_BlackBerry_Remember_small_x264.png" /></a>
				<a href=""><img src="#assetPaths.common#images/content/blackberry10/videos/thumb-BlackBerry_Z10_Camera_Time_Shift_Mode_small_x264.png" /></a>
				<a href=""><img src="#assetPaths.common#images/content/blackberry10/videos/thumb-BlackBerry_Z10_Keep_Moving_Commercial_small_x264.png" /></a>
			</div>
		</div>
		<div style="clear:both"></div>
	</div>
</cfoutput>