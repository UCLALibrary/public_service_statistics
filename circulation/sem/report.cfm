<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "SEM">

<cfinclude template="../templates/tmpReport.cfm">

