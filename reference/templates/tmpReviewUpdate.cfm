<cfif BlankForm IS NOT 1 AND IsValidCategory IS 1>
<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Unit</td>	
	<td valign="bottom" class="tblcopy"><strong>Service point</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Question Type</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Mode</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Month</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Year</strong></td>
	<td align="right" valign="bottom" class="tblcopy"><strong>Value</strong></td>
</tr>	   
<cfoutput>
<tr valign="top">
	<td class="tblcopy">#GetAggregateID.Unit#</td>
	<td class="tblcopy">#GetAggregateID.ServicePoint#</td>
	<td class="tblcopy">#GetAggregateID.QuestionType#</td>
	<td class="tblcopy"><cfif GetAggregateID.Mode IS NOT "Transaction">#GetAggregateID.Mode#<cfelse>None</cfif></td>
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
	<cfif BlankForm IS NOT 1 AND BadData IS NOT 1 AND IsValidCategory IS 1>
		<form action="action.cfm" method="post">
		<td>
		<input type="submit" value="Submit changes" class="form">
		</td>
		<input type="hidden" name="Action" value="Update">
		<input type="hidden" name="InputMethod" value="1">
		<input type="hidden" name="RecordID" value="#RecordID#">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="#AggregateID#" value="#Count#">
		<input type="hidden" name="AggregateID" value="#AggregateID#">
		<input type="hidden" name="Count" value="#Count#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		</form>
	</cfif>		
		<form action="#LCase(RemoveChars(UnitID, 4, 3))#/#LCase(GetUnit.SubUnitID)#/form.cfm" method="post">
		<td>
		<input type="submit" value="Return to form to make changes" class="form">
		</td>
		<input type="hidden" name="Action" value="ReviseUpdate">
		<input type="hidden" name="InputMethod" value = "1">
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


<cfif IsValidCategory IS NOT 1>
	<cfoutput>
<p>The following is a list of the valid statistical categories that are being collected at: <strong>#GetUnitCategory.Unit#</strong>/<strong>#GetUnitCategory.ServicePoint#</strong>.</p>
	</cfoutput>
<table width="100%"
       border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Unit</td>	
	<td valign="bottom" class="tblcopy"><strong>Service point</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Question Type</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Mode</strong></td>
</tr>	   
<cfoutput query="GetUnitCategory">
<tr valign="top" <cfif Evaluate(GetUnitCategory.CurrentRow MOD 2) IS 0>bgcolor="##EBFOF7"<cfelse> bgcolor="##FFFFFF"</cfif>>
	<td class="tblcopy">#Unit#</td>
	<td class="tblcopy">#ServicePoint#</td>
	<td class="tblcopy">#QuestionType#</td>
	<td class="tblcopy"><cfif Mode IS NOT "Transaction">#Mode#<cfelse>None</cfif></td>
</tr>
</cfoutput>
</table>	
</cfif>





