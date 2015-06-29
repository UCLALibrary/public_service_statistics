<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "UES">

<cfinclude template="../templates/tmpReport.cfm">

