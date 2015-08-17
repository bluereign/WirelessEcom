<cfsetting showdebugoutput="false" >
<cfparam name="orderDetail" type="struct" default="#structNew()#" />

<cfset orderAsHtml = application.view.order.getOrderFullView(orderDetail) />

<cfoutput>
	<div>
		<span class="actionButtonLow hideWhenPrinted"><a href="##" onclick="location.href = '/index.cfm/go/myAccount/do/viewOrderHistory'">Return to Order History</a></span>
		<span class="actionButtonLow hideWhenPrinted"><a href="#cgi.script_name##cgi.path_info#/printFormat/true" target="_blank">Print</a></span>
	</div>
	<div class="orderDetailArea">
		#trim(variables.orderAsHtml)#
	</div>
	<div>
		<span class="actionButtonLow hideWhenPrinted"><a href="##" onclick="location.href = '/index.cfm/go/myAccount/do/viewOrderHistory'">Return to Order History</a></span>
		<span class="actionButtonLow hideWhenPrinted"><a href="#cgi.script_name##cgi.path_info#/printFormat/true" target="_blank">Print</a></span>
	</div>
</cfoutput>