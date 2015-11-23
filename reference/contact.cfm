<cfparam name="LogonID" default = "davmoto">
<cfparam name="Action" default = "Identify">
<cfparam name="EmailAddress" default = "">
<cfparam name="from" default="">
<cfparam name="subject" default="">


<cfquery name="GetUser" datasource="#CircStatsDSN#">
SELECT * FROM View_RefUserUnit
WHERE LogonID = '<cfoutput>#LogonID#</cfoutput>'
</cfquery>

<html>
<head>
	<title>UCLA Library Reference Statistics User Contact</title>
	<LINK REL=STYLESHEET HREF="../css/main.css" TYPE="text/css">
<script language="JavaScript">
<!--
function CloseWindow() {
			window.self.close();
          }
//-->
</script>
<script Language="JavaScript">

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
var SenderName = new validation('your name', 'SenderName', 'text', 'isText(str)', null);
var SenderEmail = new validation('email address', 'SenderEmail', 'text', 'isEmail(str)', null);
var Message = new validation('message', 'Message', 'text', 'isText(str)', null);

var elts = new Array(
               SenderName,
               SenderEmail,
			   Message
               );

var allAtOnce = false;

var beginRequestAlertForText = "Please include ";
var beginRequestAlertGeneric = "Please select ";
var endRequestAlert = ".";
var beginInvalidAlert = " is an invalid ";
var endInvalidAlert = "!";
var beginFormatAlert = "  Use this format: ";

function isText(str) {
  return (str != "");
}

function isRadio(formObj) {
  for (j=0; j<formObj.length; j++) {
    if (formObj[j].checked) {
      return true;
    }
  }
  return false;
}

function isSelect(formObj) {
  return (formObj.selectedIndex != 0);
}

function isCheck(formObj, form, begin, num) {
  for (j=begin; j<begin+num; j++) {
    if (form.elements[j].checked) {
      return true;
    }
  }
  return false;
}

function isEmail(str) {
  return ((str != "") && (str.indexOf("@") != -1) && (str.indexOf(".") != -1));
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

</script>
</HEAD>

<BODY BGCOLOR="#FFFFFF" LINK="#000099" VLINK="#0000CC">


<cfif GetUser.RecordCount IS 0>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr valign="middle">
	<td width="100%" height="80%" align="center" valign="middle" class="form"><strong>No user information available.</strong>

<form class="form">
<input type="button" value="Close window" class="form" onClick="JavaScript:CloseWindow()">
</form></td>
</tr>
</table>

<cfelse>

<cfif Action IS "Identify">
	<cfoutput query="GetUser">
<table border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="bottom">
	<td class="copy"><strong>Name</strong>:</td>
	<td class="copy">#FirstName# #LastName#</td>
</tr>
<tr valign="bottom">
	<td class="copy"><strong>Unit</strong>:</td>
	<td class="copy">#Unit#</td>
</tr>
<tr valign="bottom">
	<td class="copy"><strong>Email</strong>:</td>
	<td class="copy">#EmailAddress#</td>
</tr>
</table>
<br><br>
<table border="0" cellspacing="0" cellpadding="1">
<tr>
<form action="contact.cfm" method="post" class="form">
	<td>
<input type="submit" value="Email this person" class="form">
<input type="hidden" name="LogonID" value="#GetUser.LogonID#">
<input type="hidden" name="Action" value="Compose">
	</td>
	<td>
<input type="button" value="Cancel" class="form" onClick="JavaScript:CloseWindow()">
	</td>
	</td>
</form>
</tr>
</table>



	</cfoutput>
<cfelseif Action IS "Compose">

<cfoutput query="GetUser">
<table border="0"
       cellspacing="1"
       cellpadding="1">
<tr valign="middle">
<form action="contact.cfm"
      method="post"
      name="EmailForm"
      id="EmailForm"
      class="form"
      onSubmit="return validateForm(this)">
	<td class="tblcopy"><strong>From</strong> (your name):<br>
<input type="text" name="SenderName" size="30" maxlength="50" class="form">
	</td>
</tr>

<tr valign="middle">
	<td class="tblcopy"><strong>Your email address</strong>:<br>
<input type="text" name="SenderEmail" size="30" maxlength="50" class="form">
	</td>
</tr>

<tr valign="top">
	<td class="tblcopy"><strong>Your message</strong>:<br>
<textarea cols="40" rows="5" name="Message" class="form" size="24" maxlength="50"></textarea>
	</td>
<input type="hidden" name="Action" value="Send">
</tr>
</table>
</cfoutput>
<br><br>
<table border="0" cellspacing="0" cellpadding="1">
<tr>
	<td>
<input type="submit" value="Send" class="form">
	</td>
	<td>
<input type="reset" value="Reset" class="form">
	</td>
	<td>
<input type="button" value="Cancel" class="form" onClick="JavaScript:CloseWindow()">
	</td>
	</td>
</form>
</tr>
</table>






<cfelseif Action IS "Send">

<cfmail to="#GetUser.EmailAddress#" from="#SenderEmail#" subject="Reference Statistics">Dear #GetUser.FirstName# #GetUser.LastName#:

#Message#

From,
#SenderName#
</cfmail>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr valign="middle">
	<td width="100%" height="80%" align="center" valign="middle" class="form"><strong>Message sent.</strong>

<form class="form">
<input type="button" value="Close window" class="form" onClick="JavaScript:CloseWindow()">
</form></td>
</tr>
</table>


</cfif>

</cfif>

</body>
</html>
