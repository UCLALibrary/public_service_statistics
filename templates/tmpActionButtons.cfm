<table border="0" cellspacing="2" cellpadding="0">
<tr>
<cfif Action IS "Insert">
	<cfoutput>
	<cfif BlankForm IS NOT 1 AND NonNumeric IS NOT 1>
		<form action="action.cfm" method="post">
		<td>
		<input type="submit" value="Submit Data" class="form"></td>
		<input type="hidden" name="Action" value="Insert">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="LogonID" value="#LogonID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		<cfloop collection="#CategoryValue#" item="CategoryID">
		<input type="hidden" name="#CategoryID#" value="#CategoryValue[CategoryID]#">
		</cfloop>
		</form>
	</cfif>		
		<form action="form.cfm" method="post">
		<td>
		<input type="submit" value="Return to Form to Make Changes" class="form"></td>
		<input type="hidden" name="Action" value="Insert">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="LogonID" value="#LogonID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		<cfloop collection="#CategoryValue#" item="CategoryID">
		<input type="hidden" name="#CategoryID#" value="#CategoryValue[CategoryID]#">
		</cfloop>
		</form>
	</cfoutput>	
		
<cfelseif Action IS "Update" OR Action IS "Delete">

	<cfif BlankForm IS NOT 1>
		<cfif NonNumeric IS NOT 1>
		<form action="action.cfm" method="post">
			<td>
		<cfoutput>
		<cfif Action is "Update">
			<input type="submit" value="Submit Changes" class="form">
			<input type="hidden" name="action" value="Update">
		<cfelseif Action IS "Delete">	
			<input type="submit" value="Delete Record" class="form">
			<input type="hidden" name="action" value="Delete">
		</cfif>
		</td>
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="LogonID" value="#LogonID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		<input type="hidden" name="RecordID" value="#RecordID#">
		<input type="hidden" name="CatID" value="#CatID#">
		<cfloop collection="#CategoryValue#" item="CategoryID">
		<input type="hidden" name="#CategoryID#" value="#CategoryValue[CategoryID]#">
		</cfloop>
		</cfoutput>	
		</form>
		</cfif>
	</cfif>

	<form action="form.cfm" method="post">
		<td><input type="submit" value="Return to Form to Make Changes" class="form"></td>
	<cfoutput>
		<input type="hidden" name="Action" value="Update">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="RecordID" value="#RecordID#">
	</cfoutput>
	</form>



</cfif>
	
	
<form action="action.cfm" method="post">
<input type="hidden" name="action" value="cancel">
	<td><input type="submit" value="Cancel" class="form"></td>
</form>

</tr>
</table>