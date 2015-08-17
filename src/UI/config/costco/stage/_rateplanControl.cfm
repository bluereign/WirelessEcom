<cfscript>
	// create the activationType sub-struct
	activationType = {
		new = true,
		upgrade = true,
		addaline = true
	};

	// create the planType sub-struct
	planType = {
		individual = duplicate(activationType),
		family = duplicate(activationType),
		data = duplicate(activationType)
	};

	// create the carrier sub-struct
	carrier = {
		109 = duplicate(planType),	// AT&T
		128 = duplicate(planType),	// T-Mobile
		42 = duplicate(planType),	// Verizon
		299 = duplicate(planType)	// Sprint
	};

	// create the main struct
	request.rateplanControl = duplicate(carrier);

	// now that the master all-enabled struct has been built, flag any exceptions below

	// disallow all family plan / upgrade combinations
	request.rateplanControl[109]['family']['upgrade'] = false;
	request.rateplanControl[128]['family']['upgrade'] = false;
	request.rateplanControl[42]['family']['upgrade'] = true;
	request.rateplanControl[299]['family']['upgrade'] = true;

	request.rateplanControl[109]['shared']['upgrade'] = true;
	request.rateplanControl[128]['shared']['upgrade'] = false;
	request.rateplanControl[42]['shared']['upgrade'] = true;
	request.rateplanControl[299]['shared']['upgrade'] = true;

	// disallow all family plan / addaline combinations
	request.rateplanControl[109]['family']['addaline'] = false;
	request.rateplanControl[128]['family']['addaline'] = false;
	request.rateplanControl[42]['family']['addaline'] = true;
	request.rateplanControl[299]['family']['addaline'] = true;
</cfscript>
