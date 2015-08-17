<cfset channelConfig = application.wirebox.getInstance("ChannelConfig") />
<p><h1>Unauthorized or Expired Session</h1><br>
You have reached this page due the following:<br>
- Lack of activity <br>
- Did not log in properly<br>
- Invalid session<br>
<h3>Please return to <a href="http://wa2go-test.wirelessadvocates.llc/">WA2GO</a> in order to log back into <cfoutput>#channelConfig.getScenarioDescription()#</cfoutput></h3></p>