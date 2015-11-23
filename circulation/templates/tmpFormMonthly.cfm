<!---cfif Find("form.cfm", PATH_INFO) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif--->

<html>
<head>
	<title>UCLA Library Circulation Statistics Data Input: <cfoutput>#GetUnitCategory.Unit#</cfoutput></title>

<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/banner.cfm">
	<cfinclude template="../../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->
	<a href="../../../home.cfm">Public Service Statistics</a> &gt; <a href="../../index.cfm">Circulation</a> &gt; <a href="../index.cfm"><cfoutput>#GetUnitCategory.Unit#</cfoutput></a>
<cfif Action IS "Insert">
&gt; Data Input
<cfelseif Action IS "Update">
&gt; Data Edit
<cfelseif Action IS "ReviseInsert">
&gt; Revise Submission
</cfif>

<!-- end you are here -->
<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>


<!--begin main content-->

<cfif NOT Session.IsValid>

<h1>Session Expired</h1>

<form action="../../index.cfm" method="post" class="form">
<input type="submit" value="Restart Session" class="form">
</form>

<cfelse>


<h1>Circulation Statistics Data Input: <cfoutput>#GetUnitCategory.Unit#</cfoutput></h1>

<form action="../review.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<cfoutput>
<strong class="form">The data I'm entering is for</strong>
<select name="dataMonth" class="form">
<cfloop index="Month" from="1" to="12">
	<cfif Action IS "Insert" OR Action IS "Clear">
	<option value="#Month#" class="form" <cfif Evaluate(dataMonth-1) IS Month>selected</cfif>>#MonthAsString(Month)#</option>
	<cfelseif Action IS "ReviseInsert">
	<option value="#Month#" class="form" <cfif dataMonth IS Month>selected</cfif>>#MonthAsString(Month)#</option>
	</cfif>	
</cfloop>
	</select>
<cfset Month = #DatePart("m", Now())#>
<select name="dataYear" class="form">
<cfloop index="Year" from="#DatePart("yyyy", Now())#" to="1999" step="-1">
	<option value="#Year#" class="form" <cfif DataYear IS Year>selected</cfif>>#Year#</option>
</cfloop>
</select>
</cfoutput>
<br><br>



<cfset i = 1>

<table border="0" cellspacing="0" cellpadding="0">
<tr valign="top">
	<td width="45%">

	<table width="300" border="0" cellspacing="4" cellpadding="0">
	<tr>
		<td height="1" colspan="3" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
	</tr>
<cfoutput query="GetUnitCategory" group="CircGroup">

<cfif i IS 5>
	</tr>
	</table>
	
</td><td width="45%">
	
	<table width="300" border="0" cellspacing="4" cellpadding="0">
	<tr>
		<td height="1" colspan="3" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
</cfif>
	</tr>
	<tr>
		<td class="formlarge">#i#.</td>
		<td colspan="2" class="formlarge">#CircGroup#</td>
	</tr>
	<cfoutput group="Category">
	<tr>
		<td class="small">&nbsp;</td>
		<td class="small">#Category#</td>
		<td class="form">
		<input type="text" name="#AggregateID#" size="6" maxlength="7" class="form"
		<cfif StructIsEmpty(FormValues) IS 0>
			<CFLOOP COLLECTION="#FormValues#" ITEM="VarName">
				<cfif VarName IS AggregateID>value = "#FormValues[VarName]#"</cfif>
			</cfloop>
		</cfif>></td>
	</tr>
	</cfoutput>
	<cfset i = i + 1>
	<tr>
		<td height="1" colspan="3" class="small">&nbsp;</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
	

		
</cfoutput>
	</tr>
	
	<tr>
		<td height="1" colspan="3" class="formlarge">Comments:<br>
		<textarea cols="25" rows="4" name="Comment"><cfif Action IS "ReviseInsert"><cfoutput>#Comment#</cfoutput></cfif></textarea>
		</td>
	</tr>	

	<tr>
		<td height="1" colspan="3" bgcolor="Gray" class="small"><img src="../images/1x1.gif" width="1" height="1" border="0"></td>
	</tr>
	
<!--- submit data/clear form/cancel buttons --->
	<tr>
		<td colspan="3">
		<table border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
<input type="submit" value="Submit Data" class="form">
			</td>
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
</cfoutput>
<input type="hidden" name="Action" value="Insert">
</form>
<form action="form.cfm" method="post">
			<td>
<input type="submit" value="Clear form" class="form">
			</td>
<input type="hidden" name="UnitID" value="<cfoutput>#UnitID#</cfoutput>">
<input type="hidden" name="Action" value="Clear">
</form>
<form action="action.cfm" method="post">
			<td>
<input type="submit" name="action" value="Cancel" class="form">
			</td>
</form>
		</tr>
		</table>
		</td>
	</tr>
	</table>
	</td>
</tr>
</table>

</cfif>


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/footer_txt.cfm">
</cfif>