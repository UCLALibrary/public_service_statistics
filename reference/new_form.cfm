<CFPARAM NAME = "Text" DEFAULT = "No">


<html>
<head>

	<title>UCLA Library Reference Statistics How to Use the Real-Time Data Input Form</title>

<cfif Text IS "No">
	<cfinclude template="../../library_pageincludes/banner.cfm">
	<cfinclude template="../../library_pageincludes/nav.cfm">
</cfif>
<cfif Text IS "Yes">
	<cfinclude template="../../library_pageincludes/banner_txt.cfm">
</cfif>


<!--begin you are here-->

<a href="../home.cfm">Public Service Statistics</a> &gt; <a href="index.cfm">Reference</a> &gt; New Real-Time Form Coming April 1

<!-- end you are here -->


<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/start_content_txt.cfm">
</cfif>

<!--begin main content-->

<h1>How to Use the Real-Time Data Input Form</h1>

<table>
<tr valign="top">
	<td class="small">Also see: </td>
	<td class="small">
	<a href="category_definitions.cfm">Statistical Category Definitions</a><br>
	<a href="procedure.cfm">Procedural Guidelines</a>
	</td>
</tr>
</table>

<p>
April 10, 2003
</p>

<p>The following are instructions on the safe and proper use of the real-time reference statistics input form.  If you have any questions that are not answered by these instructions, please feel free to contact David Yamamoto at <a href="mailto:davmoto@library.ucla.edu">davmoto@library.ucla.edu</a> or extension 72682.
</p>

<h3>New features of the form</h3>
<ul>
<li>Data submitted in batch:  no more multiple button clicks or delays when recording complex reference interactions.</li>
<li>Date stamp that can be changed by the user: now you can enter data from previous days.</li>
<li>Time stamp that can be changed by the user: assign the correct time to data that you were too busy to enter during the hour it was generated.</li>
<li>Automatic reference transaction tracking: no need to worry about remembering to click the "Transaction" category whenever a reference component was involved in your reference interaction, the form will do it automatically.</li>
<li>New digital reference statistical category: units offering digital reference services will now use the form to collect statistics.</li>
<li>Keyboard-free inputting of numbers:  use the left and right mouse buttons to increment or decrement numeric values.</li>
</ul>

<h3>Overview</h3>

<p>
Below is a screen shot (Windows NT) of the new form.  Displayed near the top of the form are the current date and hour.  The main control area of the form is laid out in a grid, similar to the old form.  Rows represent question types; columns represent modes of delivery.  Unlike the old form, the new form does not have the many clickable buttons each representing a single reference event.  White boxes at any row/column intersection represent the question type and mode of delivery combinations.  The white boxes are where values are input.  You input values by either clicking the mouse buttons or keying them in.  Once data have been input using your mouse or keyboard (more on this later,) you submit all of the data at once.
</p>
<p>
<img src="images/new_form_1.gif" alt="overview of new form" width="255" height="259" border="0">
</p>
<p>
The new form makes it possible to submit data that can describe either a single or multiple reference interactions in batch mode.  This is handy if you forget to record data for a reference interaction immediately after it transpires.
</p>

<h3>Inputting data</h3>


<p>
To input data, simply position the mouse cursor over the white box corresponding to the appropriate question type and mode of delivery you wish to record.  Click the left mouse button once and the value of "1" will automatically appear in the box.  Repeated clicks on the left mouse button will increment the value by one.  In the example below, the left mouse button was clicked 3 times in the Directional box.
</p>

<p>
<img src="images/new_form_2.gif" alt="inputting data" width="455" height="260" border="0">
</p>

<p>
If you click the left mouse button too many times and overshoot your target value, click the right mouse button to decrement the value by 1.  Repeated clicks on the right mouse button will decrement the value until the box becomes blank.
</p>

<p>
If you need to input a large number and want to avoid carpal tunnel syndrome, you can manually key in values using your keyboard.
</p>

<h3>Recording transactions</h3>

<p>
In the old form, it was up to you to determine if a reference component was involved in your interaction with a patron and remember to click the Transaction button.  The new form will automatically detect if you have input data for any reference categories such as Inquiry, Strategy, Tutorial, etc.  If a reference category is detected, a "1" will automatically appear in box next to the Transaction category.  The Transaction box is yellow to visually set it apart from the other categories.  In the above example, notice that the Transaction box does not contain any value, even though the the value of "3" appears in the Directional box.  The reason why is Directional type questions are not designated as reference questions.  If we were to click any of the boxes corresponding to categories designated as reference questions, the Transaction box will automatically be incremented by 1.
</p>
<p>
<img src="images/new_form_3.gif" alt="how the automatic transaction detection works" width="235" height="260" border="0">
</p>
<p>
In the above example, first the Directional box was clicked 3 times and no value appears in the Transaction box.  As soon as the Research Assistance box is clicked, the value of "1" automatically appears in the Transaction box.  The Transaction box works just like any other box. It is possible to use the right and left mouse buttons to increment/decrement values.  You can also manually key in values using your keyboard.
</p>
<p>
Once you have set all of your values correctly, simply click the Submit button.  Your data will be sent to the server and you will receive a very brief confirmation message. Clicking the Reset button will clear all values.
</p>

<h3>Changing the date and time</h3>
<p>
If you keep on top of things, you'll never have to tinker with the date and time functions of the form.  However, sometimes you will get busy at the desk or forget to input your data right away and will have to roll back time so that your data receives the correct date/time stamp.
</p>

<p>
The date and hour values of the form, by default, will be set to the current date and hour.
</p>
<p>
<img src="images/new_form_4.gif" alt="date and hour function of the form" width="300" height="300" border="0">
</p>
<p>
To roll back the hour, simply select a different value from the hour pull-down menu.
</p>
<p>
<img src="images/new_form_5.gif" alt="rolling back the hour" width="235" height="270" border="0">
</p>
<p>
You can roll back the date two different ways.  You can key in a date in the format <strong>d/m/yyyy</strong>, or you can select a date from the popup calendar.  To use the popup calendar, click on the <img src="../images/calendar.gif" alt="Date selector" width="20" height="20" border="0" align="absmiddle"> icon next to the date, or click on the date itself.  This causes the popup calendar to appear in the browser window.  Clicking on any day in the calendar will automatically load that date value into the date field of the form.  You can page foward or backwards through months in the calendar by clicking the left and right arrows.  The calendar will go back to the year 1900 if you should suddenly awake from a coma and realize you forgot to input your reference statistics.  Go ahead, try it if you're bored.
</p>
<p>
<img src="images/new_form_6.gif" alt="rolling back the date using the popup calendar" width="384" height="357" border="0">
</p>


<h3>A word about the date and time stamp</h3>

<p>
Remember that this form is Web browser-based and that the Web is a "stateless" environment.  What this means is the form has no continuous connection to the server.  The date and time values in the form are set whenever the form "talks" to the server,  that is, whenever you first open the form or whenever you submit data.  When the form interacts with the server, it automatically pulls back the most current date and time.  This has some implications.  Take the following hypothetical scenario:
</p>

<ul>
<li>Your desk shift runs from 2-4 p.m.; it is currently 2:59 p.m.</li>
<li>The last time you submitted data was at 2:50 p.m. and you haven't used the form since then.</li>
<li>The hour value on the form will be set to "2 pm hour".</li>
<li>It is now 3:01 p.m.</li>
<li>The hour value on the form will <em>still</em> be set to "2 pm hour"</li> because no interaction with the server has occurred since your last data submission at 2:50 p.m.
</ul>

<p>
The above scenario is likely to happen only when there is a period of inactivity that straddles the top of the hour.  You can't always be mindful of whether the top of the hour is approaching, so here's what to do.  Any time there has been an extended period of inactivity with the form, prior to inputting any data into the form:
</p>

<ul>
<li>Click the Reset button</li>
<li>Form "pings" the server and returns the most current date and time</li>
</ul>

<p>
This is a good practice in general even if time accuracy is not a concern.
</p>

<h3>Your feedback</h3>

<p>
Again, please send any comments or suggestions for improvements to David Yamamoto. Contact him at <a href="mailto:davmoto@library.ucla.edu">davmoto@library.ucla.edu</a> or extension 72682.  All requests for modifications that are broadly beneficial will be seriously considered.  Interfaces should adjust to humans, not the other way around!
</p>



<cfif Text IS "No">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer.cfm">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/end_content.cfm">
</cfif>
<cfif Text IS "Yes">
	<CFINCLUDE TEMPLATE="../../library_pageincludes/footer_txt.cfm">
</cfif>


