<cfcomponent output="false">

	<cfproperty name="ActivityId" type="numeric" required="false" />
	<cfproperty name="UserId" type="numeric" required="false" />
	<cfproperty name="Timestamp" type="date" required="false" />
	<cfproperty name="Type" type="string" required="false" />
	<cfproperty name="TypeReferenceId" type="string" required="false" />
	<cfproperty name="PrimaryActivityType" type="string" required="false" />
	<cfproperty name="Description" type="string" required="false" />

	<cfset instance = {} />
	<cfset instance.events = [] />

	<cffunction name="init" output="false" access="public" returntype="cfc.model.ActivityLog">
		<cfargument name="ActivityId" type="numeric" default="0" required="false" />
		<cfargument name="UserId" type="numeric" default="0" required="false" />
		<cfargument name="Timestamp" type="date" default="#Now()#" required="false" />
		<cfargument name="Type" type="string" default="" required="false" />
		<cfargument name="TypeReferenceId" type="string" default="" required="false" />
		<cfargument name="PrimaryActivityType" type="string" default="" required="false" />
		<cfargument name="Description" type="string" default="" required="false" />

		<cfscript>
			setActivityId( arguments.ActivityId );
			setUserId( arguments.UserId );
			setTimestamp( arguments.Timestamp );
			setType( arguments.Type );
			setTypeReferenceId( arguments.TypeReferenceId );
			setPrimaryActivityType( arguments.PrimaryActivityType );
			setDescription( arguments.Description );
		</cfscript>

		<cfreturn this />
	</cffunction>
 	
	<cffunction name="load" output="false" access="public" returntype="void">
		<cfargument name="activityLogId" type="numeric" required="true">
		
		<cfquery name="qActivity" datasource="#application.dsn.wirelessAdvocates#">
			SELECT
				ActivityId
				, UserId
				, Timestamp
				, Type
				, TypeReferenceId
				, PrimaryActivityType
				, Description
			FROM logging.Activity
			WHERE ActivityId = <cfqueryparam value="#arguments.activityLogId#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfscript>
			if ( qActivity.RecordCount )
			{
				if (len(trim( qActivity.ActivityId ))) this.setActivityId( qActivity.ActivityId );
				if (len(trim( qActivity.UserId ))) this.setUserId( qActivity.UserId );
				if (len(trim( qActivity.Timestamp ))) this.setTimestamp( qActivity.Timestamp );
				if (len(trim( qActivity.Type ))) this.setType( qActivity.Type );
				if (len(trim( qActivity.TypeReferenceId ))) this.setTypeReferenceId( qActivity.TypeReferenceId );
				if (len(trim( qActivity.PrimaryActivityType ))) this.setPrimaryActivityType( qActivity.PrimaryActivityType );
				if (len(trim( qActivity.Description ))) this.setDescription( qActivity.Description );
			}
			else
			{
				this = CreateObject( "component", "cfc.model.ActivityLog" ).init();
			}
		</cfscript>	
		
	</cffunction>		
	
	<cffunction name="save" output="false" access="public" returntype="void">
	
		<!--- Log only if any activity events were captured --->
		<cfif ArrayLen( instance.events )>
			<cfset setPrimaryActivityTypeFromEvents() />
			<cfset setDescriptionFromEvents() />
	
			<cfif not this.getActivityId()>
				<cfquery datasource="#application.dsn.wirelessAdvocates#">
					INSERT INTO logging.Activity
					(
						UserId
						, Timestamp
						, Type
						, TypeReferenceId
						, PrimaryActivityType
						, Description					
					)
					VALUES
					(
						<cfqueryparam value="#Trim( this.getUserId() )#" cfsqltype="cf_sql_integer" null="#NOT this.getUserId()#" />
						, <cfqueryparam value="#Trim( this.getTimestamp() )#" cfsqltype="cf_sql_timestamp" null="#NOT Len(Trim( this.getTimestamp() ))#" />
						, <cfqueryparam value="#Trim( this.getType() )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getType() ))#" />
						, <cfqueryparam value="#Trim( this.getTypeReferenceId() )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getTypeReferenceId() ))#" />
						, <cfqueryparam value="#Trim( this.getPrimaryActivityType() )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getPrimaryActivityType() ))#" />
						, <cfqueryparam value="#Left( Trim( this.getDescription() ), 1000 )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getDescription() ))#" />
					)
				</cfquery>
			<cfelse>
				<cfquery datasource="#application.dsn.wirelessAdvocates#">
					UPDATE logging.Activity
					SET	UserId = <cfqueryparam value="#Trim( this.getUserId() )#" cfsqltype="cf_sql_integer" null="#NOT this.getUserId()#" />
						, Timestamp = <cfqueryparam value="#Trim( this.getTimestamp() )#" cfsqltype="cf_sql_timestamp" null="#NOT Len(Trim( this.getTimestamp() ))#" />
						, Type = <cfqueryparam value="#Trim( this.getType() )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getType() ))#" />
						, TypeReferenceId = <cfqueryparam value="#Trim( this.getTypeReferenceId() )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getTypeReferenceId() ))#" />
						, PrimaryActivityType = <cfqueryparam value="#Trim( this.getPrimaryActivityType() )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getPrimaryActivityType() ))#"  />
						, Description = <cfqueryparam value="#Left( Trim( this.getDescription() ), 1000 )#" cfsqltype="cf_sql_varchar" null="#NOT Len(Trim( this.getDescription() ))#" />
					WHERE ActivityId = <cfqueryparam value="#Trim( this.getActivityId() )#" cfsqltype="cf_sql_integer" />
				</cfquery>
			</cfif>		
		</cfif>
	</cffunction>


	<cffunction name="addEvent" output="false" returntype="void">
		<cfargument name="type" type="string" required="true" />
		<cfargument name="propertyName" type="string" required="false" />
		<cfargument name="originalValue" type="string" required="false" />
		<cfargument name="newValue" type="string" required="false" />
	
		<cfscript>
			var event = CreateObject( "component", "cfc.model.ActivityLogEvent" ).init( argumentCollection = arguments );
			
			if ( NOT filterEvent( event ) )
			{
				ArrayAppend( variables.instance.events, event );
			}
		</cfscript>

	</cffunction>


	<cffunction name="filterEvent" output="false" returntype="boolean">
		<cfargument name="event" type="cfc.model.ActivityLogEvent" required="true" />
	
		<cfscript>
			var isFiltered = false;
			
			switch ( event.getType() )
			{
				case 'Status Change':
				{
					//Fall through to logic in 'Update' case
				}			
				case 'Update':
				{
					//Filter updates that have no value changes
					if ( event.getOriginalValue() EQ event.getNewValue() )
					{
						isFiltered = true;
					}
					break;
				}
			}
		</cfscript>

		<cfreturn isFiltered />
	</cffunction>


	<cffunction name="setDescriptionFromEvents" output="false" access="public" returntype="void">
	
		<cfscript>
			var desc = "";
			
			//TODO: Use Java string parser
			for ( i=1; i <= arraylen( variables.instance.events ); i++ )
			{
				desc = desc & variables.instance.events[i].convertToString() & ' | ';
			}
			
			variables.instance.Description = desc;
		</cfscript>
		
	</cffunction>


	<cffunction name="setPrimaryActivityTypeFromEvents" output="false" access="public" returntype="void">
		<cfscript>
			var primaryEvent = "";
			var events = variables.instance.events;
			
			if ( ArrayLen( events ) EQ 1 )
			{
				setPrimaryActivityType( events[1].getType() );
			}
			//Get primary type by weight if there is more than one event stored
			else if ( ArrayLen( events ) GTE 2 )
			{
				primaryEvent = events[1]; //Set base to compare with
			
				for ( i=2; i <= ArrayLen( events ); i++ )
				{
					if ( primaryEvent.getWeightByType() LT events[i].getWeightByType() )
					{
						primaryEvent = events[i];
					}
				}
				
				setPrimaryActivityType( primaryEvent.getType() );
			}
		</cfscript>
	</cffunction>


	<cffunction name="getActivityId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.ActivityId />
	</cffunction>
	<cffunction name="setActivityId" output="false" access="public" returntype="void">
		<cfargument name="ActivityId" type="numeric" required="true" />
		<cfset variables.instance.ActivityId = arguments.ActivityId />
	</cffunction>
	
	<cffunction name="getUserId" output="false" access="public" returntype="numeric">
		<cfreturn variables.instance.UserId />
	</cffunction>
	<cffunction name="setUserId" output="false" access="public" returntype="void">
		<cfargument name="UserId" type="numeric" required="true" />
		<cfset variables.instance.UserId = arguments.UserId />
	</cffunction>	
	
	<cffunction name="getTimestamp" output="false" access="public" returntype="date">
		<cfreturn variables.instance.Timestamp />
	</cffunction>
	<cffunction name="setTimestamp" output="false" access="public" returntype="void">
		<cfargument name="Timestamp" type="date" required="true" />
		<cfset variables.instance.Timestamp = arguments.Timestamp />
	</cffunction>
	
	<cffunction name="getType" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Type />
	</cffunction>
	<cffunction name="setType" output="false" access="public" returntype="void">
		<cfargument name="Type" type="string" required="true" />
		<cfset variables.instance.Type = arguments.Type />
	</cffunction>	

	<cffunction name="getTypeReferenceId" output="false" access="public" returntype="string">
		<cfreturn variables.instance.TypeReferenceId />
	</cffunction>
	<cffunction name="setTypeReferenceId" output="false" access="public" returntype="void">
		<cfargument name="TypeReferenceId" type="string" required="true" />
		<cfset variables.instance.TypeReferenceId = arguments.TypeReferenceId />
	</cffunction>	

	<cffunction name="getPrimaryActivityType" output="false" access="public" returntype="string">
		<cfreturn variables.instance.PrimaryActivityType />
	</cffunction>
	<cffunction name="setPrimaryActivityType" output="false" access="public" returntype="void">
		<cfargument name="PrimaryActivityType" type="string" required="true" />
		<cfset variables.instance.PrimaryActivityType = arguments.PrimaryActivityType />
	</cffunction>	

	<cffunction name="getDescription" output="false" access="public" returntype="string">
		<cfreturn variables.instance.Description />
	</cffunction>
	<cffunction name="setDescription" output="false" access="public" returntype="void">
		<cfargument name="Description" type="string" required="true" />
		<cfset variables.instance.Description = arguments.Description />
	</cffunction>	


	<cffunction name="getEvents" output="false" access="public" returntype="array">
		<cfreturn instance.events />
	</cffunction>

	<cffunction name="getMemento" output="false" access="public" returntype="any">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>