<cfcomponent output="false">

	<cfproperty name="Type" type="string" required="false" />
	<cfproperty name="PropertyName" type="string" required="false" />
	<cfproperty name="OriginalValue" type="string" required="false" />
	<cfproperty name="NewValue" type="string" required="false" />

	<cfscript>
		instance = {};
		instance.types = [
			{Name = 'Update', Weight = 10}
			, {Name = 'Status Change', Weight = 100}
			, {Name = 'Resolve SOC Code', Weight = 100}
		];
	</cfscript>

	<cffunction name="init" output="false" access="public" returntype="cfc.model.ActivityLogEvent">
		<cfargument name="Type" type="string" default="" required="false" />
		<cfargument name="PropertyName" type="string" default="0" required="false" />
		<cfargument name="OriginalValue" type="string" default="0" required="false" />
		<cfargument name="NewValue" type="string" default="0" required="false" />

		<cfscript>
			setType( arguments.Type );
			setPropertyName( arguments.PropertyName );
			setOriginalValue( arguments.OriginalValue );
			setNewValue( arguments.NewValue );
		</cfscript>

		<cfreturn this />
	</cffunction>


	<cffunction name="convertToString" output="false" access="public" returntype="string">
		<cfscript>
			var eventAsString = "";
		
			switch ( variables.instance.Type )
			{
				case 'Update':
				{
					eventAsString = getType() & " - " & getPropertyName() & "='" & getOriginalValue() & "' > '" & getNewValue() & "'";
					break;
				}
				case 'Status Change':
				{
					eventAsString = getType() & " - " & getPropertyName() & "='" & getOriginalValue() & "' > '" & getNewValue() & "'";
					break;
				}
				case 'Resolve SOC Code':
				{
					eventAsString = getType() & " - " & getPropertyName() & "=" & getOriginalValue();
					break;
				}				
			}
		</cfscript>
		
		<cfreturn eventAsString />
	</cffunction>


	<cffunction name="getWeightByType" output="false" access="public" returntype="string">

		<cfscript>
			var types = variables.instance.types;
			var weight = 0;
		
			for ( i = 1; i <= ArrayLen( types ); i++ )
			{
				if ( types[i].Name EQ variables.instance.Type )
				{
					weight = types[i].Weight;
					break;
				}
			}
		</cfscript>
		
		<cfreturn weight />
	</cffunction>
	
	<cffunction name="getType" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Type />
	</cffunction>
	<cffunction name="setType" output="false" access="public" returntype="void">
		<cfargument name="Type" type="string" required="true" />
		<cfset variables.instance.Type = arguments.Type />
	</cffunction>	

	<cffunction name="getPropertyName" output="false" access="public" returntype="string">
		<cfreturn variables.instance.PropertyName />
	</cffunction>
	<cffunction name="setPropertyName" output="false" access="public" returntype="void">
		<cfargument name="PropertyName" type="string" required="true" />
		<cfset variables.instance.PropertyName = arguments.PropertyName />
	</cffunction>
	
	<cffunction name="getOriginalValue" output="false" access="public" returntype="string">
		<cfreturn variables.instance.OriginalValue />
	</cffunction>
	<cffunction name="setOriginalValue" output="false" access="public" returntype="void">
		<cfargument name="OriginalValue" type="string" required="true" />
		<cfset variables.instance.OriginalValue = arguments.OriginalValue />
	</cffunction>	
	
	<cffunction name="getNewValue" output="false" access="public" returntype="string">
		<cfreturn variables.instance.NewValue />
	</cffunction>
	<cffunction name="setNewValue" output="false" access="public" returntype="void">
		<cfargument name="NewValue" type="string" required="true" />
		<cfset variables.instance.NewValue = arguments.NewValue />
	</cffunction>

	<cffunction name="getMemento" output="false" access="public" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>