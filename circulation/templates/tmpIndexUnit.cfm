<CFPARAM NAME = "Text" DEFAULT = "No">
<cfparam name="UnitID" default = "#UnitCode#">

<cfif Find("#UnitCode#", UnitID) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif>

<cfquery name="GetUnitMaster" datasource="#CircStatsDSN#">
SELECT UnitID,
       Unit
FROM CircUnit
WHERE UnitID LIKE '#UnitID#'
</cfquery>

<html>
<head>
	
<title>UCLA Library Circulation Statistics: <cfoutput>#GetUnitMaster.Unit#</cfoutput></title>
		
	<cfif Text IS "No">
		<cfinclude template="../../../library_pageincludes/banner.cfm">
		<cfinclude template="../../../library_pageincludes/nav.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
	</cfif>


<!--begin you are here-->

<a href="../../index.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Ciculation</a> &gt; <cfoutput>#GetUnitMaster.Unit#</cfoutput>

<!-- end you are here -->


	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
	</cfif>


<!--begin main content-->

<h1>Circulation Statistics: 
	<cfoutput>
			#GetUnitMaster.Unit#
	</cfoutput>
</h1>

<ul>
<cfoutput>
	<li><a href="form.cfm">Input data</a></li>
	<li><a href="edit.cfm">Edit data</a></li>
	<li><a href="report.cfm">View summary report</a></li>
</cfoutput>
</ul>



<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer_txt.cfm">
</cfif>

