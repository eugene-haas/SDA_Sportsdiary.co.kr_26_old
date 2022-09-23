<!--#include file="../dev/dist/config.asp"-->

<%
	'로그인 체크 
	Check_UserLogin()

	'Cookie 값 가져오기 
	iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
	iUserName = fInject(Request.Cookies("UserName"))
%>

<%
  Dim NowPage, Subject, Contents, Filecnt, iFilecnt, iDivision, iLink

  ' T:전부, 1:포토갤러리, 2:동영상갤러리, 3:질문과답변, 4:자유게시판, 5:관장님대화방, 6 : 시도지부 & 연맹 소식, 7 : FAQ
  iDivision = "7"

  Set Upload = Server.CreateObject("TABSUpload4.Upload")
  Upload.CodePage = 65001
  Upload.Start global_filepath_temp
  iType = fInject(Upload.Form("iType"))           ' 1:글쓰기, 2:수정
  iMSeq = fInject(Upload.Form("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)
  NowPage = fInject(Upload.Form("iNowPage"))      ' 현재페이지
  iSubType = fInject(Upload.Form("selSubType"))      ' 현재페이지
  
  Subject = fInject(Upload.Form("iSubject"))      ' 제목
  Contents = fInject(Upload.Form("iContents"))    ' 내용
	' 스마트에디터는 ' 문자만 변경이 안돼서 처리 해야 한다. HtmlSpecialChars 함수 사용 할 필요 없음.
	iContents = Replace(Contents,"'","&#039;")
  rFileCnt = Upload.Form("iFile").Count           ' 실첨부파일 갯수
  Set iFile = Upload.Form("iFile")                ' 실첨부파일,배열

  'JudoTitleWriteLine "MSeq", MSeq
  'JudoTitleWriteLine "Subject", Subject
	'JudoTitleWriteLine "iContents", iContents
	'JudoTitleWriteLine "rFileCnt", rFileCnt
  'Response.End
  
  If Err.Number = 0 Then
    Upload.Save global_filepath, False
    Dim LCnt
    LCnt = 0
    LSQL = "EXEC Community_Board_Mod_STR '" & iType & "','" & iDivision & "','" & Name & "','" & Subject & "','" & iContents & "','" & iLink & "','" & iSubType & "','"  & iTemp & "','" & ID & "','" & MSeq & "'"
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
  
    For i = 1 To CInt(rFileCnt) step 1
      If Upload.Form("iFile")(i) <> "" Then
        Dim iFileName
        iFileName = iFile(i).ShortSaveName
        '파일 TBL 에 Insert
        Dim LCnt1
        LCnt1 = 0
        LSQL = "EXEC Community_Board_Pds_Mod_STR '" & iType & "','" & iMSeq & "','" & iFileName & "','" & iLoginID & "'"
	      'response.Write "LSQL="&LSQL&"<br>"
        'response.End
        Set LRs = DBCon4.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
		      Do Until LRs.Eof
              LCnt1 = LCnt1 + 1
            LRs.MoveNext
		      Loop
	      End If
        LRs.close
      End If
    Next

		JudoKorea_DBClose()
    response.Write "<script type='text/javascript'>alert('글 등록이 잘 돼었습니다.');location.href='./FAQ_List.asp';</script>"
    response.End

  Else
		JudoKorea_DBClose()
    response.Write "<script type='text/javascript'>alert('글 등록에 오류가 있습니다.');location.href='./FAQ_List.asp';</script>"
    response.End
  End If

%>