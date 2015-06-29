<cfoutput>
       "PrevFY" = SUM(CASE WHEN 
	   			  (
				  <cfif dataMonth GTE 7 AND dataMonth LTE 12>
                   dataMonth BETWEEN 7 AND #dataMonth# AND dataYear = #PrevFYStart#
                  <cfelseif dataMonth GTE 1 AND dataMonth LTE 6>
                   (dataMonth BETWEEN 7 AND 12 AND dataYear = #PrevFYStart#)
                    OR
                   (dataMonth BETWEEN 1 AND #dataMonth# AND dataYear = #PrevFYEnd#)
                  </cfif>
				  ) THEN [Count] ELSE NULL END),
       "CurrFY" = SUM(CASE WHEN 
	   			  (
				  <cfif dataMonth GTE 7 AND dataMonth LTE 12>
                   dataMonth BETWEEN 7 AND #dataMonth# AND dataYear = #CurrFYStart#
                  <cfelseif dataMonth GTE 1 AND dataMonth LTE 6>
                   (dataMonth BETWEEN 7 AND 12 AND dataYear = #CurrFYStart#)
                    OR
                   (dataMonth BETWEEN 1 AND #dataMonth# AND dataYear = #CurrFYEnd#)
                  </cfif>
				  ) THEN [Count] ELSE NULL END),
       "PrevFYMonth" = SUM(CASE WHEN
	   				dataMonth = #dataMonth# AND dataYear = 
					<cfif dataMonth GTE 7 AND dataMonth LTE 12>#PrevFYStart#<cfelse>#CurrFYStart#</cfif>
					THEN [Count]
                    ELSE NULL END),
       "CurrFYMonth" = SUM(CASE WHEN
	   				dataMonth = #dataMonth# AND dataYear = 
					<cfif dataMonth GTE 7 AND dataMonth LTE 12>#CurrFYStart#<cfelse>#CurrFYEnd#</cfif>
					THEN [Count]
                    ELSE NULL END)
</cfoutput>