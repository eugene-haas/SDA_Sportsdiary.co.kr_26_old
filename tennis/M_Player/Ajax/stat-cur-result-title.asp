<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = Request("SDate")
	EDate = Request("EDate")
	'iStimFistCd = Request("iStimFistCd")
	iMemberIDX = fInject(Request("iMemberIDX"))
	GameTitleIDX = ""
	
	iMemberIDX = decode(iMemberIDX,0)
    
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  iType = "11"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','',''"
	Set LRs = Dbcon.Execute(LSQL)

  selData = "<select name=""iTitle"" id=""iTitle"" onchange=""javascript:iTitle_chg();"">"
  selData = selData&"   <option value="""">::측정 항목을 선택하세요::</option>"
  If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof
        selData = selData&"<option value='"&LRs("StimFistCd")&"^"&LRs("StimMidCd")&"'>"&LRs("StimFistNm")&" ["&LRs("StimMidNm")&"]"&"</option>"
	    LRs.MoveNext
		Loop 
	End If 
  selData = selData&"</select>"

  LRs.close

  Dbclose()

  Response.Write selData

%>