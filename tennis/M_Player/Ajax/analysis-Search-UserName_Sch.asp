<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()  
	
	SDate = fInject(Request("SDate"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	fnd_KeyWord 	= fInject(Request("fnd_KeyWord"))
	
	iCnt = 0
	iPlayerIDX = ""
	
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

	'- iType
	'1 : 선수분석 검색부분 > 대회명
	'2 : 선수분석 검색부분 > 선수명
	
	iType = "3"
	'iSportsGb = "judo"

  'SDate = "2016"
  'GameTitleIDX = "00"
  'fnd_KeyWord = "손"

  LSQL = "EXEC Analysis_Search '" & iType & "','" & SDate & "','" & iSportsGb & "','" & GameTitleIDX & "','" & fnd_KeyWord & "'"
	Set LRs = Dbcon.Execute(LSQL)
	

  If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof

      iCnt = iCnt + 1
      iPlayerIDX = iPlayerIDX&"$"&encode(LRs("PlayerIDX"),0)

	    LRs.MoveNext
		Loop 
	End If 
  
  LRs.Close
	SET LRs = Nothing
  Dbclose()

  '한판,절반 등...
    if iPlayerIDX <> "" then
      iPlayerIDX = Mid(iPlayerIDX, 2, len(iPlayerIDX) - 1)
    end if

  response.Write iCnt&"^"&iPlayerIDX

%>
