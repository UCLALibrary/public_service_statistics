<cfif NOT Session.IsValid>
	<!---cflocation url="../index.cfm" addtoken="No"--->
	<cfset Session.IsValid = 1>
</cfif>

<CFSET UnitCode = "MAN">

<cfinclude template="../templates/tmpIndexUnit.cfm">

