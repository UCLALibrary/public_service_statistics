<cfquery name="CheckUnitData" datasource="#CircStatsDSN#">

SELECT *
FROM view_ManualStatistics
WHERE UnitID = <cfoutput>#UnitID#</cfoutput>
</cfquery>

<cfquery name="GetDates" datasource="#CircStatsDSN#">
SELECT MAX(dataMonthYear) AS LatestDate,
	   MIN(dataMonthYear) AS EarliestDate
FROM view_ManualStatistics
WHERE UnitID = <cfoutput>#UnitID#</cfoutput>
</cfquery>

<cfif CheckUnitData.RecordCount IS 0>
	<cfset NoData = 1>
<cfelse>
	<cfset NoData = 0>
	<cfset EarliestYear = DatePart("yyyy", GetDates.EarliestDate)>
	<cfset LatestYear = DatePart("yyyy", GetDates.LatestDate)>
	<cfif dataMonth IS 0>
		<cfset dataMonth = DatePart("m", GetDates.LatestDate)>
	</cfif>
	<cfif dataYear IS 0>
		<cfset dataYear = LatestYear>
	</cfif>
</cfif>

<cfif NoData IS 0>
<cfquery name="GetTransactions" datasource="#CircStatsDSN#">
SELECT  RecordID,
        CatID,
		Title,
        GroupDescrpt,
        [count],
        dataMonth,
        dataYear,
        Updated_DT,
        LogonID
FROM view_ManualStatistics
WHERE UnitID = <cfoutput>#UnitID#</cfoutput>

<cfoutput>
<cfif RecordID IS NOT 0>
	AND RecordID = #RecordID#		
</cfif>

<cfif Find("transaction.cfm", PATH_INFO)>
	AND dataMonth = #dataMonth#
	AND dataYear = #dataYear#
</cfif>

<cfif IsDefined("SortOrder")>
	<cfswitch expression="#SortOrder#">
	<cfcase value="SG">
ORDER BY GroupDescrpt
	</cfcase>
	<cfcase value="SC">
ORDER BY Title
	</cfcase>
	<cfcase value="C">
ORDER BY [count]
	</cfcase>
	<cfcase value="D">
ORDER BY dataYear , dataMonth
	</cfcase>
	<cfcase value="CU">
ORDER BY Updated_DT
	</cfcase>
	<cfcase value="U">
ORDER BY LogonID
	</cfcase>
	</cfswitch>

	<cfif Flag IS 0>
		DESC
	</cfif>

</cfif>

</cfoutput>

</cfquery>

</cfif>

