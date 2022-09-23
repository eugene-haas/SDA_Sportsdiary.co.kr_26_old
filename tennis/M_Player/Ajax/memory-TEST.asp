<!--#include file="../Library/ajax_config.asp"-->
<%
  
  Dim iTotalCount, iTotalPage, LCnt, iTemp
  LCnt = 0

  GameTitleIDX = ""
  SDate = "2016-03-06"
  EDate = "2017-03-31"
  iMemberIDX = "42"


  iNowPage = Request("iNowPage")

  iPageSize = 3
	iBlockPage = 3

  If Len(iNowPage) = 0 Then
		iNowPage = 1
	End If

  iType = "1_1"
  iSportsGb = "judo"

  LSQL = "EXEC Memory_TM_Total_Search '','" & iPageSize & "','" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
      
        LCnt = LCnt + 1
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")

      LRs.MoveNext
		Loop

  else
    
	End If

  LRs.close

  Dbclose()

%>

<%

if LCnt > 0 then

  Response.Write "<div class=""board-btm-list"">"
  Response.Write "  <ul class=""pagination"">"
  
  iTemp = Int((iNowPage - 1) / iBlockPage) * iBlockPage + 1
							
	If iTemp = 1 Then
			Response.Write "<li><span aria-hidden=""true"">&lt;</span></li>"
	Else 
			Response.Write"<li><a href=""javascript:test('" & iTemp - iBlockPage & "')"" onclick=""javascript:test1('"&iTemp- iBlockPage&"')"" aria-label=""Previous""><span aria-hidden=""true"">&lt;</span></a></li>"
	End If
  
  iLoop = 1
  
  Do Until iLoop > iBlockPage Or iTemp > iTotalPage
			If iTemp = CInt(iNowPage) Then
					Response.Write "<li class=""active""><a href=""javascript:;"">" & iTemp &"</a></li>" 
			Else
					Response.Write"<li><a href=""javascript:test('" & iTemp & "')"" onclick=""javascript:test1('"&iTemp&"')"">" & iTemp & "</a></li>"
			End If
			iTemp = iTemp + 1
			iLoop = iLoop + 1
	Loop
  
	If iTemp > iTotalPage Then
			Response.Write "<li><span aria-hidden=""true"">&gt;</span></li>"
	Else
			Response.Write"<li><a href=""javascript:test('" & iTemp & "')"" onclick=""javascript:test1('"&iTemp&"')"" aria-label=""Next""><span aria-hidden=""true"">&gt;</span></a></li>"
	End If
  
  Response.Write "  </ul>"
  Response.Write "</div>"


end if  
  
%>