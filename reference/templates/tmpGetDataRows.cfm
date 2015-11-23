<!---cfif Find("edit.cfm", PATH_INFO) IS 0>
	<cflocation url="../../index.cfm" addtoken="No">
	<cfabort>
</cfif-->

<CFPARAM NAME = "Text" DEFAULT = "No">

<CFPARAM NAME = "UnitID" default = "#UnitCode#">
<CFPARAM NAME = "DefaultPage" DEFAULT = 1>
<CFPARAM NAME = "dataMonth" DEFAULT = 0>
<CFPARAM NAME = "dataYear" DEFAULT = 0>
<CFPARAM NAME = "InputMethod" DEFAULT = 1>
<CFPARAM NAME = "SortOrder" DEFAULT = "D">
<CFPARAM NAME = "Flag" DEFAULT = 0>
<cfif Flag IS "0">
	<cfset Flag = 1>
<cfelseif Flag IS "1">
	<cfset Flag = 0>
</cfif>

<CFIF Find("#UnitCode#", UnitID) IS 0>
	<CFLOCATION URL="../../index.cfm" ADDTOKEN="No">
	<CFABORT>
</cfif>

<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT DISTINCT Unit, UnitID, ParentUnit, SubUnitID
FROM View_RefUnitCategory
WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
</cfquery>

<cfquery name="GetAllDataRows" datasource="#CircStatsDSN#">
SELECT * FROM view_ReferenceStatistics
WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
</cfquery>
<cfquery name="GetDataRanges" datasource="#CircStatsDSN#">
SELECT MAX(MonthYear) AS LatestDBDate
FROM view_ReferenceStatistics
WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
</cfquery>

<cfif GetAllDataRows.RecordCount IS NOT 0>
	<cfif dataMonth IS 0>
		<cfset dataMonth = DatePart("m", GetDataRanges.LatestDBDate)>
	<cfelse>
		<cfset dataMonth = dataMonth>
	</cfif>
	<cfif dataYear IS 0>
		<cfset dataYear = DatePart("yyyy", GetDataRanges.LatestDBDate)>
	<cfelse>
		<cfset dataYear = dataYear>
	</cfif>
	<cfquery name="GetLimitedDataRows" dbtype="query">
	SELECT * FROM GetAllDataRows
		WHERE dataMonth = <cfoutput>#dataMonth#</cfoutput>
		AND dataYear = 	<cfoutput>#dataYear#</cfoutput>
		AND InputMethod = 1
	<cfif IsDefined("SortOrder")>
		<cfswitch expression="#SortOrder#">
			<cfcase value="SP">
		ORDER BY ServicePoint
			</cfcase>
			<cfcase value="QT">
		ORDER BY QuestionType
			</cfcase>
			<cfcase value="M">
		ORDER BY Mode
			</cfcase>
			<cfcase value="D">
		ORDER BY dataYear, dataMonth
			</cfcase>
			<cfcase value="C">
		ORDER BY Count
			</cfcase>
			<cfcase value="DT">
		ORDER BY Updated_DT
			</cfcase>
			<cfcase value="U">
		ORDER BY LogonID
			</cfcase>
		</cfswitch>
		<cfif Flag IS 0>
			DESC
		<cfelseif Flag IS 1>
		    ASC
		</cfif>
	</cfif>
	</cfquery>
</cfif>

<html>
<head>
	<title>UCLA Library Reference Statistics Data Edit: <cfoutput>#GetUnit.Unit#</cfoutput></title>
<script language=Javascript>
<!--// 

function popups1(encoded_url) {
_loc = encoded_url;
popupsWin = window.open(_loc,"PSpopups","toolbar=no,width=250,height=250,screenY=100,screenX=200,top=100,left=200,scrollbars=no,resizable=yes");
if (popupsWin.opener == null) { popupsWin.opener = self }
}
// end function

// -->
</script>

	
	
<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/banner.cfm">
	<cfinclude template="../../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->
	<a href="../../../home.cfm">Public Service Statistics</a> &gt; <a href="../../index.cfm">Reference</a> &gt; <a href="../index.cfm"><cfoutput>#GetUnit.ParentUnit#</cfoutput></a> &gt; Data Edit

<!-- end you are here -->
<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>


<!--begin main content-->

<cfoutput>
<h1>Edit Data: #GetUnit.Unit#</h1>
<cfif DefaultPage>
	<cfif GetAllDataRows.RecordCount IS NOT 0>
<p>From this page, it is possible to view and/or change data stored in the database. Data are displayed by month/year and currently you are viewing data for <strong>#MonthAsString(dataMonth)#</strong>, <strong>#dataYear#</strong>. You can specify different months/years using the form below.</p>
	<cfelse>
<p>No data available.</p>
	</cfif>

<cfelse>
	<cfif GetLimitedDataRows.RecordCount IS NOT 0>
<p>You are currently viewing data for <strong>#MonthAsString(dataMonth)#</strong>, <strong>#dataYear#</strong>. You can view data for other time periods by selecting a month/year using the form below.</p>		
	<cfelse>
<p>No data available for <strong>#MonthAsString(dataMonth)#</strong>, <strong>#dataYear#</strong>.</p>
	</cfif>
</cfif>
</cfoutput>




<cfif GetAllDataRows.RecordCount IS NOT 0>

<table border="0" cellspacing="0" cellpadding="1" bgcolor="#336699">
<tr>
	<td class="menu">
&nbsp;Select a <cfif GetLimitedDataRows.RecordCount IS 0>different</cfif> month/year
	</td>
</tr>
<tr>
	<td>
	<table border="0" cellspacing="0" cellpadding="6" bgcolor="#EBF0F7">
	<tr>
		<td>
<cfoutput>
<form action="edit.cfm" method="post" class="form">
<cfif GetLimitedDataRows.RecordCount IS NOT 0>You are viewing data for</cfif>
<select name="dataMonth" class="form">
	<cfloop index="Month" from="1" to="12">
	<option value="#Month#" class="form"
		<cfif Month IS dataMonth>selected</cfif>>#MonthAsString(Month)#</option>
	</cfloop>
</select>

<select name="dataYear" class="form">
	<cfloop index="Year" from="2001" to="#DatePart("yyyy", Now())#">
	<option value="#Year#" class="form"
		<cfif Year IS dataYear>selected</cfif>
	>#Year#</option>
	</cfloop>
</select>
<input type="submit" value="Change month/year" class="form">
<input type="hidden" name="Action" value="Select">
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="DefaultPage" value="0">
</cfoutput>
		</td>
	</tr>
    </table>
	</td>
</tr>
</form>
</table>
<br>


	<cfif GetLimitedDataRows.RecordCount IS NOT 0>
<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="top" bgcolor="#EBF0F7">
			<cfoutput>
	<td class="small"><strong>Unit</strong></td>
	<td class="small"><strong><a href="edit.cfm?dataMonth=#dataMonth#&dataYear=#dataYear#&SortOrder=SP&Flag=#Flag#">Service point</a></strong></td>
	<td class="small"><strong><a href="edit.cfm?dataMonth=#dataMonth#&dataYear=#dataYear#&SortOrder=QT&Flag=#Flag#">Question type</a></strong></td>
	<td class="small"><strong><a href="edit.cfm?dataMonth=#dataMonth#&dataYear=#dataYear#&SortOrder=M&Flag=#Flag#">Mode</a></strong></td>
	<td align="right" class="small"><strong><a href="edit.cfm?dataMonth=#dataMonth#&dataYear=#dataYear#&SortOrder=C&Flag=#Flag#">Value</a></strong></td>
	<td align="center" class="small"><strong><a href="edit.cfm?dataMonth=#dataMonth#&dataYear=#dataYear#&SortOrder=DT&Flag=#Flag#">Created/updated</a></strong></td>
	<td align="center" class="small"><strong><a href="edit.cfm?dataMonth=#dataMonth#&dataYear=#dataYear#&SortOrder=U&Flag=#Flag#">Input by</a></strong></td>
	<td colspan="2" class="small"><strong>&nbsp;</strong></td>
		</cfoutput>
</tr>
	   
		<cfoutput query="GetLimitedDataRows">
<tr valign="top" <cfif Evaluate(GetLimitedDataRows.CurrentRow MOD 2) IS 0>bgcolor="##EBFOF7"<cfelse> bgcolor="##FFFFFF"</cfif>>
	<td class="tblcopy">#Unit#</td>
	<td class="tblcopy">#ServicePoint#</td>
	<td class="tblcopy">#QuestionType#</td>
	<td class="tblcopy"><cfif Mode IS NOT "Transaction">#Mode#<cfelse>--</cfif></td>
	<td align="right" class="tblcopy">#Count#</td>
	<td align="center" class="tblcopy">#DateFormat(Updated_DT, "m/d/yy")# #TimeFormat(Updated_DT, "h:mmtt")#</td>
	<td align="center" class="tblcopy"><a href="javascript:popups1('../../contact.cfm?LogonID=#LogonID#')">#LogonID#</a></td>
	<form action="form.cfm" method="post" class="form">
	<td align="right" class="tblcopy">
	<input type="submit" value="Edit" class="form">
	<input type="hidden" name="Action" value="Update">
	<input type="hidden" name="RecordID" value="#RecordID#">
	</td>
	</form>
	<form action="../../review.cfm" method="post" class="form">
	<td align="left" class="tblcopy">
	<input type="submit" value="Delete" class="form">
	<input type="hidden" name="Action" value="Delete">
	<input type="hidden" name="UnitID" value="#UnitID#">
	<input type="hidden" name="RecordID" value="#RecordID#">
	<input type="hidden" name="dataMonth" value="#dataMonth#">
	<input type="hidden" name="dataYear" value="#dataYear#">
	</td>
	</form>

</tr>
		</cfoutput>
</table>
	</cfif>
</cfif>





<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer_txt.cfm">
</cfif>





