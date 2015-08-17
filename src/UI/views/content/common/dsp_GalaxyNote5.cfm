<!---Samsung Galaxy Note 5 landing page--->

<html class="no-js">
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
			width: 255px;
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
</head>


<body>

<div id="main"  data-hero="noble" class="noble-landing-page">
  <div class="content clear 360noble ">
    <div class="content-container clear">
      <div class="content-image content-left">
          <div id="hero_container">
            <div id="hero_imgHolder" style="background: url('/assets/common/images/content/note5/images/noble/360Grid.png') no-repeat;"></div>
            <span id="replay" class="disabled"></span>
          </div>
          <div class="fallback">
            <img srcset="/assets/common/images/content/note5/images/noble/hero-sm.png" alt="Samsung S6 Edge">
          </div>
      </div>
  
  
        <div class="content-description content-right clear ">
          <div class="content-description-container">
            <h2 class="content-description-headline">The&nbsp;next big&nbsp;thing</h2>
            <h2 class="content-description-sub-headline">is almost here</h2>
              <img class="content-description-image" src="/assets/common/images/content/note5/images/noble/logo.png" alt="Samsung" />
              <!-- hero thumbnail -->
                <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">
                  <img class="content-description-image" src="/assets/common/images/content/note5/images/noble/video-thumb.png" alt="" />
                </a>--->
  
            <p>The reimagined Samsung Galaxy Note5 is designed to keep up with your busy life. Explore the multitasking features, seamless sharing and the enhanced S Pen you&#39;ll only find on a Galaxy Note.</p>

				<!--- This content adds in the carrier dropdown and email box  --->
				<div class="gs6Content" style="margin-top:-10px;">
					<div class="contentText" style="float:left;margin-bottom:20px;">
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
					<div class="contentText" style="float:left;margin-bottom:20px; margin-left:10px;">
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
  
              <!---<a href="##" class="button" onclick="ValidateNotificationForm(); return false;">Pre-Order Now</a>--->
  
          </div>
        </div>
      </div>
  </div>
  
  
      <div class="content clear  content--lifestyle-dark">
        <div class="content-container clear">
              <div class="content-image content-right">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/noble/lifestyle/s-pen.jpg" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/noble/lifestyle/s-pen-sm.jpg" alt="Samsung S6 Edge">
                </picture>
              </div>
      
            <div class="content-description content-left clear">
              <div class="content-description-container">
                <h2 class="content-description-headline">S Pen</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Do more with the advanced S Pen. Jot down reminders, lists and schedules without waking the device. And S Pen features are easier to find from any screen or app with the Air Command menu.</p>
      
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
                  <source srcset="/assets/common/images/content/note5/images/noble/lifestyle/display.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/noble/lifestyle/display-sm.png" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Display</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Get immersed in the content you love with the adaptive 5.7&quot; Quad HD Super AMOLED 2560x1440 resolution display that adjusts to any light, making images pop.  Get an even bigger picture by connecting the Galaxy Note5 to your TV<sup>1</sup>.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
      
      
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  content--lifestyle-dark">
        <div class="content-container clear">
              <div class="content-image content-right">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/noble/lifestyle/multi.jpg" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/noble/lifestyle/multi-sm.jpg" alt="Samsung S6 Edge">
                </picture>
              </div>
      
            <div class="content-description content-left clear">
              <div class="content-description-container">
                <h2 class="content-description-headline">Multi Window</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Multitask like never before. Open two apps side by side<sup>2</sup> so you can read the news while answering email.</p>
      
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
                  <source srcset="/assets/common/images/content/note5/images/noble/lifestyle/camera.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/noble/lifestyle/camera-sm.png" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Camera</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Featuring a 16MP rear-facing camera, take sharper, clearer photos with features like image stabilization and a low-light sensor<sup>3</sup>. And take wide-angle selfies with the 5MP front-facing camera.</p>
      
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
                  <source srcset="/assets/common/images/content/note5/images/noble/lifestyle/pay.jpg" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/noble/lifestyle/pay-sm.jpg" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Samsung Pay</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Samsung Pay works virtually anywhere you can swipe a card<sup>4</sup>. From the local grocery store to the corner caf&eacute;, it&#39;s easy to pay with your device.</p>
      
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
                  <source srcset="/assets/common/images/content/note5/images/noble/lifestyle/sidesync.png" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/noble/lifestyle/sidesync-sm.png" alt="Samsung S6 Edge">
                </picture>
              </div>
      
            <div class="content-description content-left clear">
              <div class="content-description-container">
                <h2 class="content-description-headline">SideSync</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>Easily drag and drop photos and documents between Galaxy Note5 and most PCs or Macs<sup>5</sup>. And even respond to texts and answer calls directly on your laptop.</p>
      
                  <!---<a href="http://vjs.zencdn.net/v/oceans.mp4" class="button" data-video="http://vjs.zencdn.net/v/oceans" data-poster="http://www.videojs.com/img/poster.jpg">Watch the video</a>--->
              </div>
            </div>
          </div>
      </div>
      
      <div class="content clear  content--lifestyle-fifty">
        <div class="content-container clear">
          <div class="content-image content-left">
                <picture>
                  <!--[if IE 9]><video style="display: none;"><![endif]-->
                  <source srcset="/assets/common/images/content/note5/images/noble/lifestyle/knox-battery.jpg" media="(min-width: 785px)">
                  <!--[if IE 9]></video><![endif]-->
                  <img srcset="/assets/common/images/content/note5/images/noble/lifestyle/knox-battery_sm.jpg" alt="Samsung S6 Edge">
                </picture>
          </div>
      
      
            <div class="content-description content-right clear ">
              <div class="content-description-container">
                <h2 class="content-description-headline">Battery</h2>
                <h2 class="content-description-sub-headline"></h2>
      
                <p>With the 3,000mAh battery, you have the power to get through your day. Plus you can recharge wirelessly<sup>6</sup>, power up quickly<sup>7</sup> or even use Ultra Power Saving Mode to extend your text and talk time<sup>8</sup>.</p>
      
      
      
                    <h2 class="content-description-headline">Knox</h2>
                    <p>Defense-grade Samsung Knox security, featuring a separate personal and work partitioning container, protects your sensitive data.</p>
              </div>
            </div>
          </div>
      </div>
      
      <div class="content content--full">
        <div class="content-container clear">
          <h2>The next big thing</h2>
          <h2>is almost here</h2>
          <img class="content-description-image" src="/assets/common/images/content/note5/images/noble/logo.png" alt="Samsung" />

				<!--- This content adds in the carrier dropdown and email box  --->
				<div class="gs6Content" style="text-align:center;">
					<div class="contentText" style="margin-bottom:10px;">
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
					<div class="contentText" style="margin-bottom:10px;">
						<input id="email" type="email" name="email" value="#rc.Email#" maxlength="50" placeholder="Enter your email address" required>
					</div>
					<div class="contentButton" style="clear:both;">
						<div class="buttonContainer">
							<div class="blockButton">
								<a class="button" href="##" onClick="ValidateNotificationForm(); return false;">
									<span class="PreOrder">Pre-Register Now</span>
								</a>
							</div>
						</div>	
						<!---<span class="buttonLegal" style="font-size:.6em;">This device has not been authorized as required by the rules of the Federal 
						Communications Commission. This device is not, and may not be, offered for sale or lease, or sold or 
						leased, until authorization is obtained.</span>--->
					</div>
				</div>

            <!---<a href="#" class="button">Pre-order now</a>--->
            <!---<a href="#" class="button">See the GALAXY S6 EDGE+</a>--->
            
        </div>
      </div>
  
  <div class="disclaimer">
  	<p class="legal"><sup>1</sup>Compatible with 2015 and later Samsung SmartTVs.</p><p class="legal"><sup>2</sup>Multi Window does not support all applications.</p><p class="legal"><sup>3</sup>Compared to Samsung devices without image stabilization and a low-light sensor.</p><p class="legal"><sup>4</sup>Service will be available Fall 2015. Contact your bank or financial institution to verify supported cards.</p><p class="legal"><sup>5</sup>For supported devices, please visit <a href='http://www.samsung.com/us/sidesync' target='_blank'>www.samsung.com/us/sidesync.</a></p><p class="legal"><sup>6</sup>Wireless charging pad sold separately.</p><p class="legal"><sup>7</sup>Fast Charging requires an AFC-compatible charger to work.</p><p class="legal"><sup>8</sup>Battery power consumption depends on factors such as network configuration, carrier network, signal strength, operating temperature, features selected, vibrate mode, backlight settings, browser use, frequency of calls, and voice, data and other application-usage patterns.</p>
  	<p class = "copywright">&copy; 2015 Samsung Electronics America Inc. Samsung, Samsung Galaxy, Galaxy Note, S Pen, Air Command, Super AMOLED, Samsung Pay, SideSync, Samsung Knox and The Next Big Thing Is Here are all trademarks of Samsung Electronics Co., Ltd. Other company and product names mentioned may be trademarks of their respective owners. Screen images simulated. Appearance of device may vary. Contact your bank or financial institution to verify that it is a Samsung Pay participant. Samsung Pay will be available Fall 2015 on Galaxy S6 edge+, Galaxy Note5 and Galaxy S6 devices.</p>
  </div></div>

    <footer class="footer" role="contentinfo">

    </footer>

    <script src="/assets/common/images/content/note5/components/videojs/videojs.min.js"></script>
    <script src="/assets/common/images/content/note5/components/jquery/jquery.min.js"></script>
    <script src="/assets/common/images/content/note5/components/picturefill/picturefill.min.js"></script>
    <script src="/assets/common/images/content/note5/js/scripts.min.js"></script>

  </body>
</html>

<div class="modal">
  <div class="modal-container">
    
    <span id="close"></span>

    <video id="video-player" class="video-js vjs-default-skin" controls preload="auto" width="967" height="498" poster="">
     <source src="" type='video/mp4'>
     <source src="" type='video/webm'>
     <p class="vjs-no-js">To view this video please enable JavaScript, and consider upgrading to a web browser that <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a></p> 
    </video>
  </div>
</div>

<div class="modal-background">
</div>