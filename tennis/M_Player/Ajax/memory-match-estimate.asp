<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	iDate = fInject(Request("iDate"))
	iGmIDX = fInject(Request("iGmIDX"))
	
	'iDate = "2016-03-06"
	'iTrIDX = "16"
	
	iGmIDX = decode(iGmIDX,0)
	
	iType = "113"
	iSportsGb = "judo"
	
	Dim LRsCnt1
	LRsCnt1 = 0

  LSQL = "EXEC Memory_Search '" & iType & "','" & iSportsGb & "','','','','" & iGmIDX & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = "<h3>"&iDate&"</h3>"
	  retext = retext&"<table class=""navy-top-table"">"
	  retext = retext&"  <thead>"
	  retext = retext&"	  <tr>"
	  retext = retext&"		  <th rowspan=""2"">평가 내용</th>"
	  retext = retext&"		  <th colspan=""3"">만족도</th>"
	  retext = retext&"	  </tr>"
	  retext = retext&"	  <tr>"
	  retext = retext&"		  <th>상</th>"
	  retext = retext&"		  <th>중</th>"
	  retext = retext&"		  <th>하</th>"
	  retext = retext&"	  </tr>"
	  retext = retext&"	  <tbody>"

		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        'retext = retext&"{""label"": """&LRs("ResultName")&"""},"
        
        	retext = retext&"		  <tr>"
	        retext = retext&"			  <td><label for=""tranin-question"&LRsCnt1&""">"&LRsCnt1&"."&LRs("AsmtNm")&"</label></td>"

	        retext = retext&"			  <td><input type=""radio"" id=""tranin-question"&LRsCnt1&"-"&LRsCnt1&""" name=""tranin-question"&LRsCnt1&"-"&LRsCnt1&""" "
          if LRs("TopAsmtMark") = "Y" then
            retext = retext&" checked"
          end if
          retext = retext&" disabled /></td>"

	        retext = retext&"			  <td><input type=""radio"" id=""tranin-question"&LRsCnt1&"-"&LRsCnt1+1&""" name=""tranin-question"&LRsCnt1&"-"&LRsCnt1+1&""" "
          if LRs("MidAsmtMark") = "Y" then
            retext = retext&" checked"
          end if
          retext = retext&" disabled /></td>"
	        
          retext = retext&"			  <td><input type=""radio"" id=""tranin-question"&LRsCnt1&"-"&LRsCnt1+2&""" name=""tranin-question"&LRsCnt1&"-"&LRsCnt1+2&""" "
          if LRs("BotAsmtMark") = "Y" then
            retext = retext&" checked"
          end if
          retext = retext&" disabled /></td>"
	        
          retext = retext&"		  </tr>"

      LRs.MoveNext
		Loop

    retext = retext&"	  </tbody>"
	  retext = retext&"  </thead>"
	  retext = retext&"</table>"

  else
     retext="검색안나와요"
	End If

  LRs.close

  Dbclose()

	Response.Write retext
%>