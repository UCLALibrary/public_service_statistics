<cfif Action IS "Update">
<form action="validate.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="LogonID" value="#LogonID#">
<input type="hidden" name="RecordID" value="#GetTransactions.RecordID#">
</cfoutput>

<table border="0" cellspacing="4" cellpadding="0">
<tr valign="bottom">
	<td class="form"><strong>Statistical Category</strong><br>
	<select name="CatID" class="form">
<cfoutput query="GetStatCategory">
	<option value="#CatID#" class="form"
	<cfif #CatID# IS #GetTransactions.CatID#>SELECTED</cfif>
	>#Descrpt#</option>
</cfoutput>	
	</select>
	</td>
</tr>
<tr valign="bottom">	
	<td class="form"><strong>Data Collected During</strong><br>
<cfoutput>
<select name="dataMonth" class="form">
<cfloop index="Month" from="1" to="12">
<option value="#Month#" class="form"
<cfif Month IS GetTransactions.dataMonth>selected</cfif>

>#MonthAsString(Month)#</option>
</cfloop>
</select>
<select name="dataYear" class="form">
<cfloop index="Year" from="#Evaluate(DatePart("yyyy", Now()) - 1)#" to="#Evaluate(DatePart("yyyy", Now()) + 1)#">
<option value="#Year#" class="form"
<cfif Year IS GetTransactions.dataYear>selected</cfif>
>#Year#</option>
</cfloop>
</cfoutput>	
	</td>
</tr>
<tr valign="bottom">	
	<td class="form"><strong>Count</strong><br>
<cfoutput>
<input type="text" name="Cat#GetTransactions.CatID#" size="5" maxlength="6" class="form" value="#GetTransactions.Count#">
</cfoutput>	
	</td>
</tr>
</table>
<table border="0" cellspacing="2" cellpadding="0">
<tr>
	<td><input type="submit" value="Submit Changes" class="form"></td>
	    <input type="hidden" name="action" value="update">
</form>
<form action="validate.cfm" method="post">
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="LogonID" value="#LogonID#">
<input type="hidden" name="RecordID" value="#GetTransactions.RecordID#">
<input type="hidden" name="dataMonth" value="#GetTransactions.dataMonth#">
<input type="hidden" name="dataYear" value="#GetTransactions.dataYear#">
<input type="hidden" name="CatID" value="#GetTransactions.CatID#">
<input type="hidden" name="Cat#GetTransactions.CatID#" value="#GetTransactions.Count#">


</cfoutput>
<input type="hidden" name="action" value="Delete">
	<td><input type="submit" value="Delete Record" class="form"></td>
</form>
<form action="action.cfm" method="post">
	<td><input type="submit" name="action" value="Cancel" class="form"></td>
</form>
</tr>
</table>



<!----------------------------------------------->
<cfelseif Action IS "Insert">
<!----------------------------------------------->
<form action="validate.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
<input type="hidden" name="LogonID" value="#LogonID#">
</cfoutput>

<cfoutput>
<span class="form">The data I'm entering was collected during</span>

<select name="dataMonth" class="form">
<cfloop index="Month" from="1" to="12">
<option value="#Month#" class="form"

<cfif #Find("validate.cfm", HTTP_REFERER)#>
	<cfif #Month# IS #dataMonth#>selected</cfif>
<cfelse>
	<cfif #Month# IS #Evaluate(DatePart("m", Now()) - 1)#>selected</cfif>
</cfif>
	
>#MonthAsString(Month)#</option>
</cfloop>
</select>
<cfset Month = #DatePart("m", Now())#>
<select name="dataYear" class="form">
<cfloop index="Year" from="1999" to="#DatePart("yyyy", Now())#">
<option value="#Year#" class="form"

<cfif #Find("validate.cfm", HTTP_REFERER)#>
	<cfif #Year# IS #dataYear#>selected</cfif>
<cfelse>	
	<cfif Month IS 1>
		<cfif #Year# IS #Evaluate(DatePart("yyyy", Now()) - 1)#>selected</cfif>
	<cfelse>
		<cfif #Year# IS #DatePart("yyyy", Now())#>selected</cfif>
	</cfif>
</cfif>

>#Year#</option>

</cfloop>
</select>
<br><br>
</cfoutput>

<table border="0" cellspacing="0" cellpadding="0">
<tr valign="top">
	<td width="45%">
	<table width="300" border="0" cellspacing="4" cellpadding="0">
	<tr>
		<td height="1" colspan="2" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
	</tr>
	<tr>
		<td colspan="2" class="small">&nbsp;</td>
	</tr>

<cfset i = 1>
<cfset NewSection = "Yes">
<cfset SectionNo = 1>

<cfoutput query="GetUnitCategory">

<cfif i IS GroupID>
	<cfset NewSection = "No">
<cfelse>
	<cfset NewSection = "Yes">
</cfif>

<cfif NewSection IS "Yes">

		<cfif SectionNo IS NOT 1>
	<tr>
		<td colspan="2" class="small">&nbsp;</td>
	</tr>
	<tr>
		<td height="1" colspan="2" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
	</tr>
	<tr>
		<td colspan="2" class="small">&nbsp;</td>
	</tr>
		</cfif>
		<cfif SectionNo IS 5>
	</table>
	</td>
	<td width="10%">&nbsp;</td>
	<td width="45%">
	<table width="300" border="0" cellspacing="4" cellpadding="0">
	<tr>
		<td height="1" colspan="2" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
	</tr>
	<tr>
		<td colspan="2" class="small">&nbsp;</td>
	</tr>
		</cfif>
	<tr>
		<td colspan="2" class="formlarge"><strong>	
#SectionNo#. #GroupDescrpt#</strong></td>
	</tr>
	<cfset SectionNo = SectionNo + 1>
</cfif>
	<tr valign="bottom">
		<td class="form">#CatDescrpt#:</td>
		<td align="right" class="form"><input type="text" name="Cat#CatID#" size="5" maxlength="6" class="form"
	<cfif #Find("validate.cfm", HTTP_REFERER)#>

		<cfloop collection="#CategoryValue#" item="CategoryID">
			<cfif #Trim(CategoryValue[CategoryID])# IS NOT "">
				<cfif #Replace(LCase(CategoryID), "cat", "", "ALL")# IS #CatID#>
						value="#StructFind(CategoryValue, CategoryID)#">
			  	</cfif>
			<cfelse>
					value="">
			</cfif>  
		</CFLOOP>
	</cfif>	

		</td>
	</tr>
<cfset i = GroupID>
</cfoutput>
	<tr>
		<td colspan="2" class="small">&nbsp;</td>
	</tr>
	<tr>
		<td height="1" colspan="2" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
	</tr>
	</table>
	<table border="0" cellspacing="2" cellpadding="0">
	<tr>
	<cfif #Find("validate.cfm", HTTP_REFERER)#>
		<td><input type="submit" value="Submit Data" class="form"></td>		    		
	<cfelse>
		<td><input type="submit" value="Submit Data" class="form"></td>
		<td><input type="reset" value="Clear Form" class="form"></td>
	</cfif>
		   <input type="hidden" name="Action" value="Insert">		   
	</form>
	<form action="action.cfm" method="post">
		<td><input type="submit" name="action" value="Cancel" class="form"></td>
	</form>
	</tr>
	</table>



	</td>
</tr>
</table>

</cfif>




