<cfquery name="GetReferringURL" datasource="#CircStatsDSN#">
SELECT *
FROM HTTP
WHERE HTTP_ID = 2
</cfquery>