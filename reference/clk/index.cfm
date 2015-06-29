<cfif NOT Session.IsValid>
	<!---cflocation url="../index.cfm" addtoken="No"--->
	<cfset Session.IsValid = 1>
</cfif>

<cfset UnitCode = "CLK">

<cfinclude template="../templates/tmpIndexUnit.cfm">