<cfscript>
	if ( IsDefined("FORM.submit") ) {
		m_start_date = FORM.start_date;
		m_end_date = FORM.end_date;
		m_query = true;
	}
	else {
		// either Reset was submitted, or didn't come to page through form
		// make sure variables are defined and initialized
		m_start_date = "";
		m_end_date = "";
		m_query = false;
	}
</cfscript>

<!--- Copied from existing circ/ref index page --->
<cfset Session.IsValid = 1>

<CFPARAM NAME = "Text" DEFAULT = "No">

<html>
<head>
	<title>UCLA Library Statistics - Export Data</title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->

<a href="../home.cfm">Public Service Statistics</a> &gt; Export Data

<!-- end you are here -->

<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->
<h1>Export Data</h1>

<p>Export all data into Excel.  Note that this can be quite slow, depending on the date range requested.</p>
<p>Start and end dates must be entered as <code>yyyy-mm-dd</code> format.  Dates are inclusive: 2016-01-01 to 2016-01-31 will get all data for January 2016,
while 2016-07-01 to 2016-07-01 will get data for July 1 2016 only.</p>
<p>Data is exported in Excel's HTML/MHTML format.  This may be sufficient but if not, you will need to use Excel's "Save as..." menu option to convert to true Excel format.</p>

<form name="reports" id="reports" action="index.cfm" method="post">
	<label for="start_date">Start date: </label>
	<!--- HTML input type=date not yet widely supported  in browsers 20160920 akohler --->
	<input type="text" name="start_date" id="start_date" placeholder="YYYY-MM-DD">
	<label for="end_date">End date: </label>
	<input type="text" name="end_date" id="end_date" placeholder="YYYY-MM-DD">
	<input name="submit" id="submit" type="submit" value="Get data">
</form>

<cfif m_query eq true>
	<cfinclude template="sql\export_all_data.cfm">
	<!---<cfdump var="#qryExportAllData#">--->
	
	<!--- This could be done with cfspreadsheet in CF9... but local unitdev is CF8 only --->
	<cfsetting enablecfoutputonly="Yes">
	<cfsavecontent variable="ExcelExport">
	<cfoutput>
		<table>
			<tr>
				<th>Unit</th>
				<th>ServicePoint</th>
				<th>QuestionType</th>
				<th>InteractionMode</th>
				<th>EventDate</th>
				<th>EventTime</th>
				<th>UserName</th>
				<th>TimeSpent</th>
				<th>Department</th>
				<th>Course</th>
				<th>PatronType</th>
				<th>PatronFeedback</th>
				<th>StaffFeedback</th>
				<th>Topic</th>
				<th>ReferralText</th>
			</tr>
		<cfloop query="qryExportAllData">
			<tr>
				<td>#Unit#</td>
				<td>#ServicePoint#</td>
				<td>#QuestionType#</td>
				<td>#InteractionMode#</td>
				<td>#EventDate#</td>
				<td>#EventTime#</td>
				<td>#UserName#</td>
				<td>#TimeSpent#</td>
				<td>#Department#</td>
				<td>#Course#</td>
				<td>#PatronType#</td>
				<td>#PatronFeedback#</td>
				<td>#StaffFeedback#</td>
				<td>#Topic#</td>
				<td>#ReferralText#</td>
			</tr>
		</cfloop>
		</table>
	</cfoutput>
	</cfsavecontent>
	<!--- Datestamp for export filename ... DateTimeFormat added CF9+...--->
	<cfset m_export_filename = "export_" & DateFormat(Now(), "yyyymmdd") & "_" & TimeFormat(Now(), "HHmmss") & ".xls">
	<cfcontent type="application/vnd.msexcel">
	<cfheader name="Content-Disposition" value="inline; filename=#m_export_filename#">
	<cfoutput>#ExcelExport#</cfoutput>
</cfif>

<!--end main content-->

<cfif IsDefined("Session.LogonID")>
	<cfset LogonID = Session.LogonID>
<cfelse>
	<cfset LogonID = "unassigned">
</cfif>

<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>
