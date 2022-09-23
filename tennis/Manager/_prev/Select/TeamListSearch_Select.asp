<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))
	code    = fInject(Request("code"))
	
	If code = "" Then 
		Response.End
	End If 


	LSQL = "SELECT "
	LSQL = LSQL&" Team"
	LSQL = LSQL&" ,TeamNm"
	LSQL = LSQL&" ,SportsDiary.dbo.FN_SidoName(Sido,'judo')	AS SidoNm"
	LSQL = LSQL&" ,Case When Sex ='1' Then '남자' When Sex ='2' Then '여자' When Sex = '3' Then '혼성' End AS SexNm "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblTeamInfo "
	LSQL = LSQL&" WHERE TeamNm Like '%"&code&"%'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"' onChange=""chk_Player('sel_Player','PlayerIDX',this.value,'','');"" />"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If UCase(code) = UCase(LRs("Team")) Then 
				selData = selData&"<option value='"&LRs("Team")&"' selected>"&LRs("TeamNm")&"["&LRs("SexNm")&"]["&LRs("SidoNm")&"]"&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("Team")&"' >"&LRs("TeamNm")&"["&LRs("SexNm")&"]["&LRs("SidoNm")&"]"&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>