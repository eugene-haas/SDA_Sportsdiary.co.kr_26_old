<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))
	code    = fInject(Request("code"))
	
	If code = "" Then 
		Response.End
	End If 


	LSQL = "SELECT "
	LSQL = LSQL&" SchIDX"
	LSQL = LSQL&" ,SchoolName"
	LSQL = LSQL&" ,SportsDiary.dbo.FN_PubName(Sido)	AS SidoName"
	LSQL = LSQL&" ,SchoolCode"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblSchoolList "
	LSQL = LSQL&" WHERE SchoolName Like '%"&code&"%'"
	LSQL = LSQL&" AND DelYN='N'"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"' onChange=""chk_Player('sel_Player','PlayerIDX',this.value,'','');"" />"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("SchoolName") Then 
				selData = selData&"<option value='"&LRs("SchIDX")&"' selected>"&LRs("SchoolName")&LRs("SidoName")&LRs("SchoolCode")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("SchIDX")&"' >"&LRs("SchoolName")&LRs("SidoName")&LRs("SchoolCode")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>