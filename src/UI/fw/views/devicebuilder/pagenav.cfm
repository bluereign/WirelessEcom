<cfoutput>
  <!--- <Navigation --->
  <div class="head">
    <ul class="nav nav-pills nav-justified">
      <cfloop index="i" from="1" to="#arrayLen(prc.navItemsAction)#">
        <cfset navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/pid/' & rc.pid & '/type/' & rc.type & '/'>
        <li role="presentation" 
          <cfif listGetAt(rc.event,2,'.') is prc.navItemsAction[i]>
            class="active"<cfelse>class="hidden-xs
            <cfif i lt listFindNoCase(arrayToList(prc.navItemsAction), listGetAt(rc.event,2,'.'))>complete</cfif>"
          </cfif>
          >
          <a href="#navUrl#"><span>#i#</span>#prc.navItemsText[i]#</a>
        </li>
      </cfloop>
    </ul>
  </div> <!--- <end navigation --->
</cfoutput>
