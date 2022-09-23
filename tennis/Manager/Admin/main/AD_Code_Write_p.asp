<!--#include file="../dev/dist/config.asp"-->

<%

  Check_AdminLogin()

  	' 어드민관리메뉴 코드
	RoleType = "K001IGM"
%>

<!--#include file="CheckRole.asp"-->

<%

  Dim NowPage, Subject, Contents, Filecnt, iFilecnt, iDivision, iLink

  'iDivision = "0"
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
  
  iMSeq = fInject(Upload.Form("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)

  NowPage = fInject(Upload.Form("iNowPage"))      ' 현재페이지

	mSportsGb = fInject(Upload.Form("imSportsGb"))
  Code01 = fInject(Upload.Form("iCode01"))
	Code01Name = fInject(Upload.Form("iCode01Name"))
	OrderBy = fInject(Upload.Form("iOrderBy"))

  iCompanyRegNum = fInject(Upload.Form("iCompanyRegNum"))
  iCompanyAdd = fInject(Upload.Form("iCompanyAdd"))
	iCompanyPhone = fInject(Upload.Form("iCompanyPhone"))
	iManagerName = fInject(Upload.Form("iManagerName"))
  iManagerPhone = fInject(Upload.Form("iManagerPhone"))
  iManagerEmail = fInject(Upload.Form("iManagerEmail"))
	iWLSalesManager = fInject(Upload.Form("iWLSalesManager"))
  iBigo = fInject(Upload.Form("iBigo"))

  ''Contents = fInject(Upload.Form("iContents"))    ' 내용
  ' Contents = Upload.Form("iContents")    ' 내용
	'' 스마트에디터는 ' 문자만 변경이 안돼서 처리 해야 한다. HtmlSpecialChars 함수 사용 할 필요 없음.
	'iContents = Replace(Contents,"'","&#039;")
	'
  'SubType = fInject(Upload.Form("selSearch1"))  
	'NoticeYN = fInject(Upload.Form("selSearch2"))
	 
	Name = fInject(Upload.Form("iName"))            ' 로그인ID
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

    'Upload.Save global_filepath, False

    Dim LCnt
    LCnt = 0

		Code01Value = ""
		Code01Group = "IMGTYPE"
		Code01GroupName = "이미지그룹"
		
		iSportsGb = "tennis"

    LSQL = "EXEC AD_tblADCode_M '" & iType & "','" & MSeq & "','" & iSportsGb & "','" & mSportsGb & "','" & Code01 & "','" & Code01Name & "','" & Code01Value & "','" & Code01Group & "','" & Code01GroupName & "','','','','','','','','','','','','','','','','" & OrderBy & "','" & ID & "','" & iCompanyRegNum & "','" & iCompanyAdd & "','" & iCompanyPhone & "','" & iManagerName & "','" & iManagerPhone & "','" & iManagerEmail & "','" & iWLSalesManager & "','" & iBigo & "','','','','',''"
	  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon6.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

		  Do Until LRs.Eof
      
          LCnt = LCnt + 1
          iMSeq = LRs("MSeq")
					iCodeMod = LRs("CodeMod")

        LRs.MoveNext
		  Loop

	  End If

    LRs.close
  
    'For i = 1 To CInt(rFileCnt) step 1
		'
    '  If Upload.Form("iFile")(i) <> "" Then
		'
    '    Dim iFileName
    '    iFileName = iFile(i).ShortSaveName
    '    '파일 TBL 에 Insert
		'
    '    Dim LCnt1
    '    LCnt1 = 0
		'
    '    LSQL = "EXEC Community_Board_Pds_M '" & iType & "','" & iMSeq & "','" & iFileName & "','" & ID & "','" & iDivision & "','','','',''"
	  '    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    '    'response.End
  	'
    '    Set LRs = DBCon4.Execute(LSQL)
		'
    '    If Not (LRs.Eof Or LRs.Bof) Then
		'
		'      Do Until LRs.Eof
    '  
    '          LCnt1 = LCnt1 + 1
		'
    '        LRs.MoveNext
		'      Loop
		'
	  '    End If
		'
    '    LRs.close
		'
    '  End If
		'
    'Next

		AD_DBClose()

		if iCodeMod = "NOINS" then

			response.Write "<script type='text/javascript'>alert('이미 사용중인 코드 입니다.\n이미지 그룹 등록이 안 됐습니다.');location.href='./AD_Code_List.asp';</script>"
			response.End

		elseif iCodeMod = "NOMOD" then

			response.Write "<script type='text/javascript'>alert('배너 이미지에 코드가 사용 중입니다.\n코드를 제외 한 이미지 그룹 변경이 잘됐습니다.');location.href='./AD_Code_List.asp';</script>"
			response.End

		elseif iCodeMod = "YESMOD" then

			response.Write "<script type='text/javascript'>alert('이미지 그룹 변경이 잘 됐습니다.');location.href='./AD_Code_List.asp';</script>"
			response.End

		else
    
			response.Write "<script type='text/javascript'>alert('이미지 그룹 등록이 잘 됐습니다.');location.href='./AD_Code_List.asp';</script>"
			response.End

		end if

  Else
  
		AD_DBClose()

    response.Write "<script type='text/javascript'>alert('이미지 그룹 등록에 오류가 있습니다.');location.href='./AD_Code_List.asp';</script>"
    response.End
  
  End If

%>