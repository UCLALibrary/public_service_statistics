<cfif BlankForm IS NOT 1>
<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Unit</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Comment</strong></td>	
	<td valign="bottom" class="tblcopy"><strong>Month</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Year</strong></td>
</tr>
<cfoutput>
<tr valign="top">
	<td class="tblcopy">#GetUnit.Unit#</td>
	<td class="tblcopy">#Comment#</td>
	<td class="tblcopy">#MonthAsString(dataMonth)#</td>
	<td class="tblcopy">#dataYear#</td>
</tr>
</cfoutput>
</table>
</cfif>
<br>
<table border="0" cellspacing="2" cellpadding="0">
<tr>
<cfoutput>
	<cfif BlankForm IS NOT 1>
		<form action="action.cfm" method="post">
		<td>
		<input type="submit" value="Submit changes" class="form">
		</td>
		<input type="hidden" name="Action" value="UpdateComment">
		<input type="hidden" name="CommentID" value="#CommentID#">
		<input type="hidden" name="Comment" value="#Comment#">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		</form>
	</cfif>		
		<form action="#LCase(UnitID)#/form.cfm" method="post">
		<td>
		<input type="submit" value="Return to form to make changes" class="form">
		</td>
		<input type="hidden" name="Action" value="ReviseUpdateComment">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="CommentID" value="#CommentID#">
		</form>
</cfoutput>	
		<form action="action.cfm" method="post">
		<input type="hidden" name="action" value="cancel">
		<td><input type="submit" value="Cancel" class="form"></td>
		</form>
</tr>
</table>


