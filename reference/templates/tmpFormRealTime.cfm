<cfif Find("form.cfm", PATH_INFO) is 0>
    <cflocation url="../index.cfm" addtoken="No">
    <cfabort>
</cfif>

<cfset request = GetHttpRequestData()>
<cfset browser = StructFind(request.headers, "User-Agent")>
<cfif Find("MSIE",browser) neq 0>
	<cfset isIE = 1>
<cfelse>
	<cfset isIE = 0>
</cfif>

<html>
	<head>
		<title>Tallysheet</title>
		<style type="text/css">
			<!--
				.tblcopy {
					font-family: Verdana, Arial, Helvetica, sans-serif;
					font-size: 11px;
				}
				.form1 {
					font-family: Verdana, Arial, Helvetica, sans-serif;
					font-size: 11px;
					color: #0000CC;
					border: 0px solid;
					text-align: center;
				}
				.form2 {
					font-family: Verdana, Arial, Helvetica, sans-serif;
					font-size: 11px;
					color: #0000CC;
					border: 0px solid;
					background-color: #FFFFCC;
					text-align: center;
				}
				.form3 {
					font-family: Verdana, Arial, Helvetica, sans-serif;
					font-size: 11px;
					border: 0px solid;
					background-color: #DEDEDE;
					text-align: left;
					line-height: 7pt;
				}
				.small {
					font-family: Verdana, Arial, Helvetica, sans-serif;
					font-size: 11px;
					line-height: 1em;
				}
				input, textarea, select {
					font-family: Verdana, Arial, Helvetica, sans-serif;
					font-size: 11px;
					margin-bottom: 0px;
				}
			-->
		</style>
	</head>
	<body bgcolor="#FFFFFF" topmargin="1" marginheight="1" marginwidth="1" leftmargin="1" link="#000099" vlink="#0000CC">
		<cfif Session.IsValid is 0>
			<table width="210" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="middle">
					<td width="100%" height="80%" align="center" valign="middle" class="form">
						<strong><span class="red">Session Expired</span></strong>
						<form action="JavaScript:ChangeParentDocument('../../index.cfm')" method="post" class="form">
							<input type="submit" value="Restart Session" class="form">
						</form>
					</td>
				</tr>
			</table>
		<cfelse>
			<table width="220" border="0" cellspacing="0" cellpadding="0" bgcolor="#DEDEDE">
				<tr>
					<td class="tblcopy">
						<strong><cfoutput>#GetUnitCategory.Unit# #GetUnitCategory.ServicePoint#</cfoutput></strong>
					</td>
				</tr>
				<tr>
					<td height="1" bgcolor="#FFFFFF"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
				</tr>
			</table>
			<table width="220" border="0" cellspacing="0" cellpadding="0">
				<form action="../../action.cfm" method="post" name="KeyPad" id="KeyPad" onSubmit="javascript:return CheckForm(this)">
					<cfif UnitID is not "SRL00">
						<tr bgcolor="#DEDEDE">
							<td colspan="16" align="center" nowrap class="small">
								<a href="javascript:ShowCalendar('KeyPad', 'Date')">
									<img src="../../images/calendar.gif" alt="Date selector" width="16" height="15" border="0" align="absmiddle">
								</a>
								&nbsp;
								<input type="text" name="Date" value="<cfoutput>#DateFormat(Now(), "m/d/yyyy")#</cfoutput>" size="11" maxlength="11" class="form3" onClick="javascript:ShowCalendar('KeyPad', 'Date')">
								<select name="Hour" class="small">
									<cfloop index="H" from="0" to="23">
										<option value="<cfoutput>#TimeFormat(CreateTime(H, 00, 00), "H:mm:ss tt")#</cfoutput>" <cfif Hour(Now()) is H>selected</cfif> class="small"><cfoutput>#TimeFormat(CreateTime(H, 00, 00), "h tt")
											#</cfoutput> hour
										</option>
									</cfloop>
								</select>
							</td>
						</tr>
					</cfif>
					<tr>
						<td height="1" colspan="16" bgcolor="#FFFFFF"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td width="1" bgcolor="#FFFFFF" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
						<td width="63" bgcolor="#FFFFFF" class="small">&nbsp;</td>
						<td width="1" bgcolor="#FFFFFF" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
						<cfset i = 0>
						<cfoutput query="GetAllModes">
							<cfset ThisMode = GetAllModes.ModeID>
							<cfif i gt 0>
								<td bgcolor="##FFFFFF" width="1" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
							</cfif>
							<td width="26" bgcolor="##<cfif ListFind(Mode, ThisMode, ",")>DEDEDE<cfelse>FFFFFF</cfif>" class="small" align="center">
								<cfif ListFind(Mode, ThisMode, ",")>
									<cfif ThisMode eq "01">
										<img src="../../images/mode_in_person.gif" alt="In-person" width="19" height="12" border="0" align="absmiddle">
									<cfelseif ThisMode eq "02">
										<img src="../../images/mode_telephone.gif" alt="Telephone" width="16" height="14" border="0" align="absmiddle">
									<cfelseif ThisMode eq "03">
										<img src="../../images/mode_email.gif" alt="Email" width="16" height="16" border="0" align="absmiddle">
									<cfelseif ThisMode eq "05">
										<img src="../../images/mode_chat.gif" alt="Chat" width="16" height="14" border="0" align="absmiddle">
									<cfelseif ThisMode eq "04">
										<img src="../../images/mode_correspondence.gif" alt="Correspondence" width="15" height="13" border="0" align="absmiddle">
									<cfelseif ThisMode eq "06">
										<img src="../../images/mode_button_im.jpg" alt="Instant Messaging" width="15" height="13" border="0" align="absmiddle">
									</cfif>
								<cfelse>
									<img src="../../../images/1x1.gif" width="1" height="1" border="0">
								</cfif>
							</td>
							<cfset i = i + 1>
						</cfoutput>
						<td bgcolor="#FFFFFF" width="1" class="small">
							<img src="http://stats.library.ucla.edu/images/1x1.gif" width="1" height="1" border="0">
						</td>
						<td width="26" bgcolor="#DEDEDE" class="small" align="center">
							<!--&gt;10 Min-->
							<img src="../../images/mode_button_more10.gif" alt=">10 Minutes" width="20" height="20" border="0" align="absmiddle">
						</td>
					</tr>
					<cfset i = 0>
					<cfoutput query="GetUnitCategory" group="ServicePoint">
						<cfoutput group="QuestionType">
							<cfif i gt 0>
								<tr>
									<td height="1" colspan="3" bgcolor="##FFFFFF" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
									<cfset i = 0>
									<cfloop index="M" list="#AllModes#">
										<cfset Match = 0>
										<cfoutput group="ModeID">
											<cfif GetUnitCategory.ModeID is M>
												<cfset Match = 1>
											</cfif>
										</cfoutput>
										<cfif i gt 0>
											<td bgcolor="##FFFFFF" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
										</cfif>
										<td <cfif Match eq 1>bgcolor="##DEDEDE"<cfelse>bgcolor="##FFFFFF"</cfif> class="small" align="center"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
										<cfset i = i + 1>
									</cfloop>
								</tr>
							</cfif>
							<tr>
								<td bgcolor="##CCCCCC" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
								<td bgcolor="##CCCCCC" class="small">#GetUnitCategory.QuestionType#</td>
								<td bgcolor="##CCCCCC" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
								<cfset i = 0>
								<cfloop index="M" list="#AllModes#">
									<cfif i gt 0>
										<td bgcolor="##CCCCCC"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
									</cfif>
									<cfset Match = 0>
									<cfoutput group="ModeID">
										<cfif GetUnitCategory.ModeID is M>
											<cfset Match = 1>
										</cfif>
									</cfoutput>
									<td <cfif Match eq 1>bgcolor="##999999"<cfelse>bgcolor="##CCCCCC"</cfif> class="small" align="center">
										<cfset Pair = 0>
										<cfoutput group="ModeID">
											<cfif GetUnitCategory.ModeID is M>
												<cfset Pair = 1>
												<cfset AggID = GetUnitCategory.AggregateID>
											</cfif>
										</cfoutput>
										<cfif Pair>
											<input type="text" name="#AggID#" size="1" maxlength="2" class="form1" <cfif not isIE>id="#AggID#"<cfelse>onMouseDown="JavaScript:Increment('#AggID#')"</cfif> oncontextmenu="return false">
										<cfelse>
											&nbsp;
										</cfif>
									</td>
									<cfset i = i + 1>
								</cfloop>
								<!-- NOTE added next two cells -->
								<td bgcolor="##CCCCCC">
									<img src="http://stats.library.ucla.edu/images/1x1.gif" width="1" height="1" border="0">
								</td>
								<td bgcolor="##999999" class="small" align="center">
									<input type="checkbox" name="#UnitPointID##TypeID#_LONG" value="1">
								</td>
							</tr>
						</cfoutput>
						<cfset i = i + 1>
					</cfoutput>
					<tr>
						<td height="1" colspan="16" bgcolor="#FFFFFF" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
					</tr>
					<tr bgcolor="#999999">
						<td width="1" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
						<td height="8" class="small">Transaction</td>
						<td width="1" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
						<td class="small" align="center">
							<input type="text" name="<cfoutput>#UnitPointID#0000</cfoutput>" size="1" maxlength="2" class="form2" onMouseDown="JavaScript:Increment('<cfoutput>#UnitPointID#0000</cfoutput>')" oncontextmenu="return false">
						</td>
						<td colspan="12" class="small"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td height="8" colspan="16"><img src="../../../images/1x1.gif" width="1" height="1" border="0"></td>
					</tr>
					<tr>
						<td colspan="16" align="right">
							<input type="submit" name="SubmitIt" value="Submit" class="form">
							<input type="reset" value="Reset" class="form" onClick="window.location.reload()">
							&nbsp;
						</td>
					</tr>
					<input type="hidden" name="Action" value="Insert">
					<input type="hidden" name="InputMethod" value=2>
					<cfoutput>
						<input type="hidden" name="UnitID" value="#UnitID#">
						<input type="hidden" name="UnitPointID" value="#UnitPointID#">
					</cfoutput>
				</form>
			</table>
		</cfif>
		<script language="JavaScript">
			<!--// set the number of text fields
				<cfoutput>
					<cfif UnitID is "SRL00">
						var FirstField = 0
						var NumFields = #Evaluate(GetUnitCategory.RecordCount + 1)#;
					<cfelse>
						var FirstField = 2
						var NumFields = #Evaluate(GetUnitCategory.RecordCount + 3)#;
					</cfif>
				</cfoutput>

			<!--// function to reset the form
				function ResetForm()
				{
					for (var i = FirstField; i < NumFields; i++)
					{
						document.KeyPad.elements[i].value = '';
					}
					Transaction = false;
				}

			<!--// function to validate form
				function CheckForm()
				{
					var BlankForm = true;
					var NonInt = false;
					for (var i = FirstField; i < NumFields; i++)
					{
						if (document.KeyPad.elements[i].value.replace(/^\s*/, '').replace(/\s*$/, '') != '')
						{
							BlankForm = false;
							document.KeyPad.elements[i].focus();
							break;
						}
					}

					if (!BlankForm)
					{
						for (var i = FirstField; i < NumFields; i++)
						{
							if (document.KeyPad.elements[i].value.replace(/^\s*/, '').replace(/\s*$/, '') != '')
							{
								var thisInt = parseInt(document.KeyPad.elements[i].value);
								if (thisInt != document.KeyPad.elements[i].value)
								{
									NonInt = true;
									alert("Only whole numbers may be submitted.");
									document.KeyPad.elements[i].focus();
									return false;
									break;
								}
							}
						}
					}
					else
					{
						alert("A blank form cannot be submitted.");
						return false;
					}

					if (!BlankForm && !NonInt)
					{
						return true;
					}
				}

			<!--// function to increment the value in the text field when clicked
				var Transaction = false;
				<cfif isIE>
					<cfinclude template="tmpIncrementIE.cfm">
				<cfelse>
					<cfinclude template="tmpIncrementFF.cfm">
				</cfif>

			<!--// function to load the calendar window
				function ShowCalendar(FormName, FieldName)
				{
					window.open("../../select_date.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=200,height=150,left=400,top=150");
				}

			<!--// function close popup window on link click
				function ChangeParentDocument(url)
				{
					opener.location = url;
					window.self.close();
				}
			-->
		</script>
	</body>
</html>