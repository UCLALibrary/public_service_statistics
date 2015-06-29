<CFPARAM NAME = "Text" DEFAULT = "No">


<html>
<head>

	<title>UCLA Library Reference Statistical Category Definitions</title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../index.cfm">Public Service Statistics</a> &gt; <a href="index.cfm">Reference</a> &gt; Statistical Category Definitions

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>Statistical Category Definitions</h1>

<!---table>
<tr valign="top">
	<td class="small">Also see: </td>
	<td class="small">
	<a href="procedure.cfm">Procedural Guidelines</a><br>
	<a href="new_form.cfm">How to use the real-time data input form</a>
	</td>
</tr>
</table--->

<p>
<strong>Directional</strong> - These questions refer to physical or logistical use of the
facility including directions.
</p>
<ul>
<li>Answer location questions</li>
<li>Direct or refer users to other service points</li>
<li><strong>HINT TEXT: Location or directions provided. (e.g., service points, rooms, events, contact information etc.)</strong></li>
</ul>

<p>
<strong>Technical</strong>
</p>
<ul>
<li>Technical assistance - troubleshooting/fixing problems with printers, computers, copiers, other machines</li>
<li>Help users save, download, or print</li>
<li>BruinCard use, add funds, etc.</li>
<li><strong>HINT TEXT: Help with printers, computers, software, scanners, etc.</strong></li>
</ul>

<p>
<strong>Policy/operations</strong>
</p>
<ul>
<li>Communicate or interpret library policies</li>
<li>Provide hours</li>
<li>Explain access, privileges</li>
<li>Provide information about reserving spaces/rooms</li>
<li><strong>HINT TEXT: Hours, access privileges, borrowing, space reservations, other policies.</strong></li>
</ul>

<p>
<strong>Known item inquiry</strong>
</p>
<ul>
<li>Verify or provide call numbers</li>
<li>Find an article or book from a citation</li>
<li>Use the OPAC to better direct the user (e.g., to another service point)</li>
<li>Uncomplicated look-up of fact or spelling</li>
<li>Retrieve reference books</li>
<li><strong>HINT TEXT: Find call numbers, books, articles, locations etc. for known items (requested by patron).</strong></li>
</ul>

<p>
<strong>Research Assistance</strong> - Drop-in patron assistance that goes beyond inquiries, strategies, or tutorials in scope and complexity. It includes teaching users how to:
</p>
<ul>
<li>Formulate and develop strategies for research including steps to take and sources to use</li>
<li>Discover resources</li>
<li>Find appropriate sources</li>
<li>Help users evaluate sources and information found</li>
<li>Use a resource or developing a search strategy</li>
<li>Research and investigate a wide range of information formats or resources</li>
<li>Interpret a number of specialized and complex reference tools</li>
<li>Use advanced searching techniques to find information</li>
<li>Synthesize and/or analyze information during the process of fulfilling a transaction</li>
<li><strong>HINT TEXT: Help patron with research strategy, advice, overview of resources (drop-in).</strong></li>
</ul>

<p>
<strong>Scheduled Consultation -- NOW USE SIA-- </strong>Scheduled, formal one-on-one interaction for the purpose of teaching users about access to information. Examples of what might be covered:
</p>
<ul>
<li>Patrons seeking specific expertise</li>
<li>Using a library-licensed resource or information resource</li>
<li>Developing a search strategy and advanced database searches</li>
<li>Use of bibliographic management programs (e.g., EndNote, EndNote Web, Zotero)</li>
<li>Dissertation counseling</li>
<li>Research consultations for undergraduates</li>
</ul>

<!--h2>Instructional Reference</h2>
<p>
<strong>Strategy</strong> - These questions require helping the user to formulate a search strategy, usually including the selection of relevant resources.
</p>
<ul>
<li>Formulate and teach strategies for research including steps to take and sources to use</li>
<li>Teach how to discover resources</li>
<li>Suggest appropriate sources and how to find them</li>
<li>Help user evaluate sources and information found</li>
</ul>
<p>
<strong>Tutorial</strong> - In these transactions, instruct users in use of information sources or related processes
</p>
<ul>
<li>Teach how to use the resources, including short and long tutorials on how to use databases and how to formulate queries</li>
<li>Teach how to interpret citations</li>
<li>Teach the strengths and limitations of the resources</li>
</ul-->

<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>


