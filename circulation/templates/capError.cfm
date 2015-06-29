<h1>Error</h1>

<cfif Action IS "Insert">
	<cfif Blankform IS 1>
<p>None of data fields in the form you submitted contain values. A blank form cannot be submitted. Please click "Return to Form to Make Changes" to input a values.</p>
	<cfelseif BadData IS 1>
<p>One or more of the numeric data fields in the form you submitted contains a non-numeric character or a value that does not represent a whole number. Only numeric characters that are whole numbers may be submitted. Please click "Return to Form to Make Changes" below to correct the value(s).</p>
	</cfif>
<cfelseif Action IS "Update">	
	<cfif Blankform IS 1>
<p>You must enter a number in the value field.</p>
	<cfelseif BadData IS 1>
<p>The value field contains a non-numeric character or a value that does not represent a whole number. Only numeric characters that are whole numbers may be submitted. Please click "Return to Form to Make Changes" below to correct the value.</p>
	</cfif>
<cfelseif Action IS "UpdateComment">
	<cfif Blankform IS 1>
<p>You must include a comment. Please click "Return to Form to Make Changes" below to input a comment.</p>
	</cfif>
</cfif>
