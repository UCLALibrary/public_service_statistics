function Increment(AggregateID)
{
	var TypeID = AggregateID.substr(7,2);
	// if the action is a left mouse button click
	if (event.button == 1)
	{
		// if the field is empty, then set the value to 1
		if (isNaN(parseInt(document.KeyPad.elements[AggregateID].value)))
		{
			document.KeyPad.elements[AggregateID].value = 1;
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
			document.KeyPad.elements[AggregateID].value = parseInt(document.KeyPad.elements[AggregateID].value) + 1;
		}
		document.KeyPad.SubmitIt.focus();
	}
	// if the action is a right mouse button click
	if (event.button == 2)
	{
		// if the the field contains a number and it is greater than 1, then decrement the value
		if (!isNaN(parseInt(document.KeyPad.elements[AggregateID].value)))
		{
			if (parseInt(document.KeyPad.elements[AggregateID].value) > 1)
			{
				document.KeyPad.elements[AggregateID].value = parseInt(document.KeyPad.elements[AggregateID].value) - 1;
			}
			// if the field contains a number and it is less than or equal to 1, then set the value to blank
			else
			{
				document.KeyPad.elements[AggregateID].value = "";
			}
		}
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

