<cfquery name="GetUnitMaster" datasource="#CircStatsDSN#">
SELECT *
FROM View_RefUnitCategory
WHERE UnitID LIKE '#UnitID#%'
ORDER BY PointID, TypeID
</cfquery>

<cfquery name="GetCollectionMethod" dbtype="query">
SELECT DISTINCT
        UnitID,
        UnitPointID,
        Unit,
        ServicePoint,
        InputMethodID
FROM GetUnitMaster
ORDER BY Unit, InputMethodID DESC
</cfquery>

