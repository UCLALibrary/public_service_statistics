<form action="master_report.cfm"
      method="post"
      name="SelectFYUnit"
      id="SelectFYUnit"
      class="form"
      onreset="setTimeout('setForm()',100)">
<cfoutput>
<span class="form">Data for fiscal year</span>
<select name="FY" class="form">
<cfloop index="Year" from="#ThisYear#" to="#DatePart("yyyy", DBStart)#" step="-1">
<option value="#Year#" class="form"
<cfif #FYStart# IS #Year#>selected</cfif>>#Year#</option>
</cfloop>
</select>

<cfif Column IS NOT "Unit">
<select name="LibUnit" class="form">
<option value="None">All libraries</option>
<cfloop query="GetLibUnits">
<option value="#Loc#" class="form"
<cfif #LibUnit# IS #Loc#>selected</cfif>>#unit#</option>
</cfloop>
</select>
</cfif>

<input type="hidden" name="ReportType" value="#ReportType#">
<input type="submit" value="Generate Report" class="form">
<input type="reset" value="Reset" class="form">
</form>
</cfoutput>