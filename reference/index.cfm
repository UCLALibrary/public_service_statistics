<cfset Session.IsValid = 1>

<CFPARAM NAME = "Text" DEFAULT = "No">

<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT DISTINCT SUBSTRING(UnitID, 1, 3) AS ParentUnitID,
       CASE WHEN SUBSTRING(UnitID, 1, 3) = 'ART' THEN 'Arts Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'BIO' THEN 'Biomed Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'CLK' THEN 'Clark Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'COL' THEN 'Powell Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'EAL' THEN 'East Asian Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'LAW' THEN 'Law Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'MAN' THEN 'Management Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'MUS' THEN 'Music Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'RBR' THEN 'Rieber Hall'
            WHEN SUBSTRING(UnitID, 1, 3) = 'SEL' THEN 'Science & Engineering Library'
            WHEN SUBSTRING(UnitID, 1, 3) = 'SRL' THEN 'SRLF'
            WHEN SUBSTRING(UnitID, 1, 3) = 'YRL' THEN 'Young Research Library'
       ELSE NULL
       END AS "ParentUnit"
FROM View_RefUnit
ORDER BY ParentUnitID
</cfquery>

<html>
<head>

	<title>UCLA Library Reference Statistics</title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../home.cfm">Public Service Statistics</a> &gt; Reference

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Reference Statistics</h1>

<h2>Data Input/Edit</h2>
<table width="300" bgcolor="#FFFF99"><tr><td class="copy">
<strong>Have you switched to Windows XP?</strong><br>If so, read <strong><a href="../using_xp.cfm">Logging on Using Windows XP
</a></strong>.
</td></tr></table>


<ul>
<cfoutput query="GetUnit">
<li><a href="#LCase(ParentUnitID)#/index.cfm">#ParentUnit#</a></li>
</cfoutput>
</ul>

<h2>Documentation</h2>

<ul>
<li><a href="category_definitions.cfm">Statistical Category Definitions</a></li>
<!---li><a href="procedure.cfm">Procedural Guidelines</a></li>
<li><a href="new_form.cfm">How to use the real-time data input form</a></li--->
<li><a href="specifications.cfm">Technical Information</a></li>
</ul>

<h2>Reports</h2>

<ul>
<li><a href="reports/generator.cfm?Level=Library">Library-wide</a></li>
<li><a href="reports/generator.cfm?Level=Unit">Unit-specific</a></li>
<li><a href="reports/generator.cfm?Level=Account">Account-specific</a></li>
</ul>




<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>


