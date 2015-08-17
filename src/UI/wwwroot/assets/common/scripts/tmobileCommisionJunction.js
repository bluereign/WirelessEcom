function showTmobileRedirectDisclaimer(url, channel)
{
	if(channel === 'COSTCO') {
		var x=window.confirm("You will now be transferred to T-Mobile's website. If you approve and proceed, T-Mobile will share your information (including your name, address, e-mail address, phone number, traffic and order data, device type, rate plan and features, and return and exchange details) with Costco and Wireless Advocates upon the completion of your transaction. Your customer information will be shared for purposes of Wireless Advocates' accounting and reporting of your T-Mobile transaction and to permit Wireless Advocates to provide you with customer service - including sending you your free Accessory Bundle Pack and Costco Cash Card.\n\nPlease note these items will ship separately from the wireless device. For more information on how T-Mobile collects, uses, discloses, and stores customer information, please visit T-Mobile's privacy policy.\n\nPlease click 'OK' to approve and proceed or click 'Cancel' to exit this process.");
	} else {
		var x=window.confirm("You will now be transferred to T-Mobile's website.  If you approve and proceed,  T-Mobile will share your information (including your name, address, e-mail address, phone number, traffic and order data, device type, rate plan and features, and return and exchange details) with Wireless Advocates upon the completion of your transaction.  Your customer information will be shared for purposes of Wireless Advocates' accounting and reporting of your T-Mobile transaction and to permit Wireless Advocates to provide you with customer service - including sending you any Wireless Advocates benefits for which you are eligible based on this transaction.  For more information on how T-Mobile collects, uses, discloses, and stores customer information, please visit T-Mobile's privacy policy.\n\nPlease click 'OK' to approve and proceed or click 'Cancel' to exit this process.");
	}
	
	// Modified on 11/25/2014 by Denard Springle (denard.springle@cfwebtools.com)
	// Track: 7023 - Add Analytics to track User's T-Mobile Affiliate Message Click-Through decision [ Added GA event tracking ] 
	if (x) {
		if(channel === 'COSTCO') {
			try { _gaq.push(['_trackEvent', 'T-Mobile Affiliate', 'Transfer Pop-Up', 'OK']); } catch (e) {}
		} else {
			try { ga('send', 'event', 'T-Mobile Affiliate', 'Transfer Pop-Up', 'OK'); } catch (e) { }
		}
		window.location = url;
	} else {
		if(channel === 'COSTCO') {
			try { _gaq.push(['_trackEvent', 'T-Mobile Affiliate', 'Transfer Pop-Up', 'Cancel']); } catch (e) {}
		} else {
			try { ga('send', 'event', 'T-Mobile Affiliate', 'Transfer Pop-Up', 'Cancel'); } catch (e) { }
		}
	}
}