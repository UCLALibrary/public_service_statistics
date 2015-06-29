<!--- initialize the structure to store variable/value pairs --->
<cfset CategoryValue = StructNew()>
<!--- check to see if non-numeric characters were submitted,
      if not, load variable into structure --->
<CFLOOP COLLECTION="#Form#" ITEM="VarName">
<!--- only load variable/value pairs if variable name 
      contains a numeric value --->
<cfif REFind("cat[0-9]", LCase(VarName)) AND FORM[VarName] IS NOT "">
		<cfset val = StructInsert(CategoryValue, "#VarName#", "#Form[VarName]#")>
</cfif>
</CFLOOP>
<CFLOOP COLLECTION="#CategoryValue#" ITEM="VarName">
<cfif IsNumeric(Trim(CategoryValue[VarName]))>
	<cfset NonNumeric = 0>
<cfelse>
	<cfset NonNumeric = 1>
</cfif>
</CFLOOP>
<!--- check to see if the structure is empty --->
<cfif StructIsEmpty(CategoryValue)>
	<cfset BlankForm = 1>
<cfelse>	
	<cfset BlankForm = 0>
</cfif>




