<!---cfif Find("form.cfm", PATH_INFO) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif--->

<html>
<head>
	<title>UCLA Library Circulation Statistics Data Edit: <cfoutput>#GetUnit.Unit#</cfoutput></title>
<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/banner.cfm">
	<cfinclude template="../../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->
	<a href="../../home.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Circulation</a> &gt; <a href="index.cfm"><cfoutput>#GetUnit.Unit#</cfoutput></a> &gt; Data Edit

<!-- end you are here -->
<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>


<!--begin main content-->
<h1>Circulation Data Edit: <cfoutput>#GetUnit.Unit#</cfoutput></h1>

<p>
Use the form below to modify the properties of this record.
</p>

<cfoutput query="GetComments">
<table border="0"
       cellspacing="1"
       cellpadding="2">
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>CommentID</strong>:</td>
	<td class="tblcopy">#CommentID#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Created</strong>:</td>
	<td class="tblcopy">#Created_DT#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Last edited</strong>:</td>
	<td class="tblcopy">#Updated_DT#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Last edited/created by</strong>:</td>
	<td class="tblcopy">#LogonID#</td>
</tr>
<form action="../review.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Unit:</strong></td>
	<td class="tblcopy">#Unit#</td>
</tr>
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Comment:</strong></td>
	<td class="tblcopy"><textarea cols="40" rows="2" name="Comment" class="form">#Comment#</textarea></td>
</tr>
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Month:</strong></td>
	<td>
<select name="dataMonth" class="form">
<cfloop index="Month" from="1" to="12">
	<option value="#Month#" class="form" <cfif GetComments.DataMonth IS Month>selected</cfif>>
	<cfif Len(MonthAsString(Month)) GT 3>
	#MonthAsString(Month)#
	<cfelse>
	#MonthAsString(Month)#
	</cfif>
	</option>
</cfloop>
</select>	
	</td>
</tr>
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Year:</strong></td>
	<td>
<select name="dataYear" class="form">
<cfloop index="Year" from="#DatePart("yyyy", Now())#" to="1999" step="-1">
	<option value="#Year#" class="form" <cfif GetComments.DataYear IS Year>selected</cfif>>#Year#</option>
</cfloop>
</select>	
	</td>
</tr>
</cfoutput>

<tr valign="top">
	<td colspan="2">
	<table border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
<input type="submit" value="Submit Changes" class="form">
		</td>
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="CommentID" value="#CommentID#">
</cfoutput>
<input type="hidden" name="Action" value="UpdateComment">
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