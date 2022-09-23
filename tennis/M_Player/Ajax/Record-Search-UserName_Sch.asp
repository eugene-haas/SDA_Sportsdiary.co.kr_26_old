<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	  
	SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
	Schgubun = fInject(Request("Schgubun"))
	Fnd_KeyWord 	= fInject(Request("Fnd_KeyWord"))
	
    
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  fInject(Request("EnterType"))

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

	
	iType = "3"
	'iSportsGb = "judo"

  Dim iPIDX, iPhotoPath

	LSQL = "EXEC Record_Search '" & iType & "','" & iSportsGb & "','" & iEnterType & "','" & SDate & "','" & EDate & "','" & Schgubun & "','" & Fnd_KeyWord & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)
	

  If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof

      iCnt = iCnt + 1
      iPlayerIDX = iPlayerIDX&"$"&encode(LRs("SearchIDX"),0)

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
