<cfcomponent output="true">

<!--- prod uses shared images dir --->
<cfset variables.baseAbsoluteDir = request.paths.sync & "images/">
<cfset variables.baseRelDir = "/productimages/">

<cffunction name="upload" access="public" returntype="void"
		description="stores the uploaded image for later retrieval using get()">
	<cfargument name="area" type="string" required="true" hint="eg 'products'">
	<cfargument name="key" type="string" required="true" hint="identifier for this image in this area, usu a primary key">
	<cfargument name="formFieldName" type="string" required="true">

	<cfset var thekey = reReplace(trim(arguments.key), "[^a-zA-Z0-9]", "")>

	<cfif theKey is "">
		<cfthrow message="Blank keys are not allowed (no prodCode?)">
	</cfif>

	<CFFILE ACTION="upload"
		DESTINATION="#getTempDirectory()#"
		FILEFIELD="#arguments.formFieldName#"
		NAMECONFLICT="MAKEUNIQUE"
		ACCEPT="image/gif,image/jpeg,image/jpg,image/pjpeg,image/png,image/x-png">

	<cfset import(arguments.area, thekey, file.serverDirectory & "/" & file.serverfile)>

</cffunction>

<cffunction name="import" access="public" returntype="void"
		description="stores the uploaded image for later retrieval using get()">
	<cfargument name="area" type="string" required="true" hint="eg 'products'">
	<cfargument name="key" type="string" required="true" hint="identifier for this image in this area, usu a primary key">
	<cfargument name="sourceFileAbsolutePath" type="string" required="true">
	<cfargument name="deleteSourceFile" type="boolean" default="true">

	<cfset var thekey = reReplace(trim(arguments.key), "[^a-zA-Z0-9]", "")>
	<cfset var areaAbsoluteDir = variables.baseAbsoluteDir & arguments.area & "/">
	<cfset var areaRelDir = variables.baseRelDir & arguments.area & "/">
	<cfset var itemAbsoluteDir = areaAbsoluteDir & thekey & "/">
	<cfset var itemRelDir = areaRelDir & thekey & "/">

	<cfset var destFN = "">
	<cfset var imageCFC = "">
	<cfset var imgInfo = "">
	<cfif theKey is "">
		<cfthrow message="Blank keys are not allowed (no prodCode?)">
	</cfif>

	<!--- ensure directories exist --->
	<cfif not directoryExists(areaAbsoluteDir)>
		<cfdirectory action="create" directory="#areaAbsoluteDir#" />
	</cfif>
	<cfif not directoryExists(itemAbsoluteDir)>
		<cfdirectory action="create" directory="#itemAbsoluteDir#" />
	</cfif>

	<!--- delete old converted pictures --->
	<cfset delete(area,thekey)>

	<!--- convert/rename the picture --->
	<cfset destFN = itemAbsoluteDir & thekey & ".jpg">
	<cfset currentType = listLast(arguments.sourceFileAbsolutePath, ".")>
	<cfif currentType is "jpg" or currentType is "jpeg">
		<!--- copy as-is --->
		<cffile action="copy" source="#arguments.sourceFileAbsolutePath#" destination="#destFN#" mode="744">
	<cfelse>
		<!--- convert to jpg --->
		<cfset imageCFC = createObject("component", "Image")>
		<cfset imgInfo = imageCFC.convert("", arguments.sourceFileAbsolutePath, destFN)>
	</cfif>

	<cfif arguments.deleteSourceFile>
		<cffile action="Delete" file="#arguments.sourceFileAbsolutePath#">
	</cfif>

</cffunction>


<cffunction name="get" access="public" returntype="String" output="yes"
		description="Returns a relative image path to an image with the dimensions indicated, or an empty string if no image is available">
	<cfargument name="area" type="string" required="true" hint="eg 'products'">
	<cfargument name="key" type="string" required="true" hint="identifier for this image in this area, usu a primary key">
	<cfargument name="width" type="string" required="true" hint="desired width, or 0 to change height only">
	<cfargument name="height" type="string" required="true" hint="desired height, or 0 to change width only">
	<cfargument name="throwError" type="boolean" required="false" default="true" hint="if something goes wrong, throw an error or return an empty string">
	<cfargument name="useDefaultImage" type="boolean" required="false" default="false" hint="Whether or not to return the default 'no image' jpg at the requested size">

	<cfset var thekey = reReplace(trim(arguments.key), "[^a-zA-Z0-9]", "")>
	<cfset var areaAbsoluteDir = variables.baseAbsoluteDir & arguments.area & "/">
	<cfset var areaRelDir = variables.baseRelDir & arguments.area & "/">
	<cfset var itemAbsoluteDir = areaAbsoluteDir & thekey & "/">
	<cfset var itemRelDir = areaRelDir & thekey & "/">
	<cfset var baseAbsoluteFile = itemAbsoluteDir & thekey & ".jpg">
	<cfset var desiredAbsoluteFile = itemAbsoluteDir & thekey & "_#arguments.height#_#arguments.width#.jpg">
	<cfset var desiredRelFile = itemRelDir & thekey & "_#arguments.height#_#arguments.width#.jpg">
	
	<cfset var imageCFC = "">
	
	<cftry>
	
		<cfif theKey is "" AND NOT arguments.useDefaultImage>
			<cfreturn "">
		</cfif>
		
		<cfif arguments.useDefaultImage>
			<cfset itemAbsoluteDir = areaAbsoluteDir>
			<cfset itemRelDir = areaRelDir>
			<cfset baseAbsoluteFile = itemAbsoluteDir & "img_unavailable.jpg">
			<cfset desiredAbsoluteFile = itemAbsoluteDir & "img_unavailable_#arguments.height#_#arguments.width#.jpg">
			<cfset desiredRelFile = itemRelDir & "img_unavailable_#arguments.height#_#arguments.width#.jpg">		
		
		</cfif>
	
		<cfif not fileExists(baseAbsoluteFile)>
			<cfreturn "">
		</cfif>
	
		<cfif width is 0 and height is 0>
			<cfif arguments.useDefaultImage>
				<cfreturn itemRelDir & "img_unavailable.jpg">
			<cfelse>
				<cfreturn itemRelDir & thekey & ".jpg">
			</cfif>
		</cfif>
		
		<cfif not fileExists(desiredAbsoluteFile)>
			<!--- create imageCFC object --->
			<cfset imageCFC = createObject("component", "Image")>
			<!--- calculate blur needed for resize --->
			<cfset blurme = getBlurConstants(baseAbsoluteFile,arguments.width, arguments.height)>
			<!--- resize the pic --->
			<cfset imageCFC.resize(imageCFC.filterFastBlur("", baseAbsoluteFile, "",blurMe.amount,blurMe.times,100).Img, "", desiredAbsoluteFile, arguments.width, arguments.height, true)>
	
			<!--- original code before blur 
			<cfset imageCFC.resize("", baseAbsoluteFile, desiredAbsoluteFile, arguments.width, arguments.height, true)>
			--->
		</cfif>
		<cfcatch type="any">
			<cfif throwError>
				<cfrethrow />
			<cfelse>
				<!--- Log the error so we can at least see what happened --->
				<cflog type="error" application="true" file="CPGError.log" text="#cfcatch.Message#">
				<cfset desiredRelFile = "">
			</cfif>
		</cfcatch>
	</cftry>
	
	<cfreturn desiredRelFile>

</cffunction>

<cffunction name="getBlurConstants" access="public" output="false" returntype="struct">
	<cfargument name="image">
	<cfargument name="targetheight">
	<cfargument name="targetwidth">
	
	<cfscript>
		// get the original height & width
		imageCFC = createObject("component", "Image");
		origImage = imageCFC.getImageInfo("",ARGUMENTS.image);
		
		// figure out if we need to get scale by height or width
		if (ARGUMENTS.targetheight EQ 0) {
			factor = ARGUMENTS.targetheight / origImage.height;
		} else if (ARGUMENTS.targetwidth EQ 0) {
			factor = ARGUMENTS.targetwidth / origImage.width;
		} else {
			if (ARGUMENTS.targetwidth / origImage.width GT ARGUMENTS.targetheight / origImage.height) {
				factor = ARGUMENTS.targetheight / origImage.height;
			} else {
				factor = ARGUMENTS.targetwidth / origImage.width;
			}
		}
		
		// if the source was less than 200px wide, don't blur
		if (origImage.width LT 200 AND ARGUMENTS.targetheight GT 65) {
			factor = 1;
		} 
		
		blurMe = structNew();
	</cfscript>
	
	<cfif factor gt .9>
		<cfset blurMe.amount = 0>
		<cfset blurMe.times = 0>
	<cfelseif factor gt .7>
		<cfset blurMe.amount = 2>
		<cfset blurMe.times = 2>
	<cfelseif factor gt .5>
		<cfset blurMe.amount = 2>
		<cfset blurMe.times = 3>
	<cfelseif factor gt .3>
		<cfset blurMe.amount = 2>
		<cfset blurMe.times = 4>
	<cfelse>
		<cfset blurMe.amount = 2>
		<cfset blurMe.times = 5>
	</cfif>
	
	<cfreturn blurMe>
</cffunction>

<cffunction name="delete" access="public" returntype="void"
		description="delete images for this key">
	<cfargument name="area" type="string" required="true" hint="eg 'products'">
	<cfargument name="key" type="string" required="true" hint="identifier for this image in this area, usu a primary key">

	<cfset var thekey = reReplace(trim(arguments.key), "[^a-zA-Z0-9]", "")>
	<cfset var areaAbsoluteDir = variables.baseAbsoluteDir & arguments.area & "/">
	<cfset var itemAbsoluteDir = areaAbsoluteDir & thekey & "/">

	<cfif theKey is "">
		<cfthrow message="Blank keys are not allowed (no prodCode?)">
	</cfif>


	<cfdirectory action="list" directory="#itemAbsoluteDir#" name="qDir">
	<cfloop query="qDir">
		<cfif left(qDir.name,1) is not "." and fileExists("#itemAbsoluteDir##qDir.name#")>
			<cffile action="delete" file="#itemAbsoluteDir##qDir.name#">
		</cfif>
	</cfloop>

</cffunction>

</cfcomponent>