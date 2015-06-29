<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "COL">

<cfinclude template="../templates/tmpIndexUnit.cfm">

