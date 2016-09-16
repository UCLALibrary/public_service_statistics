<cfif Find("ModeID", HTTP.REFERER) gt 0>
	<cfset ReferringURL = Left(HTTP.REFERER, Find("ModeID", HTTP.REFERER) - 1) & "ModeID=" & FORM.ModeID>
<cfelse>
	<cfset ReferringURL = HTTP.REFERER & "&ModeID=" & FORM.ModeID>
</cfif>
<cfset ReferringURL = #URLEncodedFormat(ReferringURL)#>
<cfset DBStatus = 1>
<cfset Transaction = 0>
<!---cfset UnitID = "#FORM.UnitID#"--->
<cfif IsDefined("Session.LogonID")>
	<cfset LogonID = Session.LogonID>
<!---cfelseif IsDefined("AUTH_USER") and AUTH_USER ne "">
	<cfset LogonID = RemoveChars(AUTH_USER, "1", Find("\", AUTH_USER))--->
<cfelse>
	<cfset LogonID = "unassigned">
</cfif>
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

<cfif IsDefined("FORM.TimeSpent") and FORM.TimeSpent neq "">
	<cfset TimePer = #FORM.TimeSpent# / ListLen(FORM.TypeID)>
</cfif>

<cfset StatIDs = ArrayNew(1)>

<cfloop index="theType" list="#FORM.TypeID#">
	<cfif theType eq "02" or theType eq "03" or theType eq "04" or theType eq "05" or theType eq "06" or theType eq "08" or theType eq "00">
		<cfset Transaction = 1>
	</cfif>
	<cfset AggregateID="#FORM.UnitPointID##theType##FORM.ModeID#">

	<cftry>
		<cfstoredproc procedure="uspAddRefStat" datasource="#CircStatsDSN#" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@AggregateID" value="#AggregateID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@Count" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataMonth" value="#dataMonth#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataYear" value="#dataYear#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@DateTime" value="#DateTime#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@LogonID" value="#LogonID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@InputMethod" value="2" null="No">
			<cfif IsDefined("TimePer")>
				<cfprocparam type="In" cfsqltype="CF_SQL_FLOAT" dbvarname="@TimeSpent" value="#TimePer#" null="No">
			<cfelse>
				<cfprocparam type="In" cfsqltype="CF_SQL_FLOAT" dbvarname="@TimeSpent" value="0" null="No">
			</cfif>
			<cfprocresult name="Stat">
		</cfstoredproc>
		<cfset temp = ArrayAppend(StatIDs, "#Stat.StatisticID#")>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
		</cfcatch>
	</cftry>

</cfloop>

<cfif IsDefined("FORM.Referral") and FORM.Referral eq "y">
	<cftry>
		<cfstoredproc procedure="uspAddRefReferral" datasource="#CircStatsDSN#" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataMonth" value="#dataMonth#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataYear" value="#dataYear#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@DateTime" value="#DateTime#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@LogonID" value="#LogonID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ReferralText" value="#FORM.ReferralText#" null="No">
			<cfprocresult name="Referral">
		</cfstoredproc>
		<cfset ReferralID = #Referral.ReferralID#>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
		</cfcatch>
	</cftry>

	<cfloop index="theStatID" array="#StatIDs#">
		<cftry>
			<cfstoredproc procedure="uspAddRefStatReferral" datasource="#CircStatsDSN#" returncode="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@RefStatID" value="#theStatID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@RefReferralID" value="#ReferralID#" null="No">
			</cfstoredproc>
			<cfcatch type="Database">
				<cfset DBStatus = -1>
			</cfcatch>
		</cftry>
	</cfloop>

</cfif>

<cfif (IsDefined("FORM.Topic") and FORM.Topic neq "") or (IsDefined("FORM.StaffFeedback") and FORM.StaffFeedback neq "")
      or (IsDefined("FORM.PatronFeedback") and FORM.PatronFeedback neq "") or (IsDefined("FORM.DepartmentID") and FORM.DepartmentID neq "0")
      or (IsDefined("FORM.PatronType") and FORM.PatronFeedback neq "7")>
	<cftry>
		<cfstoredproc procedure="uspAddRefInteractions" datasource="#CircStatsDSN#" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataMonth" value="#dataMonth#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataYear" value="#dataYear#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@DateTime" value="#DateTime#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@LogonID" value="#LogonID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Topic" value="#FORM.Topic#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@DepartmentID" value="#FORM.DepartmentID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Course" value="#FORM.Course#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@StaffFeedback" value="#FORM.StaffFeedback#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@PatronType" value="#FORM.PatronType#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@PatronFeedback" value="#FORM.PatronFeedback#" null="No">
			<cfprocresult name="Interaction">
		</cfstoredproc>
		<cfset InteractionID = #Interaction.InteractionID#>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
		</cfcatch>
	</cftry>

	<cfloop index="theStatID" array="#StatIDs#">
		<cftry>
			<cfstoredproc procedure="uspAddRefStatInteraction" datasource="#CircStatsDSN#" returncode="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@RefStatID" value="#theStatID#" null="No">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@RefInteractionID" value="#InteractionID#" null="No">
			</cfstoredproc>
			<cfcatch type="Database">
				<cfset DBStatus = -1>
			</cfcatch>
		</cftry>
	</cfloop>

</cfif>

<cfif Transaction>
	<cfset AggregateID="#FORM.UnitPointID#0000">

	<cftry>
		<cfstoredproc procedure="uspAddRefStat" datasource="#CircStatsDSN#" returncode="Yes">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@AggregateID" value="#AggregateID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@Count" value="1" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataMonth" value="#dataMonth#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@dataYear" value="#dataYear#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" dbvarname="@DateTime" value="#DateTime#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@LogonID" value="#LogonID#" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@InputMethod" value="2" null="No">
			<cfprocparam type="In" cfsqltype="CF_SQL_FLOAT" dbvarname="@TimeSpent" value="#FORM.TimeSpent#" null="No">
		</cfstoredproc>
		<cfcatch type="Database">
			<cfset DBStatus = -1>
		</cfcatch>
	</cftry>
</cfif>

<!-------------------------------------------------------
| redirect after stored procedures executed successfully |
-------------------------------------------------------->

<cfif cfstoredproc.statuscode is 0 and DBStatus is not -1>
	<cflocation url="refConfirm.cfm?InputMethod=2&DBStatus=1&ReferringURL=#ReferringURL#" addtoken="No">
</cfif>

<!-------------------------------------------------------
|   redirect after stored procedures execution failed    |
-------------------------------------------------------->

<cfif cfstoredproc.statuscode is not 0 or DBStatus is -1>
	<cflocation url="refConfirm.cfm?InputMethod=2&DBStatus=2&ReferringURL=#ReferringURL#" addtoken="No">
</cfif>