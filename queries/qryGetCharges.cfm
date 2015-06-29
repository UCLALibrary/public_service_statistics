<cfquery name="GetCharges" datasource="#CircStatsDSN#">
SELECT Descrpt=IsNull(Descrpt, 'TOTAL'),
<cfinclude template="qryFiscalMonthYear.cfm">
FROM View_Charges
WHERE UnitCode = '<cfoutput>#UnitCode#</cfoutput>'
GROUP BY Descrpt
WITH ROLLUP

UNION ALL

SELECT DISTINCT Descrpt = 'MANCHARGE',
                NULL AS PrevFY,
                NULL AS CurrFY,
                NULL AS PrevFYMonth,
                NULL AS CurrFYMonth
FROM View_Charges
WHERE 'MANCHARGE' NOT IN (SELECT Descrpt
                          FROM View_Charges
						  WHERE UnitCode = '<cfoutput>#UnitCode#</cfoutput>'
						  )
ORDER BY Descrpt
</cfquery>

