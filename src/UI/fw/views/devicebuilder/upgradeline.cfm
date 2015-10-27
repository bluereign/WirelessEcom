<cfoutput>
  <div class="col-md-12">
      <section class="content">

        <cfif structKeyExists(prc,"warningMessage")>
          <div class="bs-callout bs-callout-error">
            <h4>#prc.warningMessage#</h4>
          </div>
        </cfif>

        <header class="main-header">
          <h1>Upgrade or Add a Line</h1>
          <p>Choose a line to Upgrade or Add a New Line for this device.</p>
        </header>

        <form action="#prc.nextStep#" method="post">

        <cfif structKeyExists(prc,"cartLine") and isValid("integer",prc.cartLine.getSubscriberIndex()) and prc.cartLine.getSubscriberIndex() gt 0>
          <div class="right">
            <a href="#prc.prevStep#">BACK</a>
            <button type="submit" class="btn btn-primary">Continue</button>
          </div>
        </cfif>
        <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />

        <div class="row">
          
          <cfloop index="i" from="1" to="#arrayLen(prc.subscribers)#">

            <cfset prc.subscribers[i].phoneNumber = prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[i].getNumber())) />

            <div class="col-md-4 col-sm-3 col-xs-8">
              <div class="product">
                <div class="phone info">#prc.subscribers[i].phoneNumber#</div>
                
                <cfif prc.subscribers[i].getIsEligible()>

                  <cfset local.isSubscriberIndexTaken = false>
                  <cfloop index="j" from="1" to="#arrayLen(prc.cartLines)#">
                    <cfif prc.cartLines[j].getSubscriberIndex() eq i>
                      <cfset local.isSubscriberIndexTaken = true>
                      <cfbreak>
                    </cfif>
                  </cfloop>

                  <cfif local.isSubscriberIndexTaken>
                    <button class="btn btn-sm btn-primary" disabled="disabled"><cfif i eq prc.cartLine.getSubscriberIndex()>Selected<cfelse>In Cart</cfif></button>
                  <cfelse>
                    <button class="btn btn-sm btn-primary" name="subscriberIndex" value="#i#">Upgrade Line</button>
                  </cfif>

                <cfelse>

                  <button class="btn btn-sm btn-primary" disabled="disabled">
                    <cfif isDate(prc.subscribers[i].getEligibilityDate()) and dateCompare(prc.subscribers[i].getEligibilityDate(),now()) gte 0>
                      Eligible #DateFormat(prc.subscribers[i].getEligibilityDate(), "m/d/yyyy")#
                    <cfelse>
                      Ineligible
                    </cfif>
                  </button>
                
                </cfif>

              </div>
            </div>

          </cfloop>


          <cfif structKeyExists(prc,"cartLine") and isValid("integer",prc.cartLine.getSubscriberIndex()) and prc.cartLine.getSubscriberIndex() gt 0>
            <div class="right">
              <a href="#prc.prevStep#">BACK</a>
              <button type="submit" class="btn btn-primary">Continue</button>
            </div>
          </cfif>
          

      </section>
    </form>
  </div>
</cfoutput>
