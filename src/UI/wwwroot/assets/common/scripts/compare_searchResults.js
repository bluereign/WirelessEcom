function InitCompareCheckbox() {
	var checks = $('allResults').select('.compareCheck');
	checks.each(function(elem, index) {
		Event.observe(elem, 'click', ToggleCompare);
		if (elem.checked) {
			Element.addClassName(elem.parentNode.parentNode.parentNode, "compare");
		}
	});
}

function ToggleCompare(event) {
	// make sure we can't select more than 5 of these.
	var totalChecks = 0;
	var checks = $('allResults').select('.compareCheck');
	checks.each(function(elem, index) {
		Event.observe(elem, 'click', ToggleCompare);
		if (elem.checked) {
			totalChecks++;
		}
	});
	
	//get input, li
	var check = event.findElement('input[type=checkbox]');
	var li = check.parentNode.parentNode.parentNode;
	//check for compare mark
	if (check.checked) {
		// make sure we can't select more than 5 of these.
		if (totalChecks > 5) {
			alert("You can only compare 5 items.");
			check.checked = false;
		}
	}		

	if (check.checked) {
		//add the compare mark
		li.addClassName('compare');
	} else {
		li.removeClassName('compare');
	}
}