<!---cfif Find("form.cfm", CGI.HTTP_REFERER) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif--->

<CFPARAM NAME = "Text" DEFAULT = "No">
<CFPARAM NAME = "ReferringURL" DEFAULT = "">
<CFPARAM NAME = "UnitID" default = "#UnitCode#">
<CFPARAM NAME = "dataMonth" DEFAULT = #DatePart("m", Now())#>
<CFPARAM NAME = "dataYear" DEFAULT = #DatePart("yyyy", Now())#>
<CFPARAM NAME = "RecordID" default = 0>
<CFPARAM NAME = "Action" default = "Insert">
<CFPARAM NAME = "Comment" default = "">


<CFIF Find("#UnitCode#", UnitID) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif>

<!-------------------------------------------------------
|        variable pre-processing and query execution     |
-------------------------------------------------------->

<cfif Action IS "Insert" OR
      Action IS "Update" OR
	  Action IS "Delete" OR
	  Action IS "ReviseInsert" OR
	  Action IS "Clear" OR
	  Action IS "ReviseUpdate">
	<cfset FormValues = StructNew()>
	<CFLOOP COLLECTION="#FORM#" ITEM="VarName">
		<cfif FORM[VarName] IS NOT "">
			<cfset val = StructInsert(FormValues, "#VarName#", "#FORM[VarName]#")>
		</cfif>
	</CFLOOP>
	<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
	SELECT *
	FROM View_CircUnitCategory
	WHERE UnitID LIKE '<cfoutput>#UnitID#</cfoutput>'
	AND DataSource = 2
	ORDER BY UnitID, CircGroupSort, CategorySort
	</cfquery>
	<cfif Action IS "Update" OR Action IS "ReviseUpdate">
		<cfquery name="GetRecord" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_CircManualStats
		WHERE RecordID = <cfoutput>#RecordID#</cfoutput>
		</cfquery>
	</cfif>		
</cfif>


<cfif Action IS "UpdateComment" OR
      Action IS "ReviseUpdateComment">
	<cfquery name="GetUnit" datasource="#CircStatsDSN#">
	<cfoutput>
	SELECT *
	FROM CircUnit
	WHERE UnitID = '#UnitID#'
	</cfoutput>
	</cfquery>
	<cfquery name="GetComments" datasource="#CircStatsDSN#">
	<cfoutput>
    SELECT CC.CommentID,
           CC.Comment,
           CC.UnitID,
           CU.Unit,
           CC.dataMonth,
           CC.dataYear,
           CC.LogonID,
           CC.Created_DT,
           CC.Updated_DT
    FROM CircComment CC
    JOIN CircUnit CU ON CU.UnitID = CC.UnitID
	WHERE CommentID = #CommentID#
	</cfoutput>
	</cfquery>
</cfif>


			
<cfif Action IS "Insert" OR
      Action IS "ReviseInsert" OR
	  Action IS "Clear">
	<cfinclude template="tmpFormMonthly.cfm">
<cfelseif Action IS "Update" OR
          Action IS "ReviseUpdate">
	<cfinclude template="tmpFormUpdate.cfm">
<cfelseif Action IS "UpdateComment" OR
          Action IS "ReviseUpdateComment">
	<cfinclude template="tmpFormUpdateComment.cfm">
</cfif>