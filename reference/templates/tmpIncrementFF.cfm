function increment(e)
{
//Firefox: 0 = left, 2 = right
	var TypeID = this.name.substr(7,2);
	var left = 0;
	var right = 2;

	if (e.button == left)
	{
		// if the field is empty, then set the value to 1
		if (isNaN(parseInt(this.value)))
		{
			this.value = 1;
			//if the the question was a reference question then increment transaction count
			if (TypeID == '02' ||
				TypeID == '03' ||
				TypeID == '04' ||
				TypeID == '05' ||
				TypeID == '06' ||
				TypeID == '08' ||
				TypeID == '00')
			{
				//if no transactions set transaction count to 1
				if (!Transaction)
				{
					document.KeyPad.<cfoutput>#UnitPointID#0000</cfoutput>.value = 1;
					Transaction = true;
				}
			}
		}
		// if the field contained a numeric value and the question was a reference question, increment the value
		else
		{
			this.value = parseInt(this.value) + 1;
		}
		document.KeyPad.SubmitIt.focus();
	}
	// if the action is a right mouse button click
	if (e.button == right)
	{
		// if the the field contains a number and it is greater than 1, then decrement the value
		if (!isNaN(parseInt(this.value)))
		{
			if (parseInt(this.value) > 1)
			{
				this.value = parseInt(this.value) - 1;
			}
			// if the field contains a number and it is less than or equal to 1, then set the value to blank
			else
			{
				this.value = "";
			}
		}
		// loop through all field values to check for reference questions
		for (var i = 0; i < NumFields; i++)
		{
			var QuestType = document.KeyPad.elements[i].name.substr(7,2);
			if (QuestType == '02' ||
				QuestType == '03' ||
				QuestType == '04' ||
				QuestType == '05' ||
				QuestType == '06' ||
				QuestType == '08' ||
				QuestType == '00')
			{
				if (document.KeyPad.elements[i].value.replace(/^\s*/, '').replace(/\s*$/, '') != '')
				{
					Transaction = true;
					break;
				}
				else
				{
					Transaction = false;
				}
			}
			if (QuestType == '01' ||
				QuestType == '07' ||
				QuestType == '09')
			{
				if (document.KeyPad.elements[i].value.replace(/^\s*/, '').replace(/\s*$/, '') != '')
				{
					if (!Transaction)
					{
						Transaction = false;
						break;
					}
				}
			}
		}
		if (!Transaction)
		{
			document.KeyPad.<cfoutput>#UnitPointID#0000</cfoutput>.value = '';
		}
		document.KeyPad.SubmitIt.focus();
	}
}

<cfoutput query="GetUnitCategory" group="ServicePoint">
	<cfoutput group="QuestionType">
		<cfloop index="M" list="#AllModes#">
			<cfset Pair = 0>
			<cfoutput group="ModeID">
				<cfif GetUnitCategory.ModeID is M>
					<cfset Pair = 1>
					<cfset AggID = GetUnitCategory.AggregateID>
				</cfif>
			</cfoutput>
			<cfif Pair>
				var #AggID# = document.getElementById('#AggID#');
				if( #AggID#.addEventListener )
				{
				  #AggID#.addEventListener('mousedown',increment,false);
				}
				else if( #AggID#.attachEvent )
				{
				  #AggID#.attachEvent('onmousedown',increment);
				}
			</cfif>
		</cfloop>
	</cfoutput>
</cfoutput>

