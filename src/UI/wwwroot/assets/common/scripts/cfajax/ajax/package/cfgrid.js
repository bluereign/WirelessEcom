/*ADOBE SYSTEMS INCORPORATED
Copyright 2007 Adobe Systems Incorporated
All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.*/
cfinitgrid=function(){
if(!ColdFusion.Grid){
ColdFusion.Grid={};
}
var $G=ColdFusion.Grid;
var $L=ColdFusion.Log;
$G.init=function(id,name,_249,_24a,edit,_24c,_24d,_24e,_24f,_250,_251,_252,_253,_254,_255,_256,_257,_258,_259,_25a,_25b,_25c){
var grid;
var _25e=new Ext.grid.ColumnModel(_24e);
var _25f={ds:_24f,cm:_25e,autoSizeColumns:_24d,autoSizeHeaders:_24d,autoHeight:_251,autoWidth:_250,stripeRows:_252};
var _260=ColdFusion.objectCache[id];
_260.bindOnLoad=_24c;
_260.dynamic=_24a;
_260.styles=_253;
_25f.selModel=new Ext.grid.RowSelectionModel({singleSelect:true});
if(!_24a){
_24f.load();
}
if(edit){
grid=new Ext.grid.EditorGrid(_260.gridId,_25f);
}else{
grid=new Ext.grid.Grid(_260.gridId,_25f);
}
_260.grid=grid;
grid.render();
if(edit&&!_24a&&(_257||_258)){
var _261=grid.getView().getFooterPanel(true);
var _262=new Ext.Toolbar(_261);
if(_257){
_262.addButton({text:_257,handler:$G.insertRow,scope:_260});
}
if(_258){
_262.addButton({text:_258,handler:$G.deleteRow,scope:_260});
}
grid.autoSize();
}
if(_24a){
_24f.addListener("load",$G.Actions.onLoad,_260,true);
_24f._cf_errorHandler=_25b;
_24f.proxy._cf_actions=_260;
var _261=grid.getView().getFooterPanel(true);
var _262=new Ext.PagingToolbar(_261,_24f,{pageSize:_254,beforePageText:CFMessage["grid.init.toolbar.page"]||"Page",afterPageText:CFMessage["grid.init.toolbar.of"]||"of {0}"});
if(_25a&&_258){
_262.addSeparator();
var _263=new Ext.ToolbarButton({text:_258});
_263.setHandler($G.deleteRow,_260);
_262.addButton(_263);
}
_24f.load({params:{start:0,limit:_254}});
}else{
$G.applyStyles(_260);
}
if(_25c){
ColdFusion.Bind.register(_25c,{actions:_260},$G.bindHandler,false);
}
$L.info("grid.init.created","widget",[id]);
_260.init(id,name,_249,_259,_24a,edit,_25a,_25b,_256,_254,_255);
};
$G.applyStyles=function(_264){
if(_264.stylesApplied){
return;
}
Ext.util.CSS.createStyleSheet(_264.styles);
_264.stylesApplied=true;
};
$G.bindHandler=function(e,_266){
$G.refresh(_266.actions.id);
};
$G.bindHandler._cf_bindhandler=true;
$G.refresh=function(_267,_268){
var _269=ColdFusion.objectCache[_267];
if(_269&&$G.Actions.prototype.isPrototypeOf(_269)==true){
var _26a=_269.grid.getDataSource();
if(_269.dynamic){
_269.editOldValue=null;
_269.selectedRow=-1;
if(_268){
_26a.reload();
}else{
_26a.reload({params:{start:0,limit:_269.pageSize}});
}
}
}else{
ColdFusion.handleError(null,"grid.refresh.notfound","widget",[_267],null,null,true);
return;
}
$L.info("grid.refresh.success","widget",[_267]);
};
$G.sort=function(_26b,_26c,_26d){
var _26e=ColdFusion.objectCache[_26b];
if(!_26e){
ColdFusion.handleError(null,"grid.sort.notfound","widget",[_26b],null,null,true);
return;
}
_26c=_26c.toUpperCase();
var _26f=-1;
var _270=_26e.grid.getColumnModel().config;
for(var i=0;i<_270.length-1;i++){
if(_26c==_270[i].colName){
_26f=i;
break;
}
}
if(_26f==-1){
ColdFusion.handleError(null,"grid.sort.colnotfound","widget",[_26c,_26b],null,null,true);
return;
}
if(!_26d){
_26d="ASC";
}
_26d=_26d.toUpperCase();
if(_26d!="ASC"&&_26d!="DESC"){
ColdFusion.handleError(null,"grid.sort.invalidsortdir","widget",[_26d,_26b],null,null,true);
return;
}
var _272=_26e.grid.getDataSource();
_272.sort(_26c,_26d);
};
$G.getGridObject=function(_273){
if(!_273){
ColdFusion.handleError(null,"grid.getgridobject.missinggridname","widget",null,null,null,true);
return;
}
var _274=ColdFusion.objectCache[_273];
if(_274==null||$G.Actions.prototype.isPrototypeOf(_274)==false){
ColdFusion.handleError(null,"grid.getgridobject.notfound","widget",[_273],null,null,true);
return;
}
return _274.grid;
};
$G.Actions=function(_275){
this.gridId=_275;
this.init=$G.Actions.init;
this.onChangeHandler=$G.Actions.onChangeHandler;
this.selectionChangeEvent=new ColdFusion.Event.CustomEvent("cfGridSelectionChange",_275);
this.fireSelectionChangeEvent=$G.fireSelectionChangeEvent;
this._cf_getAttribute=$G.Actions._cf_getAttribute;
this._cf_register=$G.Actions._cf_register;
};
$G.Actions.init=function(id,_277,_278,_279,_27a,edit,_27c,_27d,_27e,_27f,_280){
this.id=id;
this.gridName=_277;
this.formId=_278;
this.form=document.getElementById(_278);
this.cellClickInfo=_279;
this.edit=edit;
this.onChangeFunction=_27c;
this.onErrorFunction=_27d;
this.preservePageOnSort=_27e;
this.pageSize=_27f;
this.selectedRow=-1;
this.selectOnLoad=_280;
this.grid.addListener("cellclick",$G.cellClick,this,true);
this.editField=document.createElement("input");
this.editField.setAttribute("name",_277);
this.editField.setAttribute("type","hidden");
this.form.appendChild(this.editField);
if(edit){
if(!_27a){
var _281=this.grid.getColumnModel().config;
this.editFieldPrefix="__CFGRID__EDIT__=";
this.editFieldPrefix+=_281.length-1+$G.Actions.fieldSep;
for(var i=0;i<_281.length-1;i++){
if(i>0){
this.editFieldPrefix+=$G.Actions.fieldSep;
}
this.editFieldPrefix+=_281[i].colName;
this.editFieldPrefix+=$G.Actions.valueSep;
if(_281[i].editor){
this.editFieldPrefix+="Y";
}else{
this.editFieldPrefix+="N";
}
}
this.editFieldPrefix+=$G.Actions.fieldSep;
this.editFieldState=[];
this.editFieldState.length=this.grid.getDataSource().getTotalCount();
$G.Actions.computeEditField(this);
}
this.grid.addListener("beforeedit",$G.Actions.beforeEdit,this,true);
this.grid.addListener("afteredit",$G.Actions.afterEdit,this,true);
}
if(_27a){
this.grid.getDataSource().addListener("beforeload",$G.Actions.beforeLoad,this,true);
}
this.grid.getSelectionModel().addListener("rowselect",$G.rowSelect,this,true);
this.grid.getSelectionModel().addListener("beforerowselect",$G.beforeRowSelect,this,true);
if(_280){
this.grid.getSelectionModel().selectFirstRow();
}
};
$G.Actions.beforeLoad=function(_283,_284){
var _285=_283.getSortState();
var _286=(_285.field!=this.sortCol||_285.direction!=this.sortDir);
if(_286&&!this.preservePageOnSort){
_284.params.start=0;
}
this.sortCol=_285.field;
this.sortDir=_285.direction;
};
$G.Actions.onLoad=function(){
this.editOldValue=null;
this.selectedRow=-1;
var _287=this.dynamic?0:1;
if((this.bindOnLoad||!this.dynamic)&&this.selectOnLoad){
this.grid.getSelectionModel().selectRow(_287,false);
}
};
$G.Actions._cf_getAttribute=function(_288){
_288=_288.toUpperCase();
var _289=this.selectedRow;
var _28a=null;
if(_289!=0&&(!_289||_289==-1)){
return _28a;
}
var ds=this.grid.getDataSource();
var _28c=(this.dynamic)?ds.getAt(_289):ds.getById(_289);
_28a=_28c.get(_288);
return _28a;
};
$G.Actions._cf_register=function(_28d,_28e,_28f){
this.selectionChangeEvent.subscribe(_28e,_28f);
};
$G.rowSelect=function(_290,row){
var _292="";
var _293=_290.getSelected();
var _294=_293.get("CFGRIDROWINDEX")||row;
if(this.selectedRow!=_294){
this.selectedRow=_294;
var _295=true;
for(col in _293.data){
if(col=="CFGRIDROWINDEX"){
continue;
}
if(!_295){
_292+="; ";
}
_292+="__CFGRID__COLUMN__="+col+"; ";
_292+="__CFGRID__DATA__="+_293.data[col];
_295=false;
}
this.fireSelectionChangeEvent();
}
this.editField.setAttribute("value",_292);
};
$G.beforeRowSelect=function(_296,row){
var ds=this.grid.getDataSource();
var _299=ds.getAt(row);
return !$G.isNullRow(_299.data);
};
$G.isNullRow=function(data){
var _29b=true;
for(col in data){
if(data[col]!=null){
_29b=false;
break;
}
}
return _29b;
};
$G.fireSelectionChangeEvent=function(){
$L.info("grid.fireselectionchangeevent.fire","widget",[this.id]);
this.selectionChangeEvent.fire();
};
$G.cellClick=function(grid,_29d,_29e){
var _29f=this.cellClickInfo.colInfo[_29e];
if(_29f){
var _2a0=grid.getSelectionModel().getSelected();
var url=_2a0.get(_29f.href.toUpperCase());
if(!url){
url=_29f.href;
}
var _2a2=_29f.hrefKey;
var _2a3=_29f.target;
var _2a4=this.appendKey;
if(this.cellClickInfo.appendKey){
var _2a5;
if(_2a2||_2a2==0){
var _2a6=grid.getDataSource().getAt(_29d);
var _2a7=grid.getColumnModel().config[_2a2].dataIndex;
_2a5=_2a6.get(_2a7);
}else{
var _2a8=this.grid.getColumnModel().config;
_2a5=_2a0.get(_2a8[0].dataIndex);
for(var i=1;i<_2a8.length-1;i++){
_2a5+=","+_2a0.get(_2a8[i].dataIndex);
}
}
if(url.indexOf("?")!=-1){
url+="&CFGRIDKEY="+_2a5;
}else{
url+="?CFGRIDKEY="+_2a5;
}
}
if(_2a3){
_2a3=_2a3.toLowerCase();
if(_2a3=="_top"){
_2a3="top";
}else{
if(_2a3=="_parent"){
_2a3="parent";
}else{
if(_2a3=="_self"){
_2a3=window.name;
}else{
if(_2a3=="_blank"){
window.open(encodeURI(url));
return;
}
}
}
}
if(!parent[_2a3]){
ColdFusion.handleError(null,"grid.cellclick.targetnotfound","widget",[_2a3]);
return;
}
parent[_2a3].location=encodeURI(url);
}else{
window.location=encodeURI(url);
}
}
};
$G.insertRow=function(){
var _2aa={action:"I",values:[]};
var _2ab=this.grid.getColumnModel();
var _2ac=this.grid.getDataSource();
var _2ad={};
for(var i=0;i<_2ab.getColumnCount()-1;i++){
var _2af="";
var _2b0=_2ab.getCellEditor(i,0);
if(_2b0&&Ext.form.Checkbox.prototype.isPrototypeOf(_2b0.field)){
_2af=false;
}
_2aa.values[i]=[_2af,_2af];
_2ad[_2ab.getDataIndex(i)]=_2af;
}
_2ad["CFGRIDROWINDEX"]=_2ac.getCount()+1;
_2ac.add(new Ext.data.Record(_2ad));
this.editFieldState.push(_2aa);
$G.Actions.computeEditField(this);
};
$G.deleteRow=function(){
var _2b1=this.selectedRow;
if(_2b1==-1){
return;
}
if(this.onChangeFunction){
this.onChangeHandler("D",_2b1,null,$G.deleteRowCallback);
}else{
if(!this.dynamic){
var _2b2=this.editFieldState[_2b1-1];
if(_2b2){
_2b2.action="D";
}else{
_2b2=$G.Actions.initEditState(this,"D",_2b1);
}
$G.Actions.computeEditField(this);
this.grid.stopEditing();
this.selectedRow=-1;
var _2b3=this.grid.getDataSource();
_2b3.remove(this.grid.getSelectionModel().getSelected());
}
}
};
$G.deleteRowCallback=function(_2b4,_2b5){
var _2b6=_2b5._cf_grid.getDataSource();
var _2b7=_2b5._cf_grid.actions;
_2b6.reload();
};
$G.Actions.beforeEdit=function(_2b8){
if($G.isNullRow(_2b8.record.data)){
return false;
}
this.editColumn=_2b8.column;
this.editOldValue=_2b8.value;
};
$G.Actions.afterEdit=function(_2b9){
var _2ba=_2b9.value;
if(this.onChangeFunction){
this.onChangeHandler("U",this.selectedRow,_2b9);
}else{
if(!this.dynamic){
var _2bb=this.editFieldState[this.selectedRow-1];
if(_2bb){
_2bb.values[_2b9.column][1]=_2ba;
}else{
_2bb=$G.Actions.initEditState(this,"U",this.selectedRow);
var _2bc=this.editOldValue+"";
_2bb.values[_2b9.column][0]=_2bc;
_2bb.values[_2b9.column][1]=_2ba;
}
$G.Actions.computeEditField(this);
}
}
this.editOldValue=null;
this.fireSelectionChangeEvent();
};
$G.Actions.onChangeHandler=function(_2bd,_2be,_2bf,_2c0){
var _2c1={};
var _2c2={};
var data=_2bf?_2bf.record.data:this.grid.getDataSource().getAt(_2be).data;
for(col in data){
_2c1[col]=data[col];
}
if(_2bd=="U"){
_2c1[_2bf.field]=_2bf.originalValue;
_2c2[_2bf.field]=_2bf.value;
}
this.onChangeFunction(_2bd,_2c1,_2c2,_2c0,this.grid,this.onErrorFunction);
};
$G.Actions.initEditState=function(_2c4,_2c5,_2c6){
var _2c7={action:_2c5,values:[]};
var _2c8=_2c4.grid.getColumnModel();
var _2c9=_2c8.getColumnCount()-1;
var _2ca=_2c4.grid.getDataSource().getById(_2c6);
_2c7.values.length=_2c9;
for(var i=0;i<_2c9;i++){
var _2cc=_2ca.get(_2c8.getDataIndex(i));
_2c7.values[i]=[_2cc,_2cc];
}
_2c4.editFieldState[_2c6-1]=_2c7;
return _2c7;
};
$G.Actions.fieldSep=eval("'\\u0001'");
$G.Actions.valueSep=eval("'\\u0002'");
$G.Actions.nullValue=eval("'\\u0003'");
$G.Actions.computeEditField=function(_2cd){
var _2ce=_2cd.editFieldPrefix;
var _2cf=_2cd.editFieldState;
var _2d0=0;
var _2d1="";
for(var i=0;i<_2cf.length;i++){
var _2d3=_2cf[i];
if(_2d3){
_2d0++;
_2d1+=$G.Actions.fieldSep;
_2d1+=_2d3.action+$G.Actions.valueSep;
var _2d4=_2d3.values;
for(var j=0;j<_2d4.length;j++){
if(j>0){
_2d1+=$G.Actions.valueSep;
}
var _2d6=($G.Actions.isNull(_2d4[j][0]))?$G.Actions.nullValue:_2d4[j][0];
var _2d7=($G.Actions.isNull(_2d4[j][1]))?$G.Actions.nullValue:_2d4[j][1];
_2d1+=_2d7;
if(_2d3.action=="U"){
_2d1+=$G.Actions.valueSep+_2d6;
}
}
}
}
_2ce+=_2d0+_2d1;
_2cd.editField.setAttribute("value",_2ce);
};
$G.Actions.isNull=function(val){
var ret=(val==null||typeof (val)=="undefined"||val.length==0);
return ret;
};
$G.loadData=function(data,_2db){
_2db._cf_gridDataProxy.loadResponse(data,_2db);
var _2dc=ColdFusion.objectCache[_2db._cf_gridname];
$G.applyStyles(_2dc);
$L.info("grid.loaddata.loaded","widget",[_2db._cf_gridname]);
if($G.Actions.isNull(data.TOTALROWCOUNT)==false&&data.TOTALROWCOUNT==0){
_2dc.fireSelectionChangeEvent();
}
};
$G.ExtProxy=function(_2dd,_2de){
$G.ExtProxy.superclass.constructor.call(this);
this.bindHandler=_2dd;
this.errorHandler=_2de;
};
Ext.extend($G.ExtProxy,Ext.data.DataProxy,{_cf_firstLoad:true,load:function(_2df,_2e0,_2e1,_2e2,arg){
if(!this._cf_actions.bindOnLoad){
var _2e4={"_cf_reader":_2e0,"_cf_grid_errorhandler":this.errorHandler,"_cf_scope":_2e2,"_cf_gridDataProxy":this,"_cf_gridname":this._cf_gridName,"_cf_arg":arg,"_cf_callback":_2e1,"ignoreData":true};
var data=[];
for(i=0;i<_2df.limit;i++){
data.push(new Ext.data.Record({}));
}
this.loadResponse(data,_2e4);
this._cf_actions.bindOnLoad=true;
}else{
var _2e6=(_2df.start/_2df.limit)+1;
if(!_2df.sort){
_2df.sort="";
}
if(!_2df.dir){
_2df.dir="";
}
this.bindHandler(this,_2e6,_2df.limit,_2df.sort,_2df.dir,this.errorHandler,_2e1,_2e2,arg,_2e0);
}
},loadResponse:function(data,_2e8){
var _2e9=null;
if(_2e8.ignoreData){
_2e9={success:true,records:data,totalRecords:data.length};
}else{
var _2ea;
if(!data){
_2ea="grid.extproxy.loadresponse.emptyresponse";
}else{
if(!data.TOTALROWCOUNT&&data.TOTALROWCOUNT!=0){
_2ea="grid.extproxy.loadresponse.totalrowcountmissing";
}else{
if(!ColdFusion.Util.isInteger(data.TOTALROWCOUNT)){
_2ea="grid.extproxy.loadresponse.totalrowcountinvalid";
}else{
if(!data.QUERY){
_2ea="grid.extproxy.loadresponse.querymissing";
}else{
if(!data.QUERY.COLUMNS||!ColdFusion.Util.isArray(data.QUERY.COLUMNS)||!data.QUERY.DATA||!ColdFusion.Util.isArray(data.QUERY.DATA)||(data.QUERY.DATA.length>0&&!ColdFusion.Util.isArray(data.QUERY.DATA[0]))){
_2ea="grid.extproxy.loadresponse.queryinvalid";
}
}
}
}
}
if(_2ea){
ColdFusion.handleError(_2e8._cf_grid_errorHandler,_2ea,"widget");
this.fireEvent("loadexception",this,_2e8,data,e);
return;
}
_2e9=_2e8._cf_reader.readRecords(data);
}
this.fireEvent("load",this,_2e8,_2e8._cf_arg);
_2e8._cf_callback.call(_2e8._cf_scope,_2e9,_2e8._cf_arg,true);
},update:function(_2eb){
},updateResponse:function(_2ec){
}});
$G.ExtReader=function(_2ed){
this.recordType=Ext.data.Record.create(_2ed);
};
Ext.extend($G.ExtReader,Ext.data.DataReader,{readRecords:function(_2ee){
var _2ef=[];
var cols=_2ee.QUERY.COLUMNS;
var data=_2ee.QUERY.DATA;
for(var i=0;i<data.length;i++){
var _2f3={};
for(var j=0;j<cols.length;j++){
_2f3[cols[j]]=data[i][j];
}
_2ef.push(new Ext.data.Record(_2f3));
}
return {success:true,records:_2ef,totalRecords:_2ee.TOTALROWCOUNT};
}});
};
cfinitgrid();
