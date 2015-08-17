var Accordian = Class.create({
	initialize: function(targetElem, triggerElem)
	{
		this._element = targetElem;
		//this._element.style.overflow = 'hidden';
		arguments = $A(arguments);
		this._triggers = new Array();
		this._clickListeners = new Array();
		arguments.each(function(arg, index)
		{
			if (index <= 0) { return; }
			this._triggers.push(arg);
			listener = this._triggerClick.bind(this);
			arg.observe('click', listener);
			this._clickListeners.push(listener);
		}, this);

		this._state = 'down';
	},

	toggle: function()
	{
		if (this._element.visible())
		{
			//change trigger
			//link.innerHTML = 'less';
			//link.className = 'btnCollapse';
			//morph size
			//new Effect.Tween(this, acc.retrieve('accordianLow'), acc.retrieve('accordianHigh'), { duration: 0.5, transition: Effect.Transitions.sinoidal }, function(p) { this.style.height = p + 'px'; });
			this.collapse();
		} else
		{
			//change button
			//link.innerHTML = 'more';
			//link.className = 'btnExpand';
			//morph size
			//new Effect.Tween(acc, acc.retrieve('accordianHigh'), acc.retrieve('accordianLow'), { duration: 0.5, transition: Effect.Transitions.sinoidal }, function(p) { this.style.height = p + 'px'; });
			this.expand();
		}
	},

	expand: function()
	{

		new Effect.BlindDown(this._element, { duration: 0.3, afterFinish: function() { this._element.fire('acc:opened'); } .bind(this) });
		this._triggers.each(function(elem, index) { elem.addClassName('expanded'); });
	},

	collapse: function()
	{
		new Effect.BlindUp(this._element, { duration: 0.3, afterFinish: function() { this._element.fire('acc:closed'); } .bind(this) });
		this._triggers.each(function(elem, index) { elem.removeClassName('expanded'); });
	},



	_triggerClick: function(event)
	{
		this.toggle();
		return false;
	},

	dispose: function()
	{
		this._trigger.stopObserving('click');
		this._clickListener = null;
	}

});