<cfif Find("form.cfm", HTTP_REFERER) IS 0 AND
      Find("index.cfm", HTTP_REFERER) IS 0 AND
	  Find("review.cfm", HTTP_REFERER) IS 0 AND
	  Find("edit.cfm", HTTP_REFERER) IS 0>
	<cflocation url="index.cfm" addtoken="No">
</cfif>

<CFPARAM NAME = "Text" DEFAULT = "No">

<CFPARAM NAME = "Action" DEFAULT = "">
<CFPARAM NAME = "UnitID" DEFAULT = "">
<CFPARAM NAME = "UnitPointID" DEFAULT = "">
<CFPARAM NAME = "RecordID" default = 0>
<CFPARAM NAME = "dataMonth" DEFAULT = 0>
<CFPARAM NAME = "dataYear" DEFAULT = 0>
<CFPARAM NAME = "InputMethod" DEFAULT = 1>
<CFPARAM NAME = "SortOrder" DEFAULT = "D">
<cfset BlankForm = 0>
<cfset IsValidCategory = 1>
<cfset BadData = 0>

<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT DISTINCT Unit, UnitID, ParentUnit, SubUnitID
FROM View_RefUnitCategory
WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
</cfquery>

<!--- begin queries if action is insert --->
<cfif Action IS "Insert">
<!--- initialize the structure to store variable/value pairs --->
	<cfset AggregateIDValue = StructNew()>
<!--- check to see if non-numeric characters were submitted,
      if not, load variable into structure --->
	<CFLOOP COLLECTION="#Form#" ITEM="VarName">
<!--- load variable/value pairs into structure --->
		<cfif Find(LCase(UnitID), LCase(VarName)) AND FORM[VarName] IS NOT "">
			<cfset val = StructInsert(AggregateIDValue, "#VarName#", "#Trim(Replace(Replace(Form[VarName], ",", "", "ALL"), " ", "", "ALL"))#")>
		</cfif>
	</CFLOOP>
<!--- check for non-numeric characters --->
	<CFLOOP COLLECTION="#AggregateIDValue#" ITEM="VarName">
		<cfif ReFind("[[:punct:]]", AggregateIDValue[VarName]) IS 0 AND
			     ReFind("[[:alpha:]]", AggregateIDValue[VarName]) IS 0>
			<cfset BadData = 0>
		<cfelse>
			<cfset BadData = 1>
			<cfbreak>
		</cfif>
	</CFLOOP>
<!--- check to see if the structure is empty --->
	<cfif StructIsEmpty(AggregateIDValue)>
		<cfset BlankForm = 1>
	<cfelse>	
		<cfset BlankForm = 0>
	</cfif>
	<cfif BlankForm IS NOT 1>
		<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_RefUnitCategory
		WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
		AND AggregateID IN (
		<cfoutput>
		<cfset i = 1>
			<CFLOOP COLLECTION="#AggregateIDValue#" ITEM="AggregateID">
				<cfif i IS 1>
				'#AggregateID#'
				<cfelseif i GT 1>
				, '#AggregateID#'
				</cfif>
				<cfset i = i + 1>
			</cfloop>	
		</cfoutput>
		)
		ORDER BY PointID, TypeID
		</cfquery>
	</cfif>
</cfif>
<!--- end queries if action is insert --->
	
<!--- begin queries if action is update --->
<cfif Action IS "Update">
<!--- initialize the structure to store attribute name/value pairs --->
	<cfset DeAggregateID = StructNew()>
	<CFLOOP COLLECTION="#Form#" ITEM="VarName">
<!--- load attribute name/value pairs --->
		<cfif VarName IS "UnitID" OR
		      VarName IS "PointID" OR
			  VarName IS "TypeID" OR
			  VarName IS "ModeID">
			<cfset val = StructInsert(DeAggregateID, "#VarName#", "#Form[VarName]#")>
		</cfif>
	</CFLOOP>
	<cfset AggregateID = StructFind(DeAggregateID, "UnitID") & "-" & StructFind(DeAggregateID, "PointID") & "-" & StructFind(DeAggregateID, "TypeID") & "-" & StructFind(DeAggregateID, "ModeID")>

	<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
	SELECT *
	FROM View_RefUnitCategory
	WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
	AND PointID = '<cfoutput>#PointID#</cfoutput>'
	AND InputMethodID = 1
	ORDER BY PointID, TypeID
	</cfquery>
		
	<cfquery name="GetAggregateID" dbtype="query">
	SELECT *
	FROM GetUnitCategory
	WHERE UnitID LIKE '<cfoutput>#UnitID#</cfoutput>'
	AND AggregateID = '<cfoutput>#AggregateID#</cfoutput>'
	AND InputMethodID = 1
	ORDER BY PointID, TypeID
	</cfquery>
				
	<cfif GetAggregateID.RecordCount IS 0>
		<cfset IsValidCategory = 0>
		
		<cfquery name="GetMode" datasource="#CircStatsDSN#">
		SELECT * FROM RefMode
		WHERE ModeID = '<cfoutput>#ModeID#</cfoutput>'
		</cfquery>
		
		<cfquery name="GetQuestionType" datasource="#CircStatsDSN#">
		SELECT * FROM RefType
		WHERE TypeID = '<cfoutput>#TypeID#</cfoutput>'
		</cfquery>
		
		<cfquery name="GetServicePoint" datasource="#CircStatsDSN#">
		SELECT * FROM RefServicePoint
		WHERE PointID = '<cfoutput>#PointID#</cfoutput>'
		</cfquery>
		
	<cfelse>
		<cfset IsValidCategory = 1>
	</cfif>
	<cfset Count = #Trim(Replace(Replace(Count, ",", "", "ALL"), " ", "", "ALL"))#>
	<cfif Trim(Count) IS NOT "">
		<cfset BlankForm = 0>
		<cfif ReFind("[[:punct:]]", Count) IS 0 AND
			  ReFind("[[:alpha:]]", Count) IS 0>
			<cfset BadData = 0>
		<cfelse>
			<cfset BadData = 1>
		</cfif>
	<cfelse>
		<cfset BlankForm = 1>
	</cfif>
</cfif>
	
<!--- end queries if action is update --->

<!--- begin queries if action is delete --->
<cfif Action IS "Delete">
	<cfquery name="GetRecord" datasource="#CircStatsDSN#">
	SELECT * FROM View_ReferenceStatistics
	WHERE RecordID = <cfoutput>#RecordID#</cfoutput>
	</cfquery>
</cfif>
<!--- end queries if action is delete --->


<html>
<head>

	<title>UCLA Library Reference Statistics Review Data: <cfoutput>#GetUnit.Unit#</cfoutput></title>

	<cfif Text IS "No">
		<cfinclude template="../../library_pageincludes/banner.cfm">
		<cfinclude template="../../library_pageincludes/nav.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<cfinclude template="../../library_pageincludes/banner_txt.cfm">
	</cfif>

	

<!--begin you are here-->
<a href="../home.cfm">Public Services Statistics</a> &gt; <a href="index.cfm">Reference</a> &gt;
	<cfoutput>
	<cfswitch expression="#Action#">
		<cfcase value="Insert">
			<a href="#LCase(RemoveChars(UnitID, 4, 3))#/index.cfm">#GetUnit.ParentUnit#</a>
			<cfif (BlankForm IS 1) OR (BadData IS 1)>
				&gt; Error
			<cfelse>
				&gt; Data Input Review
			</cfif>
		</cfcase>
		<cfcase value="Update">
			<a href="#LCase(RemoveChars(UnitID, 4, 3))#/index.cfm">#GetUnit.ParentUnit# Data Edit</a>
			<cfif (BlankForm IS 1) OR (BadData IS 1) OR (IsValidCategory IS NOT 1)>
				&gt; Error
			<cfelse>
				&gt; Data Edit Review
			</cfif>
		</cfcase>
		<cfcase value="Delete">
			<a href="#LCase(RemoveChars(UnitID, 4, 3))#/index.cfm">#GetUnit.ParentUnit#</a> &gt; Review Deletion
		</cfcase>
	</cfswitch>
	</cfoutput>
<!-- end you are here -->

	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
	</cfif>

<!--begin main content-->

<cfif Session.IsValid IS 0>
<h1>Session Expired</h1>

<p><span class="red">Your transaction was not completed!</span></p>

<form action="index.cfm" method="post" class="form">
<input type="submit" value="Restart Session" class="form">
</form>

	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
	</cfif>

<cfabort>
</cfif>



	<cfif (BlankForm IS 1) OR (BadData IS 1) OR (IsValidCategory IS 0)>
		<cfinclude template="templates/capError.cfm">
	<cfelse>
		<cfinclude template="templates/capReview.cfm">
	</cfif>



	<cfif Action IS "Insert">
		<cfinclude template="templates/tmpReviewInsert.cfm">
	<cfelseif Action IS "Update">
		<cfinclude template="templates/tmpReviewUpdate.cfm">
	<cfelseif Action IS "Delete">
		<cfinclude template="templates/tmpReviewDelete.cfm">
	</cfif>







	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
	</cfif>
