<cfcomponent displayname="Util" hint="Tyson's Utility Belt" output="false"><cfsilent>

	<cffunction name="init" returntype="cfc.model.Util">
		<cfreturn this />
	</cffunction>

	<cffunction name="listDistinct" access="public" displayname="Returns a distinct ordered version of the input list." output="no" returntype="string" hint="Returns a string representing the distinct and ordered list.">
		<cfargument name="lstInput" type="string" required="yes" hint="String input list.">
		<cfargument name="strDelim" type="string" required="no" default="," hint="String indicating the list delimiter.">
		<cfargument name="blnSort" type="boolean" required="no" default="true" hint="Optional boolean indicating whether or not the final resulting list should be sorted (default is true).">

		<cfscript>
			var var_lstInput = arguments.lstInput;
			var var_strDelim = arguments.strDelim;

			// init our temp list
			var lstTemp = "";
			// init our boolean indicating if all list items are numeric
			var blnAllNumeric = true;
			var i = 0;
			var thisItem = 0;

			// loop through the original list
			for (i=1;i lte listLen(var_lstInput,var_strDelim);i=i+1) {
				thisItem = listGetAt(var_lstInput,i,var_strDelim);
				// if this item is not yet in the temp list
				if ( not listFindNoCase(lstTemp,thisItem,var_strDelim) ) {
					// add it to the temp list
					lstTemp = listAppend(lstTemp,thisItem,var_strDelim);
					// if all items thus far have been numeric and this item isn't
					if ( blnAllNumeric and not isNumeric(thisItem)) {
						// trip our all numeric flag
						blnAllNumeric = false;
					}
				}
			}
			// once we've built our temp list, sort it
			if ( blnAllNumeric ) {
				lstTemp = listSort(lstTemp,"numeric","asc",var_strDelim);
			} else {
				lstTemp = listSort(lstTemp,"textnocase","asc",var_strDelim);
			}
			// return the distinct, sorted list
			return lstTemp;
		</cfscript>
	</cffunction>

	<cffunction name="listDelete" access="public" description="Deletes items from a list." output="no" returntype="string">
		<cfargument name="items" required="yes" type="string"/>
		<cfargument name="list" required="no" type="string" default=""/>
		<cfargument name="delimiter" type="string" required="no" default="," hint="String indicating the list delimiter.">

		<cfscript>
		var string = "";
		//vars for use in the loop, so we don't have to evaluate lists and arrays more than once
		var ii = 1;
		var thisVar = "";
		var thisIndex = "";
		var array = "";

		//put the query string into an array for easier looping
		array = listToArray(ARGUMENTS.list,",");
		//now, loop over the array and rebuild the string
		for(ii = 1; ii lte arrayLen(array); ii = ii + 1){
			thisIndex = array[ii];
			thisVar = thisIndex;
			//if this is the var, edit it to the value, otherwise, just append
			if(not listFindnocase(ARGUMENTS.items,thisVar))
				string = listAppend(string,thisIndex,",");
		}

		//return the string
		return string;
		</cfscript>
	</cffunction>

	<cffunction name="listMid" access="public" displayname="Returns a subset of elements from a list." output="no" returntype="string" hint="Returns a string representing the subset list of the original input list as defined by the ""start position"" and ""number of elements"" arguments.">
		<cfargument name="list" type="string" required="yes" hint="String input list.">
		<cfargument name="startPos" type="numeric" required="yes" hint="Integer indicating the start position of the desired list subset.">
		<cfargument name="numElements" type="numeric" required="yes" hint="Integer indicating the number of elements to retrieve from start position for the desired list subset.">
		<cfargument name="delimiter" type="string" required="no" default="," hint="String indicating the list delimiter.">

		<cfscript>
			var var_list = arguments.list;
			var var_startPos = arguments.startPos;
			var var_numElements = arguments.numElements;
			var var_delimiter = arguments.delimiter;

			var tempList = "";
			var i = 0;
			var finish = var_startPos + var_numElements;

			if (var_startPos + var_numElements gt listLen(var_list, var_delimiter)) finish = listLen(var_list, var_delimiter)+1;
			for (i=var_startPos; i lt finish; i=i+1){
				tempList = listAppend(tempList, listGetAt(var_list, i, var_delimiter), var_delimiter);
			}
			return tempList;
		</cfscript>
	</cffunction>

	<cffunction name="listCompare" access="public" displayname="Returns a list of elements found in the first list, but not in the second list." output="no" returntype="string" hint="Returns a string list of the elements present in the first list that are not present in the second list.">
		<cfargument name="list1" type="string" required="yes" hint="String input list one.">
		<cfargument name="list2" type="string" required="yes" hint="String input list two.">
		<cfargument name="delim1" type="string" required="no" default="," hint="String indicating the list delimiter of list1.">
		<cfargument name="delim2" type="string" required="no" default="," hint="String indicating the list delimiter of list2.">
		<cfargument name="delim3" type="string" required="no" default="," hint="String indicating the list delimiter to be used in the resulting list.">

		<cfscript>
			var var_list1 = arguments.list1;
			var var_list2 = arguments.list2;
			var var_delim1 = arguments.delim1;
			var var_delim2 = arguments.delim2;
			var var_delim3 = arguments.delim3;

			var listTemp = "";
			var i = 0;

			for (i=1;i lte listLen(var_list1,var_delim1);i=i+1) {
				if (not listFindNoCase(var_list2,listGetAt(var_list1,i,var_delim1),var_delim2)) listTemp = listAppend(listTemp,listGetAt(var_list1,i,var_delim1),var_delim3);
			}
			return listTemp;
		</cfscript>
	</cffunction>

	<cffunction name="isEmail" access="public" returntype="boolean" output="false">
		<cfargument name="str" required="true" type="string" />

		<cfset StringUtil = application.wirebox.getInstance("StringUtil") />
		<cfreturn StringUtil.isEmail(str)>
		
	</cffunction>

	<cffunction name="verifyDSN" access="public" displayname="Verifies a ColdFusion datasource connection.  Utilizes internal undocumented ColdFusion services." output="no" returntype="boolean" hint="Returns a boolean value indicating whether ColdFusion was able to verify the specified datasource connection.">
	   <cfargument name="dsn" type="string" required="yes">

	   <!--- initialize variables --->
	   <cfset var dsService="">
	   <!--- try/catch block - throws errors if bad dsn --->
	   <cfset var result="true">
	   <cfset var factory = "" >

	   <cftry>
	      <!--- get "factory" --->
	      <cfobject action="create" type="java" class="coldfusion.server.ServiceFactory" name="factory">
	      <!--- get datasource service --->
	      <cfset dsService = factory.getDataSourceService()>
	      <!--- attempt to verify dsn --->
	      <cfset result = dsService.verifyDatasource(dsn)>

	      <!--- if any error, return false --->
		  <cfcatch type="any">
		     <cfset result = "false">
		  </cfcatch>
	   </cftry>

	   <cfreturn result>
	</cffunction>

	<cffunction name="isValidDate" access="public" displayname="Function for determining if a given date is properly formatted and valid." output="no" returntype="boolean" hint="Returns a boolean value indicating if the input date is properly formatted and is a valid calendar date.">
		<cfargument name="strDate" type="string" required="yes" hint="String input date.">

		<cfscript>
			var var_strDate = arguments.strDate;
			var blnValidDate = false;
			var thisMM = 0;
			var thisDD = 0;
			var thisYYYY = 0;
			var thisDate = 0;

			if (len(trim(var_strDate))) {
				if (listLen(var_strDate,"/") eq 3) {
					thisMM = listGetAt(var_strDate,1,"/");
					thisDD = listGetAt(var_strDate,2,"/");
					thisYYYY = listGetAt(var_strDate,3,"/");
					thisDate = "#thisMM#/#thisDD#/#thisYYYY#";
					if (
						len(trim(thisMM)) lte 2
						and len(trim(thisDD)) lte 2
						and ( len(trim(thisYYYY)) eq 4 or len(trim(thisYYYY)) eq 2 )
					) {
						if (
							thisMM gte 1 and thisMM lte 12
							and thisDD gte 1 and thisDD lte 31
						) {
							if (isDate(thisDate)) {
								blnValidDate = true;
							}
						}
					}
				}
			}
			return blnValidDate;
		</cfscript>
	</cffunction>

	<cffunction name="querySlice" access="public" displayname="Function for returning a subset of the original input query." output="no" returntype="query" hint="Returns a query recordset representing the subset of the original query as specified by the ""intStartRow"" and ""intRows"" arguments.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original query from which to return a subset.">
		<cfargument name="intStartRow" type="numeric" required="yes" hint="Numeric value indicating the starting row of the query subset to be returned.">
		<cfargument name="intRows" type="numeric" required="yes" hint="Numeric value indicating the number of rows to be included in the resulting query subset starting from the specified start row.">

		<cfscript>
			var var_qQuery = arguments.qQuery;
			var var_intStartRow = arguments.intStartRow;
			var var_intRows = arguments.intRows;

			var qQuerySlice = queryNew(var_qQuery.columnList);
			var intEndRow = var_intStartRow + var_intRows;
			var counter = 1;
			var x = "";
			var y = "";

			if (var_qQuery.recordCount) {
				if (intEndRow gt var_qQuery.recordCount) intEndRow = var_qQuery.recordcount+1;

				queryAddRow(qQuerySlice,intEndRow-var_intStartRow);

				for (x=1; x lte var_qQuery.recordCount; x=x+1) {
					if (x gte var_intStartRow and x lt intEndRow) {
						for (y=1; y lte listLen(var_qQuery.columnList); y=y+1) {
							querySetCell(qQuerySlice, listGetAt(var_qQuery.columnList, y), var_qQuery[listGetAt(var_qQuery.columnList, y)][x],counter);
						}
						counter = counter + 1;
					}
				}
			}

			return qQuerySlice;
		</cfscript>
	</cffunction>

	<cffunction name="queryToStruct" access="public" displayname="Converts a query recordset to a structure." output="yes" returntype="struct" hint="Returns a structure created from the original input query.  May also return error message if not properly used.">
		<cfargument name="strMode" type="string" required="yes" hint="Indicates the mode (multi or single).  Input queries with multiple records should use ""multi"" mode.  Single record queries should use ""single"" mode.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original query from which to create the new structure.">
		<cfargument name="primaryKey" type="string" required="no" default="" hint="Optional string indicating the primary key column name of a multi-record input query.">
		<cfargument name="lstColumns" type="string" required="no" default="" hint="Optional string list or columns to be converted into the struct.  Any columns not listed will be ignored.">

		<cfscript>
			var var_strMode = arguments.strMode;
			var var_qQuery = arguments.qQuery;
			var var_primaryKey = arguments.primaryKey;
			var var_lstColumns = arguments.lstColumns;
			var stcQuery = structNew();
			var i = 0;
			var ii = 0;
			var thisColumn = 0;

			if (not len(trim(var_lstColumns))) var_lstColumns = var_qQuery.columnList;

			// if the first argument passed indicates a proper "mode" value
			if (isSimpleValue(var_strMode) and (var_strMode eq "multi" or var_strMode eq "single") ) {
				// if we're operating in "multi" mode
				if (var_strMode eq "multi") {
					// if a primary key indicator was passed into the function
					if (len(trim(var_primaryKey))) {
						// determine the primary key column
//						primaryKey = arguments[3];
						// determine our query column list
//						lstColumns = qQuery.columnList;
						// if the column indicated as the primary key exists in the query column list
						if (listFindNoCase(var_lstColumns,var_primaryKey)) {
							// loop through the query
							for (i=1;i lte var_qQuery.recordCount;i=i+1) {
								// initialize a sub-struct in our primary struct for this query row
								stcQuery[var_qQuery[var_primaryKey][i]] = structNew();
								// loop through our column list
								for (ii=1;ii lte listLen(var_lstColumns);ii=ii+1) {
									thisColumn = listGetAt(var_lstColumns,ii);
									stcQuery[var_qQuery[var_primaryKey][i]][thisColumn] = var_qQuery[thisColumn][i];
								}
							}
						// if the column indicated as the primary key does not exist in the query column list
						} else {
							// throw an error
							writeOutput("<script language=""JavaScript"">alert('ERROR: UDF queryToStruct() cannot find primary key column ""#var_primaryKey#"" in the specified query!');</script>");
							return stcQuery;
						}
					// if a primary key indicator was not passed into the function
					} else {
						// throw an error
						writeOutput("<script language=""JavaScript"">alert('ERROR: UDF queryToStruct() has been called in ""multi"" mode withouth specifying a primary key argument!');</script>");
						return stcQuery;
					}
				// if we're operating in "single" mode
				} else if (var_strMode eq "single") {
					// determine our query column list
//					lstColumns = qQuery.columnList;
					// loop through our column list
					for (ii=1;ii lte listLen(var_lstColumns);ii=ii+1) {
						thisColumn = listGetAt(var_lstColumns,ii);
						stcQuery[thisColumn] = var_qQuery[thisColumn][1];
					}
				}
				// return the final struct
				return stcQuery;
			} else {
				// throw an error
				writeOutput("<script language=""JavaScript"">alert('ERROR: UDF queryToStruct() has been called with an invalid ""mode"" specification.\n\nValid mode values are ""multi"" and ""single"".');</script>");
				return stcQuery;
			}
		</cfscript>
	</cffunction>

	<cffunction name="queryToStructOfArrays" access="public" displayname="Converts a query recordset to a structure or array." output="yes" returntype="struct" hint="Returns a structure created from the original input query.  May also return error message if not properly used.">
		<cfargument name="strMode" type="string" required="yes" hint="Indicates the mode (multi or single).  Input queries with multiple records should use ""multi"" mode.  Single record queries should use ""single"" mode.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original query from which to create the new structure.">
		<cfargument name="primaryKey" type="string" required="no" default="" hint="Optional string indicating the primary key column name of a multi-record input query.">
		<cfargument name="lstColumns" type="string" required="no" default="" hint="Optional string list or columns to be converted into the struct.  Any columns not listed will be ignored.">

		<cfscript>
			var var_strMode = arguments.strMode;
			var var_qQuery = arguments.qQuery;
			var var_primaryKey = arguments.primaryKey;
			var var_lstColumns = arguments.lstColumns;
			var stcQuery = structNew();
			var stcThisRow = structNew();
			var i = 0;
			var ii = 0;
			var thisColumn = 0;

			if (not len(trim(var_lstColumns))) var_lstColumns = var_qQuery.columnList;

			// if the first argument passed indicates a proper "mode" value
			if (isSimpleValue(var_strMode) and (var_strMode eq "multi" or var_strMode eq "single") ) {
				// if we're operating in "multi" mode
				if (var_strMode eq "multi") {
					// if a primary key indicator was passed into the function
					if (len(trim(var_primaryKey))) {
						// if the column indicated as the primary key exists in the query column list
						if (listFindNoCase(var_lstColumns,var_primaryKey)) {
							// loop through the query
							for (i=1;i lte var_qQuery.recordCount;i=i+1) {
								// initialize a sub-struct in our primary struct for this query row if it's not already initialized
								if (not structKeyExists(stcQuery,var_qQuery[var_primaryKey][i]))
									stcQuery[var_qQuery[var_primaryKey][i]] = arrayNew(1);
								// init a new struct for this record
								stcThisRow = structNew();
								// loop through our column list and build the mini-struct for this row
								for (ii=1;ii lte listLen(var_lstColumns);ii=ii+1) {
									thisColumn = listGetAt(var_lstColumns,ii);
									stcThisRow[thisColumn] = var_qQuery[thisColumn][i];
								}
								// add this mini-struct to the array for this primary key value
								arrayAppend(stcQuery[var_qQuery[var_primaryKey][i]],stcThisRow);
							}
						// if the column indicated as the primary key does not exist in the query column list
						} else {
							// throw an error
							cfthrow("ERROR: queryToStructOfArrays() cannot find primary key column '#var_primaryKey#' in the specified query!");
						}
					// if a primary key indicator was not passed into the function
					} else {
						// throw an error
						cfthrow("ERROR: queryToStructOfArrays() has been called in 'multi' mode withouth specifying a primary key argument!");
					}
				// if we're operating in "single" mode
				} else if (var_strMode eq "single") {
					// loop through our column list
					for (ii=1;ii lte listLen(var_lstColumns);ii=ii+1) {
						thisColumn = listGetAt(var_lstColumns,ii);
						stcQuery[thisColumn] = var_qQuery[thisColumn][1];
					}
				}
				// return the final struct
				return stcQuery;
			} else {
				// throw an error
				cfthrow("ERROR: queryToStructOfArrays() has been called with an invalid 'mode' specification. Valid mode values are 'multi' and 'single'.");
			}
		</cfscript>
	</cffunction>

	<cffunction name="queryToStructOfSubQueries" access="public" displayname="Converts a query recordset to a structure." output="yes" returntype="struct" hint="Returns a structure created from the original input query.  May also return error message if not properly used.">
		<cfargument name="strMode" type="string" required="yes" hint="Indicates the mode (multi or single).  Input queries with multiple records should use ""multi"" mode.  Single record queries should use ""single"" mode.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original query from which to create the new structure.">
		<cfargument name="primaryKey" type="string" required="no" default="" hint="Optional string indicating the primary key column name of a multi-record input query.">
		<cfargument name="lstColumns" type="string" required="no" default="" hint="Optional string list or columns to be converted into the struct.  Any columns not listed will be ignored.">

		<cfscript>
			// declare vars
			var stcQuery = structNew();
		    var metadata = "";
		    var i = 0;
		    var col = "";

			strMode = arguments.strMode;
			qQuery = arguments.qQuery;
			primaryKey = arguments.primaryKey;
			lstColumns = arguments.lstColumns;
			lstColumnTypes = "";
			metadata = qQuery.getMetadata();

		    for (i = 1; i lte metadata.getColumnCount(); i = i+1) {
		        col = metadata.getColumnLabel(javaCast("int", i));
		        lstColumns = listAppend(lstColumns,col);
		        col = metadata.getColumnTypeName(javaCast("int", i));
		        lstColumnTypes = listAppend(lstColumnTypes,col);
		    }
			lstColumnTypes = lcase(lstColumnTypes);
			lstColumnTypes = replaceList(lstColumnTypes,'int,text,money,integer identity,uniqueidentifier,char,varvarchar,datetime,nvarchar','integer,varchar,decimal,integer,varchar,varchar,varchar,timestamp,varchar');

			if (not len(trim(lstColumns))) lstColumns = qQuery.columnList;

			// if the first argument passed indicates a proper "mode" value
			if (isSimpleValue(arguments.strMode) and (arguments.strMode eq "multi" or arguments.strMode eq "single") ) {
				// if we're operating in "multi" mode
				if (strMode eq "multi") {
					// if a primary key indicator was passed into the function
					if (len(trim(primaryKey))) {
						// determine the primary key column
//						primaryKey = arguments[3];
						// determine our query column list
//						lstColumns = qQuery.columnList;
						// if the column indicated as the primary key exists in the query column list
						if (listFindNoCase(lstColumns,primaryKey)) {
							// loop through the query
							for (i=1;i lte qQuery.recordCount;i=i+1) {
								if (not structKeyExists(stcQuery,qQuery[primaryKey][i])) {
									stcQuery[qQuery[primaryKey][i]] = queryNew(lstColumns,lstColumnTypes);
								}
								queryAddRow(stcQuery[qQuery[primaryKey][i]]);
								// loop through our column list
								for (ii=1;ii lte listLen(lstColumns);ii=ii+1) {
									thisColumn = listGetAt(lstColumns,ii);
									querySetCell(stcQuery[qQuery[primaryKey][i]],thisColumn,qQuery[thisColumn][i]);
								}
							}
						// if the column indicated as the primary key does not exist in the query column list
						} else {
							// throw an error
							writeOutput("<script language=""JavaScript"">alert('ERROR: UDF queryToStruct() cannot find primary key column ""#primaryKey#"" in the specified query!');</script>");
							return stcQuery;
						}
					// if a primary key indicator was not passed into the function
					} else {
						// throw an error
						writeOutput("<script language=""JavaScript"">alert('ERROR: UDF queryToStruct() has been called in ""multi"" mode withouth specifying a primary key argument!');</script>");
						return stcQuery;
					}
				// if we're operating in "single" mode
				} else if (strMode eq "single") {
					// determine our query column list
//					lstColumns = qQuery.columnList;
					// loop through our column list
					for (ii=1;ii lte listLen(lstColumns);ii=ii+1) {
						thisColumn = listGetAt(lstColumns,ii);
						stcQuery[thisColumn] = qQuery[thisColumn][1];
					}
				}
				// return the final struct
				return stcQuery;
			} else {
				// throw an error
				writeOutput("<script language=""JavaScript"">alert('ERROR: UDF queryToStruct() has been called with an invalid ""mode"" specification.\n\nValid mode values are ""multi"" and ""single"".');</script>");
				return stcQuery;
			}
		</cfscript>
	</cffunction>

	<cffunction name="structOfArraysSortedKeys" access="public" returntype="array" displayname="Returns an array of the sorted keys for a supplied struct of arrays based on the specified sort key/type.">
		<cfargument name="struct" type="struct" required="true">
		<cfargument name="keyName" type="string" required="true">
		<cfargument name="sortType" type="string" default="textnocase">
		<cfargument name="sortOrder" type="string" default="asc">
		<cfset var arrSortedKeys = arrayNew(1)>
		<cfset var thisItem = "">
		<cfset var localStruct = arguments.struct>
		<cfset var stcSimple = structNew()>

		<cfloop collection="#arguments.struct#" item="thisItem">
			<cfset stcSimple[thisItem] = structNew()>
			<cfset stcSimple[thisItem][arguments.keyName] = localStruct[thisItem][1][arguments.keyName]>
		</cfloop>

		<cfset arrSortedKeys = structSort(stcSimple,arguments.sortType,arguments.sortOrder,arguments.keyName)>

		<cfreturn arrSortedKeys>
	</cffunction>

	<cffunction name="queryToArray" access="public" displayname="Converts a query recordset to an array of structures." output="no" returntype="array" hint="Returns an array of structures created from the original input query.  May also return error message if not properly used.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original query from which to create the new array of structures structure.">
		<cfargument name="lstColumns" type="string" required="no" default="" hint="Optional string list or columns to be converted into the array of structs.  Any columns not listed will be ignored.">

		<cfscript>
			var arrReturn = arrayNew(1);
			var var_qQuery = arguments.qQuery;
			var var_lstColumns = arguments.lstColumns;
			var i = 0;
			var ii = 0;
			var thisColumn = 0;

			if (not len(trim(var_lstColumns))) var_lstColumns = var_qQuery.columnList;

			// loop through the query
			for (i=1;i lte var_qQuery.recordCount;i=i+1) {
				// add a new element to the return array for this query row
				arrReturn[i] = structNew();
				// loop through our column list
				for (ii=1;ii lte listLen(var_lstColumns);ii=ii+1) {
					thisColumn = listGetAt(var_lstColumns,ii);
					arrReturn[i][var_thisColumn] = var_qQuery[var_thisColumn][i];
				}
			}

			// return the final array
			return arrReturn;
		</cfscript>
	</cffunction>

	<cffunction name="queryRowToStruct" access="public" displayname="Converts the specified row of a query recordset as a structure." output="no" returntype="struct" hint="Returns a structure representing the specified row number of the input query.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original query from which to create the new structure.">
		<cfargument name="intRowNumber" type="numeric" required="yes" hint="Numeric value indicating the row number from which to create the desired structure.">

		<cfscript>
			var local = structNew();
			local.qQuery = arguments.qQuery;
			local.intRowNumber = arguments.intRowNumber;
			local.stcQuery = structNew();
			// determine our query column list
			local.lstColumns = local.qQuery.columnList;

			// loop through our column list
			for (local.ii=1;local.ii lte listLen(local.lstColumns);local.ii=local.ii+1) {
				local.thisColumn = listGetAt(local.lstColumns,local.ii);
				local.stcQuery[local.thisColumn] = local.qQuery[local.thisColumn][local.intRowNumber];
			}

			// return the final struct
			return local.stcQuery;
		</cfscript>
	</cffunction>

	<cffunction name="structToQuery" access="public" displayname="Converts a structure to a query recordset." output="yes" returntype="query" hint="Returns a query recordset created from the original input structure.  May also return error message if not properly used.">
		<cfargument name="strMode" type="string" required="yes" hint="Indicates the mode (multi or single).  Input structures with multiple sub-structures should use ""multi"" mode.  Single-level structures should use ""single"" mode.">
		<cfargument name="stcStruct" type="struct" required="yes" hint="Original struct from which to create the new query recordset.">

		<cfscript>
			var var_strMode = arguments.strMode;
			var var_stcStruct = duplicate(arguments.stcStruct);
			var qQuery = queryNew("error");
			var lstColumns = 0;
			var x = 0;
			var y = 0;

			// if the first argument passed indicates a proper "mode" value
			if (isSimpleValue(var_strMode) and (var_strMode eq "multi" or var_strMode eq "single")) {
				// if the input struct is not empty
				if (isStruct(var_stcStruct) and structCount(var_stcStruct)) {
					// if we're operating in "multi" mode
					if (var_strMode eq "multi") {
						// determine our column list from the keys that exist in the first sub-struct
						lstColumns = structKeyList(var_stcStruct[listFirst(structKeyList(var_stcStruct))]);
						qQuery = queryNew(lstColumns);

						// loop through the struct
						for (x in var_stcStruct) {
							// add a row to the query
							queryAddRow(qQuery);
							// loop through the sub-struct
							for (y in var_stcStruct[x]) {
								// add each key value to the query
								querySetCell(qQuery,y,var_stcStruct[x][y]);
							}
						}
					// if we're operating in "single" mode
					} else if (var_strMode eq "single") {
						// determine our column list from the keys in the struct
						lstColumns = structKeyList(var_stcStruct);
						qQuery = queryNew(lstColumns);
						// add a single row to the query
						queryAddRow(qQuery);

						// loop through the struct
						for (x in var_stcStruct) {
							// add each key value to the query
							querySetCell(qQuery,x,var_stcStruct[x]);
						}
					}
				// if the input struct is empty
				} else {
					// create a "dummy" query to be returned
					qQuery = queryNew("id");
				}
				// return the final query
				return qQuery;
			} else if (structCount(var_stcStruct)) {
				// throw an error
				writeOutput("<script language=""JavaScript"">alert('ERROR: UDF structToQuery() has been called with an invalid ""mode"" specification.\n\nValid mode values are ""multi"" and ""single"".');</script>");
				return qQuery;
			} else {
				return qQuery;
			}
		</cfscript>
	</cffunction>

	<cffunction name="queryDeleteColumns" access="public" displayname="Deletes specified columns from the input query." output="no" returntype="query" hint="Returns a query recordset with the specified column names removed.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original input query recordset.">
		<cfargument name="lstColumns" type="string" required="yes" hint="Comma-delimited list of column names to be removed from the input query.">

		<cfscript>
			var var_lstColumns = ucase(arguments.lstColumns);
			var var_qQuery = arguments.qQuery;

			// determine which columns exist in the input query
			var lstOriginalColumns = ucase(var_qQuery.columnList);
			// filter the specified columns from this list
			var lstFilteredColumns = replaceList(lstOriginalColumns,var_lstColumns,repeatString(",",listLen(var_lstColumns)));
			// create a new query object with the filtered columns
			var qReturn = queryNew(lstFilteredColumns);
			var i = 0;
			var j = 0;
			var thisColumn = 0;

			// loop through the input query
			for (i=1;i lte var_qQuery.recordCount;i=i+1) {
				// add a row to the return query
				queryAddRow(qReturn);
				// loop through the filtered column list
				for (j=1;j lte listLen(lstFilteredColumns);j=j+1) {
					thisColumn = listGetAt(lstFilteredColumns,j);
					querySetCell(qReturn,thisColumn,var_qQuery[thisColumn][i]);
				}
			}
		</cfscript>

		<cfreturn qReturn>
	</cffunction>

	<cffunction name="queryDeleteRows" access="public" displayname="Deletes specified rows from the input query." output="no" returntype="query" hint="Returns a query recordset with the specified row number(s) removed.">
		<cfargument name="qQuery" type="query" required="yes" hint="Original input query recordset.">
		<cfargument name="lstRows" type="string" required="yes" hint="Comma-delimited list of row numbers to be removed from the input query.">

		<!--- copy our input query and init our return query --->
		<cfset var var_qInput = arguments.qQuery >
		<cfset var qTemp = queryNew(var_qInput.columnList) >
		<cfset var thisColumn = 0 >


		<!--- loop through the input query --->
		<cfloop query="var_qInput">
			<!--- if this row numbers is not on our list to be removed --->
			<cfif not listFind(arguments.lstRows,var_qInput.currentRow)>
				<!--- copy this row from the input query to our return query --->
				<cfset queryAddRow(qTemp)>
				<!--- loop through the columns and copy all data from the input query to the return query --->
				<cfloop list="#var_qInput.columnList#" index="thisColumn">
					<cfset querySetCell(qTemp,thisColumn,var_qInput[thisColumn][var_qInput.currentRow])>
				</cfloop>
			</cfif>
		</cfloop>

		<cfreturn qTemp>
	</cffunction>

	<cffunction name="subQueryOrderBy" access="public" displayname="Orders the input query based on a specified single-column 'order by' request." output="no" returntype="query" hint="Returns the resulting sorted query object based on a single-column 'order by' without the use of query-of-queries.">
		<cfargument name="q" type="query" required="true">
		<cfargument name="pk" type="string" required="true">
		<cfargument name="sortCol" type="string" required="true">
		<cfargument name="sortType" type="string" default="text">
		<cfargument name="sortOrder" type="string" default="asc">
		<cfset var local = {}>
		<cfscript>
			local.lstColumns = "";
			local.lstColumnTypes = "";
			local.metadata = arguments.q.getMetadata();

			for (local.i = 1; local.i lte local.metadata.getColumnCount(); local.i = local.i+1) {
				local.thisCol = local.metadata.getColumnLabel(javaCast("int", local.i));
				local.lstColumns = listAppend(local.lstColumns,local.thisCol);
				local.thisCol = local.metadata.getColumnTypeName(javaCast("int", local.i));
				local.lstColumnTypes = listAppend(local.lstColumnTypes,local.thisCol);
			}
			local.lstColumnTypes = lcase(local.lstColumnTypes);
			lstColumnTypes = replaceList(lstColumnTypes,'int,text,money,integer identity,uniqueidentifier,char,varvarchar,datetime,nvarchar','integer,varchar,decimal,integer,varchar,varchar,varchar,timestamp,varchar');

			local.q = queryNew(local.lstColumns,local.lstColumnTypes);

			local.stcQ = queryToStruct("multi",arguments.q,arguments.pk);
			local.aSortedQ = structSort(local.stcQ,arguments.sortType,arguments.sortOrder,arguments.sortCol);

			for (local.i=1; local.i lte arrayLen(local.aSortedQ); local.i=local.i+1) {
				local.stcPointer = local.aSortedQ[local.i];
				local.row = local.stcQ[local.stcPointer];
				queryAddRow(local.q);
				for (local.j=1; local.j lte listLen(local.lstColumns); local.j=local.j+1) {
					querySetCell(local.q,listGetAt(local.lstColumns,local.j),local.row[listGetAt(local.lstColumns,local.j)]);
				}
			}
			return local.q;
		</cfscript>
	</cffunction>

	<cffunction name="subQueryMatchColumnsValues" access="public" displayname="Finds rows within the input query matching the supplied single-column criteria." output="no" returntype="query" hint="Returns the resulting subquery object based on a single-column match without the use of query-of-queries.">
		<cfargument name="q" type="query" required="true">
		<cfargument name="pk" type="string" required="true">
		<cfargument name="matchCol" type="string" required="true">
		<cfargument name="matchValue" type="string" required="true">
		<cfset var local = {}>
		<cfscript>
			local.lstColumns = "";
			local.lstColumnTypes = "";
			local.metadata = arguments.q.getMetadata();

			for (local.i = 1; local.i lte local.metadata.getColumnCount(); local.i = local.i+1) {
				local.thisCol = local.metadata.getColumnLabel(javaCast("int", local.i));
				local.lstColumns = listAppend(local.lstColumns,local.thisCol);
				local.thisCol = local.metadata.getColumnTypeName(javaCast("int", local.i));
				local.lstColumnTypes = listAppend(local.lstColumnTypes,local.thisCol);
			}
			local.lstColumnTypes = lcase(local.lstColumnTypes);
			lstColumnTypes = replaceList(lstColumnTypes,'int,text,money,integer identity,uniqueidentifier,char,varvarchar,datetime,nvarchar','integer,varchar,decimal,integer,varchar,varchar,varchar,timestamp,varchar');

			local.q = queryNew(local.lstColumns,local.lstColumnTypes);

//			local.stcQ = queryToStruct("multi",arguments.q,arguments.pk);

			for (local.i=1; local.i lte arguments.q.recordCount;local.i=local.i+1) {
//				local.row = local.stcQ[local.i];
				local.colValue = arguments.q[arguments.matchCol][local.i];
				local.rowMatch = false;
				if (find(",",arguments.matchValue)) {
					for (local.iValues = 1; local.iValues lte listLen(arguments.matchValue);local.iValues=local.iValues+1) {
						if (listFindNoCase(local.colValue,listGetAt(arguments.matchValue,local.iValues))) {
							local.rowMatch = true;
							break;
						}
					}
				} else if (listFindNoCase(local.colValue,arguments.matchValue)) {
					local.rowMatch = true;
				}

				if (local.rowMatch) {
					queryAddRow(local.q);
					for (local.j=1; local.j lte listLen(local.lstColumns); local.j=local.j+1) {
						querySetCell(local.q,listGetAt(local.lstColumns,local.j),arguments.q[listGetAt(local.lstColumns,local.j)][local.i]);
					}
				}
			}
			return local.q;
		</cfscript>
	</cffunction>

	<cffunction name="cfparam" access="public" displayname="Wrapper method for ColdFusion native &lt;cfparam&gt; tag." output="no" returntype="void" hint="Wrapper method for ColdFusion native &lt;cfparam&gt; tag.">
		<cfargument name="var_name" type="string" required="yes" hint="String variable name to be parammed.">
		<cfargument name="default_value" required="yes" hint="Default value to be used for this param.">

		<cfscript>
			if(not isDefined(var_name)) setVariable(var_name, default_value);
		</cfscript>
	</cffunction>

	<cffunction name="urlFormParam" access="public" displayname="Function that will param a variable to both the URL and FORM scopes, using the value of URL to default FORM." output="no" returntype="void" hint="Params the specified variable to the URL and FORM scopes.  Returns nothing.">
		<cfargument name="var_name" type="string" required="yes" hint="String variable name to be parammed.">
		<cfargument name="default_value" required="yes" hint="Default value to be assigned to the variable being parammed.">

		<cfscript>
			var var_var_name = arguments.var_name;
			var var_default_value = arguments.default_value;

			var urlName = "url.#var_var_name#";
			var formName = "form.#var_var_name#";

			if(not isDefined(urlName)) setVariable(urlName, var_default_value);
			if(not isDefined(formName)) setVariable(formName, evaluate(urlName));
		</cfscript>
	</cffunction>

	<cffunction name="cfcookie" access="public" displayname="Wrapper method for ColdFusion native &lt;cfcookie&gt; tag." output="no" returntype="void" hint="Wrapper method for ColdFusion native &lt;cfcookie&gt; tag.">
		<cfargument name="cookieName" type="string" required="yes" hint="String name of cookie to be set.">
		<cfargument name="cookieValue" type="string" required="yes" hint="String value of cookie to be set.">
		<cfargument name="cookieExpires" type="string" required="no" default="" hint="Optional string to be used in controlling cookie expiration (values of NOW, NEVER, or a date can be used).">
		<cfargument name="cookieDomain" type="string" required="no" default="" hint="Optional string used to determine domain ownership of the cookie.">

		<cfif not len(trim(arguments.cookieDomain))>
			<cfif not len(trim(arguments.cookieExpires))>
				<cfcookie name="#arguments.cookieName#" value="#arguments.cookieValue#">
			<cfelse>
				<cfcookie name="#arguments.cookieName#" value="#arguments.cookieValue#" expires="#arguments.cookieExpires#">
			</cfif>
		<cfelse>
			<cfif not len(trim(arguments.cookieExpires))>
				<cfcookie name="#arguments.cookieName#" value="#arguments.cookieValue#" domain="#arguments.cookieDomain#">
			<cfelse>
				<cfcookie name="#arguments.cookieName#" value="#arguments.cookieValue#" domain="#arguments.cookieDomain#" expires="#arguments.cookieExpires#">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="wddxFileRead" access="public" displayname="Function that will both read and deserialize a WDDX packet stored in a file." output="no" hint="Returns variable datatypes, depending on the datatype that is encoded in the WDDX packet being deserialized.">
		<cfargument name="file" type="string" required="yes" hint="Fully-qualified path to the file being read and deserialized.">

		<cfset var tempPacket = "">
		<cfset var tempVar = "">
		<!--- make sure the file exists, otherwise, throw an error --->
		<cfif not fileExists(file)>
			<cfthrow message="wddxFileRead() UDF error: File Does Not Exist" detail="The file #arguments.file# called in WDDXFileRead() does not exist.">
		</cfif>
		<!--- read the file --->
		<cffile action="read" file="#arguments.file#" variable="tempPacket">
		<!--- make sure it is a valid WDDX Packet --->
		<cfif not isWDDX(tempPacket)>
			<cfthrow message="WDDXFileRead() UDF error: Bad Packet" detail="The file #arguments.file# called in WDDXFileRead() does not contain a valid WDDX packet.">
		</cfif>
		<!--- deserialize --->
		<cfwddx action="wddx2cfml" input="#tempPacket#" output="tempVar">
		<cfreturn tempVar>
	</cffunction>

	<cffunction name="cfthrow" access="public" displayname="Wrapper method for ColdFusion native &lt;cfthrow&gt; tag." returntype="void" hint="Wrapper method for ColdFusion native &lt;cfthrow&gt; tag.">
		<cfargument name="detail" type="string" required="true" hint="detail of exception to be thrown">
		<cfthrow message="#arguments.detail#" detail="#arguments.detail#" />
	</cffunction>

	<cffunction name="cfdump" access="public" displayname="Wrapper method for ColdFusion native &lt;cfdump&gt; tag." output="yes" returntype="void" hint="Wrapper method for ColdFusion native &lt;cfdump&gt; tag.">
		<cfargument name="var" required="yes" hint="Any variable of any datatype to be dumped." />
		<cfargument name="expand" type="boolean" default="true" required="false" />
		
		<cfdump var="#arguments.var#" expand="#arguments.expand#" />
	</cffunction>

	<cffunction name="cfinclude" access="public" displayname="Wrapper method for ColdFusion native &lt;cfinclude&gt; tag." returntype="void" hint="Wrapper method for ColdFusion native &lt;cfinclude&gt; tag.">
		<cfargument name="template" type="string" required="true" hint="Path of file to be included.">
		<cfinclude template="#arguments.template#">
	</cffunction>

	<cffunction name="cflocation" access="public" displayname="Wrapper method for ColdFusion native &lt;cflocation&gt; tag." returntype="void" hint="Wrapper method for ColdFusion native &lt;cflocation&gt; tag.">
		<cfargument name="url" type="string" required="true" hint="URL of page to which we will be redirecting the request.">
		<cfargument name="addToken" type="boolean" required="no" default="false" hint="Boolean value indicating if CFID/CFTOKEN should be relayed in the cflocation process.">
		<cflocation addtoken="#arguments.addToken#" url="#arguments.url#">
	</cffunction>

	<cffunction name="cfabort" access="public" displayname="Wrapper method for ColdFusion native &lt;cfabort&gt; tag." output="no" returntype="void" hint="Wrapper method for ColdFusion native &lt;cfabort&gt; tag.">
		<cfabort>
	</cffunction>

	<cffunction name="cfflush" access="public" displayname="Wrapper method for ColdFusion native &lt;cfflush&gt; tag." output="no" returntype="void" hint="Wrapper method for ColdFusion native &lt;cfflush&gt; tag.">
		<cfflush>
	</cffunction>

	<cffunction name="cfmail" access="public" displayname="Wrapper method for ColdFusion native &lt;cflocation&gt; tag." returntype="void" hint="Wrapper method for ColdFusion native &lt;cfmail&gt; tag.">
		<cfargument name="MailFrom" type="string" required="true" />
		<cfargument name="MailTo" type="string" required="true" />
		<cfargument name="MailSubject" type="string" required="true" />
		<cfargument name="MailBody" type="string" required="true" />	
		<cfargument name="MailType" type="string" default="text/html" required="false" />
		
		<cfmail from="#arguments.MailFrom#" to="#arguments.MailTo#" subject="#arguments.MailSubject#" type="#arguments.MailType#">
			#arguments.MailBody#
		</cfmail>
		
	</cffunction>

	<cffunction name="queryStringStripParams" access="public" displayname="Returns a typical query string with the specified parameters and their values removed." output="no" returntype="string" hint="Returns the resulting query string after the specified parameters and associated values have been removed.">
		<cfargument name="query_string" type="string" required="true" hint="Original input query string to be processed.">
		<cfargument name="lstParams" type="string" required="true" hint="Comma-delimited list of parameters to be removed from the input query string.">

		<cfset var strReturn = "">
		<cfset var thisURLParam = "">
		<cfset var thisURLParamName = "">

		<!--- loop through the list of url params --->
		<cfloop list="#arguments.query_string#" delimiters="&" index="thisURLParam">
			<cfset thisURLParamName = listFirst(thisURLParam,"=")>
			<!--- if this url param is not on our list of params to strip --->
			<cfif not listFindNoCase(arguments.lstParams,thisURLParamName)>
				<!--- add this param to our return string --->
				<cfset strReturn = listAppend(strReturn,thisURLParam,"&")>
			</cfif>
		</cfloop>

		<cfreturn strReturn>
	</cffunction>

	<cffunction name="getFileSize" returntype="string">
		<cfargument name="pathFile" type="string" required="yes">

		<cfset var intFilesize = 0>
		<cfset var qFile = 0>

		<!--- get the file and its size --->
		<cfdirectory action="list" directory="#getDirectoryFromPath(arguments.pathFile)#" filter="#listLast(arguments.pathFile,"/\")#" name="qFile">
		<!--- if we found the file --->
		<cfif qFile.recordCount>
			<cfset intFilesize = qFile.size>
		</cfif>
		<cfreturn intFilesize>
	</cffunction>

	<cffunction name="stripAllBut" returntype="string">
		<cfargument name="strInput" type="string" required="yes" hint="Input string to be processed.">
		<cfargument name="strKeep" type="string" required="yes" hint="Input string to be stripped.">
		<cfargument name="strReplaceWith" type="string" required="no" default="" hint="Optional string to be used in replacing characters that don't match arguments.strKeep.">
		<cfargument name="blnCaseSensitive" type="boolean" required="no" default="true" hint="Optional boolean indicating is operation should be case-sensitive.">

		<cfscript>
			var badList = "\";
			var okList = "\\";
			var var_strKeep = replaceList(arguments.strKeep,badList,okList);

			if(arguments.blnCaseSensitive) return rereplace(arguments.strInput,"[^#var_strKeep#]","#arguments.strReplaceWith#","all");
			else return rereplaceNoCase(arguments.strInput,"[^#var_strKeep#]","#arguments.strReplaceWith#","all");
		</cfscript>
	</cffunction>

	<cffunction name="queryAddBlankColumn" returntype="query">
		<cfargument name="qQuery" type="query" required="yes" hint="Input query to which we will add the specified column.">
		<cfargument name="strColumnName" type="string" required="yes" hint="String name of new column to be added to this query.">
		<cfargument name="strColumnValue" type="string" required="no" default="" hint="Optional string value of new column to be added to this query.">

		<cfscript>
			var q = arguments.qQuery;
			var arrNewColumn = arrayNew(1);
			arraySet(arrNewColumn,1,q.recordCount,arguments.strColumnValue);
			queryAddColumn(q,arguments.strColumnName,arrNewColumn);
		</cfscript>

		<cfreturn q>
	</cffunction>

	<cffunction name="stripExtraWhiteSpace" output="false" returntype="string">
		<cfargument name="str" type="string" required="yes">

		<cfset var strReturn = str>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(9)#"," ","all")>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(10)#"," ","all")>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(13)#"," ","all")>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(32)#"," ","all")>
		<cfset strReturn = reReplaceNoCase(strReturn," +"," ","all")>
		<cfset strReturn = stripCR(strReturn)>

		<cfreturn strReturn>
	</cffunction>

	<cffunction name="stripAllWhiteSpace" output="false" returntype="string">
		<cfargument name="str" type="string" required="yes">

		<cfset var strReturn = str>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(9)#","","all")>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(10)#","","all")>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(13)#","","all")>
		<cfset strReturn = replaceNoCase(strReturn,"#chr(32)#","","all")>
		<cfset strReturn = reReplaceNoCase(strReturn," +","","all")>
		<cfset strReturn = stripCR(strReturn)>

		<cfreturn strReturn>
	</cffunction>

	<cffunction name="stripHTML" returntype="string">
		<cfargument name="str" type="string" required="yes">

		<cfset var strStripHTML = arguments.str>
		<cfset strStripHTML = reReplaceNoCase(strStripHTML,"<[^>]*>","","all")>

		<cfreturn strStripHTML>
	</cffunction>

	<cffunction name="tabDelimitedFileToStruct" returntype="struct">
		<cfargument name="pathFile" type="string" required="yes">

		<!--- init our return struct --->
		<cfset var stcReturn = structNew()>
		<!--- init our list of keys --->
		<cfset var lstKeys = "">
		<cfset var txtFile = "">
		<cfset var thisLine = "">
		<cfset var thisKey = "">
		<cfset var i = 0>

		<!--- read the tab-delimited file --->
		<cffile action="read" file="#arguments.pathFile#" variable="txtFile">

		<!--- loop through the lines in the files --->
		<cfloop list="#trim(txtFile)#" index="thisLine" delimiters="#chr(10)##chr(13)#">
			<cfset thisLine = trim(thisLine)>
			<!--- only continue if the line is not blank --->
			<cfif len(thisLine)>
				<!--- if this line does not begins with a "*" --->
				<cfif not left(thisLine,1) eq "*">
					<cfset thisKey = listGetAt(thisLine,1,"	")>
					<cfset stcReturn[thisKey] = structNew()>
					<cfloop from="1" to="#listLen(lstKeys)#" index="i">
						<cfset stcReturn[thisKey][listGetAt(lstKeys,i,",")] = trim(listGetAt(thisLine,i,"	"))>
					</cfloop>
				<!--- if this line begins with a "*" --->
				<cfelse>
					<!--- use this line to determine our key names in the sub-structs --->
					<cfset thisLine = replace(thisLine,"*","","one")>
					<cfset lstKeys = listChangeDelims(thisLine,",","	")>
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="getWeek" returntype="struct">
		<cfargument name="dtmDate" type="date" required="no" default="#now()#">

		<cfset var var_dtmDate = createDate(year(arguments.dtmDate),month(arguments.dtmDate),day(arguments.dtmDate))>
		<!--- init our return struct --->
		<cfset var stcWeek = structNew()>
		<!--- determine the ordinal day of the date that was specified --->
		<cfset var intDayOrdinal = dayOfWeek(var_dtmDate)>
		<cfset var i = 0>
		<!--- get the week beginning --->
		<cfset stcWeek.dtmWeekBegin = dateAdd("d",-1*(intDayOrdinal-1),var_dtmDate)>
		<!--- get the week ending --->
		<cfset stcWeek.dtmWeekEnd = dateAdd("d",7-intDayOrdinal,var_dtmDate)>
		<!--- get the week number --->
		<cfset stcWeek.intWeekNumber = week(stcWeek.dtmWeekBegin)>
		<!--- init our weekdays sub-struct --->
		<cfset stcWeek.stcDays = structNew()>
		<!--- loop and create the days of the week for this week --->
		<cfloop from="1" to="7" index="i">
			<cfset stcWeek.stcDays[i] = structNew()>
			<cfset stcWeek.stcDays[i].strDay = dayOfWeekAsString(i)>
			<cfset stcWeek.stcDays[i].dtmDate = dateAdd("d",i-1,stcWeek.dtmWeekBegin)>
		</cfloop>

		<cfreturn stcWeek>
	</cffunction>

	<cffunction name="fullUrlEncode" returntype="string" output="No">
		<cfargument name="strString" required="Yes" type="string">
		<cfscript>
			//found this on cflib.org
			  var encstr="";
			  var len=len(strString);
			  var i=1;
			  for(i=1; i LTE len; i=i+1) encstr = encstr & "%" & FormatBaseN(Asc(Mid(strString,i,1)),16);
			  return encstr;
		</cfscript>
	</cffunction>

	<cffunction name="fileCanRead" hint="Seems to work better than CF's FileExists function" returntype="boolean">
		<cfargument name="strFileName" type="string" required="Yes">
		<cfscript>
			var daFile = createObject("java", "java.io.File");
			daFile.init(JavaCast("string", arguments.strFileName));
			return daFile.canRead();
		</cfscript>
	</cffunction>

	<cffunction name="escapeSingleQuotes" access="public" displayname="Returns the original string with any single quotes escaped." output="no" returntype="string" hint="Returns the original string with any single quotes escaped.">
		<cfargument name="strString" type="string" required="yes" hint="String to be processed and escaped.">
		<cfset var strReturn = strString>
		<cfset strReturn = replaceNoCase(strReturn,"'","''","all")>
		<cfreturn strReturn>
	</cffunction>

	<cffunction name="nameCase" access="public" returntype="string" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfset var n = ucase(arguments.name)>
		<cfreturn reReplace(n,"([[:upper:]])([[:upper:]]*)","\1\L\2\E","all") />
	</cffunction>

	<cffunction name="mergeUrlFormVars" access="public" returntype="void" output="false">
		<cfset var x = "">
		<cfset request.p = structNew()>
		<cfset structAppend(request.p, url, true)>
		<cfset structAppend(request.p, form, true)>
		<cfset structDelete(request.p, "fieldNames", false)>
		<cfloop collection="#request.p#" item="x">
			<cfset request.p[x] = trim(request.p[x])>
		</cfloop>
	</cffunction>

	<cffunction name="createguid" access="public" returntype="string" output="false">
		<cfreturn insert("-", createuuid(), 23)>
	</cffunction>

	<cffunction name="convertToGersId" output="false" access="public" returntype="string">
		<cfargument name="userId" type="numeric" required="true" />

		<cfscript>
			var gersCustomerId = "";
			var hexString = "";
			var i = 0;
			var gersPrefix = '';
			
			hexString = FormatBaseN( arguments.userId, 16 );

			//Append zero's to get a length of 8
			for ( i=Len(hexString); i < 8; i++ )
			{
				hexString = "0" & hexString;
			}

			gersPrefix = application.wirebox.getInstance("TextDisplayRenderer").getGersCustomerIdPreFix();
			gersCustomerId = gersPrefix & UCase( hexString );
		</cfscript>

		<cfreturn gersCustomerId />
	</cffunction>


	<cffunction name="convertFromGersId" output="false" access="public" returntype="string">
		<cfargument name="gersCustomerId" type="string" required="true" />
		<cfset var userId = "" />

		<cfscript>
			hexString = Right( arguments.gersCustomerId, 8 );
			userId = InputBaseN( hexString, 16 );
		</cfscript>

		<cfreturn userId />
	</cffunction>

	<cffunction name="ArrayMerge" output="false" access="public" returntype="array">
		<cfargument name="Array1" type="array" required="true" />
		<cfargument name="Array2" type="array" required="true" />

		<cfscript>
		    var i=1;

			for (i = 1; i <= ArrayLen(Array2); i++)
			{
				ArrayAppend(Array1, Array2[i]);
			}
		</cfscript>

		<cfreturn Array1 />
	</cffunction>

<cffunction
	name="CSVToArray"
	access="public"
	returntype="array"
	output="false"
	hint="Takes a delimited text data file or chunk of delimited data and converts it to an array of arrays.">
 
	<!--- Define the arguments. --->
	<cfargument
		name="CSVData"
		type="string"
		required="false"
		default=""
		hint="This is the raw CSV data. This can be used if instead of a file path."
		/>
 
	<cfargument
		name="CSVFilePath"
		type="string"
		required="false"
		default=""
		hint="This is the file path to a CSV data file. This can be used instead of a text data blob."
		/>
 
	<cfargument
		name="Delimiter"
		type="string"
		required="false"
		default=","
		hint="The character that separate fields in the CSV."
		/>
 
	<cfargument
		name="Qualifier"
		type="string"
		required="false"
		default=""""
		hint="The field qualifier used in conjunction with fields that have delimiters (not used as delimiters ex: 1,344,343.00 where [,] is the delimiter)."
		/>
 
 
	<!--- Define the local scope. --->
	<cfset var LOCAL = StructNew() />
 
	<!---
		Check to see if we are dealing with a file. If we are,
		then we will use the data from the file to overwrite
		any csv data blob that was passed in.
	--->
	<cfif (
		Len( ARGUMENTS.CSVFilePath ) AND
		FileExists( ARGUMENTS.CSVFilePath )
		)>
 
		<!---
			Read the data file directly into the arguments scope
			where it can override the blod data.
		--->
		<cffile
			action="READ"
			file="#ARGUMENTS.CSVFilePath#"
			variable="ARGUMENTS.CSVData"
			/>
 
	</cfif>
 
 
	<!---
		ASSERT: At this point, whether we got the CSV data
		passed in as a data blob or we read it in from a
		file on the server, we now have our raw CSV data in
		the ARGUMENTS.CSVData variable.
	--->
 
 
	<!---
		Make sure that we only have a one character delimiter.
		I am not going traditional ColdFusion style here and
		allowing multiple delimiters. I am trying to keep
		it simple.
	--->
	<cfif NOT Len( ARGUMENTS.Delimiter )>
 
		<!---
			Since no delimiter was passed it, use thd default
			delimiter which is the comma.
		--->
		<cfset ARGUMENTS.Delimiter = "," />
 
	<cfelseif (Len( ARGUMENTS.Delimiter ) GT 1)>
 
		<!---
			Since multicharacter delimiter was passed, just
			grab the first character as the true delimiter.
		--->
		<cfset ARGUMENTS.Delimiter = Left(
			ARGUMENTS.Delimiter,
			1
			) />
 
	</cfif>
 
 
	<!---
		Make sure that we only have a one character qualifier.
		I am not going traditional ColdFusion style here and
		allowing multiple qualifiers. I am trying to keep
		it simple.
	--->
	<cfif NOT Len( ARGUMENTS.Qualifier )>
 
		<!---
			Since no qualifier was passed it, use thd default
			qualifier which is the quote.
		--->
		<cfset ARGUMENTS.Qualifier = """" />
 
	<cfelseif (Len( ARGUMENTS.Qualifier ) GT 1)>
 
		<!---
			Since multicharacter qualifier was passed, just
			grab the first character as the true qualifier.
		--->
		<cfset ARGUMENTS.Qualifier = Left(
			ARGUMENTS.Qualifier,
			1
			) />
 
	</cfif>
 
 
	<!--- Create an array to handel the rows of data. --->
	<cfset LOCAL.Rows = ArrayNew( 1 ) />
 
	<!---
		Split the CSV data into rows of raw data. We are going
		to assume that each row is delimited by a return and
		/ or a new line character.
	--->
	<cfset LOCAL.RawRows = ARGUMENTS.CSVData.Split(
		"\r\n?"
		) />
 
 
	<!--- Loop over the raw rows to parse out the data. --->
	<cfloop
		index="LOCAL.RowIndex"
		from="1"
		to="#ArrayLen( LOCAL.RawRows )#"
		step="1">
 
 
		<!--- Create a new array for this row of data. --->
		<cfset ArrayAppend( LOCAL.Rows, ArrayNew( 1 ) ) />
 
 
		<!--- Get the raw data for this row. --->
		<cfset LOCAL.RowData = LOCAL.RawRows[ LOCAL.RowIndex ] />
 
 
		<!---
			Replace out the double qualifiers. Two qualifiers in
			a row acts as a qualifier literal (OR an empty
			field). Replace these with a single character to
			make them easier to deal with. This is risky, but I
			figure that Chr( 1000 ) is something that no one
			is going to use (or is it????).
		--->
		<cfset LOCAL.RowData = LOCAL.RowData.ReplaceAll(
			"[\#ARGUMENTS.Qualifier#]{2}",
			Chr( 1000 )
			) />
 
		<!--- Create a new string buffer to hold the value. --->
		<cfset LOCAL.Value = CreateObject(
			"java",
			"java.lang.StringBuffer"
			).Init()
			/>
 
 
		<!---
			Set an initial flag to determine if we are in the
			middle of building a value that is contained within
			quotes. This will alter the way we handle
			delimiters - as delimiters or just character
			literals.
		--->
		<cfset LOCAL.IsInField = false />
 
 
		<!--- Loop over all the characters in this row. --->
		<cfloop
			index="LOCAL.CharIndex"
			from="1"
			to="#LOCAL.RowData.Length()#"
			step="1">
 
 
			<!---
				Get the current character. Remember, since Java
				is zero-based, we have to subtract one from out
				index when getting the character at a
				given position.
			--->
			<cfset LOCAL.ThisChar = LOCAL.RowData.CharAt(
				JavaCast( "int", (LOCAL.CharIndex - 1))
				) />
 
 
			<!---
				Check to see what character we are dealing with.
				We are interested in special characters. If we
				are not dealing with special characters, then we
				just want to add the char data to the ongoing
				value buffer.
			--->
			<cfif (LOCAL.ThisChar EQ ARGUMENTS.Delimiter)>
 
				<!---
					Check to see if we are in the middle of
					building a value. If we are, then this is a
					character literal, not an actual delimiter.
					If we are NOT buildling a value, then this
					denotes the end of a value.
				--->
				<cfif LOCAL.IsInField>
 
					<!--- Append char to current value. --->
					<cfset LOCAL.Value.Append(
						LOCAL.ThisChar.ToString()
						) />
 
 
				<!---
					Check to see if we are dealing with an
					empty field. We will know this if the value
					in the field is equal to our "escaped"
					double field qualifier (see above).
				--->
				<cfelseif (
					(LOCAL.Value.Length() EQ 1) AND
					(LOCAL.Value.ToString() EQ Chr( 1000 ))
					)>
 
					<!---
						We are dealing with an empty field so
						just append an empty string directly to
						this row data.
					--->
					<cfset ArrayAppend(
						LOCAL.Rows[ LOCAL.RowIndex ],
						""
						) />
 
 
					<!---
						Start new value buffer for the next
						row value.
					--->
					<cfset LOCAL.Value = CreateObject(
						"java",
						"java.lang.StringBuffer"
						).Init()
						/>
 
				<cfelse>
 
					<!---
						Since we are not in the middle of
						building a value, we have reached the
						end of the field. Add the current value
						to row array and start a new value.
 
						Be careful that when we add the new
						value, we replace out any "escaped"
						qualifiers with an actual qualifier
						character.
					--->
					<cfset ArrayAppend(
						LOCAL.Rows[ LOCAL.RowIndex ],
						LOCAL.Value.ToString().ReplaceAll(
							"#Chr( 1000 )#{1}",
							ARGUMENTS.Qualifier
							)
						) />
 
 
					<!---
						Start new value buffer for the next
						row value.
					--->
					<cfset LOCAL.Value = CreateObject(
						"java",
						"java.lang.StringBuffer"
						).Init()
						/>
 
				</cfif>
 
 
			<!---
				Check to see if we are dealing with a field
				qualifier being used as a literal character.
				We just have to be careful that this is NOT
				an empty field (double qualifier).
			--->
			<cfelseif (LOCAL.ThisChar EQ ARGUMENTS.Qualifier)>
 
				<!---
					Toggle the field flag. This will signal that
					future characters are part of a single value
					despite and delimiters that might show up.
				--->
				<cfset LOCAL.IsInField = (NOT LOCAL.IsInField) />
 
 
			<!---
				We just have a non-special character. Add it
				to the current value buffer.
			--->
			<cfelse>
 
				<cfset LOCAL.Value.Append(
					LOCAL.ThisChar.ToString()
					) />
 
			</cfif>
 
 
			<!---
				If we have no more characters left then we can't
				ignore the current value. We need to add this
				value to the row array.
			--->
			<cfif (LOCAL.CharIndex EQ LOCAL.RowData.Length())>
 
				<!---
					Check to see if the current value is equal
					to the empty field. If so, then we just
					want to add an empty string to the row.
				--->
				<cfif (
					(LOCAL.Value.Length() EQ 1) AND
					(LOCAL.Value.ToString() EQ Chr( 1000 ))
					)>
 
					<!---
						We are dealing with an empty field.
						Just add the empty string.
					--->
					<cfset ArrayAppend(
						LOCAL.Rows[ LOCAL.RowIndex ],
						""
						) />
 
				<cfelse>
 
					<!---
						Nothing special about the value. Just
						add it to the row data.
					--->
					<cfset ArrayAppend(
						LOCAL.Rows[ LOCAL.RowIndex ],
						LOCAL.Value.ToString().ReplaceAll(
							"#Chr( 1000 )#{1}",
							ARGUMENTS.Qualifier
							)
						) />
 
				</cfif>
 
			</cfif>
 
		</cfloop>
 
	</cfloop>
 
	<!--- Return the row data. --->
	<cfreturn( LOCAL.Rows ) />
 
</cffunction>


	<cffunction name="GetHostAddress" output="false" access="public" returntype="string">
		<cfargument name="host" type="string" required="true" />
		<cfset var userId = "" />

		<cfscript>
			/**
			* Performs a reverse DNS lookup.
			* 
			* @param host      The host name to lookup. (Required)
			* @return Returns an IP address. 
			* @author Ben Forta (ben@forta.com) 
			* @version 1, November 11, 2002 
			*/
			
			var iaclass = "";
			var addr = "";
			var ip = "";
			
			try 
			{
				iaclass = CreateObject("java", "java.net.InetAddress"); // Init class
				addr = iaclass.getByName(host); // Get address
				ip = addr.getHostAddress();				
			}
			catch (any e)
			{
				ip = 'error';
			}
		</cfscript>

		<cfreturn ip />
	</cffunction>

</cfsilent></cfcomponent>