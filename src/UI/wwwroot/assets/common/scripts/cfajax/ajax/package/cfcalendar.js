/*ADOBE SYSTEMS INCORPORATED
Copyright 2007 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
if(!ColdFusion.Calendar){
ColdFusion.Calendar={};
}
ColdFusion.Calendar.monthNamesShort=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
ColdFusion.Calendar.monthNamesLong=new Array("January","February","March","April","May","June","July","August","September","October","November","December");
ColdFusion.Calendar.dayNamesShort=new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
ColdFusion.Calendar.dayNamesLong=new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
ColdFusion.Calendar.calTableIdCounter=0;
if(navigator.userAgent.toLowerCase().indexOf("safari")>-1){
var set_month=Date.prototype.setMonth;
Date.prototype.setMonth=function(_1){
if(_1<=-1){
var n=Math.ceil(-_1);
var _3=Math.ceil(n/12);
var _4=(n%12)?12-n%12:0;
this.setFullYear(this.getFullYear()-_3);
return set_month.call(this,_4);
}else{
return set_month.apply(this,arguments);
}
};
}
if(!String.escape){
String.escape=function(_5){
return _5.replace(/('|\\)/g,"\\$1");
};
}
ColdFusion.Calendar.setUpCalendar=function(_6,_7,_8,_9,_a,_b,_c){
var _d=ColdFusion.DOM.getElement(_6+_b+"_cf_button",_b);
var _e=ColdFusion.DOM.getElement(_6,_b);
var _f=null;
var _10=null;
if(_e.value!=""){
_f=_e.value;
_10=_f.split("/");
}
var _11=_6+"_cf_calendar"+ColdFusion.Calendar.calTableIdCounter;
ColdFusion.Calendar.calTableIdCounter++;
var _12=ColdFusion.DOM.getElement(_6+_b+"_cf_container",_b);
var _13=_e.offsetLeft;
ColdFusion.DOM.getElement(_6+_b+"_cf_container",_b).style.left=_13;
YAHOO.widget.Calendar.IMG_ROOT=_cf_ajaxscriptsrc+"/resources/yui/";
var _14;
if(_10&&_10[0]&&_10[2]){
_14=new YAHOO.widget.Calendar(_11,_6+_b+"_cf_container",{close:true,pagedate:_10[0]+"/"+_10[2]});
}else{
_14=new YAHOO.widget.Calendar(_11,_6+_b+"_cf_container",{close:true});
}
_14.calendarinputid=_6;
_14.calendarinput=_e;
_14.mask=_7;
_14.formname=_b;
_14.cfg.setProperty("MONTHS_LONG",_a);
_14.cfg.setProperty("WEEKDAYS_SHORT",_9);
_14.cfg.setProperty("START_WEEKDAY",_8);
ColdFusion.objectCache[_11+_b]=_14;
_14.select(_f);
_14.render();
_14.hide();
_14.selectEvent.subscribe(ColdFusion.Calendar.handleDateSelect,_14,true);
YAHOO.util.Event.addListener(_6+_b+"_cf_button","click",ColdFusion.Calendar.handleCalendarLinkClick,_14,true);
if(_c!=null){
var _15=_c.year;
var _16=_c.month;
var day=_c.day;
var _18=new Date(_15,_16.valueOf()-1,day);
_e.value=ColdFusion.Calendar.createFormattedOutput(_6,_7,_15,_16,day,_18);
}
};
ColdFusion.Calendar.openedCalendarInstance=null;
ColdFusion.Calendar.handleCalendarLinkClick=function(_19,_1a){
var _1b=_1a;
if(ColdFusion.Calendar.openedCalendarInstance){
ColdFusion.Calendar.openedCalendarInstance.hide();
}
if(!_1b.extMask){
var _1c=ColdFusion.Calendar.convertToExtMask(_1b.mask);
_1b.extMask=_1c;
}
var _1d=ColdFusion.DOM.getElement(_1a.calendarinputid,_1b.formname).value;
var _1e=null;
if(typeof (_1d)!="undefined"&&ColdFusion.trim(_1d)!=""){
_1e=Date.parseDate(_1d,_1b.extMask);
}
if(_1e!=null){
_1b.setMonth(_1e.getMonth());
_1b.setYear(_1e.getFullYear());
_1b.select(_1e);
_1b.render();
}
ColdFusion.Calendar.openedCalendarInstance=_1b;
_1b.show();
};
ColdFusion.Calendar.handleDateSelect=function(_1f,_20,_21){
var _22=_20[0];
var _23=_22[0];
var _24=_23[0],month=_23[1],day=_23[2];
var _25=new Date(_24,month.valueOf()-1,day);
_21.calendarinput.value=ColdFusion.Calendar.createFormattedOutput(_21.calendarinputid,_21.mask,_24,month,day,_25);
ColdFusion.Event.callBindHandlers(_21.calendarinputid,null,"change");
_21.hide();
};
ColdFusion.Calendar.convertToExtMask=function(_26){
_26=_26.toUpperCase();
if(_26.indexOf("DD")!=-1){
_26=_26.replace(/DD/g,"d");
}
if(_26.indexOf("D")!=-1){
_26=_26.replace(/D/g,"d");
}
if(_26.indexOf("MMMM")!=-1){
_26=_26.replace(/MMMM/g,"F");
}else{
if(_26.indexOf("MMM")!=-1){
_26=_26.replace(/MMM/g,"M");
}else{
if(_26.indexOf("MM")!=-1){
_26=_26.replace(/MM/g,"m");
}else{
if(_26.indexOf("M")!=-1){
_26=_26.replace(/M/g,"m");
}
}
}
}
if(_26.indexOf("YYYY")!=-1){
_26=_26.replace(/YYYY/g,"Y");
}
if(_26.indexOf("YY")!=-1){
_26=_26.replace(/YY/g,"y");
}
if(_26.indexOf("EEEE")!=-1){
_26=_26.replace(/EEEE/g,"l");
}
if(_26.indexOf("EEE")!=-1){
_26=_26.replace(/EEE/g,"D");
}
if(_26.indexOf("E")!=-1){
_26=_26.replace(/E/g,"w");
}
return _26;
};
ColdFusion.Calendar.createFormattedOutput=function(_27,_28,_29,_2a,day,_2c){
_28=_28.toUpperCase();
_29=new String(_29);
_2a=new String(_2a);
day=new String(day);
var _2d=_2c.getDay();
if(_28.indexOf("DD")!=-1){
if(day.length==1){
day="0"+day;
}
_28=_28.replace(/DD/g,day);
}
if(_28.indexOf("D"!=-1)){
if(day.length!=-1&&day.charAt(0)=="0"){
day=day.charAt(1);
}
_28=_28.replace(/D/g,day);
}
if(_28.indexOf("MMMM")!=-1){
_2a=ColdFusion.Calendar.monthNamesLong[_2a.valueOf()-1];
_28=_28.replace(/MMMM/g,_2a);
}else{
if(_28.indexOf("MMM")!=-1){
_2a=ColdFusion.Calendar.monthNamesShort[_2a.valueOf()-1];
_28=_28.replace(/MMM/g,_2a);
}else{
if(_28.indexOf("MM")!=-1){
if(_2a.length==1){
_2a="0"+_2a;
}
_28=_28.replace(/MM/g,_2a);
}else{
if(_28.indexOf("M")!=-1){
if(_2a.length!=-1&&_2a.charAt(0)=="0"){
_2a=_2a.charAt(1);
}
_28=_28.replace(/M/g,_2a);
}
}
}
}
if(_28.indexOf("YYYY")!=-1){
_28=_28.replace(/YYYY/g,_29);
}
if(_28.indexOf("YY")!=-1){
_29=_29.substring(2);
_28=_28.replace(/YY/g,_29);
}
if(_28.indexOf("EEEE")!=-1){
_2d=ColdFusion.Calendar.dayNamesLong[_2d.valueOf()];
_28=_28.replace(/EEEE/g,_2d);
}
if(_28.indexOf("EEE")!=-1){
_2d=ColdFusion.Calendar.dayNamesShort[_2d.valueOf()];
_28=_28.replace(/EEE/g,_2d);
}
if(_28.indexOf("E")!=-1){
_2d=_2d.valueOf();
_2d=new String(_2d);
if(_2d.length!=-1&&_2d.charAt(0)=="0"&&_2d.charAt(1)){
_2d=_2d.charAt(1);
}
_28=_28.replace(/E/g,_2d);
}
return _28;
};
