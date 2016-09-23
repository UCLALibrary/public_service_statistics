<!--- or is datasource CircStatsDSN?  Application.dsn--->
<cfquery name="qryExportAllData" datasource="#CircStatsDSN#">
select
	ru.Descrpt AS Unit,
	rsp.Descrpt AS ServicePoint,
	rt.Descrpt AS QuestionType,
	rm.Descrpt AS InteractionMode,
-- '"' + replace(replace(coalesce(a.Title, 'N/A'), ',', ';'), '"', '''') + '"'
	<!--- Consider combining these with convert 120, instead of separate fields? --->
	convert(varchar,rs.Created_DT,101) AS EventDate,
	convert(varchar,rs.Created_DT,108) AS EventTime,
	case
		WHEN rs.LogonID is null then '"' + 'N/A'  + '"'
		WHEN LEN(ltrim(rtrim(rs.LogonID))) = 0 then '"' + 'N/A'  + '"'
		else rs.LogonID
	end AS UserName,
	rs.TimeSpent,
	case
		when dl.Department IS null then '"' + 'N/A'  + '"'
		else replace(dl.Department, ',', ';')
	end AS Department,
	case
		when LEN('"' + replace(replace(coalesce(ri.Course, 'N/A'), ',', ';'), '"', '''') + '"') = 2 THEN '"' + 'N/A' + '"'
		else '"' + replace(replace(coalesce(ri.Course, 'N/A'), ',', ';'), '"', '''') + '"'
	end AS Course,
	case
		when pt.PatronType IS null then '"' + 'N/A'  + '"'
		else pt.PatronType
	end AS PatronType,
	case
		when LEN('"' + replace(replace(coalesce(ri.PatronFeedback, 'N/A'), ',', ';'), '"', '''') + '"') = 2 THEN '"' + 'N/A' + '"'
		else '"' + replace(replace(coalesce(ri.PatronFeedback, 'N/A'), ',', ';'), '"', '''') + '"'
	end AS PatronFeedback,
	case
		when LEN('"' + replace(replace(coalesce(ri.StaffFeedback, 'N/A'), ',', ';'), '"', '''') + '"') = 2 THEN '"' + 'N/A' + '"'
		else '"' + replace(replace(coalesce(ri.StaffFeedback, 'N/A'), ',', ';'), '"', '''') + '"'
	end AS StaffFeedback,
	case
		when LEN('"' + replace(replace(coalesce(ri.Topic, 'N/A'), ',', ';'), '"', '''') + '"') = 2 THEN '"' + 'N/A' + '"'
		else '"' + replace(replace(coalesce(ri.Topic, 'N/A'), ',', ';'), '"', '''') + '"'
	end AS Topic,
	case
		when LEN('"' + replace(replace(replace(coalesce(rr.ReferralText, 'N/A'), ',', ';'), '"', ''''), '\n',';') + '"') = 2 THEN '"' + 'N/A' + '"'
		else '"' + replace(replace(replace(coalesce(rr.ReferralText, 'N/A'), ',', ';'), '"', ''''), '\n',';') + '"'
	end AS ReferralText
from
	#CircStatsDSN#.dbo.ReferenceStatistics rs
	inner join #CircStatsDSN#.dbo.RefUnit ru on SUBSTRING(rs.AggregateID,1,5) = ru.UnitID
	inner join #CircStatsDSN#.dbo.RefServicePoint rsp on SUBSTRING(rs.AggregateID,6,2) = rsp.PointID
	inner join #CircStatsDSN#.dbo.RefType rt on SUBSTRING(rs.AggregateID,8,2) = rt.TypeID
	inner join #CircStatsDSN#.dbo.RefMode rm on SUBSTRING(rs.AggregateID,10,2) = rm.ModeID
	left join #CircStatsDSN#.dbo.RefStatInteractions rsi on rs.RecordID = rsi.RefStatID
	left join #CircStatsDSN#.dbo.RefInteractions ri on rsi.RefInteractionID = ri.InteractionID
	left join #CircStatsDSN#.dbo.RefStatReferrals rsr on rs.RecordID = rsr.RefStatID
	left join #CircStatsDSN#.dbo.RefReferrals rr on rsr.RefReferralID = rr.ReferralID
	left join #CircStatsDSN#.dbo.PatronType pt on ri.PatronType = pt.PatronTypeID
	<!--- Need data from SIA or SIA_Test --->
	<!---left join #APPLICATION.dsn #.dbo.DepartmentLookup dl on ri.DepartmentID = dl.DepartmentID--->
	left join SIA.dbo.DepartmentLookup dl on ri.DepartmentID = dl.DepartmentID
where
	SUBSTRING(rs.AggregateID, 8, 2) <> '00' 
	<!--- Don't force user to think about inclusive end dates, just add a day to the end date supplied --->
	AND (rs.Created_DT >= '#m_start_date#' and rs.Created_DT < DATEADD(DAY, 1, '#m_end_date#'))
</cfquery>
