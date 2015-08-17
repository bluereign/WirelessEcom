<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<script>
	jQuery(function($) {
		active = window.location.hash;

		$("#faqAccordion").accordion({
			autoHeight: false,
			active: active
		});
		$("#presaleAccordion").accordion({
			autoHeight: false,
			active: active
		});
		
		$("#billingAccordion").accordion({
			autoHeight: false
		});
		$("#supportAccordion").accordion({
			autoHeight: false
		});
		$("#orderAccordion").accordion({
			autoHeight: false
		});		
		$("#shippingAccordion").accordion({
			autoHeight: false
		});
		$("#carrierAccordion").accordion({
			autoHeight: false
		});
		$("#portingAccordion").accordion({
			autoHeight: false
		});
	});
</script>
<h1>Frequently Asked Questions</h1>

<div id="faqAccordion">
	<h2><a href="##">Customer Care</a></h2>
	
	<div id="customerCareAccordion" class="supportAccordionLevelIndent">
		<h3><a name="contactCC"></a>How do I contact Customer Service? </h3>
		<p>
			Wireless Advocates Customer Service is available to help you by email or phone Monday through 
			Friday 6am - 6pm Pacific Standard Time.
		</p>	
		<ul>
			<li>To contact us by phone: <cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput> (toll-free)
			<li>To contact us by email: <a href="mailto:<cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput>">
				<cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput></a>
		</ul>
	</div>

	<h2 class="presaleAccordionTopBorder" id="preseale"><a href="##">Pre-Sale Orders</a></h2>
	<div id="presaleAccordion" class="presaleAccordionLevelIndent">
		<h3><a name="reservenow">Why is my order listed as "reserve now"?</a></h3>
		<p>
			 Items listed as "reserve now" can be ordered although the item is not in stock and is a pre-sale item.  
			 Once your order is received and confirmed at our distribution center, the product will be shipped to your delivery address.  
		</p>	

		<h3><a name="receiveorder">When will I receive my order?</a></h3>
		<p>
			 All orders will be processed in the order in which they were received.  
			 Please refer to the expected processing date you received when placing your order.
			 Processing time can vary from 24-48 hours.  
		</p>	

		<h3><a name="prevpurchase">I purchased a previous device less than 14 days ago.  Can I exchange it for a Pre-Sale device?</a></h3>
		<p>
			 We do not accept exchanges for items with no active inventory.  "Reserve now" items do not qualify for an exchange.  
		</p>
			
		<h3><a name="canichange">Can I change my order?</a></h3>
		<p>
			 If you would like to make any changes to your order please give us a call.  
			 A Customer Service representative will assist you in cancelling your order so that you can place an amended order.   
			 Orders cannot be changed once they have been submitted.   
		</p>	

	</div>
	
	<h2 class="supportAccordionTopBorder" id="billed">
		<a href="##">Billing</a>
	</h2>
	<div id="billingAccordion" class="levelIndent">
		<h3>
			<a href="##">Will I need to pay a deposit?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Deposits could be required by the carrier to activate new service but unfortunately, we are not 
				able to take deposits for the carrier online. However, you can visit your local Exchange Mobile 
				Center to make a purchase. The carrier's credit determination is based solely on the carrier's 
				credit policies.
			</p>
		</div>
		<h3>
			<a href="##">How will I be billed?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				You will be billed for any equipment related charges such as wireless devices, accessories, airtime cards, 
				expedited shipping, and/or applicable sales tax when your order is submitted. Due to California 
				state law, taxes are applied on the Cost of Goods sold, and not the retail or net price. Your 
				credit card statement will show our charges as "Wireless Advocates". The wireless carrier you 
				selected will bill you for any plan-related charges such as your monthly plan fee.
			</p>
		</div>
		<h3>
			<a href="##">Forms of Payment</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				We accept the following forms of payment:
				<ul>
					<li>American Express</li>
					<li>Visa</li>
					<li>Master Card</li>
					<li>Discover Card</li>
					<li>Star Card</li>
				</ul>
			</p>
		</div>
		<h3>
			<a href="##">Sales Tax</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Your Wireless Advocates purchase includes sales tax as required by law. The tax rate applied to 
				your order will generally be the combined state and local rate for the zip code of your shipping 
				address. Due to California state law, taxes are applied on the Cost of Goods sold, and not the 
				retail or net price.
			</p>
		</div>
		<h3>
			<a href="##">Rebate Information</a>
		</h3>
		<div class="supportAccordionLevelIndent">	
			<p>
				To view our current active rebates visit out our <a href="/index.cfm/go/content/do/rebateCenter/">
				rebate center</a>. All Wireless Advocates/Stuart Lee Rebate offers must be postmarked by the US 
				Postal Service within 30 days from the date of purchase for the rebate to be valid. Once Stuart 
				Lee receives your rebate submission, you can track its progress at 
				<a href="http://stuartleerebates.com/">StuartLeeRebates.Com</a>. If you have any additional 
				questions or concerns, please contact Customer Care at <cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput> Monday through Friday 6am 
				to 6pm, Pacific Standard Time.
			</p>
		</div>
	</div>
	<h2 class="supportAccordionTopBorder">
		<a href="##">Website Support</a>
	</h2>
	<div class="supportAccordionLevelIndent" id="supportAccordion">
		<h3>
			<a href="##">Item Search</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				To look for a specific item in our catalog, type the keyword into the search textbox in the 
				upper-right corner of our <a href="/index.cfm">homepage</a>. <br />
				Search Tips:
				<ul>
					<li>
						Try using a more general search term. Using fewer words in the search field will 
						improve your results.
					</li>
					<li>
						Try using different words to describe what you're looking for.
					</li>
					<li>
						Correct any spelling errors.
					</li>
					<li>
						Ensure that you are searching with the correct carrier (ex. Verizon, T-Mobile, AT&T).	
					</li>
				</ul>
			</p>
		</div>
	
		<h3>
			<a href="##">Register / Login</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				You can register or Login by going to the "<a href="/index.cfm/go/myAccount/do/login/">My 
				Account</a>" section of the Web site, and entering your password and account name.
			</p>
		</div>
		
		<h3>
			<a href="##">Forgotten Password</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				If you have forgotten the password to your account, but you still have the email address that 
				you created the account with, then you can <a href="/index.cfm/go/myAccount/do/forgotPassword/">
				reset your password here</a>.
			</p>
		</div>
	</div>
	<h2 class="supportAccordionTopBorder">
		<a href="##">Order Inquiries</a>
	</h2>
	<div id="orderAccordion" class="supportAccordionLevelIndent">
		<h3>
			<a href="##">What are the Terms and Conditions of my purchase?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Your Terms and Conditions will be included in your shipment. Please follow this link to print 
				the current <a href="/index.cfm/go/content/do/serviceAgreement">Carrier Terms and Conditions</a>.
			</p>
		</div>		
		<h3>
			<a href="##">Receipt / Order History</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Order details can be found in the "My Account" section of our website. Click on "Manage Your 
				Account", and enter your username and password to view all current and previous order details. 
				To login now follow this <a href="/index.cfm/go/myAccount/do/login">link</a>. 
			</p>
		</div>
		<h3>
			<a href="##">How do I track the status of my order?</a>
		</h3>
		<div class="supportAccordionLevelIndent">		
			<p>
				You can find details of all orders placed under the My Account section on our website. It's 
				fairly simple! Click on <a href="/index.cfm/go/myAccount/do/login">Sign in to Your Account</a>, 
				and enter your username and password to view all previous orders.
			</p>
		</div>
		<h3>
			<a href="##">How do I Change or Cancel Order?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				If you would like to change or cancel your order, please call our Customer Service Specialists 
				at <cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput> as soon as possible. We will do everything we can to accommodate your request. 
				Once the activation process has begun, the order cannot be canceled. Please refer to our 
				Return/Exchange Policy. 
			</p>
		</div>
	</div>

	<h2 class="supportAccordionTopBorder" id="return_phone">
		<a href="##">Returns and Exchanges</a>
	</h2>
		<div class="supportAccordionLevelIndent">
			<p>
				The Return Policy for all exchangemobilecenter.com purchases is 14 days from date of purchase. 
				Orders must be returned in a complete, like-new condition with all accessories, packaging, and 
				instructions. If you process a full return within 14 days you may receive a refund on the devices 
				themselves and we will contact the carrier to cancel your service with no early termination fees. 
				If you choose to cancel your service after the end of the Carrier Trial Period you will be responsible 
				for any applicable early termination fees. The Trial Period varies by carrier and state. See the 
				carrier Cancellation Policy for details.
			</p>
			<p>
				To process a return or exchange, call or email our Customer Care Specialists.
			</p>
			<div style="font-weight: bold;">Returns:</div>
			<ol>
				<li>
					Contact Customer Care at <cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput> or <a href="mailto:<cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput>">
					<cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput></a>
				</li>
				<li>
					Customer Care will provide you with a return authorization and a prepaid shipping label.
				</li>
				<li>
					After receiving the shipping label, securely package your items and place 
					in any UPS location or drop box before the end of your 14 day return period. 
				</li>
				<li>
					Upon receipt at our distribution center, you will be refunded for your order. This process 
					takes approximately 1-2 weeks. 
				</li>
			</ol>
			<div style="font-weight: bold;">Exchanges:</div>
			<ol>
				<li>
					Contact Customer Care at <cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput> or <a href="mailto:<cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput>">
					<cfoutput>#channelConfig.getCustomerCareEmail()#</cfoutput></a>
				</li>
				<li>
					Customer Care will provide you with a return authorization and a prepaid shipping label.
				</li>
				<li>
					After receiving the shipping label, securely package your items and place in any UPS location 
					or drop box before the end of your 14 day return period. 
				</li>
				<li>
					Upon receipt at our distribution center, your original purchase will be refunded to you.
				</li>
				<li>
					You will receive a payment link to pay for your new handset.
				</li>
				<li>
					Once payment is received, your new device will be shipped to you.
				</li>
			</ol>
			<p>
				Please contact Customer Care for any further questions regarding returns and exchanges. 
			</p>
		</div>
	<h2 class="supportAccordionTopBorder" id="Shipping">
		<a href="##">Shipping</a>
	</h2>
	<div id="shippingAccordion" class="levelIndent">
		<h3>
			<a href="##">Shipping Method</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				All shipments are sent via UPS, Monday - Friday. You will receive an email from UPS once your 
				order is packaged for shipping with tracking information.  The shipment will not require a 
				delivery signature. If the driver does not leave your order, they will leave an InfoNotice 
				where you will find instructions on rescheduling your delivery, having your shipment delivered 
				to a different address, or arranging to pick up your shipment at a UPS location. UPS will make 
				3 attempts to deliver the package. If they are unsuccessful after 3 attempts, UPS will hold the 
				package for 5 business days and then it will be returned to the shipper.
			</p>
		</div>
		<h3>
			<a name="Shipping" href="##">Tracking a Shipment</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Once you receive a tracking information email from UPS, you can track your shipment at 
				<a href="http://www.ups.com">www.ups.com</a>. 
			</p>
		</div>
		
		<h3>
			<a href="##">Lost Shipment</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Please contact Customer service 1- <cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput> Monday-Friday 6am - 6pm, Pacific Standard Time.
			</p>
		</div>
		
		<h3>
			<a href="##">International Orders</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				We do not ship outside of the United States unless to an APO/FPO Box address. Please see APO/FPO Box 
				shipping information below.
			</p>
		</div>
		<h3>
			<a href="##">P.O. Boxes</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Wireless Advocates does not ship to PO Boxes. If you do not have a non-PO Box address, please 
				visit your nearest Exchange Mobile Center. For additional questions regarding shipping, please 
				contact our Customer Care Specialists at <cfoutput>#channelConfig.getCustomerCarePhone()#</cfoutput>.
			</p>
		</div>
		
		<h3>
			<a href="##" name="PO_Boxes">APO/FPO Box</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				If you need to use an APO / FPO address, please enter your information in the following manner:
			</p> 
			<ul>
				<li>
					<span style="font-weight: bold;">Address Field 1:</span> Army, Navy and Marines enter Unit 
					Number and Box Number; for Ships, enter Ship Name and Hull Number; for Air Force, enter PSC 
					Number and Box Number.
				</li>
				<li>
					<span style="font-weight: bold;">Address Field 2:</span> You can enter optional military 
					command or organization name.
				</li>
				<li><span style="font-weight: bold;">City:</span> Enter APO or FPO</li>
				<li>
					<span style="font-weight: bold;">State:</span> Select one of the following:
			    	<ul>
				    	<li>AE - Armed Forces Europe, Middle East, Africa and Canada</li>
				    	<li>AA - Armed Forces Americas</li>
				    	<li>AP - Armed Forces Pacific</li>
					</ul>
				</li>
				<li>
					<span style="font-weight: bold;">Zip:</span> Enter the 5-digit ZIP code for the military 
					unit. 
				</li>
			</ul>
		</div>
	</div>
	<h2 class="supportAccordionTopBorder">
		<a href="##">Carrier Agreements and Account Information</a>
	</h2>
	<div id="carrierAccordion" class="supportAccordionLevelIndent">
		<p>
			Each carrier has specific terms and conditions to the service contract you are signing. Please 
			select your carrier for details:
			<ul>
				<li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/att/" target="_blank">AT&T Terms and Conditions</a></li>
				<li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/tmobile/" target="_blank">T-Mobile Terms and Conditions</a></li>
				<li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/verizon/" target="_blank">Verizon Terms and Conditions</a></li>
		        <li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/Sprint/" target="_blank">Sprint Terms and Conditions</a></li>
		        <li><a href="/index.cfm/go/content/do/displayDocument/?doc=termsandconditions/boost/" target="_blank">Boost Terms and Conditions</a></li>
			</ul>
		</p>

		<h3>
			<a href="##">How much will I be charged if I cancel my wireless service?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<div style="text-decoration: underline;">AT&amp;T:</div>
			<p>
				AT&amp;T gives all customers a 14 day (from date of purchase) trial period to try out the 
				service without incurring an early termination fee. If the service is canceled after the 14 day 
				trial period, AT&T will charge the subscriber an early termination fee per line of service as 
				follows:
				<ul>
					<li>
						Advanced Handset: $325 Early Termination Fee (Fee will be reduced by $10 for each full 
						month completed toward the minimum term of the contract). Note: Visit 
						<a href="http://www.att.com/equipment">www.att.com/equipment</a> for details on AT&amp;T 
						handset types.
					</li>
					<li>
						Standard Handset: $150 Early Termination Fee (Fee will be reduced by $4 for each full 
						month completed toward the minimum term of the contract). Note: Visit 
						<a href="http://www.att.com/equipment">www.att.com/equipment</a> for details on AT&amp;T 
						handset types.
					</li>
				</ul>
			</p>

			
			<p><strong>Why can I only purchase 3 lines of New Service for AT&amp;T?</strong></p>
			
			<p>
				If you would like more than 3 lines, you will need to apply for additional lines of service 
				after you receive your initial purchase.
			</p>
			<p>
				Once you receive your initial purchase, please return to our site to place your order for 
				additional lines. Please note: AT&amp;T's application requirements include: an additional credit 
				check, and may also require a minimum of 60 days service from AT&amp;T before adding additional 
				lines.
			</p>
			<p>
				A minimum deposit of $445 per line may be required when adding additional line(s). If a deposit 
				is required we invite you to visit your local Exchange Mobile Center to complete your purchase, 
				as we are unable to accept deposits online.
			</p>
			
			<div style="text-decoration: underline;">Sprint</div>
			<p>
				Sprint gives all customers a 14 day (from date of purchase) trial period to try out the service 
				without incurring an early termination fee. If the service is canceled after the 14 day trial 
				period, Sprint will charge the subscriber an early termination fee per line of service. 
				Customers will be responsible for an early termination fee of up to $350 ("ETF") for each 
				line/number terminated early. 
			</p>
			
			<div style="text-decoration: underline;">Verizon:</div>
			<p>
				Verizon Wireless gives all customers a 14 day (from date of purchase) trial period to try out 
				the service without incurring an early termination fee. If the service is canceled after the 14 
				day trial period, Verizon will charge the subscriber an early termination fee per line of 
				service as follows:
				<ul>
					<li>
						Advanced Handset: $350 Early Termination Fee (Fee will be reduced by $10 for each full 
						month completed toward the minimum term of the contract). Note: Visit 
						<a href="http://www.verizonwireless.com/advanceddevices">
							www.verizonwireless.com/advanceddevices 
						</a> for details on Verizon handset types.
					</li>
					<li>
						Standard Handset: $175 Early Termination Fee (Fee will be reduced by $5 for each full 
						month completed toward the minimum term of the contract). Note: Visit 
						<a href="http://www.verizonwireless.com/advanceddevices">
							www.verizonwireless.com/advanceddevices 
						</a> for details on Verizon handset types.
					</li>
				</ul>
			</p>	
			
			
			<div style="text-decoration: underline;">T-Mobile:</div>
			<p>
				T-Mobile gives all customers a 14 day (from date of purchase) trial period to try out the 
				service without incurring an early termination fee. If the service is canceled after the 14 day 
				trial period, T-Mobile will charge the subscriber an early termination fee per line of service 
				as follows:
				<ul>
					<li>
						For California customers there is 30 day (from date of purchase) trial period to try 
						out the phone and T-Mobile service without incurring an early termination fee
						<li>
							$200 if service is canceled with more than 180 days remaining on the term
						</li>
						<li>
							$100 if service is canceled with 91 to 180 days remaining on the term
						</li>
						<li>
							$50 if service is canceled with 31 to 90 days remaining on the term
						</li>
						<li>
							$50 or the monthly recurring charges, whichever is less, if service is canceled within 
							the last 30 days of the term
						</li>
					</li>
					<li>
						Based on carrier, changes and additional fees may be applied. Visit your carrier's 
						website for details.
					</li>
				</ul>
			</p>
		</div>
	</div>
	<h2 class="supportAccordionTopBorder">
		<a href="##">Porting Existing Phone Numbers</a>
	</h2>
	<div id="portingAccordion" class="supportAccordionLevelIndent">
		<h3>
			<a href="##">Can I transfer my current phone number from one carrier to another?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Yes, as long as your account is still active with your existing carrier, you normally can keep 
				your existing phone number. You may want to check with your carrier to ensure that you are not 
				still under contract before porting your number over to another carrier - if you are under 
				contract you may incur fees associated with early termination.
			</p>
		</div>
		
		<h3>
			<a href="##">What is port eligibility?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Port eligibility is the process of verifying that the number requested for porting is local to 
				the service area where the port is to occur, and confirming that the carrier has both a license 
				and coverage in the specified service area. If eligible, you may be able to transfer your 
				existing phone number to the carrier of your choice.
			</p>
		</div>
		
		<h3>
			<a href="##">How long will it take to switch my phone number to a different carrier?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Transferring your existing phone number can take a few minutes or up to 24 hours. If you are 
				transferring a landline number it may take up to 10 days to complete. Due to this variation in 
				processing there may be a lapse in service until the port is complete.
			</p>
		</div>
		
		<h3>
			<a href="##">Who should I contact if I am having problems transferring my number to another carrier?</a>
		</h3>
		<div class="supportAccordionLevelIndent">
			<p>
				Information provided must exactly match your current service provider's records. If there is a 
				mismatch in the data, your port will be delayed. Things like misspelled names, incorrect billing 
				addresses, and incomplete information can delay your transfer. If we experience a problem during the 
				number transfer process we will provide you with a temporary number and send an email to the email 
				address provided with instructions on how you can complete the porting process.
			</p>
		</div>
	</div>
</div>
