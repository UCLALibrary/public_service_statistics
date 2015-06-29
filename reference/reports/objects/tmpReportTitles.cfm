  <cfswitch expression="#ReportType#">
    <cfcase value="1">
      <cfset ReportTitle = "Total transactions">
    </cfcase>
    <cfcase value="2">
      <cfset ReportTitle = "Total questions">
    </cfcase>
  </cfswitch>