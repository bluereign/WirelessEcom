<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfoutput>
<style type="text/css">
	##wrapper { 
		font-family: "Lucida Grande", "Lucida Sans Unicode", Helvetica, Arial, Verdana, sans-serif;
		color:##000;
	}
	
	##iphone-hero img {
		margin-left:-12px;
	}
	
	.iphone-spacer {
		clear:both;
		margin:40px 0;
	}
	
	.clear {
		height:0px;
		clear:both;
	}
	
	.row-header, 
	.specs {
		float: left;
	}
	
	.row-header {
		width:170px;
	}
	
	.specs {
		width:244px;
	}
	
	.specs strong {
		display:block;
	}
	
	.capacity .specs strong {
		font-size: 1.2em;
	}
	
	.siri-inner {
		text-align:center;
		width:65px;
	}
	
	.siri-blank {
		display:block;
		height:65px;
	}
	
	.specs p {
		margin-top:0;
	}
	
	.specs img, .siri-blank {
		margin-bottom:10px;
	}
	
	.specs ul {
		list-style:none;
		font-size: 1.2em;
		line-height: 1.5em;
	}
	
	.inset-small {
		margin:25px;
	}
	
	.iphone-footnote {
		width:90%;
		margin:20px auto;
	}
	
	.iphone-footnote ol li {
		list-style-type: decimal;
		color:##989898;
		margin-bottom: 8px;
	}
	
	/*******************************
	 * Shadow border
	 */
	.shadow {
		background: url('#assetPaths.common#images/content/iphone/shadow.png') top left repeat-y;
		position:relative;
	}
	
	.shadow .inner {
		padding:3px 5px 5px 3px;
		background: url('#assetPaths.common#images/content/iphone/shadow.png') top right repeat-y;
	}
	
	.shadow .inner span.cap { 
		background-image: url('#assetPaths.common#images/content/iphone/shadow-border.png'); 
		height:5px; 
		position:absolute; 
	}
	
	.shadow .inner .top { 
		background-position: top left; 
		position:absolute;
		top:0;
		left:0;
	}
	
	.shadow .inner .bottom { 
		background-position: bottom left;
		position:absolute;
		bottom:0;
		left:0;
	}
	
	.shadow .inner .cap,
	.shadow .inner .cap  {
		width:50%;
		right:0;
	}
	
	.shadow .inner .top, 
	.shadow .inner .bottom {
		width:100%;
		left:0;
	} 
		
	.shadow .inner .top span { background-position: top right; }
	.shadow .inner .bottom span { background-position: bottom right; }
</style>
		
<div id="wrapper" class="shadow">
	<div class="inner">
		<span class="top cap"><span class="cap"></span></span>
		<div class="inset-small">

			<div id="iphone-hero">
				<div class="row-header">&nbsp;</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-5.png" alt="Apple iPhone 5" />
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-4s.png" alt="Apple iPhone 4s" />
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-4.png" alt="Apple iPhone 4" />
				</div>
			</div>

			<div class="iphone-spacer"><hr /></div>

			<div class="capacity">
				<div class="row-header">
					<img src="#assetPaths.common#images/content/iphone/iphone-header-capacity.png" alt="Capacity" />
				</div>
				<div class="specs">
					<strong>16GB</strong>
					<strong>32GB</strong>
					<strong>64GB</strong>
				</div>
				<div class="specs">
					<strong>16GB</strong>
				</div>
				<div class="specs">
					<strong>8GB</strong>
				</div>
				<div class="clear">&nbsp;</div>
			</div>

			<div class="iphone-spacer"><hr /></div>

			<div class="chip">
				<div class="row-header">
					<img src="#assetPaths.common#images/content/iphone/iphone-header-chip.png" alt="Chip" />
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-chip-a6.png" alt="A6 chip" />
					<p>A6 chip</p>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-chip-a5.png" alt="A5 chip" />
					<p>A5 chip</p>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-chip-a4.png" alt="A4 chip" />
					<p>A4 chip</p>
				</div>
				<div class="clear">&nbsp;</div>
			</div>

			<div class="iphone-spacer"><hr /></div>
			
			<div class="display">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-display.png" alt="Display" />
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-retna.png" alt="Retina display" />
					<p>
						<strong>4-inch Retina display</strong>
						1136-by-640 resolution<br/>
						326 ppi
					</p>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-retna.png" alt="Retina display" />
					<p>
						<strong>3.5-inch Retina display</strong>
						960-by-640 resolution<br/>
						326 ppi
					</p>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-retna.png" alt="Retina display" />
					<p>
						<strong>3.5-inch Retina display</strong>
						960-by-640 resolution<br/>
						326 ppi
					</p>
				</div>
			</div>

			<div class="iphone-spacer"><hr /></div>
			
			<div class="siri">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-siri.png" alt="Intelligent Assistant" />
				</div>
				<div class="specs">
					<div class="siri-inner">
						<img src="#assetPaths.common#images/content/iphone/iphone-siri.png" alt="Siri" />
						<p>Siri</p>
					</div>
				</div>
				<div class="specs">
					<div class="siri-inner">
						<img src="#assetPaths.common#images/content/iphone/iphone-siri.png" alt="Siri" />
						<p>Siri</p>
					</div>
				</div>
				<div class="specs">
					<div class="siri-inner">
						<div class="siri-blank">&nbsp;</div>
						&mdash;
					</div>
				</div>
			</div>

			<div class="iphone-spacer"><hr /></div>
			
			<div class="isight">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-isight.png" alt="iSight Camera Lens" />
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-lens.png" alt="iSight Cameria Lens" />
					<ul>
						<li><strong>8 megapixels</strong></li>
						<li>Autofocus</li>
						<li>Tap to focus</li>
						<li>LED flash</li>
						<li>Backside illumination sensor</li>
						<li>Five-element lens</li>
						<li>Face detection</li>
						<li>Hybrid IR filter</li>
						<li>&fnof;/2.4 aperture</li>
						<li>Panorama</li>
					</ul>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-lens.png" alt="iSight Cameria Lens" />
					<ul>
						<li><strong>8 megapixels</strong></li>
						<li>Autofocus</li>
						<li>Tap to focus</li>
						<li>LED flash</li>
						<li>Backside illumination sensor</li>
						<li>Five-element lens</li>
						<li>Face detection</li>
						<li>Hybrid IR filter</li>
						<li>&fnof;/2.4 aperture</li>
						<li>Panorama</li>
					</ul>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-lens.png" alt="iSight Cameria Lens" />
					<ul>
						<li><strong>5 megapixels</strong></li>
						<li>Autofocus</li>
						<li>Tap to focus</li>
						<li>LED flash</li>
						<li>Backside illumination sensor</li>
						<li>Four-element lens</li>
						<li>&mdash;</li>
						<li>&mdash;</li>
						<li>&fnof;/2.8 aperture</li>
						<li>&mdash;</li>
					</ul>
				</div>
				<div class="clear">&nbsp;</div>
			</div>

			<div class="iphone-spacer"><hr /></div>
			
			<div class="isight">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-isight.png" alt="Video Recording" />
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-1080p.png" alt="HD 1080p video recording" />
					<ul>
						<li><strong>1080p HD video recording</strong></li>
						<li>30 fps</li>
						<li>Tap to focus while recording</li>
						<li>LED light</li>
						<li>Improved video stabilization</li>
						<li>Take still photos while recording</li>
						<li>Face detection</li>
					</ul>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-1080p.png" alt="HD 1080p video recording" />
					<ul>
						<li><strong>1080p HD video recording</strong></li>
						<li>30 fps</li>
						<li>Tap to focus while recording</li>
						<li>LED light</li>
						<li>Improved video stabilization</li>
						<li>&mdash;</li>
						<li>&mdash;</li>
					</ul>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-1080p.png" alt="HD 1080p video recording" />
					<ul>
						<li><strong>720p HD video recording</strong></li>
						<li>30 fps</li>
						<li>Tap to focus while recording</li>
						<li>LED light</li>
						<li>&mdash;</li>
						<li>&mdash;</li>
						<li>&mdash;</li>
					</ul>
				</div>
				<div class="clear">&nbsp;</div>
			</div>

			<div class="iphone-spacer"><hr /></div>
			
			<div class="facetime">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-facetime.png" alt="FaceTime Camera" />
				</div>
				<div class="specs">
					<ul>
						<li>1.2MP photos</li>
						<li>720p HD video</li>
						<li>Backside illumination sensor</li>
					</ul>
				</div>
				<div class="specs">
					<ul>
						<li>VGA resolution photos</li>
						<li>VGA resolution video</li>
						<li>&mdash;</li>
					</ul>
				</div>
				<div class="specs">
					<ul>
						<li>VGA resolution photos</li>
						<li>VGA resolution video</li>
						<li>&mdash;</li>
					</ul>
				</div>
				<div class="clear">&nbsp;</div>
			</div>
			
			<div class="iphone-spacer"><hr /></div>
			
			<div class="video-calling">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-video-call.png" alt="Video Calling" />
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-facetime-5.png" alt="iPhone 5 video calling" />
					<p>
						<strong>FaceTime</strong>
						iPhone 5 to any<br />
						FaceTime-enabled device<br />
						over Wi-Fi and cellular
					</p>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-facetime-4s.png" alt="iPhone 4s video calling" />
					<p>
						<strong>FaceTime</strong>
						iPhone 4S to any<br />
						FaceTime-enabled device<br />
						over Wi-Fi and cellular
					</p>
				</div>
				<div class="specs">
					<img src="#assetPaths.common#images/content/iphone/iphone-facetime-4.png" alt="iPhone 4 video calling" />
					<p>
						<strong>FaceTime</strong>
						iPhone 4 to any<br />
						FaceTime-enabled device<br />
						over Wi-Fi
					</p>
				</div>
				<div class="clear">&nbsp;</div>
			</div>
			
			<div class="iphone-spacer"><hr /></div>
			
			<div class="sim">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-sim.png" alt="SIM card" />
				</div>
				<div class="specs">
					<ul>
						<li><strong>Talk time:</strong></li>
						<li>Up to 8 hours on 3G</li>
						<li><strong>Browsing time:</strong></li>
						<li>Up to 8 hours on LTE</li>
						<li>Up to 8 hours on 3G</li>
						<li>Up to 10 hours on Wi-Fi</li>
						<li><strong>Standby time:</strong></li>
						<li>Up to 225 hours</li>
					</ul>
				</div>
				<div class="specs">
					<ul>
						<li><strong>Talk time:</strong></li>
						<li>Up to 8 hours on 3G</li>
						<li><strong>Browsing time:</strong></li>
						<li>&mdash;</li>
						<li>Up to 6 hours on 3G</li>
						<li>Up to 9 hours on Wi-Fi</li>
						<li><strong>Standby time:</strong></li>
						<li>Up to 200 hours</li>
					</ul>
				</div>
				<div class="specs">
					<ul>
						<li><strong>Talk time:</strong></li>
						<li>Up to 7 hours on 3G</li>
						<li><strong>Browsing time:</strong></li>
						<li>&mdash;</li>
						<li>Up to 6 hours on 3G</li>
						<li>Up to 10 hours on Wi-Fi</li>
						<li><strong>Standby time:</strong></li>
						<li>Up to 300 hours</li>
					</ul>
				</div>
				<div class="clear">&nbsp;</div>
			</div>
			
			<div class="iphone-spacer"><hr /></div>
			
			<div class="box">
				<div class="row-header">
					<img  src="#assetPaths.common#images/content/iphone/iphone-header-box.png" alt="In the box" />
				</div>
				<div class="specs">
					<ul>
						<li>Apple EarPods with Remote and Mic</li>
						<li>EarPod storage and travel case</li>
						<li>USB Power Adapter</li>
						<li>Lightning Connector to USB Cable</li>
					</ul>
				</div>
				<div class="specs">
					<ul>
						<li>Apple EarPods with Remote and Mic</li>
						<li>&mdash;</li>
						<li>USB Power Adapter</li>
						<li>30-pin Connector to USB Cable</li>
					</ul>
				</div>
				<div class="specs">
					<ul>
						<li>Apple EarPods with Remote and Mic</li>
						<li>&mdash;</li>
						<li>USB Power Adapter</li>
						<li>30-pin Connector to USB Cable</li>
					</ul>
				</div>
				<div class="clear">&nbsp;</div>
			</div>
		
		</div>
		
		<span class="bottom cap"><span class="cap"></span></span>
	</div>
</div>

<div class="iphone-footnote">
	<ol>
		<li>1GB = 1 billion bytes; actual formatted capacity less.</li>
		<li>Siri may not be available in all languages or in all areas, and features may vary by area. Internet access required. Cellular data charges may apply.</li>
		<li>FaceTime video calling requires a FaceTime-enabled device for the caller and recipient and a Wi-Fi connection. Availability over a cellular network depends on carrier policies; data charges may apply. </li>
		<li>All battery claims depend on network configuration and many other factors; actual results will vary. Rechargeable batteries have a limited number of charge cycles and may eventually need to be replaced by an Apple service provider. See <strong>www.apple.com/batteries</strong> for more information. For more details of iPhone performance tests for talk time, standby time, Internet use over 3G, Internet use over Wi-Fi, video playback, and audio playback, see <strong>www.apple.com/iphone/battery.html</strong>.</li>
	</ol>
</div>
</cfoutput>