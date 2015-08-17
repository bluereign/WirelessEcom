var cart;

initCartDialog = function() {
	cart = new CartDialog($('cartDialog'));
	bindToolTips();
}

/*===================================*/

var ZipCodeControl = Class.create({
	initialize: function(targetElem, mode)
	{
		try
		{
			this._element = targetElem; //control container
	
			this._mode = mode; /*dialog or page*/
	
			this._currentZip = this._element.select('.currentZip')[0];
			this._readOnlyZip = this._element.select('.readOnlyZip')[0];
			this._editZip = this._element.select('.editZip')[0];
			this._zipInput = this._element.select('.input_newZipcode')[0];
	
			this._currentZip.onclick = this._toggleEditZip.bind(this);
			this._element.select('.cancelEditZip')[0].onclick = this._toggleEditZip.bind(this);
			this._element.select('.saveNewZip')[0].onclick = this._confirmSaveZip.bind(this);
		}
		catch(err)
		{
		}
	},

	_toggleEditZip: function()
	{
		this._readOnlyZip.toggle();
		this._editZip.toggle();
		if (this._readOnlyZip.visible)
		{
			this._zipInput.setValue(this._currentZip.innerHTML);
			this._zipInput.select();
		}
		return false;
	},

	_confirmSaveZip: function()
	{
		msg = 'Your cart will be emptied if you change your zip code.\n\nAre you SURE you want to change your zip code?';
		if (confirm(msg))
		{
			switch (this._mode)
			{
				case 'dialog':
					ColdFusion.navigate('/index.cfm/go/cart/do/changeZipcode/blnDialog/1/zipcode/' + this._zipInput.getValue(), 'dialog_addToCart');
					break;
				case 'page':
					location.href = '/index.cfm/go/cart/do/changeZipcode/blnDialog/0/zipcode/' + this._zipInput.getValue();
					break;
			}

		} else
		{
			this._toggleEditZip();
			return false;
		}
		return false;
	}
});



/*===================================*/


var CartDialog = Class.create({
	initialize: function(targetElem)
	{
		this._element = targetElem;

		// the following code will fail if the first item a user attempts to add to the cart is an accessory (which doesn't walk them through zipcode first) - so we'll silently handle the exception and move on
		try { this._zipControl = new ZipCodeControl($('zipHeader'), 'dialog'); } catch(err) {  }

		this._messages = this._element.select('.messages')[0];

		this._accordians = new Array();
		this._cartLines = new Array();

		this._targetLine = $('cartLineNumber');

		linesContainer = $('cartLines');
		lines = this._element.select('#cartLines > li');
		lines.each(function(elem, index)
		{
			try { this._cartLines.push(new CartLine(this, elem)); } catch (err) {  }
		}, this);

		this._addNewLine = $('addNewLine');
		if (this._addNewLine)
			this._addNewLine.onclick = this._onAddNewLineClick.bind(this);

		this.changeMode(this._element.className);

		//scroll into view
		topFromViewport = (document.viewport.getHeight() - 500) / 2;
		dialogPosY = this._element.cumulativeOffset().top;
		scrollToY = dialogPosY - topFromViewport;
		window.scrollTo(0, scrollToY);
		
	},

	_onAddNewLineClick: function(event)
	{
		ColdFusion.navigate('/index.cfm/go/cart/do/addLine/blnDialog/1/', 'dialog_addToCart');
		
	},

	changeMode: function(newMode)
	{
		this._element.className = newMode;

		activeLine = null;
		this._cartLines.each(function(line, index)
		{
			line.changeMode(newMode);
			if (line._element.hasClassName('active'))
			{
				activeLine = line;
			}
		});

		if (activeLine)
		{
			activeLine.expand();
			this._setTargetLine(activeLine._lineID,activeLine._lineLabel.innerHTML);
			if ($('whichLineText'))
			{
				$('whichLineText').innerHTML = activeLine._lineLabel.innerHTML;
			}
		}

	},

	_setTargetLine: function(lineNumber, lineLabel)
	{
		this._targetLine.value = lineNumber;
		if ($('whichLineText'))
		{
			if (lineLabel != 'Add a new line')
				$('whichLineText').innerHTML = lineLabel;
			else
				$('whichLineText').innerHTML = 'a new line';
		}
	}

});


/*========= Cart Line ==================*/

var CartLine = Class.create({
	initialize: function(parentObj, targetElem, newMode)
	{
		this._parent = parentObj;

		this._mode = "edit";

		this._element = targetElem;

		this._lineID = $F(this._element.select('[name="lineID"]')[0]);
		this._lineLabel = this._element.select('h5')[0];
		this._lineActionLabel = this._element.select('.lineActionLabel')[0];
		this._deleteLineButton = this._element.select('.deleteLine')[0];
		this._addButton = $('mt-tAdd');


		this._aliasControl = this._element.select('.aliasControl')[0];
		this._aliasForm = this._element.select('.aliasLine')[0];
		this._aliasField = this._aliasForm.select('[name=input_newAlias]')[0];
		this._aliasButton = this._aliasControl.select('a.renameButton')[0];
		this._aliasButton.observe('click', this._onNameClicked.bind(this));
		this._aliasForm.select('.saveNewAlias')[0].observe('click', this._onSaveAliasClicked.bind(this));
		this._aliasForm.select('.cancelNewAlias')[0].observe('click', this._onCancelAliasClicked.bind(this));

		accordianBody = this._element.select('.accordianBody')[0];
		this._accordianTrigger = this._element.select('.accordianTrigger')[0];
		this._accordian = new Accordian(accordianBody, this._accordianTrigger, this._lineLabel);

		Event.observe(this._accordian._element, 'acc:opened', this._accOpened.bind(this));
		Event.observe(this._accordian._element, 'acc:closed', this._accClosed.bind(this));

		Event.observe(this._addButton, 'click', this._onAddClicked.bind(this));

		this._initNonSelected();

		//default the accordian body to closed and fire accClosed event
		accordianBody.hide();
		this._accClosed();
		
		
		
	},

	_initNonSelected: function()
	{
		//set labels for non-selected items
		deviceNameElem = this._element.select('.deviceName')[0];
		if (deviceNameElem.innerHTML == '') { deviceNameElem.innerHTML = '[Select a Device]'; deviceNameElem.up().select('.removeItem')[0].hide(); }

		hasPlan = true;
		planNameElem = this._element.select('.planName')[0];
		if (planNameElem.innerHTML == '') { hasPlan = false; planNameElem.innerHTML = '[Select a Service Plan]'; planNameElem.up().select('.removeItem')[0].hide(); }

		featureNames = this.getFeatureNames();
		if (featureNames.length == 0)
		{  }

	},

	getDeviceName: function() { return this._element.select('.deviceName')[0].innerHTML; },
	getPlanName: function() { return this._element.select('.planName')[0].innerHTML },
	getFeatureNames: function()
	{
		return this._element.select('.featureNames > li');
	},
	getAccessoryNames: function()
	{
		return this._element.select('.accessoryNames > li');
	},

	_accOpened: function(event)
	{
		this._clearActionLabel();
		this._accordianTrigger.addClassName('accordianTrigger_down');
	},

	_accClosed: function(event)
	{
		this._updateActionLabel();
		this._accordianTrigger.removeClassName('accordianTrigger_down');
	},

	_onAddClicked: function(event)
	{
		this._parent._setTargetLine(this._lineID, this._lineLabel.innerHTML);
	},

	_clearActionLabel: function()
	{
		this._lineActionLabel.innerHTML = "";
	},

	_updateActionLabel: function()
	{
		if (this._lineLabel.innerHTML != 'Add a new line')
		{
			switch (this._mode)
			{
				case "edit":
					this._clearActionLabel();
					break;
				case "addDevice":
					this._lineActionLabel.innerHTML = this.getDeviceName();
					if (this._lineActionLabel.innerHTML == "[Select a Device]") { this._lineActionLabel.innerHTML = "(No Device Selected)"; }
					break;
				case "addPlan":
					this._lineActionLabel.innerHTML = this.getPlanName();
					if (this._lineActionLabel.innerHTML == "[Select a Service Plan]") { this._lineActionLabel.innerHTML = "(No Service Plan Selected)"; }
					break;
				case "addAccessory":
					this._lineActionLabel.innerHTML = this.getAccessoryNames().length-1 + " Accessories Selected";
					break;
				case "addFeature":
					this._lineActionLabel.innerHTML = this.getFeatureNames().length-1 + " Services Selected";
					break;
			}
		}
	},

	expand: function()
	{
		this._accordian.toggle();
	},

	collapse: function()
	{
		this._accordian.toggle();
	},

	getMode: function() { return this._mode; },

	changeMode: function(newMode)
	{
		this._mode = newMode;
		this._updateActionLabel();
		this._element.removeClassName('edit');
		this._element.removeClassName('addDevice');
		this._element.removeClassName('addPlan');
		this._element.removeClassName('addFeature');
		this._element.removeClassName('addAccessory');

		//===========================================
		//  element visibility handled via pure CSS
		//===========================================

		switch (this._mode)
		{
			case "edit":
				this._element.addClassName('edit');
				break;
			case "addDevice":
				this._element.addClassName('addDevice');
				break;
			case "addPlan":
				this._element.addClassName('addPlan');
				break;
			case "addAccessory":
				this._element.addClassName('addAccessory');
				break;
			case "addFeature":
				this._element.addClassName('addFeature');
				break;
		}
	},

	_onAddMouseOver: function(event)
	{
	},

	_toggleAliasForm: function()
	{
		this._aliasForm.toggle();
		this._aliasButton.toggle();
		if (this._aliasForm.visible)
		{
			this._aliasField.setValue(this._lineLabel.innerHTML);
			this._aliasField.select();
		}
	},

	_onNameClicked: function(event)
	{
		this._toggleAliasForm();
	},


	_onSaveAliasClicked: function(event)
	{
		this._aliasLine();
	},

	_onCancelAliasClicked: function(event)
	{
		this._toggleAliasForm();
	},

	_aliasLine: function()
	{
		aliasForm = $('formAliasLine');
		line = $('formAlias_line');
		alias = $('formAlias_alias');

		line.value = this._lineID;
		alias.value = this._aliasField.value;


		return ColdFusion.Ajax.checkForm($('formAliasLine'), _CF_checkformAliasLine, 'dialog_addToCart_body')
	}

});

var MyTabs;
var activeTab = 1;
function bindToolTips()
{


	MyTabs = new mt('tabs','div.my_tab');
	
	//get all the lines in the cart.
	var i = 1;
	$$('.tabline').each(function(element) {
		var active = element.readAttribute("active");
		MyTabs.addTab('tab' + i,'Line' + i);	
		if(active=="true")
		{
			MyTabs.makeActive('tab' + i);
			activeTab = i;	
		}
		i++;
	});
	
	
	
	i = 1;
	$$('.tabline').each(function(element) {
		//move the image
		$$('#secondaryImage' + i).each(function(element) {
			var html = element.innerHTML;
			$$('#mt-tab' + i).each(function(elementA) {
				elementA.innerHTML = html;
			});
		});
		i++;
	});
	
	//add new lines.
	$$('#tAdd').each(function(element) {
		MyTabs.addTab('tAdd','New Line');
	});
	$$('#secondaryImageAddLine').each(function(element) {
			var html = element.innerHTML;
			$$('#mt-tAdd').each(function(elementA) {
				elementA.innerHTML = html;
			});
		});
	
	
	
	//acc
	MyTabs.addTab('tab999','Additional Accessories');
	$$('#secondaryAccessories').each(function(element) {
			var html = element.innerHTML;
			$$('#mt-tab999').each(function(elementA) {
				elementA.innerHTML = html;
				var active = element.readAttribute("active");
				
				if(active=="true")
				{
					MyTabs.makeActive('tab999');	
				}
			});		
			
			
			
		});
	
	Event.observe('mt-tAdd', 'click', function(event) {
		addNewLine(i);
	});


}


function addNewLine(n)
{
	//ColdFusion.navigate('/index.cfm/go/cart/do/addLine/' + n, 'dialog_addToCart');	
	//window.location.href="/index.cfm/go/cart/do/addLine/" + n + "/blnDialog/true", "dialog_addToCart";
	ColdFusion.navigate('/index.cfm/go/cart/do/addLine/blnDialog/1/' + n , 'dialog_addToCart');
}
function setTargetLine(lineNumber)
{
	
	var _targetLine = $('cartLineNumber')
	_targetLine.value = lineNumber;
	
}

function cancelAccessoryClick()
{
	jQuery(".messages-box").remove();
	jQuery(".messages-modal").remove();
}
