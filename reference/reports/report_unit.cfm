<cfif Find("reports/generator.cfm", HTTP_REFERER) IS 0>
<cflocation url="../index.cfm" addtoken=0>
<cfabort>
</cfif>
<cfparam name="text" default = 0>
<cfparam name="PrintFormat" default = 0>
<cfparam name="Level" default = "#FORM.Level#">
<cfparam name="Step" default = "#FORM.Step#">
<cfparam name="UnitID" default = "#FORM.UnitID#">
<cfparam name="ReportType" default = "#FORM.ReportType#">
<cfparam name="Start1" default = "#FORM.Start1#">
<cfparam name="End1" default = "#FORM.End1#">
<cfparam name="Flag" default = 0>
<cfset BarFactor = 0.02>

<!--- check to see if a valid date range was specified --->
<cfset DateCompare = DateCompare(Start1, End1)>
<cfset IsStart1Date = IsDate(Start1)>
<cfset IsEnd1Date = IsDate(End1)>
<cfif DateCompare GT 0 OR NOT IsStart1Date OR NOT IsEnd1Date>
<cfset InvalidDateRange = 1>
<cfelse>
<cfset InvalidDateRange = 0>
</cfif>

<!--- call to query to get unit information --->
<cfinclude template="objects/qryGetUnits.cfm">

<!--- call to list of report titles switch statement --->
<cfinclude template="objects/tmpReportTitles.cfm">

<cfif NOT InvalidDateRange>

<cfquery name="GetDataCollectionMethod" datasource="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
SELECT DISTINCT
InputMethod
FROM
ReferenceStatistics
WHERE
AggregateID LIKE '#UnitID#%'
AND (
(
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#' AND InputMethod = 2
)
OR
(
CAST(CAST(dataMonth AS VARCHAR) + '/' + '01' + '/' + CAST(dataYear AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#' AND InputMethod = 1
)
)
</cfquery>

<cfif GetDataCollectionMethod.RecordCount IS 0>
<cfset NoData = 1>
<cfset Monthly = 0>
<cfset RealTime = 0>
<cfelse>
<cfset NoData = 0>
<!--- check to see if the unit/department is a real-time data inputter --->
<cfset RealTime = 0>
<cfloop query="GetDataCollectionMethod">
<cfif InputMethod EQ 2>
<cfset RealTime = 1>
<cfbreak>
</cfif>
</cfloop>
<cfset Monthly = 0>
<cfloop query="GetDataCollectionMethod">
<cfif InputMethod EQ 1>
<cfset Monthly = 1>
<cfbreak>
</cfif>
</cfloop>
</cfif>

<cfif NOT NoData>
<cfswitch expression="#ReportType#">
<!--- begin if report type is 1 --->
<cfcase value="1">
<cfif Monthly>
<cfquery name="GetTransactions"  DATASOURCE="#CircStatsDSN#">
SELECT
RU.Descrpt AS Library,
RSP.Descrpt AS ServicePoint,
SUM([Count]) AS Total
FROM
ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE
SUBSTRING(AggregateID, 8, 2) = '00'
AND AggregateID LIKE '#UnitID#%'
AND (
(
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#' AND InputMethod = 2
)
OR
(
CAST(CAST(dataMonth AS VARCHAR) + '/' + '01' + '/' + CAST(dataYear AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#' AND InputMethod = 1
)
)
GROUP BY
RU.Descrpt, RSP.Descrpt
WITH ROLLUP
ORDER BY
Library, ServicePoint
</cfquery>
<cfloop query="GetTransactions">
<cfif GetTransactions.Library IS "" AND GetTransactions.ServicePoint IS "">
<cfset GetTransactionsTotal = GetTransactions.Total>
<cfbreak>
</cfif>
</cfloop>
</cfif>

<cfif RealTime>
<cfquery name="GetTransactionsRT"  DATASOURCE="#CircStatsDSN#">
SELECT
RU.Descrpt AS Library,
RSP.Descrpt AS ServicePoint,
SUM([Count]) AS Total
FROM
ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE
SUBSTRING(AggregateID, 8, 2) = '00'
AND AggregateID LIKE '#UnitID#%'
AND InputMethod = 2
AND (
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY
RU.Descrpt, RSP.Descrpt
WITH ROLLUP
ORDER BY
Library, ServicePoint
</cfquery>
<cfloop query="GetTransactionsRT">
<cfif GetTransactionsRT.Library IS "">
<cfset GetTransactionsRTTotal = GetTransactionsRT.Total>
</cfif>
</cfloop>

<!--- hourly transactions query --->
<cfquery name="GetHourly"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
DATEPART(Hour, Created_DT) AS HourDay,
SUM([Count]) AS Total
FROM ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE SUBSTRING(AggregateID, 8, 2) = '00'
AND AggregateID LIKE '#UnitID#%'
AND InputMethod = 2
AND (
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY RU.Descrpt + ' ' + RSP.Descrpt, DATEPART(Hour, Created_DT)
WITH ROLLUP
ORDER BY LibraryPoint, HourDay
</cfoutput>
</cfquery>

<cfquery name="GetDaily"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
DATEPART(WeekDay, Created_DT) AS DayWeek,
SUM([Count]) AS Total
FROM ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE SUBSTRING(AggregateID, 8, 2) = '00'
AND AggregateID LIKE '#UnitID#%'
AND InputMethod = 2
AND (
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY RU.Descrpt + ' ' + RSP.Descrpt, DATEPART(WeekDay, Created_DT)
WITH ROLLUP
ORDER BY LibraryPoint, DayWeek
</cfoutput>
</cfquery>
<cfquery name="GetDailyHourly"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT
RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
DATEPART(hh, RS.Created_DT) AS "Hour",
"MON" = SUM(CASE WHEN DATEPART(dw, RS.Created_DT) = 2 THEN [Count] ELSE 0 END),
"TUE" = SUM(CASE WHEN DATEPART(dw, RS.Created_DT) = 3 THEN [Count] ELSE 0 END),
"WED" = SUM(CASE WHEN DATEPART(dw, RS.Created_DT) = 4 THEN [Count] ELSE 0 END),
"THU" = SUM(CASE WHEN DATEPART(dw, RS.Created_DT) = 5 THEN [Count] ELSE 0 END),
"FRI" = SUM(CASE WHEN DATEPART(dw, RS.Created_DT) = 6 THEN [Count] ELSE 0 END),
"SAT" = SUM(CASE WHEN DATEPART(dw, RS.Created_DT) = 7 THEN [Count] ELSE 0 END),
"SUN" = SUM(CASE WHEN DATEPART(dw, RS.Created_DT) = 1 THEN [Count] ELSE 0 END)
FROM ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE SUBSTRING(AggregateID, 8, 2) = '00'
AND AggregateID LIKE '#UnitID#%'
AND InputMethod = 2
AND (
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY RU.Descrpt + ' ' + RSP.Descrpt, DATEPART(hh, RS.Created_DT)
ORDER BY LibraryPoint, Hour
</cfoutput>
</cfquery>
</cfif>
</cfcase>
<!--- end if report type is 1 --->

<!--- begin if report type is 2 --->
<cfcase value="2">
<cfif Monthly>
<cfquery name="GetQuestions"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
"d" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END),
"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END),
"s" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '03' THEN [Count] ELSE 0 END),
"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '04' THEN [Count] ELSE 0 END),
"r" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END),
"c" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '06' THEN [Count] ELSE 0 END),
<cfif UnitID is "YRL02">
"mp" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '07' THEN [Count] ELSE 0 END),
"mq" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '08' THEN [Count] ELSE 0 END),
</cfif>
"Total" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '03' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '04' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '06' THEN [Count] ELSE 0 END)
<cfif UnitID is "YRL02">
+ SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '07' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '08' THEN [Count] ELSE 0 END)
</cfif>
FROM ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
AND AggregateID LIKE '#UnitID#%'
AND (
(
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#'
AND InputMethod = 2
)
OR
(
CAST(CAST(dataMonth AS VARCHAR) + '/' + '01' + '/' + CAST(dataYear AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#'
AND InputMethod = 1
)
)
GROUP BY RU.Descrpt + ' ' + RSP.Descrpt
WITH ROLLUP
ORDER BY LibraryPoint
</cfoutput>
</cfquery>
<cfloop query="GetQuestions">
<cfif GetQuestions.LibraryPoint IS "">
<cfset GetQuestionsTotal = GetQuestions.Total>
</cfif>
</cfloop>

<cfquery name="GetQuestionMode"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT RT.Descrpt AS QuestionType,
"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
"c" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '04' THEN [Count] ELSE 0 END),
"o" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '05' THEN [Count] ELSE 0 END),
"m" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '06' THEN [Count] ELSE 0 END),
"Total" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '04' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '05' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '06' THEN [Count] ELSE 0 END)
FROM ReferenceStatistics RS
JOIN RefMode RM ON RM.MOdeID = SUBSTRING(RS.AggregateID, 10, 2)
JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
AND AggregateID LIKE '#UnitID#%'
AND (
(
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#'
AND InputMethod = 2
)
OR
(
CAST(CAST(dataMonth AS VARCHAR) + '/' + '01' + '/' + CAST(dataYear AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#'
AND InputMethod = 1
)
)
GROUP BY RT.Descrpt
WITH ROLLUP
ORDER BY QuestionType
</cfoutput>
</cfquery>
<cfloop query="GetQuestionMode">
<cfif GetQuestionMode.QuestionType IS "">
<cfset GetQuestionModeTotal = GetQuestionMode.Total>
</cfif>
</cfloop>

<cfquery name="GetPointMode"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT RSP.Descrpt AS ServicePoint,
"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
"c" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '04' THEN [Count] ELSE 0 END),
"o" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '05' THEN [Count] ELSE 0 END),
"m" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '06' THEN [Count] ELSE 0 END),
"Total" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '04' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '05' THEN [Count] ELSE 0 END) +
SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '06' THEN [Count] ELSE 0 END)
FROM ReferenceStatistics RS
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
JOIN RefMode RM ON RM.ModeID = SUBSTRING(RS.AggregateID, 10, 2)
WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
AND AggregateID LIKE '#UnitID#%'
AND (
(
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#'
AND InputMethod = 2
)
OR
(
CAST(CAST(dataMonth AS VARCHAR) + '/' + '01' + '/' + CAST(dataYear AS VARCHAR) AS SMALLDATETIME)
BETWEEN '#Start1#' AND '#End1#'
AND InputMethod = 1
)
)
GROUP BY RSP.Descrpt
WITH ROLLUP
ORDER BY ServicePoint
</cfoutput>
</cfquery>
<cfloop query="GetPointMode">
<cfif GetPointMode.ServicePoint IS "">
<cfset GetPointModeTotal = GetPointMode.Total>
</cfif>
</cfloop>
</cfif>
<cfif RealTime>
<cfquery name="GetQuestionsRT"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT
	RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
	"d" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END),
	"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END),
	"r" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END),
	"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN [Count] ELSE 0 END),
	"p" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN [Count] ELSE 0 END),
	d_time = COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN TimeSpent ELSE 0 END), 0),
	i_time = coalesce(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN TimeSpent ELSE 0 END), 0),
	r_time = coalesce(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN TimeSpent ELSE 0 END), 0),
	t_time = coalesce(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN TimeSpent ELSE 0 END), 0),
	p_time = coalesce(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN TimeSpent ELSE 0 END), 0),
	"Total" =
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN [Count] ELSE 0 END),
	Total_Time =
		coalesce(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN TimeSpent ELSE 0 END), 0)
FROM
	ReferenceStatistics RS
	JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
	JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE
	SUBSTRING(AggregateID, 8, 2) <> '00'
	AND InputMethod = 2
	AND AggregateID LIKE '#UnitID#%'
	AND
	(
		CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
	)
GROUP BY
	RU.Descrpt + ' ' + RSP.Descrpt
WITH ROLLUP
ORDER BY
	LibraryPoint
</cfoutput>
</cfquery>
<cfloop query="GetQuestionsRT">
<cfif GetQuestionsRT.LibraryPoint IS "">
<cfset GetQuestionsRTTotal = GetQuestionsRT.Total>
<cfset GetQuestionsRTTimeTotal = GetQuestionsRT.Total_Time>
</cfif>
</cfloop>

<cfquery name="GetAvgQuestionsRT"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT
	RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
	d_time = COALESCE(avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN TimeSpent END), 0),
	i_time = COALESCE(avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN TimeSpent END), 0),
	r_time = COALESCE(avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN TimeSpent END), 0),
	t_time = COALESCE(avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN TimeSpent END), 0),
	p_time = COALESCE(avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN TimeSpent END), 0),
	Total_Time = COALESCE(avg(TimeSpent), 0)
--		COALESCE(avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN TimeSpent END) +
--		avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN TimeSpent END) +
--		avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN TimeSpent END) +
--		avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN TimeSpent END) +
--		avg(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN TimeSpent END), 0)
FROM
	ReferenceStatistics RS
	JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
	JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE
	SUBSTRING(AggregateID, 8, 2) <> '00'
	AND InputMethod = 2
	AND AggregateID LIKE '#UnitID#%'
	AND
	(
		CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
	)
GROUP BY
	RU.Descrpt + ' ' + RSP.Descrpt
WITH ROLLUP
ORDER BY
	LibraryPoint
</cfoutput>
</cfquery>
<cfloop query="GetAvgQuestionsRT">
<cfif GetAvgQuestionsRT.LibraryPoint IS "">
<cfset GetAvgQuestionsRTTotal = GetAvgQuestionsRT.Total_Time>
</cfif>
</cfloop>

<cfquery name="GetQuestionModeRT"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT
	RT.Descrpt AS QuestionType,
	"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
	"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
	"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
	i_time = COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent ELSE 0 END), 0),
	t_time = COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent ELSE 0 END), 0),
	e_time = COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent ELSE 0 END), 0),
	"Total" =
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
	Total_Time =
		COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent ELSE 0 END), 0)
FROM
	ReferenceStatistics RS
	JOIN RefMode RM ON RM.MOdeID = SUBSTRING(RS.AggregateID, 10, 2)
	JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
WHERE
	SUBSTRING(AggregateID, 8, 2) <> '00'
	AND AggregateID LIKE '#UnitID#%'
	AND InputMethod = 2
	AND
	(
		CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
	)
GROUP BY
	RT.Descrpt
WITH ROLLUP
ORDER BY
	QuestionType
</cfoutput>
</cfquery>
<cfloop query="GetQuestionModeRT">
<cfif GetQuestionModeRT.QuestionType IS "">
<cfset GetQuestionModeRTTotal = GetQuestionModeRT.Total>
<cfset GetQuestionModeRTTimeTotal = GetQuestionModeRT.Total_Time>
</cfif>
</cfloop>

<cfquery name="GetAvgQuestionModeRT"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT
	RT.Descrpt AS QuestionType,
	i_time = COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent END), 0),
	t_time = COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent END), 0),
	e_time = COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent END), 0),
	Total_Time =  COALESCE(AVG(TimeSpent), 0)
--		COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent END) +
--		AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent END) +
--		AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent END), 0)
FROM
	ReferenceStatistics RS
	JOIN RefMode RM ON RM.MOdeID = SUBSTRING(RS.AggregateID, 10, 2)
	JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
WHERE
	SUBSTRING(AggregateID, 8, 2) <> '00'
	AND AggregateID LIKE '#UnitID#%'
	AND InputMethod = 2
	AND
	(
		CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
	)
GROUP BY
	RT.Descrpt
WITH ROLLUP
ORDER BY
	QuestionType
</cfoutput>
</cfquery>
<cfloop query="GetAvgQuestionModeRT">
<cfif GetAvgQuestionModeRT.QuestionType IS "">
<cfset GetAvgQuestionModeRTTotal = GetAvgQuestionModeRT.Total_Time>
</cfif>
</cfloop>

<cfquery name="GetPointModeRT"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT
	RSP.Descrpt AS ServicePoint,
	"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
	"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
	"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
	i_time = COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent ELSE 0 END), 0),
	t_time = COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent ELSE 0 END), 0),
	e_time = COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent ELSE 0 END), 0),
	"Total" =
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
	Total_Time =
		COALESCE(SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent ELSE 0 END) +
		SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent ELSE 0 END), 0)
FROM
	ReferenceStatistics RS
	JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
	JOIN RefMode RM ON RM.ModeID = SUBSTRING(RS.AggregateID, 10, 2)
WHERE
	SUBSTRING(AggregateID, 8, 2) <> '00'
	AND AggregateID LIKE '#UnitID#%'
	AND InputMethod = 2
	AND
	(
		CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
	)
GROUP BY
	RSP.Descrpt
WITH ROLLUP
ORDER BY
	ServicePoint
</cfoutput>
</cfquery>
<cfloop query="GetPointModeRT">
<cfif GetPointModeRT.ServicePoint IS "">
<cfset GetPointModeRTTotal = GetPointModeRT.Total>
<cfset GetPointModeRTTimeTotal = GetPointModeRT.Total_Time>
</cfif>
</cfloop>

<cfquery name="GetAvgPointModeRT"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT
	RSP.Descrpt AS ServicePoint,
	i_time = COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent END), 0),
	t_time = COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent END), 0),
	e_time = COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent END), 0),
	Total_Time =  COALESCE(AVG(TimeSpent), 0)
--		COALESCE(AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN TimeSpent END) +
--		AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN TimeSpent END) +
--		AVG(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN TimeSpent END), 0)
FROM
	ReferenceStatistics RS
	JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
	JOIN RefMode RM ON RM.ModeID = SUBSTRING(RS.AggregateID, 10, 2)
WHERE
	SUBSTRING(AggregateID, 8, 2) <> '00'
	AND AggregateID LIKE '#UnitID#%'
	AND InputMethod = 2
	AND
	(
		CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
		CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
	)
GROUP BY
	RSP.Descrpt
WITH ROLLUP
ORDER BY
	ServicePoint
</cfoutput>
</cfquery>
<cfloop query="GetAvgPointModeRT">
<cfif GetAvgPointModeRT.ServicePoint IS "">
<cfset GetAvgPointModeRTTotal = GetAvgPointModeRT.Total_Time>
</cfif>
</cfloop>

<cfquery name="GetHourly"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
DATEPART(Hour, Created_DT) AS HourDay,
SUM([Count]) AS Total
FROM ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
AND AggregateID LIKE '#UnitID#%'
AND InputMethod = 2
AND (
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY RU.Descrpt + ' ' + RSP.Descrpt, DATEPART(Hour, Created_DT)
WITH ROLLUP
ORDER BY LibraryPoint, HourDay
</cfoutput>
</cfquery>

<cfquery name="GetHourlyType"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
<cfoutput>
SELECT
RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
RT.Descrpt AS QuestionType,
DATEPART(Hour, RS.Created_DT) AS HourDay,
SUM(RS.[Count]) AS Total
FROM
ReferenceStatistics RS
JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE
SUBSTRING(RS.AggregateID, 8, 2) <> '00'
AND AggregateID LIKE '#UnitID#%'
AND RS.InputMethod = 2
AND
(
CAST(CAST(DATEPART(Month, RS.Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Day, RS.Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Year, RS.Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY
RU.Descrpt + ' ' + RSP.Descrpt,
RT.Descrpt,
DATEPART(Hour, Created_DT)
WITH ROLLUP
ORDER BY
LibraryPoint,
QuestionType,
HourDay
</cfoutput>
</cfquery>

<cfquery name="GetDaily"  DATASOURCE="#CircStatsDSN#">
<cfoutput>
SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
DATEPART(WeekDay, Created_DT) AS DayWeek,
SUM([Count]) AS Total
FROM ReferenceStatistics RS
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
AND AggregateID LIKE '#UnitID#%'
AND InputMethod = 2
AND (
CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY RU.Descrpt + ' ' + RSP.Descrpt, DATEPART(WeekDay, Created_DT)
WITH ROLLUP
ORDER BY LibraryPoint, DayWeek
</cfoutput>
</cfquery>

<cfquery name="GetDailyType"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
<cfoutput>
SELECT
RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
RT.Descrpt AS QuestionType,
DATEPART(WeekDay, RS.Created_DT) AS DayWeek,
SUM(RS.[Count]) AS Total
FROM
ReferenceStatistics RS
JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
WHERE
SUBSTRING(AggregateID, 8, 2) <> '00'
AND AggregateID LIKE '#UnitID#%'
AND RS.InputMethod = 2
AND
(
CAST(CAST(DATEPART(Month, RS.Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Day, RS.Created_DT) AS VARCHAR) + '/' +
CAST(DATEPART(Year, RS.Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY
RU.Descrpt + ' ' + RSP.Descrpt,
RT.Descrpt,
DATEPART(WeekDay, RS.Created_DT)
WITH ROLLUP
ORDER BY
LibraryPoint,
QuestionType,
DayWeek
</cfoutput>
</cfquery>

<cfquery name="Greater10ByPoint"  DATASOURCE="#CircStatsDSN#">
SELECT
ru.[Descrpt] + ' ' + rp.[Descrpt] AS ServicePoint,
rt.[Descrpt] AS QuestionType,
COUNT(rs.[RecordID]) as Total
FROM
RefStatsLongQuestions rs
join RefServicePoint rp on rs.PointID = rp.PointID
JOIN RefType rt ON rs.TypeID = rt.TypeID
JOIN RefUnit ru ON rs.UnitID = ru.UnitID
WHERE
rs.UnitID LIKE '#UnitID#%'
AND
(
CAST(CAST(DATEPART(Month, rs.[Created_DT]) AS VARCHAR) + '/' +
CAST(DATEPART(Day, rs.[Created_DT]) AS VARCHAR) + '/' +
CAST(DATEPART(Year, rs.[Created_DT]) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY
ru.[Descrpt] + ' ' + rp.[Descrpt],
rt.[Descrpt]
UNION
SELECT
ru.[Descrpt] + ' ' + rp.[Descrpt] AS ServicePoint,
NULL AS QuestionType,
COUNT(rs.[RecordID]) as Total
FROM
RefStatsLongQuestions rs
join RefServicePoint rp on rs.PointID = rp.PointID
JOIN RefType rt ON rs.TypeID = rt.TypeID
JOIN RefUnit ru ON rs.UnitID = ru.UnitID
WHERE
rs.UnitID LIKE '#UnitID#%'
AND
(
CAST(CAST(DATEPART(Month, rs.[Created_DT]) AS VARCHAR) + '/' +
CAST(DATEPART(Day, rs.[Created_DT]) AS VARCHAR) + '/' +
CAST(DATEPART(Year, rs.[Created_DT]) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
)
GROUP BY
ru.[Descrpt] + ' ' + rp.[Descrpt]
ORDER BY
ServicePoint,
QuestionType
</cfquery>


</cfif>
</cfcase>
<!--- end if report type is 2 --->
</cfswitch>
</cfif>
</cfif>

<HTML>
<HEAD>
<script language="JavaScript">
//<!-- Display popup windows
function PopUp(URL) {
_loc = URL;
popupsWin = window.open(_loc,"PSpopups","toolbar=no,width=767,height=400,scrollbars=yes,resizable=no,screenX=10,screenY=10,top=10,left=10");
if (popupsWin.opener == null) { popupsWin.opener = self }
}
//--->
</script>


<cfoutput>
<TITLE>
#GetParentUnit.ParentUnit#
<cfif Level IS "Unit">
(all departments)
</cfif>
<cfif (Level IS "SubUnit") AND ("#GetParentUnit.ParentUnit#" IS NOT "#GetParentSubUnit.SubUnit#")>
#GetParentSubUnit.SubUnit#
</cfif>: #ReportTitle#
</TITLE>
</cfoutput>
<cfif Text IS 0>
<cfinclude template="../../../library_pageincludes/banner_nonav.cfm">
</cfif>
<cfif Text IS 1>
<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->

<a href="../../index.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Reference</a> &gt; <a href="generator.cfm?Level=Unit">Unit-Specific Report</a> &gt;
<cfoutput>
#GetParentUnit.ParentUnit#
<cfif Level IS "Unit">
(all departments)
</cfif>
<cfif (Level IS "SubUnit") AND ("#GetParentUnit.ParentUnit#" IS NOT "#GetParentSubUnit.SubUnit#")>
#GetParentSubUnit.SubUnit#
</cfif>: #ReportTitle#
</cfoutput>

<!-- end you are here -->

<cfif Text IS 0>
<cfinclude template="../../../library_pageincludes/start_content_nonav.cfm">
</cfif>
<cfif Text IS 1>
<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<cfoutput>
<form action="generator.cfm" method="post" class="form">
<input type="hidden" name="Step" value="2">
<input type="hidden" name="Level" value="#Level#">
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="ReportType" value="#ReportType#">
<input type="hidden" name="Start1" value="#Start1#">
<input type="hidden" name="End1" value="#End1#">
<input type="submit" value="< Back" class="form">
</form>
</cfoutput>

<cfif InvalidDateRange>
<cfif DateCompare GT 0 OR NOT IsStart1Date OR NOT IsEnd1Date>
<h3>Error</h3>

<cfif DateCompare GT 0>
<p>
<span class="hilite">You have specified an invalid time span.  The end date of the time span must be on or after the start date.</span>
</p>
<cfelseif NOT IsStart1Date OR NOT IsEnd1Date>
<p>
<span class="hilite">You have entered an incorrect date format. Please enter dates in the format mm/dd/yyyy.</span>
</p>
</cfif>
</cfif>

<cfelseif NoData>
<h3>Unable to generate report</h3>

<p>Possible reasons:</p>
<ul>
<li>No data is available for the time range specified</li>
<li>This unit has not input any data</li>
</ul>

<p>
<cfoutput>
<a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')">See data availability by unit/service points</a>
</cfoutput>
</p>

<cfelse>

<cfoutput>
<h2>
#GetParentUnit.ParentUnit#
<cfif Level IS "Unit">
(all departments)
</cfif>
<cfif (Level IS "SubUnit") AND ("#GetParentUnit.ParentUnit#" IS NOT "#GetParentSubUnit.SubUnit#")>
#GetParentSubUnit.SubUnit#
</cfif>
: #ReportTitle#<br>
</h2>
</cfoutput>




<hr align="left" width="100%" noshade>

<cfswitch expression="#ReportType#">

<cfcase value="1">

<cfif Monthly>


<!--- total transactions monthly --->
<p>
<cfoutput>
<span class="large">Total transactions</span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>

<cfif (Month(Start1) IS Month(End1)) AND (Year(Start1) IS Year(End1))>
#Month(Start1)#/#Year(Start1)#
<cfelse>
#Month(Start1)#/#Year(Start1)# to #Month(End1)#/#Year(End1)#
</cfif>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap class="tblcopy"><strong>Library and service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total transactions</strong></td>
</tr>
<cfoutput query="GetTransactions">
<cfif ServicePoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#Library# #ServicePoint#</td>
<td align="right" nowrap class="tblcopy">#Total# (#NumberFormat(Evaluate((Total / GetTransactionsTotal) * 100), '__._')#%)</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetTransactions">
<cfif Library IS "" AND ServicePoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#Total#</td>
</tr>
</cfif>
</cfoutput>
</table>
</p>
</cfif>

<cfif RealTime>

<!--- total transactions, real-time --->

<p>
<span class="large">Total transactions<cfif Monthly>, real-time service points only</cfif></span><br>
<cfoutput>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap class="tblcopy"><strong>Library and service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total transactions</strong></td>
</tr>
<cfoutput query="GetTransactionsRT">
<cfif ServicePoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#Library# #ServicePoint#</td>
<td align="right" nowrap class="tblcopy">#Total# (#NumberFormat(Evaluate((Total / GetTransactionsRTTotal) * 100), '__._')#%)</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetTransactionsRT">
<cfif Library IS "" AND ServicePoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#Total#</td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<!--- total transactions by day of week --->
<p>
<cfoutput>
<span class="large">Total transactions by day of week<cfif Monthly>, real-time service points only</cfif></span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
</p>
<cfoutput query="GetDaily" group="LibraryPoint">
<cfif LibraryPoint IS NOT "">
<p>
#LibraryPoint#
<cfif DayWeek IS "" AND LibraryPoint IS NOT "">
<cfset PointTotal = Total>(n = #PointTotal#)<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" background="../../images/bg_graph.gif">
<tr>
<td class="small">&nbsp;</td>
<td width="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="66" align="left" class="small">0%</td>
<td width="66" align="center" class="small">50%</td>
<td width="66" align="right" class="small">100%</td>
</tr>
</table>
</td>
</tr>
<tr>
<td height="1" colspan="3" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<cfoutput group="DayWeek">
<cfif DayWeek IS NOT "">
<cfset BarWidth = #Round(Evaluate((Total/PointTotal)*200))#>
<tr valign="middle">
<td class="small">#UCase(RemoveChars(DayOfWeekAsString(DayWeek), 4, Evaluate(Len(DayOfWeekAsString(DayWeek))-3)))#&nbsp;</td>
<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/PointTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / PointTotal) * 100), '__._')#%)</td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
</cfif>
</cfoutput>
</table></p>
</cfif>
</cfoutput>

<hr align="left" width="100%" noshade>


<!--- total transactions by hour of day --->
<cfoutput>
<p>
<span class="large">Total transactions by hour of day<cfif Monthly>, real-time service points only</cfif></span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</p>
</cfoutput>
<cfoutput query="GetHourly" group="LibraryPoint">
<cfif LibraryPoint IS NOT "">
<p>
#LibraryPoint#
<cfif HourDay IS "" AND LibraryPoint IS NOT "">
<cfset PointTotal = Total>(n = #PointTotal#)<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" background="../../images/bg_graph.gif">
<tr>
<td class="small">&nbsp;</td>
<td width="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="66" align="left" class="small">0%</td>
<td width="66" align="center" class="small">50%</td>
<td width="66" align="right" class="small">100%</td>
</tr>
</table>
</td>
</tr>
<tr>
<td height="1" colspan="3" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<cfoutput group="HourDay">
<cfif HourDay IS NOT "">
<cfset BarWidth = #Round(Evaluate((Total/PointTotal)*200))#>
<tr valign="middle">
<td class="small">#TimeFormat(CreateTime(HourDay, 00, 00), "htt")#&nbsp;</td>
<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/PointTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / PointTotal) * 100), '__._')#%)</td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
</cfif>
</cfoutput>
</table></p>
</cfif>
</cfoutput>

<hr align="left" width="100%" noshade>


<!--- total transactions by day of week and hour of day --->
<cfoutput>
<p>
<span class="large">Total transactions by day of week and hour of day<cfif Monthly>, real-time service points only</cfif></span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</p>
</cfoutput>
<cfoutput query="GetDailyHourly" group="LibraryPoint">
<cfif LibraryPoint IS NOT "">
<p>
#LibraryPoint#
<table border="1" cellspacing="0" cellpadding="1" bordercolor="##FFFFFF">
<tr bgcolor="##CCCCCC">
<td nowrap class="tblcopy"><strong>Hour</strong></td>
<td align="right" nowrap class="tblcopy"><strong>MON</strong></td>
<td align="right" nowrap class="tblcopy"><strong>TUE</strong></td>
<td align="right" nowrap class="tblcopy"><strong>WED</strong></td>
<td align="right" nowrap class="tblcopy"><strong>THU</strong></td>
<td align="right" nowrap class="tblcopy"><strong>FRI</strong></td>
<td align="right" nowrap class="tblcopy"><strong>SAT</strong></td>
<td align="right" nowrap class="tblcopy"><strong>SUN</strong></td>
</tr>
<cfoutput group="Hour">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#TimeFormat(CreateTime(Hour, 00, 00))#</td>
<td align="right" nowrap class="tblcopy">#MON#</td>
<td align="right" nowrap class="tblcopy">#TUE#</td>
<td align="right" nowrap class="tblcopy">#WED#</td>
<td align="right" nowrap class="tblcopy">#THU#</td>
<td align="right" nowrap class="tblcopy">#FRI#</td>
<td align="right" nowrap class="tblcopy">#SAT#</td>
<td align="right" nowrap class="tblcopy">#SUN#</td>
</tr>
</cfoutput>
</table></p>
</cfif>
</cfoutput>
</cfif>
</cfcase>

<cfcase value="2">
<cfif Monthly>
<!--- total questions, monthly --->
<p>
<cfoutput>
<span class="large">Total questions by type and service point</span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>

<cfif (Month(Start1) IS Month(End1)) AND (Year(Start1) IS Year(End1))>
#Month(Start1)#/#Year(Start1)#
<cfelse>
#Month(Start1)#/#Year(Start1)# to #Month(End1)#/#Year(End1)#
</cfif>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="6" align="center" nowrap class="tblcopy"><strong>Type of question</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td nowrap class="tblcopy"><strong>Library and service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Directional</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Inquiry</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Strategy</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Tutorial</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Res. Assist.</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Consultation</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetQuestions">
<cfif LibraryPoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td class="tblcopy">#LibraryPoint#</td>
<td align="right" nowrap class="tblcopy">#d# (#NumberFormat(Evaluate((d / GetQuestionsTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetQuestionsTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#s# (#NumberFormat(Evaluate((s / GetQuestionsTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetQuestionsTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#r# (#NumberFormat(Evaluate((r / GetQuestionsTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#c# (#NumberFormat(Evaluate((c / GetQuestionsTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetQuestions">
<cfif LibraryPoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#d#</td>
<td align="right" nowrap class="tblcopy">#i#</td>
<td align="right" nowrap class="tblcopy">#s#</td>
<td align="right" nowrap class="tblcopy">#t#</td>
<td align="right" nowrap class="tblcopy">#r#</td>
<td align="right" nowrap class="tblcopy">#c#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<!--- total questions by mode, monthly --->
<p>
<cfoutput>
<span class="large">Total questions by type and delivery mode</span>
<a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
<br>

<cfif (Month(Start1) IS Month(End1)) AND (Year(Start1) IS Year(End1))>
#Month(Start1)#/#Year(Start1)#
<cfelse>
#Month(Start1)#/#Year(Start1)# to #Month(End1)#/#Year(End1)#
</cfif>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="6" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Type of question</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Corresp.</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Online chat</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Instant Message</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetQuestionMode">
<cfif QuestionType IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#QuestionType#</td>
<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetQuestionModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetQuestionModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / GetQuestionModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#c# (#NumberFormat(Evaluate((c / GetQuestionModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#o# (#NumberFormat(Evaluate((o / GetQuestionModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#m# (#NumberFormat(Evaluate((m / GetQuestionModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">&nbsp;</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetQuestionMode">
<cfif QuestionType IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#i#</td>
<td align="right" nowrap class="tblcopy">#t#</td>
<td align="right" nowrap class="tblcopy">#e#</td>
<td align="right" nowrap class="tblcopy">#c#</td>
<td align="right" nowrap class="tblcopy">#o#</td>
<td align="right" nowrap class="tblcopy">#m#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<!--- total questions by service point and delivery mode, monthly --->
<p>
<cfoutput>
<span class="large">Total questions by service point and delivery mode</span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>

<cfif (Month(Start1) IS Month(End1)) AND (Year(Start1) IS Year(End1))>
#Month(Start1)#/#Year(Start1)#
<cfelse>
#Month(Start1)#/#Year(Start1)# to #Month(End1)#/#Year(End1)#
</cfif>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="6" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Corresp.</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Online chat</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Instant Message</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetPointMode">
<cfif ServicePoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#ServicePoint#</td>
<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetPointModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetPointModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / GetPointModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#c# (#NumberFormat(Evaluate((c / GetPointModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#o# (#NumberFormat(Evaluate((o / GetPointModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy">#m# (#NumberFormat(Evaluate((m / GetPointModeTotal) * 100), '__._')#%)</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetPointMode">
<cfif ServicePoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#i#</td>
<td align="right" nowrap class="tblcopy">#t#</td>
<td align="right" nowrap class="tblcopy">#e#</td>
<td align="right" nowrap class="tblcopy">#c#</td>
<td align="right" nowrap class="tblcopy">#o#</td>
<td align="right" nowrap class="tblcopy">#m#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>
<hr align="left" width="100%" noshade>
</cfif>

<cfif RealTime>
<!--- total questions by type and service point, realtime --->

<p>
<span class="large">Total questions by type and service point<cfif Monthly>, real-time service points only</cfif></span><br>
<cfoutput>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="<cfif UnitID is "YRL02">8<cfelse>6</cfif>" align="center" nowrap class="tblcopy"><strong>Type of question (total questions / total time)</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td nowrap class="tblcopy"><strong>Library and service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Directional</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Known Item</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Technical</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Research.</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Policy/Ops</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetQuestionsRT">
<cfif LibraryPoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td class="tblcopy">#LibraryPoint#</td>
<td align="right" nowrap class="tblcopy">#d# / #Round(d_time)#</td>
<td align="right" nowrap class="tblcopy">#i# / #Round(i_time)#</td>
<td align="right" nowrap class="tblcopy">#t# / #Round(t_time)#</td>
<td align="right" nowrap class="tblcopy">#r# / #Round(r_time)#</td>
<td align="right" nowrap class="tblcopy">#p# / #Round(p_time)#</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total# / #Round(Total_Time)#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetQuestionsRT">
<cfif LibraryPoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#d# / #Round(d_time)#</td>
<td align="right" nowrap class="tblcopy">#i# / #Round(i_time)#</td>
<td align="right" nowrap class="tblcopy">#t# / #Round(t_time)#</td>
<td align="right" nowrap class="tblcopy">#r# / #Round(r_time)#</td>
<td align="right" nowrap class="tblcopy">#p# / #Round(p_time)#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total# / #Round(Total_Time)#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<p>
<span class="large">Percentage of total questions by type and service point<cfif Monthly>, real-time service points only</cfif></span><br>
<cfoutput>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="<cfif UnitID is "YRL02">8<cfelse>6</cfif>" align="center" nowrap class="tblcopy"><strong>Type of question (total questions / total time)</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td nowrap class="tblcopy"><strong>Library and service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Directional</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Known Item</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Technical</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Research.</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Policy/Ops</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetQuestionsRT">
<cfif LibraryPoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td class="tblcopy">#LibraryPoint#</td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((d / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((d_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((i / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((i_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((t / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((t_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((r / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((r_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((p / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((p_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total# / #Total_Time#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetQuestionsRT">
<cfif LibraryPoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((d / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((d_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((i / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((i_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((t / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((t_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((r / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((r_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((p / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionsRTTimeTotal neq 0>#NumberFormat(Evaluate((p_time / GetQuestionsRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total# / #Total_Time#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<p>
<span class="large">Average question times by type and service point<cfif Monthly>, real-time service points only</cfif></span><br>
<cfoutput>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="<cfif UnitID is "YRL02">8<cfelse>6</cfif>" align="center" nowrap class="tblcopy"><strong>Type of question</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td nowrap class="tblcopy"><strong>Library and service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Directional</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Known Item</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Technical</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Research.</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Policy/Ops</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetAvgQuestionsRT">
<cfif LibraryPoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td class="tblcopy">#LibraryPoint#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(d_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(i_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(t_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(r_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(p_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#NumberFormat(Total_Time, '___.__')#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetAvgQuestionsRT">
<cfif LibraryPoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#NumberFormat(d_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(i_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(t_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(r_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(p_time, '___.__')#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#NumberFormat(Total_Time, '___.__')#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>


<hr align="left" width="100%" noshade>

<!--- total questions by type delivery mode, realtime --->
<p>
<cfoutput>
<span class="large">Total questions by type and delivery mode<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="4" align="center" nowrap class="tblcopy"><strong>Delivery mode (total questions / total time)</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Type of question</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetQuestionModeRT">
<cfif QuestionType IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#QuestionType#</td>
<td align="right" nowrap class="tblcopy">#i# / #Round(i_time)#</td>
<td align="right" nowrap class="tblcopy">#t# / #Round(t_time)#</td>
<td align="right" nowrap class="tblcopy">#e# / #Round(e_time)#</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total# / #Round(Total_Time)#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetQuestionModeRT">
<cfif QuestionType IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#i# / #Round(i_time)#</td>
<td align="right" nowrap class="tblcopy">#t# / #Round(t_time)#</td>
<td align="right" nowrap class="tblcopy">#e# / #Round(e_time)#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total# / #Round(Total_Time)#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<p>
<cfoutput>
<span class="large">Percentage of total questions by type and delivery mode<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="4" align="center" nowrap class="tblcopy"><strong>Delivery mode (total questions / total time)</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Type of question</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetQuestionModeRT">
<cfif QuestionType IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#QuestionType#</td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionModeRTTotal neq 0>#NumberFormat(Evaluate((i / GetQuestionModeRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionModeRTTimeTotal neq 0>#NumberFormat(Evaluate((i_time / GetQuestionModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionModeRTTotal neq 0>#NumberFormat(Evaluate((t / GetQuestionModeRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionModeRTTimeTotal neq 0>#NumberFormat(Evaluate((t_time / GetQuestionModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionModeRTTotal neq 0>#NumberFormat(Evaluate((e / GetQuestionModeRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetQuestionModeRTTimeTotal neq 0>#NumberFormat(Evaluate((e_time / GetQuestionModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total# / #Round(Total_Time)#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetQuestionModeRT">
<cfif QuestionType IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#i# / #i_time#</td>
<td align="right" nowrap class="tblcopy">#t# / #t_time#</td>
<td align="right" nowrap class="tblcopy">#e# / #e_time#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total# / #Total_Time#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<!--- total questions by type delivery mode, realtime --->
<p>
<cfoutput>
<span class="large">Average question times by type and delivery mode<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="4" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Type of question</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetAvgQuestionModeRT">
<cfif QuestionType IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#QuestionType#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(i_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(t_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(e_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#NumberFormat(Total_Time, '___.__')#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetAvgQuestionModeRT">
<cfif QuestionType IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#NumberFormat(i_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(t_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(e_time, '___.__')#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#NumberFormat(Total_Time, '___.__')#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<!--- total questions by service point and mode of delivery, realtime --->
<p>
<cfoutput>
<span class="large">Total questions by service point and mode of delivery<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="4" align="center" nowrap class="tblcopy"><strong>Delivery mode (total questions / total time)</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetPointModeRT">
<cfif ServicePoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#ServicePoint#</td>
<td align="right" nowrap class="tblcopy">#i# / #i_time#</td>
<td align="right" nowrap class="tblcopy">#t# / #t_time#</td>
<td align="right" nowrap class="tblcopy">#e# / #e_time#</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total# / #Total_Time#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetPointModeRT">
<cfif ServicePoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#i# / #i_time#</td>
<td align="right" nowrap class="tblcopy">#t# / #t_time#</td>
<td align="right" nowrap class="tblcopy">#e# / #e_time#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total# / #Total_Time#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<p>
<cfoutput>
<span class="large">Percentage of total questions by service point and mode of delivery<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="4" align="center" nowrap class="tblcopy"><strong>Delivery mode (total questions / total time)</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetPointModeRT">
<cfif ServicePoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#ServicePoint#</td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((i / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetPointModeRTTimeTotal neq 0>#NumberFormat(Evaluate((i_time / GetPointModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((t / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetPointModeRTTimeTotal neq 0>#NumberFormat(Evaluate((t_time / GetPointModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((e / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetPointModeRTTimeTotal neq 0>#NumberFormat(Evaluate((e_time / GetPointModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total# / #Total_Time#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetPointModeRT">
<cfif ServicePoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((i / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetPointModeRTTimeTotal neq 0>#NumberFormat(Evaluate((i_time / GetPointModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((t / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetPointModeRTTimeTotal neq 0>#NumberFormat(Evaluate((t_time / GetPointModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap class="tblcopy"><cfif GetQuestionsRTTotal neq 0>#NumberFormat(Evaluate((e / GetQuestionsRTTotal) * 100), '__._')#%<cfelse>0%</cfif> / <cfif GetPointModeRTTimeTotal neq 0>#NumberFormat(Evaluate((e_time / GetPointModeRTTimeTotal) * 100), '__._')#%<cfelse>0%</cfif></td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total# / #Total_Time#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<p>
<cfoutput>
<span class="large">Average question times by service point and mode of delivery<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
<br>
<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
<tr bgcolor="#CCCCCC">
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
<td colspan="4" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Service point</strong></td>
<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetAvgPointModeRT">
<cfif ServicePoint IS NOT "">
<tr bgcolor="##EBF0F7">
<td nowrap class="tblcopy">#ServicePoint#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(i_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(t_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(e_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#NumberFormat(Total_Time, '___.__')#</td>
</tr>
</cfif>
</cfoutput>
<cfoutput query="GetAvgPointModeRT">
<cfif ServicePoint IS "">
<tr bgcolor="##CCCCCC">
<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
<td align="right" nowrap class="tblcopy">#NumberFormat(i_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(t_time, '___.__')#</td>
<td align="right" nowrap class="tblcopy">#NumberFormat(e_time, '___.__')#</td>
<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#NumberFormat(Total_Time, '___.__')#</strong></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>

<hr align="left" width="100%" noshade>

<!--- total >10 questions by type and point --->
<cfoutput>
<p>
<span class="large">Total ">10 minutes" questions by service point and type, real-time service points only</span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</p>
</cfoutput>
<cfoutput query="Greater10ByPoint" group="ServicePoint">
<cfif ServicePoint IS NOT "">
<p>
#ServicePoint#
<cfif QuestionType IS "" AND ServicePoint IS NOT "">
<cfset PointTotal = Total>(n = #PointTotal#)<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" background="../../images/bg_graph.gif">
<tr>
<td class="small">&nbsp;</td>
<td width="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="66" align="left" class="small">0%</td>
<td width="66" align="center" class="small">50%</td>
<td width="66" align="right" class="small">100%</td>
</tr>
</table>
</td>
</tr>
<tr>
<td height="1" colspan="3" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<cfoutput group="QuestionType">
<cfif QuestionType IS NOT "">
<cfset BarWidth = #Round(Evaluate((Total/PointTotal)*200))#>
<tr valign="middle">
<td class="small">#QuestionType#&nbsp;</td>
<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/PointTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / PointTotal) * 100), '__._')#%)</td>
</tr>
</cfif>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
</cfoutput>
</table>
</p>
</cfif>
</cfoutput>
<hr align="left" width="100%" noshade>

<!--- total questions by hour of day --->
<cfoutput>
<p>
<span class="large">Total questions by hour of day<cfif Monthly>, real-time service points only</cfif></span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</p>
</cfoutput>
<cfoutput query="GetHourly" group="LibraryPoint">
<cfif LibraryPoint IS NOT "">
<p>
#LibraryPoint#
<cfif HourDay IS "" AND LibraryPoint IS NOT "">
<cfset PointTotal = Total>(n = #PointTotal#)<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" background="../../images/bg_graph.gif">
<tr>
<td class="small">&nbsp;</td>
<td width="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="66" align="left" class="small">0%</td>
<td width="66" align="center" class="small">50%</td>
<td width="66" align="right" class="small">100%</td>
</tr>
</table>
</td>
</tr>
<tr>
<td height="1" colspan="3" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<cfoutput group="HourDay">
<cfif HourDay IS NOT "">
<cfset BarWidth = #Round(Evaluate((Total/PointTotal)*200))#>
<tr valign="middle">
<td class="small">#TimeFormat(CreateTime(HourDay, 00, 00), "htt")#&nbsp;</td>
<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/PointTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / PointTotal) * 100), '__._')#%)</td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
</cfif>
</cfoutput>
</table></p>
</cfif>
</cfoutput>
<hr align="left" width="100%" noshade>

<!--- total questions by type and hour of day --->
<cfoutput>
<p>
<span class="large">Total questions by type and hour of day<cfif Monthly>, real-time service points only</cfif></span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</p>
</cfoutput>
<cfoutput query="GetHourlyType" group="LibraryPoint">
<cfif LibraryPoint IS NOT "">
<p>
#LibraryPoint#
<cfif HourDay IS "" AND LibraryPoint IS NOT "">
<cfset PointTotal = Total>(n = #PointTotal#)<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" background="../../images/bg_graph.gif">
<tr>
<td class="small">&nbsp;</td>
<td class="small">&nbsp;</td>
<td width="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="66" align="left" class="small">0%</td>
<td width="66" align="center" class="small">50%</td>
<td width="66" align="right" class="small">100%</td>
</tr>
</table>
</td>
</tr>
<tr>
<td height="1" colspan="4" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<cfoutput group="HourDay">
<cfif HourDay IS NOT "">
<cfset BarWidth = #Round(Evaluate((Total/PointTotal)*200))#>
<tr valign="middle">
<td class="small">#QuestionType#&nbsp;</td>
<td class="small">#TimeFormat(CreateTime(HourDay, 00, 00), "htt")#&nbsp;</td>
<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/PointTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / PointTotal) * 100), '__._')#%)</td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
</cfif>
</cfoutput>
</table>
</p>
</cfif>
</cfoutput>
<hr align="left" width="100%" noshade>

<!--- total questions by day of week --->
<p>
<cfoutput>
<span class="large">Total questions by day of week<cfif Monthly>, real-time service points only</cfif></span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
</p>
<cfoutput query="GetDaily" group="LibraryPoint">
<cfif LibraryPoint IS NOT "">
<p>
#LibraryPoint#
<cfif DayWeek IS "" AND LibraryPoint IS NOT "">
<cfset PointTotal = Total>(n = #PointTotal#)<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" background="../../images/bg_graph.gif">
<tr>
<td class="small">&nbsp;</td>
<td width="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="66" align="left" class="small">0%</td>
<td width="66" align="center" class="small">50%</td>
<td width="66" align="right" class="small">100%</td>
</tr>
</table>
</td>
</tr>
<tr>
<td height="1" colspan="3" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<cfoutput group="DayWeek">
<cfif DayWeek IS NOT "">
<cfset BarWidth = #Round(Evaluate((Total/PointTotal)*200))#>
<tr valign="middle">
<td class="small">#UCase(RemoveChars(DayOfWeekAsString(DayWeek), 4, Evaluate(Len(DayOfWeekAsString(DayWeek))-3)))#&nbsp;</td>
<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/PointTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / PointTotal) * 100), '__._')#%)</td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
</cfif>
</cfoutput>
</table></p>

</cfif>
</cfoutput>

<hr align="left" width="100%" noshade>

<!--- total questions by day of week --->
<p>
<cfoutput>
<span class="large">Total questions by type and day of week<cfif Monthly>, real-time service points only</cfif></span><br>
#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2&UnitID=#UnitID#&Level=#Level#')" class="red">*</a>
</cfoutput>
</p>
<cfoutput query="GetDailyType" group="LibraryPoint">
<cfif LibraryPoint IS NOT "">
<p>
#LibraryPoint#
<cfif DayWeek IS "" AND LibraryPoint IS NOT "">
<cfset PointTotal = Total>(n = #PointTotal#)<br>
</cfif>
<table border="0" cellspacing="0" cellpadding="0" background="../../images/bg_graph.gif">
<tr>
<td class="small">&nbsp;</td>
<td class="small">&nbsp;</td>
<td width="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="66" align="left" class="small">0%</td>
<td width="66" align="center" class="small">50%</td>
<td width="66" align="right" class="small">100%</td>
</tr>
</table>
</td>
</tr>
<tr>
<td height="1" colspan="4" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
<cfoutput group="DayWeek">
<cfif DayWeek IS NOT "">
<cfset BarWidth = #Round(Evaluate((Total/PointTotal)*200))#>
<tr valign="middle">
<td class="small">#QuestionType#&nbsp;</td>
<td class="small">#UCase(RemoveChars(DayOfWeekAsString(DayWeek), 4, Evaluate(Len(DayOfWeekAsString(DayWeek))-3)))#&nbsp;</td>
<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/PointTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / PointTotal) * 100), '__._')#%)</td>
</tr>
<tr>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
</tr>
</cfif>
</cfoutput>
</table></p>

</cfif>
</cfoutput>

<hr align="left" width="100%" noshade>
</cfif>

</cfcase>
</cfswitch>
</cfif>









<cfif Text IS 0>
<cfinclude template="../../../library_pageincludes/footer.cfm">
<CFINCLUDE TEMPLATE="../../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS 1>
<cfinclude template="../../../library_pageincludes/footer_nonav_txt.cfm">
</cfif>

