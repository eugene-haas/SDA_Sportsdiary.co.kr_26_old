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

	' 쿠키로 나중에 받을것
  ' iLoginID = global_iLoginID

  Dim iStateYN
  iStateYN = ""

  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt
  LCnt = 0

  NowPage = fInject(Request("i2"))
  iMSeq = fInject(Request("i1"))
  MSeq = crypt.DecryptStringENC(iMSeq)
  iRSeq = fInject(Request("i4"))
  RSeq = crypt.DecryptStringENC(iRSeq)
  iType = fInject(Request("i3"))
	'iLoginID = fInject(Request("I5"))
	'JudoTitleWriteLine "NowPage", NowPage
	'JudoTitleWriteLine "iMSeq", iMSeq
	'JudoTitleWriteLine "MSeq", MSeq
	'JudoTitleWriteLine "iRSeq", iRSeq
	'JudoTitleWriteLine "RSeq", RSeq
	'JudoTitleWriteLine "iType", iType

  'JudoWriteLine "Cookie 값"
	'JudoTitleWriteLine "ID", iLoginID
  'JudoTitleWriteLine "Name", iName
  'JudoTitleWriteLine "iRole", iRole

  ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
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

	' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
	If LoginIDYN = "N" Then
	
		DBClose()
	  'JudoKorea_DBClose()
	
	  'response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='./cmList.asp';</script>"
	  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
	  'response.End
	
	  iStateYN = "N"
	
	Else
	
	  ' 첨부파일 삭제
	  Dim  LCnt1
	  LCnt1 = 0
	  'iType = 1 ' 1:Delete
	  
	  LSQL = "EXEC Community_Board_Reply_D '" & iType & "','" & MSeq & "','" & RSeq & "','" & iLoginID & "'"
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
	  
		DBClose()
	  'JudoKorea_DBClose()
	
	  iStateYN = "Y"
	  
	
	End If
%>

<SCRIPT type="text/javascript">

  var iStateYN = '<%=iStateYN %>'

  if (iStateYN == "N") {

    alert("잘못된 경로 입니다.");
    location.href = './Community_Qna_List.asp';

  }
  else {
    
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

</SCRIPT>

<HTML>
	<HEAD>
	<TITLE></TITLE>
	</HEAD>

<BODY onload="Reply_Read_Link();">
<FORM name="form1" id="form1" method="post" action="./Community_Qna_Write.asp">
  <input type="hidden" id="i1" name="i1" value="<%=iMSeq %>" />
  <input type="hidden" id="i2" name="i2" value="<%=NowPage %>" />
	<input type="hidden" name="iType" id="iType" value="2" />
</FORM>
</BODY>
</HTML>