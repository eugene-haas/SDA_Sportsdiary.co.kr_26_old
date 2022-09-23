<!--#include file="../dev/dist/config.asp"-->
<!--#include virtual = "/dev/dist/common_xFso.asp"-->
<!--#include virtual = "/dev/dist/common_xTabsFileUp.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
	'===================================================================================================================================
    'PAGE : /Main_HP/association_relay_proc.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 중계일정 처리
    '===================================================================================================================================
    Dim gRow, gSQL, sRow, i, ry, intNum, Buff, Cnt 
    Dim ArrayDel, ArrayDelCnt
    Dim MSeq, Division, SubType, SubTypeName, CodeColor, Name, Subject, Contents, N_Year, FileYN, NoticeYN, TeamGb, TeamGbNm
    Dim ReplyYN, Link, LinkExt, FileCnt, ViewCnt, InsDate, LoginIDYN, InsID, Del_ImgProfile
    Dim GameTitleIdx
    Dim ListPage, ViewPage, WritePage
    Dim iLoginID
    Dim xUpPath, yUpPrevPK, yUpOObject

    ' 로그인 체크
    Check_AdminLogin()

    iDivision = "8"                             ' 현재 페이지 구분값

    ListPage    = "/Main_HP/association_relay_list.asp"
    ViewPage    = "/Main_HP/association_relay_write.asp"
    WritePage   = "/Main_HP/association_relay_write.asp"

    ' 로그인 아이디, 이름
    iLoginID = decode(fInject(Request.cookies("UserID")), 0)
    Name = fInject(Request.cookies("UserName"))

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(Request.Form("KeyWord")),"'","")))

    If Request.Form("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(Request.Form("pType")))
    If Request.Form("idx") = "" Then MSeq = 0 Else MSeq = crypt.DecryptStringENC(fInject(Trim(Request.Form("idx"))))

    If Request.Form("GameTitleIdx") = "" Or IsNumeric(Trim(Request.Form("GameTitleIdx"))) = false Then GameTitleIdx = 0 Else GameTitleIdx = Cdbl(Request.Form("GameTitleIdx"))

    SubType             = ""
    NoticeYN            = fInject(Trim(Request.Form("NoticeYN")))
    Subject             = fInject(Trim(Request.Form("Subject")))
    relayDate           = fInject(Trim(Request.Form("relayDate")))
    relayTime           = fInject(Trim(Request.Form("relayTimeHH"))) &":"& fInject(Trim(Request.Form("relayTimeMM")))
    relayChannel        = fInject(Trim(Request.Form("relayChannel")))

    ' 스마트에디터는 ' 문자만 변경이 안돼서 처리 해야 한다. HtmlSpecialChars 함수 사용 할 필요 없음.
    Contents            = Replace(fInject(Trim(Request.Form("iContents"))), "'", "&#039;")

    If NoticeYN = "" Then NoticeYN = "N"

    If GameTitleIdx = 0 Then
        Call DBClose()
        Response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.replace('/');</script>"
        Response.End
    End If

    Response.Write "iLoginID: "& iLoginID &"<br />"
    Response.Write "Name: "& Name &"<br />"
    Response.Write "ProcType: "& ProcType &"<br />"
    Response.Write "MSeq: "& MSeq &"<br />"
    Response.Write "SubType: "& SubType &"<br />"
    Response.Write "NoticeYN: "& NoticeYN &"<br />"
    Response.Write "Subject: "& Subject &"<br />"
    Response.Write "relayDate: "& relayDate &"<br />"
    Response.Write "relayTime: "& relayTime &"<br />"
    Response.Write "relayChannel: "& relayChannel &"<br />"
    Response.Write "GameTitleIdx: "& GameTitleIdx &"<br />"
    Response.Write "Contents: "& Contents &"<br />"
    'Response.End

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
                .Parameters.Append .CreateParameter("@Temp1",adChar, adParamInput, 10, relayDate)
                .Parameters.Append .CreateParameter("@Temp2",adChar, adParamInput, 5, relayTime)
                .Parameters.Append .CreateParameter("@Temp3",adVarwChar, adParamInput, 30, relayChannel)
                .Parameters.Append .CreateParameter("@Temp4",adInteger, adParamInput, 1, GameTitleIdx)
                .Parameters.Append .CreateParameter("@Temp5",adVarChar, adParamInput, 1, "")

                .Execute, ,adExecuteNoRecords

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With
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
                .Parameters.Append .CreateParameter("@Temp1",adChar, adParamInput, 10, relayDate)
                .Parameters.Append .CreateParameter("@Temp2",adChar, adParamInput, 5, relayTime)
                .Parameters.Append .CreateParameter("@Temp3",adVarwChar, adParamInput, 30, relayChannel)
                .Parameters.Append .CreateParameter("@Temp4",adInteger, adParamInput, 1, GameTitleIdx)
                .Parameters.Append .CreateParameter("@Temp5",adVarChar, adParamInput, 1, "")

                .Execute, ,adExecuteNoRecords

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With
            Call DbClose()

            If Err.Number = 0 Then
                Response.Write "<html><head><script type=""text/javascript"" src=""/dev/dist/Common_Js.js"" ></script><body>"
                Response.Write "<script type='text/javascript'>alert('글 수정이 잘 되었습니다.');"
                Response.Write "post_to_url('"& ViewPage &"', {idx: '"& crypt.EncryptStringENC(MSeq) &"', 'pType': 'M', 'NowPage': '"& NowPage &"', 'KeyField1': '"& KeyField1 &"', 'KeyField2': '"& KeyField2 &"', 'KeyWord': '"& KeyWord &"'});"
                Response.Write "</script></body></html>"
                Response.End
            Else
                Response.Write "<html><head><script type=""text/javascript"" src=""/dev/dist/Common_Js.js"" ></script><body></body></html>"
                Response.Write "<script type='text/javascript'>alert('글 수정에 오류가 있습니다.');"
                Response.Write "post_to_url('"& ViewPage &"', {idx: '"& crypt.EncryptStringENC(MSeq) &"', 'pType': 'M', 'NowPage': '"& NowPage &"', 'KeyField1': '"& KeyField1 &"', 'KeyField2': '"& KeyField2 &"', 'KeyWord': '"& KeyWord &"'});"
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

                .Execute, ,adExecuteNoRecords

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With
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