<!---cfif Find("form.cfm", PATH_INFO) IS 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif--->

<html>
<head>
<style type="text/css">
<!--
.form1 { font-family: Verdana, Arial, Helvetica, sans-serif;
              font-size: 11 px;
			  color: #0000CC;
              border: 0 px solid;
			  text-align: center;
              }
.form2 { font-family: Verdana, Arial, Helvetica, sans-serif;
              font-size: 11 px;
			  color: #0000CC;
              border: 0 px solid;
			  background-color: #FFFFCC;
			  text-align: center;
              }
.form3 { font-family: Verdana, Arial, Helvetica, sans-serif;
              font-size: 11 px;
              border: 0 px solid;
			  background-color: #DEDEDE;
			  text-align: left;
			  line-height: 7pt;
              }
-->
</style>
	<title>UCLA Library Reference Statistics Data Input: <cfoutput>#GetUnitCategory.Unit#</cfoutput></title>

<cfif Text IS "No">
	<cfinclude template="../../../library_pageincludes/banner.cfm">
	<cfinclude template="../../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>

<!--begin you are here-->
	<a href="../../../home.cfm">Public Service Statistics</a> &gt; <a href="../../index.cfm">Reference</a> &gt; <a href="../index.cfm"><cfoutput>#GetUnitCategory.ParentUnit#</cfoutput></a>
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


<h1>Reference Statistics Data Input: <cfoutput>#GetUnitCategory.Unit#</cfoutput></h1>

<form action="../../review.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<table border="0" cellspacing="1" cellpadding="1">
<tr height="20" bgcolor="#CCCCCC">
	<td colspan="6" class="form">
<cfoutput>
<strong>The data I'm entering is for</strong>
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
	</td>
</tr>


<cfoutput query="GetUnitCategory" group="ServicePoint">
<tr height="20" bgcolor="##666666">
	<td colspan="6" class="menu"><strong>#ServicePoint#</strong></td>
</tr>
	<cfoutput group="QuestionType">
		<cfif TypeID IS "00" AND ModeID IS "00">
<tr bgcolor="##CCCCCC" height="20">
	<td class="tblcopy"><strong>Total transactions</strong></td>
	<cfoutput>
	<td align="center" class="form" bgcolor="##CCCCCC">
	<input type="text" name="#AggregateID#" size="6" maxlength="6" class="form2"
			<cfif StructIsEmpty(FormValues) IS 0>
				<CFLOOP COLLECTION="#FormValues#" ITEM="VarName">
					<cfif VarName IS AggregateID>value = "#FormValues[VarName]#"</cfif>
				</cfloop>
			</cfif>
	>
	</td>
	</cfoutput>
	<td colspan="4" class="tblcopy">&nbsp;</td>
</tr>
<tr height="20" bgcolor="##666666">
	<td bgcolor="##CCCCCC" class="tblcopy">&nbsp;</td>
	<td width="70" align="center" class="menu"><strong>In-person</strong></td>
	<td width="70" align="center" class="menu"><strong>Telephone</strong></td>
	<td width="70" align="center" class="menu"><strong>Email</strong></td>
	<td width="70" align="center" class="menu"><strong>Online chat</strong></td>
	<td width="70" align="center" class="menu"><strong>Corresp.</strong></td>
</tr>
		</cfif>
	</cfoutput>
	<cfoutput group="QuestionType">
		<cfif TypeID IS NOT "00" AND ModeID IS NOT "00">
<tr height="20">
	<td class="tblcopy" bgcolor="##CCCCCC"><strong>#QuestionType#</strong></td>
	<td bgcolor="##CCCCCC" align="center" class="form">
			<cfoutput>
				<cfif ModeID IS "01">
					<input type="text" name="#AggregateID#" size="6" maxlength="6" class="form1"
						<cfif StructIsEmpty(FormValues) IS 0>
							<CFLOOP COLLECTION="#FormValues#" ITEM="VarName">
								<cfif VarName IS AggregateID>value = "#FormValues[VarName]#"</cfif>
							</cfloop>
						</cfif>
					>
				</cfif>
			</cfoutput>
	</td>
	<td bgcolor="##CCCCCC" align="center" class="form">
			<cfoutput>
				<cfif ModeID IS "02">
					<input type="text" name="#AggregateID#" size="6" maxlength="6" class="form1"
						<cfif StructIsEmpty(FormValues) IS 0>
							<CFLOOP COLLECTION="#FormValues#" ITEM="VarName">
								<cfif VarName IS AggregateID>value = "#FormValues[VarName]#"</cfif>
							</cfloop>
						</cfif>
					>
				</cfif>
			</cfoutput>
	</td>
	<td bgcolor="##CCCCCC" align="center" class="form">
			<cfoutput>
				<cfif ModeID IS "03">
					<input type="text" name="#AggregateID#" size="6" maxlength="6" class="form1"
						<cfif StructIsEmpty(FormValues) IS 0>
							<CFLOOP COLLECTION="#FormValues#" ITEM="VarName">
								<cfif VarName IS AggregateID>value = "#FormValues[VarName]#"</cfif>
							</cfloop>
						</cfif>
					>
				</cfif>
			</cfoutput>
	</td>
	<td bgcolor="##CCCCCC" align="center" class="form">
			<cfoutput>
				<cfif ModeID IS "05">
					<input type="text" name="#AggregateID#" size="6" maxlength="6" class="form1"
						<cfif StructIsEmpty(FormValues) IS 0>
							<CFLOOP COLLECTION="#FormValues#" ITEM="VarName">
								<cfif VarName IS AggregateID>value = "#FormValues[VarName]#"</cfif>
							</cfloop>
						</cfif>
					>
				</cfif>
			</cfoutput>
	</td>
	<td bgcolor="##CCCCCC" align="center" class="form">
			<cfoutput>
				<cfif ModeID IS "04">
					<input type="text" name="#AggregateID#" size="6" maxlength="6" class="form1"
						<cfif StructIsEmpty(FormValues) IS 0>
							<CFLOOP COLLECTION="#FormValues#" ITEM="VarName">
								<cfif VarName IS AggregateID>value = "#FormValues[VarName]#"</cfif>
							</cfloop>
						</cfif>
					>
				</cfif>
			</cfoutput>
	</td>
</tr>
		</cfif>
	</cfoutput>
</cfoutput>
<!--- submit data/clear form/cancel buttons --->
<tr>
	<td colspan="5">
	<table border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
<input type="submit" value="Submit Data" class="form">
		</td>
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
</cfoutput>
<input type="hidden" name="Action" value="Insert">
<input type="hidden" name="InputMethod" value="1">
</form>
<form action="form.cfm" method="post">
		<td>
<input type="submit" value="Clear form" class="form">
		</td>
<input type="hidden" name="UnitID" value="<cfoutput>#UnitID#</cfoutput>">
<input type="hidden" name="InputMethod" value="1">
<input type="hidden" name="Action" value="Clear">
</form>
<form action="../../action.cfm" method="post">
		<td>
<input type="submit" name="action" value="Cancel" class="form">
		</td>
</form>
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