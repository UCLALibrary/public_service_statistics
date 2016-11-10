<cfset Session.IsValid = 1>

<CFPARAM NAME = "Text" DEFAULT = "No">


<html>
<head>

	<title>UCLA Library Reference Statistics</title>

<LINK REL=STYLESHEET HREF="http://h-unitproj.library.ucla.edu/statistics/css/main.css" TYPE="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="http://h-unitproj.library.ucla.edu/statistics/javascript/page_14.js"></SCRIPT>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-32672693-3', 'auto');
  ga('send', 'pageview');
</script>

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
</HEAD>

<BODY BGCOLOR="#FFFFFF" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" LEFTMARGIN="0" LINK="#000099" VLINK="#0000CC">

<a name="top"></a>

<!--begin banner-->
<TABLE WIDTH="100%"
       BORDER="0"
       CELLSPACING="0"
       CELLPADDING="0">
<TR BGCOLOR="#003366"
    HEIGHT="10">
	<TD COLSPAN="2"><IMG SRC="http://unitproj.library.ucla.edu/statistics/images/1x1.gif" HEIGHT=10 BORDER=0></TD>
</TR>
<TR VALIGN="middle"
    BGCOLOR="#336699"
    HEIGHT="61">
	<td width="400" nowrap><script language="JavaScript"><!-- // Hide this script from old browsers --
          document.write('<IMG SRC="' + image + '"  WIDTH="135" HEIGHT="61" ALT="UCLA Library">')
          // -- End Hiding Here --></script>
          <a href="http://www.library.ucla.edu/">
          	<IMG SRC="http://unitproj.library.ucla.edu/statistics/images/newlogo.gif" WIDTH="265" HEIGHT="61" border="0" alt="UCLA Library">
          </a></td>
	<TD ALIGN="right"><a href="?&Text=Yes" class="toplinks">Text Only</a>&nbsp;&nbsp;&nbsp;</TD>
</TR>
</TABLE>
<!--end banner-->


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr valign="top">
	<td width="100%"
	    bgcolor="White">

<!--begin table for your are here-->

		<table width="100%"
		       border="0"
		       cellspacing="0"
		       cellpadding="4"
		       bgcolor="#CCCCCC">
		<tr valign="middle">
			<td height="18" class="nav"><b>You are here:</b>&nbsp; <a href="http://www.library.ucla.edu/">Home</a> &gt;


<!--begin you are here-->

<a href="../home.cfm">Public Service Statistics</a> &gt; Reference

<!-- end you are here -->


			</td>
		</TR>
		</TABLE>

<!--end table for you are here-->

		<table width="100%"
		       border="0"
		       cellspacing="0"
		       cellpadding="15">
		<TR>
			<td width="100%" bgcolor="White" colspan="3">
<h1 style="margin-bottom: 0px;">Reference Statistics - Input Stats</h1>
			</td>
		</TR>
		<TR>
<!--begin main content-->
<style>
.unitblock { margin: 10px 0px; padding: 5px; background-color: #EBF0F7; border: 1px solid #CCCCCC;}
.unitblock h3 { margin: 0px; }
.unitblock ul { margin: 0px; }
<</style>

		<td width="33%" bgcolor="White" style="vertical-align:top">

<div class="unitblock"><h3>Arts Library</h3>
<ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=ART0003')">Circulation desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=ART0002')">Off-desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=ART0001')">Reference desk</a></li>
</ul></div>

<div class="unitblock"><h3>Biomed Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=BIO0103')">Circulation desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=BIO0402')">Off-desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=BIO0401')">Reference desk</a></li>
</ul></div>

<div class="unitblock"><h3>Clark Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=CLK0008')">Office</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=CLK0001')">Reference desk</a></li>
</ul></div>

<div class="unitblock"><h3>Powell Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=COL0006')">Entrance foyer</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=COL0005')">Inquiry desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=COL0015')">Inquiry space (220)</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=COL0014')">Off-desk / roving</a></li>
</ul></div>

<div class="unitblock"><h3>Digital Library Program</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=DLP0002')">Off-desk</a></li>
</ul></div>

<div class="unitblock"><h3>East Asian Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=EAL0007')">Information desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=EAL0002')">Inquiry desk</a></li>
</ul></div>

<div class="unitblock"><h3>Law Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=LAW0003')">Circulation desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=LAW0001')">Reference desk</a></li>
</ul></div>

</td>
<td width="33%" bgcolor="White" style="vertical-align:top">

<div class="unitblock"><h3>Library Special Collections</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=ART0101')">LSC Arts, Reference desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=BIO0208')">LSC Biomed, Office</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=MUS0101')">LSC Music, Reference desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=YRL0302')">LSC YRL, Off-desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=YRL0301')">LSC YRL, Reference desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=YRL0402')">LSC YRL, Univ Archives Reference Desk</a></li>
</ul></div>

<div class="unitblock"><h3>Management Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=MAN0003')">Circulation desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=MAN0002')">Off-desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=MAN0001')">Reference desk</a></li>
</ul></div>

<div class="unitblock"><h3>Music Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=MUS0003')">Circulation desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=MUS0002')">Off-desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=MUS0001')">Reference desk</a></li>
</ul></div>

<div class="unitblock"><h3>Rieber Hall</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=RBR0016')">Rieber Hall 115</a></li>
</ul></div>

<div class="unitblock"><h3>Science and Engineering Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=SEL0103')">SEL Boelter, Circulation desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=SEL0102')">SEL Boelter, Off-desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=SEL0101')">SEL Boelter, Reference desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=SEL0303')">SEL Geology, Circulation desk</a></li>
</ul></div>

<div class="unitblock"><h3>Social Science Data Archive</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=SSD0108')">Office</a></li>
</ul></div>

</td>
<td width="33%" bgcolor="White" style="vertical-align:top">

<div class="unitblock"><h3>SRLF</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=SRL0003')">Circulation desk</a></li>
</ul></div>

<div class="unitblock"><h3>Young Research Library</h3><ul>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=YRL0713')">Access Services, A-lvl service desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=YRL0703')">Access Services, Circulation desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=YRL0802')">CRIS, Off-desk</a></li>
<li><a href="javascript:LaunchRefForm('refForm.cfm?UnitPointID=YRL0801')">CRIS, Reference desk</a></li>
</ul></div>

<h2 style="margin-bottom: 3px;">Documentation</h2>

<ul style="margin-top: 0px;">
<li><a href="category_definitions.cfm">Statistical Category Definitions</a></li>
<li><a href="specifications.cfm">Technical Information</a></li>
</ul>

<h2 style="margin-bottom: 3px;">Reports</h2>

<ul style="margin-top: 0px;">
<li><a href="reports/generator.cfm?Level=Library">Library-wide</a></li>
<li><a href="reports/generator.cfm?Level=Unit">Unit-specific</a></li>
<li><a href="reports/generator.cfm?Level=Account">Account-specific</a></li>
</ul>

</td>

</TR>

		<TR>
			<td width="100%" bgcolor="White" colspan="3">
<!--begin last updated date-->
<p>&nbsp;</p>
<p class="footer">Last updated: June 16, 2016</p>
<!--end last updated date-->
<p class="footer"><a href="http://www.library.ucla.edu/contact/comments.html">Send a question or comment about this site</a><br>
&copy; Regents of the University of California</p>
<!--end copyright/footer-->
</TD>
		</TR>
		</TABLE>

	</td>

</TR>

</TABLE>

</BODY>

</HTML>
