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
<script language="JavaScript" type="text/javascript">
	<!--
		function validateForm(form)
		{
			if ( form.UserName.value == "" )
			{
				alert("Please enter a user name");
				form.UserName.select();
				form.UserName.focus();
				return false;
			}
			else
			{
				return true;
			}
		}
	-->
</script>

<cfinclude template="../library_pageincludes/banner.cfm">
<cfinclude template="../library_pageincludes/nav.cfm">


<!--begin you are here-->

Public Service Statistics

<!-- end you are here -->

<cfinclude template="../library_pageincludes/start_content.cfm">

<h1>Public Service Statistics</h1>

<p>
Welcome to UCLA Library Public Service Statistics Web site.
</p>

<cfoutput>
	<form action="verifyAccount.cfm"
		  method="post"
		  name="Contact"
		  id="Contact"
		  onsubmit="JavaScript:return validateForm(this);">
		<div class="form">
			<div style="width:50%">
				<cfif isDefined("up2snuff") and not up2snuff>
					<div class="formSectionTitleErr">#em#<br></div>
				<cfelse>
					<p>To retrieve your password, enter your Public Service Statistics user name
					and press enter.</p>
				</cfif>
			</div>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr valign="top">
					<td>
						<em class="required">*</em>
						<input
							name="UserName"
							size="35"
							maxlength="50"
							<cfif isDefined("FORM.UserName")>
								value="#FORM.UserName#"
							</cfif>
						>
					</td>
				</tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr valign="top">
					<td>
						<input name="reqElements" type="hidden" value="UserName,Library network user name">
						<input name="Submit" type="submit" class="mainControl" style="width:100px;" value="OK" onclick="JavaScript:setVersion(Contact, 'main');">
					<td>
						<input name="Submit" type="submit" class="mainControl" value="Cancel" onclick="JavaScript:setVersion(Contact, 'alt');">
					</td>
				</tr>
			</table>
		</div>
	</form>
</cfoutput>
<CFINCLUDE TEMPLATE="../library_pageincludes/footer.cfm">
<CFINCLUDE TEMPLATE="../library_pageincludes/end_content.cfm">


