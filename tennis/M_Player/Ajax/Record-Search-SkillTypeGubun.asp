<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 


  '- iType
  '1 : 선수분석 검색부분 > 대회명

  iType = "5"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Search '" & iType & "','" & iSportsGb & "','','','','',''"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)

  selData = "<option value=''>:: 기술명 선택 ::</option>"

  If Not (LRs.Eof Or LRs.Bof) Then 

		Do Until LRs.Eof
      
        selData = selData&"<option value='"&LRs("PubCode")&"'>"&LRs("PubName")&"</option>"

	    LRs.MoveNext
		Loop 
	End If 

  LRs.Close

  Dbclose()

  Response.Write selData

%>