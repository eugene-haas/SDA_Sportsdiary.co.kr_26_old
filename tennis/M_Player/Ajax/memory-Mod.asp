<!--#include file= "../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	iType = fInject(Request("iType"))
	iMemberIDX = fInject(Request("iMemberIDX"))
	iRerdIDX = fInject(Request("iRerdIDX"))
	iRerdType = fInject(Request("iRerdType"))
	
	iType = decode(iType,0)
	iMemberIDX = decode(iMemberIDX,0)
	iRerdIDX = decode(iRerdIDX,0)
	
	Dim LRsCnt1, iFavYN
	LRsCnt1 = 0
	
	'iType = "1"
	iSportsGb = "judo"
  
  LSQL = "EXEC Memory_Fav_Mod '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & iRerdIDX & "','" & iRerdType & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)
  
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
  
        LRsCnt1 = LRsCnt1 + 1
        iFavYN = LRs("FavYN")
  
      LRs.MoveNext
		Loop
  else
    
	End If
  
  LRs.close
  
  Dbclose()

  response.Write iFavYN

%>