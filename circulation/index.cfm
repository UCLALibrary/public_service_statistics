<cfset Session.IsValid = 1>

<CFPARAM NAME = "Text" DEFAULT = "No">

<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT *
FROM CircUnit
WHERE Active = 1
ORDER BY Unit
</cfquery>

<html>
<head>

	<title>UCLA Library Circulation Statistics</title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->

<a href="../index.cfm">Public Service Statistics</a> &gt; Circulation

<!-- end you are here -->

<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Circulation Statistics</h1>

<table width="300" bgcolor="#FFFF99"><tr><td class="copy">
<strong>Have you switched to Windows XP?</strong><br>If so, read <strong><a href="../using_xp.cfm">Logging on Using Windows XP
</a></strong>.
</td></tr></table><br>

<table width="100%" border="0">
<tr valign="top">
	<td>
<h3>Library-wide circulation reports</h3>

<ul>
<li><a href="master_report.cfm?ReportType=1">Transactions by Library Unit</a></li>
<li><a href="master_report.cfm?ReportType=3">Transactions by Patron Category</a></li>
<li><a href="master_report.cfm?ReportType=5">Transactions by Month</a></li>
</ul>
	</td>
	<td width="20">&nbsp;</td>
	<td><h3>Unit data input/edit forms and reports</h3>
<ul>
<cfoutput query="GetUnit">
<li><a href="#LCase(UnitID)#/index.cfm">#Unit#</a></li>
</cfoutput>
</ul>
</td>
</tr>
</table>

<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>
