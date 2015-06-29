<CFIF FIND("review.cfm", HTTP_REFERER) IS 0 AND FIND("form.cfm", HTTP_REFERER) IS 0>
	<CFLOCATION URL="index.cfm" ADDTOKEN="No">
	<CFABORT>
</cfif>

<CFPARAM NAME = "InputMethod" DEFAULT = #URL.InputMethod#>
<CFPARAM NAME = "DBStatus" DEFAULT = #URL.DBStatus#>

<!--- feedback if the input method is the monthly form --->
<cfif InputMethod IS 1>
	<CFPARAM NAME = "Text" DEFAULT = "No">
	<CFPARAM NAME = "UnitID" DEFAULT = "#URL.UnitID#">
	<CFPARAM NAME = "Action" DEFAULT = "#URL.Action#">

	<cfquery name="GetUnit" datasource="#CircStatsDSN#">
	SELECT Unit, UnitID, ParentUnit
	FROM View_RefUnitCategory
	WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
	</cfquery>
<html>
<head>
	<title>UCLA Library Reference Statistics Transaction Status: <cfoutput>#GetUnit.Unit#</cfoutput></title>
	<cfif Text IS "No">
		<cfinclude template="../../library_pageincludes/banner.cfm">
		<cfinclude template="../../library_pageincludes/nav.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<cfinclude template="../../library_pageincludes/banner_txt.cfm">
	</cfif>
<!--begin you are here-->
<a href="../index.cfm">Public Services Statistics</a> &gt; <a href="index.cfm">Reference</a> &gt;
	<cfoutput>
	<cfswitch expression="#Action#">
		<cfcase value="Insert">
		<a href="#LCase(RemoveChars(UnitID, 4, 3))#/index.cfm">#GetUnit.ParentUnit#</a>
			<cfif DBStatus IS 1>
			&gt; Data Input Successful
			<cfelse>
			&gt; Data Input Failed
			</cfif>
		</cfcase>
		<cfcase value="Update">
		<a href="#LCase(RemoveChars(UnitID, 4, 3))#/index.cfm">#GetUnit.ParentUnit#</a>
			<cfif DBStatus IS 1>
			&gt; Data Edit Successful
			<cfelse>
			&gt; Data Edit Failed
			</cfif>
		</cfcase>
		<cfcase value="Delete">
		<a href="#LCase(RemoveChars(UnitID, 4, 3))#/index.cfm">#GetUnit.ParentUnit#</a>
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
	</cfswitch>
	</cfoutput>
<h3>Go to:</h3>
<ul>
	<cfoutput>
	<li><a href="#RemoveChars(Lcase(UnitID), 4, 3)#/index.cfm">#GetUnit.ParentUnit# reference statistics data input/edit page</a></li>
	</cfoutput>
</ul>
	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
	</cfif>
</cfif>


<!--- feedback if the input method is the real-time form --->
<cfif InputMethod IS 2>

	<CFPARAM NAME = "ReferringURL" DEFAULT = "#URL.ReferringURL#">
<html>
<head>
	<title>Ref. Stats. Data Input</title>
<LINK REL=STYLESHEET HREF="http://stats.library.ucla.edu/css/main.css" TYPE="text/css">
	<cfif DBStatus IS 1>
		<script language="JavaScript">
			<cfoutput>
			   setTimeout("location.href='#ReferringURL#'",500);
			</cfoutput>
		</script>
<!---
		<cfoutput>
		<META HTTP-EQUIV="Refresh" CONTENT="1;URL=#ReferringURL#">
		</cfoutput>
--->
	</cfif>
</head>

<BODY bgcolor="#DEDEDE" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" LEFTMARGIN="0" LINK="#000099" VLINK="#0000CC">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr valign="middle">
	<td width="100%" height="100%" align="center" valign="middle" class="form"><strong>

	<cfif DBStatus IS 1>
		Data recorded successfully
	<cfelse>
<span class="red">
Your entry was not recorded due to an unknown error. Click the button below to return to the keypad to try again. If the problem persists, please record your data on paper and contact David Yamamoto at davmoto@library.ucla.edu or extension 267-2682.<br><br>
<form action="#ReferringURL#" method="post" class="form">
	<cfoutput><input type="submit" value="Return to keypad">
	</cfoutput>
</form>
</span>
	</cfif>

	</strong></td>
</tr>
</table>


</body>
</html>

</cfif>


