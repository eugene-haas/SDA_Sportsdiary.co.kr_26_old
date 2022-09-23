<!--#include file="../dev/dist/config.asp"-->

<%
  Dim NowPage, Subject, Contents, Filecnt, iFilecnt, iDivision, iLink

  'iDivision = "2"

	iLink = "" ' 동영상링크등 링크주소

  'iLink = fInject(Request("iLink"))  ' 동영상링크등 링크주소
  
  'iType = fInject(Request("iType"))           ' 1:글쓰기, 2:수정
  
  'iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  'MSeq = decode(iMSeq,0)

  'NowPage = fInject(Request("iNowPage"))      ' 현재페이지
  'Subject = fInject(Request("iSubject"))      ' 제목

  'Contents = fInject(Request("iContents"))
  'iContents = HtmlSpecialChars(Contents)

  'Name = fInject(Request("iName"))            ' 로그인유저
  'ID = fInject(Request("iID"))                ' 로그인ID


  Set Upload = Server.CreateObject("TABSUpload4.Upload")

  Upload.CodePage = 65001
  Upload.Start global_filepath_temp

  iType = fInject(Upload.Form("iType"))           ' 1:글쓰기, 2:수정

	iDivision = fInject(Upload.Form("iDivision")) 
  
  iMSeq = fInject(Upload.Form("iMSeq"))           ' 수정시 글번호
  'MSeq = decode(iMSeq,0)
	MSeq = crypt.DecryptStringENC(iMSeq)

  NowPage = fInject(Upload.Form("iNowPage"))      ' 현재페이지
  Subject = fInject(Upload.Form("iSubject"))      ' 제목
	Subject = HtmlSpecialChars(Subject)

  Contents = fInject(Upload.Form("iContents"))    ' 내용
	' 스마트에디터는 ' 문자만 변경이 안돼서 처리 해야 한다. HtmlSpecialChars 함수 사용 할 필요 없음.
	iContents = Replace(Contents,"'","&#039;")

  SubType = fInject(Upload.Form("selSearch1"))  
	NoticeYN = fInject(Upload.Form("selSearch2"))

	StartDate = fInject(Upload.Form("iStartDate"))
	EndDate = fInject(Upload.Form("iEndDate"))
	iLH = fInject(Upload.Form("iLH"))
	iDB = fInject(Upload.Form("iDB"))
	 
	Name = fInject(Upload.Form("iName"))                ' 로그인ID
  ID = fInject(Upload.Form("iID"))                ' 로그인ID
  FileCnt = fInject(Upload.Form("iFilecnt"))      ' 열린첨부파일항목갯수
  rFileCnt = Upload.Form("iFile").Count           ' 실첨부파일 갯수
  Set iFile = Upload.Form("iFile")                ' 실첨부파일,배열

  'execute를 사용하여 유동적으로 변수를 만듦, 파일쪽에 set 을 붙여야 ShortSaveName 을 사용 할 수 있음. 테스트로 놔둠. 사용안함.
  'For i = 1 to CInt(Filecnt) step 1
  '  execute("Dim File_"&i&"")
  '  'execute("File_"&i&" = fInject(Upload.Form(""iFile_"&i&"""))")
  '  execute("Set File_"&i&" = Upload.Form(""iFile_"&i&""")")
  'Next
  
  If Err.Number = 0 Then

    Upload.Save global_filepath, False

    Dim LCnt
    LCnt = 0

		N_Year = ""
		Temp = ""
		ColumnistIDX = ""
		TeamGb = ""
		FileExt = ""

    LSQL = "EXEC Community_Board_M1 '" & iType & "','" & ColumnistIDX & "','" & iDivision & "','" & Name & "','" & Subject & "','" & iContents & "','" & iLink & "','" & SubType & "','" & NoticeYN & "','" & N_Year & "','" & Temp & "','" & ID & "','" & MSeq & "','" & TeamGb & "','" & FileExt & "','" & StartDate & "','" & EndDate & "','" & iLH & "','" & iDB & "','','','','',''"
	  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon.Execute(LSQL)

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
		
        LSQL = "EXEC Community_Board_Pds_M '" & iType & "','" & iMSeq & "','" & iFileName & "','" & ID & "','" & iDivision & "','','','',''"
	      'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'response.End
  	
        Set LRs = DBCon.Execute(LSQL)
		
        If Not (LRs.Eof Or LRs.Bof) Then
		
		      Do Until LRs.Eof
      
              LCnt1 = LCnt1 + 1
		
            LRs.MoveNext
		      Loop
		
	      End If
		
        LRs.close
		
      End If
		
    Next

		DBClose()
    
    response.Write "<script type='text/javascript'>alert('글 등록이 잘 되었습니다.');location.href='./Main_MiddleBanner_List.asp';</script>"
    response.End

  Else
  
		DBClose()

    response.Write "<script type='text/javascript'>alert('글 등록에 오류가 있습니다.');location.href='./Main_MiddleBanner_List.asp';</script>"
    response.End
  
  End If

%>