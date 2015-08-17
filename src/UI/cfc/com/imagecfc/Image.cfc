<!---
	image.cfc v2.19, written by Rick Root (rick@webworksllc.com)
	Derivative of work originally done originally by James Dew.
	
	Related Web Sites:
	- http://www.opensourcecf.com/imagecfc (home page)
	- http://www.cfopen.org/projects/imagecfc (project page)

	LICENSE
	-------
	Copyright (c) 2007, Rick Root <rick@webworksllc.com>
	All rights reserved.

	Redistribution and use in source and binary forms, with or 
	without modification, are permitted provided that the 
	following conditions are met:

	- Redistributions of source code must retain the above 
	  copyright notice, this list of conditions and the 
	  following disclaimer. 
	- Redistributions in binary form must reproduce the above 
	  copyright notice, this list of conditions and the 
	  following disclaimer in the documentation and/or other 
	  materials provided with the distribution. 
	- Neither the name of the Webworks, LLC. nor the names of 
	  its contributors may be used to endorse or promote products 
	  derived from this software without specific prior written 
	  permission. 

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
	CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
	OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	============================================================	
	This is a derivative work.  Following is the original 
	Copyright notice.
	============================================================	
	
	Copyright (c) 2004 James F. Dew <jdew@yggdrasil.ca>
 
	Permission to use, copy, modify, and distribute this software for any
	purpose with or without fee is hereby granted, provided that the above
	copyright notice and this permission notice appear in all copies.
 
	THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--->
<!---
	SPECIAL NOTE FOR HEADLESS SYSTEMS
	---------------------------------
	If you get a "cannot connect to X11 server" when running certain
	parts of this component under Bluedragon (Linux), you must
	add "-Djava.awt.headless=true" to the java startup line in
	<bluedragon>/bin/StartBluedragon.sh.  This isssue is discussed
	in the Bluedragon Installation Guide section 3.8.1 for
	Bluedragon 6.2.1.

	Bluedragon may also report a ClassNotFound exception when trying
	to instantiate the java.awt.image.BufferedImage class.  This is
	most likely the same issue.

	If you get "This graphics environment can be used only in the
	software emulation mode" when calling certain parts of this
	component under Coldfusion MX, you should refer to Technote
	ID #18747:  http://www.macromedia.com/go/tn_18747 
--->

<cfcomponent displayname="Image">

<cfset variables.throwOnError = "Yes">
<cfset variables.defaultJpegCompression = "100">
<cfset variables.interpolation = "bicubic">
<cfset variables.textAntiAliasing = "Yes">
<cfset variables.tempDirectory = "#expandPath(".")#">

<cfset variables.javanulls = "no">
<cftry>
	<cfset nullvalue = javacast("null","")>
	<cfset variables.javanulls = "yes">
	<cfcatch type="any">
		<cfset variables.javanulls = "no">
		<!--- javacast null not supported, so filters won't work --->
	</cfcatch>
</cftry>

<cfif javanulls>
	<cfset variables.blurFilter = createObject("component","BlurFilter")>
	<cfset variables.sharpenFilter = createObject("component","SharpenFilter")>
	<cfset variables.posterizeFilter = createObject("component","PosterizeFilter")>
</cfif>

<cfset variables.Math = createobject("java", "java.lang.Math")>
<cfset variables.arrObj = createobject("java", "java.lang.reflect.Array")>
<cfset variables.floatClass = createobject("java", "java.lang.Float").TYPE>
<cfset variables.intClass = createobject("java", "java.lang.Integer").TYPE>
<cfset variables.shortClass = createobject("java", "java.lang.Short").TYPE>

<cffunction name="getImageInfo" access="public" output="true" returntype="struct" hint="Rotate an image (+/-)90, (+/-)180, or (+/-)270 degrees.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfset var local = arguments>
	<cfset local.retVal = StructNew()>
	<cfset local.loadImage = StructNew()>
	<cfset local.img = "">

	<cfset local.retVal.errorCode = 0>
	<cfset local.retVal.errorMessage = "">
	
	<cfif local.inputFile neq "">
		<cfset local.loadImage = readImage(local.inputFile, "NO")>
		<cfif local.loadImage.errorCode is 0>
			<cfset local.img = local.loadImage.img>
		<cfelse>
			<cfset local.retVal = throw(local.loadImage.errorMessage)>
			<cfreturn local.retVal>
		</cfif>
		<cfset retVal.local.metaData = getImageMetadata(local.loadImage.inFile)>
	<cfelse>
		<cfset local.img = local.objImage>
		<cfset local.retVal.metadata = getImageMetadata("")>
	</cfif>
	<cftry>
		<cfset local.retVal.width = local.img.getWidth()>
		<cfset local.retVal.height = local.img.getHeight()>
		<cfset local.retVal.colorModel = local.img.getColorModel().toString()>
		<cfset local.retVal.colorspace = local.img.getColorModel().getColorSpace().toString()>
		<cfset local.retVal.objColorModel = local.img.getColorModel()>
		<cfset local.retVal.objColorspace = local.img.getColorModel().getColorSpace()>
		<cfset local.retVal.sampleModel = local.img.getSampleModel().toString()>
		<cfset local.retVal.imageType = local.img.getType()>
		<cfset local.retVal.misc = local.img.toString()>
		<cfset local.retVal.canModify = true>
		<cfreturn local.retVal>
		<cfcatch type="any">
			<cfset local.retVal = throw( "#cfcatch.message#: #cfcatch.detail#")>
			<cfreturn local.retVal>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="getImageMetadata" access="private" output="false" returntype="query">
	<cfargument name="inFile" required="yes" type="Any"><!--- java.io.File --->
	<cfset var local = arguments>
	<cfset local.retQry = queryNew("dirName,tagName,tagValue")>
	<cfset local.paths = arrayNew(1)>
	<cfset local.loader = "">
	<cfset local.JpegMetadatareader = "">
	<cfset local.myMetadata = "">
	<cfset local.directories = "">
	<cfset local.currentDirectory = "">
	<cfset local.tags = "">
	<cfset local.currentTag = "">
	<cfset local.tagName = "">
	
<!---
	<cftry>
	<cfscript>
		paths = arrayNew(1);
		paths[1] = getDirectoryFromPath(getCurrentTemplatePath()) & "metadata-extractor-2.3.1.jar";
		loader = createObject("component", "cfc.imagecfc.imagecfc.javaloader.JavaLoader").init(paths);
		
		//at this stage we only have access to the class, but we don't have an instance
		JpegMetadataReader = loader.create("com.drew.imaging.jpeg.JpegMetadataReader");

		myMetaData = JpegMetadataReader.readMetadata(createObject( "java","java.io.File" ).Init(inFile));
		directories = myMetaData.getDirectoryIterator();
		while (directories.hasNext()) {
			currentDirectory = directories.next();
			tags = currentDirectory.getTagIterator();
			while (tags.hasNext()) {
				currentTag = tags.next();
				if (currentTag.getTagName() DOES NOT CONTAIN "Unknown") { //leave out the junk data
					queryAddRow(retQry);
					querySetCell(retQry,"dirName",replace(currentTag.getDirectoryName(),' ','_','ALL'));
					tagName = replace(currentTag.getTagName(),' ','','ALL');
					tagName = replace(tagName,'/','','ALL');
					querySetCell(retQry,"tagName",tagName);
					querySetCell(retQry,"tagValue",currentTag.getDescription());
				}
			}
		}
		return retQry;
		</cfscript>
		<cfcatch type="any">
--->
			<cfreturn local.retQry />
<!---
		</cfcatch>
	</cftry>	
--->
</cffunction>

<cffunction name="flipHorizontal" access="public" output="true" returntype="struct" hint="Flip an image horizontally.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn flipflop(objImage, inputFile, outputFile, "horizontal", jpegCompression)>
</cffunction>

<cffunction name="flipVertical" access="public" output="true" returntype="struct" hint="Flop an image vertically.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn flipflop(objImage, inputFile, outputFile, "vertical", jpegCompression)>	
</cffunction>

<cffunction name="scaleWidth" access="public" output="true" returntype="struct" hint="Scale an image to a specific width.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn resize(objImage, inputFile, outputFile, newWidth, 0, "false", "false", jpegCompression)>
</cffunction>

<cffunction name="scaleHeight" access="public" output="true" returntype="struct" hint="Scale an image to a specific height.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn resize(objImage, inputFile, outputFile, 0, newHeight, "false", "false", jpegCompression)>
</cffunction>

<cffunction name="resize" access="public" output="true" returntype="struct" hint="Resize an image to a specific width and height.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="preserveAspect" required="no" type="boolean" default="FALSE">
	<cfargument name="cropToExact" required="no" type="boolean" default="FALSE">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">
	<cfset var local = arguments>

	<cfset local.retVal = structNew()>
	<cfset local.loadImage = structNew()>
	<cfset local.saveImage = structNew()>
	<cfset local.at = "">
	<cfset local.op = "">
	<cfset local.w = "">
	<cfset local.h = "">
	<cfset local.scale = 1>
	<cfset local.scaleX = 1>
	<cfset local.scaleY = 1>
	<cfset local.resizedImage = "">
	<cfset local.rh = getRenderingHints()>
	<cfset local.specifiedWidth = local.newWidth>
	<cfset local.specifiedHeight = local.newHeight>
	<cfset local.imgInfo = "">
	<cfset local.img = "">
	<cfset local.cropImageResult = "">
	<cfset local.cropOffsetX = "">
	<cfset local.cropOffsetY = "">
	
	<cfset local.retVal.errorCode = 0>
	<cfset local.retVal.errorMessage = "">

	<cfif local..inputFile neq "">
		<cfset local.loadImage = readImage(local..inputFile, "NO")>
		<cfif local.loadImage.errorCode is 0>
			<cfset local.img = local.loadImage.img>
		<cfelse>
			<cfset local.retVal = throw(local.loadImage.errorMessage)>
			<cfreturn local.retVal>
		</cfif>
	<cfelse>
		<cfset local.img = local..objImage>
	</cfif>
	<cfif local.img.getType() eq 0>
		<cfset local.img = convertImageObject(local.img,local.img.TYPE_3BYTE_BGR)>
	</cfif>
	<cfscript>
		local.resizedImage = createObject("java", "java.awt.image.BufferedImage");
		local.at = createObject("java", "java.awt.geom.AffineTransform");
		local.op = createObject("java", "java.awt.image.AffineTransformOp");

		local.w = local.img.getWidth();
		local.h = local.img.getHeight();

		if (local.preserveAspect and local.cropToExact and local.newHeight gt 0 and local.newWidth gt 0)
		{
			if (local.w / local.h gt local.newWidth / local.newHeight){
				local.newWidth = 0;
			} else if (local.w / local.h lt local.newWidth / local.newHeight){
				local.newHeight = 0;
		    }
		} else if (local.preserveAspect and local.newHeight gt 0 and local.newWidth gt 0) {
			if (local.w / local.h gt local.newWidth / local.newHeight){
				local.newHeight = 0;
			} else if (local.w / local.h lt local.newWidth / local.newHeight){
				local.newWidth = 0;
		    }
		}
		if (local.newWidth gt 0 and local.newHeight eq 0) {
			local.scale = local.newWidth / local.w;
			local.w = local.newWidth;
			local.h = round(local.h*local.scale);
		} else if (local.newHeight gt 0 and local.newWidth eq 0) {
			local.scale = local.newHeight / local.h;
			local.h = local.newHeight;
			local.w = round(local.w*local.scale);
		} else if (local.newHeight gt 0 and local.newWidth gt 0) {
			local.w = local.newWidth;
			local.h = local.newHeight;
		} else {
			local.retVal = throw( local.retVal.errorMessage);
			return local.retVal;
		}
//		try
//		{
		if (local.img.getType() eq 0)
		{
			local.img = convertImageObject(local.srcImage,local.srcImage.TYPE_3BYTE_BGR);
		}
		local.resizedImage.init(javacast("int",local.w),javacast("int",local.h),local.img.getType()); // TODO: for some reason, this fails on certain images of certain types on Windows - needs further review
//			}
//			catch(any e)
//			{
//				resizedImage.init(javacast("int",w),javacast("int",h),img.TYPE_3BYTE_BGR);
//		}

		local.w = local.w / local.img.getWidth();
		local.h = local.h / local.img.getHeight();


		// TODO: TRV: for some reason, this tends to fail on TEST - revisit later
		local.op.init(local.at.getScaleInstance(javacast("double",local.w),javacast("double",local.h)), local.rh);
//		resizedImage = op.createCompatibleDestImage(img, img.getColorModel());
		local.op.filter(local.img, local.resizedImage);

		if(local.preserveAspect and local.cropToExact)
		{
			local.imgInfo = getimageinfo(local.resizedImage, "");
			if (local.imgInfo.errorCode gt 0)
			{
				return local.imgInfo;
			}
	
			local.cropOffsetX = max( Int( (local.imgInfo.width/2) - (local.newWidth/2) ), 0 );
			local.cropOffsetY = max( Int( (local.imgInfo.height/2) - (local.newHeight/2) ), 0 );
			// There is a chance that the image is exactly the correct 
			// width and height and don't need to be cropped 
			if 
				(
				local.preserveAspect and local.cropToExact
				and
				(local.imgInfo.width IS NOT local.specifiedWidth OR local.imgInfo.height IS NOT local.specifiedHeight)
				)
			{
				// Get the correct offset to get the center of the image
				local.cropOffsetX = max( Int( (local.imgInfo.width/2) - (local.specifiedWidth/2) ), 0 );
				local.cropOffsetY = max( Int( (local.imgInfo.height/2) - (local.specifiedHeight/2) ), 0 );
				
				local.cropImageResult = crop( local.resizedImage, "", "", local.cropOffsetX, local.cropOffsetY, local.specifiedWidth, local.specifiedHeight );
				if ( local.cropImageResult.errorCode GT 0)
				{
					return local.cropImageResult;
				} else {
					local.resizedImage = local.cropImageResult.img;
				}
			}
		}
		if (local.outputFile eq "")
		{
			local.retVal.img = local.resizedImage;
			return local.retVal;
		} else {
			local.saveImage = writeImage(local.outputFile, local.resizedImage, local.jpegCompression);
			if (local.saveImage.errorCode gt 0)
			{
				return local.saveImage;
			} else {
				return local.retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="crop" access="public" output="true" returntype="struct" hint="Crop an image.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="fromX" required="yes" type="numeric">
	<cfargument name="fromY" required="yes" type="numeric">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">
	<cfset var local = arguments>
	<cfset local.retVal = StructNew()>
	<cfset local.loadImage = StructNew()>
	<cfset local.saveImage = StructNew()>
	<cfset local.croppedImage = "">
	<cfset local.rh = getRenderingHints()>
	<cfset local.img = "">

	<cfset local.retVal.errorCode = 0>
	<cfset local.retVal.errorMessage = "">

	<cfif local.inputFile neq "">
		<cfset local.loadImage = readImage(local.inputFile, "NO")>
		<cfif local.loadImage.errorCode is 0>
			<cfset local.img = local.loadImage.img>
		<cfelse>
			<cfset local.retVal = throw(local.loadImage.errorMessage)>
			<cfreturn local.retVal>
		</cfif>
	<cfelse>
		<cfset local.img = local.objImage>
	</cfif>
	<cfif local.img.getType() eq 0>
		<cfset local.img = convertImageObject(local.img,local.img.TYPE_3BYTE_BGR)>
	</cfif>
	<cfscript>
		if (local.fromX + local.newWidth gt local.img.getWidth()
			OR
			local.fromY + local.newHeight gt local.img.getHeight()
			)
		{
			local.retval = throw( "The cropped image dimensions go beyond the original image dimensions.");
			return local.retVal;
		}
		local.croppedImage = local.img.getSubimage(javaCast("int", local.fromX), javaCast("int", local.fromY), javaCast("int", local.newWidth), javaCast("int", local.newHeight) );
		if (local.outputFile eq "")
		{
			local.retVal.img = local.croppedImage;
			return local.retVal;
		} else {
			local.saveImage = writeImage(local.outputFile, local.croppedImage, local.jpegCompression);
			if (local.saveImage.errorCode gt 0)
			{
				return local.saveImage;
			} else {
				return local.retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="rotate" access="public" output="true" returntype="struct" hint="Rotate an image (+/-)90, (+/-)180, or (+/-)270 degrees.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="degrees" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var img = "">
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var at = "">
	<cfset var op = "">
	<cfset var w = 0>
	<cfset var h = 0>
	<cfset var iw = 0>
	<cfset var ih = 0>
	<cfset var x = 0>
	<cfset var y = 0>
	<cfset var rotatedImage = "">
	<cfset var rh = getRenderingHints()>

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset img = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>
	<cfif img.getType() eq 0>
		<cfset img = convertImageObject(img,img.TYPE_3BYTE_BGR)>
	</cfif>
	<cfif ListFind("-270,-180,-90,90,180,270",degrees) is 0>
		<cfset retVal = throw( "At this time, image.cfc only supports rotating images in 90 degree increments.")>
		<cfreturn retVal>
	</cfif>

	<cfscript>
		rotatedImage = CreateObject("java", "java.awt.image.BufferedImage");
		at = CreateObject("java", "java.awt.geom.AffineTransform");
		op = CreateObject("java", "java.awt.image.AffineTransformOp");

		iw = img.getWidth(); h = iw;
		ih = img.getHeight(); w = ih;

		if(arguments.degrees eq 180) { w = iw; h = ih; }
				
		x = (w/2)-(iw/2);
		y = (h/2)-(ih/2);
		
		rotatedImage.init(javacast("int",w),javacast("int",h),img.getType());

		at.rotate(arguments.degrees * 0.0174532925,w/2,h/2);
		at.translate(x,y);
		op.init(at, rh);
		
		op.filter(img, rotatedImage);

		if (outputFile eq "")
		{
			retVal.img = rotatedImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, rotatedImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="convert" access="public" output="true" returntype="struct" hint="Convert an image from one format to another.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">
	
	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var img = "">

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset img = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>

	<cfscript>
		if (outputFile eq "")
		{
			retVal = throw( "The convert method requires a valid output filename.");
			return retVal;
		} else {
			saveImage = writeImage(outputFile, img, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="setOption" access="public" output="true" returnType="void" hint="Sets values for allowed CFC options.">
	<cfargument name="key" type="string" required="yes">
	<cfargument name="val" type="string" required="yes">
	
	<cfset var validKeys = "interpolation,textantialiasing,throwonerror,defaultJpegCompression">
	<cfset arguments.key = lcase(trim(arguments.key))>
	<cfset arguments.val = lcase(trim(arguments.val))>
	<cfif listFind(validKeys, arguments.key) gt 0>
		<cfset variables[arguments.key] = arguments.val>
	</cfif>
</cffunction>

<cffunction name="getOption" access="public" output="true" returnType="any" hint="Returns the current value for the specified CFC option.">
	<cfargument name="key" type="string" required="yes">
	
	<cfset var validKeys = "interpolation,textantialiasing,throwonerror,defaultJpegCompression">
	<cfset arguments.key = lcase(trim(arguments.key))>
	<cfif listFindNoCase(validKeys, arguments.key) gt 0>
		<cfreturn variables[arguments.key]>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="getRenderingHints" access="private" output="true" returnType="any" hint="Internal method controls various aspects of rendering quality.">
	<cfset var local = structNew()>
	<cfset local.rh = createObject("java","java.awt.RenderingHints")>
	<cfset local.initMap = createObject("java","java.util.HashMap")>
	<cfset local.initMap.init()>
	<cfset local.rh.init(local.initMap)>
	<cfset local.rh.put(local.rh.KEY_ALPHA_INTERPOLATION, local.rh.VALUE_ALPHA_INTERPOLATION_QUALITY)> <!--- QUALITY, SPEED, DEFAULT --->
	<cfset local.rh.put(local.rh.KEY_ANTIALIASING, local.rh.VALUE_ANTIALIAS_ON)> <!--- ON, OFF, DEFAULT --->
	<cfset local.rh.put(local.rh.KEY_COLOR_RENDERING, local.rh.VALUE_COLOR_RENDER_QUALITY)>  <!--- QUALITY, SPEED, DEFAULT --->
	<cfset local.rh.put(local.rh.KEY_DITHERING, local.rh.VALUE_DITHER_DEFAULT)> <!--- DISABLE, ENABLE, DEFAULT --->
	<cfset local.rh.put(local.rh.KEY_RENDERING, local.rh.VALUE_RENDER_QUALITY)> <!--- QUALITY, SPEED, DEFAULT --->
	<cfset local.rh.put(local.rh.KEY_FRACTIONALMETRICS, local.rh.VALUE_FRACTIONALMETRICS_DEFAULT)> <!--- DISABLE, ENABLE, DEFAULT --->
	<cfset local.rh.put(local.rh.KEY_STROKE_CONTROL, local.rh.VALUE_STROKE_DEFAULT)>

	<cfif variables.textAntiAliasing>
		<cfset local.rh.put(local.rh.KEY_TEXT_ANTIALIASING, local.rh.VALUE_TEXT_ANTIALIAS_ON)>
	<cfelse>
		<cfset local.rh.put(local.rh.KEY_TEXT_ANTIALIASING, local.rh.VALUE_TEXT_ANTIALIAS_OFF)>
	</cfif>
	
	<cfif variables.interpolation eq "nearest_neighbor">
		<cfset local.rh.put(local.rh.KEY_INTERPOLATION, local.rh.VALUE_INTERPOLATION_NEAREST_NEIGHBOR)>
	<cfelseif variables.interpolation eq "bilinear">
		<cfset local.rh.put(local.rh.KEY_INTERPOLATION, local.rh.VALUE_INTERPOLATION_BILINEAR)>
	<cfelse>
		<cfset local.rh.put(local.rh.KEY_INTERPOLATION, local.rh.VALUE_INTERPOLATION_BICUBIC)>
	</cfif>

	<cfreturn local.rh>
</cffunction>

<cffunction name="readImage" access="public" output="true" returntype="struct" hint="Reads an image from a local file.  Requires an absolute path.">
	<cfargument name="source" required="yes" type="string">
	<cfargument name="forModification" required="no" type="boolean" default="yes">

	<cfif isURL(arguments.source)>
		<cfreturn readImageFromURL(arguments.source, arguments.forModification)>
	<cfelse>
		<cfreturn readImageFromFile(arguments.source, arguments.forModification)>
	</cfif>
</cffunction>

<cffunction name="readImageFromFile" access="private" output="true" returntype="struct" hint="Reads an image from a local file.  Requires an absolute path.">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="forModification" required="no" type="boolean" default="yes">
	<cfset var local = arguments>
	<cfset local.retVal = StructNew()>
	<cfset local.img = "">
	<cfset local.inFile = "">
	<cfset local.filename = getFileFromPath(local.inputFile)>
	<cfset local.extension = lcase(listLast(local.inputFile,"."))>
	<cfset local.imageIO = createObject("java", "javax.imageio.ImageIO")>
	<cfset local.validExtensionsToRead = arrayToList(local.imageIO.getReaderFormatNames())>
	
	<cfset local.retVal.errorCode = 0>
	<cfset local.retVal.errorMessage = "">
	
	<cfif not fileExists(local.inputFile)>
		<cfset local.retVal = throw("The specified file #Chr(34)##local.inputFile##Chr(34)# could not be found.")>
		<cfreturn local.retVal>
	<cfelseif listLen(local.filename,".") lt 2>
		<cfset local.retVal = throw("Sorry, image files without extensions cannot be manipulated.")>
		<cfreturn local.retVal>
	<cfelseif listFindNoCase(local.validExtensionsToRead, local.extension) is 0>
		<cfset local.retVal = throw("Java is unable to read #local.extension# files.")>
		<cfreturn local.retVal>
	<cfelseif NOT fileExists(local.inputFile)>
		<cfset local.retVal = throw("The specified input file does not exist.")>
		<cfreturn local.retVal>
	<cfelse>
		<cfset local.img = createObject("java", "java.awt.image.BufferedImage")>
		<cfset local.inFile = createObject("java", "java.io.File")>
		<cfset local.inFile.init(local.inputFile)>
		<cfif NOT local.inFile.canRead()>
			<cfset local.retVal = throw("Unable to open source file #Chr(34)##local.inputFile##Chr(34)#.")>
			<cfreturn local.retVal>
		<cfelse>
			<cftry>
				<cfset local.img = local.imageIO.read(local.inFile)>
				<!--- had to move these two lines into the CFTRY to catch any corrupt images where imageIO.read() returns a null value --->
				<cfset local.retVal.img = local.img>
				<cfset local.retVal.inFile = local.inFile>
				<cfcatch type="any">
					<cfset local.retval = throw("An error occurred attempting to read the specified image (#local.inputFile#).  #cfcatch.message# - #cfcatch.detail#")>
					<cfreturn local.retVal>
				</cfcatch>
			</cftry>
			<cfreturn local.retVal>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="readImageFromURL" access="private" output="true" returntype="struct" hint="Read an image from a URL.  Requires an absolute URL.">
	<cfargument name="inputURL" required="yes" type="string">
	<cfargument name="forModification" required="no" type="boolean" default="yes">

	<cfset var retVal = StructNew()>
	<cfset var img = CreateObject("java", "java.awt.image.BufferedImage")>
	<cfset var inURL	= CreateObject("java", "java.net.URL")>
	<cfset var imageIO = CreateObject("java", "javax.imageio.ImageIO")>
	
	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">


	<cfset inURL.init(arguments.inputURL)>
	<cftry>
		<cfset img = imageIO.read(inURL)>
		<cfcatch type="any">
			<cfset retval = throw("An error occurred attempting to read the specified image.  #cfcatch.message# - #cfcatch.detail#")>
			<cfreturn retVal>
		</cfcatch>
	</cftry>
	<cfset retVal.img = img>
	<cfreturn retVal>
</cffunction>

<cffunction name="writeImage" access="public" output="true" returntype="struct" hint="Write an image to disk.">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="img" required="yes" type="any">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">
	<cfset var local = arguments>
	<cfset local.retVal = StructNew()>
	<cfset local.outFile = "">
	<cfset local.filename = getFileFromPath(local.outputFile)>
	<cfset local.extension = lcase(listLast(local.filename,"."))>
	<cfset local.imageIO = createObject("java", "javax.imageio.ImageIO")>
	<cfset local.validExtensionsToWrite = arrayToList(local.imageIO.getWriterFormatNames())>
	<!--- used for jpeg output method --->
	<cfset local.out = "">
	<cfset local.fos = "">
	<cfset local.JPEGCodec = "">
	<cfset local.encoder = "">
	<cfset local.param = "">
	<cfset local.quality = javacast("float", local.jpegCompression/100)>
	<!--- TRV: not sure why we don't just write directly to the destination file --->
<!--- 	<cfset var tempOutputFile = "#variables.tempDirectory#\#createUUID()#.#extension#"> --->
	<cfset local.tempOutputFile = "#local.outputFile#">
	
	<cfset local.retVal.errorCode = 0>
	<cfset local.retVal.errorMessage = "">

	<cfif listFindNoCase(local.validExtensionsToWrite, local.extension) eq 0>
		<cfset throw("Java is unable to write #local.extension# files.  Valid formats include: #local.validExtensionsToWrite#")>
	</cfif>

	<cfif local.extension neq "jpg" and local.extension neq "jpeg">
		<!---
			Simple output method for non jpeg images
		--->
		<cfset local.outFile = createObject("java", "java.io.File")>
		<cfset local.outFile.init(local.tempOutputFile)>
		<cfset local.imageIO.write(local.img, local.extension, local.outFile)>
	<cfelse>
		<cfscript>
			/*
				JPEG output method handles compression
			*/
			local.out = createObject("java", "java.io.BufferedOutputStream");
			local.fos = createObject("java", "java.io.FileOutputStream");
			local.fos.init(local.tempOutputFile);
			local.out.init(local.fos);
			local.JPEGCodec = createObject("java", "com.sun.image.codec.jpeg.JPEGCodec");
			local.encoder = local.JPEGCodec.createJPEGEncoder(local.out);
		    local.param = local.encoder.getDefaultJPEGEncodeParam(local.img);
		    local.param.setQuality(local.quality, true);
		    local.encoder.setJPEGEncodeParam(local.param);
		    local.encoder.encode(local.img);
		    local.out.close();
		    local.fos.close(); 
		</cfscript>
	</cfif>
	<!--- move file to its final destination --->
<!--- 	<cffile action="MOVE" source="#tempOutputFile#" destination="#arguments.outputFile#"> --->
<!--- 	<cffile action="COPY" source="#tempOutputFile#" destination="#arguments.outputFile#">
	<cffile action="DELETE" file="#tempOutputFile#"> --->
	<cfreturn local.retVal>
</cffunction>

<cffunction name="flipflop" access="private" output="true" returntype="struct" hint="Internal method used for flipping and flopping images.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="direction" required="yes" type="string"><!--- horizontal or vertical --->
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var flippedImage = "">
	<cfset var rh = getRenderingHints()>
	<cfset var img = "">

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset img = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>
	<cfif img.getType() eq 0>
		<cfset img = convertImageObject(img,img.TYPE_3BYTE_BGR)>
	</cfif>	
	<cfscript>
		flippedImage = CreateObject("java", "java.awt.image.BufferedImage");
		at = CreateObject("java", "java.awt.geom.AffineTransform");
		op = CreateObject("java", "java.awt.image.AffineTransformOp");

		flippedImage.init(img.getWidth(), img.getHeight(), img.getType());

		if (direction eq "horizontal") {
			at = at.getScaleInstance(-1, 1);
			at.translate(-img.getWidth(), 0);
		} else {
			at = at.getScaleInstance(1,-1);
			at.translate(0, -img.getHeight());
		}
		op.init(at, rh);
		op.filter(img, flippedImage);

		if (outputFile eq "")
		{
			retVal.img = flippedImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, flippedImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>



<cffunction name="filterFastBlur" access="public" output="true" returntype="struct" hint="Internal method used for flipping and flopping images.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="blurAmount" required="yes" type="numeric">
	<cfargument name="iterations" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">
	<cfset var local = arguments>
	<cfset local.retVal = StructNew()>
	<cfset local.loadImage = StructNew()>
	<cfset local.saveImage = StructNew()>
	<cfset local.srcImage = "">
	<cfset local.destImage = "">
	<cfset local.rh = getRenderingHints()>

	<cfset local.retVal.errorCode = 0>
	<cfset local.retVal.errorMessage = "">

	<cfif NOT variables.javanulls>
		<cfset throw("Sorry, but the blur filter is not supported on this platform.")>
	</cfif>
	<cfif local.inputFile neq "">
		<cfset local.loadImage = readImage(local.inputFile, "NO")>
		<cfif local.loadImage.errorCode is 0>
			<cfset local.srcImage = local.loadImage.img>
		<cfelse>
			<cfset local.retVal = throw(local.loadImage.errorMessage)>
			<cfreturn local.retVal>
		</cfif>
	<cfelse>
		<cfset local.srcImage = local.objImage>
	</cfif>
	<cfif local.srcImage.getType() eq 0>
		<cfset local.srcImage = convertImageObject(local.srcImage,local.srcImage.TYPE_3BYTE_BGR)>
	</cfif>

	<cfscript>
		// initialize the blur filter
		variables.blurFilter.init(local.blurAmount);
		// move the source image into the destination image
		// so we can repeatedly blur it.
		local.destImage = local.srcImage;

		for (local.i=1; local.i lte local.iterations; local.i=local.i+1)
		{
			// do the blur i times
			local.destImage = variables.blurFilter.filter(local.destImage);
		}


		if (local.outputFile eq "")
		{
			// return the image object
			local.retVal.img = local.destImage;
			return local.retVal;
		} else {
			// write the image object to the specified file.
			local.saveImage = writeImage(local.outputFile, local.destImage, local.jpegCompression);
			if (local.saveImage.errorCode gt 0)
			{
				return local.saveImage;
			} else {
				return local.retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="filterSharpen" access="public" output="true" returntype="struct" hint="Internal method used for flipping and flopping images.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var srcImage = "">
	<cfset var destImage = "">
	<cfset var rh = getRenderingHints()>

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif NOT variables.javanulls>
		<cfset throw("Sorry, but the blur filter is not supported on this platform.")>
	</cfif>

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset srcImage = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset srcImage = objImage>
	</cfif>
	<cfif srcImage.getType() eq 0>
		<cfset srcImage = convertImageObject(srcImage,srcImage.TYPE_3BYTE_BGR)>
	</cfif>

	<cfscript>
		// initialize the sharpen filter
		variables.sharpenFilter.init();

		destImage = variables.sharpenFilter.filter(srcImage);


		if (outputFile eq "")
		{
			// return the image object
			retVal.img = destImage;
			return retVal;
		} else {
			// write the image object to the specified file.
			saveImage = writeImage(outputFile, destImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>


<cffunction name="filterPosterize" access="public" output="true" returntype="struct" hint="Internal method used for flipping and flopping images.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="amount" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var srcImage = "">
	<cfset var destImage = "">
	<cfset var rh = getRenderingHints()>

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif NOT variables.javanulls>
		<cfset throw("Sorry, but the blur filter is not supported on this platform.")>
	</cfif>

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset srcImage = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset srcImage = objImage>
	</cfif>
	<cfif srcImage.getType() eq 0>
		<cfset srcImage = convertImageObject(srcImage,srcImage.TYPE_3BYTE_BGR)>
	</cfif>
	<cfif srcImage.getType() neq 5>
		<cfset throw("ImageCFC cannot posterize this image type (#srcImage.getType()#)")>
	</cfif>
	<cfscript>
		// initialize the posterize filter
		variables.posterizeFilter.init(arguments.amount);

		destImage = variables.posterizeFilter.filter(srcImage);


		if (outputFile eq "")
		{
			// return the image object
			retVal.img = destImage;
			return retVal;
		} else {
			// write the image object to the specified file.
			saveImage = writeImage(outputFile, destImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>


<cffunction name="addText" access="public" output="true" returntype="struct" hint="Add text to an image.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="x" required="yes" type="numeric">
	<cfargument name="y" required="yes" type="numeric">
	<cfargument name="fontDetails" required="yes" type="struct">
	<cfargument name="content" required="yes" type="String">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var img = "">
	<cfset var saveImage = StructNew()>
	<cfset var g2d = "">
	<cfset var bgImage = "">
	<cfset var fontImage = "">
	<cfset var overlayImage = "">
	<cfset var Color = "">
	<cfset var font = "">
	<cfset var font_stream = "">
	<cfset var ac = "">
	<cfset var rgb = "">
	
	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfparam name="arguments.fontDetails.size" default="12">
	<cfparam name="arguments.fontDetails.color" default="black">
	<cfparam name="arguments.fontDetails.fontFile" default="">
	<cfparam name="arguments.fontDetails.fontName" default="serif">

	<cfif arguments.fontDetails.fontFile neq "" and not fileExists(arguments.fontDetails.fontFile)>
		<cfset retVal = throw("The specified font file #Chr(34)##arguments.inputFile##Chr(34)# could not be found on the server.")>
		<cfreturn retVal>
	</cfif>
	<cftry>
		<cfset rgb = getRGB(arguments.fontDetails.color)>
		<cfcatch type="any">
			<cfset retVal = throw("Invalid color #Chr(34)##arguments.fontDetails.color##Chr(34)#")>
			<cfreturn retVal>
		</cfcatch>
	</cftry>
	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset img = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset img = objImage>
	</cfif>
	<cfif img.getType() eq 0>
		<cfset img = convertImageObject(img,img.TYPE_3BYTE_BGR)>
	</cfif>
	<cfscript>
		// load objects
		bgImage = CreateObject("java", "java.awt.image.BufferedImage");
		fontImage = CreateObject("java", "java.awt.image.BufferedImage");
		overlayImage = CreateObject("java", "java.awt.image.BufferedImage");
		Color = CreateObject("java","java.awt.Color");
		font = createObject("java","java.awt.Font");
		font_stream = createObject("java","java.io.FileInputStream");
		ac = CreateObject("Java", "java.awt.AlphaComposite");
	
		// set up basic needs
		fontColor = Color.init(javacast("int", rgb.red), javacast("int", rgb.green), javacast("int", rgb.blue));

		if (fontDetails.fontFile neq "")
		{
			font_stream.init(arguments.fontDetails.fontFile);
			font = font.createFont(font.TRUETYPE_FONT, font_stream);
			font = font.deriveFont(javacast("float",arguments.fontDetails.size));
		} else {
			font.init(fontDetails.fontName, evaluate(fontDetails.style), fontDetails.size);
		}
		// get font metrics using a 1x1 bufferedImage
		fontImage.init(1,1,img.getType());
		g2 = fontImage.createGraphics();
		g2.setRenderingHints(getRenderingHints());
		fc = g2.getFontRenderContext();
		bounds = font.getStringBounds(content,fc);
		
		g2 = img.createGraphics();
		g2.setRenderingHints(getRenderingHints());
		g2.setFont(font);
		g2.setColor(fontColor);
		// in case you want to change the alpha
		// g2.setComposite(ac.getInstance(ac.SRC_OVER, 0.50));

		// the location (arguments.fontDetails.size+y) doesn't really work
		// the way I want it to.
		g2.drawString(content,javacast("int",x),javacast("int",arguments.fontDetails.size+y));
		
		if (outputFile eq "")
		{
			retVal.img = img;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, img, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="watermark" access="public" output="false">
	<cfargument name="objImage1" required="yes" type="Any">
	<cfargument name="objImage2" required="yes" type="Any">
	<cfargument name="inputFile1" required="yes" type="string">
	<cfargument name="inputFile2" required="yes" type="string">
	<cfargument name="alpha" required="yes" type="numeric">
	<cfargument name="placeAtX" required="yes" type="numeric">
	<cfargument name="placeAtY" required="yes" type="numeric">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var originalImage = "">
	<cfset var wmImage = "">
	<cfset var saveImage = StructNew()>
	<cfset var ac = "">
	<cfset var rh = getRenderingHints()>

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif inputFile1 neq "">
		<cfset loadImage = readImage(inputFile1, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset originalImage = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset originalImage = objImage1>
	</cfif>
	<cfif originalImage.getType() eq 0>
		<cfset originalImage = convertImageObject(originalImage,originalImage.TYPE_3BYTE_BGR)>
	</cfif>

	<cfif inputFile2 neq "">
		<cfset loadImage = readImage(inputFile2, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset wmImage = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
	<cfelse>
		<cfset wmImage = objImage2>
	</cfif>
	<cfif wmImage.getType() eq 0>
		<cfset wmImage = convertImageObject(wmImage,wmImage.TYPE_3BYTE_BGR)>
	</cfif>


	<cfscript>
		at = CreateObject("java", "java.awt.geom.AffineTransform");
		op = CreateObject("java", "java.awt.image.AffineTransformOp");
		ac = CreateObject("Java", "java.awt.AlphaComposite");
		gfx = originalImage.getGraphics();
		gfx.setComposite(ac.getInstance(ac.SRC_OVER, alpha));
		
		at.init();
		// op.init(at,op.TYPE_BILINEAR);
		op.init(at, rh);
		
		gfx.drawImage(wmImage, op, javaCast("int",arguments.placeAtX), javacast("int", arguments.placeAtY));

		gfx.dispose();

		if (outputFile eq "")
		{
			retVal.img = originalImage;
			return retVal;
		} else {
			saveImage = writeImage(outputFile, originalImage, jpegCompression);
			if (saveImage.errorCode gt 0)
			{
				return saveImage;
			} else {
				return retVal;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="isURL" access="private" output="false" returnType="boolean">
	<cfargument name="stringToCheck" required="yes" type="string">
	<cfif REFindNoCase("^(((https?:)\/\/))[-[:alnum:]\?%,\.\/&##!@:=\+~_]+[A-Za-z0-9\/]$",stringToCheck) NEQ 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<!--- function returns RGB values in a structure for hex or the 16
	HTML named colors --->
<cffunction name="getRGB" access="private" output="true" returnType="struct">
	<cfargument name="color" type="string" required="yes">

	<cfset var retVal = structNew()>
	<cfset var cnt = 0>
	<cfset var namedColors = "aqua,black,blue,fuchsia,gray,green,lime,maroon,navy,olive,purple,red,silver,teal,white,yellow">
	<cfset var namedColorsHexValues = "00ffff,000000,0000ff,ff00ff,808080,008000,00ff00,800000,000080,808080,ff0000,c0c0c0,008080,ffffff,ffff00">

	<cfset retVal.red = 0>
	<cfset retVal.green = 0>
	<cfset retVal.blue = 0>
	
	<cfset arguments.color = trim(arguments.color)>
	<cfif len(arguments.color) is 0>
		<cfreturn retVal>
	<cfelseif listFind(namedColors, arguments.color) gt 0>
		<cfset arguments.color = listGetAt(namedColorsHexValues, listFind(namedColors, arguments.color))>
	</cfif>
	<cfif left(arguments.color,1) eq "##">
		<cfset arguments.color = right(arguments.color,len(arguments.color)-1)>
	</cfif>
	<cfif len(arguments.color) neq 6>
		<cfreturn retVal>
	<cfelse>
		<cftry>
			<cfset retVal.red = InputBaseN(mid(arguments.color,1,2),16)>
			<cfset retVal.green = InputBaseN(mid(arguments.color,3,2),16)>
			<cfset retVal.blue = InputBaseN(mid(arguments.color,5,2),16)>
			<cfcatch type="any">
				<cfset retVal.red = 0>
				<cfset retVal.green = 0>
				<cfset retVal.blue = 0>
				<cfreturn retVal>
			</cfcatch>
		</cftry>
	</cfif>
	<cfreturn retVal>
</cffunction>

<cffunction name="throw" access="private" output="false" returnType="struct">
	<cfargument name="detail" type="string" required="yes">
	<cfargument name="force" type="boolean" required="no" default="no">

	<cfset var retVal = StructNew()>
	
	<cfif variables.throwOnError or arguments.force>
		<cfthrow detail="#arguments.detail#" message="#arguments.detail#">
	<cfelse>
		<cfset retVal.errorCode = 1>
		<cfset retVal.errorMessage = arguments.detail>
		<cfreturn retVal>
	</cfif>
</cffunction>

<cffunction name="debugDump" access="private">
	<cfdump var="#arguments#"><cfabort>
</cffunction>

<cffunction name="convertImageObject" access="private" output="false" returnType="any">
	<cfargument name="bImage" type="Any" required="yes">
	<cfargument name="type" type="numeric" required="yes">
	<cfset var local = arguments>

	<cfscript>
	// convert the image to a specified BufferedImage type and return it

	local.width = local.bImage.getWidth();
	local.height = local.bImage.getHeight();
	local.newImage = ImageGetBufferedImage(ImageNew(local.bImage));

// TRV: the following commented code seems to work fine outside of Windows, but seems to hang on windows - replacing with the new method above instead, which seems to accomplish the same thing.
/*
	var newImage = createObject("java","java.awt.image.BufferedImage").init(javacast("int",width), javacast("int",height), javacast("int",type));
	// int[] rgbArray = new int[width*height];
	var rgbArray = variables.arrObj.newInstance(variables.intClass, javacast("int",width*height));

	bImage.getRGB(
		javacast("int",0), 
		javacast("int",0), 
		javacast("int",width), 
		javacast("int",height), 
		rgbArray, 
		javacast("int",0), 
		javacast("int",width)
		);
	newImage.setRGB(
		javacast("int",0), 
		javacast("int",0), 
		javacast("int",width), 
		javacast("int",height), 
		rgbArray, 
		javacast("int",0), 
		javacast("int",width)
		);
*/

	return local.newImage;
	</cfscript>	

</cffunction>

<cffunction name="getBlurConstants" access="public" output="false" returntype="struct">
	<cfargument name="image">
	<cfargument name="targetheight">
	<cfargument name="targetwidth">
	<cfargument name="bIsStepResize" required="false" default="false">
	<cfset var local = arguments>
	
	<cfscript>
		if (not arguments.bIsStepResize)
		{
			// get the original height & width
			//imageCFC = createObject("component", "imagecfc.image");
			local.origImage = getImageInfo(local.image,"");
			
			// figure out if we need to get scale by height or width
			if (local.targetheight NEQ 0) {
				local.factor = local.targetheight / local.origImage.height;
			} else if (local.targetwidth NEQ 0) {
				local.factor = local.targetwidth / local.origImage.width;
			} else {
				if (local.targetwidth / local.origImage.width GT local.targetheight / local.origImage.height) {
					local.factor = local.targetheight / local.origImage.height;
				} else {
					local.factor = local.targetwidth / local.origImage.width;
				}
			}
			
			// if the source was less than 200px wide, don't blur
			if (local.origImage.width LT 200 AND local.targetheight GT 65) {
				local.factor = 1;
			}
		}
		else
		{
			local.factor = 1;
		}
		
		local.blurMe = structNew();
	</cfscript>
	
	<cfif local.factor gt .9>
		<cfset local.blurMe.amount = 0>
		<cfset local.blurMe.times = 0>
	<cfelseif local.factor gt .7>
		<cfset local.blurMe.amount = 2>
		<cfset local.blurMe.times = 2>
	<cfelseif local.factor gt .5>
		<cfset local.blurMe.amount = 2>
		<cfset local.blurMe.times = 3>
	<cfelseif local.factor gt .3>
		<cfset local.blurMe.amount = 2>
		<cfset local.blurMe.times = 4>
	<cfelseif local.factor gt .1>
		<cfset local.blurMe.amount = 4.9>
		<cfset local.blurMe.times = 4>
	<cfelse>
		<cfset local.blurMe.amount = 3>
		<cfset local.blurMe.times = 3>
	</cfif>
	
	<cfreturn local.blurMe>
</cffunction>

</cfcomponent>

