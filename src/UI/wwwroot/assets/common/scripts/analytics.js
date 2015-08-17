jQuery(document).ready(function() {
	jQuery("#nav-menu a").click(function() {
		try	{ _gaq.push(['_trackEvent', 'Navigation Menu', jQuery(this).attr('col'), jQuery(this).text()]); }
		catch (e) { }
		
		try	{ ga('send', 'event', jQuery(this).attr('col'), jQuery(this).text()); }
		catch (e) { }
	});
});