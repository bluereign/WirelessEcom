	<!---
	*****************************************************
	Name: 				environment.cfc
	Description:		Main Component for Environment Configurator
	Authors:			Rolando Lopez
						roland@soft-itech.com
						www.rolando-lopez.com/tech
	Past Contributors:  Rob Gonda; Tom DeManincor; Paul Marcotte
	Date:				2007

	*****************************************************
	License: 	Copyright 2007 Rolando Lopez (www.rolando-lopez.com) 
				Licensed under the Apache License, Version 2.0 (the "License"); 
				you may not use this file except in compliance with the License.
				You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 
				Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, 
				WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
				See the License for the specific language governing permissions and limitations under the License. 		
	--->

<cfcomponent name="environment" displayName="environment" hint = "I handle environment properties" extends="Object" >

		<!---
		*************************************************************************
		Init
		************************************************************************
		--->

	<cffunction name = "init" returntype = "environment" output = "No" hint = "I initialize the component" access="public">
		<cfargument name = "xmlFile" type = "string" required = "true"  />
		<cfscript>
			var theFile = '';
		</cfscript>

		<cftry>
			<cffile action="read" file="#expandPath( arguments.xmlFile )#" variable="theFile">
			<cfcatch type = "any" >
				<cfthrow type="configGlobal.fileNotFound" message="unable to find xmlFile" />
			</cfcatch>
		</cftry>

		<cfif not isXML( theFile )>
			<cfthrow type="configGlobal.notXml" message="#arguments.xmlFile# is not in valid XML format" />
		</cfif>
		<cftry>
			<cfscript>
				variables.instance = structNew();
				variables.instance.environmentXml  	= xmlParse( theFile );
			</cfscript>
			<cfcatch type="any">
				<cfthrow type="configGlobal.xmlParseError" message="Error Parsing XML file #arguments.xmlFile# ">
			</cfcatch>
		</cftry>

		<cfreturn this />
	</cffunction>

		<!---
		**********************************************************************************
		getEnvironmentById
		Author: rolando.lopez - Date: 5/29/2007
		**********************************************************************************
		 --->

	<cffunction name = "getEnvironmentById" access = "public" output = "false" returntype = "struct">
		<cfargument name = "environmentID" type = "string" required = "true"  />

		<cfscript>
			var properties = structnew();
			var defaultEnvironment = '';
			var defaultPropertiesArray = arrayNew(1);
			var targetEnvironment = '';
			var targetPropertiesArray = arrayNew(1);
			var targetStruct = structNew();
			var ixKey = '';
			var aTemp = arrayNew(1);
			//Vars end

			defaultEnvironment	= xmlSearch( getXmlFile(), '/environments/default/' );
			targetEnvironment	= xmlSearch( getXmlFile(), '/environments/environment[@id="#arguments.environmentID#"]/' );
		</cfscript>

			<!--- validation --->

		<cfif not arrayLen( targetEnvironment ) >
			<cfthrow errorcode="icg.configGlobal.emptyArray" message="Attempted to evaluate an empty array of name selectedElem.">
		<cfelseif arrayLen( targetEnvironment[1].xmlChildren ) lte 1>
			<cfthrow errorcode="icg.configGlobal.missingArrayElement" message="Element 2 does not exists in array of name xmlChildren.">
		</cfif>
		<cftry>
		<cfscript>
			defaultPropertiesArray = defaultEnvironment[1].XmlChildren[1].XmlChildren;
			targetPropertiesArray = targetEnvironment[1].XmlChildren[2].XmlChildren;

			structAppend(properties,getArrayProperties(defaultPropertiesArray),false);
			targetStruct = getArrayProperties(targetPropertiesArray);
			for( ixKey in targetStruct ){
				if( not isStruct( targetStruct[ixKey] )){
					properties[ixKey] = targetStruct[ixKey];
				}
				else{
					if(not structKeyExists( properties, ixKey ))
						properties[ixKey] = structNew();
					structAppend( properties[ixKey], targetStruct[ixKey], true);
				}
			}
			populateVariablesWithValues(properties);
			properties = parseStructForCFMOutput(duplicate(properties));
			properties["environmentID"] = arguments.environmentID;
			//structAppend(properties,getArrayProperties(targetPropertiesArray),true);
		</cfscript>

		<cfcatch type = "any" >
			<cfscript>
				//dump( cfcatch, true );
				ethrow(  'Failed to: get environment by id ','environmentConfig.getEnvironmentById' );
			</cfscript>
		</cfcatch>
		</cftry>
		<cfreturn properties />
	</cffunction>

		<!---
		**********************************************************************************
		getEnvironmentByUrl
		Author: roland lopez - Date: 5/29/2007
		**********************************************************************************
		 --->

	<cffunction name = "getEnvironmentByUrl" access = "public" output = "false" returntype = "struct">
		<cfargument name = "serverName" type = "string" required = "true"  />
		<cfscript>
			var propertiesArray	= arrayNew(1);
			var i = 0;
			var j = 0;
			var k = 0;
			var environmentUrl = '';
				//end of vars


			propertiesArray = xmlSearch( getXmlFile(), '/environments/environment' );

		</cfscript>

		<cfscript>
			if( isArray( propertiesArray )){
				for(i=1; i lte arrayLen( propertiesArray ); i=i+1){
					if( isArray( propertiesArray[i].xmlChildren )){

						for(j=1; j lte arrayLen(propertiesArray[i].xmlChildren); j=j+1 ){
							if( propertiesArray[i].xmlChildren[j].xmlName eq 'patterns'){
								for( k=1; k lte arrayLen( propertiesArray[i].xmlChildren[j].xmlChildren); k=k+1){

									environmentUrl = propertiesArray[i].xmlChildren[j].xmlChildren[k].xmlText;
									if( refindnocase( environmentUrl, arguments.serverName ))
										return getEnvironmentById( propertiesArray[i].xmlAttributes.id );
								}
							}
						}
					}
				}
			}
		</cfscript>
		<cfreturn structNew() />
	</cffunction>

		<!---
		**********************************************************************************
		getArrayProperties
		Author: paul marcotte - Date: 3/27/2008
		**********************************************************************************
		 --->

	<cffunction name="getArrayProperties" access="private" output="false" returntype="struct">
		<cfargument name="propArray" type="array" required="true">
		<cfscript>
			var i = 0;
			var j = 0;
			var value = "";
			var entriesArray = arraynew(1);
			var properties = structNew();
			var propertiesArray = arguments.propArray;

		</cfscript>
		<cfscript>
			//Vars end
			for( i = 1; i lte arrayLen( propertiesArray ); i = i+1 ){
				entriesArray = xmlsearch(propertiesArray[i],'map/entry');
				if (arraylen(entriesArray))
				{
					value = structnew();
					for (j = 1; j lte ArrayLen(entriesArray); j = j + 1)
					{
						value[entriesArray[j].XmlAttributes["key"]] = entriesArray[j].value.XmlText;
					}
				}
				else
				{
					value = trim(propertiesArray[i].XmlText);
				}
				properties[ propertiesArray[i].XmlAttributes.name ] = value;
			}
			return properties;
		</cfscript>
	</cffunction>


		<!---
		**********************************************************************************
		getXmlFile
		Author: roland lopez - Date: 5/29/2007
		**********************************************************************************
		 --->

	<cffunction name = "getXmlFile" access = "public" output = "false" returntype = "xml">
		<cfreturn variables.instance.environmentXml />
	</cffunction>
	<!---
		********************************************************************************
		parseCFMOutput()
		@Author: Rolando Lopez
		@Date: 5/11/2009
		@Hint: I parse text with pound signs (#) and evaluate it as CF output
		@Access: private
		********************************************************************************
		--->
	<cffunction name="parseCFMOutput" output="false" access="private" returntype="any" hint="I parse text with pound signs (##) and evaluate it as CF output">
		<cfargument name="inputString" type="string" required="true" />
		<cfscript>
			var stl 	= structNew();
			var ixPounds = 1;
			stl.aPounds = arrayNew(1);
			stl.poundsCount = 0;
			
			stl.stringToReplace = "";
		</cfscript>

		<cftry>
			<cfscript>
				stl.aPounds = reMatchNoCase("##{1}",inputString);
				stl.poundsCount = arrayLen(stl.aPounds);
				stl.removeStartPos = find("##",inputString);
				if(stl.removeStartPos > 1)
					stl.tokenPosStart	= 2;
				else
					stl.tokenPosStart	= 1;
				//stl.removeStartPos = 2;
				if(stl.poundsCount MOD 2 NEQ 0)
					ethrow( "Invalid pound sign found in string" & inputString &". A matching end pound is required or you need to escape the pound sign." );

				for(ixPounds; ixPounds <= stl.poundsCount; ixPounds++){
					stl.stringToReplace = getToken(inputString,stl.tokenPosStart,"##");
					//writeDump(var:stl,output:"console",format:"text");
					if(len(trim(stl.stringToReplace)))
						inputString = replace(inputString,"##"&stl.stringToReplace&"##",evaluate(stl.stringToReplace),"ALL");
					else
						inputString = replace(inputString,"##"&stl.stringToReplace&"##","##","ALL");
					stl.tokenPosStart = 2;
				}
			</cfscript>
			<cfcatch type="any">
				<cfscript>
					//dump( cfcatch, true );
					ethrow(  'Failed to: I parse text with pound signs (##) and evaluate it as CF output ','environmentConfig.parseCFMOutput' );
				</cfscript>
			</cfcatch>
		</cftry>
		<cfreturn inputString />
	</cffunction>

		<!---
		********************************************************************************
		parseStructForCFMOutput()
		@Author: Rolando Lopez
		@Date: 5/12/2009
		@Hint: Loop over struct elements and parse them for CFM output
		@Access: private
		********************************************************************************
		--->
	<cffunction name="parseStructForCFMOutput" output="false" access="private" returntype="struct" hint="Loop over struct elements and parse them for CFM output">
		<cfargument name="inputStruct" type="struct" required="true" />
		<cfscript>
			var ixKey = "";
			var ixKey2= "";
			var stTmp = structNew();
		</cfscript>

			<cfscript>
				for (ixKey in inputStruct){
					if(not isStruct( inputStruct[ixKey] ))
						inputStruct[ixKey]=parseCFMOutput(inputStruct[ixKey]);
					else{
						stTmp = inputStruct[ixKey];
						for (ixKey2 in stTmp){
							stTmp[ixKey2]=parseCFMOutput(toString(stTmp[ixKey2]));

						}
					}
				}
			</cfscript>
		<cfreturn inputStruct />
	</cffunction>

		<!---
		********************************************************************************
		populateVariablesWithValues()
		@Author: Rolando Lopez
		@Date: 5/12/2009
		@Hint: I parse a structure looking for environment variables and replace the variables with the string values
		@Access: private
		********************************************************************************
		--->
		
	<cffunction name="populateVariablesWithValues" output="false" access="private" returntype="void" hint="I parse a structure looking for environment variables and replace the variables with the string values">
		<cfargument name="inputStruct" type="struct" required="true" hint="pass by reference" />
		<cfargument name="subStruct" type="struct" required="false" />	
		<cfscript>
			var stl 	= structNew();
			stl.regex 	= "\$\{{1}([_a-zA-Z0-9]+)\}{1}";
			stl.regexReturn = structNew();
			stl.stTemp  = structNew();
		</cfscript>

		<cftry>
			<cfscript>
				for (ixKey in arguments.inputStruct){
					if(not isStruct( arguments.inputStruct[ixKey] )){
							replaceVariables(stl.regex,arguments.inputStruct,ixKey);
					}else{
						stl.stTemp = arguments.inputStruct[ixKey];
						for (ixKey2 in stl.stTemp){
							replaceVariables(stl.regex,arguments.inputStruct,ixKey2);
						}
					}
				}
			</cfscript>
			<cfcatch type="any">
				<cfscript>
					//dump( cfcatch, true );
					ethrow(  'Failed to: parse a structure looking for environment variables and replace the variables with the string values ','environmentConfig.populateVariablesWithValues' );
				</cfscript>
			</cfcatch>
		</cftry>
	</cffunction>
	
		<!---
    	******************************************************************************** 
    	replaceVariables()
    	@Author: Rolando Lopez 
    	@Date: 9/19/2010 
    	@Hint: Replaces EC variables ${x} with the appropriate value. If a variable is not found an error is thrown
    	@Access: private
    	********************************************************************************
    	--->
		<!--- @todo: replace this entire method below for something more efficient. --->
    <cffunction name="replaceVariables" output="false" access="private" returntype="void" hint="Replaces EC variables ${x} with the appropriate value. If a variable is not found an error is thrown">
		<cfargument name="regexTest" type="string" required="true" />
		<cfargument name="inputStruct" type="struct" required="true" />
		<cfargument name="structKey" type="string" required="true" />
    	<cfscript>	
    		var stl = structNew();
			var ix	= 2;

    		try{
				stl.foundKey	= structFindKey(inputStruct, arguments.structKey);
				stl.counter=0;
				stl.regexReturn = refind(arguments.regexTest,stl.foundKey[1].value,1,true);
				
				while(stl.regexReturn["len"][1] >0){
					stl.varName = mid(stl.foundKey[1].owner[listLast(stl.foundKey[1].path,'.')],stl.regexReturn["pos"][ix],stl.regexReturn["len"][ix]);
					stl.aVarValue = structFindKey(arguments.inputStruct,stl.varName);
					if(arrayLen(stl.aVarValue)){
						replaceVariables(arguments.regexTest,arguments.inputStruct,stl.varName);
						if(listLen(stl.foundKey[1].path,'.') gt 1){
							stl.ownerStruct = evaluate("arguments.inputStruct#listDeleteAt(stl.foundKey[1].path,listLen(stl.foundKey[1].path,'.'),'.')#");
							stl.ownerStruct[listLast(stl.foundKey[1].path,'.')] = replaceNoCase(stl.foundKey[1].value,"${"&stl.varName&"}",stl.aVarValue[1].value,"ALL");
						}else							
							arguments.inputStruct[right(stl.foundKey[1].path,len(stl.foundKey[1].path)-1)] = replaceNoCase(stl.foundKey[1].value,"${"&stl.varName&"}",stl.aVarValue[1].value,"ALL");
						stl.foundKey	= structFindKey(inputStruct, listLast(stl.foundKey[1].path,'.'));
						stl.regexReturn = refind(arguments.regexTest,stl.foundKey[1].value,1,true);
						stl.counter++;
					}
					else{
						//dump("ERROR: Variable '" & arguments.structKey & "' does not exist.",false);
						ethrow("ERROR: Variable '" & arguments.inputStruct[arguments.structKey] & "' does not exist.");
					}
						
				}
    		}catch(any e){
				dump(arguments);
				dump(stl);
    			dump( e, false);
    			ethrow(  'Failed to: Replaces EC variables ${x} with the appropriate value. If a variable is not found an error is thrown ','replaceVariables' );
    		}	
    	</cfscript>
    </cffunction>
</cfcomponent>