ActivationFeeWindowConfig = function () {
	this.center = true;
	this.closable = true;
	this.draggable = false;
	this.width = 550;
	this.height = 450;
	this.initshow = false;
	this.modal = true;
	this.resizable = false;
}

createActivationFeeWindow = function (name, title, url)
{
	var config = new ActivationFeeWindowConfig();
	ColdFusion.Window.create(name, title, url, config);
}

viewActivationFeeInWindow = function (windowName,windowTitle,windowURL)
{
	createActivationFeeWindow(windowName,windowTitle,windowURL);
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
