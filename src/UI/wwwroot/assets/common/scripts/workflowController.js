
/**
* Ajax.Request.abort
* extend the prototype.js Ajax.Request object so that it supports an abort method
* http://blog.pothoven.net/2007/12/aborting-ajax-requests-for-prototypejs.html
*/
Ajax.Request.prototype.abort = function()
{
	// prevent and state change callbacks from being issued
	this.transport.onreadystatechange = Prototype.emptyFunction;
	// abort the XHR
	this.transport.abort();
	// update the request counter
	Ajax.activeRequestCount--;
};

function createCookie(name, value, days)
{
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		var expires = "; expires=" + date.toGMTString();
	}
	else var expires = "";
	document.cookie = name + "=" + value + expires + "; path=/";
}

function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++)
	{
		var c = ca[i];
		while (c.charAt(0) == ' ') c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
	}
	return null;
}

function eraseCookie(name)
{
	createCookie(name, "", -1);
}



var WorkflowControl = Class.create({
	initialize: function()
	{
		//only one page element is recognized as the workflow control, no need to pass it in
		this._element = $('workflowControl');

		//the dialog popup
		this._dialog = $('workflowItemDetailDialog');
		this._dialog.hide();
		this._dialog.addClassName('workflowItemDetailDialog');
		//$('itemDialogTab').observe('mouseout', this._onDialogTabClicked.bind(this));
		$('workflowItemDetailDialog').observe('mouseout', this._onDialogMouseOut.bind(this));

		//find and init the line selectors
		this._lineSelectors = this._element.select('ul.lines a');
		this._lineSelectors.each(function(elem, index)
		{
			elem.observe('click', this._onLineSelectorClicked.bind(this));
			if (elem.up().hasClassName('activeLine')) { id = elem.up().id; this._activeLine = id.charAt(id.length - 1); }
		}, this);

		//save ref to line workflows
		this._lineWorkflows = this._element.select('ul.steps');

		//attach click events to line workflow-step selection labels
		this._lineWorkflows.each(this._initLineWorkflow, this);

		//ajax result cache
		this._dialogCache = new Array();
		this._currentAjaxUrl = '';
	},

	_initLineWorkflow: function(elem, index)
	{
		//for each completed step, find the label and observe the click event

		elem.select('li a').each(function(anchor, i)
		{
			if (anchor.up().hasClassName('complete'))
			{ anchor.observe('mouseover', this._onSelectionClicked.bind(this, i + 1)); }
			else
			{ anchor.observe('click', this.closeDialog.bind(this)); }
		}, this);
	},

	closeDialog: function()
	{
		Event.stopObserving(window, 'resize', this._windowResizeHanlder);
		this._dialog.hide();
	},

	openDialog: function(stepNum)
	{
		//abort any pending ajax requests
		if (this._currentAjax)
		{
			this._currentAjax.abort();
			this._currentAjaxUrl = '';
		}
		if (this._currentTimeout)
		{
			clearTimeout(this._currentTimeout);
		}


		stepLI = this._lineWorkflows[this._activeLine - 1].select('.step_' + stepNum)[0];
		stepHREF = stepLI.select('a')[0];

		//clear the dialog
		$('itemDialogTab').innerHTML = '<span>' + stepLI.select('a')[0].innerHTML + '</span>';
		var loadingHTML = "<div class=loading><img src='/assets/scripts/cfajax/ajax/resources/yui/loading.gif'/>Loading...</div>";
		$('itemDialogContent').innerHTML = loadingHTML;
		$('dialogShim').style.height = "100px";

		//position the dialog
		//set to left-side on step 4 to avoid going off screen
		if (stepNum == 4)
		{
			this._dialog.addClassName('workflowItemDetailDialog_left');
//			this._dialog.clonePosition(stepLI, { setWidth: false, setHeight: false, offsetLeft: -235, offsetTop: 65 });
			this._dialog.clonePosition(stepHREF, { setWidth: false, setHeight: false, offsetLeft: -247, offsetTop: 25 });
		} else
		{
			this._dialog.removeClassName('workflowItemDetailDialog_left');
//			this._dialog.clonePosition(stepLI, { setWidth: false, setHeight: false, offsetLeft: 25, offsetTop: 65 });
			this._dialog.clonePosition(stepHREF, { setWidth: false, setHeight: false, offsetLeft: 13, offsetTop: 25 });
		}

		if (this._dialogEffect) { this._dialogEffect.cancel(); }
		this._dialog.show();
		this._windowResizeHanlder = this._resizePoll.bind(this); // this.resizeDialog.bind(this);
		Event.observe(window, 'resize', this._windowResizeHanlder);
		this._dialogEffect = new Effect.BlindDown('dialogShim', { duration: 0.3 });


		//check the cache first
		url = '/cart/webserviceWrapper.cfm/line/' + this._activeLine + '/step/' + stepNum + '/';
		if (this._dialogCache[url])
		{ this._fillDialog(this._dialogCache[url]); } else
		{
			this._currentAjaxUrl = '/cart/webserviceWrapper.cfm/line/' + this._activeLine + '/step/' + stepNum + '/';
			//put the ajax request on a slight delay because we're now using mouseovers (unwanted rapid-fire ajax possible)
			this._currentTimeout = setTimeout(this._fireAjax.bind(this), 1000);
		}
		
		

	},

	_fireAjax: function(url)
	{
		this._currentAjax = new Ajax.Request(
		this._currentAjaxUrl,
		{
			method: 'get',
			onSuccess: this._getItemDetailComplete.bind(this)
		});
	},

	changeLine: function(lineNum)
	{
		//hide the dialog if its showing
		this.closeDialog();
		//remove "activeLine" class from line selectors
		this._lineSelectors.each(function(elem, index) { elem.up().removeClassName('activeLine'); });
		//hide all lines
		this._lineWorkflows.each(function(elem, index) { elem.hide(); });
		//add "activeLine" class to selected line		
		lineSelectorContainer = this._lineSelectors[lineNum - 1].up();
		lineSelectorContainer.addClassName('activeLine');
		//show the line workflow
		this._lineWorkflows[lineNum - 1].show();
		this._activeLine = lineNum;
		createCookie('CURRENTLINE', this._activeLine, 1);
	},

	_onLineSelectorClicked: function(event)
	{
		lineSelectorContainer = event.findElement().up();
		//get line ID from event target id
		lineIndex = lineSelectorContainer.id.charAt(lineSelectorContainer.id.length - 1);
		this.changeLine(lineIndex);
		//stuff the anchor's navigate functionality
		event.stop();
		return false;
	},

	_onSelectionClicked: function(stepNum, event)
	{
		this.openDialog(stepNum);
		event.stop();
		return false;
	},

	_onDialogMouseOut: function(event)
	{
		//check the ancestor tree.  If it contains the dialog, ignore (mouse is still in dialog)
		var relTarg = event.relatedTarget || event.toElement;
		if (relTarg.descendantOf(this._dialog)) { event.stop(); return; }

		if (this._dialogEffect) { this._dialogEffect.cancel(); }
		this.closeDialog();
	},

	_getItemDetailComplete: function(response)
	{
		this._dialogCache[this._currentAjaxUrl] = response.responseText;
		this._fillDialog(response.responseText);
	},

	_fillDialog: function(content)
	{
		$('itemDialogContent').innerHTML = content;
		//resize to fit
		this.resizeDialog();
	},

	_resizePoll: function()
	{
		if (this._resizePollTimerID) { clearTimeout(this._resizePollTimerID); }
		this._resizePollTimerID = setTimeout(this.resizeDialog.bind(this), 200);
	},

	resizeDialog: function()
	{
		//if (!this._dialog.visible()) { return; }
		if (this._resizePollTimerID) { clearTimeout(this._resizePollTimerID); }
		if (this._dialogEffect) { this._dialogEffect.cancel(); }
		var newHeight = this._calcDialogShimHeight();
		var dialogHeight = $('dialogShim').getHeight();
		if (dialogHeight != newHeight)
		{
			this._dialogEffect = new Effect.Scale('dialogShim', (this._calcDialogShimHeight() / dialogHeight) * 100, { duration: 0.3, scaleX: false, scaleContent: false, scaleMode: { originalHeight: dialogHeight, originalWidth: 420} });
		}
	},

	_calcDialogShimHeight: function()
	{
		newHeight = $('itemDialogContent').scrollHeight;
		chromeHeight = this._dialog.cumulativeOffset().top + $('itemDialogTab').getHeight() + $('itemDialogFooter').getHeight();
		totalHeight = chromeHeight + newHeight;
		viewHeight = document.viewport.getHeight();
		if (totalHeight > viewHeight)
		{
			newHeight = viewHeight - chromeHeight;
		}
		return newHeight;
	}
});

var workflowControl = null;

function InitWorkflowControl()
{
	if(!workflowControl)
	{workflowControl = new WorkflowControl();}
}

document.observe('dom:loaded',InitWorkflowControl);
