<!--#include file="../dev/dist/config.asp"-->

<%
	' 1 : 협회소개 2 : 유도소개(유도용어) 3 : 유도소개(기술용어)
  iDivision = "3"
  
  iType = fInject(Request("iType"))           ' 1:글쓰기, 2:수정
  
  iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)

  NowPage = fInject(Request("iNowPage"))      ' 현재페이지
  Subject = fInject(Request("iSubject"))      ' 제목

	Contents = fInject(Request("iContents"))    ' 내용
	' 스마트에디터는 ' 문자만 변경이 안돼서 처리 해야 한다. HtmlSpecialChars 함수 사용 할 필요 없음.
	iContents = Replace(Contents,"'","&#039;")

	iLink = ""

  NationalTermName = fInject(Request("iNationalTermName"))
	EnTermName = fInject(Request("iEnTermName"))

	Pronunciation = ""

	TermKey = fInject(Request("iTermKey"))
	TermMidKey = fInject(Request("iTermMidKey"))
	TechCode = fInject(Request("iTechCode"))

  Name = fInject(Request("iName"))            ' 로그인유저
  ID = fInject(Request("iID"))                ' 로그인ID


  Dim LCnt
  LCnt = 0

  LSQL = "EXEC Infomation_Board_Mod_STR '" & iType & "','" & iDivision & "','" & Name & "','" & Subject & "','" & iContents & "','" & iLink & "','" & NationalTermName & "','" & EnTermName & "','" & Pronunciation & "','" & TermKey & "','" & TermMidKey & "','" & TechCode & "','" & ID & "','" & MSeq & "'"
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
  
  
  response.Write "<script type='text/javascript'>alert('글 등록이 잘 돼었습니다.');location.href='./Info_SkillWord_List.asp';</script>"
  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
  response.End
  

  JudoKorea_DBClose()
%>