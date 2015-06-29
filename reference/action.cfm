<cfif Find("form.cfm", HTTP_REFERER) is 0 and
	  Find("review.cfm", HTTP_REFERER) is 0>
	<cflocation url="index.cfm" addtoken="No">
	<cfabort>
</cfif>

<!--- if the session has expired, redirect to the index page --->
<cfif Session.IsValid is 0>
	<!--- if the input method is the real-time form --->
	<cfif FORM.InputMethod is 2>
		<html>
			<head>
				<title>Ref. Stats. Session Expired!</title>
				<link rel=stylesheet href="http://stats.library.ucla.edu/css/main.css" type="text/css">
				<script language="JavaScript">
					<!--
						setTimeout('location.reload(true)',1000*60*60); // forces a reload from the server

						function ChangeParentDocument(url)
						{
							opener.location = url;
							window.self.close();
						}
					//-->
				</script>
			</head>
			<body bgcolor="#C6C3C6" topmargin="0" marginheight="0" marginwidth="0" leftmargin="0" link="#000099" vlink="#0000CC">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr valign="middle">
						<td width="100%" height="80%" align="center" valign="middle" class="form">
							<strong><span class="red">Session Expired. Your transaction was not recorded.</span></strong>
							<form action="JavaScript:ChangeParentDocument('index.cfm')" method="post" class="form">
								<input type="submit" value="Restart Session" class="form">
							</form>
						</td>
					</tr>
				</table>
			</body>
		</html>
	<!--- if the input method is the monthly form --->
	<cfelse>
		<cflocation url="index.cfm" addtoken="No">
	</cfif>
	<cfabort>
</cfif>


<!-------------------------------------------------------
|        variable pre-processing and query execution     |
-------------------------------------------------------->
<cfset Action = "#FORM.Action#">
<cfset UnitID = "#FORM.UnitID#">
<cfif IsDefined("Session.LogonID")>
	<cfset LogonID = Session.LogonID>
<cfelse>
	<cfset LogonID = "davmoto">
</cfif>
<cfset DBStatus = 1>

<cfif Action is "Cancel">
	<cflocation url="index.cfm" addtoken="No">
	<cfabort>
</cfif>

<!--- query to get user account information for email function --->
<cfquery name="GetUserAccounts" datasource="#CircStatsDSN#">
	SELECT *
	FROM RefUserAccounts
	WHERE LogonID = '<cfoutput>#LogonID#</cfoutput>'
</cfquery>

<!--- if action is delete --->
<cfif Action is "Delete">
	<cfset RecordID = #FORM.RecordID#>
	<cfquery name="GetRecord" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_ReferenceStatistics
		WHERE RecordID = <cfoutput>#RecordID#</cfoutput>
	</cfquery>
</cfif>

<!--- if action is insert or update --->
<cfif Action is "Insert" or Action is "Update">
	<cfset ReferringURL = #URLEncodedFormat(HTTP.REFERER)#>
	<cfset BadData = 0>
	<cfset BlankForm = 0>
	<cfif Action is "Update">
		<cfset RecordID = #FORM.RecordID#>
	</cfif>
	<cfset InputMethod = #FORM.InputMethod#>
	<cfif InputMethod is 1>
		<cfset dataMonth = #FORM.dataMonth#>
		<cfset dataYear = #FORM.dataYear#>
		<cfset DateTime = "#DateFormat(Now(), "mm/dd/yyy")# #TimeFormat(Now(), "hh:mm:ss tt")#">
	<cfelseif InputMethod is 2>
		<cfparam name="UnitPointID" default="#FORM.UnitPointID#">
		<cfif #IsDefined("FORM.Date")#>
			<cfset Date = #FORM.Date#>
			<cfset dataYear = #Year(Date)#>
			<cfset dataMonth = #Month(Date)#>
			<cfset Day = #Day(Date)#>
		<cfelse>
			<cfset Date = #DateFormat(Now(), "m/d/yyyy")#>
			<cfset dataYear = #Year(Date)#>
			<cfset dataMonth = #Month(Date)#>
			<cfset Day = #Day(Date)#>
		</cfif>
		<cfif #IsDefined("FORM.Hour")#>
			<cfset Hour = #FORM.Hour#>
			<cfset Hour = #TimeFormat(Hour, "hh:mm:ss tt")#>
		<cfelse>
			<cfset Hour = #TimeFormat(Now(), "h tt")#>
		</cfif>
		<cfset DateTime = "#dataMonth#/#Day#/#dataYear# #Hour#">
	</cfif>

	<!--- load just the aggregateID/value pairs into a structure --->
	<cfset AggregateIDValue = StructNew()>
	<cfloop collection="#Form#" item="VarName">
		<cfif Find(LCase(UnitID), LCase(VarName)) and (not Find('_long', LCase(VarName))) and FORM[VarName] is not "">
			<cfset val = StructInsert(AggregateIDValue, "#VarName#", "#Replace(Replace(Form[VarName], ",", "", "ALL"), " ", "", "ALL")#")>
		</cfif>
	</cfloop>

	<cfset LongQuestValue = StructNew()>
	<cfloop collection="#Form#" item="VarName">
		<cfif Find('_long', LCase(VarName)) and FORM[VarName] is not "">
			<cfset val = StructInsert(LongQuestValue, "#VarName#", "#Replace(Replace(Form[VarName], ",", "", "ALL"), " ", "", "ALL")#")>
		</cfif>
	</cfloop>

	<cfif InputMethod is 2>
		<!--- check to see if a blank form was submitted --->
		<cfif StructIsEmpty(AggregateIDValue)>
			<cfset BlankForm = 1>
		<cfelse>
			<cfset BlankForm = 0>
		</cfif>

		<!--- check for non-numeric characters --->
		<cfloop collection="#AggregateIDValue#" item="VarName">
			<cfif ReFind("[[:punct:]]", AggregateIDValue[VarName]) is 0 and
				  IsNumeric(AggregateIDValue[VarName]) is 1>
				<cfset BadData = 0>
			<cfelse>
				<cfset BadData = 1>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif BadData or BlankForm>
			<cflocation url="confirm.cfm?InputMethod=2&DBStatus=-1&ReferringURL=#ReferringURL#" addtoken="No">
			<cfabort>
		</cfif>
	</cfif>

	<!--- query to get human descriptions of aggregate ids of statistical categories --->
	<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_RefUnitCategory
		WHERE
		<cfif InputMethod is 1>
			UnitID = '#UnitID#'
		<cfelseif InputMethod is 2>
			UnitPointID = '#UnitPointID#'
		</cfif>
			and AggregateID IN (
			<cfif Action is "Insert">
				<cfset i = 1>
				<cfloop collection="#AggregateIDValue#" item="AggregateID">
					<cfif i is 1>
						'#AggregateID#'
					<cfelseif i GT 1>
						, '#AggregateID#'
					</cfif>
					<cfset i = i + 1>
				</cfloop>
			<cfelseif Action is "Update" or Action is "Delete">
				'#AggregateID#'
			</cfif>)
		ORDER BY PointID, TypeID
	</cfquery>

	<cfif Action is "Insert">
		<!--- concatenate the variable-value list to be fed to stored procedure --->
		<cfset CategoryValueList = "">
		<cfloop collection="#AggregateIDValue#" item="AggregateID">
			<cfif Find(UnitID, AggregateID)>
				<cfset CategoryValueList = CategoryValueList & ',' & AggregateID & ',' & AggregateIDValue[AggregateID]>
			</cfif>
		</cfloop>
		<cfset CategoryValueList = RemoveChars(CategoryValueList, 1, 1)>
		<cfset QuestionValueList = "">
		<cfif not StructIsEmpty(LongQuestValue)>
			<cfloop collection="#LongQuestValue#" item="QuestID">
				<cfif Find(UnitID, QuestID)>
					<cfset QuestionValueList = QuestionValueList & ',' & QuestID>
				</cfif>
			</cfloop>
			<cfset QuestionValueList = RemoveChars(QuestionValueList, 1, 1)>
		</cfif>
	</cfif>
</cfif>


<!-------------------------------------------------------
|               call to stored procedures                |
-------------------------------------------------------->

<cfswitch expression="#Action#">
	<cfcase value="Insert">
		<cftry>
			<cfstoredproc procedure="usp_Insert_Ref_Stats" datasource="#CircStatsDSN#" returncode="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CategoryValueList" value="#CategoryValueList#" maxlength="8000" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataMonth" value="#dataMonth#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataYear" value="#dataYear#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@DateTime" value="#DateTime#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@LogonID" value="#LogonID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@InputMethod" value="#InputMethod#" null="No">
			</cfstoredproc>
			<cfcatch type="Database">
				<cfset DBStatus = -1>
			</cfcatch>
		</cftry>
		<cfif ListLen(QuestionValueList) neq 0>
			<cfloop index="theQuest" list="#QuestionValueList#">
				<cftry>
					<cfstoredproc procedure="usp_Insert_Ref_Stats_Long_Quest" datasource="#CircStatsDSN#" returncode="Yes">
						<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@UnitID" value="#Mid(theQuest, 1, 5)#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@PointID" value="#Mid(theQuest, 6, 2)#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TypeID" value="#Mid(theQuest, 8, 2)#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataMonth" value="#dataMonth#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataYear" value="#dataYear#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@DateTime" value="#DateTime#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@LogonID" value="#LogonID#" null="No">
						<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@InputMethod" value="#InputMethod#" null="No">
					</cfstoredproc>
					<cfcatch type="Database">
						<cfset DBStatus = -1>
					</cfcatch>
				</cftry>
			</cfloop>
		</cfif>
	</cfcase>

	<cfcase value="Update">
		<cftry>
			<cfstoredproc procedure="usp_Update_Ref_Stats" datasource="#CircStatsDSN#" returncode="Yes">
				<cfprocparam type="IN" dbvarname="@RecordID" value="#RecordID#" cfsqltype="CF_SQL_INTEGER">
				<cfprocparam type="IN" dbvarname="@AggregateID" value="#AggregateID#" cfsqltype="CF_SQL_VARCHAR" >
				<cfprocparam type="IN" dbvarname="@Count" value="#Count#" cfsqltype="CF_SQL_INTEGER">
				<cfprocparam type="IN" dbvarname="@dataMonth" value="#dataMonth#" cfsqltype="CF_SQL_INTEGER">
				<cfprocparam type="IN" dbvarname="@dataYear" value="#dataYear#" cfsqltype="CF_SQL_INTEGER">
				<cfprocparam type="IN" dbvarname="@LogonID" value="#LogonID#" cfsqltype="CF_SQL_VARCHAR">
				<cfprocparam type="IN" dbvarname="@InputMethod" value="#InputMethod#" cfsqltype="CF_SQL_INTEGER">
			</cfstoredproc>
			<cfcatch type="Database">
				<cfset DBStatus = -1>
			</cfcatch>
		</cftry>
	</cfcase>

	<cfcase value="Delete">
		<cftry>
			<cfstoredproc procedure="usp_Delete_Ref_Stats" datasource="#CircStatsDSN#" returncode="Yes">
				<cfprocparam type="IN" dbvarname="@RecordID" value="#RecordID#" cfsqltype="CF_SQL_INTEGER">
			</cfstoredproc>
			<cfcatch type="Database">
				<cfset DBStatus = -1>
			</cfcatch>
		</cftry>
	</cfcase>
</cfswitch>

<!-------------------------------------------------------
|  email after stored procedures executed successfully   |
-------------------------------------------------------->

<cfif cfstoredproc.statuscode is 0 and DBStatus is not -1>
	<cfswitch expression="#Action#">
		<cfcase value="Insert">
			<cfif InputMethod is 1>
				<!--- send email confirming the successful input --->
				<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Ref. Data Input Successful">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

				Your reference statistics data input was successful. The following is a transcript of your transaction. We recommend saving this transcript for your records.

				AggregateID-------Unit-------Service Point-------Question Type-------Mode-------Count-------Mo/Yr
				<cfloop query="GetUnitCategory"><cfloop collection="#AggregateIDValue#" item="VarName"><cfif VarName is AggregateID>#VarName#-------#Unit#-------#ServicePoint#-------#QuestionType#-------<cfif Mode is not "Transaction">#Mode#<cfelse>N/A</cfif>-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
				</cfif></cfloop></cfloop>
				Executed on: #Now()#
				</cfmail>
			</cfif>
		</cfcase>

		<cfcase value="Update">
			<!--- send email confirming the successful update --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Ref. Data Update Successful">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

			Your reference statistics data edit was successful. The following is a transcript of your transaction. We recommend saving this transcript for your records.

			RecordID-------AggregateID-------Unit-------Service Point-------Question Type-------Mode-------Count-------Mo/Yr
			#RecordID#-------<cfloop query="GetUnitCategory"><cfloop collection="#AggregateIDValue#" item="VarName"><cfif VarName is AggregateID>#VarName#-------#Unit#-------#ServicePoint#-------#QuestionType#-------<cfif Mode is not "Transaction">#Mode#<cfelse>N/A</cfif>-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
			</cfif></cfloop></cfloop>
			Executed on: #Now()#
			</cfmail>
		</cfcase>

		<cfcase value="Delete">
			<!--- send email confirming the successful update --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Ref. Data Deletion Successful">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

			Your reference statistics data deletion was successful. The following is a transcript of your transaction. We recommend saving this transcript for your records. The following record was deleted:

			RecordID-------AggregateID-------Unit-------Service Point-------Question Type-------Mode-------Count-------Mo/Yr
			#GetRecord.RecordID#-------#GetRecord.AggregateID#-------#GetRecord.Unit#-------#GetRecord.ServicePoint#-------#GetRecord.QuestionType#-------<cfif GetRecord.Mode is not "Transaction">#GetRecord.Mode#<cfelse>N/A</cfif>-------#GetRecord.Count#-------#GetRecord.dataMonth#/#GetRecord.dataYear#
			Executed on: #Now()#
			</cfmail>
		</cfcase>
	</cfswitch>
</cfif>

<!-------------------------------------------------------
|    email after stored procedures execution failed      |
-------------------------------------------------------->

<cfif cfstoredproc.statuscode is not 0 or DBStatus is -1>
	<cfswitch expression="#Action#">
		<cfcase value="Insert">
			<!--- send email notifying the failed input --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Ref. Data Input Failed" cc="davmoto@library.ucla.edu">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

			Your reference statistics data input failed. The problem may be due to a server error and the system administrator has been notified. The following is a transcript of your attempted transaction. We recommend saving this transcript for your records.

			AggregateID-------Unit-------Service Point-------Question Type-------Mode-------Count-------Mo/Yr
			<cfloop query="GetUnitCategory"><cfloop collection="#AggregateIDValue#" item="VarName"><cfif VarName is AggregateID>#VarName#-------#Unit#-------#ServicePoint#-------#QuestionType#-------<cfif Mode is not "Transaction">#Mode#<cfelse>N/A</cfif>-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
			</cfif></cfloop></cfloop>
			Executed on: #Now()#</cfmail>
		</cfcase>

		<cfcase value="Update">
			<!--- send email notifying the failed input --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Ref. Data Update Failed" cc="davmoto@library.ucla.edu">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

			Your reference statistics data edit failed. The problem may be due to a server error and the system administrator has been notified. The following is a transcript of your attempted transaction. We recommend saving this transcript for your records.

			AggregateID-------Unit-------Service Point-------Question Type-------Mode-------Count-------Mo/Yr
			<cfloop query="GetUnitCategory"><cfloop collection="#AggregateIDValue#" item="VarName"><cfif VarName is AggregateID>#VarName#-------#Unit#-------#ServicePoint#-------#QuestionType#-------<cfif Mode is not "Transaction">#Mode#<cfelse>N/A</cfif>-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
			</cfif></cfloop></cfloop>
			Executed on: #Now()#</cfmail>
		</cfcase>

		<cfcase value="Delete">
			<!--- send email notifying the failed input --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Ref. Data Deletion Failed" cc="davmoto@library.ucla.edu">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

			Your reference statistics data deletion failed. The problem may be due to a server error and the system administrator has been notified. The following is a transcript of your attempted transaction. We recommend saving this transcript for your records. The deletion of the following record was not successful:

			RecordID-------AggregateID-------Unit-------Service Point-------Question Type-------Mode-------Count-------Mo/Yr
			#GetRecord.RecordID#-------#GetRecord.AggregateID#-------#GetRecord.Unit#-------#GetRecord.ServicePoint#-------#GetRecord.QuestionType#-------<cfif GetRecord.Mode is not "Transaction">#GetRecord.Mode#<cfelse>N/A</cfif>-------#GetRecord.Count#-------#GetRecord.dataMonth#/#GetRecord.dataYear#
			Executed on: #Now()#</cfmail>
		</cfcase>
	</cfswitch>
</cfif>

<!-------------------------------------------------------
| redirect after stored procedures executed successfully |
-------------------------------------------------------->

<cfif cfstoredproc.statuscode is 0 and DBStatus is not -1>
	<cfswitch expression="#Action#">
		<cfcase value="Insert">
			<cfif InputMethod is 1>
				<cflocation url="confirm.cfm?Action=#Action#&InputMethod=1&DBStatus=1&UnitID=#UnitID#" addtoken="No">
			<cfelseif InputMethod is 2>
				<cflocation url="confirm.cfm?InputMethod=2&DBStatus=1&ReferringURL=#ReferringURL#" addtoken="No">
			</cfif>
		</cfcase>

		<cfcase value="Update">
			<cfif InputMethod is 1>
				<cflocation url="confirm.cfm?Action=#Action#&InputMethod=1&DBStatus=1&UnitID=#UnitID#" addtoken="No">
			</cfif>
		</cfcase>

		<cfcase value="Delete">
			<cfif InputMethod is 1>
				<cflocation url="confirm.cfm?Action=#Action#&InputMethod=1&DBStatus=1&UnitID=#UnitID#" addtoken="No">
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>

<!-------------------------------------------------------
|   redirect after stored procedures execution failed    |
-------------------------------------------------------->

<cfif cfstoredproc.statuscode is not 0 or DBStatus is -1>
	<cfswitch expression="#Action#">
		<cfcase value="Insert">
			<cfif InputMethod is 1>
				<cflocation url="confirm.cfm?Action=#Action#&Status=-1&UnitID=#UnitID#" addtoken="No">
			<cfelseif InputMethod is 2>
				<cflocation url="confirm.cfm?InputMethod=2&DBStatus=1&ReferringURL=#ReferringURL#" addtoken="No">
			</cfif>
		</cfcase>

		<cfcase value="Update">
			<cfif InputMethod is 1>
				<cflocation url="confirm.cfm?Action=#Action#&Status=-1&UnitID=#UnitID#" addtoken="No">
			</cfif>
		</cfcase>

		<cfcase value="Delete">
			<cfif InputMethod is 1>
				<cflocation url="confirm.cfm?Action=#Action#&Status=-1&UnitID=#UnitID#" addtoken="No">
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>