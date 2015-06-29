
<CFHEADER NAME = "Expires" VALUE = "#Now()#">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<HTML>
<HEAD>
	<title>Select a date</title>
<LINK REL=STYLESHEET HREF="http://stats.library.ucla.edu/css/main.css" TYPE="text/css">
</HEAD>

<BODY bgcolor="#FFFFFF" TOPMARGIN="1" MARGINHEIGHT="1" MARGINWIDTH="1" LEFTMARGIN="1" LINK="#000099" VLINK="#0000CC">

<!--- Set the month and year parameters to equal the current values if they do not exist. --->
<CFPARAM NAME = "month" DEFAULT = "#DatePart('m', Now())#">
<CFPARAM NAME = "year" DEFAULT = "#DatePart('yyyy', Now())#">

<!--- Set the requested (or current) month/year date and determine the number of days in the month. --->
<CFSET ThisMonthYear = CreateDate(year, month, '1')>
<CFSET Days = DaysInMonth(ThisMonthYear)>

<!--- Set the values for the previous and next months for the back/next links. --->
<CFSET LastMonthYear = DateAdd('m', -1, ThisMonthYear)>
<CFSET LastMonth = DatePart('m', LastMonthYear)>
<CFSET LastYear = DatePart('yyyy', LastMonthYear)>

<CFSET NextMonthYear = DateAdd('m', 1, ThisMonthYear)>
<CFSET NextMonth = DatePart('m', NextMonthYear)>
<CFSET NextYear = DatePart('yyyy', NextMonthYear)>


<SCRIPT LANGUAGE = "JavaScript">
<!--

// function to populate the date on the form and to close this window. --->
function ShowDate(DayOfMonth) {
  if (DayOfMonth < 10) {
    DayOfMonth = "0" + DayOfMonth;
  }
	<CFOUTPUT>
var FormName = "#FormName#";
var FieldName = "#FieldName#";
var DateToShow = "<cfif month LT 10>0</cfif>#month#/" + DayOfMonth + "/#year#";
eval("self.opener.document." + FormName + "." + FieldName + ".value = DateToShow");
setTimeout('window.close()',500);
	</CFOUTPUT>
}

//-->
</SCRIPT>





<table width="200" border="0" cellspacing="0" cellpadding="1" bgcolor="#CCCCCC">

<CFOUTPUT>
<tr bgcolor="##666666">
	<td align="left" class="small"><A HREF = "select_date.cfm?month=#LastMonth#&year=#LastYear#&FormName=#FormName#&FieldName=#FieldName#"><img src="images/left4.gif" alt="#MonthAsString(LastMonth)#" width="11" height="11" border="0"></A>&nbsp;&nbsp;</td>
	<td align="center" class="menu"><b>#MonthAsString(month)#&nbsp;#year#</b></td>
	<td align="right" class="small">&nbsp;&nbsp;<A HREF = "select_date.cfm?month=#NextMonth#&year=#NextYear#&FormName=#FormName#&FieldName=#FieldName#"><img src="images/right4.gif" alt="#MonthAsString(NextMonth)#" width="11" height="11" border="0"></A></td>
</tr>
</CFOUTPUT>
<tr>
	<td colspan="3">

	<table width="100%" border="0" cellspacing="1" cellpadding="1">
	<TR>
	<CFLOOP FROM = "1" TO = "7" INDEX = "LoopDay">
	<CFOUTPUT>
		<td width="40" align="center" bgcolor="##CCCCCC" class="small">#Left(DayOfWeekAsString(LoopDay), 1)#</td>
	</CFOUTPUT>
	</CFLOOP>
	</TR>
<CFSET ThisDay = 0>

<CFLOOP CONDITION = "ThisDay LTE Days">
	<TR>
	<CFLOOP FROM = "1" TO = "7" INDEX = "LoopDay">
<CFIF ThisDay IS 0>
	<CFIF DayOfWeek(ThisMonthYear) IS LoopDay>
<CFSET ThisDay = 1>
	</CFIF>
</CFIF>
<CFIF (ThisDay IS NOT 0) AND (ThisDay LTE Days)>
	<CFOUTPUT>
		<td align="center" class="small"
			<cfif #CreateDate(year, month, ThisDay)# IS #DateFormat(Now())#>
			bgcolor="##FFFFCC"
			<cfelse>
			bgcolor="White"
			</cfif>
		>
		<A HREF = "javascript:ShowDate(#NumberFormat(ThisDay, 00)#)">#ThisDay#</A></td>
	</CFOUTPUT>
	<CFSET ThisDay = ThisDay + 1>
<CFELSE>
		<TD>&nbsp;</TD>
</CFIF>
	</CFLOOP>
	</TR>
</CFLOOP>

	</TABLE>

</td>
	</TR>
</TABLE>

</BODY>
</HTML>




