<cfparam name="URL.img" type="string" default="" />
<cfparam name="URL.height" type="integer" default="0" />
<cfparam name="URL.width" type="integer" default="0" />
<cfoutput>
	<cfset imgURL = application.view.ImageManager.displayImage(URL.img, URL.height, URL.width) />
	<cflocation url="#imgURL#" addtoken="false" />
</cfoutput>