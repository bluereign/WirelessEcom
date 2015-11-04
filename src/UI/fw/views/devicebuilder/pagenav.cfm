<cfoutput>
<cfif event.getCurrentAction() is not "orderreview">

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
          <!--- Set cartLineNumber to '1' if coming from Order Summary page (and cartLineNumber is 999) --->
          <cfset prc.navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/cartLineNumber/' & IIF(rc.cartLineNumber eq request.config.otherItemsLineNumber, 1, DE(rc.cartLineNumber) ) & '/'>

        <cfelse>
          
          <cfset prc.isComplete = false>
<!--- DONE: change this before production to disabled URL when item is not complete --->
<!--- UNCOMMENT THIS NEXT LINE: --->
          <cfset prc.navUrl = 'javascript: void(0)'>

<!--- COMMENT OUT THIS NEXT LINE: --->
          <!--- <cfset prc.navUrl = event.buildLink('devicebuilder.#prc.navItemsAction[i]#') & '/cartLineNumber/' & rc.cartLineNumber & '/'> --->

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
  </div>
  </cfif>
</cfoutput>
