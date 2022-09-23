<!--#include file="../dev/dist/config.asp"-->

<%
  
  iType = fInject(Request("iType"))           ' 1:글쓰기, 2:수정
  
  iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)

  NowPage = fInject(Request("iNowPage"))      ' 현재페이지
  
	iSctNm = fInject(Request("iSctNm"))
  iDirector = fInject(Request("iDirector"))
	iSidoNm = fInject(Request("iSidoNm"))
	PostCode = fInject(Request("PostCode"))
	UserAddr = fInject(Request("UserAddr"))
  UserAddrDtl = fInject(Request("UserAddrDtl"))
	iPhone = fInject(Request("iPhone"))
	iMobile = fInject(Request("iMobile"))

  iLoginID = fInject(Request("iID"))                ' 로그인ID


  Dim LCnt
  LCnt = 0

  LSQL = "EXEC tblSvcSctInfo_Mod_STR '" & iType & "','" & iSidoNm & "','" & iSctNm & "','" & iDirector & "','" & PostCode & "','" & UserAddr & "','" & UserAddrDtl & "','" & iPhone & "','" & iMobile & "','','','" & iLoginID & "','" & MSeq & "'"
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
  
  
  response.Write "<script type='text/javascript'>alert('글 등록이 잘 돼었습니다.');location.href='./Stadium_List.asp';</script>"
  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
  response.End
  

  JudoKorea_DBClose()
%>