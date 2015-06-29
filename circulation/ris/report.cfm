<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "RIS">

<cfinclude template="../templates/tmpReport.cfm">

