<cfscript>
	carrier = {
		109 = true,	// AT&T
		128 = true,	// T-Mobile
		42 = true,	// Verizon
		299 = true //Sprint
	};

	// create the main struct
	request.carrierControl = duplicate(carrier);

	// now that the master all-enabled struct has been built, flag any exceptions below

	// uncomment following line to disable AT&T
	// request.carrierControl[109] = false;

	// uncomment following line to disable T-Mobile
	// request.carrierControl[128] = false;

	// uncomment following line to disable Verizon
	// request.carrierControl[42] = false;

	// uncomment following line to disable Sprint
	// request.carrierControl[299] = false;
</cfscript>
