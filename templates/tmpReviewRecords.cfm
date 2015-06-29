<cfif Action IS "Insert">
<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="1"
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="tblcopy"><strong>Statistical Group</strong></td>
	<td valign="bottom" class="tblcopy"><strong>Statistical Category</td>	
	<td align="right" valign="bottom" class="tblcopy"><strong>Value</strong></td>
</tr>
	   
<cfoutput query="GetUnitCategory">

<CFLOOP COLLECTION="#CategoryValue#" ITEM="VarName">
<cfif #Replace(LCase(VarName), "cat", "", "ALL")# IS #CatID#>

<tr valign="top" 

<cfif Evaluate(GetUnitCategory.CurrentRow MOD 2) IS 0>
bgcolor="##EBFOF7"
<cfelse>
bgcolor="##FFFFFF"
</cfif>>
	<td class="tblcopy">
	<cfif #IsNumeric(CategoryValue[VarName])#>
	#GroupDescrpt#
	<cfelse>
	<span class="hilite">#GroupDescrpt#</span>
	</cfif>
	</td>
	<td class="tblcopy">
	<cfif #IsNumeric(CategoryValue[VarName])#>
	#CatDescrpt#
	<cfelse>
	<span class="hilite">#CatDescrpt#</span>
	</cfif>
	</td>
	<td align="right" class="tblcopy">
	<cfif #IsNumeric(CategoryValue[VarName])#>
	#CategoryValue[VarName]#
	<cfelse>
	<span class="hilite">#CategoryValue[VarName]#</span>
	</cfif>
	</td>
</tr>
</cfif>  
</CFLOOP>
</CFOUTPUT>
</table>









<cfelseif Action IS "Update" OR Action IS "Delete">
<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="1">
<tr valign="bottom" bgcolor="#EBF0F7">
	<td valign="bottom" class="small"><strong>Statistical Group</strong></td>
	<td valign="bottom" class="small"><strong>Statistical Category</strong></td>	
	<td valign="bottom" class="small"><strong>Value</strong></td>
	<td valign="bottom" class="small"><strong>Data Collected</strong></td>
	<td valign="bottom" class="small"><strong>Created/Updated</strong></td>
	<td valign="bottom" class="small"><strong>Input by</strong></td>
</tr>
	   
<cfoutput>
<tr valign="top">
	<td class="small">
	#GetStatGroup.GroupDescrpt#
	</td>
	<td class="small">
	#GetStatGroup.CategoryDescrpt#
	</td>
	<td class="small">
	<cfloop collection="#CategoryValue#" item="CategoryID">
		<cfif #IsNumeric(Replace(LCase(CategoryID), "cat", "", "ALL"))#>
			<cfif #IsNumeric(CategoryValue[CategoryID])#>
				#CategoryValue[CategoryID]#
			<cfelse>
				<span class="hilite">#CategoryValue[CategoryID]#</span>
			</cfif>
		</cfif>
	</cfloop>
	</td>
	<td class="small">
	#Left(MonthAsString(dataMonth), 3)# #dataYear#
	</td>
	<td class="small">
	#DateFormat(Now(), "m/d/yy")# #TimeFormat(Now(), "h:mmtt")#
	</td>
	<td class="small">
	#LogonID#
	</td>
</tr>
</CFOUTPUT>
</table>
</cfif>

