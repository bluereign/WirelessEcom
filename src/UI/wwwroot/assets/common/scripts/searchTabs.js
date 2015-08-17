InitSearchTabs = function ()
{
	var localTabContainers = $('divTabs').select('div.tabContent');
	var firstTab = localTabContainers[0];
	localTabContainers.each(Element.hide);
	firstTab.show();

	var tabNavigators = $('tabNavigation').select('a');
	tabNavigators.each(function(elem,index){
		Event.observe(elem, 'click', ChangeActiveTab);
		if (index == 0)
			elem.addClassName('selected');
	});
}

ChangeActiveTab = function (event)
{
	if(event.element().tagName != "A") return;
	//clear all tabs
	var allTabs = $('tabNavigation').select('a');
	allTabs.each(function(elem, index) { elem.removeClassName('selected'); });
	var localTabContainers = $('divTabs').select('div.tabContent');
	localTabContainers.each(Element.hide);

	event.element().addClassName('selected');
	$(event.element().hash).show();
	event.element().blur();
	event.stop();
	return false;
}

document.observe("dom:loaded", InitSearchTabs);
