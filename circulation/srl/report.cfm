<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "SRL">

<cfinclude template="../templates/tmpReport.cfm">

