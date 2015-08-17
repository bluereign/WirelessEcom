<cfsilent><cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfparam name="request.p.jsessionid" type="string" default="#session.sessionid#">
<cfparam name="request.p.line" type="numeric">
<cfparam name="request.p.step" type="numeric">

<cfscript>
	html = application.model.CartHelper.getWorkflowContent(jsessionid=request.p.jsessionid,line=request.p.line,step=request.p.step);
</cfscript>

</cfsilent><cfoutput>#trim(html)#</cfoutput><cfabort>