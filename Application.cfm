<cfif FindNoCase("unitproj", CGI.SERVER_NAME) GT 0>
	<cfset CircStatsDSN = "Pub_Stats_Report">
<cfelse>
	<cfset CircStatsDSN = "PSS_Test">
</cfif>
