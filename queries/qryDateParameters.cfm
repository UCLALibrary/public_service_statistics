<cfquery name="GetMaxDate" datasource="#CircStatsDSN#">
SELECT Max(Date) AS 'MaxDate' FROM Circulation
</cfquery>
<cfquery name="GetMaxDateManualStats" datasource="#CircStatsDSN#">
SELECT Max(Updated_DT) AS 'MaxDate' FROM ManualStatistics
WHERE UnitID = <cfoutput>#UnitID#</cfoutput>
</cfquery>

<cfset ReferenceDate = GetMaxDate.MaxDate>
<cfset ReferenceDateManualStats = GetMaxDateManualStats.MaxDate>

<cfset dataMonth = "#DatePart("m", ReferenceDate)#">
<cfset dataYear = "#DatePart("yyyy", GetMaxDate.MaxDate)#">
<cfif dataMonth GTE 1 AND dataMonth LTE 6>
	<cfset CurrFYStart = dataYear - 1>
	<cfset CurrFYEnd = dataYear>
	<cfset PrevFYStart = dataYear - 2>
	<cfset PrevFYEnd = dataYear - 1>
<cfelseif dataMonth GTE 7 AND dataMonth LTE 12>
	<cfset CurrFYStart = dataYear>
	<cfset CurrFYEnd = dataYear + 1>
	<cfset PrevFYStart = dataYear - 1>
	<cfset PrevFYEnd = dataYear>
</cfif>