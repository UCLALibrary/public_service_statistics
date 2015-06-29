<cfoutput>

<cfif Action IS "Update">

<h1>Review Changes</h1>

<p>
Please take a moment to review the following changes you are about to submit. If you need to make further corrections, click "Return to Form and Make Changes" at the bottom of the page.
</p>

<cfelseif Action IS "Insert">

<h1>Review Submission</h1>

<p>
Please take a moment to review the following information you are about to submit. If you would like to add or modify any values, click "Return to Form and Make Changes" at the bottom of the page.
</p>

<p>
The following data will be submitted for the <strong>#GetUnit.Title#</strong> for the month of <strong>#MonthAsString(dataMonth)#</strong>, <strong>#dataYear#</strong>.
</p>

<cfelseif Action IS "Delete">

<h1>Warning!</h1>

<p>
You are about to delete the following record. Are you sure you want to do this?
</p>

</cfif>

</cfoutput>
