<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />

<cfoutput>
<h1>Frequently Asked Questions</h1>

<h2>Contact Information</h2>
<h3><a name="contactCC"></a>How do I contact Customer Care?</h3>
<p>Customer Care is available to help you phone Monday through Friday 6am - 6pm Pacific Time.</p>
<ul>
	<li>To contact us by phone:  #channelConfig.getCustomerCarePhone()#
</ul>

<h2>Important Information while placing your order</h2>
<h3><a name="contactCC"></a>I already have a data package why am I being forced to choose a new one? Can I keep my existing data package?</h3>

<p><b>Verizon</b> - We will make every effort to keep your existing data package. If for any reason we are unable to keep your existing data, we will activate the data that you selected during order placement.  As a Verizon Wireless customer, you have choices when you upgrade at discounted pricing. You can choose from a standalone data package starting at $30 for 2GB or a Share Everything plan. If keeping unlimited is important to you, you can choose to purchase a wireless device at full retail price from your carrier.</p>
<p><b>Sprint</b> - We will make every effort to keep your existing data package.  If for any reason we are unable to we will contact you via email before processing your order.</p>

<h3><a name="contactCC"></a>Can I purchase a wireless device at full retail price without signing up for or renewing a contract?</h3>
<p>Currently we do not sell phones at full retail price. Please contact your carrier to inquire about purchasing a phone without a contract.</p>

<h2>Returns, Cancellations and Exchanges</h2>

<h3><a name="return_phone"></a>If I do not like my phone, can I return it?</h3>
<p>You have a 14-day carrier trial period. After 14 days you are responsible for any applicable fees (see carrier Cancellation Policy). All phone(s) must be returned in a complete, like-new condition with all accessories, box, and instructions. All cellular phone purchases require either a new 2-year activation agreement or a qualified upgrade.</p>
<p>Call for return authorization and a prepaid label. After receiving the label, send the item back. Upon receipt at our distribution center, you will be refunded. This process takes approximately 1-2 weeks. All merchandise including all of the components, must be returned in original, like new condition.</p>



<h3><a name="cancel_order"></a>How do I cancel my order?</h3>
<p>If you would like to cancel your order, please call #channelConfig.getCustomerCarePhone()# as soon as possible. We will do everything we can to accommodate your request but cannot guarantee that we can cancel your order due to real time order processing. Once an order has entered the activation process we will be unable to cancel the order.</p>

<h2>Payment and Shipping</h2>

<h3><a name="track_status"></a>How do I track the status of my order? </h3>
<p>You can find details of all orders placed under the My Account section on our website.  It's fairly simple! Click on <a href="/index.cfm/go/myAccount/do/view">Sign in to Your Account</a>, and enter your username and password to view all previous orders.</p>

<h3><a name="Lost_Order"></a>What if my order is lost?</a></h3>
<p>Please contact Customer Service #channelConfig.getCustomerCarePhone()# Mon-Fri 6am - 6pm, Pacific Time.</p>

<h3><a name="order_delivered"></a>How will my order be delivered?</h3>
<p>We ship all orders via UPS shipping. If you requested Overnight Delivery, your order will be delivered on the next business day after the carrier approved your order.  We will notify you via e-mail once your order has shipped with its expected arrival date. We will also notify you via email if we cannot ship your order within 3 business days. Accessory only orders will ship via USPS in 2-4 business days.</p>

<p>Activations are typically processed within 3-5 business days of your order being placed.&nbsp; If we are unable to activate   your order within that time, we will contact you via email.&nbsp; Once your order is   activated, it will enter the shipping process and you will receive an email notification of the shipment.</p>

<h3><a name="Shipping"></a>How do I know when my order has shipped?</h3>
<p>We will notify you via e-mail once your order has shipped with its expected arrival date. We will also notify you via email if we cannot ship your order within 3 business days. Accessory only orders will ship via USPS in 2-4 business days. We do not ship outside of the U.S.</h3>
<p>Activations are typically processed within 3 business days of your order being placed.  If we are unable to activate your order within that time, we will contact you via email.  Once your order is activated, it will enter the shipping process and you will receive an email notification of the shipment. Please review our <a href="/index.cfm/go/content/do/Shipping">Shipping Policy</a> for more details.</p>

<h3><a name="PO_Boxes"></a>Can I ship to a P.O. Box or an APO/FPO Box?</h3>
<p>We do not ship to APO/FPO boxes at this time. However, we do accept PO Box billing addresses for some transactions (Verizon orders only). 

<h3><a name="billed"></a>How will I be billed?</h3>
<p>We will bill you for any equipment related charges such as wireless devices, accessories, airtime cards, expedited shipping, and/or applicable sales tax when your order is submitted. Due to California state law, taxes are applied on the Cost of Goods sold, and not the retail or net price. </p>
<p>Your credit card statement will show our charges as &quot;Wireless Advocates&quot;. The wireless carrier you selected will bill you for any plan-related charges such as your monthly plan fee.</p>

<h3><a name="tax-exempt"></a>I am tax exempt. Can I order online?</h3>
<p>We regret that we are not able to accept tax exempt paperwork for online orders.</p>

<h2>Carrier Information</h2>
<h3><a name="keepnumber"></a>Can I keep my current phone number?</h3>
<p>Yes, as long as your account is still active with your existing carrier, you normally can keep your existing phone number. You may want to check with your carrier to ensure that you are not still under contract before porting your number over to another carrier - if you are under contract you may incur fees associated with early termination.   
For a quick check to see if you are eligible to port your number to another carrier, please click on the link below.</p>

<h3><a name="terms_conditions"></a>What are the Terms and Conditions of my purchase?</h3>
<p>Your Terms and Conditions will be included in your shipment. Please follow this link to print the current <a href="/index.cfm/go/content/do/serviceAgreement">Carrier Terms and Conditions</a>.</p>

<h3><a name="pay_desposit"></a>Will I need to pay a deposit?</h3>
<p>Unfortunately we are not able to take deposits for the carrier online. Deposit required orders will be cancelled. The carrier's credit determination is based solely on the carrier's credit policies.</p>

<h2>Account Information</h2>
<h3><a name="Forgot_PIN"></a>What do I do if I've forgotten my PIN number?</h3>
<p>Try the last 4 digits of your social security number. If that PIN does not work, contact the carrier and have your PIN reset.</p>
<ul>
  <li>Verizon 800-922-0204</li> 
  <li>Sprint 1-888-211-4727</li>
</ul>
<p>We recommend that you request the carrier reset your PIN to the last four digits of the primary account holder's social security number or a number you frequently use and can easily remember.</p>

<h3><a name="early_termination"></a>How much will I be charged if I cancel my wireless service?</h3>

<p><strong>Sprint:</strong>
<p>Sprint gives all customers a 14 day (from date of purchase) trial period to try out the service without incurring an early termination fee. If the service is canceled after the 14 day trial period, Sprint will charge the subscriber an early termination fee per line of service. Customers will be responsible for an early termination fee of up to $350 ("ETF") for each line/number terminated early.</p>

<p><strong>Verizon:</strong></p>
<p>You can try out our service for 14 days. Verizon Wireless gives all customers a 14 day (from date of purchase) trial period to try out the phone and Verizon service without incurring an early termination fee. If the service is canceled after the 14 day trial period, Verizon will charge the subscriber an early termination fee per line of service as follows:
<p>
<strong>Advanced Handset:</strong> $350 Early Termination Fee (Fee will be reduced by $10 for each full month completed toward the minimum term of the contract) Note: Visit www.verizonwireless.com/advanceddevices for details on Verizon handset types.</p>
<p>
<strong>Standard Handset:</strong> $175 Early Termination Fee (Fee will be reduced by $5 for each full month completed toward the minimum term of the contract) Note: Visit www.verizonwireless.com/advanceddevices for details on Verizon handset types.</p>

<p>Based on carrier, changes and additional fees may be applied. Visit your carrier's website for details.</p>

<h3><a name="Switch_number_time"></a>How long will it take to switch my phone number to a different carrier? </h3>
<p>Transferring your existing phone number can take a few minutes or up to 24 hours. If you are transferring a landline number it may take up to 10 days to complete. </p>
<p>Due to this variation in processing there may be a lapse in service until the port is complete.</p>

<h3><a name="Switch_number_carrier"></a>Can I switch to my current phone number I already have from one carrier to another carrier?</h3>
<p>Yes, it is possible to keep the number you already have from another wireless or landline carrier</p>

<h3><a name="Problems transferring"></a>Who should I contact if I am having problems transferring my number to another carrier?</h3>
<p>
	Information provided must exactly match your current service provider's records. If there is a 
	mismatch in the data, your port will be delayed. Things like misspelled names, incorrect 
	billing addresses, and incomplete information can delay your transfer. If we experience 
	a problem during the number transfer process we will provide you with a temporary number 
	and send an email to the email address provided with instructions on how you can complete 
	the porting process.
</p>

<h3><a name="Port_eligibility"></a>What is port eligibility?</h3>
<p>Port eligibility is the process of verifying that the number requested for porting is local to the service area where the port is to occur, and confirming that the carrier has both a license and coverage in the specified service area. If eligible, you may be able to transfer your existing phone number to the carrier of your choice.</p>

<h3><a name="Verify_account"></a>How can I verify my existing account information?</h3>
<p>Refer to a recent bill or call your current service provider to verify your information. This is especially important if you have a PIN or password on your account that you can't remember.</p>

<h3><a name="Port_cancel"></a>Do I need to cancel my current service?</h3>
<p>No. The number must be in active service in order to be transferred. Your old service will be canceled automatically as part of the port process.</p>

<h3><a name="Account"></a>Where do I register for an account?</h3>
<p>You can register or login by going to the "My Account" section of the website, and entering your password and account name.</p> 

<h3><a name="Forgot_password"></a>What if I forget my password?</h3>
<p>If you have forgotten the password to your account, but you still have the e-mail address that you created the account with, then you can <a href="/index.cfm/go/myAccount/do/forgotPassword/">reset your password here</a>.</p>

</cfoutput>
