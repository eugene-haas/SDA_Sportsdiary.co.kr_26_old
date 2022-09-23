<!--#include file="../dev/dist/config.asp"-->

<%
	' 1 : 협회소개 2 : 유도소개(유도용어) 3 : 유도소개(기술용어)
  iDivision = "2"
  
  iType = fInject(Request("iType"))           ' 1:글쓰기, 2:수정
  
  iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)

  NowPage = fInject(Request("iNowPage"))      ' 현재페이지
  'Subject = fInject(Request("iSubject"))      ' 제목

	iStatus = fInject(Request("iStatus"))
  iDivision = fInject(Request("iDivision"))
	isyear = fInject(Request("isyear"))
	iStartSection = fInject(Request("iStartSection"))
	ieyear = fInject(Request("ieyear"))
	iEndSection = fInject(Request("iEndSection"))
	iPeriod = fInject(Request("iPeriod"))
	iPayment = fInject(Request("iPayment"))
	iName = fInject(Request("iName"))
	iPhone = fInject(Request("iPhone"))
	iPostCode = fInject(Request("PostCode"))
	iUserAddr = fInject(Request("UserAddr"))
	iUserAddrDtl = fInject(Request("UserAddrDtl"))
	iEmail = fInject(Request("iEmail"))
	iDepositorName = fInject(Request("iDepositorName"))

	iStartSectionName = fInject(Request("iStartSectionName"))

  iLoginName = fInject(Request("iLN"))            ' 로그인유저
  iLoginID = fInject(Request("iID"))                ' 로그인ID


  Dim LCnt
  LCnt = 0

  LSQL = "EXEC Subscription_Board_Mod_Admin_STR '" & iType & "','" & iStatus & "','" & iDivision & "','" & isyear & "','" & iStartSection & "','" & ieyear & "','" & iEndSection & "','" & iPeriod & "','" & iPayment & "','" & iName & "','" & iPhone & "','" & iPostCode & "','" & iUserAddr & "','" & iUserAddrDtl & "','" & iEmail & "','" & iDepositorName & "','" & iStartSectionName & "','','','','" & iLoginID & "','" & MSeq & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon4.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

		Do Until LRs.Eof
      
        LCnt = LCnt + 1
        iMSeq = LRs("MSeq")

      LRs.MoveNext
		Loop

	End If

  LRs.close
  
	JudoKorea_DBClose()
  
  response.Write "<script type='text/javascript'>alert('글 등록이 잘 돼었습니다.');location.href='./News_Magazine_Req_List.asp?i2="&NowPage&"';</script>"
  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
  response.End
  
%>