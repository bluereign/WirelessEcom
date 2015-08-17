<cftry>
  <cfif structKeyExists(url, 'details')>
    <cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=5cbefad6-8568-4e33-9040-7f89031d15e0'>
      <cfoutput>
        #cfhttp.filecontent#
      </cfoutput>

      <cfelse>

        <cfhttp url='http://#CGI.HTTP_HOST#/Content-asp/ShowContent.aspx?l=3973e419-1e60-4736-9c73-6052b8029589'>
          <cfoutput>
            #cfhttp.filecontent#
          </cfoutput>
        </cfif>

  <cfcatch type="missinginclude">
    <cflocation url="/index.cfm/go/error/do/404/" addtoken="false" />
  </cfcatch>
</cftry>