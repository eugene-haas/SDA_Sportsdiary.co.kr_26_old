<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%

Function FnURLDecode(sStr) '사파리에 문제로 넣음
    Dim sRet, reEncode, sChar
    Dim i

    If isnull(sStr) Then
        sStr = ""
    Else
        Set reEncode = New RegExp
            reEncode.IgnoreCase = True
            reEncode.Pattern = "^%[0-9a-f][0-9a-f]$"
            sStr = Replace(sStr, "+", " ")
            sRet = ""

            For i = 1 To Len(sStr)
                sChar = Mid(sStr, i, 3)
                If reEncode.Test(sChar) Then
                    If CInt("&H" & Mid(sStr, i + 1, 2)) < 128 Then
                        sRet = sRet & Chr(CInt("&H" & Mid(sStr, i + 1, 2)))
                        i = i + 2
                    Elseif mid(sStr, i+3, 1) ="%" Then
                        sRet = sRet & Chr(CInt("&H" & Mid(sStr, i + 1, 2) & Mid(sStr, i + 4, 2)))
                        i = i + 5
                    Else
                        sRet = sRet & Chr(CInt("&H" & Mid(sStr, i + 1, 2) & "00") + asc(mid(sStr,i+3,1)))
                        i = i + 3
                        '이부분이 중요하다.
                        '기존 urldecode함수가 몇 몇 글자들에서 에러를 내는 이유는 3바이트로 인코딩 되어있는 부분이 '있기 때문. ascII로 변형되어 인코딩 된 부분이 존재한다.
                    End If
                Else
                    sRet = sRet & Mid(sStr, i, 1)
                End If
            Next
    End If
    FnURLDecode = sRet
End Function


  'request 처리##############
		Select Case  PAGENAME
		Case  "tube.asp"
			If InStr(m_agent,"ipad") > 0 or InStr(m_agent,"iphone") > 0 then
				  REQ = FnURLDecode(request("p")) ''chkReqMethod("p", "GET")
			Else
				  REQ = request("p")
			End if

		Case "writing_ok.asp"
		  Set Upload = Server.CreateObject("TABSUpload4.Upload")
		  REQ =  fInject(Upload.Form("p"))
		Case Else
		  REQ = chkReqMethod("p", "POST")
		End Select

If USER_IP = "118.33.86.240" Then
  ' response.redirect "http://www.sdamall.co.kr/admin/deal.asp"
	'Response.write req & "<br>"
	'Response.write m_agent
	'Response.end
	'TiykY25LTmvlzsqcNzuHYmnhqqcl9us2jNyWYGGZt6isEPxLiSDNglRLtW9H1dWze/6EG/L1iLu5+ZWlhOSDYg==
	'TiykY25LTmvlzsqcNzuHYmnhqqcl9us2jNyWYGGZt6isEPxLiSDNglRLtW9H1dWze/6EG/L1iLu5+ZWlhOSDYg==

End if

		'디버그 프린트
		'Call debugprint(REQ)
		If REQ <> "" Then

			Select Case  PAGENAME
			Case  "tube.asp"
			REQ =  decode(REQ,0)
			End Select

			If USER_IP = "118.33.86.240" Then
			'Response.write req
			'Response.end
			End if

			Set oJSONoutput = JSON.Parse(REQ)

			If hasown(oJSONoutput, "PN") = "ok" Then
				PN = oJSONoutput.PN
			Else
				If hasown(oJSONoutput, "pg") = "ok" Then
					PN = oJSONoutput.pg
				Else
					PN = 1
				End If
			End If

			If hasown(oJSONoutput, "F1") = "ok" Then  '검색필드
				F1 = chkStrRpl(oJSONoutput.F1,"")
			End If
			If hasown(oJSONoutput, "F2") = "ok" Then  '필드데이터
				F2 = chkStrRpl(oJSONoutput.F2,"")
			End If



			If hasown(oJSONoutput, "RTURL") = "ok" Then '유저번호
				RTURL =	 oJSONoutput.RTURL
			End If

			If hasown(oJSONoutput, "M_MIDX") = "ok" Then '유저번호
				m_idx =	 chkInt(oJSONoutput.M_MIDX, 0)
			End If

			If hasown(oJSONoutput, "M_PR") = "ok" then		'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
				m_pr = oJSONoutput.M_PR
			End If

			If hasown(oJSONoutput, "M_SGB") = "ok" then	'종목 judo
				m_sgb = oJSONoutput.M_SGB
			End if

			If hasown(oJSONoutput, "M_BNKEY") = "ok" then	'이동할 풀네임 주소 (tube.asp 에서만 사용하면 됨)
				m_bnidx = chkInt(oJSONoutput.M_BNKEY,0)
                If m_bnidx = 0 Then
                m_bnidx = oJSONoutput.M_BNKEY
                End If
			Else
				m_bnidx = 0
			End If


			If hasown(oJSONoutput, "EVTIDX") = "ok" then	'event view idx
				EVTIDX = oJSONoutput.EVTIDX
			End if

  Select Case  PAGENAME
  Case "detail.asp"
    If hasown(oJSONoutput, "GD_SEQ") = "ok" then
  		seq = oJSONoutput.GD_SEQ
      gdSeq = oJSONoutput.GD_SEQ
  	End if
    If hasown(oJSONoutput, "pageType") = "ok" then
  		pageType = oJSONoutput.pageType
  	End if
    If hasown(oJSONoutput, "BRAND_SEQ") = "ok" then
  		brandSeq = oJSONoutput.BRAND_SEQ
  	End if
  End Select

		Else
			pno = 1 '한페이지에서 (여러 화면 중 1페이지)

			Select Case  PAGENAME
			Case  "fnd_id_ok.asp"
				fnd_UserID = decode(chkReqMethod("fnd_UserID", "GET"),0)
			Case "event.asp"
		eventidx = chkReqMethod("idx", "GET")
			Case else
			'findmode 전체검색
			Set oJSONoutput = JSON.Parse("{}")
			PN = chkInt(chkReqMethod("PN", "GET"), 1)
		    gdSeq = chkInt(chkReqMethod("seq", "GET"), 1)
		    RTURL = chkReqMethod("RTURL", "GET") '로그인후 돌아갈 페이지 지정할때 사용
			End Select

		End If

		reqjson = JSON.stringify(oJSONoutput)
  'request 처리##############

	If sitecode  = "ADN99" Then
		If pagename = "tablehelp.asp" Or pagename = "jsonp.asp" then
			ConStr = B_ConStr
			Response.Cookies("DBNO") = "DB00"
			Response.Cookies("DBNO").domain = "adm.sportsdiary.co.kr"	
		End if
		'dbnmarr = array("공통","멤버","아이템센터","베드민턴","테니스","SD테니스","수영","승마","자전거","유도") cfg.pub 에 정의

		If F1 <> "" Then

			%><!-- #include virtual = "/pub/inc/inc.dbNick.asp" --><%

			Response.Cookies("DBNO") = F1
			Response.Cookies("DBNO").domain = "adm.sportsdiary.co.kr"	
		
		End If

	End if
%>
