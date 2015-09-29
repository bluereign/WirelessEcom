<cfparam name="prc.includeTallyBox" default="true" />
<cfparam name="prc.includeTooltip" default="false" />
<cfparam name="rc.type" default="upgrade" /> <!--- upgrade, addaline, new --->
<cfparam name="rc.pid" default="00000" />
<cfparam name="prc.showNav" default="true" />

<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker") />
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker") />

<cfparam name="request.title" default="Costco Wireless - Big Savings on Cell Phones - Offering Plans from Verizon Wireless, AT&T, T-Mobile, and Sprint." type="string" />
<cfparam name="request.MetaDescription" default="Costco Wireless offers big savings on phones from Verizon, AT&amp;T, T-Mobile, and Sprint. In additional to great prices, Costco Wireless offers Free New Activation, Free shipping, and Free Accessories with the phone purchase." type="string" />
<cfparam name="request.MetaKeywords" default="mobile phone,wireless phone,cellular phones,cell phone,cell phone plans,cellular phone service,service plan,cellular phone plans,prepaid plans,wireless phone service,cell phone plans,cell phone accessories,wireless phones,mobile phones,purchase cell phone,buy cell phone,research cell phones,compare cell phone prices,compare cell phones, cell phone comparison,cell service comparison,best cell phone deal,free cell phones,free cellular phones,buy,sold,online,best price,great deals,discount,discounts,specials" type="string" />

<cfoutput>
#html.doctype()#
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
  <title>#request.title#</title>
  <meta name="Description" content="#request.MetaDescription#" />
  <meta name="Keywords" content="#request.MetaKeywords#" />
  <meta name="Title" content="#request.title#" />
  <meta name="y_key" content="3541dfb9b35b7d6c" />
  <link rel="sitemap" href="http://#cgi.server_name#/sitemap.xml" type="application/xml" />
  <meta name="robots" content="all" />
  <cfif channelConfig.getTrackMercentAnalytics()>
    #mercentAnalyticsTracker.tagPage()#
  </cfif> 
  #googleAnalyticsTracker.tagPage()#
  <link rel="stylesheet" href="#assetPaths.channel#styles/devicebuilder.css" />
  <!--- TODO: Add following to devicebuilder.css after final HTML prototype build and then remove it from this file --->
  <style>
  body.modal-open .nonmodal-container{
      -webkit-filter: blur(5px);
      -moz-filter: blur(5px);
      -o-filter: blur(5px);
      -ms-filter: blur(5px);
      filter: blur(5px);
      opacity:0.7 !important;
  }
  </style>
</head>

<body id="#event.getCurrentAction()#">
  #renderView('devicebuilder/pageheader')#
<div class="container nonmodal-container">
  <cfif prc.showNav>
    #renderView('devicebuilder/pagenav')#  
  <cfelse>
    <br /><br /><br /><br />
  </cfif>
  <div class="row main<cfif !prc.includeTallyBox> cart</cfif>">
    #renderView()#
    <cfif prc.includeTallyBox>
      #renderView('devicebuilder/tallybox')#
    </cfif>
  </div>
</div>
#renderView('devicebuilder/pagefooter')#

<script type="text/javascript" src="#assetPaths.common#scripts/devicebuilder.min.js"></script>

<cfif prc.includeTooltip>
  <!--- Tooltip bootstrap js was ommited from devicebuilder.min.js.  Override required js: --->
  <script type="text/javascript" src="#assetPaths.common#scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.min.js"></script>
  <script>
  $(function(){
      $('[data-toggle="tooltip"]').tooltip(); 
  });
  </script>
</cfif>

<cfif listFindNoCase("devicebuilder.carrierlogin", event.getCurrentEvent())>
  #renderView('devicebuilder/carrierloginValidate')#
</cfif>

<!--- zipModal, planModal --->
<cfif listFindNoCase("devicebuilder.plans", event.getCurrentEvent())>
  #renderView('devicebuilder/zipmodal')#
  <cfif rc.type is 'new' and !application.model.cartHelper.zipCodeEntered()>
    <script>
      $('##zipModal').modal('show');
    </script>
  </cfif>
</cfif>
<!--- <end zipModal, planModal --->


<!--- <protectionModal --->
<cfif listFindNoCase("devicebuilder.protection", event.getCurrentEvent())>
  <div class="modal fade" id="protectionModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="true">
    <div class="modal-dialog modal-lg"> 
      <div class="modal-content">
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div>
  <div class="modal fade" id="featureModal" tabindex="-2" role="dialog" aria-hidden="true" data-backdrop="static" data-keyboard="true">
    <div class="modal-dialog modal-lg"> 
      <div class="modal-content">


        <!--- <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4 class="modal-title">Feature Modal</h4>
        </div>
        <div class="modal-body">
          <div class="plans">
            <div class="info">
              <h3 style="height:40px"><span>Hey</span></h3>
              <p>Yo</p>
            </div>
          </div>
        </div>
        
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <a href="##" type="button" class="btn btn-primary" name="btnAddFeature" id="btnAddWarranty" value="">Add to Cart</a>
        </div> --->



      </div>
    </div>
  </div>
</cfif>
<!--- <end protectionModal --->


<!--- clear data from Bootstrap 3 modals to load dynamic data --->
<script>
  $('body').on('hidden.bs.modal', '.modal', function () {
    $(this).removeData('bs.modal');
  });
</script>
<!--- <end clear bootstrap data --->

</body>
</html>
</cfoutput>
