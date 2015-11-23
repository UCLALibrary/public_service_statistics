<CFPARAM NAME = "Text" DEFAULT = "No">


<html>
<head>

	<title>UCLA Library Reference Statistics Procedural Guidelines</title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../home.cfm">Public Service Statistics</a> &gt; <a href="index.cfm">Reference</a> &gt; Procedural Guidelines

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Reference Statistics Procedural Guidelines for Recording Data</h1>

<table>
<tr valign="top">
	<td class="small">Also see: </td>
	<td class="small">
	<a href="category_definitions.cfm">Statistical Category Definitions</a><br>
	<!---a href="new_form.cfm">Statistical Category Definitions</a><br>
	<a href="new_form.cfm">How to use the real-time data input form</a--->
	</td>
</tr>
</table>

<p>
Rev. August 4, 2011
</p>
<p>
For definitions of the reference categories, Directional, Inquiry, Strategy, Tutorial, and Research Assistance, <a href="category_definitions.cfm">see the Reference Statistics Categories page</a>.
</p>

<!--h2>Recording Data</h2-->

<dl>

<dt>
<strong>Transaction</strong>&nbsp;[Note: the system automatically records the transaction field]
</dt>

<dd>
If a person leaves and comes back at a later time and asks further questions, record another statistic
(inquiry, research assistance, etc.) for this contact. Note: transaction counts are only recorded for
interactions that involve reference outputs (inquiry, research assistance). If a question involves a
directional output in addition to one or more of the reference outputs, then record a directional query
as well as the reference output. If a question involves ONLY a directional component, do not record a
transaction count BUT do capture this in the Directional column.
</dd>

<dt>
<strong>Inquiry</strong>
</dt>

<dd>
Record once for each ready reference output provided in an interaction with a patron.
For example, if a patron asks for the call number for a book and how to find a journal title,
record one Inquiry (the Transaction box will be filled in automatically).
</dd>

<!--dt>
<strong>Strategy</strong>
</dt>
<dd>
if multiple strategies are provided, count each strategy.
</dd>

<dt>
<strong>Tutorial</strong>
</dt>
<dd>
if multiple tutorials are provided, count each tutorial.
</dd-->

<dt>
<strong>Research Assistance</strong>
</dt>

<dd>
Record in this category interactions that go beyond ready reference, including/such as database selection
and search strategy development. For example, if a patron is asking how to find a scholarly journal article
or where to look for journal articles in a discipline, record one Research Assistance (the Transaction box
will be filled in automatically).
</dd>

<dt>
<strong>Directional</strong>
</dt>

<dd>
If multiple directional questions are answered (e.g., where are copiers and where are restrooms), record only once.
</dd>

<dt>
<strong>&gt;10 Minutes</strong>
</dt>

<dd>
If a transaction of any type (e.g., in person, email, telephone, text/IM, etc.) lasts longer
than 10 minutes, record that in the appropriate box, in addition to the Research Assistance or Inquiry category.
</dd>

<br/>
<dt>
<strong>Delivery Method</strong><br/>
Record outputs under the appropriate method of delivery used, e.g., in-person, phone, email, etc.
</dt>
<br/>

<ul>
<li>
In-Person - a transaction at a UCLA Library Reference Desk, Circulation Desk, or single service point
</li>
<li>
Phone - telephone assistance at a UCLA Library Reference Desk or in a librarian’s office
</li>
<li>
Email - questions received and answered via personal email or shared reference email accounts
</li>
<li>
IM/Text-message - questions received and answered via instant message or text message.
Ask a Librarian statistics should not be recorded on this form (they are captured in QuestionPoint).
</li>
</ul>

</dl>

<!---p>
Use any combination of the above categories when multiple outputs are provided in response to a query.
</p>
<p>
Record outputs under the appropriate method of delivery used, e.g., in-person, phone, email, etc.
</p--->

<h2>Related Issues</h2>
<p>
Each unit has the option to use either paper forms for collecting data or to use real-time input. Only one method per unit is allowed (i.e., paper OR real-time).
</p>


<h3>Units Using Paper Forms</h3>
<ul>
<li>
Must input their data on a monthly basis using an online template by the 15th of the following month.
</li>
<li>
Are responsible for duplicating their forms within the unit; these are not provided centrally.
</li>
<li>
Must designate at least one staff member who will be responsible for monthly data input; this information must be provided to the Library Public Services Web Developer so he can assign rights for data input. This is the only person who can input and/or edit unit data.
</li>
</ul>

<h3>Units Using Real-Time Input</h3>
<ul>
<li>
Must input their data immediately as transactions take place using a special online real-time input form.
</li>
<li>
Must designate all staff who has authority to use the real-time input forms at each of the service locations within the unit to the library web administrator so he can assign rights for each person to use the online form.
</li>
<li>
Must notify the Library Public Services Web Developer about new staff who require permission to use the real-time input form and about staff who leave the unit.
</li>
</ul>



<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>


