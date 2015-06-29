<cfquery name="GetAutoCircStats" datasource="#CircStatsDSN#">
SELECT  Title,
		Descrpt,
<cfinclude template="qryFiscalMonthYear.cfm">
FROM View_AutoCircStats
WHERE UnitCode = '<cfoutput>#UnitCode#</cfoutput>'
GROUP BY Descrpt, Title
ORDER BY Descrpt
</cfquery>





