<!--- TRV: determine which gallery file to use based on the page requested by the end-user --->
<cfset assetPaths = application.wirebox.getInstance("AssetPaths") />
<cfset targetBannerFile = "banners_home.cfm" />

<cfoutput>
	<link rel="stylesheet" media="screen" type="text/css" href="#assetPaths.common#styles/gallery.css" />
	<script language="javascript" src="#assetPaths.common#scripts/gallery.js"></script>
	
	<!--- Outage Notice --->
	<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?t=58EA2102-9757-43F0-962A-A7636C00523F'>
    <cfoutput>#cfhttp.filecontent#</cfoutput>

    <!--- Certainly not tabular data, but a table is the most solid way to get this layout done --->
	<div class="shimRow">
		<!--- Hot Phone Feature (top right)--->
		<div class="carrierModule">
			<div class="greyModule">
				<!--- Phones by Carrier module --->
				<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=5DDE8FB8-0616-4C48-B7B0-A4B48903B1B2' />
	  			<cfoutput>#cfhttp.filecontent#</cfoutput>				
			</div>
		</div>
		<!--- jQuery Banner w: 729px --->
		<div class="rotatingBanner">
			<div class="greyModule">
				<div class="moduleContent">
					<div class="contentBanner">
						<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=5E0999D0-054B-4300-8C00-6D71EB2DAF9C' />
			  			<cfoutput>#cfhttp.filecontent#</cfoutput>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="shimRow">
		<div class="leftQuad">
			<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=F6293FBB-1F2D-4705-8D29-6D3C95A84565' />
  			<cfoutput>#cfhttp.filecontent#</cfoutput>
		</div>
		<div class="rightQuad">
			<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=76219678-09ED-4657-B38A-2CBB07DACD5B' />
  			<cfoutput>#cfhttp.filecontent#</cfoutput>
		</div>
	</div>
	
	<div class="shimRow">
		<div class="mainContentLegal">
			<p>
				The Exchange Mobile Center and Wireless Advocates are authorized retailers of wireless devices and wireless plans from 
				AT&T&reg;, Sprint, T-Mobile&reg;, Verizon Wireless, and Boost Mobile. We carry a broad range of products from Apple, 
				Motorola, BlackBerry&reg;, LG, Sony Ericsson, Samsung, HTC, Pantech and Nokia. Device and screen images simulated. 
				All marks, names, and logos contained herein are the property of their respective owners.
			</p>
			<p>
				&copy;2013 Samsung Telecommunications America, LLC. Samsung and Galaxy S are both registered trademarks of Samsung 
				Electronics Co., Ltd
			</p>
			<p>
				Apple, the Apple logo, and iPhone are trademarks of Apple Inc., registered in the U.S. and other countries.
			</p>
		</div>
	</div>

</cfoutput>