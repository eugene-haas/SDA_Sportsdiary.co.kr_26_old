<!--#include file="../dev/dist/config.asp"-->

<%
	' 1 : 협회소개 2 : 유도소개(유도용어) 3 : 유도소개(기술용어)
  iDivision = "2"
  
  iType = fInject(Request("iType"))           ' 1:글쓰기, 2:수정
  
  iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)

  NowPage = fInject(Request("iNowPage"))      ' 현재페이지
  Subject = fInject(Request("iSubject"))      ' 제목

  NationalTermName = fInject(Request("iNationalTermName"))
	Pronunciation = fInject(Request("iPronunciation"))

  Name = fInject(Request("iName"))            ' 로그인유저
  ID = fInject(Request("iID"))                ' 로그인ID


  Dim LCnt
  LCnt = 0

  LSQL = "EXEC Infomation_Board_Mod_STR '" & iType & "','" & iDivision & "','" & Name & "','" & Subject & "','" & iContents & "','" & iLink & "','" & NationalTermName & "','','" & Pronunciation & "','','','','" & ID & "','" & MSeq & "'"
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
  
  
  response.Write "<script type='text/javascript'>alert('글 등록이 잘 돼었습니다.');location.href='./Info_JudoWord_List.asp';</script>"
  'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
  response.End
  

  JudoKorea_DBClose()
%>