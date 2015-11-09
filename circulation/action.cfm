<cfif Find("circulation/form.cfm", HTTP_REFERER) IS 0 AND
	  Find("circulation/review.cfm", HTTP_REFERER) IS 0>
	<cflocation url="home.cfm" addtoken="No">
	<cfabort>
</cfif>

<cfif Session.IsValid IS 0>
	<cflocation url="index.cfm" addtoken="No">
</cfif>

<cfif Action IS "Cancel">
	<cflocation url="index.cfm" addtoken="No">
	<cfabort>
</cfif>

<!-------------------------------------------------------
|        variable pre-processing and query execution     |
-------------------------------------------------------->
<cfset Action = "#FORM.Action#">
<cfset UnitID = "#FORM.UnitID#">
<cfif Action IS "Insert" OR Action IS "InsertComment">
	<cfset CommentPresent = "#FORM.CommentPresent#">
	<cfif CommentPresent>
		<cfset Comment = "#FORM.Comment#">
	</cfif>
</cfif>
<cfif Action IS "Update">
	<cfset AggregateID = FORM.AggregateID>
	<cfset Count = FORM.Count>
</cfif>
<cfif IsDefined("Session.LogonID")>
	<cfset LogonID = Session.LogonID>
<cfelse>
	<cfset LogonID = "unassigned">
</cfif>
<cfoutput><p>LogonID = #LogonID#</p></cfoutput>
<cfset DBStatus = 1>

<!--- query to get user account information for email function --->
<cfquery name="GetUserAccounts" datasource="#CircStatsDSN#">
SELECT *
FROM View_CircUserUnit
WHERE LogonID = '<cfoutput>#LogonID#</cfoutput>'
</cfquery>

<!--- if action is delete --->
<cfif Action IS "Delete">
	<cfset RecordID = #FORM.RecordID#>
	<cfquery name="GetRecord" datasource="#CircStatsDSN#">
	SELECT *
	FROM View_CircManualStats
	WHERE RecordID = <cfoutput>#RecordID#</cfoutput>
	</cfquery>
</cfif>

<!--- if action is insert or update --->
<cfif Action IS "Insert" OR Action IS "Update">

	<cfset ReferringURL = #URLEncodedFormat(HTTP.REFERER)#>
	<cfif Action IS "Update">
		<cfset RecordID = #FORM.RecordID#>
	</cfif>

	<cfset UnitID = FORM.UnitID>
	<cfset dataMonth = FORM.dataMonth>
	<cfset dataYear = FORM.dataYear>

<!--- load just the aggregateID/value pairs into a structure --->
	<cfset AggregateIDValue = StructNew()>
	<CFLOOP COLLECTION="#Form#" ITEM="VarName">
		<cfif Find(LCase(UnitID), LCase(VarName)) AND FORM[VarName] IS NOT "">
			<cfset val = StructInsert(AggregateIDValue, "#VarName#", "#Replace(Replace(Form[VarName], ",", "", "ALL"), " ", "", "ALL")#")>
		</cfif>
	</CFLOOP>

<!--- query to get human descriptions of aggregate ids of statistical categories --->
	<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
	SELECT *
	FROM View_CircUnitCategory
	WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
		AND AggregateID IN (
		<cfoutput>
		<cfif Action IS "Insert">
			<cfset i = 1>
			<CFLOOP COLLECTION="#AggregateIDValue#" ITEM="AggregateID">
				<cfif i IS 1>
				'#AggregateID#'
				<cfelseif i GT 1>
				, '#AggregateID#'
				</cfif>
				<cfset i = i + 1>
			</cfloop>	
		<cfelseif Action IS "Update" OR Action IS "Delete">
			'#AggregateID#'
		</cfif>
		</cfoutput>
		)
	ORDER BY CircGroupSort, CategorySort
	</cfquery>

	<cfset ReferringURL = #URLEncodedFormat(HTTP.REFERER)#>

	<cfif Action IS "Update">
		<cfset RecordID = #FORM.RecordID#>
	</cfif>
	<cfset UnitID = FORM.UnitID>
	<cfset dataMonth = FORM.dataMonth>
	<cfset dataYear = FORM.dataYear>

<!--- load just the aggregateID/value pairs into a structure --->
	<cfset AggregateIDValue = StructNew()>
	<CFLOOP COLLECTION="#Form#" ITEM="VarName">
		<cfif Find(LCase(UnitID), LCase(VarName)) AND FORM[VarName] IS NOT "">
			<cfset val = StructInsert(AggregateIDValue, "#VarName#", "#Replace(Replace(Form[VarName], ",", "", "ALL"), " ", "", "ALL")#")>
		</cfif>
	</CFLOOP>
	
	<cfif Action IS "Insert">
<!--- concatenate the variable-value list to be fed to stored procedure --->
		<cfset CategoryValueList = "">
		<CFLOOP COLLECTION="#AggregateIDValue#" ITEM="AggregateID">
			<cfif Find(UnitID, AggregateID)>
				<cfset CategoryValueList = CategoryValueList & ',' & AggregateID & ',' & AggregateIDValue[AggregateID]>
			</cfif>
		</CFLOOP>
		<cfset CategoryValueList = RemoveChars(CategoryValueList, 1, 1)>
	</cfif>
</cfif>

<!--- if action is update or delete comment --->
<cfif Action IS "UpdateComment" OR
      Action IS "DeleteComment">
	<cfset CommentID = #FORM.CommentID#>
	<cfquery name="GetUnit" datasource="#CircStatsDSN#">
	SELECT *
	FROM CircUnit
	WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
	</cfquery>

<!--- if action is delete comment--->
	<cfif Action IS "DeleteComment">
		<cfset CommentID = #FORM.CommentID#>
		<cfquery name="GetComment" datasource="#CircStatsDSN#">
		SELECT *
		FROM CircComment
		WHERE CommentID = <cfoutput>#CommentID#</cfoutput>
		</cfquery>
	</cfif>
</cfif>


<!-------------------------------------------------------
|               call to stored procedures                |
-------------------------------------------------------->
<cfswitch expression="#Action#">
	<cfcase value="Insert">
		<cftry>
			<cfstoredproc procedure="usp_Insert_Circ_Stats" datasource="#CircStatsDSN#" returncode="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CategoryValueList" value="#CategoryValueList#" maxlength="8000" null="No">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataMonth" VALUE="#dataMonth#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataYear" VALUE="#dataYear#" CFSQLTYPE="CF_SQL_INTEGER">	
				<CFPROCPARAM TYPE="IN" DBVARNAME="@LogonID" VALUE="#LogonID#" CFSQLTYPE="CF_SQL_VARCHAR">
			</CFSTOREDPROC>
			<cfif CommentPresent>
				<cfstoredproc procedure="usp_Insert_Circ_Stats_Comment" datasource="#CircStatsDSN#" returncode="Yes">
					<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Comment" value="#Comment#" maxlength="8000" null="No">
					<CFPROCPARAM TYPE="IN" DBVARNAME="@UnitID" VALUE="#UnitID#" CFSQLTYPE="CF_SQL_VARCHAR">
					<CFPROCPARAM TYPE="IN" DBVARNAME="@dataMonth" VALUE="#dataMonth#" CFSQLTYPE="CF_SQL_INTEGER">
					<CFPROCPARAM TYPE="IN" DBVARNAME="@dataYear" VALUE="#dataYear#" CFSQLTYPE="CF_SQL_INTEGER">	
					<CFPROCPARAM TYPE="IN" DBVARNAME="@LogonID" VALUE="#LogonID#" CFSQLTYPE="CF_SQL_VARCHAR">
				</CFSTOREDPROC>
			</cfif>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
			<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfcase>

	<cfcase value="InsertComment">
		<cftry>
			<cfstoredproc procedure="usp_Insert_Circ_Stats_Comment" datasource="#CircStatsDSN#" returncode="Yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Comment" value="#Comment#" maxlength="8000" null="No">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@UnitID" VALUE="#UnitID#" CFSQLTYPE="CF_SQL_VARCHAR">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataMonth" VALUE="#dataMonth#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataYear" VALUE="#dataYear#" CFSQLTYPE="CF_SQL_INTEGER">	
				<CFPROCPARAM TYPE="IN" DBVARNAME="@LogonID" VALUE="#LogonID#" CFSQLTYPE="CF_SQL_VARCHAR">
			</CFSTOREDPROC>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
			<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfcase>

	<cfcase value="Update">
		<cftry>
			<cfstoredproc procedure="usp_Update_Circ_Stats" datasource="#CircStatsDSN#" RETURNCODE="Yes">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@RecordID" VALUE="#RecordID#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@AggregateID" VALUE="#AggregateID#" CFSQLTYPE="CF_SQL_VARCHAR" >
				<CFPROCPARAM TYPE="IN" DBVARNAME="@Count" VALUE="#Count#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataMonth" VALUE="#dataMonth#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataYear" VALUE="#dataYear#" CFSQLTYPE="CF_SQL_INTEGER">	
				<CFPROCPARAM TYPE="IN" DBVARNAME="@LogonID" VALUE="#LogonID#" CFSQLTYPE="CF_SQL_VARCHAR">
			</CFSTOREDPROC>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
			<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfcase>

	<cfcase value="Delete">
		<cftry>
			<cfstoredproc procedure="usp_Delete_Circ_Stats" datasource="#CircStatsDSN#" RETURNCODE="Yes">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@RecordID" VALUE="#RecordID#" CFSQLTYPE="CF_SQL_INTEGER">
			</CFSTOREDPROC>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
			<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfcase>

	<cfcase value="UpdateComment">
		<cftry>
			<cfstoredproc procedure="usp_Update_Circ_Stats_Comment" datasource="#CircStatsDSN#" RETURNCODE="Yes">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@CommentID" VALUE="#CommentID#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@Comment" VALUE="#Comment#" CFSQLTYPE="CF_SQL_VARCHAR">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@UnitID" VALUE="#UnitID#" CFSQLTYPE="CF_SQL_VARCHAR">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataMonth" VALUE="#dataMonth#" CFSQLTYPE="CF_SQL_INTEGER">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@dataYear" VALUE="#dataYear#" CFSQLTYPE="CF_SQL_INTEGER">	
				<CFPROCPARAM TYPE="IN" DBVARNAME="@LogonID" VALUE="#LogonID#" CFSQLTYPE="CF_SQL_VARCHAR">
			</CFSTOREDPROC>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
			<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfcase>

	<cfcase value="DeleteComment">
		<cftry>
			<cfstoredproc procedure="usp_Delete_Circ_Stats_Comment" datasource="#CircStatsDSN#" RETURNCODE="Yes">
				<CFPROCPARAM TYPE="IN" DBVARNAME="@CommentID" VALUE="#CommentID#" CFSQLTYPE="CF_SQL_INTEGER">
			</CFSTOREDPROC>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
			<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfcase>

</cfswitch>

<!-------------------------------------------------------
|  email after stored procedures executed successfully   |
-------------------------------------------------------->

<cfif CFSTOREDPROC.STATUSCODE IS 0 AND DBStatus IS NOT -1>
	<cfswitch expression="#Action#">

		<cfcase value="Insert">
<!--- send email confirming the successful input --->
			<cftry>
            <cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Data Input Successful">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics data input was successful. The following is a transcript of your transaction.
We recommend saving this transcript for you records.

Data added:

AggregateID-------Unit-------Stat. Group-------Category-------Count-------Mo/Yr
<cfloop query="GetUnitCategory"><CFLOOP COLLECTION="#AggregateIDValue#" ITEM="VarName"><cfif VarName IS AggregateID>#VarName#-------#Unit#-------#CircGroup#-------#Category#-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
</cfif></cfloop></cfloop>
<cfif CommentPresent>
Comment: #Comment#
</cfif>

Executed on: #Now()#
			</cfmail>
			<cfcatch type="any">
            	<cfset em = "#cfcatch.Message#" & "#cfcatch.Detail#">
                <span>Error!</span>
                <div>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr valign="top">
                            <td class="first">Insert confirmation email send failure.</td>
                        </tr>
                        <tr valign="top">
                            <td class="first"><cfoutput>#em#</cfoutput></td>
                        </tr>
                    </table>
                </div>
                <cfabort>
            </cfcatch>
            </cftry>
		</cfcase>

		<cfcase value="Delete">
<!--- send email confirming the successful update --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Data Deletion Successful">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics data deletion was successful. The following is a transcript of your transaction.
We recommend saving this transcript for you records.

Data deleted:

RecordID-------AggregateID-------Unit-------Stat. Group-------Category-------Count-------Mo/Yr
<cfloop query="GetRecord">#RecordID#-------#AggregateID#-------#Unit#-------#CircGroup#-------#Category#-------#Count#-------#dataMonth#/#dataYear#
</cfloop>

Executed on: #Now()#
			</cfmail>
		</cfcase>		

		<cfcase value="UpdateComment">
<!--- send email confirming the successful comment update --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Data Update Successful">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics comment edit was successful. The following is a transcript of your transaction.
We recommend saving this transcript for you records.

Comment updated:

CommentID-------UnitID-------Comment-------Mo/Yr
#CommentID#-------#GetUnit.Unit#-------#Comment#-------#dataMonth#/#dataYear#

Executed on: #Now()#
			</cfmail>
		</cfcase>

		<cfcase value="DeleteComment">
<!--- send email confirming the successful comment deletion --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Data Deletion Successful">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics comment deletion was successful. The following is a transcript of your transaction.
We recommend saving this transcript for you records.

Comment deleted:

CommentID-------UnitID-------Comment-------Mo/Yr
#CommentID#-------#GetUnit.Unit#-------#GetComment.Comment#-------#GetComment.dataMonth#/#GetComment.dataYear#

Executed on: #Now()#
			</cfmail>
		</cfcase>
		
	</cfswitch>
</cfif>

<!-------------------------------------------------------
|    email after stored procedures execution failed      |
-------------------------------------------------------->

<cfif CFSTOREDPROC.STATUSCODE IS NOT 0 OR DBStatus IS -1>
	<cfswitch expression="#Action#">

		<cfcase value="Insert">
<!--- send email notifying the failed input --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Data Input Failed" cc="davmoto@library.ucla.edu">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics data input failed. The problem may be due to a server error.
The system administrator has been notified. The following is a transcript of your attempted
transaction. We recommend saving this transcript for your records.

AggregateID-------Unit-------Stat. Group-------Category-------Count-------Mo/Yr
<cfloop query="GetUnitCategory"><CFLOOP COLLECTION="#AggregateIDValue#" ITEM="VarName"><cfif VarName IS AggregateID>#VarName#-------#Unit#-------#CircGroup#-------#Category#-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
</cfif></cfloop></cfloop>
<cfif CommentPresent>
Comment: #Comment#
</cfif>

Executed on: #Now()#</cfmail>
		</cfcase>

		<cfcase value="InsertComment">
<!--- send email notifying the failed input --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Statistics Comment Input Failed" cc="davmoto@library.ucla.edu">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics comment input failed. The problem may be due to a server error.
The system administrator has been notified. The following is a transcript of your attempted
transaction. We recommend saving this transcript for your records.

Comment: #Comment#

Executed on: #Now()#</cfmail>
		</cfcase>
		
		<cfcase value="Update">
<!--- send email notifying the failed input --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Data Update Failed" cc="davmoto@library.ucla.edu">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics data edit failed. The problem may be due to a server error.
The system administrator has been notified. The following is a transcript of your attempted
transaction. We recommend saving this transcript for your records.

Following data update failed:

AggregateID-------Unit-------Stat. Group-------Category-------Count-------Mo/Yr
<cfloop query="GetUnitCategory"><CFLOOP COLLECTION="#AggregateIDValue#" ITEM="VarName"><cfif VarName IS AggregateID>#VarName#-------#Unit#-------#CircGroup#-------#Category#-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
</cfif></cfloop></cfloop>
<cfif CommentPresent>
Comment: #Comment#
</cfif>

Executed on: #Now()#</cfmail>
		</cfcase>

		<cfcase value="Delete">
<!--- send email notifying the failed input --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Data Deletion Failed" cc="davmoto@library.ucla.edu">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics data deletion failed. The problem may be due to a server error. 
The system administrator has been notified. The following is a transcript of your attempted
transaction. We recommend saving this transcript for your records.

Following data deletion failed:

AggregateID-------Unit-------Stat. Group-------Category-------Count-------Mo/Yr
<cfloop query="GetUnitCategory"><CFLOOP COLLECTION="#AggregateIDValue#" ITEM="VarName"><cfif VarName IS AggregateID>#VarName#-------#Unit#-------#CircGroup#-------#Category#-------#AggregateIDValue[VarName]#-------#dataMonth#/#dataYear#
</cfif></cfloop></cfloop>
<cfif CommentPresent>
Comment: #Comment#
</cfif>

Executed on: #Now()#</cfmail>
		</cfcase>
		
		<cfcase value="DeleteComment">
<!--- send email confirming the successful comment deletion --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Comment Deletion Failed">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics comment deletion failed. The problem may be due to a server error. 
The system administrator has been notified. The following is a transcript of your attempted
transaction. We recommend saving this transcript for your records.

Following comment deletion failed:

CommentID-------UnitID-------Comment-------Mo/Yr
#CommentID#-------#GetUnit.Unit#-------#GetComment.Comment#-------#GetComment.dataMonth#/#GetComment.dataYear#

Executed on: #Now()#
			</cfmail>
		</cfcase>

		<cfcase value="UpdateComment">
<!--- send email confirming the successful comment update --->
			<cfmail to="#GetUserAccounts.EmailAddress#" from="webadmin@library.ucla.edu" subject="Circ. Comment Update Failed">Dear #GetUserAccounts.FirstName# #GetUserAccounts.LastName#:

Your circulation statistics comment edit failed.  The problem may be due to a server error.
The system administrator has been notified. The following is a transcript of your attempted
transaction. We recommend saving this transcript for your records.

Following comment update failed:

CommentID-------UnitID-------Comment-------Mo/Yr
#CommentID#-------#GetUnit.Unit#-------#Comment#-------#dataMonth#/#dataYear#

Executed on: #Now()#
			</cfmail>
		</cfcase>
				
	</cfswitch>
</cfif>

<!-------------------------------------------------------
| redirect after stored procedures executed successfully |
-------------------------------------------------------->

<cfif CFSTOREDPROC.STATUSCODE IS 0 AND DBStatus IS NOT -1>
	<CFLOCATION URL="confirm.cfm?Action=#Action#&DBStatus=1&UnitID=#UnitID#" ADDTOKEN="No">
</cfif>

<!-------------------------------------------------------
|   redirect after stored procedures execution failed    |
-------------------------------------------------------->

<cfif CFSTOREDPROC.STATUSCODE IS NOT 0 OR DBStatus IS -1>
	<CFLOCATION URL="confirm.cfm?Action=#Action#&Status=-1&UnitID=#UnitID#" ADDTOKEN="No">
</cfif>