<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "CLK">

<cfinclude template="../templates/tmpReport.cfm">

