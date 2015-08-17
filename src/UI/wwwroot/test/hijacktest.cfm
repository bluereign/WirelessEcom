<cfparam name="fname" default="Scott" />
<cfparam name="lname" default="Hamilton" />
<cfparam name="msg" default="" />
<cfparam name="action" default="" />
<cfif action is "postme">
	<cfset msg = "Thanks #fname# #lname#. Your data has been posted. Do you like to travel?" />
	<cflocation url="hijacktest.cfm?msg=#urlencodedFormat(msg)#&fname=#urlencodedformat(fname)#&lname=#urlencodedformat(lname)#" />
</cfif>	
<html>
<body>
<div>
<cfif msg is not "">
	<div style="color:green;"><cfoutput>#msg#</cfoutput></div>
</cfif>
<cfoutput>
<form action="hijacktest.cfm" method="post">
First Name: <input type="text" name="fname" size="25" value="#fname#" />
Last Name: <input type="text" name="lname" size="25"  value="#lname#"/>
<input type="hidden" name="action" value="postme" />
<input type="submit" value="submit" />	
</form>
</cfoutput>
</div>		
</body>	
</html>