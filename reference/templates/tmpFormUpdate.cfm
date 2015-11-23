<!---cfif Find("form.cfm", PATH_INFO) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif--->

<html>
<head>
	<title>UCLA Library Reference Statistics Data Edit: <cfoutput>#GetUnitCategory.Unit#</cfoutput></title>
<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/banner.cfm">
	<cfinclude template="../../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->
	<a href="../../home.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Reference</a> &gt; <a href="index.cfm"><cfoutput>#GetUnitCategory.ParentUnit#</cfoutput></a> &gt; Data Edit

<!-- end you are here -->
<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>


<!--begin main content-->
<h1>Reference Statistics Data Edit: <cfoutput>#GetUnitCategory.Unit#</cfoutput></h1>

<p>
Use the form below to modify any of the properties of this record.
</p>

<cfoutput>
<table border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>RecordID</strong>:</td>
	<td class="tblcopy">#GetRecord.RecordID#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Created</strong>:</td>
	<td class="tblcopy">#GetRecord.Created_DT#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Last edited</strong>:</td>
	<td class="tblcopy">#GetRecord.Updated_DT#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Last edited/created by</strong>:</td>
	<td class="tblcopy">#GetRecord.LogonID#</td>
</tr>
</table>
</cfoutput>

<form action="../../review.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<table border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="top" bgcolor="#EBF0F7">
	<td class="small"><strong>Unit</strong></td>
	<td class="small"><strong>Service point</strong></td>
	<td class="small"><strong>Question type</strong></td>
	<td class="small"><strong>Mode</strong></td>
	<td class="small"><strong>Month</strong></td>
	<td class="small"><strong>Year</strong></td>
	<td class="small"><strong>Value</strong></td>
</tr>

<tr valign="middle">
	<td class="small"><cfoutput>#GetRecord.Unit#</cfoutput></td>
	<td class="small">
<select name="PointID" class="form">
<cfoutput query="GetServicePoint">
<option value="#PointID#" class="form" <cfif GetRecord.PointID IS PointID>selected</cfif>>#ServicePoint#</option>
</cfoutput>
</select>
	</td>
	<td class="small">
<select name="TypeID" class="form">
<cfoutput query="GetQuestionType">
<option value="#TypeID#" class="form" <cfif GetRecord.TypeID IS TypeID>selected</cfif>>#QuestionType#</option>
</cfoutput>
</select>
	</td>
	<td class="small">
<select name="ModeID" class="form">
<cfoutput query="GetMode">
<option value="#ModeID#" class="form" <cfif GetRecord.ModeID IS ModeID>selected</cfif>><cfif ModeID IS "00">None<cfelse>#Mode#</cfif></option>
</cfoutput>
</select>
	</td>
	<td class="small">
<cfoutput>
<select name="dataMonth" class="form">
<cfloop index="Month" from="1" to="12">
	<option value="#Month#" class="form" <cfif GetRecord.DataMonth IS Month>selected</cfif>>
	<cfif Len(MonthAsString(Month)) GT 3>
	#RemoveChars(MonthAsString(Month), 4, Evaluate(Len(MonthAsString(Month)) - 3))#
	<cfelse>
	#MonthAsString(Month)#
	</cfif>
	</option>
</cfloop>
</select>
	</td>
	<td class="small">
<select name="dataYear" class="form">
<cfloop index="Year" from="#DatePart("yyyy", Now())#" to="1999" step="-1">
	<option value="#Year#" class="form" <cfif GetRecord.DataYear IS Year>selected</cfif>>#Year#</option>
</cfloop>
</select>
</cfoutput>	
	</td>
	<td class="small">
<cfoutput><input type="text" name="Count" value="#GetRecord.Count#" size="6" maxlength="6" class="form"></cfoutput>
	</td>
</tr>
<!--- submit data/clear form/cancel buttons --->
<tr>
	<td colspan="7" class="form">&nbsp;</td>
</tr>

<tr>
	<td>&nbsp;</td>
	<td colspan="6">
	<table border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
<input type="submit" value="Submit Changes" class="form">
		</td>
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="RecordID" value="#RecordID#">
<input type="hidden" name="Action" value="Update">
<input type="hidden" name="InputMethod" value="1">
</cfoutput>
		<td>
<input type="reset" value="Restore Original Values" class="form">
		</td>
</form>
<cfoutput>
<form action="edit.cfm" method="post">
		<td>
<input type="submit" value="Return to list" class="form">
		</td>
<input type="hidden" name="Action" value="Select">
<input type="hidden" name="InputMethod" value = "1">
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="dataMonth" value="#GetRecord.DataMonth#">
<input type="hidden" name="dataYear" value="#GetRecord.DataYear#">
</form>
</cfoutput>
<form action="../../action.cfm" method="post">
		<td>
<input type="submit" name="action" value="Cancel" class="form">
		</td>
</form>
	</tr>
	</table>
	</td>
</tr>
</table>

<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer_txt.cfm">
</cfif>