FooterContentWindowConfig = function () {
	this.center = true;
	this.closable = true;
	this.draggable = false;
	this.width = 780;
	this.height = 525;
	this.initshow = false;
	this.modal = true;
	this.resizable = false;
}

createFooterContentWindow = function (name, title, url)
{
	var config = new FooterContentWindowConfig();
	ColdFusion.Window.create(name, title, url, config);
}

viewFooterContentInWindow = function (windowName,windowTitle,windowURL)
{
	createFooterContentWindow(windowName,windowTitle,windowURL);
	ColdFusion.Window.show(windowName);
	centerWindow(windowName);
}

centerWindow = function (windowName)
{
	// get window object
	var myWindow = ColdFusion.Window.getWindowObject(windowName);
	// use the center function to center the window.
	myWindow.center();
}
