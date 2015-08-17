/*ADOBE SYSTEMS INCORPORATED
Copyright 2007 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
if(!ColdFusion.Tree){
ColdFusion.Tree={};
}
ColdFusion.Tree.AttributesCollection=function(){
this.cache=true;
this.fontname=null;
this.bold=false;
this.italic=false;
this.completepath=false;
this.appendkey=false;
this.delimiter=null;
this.formname=null;
this.fontsize=null;
this.formparamname=null;
this.prevspanid=null;
this.prevspanbackground=null;
this.images={};
this.images.folder=_cf_ajaxscriptsrc+"/resources/cf/images/FolderClose.gif";
this.images.cd=_cf_ajaxscriptsrc+"/resources/cf/images/Cd.png";
this.images.computer=_cf_ajaxscriptsrc+"/resources/cf/images/Computer.png";
this.images.document=_cf_ajaxscriptsrc+"/resources/cf/images/Document.gif";
this.images.element=_cf_ajaxscriptsrc+"/resources/cf/images/Elements.png";
this.images.floppy=_cf_ajaxscriptsrc+"/resources/cf/images/Floppy.png";
this.images.fixed=_cf_ajaxscriptsrc+"/resources/cf/images/HardDrive.png";
this.images.remote=_cf_ajaxscriptsrc+"/resources/cf/images/NetworkDrive.png";
this.imagesopen={};
this.imagesopen.folder=_cf_ajaxscriptsrc+"/resources/cf/images/FolderOpen.gif";
this.imagesopen.cd=_cf_ajaxscriptsrc+"/resources/cf/images/Cd.png";
this.imagesopen.computer=_cf_ajaxscriptsrc+"/resources/cf/images/Computer.png";
this.imagesopen.document=_cf_ajaxscriptsrc+"/resources/cf/images/Document.gif";
this.imagesopen.element=_cf_ajaxscriptsrc+"/resources/cf/images/Elements.png";
this.imagesopen.floppy=_cf_ajaxscriptsrc+"/resources/cf/images/Floppy.png";
this.imagesopen.fixed=_cf_ajaxscriptsrc+"/resources/cf/images/HardDrive.png";
this.imagesopen.remote=_cf_ajaxscriptsrc+"/resources/cf/images/NetworkDrive.png";
this.eventcount=0;
this.eventHandlers=new Array();
this.nodeCounter=0;
};
ColdFusion.Tree.refresh=function(_46){
var _47=ColdFusion.objectCache[_46];
var _48=ColdFusion.objectCache[_46+"collection"];
if(!_47||YAHOO.widget.TreeView.prototype.isPrototypeOf(_47)==false){
ColdFusion.handleError(null,"tree.refresh.notfound","widget",[_46],null,null,true);
return;
}
if(!_48.dynLoadFunction){
ColdFusion.Log.info("tree.refresh.statictree","widget");
return;
}
_48.dynLoadFunction.call(null,_47.getRoot());
ColdFusion.Log.info("tree.refresh.success","widget",[_46]);
};
ColdFusion.Tree.getTreeObject=function(_49){
if(!_49){
ColdFusion.handleError(null,"tree.gettreeobject.emptyname","widget",null,null,null,true);
return;
}
var _4a=ColdFusion.objectCache[_49];
if(_4a==null||YAHOO.widget.TreeView.prototype.isPrototypeOf(_4a)==false){
ColdFusion.handleError(null,"tree.gettreeobject.notfound","widget",[_49],null,null,true);
return;
}
return _4a;
};
ColdFusion.Tree.loadNodes=function(_4b,_4c){
var i=0;
var _4e=ColdFusion.objectCache[_4c.treeid+"collection"];
var _4f=ColdFusion.objectCache[_4c.treeid];
var _50;
var _51=false;
if(_4b&&typeof (_4b.length)=="number"&&!_4b.toUpperCase){
if(_4b.length>0&&typeof (_4b[0])!="object"){
_51=true;
}
}else{
_51=true;
}
if(_51){
ColdFusion.handleError(_4f.onbinderror,"tree.loadnodes.invalidbindvalue","widget",[_4c.treeid]);
return;
}
if(_4c.parent&&!_4c.parent.isRoot()){
_4f.removeChildren(_4c.parent);
}else{
if(_4c.parent&&_4c.parent.hasChildren()){
_4f.removeChildren(_4c.parent);
_4c.parent=_4f.getRoot();
}
}
if(!_4c.parent.leafnode){
for(i=0;i<_4b.length;i++){
var _52=_4e.nodeCounter++;
var _53={};
_53.id=_4b[i].VALUE;
if(typeof (_4b[i].DISPLAY)==undefined||_4b[i].DISPLAY==null){
_53.label=_4b[i].VALUE;
}else{
_53.label=_4b[i].DISPLAY;
}
_53.expand=_4b[i].EXPAND;
_53.appendkey=_4b[i].APPENDKEY;
_53.href=_4b[i].HREF;
_53.img=_4b[i].IMG;
_53.imgOpen=_4b[i].IMGOPEN;
_53.imgid="_cf_image"+_52;
_53.spanid="_cf_span"+_52;
_53.target=_4b[i].TARGET;
if(_4e.appendkey&&_4e.appendkey==true&&_53.href){
var _54=new String(_53.href);
_54=_54.toLowerCase();
if(_54.indexOf("javascript")<0){
if(_54.indexOf("?")>=0){
_53.href=_4b[i].HREF+"&";
}else{
_53.href=_4b[i].HREF+"?";
}
_53.href=_53.href+"CFTREEITEMKEY="+_53.id;
}
}
var _55="";
if(_53.img){
if(_4e.images[_53.img]){
_55="<img src='"+_4e.images[_53.img]+"' id='"+_53.imgid+"' style='border:0'/>&nbsp;";
}else{
_55="<img src='"+_53.img+"' id='"+_53.imgid+"' style='border:0'/>&nbsp;";
}
}
if(_4e.fontname||_4e.italic==true||_4e.bold==true||_4e.fontsize){
_55=_55+"<span id='"+_53.spanid+"' style='";
if(_4e.fontname){
_55=_55+"font-family:"+_4e.fontname+";";
}
if(_4e.italic==true){
_55=_55+"font-style:italic;";
}
if(_4e.bold==true){
_55=_55+"font-weight:bold;";
}
if(_4e.fontsize){
_55=_55+"font-size:"+_4e.fontsize+";";
}
_55=_55+"'>"+_53.label+"</span>";
_53.label=_55;
}else{
_53.label=_55+"<span id='"+_53.spanid+"'  >"+_53.label+"</span>";
}
_53.childrenFetched=false;
var _56=new YAHOO.widget.TextNode(_53,_4c.parent,false);
var _57=false;
if(_4b[i].LEAFNODE&&_4b[i].LEAFNODE==true){
_57=true;
_56.leafnode=true;
_56.iconMode=1;
}
if(_57==true||(_53.expand&&_53.expand==true)){
_56.expand();
}
}
}
if(!_4c.parent.isRoot()){
_4c.parent.data.childrenFetched=true;
}
if(_4c.onCompleteCallBack){
_4c.onCompleteCallBack.call();
}else{
_4c.parent.tree.draw();
}
ColdFusion.Log.info("tree.loadnodes.success","widget",[_4c.treeid]);
};
ColdFusion.Tree.onExpand=function(_58){
if(_58.isRoot()){
return;
}
var _59=ColdFusion.objectCache[_58.tree.id+"collection"];
if(_58.data.imgOpen&&typeof (_58.leafnode)=="undefined"){
var _5a=ColdFusion.DOM.getElement(_58.data.imgid,_58.tree.id);
var src;
if(_59.imagesopen[_58.data.imgOpen]){
src=_59.imagesopen[_58.data.imgOpen];
}else{
src=_58.data.imgOpen;
}
_5a.src=src;
}
if(_59.cache==false&&_58.data.childrenFetched==false&&_59.dynLoadFunction){
_58.tree.removeChildren(_58);
}
};
ColdFusion.Tree.onCollapse=function(_5c){
if(_5c.isRoot()){
return;
}
var _5d=ColdFusion.objectCache[_5c.tree.id+"collection"];
if(_5c.data.img){
var _5e=ColdFusion.DOM.getElement(_5c.data.imgid,_5c.tree.id);
var src;
if(_5d.images[_5c.data.img]){
src=_5d.images[_5c.data.img];
}else{
src=_5c.data.img;
}
_5e.src=src;
}
_5c.data.childrenFetched=false;
};
ColdFusion.Tree.formPath=function(_60,_61){
var _62=ColdFusion.objectCache[_60.tree.id+"collection"];
if(_62.completepath==true&&_60.isRoot()){
return "";
}else{
if(_62.completepath==false&&_60.parent.isRoot()){
return "";
}
}
if(!_61){
_61=_60;
}
var _63=ColdFusion.Tree.formPath(_60.parent,_61);
_63=_63+_60.data.id;
if(_61.data.id!=_60.data.id){
_63=_63+_62.delimiter;
}
return _63;
};
ColdFusion.Tree.onLabelClick=function(_64){
var _65="";
var _66=ColdFusion.objectCache[_64.tree.id+"collection"];
var _65=ColdFusion.Tree.formPath(_64);
if(_66.prevspanid){
var _67=ColdFusion.DOM.getElement(_66.prevspanid,_64.tree.id);
if(_67.style){
_67.style.backgroundColor=_66.prevspanbackground;
}
}
var _68=ColdFusion.DOM.getElement(_64.data.spanid,_64.tree.id);
if(_68&&_68.style){
_66.prevspanbackground=_68.style.backgroundColor;
}
_68.style.backgroundColor="lightblue";
_66.prevspanid=_64.data.spanid;
_64.tree._cf_path=_65;
_64.tree._cf_node=_64.data.id;
var val="PATH="+_65+"; NODE="+_64.data.id;
updateHiddenValue(val,_66.formname,_66.formparamname);
ColdFusion.Tree.fireSelectionChangeEvent(_64.tree.id,_66.formname);
};
ColdFusion.Tree.fireSelectionChangeEvent=function(id,_6b){
ColdFusion.Log.info("tree.fireselectionchangeevent.fire","widget",[id]);
ColdFusion.Event.callBindHandlers(id,_6b,"change");
};
ColdFusion.Tree.getObject=function(_6c){
var _6d={};
_6d.id=_6c.value;
if(_6c.href&&_6c.href!="null"){
_6d.href=_6c.href;
}
_6d.target=_6c.target;
_6d.label=_6c.label;
_6d.display=_6c.display;
_6d.img=_6c.img;
_6d.imgOpen=_6c.imgOpen;
_6d.imgid=_6c.imgid;
_6d.spanid=_6c.spanid;
_6d.childrenfetched=_6c.childrenfetched;
return _6d;
};
ColdFusion.Tree.initializeTree=function(_6e,_6f,_70,_71,_72,_73,_74,_75,_76,_77,_78,_79){
var _7a=new YAHOO.widget.TreeView(_6e);
_7a.subscribe("expand",ColdFusion.Tree.onExpand);
_7a.subscribe("collapse",ColdFusion.Tree.onCollapse);
_7a.subscribe("labelClick",ColdFusion.Tree.onLabelClick);
_7a._cf_getAttribute=function(_7b){
_7b=_7b.toUpperCase();
if(_7b=="PATH"){
return _7a._cf_path;
}else{
if(_7b=="NODE"){
return _7a._cf_node;
}else{
return null;
}
}
};
_7a.onbinderror=_77;
ColdFusion.objectCache[_6e]=_7a;
var _7c=new ColdFusion.Tree.AttributesCollection();
_7c.cache=_6f;
_7c.italic=_70;
_7c.bold=_71;
_7c.completepath=_72;
_7c.delimiter=_74;
_7c.appendkey=_73;
_7c.formname=_75;
_7c.formparamname=_76;
_7c.fontsize=_78;
_7c.fontname=_79;
ColdFusion.objectCache[_6e+"collection"]=_7c;
ColdFusion.Log.info("tree.initializetree.success","widget",[_6e]);
return _7a;
};
