/*ADOBE SYSTEMS INCORPORATED
Copyright 2007 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
if(!ColdFusion.Autosuggest){
ColdFusion.Autosuggest={};
}
var staticgifpath=_cf_ajaxscriptsrc+"/resources/cf/images/static.gif";
var dynamicgifpath=_cf_ajaxscriptsrc+"/resources/cf/images/loading.gif";
ColdFusion.Autosuggest.loadAutoSuggest=function(_33,_34){
var _35=ColdFusion.objectCache[_34.autosuggestid];
if(typeof (_33)=="string"){
_33=_33.split(",");
}else{
var _36=false;
if(_33&&ColdFusion.Util.isArray(_33)){
_36=true;
if(_33.length>0&&typeof (_33[0])!="string"){
_36=false;
}
}
if(!_36){
ColdFusion.handleError(_35.onbinderror,"autosuggest.loadautosuggest.invalidvalue","widget",[_34.autosuggestid]);
return;
}
}
var _37=document.getElementById(_34.autosuggestid).value;
if(_37.length==1&&_33.length==0){
var _38=new Array();
_35.dataSource.flushCache();
_35.dataSource=new YAHOO.widget.DS_JSArray(_38);
_35.autosuggestitems=_38;
}
if(_33.length>0){
var i=0;
var _3a=false;
var _38=new Array();
for(i=0;i<_33.length;i++){
if(_33[i]){
if(typeof (_33[i])=="string"){
_38[i]=_33[i];
}else{
_38[i]=new String(_33[i]);
}
if(_38[i].indexOf(_37)==0){
_3a=true;
}
}
}
if(_3a==false&&_35.showloadingicon==true){
document.getElementById(_34.autosuggestid+"_cf_button").src=staticgifpath;
}
_35.dataSource.flushCache();
_35.dataSource=new YAHOO.widget.DS_JSArray(_38);
_35.autosuggestitems=_38;
}else{
if(_35.showloadingicon==true){
document.getElementById(_34.autosuggestid+"_cf_button").src=staticgifpath;
}
}
};
ColdFusion.Autosuggest.checkToMakeBindCall=function(arg,_3c,_3d,_3e){
var _3e=document.getElementById(_3c).value;
if(!_3d.isContainerOpen()&&_3e.length>0&&arg.keyCode!=39&&(arg.keyCode>31||(arg.keyCode==8&&_3d.valuePresent==true))){
_3d.valuePresent=false;
if(_3d.showloadingicon==true){
document.getElementById(_3c+"_cf_button").src=dynamicgifpath;
}
ColdFusion.Log.info("autosuggest.checktomakebindcall.fetching","widget",[_3c,_3e]);
return true;
}
return false;
};
ColdFusion.Autosuggest.checkValueNotInAutosuggest=function(_3f,_40){
if(_3f.autosuggestitems){
for(var i=0;i<_3f.autosuggestitems.length;i++){
if(_40==_3f.autosuggestitems[i]){
return false;
}
}
}
return true;
};
ColdFusion.Autosuggest.triggerOnChange=function(_42,_43){
var _44=_43[0];
var _45=document.getElementById(_44.id);
ColdFusion.Event.callBindHandlers(_44.id,null,"change");
};
