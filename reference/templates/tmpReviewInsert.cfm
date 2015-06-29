<cfif BlankForm IS NOT 1>
<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Unit</td>	
	<td valign="bottom" class="tblcopy"><strong>Service point</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Question Type</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Mode</strong></td>
	<td align="right" valign="bottom" class="tblcopy"><strong>Value</strong></td>
</tr>	   
	<cfoutput query="GetUnitCategory">
		<CFLOOP COLLECTION="#AggregateIDValue#" ITEM="VarName">
			<cfif VarName IS AggregateID>
			<tr valign="top" <cfif (IsNumeric(AggregateIDValue[VarName]) IS 0) OR (ReFind("[[:punct:]]", AggregateIDValue[VarName]))>bgcolor="##FFFF00"<cfelseif Evaluate(GetUnitCategory.CurrentRow MOD 2) IS 0>bgcolor="##EBFOF7"<cfelse> bgcolor="##FFFFFF"</cfif>>
				<td class="tblcopy">
				#Unit#
				</td>
				<td class="tblcopy">
				#ServicePoint#
				</td>
				<td class="tblcopy">
				#QuestionType#
				</td>
				<td class="tblcopy">
				<cfif Mode IS NOT "Transaction">
				#Mode#
				<cfelse>
				--
				</cfif>
				</td>
				<td align="right" class="tblcopy">
				#AggregateIDValue[VarName]#
				</td>
			</tr>
			</cfif>
		</cfloop>
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
		<input type="submit" value="Submit data" class="form"></td>
		<input type="hidden" name="Action" value="Insert">
		<input type="hidden" name="InputMethod" value="1">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		<cfloop collection="#AggregateIDValue#" item="VarName">
		<input type="hidden" name="#VarName#" value="#AggregateIDValue[VarName]#">
		</cfloop>
		</form>
	</cfif>		
		<form action="#LCase(RemoveChars(UnitID, 4, 3))#/#LCase(GetUnit.SubUnitID)#/form.cfm" method="post">
		<td>
		<input type="submit" value="Return to form to make changes" class="form"></td>
		<input type="hidden" name="Action" value="ReviseInsert">
		<input type="hidden" name="InputMethod" value = 1>
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
		<cfloop collection="#AggregateIDValue#" item="VarName">
		<input type="hidden" name="#VarName#" value="#AggregateIDValue[VarName]#">
		</cfloop>
		</form>
</cfoutput>	
		<form action="action.cfm" method="post">
		<input type="hidden" name="action" value="cancel">
		<td><input type="submit" value="Cancel" class="form"></td>
		</form>
</tr>
</table>

