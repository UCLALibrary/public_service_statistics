<cfif NOT Session.IsValid>
	<cflocation url="../index.cfm" addtoken="No">
</cfif>

<CFSET UnitCode = "BIO">

<cfinclude template="../templates/tmpReport.cfm">

