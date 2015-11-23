<CFQUERY NAME="GetReferenceStatistics" DATASOURCE="#CircStatsDSN#">
SELECT * FROM view_ReferenceStatistics
ORDER BY Created_DT DESC
</CFQUERY>

<CFQUERY NAME="GetServicePointTotal" DATASOURCE="#CircStatsDSN#">
SELECT SUM([Count]) AS Total,
       ServicePoint
FROM View_ReferenceStatistics
GROUP BY ServicePoint
ORDER BY Total DESC
</CFQUERY>

<CFQUERY NAME="GetQuestionTypeTotal" DATASOURCE="#CircStatsDSN#">
SELECT SUM([Count]) AS Total,
       QuestionType
FROM View_ReferenceStatistics
GROUP BY QuestionType
ORDER BY Total DESC
</CFQUERY>

<CFQUERY NAME="GetModeTotal" DATASOURCE="#CircStatsDSN#">
SELECT SUM([Count]) AS Total,
       Mode
FROM View_ReferenceStatistics
GROUP BY Mode
ORDER BY Total DESC
</CFQUERY>

<HTML>
<HEAD>
	<TITLE>view_ReferenceStatistics</TITLE>
<LINK REL=STYLESHEET HREF="../css/main.css" TYPE="text/css">
</HEAD>

<BODY>


<table width="100%"
       border="1"
       cellspacing="0"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td class="tblcopy"><strong>Unit</td>
	<td class="tblcopy"><strong>ServicePoint</strong></td>
	<td class="tblcopy"><strong>QuestionType</strong></td>
	<td class="tblcopy"><strong>Mode</strong></td>
	<td class="tblcopy"><strong>Count</strong></td>
	<td class="tblcopy"><strong>Mo</strong></td>
	<td class="tblcopy"><strong>Yr</strong></td>
	<td class="tblcopy"><strong>Created_DT</strong></td>
	<td class="tblcopy"><strong>Updated_DT</strong></td>
	<td class="tblcopy"><strong>InputMethod</strong></td>
</tr>


<cfoutput query="GetReferenceStatistics">
<tr valign="bottom">
	<td class="tblcopy">#Unit#</td>
	<td class="tblcopy">#ServicePoint#</td>
	<td class="tblcopy">#QuestionType#</td>
	<td class="tblcopy">#Mode#</td>
	<td class="tblcopy">#Count#</td>
	<td class="tblcopy">#dataMonth#</td>
	<td class="tblcopy">#dataYear#</td>
	<td class="tblcopy">#Created_DT#</td>
	<td class="tblcopy">#Updated_DT#</td>
	<td class="tblcopy">#InputMethod#</td>
</tr>
</CFOUTPUT>

</table>

<br><br>

<table border="1"
       cellspacing="0"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td class="tblcopy"><strong>Service Point</strong></td>
	<td class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetServicePointTotal">
<tr valign="bottom">
	<td class="tblcopy">#ServicePoint#</td>
	<td class="tblcopy">#Total#</td>
</tr>
</cfoutput>

<tr valign="bottom" bgcolor="#EBF0F7">
	<td class="tblcopy"><strong>Question Type</strong></td>
	<td class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetQuestionTypeTotal">
<tr valign="bottom">
	<td class="tblcopy">#QuestionType#</td>
	<td class="tblcopy">#Total#</td>
</tr>
</cfoutput>


<tr valign="bottom" bgcolor="#EBF0F7">
	<td class="tblcopy"><strong>Mode</strong></td>
	<td class="tblcopy"><strong>Total</strong></td>
</tr>
<cfoutput query="GetModeTotal">
<tr valign="bottom">
	<td class="tblcopy">#Mode#</td>
	<td class="tblcopy">#Total#</td>
</tr>
</cfoutput>



</table>


</BODY>
</HTML>
