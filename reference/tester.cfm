<cfquery name="GetUnitPoint" datasource="#CircStatsDSN#">
	SELECT DISTINCT Unit, ServicePoint
	FROM View_RefUnitCategory
	WHERE
		UnitPointID = 'ART0003'
		AND InputMethodID = 2
</cfquery>

<cfquery name="GetTypes" datasource="#CircStatsDSN#">
	SELECT DISTINCT QuestionType, HelpText, TypeID
	FROM View_RefUnitCategory
	WHERE
		UnitPointID = 'ART0003'
		AND InputMethodID = 2
		AND (TypeID <> '00' AND TypeID <> '03' AND TypeID <> '04' AND TypeID <> '07' AND TypeID <> '08' AND ModeID <> '00')
	ORDER BY QuestionType
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
<option value="<cfoutput>#TimeFormat(CreateTime(H, 00, 00), "H:mm:ss tt")#</cfoutput>" <cfif Hour(Now()) is H>selected</cfif> class="small"><cfoutput>#TimeFormat(CreateTime(H, 00, 00), "h tt")
#</cfoutput> hour
</option>
</cfloop>
</select>
<br/>
</div>
</div>

<div id="menu" style="background-color:#FFFFFF;height:75%;width:75%;float:left; margin: 5px;">
<div id="types" style="background-color:#FFFFFF;height:98%;width:49%;float:left; margin: 5px;">
<strong>Question Type</strong><br/>
<cfoutput query="GetTypes">
<input type="checkbox" name="TypeID" value="#GetTypes.TypeID#">&nbsp;<strong>#GetTypes.QuestionType#</strong><br/>
</cfoutput>
</div>
<div id="text" style="background-color:#FFFFFF;height:98%;width:49%;float:left; margin: 5px;">
<cfoutput query="GetTypes">
&nbsp;<em>#GetTypes.HelpText#</em><br/>
</cfoutput>
</div>
</div>

<div id="content" style="background-color:#FFFFFF;height:75%;width:25%;float:left; margin: 5px;">
<strong>Mode</strong>
<br/>
<br/>
<strong>Total time (minutes)</strong><br/>
<input name="TimeSpent" type="text" length="25" value="" class="form">
</div>
<div id="footer" style="clear:both;text-align:left; width: 98%; padding: 10px;">
<div style="margin: 5px;">
<input type="submit" name="SubmitIt" value="Submit" class="form">&nbsp;
<input type="reset" value="Reset" class="form" onClick="window.location.reload()">
<cfoutput>
</cfoutput>
</div>
<div style="background-color: #DEDEDE;">
Research Consultation? Use <a href="http://sia.library.ucla.edu">SIA</a>.<br/>
<a href="category_definitions.cfm" target="_blank">Question Type Category Definitions and Guidelines for use</a>.<br/>
</div>
</div>
</div>
</form>
</body>
</html>
