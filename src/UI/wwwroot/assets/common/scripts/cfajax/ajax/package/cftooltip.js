/*ADOBE SYSTEMS INCORPORATED
Copyright 2007 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
if(!ColdFusion.Tooltip){
ColdFusion.Tooltip={};
}
ColdFusion.Tooltip.setToolTipOut=function(_345,_346){
var _347=_346.tooltip;
_347.tooltipout=true;
};
ColdFusion.Tooltip.getToolTip=function(_348,_349){
var _34a=ColdFusion.objectCache[_349.context];
if(!_34a){
_34a=new YAHOO.widget.Tooltip(_349.context+"_cf_tooltip",_349);
ColdFusion.objectCache[_349.context]=_34a;
_34a.doShow(_348,_349.context);
if(_349._cf_url){
var _34b=function(req,_34d){
_34d.tooltip.cfg.setProperty("text",req.responseText);
if(_34d.tooltip.tooltipout==false){
_34d.tooltip.doShow(_34d.event,_34d.id);
}
};
YAHOO.util.Event.addListener(_349.context,"mouseout",ColdFusion.Tooltip.setToolTipOut,{"tooltip":_34a});
_34a.cfg.setProperty("text",_cf_loadingtexthtml);
_34a.doShow(_348,_349.context);
try{
ColdFusion.Log.info("tooltip.gettooltip.fetch","widget",[_349.context]);
ColdFusion.Ajax.sendMessage(_349._cf_url,"GET",_349._cf_query,true,_34b,{tooltip:_34a,event:_348,id:_349.context});
}
catch(e){
tooltipdiv=ColdFusion.DOM.getElement(_349.context);
tooltipdiv.innerHTML="";
ColdFusion.globalErrorHandler(null,e,tooltipdiv);
}
}
}
_34a.tooltipout=false;
};
