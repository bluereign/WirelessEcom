<cfparam name="realurl" default=""/>
<cfif realurl is not "">
<cflocation url="#realurl#"/>
<cfelse>
You did not specify the realurl parameter.
</cfif>