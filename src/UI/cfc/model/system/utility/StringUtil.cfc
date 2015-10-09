<cfcomponent>
	
	<cffunction name="init" access="public" output="false" returntype="StringUtil">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createRandom" access="public" output="false" returntype="string" hint="Creates random string containing at least one lowercase letter, one capital letter and one number">
		<cfargument name="length" type="numeric" default="8" />

		<cfscript>
			var i = "";		
			var lower = 'abcdefghjkmnpqrtuvwxyz';
			var upper = ucase(lower);
			var num = '1234567890';
			var allValid = lower & upper & num;
			
			var arr = [];
			
			arr[1] = mid( lower, randRange( 1, len( lower ) ), 1 );
			arr[2] = mid( upper, randRange( 1, len( upper ) ), 1 );
			arr[3] = mid( num, randRange( 1, len( num ) ), 1 );
			
			if( arguments.length < arrayLen(arr) ) 
			{
				_throw( 
					message="Minimim length is #arrayLen(arr)#. Value provided: #arguments.length#", 
					type="StringUtilities.createRandom.InvalidArgument"
				);
			}  
			
			for( i=5; i <= arguments.length; i ++ )
			{
				arr[i] = mid( allValid, randRange( 1, len( allValid ) ), 1 );
			}
			
			return shuffle( arrayToList( arr ) );
		</cfscript>
		
	</cffunction>
	
	<cffunction name="shuffle" access="public" output="false" returntype="string" hint="Randomly shuffles string">	
		<cfargument name="strIn" type="string" required="true" />
		
		<cfscript>
			var strOut = "";
			var pos = "";
			var arr = listToArray( arguments.strIn );
			
			while( arrayLen(arr) ) 
			{
				pos = randRange( 1, arrayLen(arr) );
				strOut &= arr[pos];
				arrayDeleteAt(arr,pos);
			}
			
			return strOut;
		</cfscript>
		
	</cffunction>
	
	<cffunction name="isEmail" access="public" returntype="boolean" output="false">
		<cfargument name="str" required="true" type="string" />

		<cfscript>
			var var_str = trim(arguments.str);

			if(reFindNoCase("^['_a-z0-9-/]+(\.['_a-z0-9-/]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$", var_str))
			{
				return true;
			}
			else
			{
				return false;
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="friendlyUrl" access="public" returntype="string" output="false">
		<cfargument name="title" required="true" type="string" />

		<cfscript>
			var urlString = trim(arguments.title);

		    urlString = replaceNoCase(urlString,"&amp;","","all"); //replace &amp;
		    urlString = replaceNoCase(urlString,"&","","all"); //replace &
		    urlString = replaceNoCase(urlString,"'","","all"); //remove apostrophe
		    urlString = reReplaceNoCase(trim(urlString),"[^a-zA-Z0-9]","-","ALL");
		    urlString = reReplaceNoCase(urlString,"[\-\-]+","-","all");
		    //Remove trailing dashes
		    if(right(urlString,1) eq "-") {
		        urlString = left(urlString,len(urlString) - 1);
		    }
		    if(left(urlString,1) eq "-") {
		        urlString = right(urlString,len(urlString) - 1);
		    }
		    
		    return lcase(urlString);
		</cfscript>
	</cffunction>	
	
	<cffunction name="_throw" access="private">
		<cfargument name="message" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="StringUtilities" />
		<cfthrow message="#arguments.message#" type="#arguments.type#" />
	</cffunction>

	<cffunction name="formatPhoneNumber" output="false" access="public" returntype="string">
		<cfargument name="phoneNumber" type="string" required="true" />
		<cfset var formattedPhoneNumber = ""/>
		<cfset var phoneNumber1 = ""/>
		<cfset var phoneNumber2 = ""/>
		<cfset var phoneNumber3 = ""/>

		<cfscript>
			formattedPhoneNumber = reReplace(arguments.phoneNumber,"[{}\(\)\^$&%##!@=<>:;,~`'\'\*\?\/\+\|\[\\\\]|\]|\-",'','all');
			if ( len(formattedPhoneNumber eq 10) ) {
				phoneNumber1 = left(formattedPhoneNumber, 3);
				phoneNumber2 = mid(formattedPhoneNumber, 4, 3);
				phoneNumber3 = right(formattedPhoneNumber, 4);
				formattedPhoneNumber = "(#phoneNumber1#) #phoneNumber2#-#phoneNumber3#";
			} else {
				formattedPhoneNumber = "Not Valid.";
			}
		</cfscript>

		<cfreturn formattedPhoneNumber />
	</cffunction>
	
</cfcomponent>
