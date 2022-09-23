<!--#include file="../dev/dist/config.asp"-->
<!--#include virtual = "/dev/dist/common_xFso.asp"-->
<!--#include virtual = "/dev/dist/common_xTabsFileUp.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
	'===================================================================================================================================
    'PAGE : /Main_HP/settlement_proc.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 결산 처리
    '===================================================================================================================================
    Dim gRow, gSQL, sRow, i, ry, intNum, Buff, Cnt 
    Dim ArrayDel, ArrayDelCnt
    Dim MSeq, Division, SubType, SubTypeName, CodeColor, Name, Subject, Contents, N_Year, FileYN, NoticeYN, TeamGb, TeamGbNm
    Dim ReplyYN, Link, LinkExt, FileCnt, ViewCnt, InsDate, LoginIDYN, InsID, Del_ImgProfile
    Dim PSeq, FileName, FilePath, FileExt
    Dim ListPage, ViewPage, WritePage
    Dim iLoginID
    Dim xUpPath, yUpPrevPK, yUpOObject

    ' 로그인 체크
    Check_AdminLogin()

    iDivision = "10"                             ' 현재 페이지 구분값

    ListPage    = "/Main_HP/settlement_list.asp"
    ViewPage    = "/Main_HP/settlement_write.asp"
    WritePage   = "/Main_HP/settlement_write.asp"

    ' 로그인 아이디, 이름
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)
    Name = fInject(Request.cookies("UserName"))

    ' 업로드 사이즈 제한(MB)
    xUpLimitSize    = 10                    ' 기본 세팅 사이즈 제한값보다 큰값이 업로드 될경우 404 에러 발생.
    xUpPath         = global_filepath

    ' 업로드 객체 생성
    Call xUpTabsInstCreate(xUpPath, xUpLimitSize)

    If xTabsInst.Form("NowPage") = "" Or IsNumeric(Trim(xTabsInst.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(xTabsInst.Form("NowPage"))
    If xTabsInst.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(xTabsInst.Form("KeyField1")))
    If xTabsInst.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(xTabsInst.Form("KeyWord")),"'","")))

    If xTabsInst.Form("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(xTabsInst.Form("pType")))
    If xTabsInst.Form("idx") = "" Then MSeq = 0 Else MSeq = crypt.DecryptStringENC(fInject(Trim(xTabsInst.Form("idx"))))

    SubType             = ""
    NoticeYN            = "N"
    Del_ImgProfile      = fInject(Trim(xTabsInst.Form("Del_ImgProfile")))
    Subject             = fInject(Trim(xTabsInst.Form("Subject")))
    yUpPrevPK           = fInject(Trim(xTabsInst.Form("yUpPrevPK")))
    yUpOObject          = fInject(Trim(xTabsInst.Form("yUpOObject")))
    Contents            = ""

    'Response.Write "iLoginID: "& iLoginID &"<br />"
    'Response.Write "Name: "& Name &"<br />"
    'Response.Write "ProcType: "& ProcType &"<br />"
    'Response.Write "MSeq: "& MSeq &"<br />"
    'Response.Write "SubType: "& SubType &"<br />"
    'Response.Write "NoticeYN: "& NoticeYN &"<br />"
    'Response.Write "Del_ImgProfile: "& Del_ImgProfile &"<br />"
    'Response.Write "Subject: "& Subject &"<br />"
    'Response.Write "yUpPrevPK: "& yUpPrevPK &"<br />"
    'Response.Write "yUpOObject: "& yUpOObject &"<br />"
    'Response.Write "Contents: "& Contents &"<br />"
    'Response.End

    '첨부파일 업로드
    Call xUpTabsUpload(xUpPath, xTabsInst.Form("yUpStateFlag"), xTabsInst.Form("yUpPrevPK"), xTabsInst.Form("yUpRObject"), xTabsInst.Form("xUpRObject"), xUpLimitSize, xTabsInst.Form("xUpCondition"), "N", ListPage)

    'Response.Write "xUpPath: "& xUpPath &"<br />"
    'Response.Write "yUpStateFlag: "& xTabsInst.Form("yUpStateFlag") &"<br />"
    'Response.Write "yUpPrevPK: "& xTabsInst.Form("yUpPrevPK") &"<br />"
    'Response.Write "yUpRObject: "& xTabsInst.Form("yUpRObject") &"<br />"
    'Response.Write "xUpCondition: "& xTabsInst.Form("xUpCondition") &"<br /><br />"
    'Response.Write "xSaveFileDBPK: "& xSaveFileDBPK &"<br />"
    'Response.Write "xSaveFileDBAction: "& xSaveFileDBAction &"<br />"
    'Response.Write "xSaveFileONameStr: "& xSaveFileONameStr &"<br />"
    'Response.Write "xSaveFileNNameStr: "& xSaveFileNNameStr &"<br />"
    'Response.Write "xSaveFileSizeStr: "& xSaveFileSizeStr &"<br />"
    'Response.End

    ' 업로드 객체 제거
    Call xUpTabsInstDelete()

    Select Case ProcType
        Case "W"
            iType = "1"             ' 1:글쓰기, 2:수정
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "Community_Board_M"

                .Parameters.Append .CreateParameter("@iType", adInteger, adParamInput, 4, iType)
                .Parameters.Append .CreateParameter("@iColumnistIDX", adLongVarChar, adParamInput, 1073741823, "")
                .Parameters.Append .CreateParameter("@Division",adVarChar, adParamInput, 2, iDivision)
                .Parameters.Append .CreateParameter("@Name",adVarWChar, adParamInput, 50, Name)
                .Parameters.Append .CreateParameter("@Subject",adVarWChar, adParamInput, 1000, Subject)
                .Parameters.Append .CreateParameter("@Contents",adLongVarWChar, adParamInput, 1073741823, Contents)
                .Parameters.Append .CreateParameter("@Link",adLongVarWChar, adParamInput, 1073741823, "")
                .Parameters.Append .CreateParameter("@SubType",adVarChar, adParamInput, 10, SubType)
                .Parameters.Append .CreateParameter("@NoticeYN",adVarChar, adParamInput, 2, NoticeYN)
                .Parameters.Append .CreateParameter("@N_Year",adVarChar, adParamInput, 5, "")
                .Parameters.Append .CreateParameter("@Temp",adVarChar, adParamInput, 1, "")
                .Parameters.Append .CreateParameter("@Id",adVarChar, adParamInput, 30, iLoginID)
                .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)
                .Parameters.Append .CreateParameter("@TeamGb",adVarChar, adParamInput, 30, "")
                .Parameters.Append .CreateParameter("@FileExt",adVarChar, adParamInput, 6, "")
                .Parameters.Append .CreateParameter("@Temp1",adChar, adParamInput, 10, "")
                .Parameters.Append .CreateParameter("@Temp2",adChar, adParamInput, 5, "")
                .Parameters.Append .CreateParameter("@Temp3",adVarwChar, adParamInput, 30, "")
                .Parameters.Append .CreateParameter("@Temp4",adInteger, adParamInput, 1, 0)
                .Parameters.Append .CreateParameter("@Temp5",adVarChar, adParamInput, 1, "")

                Set gRow = .Execute

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With

            If gRow.eof Or gRow.bof Then
                MSeq = 0
            Else
                MSeq = Cdbl(gRow(0))
            End If
            Set gRow = Nothing
            
            ArrayResPK  = StrSplit(xSaveFileDBPK, "**")
            ArrayResAct = StrSplit(xSaveFileDBAction, "**")
            ArrayResON  = StrSplit(xSaveFileONameStr, "**")
            ArrayResNN  = StrSplit(xSaveFileNNameStr, "**")
            ArrayResSZ  = StrSplit(xSaveFileSizeStr, "**")
            ArrayResPK_Cnt = Ubound(ArrayResPK,1)
            
            For i = 0 to ArrayResPK_Cnt - 1
                ACT = Trim(ArrayResAct(i))
                IF ArrayResPK(i) = "" OR ISNULL(ArrayResPK(i)) = TRUE THEN CLP_IDX = 0 ELSE CLP_IDX = Trim(ArrayResPK(i))
                PRT_IDX = MSeq
                CLP_CLIPNAME_ORG = Trim(ArrayResON(i))
                CLP_CLIPNAME_CHG = Trim(ArrayResNN(i))
                CLP_CLIPSIZE = CDbl(ArrayResSZ(i))

                'Response.Write "CLP_IDX: "& CLP_IDX &"<br />"
                'Response.Write "PRT_IDX: "& PRT_IDX &"<br />"
                'Response.Write "CLP_CLIPNAME_ORG: "& CLP_CLIPNAME_ORG &"<br />"
                'Response.Write "CLP_CLIPNAME_CHG: "& CLP_CLIPNAME_CHG &"<br />"
                'Response.Write "CLP_CLIPSIZE: "& CLP_CLIPSIZE &"<br />"

                With objCmd
                    .ActiveConnection = DBCon
                    .CommandType  = adCmdStoredProc
                    .CommandText  = "Community_Board_Pds_M"
                    
                    .Parameters.Append .CreateParameter("@iType", adInteger, adParamInput, 4, 1)
                    .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)
                    .Parameters.Append .CreateParameter("@FileName", adLongVarWChar, adParamInput, 1073741823, CLP_CLIPNAME_CHG)
                    .Parameters.Append .CreateParameter("@ID",adVarChar, adParamInput, 30, iLoginID)
                    .Parameters.Append .CreateParameter("@Division",adVarChar, adParamInput, 2, iDivision)
                    .Parameters.Append .CreateParameter("@Temp2", adVarWChar, adParamInput, 200, CLP_CLIPNAME_ORG)
                    .Parameters.Append .CreateParameter("@Temp3",adVarChar, adParamInput, 1, "")
                    .Parameters.Append .CreateParameter("@Temp4",adVarChar, adParamInput, 1, "")
                    .Parameters.Append .CreateParameter("@Temp5",adVarChar, adParamInput, 1, "")

                    .Execute, ,adExecuteNoRecords

                    For ry = .Parameters.Count - 1 to 0 Step -1
                        .Parameters.Delete(ry)
                    Next
                End With
            Next

            Call DbClose()
            If Err.Number = 0 Then
                Response.Write "<script type='text/javascript'>alert('글 등록이 잘 되었습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            Else
                Response.Write "<script type='text/javascript'>alert('글 등록에 오류가 있습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            End If
        Case "M"
            iType = "2"             ' 1:글쓰기, 2:수정
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "Community_Board_M"

                .Parameters.Append .CreateParameter("@iType", adInteger, adParamInput, 4, iType)
                .Parameters.Append .CreateParameter("@iColumnistIDX", adLongVarChar, adParamInput, 1073741823, "")
                .Parameters.Append .CreateParameter("@Division",adVarChar, adParamInput, 2, iDivision)
                .Parameters.Append .CreateParameter("@Name",adVarWChar, adParamInput, 50, Name)
                .Parameters.Append .CreateParameter("@Subject",adVarWChar, adParamInput, 1000, Subject)
                .Parameters.Append .CreateParameter("@Contents",adLongVarWChar, adParamInput, 1073741823, Contents)
                .Parameters.Append .CreateParameter("@Link",adLongVarWChar, adParamInput, 1073741823, "")
                .Parameters.Append .CreateParameter("@SubType",adVarChar, adParamInput, 10, SubType)
                .Parameters.Append .CreateParameter("@NoticeYN",adVarChar, adParamInput, 2, NoticeYN)
                .Parameters.Append .CreateParameter("@N_Year",adVarChar, adParamInput, 5, "")
                .Parameters.Append .CreateParameter("@Temp",adVarChar, adParamInput, 1, "")
                .Parameters.Append .CreateParameter("@Id",adVarChar, adParamInput, 30, iLoginID)
                .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)
                .Parameters.Append .CreateParameter("@TeamGb",adVarChar, adParamInput, 30, "")
                .Parameters.Append .CreateParameter("@FileExt",adVarChar, adParamInput, 6, "")
                .Parameters.Append .CreateParameter("@Temp1",adChar, adParamInput, 10, "")
                .Parameters.Append .CreateParameter("@Temp2",adChar, adParamInput, 5, "")
                .Parameters.Append .CreateParameter("@Temp3",adVarwChar, adParamInput, 30, "")
                .Parameters.Append .CreateParameter("@Temp4",adInteger, adParamInput, 1, 0)
                .Parameters.Append .CreateParameter("@Temp5",adVarChar, adParamInput, 1, "")

                .Execute, ,adExecuteNoRecords

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With
            
            If Del_ImgProfile = "Y" Then
                gSQL = "UPDATE Community_Board_Tbl SET FileYN = 'N' WHERE DelYN = 'N' AND MSeq = ?"
                With objCmd
                    .ActiveConnection = DBCon
                    .CommandType  = adCmdText
                    .CommandText  = gSQL
                    
                    .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)

                    .Execute, ,adExecuteNoRecords

                    For ry = .Parameters.Count - 1 to 0 Step -1
                        .Parameters.Delete(ry)
                    Next
                End With

                gSQL = "UPDATE Community_Board_Pds_Tbl SET DelYN = 'Y' WHERE PSeq = ?"
                With objCmd
                    .ActiveConnection = DBCon
                    .CommandType  = adCmdText
                    .CommandText  = gSQL
                    
                    .Parameters.Append .CreateParameter("@PSeq", adBigInt, adParamInput, 20, yUpPrevPK)

                    .Execute, ,adExecuteNoRecords

                    For ry = .Parameters.Count - 1 to 0 Step -1
                        .Parameters.Delete(ry)
                    Next
                End With
                
                Call OpenFso()
                If xFsoSrFile(xUpPath, yUpOObject) Then
                    Call xUpTabsDelete(xUpPath, yUpOObject)
                End If
                Call CloseFso()
            End If

            ArrayResPK  = StrSplit(xSaveFileDBPK, "**")
            ArrayResAct = StrSplit(xSaveFileDBAction, "**")
            ArrayResON  = StrSplit(xSaveFileONameStr, "**")
            ArrayResNN  = StrSplit(xSaveFileNNameStr, "**")
            ArrayResSZ  = StrSplit(xSaveFileSizeStr, "**")
            ArrayResPK_Cnt = Ubound(ArrayResPK,1)
            
            For i = 0 to ArrayResPK_Cnt - 1
                ACT = Trim(ArrayResAct(i))
                IF ArrayResPK(i) = "" OR ISNULL(ArrayResPK(i)) = TRUE THEN CLP_IDX = 0 ELSE CLP_IDX = Trim(ArrayResPK(i))
                PRT_IDX = MSeq
                CLP_CLIPNAME_ORG = Trim(ArrayResON(i))
                CLP_CLIPNAME_CHG = Trim(ArrayResNN(i))
                CLP_CLIPSIZE = CDbl(ArrayResSZ(i))

                'Response.Write "CLP_IDX: "& CLP_IDX &"<br />"
                'Response.Write "PRT_IDX: "& PRT_IDX &"<br />"
                'Response.Write "CLP_CLIPNAME_ORG: "& CLP_CLIPNAME_ORG &"<br />"
                'Response.Write "CLP_CLIPNAME_CHG: "& CLP_CLIPNAME_CHG &"<br />"
                'Response.Write "CLP_CLIPSIZE: "& CLP_CLIPSIZE &"<br />"

                With objCmd
                    .ActiveConnection = DBCon
                    .CommandType  = adCmdStoredProc
                    .CommandText  = "Community_Board_Pds_M"
                    
                    .Parameters.Append .CreateParameter("@iType", adInteger, adParamInput, 4, 1)
                    .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)
                    .Parameters.Append .CreateParameter("@FileName", adLongVarWChar, adParamInput, 1073741823, CLP_CLIPNAME_CHG)
                    .Parameters.Append .CreateParameter("@ID",adVarChar, adParamInput, 30, iLoginID)
                    .Parameters.Append .CreateParameter("@Division",adVarChar, adParamInput, 2, iDivision)
                    .Parameters.Append .CreateParameter("@Temp2", adVarWChar, adParamInput, 200, CLP_CLIPNAME_ORG)
                    .Parameters.Append .CreateParameter("@Temp3",adVarChar, adParamInput, 1, "")
                    .Parameters.Append .CreateParameter("@Temp4",adVarChar, adParamInput, 1, "")
                    .Parameters.Append .CreateParameter("@Temp5",adVarChar, adParamInput, 1, "")

                    .Execute, ,adExecuteNoRecords

                    For ry = .Parameters.Count - 1 to 0 Step -1
                        .Parameters.Delete(ry)
                    Next
                End With
            Next

            Call DbClose()
            If Err.Number = 0 Then
                Response.Write "<html><head><script type=""text/javascript"" src=""/dev/dist/Common_Js.js"" ></script><body>"
                Response.Write "<script type='text/javascript'>alert('글 수정이 잘 되었습니다.');"
                Response.Write "post_to_url('"& ViewPage &"', {idx: '"& crypt.EncryptStringENC(MSeq) &"', 'pType': 'M', 'NowPage': '"& NowPage &"', 'KeyField1': '"& KeyField1 &"', 'KeyField2': '"& KeyField2 &"', 'KeyField3': '"& KeyField3 &"', 'KeyWord': '"& KeyWord &"'});"
                Response.Write "</script></body></html>"
                Response.End
            Else
                Response.Write "<html><head><script type=""text/javascript"" src=""/dev/dist/Common_Js.js"" ></script><body></body></html>"
                Response.Write "<script type='text/javascript'>alert('글 수정에 오류가 있습니다.');"
                Response.Write "post_to_url('"& ViewPage &"', {idx: '"& crypt.EncryptStringENC(MSeq) &"', 'pType': 'M', 'NowPage': '"& NowPage &"', 'KeyField1': '"& KeyField1 &"', 'KeyField2': '"& KeyField2 &"', 'KeyField3': '"& KeyField3 &"', 'KeyWord': '"& KeyWord &"'});"
                Response.Write "</script>"
                Response.End
            End If
        Case "D"
            iType = "1"
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "Community_Board_D"

                .Parameters.Append .CreateParameter("@iType", adInteger, adParamInput, 4, iType)
                .Parameters.Append .CreateParameter("@MSeq", adBigInt, adParamInput, 20, MSeq)

                Set gRow = .Execute

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With

            If gRow.bof = true Then
				ArrayDel = Null
			Else
				ArrayDel = gRow.getRows
				ArrayDelCnt = UBound(ArrayDel,2)
			End If

			If IsNull(ArrayDel) = false Then
				For i = 0 To ArrayDelCnt
					Call xUpTabsDelete(xUpPath, Trim(ArrayDel(0,i)))
				Next
			End If
            Set gRow = Nothing
            Call DbClose()
            
            If Err.Number = 0 Then
                Response.Write "<script type='text/javascript'>alert('글 삭제가 잘 되었습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            Else
                Response.Write "<script type='text/javascript'>alert('글 삭제시 오류가 있습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            End If
    End Select

    Call DbClose()
%>