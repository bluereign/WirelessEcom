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
          <cfloop index="i" from="1" to="#arrayLen(prc.subscribers)#">
            <cfset prc.subscribers[i].phoneNumber = prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[i].getNumber())) />
            <cfif prc.subscribers[i].getIsEligible()>
              <div class="col-md-4 col-sm-3 col-xs-8">
                <div class="product">
                  <div class="phone info">
                    #prc.subscribers[i].phoneNumber#
                  </div>
                  <cfif listFindNoCase(prc.subscribersInCart,i)>
                    <button class="btn btn-sm btn-primary" disabled="disabled">
                      <cfif i eq prc.cartLine.getSubscriberIndex()>Selected<cfelse>In Cart</cfif>
                    </button>
                  <cfelseif listFindNoCase(prc.subscribersConflictsUnresolvable,i)>
                    <button class="btn btn-sm btn-primary" disabled="disabled">
                      Incompatible
                    </button>
                  <cfelse>
                    <button class="btn btn-sm btn-primary" name="subscriberIndex" value="#i#">Upgrade This Line</button>
                  </cfif>
                </div>
              </div>
            </cfif>
          </cfloop>
          <!-- End output upgrade eligible lines-->
          <!-- Start output upgrade non eligible lines-->
          <cfloop index="i" from="1" to="#arrayLen(prc.subscribers)#">
            <cfset prc.subscribers[i].phoneNumber = prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[i].getNumber())) />
            <cfif !prc.subscribers[i].getIsEligible()>
              <div class="col-md-4 col-sm-3 col-xs-8">
                <div class="product">
                  <div class="phone info">
                    #prc.subscribers[i].phoneNumber#
                  </div>
                  <button class="btn btn-sm btn-primary" disabled="disabled">
                    <cfif isDate(prc.subscribers[i].getEligibilityDate()) and dateCompare(prc.subscribers[i].getEligibilityDate(),now()) gte 0>
                      Eligible #DateFormat(prc.subscribers[i].getEligibilityDate(), "m/d/yyyy")#
                    <cfelse>
                      Ineligible
                    </cfif>
                  </button>
                </div>
              </div>
            </cfif>
          </cfloop>
          <!-- Start output upgrade non eligible lines-->
          
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
