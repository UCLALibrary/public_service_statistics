<cfparam name = "Text" default = "No">
<cfparam name = "PrintFormat" default = "No">
<cfparam name="UnitID" default = "#UnitCode#">
<cfparam name="DefaultPage" default = 1>

<cfif Find("#UnitCode#", UnitID) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif>

<cfquery name="GetUnit" datasource="#CircStatsDSN#">
	SELECT UnitID,
		   Unit
	FROM   CircUnit
	WHERE  UnitID LIKE '#UnitID#'
</cfquery>

<cfquery name="DateRangeAutoStats" datasource="#CircStatsDSN#">
	SELECT Max(Date) AS 'MaxDate',
		   Min(Date) AS 'MinDate'
	FROM   CirculationCharges
</cfquery>

<cfquery name="DateRangeManualStats" datasource="#CircStatsDSN#">
	SELECT Max(Updated_DT) AS 'MaxDate',
           Min(Updated_DT) AS 'MinDate'
	FROM   CircManualStatistics
	WHERE  SUBSTRING(AggregateID, 1, 3) = '<cfoutput>#UnitID#</cfoutput>'
</cfquery>

<cfset StartDateManualStats = DateRangeManualStats.MinDate>
<cfset EndDateManualStats = DateRangeManualStats.MaxDate>
<cfset StartDateAutoStats = DateRangeAutoStats.MinDate>
<cfset EndDateAutoStats = DateRangeAutoStats.MaxDate>

<cfparam name="dataMonth" default = #DatePart("m", DateRangeAutoStats.MaxDate)#>
<cfparam name="dataYear" default = #DatePart("yyyy", DateRangeAutoStats.MaxDate)#>


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

<cfquery name="GetTotals" datasource="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
	SELECT
		T1.CategoryID,
		T1.GroupID,
		T1.Category,
		T1.CircGroup,
		T1.CircGroupSort,
		T1.CategorySort,
		"PrevFY" = SUM(
			CASE
				WHEN
		   		(
		   			<cfif dataMonth GTE 7 AND dataMonth LTE 12>
		   				dataMonth BETWEEN 7 AND #dataMonth# AND dataYear = #PrevFYStart#
		   			<cfelseif dataMonth GTE 1 AND dataMonth LTE 6>
		   				(dataMonth BETWEEN 7 AND 12 AND dataYear = #PrevFYStart#)
                    	OR
                    	(dataMonth BETWEEN 1 AND #dataMonth# AND dataYear = #PrevFYEnd#)
                    </cfif>
				) THEN Total ELSE NULL END),
		"CurrFY" = SUM(
			CASE
				WHEN
				(
					<cfif dataMonth GTE 7 AND dataMonth LTE 12>
						dataMonth BETWEEN 7 AND #dataMonth# AND dataYear = #CurrFYStart#
					<cfelseif dataMonth GTE 1 AND dataMonth LTE 6>
						(dataMonth BETWEEN 7 AND 12 AND dataYear = #CurrFYStart#)
						OR
						(dataMonth BETWEEN 1 AND #dataMonth# AND dataYear = #CurrFYEnd#)
					</cfif>
				) THEN Total ELSE NULL END),
		"PrevFYMonth" = SUM(
			CASE
				WHEN dataMonth = #dataMonth# AND dataYear =
					<cfif dataMonth GTE 7 AND dataMonth LTE 12>#PrevFYStart#<cfelse>#CurrFYStart#</cfif>
				THEN Total
                ELSE NULL END),
       	"CurrFYMonth" = SUM(
       		CASE
       			WHEN dataMonth = #dataMonth# AND dataYear =
					<cfif dataMonth GTE 7 AND dataMonth LTE 12>#CurrFYStart#<cfelse>#CurrFYEnd#</cfif>
				THEN Total
                ELSE NULL END)
	FROM (
		SELECT
			CategoryID,
			GroupID,
			Category,
			CircGroup,
			CircGroupSort,
			CategorySort
		FROM
			View_CircUnitCategory
		WHERE
			UnitID='#UnitID#' ) T1
	LEFT OUTER JOIN (
		SELECT
			Total,
			CategoryID,
			dataMonth,
			dataYear
		FROM
			View_CircStats
		WHERE
			UnitID='#UnitID#' ) T2
	ON T1.CategoryID = T2.CategoryID
	GROUP BY
		T1.CategoryID,
		T1.GroupID,
		T1.Category,
		T1.CircGroup,
		T1.CircGroupSort,
		T1.CategorySort
	ORDER BY
		T1.CircGroupSort,
		T1.CategorySort
</cfquery>

<cfquery name="GetComments" datasource="#CircStatsDSN#">
	SELECT *
	FROM   CircComment
	WHERE  UnitID = '#UnitID#' AND dataMonth = #dataMonth# AND dataYear = #dataYear#
</cfquery>

<cfif GetComments.RecordCount IS NOT 0>
	<cfset CommentExists = 1>
<cfelse>
	<cfset CommentExists = 0>
</cfif>

<html>
	<head>
		<title>UCLA Library Public Service Statistics Report: <cfoutput>#GetUnit.Unit#</cfoutput></title>
		<cfif PrintFormat IS "Yes">
				<link rel=STYLESHEET href="../../css/main.css" type="text/css">
			</head>
			<body bgcolor="#FFFFFF">
		<cfelse>
			<cfif Text IS "No">
				<cfinclude template="../../../library_pageincludes/banner_nonav.cfm">
			</cfif>
			<cfif Text IS "Yes">
				<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
			</cfif>
			<!--begin you are here-->
				<a href="../../home.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Circulation</a> &gt; <cfoutput><a href="index.cfm">#GetUnit.Unit#</a></cfoutput> &gt; Summary Report
			<!-- end you are here -->
			<cfinclude template="../../../library_pageincludes/start_content_nonav.cfm">
		</cfif>
		<!--begin main content-->
			<h1><cfoutput>#GetUnit.Unit#</cfoutput>: Circulation Statistics Summary Report</h1>
			<cfoutput>
				<h3>#MonthAsString(dataMonth)#, Fiscal #CurrFYStart# - #CurrFYEnd# <!--year -->
				<cfif CommentExists><sup><a href="##footnote">*</a></sup></cfif></h3>
			</cfoutput>
			<p>
				<cfif EndDateManualStats IS NOT "">
					Circulation data extracted from Voyager are current to
					<cfoutput>#DateFormat(EndDateAutoStats, "mmmm d, yyyy")#</cfoutput>.
					Manually collected public services data were last input on
					<cfoutput>#DateFormat(EndDateManualStats, "mmmm d, yyyy")#</cfoutput>.
				<cfelse>
					No manually collected data have been input into the database.
				</cfif>
			</p>
			<cfif PrintFormat IS NOT "Yes">
				<table border="0" cellspacing="0" cellpadding="1" bgcolor="#336699">
					<tr>
						<td class="menu">&nbsp;Select a month/calendar year</td>
					</tr>
					<tr>
						<td>
							<table border="0" cellspacing="0" cellpadding="6" bgcolor="#EBF0F7">
								<tr>
									<td>
										<cfoutput>
											<form action="report.cfm" method="post" class="form">
												View data for
												<select name="dataMonth" class="form">
													<cfloop index="Month" from="1" to="12">
														<option value="#Month#" class="form" <cfif Month IS dataMonth>selected</cfif>>#MonthAsString(Month)#</option>
													</cfloop>
												</select>
												calendar year
												<select name="dataYear" class="form">
													<cfloop index="Year" from="1999" to="#DatePart("yyyy", Now())#">
														<option value="#Year#" class="form" <cfif Year IS dataYear>selected</cfif>>#Year#</option>
													</cfloop>
												</select>
												<input type="submit" value="Change month/year" class="form">
												<input type="hidden" name="UnitID" value="#UnitID#">
												<input type="hidden" name="DefaultPage" value="0">
											</form>
										</cfoutput>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br>
				<cfoutput>
					<span class="small">
						<cfif Text IS "No">
							<a href="report.cfm?PrintFormat=Yes"><img src="../../images/printer.gif" alt="Format for printing" width="20" height="20" border="0" align="absmiddle"></a>
						</cfif>
						<a href="report.cfm?PrintFormat=Yes&UnitID=#UnitID#&dataMonth=#dataMonth#&dataYear=#dataYear#">Format for printing</a>
					</span>
				</cfoutput>
			</cfif>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
				<tr valign="bottom" bgcolor="#CCCCCC">
					<td class="small" bgcolor="#FFFFFF">&nbsp;</td>
					<td align="right" class="small">
						<b><cfoutput>FY #RemoveChars(PrevFYStart, 1, 2)#/#RemoveChars(PrevFYEnd, 1, 2)#</cfoutput> YTD</b>
					</td>
					<td align="right" class="small">
						<b><cfoutput>FY #RemoveChars(CurrFYStart, 1, 2)#/#RemoveChars(CurrFYEnd, 1, 2)#</cfoutput> YTD</b>
					</td>
					<td align="right" class="small"><b>Diff.</b></td>
					<td align="center" nowrap class="small"><b>%Change</b></td>
					<td align="right" class="small">
						<b><cfoutput>#Left(MonthAsString(dataMonth), 3)# FY #RemoveChars(PrevFYStart, 1, 2)#/#RemoveChars(PrevFYEnd, 1, 2)#</cfoutput></b>
					</td>
					<td align="right" class="small">
						<b><cfoutput>#Left(MonthAsString(dataMonth), 3)# FY #RemoveChars(CurrFYStart, 1, 2)#/#RemoveChars(CurrFYEnd, 1, 2)#</cfoutput></b>
					</td>
					<td align="right" class="small"><b>Diff.</b></td>
					<td align="center" nowrap class="small"><b>%Change</b></td>
				</tr>
				<cfoutput query="GetTotals" group="CircGroup">
					<tr valign="top" bgcolor="##CCCCCC">
						<td colspan="9" class="small"><strong>#CircGroup#</strong></td>
					</tr>
					<cfoutput group="Category">
						<tr valign="top" bgcolor="##EBF0F7">
							<td class="small">#Category#</td>
							<td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
							<td align="right" class="small"><cfif CurrFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
							<td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
							<td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT '' AND PrevFY IS NOT 0 AND CurrFY IS NOT 0>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
							<td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
							<td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
							<td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
							<td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT '' AND PrevFYMonth IS NOT 0 AND CurrFYMonth IS NOT 0>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif></td>
						</tr>
					</cfoutput>
				</cfoutput>
			</table>
			<cfif CommentExists>
				<a name="footnote" id="footnote"></a>
				<table width="100%" border="0" cellspacing="0" cellpadding="4" bgcolor="#FFFFCC">
					<tr valign="top">
						<td width="2%" class="copy"><strong>Notes:</strong></td>
						<td width="2%">&nbsp;</td>
						<td width="96%" class="copy">
							<cfoutput query="GetComments">
								#Comment#<br>
								(by #LogonID#, #DateFormat(Updated_DT, "mm/dd/yyyy")#--#TimeFormat(Updated_DT, "hh:mm:ss tt")#)<br><br>
							</cfoutput>
						</td>
					</tr>
				</table>
			</cfif>
			<cfif PrintFormat IS "Yes">
					</body>
				</html>
			<cfelse>
				<cfif Text IS "No">
					<cfinclude template="../../../library_pageincludes/footer.cfm">
					<cfinclude template="../../../library_pageincludes/end_content.cfm">
				</cfif>
				<cfif Text IS "Yes">
					<cfinclude template="../../../library_pageincludes/footer_nonav_txt.cfm">
				</cfif>
			</cfif>