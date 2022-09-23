<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	
	iPlayerIDX = decode(iPlayerIDX,0)

  'SDate = "2016-03-06"
  'EDate = "2017-03-10"
  'iPlayerIDX = "1403"
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  Dim LRsCnt1, iTotalResult1
  LRsCnt1 = 0

  iType = "21"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        iTotalResult1 = LRs("iTotalResult")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  Dim LRsCnt2, iWinResult2
  LRsCnt2 = 0

  iType = "22"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1
        iWinResult2 = LRs("iWinResult")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  Dbclose()


  Dim ihtml, iper, iLoseResult

  if LRsCnt1 > 0 then

    'iLoseResult = CInt(iTotalResult1) - CInt(iWinResult2)
    'iper = ROUND(CInt(iWinResult2) / CInt(iTotalResult1) * 100)

    if CInt(iTotalResult1) = 0 or CInt(iWinResult2) = 0 then
      iLoseResult = CInt(iTotalResult1) - CInt(iWinResult2)
      iper = 0
    else
      iLoseResult = CInt(iTotalResult1) - CInt(iWinResult2)
      iper = ROUND(CInt(iWinResult2) / CInt(iTotalResult1) * 100)
    end if
      
    
    ihtml = iTotalResult1&"전 "&iWinResult2&"승 "&iLoseResult&"패 ("&iper&"%)"
    
    response.Write ihtml

  end if

%>
