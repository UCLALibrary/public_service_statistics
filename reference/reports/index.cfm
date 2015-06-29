<cfparam name="text" default="No">

<HTML>
<HEAD>
<TITLE>UCLA Library Reference Statistics: Summary Reports</TITLE>


<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/banner_nonav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->

<a href="../../index.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Reference</a> &gt; Summary Reports

<!-- end you are here -->

<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/start_content_nonav.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Reference Statistics Reports</h1>

<h2>Reports</h2>

<ul>
<li><a href="report.cfm?ReportType=1">Total transactions by unit</a></li>
<li><a href="report.cfm?ReportType=2">Total transactions by point of service</a></li>
<li><a href="report.cfm?ReportType=3">Total transactions by month</a></li>
<li><a href="report.cfm?ReportType=4">Total transactions by hour</a> *</li>
<li><a href="report.cfm?ReportType=5">Total transactions by day of week</a> *</li>
<li><a href="report.cfm?ReportType=6">Total questions by type</a></li>
<li><a href="report.cfm?ReportType=7">Total questions by type and point of service</a></li>
<li><a href="report.cfm?ReportType=8">Total questions by type and hour</a> *</li>
<li><a href="report.cfm?ReportType=9">Total questions by mode of delivery</a></li>
<li><a href="staff.cfm?ReportType=10">Peer review documentation criteria 1 and 2 report</a></li>
</ul>

<p>*real-time data inputting units only</p>

<h2>Unit Data Profiles</h2>

<ul>
<li><a href="facts.cfm?ReportType=1">Data collection methods for units/service points</a></li>
<li><a href="facts.cfm?ReportType=2">Data availability by unit/service points</a></li>
</ul>







<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/footer_nonav_txt.cfm">	
</cfif>



