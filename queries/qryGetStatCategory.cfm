<cfquery name="GetStatCategory" datasource="#CircStatsDSN#">
<cfoutput>
SELECT  UC.UnitID,
        SC.CatID,
        SC.Descrpt

FROM UnitCategory UC

JOIN StatCategory SC
ON SC.CatID = UC.CatID

WHERE UC.UnitID = #UnitID#

	<cfif Find("validate.cfm", CF_TEMPLATE_PATH)>
AND UC.CatID = #CatID#
	</cfif>

ORDER BY Descrpt
</cfoutput>
</cfquery>




