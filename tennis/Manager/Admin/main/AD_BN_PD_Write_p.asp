<!--#include file="../dev/dist/config.asp"-->

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

	iCateLocate1 = fInject(Upload.Form("iCateLocate1"))
	iCateLocate2 = fInject(Upload.Form("iCateLocate2"))
	iCateLocate3 = fInject(Upload.Form("iCateLocate3"))
	iCateLocate4 = fInject(Upload.Form("iCateLocate4"))

	iDateProdS = fInject(Upload.Form("iDateProdS"))
	iDateProdE = fInject(Upload.Form("iDateProdE"))

  ehdimgselno = fInject(Upload.Form("hdimgselno"))
	dhdimgselno = decode(ehdimgselno,0)

	iTitle = fInject(Upload.Form("iTitle"))
	itxtMemo = fInject(Upload.Form("itxtMemo"))
	iLink = fInject(Upload.Form("iLK"))
  iLKType = fInject(Upload.Form("iLKType"))

	iProductKeyCode = fInject(Upload.Form("iProductKeyCode"))
	iProductNm = fInject(Upload.Form("iProductNm"))
	iTypeDiscount = fInject(Upload.Form("iTypeDiscount"))
	iDiscountValue = fInject(Upload.Form("iDiscountValue"))
	itxtWorker = fInject(Upload.Form("itxtWorker"))
	iViewYN = fInject(Upload.Form("iViewYN"))


  iPeriodType = fInject(Upload.Form("iPeriodType"))
	iPayment = fInject(Upload.Form("iPayment"))
	iTimeProdS = fInject(Upload.Form("iTimeProdS"))
  iTimeProdE = fInject(Upload.Form("iTimeProdE"))


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
		
		iSportsGb = "tennis"

    LSQL = "EXEC AD_tblADProductLocate_M '" & iType & "','" & MSeq & "','" & iSportsGb & "','" & iCateLocate1 & "','" & iCateLocate2 & "','" & iCateLocate3 & "','" & iCateLocate4 & "','" & iDateProdS & "','" & iDateProdE & "','" & dhdimgselno & "','" & iTitle & "','" & itxtMemo & "','" & iLink & "','" & iProductKeyCode & "','" & iProductNm & "','" & iTypeDiscount & "','" & iDiscountValue & "','" & itxtWorker & "','" & iViewYN & "','" & ID & "','" & iLKType & "','" & iPeriodType & "','" & iPayment & "','" & iTimeProdS & "','" & iTimeProdE & "','','','','',''"
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
    '    Set LRs = DBCon6.Execute(LSQL)
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

		if iCodeMod = "YESINS" then

			response.Write "<script type='text/javascript'>alert('광고 연결이 잘 돼었습니다.');location.href='./AD_BN_PD_List.asp';</script>"
			response.End

		elseif iCodeMod = "YESMOD" then

			response.Write "<script type='text/javascript'>alert('광고 연결 수정이 잘 돼었습니다.');location.href='./AD_BN_PD_List.asp';</script>"
			response.End

		end if

  Else
  
		AD_DBClose()

    response.Write "<script type='text/javascript'>alert('이미지 그룹 등록에 오류가 있습니다.');location.href='./AD_BN_PD_List.asp';</script>"
    response.End
  
  End If

%>