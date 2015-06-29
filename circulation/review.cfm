<cfif Find("form.cfm", HTTP_REFERER) IS 0 AND
      Find("index.cfm", HTTP_REFERER) IS 0 AND
	  Find("review.cfm", HTTP_REFERER) IS 0 AND
	  Find("edit.cfm", HTTP_REFERER) IS 0>
	<cflocation url="index.cfm" addtoken="No">
</cfif>

<CFPARAM NAME = "Text" DEFAULT = "No">

<CFPARAM NAME = "Action" DEFAULT = "">
<CFPARAM NAME = "UnitID" DEFAULT = "">
<CFPARAM NAME = "RecordID" default = 0>
<CFPARAM NAME = "dataMonth" DEFAULT = 0>
<CFPARAM NAME = "dataYear" DEFAULT = 0>
<CFPARAM NAME = "SortOrder" DEFAULT = "D">
<cfset BlankForm = 0>
<cfset BadData = 0>

<cfquery name="GetUnit" datasource="#CircStatsDSN#">
SELECT Unit,
	UnitID
FROM CircUnit
WHERE UnitID = '<cfoutput>#UnitID#</cfoutput>'
</cfquery>

<!--- begin queries if action is insert --->
<cfif Action IS "Insert">
<!--- initialize the structure to store filtered variable/value pairs --->
	<cfset CleanValue = StructNew()>
<!--- load variable/value pairs into structure to clean --->
	<CFLOOP COLLECTION="#Form#" ITEM="VarName">
		<cfif Find(LCase(UnitID), LCase(VarName))>
			<cfset val = StructInsert(CleanValue, #VarName#, #Replace(Replace(Form[VarName], ",", "", "ALL"), " ", "", "ALL")#)>
		</cfif>
	</CFLOOP>

<!--- initialize the structure to store variable/value pairs --->
	<cfset AggregateIDValue = StructNew()>
<!--- load variable/value pairs into structure --->
	<CFLOOP COLLECTION="#CleanValue#" ITEM="VarName">
		<cfif CleanValue[VarName] IS NOT "">
			<cfset val = StructInsert(AggregateIDValue, VarName, CleanValue[VarName])>
		</cfif>
	</CFLOOP>
	
	<cfparam name="Comment" default="">
	<cfif Trim(Comment) IS NOT "">
		<cfset CommentPresent = 1>
		<cfset Comment = Trim(Comment)>
	<cfelse>
		<cfset CommentPresent = 0>
	</cfif>

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
	<cfif StructIsEmpty(AggregateIDValue) AND CommentPresent IS 0>
		<cfset BlankForm = 1>
	<cfelseif StructIsEmpty(AggregateIDValue) AND CommentPresent IS 1>	
		<cfset Action = "InsertComment">
		<cfset BlankForm = 1>
	<cfelseif StructIsEmpty(AggregateIDValue) IS NOT 0 AND CommentPresent IS 1>
		<cfset BlankForm = 0>
	</cfif>
	<cfif BlankForm IS NOT 1>
		<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_CircUnitCategory
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
		ORDER BY CircGroupSort, CategorySort
		</cfquery>
	</cfif>
</cfif>
<!--- end queries if action is insert --->
	
<!--- begin queries if action is update --->
<cfif Action IS "Update">
<!--- initialize the structure to store attribute name/value pairs --->
	<cfset AggregateID = FORM.AggregateID>
	<cfset Count = FORM.Count>
<!--- initialize the structure to store variable/value pairs --->
	<cfset AggregateIDValue = StructNew()>
<!--- check to see if non-numeric characters were submitted,
      if not, load variable into structure --->
	<cfset val = StructInsert(AggregateIDValue, "#AggregateID#", "#Count#")>

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
	<cfif AggregateIDValue[VarName] IS "">
		<cfset BlankForm = 1>
	<cfelse>	
		<cfset BlankForm = 0>
	</cfif>
	<cfif BlankForm IS NOT 1>
		<cfquery name="GetUnitCategory" datasource="#CircStatsDSN#">
		SELECT *
		FROM View_CircUnitCategory
		WHERE AggregateID = '#AggregateID#'
		ORDER BY CircGroupSort, CategorySort
		</cfquery>
	</cfif>
</cfif>
	
<!--- end queries if action is update --->

<!--- begin queries if action is delete --->
<cfif Action IS "Delete">
	<cfquery name="GetRecord" datasource="#CircStatsDSN#">
	SELECT *
	FROM View_CircManualStats
	WHERE RecordID = <cfoutput>#RecordID#</cfoutput>
	</cfquery>
</cfif>
<!--- end queries if action is delete --->

<!--- begin validation if action is update comment --->
<cfif Action IS "UpdateComment">
	<CFPARAM NAME = "Comment" DEFAULT = Trim(FORM.Comment)>
	<cfif Comment IS "">
		<cfset BlankForm = 1>
	<cfelse>
		<cfset BlankForm = 0>
	</cfif>
</cfif>
<!--- end validation if action is update comment --->


<!--- begin queries if action is delete comment--->
<cfif Action IS "DeleteComment">
	<CFPARAM NAME = "CommentID" DEFAULT = FORM.CommentID>
	<cfquery name="GetComment" datasource="#CircStatsDSN#">
	<cfoutput>
    SELECT CC.CommentID,
           CC.Comment,
           CC.UnitID,
           CU.Unit,
           CC.dataMonth,
           CC.dataYear,
           CC.LogonID,
           CC.Created_DT,
           CC.Updated_DT
    FROM CircComment CC
    JOIN CircUnit CU ON CU.UnitID = CC.UnitID
	WHERE CommentID = #CommentID#
	</cfoutput>
	</cfquery>
</cfif>
<!--- end queries if action is delete comment--->



<html>
<head>

	<title>UCLA Library Circulation Statistics Review Data: <cfoutput>#GetUnit.Unit#</cfoutput></title>

	<cfif Text IS "No">
		<cfinclude template="../../library_pageincludes/banner.cfm">
		<cfinclude template="../../library_pageincludes/nav.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<cfinclude template="../../library_pageincludes/banner_txt.cfm">
	</cfif>

	

<!--begin you are here-->
<a href="../index.cfm">Public Services Statistics</a> &gt; <a href="index.cfm">Circulation</a> &gt;
	<cfoutput>
	<cfswitch expression="#Action#">
		<cfcase value="Insert">
			<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
			<cfif (BlankForm IS 1) OR (BadData IS 1)>
				&gt; Error
			<cfelse>
				&gt; Data Input Review
			</cfif>
		</cfcase>
		<cfcase value="InsertComment">
			<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
				&gt; Comment Submission Review
		</cfcase>
		<cfcase value="Update">
			<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit# Data Edit</a>
			<cfif (BlankForm IS 1) OR (BadData IS 1)>
				&gt; Error
			<cfelse>
				&gt; Data Edit Review
			</cfif>
		</cfcase>
		<cfcase value="Delete">
			<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a> &gt; Review Deletion
		</cfcase>
		<cfcase value="UpdateComment">
			<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a>
			<cfif (BlankForm IS 1) OR (BadData IS 1)>
				&gt; Error
			<cfelse>
				&gt; Data Edit Review
			</cfif>
		</cfcase>
		<cfcase value="DeleteComment">
			<a href="#LCase(UnitID)#/index.cfm">#GetUnit.Unit#</a> &gt; Review Deletion
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

	<cfif ((BlankForm IS 1) OR (BadData IS 1)) AND Action IS NOT "InsertComment">
		<cfinclude template="templates/capError.cfm">
	<cfelse>
		<cfinclude template="templates/capReview.cfm">
	</cfif>


<!--- call to review templates --->
	
	<cfif Action IS "Insert" OR Action IS "InsertComment">
		<cfinclude template="templates/tmpReviewInsert.cfm">
	<cfelseif Action IS "Update">
		<cfinclude template="templates/tmpReviewUpdate.cfm">
	<cfelseif Action IS "Delete">
		<cfinclude template="templates/tmpReviewDelete.cfm">
	<cfelseif Action IS "UpdateComment">
		<cfinclude template="templates/tmpReviewUpdateComment.cfm">
	<cfelseif Action IS "DeleteComment">
		<cfinclude template="templates/tmpReviewDeleteComment.cfm">
	</cfif>


	<cfif Text IS "No">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
	</cfif>
	<cfif Text IS "Yes">
		<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
	</cfif>
