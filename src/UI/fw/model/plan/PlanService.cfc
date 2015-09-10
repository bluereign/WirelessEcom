  <cfcomponent displayname="PlanService" hint="Provides a plan data" extends="fw.model.BaseService" output="false">

  <cffunction name="init" output="false" access="public" returntype="fw.model.plan.PlanService">
    <cfreturn this />
  </cffunction>
  
  <cffunction name="getPlans" access="public" output="false" returntype="any" hint="Return a query object of plans.">
    <cfargument name="carrierId" required="true" />
    <cfargument name="zipCode" required="true" />
    <cfargument name="isShared" type="string" default="" />
    <cfargument name="idList" type="string" default="" />

    <cfquery name="planData" datasource="#application.dsn.wirelessAdvocates#">
      SELECT 
        p.RateplanGuid
      , p.ProductGuid
      , p.PlanId
      , p.ProductId
      , p.GersSku
      , p.CarrierBillCode
      , p.PlanName
      , p.PlanType
      , p.IsShared
      , p.PageTitle
      , p.SummaryTitle
      , p.DetailTitle
      , p.FamilyPlan
      , p.CompanyName
      , p.CarrierName
      , p.CarrierId
      , p.CarrierGuid
      , p.CarrierLogoSmall
      , p.CarrierLogoMedium
      , p.CarrierLogoLarge
      , p.SummaryDescription
      , p.DetailDescription
      , p.MetaKeywords
      , p.PlanPrice
      , p.MonthlyFee
      , p.IncludedLines
      , p.MaxLines
      , p.AdditionalLineFee
      , p.minutes_anytime
      , p.minutes_offpeak
      , p.minutes_mobtomob
      , p.minutes_friendsandfamily
      , p.unlimited_offpeak
      , p.unlimited_mobtomob
      , p.unlimited_friendsandfamily
      , p.unlimited_data
      , p.unlimited_textmessaging
      , p.free_longdistance
      , p.free_roaming
      , p.data_limit
      , p.DataLimitGB
      , p.additional_data_usage
      , IsNull( (SELECT TOP 1 pp.Value FROM catalog.Property pp WHERE pp.ProductGuid = p.ProductGuid AND pp.Name = 'PLAID_DEVICE_CAP_INDICATOR'), 'N') HasPlanDeviceCap 
      FROM  catalog.dn_Plans AS p WITH (NOLOCK) 
      WHERE 1 = 1 
        AND p.carrierID IN ( #arguments.carrierId# ) 
        AND p.PlanPrice > 0 
      <cfif len(trim(arguments.idList))>
        AND (
            1 = 0
            <cfloop list="#arguments.idList#" index="local.thisId">
              <cfif len(trim(local.thisId))>
                OR (
                  p.planId  = <cfqueryparam value="#local.thisId#" cfsqltype="cf_sql_integer" />
                )
              </cfif>
            </cfloop>
          )
      <cfelse>
        <cfif arguments.isShared is 'true'>
          AND p.IsShared = 1
        </cfif>
        <cfif len(trim(arguments.zipCode))>
          AND EXISTS  (
              SELECT      1
              FROM      catalog.dn_Plans AS p2 WITH (NOLOCK)
              INNER LOOP JOIN catalog.RateplanMarket AS rm WITH (NOLOCK) ON p2.RateplanGuid = rm.RateplanGuid
              INNER LOOP JOIN catalog.ZipCodeMarket AS zm WITH (NOLOCK) ON rm.MarketGuid = zm.MarketGuid
              WHERE     zm.ZipCode  = <cfqueryparam value="#arguments.zipCode#" cfsqltype="cf_sql_varchar" />
                    AND p2.CarrierBillCode = p.CarrierBillCode
            )
        </cfif>
      </cfif>
      
      ORDER BY p.planPrice ASC, CAST(p.minutes_anytime AS integer) ASC, CAST(p.DataLimitGB AS DECIMAL(10,5)) ASC
    </cfquery>

    <cfreturn planData />
  </cffunction>

  <cffunction name="getSharedPlans" access="public" output="false" returntype="any" hint="Return a query object of plans.">
    <cfargument name="carrierId" required="true" />
    <cfargument name="zipCode" required="true" />
    <cfargument name="isShared" type="string" default="true" />
    <cfargument name="idList" type="string" default="" />

    <cfreturn getPlans(argumentCollection=arguments) />
  </cffunction>

</cfcomponent>
