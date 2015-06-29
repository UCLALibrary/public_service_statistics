<cfoutput query="GetRecord">
<table border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>RecordID</strong>:</td>
	<td class="tblcopy">#RecordID#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Unit</td>
	<td class="tblcopy">#Unit#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Service point</strong></td>
	<td class="tblcopy">#ServicePoint#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Question Type</strong></td>
	<td class="tblcopy">#QuestionType#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Mode</strong></td>
	<td class="tblcopy"><cfif Mode IS NOT "Transaction">#Mode#<cfelse>None</cfif></td>	
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Month</strong></td>
	<td class="tblcopy">#MonthAsString(dataMonth)#</td>	
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Year</strong></td>
	<td class="tblcopy">#dataYear#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td align="left" valign="bottom" class="tblcopy"><strong>Value</strong></td>
	<td align="left" class="tblcopy">#Count#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Created</strong>:</td>
	<td class="tblcopy">#Created_DT#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Last edited</strong>:</td>
	<td class="tblcopy">#Updated_DT#</td>
</tr>
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Last edited/created by</strong>:</td>
	<td class="tblcopy">#LogonID#</td>
</tr>
</cfoutput>
<tr valign="bottom">
	<td colspan="2">
	<table border="0" cellspacing="2" cellpadding="0">
	<tr>
		<cfoutput>
		<form action="action.cfm" method="post">
		<td>
		<input type="submit" value="Quit nagging me and just do it!" class="form">
		</td>
		<input type="hidden" name="Action" value="Delete">
		<input type="hidden" name="InputMethod" value = "1">
		<input type="hidden" name="RecordID" value="#RecordID#">
		<input type="hidden" name="UnitID" value="#UnitID#">
		</form>

		<form action="#LCase(RemoveChars(UnitID, 4, 6))#/#LCase(RemoveChars(UnitID, 1, 3))#/edit.cfm" method="post">
		<td>
		<input type="submit" value="Return to list" class="form">
		</td>
		<input type="hidden" name="Action" value="Select">
		<input type="hidden" name="InputMethod" value = "1">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		</form>
</cfoutput>	
		<form action="action.cfm" method="post">
		<input type="hidden" name="action" value="cancel">
		<td><input type="submit" value="Cancel" class="form"></td>
		</form>
	</tr>
	</table>
	</td>
</tr>
</table>
