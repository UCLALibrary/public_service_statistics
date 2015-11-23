	<CFPARAM NAME = "ReferringURL" DEFAULT = "#URL.ReferringURL#">
<html>
<head>
	<title>Ref. Stats. Data Input</title>
<LINK REL=STYLESHEET HREF="../css/main.css" TYPE="text/css">
	<cfif DBStatus IS 1>
		<script language="JavaScript">
			<cfoutput>
			   setTimeout("location.href='#ReferringURL#'",500);
			</cfoutput>
		</script>
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
