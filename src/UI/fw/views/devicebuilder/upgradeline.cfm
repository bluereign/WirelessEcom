<cfoutput>
  <div class="col-md-12">
    <form action="#prc.nextStep#" method="post">
      <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
      <section class="content">
        <header class="main-header">
          <h1>Upgrade or Add a Line</h1>
          <p>Choose a line to Upgrade or Add a New Line for this device.</p>
        </header>
        <div class="row">
          
          <cfloop index="i" from="1" to="#arrayLen(prc.subscribers)#">

            <cfset prc.subscribers[i].phoneNumber = prc.stringUtil.formatPhoneNumber(trim(prc.subscribers[i].getNumber())) />

            <div class="col-md-4 col-sm-3 col-xs-8">
              <div class="product">
                <div class="phone info">#prc.subscribers[i].phoneNumber#</div>
                <cfif prc.subscribers[i].getIsEligible()>
                  <button class="btn btn-sm btn-primary" name="subscriberIndex" value="#i#">Upgrade Line</button>
                <cfelse>
                  <button class="btn btn-sm btn-primary" disabled="disabled">
                    <cfif isDate(prc.subscribers[i].getEligibilityDate()) and dateCompare(prc.subscribers[i].getEligibilityDate(),now()) gte 0>
                      Eligible #DateFormat(prc.subscribers[i].getEligibilityDate(), "m/d/yyyy")#
                    </cfif>
                  </button>
                </cfif>
              </div>
            </div>

          </cfloop>

      </section>
    </form>
  </div>
</cfoutput>
