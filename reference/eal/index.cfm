<cfif NOT Session.IsValid>
	<!---cflocation url="../index.cfm" addtoken="No"--->
	<cfset Session.IsValid = 1>
</cfif>

<CFSET UnitCode = "EAL">

<cfinclude template="../templates/tmpIndexUnit.cfm">

