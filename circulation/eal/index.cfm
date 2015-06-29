<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "EAL">

<cfinclude template="../templates/tmpIndexUnit.cfm">

