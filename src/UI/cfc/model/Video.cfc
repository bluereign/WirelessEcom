<cfcomponent output="false">

	<cffunction name="init" output="false" access="public" returntype="cfc.model.Video">
		<cfargument name="VideoId" type="numeric" default="0" required="false" />
		<cfargument name="ProductId" type="numeric" default="0" required="false" />
		<cfargument name="FileName" type="string" default="" required="false" />
		<cfargument name="Title" type="string" default="" required="false" />
		<cfargument name="PosterFileName" type="string" default="" required="false" />
		<cfargument name="Active" type="boolean" default="true" required="false" />
		<cfargument name="Ordinal" type="numeric" default="0" required="false" />

		<cfscript>
			variables.instance = {};
			
			setVideoId( arguments.VideoId );
			setProductId( arguments.ProductId );
			setFileName( arguments.FileName );
			setTitle( arguments.Title );
			setPosterFileName( arguments.PosterFileName );
			setActive( arguments.Active );
			setOrdinal( arguments.Ordinal );
		</cfscript>

		<cfreturn this />
	</cffunction>

	<cffunction name="setVideoId" output="false" access="public" returntype="void">
		<cfargument name="VideoId" type="numeric" default="0" required="false" />
		<cfset variables.instance.VideoId = arguments.VideoId />
	</cffunction>
	<cffunction name="getVideoId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.VideoId />
	</cffunction>

	<cffunction name="setProductId" output="false" access="public" returntype="void">
		<cfargument name="ProductId" type="numeric" default="0" required="false" />
		<cfset variables.instance.ProductId = arguments.ProductId />
	</cffunction>
	<cffunction name="getProductId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.ProductId />
	</cffunction>

	<cffunction name="setFileName" output="false" access="public" returntype="void">
		<cfargument name="FileName" type="string" default="0" required="false" />
		<cfset variables.instance.FileName = arguments.FileName />
	</cffunction>
	<cffunction name="getFileName" output="false" access="public" returntype="string">
		<cfreturn variables.instance.FileName />
	</cffunction>
	
	<cffunction name="setTitle" output="false" access="public" returntype="void">
		<cfargument name="Title" type="string" default="0" required="false" />
		<cfset variables.instance.Title = arguments.Title />
	</cffunction>
	<cffunction name="getTitle" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Title />
	</cffunction>

	<cffunction name="setPosterFileName" output="false" access="public" returntype="void">
		<cfargument name="PosterFileName" type="string" default="0" required="false" />
		<cfset variables.instance.PosterFileName = arguments.PosterFileName />
	</cffunction>
	<cffunction name="getPosterFileName" output="false" access="public" returntype="string">
		<cfreturn variables.instance.PosterFileName />
	</cffunction>

	<cffunction name="setActive" output="false" access="public" returntype="void">
		<cfargument name="Active" type="boolean" default="true" required="false" />
		<cfset variables.instance.Active = arguments.Active />
	</cffunction>
	<cffunction name="getActive" output="false" access="public" returntype="boolean">
		<cfreturn variables.instance.Active />
	</cffunction>

	<cffunction name="setOrdinal" output="false" access="public" returntype="void">
		<cfargument name="Ordinal" type="numeric" default="0" required="false" />
		<cfset variables.instance.Ordinal = arguments.Ordinal />
	</cffunction>
	<cffunction name="getOrdinal" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.Ordinal />
	</cffunction>

	<cffunction name="save" output="false" access="public" returntype="void">
		<cfset var result = '' />
		
		<cfif !Trim(getVideoId())>
			<cfquery datasource="#application.dsn.wirelessAdvocates#" result="result">
				INSERT INTO content.Video
				(
					ProductId
					, FileName
					, Title
					, PosterFileName
					, Active
					, Ordinal
				)
				VALUES
				(
					<cfqueryparam value="#Trim( getProductId() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getProductId()))#" />
					, <cfqueryparam value="#Trim( getFileName() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getFileName()))#" />
					, <cfqueryparam value="#Trim( getTitle() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getTitle()))#" />
					, <cfqueryparam value="#Trim( getPosterFileName() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getPosterFileName()))#" />
					, <cfqueryparam value="#Trim( getActive() )#" cfsqltype="cf_sql_bit" null="#!len(trim(getActive()))#" />
					, <cfqueryparam value="#Trim( getOrdinal() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getOrdinal()))#" />
				)
			</cfquery>
			
			<cfset setVideoId( result.IdentityCol ) />
		<cfelse>
			<cfquery datasource="#application.dsn.wirelessAdvocates#">
				UPDATE content.Video
				SET	FileName = <cfqueryparam value="#Trim( getFileName() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getFileName()))#" />
					, ProductId = <cfqueryparam value="#Trim( getProductId() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getProductId()))#" />
					, Title = <cfqueryparam value="#Trim( getTitle() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getTitle()))#" />
					, PosterFileName = <cfqueryparam value="#Trim( getPosterFileName() )#" cfsqltype="cf_sql_varchar" null="#!len(trim(getPosterFileName()))#" />
					, Active = <cfqueryparam value="#Trim( getActive() )#" cfsqltype="cf_sql_bit" null="#!len(trim(getActive()))#" />
					, Ordinal = <cfqueryparam value="#Trim( getOrdinal() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getOrdinal()))#" />
				WHERE VideoId = <cfqueryparam value="#Trim( getVideoId() )#" cfsqltype="cf_sql_integer" null="#!len(trim(getVideoId()))#" />
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="load" output="false" access="public" returntype="void">
		<cfargument name="VideoId" type="numeric" required="true" />
		<cfset var qVideo = '' />

		<cfquery name="qVideo" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				VideoId
				, ProductId
				, FileName
				, Title
				, PosterFileName
				, Active
				, Ordinal
			FROM content.Video
			WHERE VideoId = <cfqueryparam value="#arguments.VideoId#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfscript>
			if (qVideo.recordCount)
			{
				setVideoId( qVideo.VideoId );
				setProductId( qVideo.ProductId );
				setFileName( qVideo.FileName );
				setTitle( qVideo.Title );
				setPosterFileName( qVideo.PosterFileName );
				setActive( qVideo.Active );
				setOrdinal( qVideo.Ordinal );
			}
		</cfscript>

	</cffunction>

	<cffunction name="getInstanceData" output="false" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>