<cfcomponent output="false" displayname="VideoManager">

	<cffunction name="init" output="false" access="public" returntype="VideoManager">
		<cfscript>
			variables.fileManager = CreateObject('component', 'cfc.com.videoconverter.FileMgr').init( request.config.VideoConvertor.VideoFilePath, '/poster/' );
			variables.videoConverter = CreateObject('component', 'cfc.com.videoconverter.VideoConverter').init( variables.fileManager );
		</cfscript>
		
    	<cfreturn this />
    </cffunction>


	<cffunction name="GetVideoByProductId" output="false" access="public" returntype="query">
		<cfargument name="ProductId" type="numeric" required="true" />		
		<cfset var qVideos = '' />
		
		<cfquery name="qVideos" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				VideoId
				, ProductId
				, Title
				, FileName
				, PosterFileName
				, Active
			FROM content.Video
			WHERE ProductId =   <cfqueryparam value="#arguments.ProductId#" cfsqltype="cf_sql_integer" />
			ORDER BY Ordinal
		</cfquery>

		<cfreturn qVideos />
    </cffunction>


	<cffunction name="DeleteVideo" output="false" access="public" returntype="void">
		<cfargument name="Video" type="cfc.model.Video" required="true" />
    	<cfset var i = 0 />
		<cfset var videoFilepath = '' />
		<cfset var posterFilepath = '' />
    	
		<cfquery datasource="#application.dsn.wirelessAdvocates#">
			DELETE FROM content.Video
			WHERE VideoId = <cfqueryparam value="#arguments.Video.getVideoId()#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<!--- Remove videos --->
		<cfloop list="mp4,webm,swf,ogv" index="i" >
			<cfset videoFilepath = '#request.config.VideoConvertor.VideoFilePath#\products\#Video.getProductId()#\#Video.getFileName()#.#i#' />
			
			<cfif FileExists(videoFilepath)>
				<cffile action="delete" file="#videoFilepath#" />
			</cfif>
		</cfloop>
		
		<!--- Remove poster --->
		<cfset posterFilepath = '#request.config.VideoConvertor.VideoFilePath#\poster\#Video.getPosterFileName()#' />	
		<cfif FileExists(posterFilepath)>
			<cffile action="delete" file="#posterFilepath#" />
		</cfif>
		
    </cffunction>


	<cffunction name="ConvertVideo" output="false" access="public" returntype="void">
		<cfargument name="FilePath" type="string" required="true" />
		<cfargument name="FileTypes" type="array" required="true" />
		<cfargument name="OutputFolder" type="string" required="true" />

		<cfscript>
			var i = 0;

			for (i=1; i <= ArrayLen(arguments.FileTypes); i++)
			{
				//Convert for different file types than original file
				if ( arguments.FileTypes[i] neq ListLast(arguments.FilePath, '.'))
				{
					variables.videoConverter.convertVideo( arguments.FilePath, arguments.OutputFolder, arguments.FileTypes[i], true);
				}
			}
		</cfscript>

    </cffunction>
		

	<cffunction name="CreatePoster" output="false" access="public" returntype="string">
		<cfargument name="FilePath" type="string" required="true" />
		<cfargument name="OutputFolder" type="string" required="true" />
		<cfargument name="Offset" type="string" required="true" />

		<cfscript>
			var result = variables.videoConverter.generateVideoThumb( arguments.FilePath, arguments.OutputFolder, arguments.Offset );
		</cfscript>
		
		<cfreturn result />
    </cffunction>

</cfcomponent>