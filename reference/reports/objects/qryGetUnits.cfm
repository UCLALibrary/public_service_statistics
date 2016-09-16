<cfquery name="GetParentUnit" datasource="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
SELECT DISTINCT SUBSTRING(UnitID, 1, 3) AS ParentUnitID,
	   CASE
	   WHEN SUBSTRING(UnitID, 1, 3) = 'ART' THEN 'Arts'
       WHEN SUBSTRING(UnitID, 1, 3) = 'BIO' THEN 'Biomed'
       WHEN SUBSTRING(UnitID, 1, 3) = 'CLK' THEN 'Clark'
       WHEN SUBSTRING(UnitID, 1, 3) = 'COL' THEN 'Powell'
       WHEN SUBSTRING(UnitID, 1, 3) = 'EAL' THEN 'East Asian'
       WHEN SUBSTRING(UnitID, 1, 3) = 'LAW' THEN 'Law'
       WHEN SUBSTRING(UnitID, 1, 3) = 'MAN' THEN 'Management'
       WHEN SUBSTRING(UnitID, 1, 3) = 'MUS' THEN 'Music'
       WHEN SUBSTRING(UnitID, 1, 3) = 'RBR' THEN 'Rieber'
       WHEN SUBSTRING(UnitID, 1, 3) = 'SEL' THEN 'SEL'
       WHEN SUBSTRING(UnitID, 1, 3) = 'SRL' THEN 'SRLF'
       WHEN SUBSTRING(UnitID, 1, 3) = 'YRL' THEN 'YRL'
       WHEN SUBSTRING(UnitID, 1, 3) = 'DLP' THEN 'DLP'
       WHEN SUBSTRING(UnitID, 1, 3) = 'SSD' THEN 'Social Science Data Archive'
       ELSE NULL
       END AS "ParentUnit"
FROM RefUnit
WHERE UnitID <> 'ADM00'  AND Active = 1
<cfif Step GT 1>
  <cfif Level IS "Unit">
AND SUBSTRING(UnitID, 1, 3) = '<cfoutput>#UnitID#</cfoutput>'
    <cfelseif Level IS "SubUnit">
AND SUBSTRING(UnitID, 1, 3) = '<cfoutput>#Left(UnitID, 3)#</cfoutput>'
  </cfif>
</cfif>
ORDER BY ParentUnitID ASC
</cfquery>
<cfset LibCount = GetParentUnit.RecordCount>
<cfquery name="GetParentSubUnit" datasource="#CircStatsDSN#" cachedwithin="#CreateTimeSpan(0,0,10,0)#">
SELECT UnitID,
	   CASE
	   WHEN SUBSTRING(UnitID, 1, 3) = 'ART' THEN 'Arts'
       WHEN SUBSTRING(UnitID, 1, 3) = 'BIO' THEN 'Biomed'
       WHEN SUBSTRING(UnitID, 1, 3) = 'CLK' THEN 'Clark'
       WHEN SUBSTRING(UnitID, 1, 3) = 'COL' THEN 'Powell'
       WHEN SUBSTRING(UnitID, 1, 3) = 'EAL' THEN 'East Asian'
       WHEN SUBSTRING(UnitID, 1, 3) = 'LAW' THEN 'Law'
       WHEN SUBSTRING(UnitID, 1, 3) = 'MAN' THEN 'Management'
       WHEN SUBSTRING(UnitID, 1, 3) = 'MUS' THEN 'Music'
       WHEN SUBSTRING(UnitID, 1, 3) = 'RBR' THEN 'Rieber'
       WHEN SUBSTRING(UnitID, 1, 3) = 'SEL' THEN 'SEL'
       WHEN SUBSTRING(UnitID, 1, 3) = 'SRL' THEN 'SRLF'
       WHEN SUBSTRING(UnitID, 1, 3) = 'YRL' THEN 'YRL'
       WHEN SUBSTRING(UnitID, 1, 3) = 'DLP' THEN 'DLP'
       WHEN SUBSTRING(UnitID, 1, 3) = 'SSD' THEN 'Social Science Data Archive'
       ELSE NULL
       END AS "ParentUnit",
       CASE
       WHEN UnitID = 'ART00' THEN 'Arts'
       WHEN UnitID = 'ART01' THEN 'Special Collections'
       WHEN UnitID = 'BIO01' THEN 'Access Delivery Services'
       WHEN UnitID = 'BIO02' THEN 'History and Special Collections'
       WHEN UnitID = 'BIO03' THEN 'IMF/LRD'
       WHEN UnitID = 'BIO04' THEN 'Reference'
       WHEN UnitID = 'CLK00' THEN 'Clark'
       WHEN UnitID = 'COL00' THEN 'Powell'
       WHEN UnitID = 'EAL00' THEN 'East Asian'
       WHEN UnitID = 'LAW00' THEN 'Law'
       WHEN UnitID = 'MAN00' THEN 'Management'
       WHEN UnitID = 'MUS00' THEN 'Music'
       WHEN UnitID = 'MUS01' THEN 'Special Collections'
       WHEN UnitID = 'RBR00' THEN 'Rieber'
       WHEN UnitID = 'SEL01' THEN 'EMS'
       WHEN UnitID = 'SEL02' THEN 'Chemistry'
       WHEN UnitID = 'SEL03' THEN 'Geology/Geophysics'
       WHEN UnitID = 'SEL04' THEN 'Physics'
       WHEN UnitID = 'SRL00' THEN 'SRLF'
       WHEN UnitID = 'YRL05' THEN 'Collection Management Department'
       WHEN UnitID = 'YRL03' THEN 'Special Collections'
       WHEN UnitID = 'YRL06' THEN 'Special Collections Thesis and Dissertation Advisor'
       WHEN UnitID = 'YRL04' THEN 'Special Collections University Archives'
       WHEN UnitID = 'YRL02' THEN 'Reference and Instructional Services'
       WHEN UnitID = 'YRL07' THEN 'Access Services'
       WHEN UnitID = 'YRL08' THEN 'CRIS'
       ELSE NULL
       END AS "SubUnit"
FROM RefUnit
WHERE UnitID <> 'ADM00'
<cfif Step GT 1 AND Level IS "SubUnit">
AND UnitID = '<cfoutput>#UnitID#</cfoutput>'
</cfif>
ORDER BY UnitID ASC
</cfquery>














