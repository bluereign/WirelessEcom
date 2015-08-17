	<!---
	Copyright 2008 Jason Delmore
    All rights reserved.
    jason@jasondelmore.com
	
	This file is part of CFXL.

    CFXL is free software: you can redistribute it and/or modify
    it under the terms of the Lesser GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    CFXL is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Lesser GNU General Public License for more details.

    You should have received a copy of the Lesser GNU General Public License
    along with CFXL.  If not, see <http://www.gnu.org/licenses/>.
	--->
	
<cfcomponent hint="This Component exposes many functions of the POI API." output="false">

	<cffunction name="init" access="public" returntype="any" output="false">
        <cfargument name="sourceFile" type="string" required="no" default=""/>
		<cfset initializeJavaLoader("cfc.com.compoundtheory.javaloader.JavaLoader")/><!--- change path to javaloader if needed--->
		<cfset setOutputStream(createJavaObject("java.io.ByteArrayOutputStream").init())/>
        <cfset setWorkbook(arguments.sourcefile)>
		<cfset setSheet()/>
		<cfset setRow()/>
        <cfreturn this/>
    </cffunction>
	
    <cffunction name="initializeJavaLoader" access="private" returntype="void" output="false">
		<cfargument name="javaloaderpath" type="string" required="no" default="com.compundtheory.javaloader.JavaLoader"/>
		<cfset var paths = arraynew(1)/>
		<cfset var thisPath = GetDirectoryFromPath(getCurrentTemplatePath())/>
		<cfset variables.javaloader = javacast("null","java.lang.Object")/>
		
		<cfset paths[1] = thisPath & "poi.jar"/>
		<cfset paths[2] = thisPath & "poi-contrib.jar"/>
		<cfset paths[3] = thisPath & "poi-ooxml.jar"/>
		<cfset paths[4] = thisPath & "poi-scratchpad.jar"/>
		<cfset variables.javaloader = createObject("component", arguments.javaloaderpath).init(paths)/>
	</cffunction>
	
	<cffunction name="createJavaObject" access="private" returntype="any" output="false">
		<cfreturn variables.javaloader.create(arguments[1])/>
    </cffunction>
	
    <cffunction name="setOutputStream" access="public" returntype="any" output="false">
        <cfset variables.OutputStream = arguments[1]/>
		<cfreturn variables.OutputStream/>
    </cffunction>

    <cffunction name="getOutputStream" access="public" returntype="any" output="false">
        <cfreturn variables.OutputStream/>
    </cffunction>
    
	<cffunction name="setWorkbook" access="public" returntype="any" output="false">
		<cfargument name="sourceFile" type="string" required="no" default=""/>
		<cfset var local = structnew()/>
		<cfif len(arguments.sourcefile)>
			<!--- reading in a new file... can be any format --->
			<cfset local.sourceFileObj = createJavaObject("java.io.FileInputStream").init(arguments.sourceFile)/>
			<cfset local.WorkbookFactory = createJavaObject("org.apache.poi.ss.usermodel.WorkbookFactory")/>
			<cfset variables.outputWorkbook = local.WorkbookFactory.create(local.sourceFileObj)/>
        <cfelse>
			<cfset variables.outputWorkbook = createJavaObject("org.apache.poi.hssf.usermodel.HSSFWorkbook").init()/>
        </cfif>
		<cfreturn variables.outputWorkbook/>
    </cffunction>

    <cffunction name="getWorkbook" access="public" returntype="any" output="false">
        <cfreturn variables.outputWorkbook/>
    </cffunction>
    
    <cffunction name="setSheet" access="public" returntype="any" output="false">
        <cfargument name="sheet" required="no" default="0"/>
		<cfif isNumeric(arguments.sheet)>
			<cfif arguments.sheet lt getWorkbook().getNumberOfSheets()><!--- the sheet exists--->
            	<cfset variables.sheet = getWorkbook().getSheetAt(JavaCast("int",arguments.sheet))/>
			<cfelse>
                <cfset variables.sheet = getWorkbook().createSheet("Sheet#getWorkbook().getNumberOfSheets()+1#")/>
			</cfif>
         <cfelse><!--- the sheet exists--->
            <cfif isObject(getWorkbook().getSheet(JavaCast("string",arguments.sheet)))>
				<cfset variables.sheet = getWorkbook().getSheet(JavaCast("string",arguments.sheet))/>
            <cfelse>
                <cfset variables.sheet = getWorkbook().createSheet("#arguments.sheet#")/>
			</cfif>
		</cfif>
		<cfreturn variables.sheet/>
    </cffunction>
    
    <cffunction name="getSheet" access="public" returntype="any" output="false">
        <cfreturn variables.sheet/>
    </cffunction>

	<cffunction name="setRow" access="public" returntype="any" output="false">
        <cfargument name="rowNum" type="numeric" required="yes" default="1"/>
		<cfset variables.row = getSheet().getRow(JavaCast("int",convertExcelRow(arguments.rowNum)))/>
		<cfif not isDefined("variables.row")>
			<cfset variables.row = getSheet().createRow(JavaCast("int",convertExcelRow(arguments.rowNum)))/>
		</cfif>
		<cfreturn variables.row/>
    </cffunction>
    
    <cffunction name="getRow" access="public" returntype="any" output="false">
        <cfreturn variables.row/>
    </cffunction>
    
	<cffunction name="setCell" access="public" returntype="any" output="false">
        <cfargument name="columnNum" type="any" required="yes"/>
        <cfargument name="rowNum" type="numeric" required="no"/>
        <cfargument name="newValue" type="any" required="no"/>
		<cfargument name="cellType" type="any" required="no"/>
		<cfif isDefined("arguments.rowNum")>
			<cfset setRow(arguments.rowNum)>
		</cfif>
		<cfset variables.cell = getRow().getCell(JavaCast("int",convertExcelColumn(arguments.columnNum)))>
        <cfif not isDefined("variables.cell")>
			<cfset variables.cell = getRow().createCell(JavaCast("int",convertExcelColumn(arguments.columnNum)))>
		</cfif>
		<cfif isDefined("arguments.newValue")>
			<cfif isDefined("arguments.cellType")>
				<cfset setCellValue(arguments.newValue,arguments.cellType)>
			<cfelse>
				<cfset setCellValue(arguments.newValue)>
			</cfif>
		</cfif>
		<cfreturn variables.cell/>
    </cffunction>
	
	<cffunction name="getCell" access="public" returntype="any" output="false">
        <cfreturn variables.cell/>
    </cffunction>
	
	<cffunction name="setCellValue" access="public" returntype="any" output="false">
        <cfargument name="newValue" type="any" required="yes"/>
		<cfargument name="cellType" type="any" required="no" hint="Possible values: numeric, string, formula, blank, boolean"/>
		<cfset var cellTypeInt = getCell().getCellType()/>
		<cfif isDefined("arguments.cellType")>
			<cfset cellTypeInt = evaluate("getCell().CELL_TYPE_" & UCASE(arguments.cellType))/>
		</cfif>
		
		<cfswitch expression="#cellTypeInt#">
			<cfcase value="0"><!--- CELL_TYPE_NUMERIC --->
				<cfset getCell().setCellValue(JavaCast("double",arguments.newValue))/>
			</cfcase>
			<cfcase value="1"><!--- CELL_TYPE_STRING --->
				<cfset getCell().setCellValue(arguments.newValue)/>
			</cfcase>
			<cfcase value="2"><!--- CELL_TYPE_FORMULA --->
				<cfset getCell().setCellFormula(arguments.newValue)/>
			</cfcase>
			<cfcase value="3"><!--- CELL_TYPE_BLANK --->
				<cfset getCell().setCellValue(arguments.newValue)/>
			</cfcase>
			<cfcase value="4"><!--- CELL_TYPE_BOOLEAN --->
				<cfset getCell().setCellValue(JavaCast("boolean",arguments.newValue))/>
			</cfcase>
			<cfcase value="5"><!--- CELL_TYPE_ERROR --->
				<cfset getCell().setCellValue(arguments.newValue)/>
			</cfcase>
		</cfswitch>
		<cfreturn getCell()/>
    </cffunction>
	
	<cffunction name="getCellValue" access="public" returntype="any" output="false">
        <cfargument name="columnNum" type="any" required="yes"/>
        <cfargument name="rowNum" type="numeric" required="no"/>
		<cfif isDefined("arguments.rowNum")>
			<cfset setCell(arguments.columnNum,arguments.rowNum)>
		<cfelse>
			<cfset setCell(arguments.columnNum)>
		</cfif>
		
		<cfswitch expression="#getCell().getCellType()#">
			<cfcase value="0"><!--- CELL_TYPE_NUMERIC --->
				<cfif createJavaObject("org.apache.poi.ss.usermodel.DateUtil").isCellDateFormatted(getCell())>
					<cfreturn getCell().getDateCellValue()/>
				<cfelse>
					<cfreturn getCell().getNumericCellValue()/>
				</cfif>
			</cfcase>
			<cfcase value="1"><!--- CELL_TYPE_STRING --->
				<cfreturn getCell().getRichStringCellValue().getString()/>
			</cfcase>
			<cfcase value="2"><!--- CELL_TYPE_FORMULA --->
				<cfreturn getCell().getCellFormula()/>
			</cfcase>
			<cfcase value="3"><!--- CELL_TYPE_BLANK --->
				<cfreturn ""/>
			</cfcase>
			<cfcase value="4"><!--- CELL_TYPE_BOOLEAN --->
				<cfset getCell().getBooleanCellValue()/>
			</cfcase>
			<cfcase value="5"><!--- CELL_TYPE_ERROR --->
				<cfreturn ""/>
			</cfcase>
		</cfswitch>
		<cfreturn getCell()/>
    </cffunction>

    <cffunction name="removeRow" access="public" returntype="void" output="false">
       <cfargument name="row" type="numeric" required="yes"/>
       <cfset getSheet().removeRow(JavaCast("int",convertExcelRow(arguments.row)))/>
    </cffunction>

    <cffunction name="autoSizeColumn" access="public" returntype="void" output="false">
       <cfargument name="column" type="string" required="yes"/>
       <cfset getSheet().autoSizeColumn(JavaCast("int", convertExcelColumn(arguments.column))) />
    </cffunction>

    <cffunction name="setCellDataFormat" access="public" returntype="void" output="false">
    	<cfargument name="dataFormat" type="string" required="yes"/>
	   
	   <cfscript>
	   		var format = getWorkbook().createDataFormat();
	   		var style = getWorkbook().createCellStyle();
		    style.setDataFormat(format.getFormat( arguments.dataFormat ));
		    getCell().setCellStyle( style );
	   </cfscript>

    </cffunction>

    <cffunction name="convertExcelColumn" access="private" returntype="numeric" output="false" hint="Converts the alphabetical value for column displayed in excel to the numeric POI wants.">
        <cfargument name="column" type="any" required="yes"/>
        <cfset var alpha = ""/>
        <cfset var alphaList = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z'/>
        <cfset var alphaListIndex = ""/>
        <cfset var totalValue = 0/>
        <cfset var columnValue = 0/>
        <cfset var conversionValue = 0/>
        <cfset var invertColumn = Reverse(column)/>
        
		<cfif isNumeric(arguments.column)>
	        <cfreturn arguments.column-1/>
	    <cfelse>
	    	<cfloop index="columnIndex" from="1" to="#Len(invertColumn)#" step="1">
	            <cfset alpha = Mid(invertColumn,columnIndex,1)/>
	            <cfset alphaListIndex = ListFindNoCase(alphaList, alpha)/>
	            <cfset columnValue = (26^(columnIndex-1)) * alphaListIndex/>
	            <cfset totalValue = totalValue + columnValue/>
	        </cfloop>
	        <cfset conversionValue = totalValue-1/>
	        <cfreturn conversionValue/>
	    </cfif>
    </cffunction>

    <cffunction name="convertExcelRow" access="private" returntype="numeric" output="false" hint="Converts the value for row displayed in excel to the value POI wants (POI starts with 0 rather than 1).">
       <cfargument name="row" type="numeric" required="yes"/>
       <cfreturn arguments.row-1/>
    </cffunction>

    <cffunction name="closeWorkbook" access="public" output="false">
       <cfset getWorkbook().write(getOutputStream())/>
       <cfset getOutputStream().flush()/>
       <cfset getOutputStream().close()/>
    </cffunction>
    
    <cffunction name="writeWorkbook" access="public" returntype="void" output="false">
       <cfargument name="outputFile" type="string" required="yes"/>
       <cfset closeWorkbook()/>
       <cffile action="write" addnewline="no" file="#arguments.outputFile#" mode="777" output="#getOutputStream().toByteArray()#"/>
    </cffunction>

    <cffunction name="viewWorkbook" access="public" returntype="void" output="false">
       <cfset var filename = createUUID() & '.xls'/>
	   <cfset closeWorkbook()/>
       <cfheader name="Content-Disposition" value="inline;filename=#filename#">
       <cfcontent type="application/msexcel" variable="#getOutputStream().toByteArray()#">
    </cffunction>
</cfcomponent>