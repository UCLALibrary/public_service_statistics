<CFPARAM NAME = "Text" DEFAULT = "No">


<html>
<head>

	<title>UCLA Library Reference Statistics Technical Information</title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../index.cfm">Public Service Statistics</a> &gt; <a href="index.cfm">Reference</a> &gt; Application Technical Information

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Technical Information</h1>

<table>
<tr valign="top">
	<td class="small">Also see: </td>
	<td class="small">
	<a href="category_definitions.cfm">Statistical Category Definitions</a><br>
	<!---a href="procedure.cfm">Procedural Guidelines</a><br>
	<a href="new_form.cfm">How to Use the Real-Time Data Input Form</a--->
	</td>
</tr>
</table>

<p>
July 2, 2003
</p>

<h2>System Requirements</h2>

<ul>
<li>Microsoft Internet Explorer v. 6+</li>
<li>Cookies enabled</li>
<li>JavaScript enabled</li>
</ul>

<h2>System Information</h2>

<ul>
<li>Database application server:  Microsoft SQL Server 2000</li>
<li>Web server:  Microsoft Internet Information Server 5.0</li>
<li>Operating system:  Microsoft Windows 2000</li>
<li>Web application server:  Macromedia ColdFusion 5.0</li>
<li>Browser:  Microsoft Internet Explorer v. 6+</li>
</ul>


<h2>Data Modeling</h2>

<p>
The database captures and stores data describing reference interactions.  Reference interactions or events are described by 5 attributes:
</p>

<ul>
<li>Library unit</li>
<li>Library sub-unit</li>
<li>Service point/li>
<li>Type of question</li>
<li>Mode of delivery</li>
</ul>
<p>
These attribute can take the following possible values:
</p>

<table border="1" cellspacing="0" cellpadding="2" bordercolor="#CCCCCC">
<tr valign="top">
<td class="copy"><strong>Attibute</strong></td>
<td class="copy"><strong>Example value</strong></td>
</tr>

<tr valign="top">
<td class="copy">Library unit</td>
<td class="copy">
Arts Library<br>
Biomedical Library<br>
Powell Library<br>
Management Library<br>
Etc.</td>
</tr>

<tr valign="top">
<td class="copy">Library sub-unit</td>
<td class="copy">
Circulation<br>
Reference<br>
Special Collections<br>
Etc.
</td>
</tr>

<tr valign="top">
<td class="copy">
Service point
</td>
<td class="copy">
Reference desk<br>
Off-desk<br>
Circulation desk<br>
Office<br>
Information desk<br>
Rovers
</td>
</tr>
<tr valign="top">
<td class="copy">
Type of question
</td>
<td class="copy">
Consultation<br>
Directional<br>
Extensive reference<br>
Inquiry<br>
Strategy<br>
Transaction<br>
Tutorial
</td>
</tr>
<tr valign="top">
<td class="copy">
Mode of delivery
</td>
<td class="copy">
Consultation<br>
Correspondence<br>
Email<br>
In-person<br>
Telephone<br>
</td>
</tr>

</table>

<p>
Reference interactions or events are also assigned a numeric value representing the number of occurrences.  The database can accommodate the input of "real-time" data, that is, data input immediately after the event occurs using a Web-based tally sheet; as well as data that is cumulated on a monthly basis.  The system allows manual editing and deletion of cumulated monthly data only.
</p>
<p>
The design of the database accommodates reports on any number of permutations of the above data attributes.
</p>





<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>


