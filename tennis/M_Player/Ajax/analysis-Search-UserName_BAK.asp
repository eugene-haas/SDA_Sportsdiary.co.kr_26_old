<!--#include file="../Library/ajax_config.asp"-->
<%
  
	SDate = fInject(Request("SDate"))
  GameTitleIDX = fInject(Request("GameTitleIDX"))
  fnd_KeyWord 	= fInject(Request("fnd_KeyWord"))
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  if  fnd_KeyWord = "park" then
    fnd_KeyWord = "박"
  end if

  '- iType
  '1 : 선수분석 검색부분 > 대회명
  '2 : 선수분석 검색부분 > 선수명

  iType = "2"
  'iSportsGb = "judo"

  LSQL = "EXEC Analysis_View '" & iType & "','" & SDate & "','" & iSportsGb & "','" & GameTitleIDX & "','" & fnd_KeyWord & "'"
	Set LRs = Dbcon.Execute(LSQL)
	

  If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof
%>
      <li><a href="javascript:$('#fnd_KeyWord').val('<%=LRs("UserName")%>')"><%=replace(LRs("UserName"),fnd_KeyWord, "<strong>"&fnd_KeyWord&"</strong>")%></a></li>
<%
	    LRs.MoveNext
		Loop 
	End If 
  
  LRs.Close
	SET LRs = Nothing
  Dbclose()

%>