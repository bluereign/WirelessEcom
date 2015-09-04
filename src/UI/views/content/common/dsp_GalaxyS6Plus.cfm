<!---Samsung Galaxy S6+ landing page--->

<!---<html class="no-js">--->
<head>
    <meta charset="utf-8">
    <title></title>

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width,initial-scale=1">


    <script type="text/javascript">
      if (!window.console) window.console = {};
      if (!window.console.log) window.console.log = function () { };
    </script>

    <link href="/assets/common/images/content/note5/css/style.min.css" rel="stylesheet">
    <link href="http://vjs.zencdn.net/4.12/video-js.css" rel="stylesheet">

    <script src="/assets/common/images/content/note5/components/modernizr/modernizr.js"></script>

    <style>
		.contentText > em
		{
			font-size: 14px;
			font-weight: bold;
			margin-left: 12px;
		}
		
		.contentText > input
		{
			width: 225px;
		}

		.contentText > select {}
		
		.contentText > input, .contentText > select {
		    -webkit-box-sizing: border-box;
		    -moz-box-sizing: border-box;
		    box-sizing: border-box;  
			border: 1px solid rgba(0, 0, 0, 0.85);
			font-size: 16px;
			height: 34px;
			line-height: normal;
			background-color: #fff;
			/*margin-bottom: 20px;*/
			/*border-radius: 5px;*/
			padding: 5px 5px;
		}
    	
    	/*.aafesmobile .blockButton_aafes,
    	.membershipwireless .blockButton_costco
    	{
    		display:block;
    	}
    	
    	.aafesmobile .blockButton_costco,
    	.membershipwireless .blockButton_aafes
    	{
    		display:none;
    	}*/
    	
    </style>


<cfoutput>
	<script src="#prc.assetPaths.common#scripts/libs/jquery.validate.min.js"></script>
	<script src="#prc.assetPaths.common#scripts/libs/jquery.placeholder.js"></script>
</cfoutput>

<script>
	var ss= jQuery.noConflict();
//	jQuery.noConflict();
	ss(document).ready(function($) {

		//Set validation plugin defaults
		ss.validator.setDefaults({
		   ignore: ".ignore"
		   , errorElement: "em"
		});
		
		ss('#email').placeholder();
	});

	function ValidateNotificationForm()
	{
		var validator = ss("#notificationform").validate();

		if ( ss("#notificationform").valid() )
		{
			ss('#notificationform').submit();
		}

		return false;
	}
</script>
</head>


<cfoutput>
<body>
<form id="notificationform" action="/notification/RegisterPresaleAlert/" method="post">
<input type="hidden"  name="pageURL" id="pageURL" value='#CGI.SERVER_NAME & CGI.PATH_INFO#'> 
<div  id="main" data-hero="zero" class="zero-landing-page">
  <div class="content clear 360zero ">
    <div class="content-container clear">
      <div class="content-image content-left">
          <div id="hero_container">
            <div id="hero_imgHolder" style="background: url('/assets/common/images/content/note5/images/zero/360Grid.png') no-repeat;"></div>
            <span id="replay" class="disabled"></span>
          </div>
          <div class="fallback">
            <img srcset="/assets/common/images/content/note5/images/zero/hero-sm.png" alt="Samsung S6 Edge">
          </div>
      </div>
  
  
        <div class="content-description content-right clear ">
          <div class="content-description-container">
            <h2 class="content-description-headline">The&nbsp;next big&nbsp;thing</h2>
            <h2 class="content-description-sub-headline">is almost here</h2>
              <img class="content-description-image" src="/assets/common/images/content/note5/images/zero/logo.png" alt="Samsung" />
              <!-- hero thumbnail -->
                <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">
                  <img class="content-description-image" src="/assets/common/images/content/note5/images/zero/video-thumb.png" alt="" />
                </a>--->
  
            <p>The Samsung Galaxy S6 edge+ gives you an entertainment experience unlike any other. Explore how the features take gaming, movies, photos, music &amp; more to the next level.</p>

				<!--- This content adds in the carrier dropdown and email box  --->
				<div class="gs6Content" style="margin-top:-10px;">
					<div class="contentText" style="margin-bottom:10px;">
						<select name="campaignId" required>
							<option value="" <cfif rc.CampaignId eq ''>selected</cfif>>Select your carrier</option>
							<option value="5" <cfif rc.CampaignId eq '5'>selected</cfif>>AT&T</option>
							<cfif application.model.Carrier.isEnabled(299)>
								<option value="7" <cfif rc.CampaignId eq '7'>selected</cfif>>Sprint</option>
							</cfif>
							<option value="6" <cfif rc.CampaignId eq '6'>selected</cfif>>T-Mobile</option>
							<option value="8" <cfif rc.CampaignId eq '8'>selected</cfif>>Verizon Wireless</option>
						</select>
					</div>
					<div class="contentText" style="margin-bottom:20px;">
						<input id="email" type="email" name="email" value="#rc.Email#" maxlength="50" placeholder="Enter your email address" required>
					</div>
					<div class="contentButton" style="clear:both;">
						<div class="buttonContainer" style="margin-bottom:10px;">
							<div class="blockButton">
								<a class="button" href="##" onClick="ValidateNotificationForm(); return false;" >
									<span class="PreOrder">Pre-Register Now</span>
								</a>
							</div>
						</div>	
						<!---<span class="buttonLegal" style="font-size:.6em;">This device has not been authorized as required by the rules of the Federal 
						Communications Commission. This device is not, and may not be, offered for sale or lease, or sold or 
						leased, until authorization is obtained.</span>--->
					</div>
				</div>
  
              <!---<a href="#" class="button">Pre-Order Now</a>--->
  
  
          </div>
        </div>
      </div>
  </div>
  
  
      <div class="content clear  content--lifestyle">
        <div class="content-container clear">
          <div class="content-image content-left">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/zero/lifestyle/display.jpg" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/zero/lifestyle/display-sm.jpg" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Display</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Your favorite tunes have never sounded better on a Samsung smartphone. This breakthrough audio technology can take select music files and enhance the richness and detail<sup>1</sup>.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
      
      
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  ">
        <div class="content-container clear">
              <div class="content-image content-right">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/zero/lifestyle/edge-ux.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/zero/lifestyle/edge-ux-sm.png" alt="Samsung S6 Edge">
                </picture>
              </div>
      
            <div class="content-description content-left clear">
              <div class="content-description-container">
                <h2 class="content-description-headline">Edge UX</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Keep your top five contacts and apps at your fingertips for quick access. Always see who&##39;s contacting you with a discreet light-up notification on the edge screen.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  content--lifestyle">
        <div class="content-container clear">
          <div class="content-image content-left">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/zero/lifestyle/live-video.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/zero/lifestyle/live-video-sm.png" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Live Broadcast</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Share life&##39;s can&##39;t-miss moments with your friends as they happen. Take live video and broadcast it via YouTube<sup>TM</sup> with this built-in app.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
      
      
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  ">
        <div class="content-container clear">
          <div class="content-image content-left">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/zero/lifestyle/ultra-high.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/zero/lifestyle/ultra-high-sm.png" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Ultra-High-Quality Audio</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Your favorite tunes have never sounded better on a Samsung smartphone. This breakthrough audio technology can take select music files and enhance the richness and detail<sup>1</sup>.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
      
      
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  content--lifestyle-thin">
        <div class="content-container clear">
              <div class="content-image content-right">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/zero/lifestyle/camera.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/zero/lifestyle/camera-sm.png" alt="Samsung S6 Edge">
                </picture>
              </div>
      
            <div class="content-description content-left clear">
              <div class="content-description-container">
                <h2 class="content-description-headline">Camera</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Featuring a 16MP rear-facing camera, take sharper, clearer photos with features like image stabilization and a low-light sensor<sup>2</sup>. And take wide-angle selfies with the 5MP front-facing camera.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  ">
        <div class="content-container clear">
          <div class="content-image content-left">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/zero/lifestyle/pay.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/zero/lifestyle/pay-sm.png" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Samsung Pay</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Samsung Pay works virtually anywhere you can swipe a card<sup>3</sup>. From the local grocery store to the corner caf&eacute;, it&##39;s easy to pay with your device.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
      
      
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  content--lifestyle">
        <div class="content-container clear">
          <div class="content-image content-left">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/zero/lifestyle/battery-knox.jpg" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/zero/lifestyle/battery-knox-sm.jpg" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear content-description--left-override">
              <div class="content-description-container">
                <h2 class="content-description-headline">Battery</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>With the 3,000mAh battery, you have the power to get through your day. Plus you can recharge wirelessly<sup>4</sup>, power up quickly<sup>5</sup> or even use Ultra Power Saving Mode to extend your text and talk time<sup>6</sup>.</p>
      
      
                    <h2 class="content-description-headline">Samsung Knox</h2>
                    <p>Defense-grade Samsung Knox security, featuring a separate personal and work partitioning container, protects your sensitive data.</p>
      
              </div>
            </div>
          </div>
      </div>
      
      <div class="content content--full">
        <div class="content-container clear">
          <h2>The next big thing</h2>
          <h2>is almost here</h2>
          <img class="content-description-image" src="/assets/common/images/content/note5/images/zero/logo.png" alt="Samsung" />

				<!--- This content adds in the carrier dropdown and email box  --->
				
        </div>
      </div>
  
  <div class="disclaimer">
  	<p class="legal"><sup>1</sup>Works on most music stored on device (e.g. MP3s) and on leading streaming multimedia services (e.g. Pandora, YouTube, Play Music, etc) with more services added after launch. (See <a href='http://www.samsung.com' target='_blank'>www.samsung.com</a> for current list.) For all music, degree of upscaling depends on various factors including quality of original file. For best results, use high-quality wired headphones. For best results with wireless headphones, use compatible Samsung Level headphones. Your experience may vary based on personal hearing range.</p><p class="legal"><sup>2</sup>Compared to Samsung devices without image stabilization and a low-light sensor.</p><p class="legal"><sup>3</sup>Service will be available Fall 2015. Contact your bank or financial institution to verify supported cards.</p><p class="legal"><sup>4</sup>Wireless charging pad sold separately.</p><p class="legal"><sup>5</sup>Fast Charging requires an AFC-compatible charger to work.</p><p class="legal"><sup>6</sup>Battery power consumption depends on factors such as network configuration, carrier network, signal strength, operating temperature, features selected, vibrate mode, backlight settings, browser use, frequency of calls, and voice, data and other application-usage patterns.</p>
  	<p class = "copywright">&copy; 2015 Samsung Electronics America Inc. Samsung, Samsung Galaxy, Galaxy S, Super AMOLED, Samsung Pay, Samsung Knox and The Next Big Thing Is Here are all trademarks of Samsung Electronics Co., Ltd. Other company and product names mentioned may be trademarks of their respective owners. Screen images simulated. Appearance of device may vary. Contact bank or financial institution to verify that it is a Samsung Pay participant. Samsung Pay will be available Fall 2015 on Galaxy S6 edge+, Galaxy Note5 and Galaxy S6 devices.</p>
  </div></div>

    <footer class="footer" role="contentinfo">

    </footer>

    <script src="/assets/common/images/content/note5/components/videojs/videojs.min.js"></script>
    <script src="/assets/common/images/content/note5/components/jquery/jquery.min.js"></script>
    <script src="/assets/common/images/content/note5/components/picturefill/picturefill.min.js"></script>
    <script src="/assets/common/images/content/note5/js/scripts.min.js"></script>
</form>
  </body>
  </cfoutput>
</html>

