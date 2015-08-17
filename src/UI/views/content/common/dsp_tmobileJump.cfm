<cfset textDisplayRenderer = application.wirebox.getInstance("TextDisplayRenderer") />

<style type="text/css">
.tmoJump
{
	width:922px;
	border-radius:5px;
	border:1px solid #dcdcdc;
	background-color:#f5f5f5;
	padding:20px;
}

#tmoJump
{}

	.planRowHead
	{}
	
		.rowHeadLink
		{}
		
			.aafesMobile .headLinkImage_aafes
			{
				background-image:url(/assets/common/images/content/tmo/JumpHeader_aafes.jpg);
				background-repeat: no-repeat;
				display:block;
				height:446px;
				margin:0px auto;
				width:922px;
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
				background-image:url(/assets/common/images/content/tmo/JumpHeader_costco.jpg);
				background-repeat: no-repeat;
				display:block;
				height:446px;
				margin:0px auto;
				width:922px;
			}
	
	.planRow
	{
		border: 1px solid #dcdcdc;
		background-color:#fff;
		border-radius:5px;
		margin-top:20px;
		overflow:hidden;
		padding:30px;
	}
	
		.rowContent
		{}
		
			.contentText
			{
				float:left;
				padding-left:20px;
				width:480px;
			}
			
			.pink
			{
				color:#ec008c;
			}
						
				.FAQHead,
				.textHead,
				.aafesMobile .textHead_aafes,
				.membershipWireless .textHead_costco
				{
					color:#000;
					font-family:Arial, Helvetica, sans-serif;
					font-size:24px;
					font-weight:normal;
					line-height:30px;
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
			
					.aafesMobile .blockLink_aafes,
					.membershipWireless .blockLink_costco
					{
						display:block;
						font-size:16px;
						font-weight:normal;
						line-height:16px;
						margin-top:20px;
					}
					
					.membershipWireless .blockLink_aafes,
					.aafesMobile .blockLink_costco
					{
						display:none;
					}
					
					.aafesMobile .blockLink_aafes a,
					.membershipWireless .blockLink_costco a
					{
						color:#ec008c;
						text-decoration:none;
					}
					
					.aafesMobile .blockLink_aafes a:hover,
					.membershipWireless .blockLink_costco a:hover
					{
						color:#ec008c;
						text-decoration:underline;
					}
					
					.aafesMobile .blockLink_aafes a:visited,
					.membershipWireless .blockLink_costco a:visited
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
					background-image:url(/assets/common/images/content/tmo/JUMP_Logo.png);
					background-position:0px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:350px;
				}
		
				.image_figure8
				{
					background-image:url(/assets/common/images/content/tmo/Upgrade_Whenever_M.jpg);
					background-position:0px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:350px;
				}
		
				.image_highspeeddata
				{
					background-image:url(/assets/common/images/content/tmo/Upgrade_or_Choose_Phone_U_Love_M.jpg);
					background-position:0px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:350px;
				}
		
				.aafesMobile .image_kiosk_aafes
				{
					background-image:url(/assets/common/images/content/tmo/kiosk_EMC_pink.jpg);
					background-position:0px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:350px;
				}
	
				.membershipWireless .image_kiosk_costco
				{
					background-image:url(/assets/common/images/content/tmo/kiosk_260.png);
					background-position:0px 20px;
					background-repeat: no-repeat;
					height:280px;
					width:350px;
				}
				
				.aafesMobile .image_kiosk_costco,
				.membershipWireless .image_kiosk_aafes
				{
					display:none;
				}
			
			.contentFAQ
			{
				padding-left:20px;
				padding-right:20px;
			}
			
				.FAQBlock
				{
					color:#6a6a6a;
					font-family:Arial, Helvetica, sans-serif;
					font-size:17px;
					font-weight:normal;
					line-height:24px;
					margin-bottom:20px;
				}
				
					.blockToggle a:link
					{
						color:#ec008c;
						text-decoration:none;
					}
				
					.blockToggle a:hover
					{
						color:#ec008c;
						text-decoration:underline;
					}
				
					.blockToggle a:visited
					{
						color:#ec008c;
						text-decoration:none;
					}
				
						.toggleTitle
						{
							background-image:url(/assets/common/images/content/tmo/linkArrow.png);
							background-position:0px 6px;
							background-repeat: no-repeat;
							color:#ec008c;
							padding-left:21px;
							text-decoration:none;
						}
						
						
						.toggleDescription
						{
							margin-top:10px;
							margin-bottom:20px;
							margin-left:20px;
						}
						
	.planRowLast
	{
		overflow:hidden;
		padding:30px 0px 0px;
	}
		
		.contentLegal
		{}
		
			.legalBlock
			{
				font-size:10px;
				margin-bottom:10px;
			}
	
</style>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

<script>
function ToggleFAQ (descid)
{
	$(descid).toggle();
};
</script>

<div class="tmoJump" id="tmoJump">
	<div class="planRowHead">
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
				<div class="textHead">We&#39;ve upgraded upgrades.</div>
				<div class="textBlock">
					<div class="blockParagraph">
						Two years is too long to wait to upgrade your device. That&#39;s why we offer JUMP!&#8482;, a 
						revolutionary upgrade program only from T-Mobile.
						<ul>
							<li>Upgrade your phone or tablet when the next hot device comes out or simply when you&#39;re ready 
							for something new. There&#39;s no waiting to upgrade or limits on how many times you can upgrade.</li>
							<li>When you&#39;re ready to upgrade, simply trade in your eligible device and receive credit for all 
							remaining device payments, up to half of its original cost. You are responsible for any remaining 
							device payments at the time of upgrade.</li>
							<li>Total peace of mind knowing that you can replace virtually any phone or tablet that&#39;s been 
							damaged or lost through our premium device protection and mobile security features, included in 
							JUMP!</li>
						</ul>
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
				<div class="textHead">Here&#39;s how JUMP! works</div>
				<div class="textBlock">
					<div class="blockParagraph">
						<ol>
							<li>Buy a phone or tablet, get a Simple Choice plan, and finance your device through T-Mobile.</li>
							<li>Enroll in JUMP! for $10/mo. when you buy your new device.</li>
							<li>Upgrade anytime you want. Simply trade in your eligible device and T-Mobile will cover your 
							remaining device payments up to half of your device cost.</li>
						</ol>
						And only with JUMP!, you're protected if your device  is lost, damaged, or stolen with the 
						included Premium Handset Protection<sup>&reg;</sup> and Lookout Mobile Security<sup>&reg;</sup>. (Deductible may apply; 
						see FAQ below.)
					</div>
					<div class="blockLink_aafes">
						<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2/index?utm_source=AAFESmobile&utm_medium=TMOJUMPpage&utm_term=PhonesList&utm_content=tmo&utm_campaign=all_phones">
							See phones available in select Exchange Mobile Center <img src="/assets/common/images/content/tmo/linkArrow.png" class="linkArrow" />
						</a>
					</div>
					<div class="blockLink_costco">
						<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2/index?utm_source=membershipWireless&utm_medium=TMOJUMPpage&utm_term=PhonesList&utm_content=tmo&utm_campaign=all_phones">
							See phones available in select Costco Wireless Kiosks <img src="/assets/common/images/content/tmo/linkArrow.png" class="linkArrow" />
						</a>
					</div>
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
					T-Mobile offers the best upgrades in wireless. Period.
				</div>
				<div class="textBlock">
					<div class="blockParagraph">
						T-Mobile ended the era of waiting two years for an upgrade. We got rid of the long waits, 
						unfair fees, and restrictive annual service contracts. With JUMP!, you can upgrade to the 
						phones and tablets you want at a great price and use them on the fastest nationwide 4G LTE 
						network*. Plus, only JUMP! offers peace of mind that your device is protected against loss 
						or damage with Premium Handset Protection and Lookout Mobile Security.
					</div>
					<div class="blockParagraph">
						*Based on download speeds.
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
					Visit an Exchange Mobile Center today for great prices on T-Mobile's best plans and devices.
				</div>
				<div class="textHead_costco">
					Visit a Costco Wireless Kiosk today for great prices on T-Mobile's best plans and devices.
				</div>
			</div>
		</div>
	</div>

	<div class="planRow">
		<div class="rowContent">
			<div class="contentFAQ">
				<div class="FAQHead">
					JUMP! FAQ
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPWorksDesc')">
							How does JUMP! work?
						</a>
					</div>
					<div id="JUMPWorksDesc" class="toggleDescription" style="display:none;">
						JUMP! TM offers you freedom to upgrade your device when you want, not when you're told. 
						Whenever you're ready to upgrade, simply trade in your eligible device and T-Mobile will 
						pay off your remaining device payments, up to half of your device cost. Then purchase your 
						new device on a new Equipment Installment Plan (EIP). JUMP! is also the only upgrade program 
						from a major national carrier to offer you virtually complete protection for your device 
						investment. Device protection and mobile security are included, for ultimate peace of mind. 
						No more worrying about mechanical breakdown, accidental damage, loss, or theft. You're covered 
						with JUMP!.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPCostDesc')">
							What is the total cost of JUMP!?
						</a>
					</div>
					<div id="JUMPCostDesc" class="toggleDescription" style="display:none;">
						JUMP! TM offers you freedom to upgrade your device when you want, not when you're told. 
						Whenever you're ready to upgrade, simply trade in your eligible device and T-Mobile will 
						pay off your remaining device payments, up to half of your device cost. Then purchase your 
						new device on a new Equipment Installment Plan (EIP). JUMP! is also the only upgrade program 
						from a major national carrier to offer you virtually complete protection for your device 
						investment. Device protection and mobile security are included, for ultimate peace of mind. 
						No more worrying about mechanical breakdown, accidental damage, loss, or theft. You're covered 
						with JUMP!.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPPlanDesc')">
							Do I have to be on a specific rate plan to enroll in JUMP!?
						</a>
					</div>
					<div id="JUMPPlanDesc" class="toggleDescription" style="display:none;">
						Any customer on a qualifying Simple Choice rate plan, who financed a new phone or tablet within 
						14 days of purchase can enroll in JUMP! If you're an existing customer with other types of Value 
						Plans you also may be eligible. Login to my.t-mobile.com for more details.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPTabletsDesc')">
							How does JUMP! work for tablets?
						</a>
					</div>
					<div id="JUMPTabletsDesc" class="toggleDescription" style="display:none;">
						JUMP! is available for financed tablets and works the same as it does for handsets.  We'll pay 
						for your remaining device payments, up to half of your original tablet cost when you trade in 
						your eligible tablet.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPEligibleDesc')">
							Do I need to have a specific phone or tablet to qualify for JUMP!?
						</a>
					</div>
					<div id="JUMPEligibleDesc" class="toggleDescription" style="display:none;">
						Any device financed through EIP is eligible for JUMP!.  <!---See www.T-Mobile.com for details.--->
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPDeviceTypeDesc')">
							Am I limited to specific types of devices when I upgrade?
						</a>
					</div>
					<div id="JUMPDeviceTypeDesc" class="toggleDescription" style="display:none;">
						You may upgrade to any device that's financed through EIP.  However, you may not upgrade from a 
						phone to a tablet or vise-versa.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPTradeInDesc')">
							Do I have to trade in my old phone or tablet in order to upgrade through the JUMP! program?
						</a>
					</div>
					<div id="JUMPTradeInDesc" class="toggleDescription" style="display:none;">
						Yes, if enrolled in JUMP!, you must trade in the same phone or tablet that you financed through 
						EIP, and it must pass a three-point inspection: 1) powers on, 2) no cracked screen, and 3) no water 
						damage. Should you experience any issue that would cause the device  to fail initial inspection, 
						you simply file a PHP claim and pay the deductible or any processing fee to replace it before 
						redeeming a JUMP! upgrade. During the trade in, the IMEI number on the phone must match the IMEI 
						number on the JUMP! account to be eligible.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPDamagedDesc')">
							<span class="titleQuestion">What happens if I lose my phone or tablet or if it gets damaged before I can trade it in? Or what 
							if it doesn't pass the 3-point inspection?</span>
						</a>
					</div>
					<div id="JUMPDamagedDesc" class="toggleDescription" style="display:none;">
						JUMP! includes Premium Handset Protection (PHP), which covers accidental damage, mechanical breakdown, 
						loss, and theft, and provides a replacement phone up to two times in twelve months after the deductible 
						or any processing fees are paid. If a device is damaged and does not pass the 3-point inspection at trade 
						in, you must file a claim for the damaged device through PHP and pay the deductible or any processing fee 
						to replace it before a trade-in for an upgrade can be initiated. However, this can be handled in one visit 
						to a participating T-Mobile store. If you want to file a PHP claim but not process an upgrade, you can 
						call the vendor directly without a store visit.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPWhenDesc')">
							How often can I JUMP!?
						</a>
					</div>
					<div id="JUMPWhenDesc" class="toggleDescription" style="display:none;">
						There are no limitations on how many times you can upgrade with JUMP!. We want you to pick the frequency 
						that's right for you. When you're ready, trade in your eligible device and T-Mobile will cover your 
						remaining device payments up to half of your device cost.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPTimeframeDesc')">
							How quickly after a device purchase can I upgrade?
						</a>
					</div>
					<div id="JUMPTimeframeDesc" class="toggleDescription" style="display:none;">
						There are no waiting periods on when you can upgrade with JUMP!. When you are ready to upgrade, trade in 
						your eligible device and T-Mobile will pay off your remaining device payments, up to half of your original 
						cost. Any remaining EIP balance must be paid at the time of upgrade.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPFrequencyDesc')">
							When I originally signed up for JUMP!, I was told I had to wait to upgrade and also had a limit on how 
							frequently I could upgrade in a year. What happened?
						</a>
					</div>
					<div id="JUMPFrequencyDesc" class="toggleDescription" style="display:none;">
						Customers have spoken, and we've listened.  We've simplified the original program by removing these 
						limitations to truly give customers control over when to upgrade.  Unlimited upgrades with no waiting 
						periods means ultimate freedom.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPHowToJumpDesc')">
							I'm a current JUMP! customer. How can I take advantage of this new program?
						</a>
					</div>
					<div id="JUMPHowToJumpDesc" class="toggleDescription" style="display:none;">
						Customers who added JUMP! before 02/23/2014 will be subject to the existing terms of the program, however, 
						once you upgrade to a new device, you may migrate to the new program at no additional costs.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPPrepaidDesc')">
							Are prepaid phones and tablets eligible for JUMP!?
						</a>
					</div>
					<div id="JUMPPrepaidDesc" class="toggleDescription" style="display:none;">
						No, prepaid devices are not financed on EIP, so they are not eligible.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPRightForMeDesc')">
							I usually upgrade my phone every couple of years. Is JUMP! right for me?
						</a>
					</div>
					<div id="JUMPRightForMeDesc" class="toggleDescription" style="display:none;">
						JUMP! is designed to give you full control of your upgrade frequency as well as ultimate peace of mind when 
						it comes to your device.  If you'd like to fully protect your device investment as well as have the flexibility 
						to affordably get one of our new devices released in the future, JUMP! is for you.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPDifferencesDesc')">
							How is JUMP! different from the other carriers' upgrade programs?
						</a>
					</div>
					<div id="JUMPDifferencesDesc" class="toggleDescription" style="display:none;">
						JUMP! is the only comprehensive program among the major national carriers that protects a customer's phone 
						investment from virtually any eventuality—including obsolescence. JUMP! includes device protection and 
						mobile security features that other carriers may charge separately for, so you get what you want – device 
						peace of mind and the ability to upgrade when you want, not when you're told.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPRewardDesc')">
							How does the JUMP! program reward me for staying with T-Mobile?
						</a>
					</div>
					<div id="JUMPRewardDesc" class="toggleDescription" style="display:none;">
						Not only do you get peace of mind with device protection and mobile security, you also get the benefit of 
						T-Mobile paying off the remaining payments of your current device when you trade it in, up to half of your 
						device cost. Upgrade to our latest and greatest devices, any time you want, as often as you want. Only 
						T-Mobile offers this kind of comprehensive, all-in-one device program.
					</div>
				</div>
				<div class="FAQBlock">
					<div class="blockToggle">
						<a href="##" class="toggleTitle" onclick="ToggleFAQ('#JUMPQuitDesc')">
							What if I change my mind and don't want JUMP! anymore?
						</a>
					</div>
					<div id="JUMPQuitDesc" class="toggleDescription" style="display:none;">
						You can remove the JUMP! feature any time, but you can only add it within 14 days of a new device purchase 
						financed on EIP.
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="planRowLast">
		<div class="rowContent">
			<div class="contentLegal">
				<div class="legalBlock">
					Deductible or processing fee will apply if traded-in device is lost/stolen, not in good working order, 
					does not power on, or has liquid damage or broken screen; up to two Premium Handset Protection claims 
					in a 12 month period.
				</div>
				<div class="legalBlock">
					Limited time offer; subject to change. Qualifying service plan with financed device required. Pay 50% 
					of your device cost to be eligible for upgrades. Trade-in of an eligible device required. Eligible 
					device must be in good working order. JUMP! must be added within 14 days of a qualified device purchase. 
					Device pricing may vary based on approved credit. Offer may not be available in all locations. NY 
					residents must use JUMP! benefits prior to completing 2 insurance claims in 12 months. JUMP! upgrades 
					from T-Mobile; trade-in benefits through CWork Solutions, LP. Program fees paid to CWork. No separate 
					insurance fees, except in NY.
				</div>
			</div>
		</div>
	</div>
	
</div>