<cfif BlankForm IS NOT 1 AND Action IS NOT "InsertComment">
<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Unit</strong></td>	
	<td valign="bottom" class="tblcopy"><strong>Statistical Group</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Statistical Category</strong></td>
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
				#CircGroup#
				</td>
				<td class="tblcopy">
				#Category#
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
<cfif CommentPresent>
<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Comment</strong></td>	
</tr>	   
<tr>
	<td class="tblcopy"><cfoutput>#Comment#</cfoutput></td>
</tr>
</table>
</cfif>
<br>
<table border="0" cellspacing="2" cellpadding="0">
<tr>
<cfoutput>
	<cfif (BlankForm IS NOT 1 AND BadData IS NOT 1) OR Action IS "InsertComment">
		<form action="action.cfm" method="post">
		<td>
		<cfif Action IS "InsertComment">
		<input type="submit" value="Submit comment" class="form"></td>
		<input type="hidden" name="Action" value="InsertComment">
		<cfelse>
		<input type="submit" value="Submit data" class="form"></td>
		<input type="hidden" name="Action" value="Insert">
		<cfloop collection="#AggregateIDValue#" item="VarName">
		<input type="hidden" name="#VarName#" value="#AggregateIDValue[VarName]#">
		</cfloop>
		</cfif>
		<input type="hidden" name="CommentPresent" value="#CommentPresent#">
		<input type="hidden" name="Comment" value="#Comment#">
		<input type="hidden" name="UnitID" value="#UnitID#">
		<input type="hidden" name="dataMonth" value="#dataMonth#">
		<input type="hidden" name="dataYear" value="#dataYear#">
	</cfif>		
		</form>
		<form action="#LCase(UnitID)#/form.cfm" method="post">
		<td>
		<input type="submit" value="Return to form to make changes" class="form"></td>
		<input type="hidden" name="Action" value="ReviseInsert">
		<input type="hidden" name="CommentPresent" value="#CommentPresent#">
		<input type="hidden" name="Comment" value="#Comment#">
		<cfif Action IS "Insert">
		<cfloop collection="#AggregateIDValue#" item="VarName">
		<input type="hidden" name="#VarName#" value="#AggregateIDValue[VarName]#">
		</cfloop>
		</cfif>
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

