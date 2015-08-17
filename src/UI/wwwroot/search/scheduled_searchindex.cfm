<cfsetting requesttimeout="1200"/>
<cfparam name="URL.start" default="1"/>

<cfscript>
  // should we reset the index?
  if (isDefined("URL.resetIndex")) {
  REQUEST.solr.resetIndex();
  REQUEST.solr.commit();
  REQUEST.solr.optimize();
  }

  // phones
  qphones = application.model.Phone.getAll(bActiveOnly=true);

  // Mobile Hotspots and netbooks
  qdataCardsAndNetBooks = application.model.DataCardAndNetbook.getAll(bActiveOnly=true);

  // prepaid
  qprepaids = application.model.PrePaid.getAll(bActiveOnly=true);

  // accessories
  qaccessories = application.model.Accessory.getAll(bActiveOnly=true,bIncludeBundled=false);

  // rateplans
  qplans = application.model.Plan.getAll(bActiveOnly=true);

  // warranty
  qWarranty = application.model.Warranty.getAll(bActiveOnly=true);

  // tablet
  qTablets = application.model.Tablet.getAll(bActiveOnly=true);  

</cfscript>

<!--- loop over phones --->
<cfloop query="qphones">
  <cfoutput>Adding phone  #pageTitle# (id=#phoneID#,gs=#gerssku#)...</cfoutput>
  <cfxml variable="thisPhone">
    <cfoutput>
      <doc>
        <field name="itemType">Phone</field>
        <field name="productID">#xmlFormat(phoneID)#</field>
        <field name="productName">#xmlFormat(pageTitle)#</field>
        <field name="productBrand">#xmlFormat(manufacturerName)#</field>
        <field name="productDescription">#xmlFormat(metaKeywords)#</field>
      </doc>
    </cfoutput>
  </cfxml>

  <!--- add or update this phone --->
  <cfset REQUEST.solr.add(thisPhone) />
  <cfoutput>
    Done<br/>
  </cfoutput>
</cfloop>

<cfoutput>
  <hr/>
</cfoutput>

<!--- loop over Mobile Hotspots and netbooks --->
<cfloop query="qdataCardsAndNetbooks">
  <cfoutput>Adding datacard/netbook #pageTitle# (id=#productID#,gs=#gerssku#)...</cfoutput>
  <cfxml variable="thisData">
    <cfoutput>
      <doc>
        <field name="itemType">DataCardAndNetBook</field>
        <field name="productID">#xmlFormat(productID)#</field>
        <field name="productName">#xmlFormat(detailTitle)#</field>
        <field name="productBrand">#xmlFormat("#detailDescription##summaryDescription#")#</field>
        <field name="productDescription">#xmlFormat(metaKeywords)#</field>
      </doc>
    </cfoutput>
  </cfxml>

  <!--- add or update this datacard/netbook --->
  <cfset REQUEST.solr.add(thisData) />
  <cfoutput>
    Done<br/>
  </cfoutput>
</cfloop>

<cfoutput>
  <hr/>
</cfoutput>

<!--- loop over prepaids --->
<cfloop query="qprePaids">
  <cfoutput>Adding prepaid #pageTitle# (id=#productID#,gs=#gerssku#)...</cfoutput>
  <cfxml variable="thisData">
    <cfoutput>
      <doc>
        <field name="itemType">PrePaid</field>
        <field name="productID">#xmlFormat(productID)#</field>
        <field name="productName">#xmlFormat(detailTitle)#</field>
        <field name="productBrand">#xmlFormat("#detailDescription##summaryDescription#")#</field>
        <field name="productDescription">#xmlFormat(metaKeywords)#</field>
      </doc>
    </cfoutput>
  </cfxml>

  <!--- add or update this datacard/netbook --->
  <cfset REQUEST.solr.add(thisData) />
  <cfoutput>
    Done<br/>
  </cfoutput>
</cfloop>

<cfoutput>
  <hr/>
</cfoutput>

<!--- loop over accessories --->
<cfloop query="qaccessories">
  <!--- TRV: getAll() should be filtering free kits - but if they're not tagged for some reason, try and filter them here by their price --->
  <cfif qaccessories.price>
    <cfoutput>Adding accessory  #pageTitle# (id=#product_id#,gs=#gerssku#)...</cfoutput>
    <cfxml variable="thisAcc">
      <cfoutput>
        <doc>
          <field name="itemType">Accessory</field>
          <field name="productID">#xmlFormat(product_id)#</field>
          <field name="productName">#xmlFormat(detailTitle)#</field>
          <field name="productBrand">#xmlFormat("#detailDescription##summaryDescription#")#</field>
          <field name="productDescription">#xmlFormat(metaKeywords)#</field>
        </doc>
      </cfoutput>
    </cfxml>

    <!--- add or update this phone --->
    <cfset REQUEST.solr.add(thisAcc) />
    <cfoutput>
      Done<br/>
    </cfoutput>
  </cfif>
</cfloop>

<cfoutput>
  <hr/>
</cfoutput>

<!--- loop over plans --->
<cfloop query="qplans">
	<!--- get a plan id for this planStringId --->
	<cfset thisPlanId = planId>
    <cfoutput>Adding planId #planId# (#detailTitle#, #carrierName#)...</cfoutput>
    <cfxml variable="thisPlan">
      <cfoutput>
        <doc>
          <field name="itemType">Plan</field>
          <field name="productID">#xmlFormat(thisPlanId)#</field>
          <field name="productName">#xmlFormat(detailTitle)#</field>
          <field name="productBrand">#xmlFormat(carrierName)#</field>
          <!---  <field name="productDescription">#xmlFormat(metaKeywords)#</field> --->
          <field name="productDescription">#xmlFormat("#detailDescription##summaryDescription#")#</field>
        </doc>
      </cfoutput>
    </cfxml>

    <!--- add or update this plan --->
    <cfset REQUEST.solr.add(thisPlan) />
    <cfoutput>
      Done<br/>
    </cfoutput>
</cfloop>

<!--- loop over warranty --->
<cfloop query="qWarranty">
    <cfoutput>Adding WarrantyId #qWarranty.ProductId# (#qWarranty.SummaryTitle#)...</cfoutput>
    <cfxml variable="thisWarranty">
      <cfoutput>
        <doc>
          <field name="itemType">Warranty</field>
          <field name="productID">#xmlFormat(qWarranty.ProductId)#</field>
          <field name="productName">#xmlFormat(qWarranty.SummaryTitle)#</field>
          <field name="productBrand">#xmlFormat(qWarranty.MetaKeywords)#</field>
          <field name="productDescription">#xmlFormat("#qWarranty.ShortDescription##qWarranty.LongDescription#")#</field>
        </doc>
      </cfoutput>
    </cfxml>

    <!--- add or update this plan --->
    <cfset REQUEST.solr.add(thisWarranty) />
    <cfoutput>
      Done<br/>
    </cfoutput>
</cfloop>

<!--- loop over tablets --->
<cfloop query="qtablets">
  <cfoutput>Adding tablet #pageTitle# (#phoneID#,gs=#gerssku#)...</cfoutput>
  <cfxml variable="thisTablet">
    <cfoutput>
      <doc>
        <field name="itemType">Tablet</field>
        <field name="productID">#xmlFormat(phoneID)#</field>
        <field name="productName">#xmlFormat(pageTitle)#</field>
        <field name="productBrand">#xmlFormat(manufacturerName)#</field>
        <field name="productDescription">#xmlFormat(metaKeywords)#</field>
      </doc>
    </cfoutput>
  </cfxml>

  <!--- add or update this tablet --->
  <cfset REQUEST.solr.add(thisTablet) />
  <cfoutput>
    Done<br/>
  </cfoutput>
</cfloop>

<cfscript>
	// tell solr we're done making changes
	REQUEST.solr.commit();
	REQUEST.solr.optimize();
</cfscript>

<cfabort/>