<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
  Level = fInject(Request("Level"))
  fnd_ilevelname = fInject(Request("fnd_ilevelname"))
  '- iType
  '1 : 선수분석 검색부분 > 대회명
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  iType = "2"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Search '" & iType & "','" & iSportsGb & "','" & Level & "','','','',''"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)

  selData = "<option value=''>:: 체급 선택 ::</option>"

  If Not (LRs.Eof Or LRs.Bof) Then 

		Do Until LRs.Eof
       
	    IF fnd_ilevelname<>"" Then
			selData = selData & "<option value='"&LRs("Level")&"'"
			
			IF fnd_ilevelname = LRs("Level") Then selData = selData & " selected "		
			
			selData = selData & ">"&LRs("LevelNm")&"</option>"
		Else
		
			selData = selData&"<option value='"&LRs("Level")&"'>"&LRs("LevelNm")&"</option>"
		
		End IF
		
	    LRs.MoveNext
		Loop 
	End If 

  LRs.Close

  Dbclose()

  Response.Write selData

%>