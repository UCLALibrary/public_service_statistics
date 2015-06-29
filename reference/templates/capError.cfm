<h1>Error</h1>

<cfif Action IS "Insert">
	<cfif Blankform IS 1>
<p>None of the fields in the form you submitted contain values. A blank form cannot be submitted. Please click "Return to Form to Make Changes" to input a values.</p>
	<cfelseif BadData IS 1>
<p>One or more of the fields in the form you submitted contains a non-numeric character or a value that does not represent a whole number. Only numeric characters that are whole numbers may be submitted. Please click "Return to Form to Make Changes" below to correct the value(s).</p>
	</cfif>
<cfelseif Action IS "Update">	
	<cfif Blankform IS 1>
<p>You must enter a number in the value field.</p>
	<cfelseif BadData IS 1>
<p>The value field contains a non-numeric character or a value that does not represent a whole number. Only numeric characters that are whole numbers may be submitted. Please click "Return to Form to Make Changes" below to correct the value.</p>
	<cfelseif IsValidCategory IS 0>
		<cfoutput>
<p>The combination of statistical category attributes that you have specified for this unit/service point is not valid.</p>

<p>
		<cfif StructFind(DeAggregateID, "TypeID") IS "00" AND
		      StructFind(DeAggregateID, "ModeID") IS NOT "00">
The <strong>#GetQuestionType.Descrpt#</strong> category can only have a value of <strong>None</strong> for mode (e.g., "in-person," "telephone," etc.) of interaction.
		<cfelseif StructFind(DeAggregateID, "TypeID") IS NOT "00" AND
		      StructFind(DeAggregateID, "ModeID") IS "00">
A <strong>mode</strong> (e.g., "in-person," "telephone," etc.) of interaction must be specified for <strong>#GetQuestionType.Descrpt#</strong> type questions.			  
		<cfelse>
<strong>#GetMode.Descrpt#</strong> <strong>#GetQuestionType.Descrpt#</strong> type questions are not being tracked at the <strong>#GetUnit.Unit#/#GetServicePoint.Descrpt#</strong> location.
		</cfif>
</p>

<p>
If you are not sure which statistical categories are being collected for this unit/service point, see the list below. If you need to add a new statistical category to capture for this unit/service point, please contact David Yamamoto at 310/267-2692 or davmoto@library.ucla.edu. Please click "Return to Form to Make Changes" below to correct the value(s).</p>
		</cfoutput>
	</cfif>
</cfif>
