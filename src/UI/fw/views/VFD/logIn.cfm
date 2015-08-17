<cfoutput>
	<script type="text/javascript">
		
		function submitForm(which)	{
			var loginVFD = document.forms[which];

			if(validateLogin())	{
				loginVFD.submit();
			}
		}
					
		function validateLogin()	{
			var objEmp = document.getElementById('employeeNumber');
			var objKiosk = document.getElementById('kioskNumber');

			if(objEmp.value == '')	{
				alert('Please enter your Employee ID.');
				objEmp.focus();

				return false;
			} else if(objKiosk.value == '')	{
				alert('Please enter your Kiosk ID.');
				objKiosk.focus();

				return false;
			} else {
				return true;
			}
		}			
				
				
				
	</script>
	
	<form id="loginVFD" name="loginVFD" role="form" action="#event.buildLink('mainVFD.loginVFD')#" class="form-horizontal" method="post">
		<h1>VFD Login</h1>
	
		<div id="loginDiv" name="loginDiv">
			<label class="loginText" for="employeeNumber">Employee ID:</label>
			<input name="employeeNumber" id="employeeNumber" type="text"><br/>
			<br />
			<label class="loginText" for="kioskNumber" type="text">Kiosk ID:</label>
			<input name="kioskNumber" id="kioskNumber"><br/>
			<br />
			<div id="buttonDiv" name="buttonDiv">
				<span id="submitButton" class="actionButton"><a onclick="submitForm('loginVFD')" >Log In</a></span>
				<span id="disableButton" class="actionButton"><a onclick="location.href='/MainVFD/disableVFD';return false;" >Disable VFD</a></span>
			</div>
		</div>		
	</form>

	
</cfoutput>