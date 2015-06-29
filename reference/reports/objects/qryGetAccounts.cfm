<!---cfquery name="GetAccounts" datasource="#CircStatsDSN#">
SELECT DISTINCT
       LOWER(RS.LogonID) AS 'LogonID',
       RUA.LastName AS 'LastName',
       RUA.FirstName AS 'FirstName',
       RUA.AccountType AS 'AccountType'
FROM ReferenceStatistics RS
JOIN RefUserAccounts RUA ON RUA.LogonID = RS.LogonID
WHERE InputMethod = 2
AND RS.LogonID = '<cfoutput>#LogonID#</cfoutput>'
ORDER BY AccountType, LastName, FirstName
</cfquery--->

<cfquery name="GetAccounts" datasource="#CircStatsDSN#">
SELECT LOWER(LogonID) AS LogonID,
       LastName,
       FirstName,
	   AccountType
FROM RefUserAccounts
WHERE LogonID = '<cfoutput>#LogonID#</cfoutput>'
</cfquery>















