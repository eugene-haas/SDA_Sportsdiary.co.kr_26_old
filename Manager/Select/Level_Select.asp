<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))
	teamgb  = fInject(Request("teamgb"))
	sex  = fInject(Request("sex"))



	if sex = "Man" Then 
	'초등
		if teamgb = "sd011001" Then 
			'초등 lv007
			level_type = "lv007"
		ElseIf  teamgb = "sd011002" Then 
			'중등 lv005
			level_type = "lv005"
		ElseIf  teamgb = "sd011003" Then  
			'고등 lv003
			level_type = "lv003"
		ElseIf teamgb = "sd011004" Then 
			'대등 lv001
			level_type = "lv001"
		ElseIf teamgb = "sd011005" Then 
				level_type = "lv009"
		End If 
	ElseIf sex = "WoMan" Then 
		If teamgb == "sd011001" Then 
			'초등 lv008
			level_type = "lv008"
		ElseIf teamgb = "sd011002"
			//중등 lv006
			level_type = "lv006";
		ElseIf teamgb = "sd011003"
			//고등 lv004
			level_type = "lv004";
		ElseIf teamgb = "sd011004"
			//대등 lv002
			level_type = "lv002";
		ElseIf teamgb = "sd011005"
			level_type = "lv010";
		End If 			
	End If 









	LSQL = "SELECT"
	LSQL = LSQL&" PubCode"
	LSQL = LSQL&" ,Pubname"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblPubCode"
	LSQL = LSQL&" WHERE pPubCode='"&level_type&"'"
	LSQL = LSQL&" ORDER BY PubCode ASC"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"'>"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("PubCode") Then 
				selData = selData&"<option value='"&LRs("PubCode")&"' selected>"&LRs("Pubname")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("PubCode")&"' >"&LRs("Pubname")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>