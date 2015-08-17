<cfhttp method="GET" url="https://shop.aafes.com/wsICS/clsSecurity.asmx/ReturnInputXML" >
				<!---<cfhttpparam type="formField" name="submit" value="Invoke" />--->
</cfhttp>
<cfdump var="#cfhttp#" />

<form method="POST" action="https://shop.aafes.com/wsICS/clsSecurity.asmx/ReturnInputXML" >
	<input type="submit" value="Invoke POST" />
</form>	

<form method="GET" action="https://shop.aafes.com/wsICS/clsSecurity.asmx/ReturnInputXML" target="_blank">
	<input type="submit" value="Invoke GET" />
</form>	