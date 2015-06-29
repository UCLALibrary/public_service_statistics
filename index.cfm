<CFPARAM NAME = "Text" DEFAULT = "No">

<html>
<head>
	<title>UCLA Library Public Service Statistics</title>
<script language=Javascript>
<!--//

function popups1(name) {
_loc = 'ref_login.cfm';
popupsWin = window.open(_loc,"PSpopups","toolbar=no,width=280,height=230,scrollbars=no,resizable=no,screenX=450,screenY=10,top=10,left=450'");
if (popupsWin.opener == null) { popupsWin.opener = self }
}
// end function
// -->
</script>

<cfif Text IS "No">
	<cfinclude template="../library_pageincludes/banner.cfm">
	<cfinclude template="../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

Public Service Statistics

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Public Service Statistics</h1>

<p>
Welcome to UCLA Library Public Service Statistics Web site.
</p>

<h2>Go to:</h2>

<ul class="large">
<li class="large"><a href="circulation/index.cfm">Circulation and other public services statistics</a></li>
<li class="large"><a href="reference/index.cfm">Reference statistics</a></li>
</ul>


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer_txt.cfm">
</cfif>


