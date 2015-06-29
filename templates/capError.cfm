<h1>Error</h1>

<cfif Action IS "Insert">
	<cfif Blankform IS 1>
<p>None of the fields in the form you submitted contain values. A blank form cannot be submitted.</p>
	<cfelseif NonNumeric IS 1>
<p>One or more of the fields in the form you submitted contains a non-numeric character. Only numeric characters may be submitted. Please click "Return to Form and Make Changes" at the bottom of the page and correct the value(s).</p>	
	</cfif>
<cfelseif Action IS "Update">	
	<cfif Blankform IS 1>
<p>You must enter a number in the value field.</p>
	<cfelseif NonNumeric IS 1>
<p>The value field contains a non-numeric character. Only numeric characters may be submitted.</p>
	</cfif>
</cfif>
