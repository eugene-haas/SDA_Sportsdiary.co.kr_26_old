<!--#include file="../dev/dist/config.asp"-->

<%
	'로그인 체크 
	'Check_UserLogin()

	'Cookie 값 가져오기 
  'iUserName =fInject(Request.cookies(global_HP)("UserName"))
	iUserName = fInject(Request.cookies("UserName"))

	'iLoginID = fInject(decode(fInject(Request.cookies(global_HP)("UserID")), 0))	
	iUserID = fInject(Request.cookies("UserID"))
	iLoginID = decode(iUserID,0)

%>

<%
  Dim iStateYN
  iStateYN = ""
  NowPage = fInject(Request("iiNowPage"))
  iMSeq = fInject(Request("iiMSeq"))
  MSeq = crypt.DecryptStringENC(iMSeq)
  iRSeq = fInject(Request("iiRSeq"))
  RSeq = crypt.DecryptStringENC(iRSeq)
  iType = fInject(Request("iiType"))

	'response.Write "iUserName : "&iUserName&"<BR>"
	'response.Write "iType : "&iType&"<BR>"
	'response.End

  If iType = "1" Then
    iContents = fInject(Request("iContentsMain"))
    iContents = HtmlSpecialChars1(iContents)
  Else
    iContents = fInject(Request("txtContents"))
    iContents = HtmlSpecialChars1(iContents)
  End If

  'response.Write "NowPage:"&NowPage&"<br />iMSeq:"&iMSeq&"<br />iContents:"&iContents&"<br />iRSeq:"&iRSeq&"<br />iType:"&iType
  'response.End

  ' iType 1 : 추가 , 2 : 수정
	If iType = "2" Then
		'JudoTitleWriteLine "iType", iType
		LSQL = "EXEC Community_Board_Reply_S '" & iType & "','" & NowPage & "','" & MSeq & "','" & iLoginID & "','" & RSeq & "','','','','',''"
		'response.Write "LSQL="&LSQL&"<br>"
		'response.End

		Set LRs = DBCon.Execute(LSQL)
		If Not (LRs.Eof Or LRs.Bof) Then
			Do Until LRs.Eof
					LCnt = LCnt + 1
					LoginIDYN = LRs("LoginIDYN")
				LRs.MoveNext
			Loop
		End If
		LRs.close

		' 수정 모드에서는 LoginIDYN 값이 'Y' 이여야 한다.
		IF LoginIDYN = "N" Then
			DBClose()
			'JudoKorea_DBClose()
			iStateYN = "N"
		Else
			' 리플수정
			Dim  LCnt1
			LCnt1 = 0
			LSQL = "EXEC Community_Board_Reply_M '" & iType & "','" & MSeq & "','" & iUserName & "','" & iContents & "','" & iLoginID & "','" & RSeq & "','','','','',''"
			'response.Write "LSQL="&LSQL&"<br>"
			'response.End
			
			Set LRs = DBCon.Execute(LSQL)
			If Not (LRs.Eof Or LRs.Bof) Then
				Do Until LRs.Eof
						LCnt1 = LCnt1 + 1
					LRs.MoveNext
				Loop
			End If
			LRs.close
			iStateYN = "Y"
			'JudoTitleWriteLine "iStateYN", iStateYN
		End IF
	ELSE
			'JudoTitleWriteLine "iType", iType
			'리플 달기 
			Dim  LCnt2
			LCnt2 = 0
			LSQL = "EXEC Community_Board_Reply_M '" & iType & "','" & MSeq & "','" & iUserName & "','" & iContents & "','" & iLoginID & "','" & RSeq & "','','','','',''"
			'response.Write "LSQL="&LSQL&"<br>"
			'response.End

			Set LRs = DBCon.Execute(LSQL)
			If Not (LRs.Eof Or LRs.Bof) Then
				Do Until LRs.Eof
						LCnt2 = LCnt2 + 1
					LRs.MoveNext
				Loop
			End If
			LRs.close
			iStateYN = "Y"
			'JudoTitleWriteLine "iStateYN", iStateYN
	End IF

	DBClose()
	'JudoKorea_DBClose()
%>

<html>
  <head>
    <title></title>
    <script type="text/javascript">

      var iStateYN = '<%=iStateYN %>'
      if (iStateYN == "N") {
        alert("잘못된 경로 입니다.");
        location.href = './Community_Qna_List.asp';
      }

      function Reply_Read_Link() {
        if (iStateYN == "N") {
          alert("잘못된 경로 입니다.");
          location.href = './Community_Qna_List.asp';
        }
        else {
          document.form1.submit();
        }
      }

  </script>
  </head>
  <body onload="Reply_Read_Link();">
    <form id="form1" name="form1" method="post" action="./Community_Qna_Write.asp">
      <input type="hidden" name="i1" id="i1" value="<%=iMSeq %>" />
      <input type="hidden" name="i2" id="i2" value="<%=NowPage %>" />
			<input type="hidden" name="iType" id="iType" value="2" />
    </form>
  </body>
</html>