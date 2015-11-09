<CFPARAM NAME = "Text" DEFAULT = "No">
<cfparam name="URL.action" default="">

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
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-32672693-3', 'auto');
  ga('send', 'pageview');
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
<p>
<strong>
    If this is your first time at the new site, click <a href="createAccount.cfm">here</a> to setup your login account
</strong>
</p>
					<form action="loginExe.cfm"
						  method="post"
						  name="Login"
						  id="Login">
						  <!--onsubmit="JavaScript:return validateForm(this);"-->
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td></td>
								<td colspan="2">
									<cfif URL.action eq "deny">
										<div class="formSectionTitleErr">Log in error! Try again.</div>
									<cfelseif URL.action eq "nc">
										<div class="formSectionTitleErr">This site required cookies.</div>
									<cfelse>
										<div class="formSectionTitle">Log In</div>
									</cfif>
								</td>
							</tr>
							<tr>
								<td align="right">User name</td>
                                                                <td>&nbsp;</td>
								<td>
									<input name="UserName" type="text" size="15" maxlength="50">
								</td>
							</tr>
							<tr>
								<td align="right">Password</td>
                                                                <td>&nbsp;</td>
								<td>
									<input name="Password" type="password" size="15" maxlength="50">
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td align="right">
									<input type="submit" class="mainControl" value="Log In">
								</td>
								<td valign="top">
									&nbsp;
								</td>
							</tr>
							<tr>
								<td colspan="2"></td>
								<td valign="top">
									<a href="getPassword.cfm">Forgot your password?</a><br>
								</td>
							</tr>
						</table>
					</form>

<!--h2>Go to:</h2>

<ul class="large">
<li class="large"><a href="circulation/index.cfm">Circulation and other public services statistics</a></li>
<li class="large"><a href="reference/index.cfm">Reference statistics</a></li>
</ul-->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer_txt.cfm">
</cfif>

