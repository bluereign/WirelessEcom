<!---
Noeologix Software Solutions
Created By		: Roshith.M.P
Date Created	: 06 March 2010
Modified By		:
Date Modified	:
Description		: Page to display the Billing information

--->

<cfparam name="billingInfoHTML" type="string" default="">
<cfparam name="leftMenuHTML" type="string" default="">

<cfoutput>
<table width="750" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td width="20%" valign="top">#leftMenuHTML#</td>
    <td valign="top">#billingInfoHTML#</td>
  </tr>
</table>

</cfoutput>