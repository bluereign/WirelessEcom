<cfparam name="prc.displayBackButton" default="false" />
<cfoutput>
  <div class="col-md-12">
      <section class="content">

        <cfif structKeyExists(prc,"warningMessage")>
          <div class="bs-callout bs-callout-error">
            <h4>#prc.warningMessage#</h4>
          </div>
        </cfif>

        <header class="main-header">
          <h1>Upgrade a Line</h1>
          <p>Choose a line to Upgrade for this device.</p>
        </header>

        <form action="#prc.nextStep#" method="post">

        <cfif structKeyExists(prc,"cartLine") and isValid("integer",prc.cartLine.getSubscriberIndex()) and prc.cartLine.getSubscriberIndex() gt 0>
          <div class="right">
            <a href="#prc.prevStep#">BACK</a>
            <button type="submit" class="btn btn-primary">Continue</button>
          </div>
        <cfelseif prc.displayBackButton>
          <div class="right">
            <a href="#prc.prevStep#">BACK</a>
          </div>
        </cfif>
        <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />

        <div class="row">
          <!-- output upgrade eligible lines-->
          <cfloop index="i" from="1" to="#arrayLen(prc.subscribers)#">
            <cfset prc.subscribers[i].phoneNumber = prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[i].getNumber())) />
            <cfset local.isSubscriberIndexTaken = false>
            <cfloop index="j" from="1" to="#arrayLen(prc.cartLines)#">
              <cfif prc.cartLines[j].getSubscriberIndex() eq i>
                <cfset local.isSubscriberIndexTaken = true>
                <cfbreak>
              </cfif>
            </cfloop>
            <cfif prc.subscribers[i].getIsEligible()>
            <div class="col-md-4 col-sm-3 col-xs-8">
              <div class="product">
                <div class="phone info">#prc.subscribers[i].phoneNumber#</div>
                <cfif prc.subscribers[i].getIsEligible()>
                  <cfif local.isSubscriberIndexTaken>
                    <button class="btn btn-sm btn-primary" disabled="disabled"><cfif i eq prc.cartLine.getSubscriberIndex()>Selected<cfelse>In Cart</cfif></button>
                  <cfelse>
                    <button class="btn btn-sm btn-primary" name="subscriberIndex" value="#i#">Upgrade This Line</button>
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
            </cfif>
          </cfloop>
          <!-- End output upgrade eligible lines-->
          <!-- output upgrade eligible lines-->
          <cfloop index="i" from="1" to="#arrayLen(prc.subscribers)#">
            <cfset prc.subscribers[i].phoneNumber = prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[i].getNumber())) />
            <cfset local.isSubscriberIndexTaken = false>
            <cfloop index="j" from="1" to="#arrayLen(prc.cartLines)#">
              <cfif prc.cartLines[j].getSubscriberIndex() eq i>
                <cfset local.isSubscriberIndexTaken = true>
                <cfbreak>
              </cfif>
            </cfloop>
          
            <cfif !prc.subscribers[i].getIsEligible()>
            <div class="col-md-4 col-sm-3 col-xs-8">
              <div class="product">
                <div class="phone info">#prc.subscribers[i].phoneNumber#</div>
                <cfif prc.subscribers[i].getIsEligible()>
                  <cfif local.isSubscriberIndexTaken>
                    <button class="btn btn-sm btn-primary" disabled="disabled"><cfif i eq prc.cartLine.getSubscriberIndex()>Selected<cfelse>In Cart</cfif></button>
                  <cfelse>
                    <button class="btn btn-sm btn-primary" name="subscriberIndex" value="#i#">Upgrade This Line</button>
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
            </cfif>
          </cfloop>
          <!-- End output upgrade eligible lines-->
          

          <cfif structKeyExists(prc,"cartLine") and isValid("integer",prc.cartLine.getSubscriberIndex()) and prc.cartLine.getSubscriberIndex() gt 0>
            <div class="right">
              <a href="#prc.prevStep#">BACK</a>
              <button type="submit" class="btn btn-primary">Continue</button>
            </div>
          <cfelseif prc.displayBackButton>
            <div class="right">
              <a href="#prc.prevStep#">BACK</a>
            </div>
          </cfif>
          

      </section>
    </form>
  </div>
</cfoutput>
