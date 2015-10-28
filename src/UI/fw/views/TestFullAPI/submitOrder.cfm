<h1>Submit Order Results</h1><br/>
<br>Submit Order Request:<br/>
<cfdump var="#rc.submitOrderRequest#" expand="false" />
<br>Submit Order Response:<br/>
<cfdump var="#rc.submitOrderResponse.getResponse()#" expand="false"/>
<br/>
<br/>Dump the Carrierfacade Session Storage Struct:<br/>
<cfdump var="#session.carrierfacade#" expand="false" />