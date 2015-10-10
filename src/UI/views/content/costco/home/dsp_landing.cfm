<!--- TRV: determine which gallery file to use based on the page requested by the end-user --->
<cfset assetPaths = application.wirebox.getInstance("assetPaths") />

<cfset targetBannerFile = "">
<cfif listFindNoCase( "shop,content", request.p.go ) and request.p.do eq "home">
	<cfset targetBannerFile = "banners_home.cfm">
<cfelseif listFindNoCase( "shop,content", request.p.go ) and request.p.do eq "phonesHome">
	<cfset targetBannerFile = "banners_phones.cfm">
<cfelseif listFindNoCase( "shop,content", request.p.go ) and request.p.do eq "plansHome">
	<cfset targetBannerFile = "banners_plans.cfm">
<cfelseif listFindNoCase( "shop,content", request.p.go ) and request.p.do eq "accessoriesHome">
	<cfset targetBannerFile = "banners_accessories.cfm">
<cfelseif listFindNoCase( "shop,content", request.p.go ) and request.p.do eq "dataCardsHome">
	<cfset targetBannerFile = "banners_datacards.cfm">
</cfif>

<cfoutput>
	<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/gallery.css" />
	<script language="javascript" src="#assetPaths.common#scripts/gallery.js"></script>

	<link rel="stylesheet" media="screen" type="text/css" href="/Marketing/landingPage/css/landingPage.css?v=1.0.2" />

	<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?t=86f99cda-5eb8-4fcb-9442-0f5c31a59d0e'>
    <cfoutput>
      #cfhttp.filecontent#
    </cfoutput>

    <!--- Certainly not tabular data, but a table is the most solid way to get this layout done --->
	<table cellpadding="0" cellspacing="0" border="0">
		<tbody>
			<tr>
				<td colspan="3" align="left" valign="top">
					<div id="landingPageCarrierBanner"> <!--- w: 729px, h: 80px --->
						<cfif application.model.Carrier.isEnabled(109)>
                        	<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/" alt="Shop for AT&T Phones" title="Shop for AT&T Phones"><div id="landingPage_ATT"></div></a>
						</cfif>
                    	<cfif application.model.Carrier.isEnabled(128)>
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,32/" alt="Shop for T-Mobile Phones" title="Shop for T-Mobile Phones"><div id="landingPage_TMobile"></div></a>
						</cfif>
                        <cfif application.model.Carrier.isEnabled(42)>
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/" alt="Shop for Verizon Wireless Phones" title="Shop for Verizon Wireless Phones"><div id="landingPage_Verizon"></div></a>
						</cfif>
						<cfif application.model.Carrier.isEnabled(299)>
							<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,32/" alt="Shop for Sprint Phones" title="Shop for Sprint Phones"><div id="landingPage_Sprint"></div></a>
						</cfif>
					</div>

					<!--- jQuery Banner --->
					<cfinclude template="/marketing/landingpage/banners/#targetBannerFile#" />
				</td>
				<!--- Hot Phone Feature (top right)--->
				<td valign="top" align="center">
					<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=34693282-6fc9-4d9b-844b-69669abf3da1'>
					<cfoutput>#cfhttp.filecontent#</cfoutput>
				</td>
			</tr>
            <tr>
            	<td colspan="4">
                	<div style="padding-top:12px;">
						<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=e6d68f7a-1b6b-40fe-b287-d1af044b3dbb'>
						<cfoutput>#cfhttp.filecontent#</cfoutput>
					</div>
				</td>
			</tr>
          	<tr>
            	<td colspan="4">
                	<div style="padding-top:10px;">
						<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=da9e9501-65a9-4ab1-977c-fbd0c116235e'>
						<cfoutput>#cfhttp.filecontent#</cfoutput>
                    </div>
                </td>
            </tr>
         </tr>
	  </tbody>
	</table>
	<div>
		<p>Costco and Wireless Advocates are authorized retailers of wireless devices and wireless plans from AT&T&reg;, Sprint, T-Mobile&reg;, and Verizon Wireless. We carry a broad range of products from Motorola, BlackBerry&reg;, LG, Sony Ericsson, Samsung, HTC, Pantech and Nokia. BlackBerry&reg;, RIM&reg;, Research In Motion&reg;, SureType&reg; and related trademarks, names and logos are the property of Research In Motion Limited and are registered and/or used in EMEA and countries around the world. Used under license from Research in Motion Limited.</p>
		<p>Apple, the Apple logo, iPad, iPhone and Retina are trademarks of Apple Inc. registered in the US and other countries.  iPad Air and iPad mini are trademarks of Apple Inc.</p>
	</div>
	<div id="server" style="visibility:hidden; display:none;"><cfoutput>#ListLast(application.model.Util.GetHostAddress(CGI.SERVER_NAME), '.')#</cfoutput></div>			
</cfoutput>
