<cfif Find("form.cfm", PATH_INFO) is 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif>

<cfparam name = "Text" default = "No">
<cfparam name = "ReferringURL" default = "">
<cfparam name = "UnitID" default = "#UnitCode#">
<cfparam name = "UnitPointID" default = "">
<cfparam name = "dataMonth" default = #DatePart("m", Now())#>
<cfparam name = "dataYear" default = #DatePart("yyyy", Now())#>
<cfparam name = "RecordID" default = 0>
<cfparam name = "Action" default = "Insert">
<cfparam name = "InputMethod" default = 0>

<cfif Find("#UnitCode#", UnitID) is 0>
	<cflocation url="../../index.cfm" addtoken="No">
	<cfabort>
</cfif>

<cfset FormValues = StructNew()>
<cfloop collection="#FORM#" item="VarName">
	<cfif FORM[VarName] is not "">
		<cfset val = StructInsert(FormValues, "#VarName#", "#FORM[VarName]#")>
	</cfif>
</cfloop>

<cfset CircDesks = "ART0003,COL0006,COL0005,LAW0003,MAN0003,MUS0003,SEL0203,SEL0103,SEL0303,SRL0003,YRL0710,YRL0703,YRL0713">

<!-------------------------------------------------------
|        variable pre-processing and query execution     |
-------------------------------------------------------->

<cfif Action is "Insert" or Action is "ReviseInsert" or Action is "Clear">
	<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_RefUnitCategory
		WHERE
		<cfif InputMethod is 1>
			UnitID LIKE '#UnitID#'
			AND InputMethodID = 1
		<cfelseif InputMethod is 2>
			UnitPointID = '#UnitPointID#'
			AND InputMethodID = 2
			<cfif listContainsNoCase(CircDesks, UnitPointID)>
				AND (TypeID IN ('01','02','10') AND ModeID IN ('01','02','03','04') AND ModeID <> '00')
			<cfelse>
				AND (TypeID <> '00' AND TypeID <> '03' AND TypeID <> '04' AND TypeID <> '07' AND TypeID <> '08' AND ModeID <> '00')
			</cfif>
		</cfif>
		ORDER BY PointID, TypeID, ServicePoint
	</cfquery>

	<cfif InputMethod is 2>
		<cfquery name="GetAllModes" datasource="#CircStatsDSN#">
			SELECT ModeID, SortOrder
			FROM RefMode
			WHERE ModeID <> '00'
			<cfif listContainsNoCase(CircDesks, UnitPointID)>
				AND ModeID IN ('01','02','03','04')
			</cfif>
			ORDER BY SortOrder
		</cfquery>
		<cfquery name="GetMode" dbtype="query">
			SELECT DISTINCT ModeID
			FROM GetUnitCategory
		</cfquery>
		<cfset Mode = ValueList(GetMode.ModeID, ",")>
		<cfset AllModes = ValueList(GetAllModes.ModeID, ",")>
	</cfif>
</cfif>

<cfif Action is "Update" or Action is "ReviseUpdate">
	<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_RefUnitCategory
		WHERE UnitID LIKE '<cfoutput>#UnitID#</cfoutput>'
		AND InputMethodID = 1
		ORDER BY PointID, TypeID
	</cfquery>
	<cfquery name="GetServicePoint" dbtype="query">
		SELECT DISTINCT ServicePoint, PointID
		FROM GetUnitCategory
		ORDER BY PointID
	</cfquery>
	<cfquery name="GetQuestionType" dbtype="query">
		SELECT DISTINCT QuestionType, TypeID
		FROM GetUnitCategory
		ORDER BY TypeID
	</cfquery>
	<cfquery name="GetMode" dbtype="query">
		SELECT DISTINCT Mode, ModeID
		FROM GetUnitCategory
		ORDER BY ModeID
	</cfquery>
	<cfquery name="GetRecord" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_ReferenceStatistics
		WHERE RecordID = <cfoutput>#RecordID#</cfoutput>
	</cfquery>
</cfif>

<cfif Action is "Insert" or Action is "ReviseInsert" or Action is "Clear">
	<cfif InputMethod is 1>
		<cfinclude template="tmpFormMonthly.cfm">
	<cfelseif InputMethod is 2>
		<cfinclude template="tmpFormRealTime.cfm">
	</cfif>
<cfelseif Action is "Update" or Action is "ReviseUpdate">
	<cfinclude template="tmpFormUpdate.cfm">
</cfif>