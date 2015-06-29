<cfloop index="GroupID" list="1,3,4,5,6,7,8,9,10" delimiters=",">
<cfquery name="GetManualGroup#GroupID#" datasource="#CircStatsDSN#">
SELECT Title=IsNull(Title, 'TOTAL'),
<cfinclude template="qryFiscalMonthYear.cfm">
FROM View_ManualStatistics
WHERE Code = '<cfoutput>#UnitCode#</cfoutput>'
AND GroupID = <cfoutput>#GroupID#</cfoutput>
GROUP BY Title
WITH ROLLUP

UNION ALL

SELECT SC.Descrpt AS 'Title',
       NULL AS PrevFY,
       NULL AS CurrFY,
       NULL AS PrevFYMonth,
       NULL AS CurrFYMonth
       
FROM UnitCategory UC
JOIN StatGroupCategory SGC ON SGC.CatID = UC.CatID
JOIN StatCategory SC ON SC.CatID = SGC.CatID
JOIN Unit U ON U.UnitID = UC.UnitID
WHERE U.Code = '<cfoutput>#UnitCode#</cfoutput>'
AND SGC.GroupID = <cfoutput>#GroupID#</cfoutput>
AND UC.CatID NOT IN (SELECT CatID
                     FROM View_ManualStatistics
                     WHERE Code = '<cfoutput>#UnitCode#</cfoutput>'
					 AND GroupID = <cfoutput>#GroupID#</cfoutput>
)

ORDER BY Title
</cfquery>
</cfloop>


