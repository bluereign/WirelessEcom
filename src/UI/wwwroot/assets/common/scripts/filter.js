var g_filterTimer;
var g_filterURL;

function BeginUpdateFilter() {
	if (g_filterTimer) {
		clearTimeout(g_filterTimer);
	}
	g_filterTimer = setTimeout(UpdateFilter, 1000);
}

function UpdateFilter(sortVal, link, activationPrice)	{
	g_filterTimer = null;
	DisableFilters();
	
	requestURL = g_filterURL;	
	
	for (i = 0; i < document.filterForm.elements.length; i++)	{
		if(document.filterForm.elements[i].checked)	{
			requestURL = requestURL + '&' + document.filterForm.elements[i].name + '=' + document.filterForm.elements[i].value;
		} else if(document.filterForm.elements[i].id == 'accessoryDevices' && document.filterForm.elements[i].value != 0){
			requestURL = requestURL + '&deviceIdFilter=' + document.filterForm.elements[i].value;
		} else if(document.filterForm.elements[i].id == 'hiddenFilterOptions')	{
			requestURL = requestURL + '&' + document.filterForm.elements[i].name + '=' + document.filterForm.elements[i].value;
		}
	}
	
	if (sortVal && isNaN(sortVal)) {
		requestURL = requestURL + '&sort=' + sortVal;
	}
	
	if (activationPrice && isNaN(sortVal)) {
		requestURL = requestURL + '&activationPrice=' + activationPrice;
	}

	ColdFusion.navigate(requestURL, 'resultsDiv');
}

function DisableFilters()	{
	Form.getElements('filterForm').each(function(elem)	{elem.disabled = true; });
}

function EnableFilters() {
	Form.getElements('filterForm').each(function(elem) { elem.disabled = false; });
}

function InitFilterAccordians() {
	//get all filter ULs
	var uls = Element.select($('filters'),'ul ul');
	uls.each(function(elem, index) {
	//if the ul has more than 5 elements, add accoridan    			
		if (elem.childElements().length > 5) {
			AddFilterAccordian(elem);
		}
	});
}

function AddFilterAccordian(elem) {
	elem.addClassName('accordian');
	//count the height of 3 children
	var kids = elem.childElements();
	var height = 0;
	var inputs;
	var anyChecked = false;
	for (var i = 0; i < kids.length; i++) {
		height += kids[i].getHeight();
		inputs = Element.select($(kids[i]),'input');
		inputs.each(function(e, idx) {
			if (e.checked)
				anyChecked = true;
		})
	}
	elem.store('accordianHigh', height);
	var lowHeight = ((height / kids.length) * 3.5);
	elem.style.height = lowHeight + 'px';
	lowHeight = elem.getHeight();
	elem.store('accordianLow', lowHeight);
	var id = elem.identify();
	elem.insert({ after: '<a href="##" class="smButton_accent" onclick="ToggleAccordian(\'' + id + '\');this.blur();return false;">more</a>' });
	if (anyChecked)
		ToggleAccordian(id);
}

function ToggleAccordian(elementID) {
	var acc = $(elementID);
	var link = acc.next();
	if (acc.getHeight() == acc.retrieve('accordianLow')) {
		//change button
		link.innerHTML = 'less';
		link.className = 'btnCollapse';
		//morph size
		new Effect.Tween(acc, acc.retrieve('accordianLow'), acc.retrieve('accordianHigh'), { duration: 0.5, transition: Effect.Transitions.sinoidal }, function(p) { this.style.height = p + 'px'; });
	} else {    			
		//change button
		link.innerHTML = 'more';
		link.className = 'btnExpand';
		//morph size
		new Effect.Tween(acc, acc.retrieve('accordianHigh'), acc.retrieve('accordianLow'), { duration: 0.5, transition: Effect.Transitions.sinoidal }, function(p) { this.style.height = p + 'px'; });
	}
}
