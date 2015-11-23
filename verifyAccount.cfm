<!---cfif not Find("getPassword.cfm", PATH_INFO)>
	<cflocation url="index.cfm" addtoken="no">
	<cfabort>
</cfif--->
<cfquery name="checkAccount" datasource="#CircStatsDSN#">
	SELECT count(LogonID) AS account FROM dbo.UserLogons WHERE LogonID = '#FORM.UserName#'
</cfquery>
<cfset up2snuff = 1>
<cfif checkAccount.account eq 0>
	<html>
	<head>
		<title>UCLA Library Public Service Statistics</title>
		<cfinclude template="../library_pageincludes/banner.cfm">
		<cfinclude template="../library_pageincludes/nav.cfm">


		<!--begin you are here-->

		Public Service Statistics

		<!-- end you are here -->

		<cfinclude template="../library_pageincludes/start_content.cfm">

		<h1>Public Service Statistics</h1>
		<p>
			<cfoutput>
				#FORM.UserName# is not a valid Public Service Statistics user name.<br/>
				Please <a href="getPassword.cfm">re-enter</a> your user name.
			</cfoutput>
		</p>

	<cfinclude template="../library_pageincludes/footer.cfm">
	<cfinclude template="../library_pageincludes/end_content.cfm">
<cfelse>
	<cfquery name="getPassword" datasource="#CircStatsDSN#">
		SELECT
			FirstName,
			LastName,
			EmailAddress,
			Password
		FROM
			dbo.UserLogons
		where
			LogonID = '#FORM.UserName#'
	</cfquery>

	<cftry>
		<cfmail to="#getPassword.EmailAddress#"
				from="do-not-reply@library.ucla.edu"
				subject="UCLA Library Public Service Statistics Password Retrieval">
Dear #getPassword.FirstName# #getPassword.LastName#:

Your UCLA Library Public Service Statistics password is: #getPassword.Password#

Go to the UCLA Library PSS Database now: https://unitproj.library.ucla.edu/statistics/

Sent: #DateFormat(Now(), "mm/dd/yyyy")#
		</cfmail>
		<cfcatch type="Any">
			<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
			<cfscript>
				up2snuff = 0;
			</cfscript>
		</cfcatch>
	</cftry>

	<cfif not up2snuff>
		<html>
		<head>
			<title>UCLA Library Public Service Statistics</title>
			<cfinclude template="../library_pageincludes/banner.cfm">
			<cfinclude template="../library_pageincludes/nav.cfm">


			<!--begin you are here-->

			Public Service Statistics

			<!-- end you are here -->

			<cfinclude template="../library_pageincludes/start_content.cfm">

			<h1>Public Service Statistics</h1>
			<p>
				<cfoutput>
					Sorry, something went wrong with the email.<br/>
					Please report the following error message
					to the <a href="mailto:helpdesk@library.ucla.edu">Help Desk</a>:<br/>
					#em#
				</cfoutput>
			</p>

		<cfinclude template="../library_pageincludes/footer.cfm">
		<cfinclude template="../library_pageincludes/end_content.cfm">
	<cfelse>
		<html>
		<head>
			<title>UCLA Library Public Service Statistics</title>
			<cfinclude template="../library_pageincludes/banner.cfm">
			<cfinclude template="../library_pageincludes/nav.cfm">


			<!--begin you are here-->

			Public Service Statistics

			<!-- end you are here -->

			<cfinclude template="../library_pageincludes/start_content.cfm">

			<h1>Public Service Statistics</h1>
			<div class="form">
				<div style="width:50%">
					<p>Your password has been mailed to you.</p>
					<p>Click <a href="index.cfm">here</a> to login.</p>
				</div>
			</div>

		<cfinclude template="../library_pageincludes/footer.cfm">
		<cfinclude template="../library_pageincludes/end_content.cfm">
	</cfif>
</cfif>
