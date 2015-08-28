<cfoutput>
  <!--- <Navigation --->
  <div class="head">
    <ul class="nav nav-pills nav-justified">
      <cfloop index="i" from="1" to="#arrayLen(prc.navItemsAction)#">
        
        <cfif event.getCurrentAction() is prc.navItemsAction[i]>
          <cfset request.isCurrent = true>
        <cfelse>
          <cfset request.isCurrent = false>
        </cfif>
        <cfif i lt listFindNoCase(arrayToList(prc.navItemsAction), event.getCurrentAction())>
          <cfset request.isComplete = true>
          <cfset request.navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/pid/' & rc.pid & '/type/' & rc.type & '/'>
        <cfelse>
          <cfset request.isComplete = false>

<!--- change this before production to disabled URL when item is not complete --->
<!--- UNCOMMENT THIS NEXT LINE: --->
          <!--- <cfset request.navUrl = 'javascript: void(0)'> --->

<!--- COMMENT OUT THIS NEXT LINE: --->
          <cfset request.navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/pid/' & rc.pid & '/type/' & rc.type & '/'>

        </cfif>
        
        <li role="presentation" 
          <cfif request.isCurrent>
            class="active"
          <cfelse>
            class="hidden-xs
            <cfif request.isComplete>complete</cfif>"
          </cfif>>
          <a href="#request.navUrl#"><span>#i#</span>#prc.navItemsText[i]#</a>
        </li>
      </cfloop>
    </ul>
  </div> <!--- <end navigation --->
</cfoutput>
