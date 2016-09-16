<cfquery name="GetCircUnit" datasource="#CircStatsDSN#">
	SELECT
		UnitID,
		Unit
	FROM
		CircUnit
	WHERE
		Active = 1
	ORDER BY
		Unit
</cfquery>

<cfquery name="GetRefUnit" datasource="#CircStatsDSN#">
	SELECT DISTINCT
		SUBSTRING(UnitID, 1, 3) AS ParentUnitID,
		CASE
			WHEN SUBSTRING(UnitID, 1, 3) = 'ART' THEN 'Arts Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'BIO' THEN 'Biomed Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'CLK' THEN 'Clark Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'COL' THEN 'Powell Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'EAL' THEN 'East Asian Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'LAW' THEN 'Law Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'MAN' THEN 'Management Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'MUS' THEN 'Music Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'RBR' THEN 'Rieber Hall'
			WHEN SUBSTRING(UnitID, 1, 3) = 'SEL' THEN 'Science & Engineering Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'SRL' THEN 'SRLF'
			WHEN SUBSTRING(UnitID, 1, 3) = 'YRL' THEN 'Young Research Library'
			WHEN SUBSTRING(UnitID, 1, 3) = 'DLP' THEN 'Digital Library Program'
            WHEN SUBSTRING(UnitID, 1, 3) = 'SSD' THEN 'Social Science Data Archive'
			ELSE NULL
		END AS "ParentUnit"
	FROM
		View_RefUnit
	ORDER BY
		ParentUnit
</cfquery>

<html>
<head>
	<title>UCLA Library Public Service Statistics</title>
	<cfinclude template="../library_pageincludes/banner.cfm">
	<cfinclude template="../library_pageincludes/nav.cfm">
<!--begin you are here-->

Public Service Statistics

<!-- end you are here -->
	<CFINCLUDE TEMPLATE="../library_pageincludes/start_content.cfm">
<h1>Public Service Statistics</h1>

<p>
Welcome to UCLA Library Public Service Statistics Web site.
</p>
					<form action="addAccount.cfm"
						  method="post"
						  name="Login"
						  id="Login">
						  <!--onsubmit="JavaScript:return validateForm(this);"-->
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td align="right">User name</td>
								<td>&nbsp;</td>
								<td>
									<input name="LogonID" type="text" size="15" maxlength="50">
								</td>
							</tr>
							<tr>
								<td align="right">Password</td>
								<td>&nbsp;</td>
								<td>
									<input name="newPassword" type="password" size="15" maxlength="50">
								</td>
							</tr>
							<tr>
								<td align="right">First Name</td>
								<td>&nbsp;</td>
								<td>
									<input name="FirstName" type="text" size="15" maxlength="50">
								</td>
							</tr>
							<tr>
								<td align="right">Last Name</td>
								<td>&nbsp;</td>
								<td>
									<input name="LastName" type="text" size="15" maxlength="50">
								</td>
							</tr>
							<tr>
								<td align="right">Email Address</td>
								<td>&nbsp;</td>
								<td>
									<input name="EmailAddress" type="text" size="15" maxlength="50">
								</td>
							</tr>
							<tr>
								<td align="right">Circ Unit</td>
								<td>&nbsp;</td>
								<td>
									<select name="CircUnit" class="form">
										<cfoutput query="GetCircUnit">
											<option value="#GetCircUnit.UnitID#">#GetCircUnit.Unit#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
							<tr>
								<td align="right">Ref Unit</td>
								<td>&nbsp;</td>
								<td>
									<select name="RefUnit" class="form">
										<cfoutput query="GetRefUnit">
											<option value="#GetRefUnit.ParentUnitID#">#GetRefUnit.ParentUnit#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<tr>
								<td>&nbsp;</td>
								<td align="right">
									<input type="submit" class="mainControl" value="Create Account">
								</td>
								<td valign="top">
									&nbsp;
								</td>
							</tr>
						</table>
					</form>
	<CFINCLUDE TEMPLATE="../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../library_pageincludes/end_content.cfm">
