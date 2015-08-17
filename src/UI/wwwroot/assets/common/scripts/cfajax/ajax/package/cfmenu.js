/*ADOBE SYSTEMS INCORPORATED
Copyright 2007 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
if(!ColdFusion.Menu){
ColdFusion.Menu={};
}
ColdFusion.Menu.menuItemMouseOver=function(id,_2f){
var _30=document.getElementById(id);
_30.tempfontcolor=_30.firstChild.style.color;
if(_2f){
_30.firstChild.style.color=_2f;
}
};
ColdFusion.Menu.menuItemMouseOut=function(id){
var _32=document.getElementById(id);
if(_32.tempfontcolor){
_32.firstChild.style.color=_32.tempfontcolor;
}else{
_32.firstChild.style.color="black";
}
};
