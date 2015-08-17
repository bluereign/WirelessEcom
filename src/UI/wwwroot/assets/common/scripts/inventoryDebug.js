revealInventoryDebugInfo = function (productId,elem)
{
	var debugInfoDiv = $('inventoryDebugInfo_'+productId);
	debugInfoDiv.addClassName('inventoryDebugInfoVisible');
	debugInfoDiv.clonePosition(elem, { setWidth: false, setHeight: false, setTop: true, setLeft: true, offsetLeft: -248 });
}

hideInventoryDebugInfo = function (elem)
{
	elem.removeClassName('inventoryDebugInfoVisible');
}
