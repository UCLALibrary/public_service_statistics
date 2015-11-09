<cfif NOT IsDefined("ReportType")>
	<cflocation url="index.cfm" addtoken="No">
	<cfabort>
</cfif>
<cfparam name="text" default="No">
<cfparam name="ReportType" default=0>
<cfparam name="flag" default="0">
<cfparam name="SortColumn" default="">
<cfparam name="SortOrder" default="0">

<cfif IsDefined("URL.UnitID")>
	<cfset UnitID = "#URL.UnitID#">
	<cfset UnitSpecified = 1>
<cfelse>
	<cfset UnitSpecified = 0>
</cfif>
<cfif IsDefined("URL.Level")>
	<cfset Level = "#URL.Level#">
	<cfset LevelSpecified = 1>
<cfelse>
	<cfset LevelSpecified = 0>
</cfif>

<cfif SortOrder IS 1>
  <cfset SortOrder=0>
<cfelseif SortOrder IS 0>
  <cfset SortOrder=1>
</cfif>

<cfswitch expression="#ReportType#">
  <cfcase value="1">
    <cfquery name="GetDataCollectionMethod" DATASOURCE="#CircStatsDSN#">
    SELECT DISTINCT Unit + ' ' + ServicePoint AS 'UnitServicePoint',
         CASE WHEN InputMethodID = 2 THEN 'Real-time' ELSE 'Monthly' END AS 'InputMethod'
    FROM View_RefUnitCategory
    </cfquery>
	<cfquery name="SortDataCollectionMethod" dbtype="query">
	SELECT *
	FROM GetDataCollectionMethod
    <cfif SortColumn IS NOT "">
	ORDER BY #SortColumn#
      <cfif SortOrder IS 1>
	  ASC
	  <cfelseif SortOrder IS 0>
	  DESC
	  </cfif>
	  <cfif SortColumn IS "InputMethod">
	  , UnitServicePoint ASC
	  <cfelseif SortColumn IS "UnitServicePoint">
	  , InputMethod ASC
	  </cfif>
	</cfif>
	</cfquery>
    <cfset ReportTitle = "Data collection methods for units/service points">
  </cfcase>

  <cfcase value="2">
    <cfquery name="GetUnitDataProfile" DATASOURCE="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,4,0,0)#">
SELECT DISTINCT SUBSTRING(RS.AggregateID, 1, 7) AS 'UnitPointID',
       RU.Descrpt + ' ' + RSP.Descrpt AS 'UnitServicePoint',
       CASE
         WHEN RS.InputMethod = 1 THEN MIN(CAST(CAST(dataMonth AS VARCHAR) + '/1/' + CAST(dataYear AS VARCHAR) AS SMALLDATETIME))
         WHEN RS.InputMethod = 2 THEN MIN(RS.Created_DT)
         ELSE NULL
       END AS 'Start',
       CASE
         WHEN RS.InputMethod = 1 THEN MAX(CAST(CAST(dataMonth AS VARCHAR) + '/1/' + CAST(dataYear AS VARCHAR) AS SMALLDATETIME))
         WHEN RS.InputMethod = 2 THEN MAX(RS.Updated_DT)
         ELSE NULL
       END AS 'End',
       CASE
         WHEN RS.InputMethod = 1 THEN 'Monthly'
         WHEN RS.InputMethod = 2 THEN 'Real-time'
         ELSE NULL
       END AS 'InputMethod'
       FROM ReferenceStatistics RS
JOIN RefUnitCategory RUC ON RUC.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefUnit RU ON RU.UnitID = SUBSTRING(RS.AggregateID, 1, 5)
JOIN RefServicePoint RSP ON RSP.PointID = SUBSTRING(RS.AggregateID, 6, 2)
GROUP BY SUBSTRING(RS.AggregateID, 1, 7), RU.Descrpt, RSP.Descrpt, RS.InputMethod

UNION ALL

SELECT DISTINCT RUC.UnitID + RUC.PointID AS 'UnitPointID',
       RU.Descrpt  + ' ' +  RSP.Descrpt AS 'UnitServicePoint',
       NULL AS 'Start',
       NULL AS 'End',
       CASE
         WHEN RPM.InputMethodID = 1 THEN 'Monthly'
         WHEN RPM.InputMethodID = 2 THEN 'Real-time'
         ELSE NULL
       END AS 'InputMethod'
FROM RefUnitCategory RUC
JOIN RefUnit RU ON RU.UnitID = RUC.UnitID
JOIN RefServicePoint RSP ON RSP.PointID = RUC.PointID
JOIN RefPointMethod RPM ON RPM.UnitPointID = CAST(RU.UnitID + RSP.PointID AS VARCHAR)
WHERE RUC.UnitID NOT IN (
        SELECT SUBSTRING(RS.AggregateID, 1, 5)
        FROM ReferenceStatistics RS
)

ORDER BY UnitServicePoint
    </cfquery>
    <cfset ReportTitle = "Data availability by unit/service points ">
  </cfcase>
</cfswitch>



<HTML>
<HEAD>
<TITLE>UCLA Library Reference Statistics: Facts and Figures</TITLE>
<LINK REL=STYLESHEET HREF="../../css/main.css" TYPE="text/css">
</head>

<BODY>
<!--begin main content-->

<h3><cfoutput>#ReportTitle#</cfoutput></h3>

<cfswitch expression="#ReportType#">
  <cfcase value="1">
<table width="400"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr bgcolor="#CCCCCC">
    <cfoutput>
  <td nowrap class="tblcopy"><strong><a href="facts.cfm?ReportType=#ReportType#&SortOrder=#SortOrder#&SortColumn=UnitServicePoint">Unit/service point</a></strong></td>
  <td nowrap class="tblcopy"><strong><a href="facts.cfm?ReportType=#ReportType#&SortOrder=#SortOrder#&SortColumn=InputMethod">Data collection method</a></strong></td>
    </cfoutput>
</tr>

<cfoutput query="SortDataCollectionMethod">
<tr bgcolor="##EBF0F7">
  <td nowrap class="tblcopy">#UnitServicePoint#</td>
  <td nowrap class="tblcopy">#InputMethod#</td>
</tr>
</cfoutput>
</table>

  </cfcase>

  <cfcase value="2">

<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr bgcolor="#CCCCCC">
  <td nowrap bgcolor="#FFFFFF" class="tblcopy"><strong>&nbsp;</strong></td>
  <td colspan="2" nowrap class="tblcopy"><strong>Data available:</strong></td>
  <td nowrap bgcolor="#FFFFFF" class="tblcopy"><strong>&nbsp;</strong></td>
</tr>
<tr bgcolor="#CCCCCC">
  <td nowrap class="tblcopy"><strong>Unit/service point</strong></td>
  <td nowrap class="tblcopy"><strong>From:</strong></td>
  <td nowrap class="tblcopy"><strong>To:</strong></td>
  <td nowrap class="tblcopy"><strong>Data collection method</strong></td>
</tr>
<cfoutput query="GetUnitDataProfile">
<tr
<cfif UnitSpecified AND LevelSpecified>
	<cfif Level IS "Unit">
		<cfif Left(UnitPointID, 3) IS UnitID>
		bgcolor="##FFFFCC"
		<cfelse>
		bgcolor="##EBF0F7"
		</cfif>
	<cfelseif Level IS "SubUnit">
		<cfif Left(UnitPointID, 5) IS UnitID>
		bgcolor="##FFFFCC"
		<cfelse>
		bgcolor="##EBF0F7"
		</cfif>
    </cfif>
<cfelse>
bgcolor="##EBF0F7"
</cfif>>
  <td nowrap class="tblcopy">#UnitServicePoint#</td>
  <td nowrap class="tblcopy" <cfif Start IS "">colspan="2"</cfif>>
  <cfif Start IS NOT "">
    <cfif InputMethod IS "Real-time">
      #DateFormat(Start, 'm/d/yyyy')# #TimeFormat(Start, 'hh:mm tt')#
    <cfelseif InputMethod IS "Monthly">
      #DateFormat(Start, 'm/yyyy')#
    </cfif>
  <cfelse>
    <span class="red">no data available</span>
  </cfif>
  </td>

  <cfif Start IS NOT "">
  <td nowrap class="tblcopy">
    <cfif InputMethod IS "Real-time">
    #DateFormat(End, 'm/d/yyyy')# #TimeFormat(End, 'hh:mm tt')#
    <cfelseif InputMethod IS "Monthly">
    #DateFormat(End, 'm/yyyy')#
    </cfif>
   </td>
   </cfif>
  <td nowrap class="tblcopy">#InputMethod#</td>
</tr>
</cfoutput>
</table>

  </cfcase>
</cfswitch>


</BODY>
</HTML>