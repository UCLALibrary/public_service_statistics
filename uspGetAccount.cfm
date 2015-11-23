<!---
// Required variables for uspGetAccount
    @UserName VARCHAR(50) = NULL,
    @Password VARCHAR(50) = NULL
--->
<cftry>
	<cfstoredproc procedure="uspGetAccount" datasource="#CircStatsDSN#">
		<cfprocparam type = "In" CFSQLType = "CF_SQL_VARCHAR" dbvarname="@UserName" value = "#UserName#" null="no">
		<cfprocparam type = "In" CFSQLType = "CF_SQL_VARCHAR" dbvarname="@Password" value = "#Password#" null="no">
		<cfprocresult name="Account">
	</cfstoredproc>
	<cfcatch type="Database">
		<cfset up2snuff = 0>
		<!---cfset em = "Account access error"--->
		<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
	</cfcatch>
</cftry>
