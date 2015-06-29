<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
SELECT  U.UnitID,
        U.Title,
        UC.CatID,
        SC.Descrpt AS CatDescrpt,
        SG.GroupID,
        SG.Descrpt AS GroupDescrpt
FROM Unit U

JOIN UnitCategory UC
ON U.UnitID = UC.UnitID

JOIN StatCategory SC
ON UC.CatID = SC.CatID

JOIN StatGroupCategory SGC
ON SC.CatID = SGC.CatID

JOIN StatGroup SG
ON SGC.GroupID = SG.GroupID


WHERE UC.UnitID = <cfoutput>#UnitID#</cfoutput>

<cfif #Find("validate.cfm", CF_TEMPLATE_PATH)#>
AND SC.CatID IN (
	<cfoutput>
		<cfif Action IS "Insert">
			<cfset i = 1>
			<CFLOOP COLLECTION="#CategoryValue#" ITEM="CategoryID">
			<cfif i IS 1>
				  #Replace(LCase(CategoryID), "cat", "", "ALL")#
			<cfelseif i GT 1>
				, #Replace(LCase(CategoryID), "cat", "", "ALL")#
			</cfif>
			<cfset i = i + 1>
			</cfloop>	
		<cfelseif Action IS "Update" OR Action IS "Delete">
			#CatID#
		</cfif>
	</cfoutput>
)
</cfif>

ORDER BY SG.SortOrder, SC.Descrpt




</cfquery>