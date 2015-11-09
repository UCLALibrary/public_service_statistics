<CFPARAM NAME = "Text" DEFAULT = "No">
<CFPARAM NAME = "PrintFormat" DEFAULT = "no">
<CFPARAM NAME = "ReportType" DEFAULT = 0>
<CFPARAM NAME = "FY" DEFAULT = 0>
<CFPARAM NAME = "LibUnit" DEFAULT = "None">
<CFPARAM NAME = "Month" DEFAULT = 0>

<cfswitch expression="#ReportType#">
	<cfcase value="1">
		<cfset Column = "Unit">
		<cfset QueryName = "GetUnit">
		<cfset QueryRecordCount = "GetUnit.RecordCount">
	</cfcase>
	<cfcase value="2">
		<cfset Column = "Inst_Type">
		<cfset QueryName = "GetInst_Type">
		<cfset QueryRecordCount = "GetInst_Type.RecordCount">
	</cfcase>
	<cfcase value="3">
		<cfset Column = "Category">
		<cfset QueryName = "GetCategory">
		<cfset QueryRecordCount = "GetCategory.RecordCount">
	</cfcase>
	<cfcase value="4">
		<cfset Column = "WeekDay">
		<cfset QueryName = "GetWeekDay">
		<cfset QueryRecordCount = "GetWeekDay.RecordCount">
	</cfcase>
	<cfcase value="5">
		<cfset Column = "Month">
		<cfset QueryName = "GetMonth">
		<cfset QueryRecordCount = "GetMonth.RecordCount">
	</cfcase>
	<cfcase value="0">
		<cfset Column = "Unit">
		<cfset QueryName = "GetUnit">
		<cfset QueryRecordCount = "GetUnit.RecordCount">
	</cfcase>
</cfswitch>

<cfset ThisMonth = DatePart("m", Now())>
<cfset ThisYear = DatePart("yyyy", Now())>

<cfif FY IS 0>
	<cfif ThisMonth GTE 7 AND ThisMonth LTE 12>
		<cfset FYStart = ThisYear>
		<cfset FYEnd = ThisYear + 1>
	<cfelseif ThisMonth GTE 1 AND ThisMonth LTE 6>
		<cfset FYStart = ThisYear - 1>
		<cfset FYEnd = ThisYear>
	</cfif>
<cfelse>
	<cfset FYStart = FY>
	<cfset FYEnd = FY + 1>
</cfif>

<cfquery name="GetLibUnits" datasource="#CircStatsDSN#">
SELECT *
FROM locunit
WHERE loc NOT IN
 ('CSR', 'AAS', 'ETH', 'FTA', 'MIT', 'UCB', 'UCI',
  'USB', 'USC', 'USD', 'USF', 'UKN', 'UCL')
AND Unit <> 'other'
</cfquery>

<cfquery name="GetDBTotalCoverage" datasource="#CircStatsDSN#">
SELECT 'Coverage' = 'COMPLETE',
       Min(Date) AS 'Start',
       Max(Date) AS 'End'
from view_Circulation
</cfquery>

<cfquery name="GetDBFYCoverage" datasource="#CircStatsDSN#">
SELECT 'Coverage' = 'FY',
       Min(Date) AS 'Start',
       Max(Date) AS 'End'
from view_Circulation
WHERE (Month([Date]) BETWEEN 7 AND 12 AND Year([Date]) = #FYStart#)
       OR
      (Month([Date]) BETWEEN 1 AND 6 AND Year([Date]) = #FYEnd#)
</cfquery>

<cfset DBEnd = GetDBTotalCoverage.End>
<cfset DBStart = GetDBTotalCoverage.Start>
<cfset DBFYEnd = GetDBFYCoverage.End>
<cfset DBFYStart = GetDBFYCoverage.Start>

<cfswitch expression="#Column#">
	<cfcase value="Unit">
		<cfquery name="GetUnit" datasource="#CircStatsDSN#">
			<cfoutput>
SELECT unit=IsNull(unit, 'TOTAL'),
       SUM(C.Charges) AS Charges,
       SUM(C.Renewals) AS Renewals,
       SUM(C.Charges+C.Renewals) AS ChargesRenewals,
       SUM(C.Discharges) AS Discharges,
       SUM(C.Discharges+C.Renewals+C.Charges) AS RowTotal
from view_Circulation C
JOIN LocUnit LU ON C.loc = LU.loc
WHERE C.loc NOT IN
 ('CSR', 'AAS', 'ETH', 'FTA', 'MIT', 'UCB', 'UCI',
  'USB', 'USC', 'USD', 'USF', 'UKN')
AND (
        (Month([Date]) BETWEEN 7 AND 12 AND Year([Date]) = #FYStart#)
        OR
        (Month([Date]) BETWEEN 1 AND 6 AND Year([Date]) = #FYEnd#)
    )
GROUP BY LU.unit
WITH ROLLUP
ORDER BY LU.unit
			</cfoutput>
		</cfquery>
	</cfcase>
	<cfcase value="Inst_Type">
		<cfquery name="GetInst_Type" datasource="#CircStatsDSN#">
			<cfoutput>
SELECT inst_type=IsNull(CS.inst_type, 'TOTAL'),
       SUM(CS.Charges) AS Charges,
       SUM(CS.Renewals) AS Renewals,
       SUM(CS.Charges+CS.Renewals) AS ChargesRenewals,
       SUM(CS.Discharges) AS Discharges,
       SUM(CS.Discharges+CS.Renewals+CS.Charges) AS RowTotal
FROM
( SELECT inst_type =
  CASE
    WHEN inst_type IS NULL THEN 'Unknown'
    WHEN inst_type = 'UKN' THEN 'Unknown'
    ELSE inst_type
  END,
  Charges, Renewals, Discharges
  from view_Circulation
  WHERE (
  		  (Month([Date]) BETWEEN 7 AND 12 AND Year([Date]) = #FYStart#)
          OR
          (Month([Date]) BETWEEN 1 AND 6 AND Year([Date]) = #FYEnd#)
		)
<cfif LibUnit IS NOT "None">
AND Loc = '#LibUnit#'
</cfif>
) AS CS
GROUP BY inst_type WITH ROLLUP
ORDER BY

CS.inst_type
			</cfoutput>
		</cfquery>
	</cfcase>
	<cfcase value="Category">
		<cfquery name="GetCategory" datasource="#CircStatsDSN#">
			<cfoutput>
SELECT category=IsNull(CS.category, 'TOTAL'),
	   SUM(CS.Charges) AS Charges,
	   SUM(CS.Renewals) AS Renewals,
       SUM(CS.Charges+CS.Renewals) AS ChargesRenewals,
       SUM(CS.Discharges) AS Discharges,
	   SUM(CS.Discharges+CS.Renewals+CS.Charges) AS RowTotal
from view_Circulation CS
WHERE (
		(Month([Date]) BETWEEN 7 AND 12 AND Year([Date]) = #FYStart#)
        OR
        (Month([Date]) BETWEEN 1 AND 6 AND Year([Date]) = #FYEnd#)
      )
AND Category <> 'NULL'
<cfif LibUnit IS NOT "None">
AND Loc = '#LibUnit#'
</cfif>
GROUP BY CS.category WITH ROLLUP
ORDER BY

  CS.category
			</cfoutput>
		</cfquery>
	</cfcase>
	<cfcase value="WeekDay">
		<cfquery name="GetWeekDay" datasource="#CircStatsDSN#">
			<cfoutput>
SELECT [WeekDay]=IsNull([WeekDay], 'TOTAL'),
       SUM(CS.Charges) AS Charges,
       SUM(CS.Renewals) AS Renewals,
       SUM(CS.Charges+CS.Renewals) AS ChargesRenewals,
       SUM(CS.Discharges) AS Discharges,
       SUM(CS.Discharges+CS.Renewals+CS.Charges) AS RowTotal
FROM
(SELECT Cast(DatePart(WeekDay, [Date]) AS VARCHAR) AS [WeekDay],
       Charges,
       Renewals,
       Discharges
from view_Circulation
WHERE (
		(Month([Date]) BETWEEN 7 AND 12 AND Year([Date]) = #FYStart#)
        OR
        (Month([Date]) BETWEEN 1 AND 6 AND Year([Date]) = #FYEnd#)
      )
<cfif LibUnit IS NOT "None">
AND Loc = '#LibUnit#'
</cfif>
) AS CS
GROUP BY CS.[WeekDay] WITH ROLLUP
ORDER BY CS.[WeekDay]
			</cfoutput>
		</cfquery>
	</cfcase>
	<cfcase value="Month">
		<cfquery name="GetMonth" datasource="#CircStatsDSN#">
			<cfoutput>
SELECT [Month]=IsNull(Cast([Month] AS VARCHAR), 'TOTAL'),
       CASE WHEN CS.[Month] = 7 THEN 1
            WHEN CS.[Month] = 8 THEN 2
            WHEN CS.[Month] = 9 THEN 3
            WHEN CS.[Month] = 10 THEN 4
            WHEN CS.[Month] = 11 THEN 5
            WHEN CS.[Month] = 12 THEN 6
            WHEN CS.[Month] = 1 THEN 7
            WHEN CS.[Month] = 2 THEN 8
            WHEN CS.[Month] = 3 THEN 9
            WHEN CS.[Month] = 4 THEN 10
            WHEN CS.[Month] = 5 THEN 11
            WHEN CS.[Month] = 6 THEN 12
       ELSE NULL END AS 'MonthSort',
       CS.Charges,
       CS.Renewals,
	   CS.ChargesRenewals,
       CS.Discharges,
       CS.RowTotal
FROM
(
SELECT Month([Date]) AS [Month],
       SUM(Charges) AS Charges,
       SUM(Renewals) AS Renewals,
       SUM(Charges+Renewals) AS ChargesRenewals,
       SUM(Discharges) AS Discharges,
       SUM(Discharges+Renewals+Charges) AS RowTotal
from view_Circulation
WHERE (
		(Month([Date]) BETWEEN 7 AND 12 AND Year([Date]) = #FYStart#)
        OR
        (Month([Date]) BETWEEN 1 AND 6 AND Year([Date]) = #FYEnd#)
      )
<cfif LibUnit IS NOT "None">
AND Loc = '#LibUnit#'
</cfif>
GROUP BY Month([Date]) WITH ROLLUP
) AS CS
ORDER BY MonthSort
			</cfoutput>
		</cfquery>
	</cfcase>
</cfswitch>

<cfswitch expression="#Column#">
	<cfcase value="Unit">
		<cfset MaxCharges = GetUnit.Charges>
		<cfset MaxRenewals = GetUnit.Renewals>
		<cfset MaxDischarges = GetUnit.Discharges>
	</cfcase>
	<cfcase value="Inst_Type">
		<cfset MaxCharges = GetInst_Type.Charges>
		<cfset MaxRenewals = GetInst_Type.Renewals>
		<cfset MaxDischarges = GetInst_Type.Discharges>
	</cfcase>
	<cfcase value="Category">
		<cfset MaxCharges = GetCategory.Charges>
		<cfset MaxRenewals = GetCategory.Renewals>
		<cfset MaxDischarges = GetCategory.Discharges>
	</cfcase>
	<cfcase value="WeekDay">
		<cfset MaxCharges = GetWeekDay.Charges>
		<cfset MaxRenewals = GetWeekDay.Renewals>
		<cfset MaxDischarges = GetWeekDay.Discharges>
	</cfcase>
	<cfcase value="Month">
		<cfset MaxCharges = GetMonth.Charges>
		<cfset MaxRenewals = GetMonth.Renewals>
		<cfset MaxDischarges = GetMonth.Discharges>
	</cfcase>
</cfswitch>

<cfloop query="Get#Column#">
<cfif Evaluate(#Column#) IS NOT "TOTAL">
	<cfif Charges GT MaxCharges>
		<cfset MaxCharges = Charges>
	</cfif>
</cfif>
</cfloop>
<cfloop query="Get#Column#">
<cfif Evaluate(#Column#) IS NOT "TOTAL">
	<cfif Renewals GT MaxRenewals>
		<cfset MaxRenewals = Renewals>
	</cfif>
</cfif>
</cfloop>
<cfloop query="Get#Column#">
<cfif Evaluate(#Column#) IS NOT "TOTAL">
	<cfif Discharges GT MaxDischarges>
		<cfset MaxDischarges = Discharges>
	</cfif>
</cfif>
</cfloop>

<cfset MaxTransaction = 0>
<cfloop index="Value" list="#MaxCharges#,#MaxRenewals#,#MaxDischarges#" delimiters=",">
<cfif Value GT MaxTransaction>
	<cfset MaxTransaction = Value>
</cfif>
</cfloop>

<cfoutput query="Get#Column#">
<cfif #Evaluate(Column)# IS "Total">
	<cfset Total = RowTotal>
	<cfset TotalCharges = Charges>
	<cfset TotalRenewals = Renewals>
	<cfset TotalDischarges = Discharges>
	<cfset TotalTransactions = Evaluate(Charges + Renewals + Discharges)>
</cfif>
</cfoutput>

<html>
<head>

<script language=Javascript>
<!--// Reset forms
 function setForm() {
 document.SelectFYUnit.FY[0].selected = true;
<cfif LibUnit IS NOT "None">
 document.SelectFYUnit.LibUnit[0].selected = true;
</cfif>
 document.SelectFYUnit.submit();
 }
// end function -->
</script>

	<title>UCLA Library Circulation Statistics</title>
<cfif PrintFormat IS "Yes">
	<LINK REL=STYLESHEET HREF="../css/main.css" TYPE="text/css">
	</HEAD>
	<BODY BGCOLOR="#FFFFFF">
<cfelse>
	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/banner_nonav.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/banner_txt.cfm">
	</cfif>


<a name="top"></a>

<!--begin you are here-->


<a href="../home.cfm">Public Service Statistics</a> &gt; <a href="index.cfm">Circulation</a> &gt;
<cfoutput>
<cfswitch expression="#Column#">
	<cfcase value="Unit">
Circulation Transactions by Library Unit
	</cfcase>
	<cfcase value="Inst_Type">
Circulation Transactions by Institutional Category
	</cfcase>
	<cfcase value="Category">
Circulation Transactions by Patron Category
	</cfcase>
	<cfcase value="WeekDay">
Circulation Transactions by Week Day
	</cfcase>
	<cfcase value="Month">
Circulation Transactions by Month
	</cfcase>
</cfswitch>
<cfif Column IS NOT "Unit" AND LibUnit IS NOT "None">
:<cfswitch expression="#LibUnit#">
	<cfcase value="ART">
Arts Library
	</cfcase>
	<cfcase value="BIO">
Biomed Library
	</cfcase>
	<cfcase value="CLK">
Clark Library
	</cfcase>
	<cfcase value="COL">
Powell Library
	</cfcase>
	<cfcase value="EAL">
East Asian Library
	</cfcase>
	<cfcase value="LAW">
Law Library
	</cfcase>
	<cfcase value="MAN">
Management Library
	</cfcase>
	<cfcase value="MUS">
Music Library
	</cfcase>
	<cfcase value="SCH">
SEL Chemistry Library
	</cfcase>
	<cfcase value="SEM">
SEL EMS Library
	</cfcase>
	<cfcase value="SGG">
SEL Geo Library
	</cfcase>
	<cfcase value="SPH">
SEL Physics Library
	</cfcase>
	<cfcase value="SRL">
SRLF Library
	</cfcase>
	<cfcase value="UES">
UES Library
	</cfcase>
	<cfcase value="YRL">
YRL Library
	</cfcase>
	<cfcase value="USG">
Other Library
	</cfcase>
</cfswitch>
</cfif>


</cfoutput>

	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_nonav.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_nonav_txt.cfm">
	</cfif>

</cfif>

<!--begin main content-->

<cfif Evaluate(#QueryRecordCount#) IS 0>
	<cfoutput>
	<h1>No data available for fiscal year #FYStart#</h1>
	<p>Try selecting another fiscal year from the menu below.</p>
	</cfoutput>
	<cfif PrintFormat IS NOT "Yes">
		<cfinclude template="templates/tmpSelectFYUnit.cfm">
	</cfif>
<cfelse>


	<cfoutput>
<h1>

<cfswitch expression="#Column#">
	<cfcase value="Unit">
Circulation Transactions by Library Unit
	</cfcase>
	<cfcase value="Inst_Type">
Circulation Transactions by Institutional Category
	</cfcase>
	<cfcase value="Category">
Circulation Transactions by Patron Category
	</cfcase>
	<cfcase value="WeekDay">
Circulation Transactions by Week Day
	</cfcase>
	<cfcase value="Month">
Circulation Transactions by Month
	</cfcase>
</cfswitch>
<cfif Column IS NOT "Unit" AND LibUnit IS NOT "None">
:<cfswitch expression="#LibUnit#">
	<cfcase value="ART">
Arts Library
	</cfcase>
	<cfcase value="BIO">
Biomed Library
	</cfcase>
	<cfcase value="CLK">
Clark Library
	</cfcase>
	<cfcase value="COL">
Powell Library
	</cfcase>
	<cfcase value="EAL">
East Asian Library
	</cfcase>
	<cfcase value="LAW">
Law Library
	</cfcase>
	<cfcase value="MAN">
Management Library
	</cfcase>
	<cfcase value="MUS">
Music Library
	</cfcase>
	<cfcase value="SCH">
SEL Chemistry Library
	</cfcase>
	<cfcase value="SEM">
SEL EMS Library
	</cfcase>
	<cfcase value="SGG">
SEL Geo Library
	</cfcase>
	<cfcase value="SPH">
SEL Physics Library
	</cfcase>
	<cfcase value="SRL">
SRLF Library
	</cfcase>
	<cfcase value="UES">
UES Library
	</cfcase>
	<cfcase value="YRL">
YRL Library
	</cfcase>
	<cfcase value="USG">
Other Library
	</cfcase>
</cfswitch>
</cfif>
</h1>

<h3>FY #FYStart#; data covering #DateFormat(DBFYStart, "mmm d, yyyy")# to #DateFormat(DBFYEnd, "mmm d, yyyy")#</h3>

</cfoutput>

<cfif PrintFormat IS NOT "Yes">
	<cfinclude template="templates/tmpSelectFYUnit.cfm">
</cfif>


<cfif PrintFormat IS NOT "Yes">
	<cfoutput>
<span class="small">
<cfif Text IS "No"><a href="master_report.cfm?ReportType=#ReportType#&FY=#FY#&PrintFormat=Yes"><img src="../images/printer.gif" alt="Format for printing" width="20" height="20" border="0" align="absmiddle"></a></cfif>
<a href="master_report.cfm?ReportType=#ReportType#&FY=#FY#&PrintFormat=Yes">Format for printing</a>
</span>
	</cfoutput>
</cfif>


<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="top" bgcolor="#CCCCCC">
<cfswitch expression="#Column#">
	<cfcase value="Unit">
		<td class="small"><b>Unit</b></td>
	</cfcase>
	<cfcase value="Inst_Type">
		<td class="small"><b>Institutional category</b></td>
	</cfcase>
	<cfcase value="Category">
		<td class="small"><b>Patron category</b></td>
	</cfcase>
	<cfcase value="WeekDay">
		<td class="small"><b>Week day</b></td>
	</cfcase>
	<cfcase value="Month">
		<td class="small"><b>Month</b></td>
	</cfcase>
</cfswitch>
	<td align="right" class="small"><b>Charges</b></td>
	<td align="right" class="small"><b>Renewals</b></td>
	<td align="right" class="small"><b>Charges+Renewals</b></td>
	<td align="right" class="small"><b>Discharges</b></td>
	<td align="right" class="small"><b>Total</b></td>
</tr>
<cfset i = 1>
<cfoutput query="Get#Column#">
<cfif Evaluate(#Column#) IS NOT "TOTAL">
<tr valign="top"
	<cfif Evaluate(i MOD 2) IS 0>bgcolor="##EBFOF7"
	<cfelse>bgcolor="##FFFFFF"
	</cfif>>
	<cfswitch expression="#Column#">
		<cfcase value="Unit">
			<td class="small">#Unit#</td>
		</cfcase>
		<cfcase value="Inst_Type">
			<td class="small">#Inst_type#</td>
		</cfcase>
		<cfcase value="Category">
			<td class="small">#Category#</td>
		</cfcase>
		<cfcase value="WeekDay">
			<td class="small">#DayOfWeekAsString(WeekDay)#</td>
		</cfcase>
		<cfcase value="Month">
			<td class="small">#MonthAsString(Month)#</td>
		</cfcase>
	</cfswitch>
	<td align="right" class="small">#NumberFormat(Charges, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(Renewals, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(ChargesRenewals, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(Discharges, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(RowTotal, "_,___,___")#</td>
</tr>
	<cfset i = i + 1>
</cfif>
</cfoutput>
<cfoutput query="Get#Column#">
<cfif Evaluate(#Column#) IS "TOTAL">
<tr valign="top" bgcolor="##CCCCCC">
	<cfswitch expression="#Column#">
		<cfcase value="Unit">
			<td class="small">#Unit#</td>
		</cfcase>
		<cfcase value="Inst_Type">
			<td class="small">#Inst_type#</td>
		</cfcase>
		<cfcase value="Category">
			<td class="small">#Category#</td>
		</cfcase>
		<cfcase value="WeekDay">
			<td class="small">#WeekDay#</td>
		</cfcase>
		<cfcase value="Month">
			<td class="small">#Month#</td>
		</cfcase>
	</cfswitch>
	<td align="right" class="small">#NumberFormat(Charges, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(Renewals, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(ChargesRenewals, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(Discharges, "_,___,___")#</td>
	<td align="right" class="small">#NumberFormat(RowTotal, "_,___,___")#</td>
</tr>
</cfif>
</cfoutput>
</table>

<br>&nbsp;<br>


<!--- start graph --->

<cfswitch expression="#Column#">

<!--- start graph for unit --->

	<cfcase value="Unit">
<!--- charges --->
<cfif TotalCharges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_red.gif" alt="Charges" width="9" height="9" border="0"> charges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Charges/TotalCharges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%<br><img src="../images/pixel_red.gif" alt="#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="30" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Unit#">
	<cfcase value="Arts">#Replace(Unit, Unit, "ART", "ALL")#</cfcase>
	<cfcase value="Biomed">#Replace(Unit, Unit, "BIO", "ALL")#</cfcase>
	<cfcase value="Clark">#Replace(Unit, Unit, "CLK", "ALL")#</cfcase>
	<cfcase value="Powell">#Replace(Unit, Unit, "POW", "ALL")#</cfcase>
	<cfcase value="East Asian">#Replace(Unit, Unit, "EAL", "ALL")#</cfcase>
	<cfcase value="Law">#Replace(Unit, Unit, "LAW", "ALL")#</cfcase>
	<cfcase value="Management">#Replace(Unit, Unit, "MAN", "ALL")#</cfcase>
	<cfcase value="Music">#Replace(Unit, Unit, "MUS", "ALL")#</cfcase>
	<cfcase value="SEL Chemistry">#Replace(Unit, Unit, "SCH", "ALL")#</cfcase>
	<cfcase value="SEL EMS">#Replace(Unit, Unit, "SEM", "ALL")#</cfcase>
	<cfcase value="SEL Geo">#Replace(Unit, Unit, "SGG", "ALL")#</cfcase>
	<cfcase value="SEL Physics">#Replace(Unit, Unit, "SPH", "ALL")#</cfcase>
	<cfcase value="SRLF">#Replace(Unit, Unit, "SRL", "ALL")#</cfcase>
	<cfcase value="UES">#Replace(Unit, Unit, "UES", "ALL")#</cfcase>
	<cfcase value="Web">#Replace(Unit, Unit, "WEB", "ALL")#</cfcase>
	<cfcase value="Yrl">#Replace(Unit, Unit, "YRL", "ALL")#	</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- renewals --->
<cfif TotalRenewals IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_green.gif" alt="Renewals" width="9" height="9" border="0"> renewals
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Renewals/TotalRenewals)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%<br><img src="../images/pixel_green.gif" alt="#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="30" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Unit#">
	<cfcase value="Arts">#Replace(Unit, Unit, "ART", "ALL")#</cfcase>
	<cfcase value="Biomed">#Replace(Unit, Unit, "BIO", "ALL")#</cfcase>
	<cfcase value="Clark">#Replace(Unit, Unit, "CLK", "ALL")#</cfcase>
	<cfcase value="Powell">#Replace(Unit, Unit, "POW", "ALL")#</cfcase>
	<cfcase value="East Asian">#Replace(Unit, Unit, "EAL", "ALL")#</cfcase>
	<cfcase value="Law">#Replace(Unit, Unit, "LAW", "ALL")#</cfcase>
	<cfcase value="Management">#Replace(Unit, Unit, "MAN", "ALL")#</cfcase>
	<cfcase value="Music">#Replace(Unit, Unit, "MUS", "ALL")#</cfcase>
	<cfcase value="SEL Chemistry">#Replace(Unit, Unit, "SCH", "ALL")#</cfcase>
	<cfcase value="SEL EMS">#Replace(Unit, Unit, "SEM", "ALL")#</cfcase>
	<cfcase value="SEL Geo">#Replace(Unit, Unit, "SGG", "ALL")#</cfcase>
	<cfcase value="SEL Physics">#Replace(Unit, Unit, "SPH", "ALL")#</cfcase>
	<cfcase value="SRLF">#Replace(Unit, Unit, "SRL", "ALL")#</cfcase>
	<cfcase value="UES">#Replace(Unit, Unit, "UES", "ALL")#</cfcase>
	<cfcase value="Web">#Replace(Unit, Unit, "WEB", "ALL")#</cfcase>
	<cfcase value="Yrl">#Replace(Unit, Unit, "YRL", "ALL")#	</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<br>
<!--- discharges --->
<cfif TotalDischarges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_blue.gif" alt="Renewals" width="9" height="9" border="0"> discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Discharges/TotalDischarges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Discharges/TotalDischarges)*100), "__._")#%<br><img src="../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Discharges/TotalDischarges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="30" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Unit#">
	<cfcase value="Arts">#Replace(Unit, Unit, "ART", "ALL")#</cfcase>
	<cfcase value="Biomed">#Replace(Unit, Unit, "BIO", "ALL")#</cfcase>
	<cfcase value="Clark">#Replace(Unit, Unit, "CLK", "ALL")#</cfcase>
	<cfcase value="Powell">#Replace(Unit, Unit, "POW", "ALL")#</cfcase>
	<cfcase value="East Asian">#Replace(Unit, Unit, "EAL", "ALL")#</cfcase>
	<cfcase value="Law">#Replace(Unit, Unit, "LAW", "ALL")#</cfcase>
	<cfcase value="Management">#Replace(Unit, Unit, "MAN", "ALL")#</cfcase>
	<cfcase value="Music">#Replace(Unit, Unit, "MUS", "ALL")#</cfcase>
	<cfcase value="SEL Chemistry">#Replace(Unit, Unit, "SCH", "ALL")#</cfcase>
	<cfcase value="SEL EMS">#Replace(Unit, Unit, "SEM", "ALL")#</cfcase>
	<cfcase value="SEL Geo">#Replace(Unit, Unit, "SGG", "ALL")#</cfcase>
	<cfcase value="SEL Physics">#Replace(Unit, Unit, "SPH", "ALL")#</cfcase>
	<cfcase value="SRLF">#Replace(Unit, Unit, "SRL", "ALL")#</cfcase>
	<cfcase value="UES">#Replace(Unit, Unit, "UES", "ALL")#</cfcase>
	<cfcase value="Web">#Replace(Unit, Unit, "WEB", "ALL")#</cfcase>
	<cfcase value="Yrl">#Replace(Unit, Unit, "YRL", "ALL")#	</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- total transactions --->
<cfif TotalTransactions IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_orange.gif" alt="Renewals" width="9" height="9" border="0"> charges + renewals + discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((RowTotal/TotalTransactions)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%<br><img src="../images/pixel_orange.gif" alt="#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="30" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetUnit">
<cfif Unit IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Unit#">
	<cfcase value="Arts">#Replace(Unit, Unit, "ART", "ALL")#</cfcase>
	<cfcase value="Biomed">#Replace(Unit, Unit, "BIO", "ALL")#</cfcase>
	<cfcase value="Clark">#Replace(Unit, Unit, "CLK", "ALL")#</cfcase>
	<cfcase value="Powell">#Replace(Unit, Unit, "POW", "ALL")#</cfcase>
	<cfcase value="East Asian">#Replace(Unit, Unit, "EAL", "ALL")#</cfcase>
	<cfcase value="Law">#Replace(Unit, Unit, "LAW", "ALL")#</cfcase>
	<cfcase value="Management">#Replace(Unit, Unit, "MAN", "ALL")#</cfcase>
	<cfcase value="Music">#Replace(Unit, Unit, "MUS", "ALL")#</cfcase>
	<cfcase value="SEL Chemistry">#Replace(Unit, Unit, "SCH", "ALL")#</cfcase>
	<cfcase value="SEL EMS">#Replace(Unit, Unit, "SEM", "ALL")#</cfcase>
	<cfcase value="SEL Geo">#Replace(Unit, Unit, "SGG", "ALL")#</cfcase>
	<cfcase value="SEL Physics">#Replace(Unit, Unit, "SPH", "ALL")#</cfcase>
	<cfcase value="SRLF">#Replace(Unit, Unit, "SRL", "ALL")#</cfcase>
	<cfcase value="UES">#Replace(Unit, Unit, "UES", "ALL")#</cfcase>
	<cfcase value="Web">#Replace(Unit, Unit, "WEB", "ALL")#</cfcase>
	<cfcase value="Yrl">#Replace(Unit, Unit, "YRL", "ALL")#	</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
	</cfcase>

<!--- end graph for unit --->


<!--- start graph for institutional category --->


	<cfcase value="Inst_Type">
<!--- charges --->
<cfif TotalCharges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_red.gif" alt="Charges" width="9" height="9" border="0"> charges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Charges/TotalCharges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%<br><img src="../images/pixel_red.gif" alt="#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Inst_Type#">
	<cfcase value="CSU">&nbsp;&nbsp;&nbsp;&nbsp;CSU&nbsp;&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC">&nbsp;&nbsp;&nbsp;NonUC&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC/SP">&nbsp;NonUC/SP&nbsp;&nbsp;</cfcase>
	<cfcase value="OtherUC">&nbsp;&nbsp;OtherUC&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA">&nbsp;&nbsp;&nbsp;UCLA&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA Related">&nbsp;UCLA Rel.&nbsp;</cfcase>
	<cfcase value="Unknown">&nbsp;&nbsp;Unknown&nbsp;&nbsp;</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- renewals --->
<cfif TotalRenewals IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_green.gif" alt="Charges" width="9" height="9" border="0"> renewals
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Renewals/TotalRenewals)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%<br><img src="../images/pixel_green.gif" alt="#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Inst_Type#">
	<cfcase value="CSU">&nbsp;&nbsp;&nbsp;&nbsp;CSU&nbsp;&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC">&nbsp;&nbsp;&nbsp;NonUC&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC/SP">&nbsp;NonUC/SP&nbsp;&nbsp;</cfcase>
	<cfcase value="OtherUC">&nbsp;&nbsp;OtherUC&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA">&nbsp;&nbsp;&nbsp;UCLA&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA Related">&nbsp;UCLA Rel.&nbsp;</cfcase>
	<cfcase value="Unknown">&nbsp;&nbsp;Unknown&nbsp;&nbsp;</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- discharges --->
<cfif TotalDischarges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_blue.gif" alt="Charges" width="9" height="9" border="0"> discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Discharges/TotalDischarges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Discharges/TotalDischarges)*100), "__._")#%<br><img src="../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Discharges/TotalDischarges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Inst_Type#">
	<cfcase value="CSU">&nbsp;&nbsp;&nbsp;&nbsp;CSU&nbsp;&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC">&nbsp;&nbsp;&nbsp;NonUC&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC/SP">&nbsp;NonUC/SP&nbsp;&nbsp;</cfcase>
	<cfcase value="OtherUC">&nbsp;&nbsp;OtherUC&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA">&nbsp;&nbsp;&nbsp;UCLA&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA Related">&nbsp;UCLA Rel.&nbsp;</cfcase>
	<cfcase value="Unknown">&nbsp;&nbsp;Unknown&nbsp;&nbsp;</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- total transactions --->
<cfif TotalTransactions IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_orange.gif" alt="Charges" width="9" height="9" border="0"> charges + renewals + discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((RowTotal/TotalTransactions)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%<br><img src="../images/pixel_orange.gif" alt="#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetInst_Type">
<cfif Inst_Type IS NOT "Total">
<td align="center" bgcolor="White" class="small">
<cfswitch expression="#Inst_Type#">
	<cfcase value="CSU">&nbsp;&nbsp;&nbsp;&nbsp;CSU&nbsp;&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC">&nbsp;&nbsp;&nbsp;NonUC&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="NonUC/SP">&nbsp;NonUC/SP&nbsp;&nbsp;</cfcase>
	<cfcase value="OtherUC">&nbsp;&nbsp;OtherUC&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA">&nbsp;&nbsp;&nbsp;UCLA&nbsp;&nbsp;&nbsp;</cfcase>
	<cfcase value="UCLA Related">&nbsp;UCLA Rel.&nbsp;</cfcase>
	<cfcase value="Unknown">&nbsp;&nbsp;Unknown&nbsp;&nbsp;</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
		</cfcase>
<!--- end graph for institutional category --->





<!--- start graph for patron category --->
	<cfcase value="Category">
<!--- charges --->
<cfif TotalCharges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_red.gif" alt="Charges" width="9" height="9" border="0"> charges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetCategory">
<cfif Category IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Charges/TotalCharges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%<br><img src="../images/pixel_red.gif" alt="#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="42" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetCategory">
<cfif Category IS NOT "Total">
<td align="center" valign="top" bgcolor="White" class="small">
<cfswitch expression="#Replace(Category, ",", "", "ALL")#">
	<cfcase value="ACADEMIC">ACAD</cfcase>
	<cfcase value="ACCESS ONLY">ACC</cfcase>
	<cfcase value="AP/TRANS ALLIANCE">AP/<br>TRAN</cfcase>
	<cfcase value="EMERITUS">EMER</cfcase>
	<cfcase value="EXT FACULTY">EXT<br>FAC</cfcase>
	<cfcase value="EXT STUDENTS">EXT<br>STU</cfcase>
	<cfcase value="EXTERNAL UNLIMITED">EXTRL</cfcase>
	<cfcase value="FEE 10">FEE10</cfcase>
	<cfcase value="FEE 20">FEE20</cfcase>
	<cfcase value="FEE 5">FEE5</cfcase>
	<cfcase value="FRIENDS">FRNDS</cfcase>
	<cfcase value="GRAD">GRAD</cfcase>
	<cfcase value="ILL">ILL</cfcase>
	<cfcase value="INTERNAL LIBRARY">INTRL</cfcase>
	<cfcase value="LAW GRAD">LAW<BR>GRAD</cfcase>
	<cfcase value="LAW ACADEMIC">LAW<BR>ACAD</cfcase>
	<cfcase value="OTHERS">OTHER</cfcase>
	<cfcase value="RETIRED STAFF">RET<br>STFF</cfcase>
	<cfcase value="STAFF">STFF</cfcase>
	<cfcase value="STUDENT">STU</cfcase>
	<cfcase value="SUMMER SESSION">SUM<br>SESS</cfcase>
	<cfcase value="UCLA ALUMNI">UCLA<br>ALUM</cfcase>
	<cfcase value="UNDERGRAD">UGRAD</cfcase>
	<cfcase value="ASSOCIATES">ASSOC</cfcase>
	<cfcase value="NO GROUP">NO<br>GRP</cfcase>
	<cfcase value="LAW LIBRARY USE ONLY">LAW<br>LBUSE</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- renewals --->
<cfif TotalRenewals IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_green.gif" alt="Charges" width="9" height="9" border="0"> renewals
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetCategory">
<cfif Category IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Renewals/TotalRenewals)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%<br><img src="../images/pixel_green.gif" alt="#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="42" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetCategory">
<cfif Category IS NOT "Total">
<td align="center" valign="top" bgcolor="White" class="small">
<cfswitch expression="#Replace(Category, ",", "", "ALL")#">
	<cfcase value="ACADEMIC">ACAD</cfcase>
	<cfcase value="ACCESS ONLY">ACC</cfcase>
	<cfcase value="AP/TRANS ALLIANCE">AP/<br>TRAN</cfcase>
	<cfcase value="EMERITUS">EMER</cfcase>
	<cfcase value="EXT FACULTY">EXT<br>FAC</cfcase>
	<cfcase value="EXT STUDENTS">EXT<br>STU</cfcase>
	<cfcase value="EXTERNAL UNLIMITED">EXTRL</cfcase>
	<cfcase value="FEE 10">FEE10</cfcase>
	<cfcase value="FEE 20">FEE20</cfcase>
	<cfcase value="FEE 5">FEE5</cfcase>
	<cfcase value="FRIENDS">FRNDS</cfcase>
	<cfcase value="GRAD">GRAD</cfcase>
	<cfcase value="ILL">ILL</cfcase>
	<cfcase value="INTERNAL LIBRARY">INTRL</cfcase>
	<cfcase value="LAW GRAD">LAW<BR>GRAD</cfcase>
	<cfcase value="LAW ACADEMIC">LAW<BR>ACAD</cfcase>
	<cfcase value="OTHERS">OTHER</cfcase>
	<cfcase value="RETIRED STAFF">RET<br>STFF</cfcase>
	<cfcase value="STAFF">STFF</cfcase>
	<cfcase value="STUDENT">STU</cfcase>
	<cfcase value="SUMMER SESSION">SUM<br>SESS</cfcase>
	<cfcase value="UCLA ALUMNI">UCLA<br>ALUM</cfcase>
	<cfcase value="UNDERGRAD">UGRAD</cfcase>
	<cfcase value="ASSOCIATES">ASSOC</cfcase>
	<cfcase value="NO GROUP">NO<br>GRP</cfcase>
	<cfcase value="LAW LIBRARY USE ONLY">LAW<br>LBUSE</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- total transactions --->
<cfif TotalTransactions IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_orange.gif" alt="Disharges" width="9" height="9" border="0"> charges + renewals + disharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetCategory">
<cfif Category IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((RowTotal/TotalTransactions)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%<br><img src="../images/pixel_orange.gif" alt="#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="42" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetCategory">
<cfif Category IS NOT "Total">
<td align="center" valign="top" bgcolor="White" class="small">
<cfswitch expression="#Replace(Category, ",", "", "ALL")#">
	<cfcase value="ACADEMIC">ACAD</cfcase>
	<cfcase value="ACCESS ONLY">ACC</cfcase>
	<cfcase value="AP/TRANS ALLIANCE">AP/<br>TRAN</cfcase>
	<cfcase value="EMERITUS">EMER</cfcase>
	<cfcase value="EXT FACULTY">EXT<br>FAC</cfcase>
	<cfcase value="EXT STUDENTS">EXT<br>STU</cfcase>
	<cfcase value="EXTERNAL UNLIMITED">EXTRL</cfcase>
	<cfcase value="FEE 10">FEE10</cfcase>
	<cfcase value="FEE 20">FEE20</cfcase>
	<cfcase value="FEE 5">FEE5</cfcase>
	<cfcase value="FRIENDS">FRNDS</cfcase>
	<cfcase value="GRAD">GRAD</cfcase>
	<cfcase value="ILL">ILL</cfcase>
	<cfcase value="INTERNAL LIBRARY">INTRL</cfcase>
	<cfcase value="LAW GRAD">LAW<BR>GRAD</cfcase>
	<cfcase value="LAW ACADEMIC">LAW<BR>ACAD</cfcase>
	<cfcase value="OTHERS">OTHER</cfcase>
	<cfcase value="RETIRED STAFF">RET<br>STFF</cfcase>
	<cfcase value="STAFF">STFF</cfcase>
	<cfcase value="STUDENT">STU</cfcase>
	<cfcase value="SUMMER SESSION">SUM<br>SESS</cfcase>
	<cfcase value="UCLA ALUMNI">UCLA<br>ALUM</cfcase>
	<cfcase value="UNDERGRAD">UGRAD</cfcase>
	<cfcase value="ASSOCIATES">ASSOC</cfcase>
	<cfcase value="NO GROUP">NO<br>GRP</cfcase>
	<cfcase value="LAW LIBRARY USE ONLY">LAW<br>LBUSE</cfcase>
</cfswitch>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>



	</cfcase>

<!--- end graph for patron category --->




<!--- start graph for week day --->
	<cfcase value="WeekDay">
<!--- charges --->
<cfif TotalCharges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_red.gif" alt="Charges" width="9" height="9" border="0"> charges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Charges/TotalCharges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%<br><img src="../images/pixel_red.gif" alt="#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
#UCase(RemoveChars(DayOfWeekAsString(WeekDay), 4, Evaluate(Len(DayOfWeekAsString(WeekDay))-3)))#
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- renewals --->
<cfif TotalRenewals IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_green.gif" alt="Discharges" width="9" height="9" border="0"> renewals
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Renewals/TotalRenewals)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%<br><img src="../images/pixel_green.gif" alt="#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
#UCase(RemoveChars(DayOfWeekAsString(WeekDay), 4, Evaluate(Len(DayOfWeekAsString(WeekDay))-3)))#
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- discharges --->
<cfif TotalDischarges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_blue.gif" alt="Discharges" width="9" height="9" border="0"> discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Discharges/TotalDischarges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Discharges/TotalDischarges)*100), "__._")#%<br><img src="../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Discharges/TotalDischarges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
#UCase(RemoveChars(DayOfWeekAsString(WeekDay), 4, Evaluate(Len(DayOfWeekAsString(WeekDay))-3)))#
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- total transactions --->
<cfif TotalTransactions IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_orange.gif" alt="Charges+Renewals+Discharges" width="9" height="9" border="0"> charges + renewals + discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((RowTotal/Total)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((RowTotal/Total)*100), "__._")#%<br><img src="../images/pixel_orange.gif" alt="#NumberFormat(Evaluate((RowTotal/Total)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="14" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetWeekDay">
<cfif WeekDay IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
#UCase(RemoveChars(DayOfWeekAsString(WeekDay), 4, Evaluate(Len(DayOfWeekAsString(WeekDay))-3)))#
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
	</cfcase>



<!--- end graph for week day --->








<!--- start graph for month --->
	<cfcase value="Month">
<!--- charges --->
<cfif TotalCharges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_red.gif" alt="Charges" width="9" height="9" border="0"> charges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Charges/TotalCharges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%<br><img src="../images/pixel_red.gif" alt="#NumberFormat(Evaluate((Charges/TotalCharges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="24" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
<cfif Len(MonthAsString(Month)) GT 3>
#UCase(RemoveChars(MonthAsString(Month), 4, Evaluate(Len(MonthAsString(Month))-3)))#
<cfelse>
#UCase(MonthAsString(Month))#
</cfif>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>


<br>


<!--- renewals --->
<cfif TotalRenewals IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_green.gif" alt="Renewals" width="9" height="9" border="0"> renewals
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Renewals/TotalRenewals)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%<br><img src="../images/pixel_green.gif" alt="#NumberFormat(Evaluate((Renewals/TotalRenewals)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="24" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
<cfif Len(MonthAsString(Month)) GT 3>
#UCase(RemoveChars(MonthAsString(Month), 4, Evaluate(Len(MonthAsString(Month))-3)))#
<cfelse>
#UCase(MonthAsString(Month))#
</cfif>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- discharges --->
<cfif TotalDischarges IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_blue.gif" alt="Discharges" width="9" height="9" border="0"> discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((Discharges/TotalDischarges)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((Discharges/TotalDischarges)*100), "__._")#%<br><img src="../images/pixel_blue.gif" alt="#NumberFormat(Evaluate((Renewals/TotalDischarges)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="24" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
<cfif Len(MonthAsString(Month)) GT 3>
#UCase(RemoveChars(MonthAsString(Month), 4, Evaluate(Len(MonthAsString(Month))-3)))#
<cfelse>
#UCase(MonthAsString(Month))#
</cfif>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
<br>
<!--- total transactions --->
<cfif TotalTransactions IS NOT 0>
<table>
<tr>
	<td width="30" class="small">&nbsp;</td>
	<td class="small">
<img src="../images/pixel_orange.gif" alt="Total transactions" width="9" height="9" border="0"> charges + renewals + discharges
	</td>
</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" background="../images/bg_graph.gif">
<tr valign="bottom">
	<td height="200" rowspan="2" bgcolor="#FFFFFF">
		<table height="200" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="66" align="right" valign="top" class="small">100%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="middle" class="small">50%&nbsp;</td></tr>
		<tr><td height="66" align="right" valign="bottom" class="small">0%&nbsp;</td></tr>
		</table>
	</td>
	<td height="1" rowspan="2" bgcolor="#000000"><img src="../images/1x1.gif" height="1" border="0"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
		<cfset BarHeight = #Round(Evaluate((RowTotal/TotalTransactions)*200))#>
	<td height="200" align="center" nowrap class="small">#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%<br><img src="../images/pixel_orange.gif" alt="#NumberFormat(Evaluate((RowTotal/TotalTransactions)*100), "__._")#%" width="40" height="#BarHeight#" border="0"></td>
	<td align="center" nowrap class="small"><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
<tr>
	<td height="1" colspan="24" bgcolor="Black"><img src="../images/1x1.gif" height="1" border="0"></td>
</tr>
<tr>
	<td bgcolor="#FFFFFF"></td>
	<td align="center" nowrap class="small" bgcolor="Black"><img src="../images/1x1.gif" width="1"></td>
<cfoutput query="GetMonth">
<cfif Month IS NOT "Total">
	<td align="center" bgcolor="White" class="small">
<cfif Len(MonthAsString(Month)) GT 3>
#UCase(RemoveChars(MonthAsString(Month), 4, Evaluate(Len(MonthAsString(Month))-3)))#
<cfelse>
#UCase(MonthAsString(Month))#
</cfif>
	</td>
	<td align="center" nowrap class="small" bgcolor="##000000""><img src="../images/1x1.gif" width="1"></td>
</cfif>
</cfoutput>
</tr>
</table>
</cfif>
	</cfcase>
<!--- end graph for month --->


</cfswitch>
<!--- end graph --->


</cfif>

<cfif PrintFormat IS "Yes">
</body>
</HTML>
<cfelse>
	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_nonav_txt.cfm">
	</cfif>
</cfif>