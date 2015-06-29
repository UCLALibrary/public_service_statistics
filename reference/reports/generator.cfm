<CFPARAM NAME = "Text" DEFAULT = 0>
<CFPARAM NAME = "Step" DEFAULT = 1>
<cfparam name="LogonID" default = #RemoveChars(AUTH_USER, 1, Find("\", AUTH_USER))#>

<cfif IsDefined("URL.Level")>
	<CFPARAM NAME = "Level" DEFAULT = "#URL.Level#">
<cfelseif IsDefined("FORM.Level")>
	<CFPARAM NAME = "Level" DEFAULT = "#FORM.Level#">
</cfif>

<cfif IsDefined("URL.UnitID")>
	<CFPARAM NAME = "UnitID" DEFAULT = "#URL.UnitID#">
<cfelseif IsDefined("FORM.UnitID")>
	<CFPARAM NAME = "UnitID" DEFAULT = "#FORM.UnitID#">
</cfif>

<cfif IsDefined("FORM.Start1")>
	<cfset Start1 = "#FORM.Start1#">
	<cfset End1 = "#FORM.End1#">
<cfelse>
	<cfset Start1 = "">
	<cfset End1 = "">
</cfif>

<!---
<cfif IsDefined("FORM.LogonID")>
	<cfset LogonID = "#FORM.LogonID#">
<cfelse>
	<cfset LogonID = "miki">
</cfif>
--->

<cfif IsDefined("FORM.ReportType")>
	<cfset ReportType = "#FORM.ReportType#">
<cfelse>
	<cfset ReportType = 0>
</cfif>

<cfif Level IS "Unit" OR Level is "SubUnit">
<!--- call to query to get unit information --->
  <cfinclude template="objects/qryGetUnits.cfm">
<cfelseif Level IS "Account">
<!--- call to query to get user acconts --->
  <cfinclude template="objects/qryGetAccounts.cfm">
</cfif>

<html>
<head>

<!--- step 1 select library and unit --->
<cfif (Level IS "Unit" OR Level IS "Subunit") AND Step IS 1>
  <script language="JavaScript">
//<!-- function for library and department select menu
function getDepartment(myForm, myArray, sliceLength) {
  var arrayLength = myArray.length;
  var selLibraryIndex = myForm.library.selectedIndex;
  var selLibrary = myForm.library.options[selLibraryIndex].text;
  myForm.department.options.length = 0;
  myForm.department.options[0] = new  Option("- Select a department -", "");
  var departmentIndex = 1;
  if ((!myForm.name.match(/buy/)) && (!myForm.name.match(/cat/))) {
    myForm.department.options[departmentIndex] =
      new Option ("All departments", "alldept");
      departmentIndex++;
  }
  for (var i=0;i<arrayLength;i++) {
    if (selLibrary == myArray[i][0]) {
      for (var j=1;j<myArray[i].length;j++) {
        var splitArray = myArray[i][j].split(":");
        var departmentName = splitArray[0];
        var value = splitArray[1];
        if (!departmentName.match(/.Discontinued./)) {
          myForm.department.options[departmentIndex] =
            new Option (departmentName.slice(0,sliceLength), value);
          departmentIndex++;
        }
      } // for j
    }
  } // for i
  myForm.department.selectedIndex = 0;
  myForm.department.disabled = false;
  myForm.department.focus();
}
function LibraryDepartmentSubmitCheck(myForm, type) {
  var selLibraryIndex = myForm.library.selectedIndex;
  var selDepartmentIndex = myForm.department.selectedIndex;
  var urlstr;
  if ((myForm.library.options[selLibraryIndex].value) &&
  (myForm.department.options[selDepartmentIndex].value)) {
	if (myForm.department.options[selDepartmentIndex].value == "alldept") {
    urlstr = "generator.cfm?Step=2&Level=Unit&UnitID=" +
    myForm.library.options[selLibraryIndex].value;
    }
    else {
    urlstr = "generator.cfm?Step=2&Level=SubUnit&UnitID=" +
    myForm.department.options[selDepartmentIndex].value;
    }
    window.location = urlstr;
  } // if
  else {
    alert("Please select both a library and department");
  }
}
// -->
  </script>
</cfif>

<!--- step 2 report type and date range --->
<cfif (Level IS "Library" AND Step EQ 1) OR Step IS 2 OR (Level IS "Account" AND Step EQ 1)>
  <cfset ThisDate = DateFormat(Now(), "mm/dd/yyyy")>
  <cfset ThisYear = Year(Now())>
  <cfset ThisMonth = Month(Now())>  
  <cfif ThisMonth GTE 1 AND ThisMonth LTE 6>
	<cfset CurrFYStart = ThisYear - 1>
	<cfset CurrFYEnd = ThisYear>
	<cfset PrevFYStart = ThisYear - 2>
	<cfset PrevFYEnd = ThisYear - 1>
  <cfelseif ThisMonth GTE 7 AND ThisMonth LTE 12>
	<cfset CurrFYStart = ThisYear>
	<cfset CurrFYEnd = ThisYear + 1>
	<cfset PrevFYStart = ThisYear - 1>
	<cfset PrevFYEnd = ThisYear>
  </cfif>
  <script language="JavaScript">
//<!-- function to popup about reports
function AboutReport(QueryString) {
_loc = 'about_report.cfm?' + QueryString;
popupsWin = window.open(_loc,"PSpopups","toolbar=no,width=500,height=500,scrollbars=yes,resizable=no");
if (popupsWin.opener == null) { popupsWin.opener = self }
} 
// -->

//<!-- function to automatically set start and end dates to current fiscal year
function SetFiscal() {
  var Start1 = '<cfoutput>07/01/#CurrFYStart#</cfoutput>';
  var End1 = '<cfoutput>#ThisDate#</cfoutput>';
  if (document.TypeSpan.FYYTD.checked == false) {
    var Start1 = '';
    var End1 = '';
  }
  document.TypeSpan.Start1.value = Start1;
  document.TypeSpan.End1.value = End1;  
} 
// -->

//<!-- function to clear dates
function ResetDate() {
  document.TypeSpan.FYYTD.checked = false;
  document.TypeSpan.Start1.value = '';
  document.TypeSpan.End1.value = '';
} 
// -->

//<!-- function to load the calendar window
function ShowCalendar(FormName, FieldName) {
  window.open("../select_date.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=200,height=150,left=400,top=150");
  if (document.TypeSpan.FYYTD.checked) {
  document.TypeSpan.FYYTD.checked = false;
  document.TypeSpan.Start1.value = '';
  document.TypeSpan.End1.value = '';
  }
}
// end function -->

//<!-- function to validate date range form

// check for IE3
var isIE3 = (navigator.appVersion.indexOf('MSIE 3') != -1);
// object definition
function validation(realName, formEltName, eltType, upToSnuff, format) {
  this.realName = realName;
  this.formEltName = formEltName;
  this.eltType = eltType;
  this.upToSnuff = upToSnuff;
  this.format = format;
}
// create a new object for each form element you need to validate
            <cfif Level IS NOT "Account">
var ReportType = new validation('report type', 'ReportType', 'radio', 'isRadio(formObj)', null);
            </cfif>
            <cfif Level IS "Account">
var LogonID = new validation('user account', 'LogonID', 'select', 'isSelect(formObj)', null);
            </cfif>
var Start1 = new validation('start date', 'Start1', 'text', 'isDate(str)', 'mm/dd/yyyy');
var End1 = new validation('end date', 'End1', 'text', 'isDate(str)', 'mm/dd/yyyy');
var elts = new Array(
            <cfif Level IS NOT "Account">
			   ReportType,
            </cfif>
            <cfif Level IS "Account">
			   LogonID,
            </cfif>
			   Start1,
               End1
               );
var allAtOnce = false;
var beginRequestAlertForText = "Please include ";
var beginRequestAlertGeneric = "Please select a  ";
var endRequestAlert = ".";
var beginInvalidAlert = " is an invalid ";
var endInvalidAlert = "!";
var beginFormatAlert = "  Use this format: ";

function isSelect(formObj) {
  return (formObj.selectedIndex != 0);
}

function isRadio(formObj) {
  for (j=0; j<formObj.length; j++) {
    if (formObj[j].checked) {
      return true;
    }
  }
  return false;
}

function isDate(str) {
  if (str.length != 10) { return false }

  for (j=0; j<str.length; j++) {
    if ((j == 2) || (j == 5)) {
      if (str.charAt(j) != "/") { return false }
    } else {
      if ((str.charAt(j) < "0") || (str.charAt(j) > "9")) { return false }
    }
  }

  var month = str.charAt(0) == "0" ? parseInt(str.substring(1,2)) : parseInt(str.substring(0,2));
  var day = str.charAt(3) == "0" ? parseInt(str.substring(4,5)) : parseInt(str.substring(3,5));
  var begin = str.charAt(6) == "0" ? (str.charAt(7) == "0" ? (str.charAt(8) == "0" ? 9 : 8) : 7) : 6;
  var year = parseInt(str.substring(begin, 10));

  if (day == 0) { return false }
  if (month == 0 || month > 12) { return false }
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
    if (day > 31) { return false }
  } else {
    if (month == 4 || month == 6 || month == 9 || month == 11) {
      if (day > 30) { return false }
    } else {
      if (year%4 != 0) {
        if (day > 28) { return false }
      } else {
        if (day > 29) { return false }
      }
    }
  }
  return true;
}

function validateForm(form) {
  var formEltName = "";
  var formObj = "";
  var str = "";
  var realName = "";
  var alertText = "";
  var firstMissingElt = null;
  var hardReturn = "\r\n";

  for (i=0; i<elts.length; i++) {
    formEltName = elts[i].formEltName;
    formObj = eval("form." + formEltName);
    realName = elts[i].realName;

    if (elts[i].eltType == "text") {
      str = formObj.value;

      if (eval(elts[i].upToSnuff)) continue;

      if (str == "") {
        if (allAtOnce) {
          alertText += beginRequestAlertForText + realName + endRequestAlert + hardReturn;
          if (firstMissingElt == null) {firstMissingElt = formObj};
        } else {
          alertText = beginRequestAlertForText + realName + endRequestAlert + hardReturn;
          alert(alertText);
        }
      } else {
        if (allAtOnce) {
          alertText += str + beginInvalidAlert + realName + endInvalidAlert + hardReturn;
        } else {
          alertText = str + beginInvalidAlert + realName + endInvalidAlert + hardReturn;
        }
        if (elts[i].format != null) {
          alertText += beginFormatAlert + elts[i].format + hardReturn;
        }
        if (allAtOnce) {
          if (firstMissingElt == null) {firstMissingElt = formObj};
        } else {
          alert(alertText);
        }
      }
    } else {
      if (eval(elts[i].upToSnuff)) continue;
      if (allAtOnce) {
        alertText += beginRequestAlertGeneric + realName + endRequestAlert + hardReturn;
        if (firstMissingElt == null) {firstMissingElt = formObj};
      } else {
        alertText = beginRequestAlertGeneric + realName + endRequestAlert + hardReturn;
        alert(alertText);
      }
    }
    if (!isIE3) {
      var goToObj = (allAtOnce) ? firstMissingElt : formObj;
      if (goToObj.select) goToObj.select();
      if (goToObj.focus) goToObj.focus();
    }
    if (!allAtOnce) {return false};
  }
  if (allAtOnce) {
    if (alertText != "") {
      alert(alertText);
      return false;
    }
  } 
  return true;
}

// -->
  </script>
</cfif>

<!--- call to list of report titles switch statement --->
<cfif Step GT 2>
  <cfinclude template="objects/tmpReportTitles.cfm">
</cfif>

	<title>UCLA Library Reference Statistics <cfif Level IS "Library">
Library-Wide
<cfelseif Level IS "Unit" OR Level IS "SubUnit">
Unit-Specific
<cfelseif Level IS "Account">
Individual Account
</cfif> Report Generator
    </title>

<cfif Text IS 0>
	<cfinclude template="../../../library_pageincludes/banner_nonav.cfm">
</cfif>
<cfif Text IS 1>
	<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../index.cfm">Public Service Statistics</a> &gt; <a href="../index.cfm">Reference</a> &gt;
<cfif Level IS "Library">
Library-Wide
<cfelseif Level IS "Unit" OR Level IS "SubUnit">
Unit-Specific
<cfelseif Level IS "Account">
Individual Account
</cfif> Report Generator

<!-- end you are here -->

<cfif Text IS 0>
	<cfinclude template="../../../library_pageincludes/start_content_nonav.cfm">
</cfif>
<cfif Text IS 1>
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->


<!--- step 1: select a library and department --->
<cfif Level IS "Unit" AND Step EQ 1>

<h2>Unit-Specific Report Generator</h2>

<h3>Step 1: Select a library and department</h3>
<form name="LibraryForm">
	<table border="0" cellspacing="0" cellpadding="8">
	<tr valign="top">
		<td class="form">
<strong>First select a library:</strong><br>
<select name="library" onChange="getDepartment(LibraryForm, departmentArray, 100)" class="form">
<script language="JavaScript">
<!-- 
document.write('<option value="" selected class="form">- Select a library -');
// -->
</script>
<cfoutput query="GetParentUnit">
<option value="#ParentUnitID#">#ParentUnit#</option>
</cfoutput>
</select>
		</td>
	</tr>
	<tr valign="top">
		<td class="form">
<strong>Then select a department:</strong><br>
<script language="JavaScript">
<!-- 
document.LibraryForm.library.disabled = true;
document.write('<select name="department" disabled  class="form">');
document.write('<option value="" selected>- Select a department -');
document.write('<option value="">- Please select a library first -');
document.write('</select>');
// -->
</script>
<script language="JavaScript">
<!-- 
var librarynum = <cfoutput>#LibCount#</cfoutput>;
var departmentArray = new Array(<cfoutput>#LibCount#</cfoutput>);
<cfset i = 0>
<cfoutput query="GetParentSubUnit" group="ParentUnit">
departmentArray[#i#] = new Array("#ParentUnit#"<cfoutput group="UnitID">,"#SubUnit#:#UnitID#"</cfoutput>);
<cfset i = i + 1>
</cfoutput>
  document.LibraryForm.library.selectedIndex = 0;
  document.LibraryForm.library.disabled = false;
  document.LibraryForm.department.disabled = false;
// -->
</script>
		</td>
	</tr>
	<tr valign="top">
		<td>
<script language="JavaScript">
<!-- 
document.write('<input type="button" onClick="window.location.reload()" value="Start over" class="form">');
document.write('&nbsp;<input type="button" name="submitbutton1" value="Continue >" onClick="LibraryDepartmentSubmitCheck(LibraryForm, \'ncg\')" class="form">');
// -->
</script>
      <noscript>
        <input type="submit" value="Research" class="form">
      </noscript>
		</td>
	</tr>
	</table>
</form>
</cfif>

<!--- step 2: select a report type and date range --->
<cfif (Level IS "Library" AND Step EQ 1) OR
      ((Level IS "Unit" OR Level IS "SubUnit") AND Step GT 1) OR
	  Level IS "Account" AND Step EQ 1>
  <cfoutput>

    <cfif Level IS "Unit" OR Level IS "SubUnit">
<form action="generator.cfm?Step=1" class="form">
<input type="hidden" name="Level" value="Unit">
    <cfelseif Level IS "Library" OR Level IS "Account">
<form action="../index.cfm" class="form">
    </cfif>
<input type="submit" value="< Back" class="form">
</form>


    <cfif Level IS "Unit" OR Level IS "SubUnit" OR Level IS "Library">
<h3><cfif Level IS NOT "Library">Step 2: </cfif>Select a report type and date range</h3>	
	<cfelseif Level IS "Account">
<h3>
     <cfif LogonID neq "">
Generate a report for account: #GetAccounts.LogonID# (#GetAccounts.FirstName# #GetAccounts.LastName#)
     <cfelse>
Problem generating an account-specific report. Contact David Yamamoto at extension 7-2682.
     </cfif>
</h3>
	</cfif>


    <cfif (Level is "Account" and LogonID neq "") or Level is "Unit" or Level is "Library" or level is "SubUnit">
    <cfif Level IS "Unit" OR Level IS "SubUnit">
<form action="report_unit.cfm"
    <cfelseif Level IS "Library">
<form action="report.cfm"
    <cfelseif Level IS "Account">
<form action="report_account.cfm"
    </cfif>
      method="post"
      name="TypeSpan"
      id="TypeSpan"
      onSubmit="return validateForm(this)">
<input type="hidden" name="Step" value="#Step#">
<input type="hidden" name="Level" value="#Level#">
  <cfif (Level IS "Unit" OR Level IS "SubUnit") AND Step GT 1>
<input type="hidden" name="UnitID" value="#UnitID#">
  </cfif>
	<table border="0" cellspacing="0" cellpadding="8">
  <cfif Level IS "Unit" OR Level IS "SubUnit">
	<tr valign="top">
		<td class="form">
<strong>Unit<cfif (Level IS "SubUnit") AND ("#GetParentUnit.ParentUnit#" IS NOT "#GetParentSubUnit.SubUnit#")> and department</cfif> selected:</strong> 
  #GetParentUnit.ParentUnit# <cfif Level IS "Unit">(all departments)</cfif>
    <cfif (Level IS "SubUnit") AND ("#GetParentUnit.ParentUnit#" IS NOT "#GetParentSubUnit.SubUnit#")>
	  #GetParentSubUnit.SubUnit#
    </cfif>
		</td>
	</tr>
  </cfif>
  <cfif Level IS NOT "Account">
	<tr valign="top">
		<td class="form">
<strong>Report type:</strong><br>
<input type="radio" name="ReportType" value="1" class="form" <cfif ReportType IS 1>CHECKED</cfif>>Total transactions<br>
<input type="radio" name="ReportType" value="2" class="form" <cfif ReportType IS 2>CHECKED</cfif>>Total questions<br>
		</td>
	</tr>
  </cfif>
  
<!--- form elements to select date range --->
	<tr valign="top">
		<td class="form">
		<strong>Date range:</strong><br>
		<input type="checkbox" name="FYYTD" value="1" class="form" onClick="Javascript:SetFiscal()">Current fiscal year-to-date<br><br>
		<table border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td class="form">Start:</td>
			<td class="form">End:</td>
		</tr>
		<tr>
			<td class="form"><input type="text" name="Start1" size="12" maxlength="10" class="form" value="#Start1#"><a href="javascript:ShowCalendar('TypeSpan', 'Start1')"><img src="../images/calendar.gif" alt="Select a date" width="16" height="15" border="0" align="absmiddle"></a></td>
			<td class="form"><input type="text" name="End1" size="12" maxlength="10" class="form" value="#End1#"><a href="javascript:ShowCalendar('TypeSpan', 'End1')"><img src="../images/calendar.gif" alt="Select a date" width="16" height="15" border="0" align="absmiddle"></a></td>
			<td width="10" class="form">&nbsp;</td>
			<td class="form"><input type="button" name="ClearDate" value="Clear dates" class="form" onClick="JavaScript:ResetDate()"></td>
		</tr>
		<tr>
			<td colspan="2" class="form">(enter as mm/dd/yyyy)</td>
		</tr>
		</table>
		</td>
	</tr>


<!--- back and continue buttons --->
	<tr valign="top">
		<td>
  <cfif Level IS NOT "Library">
		<input type="button" value="< Back" onClick="parent.location='generator.cfm?Level=#Level#&Step=1'" class="form">
  </cfif>
  <cfif Level is "Account">
        <input type="hidden" name="LogonID" value="#LogonID#">
  </cfif>
		<input type="submit" value="Generate report" class="form">
		</td>
	</tr>
</form>
	</table>
   </cfif>
  </cfoutput>
</cfif>

<cfif Text IS 0>
	<cfinclude template="../../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS 1>
	<cfinclude template="../../../library_pageincludes/footer_nonav_txt.cfm">	
</cfif>

