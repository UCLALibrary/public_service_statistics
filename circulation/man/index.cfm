<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "MAN">

<cfinclude template="../templates/tmpIndexUnit.cfm">

