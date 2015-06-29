<cfif BlankForm IS NOT 1>
<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Unit</strong></td>	
	<td valign="bottom" class="tblcopy"><strong>Statistical group</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Statistical category</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Month</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Year</strong></td>
	<td align="right" valign="bottom" class="tblcopy"><strong>Value</strong></td>
</tr>
<cfoutput>
<tr valign="top">
	<td class="tblcopy">#GetUnitCategory.Unit#</td>
	<td class="tblcopy">#GetUnitCategory.CircGroup#</td>
	<td class="tblcopy">#GetUnitCategory.Category#</td>
	<td class="tblcopy">#MonthAsString(dataMonth)#</td>
	<td class="tblcopy">#dataYear#</td>
	<td align="right" class="tblcopy"><cfif BadData IS 1><span class="hilite">#Count#</span><cfelse>#Count#</cfif></td>
</tr>
</cfoutput>
</table>
</cfif>
<br>
<table border="0" cellspacing="2" cellpadding="0">
<tr>
<cfoutput>
	<cfif BlankForm IS NOT 1 AND BadData IS NOT 1>
		<form action="action.cfm" method="post">
		<td>
		<input type="submit" value="Submit changes" class="form">
		</td>
		<input type="hidden" name="Action" value="Update">
		<input type="hidden" name="RecordID" value="#RecordID#">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="#AggregateID#" value="#Count#">
		<input type="hidden" name="AggregateID" value="#AggregateID#">
		<input type="hidden" name="Count" value="#Count#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		</form>
	</cfif>		
		<form action="#LCase(UnitID)#/form.cfm" method="post">
		<td>
		<input type="submit" value="Return to form to make changes" class="form">
		</td>
		<input type="hidden" name="Action" value="ReviseUpdate">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="RecordID" value="#RecordID#">
		</form>
</cfoutput>	
		<form action="action.cfm" method="post">
		<input type="hidden" name="action" value="cancel">
		<td><input type="submit" value="Cancel" class="form"></td>
		</form>
</tr>
</table>


