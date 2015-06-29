<cfquery name="GetStatGroup" datasource="#CircStatsDSN#">
<cfoutput>
SELECT  SG.GroupID,
        SG.Descrpt AS GroupDescrpt,
        SC.CatID,
        SC.Descrpt AS CategoryDescrpt


FROM StatGroup SG

JOIN StatGroupCategory SGC ON
SG.GroupID = SGC.GroupID
	
JOIN StatCategory SC ON
SC.CatID = SGC.CatID

JOIN UnitCategory UC ON
UC.CatID = SC.CatID

WHERE UC.UnitID = #UnitID#

<cfif Find("validate.cfm", PATH_INFO)>
	AND SC.CatID = #CatID#
</cfif>

</cfoutput>
</cfquery>



