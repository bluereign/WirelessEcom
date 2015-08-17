ServiceDescriptionWindowConfig = function () {
	this.center = true;
	this.closable = true;
	this.draggable = false;
	this.width = 500;
	this.height = 350;
	this.initshow = false;
	this.modal = true;
	this.resizable = false;
}

createServiceDescriptionWindow = function (name, title, url)
{
	var config = new ServiceDescriptionWindowConfig();
	ColdFusion.Window.create(name, title, url, config);
	ColdFusion.navigate(url,name);
}

viewServiceDescription = function (productId) {
	createServiceDescriptionWindow('windowServiceDescription','Wireless Advocates - Service Description','/index.cfm/go/shop/do/serviceDescription/productId/'+productId);
	ColdFusion.Window.show("windowServiceDescription");
	centerWindow('windowServiceDescription');
}

centerWindow = function (windowName) {
	// get window object
	var myWindow = ColdFusion.Window.getWindowObject(windowName);
	// use the center function to center the window.
	myWindow.center();
}
