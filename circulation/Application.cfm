<cfapplication name="CircStats" sessionmanagement="Yes" sessiontimeout="#CreateTimeSpan(0,4,0,0)#">

<cfif IsDefined( "Cookie.CFID" ) AND IsDefined( "Cookie.CFTOKEN" )>
  <cfcookie name="CFID" value="#Cookie.CFID#">
  <cfcookie name="CFTOKEN" value="#Cookie.CFTOKEN#">
</cfif>

<cfif FindNoCase("unitproj", CGI.SERVER_NAME) GT 0>
	<cfset CircStatsDSN = "Pub_Stats_Report">
<cfelse>
	<cfset CircStatsDSN = "PSS_Test">
</cfif>

<cfif NOT IsDefined("Session.IsValid")>
	<cflock timeout="#CreateTimeSpan(0,4,0,0)#" throwontimeout="No" name="#Session.SessionID#SessionIsValid" type="EXCLUSIVE">
		<cfparam name="Session.IsValid" default="0">
	</cflock>
</cfif>

<CFIF AUTH_USER IS NOT "">
	<cflock timeout="#CreateTimeSpan(0,4,0,0)#" throwontimeout="No" name="#Session.SessionID#LogonID" type="EXCLUSIVE">
		<cfset Session.LogonID = RemoveChars(AUTH_USER, "1", Find("\", AUTH_USER))>
	</CFLOCK>
</cfif>