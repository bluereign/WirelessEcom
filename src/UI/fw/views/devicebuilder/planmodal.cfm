<cfif !structKeyExists(rc,"plan")>
  <cfset prc.DetailTitle = "rc.plan does not exist" />
  <cfset prc.DataLimitGB = "0" />
  <cfset prc.SummaryDescription = "No plan selected" />
<cfelseif structKeyExists(prc,"planInfo")>
  <cfset prc.DetailTitle = prc.planInfo.DetailTitle />
  <cfset prc.DataLimitGB = prc.planInfo.DataLimitGB />
  <cfset prc.SummaryDescription = prc.planInfo.SummaryDescription />
  <cfset prc.MonthlyFee = prc.planInfo.MonthlyFee />
  <cfset prc.DetailDescription = prc.planInfo.DetailDescription />
</cfif>

<cfparam name="prc.DetailTitle" default="Plan Modal Title" />
<cfparam name="prc.DataLimitGB" default="" />
<cfparam name="prc.SummaryDescription" default="Please close this modal and then refresh your page" />
<cfparam name="prc.MonthlyFee" default="0" />

<cfoutput>
    <input type="hidden" name="plan" value="#rc.plan#">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h4 class="modal-title">#prc.DetailTitle#</h4>
    </div>
    <div class="modal-body plans">
      <div class="info">
        <ul>
          <li class="large"><span>#prc.DataLimitGB#GB</span></li>
        </ul>
        <p>#prc.SummaryDescription#</p>
        <p>#prc.DetailDescription#</p>
        <div class="price">#dollarFormat(prc.MonthlyFee)#/month</div>
      </div>
    </div>
    
    <div class="modal-footer">
      <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      <a href="#event.buildLink('devicebuilder.protection')#/pid/#rc.pid#/type/#rc.type#/plan/#rc.plan#" type="button" class="btn btn-primary">Select Package</a>
    </div>

</cfoutput>
