<!---iPhone landing page--->

<style>
	.iPhoneLandingPage
	{
		font-family:Helvetica, Arial, sans-serif;
		margin:20px auto;
	}
	
		.PageRow
		{
			width:960px;
			clear:both;
		}
		
		.grayBG
		{
			background-color:#f0f0f0;
			height:70px;
		}

		.whiteBG
		{
			background-color:#fff;
			height:70px;
		}
		
		.buttonBar
		{
			background-image:url('/assets/common/images/content/iphone/button_bar.png');
		}

		.image_0
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_0.png');
			height:210px;
		}
	
		.membershipWireless #Register /* Added to hide the notification container on membershipwireless.com */
		{
			display:none;
			height:0px;
		}
	
		.image_1
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_1.jpg');
			height:1041px;
		}
	
		.image_2
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_2.jpg');
			height:540px;
		}
	
		.image_3
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_3.jpg');
			height:603px;
		}
	
		.image_4
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_4.jpg');
			height:517px;
		}
	
		.image_5
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_5.jpg');
			height:625px;
		}
	
		.image_6
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_6.jpg');
			height:569px;
		}
	
		.image_7
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_7.jpg');
			height:597px;
		}
	
		.image_8
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_8.jpg');
			height:770px;
		}
	
		.image_9
		{
			background-image:url('/assets/common/images/content/iphone/iphone6s_image_9.jpg');
			height:696px;
		}
	
			.rowButton
			{
				border:2px solid #999;
				border-radius:5px;
				float:right;
				font-weight:bolder;
				margin-top:20px;
				margin-right:20px;
				padding:5px 20px;
			}
			
			.membershipWireless .notifyMe
			{
				display:none;
			}
			
			.grayBG .rowButton:hover
			{
				background-color:#fff;
				border:2px solid #666;
				border-radius:5px;
			}
			
			.whiteBG .rowButton:hover
			{
				background-color:#f0f0f0;
				border:2px solid #666;
				border-radius:5px;
			}
			
				.buttonText
				{}

			.rowButton a
			{
				color:#808080;
				text-decoration:none;
			}
			
			.rowButton:hover a
			{
				color:#666;
			}
			
			.rowButton:active a
			{
				color:#808080;
			}
			
			.rowContent
			{
				float:left;
				margin:20px 0px 0px 400px;
			}
			
				.contentText
				{
					margin-bottom:10px;
				}
				
				.contentText select				
				{
					width:186px;
				}
				
				.contentText input				
				{
					width:180px;
				}
				
					.textSignupTitle
					{
						font-size:2.5em;
						margin-bottom:5px;
					}
					
					.textSignupDesc
					{
						font-size:1.3em;
						margin-bottom:20px;
					}
				
				.contentButton
				{
					margin-bottom:10px;
				}
					
					.buttonContainer
					{
						border:2px solid #999;
						border-radius:5px;
						float:left;
						font-weight:bolder;
						margin-top:5px;
						padding:5px 20px;
					}
					
					.buttonContainer:hover
					{
						background-color:#fff;
					}
					
					.buttonContainer:active
					{
					}
					
					.buttonContainer a
					{
						color:#808080;
						text-decoration:none;
					}
					
					.buttonContainer:hover a
					{
						color:#666;
					}
					
					.buttonContainer:active a
					{
						color:#808080;
					}

						.button_container
						{}
						
					.buttonLegal
					{
						float:none;
						font-size:9px;
						width:365px;
						margin-left:165px;
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
	<input type="hidden"  name="pageURL" id="pageURL" value='#CGI.SERVER_NAME & CGI.PATH_INFO#'> <!--- Required line of code to make the notifications work. --->
	<div class="iPhoneLandingPage">
		<div class="PageRow image_0" id="Register">
			<div class="rowContent">
				<div class="contentText">
					<div class="textSignupTitle">iPhone 6s Notification Sign Up</div>
					<div class="textSignupDesc">Sign up to be notified when the iPhone 6s and iPhone 6s Plus are available for purchase.</div>
				</div>
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
						<a class="button_container" href="##" onclick="ValidateNotificationForm(); return false;" >
							<span class="buttonText">Register to be Notified</span>
						</a>
					</div>	
					<div class="buttonLegal">This device has not been authorized as required by the rules of the Federal 
					Communications Commission. This device is not, and may not be, offered for sale or lease, or sold or 
					leased, until authorization is obtained.</div>
				</div>
			</div>
		</div>
		<div class="PageRow image_1"></div>
		<div class="PageRow grayBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_3D-Touch&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_2"></div>
		<div class="PageRow whiteBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_Pictures&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_3"></div>
		<div class="PageRow grayBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_Architecture&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_4"></div>
		<div class="PageRow whiteBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_Design&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_5"></div>
		<div class="PageRow grayBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_Faster&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_6"></div>
		<div class="PageRow whiteBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_TouchID&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_7"></div>
		<div class="PageRow grayBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_iOS9&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_8"></div>
		<div class="PageRow whiteBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_Why&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
		<div class="PageRow image_9"></div>
		<div class="PageRow grayBG buttonBar">
			<div class="rowButton">
				<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,481,482/index?utm_source=iPhoneLandingPage&utm_medium=PreorderButton_bottom&utm_campaign=iPhone6s"><span class="buttonText">Preorder Today</span></a>
			</div>
			<div class="rowButton notifyMe">
				<a href="##Register"><span class="buttonText">Register to be Notified</span></a>
			</div>
		</div>
	</div>
	
</form>
</cfoutput>	