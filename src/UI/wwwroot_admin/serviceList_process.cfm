<cfparam name="url.iDisplayStart" default="0" type="integer" />
<cfparam name="url.iDisplayLength" default="50" type="integer" />
<cfparam name="url.sSearch" default="" type="string" />
<cfparam name="url.iSortingCols" default="0" type="integer" />

<cfset qFiltered = application.model.ServiceManager.filterServiceList(url) />
<cfset qCount = application.model.ServiceManager.serviceListCount() />
<cfcontent reset="Yes" />{"sEcho": <cfoutput>#val(url.sEcho)#</cfoutput>, "iTotalRecords": <cfoutput>#qCount.total#</cfoutput>, "iTotalDisplayRecords": <cfoutput>#qFiltered.recordCount#</cfoutput>, "aaData": [ <cfoutput query="qFiltered" startrow="#val(url.iDisplayStart+1)#" maxrows="#val(url.iDisplayLength)#"><cfif currentRow gt (url.iDisplayStart+1)>,</cfif>["#jsStringFormat(qFiltered.name)#","#jsStringFormat(qFiltered.active)#","#jsStringFormat(qFiltered.carrier)#","#jsStringFormat(qFiltered.carrierBillCode)#","#jsStringFormat(qFiltered.gersSku)#","#jsStringFormat(qFiltered.ServiceGuid)#"]</cfoutput> ] }

	