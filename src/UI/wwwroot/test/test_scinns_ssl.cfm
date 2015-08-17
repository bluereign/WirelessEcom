<cfscript>
	request.layoutFile = 'nolayout';
	request.bodycontent = '';
</cfscript>

<cfhttp method="post" url="https://payment.aafesmobile.com/scinssdev/api/echo" result="scinss">
	<cfhttpparam type="formField" name="test" value="test">
</cfhttp>


<cfdump var="#scinss#">