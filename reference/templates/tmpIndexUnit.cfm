<cfparam name = "Text" default = "No">
<cfparam name="UnitID" default = "#UnitCode#">
<cfparam name="Flag" default = 0>

<cfif Find("#UnitCode#", UnitID) is 0>
	<cflocation url="../index.cfm" addtoken="No">
	<cfabort>
</cfif>

<cfquery name="GetUnitMaster" datasource="#CircStatsDSN#">
	SELECT *
	FROM View_RefUnitCategory
	<cfif Flag>
		WHERE UnitID LIKE '#UnitID#'
	<cfelse>
		WHERE UnitID LIKE '#UnitCode#%'
	</cfif>
	ORDER BY SubUnitID, PointID, TypeID, ServicePoint
</cfquery>

<cfquery name="GetSubUnit" dbtype="query">
	SELECT DISTINCT
		UnitID,
		Unit
	FROM GetUnitMaster
	ORDER BY Unit
</cfquery>

<cfif GetSubUnit.RecordCount LTE 1>
	<cfset SubunitExists = 0>
<cfelse>
	<cfset SubunitExists = 1>
</cfif>

<cfquery name="GetCollectionMethod" dbtype="query">
	SELECT
		InputMethodID,
		UnitPointID,
		UnitID,
		Unit,
		SubUnitID,
		ServicePoint,
		PointID
	FROM GetUnitMaster
	WHERE UnitPointID NOT IN ('BIO0108','SRL0002')
	GROUP BY InputMethodID, UnitPointID, UnitID, SubUnitID, Unit, ServicePoint, PointID
	ORDER BY InputMethodID, ServicePoint
</cfquery>

<cfquery name="GetEditUnits" dbtype="query">
	SELECT DISTINCT
		UnitID,
		Unit
	FROM GetUnitMaster
	WHERE UnitID LIKE '#UnitCode#%' AND InputMethodID = 1
</cfquery>

<cfloop query="GetCollectionMethod">
	<cfif InputMethodID is 2>
		<cfset KeyPadInput = 1>
		<cfbreak>
	<cfelse>
		<cfset KeyPadInput = 0>
	</cfif>
</cfloop>


<cfif KeyPadInput>
	<cfquery name="GetNumKeyPadLocations" datasource="#CircStatsDSN#">
		SELECT
			PointID,
			COUNT(PointID) AS NumQuestions
		FROM
			(
				SELECT DISTINCT
					PointID,
					QuestionType
				FROM View_RefUnitCategory
				WHERE UnitID LIKE '#UnitID#%'
					  AND InputMethodID = 2
					  AND Active = 1
			) NumQuestions
		GROUP BY PointID
		ORDER BY PointID
	</cfquery>
</cfif>


<html>
	<head>
		<title>
			UCLA Library Reference Statistics Data Input:
			<cfoutput>
				<cfif Flag>
					#GetUnitMaster.Unit#
				<cfelse>
					#GetUnitMaster.ParentUnit#
				</cfif>
			</cfoutput>
		</title>
		<cfif KeyPadInput>
			<script language="JavaScript">
				<!--// begin function to popup keypad
					var KeyPad = null;
					function LaunchKeyPad (encoded_url, num_quest)
					{
						//var _loc = encoded_url;
						//var _size = num_quest;
						if (KeyPad != null)
						{
							window.KeyPad.close();
						}
						KeyPad = window.open(
							encoded_url,
							'KeyPadWindow',
							'toolbar=no,width=250,height=' + num_quest + ',screenY=100,screenX=200,top=100,left=200,scrollbars=1,resizable=1');
						window.KeyPad.focus();
					}
					function LaunchRefForm(encoded_url)
					{
						if (KeyPad != null)
						{
							window.KeyPad.close();
						}
						KeyPad = window.open(
							encoded_url,
							'KeyPadWindow');
						window.KeyPad.focus();
					}
				// end function
				// -->
			</script>
		</cfif>
		<cfif Text is "No">
				<link rel=stylesheet href="../../css/main.css" type="text/css">
				<script language="JavaScript" SRC="../../javascript/page_14.js"></script>
			</head>
			<body bgcolor="#FFFFFF" topmargin="0" marginheight="0" marginwidth="0" leftmargin="0" link="#000099" vlink="#0000CC">
				<!--begin banner-->
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr bgcolor="#003366" height="10">
						<td colspan="2">
							<img src="../../images/1x1.gif" height=10 border=0>
						</td>
					</tr>
					<tr valign="middle" bgcolor="#336699" height="61">
						<td width="400" nowrap>
							<script language="JavaScript">
								<!-- // Hide this script from old browsers --
									document.write('<img src="' + image + '"  width="135" height="61" alt="UCLA Library">')
								// -- End Hiding Here -->
							</script>
							<img src="../../images/newlogo.gif" width="265" height="61" border="0" alt="UCLA Library">
						</td>
						<td align="right">
							<!---<A HREF="index_txt.html" CLASS="toplinks">Text Only</A>&nbsp;&nbsp;--->
						</td>
					</tr>
				</table>
				<!--end banner-->
				<cfinclude template="../../../library_pageincludes/nav.cfm">
		</cfif>
		<cfif Text is "Yes">
			<cfinclude template="../../../library_pageincludes/banner_txt.cfm">
		</cfif>
		<!--begin you are here-->
		<a href="../../home.cfm">Public Service Statistics</a> &gt;
		<a href="../index.cfm">Reference</a> &gt;
		<cfoutput>#GetUnitMaster.ParentUnit#</cfoutput>
		<!-- end you are here -->
		<cfif Text is "No">
			<cfinclude template="../../../library_pageincludes/start_content.cfm">
		</cfif>
		<cfif Text is "Yes">
			<cfinclude template="../../../library_pageincludes/start_content_txt.cfm">
		</cfif>
		<!--begin main content-->
		<h1>
			Reference Statistics:
			<cfoutput>
				<cfif Flag>
					#GetUnitMaster.Unit#
				<cfelse>
					#GetUnitMaster.ParentUnit#
				</cfif>
			</cfoutput>
		</h1>
		<cfif SubUnitExists AND Flag is 0>
			<h3>Input data for:</h3>
			<ul>
				<cfoutput query="GetSubUnit">
					<li><a href="index.cfm?UnitID=#UnitID#&Flag=1">#Unit#</a></li>
				</cfoutput>
			</ul>
		<cfelse>
			<cfset i = 1>
			<cfoutput query="GetCollectionMethod" group="InputMethodID">
				<cfif InputMethodID is 1>
					<h3>
						<a href="#LCase(SubUnitID)#/form.cfm?UnitID=#UnitID#&InputMethod=1">Go to monthly data input form for the following service location(s)</a>:
						<!--/strong-->
					</h3>
				<cfelseif InputMethodID is 2>
					<h3>Go to real-time data input form for the following service location(s):</h3>
				</cfif>
				<ul>
					<cfoutput>
						<cfif InputMethodID is 1>
							<li>#Unit#--#ServicePoint#</li>
						<cfelseif InputMethodID is 2>
							<cfset PID = GetCollectionMethod.PointID>
							<li>
								<a href="javascript:LaunchRefForm('../refForm.cfm?UnitPointID=#UnitPointID#')">#Unit#--#ServicePoint#</a>
								<!---a href="javascript:LaunchKeyPad('#LCase(SubUnitID)#/form.cfm?InputMethod=2&UnitPointID=#UnitPointID#',
									'<cfloop query="GetNumKeyPadLocations">
										<cfif GetNumKeyPadLocations.PointID is PID>
											<cfif NumQuestions LTE 5>200
											<cfelseif NumQuestions GT 5 AND NumQuestions LTE 10>250
											<cfelseif NumQuestions GT 10>380
											</cfif>
											<cfbreak>
										</cfif>
									</cfloop>')">
									#Unit#--#ServicePoint#
								</a--->
							</li>
							<cfset i = i + 1>
						</cfif>
					</cfoutput>
				</ul>
			</cfoutput>
		</cfif>
		<cfif Flag is NOT 1>
			<cfif GetEditUnits.RecordCount is NOT 0>
				<h3>Edit data for:</h3>
				<ul>
					<cfoutput query="GetEditUnits">
						<li><a href="#LCase(RemoveChars(UnitID, 1, 3))#/edit.cfm">#Unit#</a></li>
					</cfoutput>
				</ul>
			</cfif>
		</cfif>
		<cfif Text is "No">
			<cfinclude template="../../../library_pageincludes/footer.cfm">
			<cfinclude template="../../../library_pageincludes/end_content.cfm">
		</cfif>
		<cfif Text is "Yes">
			<cfinclude template="../../../library_pageincludes/footer_txt.cfm">
		</cfif>