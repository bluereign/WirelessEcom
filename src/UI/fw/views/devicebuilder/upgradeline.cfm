<!--- <cfdump var="#rc#"> --->
<cfoutput>
  <div class="col-md-12">
    <form action="#prc.nextStep#" method="post">
      <input type="hidden" name="finance" value="#rc.finance#">
      <cfif structKeyExists(rc,"line")>
        <input type="hidden" name="line" value="#rc.line#">
      </cfif>
      <section class="content">
        <header class="main-header">
          <h1>Upgrade or Add a Line</h1>
          <p>Choose a line to Upgrade or Add a New Line for this device.</p>
        </header>
        <div class="row">
          <cfloop index="i" from="1" to="#arrayLen(prc.subscribers)#">
            <!--- TESTING ONLY: ensure that there is at least one eligible number for upgrade --->
            <cfif i eq 1>
              <cfset prc.subscribers[i].isEligible = 1 />
            <cfelse>
              <cfset prc.subscribers[i].isEligible = prc.subscribers[i].getIsEligible() />
            </cfif>
            <!--- format phonenumber --->
            <!--- step 1: remove special characters (if any) --->
            <cfset prc.subscribers[i].phoneNumber = reReplace(prc.subscribers[i].getNumber(),"[{}\(\)\^$&%##!@=<>:;,~`'\'\*\?\/\+\|\[\\\\]|\]|\-",'','all') />
            <cfset prc.subscribers[i].phoneNumber1 = left(prc.subscribers[i].phoneNumber, 3) />
            <cfset prc.subscribers[i].phoneNumber2 = mid(prc.subscribers[i].phoneNumber, 4, 3) />
            <cfset prc.subscribers[i].phoneNumber3 = right(prc.subscribers[i].phoneNumber, 4) />
            <cfset prc.subscribers[i].phoneNumber = "(#prc.subscribers[i].phoneNumber1#) #prc.subscribers[i].phoneNumber2#-#prc.subscribers[i].phoneNumber3#" />
            <div class="col-md-4 col-sm-3 col-xs-8">
              <div class="product">
                <img src="#prc.productImages[1].imagesrc#" alt="#prc.productImages[1].imageAlt#" />
				<div class="manufacturer">apple</div>
                <div class="model info ">iPhone 5</div>
                <div class="phone info">#prc.subscribers[i].phoneNumber#</div>
                <cfif prc.subscribers[i].isEligible>
                  <button class="btn btn-sm btn-primary" name="line" value="#i#">Upgrade Line</button>
                <cfelse>
                  <button class="btn btn-sm btn-primary" disabled="disabled">
                    <cfif isDate(prc.subscribers[i].getEligibilityDate()) and dateCompare(prc.subscribers[i].getEligibilityDate(),now()) gte 0>
                      Eligible #DateFormat(prc.subscribers[i].getEligibilityDate(), "m/d/yyyy")#
                    </cfif>
                  </button>
                  <!--- <cfif isDate(prc.subscribers[i].getEligibilityDate())>
                    <br />
                    Date Eligible: #DateFormat(prc.subscribers[i].getEligibilityDate(), "m/d/yyyy")#
                  </cfif> --->
                </cfif>
              </div>
            </div>
          </cfloop>
      </section>
    </form>
  </div>


  <!--- for debugging: --->
    <!--- <cfdump var="#prc.productData#" label="prc.productData"> --->
    <!--- <cfdump var="#prc.productData.resultset#"> --->
    <!---   prc.productData.productId: #prc.productData.productId#
    <br/>
    prc.productData.carrierId: #prc.productData.carrierId#
    <br />
     structKeyExists(session,'carrierObj'): #structKeyExists(session,'carrierObj')# --->


</cfoutput>
