<cfset assetPaths = application.wirebox.getInstance("assetPaths") />
<!--- <cflocation addtoken="false" url="/shop/index.cfm/do/home"> --->
<cfparam name="request.p.go" default="content">
<cfparam name="request.p.do" default="home">

<cfsavecontent variable="request.bodycontent">
	<!--- import necessary AJAX/JS libraries for cfwindow and cfform --->
	<cfajaximport tags="cfform,cfwindow,cfdiv" scriptsrc="#assetPaths.common#scripts/cfajax/">

	<cfoutput><cfinclude template="#request.p.go##application.pathDelim#index.cfm"></cfoutput>
</cfsavecontent>