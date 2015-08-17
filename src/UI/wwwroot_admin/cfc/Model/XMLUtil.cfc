<cfcomponent displayname="xmlutil">

      
 	<cffunction name="init" returntype="xmlutil">	
		<cfreturn this />
	</cffunction>

      <!--- Given a complete XML object, returns the root element object. --->

       <cffunction name="getRootElement" access="public" returntype="string" hint="Given a complete XML object, returns the root element object.">

              <cfargument name="passedXMLElement">

              <cfif isXMLRoot( evaluate( 'arguments.passedXMLElement.#structKeyList( arguments.passedXMLElement )#' ) )>

                     <cfreturn evaluate( 'arguments.passedXMLElement.#structKeyList( arguments.passedXMLElement )#' )>

              </cfif>

       </cffunction>

      

      <!--- Returns true if passed element has child elements. --->

       <cffunction name="hasXMLChildren" hint="Returns true if passed element has child elements.">

              <cfargument name="passedXMLElement">

              <cfif isDefined( "passedXMLElement.xmlChildren" ) and isArray( passedXMLElement.xmlChildren ) and arrayLen( passedXMLElement.xmlChildren )>

                     <cfreturn true>

              <cfelse>

                     <cfreturn false>

              </cfif>

       </cffunction>

      

      <!--- Returns the number of child elements of the passed element. --->

       <cffunction name="getXMLChildCount" hint="Returns the number of child elements of the passed element.">

              <cfargument name="passedXMLElement">

              <cfreturn arrayLen( passedXMLElement.xmlChildren )>

       </cffunction>

      

      <!--- Returns the specified child element of the passed element. --->

       <cffunction name="getXMLChildElement" hint="Returns the specified child element of the passed element.">

              <cfargument name="passedXMLElement">

              <cfargument name="childElementPosition">

              <cfreturn passedXMLElement.xmlChildren[childElementPosition]>

       </cffunction>

      

      <!--- Returns true if passed element has attributes. --->

       <cffunction name="hasXMLAttributes" hint="Returns true if passed element has attributes.">

              <cfargument name="passedXMLElement">

              <cfif isDefined( "passedXMLElement.xmlAttributes" ) and isStruct( passedXMLElement.xmlAttributes ) and structCount( passedXMLElement.xmlAttributes )>

                     <cfreturn true>

              <cfelse>

                     <cfreturn false>

              </cfif>

       </cffunction>

      

      <!--- Returns the attributes of the passed element. --->

       <cffunction name="getXMLAttributes" hint="Returns the attributes of the passed element.">

              <cfargument name="passedXMLElement">

              <cfreturn passedXMLElement.xmlAttributes>

       </cffunction>

      

      <!--- Returns the specified attribute from the passed attributes structure. --->

       <cffunction name="getXMLAttributeValue" hint="Returns the specified attribute from the passed attributes structure.">

              <cfargument name="attributesStruct">

              <cfargument name="attributeName">

              <cfreturn evaluate( 'attributesStruct.#attributeName#' )>

       </cffunction>

      

      <!--- Returns true if the passed element contains an element with the specified name. --->

       <cffunction name="hasXMLElementName" hint="Returns true if the passed element contains an element with the specified name.">

              <cfargument name="passedXMLElement">

              <cfif isDefined( 'passedXMLElement.xmlName' )>

                     <cfreturn true>

              <cfelse>

                     <cfreturn false>    

              </cfif>

       </cffunction>

      

      <!--- Returns the specified element from the passed XML element. --->

       <cffunction name="getXMLElementName" access="public" returntype="string" hint="Returns the specified element from the passed XML element.">

              <cfargument name="passedXMLElement">

              <cfreturn passedXMLElement.xmlName>

       </cffunction>

      

      <!--- Returns true if the passed element has XML text. --->

       <cffunction name="hasXMLElementText" access="public" returntype="boolean" hint="Returns true if the passed element has XML text.">

              <cfargument name="passedXMLElement">

              <cfif isDefined( 'passedXMLElement.xmlText' ) and len( trim( passedXMLElement.xmlText ) )>

                     <cfreturn true>

              <cfelse>

                     <cfreturn false>    

              </cfif>

       </cffunction>

      

      <!--- Returns the XML text of the passed element. --->

       <cffunction name="getXMLElementText" access="public" returntype="string" hint="Returns the XML text of the passed element.">

              <cfargument name="passedXMLElement">

              <cfreturn passedXMLElement.xmlText>

       </cffunction>

      

      <!--- Returns true if the name of the passed element is found in the passed element name filter list. --->

       <cffunction name="isElementNameInFilterList" access="private" returntype="boolean" hint="Returns true if the name of the passed element is found in the passed element name filter list.">

              <cfargument name="elementNameFilterList">

              <cfargument name="passedXMLElement">

              <cfreturn listFindNoCase( arguments.elementNameFilterList, getXMLElementName( arguments.passedXMLElement ) )>

       </cffunction>

      

      <!--- Returns true if the passed element name filter list is empty. --->

       <cffunction name="isEmptyFilterList" access="private" returntype="boolean" hint="Returns true if the passed element name filter list is empty.">

              <cfargument name="elementNameFilterList" type="string">

              <cfif not listLen(arguments.elementNameFilterList )>

                     <cfreturn true>

              <cfelse>

                     <cfreturn false>    

              </cfif>

       </cffunction>

      

      <!--- Function to iterate through the XML Object. --->
		
      <cffunction name="recurseXMLObject" access="public" output="no" returntype="array" hint="Function to iterate through the XML Object.">
              <cfargument name="passedXMLElement">
              <cfargument name="parentId" default="">
              <cfargument name="elementNameFilterList" default="">
              <cfargument name="depth" default="0">
		
			  <cfset var local = structNew()>
              
              <cfparam name="resultArray" default="#arrayNew(1)#">
              <cfset depth = arguments.depth>
			  
              <cfset local.id = CreateUUID()>
              <cfset local.parentId = arguments.parentId>


              <!--- If the current node has an XML Element Name that the user wants, capture it along with the current XML node's depth in the XML tree. --->
              <cfif hasXMLElementName( arguments.passedXMLElement ) and ( isEmptyFilterList( arguments.elementNameFilterList ) or isElementNameInFilterList( arguments.elementNameFilterList, arguments.passedXMLElement ) )>
                     <cfset arrayAppend( resultArray, structNew() )>
                     <cfset structInsert( resultArray[ arrayLen( resultArray ) ], 'nodeDepth', depth )>
                     <cfset structInsert( resultArray[ arrayLen( resultArray ) ], 'elementName', getXMLElementName( arguments.passedXMLElement ) )>
                     <cfset structInsert( resultArray[ arrayLen( resultArray ) ], 'id', local.id )>
                     <cfset structInsert( resultArray[ arrayLen( resultArray ) ], 'parentId', local.parentId )>
                     
              </cfif>

             <!--- If the current node has XML Text that the user wants, capture it. --->
              <cfif hasXMLElementText( arguments.passedXMLElement ) and ( isEmptyFilterList( arguments.elementNameFilterList ) or isElementNameInFilterList( arguments.elementNameFilterList, arguments.passedXMLElement ) )>
                     <cfset structInsert( resultArray[ arrayLen( resultArray ) ], 'elementText', getXMLElementText( arguments.passedXMLElement ) )>
              </cfif>

             <!--- If the current node has XML Attributes that the user wants, capture them. --->

              <cfif hasXMLAttributes( arguments.passedXMLElement ) and ( isEmptyFilterList( arguments.elementNameFilterList ) or isElementNameInFilterList( arguments.elementNameFilterList, arguments.passedXMLElement ) )>
                     <cfset structInsert( resultArray[ arrayLen( resultArray ) ], 'attributes', getXMLAttributes( arguments.passedXMLElement ) )>
              </cfif>

             <!--- If the current node has XML Children, loop over the children and recurse this function for each child element. --->
             <cfif hasXMLChildren( passedXMLElement )>
                     <cfset passedXMLElementChildCount = getXMLChildCount( arguments.passedXMLElement )>
                     <cfloop index="thisChildElement" from="1" to="#passedXMLElementChildCount#">
                           <cfset depth = depth + 1>
                           <cfset recurseXMLObject( getXMLChildElement( arguments.passedXMLElement, thisChildElement ), local.id, arguments.elementNameFilterList, depth )>
                           <cfset depth = depth - 1>
                     </cfloop>
              </cfif>

              <cfreturn resultArray>

       </cffunction>

      

</cfcomponent>      