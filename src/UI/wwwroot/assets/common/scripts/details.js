	function InitSpecTabs() {
		//grab the li containers
		var tabContainers = $('prodSpecs').select('ul > li a.tab');

		tabContainers.each(function(elem, index) {
			Event.observe(elem, 'click', ChangeSpecTab);    			
		});
	}

	function ChangeSpecTab(event) {
		//clear all tabs
			var ul = event.findElement("ul");
		var allTabs = ul.childElements();
		allTabs.each(function(elem, index) { elem.removeClassName("active"); });

		//add 'active' class to clicked li
		event.findElement('li').addClassName('active');
		//event.element().ancestors().each(function(elem, index) { elem.blur(); }); //this actually blurs the browser in IE 8!
			ul.descendants().each(function(elem,index){elem.blur();});
		event.stop();
	}

	function InitImgThumbs() {
		//grab the li containers
		var thumbs = $$('.prodImage .thumbs img');
	
/*
		thumbs.each(function(elem, index) {
			Event.observe(elem, 'click', ChangeImage);
		});
*/
	}

	function ChangeImage(event) {
		if (event.element().tagName != "IMG") return;
	
		//figure large image name
		var imageName = event.element().src;
		imageName = imageName.substring(imageName.lastIndexOf('/') + 1, imageName.length);
		imageName = imageName.substring(0, imageName.indexOf('_thumb')) + '.jpg';

		//find the main image
		$('prodDetailImg').src = '/images/products/' + imageName;
		event.stop();
	}

	document.observe("dom:loaded", InitSpecTabs);
	document.observe("dom:loaded", InitImgThumbs);