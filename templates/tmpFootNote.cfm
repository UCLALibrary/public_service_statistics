<a name="footnote" id="footnote"></a>
<p>
*Circulation data extracted from ORION2 is current to <cfoutput>#DateFormat(ReferenceDate, "mmmm d, yyyy")#</cfoutput>.  As of <cfoutput>#DateFormat(Now(), "mmmm d, yyyy")#</cfoutput>, 
<cfif ReferenceDateManualStats IS NOT "">
public service data collected manually is current to <cfoutput>#DateFormat(ReferenceDateManualStats, "mmmm d, yyyy")#</cfoutput>.
<cfelse>
no manually collected data have been input into the database.
</cfif>
</p>

<p>
&dagger;This report does not reflect manually collected data input after <cfoutput>#DateFormat(ReferenceDate, "mmmm d, yyyy")#</cfoutput>.
</p>

