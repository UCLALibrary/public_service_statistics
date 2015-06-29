<cfif Find("reports/generator.cfm", HTTP_REFERER) IS 0>
	<cflocation url="../index.cfm" addtoken=0>
	<cfabort>
</cfif>
<cfparam name="text" default = 0>
<cfparam name="PrintFormat" default = 0>
<cfparam name="Level" default = "#FORM.Level#">
<cfparam name="Step" default = "#FORM.Step#">
<cfparam name="LogonID" default = "#ReplaceNoCase(REMOTE_USER, "LIBRARY\", "")#">
<cfparam name="Start1" default = "#FORM.Start1#">
<cfparam name="End1" default = "#FORM.End1#">
<cfparam name="Flag" default = 0>
<cfset BarFactor = 0.02>

<cfinclude template="objects/qryGetAccounts.cfm">

<!--- check to see if a valid date range was specified --->
<cfset DateCompare = DateCompare(Start1, End1)>
<cfset IsStart1Date = IsDate(Start1)>
<cfset IsEnd1Date = IsDate(End1)>
<cfif DateCompare GT 0 OR NOT IsStart1Date OR NOT IsEnd1Date>
	<cfset InvalidDateRange = 1>
<cfelse>
	<cfset InvalidDateRange = 0>
</cfif>

<cfif NOT InvalidDateRange>

	<cfquery name="GetDataCollectionMethod" datasource="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
		<cfoutput>
			SELECT DISTINCT
				InputMethod
			FROM
				ReferenceStatistics
			WHERE
				LogonID = '#LogonID#'
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
		<cfquery name="GetT"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT RU.Descrpt AS Library,
				RSP.Descrpt AS ServicePoint,
				SUM([Count]) AS Total
				FROM ReferenceStatistics RS
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE SUBSTRING(AggregateID, 8, 2) = '00'
				AND LogonID = '#LogonID#'
				AND InputMethod = 2
				AND (
				CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
				CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
				CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
				)
				GROUP BY RU.Descrpt, RSP.Descrpt
				WITH ROLLUP
				ORDER BY Library, ServicePoint
			</cfoutput>
		</cfquery>
		<cfloop query="GetT">
			<cfif GetT.Library IS "">
				<cfset GetTTotal = GetT.Total>
			</cfif>
		</cfloop>

		<!--- hourly transactions query --->
		<cfquery name="GetTHour"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
				DATEPART(Hour, Created_DT) AS HourDay,
				SUM([Count]) AS Total
				FROM ReferenceStatistics RS
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE SUBSTRING(AggregateID, 8, 2) = '00'
				AND LogonID = '#LogonID#'
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

		<cfquery name="GetTDay"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
				DATEPART(WeekDay, Created_DT) AS DayWeek,
				SUM([Count]) AS Total
				FROM ReferenceStatistics RS
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE SUBSTRING(AggregateID, 8, 2) = '00'
				AND LogonID = '#LogonID#'
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

		<cfquery name="GetQ"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
				"d" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END),
				"i" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END),
				"s" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '03' THEN [Count] ELSE 0 END),
				"t" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '04' THEN [Count] ELSE 0 END),
				"r" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END),
				"c" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '06' THEN [Count] ELSE 0 END),
				"Total" = SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '01' THEN [Count] ELSE 0 END) +
				SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '02' THEN [Count] ELSE 0 END) +
				SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '03' THEN [Count] ELSE 0 END) +
				SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '04' THEN [Count] ELSE 0 END) +
				SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '05' THEN [Count] ELSE 0 END) +
				SUM(CASE WHEN SUBSTRING(RS.AggregateID, 8, 2) = '06' THEN [Count] ELSE 0 END)
				FROM ReferenceStatistics RS
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
				AND LogonID = '#LogonID#'
				AND InputMethod = 2
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
		<cfloop query="GetQ">
			<cfif GetQ.LibraryPoint IS "">
				<cfset QTotal = GetQ.Total>
			</cfif>
		</cfloop>

		<cfquery name="GetQM"  DATASOURCE="#CircStatsDSN#">
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
				AND LogonID = '#LogonID#'
				AND InputMethod = 2
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
		<cfloop query="GetQM">
			<cfif GetQM.QuestionType IS "">
				<cfset QMTotal = GetQM.Total>
			</cfif>
		</cfloop>

		<cfquery name="GetQPM"  DATASOURCE="#CircStatsDSN#">
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
				AND LogonID = '#LogonID#'
				AND InputMethod = 2
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
		<cfloop query="GetQPM">
			<cfif GetQPM.ServicePoint IS "">
				<cfset QPMTotal = GetQPM.Total>
			</cfif>
		</cfloop>

		<cfquery name="GetQHour"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
				DATEPART(Hour, Created_DT) AS HourDay,
				SUM([Count]) AS Total
				FROM ReferenceStatistics RS
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
				AND LogonID = '#LogonID#'
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

		<cfquery name="GetHourlyType"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT
				RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
				RT.Descrpt AS QuestionType,
				DATEPART(Hour, Created_DT) AS HourDay,
				SUM([Count]) AS Total
				FROM
				ReferenceStatistics RS
				JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE
				SUBSTRING(AggregateID, 8, 2) <> '00'
				AND LogonID = '#LogonID#'
				AND InputMethod = 2
				AND
				(
				CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
				CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
				CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
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

		<cfquery name="GetQDay"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
				DATEPART(WeekDay, Created_DT) AS DayWeek,
				SUM([Count]) AS Total
				FROM ReferenceStatistics RS
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE SUBSTRING(AggregateID, 8, 2) <> '00'
				AND LogonID = '#LogonID#'
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

		<cfquery name="GetDailyType"  DATASOURCE="#CircStatsDSN#">
			<cfoutput>
				SELECT
				RU.Descrpt + ' ' + RSP.Descrpt AS LibraryPoint,
				RT.Descrpt AS QuestionType,
				DATEPART(WeekDay, Created_DT) AS DayWeek,
				SUM([Count]) AS Total
				FROM
				ReferenceStatistics RS
				JOIN RefType RT ON RT.TypeID = SUBSTRING(RS.AggregateID, 8, 2)
				JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
				JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
				WHERE
				SUBSTRING(AggregateID, 8, 2) <> '00'
				AND LogonID = '#LogonID#'
				AND InputMethod = 2
				AND (
				CAST(CAST(DATEPART(Month, Created_DT) AS VARCHAR) + '/' +
				CAST(DATEPART(Day, Created_DT) AS VARCHAR) + '/' +
				CAST(DATEPART(Year, Created_DT) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
				)
				GROUP BY
				RU.Descrpt + ' ' + RSP.Descrpt,
				RT.Descrpt,
				DATEPART(WeekDay, Created_DT)
				WITH ROLLUP
				ORDER BY
				LibraryPoint,
				QuestionType,
				DayWeek
			</cfoutput>
		</cfquery>

		<cfquery name="Greater10ByPoint"  DATASOURCE="#CircStatsDSN#">
			SELECT
				rp.[Descrpt] AS ServicePoint,
				rt.[Descrpt] AS QuestionType,
				COUNT(rs.[RecordID]) as Total
			FROM
				RefStatsLongQuestions rs
				join RefServicePoint rp on rs.PointID = rp.PointID
				JOIN RefType rt ON rs.TypeID = rt.TypeID
			WHERE
				(
					CAST(CAST(DATEPART(Month, rs.[Created_DT]) AS VARCHAR) + '/' +
					CAST(DATEPART(Day, rs.[Created_DT]) AS VARCHAR) + '/' +
					CAST(DATEPART(Year, rs.[Created_DT]) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
				)
				AND LogonID = '#LogonID#'
			GROUP BY
				rp.[Descrpt],
				rt.[Descrpt]
			UNION
			SELECT
				rp.[Descrpt] AS ServicePoint,
				NULL AS QuestionType,
				COUNT(rs.[RecordID]) as Total
			FROM
				RefStatsLongQuestions rs
				join RefServicePoint rp on rs.PointID = rp.PointID
				JOIN RefType rt ON rs.TypeID = rt.TypeID
			WHERE
				(
					CAST(CAST(DATEPART(Month, rs.[Created_DT]) AS VARCHAR) + '/' +
					CAST(DATEPART(Day, rs.[Created_DT]) AS VARCHAR) + '/' +
					CAST(DATEPART(Year, rs.[Created_DT]) AS VARCHAR) AS SMALLDATETIME) BETWEEN '#Start1#' AND '#End1#'
				)
				AND LogonID = '#LogonID#'
			GROUP BY
				rp.[Descrpt]
			ORDER BY
				ServicePoint,
				QuestionType
		</cfquery>
	</cfif>
</cfif>

<html>
	<head>
		<cfoutput>
			<title>Account-Specific Report: #GetAccounts.Firstname# #GetAccounts.LastName#</title>
		</cfoutput>

		<cfif Text IS 0>
			<cfinclude template="../../../library_pageincludes/banner_nonav.cfm">
		</cfif>
		<cfif Text IS 1>
			<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
		</cfif>

		<!--begin you are here-->

		<a href="../../index.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Reference</a> &gt; <a href="generator.cfm?Level=Account">Account-Specific Report</a> &gt;
		<cfoutput>
			#GetAccounts.Firstname# #GetAccounts.LastName#
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
			<form action="generator.cfm" method="post" class="form">
				<input type="hidden" name="Step" value="1">
				<input type="hidden" name="Level" value="#Level#">
				<input type="hidden" name="Start1" value="#Start1#">
				<input type="hidden" name="End1" value="#End1#">
				<input type="hidden" name="LogonID" value="#LogonID#">
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
				<li>This account may not have any data associated with it</li>
			</ul>
		<cfelse>
			<cfoutput>
				<h2>Reference statistics report: #GetAccounts.Firstname# #GetAccounts.LastName#<br></h2>
			</cfoutput>

			<hr align="left" width="100%" noshade>

			<!--- total transactions --->
			<p>
				<span class="large">Total transactions</span><br>
				<cfoutput>
					#Start1# to #End1#
				</cfoutput>
				<br>
				<table border="1" cellspacing="0" cellpadding="1" bordercolor="#FFFFFF">
					<tr bgcolor="#CCCCCC">
						<td nowrap class="tblcopy"><strong>Library and service point</strong></td>
						<td align="right" nowrap class="tblcopy"><strong>Total transactions</strong></td>
					</tr>
					<cfoutput query="GetT">
						<cfif ServicePoint IS NOT "">
							<tr bgcolor="##EBF0F7">
								<td nowrap class="tblcopy">#Library# #ServicePoint#</td>
								<td align="right" nowrap class="tblcopy">#Total# (#NumberFormat(Evaluate((Total / GetTTotal) * 100), '__._')#%)</td>
							</tr>
						</cfif>
					</cfoutput>
					<cfoutput query="GetT">
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
					<span class="large">Total transactions by day of week</span><br>
					#Start1# to #End1#
				</cfoutput>
			</p>
			<cfoutput query="GetTDay" group="LibraryPoint">
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
						</table>
					</p>
				</cfif>
			</cfoutput>
			<hr align="left" width="100%" noshade>


			<!--- total transactions by hour of day --->
			<cfoutput>
				<p>
					<span class="large">Total transactions by hour of day<cfif Monthly>, real-time service points only</cfif></span><br>
					#Start1# to #End1#
				</p>
			</cfoutput>
			<cfoutput query="GetTHour" group="LibraryPoint">
				<cfif LibraryPoint IS NOT "">
					<p>
						#LibraryPoint#
						<cfif HourDay IS "" AND LibraryPoint IS NOT "">
							<cfset THourTotal = Total>(n = #Total#)<br>
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
									<cfset BarWidth = #Round(Evaluate((Total/THourTotal)*200))#>
									<tr valign="middle">
										<td class="small">#TimeFormat(CreateTime(HourDay, 00, 00), "htt")#&nbsp;</td>
										<td width="1" bgcolor="Black"><img src="../../images/1x1.gif" height="1" border="0"></td>
										<td align="left" nowrap class="small"><img src="../../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Total / THourTotal)*100), "__._")#%" width="#BarWidth#" height="16" border="0" align="absmiddle">&nbsp;#Total# (#NumberFormat(Evaluate((Total / THourTotal) * 100), '__._')#%)</td>
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
				</cfif>
			</cfoutput>

			<!--- total questions by type and service point --->
			<p>
				<span class="large">Total questions by type and service point</span><br>
				<cfoutput>
					#Start1# to #End1#
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
					<cfoutput query="GetQ">
						<cfif LibraryPoint IS NOT "">
							<tr bgcolor="##EBF0F7">
								<td class="tblcopy">#LibraryPoint#</td>
								<td align="right" nowrap class="tblcopy">#d# <cfif QTotal neq 0>(#NumberFormat(Evaluate((d / QTotal) * 100), '__._')#%)<cfelse>(0%)</cfif></td>
								<td align="right" nowrap class="tblcopy">#i# <cfif QTotal neq 0>(#NumberFormat(Evaluate((i / QTotal) * 100), '__._')#%)<cfelse>(0%)</cfif></td>
								<td align="right" nowrap class="tblcopy">#s# <cfif QTotal neq 0>(#NumberFormat(Evaluate((s / QTotal) * 100), '__._')#%)<cfelse>(0%)</cfif></td>
								<td align="right" nowrap class="tblcopy">#t# <cfif QTotal neq 0>(#NumberFormat(Evaluate((t / QTotal) * 100), '__._')#%)<cfelse>(0%)</cfif></td>
								<td align="right" nowrap class="tblcopy">#r# <cfif QTotal neq 0>(#NumberFormat(Evaluate((r / QTotal) * 100), '__._')#%)<cfelse>(0%)</cfif></td>
								<td align="right" nowrap class="tblcopy">#c# <cfif QTotal neq 0>(#NumberFormat(Evaluate((c / QTotal) * 100), '__._')#%)<cfelse>(0%)</cfif></td>
								<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
							</tr>
						</cfif>
					</cfoutput>
					<cfoutput query="GetQ">
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

			<!--- total questions by type delivery mode, realtime --->
			<p>
				<cfoutput>
					<span class="large">Total questions by type and delivery mode</span><br>
					#Start1# to #End1#
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
					<cfoutput query="GetQM">
						<cfif QuestionType IS NOT "">
							<tr bgcolor="##EBF0F7">
								<td nowrap class="tblcopy">#QuestionType#</td>
								<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / QMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / QMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / QMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#c# (#NumberFormat(Evaluate((c / QMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#o# (#NumberFormat(Evaluate((o / QMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#m# (#NumberFormat(Evaluate((m / QMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
							</tr>
						</cfif>
					</cfoutput>
					<cfoutput query="GetQM">
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

			<!--- total questions by service point and mode of delivery --->
			<p>
				<cfoutput>
					<span class="large">Total questions by service point and mode of delivery</span><br>
					#Start1# to #End1#
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
					<cfoutput query="GetQPM">
						<cfif ServicePoint IS NOT "">
							<tr bgcolor="##EBF0F7">
								<td nowrap class="tblcopy">#ServicePoint#</td>
								<td align="right" nowrap class="tblcopy">#i# (#NumberFormat(Evaluate((i / QPMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#t# (#NumberFormat(Evaluate((t / QPMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#e# (#NumberFormat(Evaluate((e / QPMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#c# (#NumberFormat(Evaluate((c / QPMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#o# (#NumberFormat(Evaluate((o / QPMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy">#m# (#NumberFormat(Evaluate((m / QPMTotal) * 100), '__._')#%)</td>
								<td align="right" nowrap class="tblcopy" bgcolor="##CCCCCC">#Total#</td>
							</tr>
						</cfif>
					</cfoutput>
					<cfoutput query="GetQPM">
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

			<!--- total >10 questions by type and point --->
			<cfoutput>
			<p>
			<span class="large">Total ">10 minutes" questions by service point and type, real-time service points only</span><br>
			#Start1# to #End1# <!---a href="JavaScript:PopUp('facts.cfm?ReportType=2')" class="red">*</a--->
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
					<span class="large">Total questions by hour of day</span><br>
					#Start1# to #End1#
				</p>
			</cfoutput>
			<cfoutput query="GetQHour" group="LibraryPoint">
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
						</table>
					</p>
				</cfif>
			</cfoutput>
			<hr align="left" width="100%" noshade>

			<!--- total questions by type and hour of day --->
			<cfoutput>
				<p>
					<span class="large">Total questions by type and hour of day</span><br>
					#Start1# to #End1#
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
					<span class="large">Total questions by day of week</span><br>
					#Start1# to #End1#
				</cfoutput>
			</p>
			<cfoutput query="GetQDay" group="LibraryPoint">
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
						</table>
					</p>
				</cfif>
			</cfoutput>
			<hr align="left" width="100%" noshade>

			<!--- total questions by type and day of week --->
			<p>
				<cfoutput>
					<span class="large">Total questions by type and day of week</span><br>
					#Start1# to #End1#'
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
						</table>
					</p>
				</cfif>
			</cfoutput>
			<hr align="left" width="100%" noshade>
		</cfif>

		<cfif Text IS 0>
			<cfinclude template="../../../library_pageincludes/footer.cfm">
			<cfinclude template="../../../library_pageincludes/end_content.cfm">
		</cfif>
		<cfif Text IS 1>
			<cfinclude template="../../../library_pageincludes/footer_nonav_txt.cfm">
		</cfif>

