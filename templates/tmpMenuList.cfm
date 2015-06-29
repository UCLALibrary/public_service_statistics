<cfoutput>
<ul>
<li><a href="form.cfm?Action=Insert&UnitID=#GetUnit.UnitID#">Input Data</a></li>
<li><a href="transaction.cfm?UnitID=#GetUnit.UnitID#">View/Edit Recent Data</a></li>
<cfif GetUnit.UnitID IS NOT 5 AND GetUnit.UnitID IS NOT 6>
	<cfif GetUnit.UnitID IS NOT 9 AND
	      GetUnit.UnitID IS NOT 10 AND
		  GetUnit.UnitID IS NOT 11 AND
		  GetUnit.UnitID IS NOT 12>
<li><a href="../reports/#Replace(LCase(GetUnit.Code), "url", "yrl", "ALL")#.cfm?UnitID=#GetUnit.UnitID#">Summary Report</a></li>
	<cfelseif GetUnit.UnitID IS 9 OR
	      GetUnit.UnitID IS 10 OR
		  GetUnit.UnitID IS 11 OR
		  GetUnit.UnitID IS 12>
<li><a href="../reports/sel.cfm?UnitID=#GetUnit.UnitID#">Summary Report</a></li>
	</cfif>
</cfif>
	
</ul>
</cfoutput>
