<cfcomponent output="false" displayname="FormValidation">
	<cffunction name="init" returntype="FormValidation">
        <cfset instance.messages = arrayNew(1)> <!--- struct of Message, FieldOfRef (should be unique per form) --->

        <cfreturn this>
    </cffunction>

	<cffunction name="clear" access="public" returntype="void" output="false">
		<cfset instance.messages = arrayNew(1) />
	</cffunction>

	<cffunction name="AddValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="ValidationType" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <!--- add the validator --->
        <cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        <cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        <cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
        <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
        <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>

	</cffunction>

    <cffunction name="AddRequiredFieldValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="Required">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif len(trim(local.fieldValue)) eq 0>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddEmailValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>
        <cfif trim( local.fieldValue) neq "">
			<cfif NOT isValid("email",local.fieldValue)>
                <cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
                <cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
                <cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
                <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
                <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
            </cfif>
        </cfif>

    </cffunction>

    <cffunction name="AddRangeValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="min" type="numeric" required="yes">
        <cfargument name="max" type="numeric" required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif (len(local.fieldValue) LT ARGUMENTS.min) OR (len(local.fieldValue) GT ARGUMENTS.max)>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddMaxRangeValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="max" type="numeric" required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>
        <cfif len(local.fieldValue) gt max>
			  <cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
              <cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
              <cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
              <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
              <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddRegexValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="pattern" type="string" required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif NOT isValid("regex",local.fieldValue,ARGUMENTS.pattern)>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddDateValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="Invalid. Required Format: mm/dd/yyyy">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif NOT IsValid("USdate", local.fieldValue)>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddFutureDateValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif  IsValid("USdate", local.fieldValue)>
        	<cfif local.fieldValue lt DateFormat(now(), 'mm/dd/yyyy')>
				<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
                <cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
                <cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
                <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
                <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        	</cfif>
        </cfif>

    </cffunction>


    <cffunction name="AddMaxDateValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes" />
        <cfargument name="FieldValue" type="string" required="yes" />
		<cfargument name="MaxDate" type="string" required="yes" />
        <cfargument name="Message" type="string"  required="yes" />
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true" />
        <cfargument name="InlineMessage" type="string" required="false" default="" />

        <cfset var local = structNew() />
        <cfset local.fieldValue = arguments.FieldValue />

        <cfif  IsValid("USdate", local.fieldValue)>
        	<cfif local.fieldValue gt DateFormat(arguments.MaxDate, 'mm/dd/yyyy')>
				<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
                <cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
                <cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
                <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
                <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        	</cfif>
        </cfif>
    </cffunction>

	<cffunction name="AddAgeValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif  IsValid("USdate", local.fieldValue)>
        	<cfset local.years = dateDiff("yyyy", local.fieldValue, now())>

        	<cfif local.years lt 18 >
				<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
                <cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
                <cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
                <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
                <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        	</cfif>
        </cfif>

    </cffunction>

    <cffunction name="AddSSNValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="Invalid. Format: XXX-XX-XXXX">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif NOT isValid("ssn",local.fieldValue) and len(trim(local.fieldValue)) gt 0>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddPhoneValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif NOT isValid("telephone",local.fieldValue)>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddURLValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif NOT isValid("URL",local.fieldValue)>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddZipCodeValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif NOT isValid("zipcode",local.fieldValue)>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddEqualityValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
		<cfargument name="ExpectedValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="Required">

        <cfif arguments.FieldValue neq arguments.ExpectedValue>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = {} />
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message />
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef />
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary />
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage />
        </cfif>

    </cffunction>

    <cffunction name="AddTextBoxValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="MaxLength" type="number"  required="no" default="0">
        <cfargument name="Regex" type="string" required="no" default="">
    </cffunction>

	<cffunction name="addMessage" access="public" returntype="void" output="false">
		<cfargument name="fieldOfRef" required="true" type="string" />
		<cfargument name="customMessage" required="true" type="string" />
		<cfargument name="showInSummary" required="false" type="boolean" default="true" />
		<cfargument name="inlineMessage" required="false" type="string" default="" />

		<cfset instance.messages[arrayLen(instance.messages) + 1] = structNew() />
		<cfset instance.messages[arrayLen(instance.messages)].message = trim(arguments.customMessage) />
		<cfset instance.messages[arrayLen(instance.messages)].fieldOfRef = trim(arguments.fieldOfRef) />
		<cfset instance.messages[arrayLen(instance.messages)].showInSummary = arguments.showInSummary />
		<cfset instance.messages[arrayLen(instance.messages)].inlineMessage = arguments.inlineMessage />
	</cffunction>

    <cffunction name="AddFieldLengthValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
		<cfargument name="minLength" type="numeric" default="0" required="false">
        <cfargument name="maxLength" type="numeric" required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif len(trim(local.fieldValue)) LT arguments.minLength || len(trim(local.fieldValue)) GT arguments.maxLength>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>

    <cffunction name="AddIsNumericValidator" returntype="void">
    	<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">

        <cfset var local = structNew()>
        <cfset local.fieldValue = arguments.FieldValue>

        <cfif !IsNumeric(trim(local.fieldValue))>
        	<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
        </cfif>

    </cffunction>
    
    <cffunction name="addCreditCardValidator" returntype="void">
		<cfargument name="FieldOfRef" type="string" required="yes">
        <cfargument name="FieldValue" type="string" required="yes">
        <cfargument name="Message" type="string"  required="yes">
        <cfargument name="ShowInSummary" type="boolean" required="false" default="true">
        <cfargument name="InlineMessage" type="string" required="false" default="">
		
		<cfif !isValid( "creditcard", arguments.fieldValue )>
			<cfset instance.messages[ArrayLen(instance.messages)+1] = structNew()>
        	<cfset instance.messages[ArrayLen(instance.messages)].Message = arguments.Message>
        	<cfset instance.messages[ArrayLen(instance.messages)].FieldOfRef = arguments.FieldOfRef>
            <cfset instance.messages[ArrayLen(instance.messages)].ShowInSummary = arguments.ShowInSummary>
            <cfset instance.messages[ArrayLen(instance.messages)].InlineMessage = arguments.InlineMessage>
		</cfif>
	
	</cffunction>

	<cffunction name="getMessages" access="public" returntype="array" output="false">
		<cfreturn instance.messages />
	</cffunction>

	<cffunction name="getMessageStrings" access="public" returntype="array" output="false">
		<cfset var i = '' />
		<cfset var messages = [] />
		
		<cfloop array="#instance.messages#" index="i">
			<cfset ArrayAppend(messages, i.Message) />
		</cfloop> 
		
		<cfreturn messages />
	</cffunction>

	<cffunction name="hasMessages" access="public" returntype="boolean" output="false">

		<cfset var local = structNew() />
		<cfset var hasMessagesReturn = false />

        <cfif arrayLen(instance.messages)>
			<cfset hasMessagesReturn = true />
		</cfif>

		<cfreturn hasMessagesReturn />
	</cffunction>

	<cffunction name="fieldHasMessages" access="public" returntype="boolean" output="false">
		<cfargument name="fieldOfRef" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset var fieldHasMessagesReturn = false />

		<cfloop from="1" to="#arrayLen(instance.messages)#" index="local.i">
			<cfif instance.messages[local.i].fieldOfRef is arguments.fieldOfRef>
				<cfset fieldHasMessagesReturn = true />
				<cfbreak />
			</cfif>
		</cfloop>

		<cfreturn fieldHasMessagesReturn />
	</cffunction>
</cfcomponent>