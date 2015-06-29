<cfoutput>

<cfif Action IS "Update">
<h1>Review Changes</h1>
<p>
Please take a moment to review the following changes you are about to submit.
</p>

<cfelseif Action IS "Insert">
<h1>Review Your Submission</h1>
<p>
Please take a moment to review the following data you are about to submit. If you would like to add or modify any values, click "Return to Form and Make Changes" at the bottom of the page.
</p>
<p>
The following data will be submitted for <strong>#GetUnit.Unit#</strong> for the month of <strong>#MonthAsString(dataMonth)#</strong>, <strong>#dataYear#</strong>.
</p>

<cfelseif Action IS "Delete">
<table border="0" cellpadding="00">
<tr valign="top">
	<td><img src="../images/warning.gif" alt="Warning" width="34" height="34" border="0" align="absmiddle"></td>
	<td><h2>You are about to delete the following record.<br>Are you sure you want to do this?</h2></td>
</tr>
</table>

<cfelseif Action IS "InsertComment">

<h1>Review Your Submission</h1>
<p>
Please take a moment to review the following comment you are about to submit. If you would like to add or modify any values, click "Return to Form and Make Changes" at the bottom of the page.
</p>
<p>
The following comment will be submitted for <strong>#GetUnit.Unit#</strong> for the month of <strong>#MonthAsString(dataMonth)#</strong>, <strong>#dataYear#</strong>.
</p>




<cfelseif Action IS "UpdateComment">
<h1>Review Changes</h1>
<p>
Please take a moment to review the following changes you are about to submit.
</p>


<cfelseif Action IS "DeleteComment">
<table border="0" cellpadding="00">
<tr valign="top">
	<td><img src="../images/warning.gif" alt="Warning" width="34" height="34" border="0" align="absmiddle"></td>
	<td><h2>You are about to delete the following comment.<br>Are you sure you want to do this?</h2></td>
</tr>
</table>

</cfif>

</cfoutput>
