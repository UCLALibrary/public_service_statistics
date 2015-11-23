<CFPARAM NAME = "Text" DEFAULT = "No">
<CFPARAM NAME = "UnitID" DEFAULT = 7>
<CFPARAM NAME = "dataMonth" DEFAULT = 0>
<CFPARAM NAME = "dataYear" DEFAULT = 0>
<CFPARAM NAME = "RecordID" default = 0>
<CFPARAM NAME = "Action" default = "Insert">

<cfinclude template="../queries/qryGetUnit.cfm">

<html>
<head>

	<title>UCLA Library Reference Statistics Data Input: <cfoutput>#GetUnit.Title#</cfoutput></title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../home.cfm">Public Service Statistics</a> &gt; <a href="index.cfm"><cfoutput>#GetUnit.Title#</cfoutput></a>
<cfif Action IS "Insert">
&gt; Reference Statistics Data Input
<cfelseif Action IS "Update">
&gt; Reference Statistics Data Edit
</cfif>

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Reference Statistics Data Input</h1>

<h2><cfoutput>#GetUnit.Title#</cfoutput></h2>


<form action="validate.cfm"
      method="post"
      name="StatForm"
      id="StatForm">
<cfoutput>
<input type="hidden" name="UnitID" value="#UnitID#">
</cfoutput>

<cfoutput>
<span class="form">The data I'm entering was collected during</span>

<select name="dataMonth" class="form">
<cfloop index="Month" from="1" to="#Evaluate(DatePart("m", Now()) - 1)#">
<option value="#Month#" class="form"

	<cfif #Month# IS #Evaluate(DatePart("m", Now()) - 1)#>selected</cfif>

	
>#MonthAsString(Month)#</option>
</cfloop>
</select>
<cfset Month = #DatePart("m", Now())#>
<select name="dataYear" class="form">
<cfloop index="Year" from="1999" to="#DatePart("yyyy", Now())#">
<option value="#Year#" class="form"

	<cfif Month IS 1>
		<cfif #Year# IS #Evaluate(DatePart("yyyy", Now()) - 1)#>selected</cfif>
	<cfelse>
		<cfif #Year# IS #DatePart("yyyy", Now())#>selected</cfif>
	</cfif>

>#Year#</option>

</cfloop>
</select>
</cfoutput>
<br><br>
<table border="0"
       cellspacing="1"
       cellpadding="0">
<form>
<tr valign="bottom" bgcolor="#CCCCCC">
	<td colspan="2" valign="bottom" class="tblcopy"><strong>Total contacts</strong></td>
</tr>

<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Reference desk</strong></td>
	<td align="center" class="form"><input type="text" name="Cat1" size="5" maxlength="6" class="form"></td>
</tr>
<tr bgcolor="#EBFOF7">
	<td align="right" class="tblcopy"><strong>Loan desk</strong></td>
	<td align="center" class="form"><input type="text" name="Cat2" size="5" maxlength="6" class="form"></td>
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Other service points</strong></td>
	<td align="center" class="form"><input type="text" name="Cat3" size="5" maxlength="6" class="form"></td>
</tr>
<tr valign="middle">
	<td height="16" colspan="6" align="center" valign="bottom" class="tblcopy">&nbsp;</td>
</tr>
<tr valign="middle">
<td align="center" valign="bottom" class="tblcopy">&nbsp;</td>
	<td align="center" valign="bottom" bgcolor="#CCCCCC" class="tblcopy"><strong>&nbsp;In-person&nbsp;</strong></td>
	<td align="center" valign="bottom" bgcolor="#CCCCCC" class="tblcopy"><strong>&nbsp;Telephone&nbsp;</strong></td>
	<td align="center" valign="bottom" bgcolor="#CCCCCC" class="tblcopy"><strong>&nbsp;Email&nbsp;</strong></td>
	<td align="center" valign="bottom" bgcolor="#CCCCCC" class="tblcopy"><strong>&nbsp;Correspondence&nbsp;</strong></td>
</tr>
<tr valign="middle" bgcolor="#CCCCCC">
	<td colspan="5" valign="bottom" class="tblcopy"><strong>Reference desk</strong></td>
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Inquiry</strong></td>
	<td align="center" class="form"><input type="text" name="Cat4" size="5" maxlength="6" class="form"></td>
	<td align="center" class="form"><input type="text" name="Cat5" size="5" maxlength="6" class="form"></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#EBFOF7">
	<td align="right" class="tblcopy"><strong>Strategy</strong></td>
	<td align="center" class="form"><input type="text" name="Cat6" size="5" maxlength="6" class="form"></td>	
	<td align="center" class="form"><input type="text" name="Cat7" size="5" maxlength="6" class="form"></td>	
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Tutorial</strong></td>
	<td align="center" class="form"><input type="text" name="Cat8" size="5" maxlength="6" class="form"></td>
	<td align="center" class="form"><input type="text" name="Cat9" size="5" maxlength="6" class="form"></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#EBFOF7">
	<td align="right" class="tblcopy"><strong>Directional</strong></td>
	<td align="center" class="form"><input type="text" name="Cat29" size="5" maxlength="6" class="form"></td>	
	<td align="center" class="form"><input type="text" name="Cat30" size="5" maxlength="6" class="form"></td>	
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>



<tr valign="bottom" bgcolor="#CCCCCC">
	<td colspan="5" valign="bottom" class="tblcopy"><strong>Off-desk</strong></td>
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Inquiry</strong></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
	<td align="center" class="form"><input type="text" name="Cat11" size="5" maxlength="6" class="form"></td>
	<td align="center" class="form"><input type="text" name="Cat12" size="5" maxlength="6" class="form"></td>
</tr>
<tr bgcolor="#EBFOF7">
	<td align="right" class="tblcopy"><strong>Strategy</strong></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
	<td align="center" class="form"><input type="text" name="Cat13" size="5" maxlength="6" class="form"></td>	
	<td align="center" class="form"><input type="text" name="Cat14" size="5" maxlength="6" class="form"></td>	
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Tutorial</strong></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
	<td align="center" class="form"><input type="text" name="Cat15" size="5" maxlength="6" class="form"></td>
	<td align="center" class="form"><input type="text" name="Cat16" size="5" maxlength="6" class="form"></td>
</tr>
<tr bgcolor="#EBFOF7">
	<td align="right" class="tblcopy"><strong>Extensive reference</strong></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
	<td align="center" class="form"><input type="text" name="Cat17" size="5" maxlength="6" class="form"></td>	
	<td align="center" class="form"><input type="text" name="Cat18" size="5" maxlength="6" class="form"></td>	
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Consultation</strong></td>
	<td align="center" class="form"><input type="text" name="Cat19" size="5" maxlength="6" class="form"></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>


<tr valign="bottom" bgcolor="#CCCCCC">
	<td colspan="6" valign="bottom" class="tblcopy"><strong>Loan desk</strong></td>
</tr>
<tr bgcolor="#FFFFFF">
	<td align="right" class="tblcopy"><strong>Directional</strong></td>
	<td align="center" class="form"><input type="text" name="Cat31" size="5" maxlength="6" class="form"></td>	
	<td align="center" class="form"><input type="text" name="Cat32" size="5" maxlength="6" class="form"></td>	
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>


<tr valign="bottom" bgcolor="#CCCCCC">
	<td colspan="6" valign="bottom" class="tblcopy"><strong>Other public service desks</strong></td>
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Inquiry</strong></td>
	<td align="center" class="form"><input type="text" name="Cat23" size="5" maxlength="6" class="form"></td>
	<td align="center" class="form"><input type="text" name="Cat24" size="5" maxlength="6" class="form"></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#EBFOF7">
	<td align="right" class="tblcopy"><strong>Strategy</strong></td>
	<td align="center" class="form"><input type="text" name="Cat25" size="5" maxlength="6" class="form"></td>	
	<td align="center" class="form"><input type="text" name="Cat26" size="5" maxlength="6" class="form"></td>	
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="White">
	<td align="right" class="tblcopy"><strong>Tutorial</strong></td>
	<td align="center" class="form"><input type="text" name="Cat27" size="5" maxlength="6" class="form"></td>
	<td align="center" class="form"><input type="text" name="Cat28" size="5" maxlength="6" class="form"></td>
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>
<tr bgcolor="#EBFOF7">
	<td align="right" class="tblcopy"><strong>Directional</strong></td>
	<td align="center" class="form"><input type="text" name="Cat33" size="5" maxlength="6" class="form"></td>	
	<td align="center" class="form"><input type="text" name="Cat34" size="5" maxlength="6" class="form"></td>	
	<td class="tblcopy">&nbsp;</td>
	<td class="tblcopy">&nbsp;</td>
</tr>
</table>
<br>
	<table border="0" cellspacing="2" cellpadding="0">
	<tr>
		<td><input type="submit" value="Submit Data" class="form"></td>
		<td><input type="reset" value="Clear Form" class="form"></td>
	</form>
	<form action="action.cfm" method="post">
		<td><input type="submit" name="action" value="Cancel" class="form"></td>
	</form>
	</tr>
	</table>



<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>


