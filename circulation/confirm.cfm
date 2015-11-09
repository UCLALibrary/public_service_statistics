<CFIF FIND("review.cfm", HTTP_REFERER) IS 0 AND FIND("form.cfm", HTTP_REFERER) IS 0>
	<CFLOCATION URL="index.cfm" ADDTOKEN="No">
	<CFABORT>
</cfif>

<CFPARAM NAME = "DBStatus" DEFAULT = URL.DBStatus>
<CFPARAM NAME = "Text" DEFAULT = "No">
<CFPARAM NAME = "UnitID" DEFAULT = "#URL.UnitID#">
<CFPARAM NAME = "Action" DEFAULT = "#URL.Action#">

<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT Unit,
       UnitID
FROM CircUnit
WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
</cfquery>

<html>
<head>
	<title>UCLA Library Circulation Statistics Transaction Status: <cfoutput>#GetUnit.Unit#</cfoutput></title>


<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../home.cfm">Public Services Statistics</a> &gt; <a href="index.cfm">Circulation</a> &gt;
<cfoutput>
<cfswitch expression="#Action#">
	<cfcase value="Insert">
		<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
		<cfif DBStatus IS 1>
			&gt; Data Input Successful
		<cfelse>
			&gt; Data Input Failed
		</cfif>
	</cfcase>
	<cfcase value="Update">
		<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
		<cfif DBStatus IS 1>
			&gt; Data Edit Successful
		<cfelse>
			&gt; Data Edit Failed
		</cfif>
	</cfcase>
	<cfcase value="Delete">
		<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
		<cfif DBStatus IS 1>
			&gt; Data Deletion Successful
		<cfelse>
			&gt; Data Deletion Failed
		</cfif>
	</cfcase>
	<cfcase value="UpdateComment">
		<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
		<cfif DBStatus IS 1>
			&gt; Data Edit Successful
		<cfelse>
			&gt; Data Edit Failed
		</cfif>
	</cfcase>
	<cfcase value="DeleteComment">
		<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
		<cfif DBStatus IS 1>
			&gt; Data Deletion Successful
		<cfelse>
			&gt; Data Deletion Failed
		</cfif>
	</cfcase>
</cfswitch>
</cfoutput>

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->



<cfoutput>
<cfswitch expression="#Action#">
	<cfcase value="Insert">
		<cfif DBStatus IS 1>
		<h2>Your data input was successful</h2>
		<cfelse>
		<h2>Error</h2>

		<p>Your data input failed. The system administrator has been notified and you will be contacted shortly.</p>
		</cfif>
	</cfcase>
	<cfcase value="InsertComment">
		<cfif DBStatus IS 1>
		<h2>Your comment input was successful</h2>
		<cfelse>
		<h2>Error</h2>

		<p>Your data input failed. The system administrator has been notified and you will be contacted shortly.</p>
		</cfif>
	</cfcase>
	<cfcase value="Update">
		<cfif DBStatus IS 1>
		<h2>Your data edit was successful</h2>
		<cfelse>
		<h2>Error</h2>

		<p>Your data edit failed. The system administrator has been notified and you will be contacted shortly.</p>
		</cfif>
	</cfcase>
	<cfcase value="Delete">
		<cfif DBStatus IS 1>
		<h2>Your data deletion was successful</h2>
		<cfelse>
		<h2>Error</h2>

		<p>Your data deletion failed. The system administrator has been notified and you will be contacted shortly.</p>
		</cfif>
	</cfcase>
	<cfcase value="UpdateComment">
		<cfif DBStatus IS 1>
		<h2>Your data edit was successful</h2>
		<cfelse>
		<h2>Error</h2>

		<p>Your data edit failed. The system administrator has been notified and you will be contacted shortly.</p>
		</cfif>
	</cfcase>

	<cfcase value="DeleteComment">
		<cfif DBStatus IS 1>
		<h2>Your data deletion was successful</h2>
		<cfelse>
		<h2>Error</h2>

		<p>Your data edit failed. The system administrator has been notified and you will be contacted shortly.</p>
		</cfif>
	</cfcase>
</cfswitch>
</cfoutput>

<h3>Go to:</h3>
<ul>
<cfoutput>
	<li><a href="#Lcase(UnitID)#/index.cfm">#GetUnit.Unit# circulation statistics data input/edit page</a></li>
</cfoutput>
</ul>

<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>

