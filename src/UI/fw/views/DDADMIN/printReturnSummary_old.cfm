<cfoutput>
<cfset assetPaths = application.wirebox.getInstance("assetPaths")/>
<cfset channelConfig = application.wirebox.getInstance("ChannelConfig")/>
<cfset googleAnalyticsTracker = application.wirebox.getInstance("GoogleAnalyticsTracker")/>
<cfset mercentAnalyticsTracker = application.wirebox.getInstance("MercentAnalyticsTracker")/>
<html>
	<head>
		<script type="text/javascript" src="#assetPaths.common#scripts/bootstrap/3.2.0-custom/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="#assetPaths.common#scripts/bootstrap/3.2.0-custom/css/bootstrap.min.css" />
		<script type="text/javascript" src="#assetPaths.common#scripts/prototype-bootstrap-conflict.js?v=1.0.0"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-1.7.2.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.validate.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/additional-methods.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.datatables.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.autosize.min.js"></script>
		<script language="javascript" type="text/javascript" src="#assetPaths.common#scripts/libs/jquery.confirm.min.js"></script>
		<script type="text/javascript" src="#assetPaths.common#scripts/libs/jquery-ui-1.11.4/jquery-ui.min.js"></script>

		<!---<link href="#assetPaths.common#styles/jquery.dataTables.css" rel="stylesheet" media="screen">--->
		<link rel="stylesheet" href="#assetPaths.common#theme/jquery-ui-1.11.4.redmond/jquery-ui.min.css" />
	<style>
		@media print { 
		## header { 
		display: none; 
		} 
		##footer 
		{ 
		display: none; 
		} 
		}
		.pane {
		    height: 90%;
		    float: left;
		    width: 200px;
		    margin-left: 10px;
		}
		.floatRight {
		    vertical-align: text-top;
		    width: auto;
		    float: right;
		    display: inline-block;
		}
		.bootstrap .progressBtn {
		    background: linear-gradient(to bottom, ##8bcd68 0%, ##65b43c 5%, ##518f30 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 180px;
				}
				.bootstrap .progressBtnLarge {
		   			background: linear-gradient(to bottom, ##8bcd68 0%, ##65b43c 5%, ##518f30 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 250px;
				}
				.bootstrap .waitForActionBtn {
		   			background: linear-gradient(to bottom, ##E3E3ED 0%, ##DCDCDA 5%, ##C7C7C1 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 180px;
				}
				.bootstrap .waitForActionBtn span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap .waitForActionBtnLarge {
		   			background: linear-gradient(to bottom, ##E3E3ED 0%, ##DCDCDA 5%, ##C7C7C1 100%) repeat scroll 0 0 rgba(0, 0, 0, 0);
		   			border-radius: 2px;
					display: inline-block;
		    		height: 42px;
		    		line-height: 42px;
		    		margin: 0 auto;
		    		text-align: center;
		    		text-decoration: none;
		    		width: 250px;
				}
				.bootstrap .waitForActionBtnLarge span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap .progressBtn span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap .progressBtnLarge span {
					font-size: 18px;
		  			color: ##ffffff;
		  			text-shadow: ##444444;
		  			font-weight: bold;
				}
				.bootstrap div.carrier-box {
			   		border: 1px solid ##808080;
					width: 200px;
					height: 300px;
			 	  	padding-top: 10px;
			 	  	padding-bottom: 10px;
			 	  	margin-bottom: 15px;
			  	  /* CSS3 For Various Browsers*/
			 	   	border-radius: 5px;
					position: relative;
					left:10px;
					top:10px;
				}
				.bootstrap img.carrier {
		   		 	margin: 0;
		    		position: absolute;
		    		top: 50%;
		    		left: 50%;
		    		margin-right: -50%;
		    		transform: translate(-50%, -50%) ;
				}
				.bootstrap h3.carrier {
		   		 	margin-top:150px;
				}
				.bootstrap iframe.carrier {
		   		 	margin-top:20px;
					margin-bottom:20px;
					height:100%;
					width:100%;
				}
				.bootstrap .modal-custom{
					width:700px
				}
	</style>
	</head>
	<body>
		<div class="bootstrap returnSummary">
			<div class="row">
				<div class="col-md-12"><strong>Return Order Summary Information</strong></div>
			</div>				
			<div class="row">
				<div class="col-md-12">&nbsp;</div>
			</div>				
			<div class="row">
				<div class="col-md-3 formLabel">Order ID:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.Order.getOrderId()#</div>
			</div>	
			<div class="row">
				<div class="col-md-3 formLabel">Date/Time:</div>
				<div class="col-md-9">#dateformat(session.ddadmin.returnRequest.returnDt,"mm/dd/yyyy")# #timeformat(session.ddadmin.returnRequest.returnDt,"hh:mm tt")#</div>
			</div>				
			<div class="row">
				<div class="col-md-3 formLabel">GERS Salesorder Number:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.Order.getGersRefNum()#</div>
			</div>	
						
			<div class="row">
				<div class="col-md-3 formLabel">Customer:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.Order.getBillAddress().getFirstName()# #session.ddadmin.returnRequest.Order.getBillAddress().getLastName()#</div>
			</div>				
			<div class="row">
				<div class="col-md-3 formLabel">Tracking Number:</div>
				<div class="col-md-9">#session.ddadmin.returnRequest.TrackingNumber#</div>
			</div>
			<cfset accessoryHeader = false />		
			<cfloop array="#session.ddadmin.returnRequest.ItemsReturned#" index="r">
			<div class="row">
				<cfif r.groupName is not "">
					<div class="col-md-12 GroupHeader">#r.groupName#:</div>
				<cfelseif accessoryHeader is false>
					<div class="col-md-12 GroupHeader">Accessories:</div>
					<cfset accessoryHeader = true />
				</cfif>
			</div>		
<!---			<div class="row">
				<div class="col-md-3 formLabel">Reason:</div><div class="col-md-9">#r.ReasonText#</div>
			</div>		
			<div class="row">
				<div class="col-md-3 formLabel">Comment:</div><div class="col-md-9">#r.Comment#</div>
			</div>
--->			
				<cfloop array="#session.ddadmin.returnRequest.Order.getOrderDetail()#" index="od">
					<cfif od.GetOrderDetailType() is "d" and od.getGroupName() is r.groupName >
						<cfset wl = getWirelessLine(od.getOrderdetailId(), session.ddadmin.returnRequest.Order.getWirelesslines()) />
                        <!---<div class="row"><div class="col-lg-3 orderDetailLabel">Device:</div></div>--->
                        <div class="row productname"><div class="col-lg-3 orderDetailLabel">Device Name:</div><div class="col-lg-7">#od.getProductTitle()#</div></div>
                        <div class="row"><div class="col-lg-3 orderDetailLabel">GERS SKU:</div><div class="col-lg-7">#od.getGersSku()#</div></div>
                        <div class="row"><div class="col-lg-3 orderDetailLabel">IMEI/ESN:</div><div class="col-lg-7">#wl.getIMEI()#</div></div>
                        <div class="row"><div class="col-lg-3 orderDetailLabel">SIM:</div><div class="col-lg-7">#wl.getSIM()#</div></div>
                        <cfif wl.getCurrentMDN() is not "" >
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Current MDN:</div><div class="col-lg-7">#wl.getCurrentMDN()#</div></div>
						</cfif>
                        <cfif wl.getNewMDN() is not "">
                            <div class="row"><div class="col-lg-3 orderDetailLabel">New MDN:</div><div class="col-lg-7">#wl.getNewMDN()#</div></div>
						</cfif>
                        <!---<div class="longView">--->
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Retail Price:</div><div class="col-lg-1"><span style="float:right;">#decimalformat(od.getRetailPrice())#</span></div></div>
							<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Online Discount:</div><div class="col-lg-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Net Price:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Taxes:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
							<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Total:</div><div class="col-lg-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
                        <!---</div>--->
						<div class="row">
							<div class="col-md-3 orderDetailLabel">Reason:</div>
							<div class="col-md-9">#r.ReasonText#</div>
						</div>		
						<div class="row">
							<div class="col-md-3 orderDetailLabel">Comment:</div>
							<div class="col-md-9">#r.Comment#</div>
						</div>						
					</cfif>
				</cfloop>
				
				<cfif accessoryHeader is true>
					<cfloop array="#session.ddadmin.returnRequest.ItemsReturned#" index="i">
						<cfif i.orderdetailid is not "" >
							<cfset od = createObject( "component", "cfc.model.OrderDetail" ).init() />
							<cfset od.load(i.orderDetailId) />
							<div class="row productname">
								<div class="col-lg-3 orderDetailLabel">Accessory:</div>
								<div class="col-lg-9">#od.getProductTitle()#</div>
							</div>
							<div class="row">
								<div class="col-lg-3 orderDetailLabel">GERS SKU:</div>
								<div class="col-lg-9">#od.getGersSku()#</div>
							</div>
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Retail Price:</div><div class="col-lg-1"><span style="float:right;">#decimalformat(od.getRetailPrice())#</span></div></div>
							<cfset OnlineDiscount = od.getRetailPrice() - od.getNetPrice()  />
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Online Discount:</div><div class="col-lg-1"><span style="float:right">#decimalformat(OnlineDiscount)#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Net Price:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getNetPrice())#</span></div></div>
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Taxes:</div><div class="col-lg-1"><span style="float:right">#decimalformat(od.getTaxes())#</span></div></div>
							<cfset TotalPrice = od.getNetPrice() + od.getTaxes() />
                            <div class="row"><div class="col-lg-3 orderDetailLabel">Total:</div><div class="col-lg-1 orderDetailLabel"><span style="float:right">#decimalformat(TotalPrice)#</span></div></div>
							<div class="row">
								<div class="col-md-3 orderDetailLabel">Reason:</div>
								<div class="col-md-9">#r.ReasonText#</div>
							</div>		
							<div class="row">
								<div class="col-md-3 orderDetailLabel">Comment:</div>
								<div class="col-md-9">#r.Comment#</div>
							</div>						
							
						</cfif>
					</cfloop>
				</cfif>			
			</cfloop>
		</div>
	</body>
	</html>
</cfoutput>		
	<cffunction name="getWirelessLine" returnType="cfc.model.wirelessLine">
		<cfargument name="orderDetailId" type="numeric" required="true" />
		<cfargument name="wirelesslines" type="cfc.model.wirelessline[]" required="true" />
		
		<cfloop array="#arguments.wirelesslines#" index="wl">
			<cfif wl.getOrderDetailId() is arguments.orderdetailid >
				<cfreturn wl />
			</cfif>		
		</cfloop>
		<cfreturn "" />
	</cffunction>	
