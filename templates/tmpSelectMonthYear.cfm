<table border="0" cellspacing="0" cellpadding="1" bgcolor="#336699">
<tr>
	<td class="menu">Select a month/year</td>
</tr>
<tr>
	<td>
	<table border="0" cellspacing="0" cellpadding="6" bgcolor="#EBF0F7">
	<tr>
		<td>
<cfoutput>
<form action="transaction.cfm" method="post" class="form">
You are viewing data for 
<select name="dataMonth" class="form">
<cfloop index="Month" from="1" to="12">
	<option value="#Month#" class="form"
	<cfif Month IS dataMonth>selected</cfif>
	>#MonthAsString(Month)#</option>
</cfloop>
</select>

<select name="dataYear" class="form">
<cfloop index="Year" from="#EarliestYear#" to="#LatestYear#">
	<option value="#Year#" class="form"
	<cfif Year IS dataYear>selected</cfif>
	>#Year#</option>
</cfloop>
</select>
<input type="submit" value="Change month/year" class="form">
<input type="hidden" name="UnitID" value="#UnitID#">
</cfoutput>
		</td>
	</tr>
    </table>
	</td>
</tr>
</form>
</table>
<br>

