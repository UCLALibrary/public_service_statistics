<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "SGG">

<cfinclude template="../templates/tmpIndexUnit.cfm">

