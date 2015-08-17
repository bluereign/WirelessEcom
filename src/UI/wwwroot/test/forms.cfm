<html>
<head>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jquery-ui.min.js"></script>
<script src="http://malsup.github.io/jquery.form.js"></script>
<script src="forms.js"></script>
	
</head>

<body>
<div id="output1"></div>

FORM1:<br/>
<form class="testform" id="form1" name="form1" action="form1.cfm">
	<input type="text" size="50" maxlength="50" />
	<input type="hidden" name="action" value="updatePhoneDetails" />
	<input type="submit">
	<!---<a href="javascript: void();" onclick="postForm(this);" class="button" title="Save changes made to this phone"><span>Save</span></a> --->
</form>

FORM2:<br/>
<form class="testform" id="form2" name="form2" action="form2.cfm">
	<input type="text" size="50" maxlength="50" />
	<input type="submit">
</form>

FORM3:<br/>
<form class="testform" id="form3" name="form3" action="form3.cfm">
	<input type="text" size="50" maxlength="50" />
	<input type="submit">
</form>

</body>	
	
</html>