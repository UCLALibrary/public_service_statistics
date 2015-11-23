<cfscript>
	up2snuff = 1;
</cfscript>
<cfif not IsDefined("FORM.UserName") or
      not IsDefined("FORM.Password") or
      Trim(StripCR(FORM.UserName)) eq "" or
      Trim(StripCR(FORM.Password)) eq "">
	<cflocation url="index.cfm?action=deny" addtoken="no">
	<cfabort>
</cfif>
<cfscript>
	// initialize variables for uspGetAccount stored procedure
	LibID = 0;
	UserName = Trim(StripCR(FORM.UserName));
	Password = Trim(StripCR(FORM.Password));
</cfscript>
<cfinclude template="uspGetAccount.cfm">
<cfif not up2snuff>
    <cfoutput>#em#</cfoutput>
	<!---cfinclude template="incBegin.cfm">
	<cfinclude template="incError.cfm"--->
<cfelse>
	<cfif Account.RecordCount gt 0>
		<cflock timeout="#CreateTimeSpan(0,4,0,0)#" type="readonly" scope="session">
			<cfset SESSION.IsValid = 1>
			<cfset SESSION.LogonID = Account.LogonID>
		</cflock>
		<cflocation url="home.cfm" addtoken="no">
	<cfelse>
		<cflocation url="index.cfm?action=deny" addtoken="no">
	</cfif>
</cfif>