<cfscript>
	carrier = {
		109 = true,	// AT&T
		128 = true,	// T-Mobile
		42 = true,	// Verizon
		299 = true  // Sprint
	};

	// create the main struct
	request.checkoutControl = duplicate(carrier);

	// now that the master all-enabled struct has been built, flag any exceptions below

	// uncomment following line to disallow checkout for AT&T
	// request.checkoutControl[109] = false;

	// uncomment following line to disallow checkout for T-Mobile
	// request.checkoutControl[128] = false;

	// uncomment following line to disallow checkout for Verizon
	// request.checkoutControl[42] = false;

	//Temp checkout redesign control
	request.CheckoutRedesignControl.Upgrade.Carrier = {
		VZN = false,
		ATT = false,
		TMO = false,
		SPT = false
	};
</cfscript>
