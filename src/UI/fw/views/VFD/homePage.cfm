<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<style type="text/css">
	div.carrier-box {
	    border: 1px solid #808080;
		width: 200px;
		height: 300px;
	    padding-top: 10px;
	    padding-bottom: 10px;
	    margin-bottom: 15px;
	    /* CSS3 For Various Browsers*/
	    border-radius: 5px;
		position: relative;
	}
	div.carrier-box img {
    margin: 0;
    position: absolute;
    top: 50%;
    left: 50%;
    margin-right: -50%;
    transform: translate(-50%, -50%) ;
	}
	.carrier-box span {
   position: absolute;
   bottom: 20%;
   display: block;
   text-align: center;
   width: 100%;
   }
</style>
<script>jQuery.noConflict();</script>
<cfoutput>
	<script type="text/javascript">
		function showHide(divId){
    		var theDiv = document.getElementById(divId);
    		if(theDiv.style.display=="none"){
      			theDiv.style.display="";
   			}else{
        		theDiv.style.display="none";
    		}   
		}
	</script>

	<link rel="stylesheet" media="screen" type="text/css" href="/Marketing/landingPage/css/landingPage.css?v=1.0.2" />

	<div align=center>
		<h1>#channelConfig.getScenarioDescription()# Homepage</h1>
		<hr size="4" Color="##3c5cb2" width="1010px">
					<!---<p><a href="#event.buildLink('DDadmin.start')#">Direct Delivery Returns</a> | </p>--->
	</div>
	<cfif request.config.debugInventoryData>
		<div align=right>
			<!---<input type="button" onclick="showHide('debugDiv')" value="Debug Info"> --->
		</div>
		<div id="debugDiv" style="display: none">
			<div align=right>
				<h2>VFD State:</h2><input type="radio" name="vfdOn" value="vfdOn" disabled=true <cfif (structKeyExists(session, 'VFD')) and (Session.VFD.Access eq true)>checked</cfif> />On  
				<input type="radio" name="vfdOff" value="vfdOff" disabled=true <cfif (not structKeyExists(session, 'VFD')) or (Session.VFD.Access neq true)>checked</cfif> />Off
			</div>
			<!---<h2>Sending</h2>
			MKey: #rc.genKey#<br/>
			<br/>
			IV:	#rc.useasIV#<br/>
			<br/>
			To be encrypted: #rc.secret#<br/>
			<br/>
			Encrypted value using MKey: #rc.encoded# <br/>
			<br/>
			<h2>Receiving</h2>
			Received value: #rc.encoded# <br/>
			<br/>
			Decrypted Data: #rc.decoded# <br/>
			<br/>
			Session.VFD.EmployeeNumber = #Session.VFD.employeeNumber# <br/>
			Session.VFD.kioskNumber = #Session.VFD.kioskNumber# <br/>
			Session.VFD.Expires = #Session.VFD.Expires# <br/>
			<br/>--->
	</div>
	</cfif>
	<table cellpadding="0" cellspacing="0" border="0">
		<tbody>
			<tr>
				<td>
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,1,32/" alt="Shop for AT&T Phones" title="Shop for AT&T Phones">
						<div class="carrier-box">
							<img src="#assetPaths.common#images/content/rebatecenter/att.jpg" width="117" height="51" style="border:0">
							<span><strong>AT&T Devices</strong></span>
						</div>
					</a>
				</td>
				<td>
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,3,32/" alt="Shop for Verizon Wireless Phones" title="Shop for Verizon Wireless Phones">
						<div class="carrier-box">
							<img src="#assetPaths.common#images/carrierLogos/verizon_175.gif" style="border:0" />
							<span><strong>Verizon Devices</strong></span>
						</div>
					</a>
				</td>
				<td>
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,230,32/" alt="Shop for Sprint Phones" title="Shop for Sprint Phones">
						<div class="carrier-box">
							<img src="#assetPaths.common#images/content/rebatecenter/sprint.jpg" width="117" height="51" style="border:0">
							<span><strong>Sprint Devices</strong></span>
						</div>
					</a>
				</td>
				<td>
					<a href="/index.cfm/go/shop/do/browsePhones/phoneFilter.submit/1/filter.filterOptions/0,2,32/" alt="Shop for T-Mobile Phones" title="Shop for T-Mobile Phones">
						<div class="carrier-box">
							<img src="#assetPaths.common#images/content/rebatecenter/TM_authdealerlogo.jpg" width="140" height="25" style="border:0">
							<span><strong>T-Mobile Devices</strong></span>
						</div>
					</a>
				</td>
				<td>
					<a href="/index.cfm/go/shop/do/browseAccessories/accessoryFilter.submit/1/filter.filterOptions/0/" alt="Shop for Accessories" title="Shop for Accessories">
						<div class="carrier-box">
							<span><strong>Accessories</strong></span>
						</div>
					</a>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="left" valign="top">
				<div class="bootstrap">	
					<div class="row">	
						<div class="col-md-12" style="padding:10px;text-align:center;" >	
							<form id="DDReturns" action="#event.buildLink('ddadmin.start')#" method="post" >
						          <button class="btn btn-primary" style="width: 400px;" type="submit">Process Direct Delivery Returns</button>
							</form>
							<form id="DDReprint" action="#event.buildLink('OmtVFD.searchOrders')#" method="post" >
						          <button class="btn btn-primary" style="width: 300px;" type="submit">View Past Orders</button>
							</form>
						</div>
					</div>		
				</div>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="left" valign="top">
					<h2>Direct Delivery News:</h2>
					<hr size="2" Color="##0a94d6">
					<div style="overflow: scroll; height: 200px;">
						<!---<p>#channelConfig.getScenarioDescription()# announcements will be available here.</p>--->
						<!---<cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=e6d68f7a-1b6b-40fe-b287-d1af044b3dbb'>--->
						<cfif ChannelConfig.getEnvironment() neq 'production'>					
							<cfhttp url='http://10.7.0.80/Content-asp/ShowContent.aspx?t=2ebec2f9-b1fa-4e06-a138-112256acaa05'>
						<cfelse>
							<cfhttp url='http://10.7.0.144/Content-asp/ShowContent.aspx?t=2ebec2f9-b1fa-4e06-a138-112256acaa05'>
						</cfif>
						<cfoutput>#cfhttp.filecontent#</cfoutput>
					</div>
				</td>
			</tr>
		</tbody>
	</table>

</cfoutput>