<cfcomponent displayname="utils">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfset variables.encConfig = createObject('component','model.Encryption').init(
			keyOne 		= 'prFcAUbQFbKx4oQLaN1xrA==',
			algOne 		= 'AES/CBC/PKCS5Padding',
			encOne 		= 'BASE64',
			keyTwo 		= 'qgayS5RUWqDnpmKKLecTTQ==',
			algTwo 		= 'BLOWFISH/CBC/PKCS5Padding',
			encTwo 		= 'HEX',
			keyThree 	= 'MnOe+Dgv3KddFpfxYAbGrw==',
			algThree 	= 'AES/CBC/PKCS5Padding',
			encThree 	= 'HEX'
		) />
		<cfreturn this />
	</cffunction>

	<!--- DATA ENCRYPTION --->
	<cffunction name="dataEnc" access="public" returntype="string">
		<cfargument name="value" type="string" required="yes" hint="I am the value to encrypt for the database." />
		<cfargument name="mode" type="string" required="false" default="db" />
		
		<!--- var scope --->
		<cfset var onePassEnc = '' />
		<cfset var twoPassEnc = '' />
		<cfset var lastPassEnc = '' />
		
		<!--- check if the passed value has length --->
		<cfif Len(ARGUMENTS.value)>
		
			<!--- it does, check if the mode of the encryption is 'db' --->
			<cfif FindNoCase('db',ARGUMENTS.mode)>
			
				<!--- using database encryption, encrypt with the first set of keys and algorithm --->
				<cfset onePassEnc = Encrypt(ARGUMENTS.value,variables.encConfig.getKeyOne(),variables.encConfig.getAlgOne(),variables.encConfig.getEncOne()) />
				<!--- and again with the second set of keys and algorithm --->
				<cfset twoPassEnc = Encrypt(onePassEnc,variables.encConfig.getKeyTwo(),variables.encConfig.getAlgTwo(),variables.encConfig.getEncTwo()) />
				<!--- and again with the third set of keys and algorithm --->
				<cfset lastPassEnc = Encrypt(twoPassEnc,variables.encConfig.getKeyThree(),variables.encConfig.getAlgThree(),variables.encConfig.getEncThree()) />
				<!--- NOTE: Add additional passes here for greater security --->
				
			<!--- otherwise, check if the mode of the encryption is 'repeatable' --->
			<cfelseif FindNoCase('repeatable',ARGUMENTS.mode)>
			
				<!--- using database encryption, encrypt with the first set of keys and algorithm --->
				<cfset lastPassEnc = Encrypt(ARGUMENTS.value,variables.encConfig.getKeyOne(),'AES','HEX') />
				<!---
				<!--- and again with the second set of keys and algorithm --->
				<cfset twoPassEnc = Encrypt(onePassEnc,variables.encConfig.getKeyTwo(),'BLOWFISH',variables.encConfig.getEncTwo()) />
				<!--- and again with the third set of keys and algorithm --->
				<cfset lastPassEnc = Encrypt(twoPassEnc,variables.encConfig.getKeyThree(),'AES',variables.encConfig.getEncThree()) />
				<!--- NOTE: Add additional passes here for greater security --->
				--->
			
			<!--- otherwise, check if the mode of the encryption is 'url' --->
			<cfelseif FindNoCase('url',ARGUMENTS.mode)>
				
				<!--- using url encryption, check if useing BASE64 encoding on the URL key --->
				<cfif FindNoCase('BASE64',variables.encConfig.getEncOne())>
				
					<!--- encrypt with the first set of keys and repeatable algorithm using BASE64 encoding --->
					<cfset lastPassEnc = URLEncodedFormat(Encrypt(ARGUMENTS.value,variables.encConfig.getKeyOne(),'AES',variables.encConfig.getEncOne())) />
				
				<!--- otherwise --->
				<cfelse>
				
					<!--- not BASE64 encoded, encrypt with the first set of keys and algorithm --->
					<cfset lastPassEnc = Encrypt(ARGUMENTS.value,variables.encConfig.getKeyOne(),variables.encConfig.getAlgOne(),variables.encConfig.getEncOne()) />
				
				<!--- end checking if useing BASE64 encoding on the URL key --->	
				</cfif>	
				
			<!--- otherwise, check if the mode of the encryption is 'form' --->
			<cfelseif FindNoCase('form',ARGUMENTS.mode)>
			
				<!--- using form encryption, encrypt with the second set of keys and algorithm --->
				<cfset lastPassEnc = Encrypt(ARGUMENTS.value,variables.encConfig.getKeyTwo(),variables.encConfig.getAlgTwo(),variables.encConfig.getEncTwo()) />
				
			<!--- otherwise, check if the mode of the encryption is 'cookie' --->
			<cfelseif FindNoCase('cookie',ARGUMENTS.mode)>
			
				<!--- using cookie encryption, encrypt with the first set of keys and algorithm --->
				<cfset lastPassEnc = Encrypt(ARGUMENTS.value,variables.encConfig.getKeyThree(),variables.encConfig.getAlgThree(),variables.encConfig.getEncThree()) />
			
			<!--- end checking if the mode of the encryption is 'db', 'url', 'form' or 'cookie' --->	
			</cfif>
		
		<!--- end checking if the passed value has length --->
		</cfif>
		
		<!--- return the encrypted value (or null if passed value has no length) --->
		<cfreturn lastPassEnc>
	</cffunction>

	<!--- DATA DECRYPTION --->
	<cffunction name="dataDec" access="public" returntype="string">
		<cfargument name="value" type="string" required="yes" hint="I am the value to decrypt for the database.">
		<cfargument name="mode" type="string" required="false" default="db" />

		<!--- var scope --->
		<cfset var onePassDec = '' />
		<cfset var twoPassDec = '' />
		<cfset var lastPassDec = '' />
		
		<!--- check if the passed value has length --->
		<cfif Len(ARGUMENTS.value)>
		
			<!--- it does, check if the mode of the encryption is 'db' --->
			<cfif FindNoCase('db',ARGUMENTS.mode)>
	
				<!--- NOTE: Add additional passes here for greater security --->
				<!--- using database encryption, decrypt with the third set of keys and algorithm --->
				<cfset onePassDec = Decrypt(ARGUMENTS.value,variables.encConfig.getKeyThree(),variables.encConfig.getAlgThree(),variables.encConfig.getEncThree()) />
				<!--- and again with the second set of keys and algorithm --->
				<cfset twoPassDec = Decrypt(onePassDec,variables.encConfig.getKeyTwo(),variables.encConfig.getAlgTwo(),variables.encConfig.getEncTwo()) />
				<!--- and again with the first set of keys and algorithm --->
				<cfset lastPassDec = Decrypt(twoPassDec,variables.encConfig.getKeyOne(),variables.encConfig.getAlgOne(),variables.encConfig.getEncOne()) />
		
			<!--- otherwise, check if the mode of the encryption is 'repeatable' --->
			<cfelseif FindNoCase('repeatable',ARGUMENTS.mode)>
	
				<!---
				<!--- NOTE: Add additional passes here for greater security --->
				<!--- using database encryption, decrypt with the third set of keys and algorithm --->
				<cfset onePassDec = Decrypt(ARGUMENTS.value,variables.encConfig.getKeyThree(),'AES',variables.encConfig.getEncThree()) />
				<!--- and again with the second set of keys and algorithm --->
				<cfset twoPassDec = Decrypt(onePassDec,variables.encConfig.getKeyTwo(),'BLOWFISH',variables.encConfig.getEncTwo()) />
				--->
				<!--- and again with the first set of keys and algorithm --->
				<cfset lastPassDec = Decrypt(ARGUMENTS.value,variables.encConfig.getKeyOne(),'AES','HEX') />
			
			<!--- otherwise, check if the mode of the encryption is 'url' --->
			<cfelseif FindNoCase('url',ARGUMENTS.mode)>
				
				<!--- using url encryption, check if useing BASE64 encoding on the URL key --->
				<cfif FindNoCase('BASE64',variables.encConfig.getEncOne())>
				
					<!--- using BASE64 encoding, URL decode the value --->
					<cfset ARGUMENTS.value = URLDecode(ARGUMENTS.value) />
					<!--- replace spaces with + --->
					<cfset ARGUMENTS.value = Replace(ARGUMENTS.value,chr(32),'+','ALL') />
					<!--- decrypt with the first set of keys and repeatable algorithm --->
					<cfset lastPassDec = Decrypt(ARGUMENTS.value,variables.encConfig.getKeyOne(),'AES',variables.encConfig.getEncOne()) />
				
				<!--- otherwise --->
				<cfelse>
				
					<!--- not BASE64 encoded, decrypt with the first set of keys and algorithm --->
					<cfset lastPassDec = Decrypt(ARGUMENTS.value,variables.encConfig.getKeyOne(),variables.encConfig.getAlgOne(),variables.encConfig.getEncOne()) />
				
				<!--- end checking if useing BASE64 encoding on the URL key --->	
				</cfif>			
				
			<!--- otherwise, check if the mode of the encryption is 'form' --->
			<cfelseif FindNoCase('form',ARGUMENTS.mode)>
			
				<!--- using form encryption, decrypt with the second set of keys and algorithm --->
				<cfset lastPassDec = Decrypt(ARGUMENTS.value,variables.encConfig.getKeyTwo(),variables.encConfig.getAlgTwo(),variables.encConfig.getEncTwo()) />
				
			<!--- otherwise, check if the mode of the encryption is 'cookie' --->
			<cfelseif FindNoCase('cookie',ARGUMENTS.mode)>
			
				<!--- using cookie encryption, decrypt with the first set of keys and algorithm --->
				<cfset lastPassDec = Decrypt(ARGUMENTS.value,variables.encConfig.getKeyThree(),variables.encConfig.getAlgThree(),variables.encConfig.getEncThree()) />
			
			<!--- end checking if the mode of the encryption is 'db', 'url', 'form' or 'cookie' --->	
			</cfif>
		
		<!--- end checking if the passed value has length --->
		</cfif>

		<!--- return the decrypted value (or null if passed value has no length) --->
		<cfreturn lastPassDec>
	</cffunction>
	
	<!--- GLOBAL ERROR HANDLER --->
	<cffunction name="errorHandler" access="public" returntype="void" output="true">
		<cfargument name="errorData" type="any" required="true" hint="I am the struct returned by cfcatch." />
		<cfargument name="debug" type="boolean" required="false" default="true" hint="I determine whether to fail gracefully or output debug." />
		
		<!--- var scope --->
		<cfset var errorDetail = '' />
		
		<!--- dump the error as text to a variable --->
		<cfsavecontent variable="errorDetail">
			<cfdump var="#errorData#" format="text" />
		</cfsavecontent>
		
		<!--- log the error --->
		<cflog text="ERROR: #errorDetail#" type="Information" file="#APPLICATION.getApplicationSettings().name#" thread="yes" date="yes" time="yes" application="yes">
		
		<!--- check if we're failing gracefully --->
		<cfif NOT ARGUMENTS.debug>
		
			<!--- we are, output an error message --->
			<script type="text/javascript">
				document.removeChild(document.documentElement);
			</script>
			<h1>We're sorry but an error has occurred. Please refresh your browser to try again.</h1>
			
		<!--- otherwise --->
		<cfelse>
		
			<!--- dump the error to the screen --->
			<cfdump var="#ARGUMENTS.errorData#" label="ERROR DATA (CFCATCH)" />
			<!--- and abort --->
			<cfabort>
		
		<!--- end checking if we're failing gracefully --->
		</cfif>	
		
	</cffunction>

	<!--- SANITIZE FORM VALUES --->
	<cffunction name="sanitize" access="public" returntype="struct" output="false" hint="I sanitize data passed in a FORM scope using either ESAPI or HTMLEditFormat().">
		<cfargument name="formData" type="struct" required="true" hint="I am the FORM struct." />
		
		<!--- var scope --->
		<cfset var formField = '' />
		<cfset var returnStruct = StructNew() />
		
		<!--- loop through the FORM fields provided --->
		<cfloop collection="#ARGUMENTS.formData#" item="formField">
			<!--- check if any script tags were provided in this form value --->
			<cfif ReFindNoCase('(\<invalidtag|\<script)',ARGUMENTS.formData[formfield])>
				<!--- invalid tags found, clear this field completely --->
				<cfset returnStruct[formfield] = '' />				
			<!--- check if this is a known value (boolean, numeric, date, email or password) --->
			<cfelseif IsBoolean(ARGUMENTS.formData[formfield]) OR IsNumeric(ARGUMENTS.formData[formfield]) OR IsDate(ARGUMENTS.formData[formfield]) OR ReFindNoCase('^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,12}$',ARGUMENTS.formData[formField]) OR FindNoCase('password',formField)>
				<!--- it is, so just add it to the return struct --->
				<cfset returnStruct[formfield] = ARGUMENTS.formData[formfield] />
			<!--- otherwise --->
			<cfelse>
				<!--- not boolean or numeric, check if we're using ESAPI --->
				<cfif APPLICATION.useESAPI>
					<!--- we are, process the form field through ESAPI --->
					<cfset returnStruct[formField] = APPLICATION.esapiEncoder.encodeForHTML(ARGUMENTS.formData[formfield]) />
				<!--- otherwise --->
				<cfelse>
					<!--- we're not using ESAPI, process the form field through HTMLEditFormat() --->
					<cfset returnStruct[formField] = HTMLEditFormat(ARGUMENTS.formdata[formfield]) />
				<!--- end checking if we're using ESAPI --->
				</cfif>
			<!--- end checking if this is a boolean or numeric value --->
			</cfif>
		<!--- end looping through the FORM fields provided --->
		</cfloop> 
		
		<!--- return the sanitzed form values --->
		<cfreturn returnStruct />
		
	</cffunction>
	
	<!--- DECODE STORED VALUES --->
	<cffunction name="decodeVal" access="public" returntype="string" output="false" hint="I decode HTML encoded with ESAPI.">
		<cfargument name="value" type="string" required="true" hint="I am the string to decode." />
		
			<!--- var scope --->
			<cfset var decodedValue = '' />
		
			<!--- check if we're using ESAPI --->
			<cfif APPLICATION.useESAPI>
				<!--- we are, decode the value through ESAPI --->
				<cfset decodedValue = APPLICATION.esapiEncoder.decodeForHTML(ARGUMENTS.value) />
			<!--- otherwise --->
			<cfelse>
				<!--- we're not using ESAPI, simply return the value --->
				<cfset decodedValue = ARGUMENTS.value />
			<!--- end checking if we're using ESAPI --->
			</cfif>
		
		<!--- return the sanitzed form values --->
		<cfreturn decodedValue />
		
	</cffunction>	
	
	<!--- CHECK FIELDS --->
	<cffunction name="checkFields" access="public" returntype="struct" output="false" hint="I take a struct of fields and values and ensure they are valid.">
		<cfargument name="fields" type="array" required="true" hint="I am an array of structs containing the fields to check." />
		
		<!--- var scope --->
		<cfset var formField = '' />
		<cfset var returnStruct = StructNew() />
		<cfset var iX = 0 />
		
		<!--- set the result of this check to true by default (all fields provide values) --->
		<cfset returnStruct.result = true />
		<cfset returnStruct.fields = '' />
		
		<!--- loop through the passed in struct --->
		<cfloop from="1" to="#arrayLen( ARGUMENTS.fields )#" index="iX">

			<!--- switch on the field type --->
			<cfswitch expression="#ARGUMENTS.fields[iX].type#">
				
				<cfcase value="date">
					<cfif NOT isDate( ARGUMENTS.fields[iX].value )>
						<cfset returnStruct.result = false />
						<cfset returnStruct.fields = listAppend(returnStruct.fields, ARGUMENTS.fields[iX].field & ' is not a valid date or time.' ) />
					</cfif>
				</cfcase>
				
				<cfcase value="numeric">
					<cfif NOT isNumeric( ARGUMENTS.fields[iX].value )>
						<cfset returnStruct.result = false />
						<cfset returnStruct.fields = listAppend(returnStruct.fields, ARGUMENTS.fields[iX].field & ' is not a valid number.' ) />
					</cfif>
				</cfcase>

				<cfdefaultcase>
					<cfif NOT len( ARGUMENTS.fields[iX].value )>
						<cfset returnStruct.result = false />
						<cfset returnStruct.fields = listAppend(returnStruct.fields, ARGUMENTS.fields[iX].field & ' is required.' ) />						
					</cfif>
				</cfdefaultcase>

			</cfswitch>

		<!--- end looping through the passed in struct --->
		</cfloop>
		
		<!--- return the results of the required check (true/false and any missing fields) --->
		<cfreturn returnStruct />
		
	</cffunction>
	
	<!--- GENERATE SESSION ID --->
	<cffunction name="generateSessionId" access="public" returntype="string" output="false" hint="I generate a unique session id.">
	
		<!--- return a triple hash of CreateUUID() --->
		<cfreturn Hash(Hash(Hash(CreateUUID(),'SHA-512'),'SHA-384'),'SHA-256') />
		
	</cffunction>
	
	<!--- GENERATE PASSWORD --->
	<cffunction name="generatePassword" access="public" returntype="string" output="false" hint="I generate a random password.">
	
		<!--- var scope --->
		<cfset var alphaNum = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9' />
		<cfset var newPass = '' />
		<cfset var iX = 0 />
		
		<!--- loop from 8 to 12 times --->
		<cfloop from="1" to="#RandRange(8,12)#" index="iX">
			<!--- add a random character from the alphaNum list to build the new password --->
			<cfset newPass = newPass & ListGetAt(alphaNum,RandRange(1,ListLen(alphaNum))) />
		</cfloop>
		
		<!--- return the new password --->
		<cfreturn newPass />
		
	</cffunction>
	
	<!--- FORMAT PHONE --->
	<cffunction name="formatPhone" access="public" returntype="string" output="false" hint="I format a phone number for various country formats.">
		<cfargument name="phone" type="string" required="true" hint="I am the phone number as input by the user.">
		
		<!--- var scope --->
		<cfset var phoneDigits = ReReplace(ARGUMENTS.phone,'[^0-9]','','ALL') />
		<cfset var returnPhone = '' />
		
		<!--- switch on the length of the phone number digits (0-9) --->
		<cfswitch expression="#Len(phoneDigits)#">
		
			<!--- United States --->
			<cfcase value="10">
			
				<!--- format phone as (XXX) XXX-XXXX --->
				<cfset returnPhone = '(' & Left(phoneDigits,3) & ') ' & Mid(phoneDigits,4,3) & '-' & Right(phoneDigits,4) />
				
			</cfcase>
			
			<!--- DEFAULT (UNKNOWN) --->
			<cfdefaultcase>
			
				<!--- no formatting, return value sent to function --->
				<cfset returnPhone = ARGUMENTS.phone />
				
			</cfdefaultcase>
		
		</cfswitch>
		
		<!--- return the formatted phone number --->
		<cfreturn returnPhone />
		
	</cffunction>

<cffunction name="queryToArray" access="public" returntype="array" output="false" hint="This turns a query into an array of structures.">
	<cfargument name="Data" type="query" required="yes" />
 
	<cfscript>
	 
	 	// set a local variable
		var LOCAL = StructNew();
		
		// get the column names 
		LOCAL.Columns = ListToArray( ARGUMENTS.Data.ColumnList );
		
		// create an array to store the results 
		LOCAL.QueryArray = ArrayNew( 1 );
		
		// loop over query data
		for (LOCAL.RowIndex = 1 ; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
		 
			// Create a row structure.
			LOCAL.Row = StructNew();
			 
			// Loop over the columns in this row
			for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE ArrayLen( LOCAL.Columns ) ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
			 
				// Get a reference to the query column
				LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
				 
				// Store the query cell value into the struct by key
				LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
				 
			}
			 
			// Add the structure to the query array
			ArrayAppend( LOCAL.QueryArray, LOCAL.Row );
			 
			}
		 
		// Return the array equivalent
		return( LOCAL.QueryArray );
	 
	</cfscript>
</cffunction>

<cffunction name="queryToJSON" access="public" returntype="string" output="false" hint="I turn a query into properly formatted lowercase data.">
	<cfargument name="qGetData" type="query" required="true" hint="I am the query data to process in JSON." />
	<cfset var retData = '' />
	<cfset var colList = LCase( ARGUMENTS.qGetData.columnList ) />
	<cfset var iX = 0 />

	<cfprocessingdirective suppressWhiteSpace = "true">
	<cfsavecontent variable="retData">
		<cfoutput>
		{
  			"data": [<cfloop query="qGetData">
  				{
  				<cfloop from="1" to="#ListLen( colList )#" index="iX">"#ListGetAt( colList, iX )#": "#qGetData[ ListGetAt( colList, iX ) ][ currentRow ]#"<cfif NOT iX EQ ListLen(colList)>,</cfif></cfloop>
  				}<cfif currentRow NEQ qGetData.recordCount>,</cfif>
  			</cfloop>
  			]
  		}
  		</cfoutput>
	</cfsavecontent>
	</cfprocessingdirective>

	<cfreturn retData />

</cffunction>
		
</cfcomponent>