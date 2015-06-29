<cfif Find("reports/generator.cfm", HTTP_REFERER) IS 0>
	<cflocation url="../index.cfm" addtoken=0>
	<cfabort>
</cfif>
<!---cfcontent type="application/vnd.ms-excel"--->
<cfparam name="text" default = 0>
<cfparam name="PrintFormat" default = 0>
<cfparam name="Level" default = "#FORM.Level#">
<cfparam name="Step" default = "#FORM.Step#">
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

<!--- call to list of report titles switch statement --->
<cfinclude template="objects/tmpReportTitles.cfm">

<cfif NOT InvalidDateRange>

	<cfquery name="GetDataCollectionMethod" datasource="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
		<cfoutput>
			SELECT DISTINCT InputMethod
			FROM ReferenceStatistics
			WHERE
			(
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
		</cfoutput>
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
					<cfquery name="GetTransactions"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								CASE
									WHEN SUBSTRING(AggregateID, 1, 3) = 'ART' THEN 'Arts'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'CLK' THEN 'Clark'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'COL' THEN 'Powell'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'LAW' THEN 'Law'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'MAN' THEN 'Management'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'MUS' THEN 'Music'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'SEL' THEN 'SEL'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'YRL' THEN 'YRL'
									ELSE NULL
								END AS 'Library',
								SUM([Count]) AS Total
							FROM
								ReferenceStatistics RS
							WHERE
								SUBSTRING(AggregateID, 8, 2) = '00'
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
							GROUP BY
								CASE
									WHEN SUBSTRING(AggregateID, 1, 3) = 'ART' THEN 'Arts'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'CLK' THEN 'Clark'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'COL' THEN 'Powell'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'LAW' THEN 'Law'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'MAN' THEN 'Management'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'MUS' THEN 'Music'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'SEL' THEN 'SEL'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
									WHEN SUBSTRING(AggregateID, 1, 3) = 'YRL' THEN 'YRL'
									ELSE NULL
								END
							WITH ROLLUP
							ORDER BY Library
						</cfoutput>
					</cfquery>

					<cfloop query="GetTransactions">
						<cfif GetTransactions.Library IS "">
							<cfset GetTransactionsTotal = GetTransactions.Total>
							<cfbreak>
						</cfif>
					</cfloop>

					<cfquery name="GetTransactionPoint"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT SUM([Count]) AS Total,
								CASE WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
								WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk' ELSE RSP.Descrpt
								END AS ServicePoint
							FROM ReferenceStatistics RS
								JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
							WHERE SUBSTRING(AggregateID, 8, 2) = '00'
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
							GROUP BY
								CASE WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
								WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk' ELSE RSP.Descrpt
								END
							WITH ROLLUP
							ORDER BY ServicePoint
						</cfoutput>
					</cfquery>

					<cfloop query="GetTransactionPoint">
						<cfif GetTransactionPoint.ServicePoint IS "">
							<cfset GetTransactionPointTotal = GetTransactionPoint.Total>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>

				<cfif RealTime>
					<cfquery name="GetTransactionsRT"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT CASE
								WHEN SUBSTRING(AggregateID, 1, 3) = 'ART' THEN 'Arts'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'CLK' THEN 'Clark'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'COL' THEN 'Powell'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'LAW' THEN 'Law'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'MAN' THEN 'Management'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'MUS' THEN 'Music'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'SEL' THEN 'SEL'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'YRL' THEN 'YRL'
								ELSE NULL
								END AS 'Library',
								SUM([Count]) AS Total
							FROM ReferenceStatistics RS
								JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
							WHERE SUBSTRING(AggregateID, 8, 2) = '00'
								AND InputMethod = 2
								AND (
								CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
								CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
								CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY CASE
								WHEN SUBSTRING(AggregateID, 1, 3) = 'ART' THEN 'Arts'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'CLK' THEN 'Clark'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'COL' THEN 'Powell'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'LAW' THEN 'Law'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'MAN' THEN 'Management'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'MUS' THEN 'Music'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'SEL' THEN 'SEL'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
								WHEN SUBSTRING(AggregateID, 1, 3) = 'YRL' THEN 'YRL'
								END
							WITH ROLLUP
							ORDER BY Library
						</cfoutput>
					</cfquery>

					<cfloop query="GetTransactionsRT">
						<cfif GetTransactionsRT.Library IS "">
							<cfset GetTransactionsRTTotal = GetTransactionsRT.Total>
						</cfif>
					</cfloop>

					<cfquery name="GetTransactionPointRT"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT SUM([Count]) AS Total,
								CASE WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
								WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk' ELSE RSP.Descrpt
								END AS ServicePoint
							FROM ReferenceStatistics RS
								JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
							WHERE SUBSTRING(AggregateID, 8, 2) = '00'
								AND InputMethod = 2
								AND   (
								CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME)
								BETWEEN '#Start1#' AND '#End1#'
								AND InputMethod = 2
								)
							GROUP BY CASE WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
								WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk' ELSE RSP.Descrpt
								END
							WITH ROLLUP
							ORDER BY ServicePoint
						</cfoutput>
					</cfquery>

					<cfloop query="GetTransactionPointRT">
						<cfif GetTransactionPointRT.ServicePoint IS "">
							<cfset GetTransactionPointTotal = GetTransactionPointRT.Total>
							<cfbreak>
						</cfif>
					</cfloop>

					<!--- hourly transactions query --->
					<cfquery name="GetHourly"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT DATEPART(Hour, Created_DT) AS HourDay,
								SUM([Count]) AS Total
							FROM ReferenceStatistics RS
							WHERE SUBSTRING(AggregateID, 8, 2) = '00'
								AND InputMethod = 2
								AND (
								CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
								CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
								CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY DATEPART(Hour, Created_DT)
							WITH ROLLUP
							ORDER BY HourDay
						</cfoutput>
					</cfquery>

					<cfquery name="GetDaily"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT DATEPART(WeekDay, Created_DT) AS DayWeek,
								SUM([Count]) AS Total
							FROM ReferenceStatistics RS
								JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
							WHERE SUBSTRING(AggregateID, 8, 2) = '00'
								AND InputMethod = 2
								AND (
								CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
								CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
								CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY DATEPART(WeekDay, Created_DT)
							WITH ROLLUP
							ORDER BY DayWeek
						</cfoutput>
					</cfquery>

				</cfif>
			</cfcase>
			<!--- end if report type is 1 --->

			<!--- begin if report type is 2 --->
			<cfcase value="2">
				<cfif Monthly>
					<cfquery name="GetQuestions"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								CASE
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'ART' THEN 'Arts'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'CLK' THEN 'Clark'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'COL' THEN 'Powell'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'LAW' THEN 'Law'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MAN' THEN 'Management'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MUS' THEN 'Music'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SEL' THEN 'SEL'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'YRL' THEN 'YRL'
									ELSE NULL
								END AS 'Library',
								"d" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END),
								"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END),
								"p" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN [Count] ELSE 0 END),
								"r" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END),
								"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN [Count] ELSE 0 END),
								"Total" =
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN [Count] ELSE 0 END)
							FROM
								ReferenceStatistics RS
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND
								(
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
							GROUP BY
								CASE
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'ART' THEN 'Arts'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'CLK' THEN 'Clark'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'COL' THEN 'Powell'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'LAW' THEN 'Law'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MAN' THEN 'Management'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MUS' THEN 'Music'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SEL' THEN 'SEL'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'YRL' THEN 'YRL'
								END
							WITH ROLLUP
							ORDER BY
								Library
						</cfoutput>
					</cfquery>

					<cfloop query="GetQuestions">
						<cfif GetQuestions.Library IS "">
							<cfset GetQuestionsTotal = GetQuestions.Total>
						</cfif>
					</cfloop>

					<cfquery name="GetQuestionMode"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								RT.Descrpt AS QuestionType,
								"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
								"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
								"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
								"Total" =
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END)
							FROM
								ReferenceStatistics RS
								JOIN RefMode RM ON RM.MOdeID = SUBSTRING(RS.AggregateID, 10, 2)
								JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND
								(
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
							GROUP BY
								RT.Descrpt
							WITH ROLLUP
							ORDER BY
								QuestionType
						</cfoutput>
					</cfquery>

					<cfloop query="GetQuestionMode">
						<cfif GetQuestionMode.QuestionType IS "">
							<cfset GetQuestionModeTotal = GetQuestionMode.Total>
						</cfif>
					</cfloop>

					<cfquery name="GetPointMode"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								CASE
									WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
									WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk'
									ELSE RSP.Descrpt
								END AS ServicePoint,
								"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
								"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
								"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
								"Total" =
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END)
							FROM
								ReferenceStatistics RS
								JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
								JOIN RefMode RM ON RM.ModeID = SUBSTRING(RS.AggregateID, 10, 2)
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND
								(
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
							GROUP BY
								CASE
									WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
									WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk'
									ELSE RSP.Descrpt
								END
							WITH ROLLUP
							ORDER BY
								ServicePoint
						</cfoutput>
					</cfquery>

					<cfloop query="GetPointMode">
						<cfif GetPointMode.ServicePoint IS "">
							<cfset GetPointModeTotal = GetPointMode.Total>
						</cfif>
					</cfloop>
				</cfif>
				<cfif RealTime>
					<cfquery name="GetQuestionsRT"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								CASE
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'ART' THEN 'Arts'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'CLK' THEN 'Clark'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'COL' THEN 'Powell'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'LAW' THEN 'Law'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MAN' THEN 'Management'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MUS' THEN 'Music'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SEL' THEN 'SEL'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'YRL' THEN 'YRL'
									ELSE NULL
								END AS 'Library',
								"d" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END),
								"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END),
								"p" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN [Count] ELSE 0 END),
								"r" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END),
								"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN [Count] ELSE 0 END),
								"Total" =
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '12' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '10' THEN [Count] ELSE 0 END)
							FROM
								ReferenceStatistics RS
								JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
								JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND InputMethod = 2
								AND
								(
									(
										CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' + CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME)
										BETWEEN '#Start1#' AND '#End1#'
									)
								)
							GROUP BY
								CASE
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'ART' THEN 'Arts'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'BIO' THEN 'Biomed'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'CLK' THEN 'Clark'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'COL' THEN 'Powell'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'EAL' THEN 'East Asian'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'LAW' THEN 'Law'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MAN' THEN 'Management'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'MUS' THEN 'Music'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SEL' THEN 'SEL'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'SRL' THEN 'SRLF'
									WHEN SUBSTRING(RS.AggregateID, 1, 3) = 'YRL' THEN 'YRL'
								END
							WITH ROLLUP
							ORDER BY
								Library
						</cfoutput>
					</cfquery>

					<cfloop query="GetQuestionsRT">
						<cfif GetQuestionsRT.Library IS "">
							<cfset GetQuestionsRTTotal = GetQuestionsRT.Total>
						</cfif>
					</cfloop>

					<cfquery name="GetQuestionModeRT"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								RT.Descrpt AS QuestionType,
								"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
								"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
								"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
								"Total" =
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END)
							FROM
								ReferenceStatistics RS
								JOIN RefMode RM ON RM.MOdeID = SUBSTRING(RS.AggregateID, 10, 2)
								JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
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
						</cfif>
					</cfloop>

					<cfquery name="GetPointModeRT"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								CASE
									WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
									WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk'
									ELSE RSP.Descrpt
								END AS ServicePoint,
								"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END),
								"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END),
								"e" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END),
								"Total" =
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '01' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '02' THEN [Count] ELSE 0 END) +
									SUM(CASE WHEN SUBSTRING(RS.AggregateID, 10, 2) = '03' THEN [Count] ELSE 0 END)
							FROM
								ReferenceStatistics RS
								JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
								JOIN RefMode RM ON RM.ModeID = SUBSTRING(RS.AggregateID, 10, 2)
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND InputMethod = 2
								AND
								(
									CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY
								CASE
									WHEN RSP.Descrpt LIKE 'Circulation%' THEN 'Circulation desk'
									WHEN RSP.Descrpt LIKE '%Information%' THEN 'Information desk'
									ELSE RSP.Descrpt
								END
							WITH ROLLUP
							ORDER BY
								ServicePoint
						</cfoutput>
					</cfquery>

					<cfloop query="GetPointModeRT">
						<cfif GetPointModeRT.ServicePoint IS "">
							<cfset GetPointModeRTTotal = GetPointModeRT.Total>
						</cfif>
					</cfloop>

					<cfquery name="GetHourly"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								DATEPART(Hour, Created_DT) AS HourDay,
								SUM([Count]) AS Total
							FROM
								ReferenceStatistics RS
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND InputMethod = 2
								AND
								(
									CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY
								DATEPART(Hour, Created_DT)
							WITH ROLLUP
							ORDER BY
								HourDay
						</cfoutput>
					</cfquery>

					<cfquery name="GetDaily"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								DATEPART(WeekDay, Created_DT) AS DayWeek,
								SUM([Count]) AS Total
							FROM
								ReferenceStatistics RS
							WHERE
								SUBSTRING(AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND InputMethod = 2
								AND
								(
									CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY
								DATEPART(WeekDay, Created_DT)
							WITH ROLLUP
							ORDER BY
								DayWeek
						</cfoutput>
					</cfquery>


					<cfquery name="GetHourlyType"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								RT.Descrpt AS QuestionType,
								DATEPART(Hour, RS.Created_DT) AS HourDay,
								SUM(RS.[Count]) AS Total
							FROM
								ReferenceStatistics RS
								JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
							WHERE
								SUBSTRING(RS.AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND RS.InputMethod = 2
								AND
								(
									CAST(CAST(DATEPART(Month, RS.Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Day, RS.Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Year, RS.Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY
								RT.Descrpt,
								DATEPART(Hour, Created_DT)
							WITH ROLLUP
							ORDER BY
								QuestionType,
								HourDay
						</cfoutput>
					</cfquery>

					<cfquery name="GetDailyType"  DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
						<cfoutput>
							SELECT
								RT.Descrpt AS QuestionType,
								DATEPART(WeekDay, RS.Created_DT) AS DayWeek,
								SUM(RS.[Count]) AS Total
							FROM
								ReferenceStatistics RS
								JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
							WHERE
								SUBSTRING(RS.AggregateID, 8, 2) NOT IN  ('00','07','08','09')
								AND RS.InputMethod = 2
								AND
								(
									CAST(CAST(DATEPART(Month, RS.Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Day, RS.Created_DT) AS VARCHAR) + '/' +
									CAST(DATEPART(Year, RS.Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
								)
							GROUP BY
								RT.Descrpt,
								DATEPART(WeekDay, RS.Created_DT)
							WITH ROLLUP
							ORDER BY
								QuestionType,
								DayWeek
						</cfoutput>
					</cfquery>

				</cfif>
			</cfcase>
			<!--- end if report type is 2 --->
		</cfswitch>
	</cfif>
</cfif>

<html>
	<head>
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
			<title>
				UCLA Libary-Wide Reference Statistics: #ReportTitle#
			</title>
		</cfoutput>
		<cfif Text IS 0>
			<cfinclude template="../../../library_pageincludes/banner_nonav.cfm">
		</cfif>
		<cfif Text IS 1>
			<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
		</cfif>
		<!--begin you are here-->
		<cfoutput>
			<a href="../../index.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Reference</a> &gt; <a href="generator.cfm?Level=Library">Library-Wide Report</a> &gt; #ReportTitle#
		</cfoutput>
		<!-- end you are here -->
		<cfif Text IS 0>
			<cfinclude template="../../../library_pageincludes/start_content_nonav.cfm">
		</cfif>
		<cfif Text IS 1>
			<cfinclude template="../../../library_pageincludes/start_content_txt.cfm">
		</cfif>
		<!--begin main content-->
		<cfoutput>
			<form action="generator.cfm?Level=Library" method="post" class="form">
				<input type="hidden" name="Level" value="#Level#">
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
					<a href="JavaScript:PopUp('facts.cfm?ReportType=2')">See data availability by unit/service points</a>
				</cfoutput>
			</p>
		<cfelse>
			<cfoutput>
				<h2>Library-wide reference statistics report: #ReportTitle#<br></h2>
			</cfoutput>
			<hr align="left" width="100%" noshade>
			<cfswitch expression="#ReportType#">
				<cfcase value="1">
					<cfif Monthly>
						<!--- total transactions monthly --->
						<p>
							<cfoutput>
								<span class="large">Total transactions by unit</span>
								<a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a><br>
								<cfif (Month(Start1) IS Month(End1)) AND (Year(Start1) IS Year(End1))>
									#Month(Start1)#/#Year(Start1)#
								<cfelse>
									#Month(Start1)#/#Year(Start1)# to #Month(End1)#/#Year(End1)#
								</cfif>
							</cfoutput>
							<br>
							<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
								<tr bgcolor="#CCCCCC">
									<td nowrap class="tblcopy"><strong>Unit</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total transactions</strong></td>
								</tr>
								<cfoutput query="GetTransactions">
									<cfif Library IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td nowrap class="tblcopy">#Library#</td>
											<td align="right" nowrap class="tblcopy">#Total# (#NumberFormat(Evaluate((Total / GetTransactionsTotal) * 100), '__._')#%)</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetTransactions">
									<cfif Library IS "">
										<tr bgcolor="##CCCCCC">
											<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
											<td align="right" nowrap class="tblcopy">#Total#</td>
										</tr>
									</cfif>
								</cfoutput>
							</table>
						</p>
						<hr align="left" width="100%" noshade>
						<!--- total transactions by service point, monthly --->
						<p>
							<cfoutput>
								<span class="large">Total transactions by service point</span>
								<a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a><br>
								<cfif (Month(Start1) IS Month(End1)) AND (Year(Start1) IS Year(End1))>
									#Month(Start1)#/#Year(Start1)#
								<cfelse>
									#Month(Start1)#/#Year(Start1)# to #Month(End1)#/#Year(End1)#
								</cfif>
							</cfoutput>
							<br>
							<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
								<tr bgcolor="#CCCCCC">
									<td nowrap class="tblcopy"><strong>Service point</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total transactions</strong></td>
								</tr>
								<cfoutput query="GetTransactionPoint">
									<cfif ServicePoint IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td nowrap class="tblcopy">#ServicePoint#</td>
											<td align="right" nowrap class="tblcopy">#Total# (#NumberFormat(Evaluate((Total / GetTransactionPointTotal) * 100), '__._')#%)</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetTransactionPoint">
									<cfif ServicePoint IS "">
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
						<hr align="left" width="100%" noshade>
						<p>
							<span class="large">Total transactions<cfif Monthly>, units with real-time service points only</cfif></span><br>
							<cfoutput>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
							</cfoutput>
							<br>
							<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
								<tr bgcolor="#CCCCCC">
									<td nowrap class="tblcopy"><strong>Unit</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total transactions</strong></td>
								</tr>
								<cfoutput query="GetTransactionsRT">
									<cfif Library IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td nowrap class="tblcopy">#Library#</td>
											<td align="right" nowrap class="tblcopy">#Total# (#NumberFormat(Evaluate((Total / GetTransactionsRTTotal) * 100), '__._')#%)</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetTransactionsRT">
									<cfif Library IS "">
										<tr bgcolor="##CCCCCC">
											<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
											<td align="right" nowrap class="tblcopy">#Total#</td>
										</tr>
									</cfif>
								</cfoutput>
							</table>
						</p>
						<hr align="left" width="100%" noshade>
						<!--- total transactions by service point, real-time --->
						<p>
							<cfoutput>
								<span class="large">Total transactions by service point<cfif Monthly>, units with real-time service points only</cfif>
									<cfloop query="GetTransactionPointRT">
										<cfif ServicePoint IS "">
											<cfset TransactionPointRTTotal = Total>(n = #TransactionPointRTTotal#)<br>
											<cfbreak>
										</cfif>
									</cfloop>
								</span>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
							</cfoutput>
							<br>
							<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
								<tr bgcolor="#CCCCCC">
									<td nowrap class="tblcopy"><strong>Service point</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total transactions</strong></td>
								</tr>
								<cfoutput query="GetTransactionPointRT">
									<cfif ServicePoint IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td nowrap class="tblcopy">#ServicePoint#</td>
											<td align="right" nowrap class="tblcopy">#Total# (#NumberFormat(Evaluate((Total / TransactionPointRTTotal) * 100), '__._')#%)</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetTransactionPointRT">
									<cfif ServicePoint IS "">
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
								<span class="large">Total transactions by day of week<cfif Monthly>, units with real-time service points only</cfif>
									<cfloop query="GetDaily">
										<cfif DayWeek IS "">
											<cfset DailyTotal = Total>(n = #DailyTotal#)<br>
											<cfbreak>
										</cfif>
									</cfloop>
								</span>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
							</cfoutput>
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
								<cfoutput query="GetDaily">
									<cfif DayWeek IS NOT "">
										<cfset BarWidth = #Round(Evaluate((Total/DailyTotal)*200))#>
										<tr valign="middle">
											<td class="small">#UCase(RemoveChars(DayOfWeekAsString(DayWeek), 4, Evaluate(Len(DayOfWeekAsString(DayWeek))-3)))#&nbsp;</td>
											<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
											<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/DailyTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / DailyTotal) * 100), '__._')#%)</td>
										</tr>
										<tr>
											<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
											<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
											<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
										</tr>
									</cfif>
								</cfoutput>
							</table>
						</p>
						<hr align="left" width="100%" noshade>
						<!--- total transactions by hour of day --->
						<cfoutput>
							<p>
								<span class="large">Total transactions by hour of day<cfif Monthly>, units with real-time service points only</cfif>
									<cfloop query="GetHourly">
										<cfif HourDay IS "">
											<cfset HourlyTotal = Total>(n = #HourlyTotal#)
											<cfbreak>
										</cfif>
									</cfloop>
								</span><br>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
							</p>
						</cfoutput>
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
							<cfoutput query="GetHourly">
								<cfif HourDay IS NOT "">
									<cfset BarWidth = #Round(Evaluate((Total/HourlyTotal)*200))#>
									<tr valign="middle">
										<td class="small">#TimeFormat(CreateTime(HourDay, 00, 00), "htt")#&nbsp;</td>
										<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/HourlyTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total/HourlyTotal) * 100), '__._')#%)</td>
									</tr>
									<tr>
										<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
									</tr>
								</cfif>
							</cfoutput>
						</table><!--/p-->
					</cfif>
				</cfcase>
				<cfcase value="2">
					<cfif Monthly>
						<!--- total questions, monthly --->
						<p>
							<cfoutput>
								<span class="large">Total questions by type and unit</span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a><br>
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
									<td colspan="4" align="center" nowrap class="tblcopy"><strong>Type of question</strong></td>
									<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
								</tr>
								<tr bgcolor="#CCCCCC">
									<td nowrap class="tblcopy"><strong>Unit</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Directional</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Inquiry</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Policy/Ops</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Res. Assist.</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Tech. Assist</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
								</tr>
								<cfoutput query="GetQuestions">
									<cfif Library IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td class="tblcopy">#Library#</td>
											<td align="right" nowrap class="tblcopy">#d# (#NumberFormat(Evaluate((d / GetQuestionsTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetQuestionsTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#p# (#NumberFormat(Evaluate((p / GetQuestionsTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#r# (#NumberFormat(Evaluate((r / GetQuestionsTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetQuestionsTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetQuestions">
									<cfif Library IS "">
										<tr bgcolor="##CCCCCC">
											<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
											<td align="right" nowrap class="tblcopy">#d#</td>
											<td align="right" nowrap class="tblcopy">#i#</td>
											<td align="right" nowrap class="tblcopy">#p#</td>
											<td align="right" nowrap class="tblcopy">#r#</td>
											<td align="right" nowrap class="tblcopy">#t#</td>
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
								<span class="large">Total questions by type and delivery mode</span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a><br>
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
									<td colspan="3" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
									<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
								</tr>
								<tr bgcolor="#CCCCCC">
									<td align="right" nowrap class="tblcopy"><strong>Type of question</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
								</tr>
								<cfoutput query="GetQuestionMode">
									<cfif QuestionType IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td nowrap class="tblcopy">#QuestionType#</td>
											<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetQuestionModeTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetQuestionModeTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / GetQuestionModeTotal) * 100), '__._')#%)</td>
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
								<span class="large">Total questions by service point and delivery mode</span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a><br>
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
									<td colspan="3" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
									<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
								</tr>
								<tr bgcolor="#CCCCCC">
									<td align="right" nowrap class="tblcopy"><strong>Service point</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>In-person</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Telephone</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Email</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
								</tr>
								<cfoutput query="GetPointMode">
									<cfif ServicePoint IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td nowrap class="tblcopy">#ServicePoint#</td>
											<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetPointModeTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetPointModeTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / GetPointModeTotal) * 100), '__._')#%)</td>
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
											<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total#</strong></td>
										</tr>
									</cfif>
								</cfoutput>
							</table>
						</p>
					</cfif>
					<cfif RealTime>
						<hr align="left" width="100%" noshade>
						<!--- total questions by type and service point, realtime --->
						<p>
							<span class="large">Total questions by type and unit<cfif Monthly>, real-time service points only</cfif></span><br>
							<cfoutput>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
							</cfoutput>
							<br>
							<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
								<tr bgcolor="#CCCCCC">
									<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
									<td colspan="6" align="center" nowrap class="tblcopy"><strong>Type of question</strong></td>
									<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
								</tr>
								<tr bgcolor="#CCCCCC">
									<td nowrap class="tblcopy"><strong>Unit</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Directional</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Inquiry</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Policy</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Res. Assist.</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Tech. Assist.</strong></td>
									<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
								</tr>
								<cfoutput query="GetQuestionsRT">
									<cfif Library IS NOT "">
										<tr bgcolor="##EBF0F7">
											<td class="tblcopy">#Library#</td>
											<td align="right" nowrap class="tblcopy">#d# (#NumberFormat(Evaluate((d / GetQuestionsRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetQuestionsRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#p# (#NumberFormat(Evaluate((p / GetQuestionsRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#r# (#NumberFormat(Evaluate((r / GetQuestionsRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetQuestionsRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetQuestionsRT">
									<cfif Library IS "">
										<tr bgcolor="##CCCCCC">
											<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
											<td align="right" nowrap class="tblcopy">#d#</td>
											<td align="right" nowrap class="tblcopy">#i#</td>
											<td align="right" nowrap class="tblcopy">#p#</td>
											<td align="right" nowrap class="tblcopy">#r#</td>
											<td align="right" nowrap class="tblcopy">#t#</td>
											<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total#</strong></td>
										</tr>
									</cfif>
								</cfoutput>
							</table>
						</p>
						<hr align="left" width="100%" noshade>
						<!--- total questions by type delivery mode, realtime --->
						<p>
							<cfoutput>
								<span class="large">Total questions by type and delivery mode<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a><br>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
							</cfoutput>
							<br>
							<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
								<tr bgcolor="#CCCCCC">
									<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
									<td colspan="3" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
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
											<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetQuestionModeRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetQuestionModeRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / GetQuestionModeRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetQuestionModeRT">
									<cfif QuestionType IS "">
										<tr bgcolor="##CCCCCC">
											<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
											<td align="right" nowrap class="tblcopy">#i#</td>
											<td align="right" nowrap class="tblcopy">#t#</td>
											<td align="right" nowrap class="tblcopy">#e#</td>
											<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total#</strong></td>
										</tr>
									</cfif>
								</cfoutput>
							</table>
						</p>
						<hr align="left" width="100%" noshade>
						<!--- total questions by service point and mode of delivery, realtime --->
						<p>
							<cfoutput>
								<span class="large">Total questions by service point and mode of delivery<cfif Monthly>, real-time service points only</cfif></span> <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a><br>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
							</cfoutput>
							<br>
							<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
								<tr bgcolor="#CCCCCC">
									<td nowrap bgcolor="#FFFFFF" class="tblcopy">&nbsp;</td>
									<td colspan="3" align="center" nowrap class="tblcopy"><strong>Delivery mode</strong></td>
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
											<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / GetPointModeRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / GetPointModeRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / GetPointModeRTTotal) * 100), '__._')#%)</td>
											<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
										</tr>
									</cfif>
								</cfoutput>
								<cfoutput query="GetPointModeRT">
									<cfif ServicePoint IS "">
										<tr bgcolor="##CCCCCC">
											<td align="right" nowrap class="tblcopy"><strong>Total</strong></td>
											<td align="right" nowrap class="tblcopy">#i#</td>
											<td align="right" nowrap class="tblcopy">#t#</td>
											<td align="right" nowrap class="tblcopy">#e#</td>
											<td align="right" nowrap bgcolor="##FFCCCC" class="tblcopy"><strong>#Total#</strong></td>
										</tr>
									</cfif>
								</cfoutput>
							</table>
						</p>
						<hr align="left" width="100%" noshade>

						<!--- total questions by hour of day --->
						<cfoutput>
							<p>
								<span class="large">Total questions by hour of day<cfif Monthly>, units with real-time service points only</cfif>
									<cfloop query="GetHourly">
										<cfif HourDay IS "">
											<cfset HourlyTotal = Total>(n = #HourlyTotal#)
											<cfbreak>
										</cfif>
									</cfloop>
								</span><br>
								#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
						</cfoutput>
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
							<cfoutput query="GetHourly">
								<cfif HourDay IS NOT "">
									<cfset BarWidth = #Round(Evaluate((Total/HourlyTotal)*200))#>
									<tr valign="middle">
										<td class="small">#TimeFormat(CreateTime(HourDay, 00, 00), "htt")#&nbsp;</td>
										<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/HourlyTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total/HourlyTotal) * 100), '__._')#%)</td>
									</tr>
									<tr>
										<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
									</tr>
								</cfif>
							</cfoutput>
						</table>
					</p>
					<hr align="left" width="100%" noshade>
					<!--- total questions by type and hour of day --->
					<cfoutput>
					<p>
					<span class="large">Total questions by type and hour of day<cfif Monthly>, units with real-time service points only</cfif>
					<cfloop query="GetHourlyType">
					<cfif HourDay IS "">
					<cfset HourlyTotal = Total>(n = #HourlyTotal#)
					<cfbreak>
					</cfif>
					</cfloop>
					</span><br>
					#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
					</cfoutput>
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
					<cfoutput query="GetHourlyType">
					<cfif HourDay IS NOT "">
					<cfset BarWidth = #Round(Evaluate((Total/HourlyTotal)*200))#>
					<tr valign="middle">
					<td class="small">#QuestionType#&nbsp;</td>
					<td class="small">#TimeFormat(CreateTime(HourDay, 00, 00), "htt")#&nbsp;</td>
					<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
					<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/HourlyTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total/HourlyTotal) * 100), '__._')#%)</td>
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
					<hr align="left" width="100%" noshade>
					<!--- total questions by day of week --->
					<p>
						<cfoutput>
							<span class="large">Total questions by day of week<cfif Monthly>, units with real-time service points only</cfif>
								<cfloop query="GetDaily">
									<cfif DayWeek IS "">
										<cfset DailyTotal = Total>(n = #DailyTotal#)<br>
									<cfbreak>
									</cfif>
								</cfloop>
							</span>
							#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
						</cfoutput>
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
							<cfoutput query="GetDaily">
								<cfif DayWeek IS NOT "">
									<cfset BarWidth = #Round(Evaluate((Total/DailyTotal)*200))#>
									<tr valign="middle">
										<td class="small">#UCase(RemoveChars(DayOfWeekAsString(DayWeek), 4, Evaluate(Len(DayOfWeekAsString(DayWeek))-3)))#&nbsp;</td>
										<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/DailyTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / DailyTotal) * 100), '__._')#%)</td>
									</tr>
									<tr>
										<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
									</tr>
								</cfif>
							</cfoutput>
						</table>
					</p>
					<hr align="left" width="100%" noshade>
					<!--- total questions by type and day of week --->
					<p>
					<cfoutput>
					<span class="large">Total questions by type and day of week<cfif Monthly>, units with real-time service points only</cfif>
					<cfloop query="GetDailyType">
					<cfif DayWeek IS "">
					<cfset DailyTotal = Total>(n = #DailyTotal#)<br>
					<cfbreak>
					</cfif>
					</cfloop>
					</span>
					#Start1# to #End1# <a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a>
					</cfoutput>
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
					<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
					<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
					</tr>
					<cfoutput query="GetDailyType">
					<cfif DayWeek IS NOT "">
					<cfset BarWidth = #Round(Evaluate((Total/DailyTotal)*200))#>
					<tr valign="middle">
					<td class="small">#QuestionType#&nbsp;</td>
					<td class="small">#UCase(RemoveChars(DayOfWeekAsString(DayWeek), 4, Evaluate(Len(DayOfWeekAsString(DayWeek))-3)))#&nbsp;</td>
					<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
					<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total/DailyTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / DailyTotal) * 100), '__._')#%)</td>
					</tr>
					<tr>
					<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
					<td height="1" bgcolor="black"><img src="../../images/1x1.gif" height="1" border="0"></td>
					<td height="1"><img src="../../images/1x1.gif" height="1" border="0"></td>
					</tr>
					</cfif>
					</cfoutput>
					</table>
					</p>
					<hr align="left" width="100%" noshade>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
	<cfif Text IS 0>
		<cfinclude template="../../../library_pageincludes/footer.cfm">
		<cfinclude template="../../../library_pageincludes/end_content.cfm">
	</cfif>
	<cfif Text IS 1>
		<cfinclude template="../../../library_pageincludes/footer_nonav_txt.cfm">
	</cfif>
