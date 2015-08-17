<cfcomponent displayname="Data Object Serialiser" hint="This CFC handles the serialisation of CFC objects for transfer between ColdFusion applications">
	
    <cffunction name="init" returntype="serialiser">
    	<cfreturn this>
    </cffunction>
    
	<cffunction name="serialize" access="public" returntype="string" output="false" hint="Serializes a given variable to a string">
		<cfargument name="input" type="any" required="true"/>
		
		<cfreturn ToBase64(serializeToBinary(input))>
	</cffunction>
	
	<cffunction name="serializeToBinary" access="public" returntype="any" output="false" hint="Serializes a given variable to a binary value">
		<cfargument name="input" type="any" required="true"/>
		
		<cfscript>
			var byteOut = CreateObject("java", "java.io.ByteArrayOutputStream");
			var objOut  = CreateObject("java", "java.io.ObjectOutputStream");
			
			byteOut.init();
			objOut.init(byteOut);
			objOut.writeObject(arguments.input);
			objOut.close();

			return byteOut.toByteArray();
		</cfscript>
		
	</cffunction>
	
	<cffunction name="deserialize" access="public" returntype="Any" output="false" hint="Deserializes a string to it's original variable">
		<cfargument name="input" type="string" required="true"/>

		<cfreturn deserializeFromBinary(toBinary(input))>
	</cffunction>
	
	<cffunction name="deserializeFromBinary" access="public" returntype="Any" output="false" hint="Deserializes a string to it's original variable">
		<cfargument name="input" type="any" required="true"/>
		
		<cfscript>
			var byteIn = CreateObject("java", "java.io.ByteArrayInputStream");
			var objIn  = CreateObject("java", "java.io.ObjectInputStream");
			
			byteIn.init(arguments.input);
			objIn.init(byteIn);
			
			return objIn.readObject();
		</cfscript>
	</cffunction>

	<cffunction name="CFObjectToXML" access="public" returntype="string" output="false" hint="Converts any CFC object into an XML string">
		<cfargument name="cfObj" type="any" required="true" hint="The object to be converted"/>
	 	<cfargument name="objName" type="string" required="false" hint="The object / attribute name" default="object"/>
	 
	 	<cfscript>
			var xmlString 	= '';
			var i 			= 0;
			var errorMsg	= 0;
			
			try
			{
				if (isArray(cfObj))
				{
					xmlString &= '<#arguments.objName# type="array">';
					
					for (i=1; i <= arrayLen(cfObj);i++)
						if (isDate(cfObj[i]))
							xmlString &= '<item type="date">' & xmlFormat(cfObj[i]) & '</item>';
						else if (isSimpleValue(cfObj[i]))
							xmlString &= '<item>' & xmlFormat(cfObj[i]) & '</item>';
						else
							xmlString &= CFObjectToXML(cfObj[i],'item');
				}
				else
				{
					xmlString &= '<#arguments.objName# type="#getMetaData(cfObj).name#">';
					
					for (i in cfObj)
						if (isDate(cfObj[i]))
							xmlString &= '<#lcase(i)# type="date">' & xmlFormat(cfObj[i]) & '</#lcase(i)#>';
						else if (isSimpleValue(cfObj[i]))
							xmlString &= '<#lcase(i)#>' & xmlFormat(cfObj[i]) & '</#lcase(i)#>';
						else
							xmlString &= CFObjectToXML(cfObj[i],lcase(i));
				}
				xmlString &= '</#arguments.objName#>';
				
				return xmlString;
			}
			catch(Any e)
			{
				// Do your own error trapping / logging here...
			}
		</cfscript>
	
	</cffunction>
	
	<cffunction name="XMLToCFObject" access="public" returntype="any" output="false" hint="Converts an XML string into an internal CFC object">
		<cfargument name="xmlString" type="any" required="true" hint="The XML to be converted back to our object"/>
		
	 	<cfscript>
		 	var i 			= 0;
			var CFObject 	= 0;
		 	var xmlObj		= 0;
			var errorMsg	= 0;

		 	try
		 	{
			 	 xmlObj	= xmlParse(arguments.xmlString);
				
				if (structKeyExists(xmlObj,'object'))
				{
					CFObject = XMLObjectToCFObject(xmlObj.object);
					return CFObject;
				}
				// else drop through to error handler
			}
			catch(Any e)
			{
				// drop through to error handler
			}
		
			// Do your own error trapping / logging here...
			
			return -1;
		</cfscript>
	
	</cffunction>
	
	<cffunction name="XMLObjectToCFObject" access="public" returntype="any" output="false" hint="Converts an XML object into an internal CFC object">
		<cfargument name="xmlObject" type="xml" required="true" hint="The XML object to be converted back to our object"/>
	 
	 	<cfscript>
		 	var cfObj 		= 0;
		 	var i			= 0;
			var errorMsg	= 0;
			
		 	try
		 	{
				if (structKeyexists(xmlObject.xmlAttributes,'type'))
				{
					switch(xmlObject.xmlAttributes.type)
					{
						case 'array':
						{
							cfObj = arrayNew(1);
							
							for (i=1;i <= arrayLen(xmlObject.xmlChildren);i++)
							{
								if (structKeyexists(xmlObject.xmlChildren[i].xmlAttributes,'type'))
								{
									if (xmlObject.xmlChildren[i].xmlAttributes.type == 'date')
										cfObj[i] = parseDateTime(xmlObject.xmlChildren[i].xmlText);
									else
										cfObj[i] = XMLObjectToCFObject(xmlObject.xmlChildren[i]);
								}
								else
									cfObj[i] = xmlObject.xmlChildren[i].xmlText;
							}
					
							break;
						}
						
						case 'date':
						{
							cfObj = parseDateTime(xmlObject.xmlText);
							break;
						}
						
						default:
						{
							cfObj = createObject("component",xmlObject.xmlAttributes.type);
							
							for (i=1;i <= arrayLen(xmlObject.xmlChildren);i++)
							{
								if (structKeyExists(xmlObject.xmlChildren[i].xmlAttributes,'type'))
								{
									if (xmlObject.xmlChildren[i].xmlAttributes.type == 'date')
										cfObj[xmlObject.xmlChildren[i].xmlName] = parseDateTime(xmlObject.xmlChildren[i].xmlText);
									else
										cfObj[xmlObject.xmlChildren[i].xmlName] = XMLObjectToCFObject(xmlObject.xmlChildren[i]);
								}
								else
									cfObj[xmlObject.xmlChildren[i].xmlName] = xmlObject.xmlChildren[i].xmlText;
							}
						}
					}
					
					return cfObj;
				}
				// else drop through to error handler
			}
			catch(Any e)
			{
				// Just drop through to terror handler
			}
			
			// Do your own error trapping / logging here...

			return -1;
		</cfscript>
	
	</cffunction>
</cfcomponent>