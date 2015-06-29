<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT *
FROM View_RefUnit
<cfif Find("index.cfm", PATH_INFO) OR Find("confirm.cfm", PATH_INFO)>	
	WHERE UnitID LIKE '<cfoutput>#UnitID#</cfoutput>%'
<cfelse>
	WHERE UnitID LIKE '<cfoutput>#UnitID#</cfoutput>%'
</cfif>
ORDER BY Unit
</cfquery>




