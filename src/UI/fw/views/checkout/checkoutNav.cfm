<cfoutput>
  <!--- <Navigation --->
  <div class="head">
    <ul class="nav nav-pills nav-justified">
      <cfloop index="i" from="1" to="#arrayLen(prc.navItemsAction)#">
        
        <cfif event.getCurrentAction() is prc.navItemsAction[i]>
          <cfset prc.isCurrent = true>
        <cfelse>
          <cfset prc.isCurrent = false>
        </cfif>
        <cfif i lt listFindNoCase(arrayToList(prc.navItemsAction), event.getCurrentAction())>
          <cfset prc.isComplete = true>
          <cfset prc.navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/pid/' & rc.pid & '/type/' & rc.type & '/finance/' & rc.finance & '/'>
          <cfif structKeyExists(rc,"line")>
            <cfset prc.navUrl = prc.navUrl & 'line/' & rc.line & '/'>
          </cfif>
          <cfif structKeyExists(rc,"plan")>
            <cfset prc.navUrl = prc.navUrl & 'plan/' & rc.plan & '/'>
          </cfif>
        <cfelse>
          <cfset prc.isComplete = false>

<!--- change this before production to disabled URL when item is not complete --->
<!--- UNCOMMENT THIS NEXT LINE: --->
          <!--- <cfset request.navUrl = 'javascript: void(0)'> --->

<!--- COMMENT OUT THIS NEXT LINE: --->
          <cfset prc.navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/pid/' & rc.pid & '/type/' & rc.type & '/finance/' & rc.finance & '/'>

        </cfif>
        
        <li role="presentation" 
          <cfif prc.isCurrent>
            class="active"
          <cfelse>
            class="hidden-xs
            <cfif prc.isComplete>complete</cfif>"
          </cfif>>
          <a href="#prc.navUrl#"><span>#i#</span>#prc.navItemsText[i]#</a>
        </li>
      </cfloop>
    </ul>
  </div> <!--- <end navigation --->
</cfoutput>
