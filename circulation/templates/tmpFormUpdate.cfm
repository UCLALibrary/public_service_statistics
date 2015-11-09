<!---cfif Find("form.cfm", PATH_INFO) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif--->

<html>
<head>
	<title>UCLA Library Circulation Statistics Data Edit: <cfoutput>#GetUnitCategory.Unit#</cfoutput></title>
<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/banner.cfm">
	<cfinclude template="../../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->
	<a href="../../home.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Circulation</a> &gt; <a href="index.cfm"><cfoutput>#GetUnitCategory.Unit#</cfoutput></a> &gt; Data Edit

<!-- end you are here -->
<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>


<!--begin main content-->
<h1>Circulation Data Edit: <cfoutput>#GetUnitCategory.Unit#</cfoutput></h1>

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

<form action="../review.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<table border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="top" bgcolor="#EBF0F7">
	<td class="small"><strong>Unit</strong></td>
	<td class="small"><strong>Statistical category</strong></td>
	<td class="small"><strong>Month</strong></td>
	<td class="small"><strong>Year</strong></td>
	<td class="small"><strong>Value</strong></td>
</tr>

<tr valign="middle">
	<td class="small"><cfoutput>#GetRecord.Unit#</cfoutput></td>
	<td class="small">
<select name="AggregateID" class="form">
<cfoutput query="GetUnitCategory">
<option value="#AggregateID#" class="form" <cfif GetUnitCategory.AggregateID IS GetRecord.AggregateID>selected</cfif>>#Category#</option>
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
</cfoutput>
<input type="hidden" name="Action" value="Update">
		<td>
<input type="reset" value="Restore Original Values" class="form">
		</td>
</form>
<form action="../action.cfm" method="post">
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