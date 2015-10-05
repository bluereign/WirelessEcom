<cfoutput>
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
      <h4 class="modal-title">Plan Details</h4>
    </div>
    <div class="modal-body">
      <div class="plans">
        <div class="info">
          <h3 style="height:40px"><span>#prc.planInfo.DetailTitle#</span></h3>
          <ul>
            <li class="large"><span>#prc.planInfo.DataLimitGB#GB</span></li>
          </ul>
          <p>#prc.planInfo.SummaryDescription#</p>
          <p>#prc.planInfo.DetailDescription#</p>
          <div class="price">#dollarFormat(prc.planInfo.MonthlyFee)#/month</div>
        </div>
      </div>
    </div>
    
    <div class="modal-footer">
      <form action="#prc.nextStep#" method="post">
        <input type="hidden" name="plan" value="#rc.plan#" />
        <input type="hidden" name="pid" value="#rc.pid#" />
        <input type="hidden" name="type" value="#rc.type#" />
        <input type="hidden" name="finance" value="#rc.finance#" />
        <input type="hidden" name="line" value="#rc.line#" />
        <input type="hidden" name="cartLineNumber" value="#rc.cartLineNumber#" />
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button class="btn btn-primary" type="submit">Select Package</button>
      </form>
    </div>

</cfoutput>
