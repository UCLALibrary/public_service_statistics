<CFPARAM NAME = "Text" DEFAULT = "No">


<html>
<head>

	<title>UCLA Library Public Service Statistics: Loggin on Using Windows XP</title>

<cfif Text IS "No">
	<cfinclude template="../library_pageincludes/banner.cfm">
	<cfinclude template="../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../index.cfm">Public Service Statistics</a> &gt; Logging on Using Windows XP

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Logging on Using Windows XP</h1>

<p>
There have been several reports from people having problems logging on to the reference statistics data inputting forms from workstations that have recently been converted to Windows XP.  If you're using Windows XP, you will have to enter your user name slightly differently.  Precede your user name with the "AD" (if you're curious, it stands for "active directory") followed by a backslash ("\"). For example, if your user name is "myaccount", enter it as follows:
</p>
<p>
<img src="images/xp_logon.gif" alt="Windows XP Logon" width="326" height="261" border="0">
</p>
<p>
Continue to enter your password as usual.
</p>



<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer_txt.cfm">
</cfif>


