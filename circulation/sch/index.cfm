<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "SCH">

<cfinclude template="../templates/tmpIndexUnit.cfm">

