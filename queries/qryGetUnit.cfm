<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT  U.UnitID,
        U.Title,
		U.Code
FROM Unit U
WHERE U.UnitID = <cfoutput>#UnitID#</cfoutput>

</cfquery>