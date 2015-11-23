<CFPARAM NAME = "Text" DEFAULT = "No">
<CFPARAM NAME = "PrintFormat" DEFAULT = "no">
<cfset UnitID = 7>

<cfinclude template="../queries/qryGetUnit.cfm">
<cfset UnitCode = "#GetUnit.Code#">

<cfinclude template="../queries/qryDateParameters.cfm">
<cfinclude template="../queries/qryGetCharges.cfm">
<cfinclude template="../queries/qryGetAutoCircStats.cfm">
<cfinclude template="../queries/qryGetManualStats.cfm">

<cfquery name="GetTurnstileTotal" datasource="#CircStatsDSN#">
SELECT Title=IsNull(Title, 'TOTAL'),
<cfinclude template="../queries/qryFiscalMonthYear.cfm">
FROM View_ManualStatistics
WHERE Code = '<cfoutput>#UnitCode#</cfoutput>'
AND CatID IN (48,49)
GROUP BY Title
WITH ROLLUP
</cfquery>

<cfquery name="GetEquipmentTotal" datasource="#CircStatsDSN#">
SELECT Title=IsNull(Title, 'TOTAL'),
<cfinclude template="../queries/qryFiscalMonthYear.cfm">
FROM View_ManualStatistics
WHERE Code = '<cfoutput>#UnitCode#</cfoutput>'
AND CatID IN (17,7)
GROUP BY Title
WITH ROLLUP
</cfquery>
<html>
<head>
	<title>UCLA Library Public Service Statistics Report: <cfoutput>#GetUnit.Title#</cfoutput></title>

<cfif PrintFormat IS "Yes">
	<LINK REL=STYLESHEET HREF="../css/main.css" TYPE="text/css">
	</HEAD>
	<BODY BGCOLOR="#FFFFFF">
<cfelse>
	<cfif Text IS "No">
		<cfinclude template="../../library_pageincludes/banner_nonav.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<cfinclude template="../../library_pageincludes/banner_txt.cfm">
	</cfif>


<a name="top"></a>

<!--begin you are here-->

<a href="../home.cfm">Public Service Statistics</a> &gt; Statistics Summary Report for <cfoutput>#GetUnit.Title#</cfoutput>

<!-- end you are here -->

<cfinclude template="../../library_pageincludes/start_content_nonav.cfm">

</cfif>

<!--begin main content-->

<h1>Public Service Statistics Report: <cfoutput>#GetUnit.Title#</cfoutput> <sup><a href="#footnote">*</a></sup></h1>

<cfinclude template="../templates/capCoverageDate.cfm">

<cfif PrintFormat IS NOT "Yes">
	<cfoutput>
<span class="small">
	<cfif GetUnit.UnitID IS NOT 9 AND
	      GetUnit.UnitID IS NOT 10 AND
		  GetUnit.UnitID IS NOT 11 AND
		  GetUnit.UnitID IS NOT 12>
		<cfif Text IS "No">
<a href="#Replace(LCase(GetUnit.Code), "url", "yrl", "ALL")#.cfm?PrintFormat=Yes"><img src="../images/printer.gif" alt="Format for printing" width="20" height="20" border="0" align="absmiddle"></a>
		</cfif>
<a href="#Replace(LCase(GetUnit.Code), "url", "yrl", "ALL")#.cfm?PrintFormat=Yes">Format for printing</a>
	<cfelseif GetUnit.UnitID IS 9 OR
	      GetUnit.UnitID IS 10 OR
		  GetUnit.UnitID IS 11 OR
		  GetUnit.UnitID IS 12>
		<cfif Text IS "No">
<a href="../reports/sel.cfm?UnitID=#GetUnit.UnitID#&PrintFormat=Yes"><img src="../images/printer.gif" alt="Format for printing" width="20" height="20" border="0" align="absmiddle"></a>
		</cfif>
<a href="../reports/sel.cfm?UnitID=#GetUnit.UnitID#&PrintFormat=Yes">Format for Printing</a>
	</cfif>
</span>
	</cfoutput>
</cfif>

<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="top" bgcolor="#CCCCCC">
	<td bgcolor="#FFFFFF" class="small">&nbsp;</td>
	<td align="right" class="small"><b><cfoutput>FY #PrevFYStart#</cfoutput> YTD</b></td>
	<td align="right" class="small"><b><cfoutput>FY #CurrFYStart#</cfoutput> YTD</b></td>
	<td align="right" class="small"><b>Difference</b></td>
	<td align="center" nowrap class="small"><b>%Change</b></td>
	<td align="right" class="small"><b><cfoutput>#MonthAsString(dataMonth)# FY #PrevFYStart#</cfoutput></b></td>
	<td align="right" class="small"><b><cfoutput>#MonthAsString(dataMonth)# FY #CurrFYStart#</cfoutput></b></td>
	<td align="right" class="small"><b>Difference</b></td>
	<td align="center" nowrap class="small"><b>%Change</b></td>
</tr>
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Circulation Transactions</b></td>
</tr>

<!--- charges --->
<cfoutput query="GetCharges">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">
	<cfswitch expression="#Descrpt#">
		<cfcase value="CHARGE">
	ORION charge outs
		</cfcase>
		<cfcase value="MANCHARGE">
	Manual charge outs
		</cfcase>
		<cfcase value="TOTAL">
	Total charge outs
		</cfcase>
	</cfswitch>
	</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
</cfoutput>

<!--- other auto circ stats --->
<cfoutput query="GetAutoCircStats">
<cfif Descrpt IS "RENEWAL" OR
	  Descrpt IS "DISCHARGE" OR
	  Descrpt IS "HOLDPLCD" OR
	  Descrpt IS "HOLDFULL">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
</cfif>
</cfoutput>


<!--- searches --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Searches</b></td>
</tr>
<cfoutput query="GetManualGroup8">
<cfif Title IS NOT "TOTAL" AND Title IS NOT "DUMMYTOTAL">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
</cfif>
</cfoutput>

<!--- overdue and billed items --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Overdue and billed items</b></td>
</tr>

<cfoutput query="GetAutoCircStats">
<cfif Descrpt IS "OVERDUE" OR
	  Descrpt IS "FINE" OR
	  Descrpt IS "BILL" OR
	  Descrpt IS "BILLCNCLD" OR
	  Descrpt IS "LOSTITEM">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
</cfif>
</cfoutput>

<!--- library cards --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Library cards</b></td>
</tr>

<cfoutput query="GetAutoCircStats">
<cfif Descrpt IS "LIBCARD">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
</cfif>
</cfoutput>


<!--- shelving --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Shelving</b></td>
</tr>
<cfoutput query="GetManualGroup9">
<cfif Title IS NOT "TOTAL">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
</cfif>
</cfoutput>

<cfloop query="GetManualGroup9">
	<cfif Title IS "TOTAL">
		<cfset TOTALExists = 1>
		<cfbreak>
	<cfelse>
		<cfset TOTALExists = 0>
	</cfif>
</cfloop>

<cfif TOTALExists IS 1>
	<cfoutput query="GetManualGroup9">
		<cfif Title IS "TOTAL">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">Total items shelved</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
		</cfif>
	</cfoutput>
<cfelse>
<tr valign="top" bgcolor="#EBF0F7">
	<td class="small">Total items shelved</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
</tr>
</cfif>

<!--- paging --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Paging</b></td>
</tr>
<cfoutput query="GetManualGroup6">
<cfif Title IS NOT "TOTAL">
<tr valign="top" bgcolor="##EBF0F7"><td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#Evaluate(CurrFYMonth - PrevFYMonth)#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif></td>
</tr>
</cfif>
</cfoutput>

<!--- reserves --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Reserves</b></td>
</tr>
<cfoutput query="GetManualGroup7">
<cfif Title IS NOT "TOTAL">
<tr valign="top" bgcolor="##EBF0F7"><td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#Evaluate(CurrFYMonth - PrevFYMonth)#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif></td>
</tr>
</cfif>
</cfoutput>


<!--- building statistics --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Building Statistics</b></td>
</tr>
<cfoutput query="GetManualGroup1">
<cfif Title IS NOT "TOTAL">
<tr valign="top" bgcolor="##EBF0F7"><td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#Evaluate(CurrFYMonth - PrevFYMonth)#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif></td>
</tr>
</cfif>
</cfoutput>

<cfloop query="GetTurnstileTotal">
	<cfif Title IS "TOTAL">
		<cfset TOTALExists = 1>
		<cfbreak>
	<cfelse>
		<cfset TOTALExists = 0>
	</cfif>
</cfloop>

<cfif TOTALExists IS 1>
	<cfoutput query="GetTurnstileTotal">
		<cfif Title IS "TOTAL">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">Total turnstile count</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
		</cfif>
	</cfoutput>
<cfelse>
<tr valign="top" bgcolor="#EBF0F7">
	<td class="small">Total turnstile count</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
</tr>
</cfif>

<!--- facilities activities --->
<tr valign="top" bgcolor="#CCCCCC">
	<td colspan="9" class="small"><b>Facilities activities</b></td>
</tr>
<cfoutput query="GetManualGroup3">
<cfif Title IS NOT "TOTAL" AND Title IS NOT "Ports checked">
<tr valign="top" bgcolor="##EBF0F7"><td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#Evaluate(CurrFYMonth - PrevFYMonth)#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif></td>
</tr>
</cfif>
</cfoutput>


<cfloop query="GetEquipmentTotal">
	<cfif Title IS "TOTAL">
		<cfset TOTALExists = 1>
		<cfbreak>
	<cfelse>
		<cfset TOTALExists = 0>
	</cfif>
</cfloop>

<cfif TOTALExists IS 1>
	<cfoutput query="GetEquipmentTotal">
		<cfif Title IS "TOTAL">
<tr valign="top" bgcolor="##EBF0F7">
	<td class="small">Total equipment service requests</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(CurrFYMonth - PrevFYMonth), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif>
	</td>
</tr>
		</cfif>
	</cfoutput>
<cfelse>
<tr valign="top" bgcolor="#EBF0F7">
	<td class="small">Total equipment service requests</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
    <td align="right" class="small">NA</td>
</tr>
</cfif>

<cfoutput query="GetManualGroup3">
<cfif Title IS "Ports checked">
<tr valign="top" bgcolor="##EBF0F7"><td class="small">#Title#</td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(PrevFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT ''>#NumberFormat(CurrFY, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(CurrFY-PrevFY), "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFY IS NOT '' AND  CurrFY IS NOT ''>#NumberFormat(Evaluate(((CurrFY - PrevFY) / PrevFY) * 100), "999999.9")#%<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT ''>#NumberFormat(PrevFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif CurrFYMonth IS NOT ''>#NumberFormat(CurrFYMonth, "_,___,___")#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#Evaluate(CurrFYMonth - PrevFYMonth)#<cfelse>NA</cfif></td>
    <td align="right" class="small"><cfif PrevFYMonth IS NOT '' AND  CurrFYMonth IS NOT ''>#NumberFormat(Evaluate(((CurrFYMonth - PrevFYMonth) / PrevFYMonth) * 100), "999999.9")#%<cfelse>NA</cfif></td>
</tr>
</cfif>
</cfoutput>
</table>


<cfinclude template="../templates/tmpFootNote.cfm">
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
