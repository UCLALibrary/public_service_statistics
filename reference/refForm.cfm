<cfset CircDesks = "ART0003,COL0006,COL0005,LAW0003,MAN0003,MUS0003,SEL0203,SEL0103,SEL0303,SRL0003,YRL0710,YRL0703,YRL0713">

<cfquery name="GetUnitPoint" datasource="#CircStatsDSN#">
	SELECT DISTINCT Unit, ServicePoint
	FROM View_RefUnitCategory
	WHERE
		UnitPointID = '#URL.UnitPointID#'
		AND InputMethodID = 2
</cfquery>

<cfquery name="GetModes" datasource="#CircStatsDSN#">
	SELECT DISTINCT Mode, ModeID
	FROM View_RefUnitCategory
	WHERE
		UnitPointID = '#URL.UnitPointID#'
		AND InputMethodID = 2
		AND (TypeID <> '00' AND TypeID <> '03' AND TypeID <> '04' AND TypeID <> '07' AND TypeID <> '08' AND ModeID <> '00')
	ORDER BY Mode
</cfquery>

<cfquery name="GetTypes" datasource="#CircStatsDSN#">
	SELECT DISTINCT QuestionType, HelpText, TypeID
	FROM View_RefUnitCategory
	WHERE
		UnitPointID = '#URL.UnitPointID#'
		AND InputMethodID = 2
		AND (TypeID <> '00' AND TypeID <> '03' AND TypeID <> '04' AND TypeID <> '07' AND TypeID <> '08' AND ModeID <> '00')
	ORDER BY QuestionType
</cfquery>

<cfquery name="GetDepartments" datasource="#APPLICATION.dsn#">
	SELECT
		DepartmentID,
		Department,
		Ordering
	FROM
		SIA.dbo.DepartmentLookup
	ORDER BY
		Ordering, Department
</cfquery>

<cfquery name="GetPatrons" datasource="#CircStatsDSN#">
	SELECT
		PatronTypeID,
		PatronType
	FROM
		PatronType
	ORDER BY
		Ordering
</cfquery>

<!DOCTYPE html>
<html>
<head>
<title>Reference Statistics Data Input</title>
<style type="text/css">
<!--
.tblcopy {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 11px;
}
.form1 {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 11px;
color: #0000CC;
border: 0px solid;
text-align: center;
}
.form2 {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 11px;
color: #0000CC;
border: 0px solid;
background-color: #FFFFCC;
text-align: center;
}
.form3 {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 11px;
border: 0px solid;
background-color: #DEDEDE;
text-align: left;
line-height: 7pt;
}
.small {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 11px;
line-height: 1em;
}
input, textarea, select {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 11px;
margin-bottom: 0px;
}
-->
</style>
<script language="JavaScript">
function validate(formName)
{
	var selectedCount = 0;
	for ( var i = 0; i < formName.TypeID.length; i++ )
	{
		if ( formName.TypeID[i].checked )
			selectedCount += 1;
	}
	if ( selectedCount != 0 )
		return true;
	else
	{
		alert("Please select at least one question type");
		return false;
	}
}
function ShowCalendar(FormName, FieldName)
{
	window.open("select_date.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=200,height=150,left=400,top=150");
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="1" marginheight="1" marginwidth="1" leftmargin="1" link="#000099" vlink="#0000CC">
<form name="refForm" action="submitStat.cfm" method="post" onsubmit="javascript:return validate(refForm);">
<div id="container" style="height: 100%; width:98%">
<div id="header" style="background-color:#DEDEDE;">
<strong class="tblcopy"><cfoutput>#GetUnitPoint.Unit# #GetUnitPoint.ServicePoint#</cfoutput></strong>
<span height="1" bgcolor="#FFFFFF"><img src="images/1x1.gif" width="1" height="1" border="0"></span>
<br/>
<div style="background-color:#FFFFFF;">
<a href="javascript:ShowCalendar('refForm', 'Date')">
<img src="images/calendar.gif" alt="Date selector" width="16" height="15" border="0" align="absmiddle">
</a>
&nbsp;
<input type="text" name="Date" value="<cfoutput>#DateFormat(Now(), "m/d/yyyy")#</cfoutput>" size="11" maxlength="11" class="form3" onClick="javascript:ShowCalendar('KeyPad', 'Date')">
<select name="Hour" class="small">
<cfloop index="H" from="0" to="23">
<option value="<cfoutput>#TimeFormat(CreateTime(H, 00, 00), "H:mm:ss tt")#</cfoutput>" <cfif Hour(Now()) - 2 is H>selected</cfif> class="small"><cfoutput>#TimeFormat(CreateTime(H, 00, 00), "h tt")
#</cfoutput> hour
</option>
</cfloop>
</select>
<br/>
</div>
</div>
<div id="menu" style="background-color:#FFFFFF;height:75%;width:69%;float:left; margin: 5px;">
<strong>Question Type</strong><br/>
<table>
<cfoutput query="GetTypes">
<tr>
<td><input type="checkbox" name="TypeID" value="#GetTypes.TypeID#">&nbsp;<strong>#GetTypes.QuestionType#</strong></td>
<td>&nbsp;</td>
<td><em>#GetTypes.HelpText#</em></td>
</cfoutput>
</tr>
</table>
<br/>
<strong>Referral</strong><br/>
Did you provide a referral to the patron?&nbsp;&nbsp;
<input type="radio" name="Referral" value="y">Yes&nbsp;
<input type="radio" name="Referral" value="n" checked>No<br/>
<em>If yes, please provide a description</em><br/>
<textarea name="ReferralText" cols="50" rows="2"></textarea>
</div>
<div id="content" style="background-color:#FFFFFF;height:75%;width:29%;float:left; margin: 5px;">
<strong>Mode</strong>
<br/>
<cfoutput query="GetModes">
<input type="radio" name="ModeID" value="#GetModes.ModeID#"
	<cfif IsDefined("URL.ModeID") and GetModes.ModeID eq URL.ModeID>checked
	<cfelseif !IsDefined("URL.ModeID") and GetModes.ModeID eq '01'>checked</cfif>
	>&nbsp;<strong>#GetModes.Mode#</strong><br/>
</cfoutput>
<br/>
<strong>Total time (minutes)</strong><br/>
<input name="TimeSpent" type="text" length="25" value="3" class="form">
</div>

<div id="footer" style="clear:both;text-align:left; width: 98%; padding: 10px;">
<div style="margin: 5px;">
<input type="submit" name="SubmitIt" value="Submit" class="form">&nbsp;
<input type="reset" value="Reset" class="form" onClick="window.location.reload()">
</div>

<div id="optionals" style="clear:both; text-align:left; width: 98%; padding: 10px;">
<hr size="1" width="98%"/>
<p><em style="color: red; font-weight: bold;">All the following elements are optional</em></p>
<div style="width: 69%; float: left;">
<table>
<tr>
<td>
<strong>Question Topic</strong><br/>
<textarea name="Topic" rows="4" cols="50">
</textarea>
</td>
</tr>
<tr>
<td>
<strong>Department/Unit</strong><br/>
<cfoutput>
<select name="DepartmentID">
	<option value="0">-select-</option>
	<cfloop query="GetDepartments">
		<option value="#GetDepartments.DepartmentID#">#GetDepartments.Department#</option>
	</cfloop>
</select>
</cfoutput>
<br/>
<strong>Course/Section</strong><br/>
<input type="text" name="Course" value=""/>
</td>
</tr>
<tr>
<td>
<strong>Staff feedback/comment</strong><br/>
<textarea name="StaffFeedback" rows="4" cols="50">
</textarea>
</td>
</tr>
</table>
</div>
<div style="width: 29%; float: right;">
<p><strong>Patron Status</strong></p>
<cfoutput>
	<cfloop query="GetPatrons">
		<input type="radio" name="PatronType" value="#GetPatrons.PatronTypeID#" <cfif GetPatrons.PatronTypeID eq 7>checked</cfif>>&nbsp;#GetPatrons.PatronType#<br/>
	</cfloop>
</cfoutput>
<p><strong>Patron Feedback/Comment</strong></p>
<textarea name="PatronFeedback" rows="10" cols="25">
</textarea>
</div>
</div>
<div id="footer" style="clear:both;text-align:left; width: 98%; padding: 10px;">
<div style="margin: 5px;">
<input type="submit" name="SubmitIt" value="Submit" class="form">&nbsp;
<input type="reset" value="Reset" class="form" onClick="window.location.reload()">
<cfoutput>
<input type="hidden" name="UnitPointID" value="#URL.UnitPointID#">
<!---input type="hidden" name="UnitID" value="#UnitID#"--->
</cfoutput>
</div>
<div style="background-color: #DEDEDE;">
Scheduled Consultation? Use <a href="http://h-unitproj.library.ucla.edu/sia" target="_blank">SIA</a>.<br/>
<a href="category_definitions.cfm" target="_blank">Question Type Category Definitions and Guidelines for use</a>.<br/>
</div>
</div>
</div>
</form>
</body>
</html>
<!--
caller will pass in UnitPointID
page will retrieve distinct modes and questions for unit-point
upon submit, action page will:
loop through questions
create aggregate id as UnitPointID + current question type + single-valued mode type
submit dbo.ReferenceStatistics record as aggregate id, count = 1, date month/year as currently done, time = form.time/question count
end loop
determine if transaction occurred and add record as appropriate

refForm.cfm?UnitPointID=ART0003

-->
