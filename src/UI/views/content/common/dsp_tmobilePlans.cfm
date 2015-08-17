<cfset textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer") />

<style type="text/css">
	.SCPlan
	{
		width:962px;
	}
	
	#SCPlan
	{}
	
	.planRowHead
	{}
	
		.rowHeadLink
		{}
		
			/*.headLinkImage
			{
				background-image:url(/assets/common/images/content/tmo/SimpleChoicePlanHeader.png);
				background-repeat: no-repeat;
				display:block;
				height:312px;
				margin:0px auto;
				width:962px;
			}*/
	
			.aafesMobile .headLinkImage_aafes
			{
				background-image:url(/assets/common/images/content/tmo/TMO_banner_v3_aafes.jpg);
				background-repeat: no-repeat;
				display:block;
				height:312px;
				margin:0px auto;
				width:962px;
			}
	
			.aafesMobile .headLinkImage_costco
			{
				display:none;
			}
	
			.membershipWireless .headLinkImage_aafes
			{
				display:none;
			}
	
			.membershipWireless .headLinkImage_costco
			{
				background-image:url(/assets/common/images/content/tmo/TMO_banner_v3_costco.jpg);
				background-repeat: no-repeat;
				display:block;
				height:312px;
				margin:0px auto;
				width:962px;
			}
	
	.planRow
	{
		border-bottom: 1px dotted #6a6a6a;
		overflow:hidden;
		padding:30px 0px;
	}
	
		.rowContent
		{}
	
			.contentText
			{
				float:left;
				padding-left:20px;
				width:450px;
			}
			
			.pink
			{
				color:#ec008c;
			}
						
				.textHead,
				.aafesMobile .textHead_aafes,
				.membershipWireless .textHead_costco
				{
					color:#000;
					font-family:Arial, Helvetica, sans-serif;
					font-size:42px;
					font-weight:bolder;
					margin-bottom:20px;
					margin-top:20px;
				}
				
				.aafesMobile .textHead_costco,
				.membershipWireless .textHead_aafes
				{
					display:none;
				}
				
				.textBlock
				{
					color:#6a6a6a;
					font-family:Arial, Helvetica, sans-serif;
					font-size:17px;
					font-weight:normal;
					line-height:24px;
				}
				
					.blockParagraph
					{
						margin-top:12px;
					}
			
					.blockLink
					{
						font-size:16px;
						font-weight:bold;
						line-height:16px;
						margin-top:20px;
					}
					
					.blockLink a
					{
						color:#ec008c;
						text-decoration:none;
					}
					
					.blockLink a:hover
					{
						color:#ec008c;
						text-decoration:underline;
					}
					
					.blockLink a:visited
					{
						color:#ec008c;
						text-decoration:none;
					}
					
						.linkArrow
						{
							margin-bottom:4px;
							border:0px;
						}
				
					.block
					{
						display:block;
					}
			
				.textBlock li
				{
					list-style:disc outside;
					margin-left:24px;
					margin-top:12px;
				}
			
				.textBlock ol
				{
					margin-top:12px;
					padding-left:0px;
				}
			
				.textBlock ol li
				{
					list-style:decimal outside;
				}
			
			.contentImage
			{
				float:left;
			}

				.image_jump
				{
					background-image:url(/assets/common/images/content/tmo/No_Contracts_M_260.jpg);
					background-position:100px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:400px;
				}
		
				.image_figure8
				{
					background-image:url(/assets/common/images/content/tmo/Unlimited_Rate_Plans_M_260.jpg);
					background-position:120px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:400px;
				}
		
				.image_highspeeddata
				{
					background-image:url(/assets/common/images/content/tmo/High_Speed_Data_M_260.jpg);
					background-position:120px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:400px;
				}
		
				.aafesMobile .image_kiosk_aafes
				{
					background-image:url(/assets/common/images/content/tmo/kiosk_EMC_pink.jpg);
					background-position:120px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:400px;
				}
	
				.membershipWireless .image_kiosk_costco
				{
					background-image:url(/assets/common/images/content/tmo/kiosk_260.png);
					background-position:120px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:400px;
				}
				
				.aafesMobile .image_kiosk_costco,
				.membershipWireless .image_kiosk_aafes
				{
					display:none;
				}
	
	.planRowLast
	{
		overflow:hidden;
		padding:30px 0px;
	}
	
</style>

<div class="SCPlan" id="SCPlan">
	<div class="planRowHead">
		<!---<a class="rowHeadLink">
			<span class="headLinkImage"></span>
		</a>--->
		<a class="rowHeadLink" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/2/filter.filterOptions/2/index?utm_source=aafesMobile&utm_medium=T-Mobile-Plans_banner&utm_content=tmo&utm_campaign=all_tmo_phones">
			<span class="headLinkImage_aafes"></span>
		</a>
		<a class="rowHeadLink" href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/2/filter.filterOptions/2/index?utm_source=membershipWireless&utm_medium=T-Mobile-Plans_banner&utm_content=tmo&utm_campaign=all_tmo_phones">
			<span class="headLinkImage_costco"></span>
		</a>
	</div>
	
	<div class="planRow">
		<div class="rowContent">
			<div class="contentImage">
				<div class="image_jump"></div>
			</div>
			<div class="contentText">
				<div class="textHead"><span class="pink">We've upgraded upgrades.</span></div>
				<div class="textBlock">
					<div class="blockParagraph">
						You shouldn't have to live with a cracked screen, a battery that doesn't hold a charge, or a 
						phone that's totally outdated just because your carrier says you're not eligible for an upgrade. 
						We've heard your frustrations, and we agree. That's why we're introducing JUMP!&mdash;so you can get a 
						new phone on your own terms.
					</div>
					<div class="blockParagraph">
						Upgrade to the phone you want twice every 12 months, not once every two years. Get your first 
						upgrade as soon as 6 months after enrollment.
					</div>
					<div class="blockParagraph">
						Existing customers can get the same great phone prices as new customers when you upgrade.
					</div>
					<div class="blockParagraph">
						Get a new phone when you want it: if your screen cracks, if your phone is lost or stolen, or if 
						you just change your mind and want something different.
					</div>
					<div class="blockLink">
						<a href="/index.cfm/go/content/do/T-Mobile-Jump">Learn more about JUMP! <img src="/assets/common/images/content/tmo/linkArrow.png" class="linkArrow" /></a>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="planRow">
		<div class="rowContent">
			<div class="contentImage">
				<div class="image_figure8"></div>
			</div>
			<div class="contentText">
				<div class="textHead"><span class="pink">The Simple Choice Plan,</span> with unlimited everything.</div>
				<div class="textBlock">
					<div class="blockParagraph">
						Only T-Mobile's network can give you unlimited everything for everyone. Other carriers may even make 
						you share minutes, messages, and data between you and your family. With the Simple Choice Plan, each 
						line comes with unlimited talk, text, and data while on our home network-and starting October 20, 
						unlimited data and text in over 100 countries at no extra charge. That means no overages just about 
						anywhere you go. Plus, there's no annual service contract and it's easy to add additional lines.
					</div>
					<!---<div class="blockLink">
						<a href="/index.cfm/go/content/do/T-Mobile-Simple-Choice-Plans">Learn more about our Simple Choice Plan <img src="/assets/common/images/content/tmo/linkArrow.png" class="linkArrow" /></a>
					</div>--->
				</div>
			</div>
		</div>
	</div>
	
	<div class="planRow">
		<div class="rowContent">
			<div class="contentImage">
				<div class="image_highspeeddata"></div>
			</div>
			<div class="contentText">
				<div class="textHead">
					<span class="pink">Now with nationwide 4G LTE coverage:</span> reaching more than 200 million people and Counting.
				</div>
				<div class="textBlock">
					<div class="blockParagraph">
						T-Mobile's advanced 4G LTE network now reaches more people, faster than ever before. Web browsing on 
						T-Mobile's 4G LTE is even faster than AT&T's 4G LTE. Now you can download, stream and surf with our 
						fastest experience ever.
					</div>
					<div class="blockParagraph">
						Get download speeds that are now 2x faster than before with 4G LTE and get the most out of your smartphone.
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="planRow">
		<div class="rowContent">
			<div class="contentImage">
				<div class="image_kiosk_aafes"></div>
				<div class="image_kiosk_costco"></div>
			</div>
			<div class="contentText">
				<div class="textHead_aafes">
					<span class="pink">Visit an Exchange Mobile Center today</span> for great prices on <br/>T-Mobile's best plans and devices.
				</div>
				<div class="textHead_costco">
					<span class="pink">Visit a Costco Wireless Kiosk today</span> for great prices on <br/>T-Mobile's best plans and devices.
				</div>
			</div>
		</div>
	</div>

	<div class="planRowLast">
		<div class="rowContent">
			<div class="contentLegal">
				<div class="legalBlock">
					Capable device and qualifying rate plan required for 4G LTE.  Qualifying service plan with financed device on new 
					lines required. Upgrades available 6 months after enrollment and up to 2 times in a 12-month period, beginning on 
					the date of the first upgrade. JUMP! must be added within 14 days of qualified device purchase. Device pricing may 
					vary based on approved credit. Offer may not be available in all locations. NY residents must use JUMP! benefits 
					prior to completing 2 insurance claims in 12/mos. JUMP Upgrades from T-Mobile; trade-in benefits through CWork 
					Solutions, LP. Program fees paid to CWork. No separate insurance fees, except in NY.Our Fastest Speeds/Twice as 
					Fast with 4G LTE: Based on T-Mobile's HSPA and LTE networks. Faster Web-Browsing: Based on average website download 
					speeds. Congestion and speed claims: based on July 2013 third party data during peak times of usage on HSPA/HSPA+ 
					and LTE.  Coverage not available in some areas. LTE is a trademark of ETSI. Not available in Puerto Rico.
				</div>
			</div>
		</div>
	</div>
	
</div>