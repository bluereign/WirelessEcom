<script>
	viewMilitaryWindow = function (showPage, windowTitle) {
		ColdFusion.Window.create(showPage,windowTitle,'//<cfoutput>#cgi.server_name#</cfoutput>/index.cfm/go/content/do/' + showPage,  {x:50,y:50,height:650,width:535,modal:true,
        draggable:true,resizable:true,initshow:true,
        minheight:200,minwidth:200 });
		ColdFusion.Window.show(showPage);
		ColdFusion.Window.onHide(showPage,refreshParent);
	}
</script>
<cfoutput>
	<div id="nav-menu-container">
		<ul id="nav" class="dropdown dropdown-horizontal">
			<li class="dir">
				<a href="/">Return to Shopping</a>
			</li>
			<li class="dir">
				<a href="##" onClick="viewMilitaryWindow('MilitaryDiscount', 'Military Discount')" col="Military Discounts">Military Discounts</a>
			</li>
			<li class="dropdown-vertical-rtl dir">
				<a href="##" onClick="viewMilitaryWindow('MilitaryDeployment', 'Military Deployment')" col="Military Deployment">Military Deployment</a>
			</li>			
		</ul>
	</div>
</cfoutput>