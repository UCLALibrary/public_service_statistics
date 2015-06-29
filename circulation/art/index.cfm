<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "ART">

<cfinclude template="../templates/tmpIndexUnit.cfm">

