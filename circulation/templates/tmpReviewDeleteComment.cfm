<cfoutput query="GetComment">
<table border="0"
       cellspacing="1"
       cellpadding="2">
<tr valign="bottom" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>CommentID</strong>:</td>
	<td class="tblcopy">#CommentID#</td>
</tr>
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Unit:</strong></td>
	<td class="tblcopy">#Unit#</td>
</tr>
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Comment:</strong></td>
	<td class="tblcopy">#Comment#</td>
</tr>
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Month:</strong></td>
	<td class="tblcopy">#MonthAsString(DataMonth)#</td>
</tr>
<tr valign="top" bgcolor="##EBF0F7">
	<td class="tblcopy"><strong>Year:</strong></td>
	<td class="tblcopy">#DataYear#</td>
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

<tr valign="top">
	<td colspan="2">
	<table border="0" cellspacing="0" cellpadding="1">
	<tr>
<cfoutput>
		<form action="action.cfm" method="post">
		<td>
		<input type="submit" value="Quit nagging me and just do it!" class="form">
		</td>
		<input type="hidden" name="Action" value="DeleteComment">
		<input type="hidden" name="CommentID" value="#CommentID#">
		<input type="hidden" name="UnitID" value="#UnitID#">
		</form>
		<form action="#LCase(UnitID)#/edit.cfm" method="post">
		<td>
		<input type="submit" value="Return to list" class="form">
		</td>
		<input type="hidden" name="Action" value="Select">
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


