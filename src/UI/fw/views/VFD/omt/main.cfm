<style>
 .bootstrap {
		font-size:137.5%;
	}
	
	.bootstrap .btn-bar{
		background-color: #cccccc;
		padding:20px;
	}
	
	.bootstrap #results{
		display:none;
	}
	
	#loading{
		display:none;
	}
</style>


<script type="text/javascript">
var $j = jQuery.noConflict();
	
$j(document).ready(function($j) {

	$j('#btn-search').on('click', function (e) {
			
			$j("#loading").show();
			
			
			setTimeout(
			  function() 
			  {
			   $j("#loading").hide();
			   $j("#results").show();
			   
			  }, 3000);
			
		 });
		 
		 
		$j('#btn-clearresults').on('click', function (e) {
			
			$j("#results").hide();
			
			
			
		 });	 


$j
	

	
	
		 	 
});
</script>
<div class="bootstrap">
<div class="container" style="width:980px;">
	<h1>Order Search</h1>
		<form class="form-horizontal">
		<div style="width:600px">
	  
		  
		  <div class="form-group">
		    <label for="search-firstname" class="col-sm-6 control-label">Name</label>
		    <div class="col-sm-3">
		      <input type="text" class="form-control" name="search-firstname" id="search-firstname" placeholder="First Name">
		    </div>
		    <div class="col-sm-3">
		      <input type="text" class="form-control" name="search-lastname" id="search-lastname" placeholder="Last Name">
		     </div>
		  </div>
		  
		  
		  <div class="form-group">
		    <label for="" class="col-sm-6 control-label">IMEI</label>
		    <div class="col-sm-6">
		      <input type="text" class="form-control" id="search-IMEI" name="search-IMEI" placeholder="IMEI">
		    </div>
		  </div>

		  <div class="form-group">
		    <label for="" class="col-sm-6 control-label">Primary Phone Number</label>
		    <div class="col-sm-6">
		      <input type="tel" class="form-control" id="search-phonenum" name="search-phonenum" placeholder="(XXX) XXX-XXXX">
		    </div>
		  </div>
		  
		  <div class="form-group">
		    <label for="" class="col-sm-6 control-label">Order Number</label>
		    <div class="col-sm-6">
		      <input type="text" class="form-control" id="search-ordernum" name="search-ordernum" placeholder="Order Number">
		    </div>
		  </div>
		  
		  
		  <div class="form-group">
		    <label for="" class="col-sm-6 control-label">Store Code</label>
		    <div class="col-sm-6">
		      <input type="text" class="form-control" id="search-storecode" name="search-storecode" placeholder="Store Code">
		    </div>
		  </div>
		  		
	</div>
		 <div class="form-group btn-bar ">
		    <div class="col-sm-12 text-center">
		      <button type="button" class="btn btn-default" id="btn-search">Search</button>
		      <button type="button" class="btn btn-default" id="btn-clear">Clear</button>
		      <button type="button" class="btn btn-default" id="btn-clearresults">Clear Results</button>
		    </div>
		  </div>
	</form>
	
	<div id="loading" class="text-center">
		<img src="/assets/common/images/ui/ajax-loader.gif">
	</div>
<cfoutput>		
	<div id="results">
		<table class="table table-hover table-striped">
			<thead>
				 <tr>
					  <th>Name</th>
					  <th>Order ##</th>
					  <th>Carrier</th>
					  <th>DATE</th>
					  <th>Address</th>
					  <th>Phone ##</th>	  
				 </tr>
			 </thead>
			 <tbody>
				<tr>
					<td>John Smith</td>
					<td><a href="#event.buildLink('omtVFD.order')#/WC9823047">WC9823047<a></td>
					<td>VZW</td>
					<td>3/25/2015</td>
					<td>123 Your Street, 37174</td>
					<td>(615) 555-5555</td>
				</tr>
				<tr>
					<td>John Smith</td>
					<td><a href="#event.buildLink('omtVFD.order')#/WC9823047">WC9823047<a></td>
					<td>VZW</td>
					<td>3/25/2015</td>
					<td>123 Your Street, 37174</td>
					<td>(615) 555-5555</td>
				</tr>
				<tr>
					<td>John Smith</td>
					<td><a href="#event.buildLink('omtVFD.order')#/WC9823047">WC9823047<a></td>
					<td>VZW</td>
					<td>3/25/2015</td>
					<td>123 Your Street, 37174</td>
					<td>(615) 555-5555</td>
				</tr>
				<tr>
					<td>John Smith</td>
					<td><a href="#event.buildLink('omtVFD.order')#/WC9823047">WC9823047<a></td>
					<td>VZW</td>
					<td>3/25/2015</td>
					<td>123 Your Street, 37174</td>
					<td>(615) 555-5555</td>
				</tr>
				<tr>
					<td>John Smith</td>
					<td><a href="#event.buildLink('omtVFD.order')#/WC9823047">WC9823047<a></td>
					<td>VZW</td>
					<td>3/25/2015</td>
					<td>123 Your Street, 37174</td>
					<td>(615) 555-5555</td>
				</tr>
				<tr>
					<td>John Smith</td>
					<td><a href="#event.buildLink('omtVFD.order')#/WC9823047">WC9823047<a></td>
					<td>VZW</td>
					<td>3/25/2015</td>
					<td>123 Your Street, 37174</td>
					<td>(615) 555-5555</td>
				</tr>																				
			</tbody>				
		</table>	
	</div>
</cfoutput>	
</div>
</div>


