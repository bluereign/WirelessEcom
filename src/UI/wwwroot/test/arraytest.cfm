Array Test Page<br/>

<cfset list1 = "$149" />
<cfset list2 = "$149,$150" />
<cfset list3 = "$149,$150,$151" />

<cfset array1 = listToArray(list1) />
<cfset array2 = listToArray(list2) />
<cfset array3 = listToArray(list3) />


<cfdump var="#array1#" />
<cfdump var="#array2#" />
<cfdump var="#array3#" />

<form action="arraytest.cfm" method="post">
	<input type="hidden" name="action" value="fromform"/>
	<cfoutput>
	<input type="hidden" name="formlist1" value="#list1#"/>
	<input type="hidden" name="formlist2" value="#list2#"/>
	<input type="hidden" name="formlist3" value="#list3#"/>
	</cfoutput>
	<input type="submit">
</form>

<cfif isdefined("action") >
		
<cfset formarray1 = listToArray(form.formlist1) />
<cfset formarray2 = listToArray(form.formlist2) />
<cfset formarray3 = listToArray(form.formlist3) />

<cfdump var="#form#" />
<cfdump var="#formarray1#" />
<cfdump var="#formarray2#" />
<cfdump var="#formarray3#" />

	
</cfif>	
	