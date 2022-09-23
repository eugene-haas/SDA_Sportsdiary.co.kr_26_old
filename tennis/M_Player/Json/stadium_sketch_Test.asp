<!--#include file="../Library/ajax_config.asp"-->
<%
	'Check_Login()
	    
  ilType = request("ilType")

  if ilType = "" then

    ilType = "1"

  end if

  GameTitleIDX = request("GameTitleIDX")
  TeamGbIDX	 = request("TeamGbIDX")
  NowPage = request("NowPage")
  SiteGubun = request("SiteGubun")


  LRsCnt1 = 0

  iType = "1"
  'iSportsGb = "judo"

  If SiteGubun = "S"  then
  CSQL = "EXEC SD_RookieTennis.dbo.Stadium_Sketch_S '" & NowPage & "','" & global_sketch_PagePerData & "','" & global_sketch_BlockPage & "','" & iType & "','" & GameTitleIDX & "','" & TeamGbIDX & "','T','','','','','','',''"
  Else
  CSQL = "EXEC Stadium_Sketch_S '" & NowPage & "','" & global_sketch_PagePerData & "','" & global_sketch_BlockPage & "','" & iType & "','" & GameTitleIDX & "','" & TeamGbIDX & "','T','','','','','','',''"
  End if

  Set CRs = DBCon4.Execute(CSQL)

  FormData = FormData & "<ul id='DP_ImgList'>"

  If Not (CRs.Eof Or CRs.Bof) Then
		Do Until CRs.Eof

        CRsCnt1 = CRsCnt1 + 1

        if CRsCnt1 = 1 then
          
          retext = "[{"
          retext = retext&"""cnt"":"""&CRs("TOTALCNT")&""","
          retext = retext&"""links"":["

        end if
        
        'retext = retext&"{""link"":""http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/"&CRs("photo")&"""},"
        'retext = retext&"{""link"":""http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/ListTN/ListTN_"&CRs("photo")&"""},"
        retext = retext&"{""link"":"""&CRs("photo")&"""},"

      CRs.MoveNext
		Loop

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]}]"

  else

	End If
	

  CRs.close

  DBClose4()
	
  response.Write retext
%>