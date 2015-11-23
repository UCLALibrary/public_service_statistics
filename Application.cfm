<cfapplication name="Statistics"
			   clientmanagement="no"
		       sessionmanagement="yes"
			   setclientcookies="yes"
			   setdomaincookies="no"
			   sessiontimeout="#CreateTimeSpan(0, 4, 0, 0)#">

<cfif IsDefined( "Cookie.CFID" ) AND IsDefined( "Cookie.CFTOKEN" )>
  <cfcookie name="MyCFID" value="#Cookie.CFID#">
  <cfcookie name="MyCFTOKEN" value="#Cookie.CFTOKEN#">
</cfif>

<cfif FindNoCase("unitproj", CGI.SERVER_NAME) EQ 1>
	<cfset CircStatsDSN = "Public_Service_Stats">
        <cfset APPLICATION.dsn = "SIA">
<cfelse>
	<cfset CircStatsDSN = "PSS_Test">
        <cfset APPLICATION.dsn = "SIA_Test">
</cfif>
<!---CFSET CircStatsDSN = "PSS_Test"> <!---"Pub_Stats_Report"--->
<cfset APPLICATION.dsn = "SIA_Test"--->
<cfset APPLICATION.HostServer = CGI.SERVER_NAME>
<cfparam name="SESSION.IsValid" default="0" type="boolean">
<cfparam name="SESSION.LogonID" default="">