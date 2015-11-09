<cfset DBStatus = 1>

<cftry>
	<cfstoredproc procedure="uspAddUserLogon" datasource="#CircStatsDSN#" returncode="Yes">
		<cfprocparam TYPE="IN" DBVARNAME="@LogonID" VALUE="#FORM.LogonID#" CFSQLTYPE="CF_SQL_VARCHAR">
		<cfprocparam TYPE="IN" DBVARNAME="@Password" VALUE="#FORM.newPassword#" CFSQLTYPE="CF_SQL_VARCHAR">
		<cfprocparam TYPE="IN" DBVARNAME="@FirstName" VALUE="#FORM.FirstName#" CFSQLTYPE="CF_SQL_VARCHAR">
		<cfprocparam TYPE="IN" DBVARNAME="@LastName" VALUE="#FORM.LastName#" CFSQLTYPE="CF_SQL_VARCHAR">
		<cfprocparam TYPE="IN" DBVARNAME="@EmailAddress" VALUE="#FORM.EmailAddress#" CFSQLTYPE="CF_SQL_VARCHAR">
		<cfprocparam TYPE="IN" DBVARNAME="@CircUnit" VALUE="#FORM.CircUnit#" CFSQLTYPE="CF_SQL_VARCHAR">
		<cfprocparam TYPE="IN" DBVARNAME="@RefUnit" VALUE="#FORM.RefUnit#" CFSQLTYPE="CF_SQL_VARCHAR">
	</cfstoredproc>
<cfcatch type="Database">
	<cfset DBStatus = -1>
	<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
</cfcatch>
</cftry>

<html>
<head>
	<title>UCLA Library Public Service Statistics</title>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-32672693-3', 'auto');
  ga('send', 'pageview');
</script>
	<cfinclude template="../library_pageincludes/banner.cfm">
	<cfinclude template="../library_pageincludes/nav.cfm">
<!--begin you are here-->

Public Service Statistics

<!-- end you are here -->
	<CFINCLUDE TEMPLATE="../library_pageincludes/start_content.cfm">
<h1>Public Service Statistics</h1>

<p>
Welcome to UCLA Library Public Service Statistics Web site.
</p>
<cfif DBStatus eq 1>
<p>Account Successfully Created</p>
<p>Please go to <a href="index.cfm">here</a> to login and begin working</p>
<cfelse>
<p>ERROR!</p>
<p><cfoutput>Sorry; something went wrong; please <a href="mailto:helpdesk@library.ucla.edu">report</a> this error message: #em#</cfoutput></p>
</cfif>
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../library_pageincludes/end_content.cfm">
