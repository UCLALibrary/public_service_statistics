<cfif NOT Session.IsValid>
	<!---cflocation url="../index.cfm" addtoken="No"--->
	<cfset Session.IsValid = 1>
</cfif>

<cfset UnitCode = "RBR">

<cfinclude template="../templates/tmpIndexUnit.cfm">