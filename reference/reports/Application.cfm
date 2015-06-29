<!--- Use production DSN only on unitproj, otherwise use test DSN --->
<cfif FindNoCase("unitproj", CGI.SERVER_NAME) EQ 1>
	<cfset CircStatsDSN = "Pub_Stats_Report">
<cfelse>
	<cfset CircStatsDSN = "PSS_Test">
</cfif>
