<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/teamInfo_reg_proc.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 팀등록 처리
    '===================================================================================================================================

    Dim gRow, sRow, gSql, i, ry, intNum, Buff, Cnt 
    Dim PTeamIDX, PTeamGb, Team, TeamNm, TeamEnNm, Sex, sido, ZipCode, Address, AddrDtl, TeamTel, TeamFax, EnterType
    Dim ListPage, ViewPage, WritePage
    Dim RTN_ERROR

    ' 로그인 체크
    Check_AdminLogin()

    ListPage    = "/Main_HP/teamInfo_list.asp"
    ViewPage    = "/Main_HP/teamInfo_reg.asp"
    WritePage   = "/Main_HP/teamInfo_reg.asp"

    If Request.Form("NowPage") = "" Or IsNumeric(Trim(Request.Form("NowPage"))) = false Then NowPage = 1 Else NowPage = Cdbl(Request.Form("NowPage"))
    If Request.Form("KeyField1") = "" Then KeyField1 = "" Else KeyField1 = fInject(Trim(Request.Form("KeyField1")))
    If Request.Form("KeyField2") = "" Then KeyField2 = "" Else KeyField2 = fInject(Trim(Request.Form("KeyField2")))
    If Request.Form("KeyField3") = "" Then KeyField3 = "" Else KeyField3 = fInject(Trim(Request.Form("KeyField3")))
    If Request.Form("KeyField4") = "" Then KeyField4 = "" Else KeyField4 = fInject(Trim(Request.Form("KeyField4")))
    If Request.Form("KeyField5") = "" Then KeyField5 = "" Else KeyField5 = fInject(Trim(Request.Form("KeyField5")))
    If Request.Form("KeyWord") = "" Then KeyWord = "" Else KeyWord = Cstr(fInject(Replace(Trim(Request.Form("KeyWord")),"'","")))

    If Request.Form("pType") = "" Then ProcType = "W" Else ProcType = fInject(Trim(Request.Form("pType")))
    If Request.Form("idx") = "" Then PTeamIDX = 0 Else PTeamIDX = crypt.DecryptStringENC(fInject(Trim(Request.Form("idx"))))

    EnterType           = fInject(Trim(Request.Form("EnterType")))
    PTeamGb             = fInject(Trim(Request.Form("PTeamGb")))
    TeamNm              = fInject(Trim(Request.Form("TeamNm")))
    TeamEnNm            = fInject(Trim(Request.Form("TeamEnNm")))
    Sex                 = fInject(Trim(Request.Form("Sex")))
    sido                = fInject(Trim(Request.Form("Sido")))
    ZipCode             = fInject(Trim(Request.Form("ZipCode")))
    Address             = fInject(Trim(Request.Form("UserAddr")))
    AddrDtl             = fInject(Trim(Request.Form("UserAddrDtl")))
    TeamTel             = fInject(Trim(Request.Form("TeamTel1"))) &"-"& fInject(Trim(Request.Form("TeamTel2"))) &"-"& fInject(Trim(Request.Form("TeamTel3")))
    TeamFax             = fInject(Trim(Request.Form("TeamFax1"))) &"-"& fInject(Trim(Request.Form("TeamFax2"))) &"-"& fInject(Trim(Request.Form("TeamFax3")))

    IF ProcType = "W" THEN
        'Response.Write "EnterType = "& EnterType &"<br />"
        'Response.Write "PTeamGb = "& PTeamGb &"<br />"
        'Response.Write "TeamNm = "& TeamNm &"<br />"
        'Response.Write "TeamEnNm = "& TeamEnNm &"<br />"
        'Response.Write "Sex = "& Sex &"<br />"
        'Response.Write "sido = "& sido &"<br />"
        'Response.Write "ZipCode = "& ZipCode &"<br />"
        'Response.Write "Address = "& Address &"<br />"
        'Response.Write "AddrDtl = "& AddrDtl &"<br />"
        'Response.Write "TeamTel = "& TeamTel &"<br />"
        'Response.Write "TeamFax = "& TeamFax &"<br />"
        'Response.end
    Else
		'Response.Write "ProcType = "& ProcType &"<br />"
        'Response.Write "PTeamIDX = "& PTeamIDX &"<br />"
        'Response.Write "sido = "& sido &"<br />"
        'Response.Write "ZipCode = "& ZipCode &"<br />"
        'Response.Write "Address = "& Address &"<br />"
        'Response.Write "AddrDtl = "& AddrDtl &"<br />"
        'Response.Write "TeamTel = "& TeamTel &"<br />"
        'Response.Write "TeamFax = "& TeamFax &"<br />"
        'Response.end
    END IF 

    if TeamTel = "--" then TeamTel = ""
    if TeamFax = "--" then TeamFax = ""

    Select Case ProcType
        Case "W"
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "SP_ADM_TBLTEAMINFO_INSERT"

                .Parameters.Append .CreateParameter("@EnterType", adVarChar, adParamInput, 1, EnterType)
                .Parameters.Append .CreateParameter("@PTeamGb", adVarWChar, adParamInput, 50, PTeamGb)
                .Parameters.Append .CreateParameter("@TeamNm", adVarChar, adParamInput, 100, TeamNm)
                .Parameters.Append .CreateParameter("@TeamEnNm", adVarChar, adParamInput, 100, TeamEnNm)
                .Parameters.Append .CreateParameter("@Sex",adVarWChar, adParamInput, 20, Sex)
                .Parameters.Append .CreateParameter("@sido",adVarChar, adParamInput, 10, sido)
                .Parameters.Append .CreateParameter("@ZipCode",adVarChar, adParamInput, 10, ZipCode)
                .Parameters.Append .CreateParameter("@Address",adVarChar, adParamInput, 200, Address)
                .Parameters.Append .CreateParameter("@AddrDtl",adVarChar, adParamInput, 200, AddrDtl)
                .Parameters.Append .CreateParameter("@TeamTel",adVarChar, adParamInput, 20, TeamTel)
                .Parameters.Append .CreateParameter("@TeamFax",adVarChar, adParamInput, 20, TeamFax)
                .Parameters.Append .CreateParameter("@RTN_ERROR", adChar, adParamOutput, 1, "")

                .Execute, ,adExecuteNoRecords

                RTN_ERROR = .Parameters("@RTN_ERROR")

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With
            Call DbClose()

            If RTN_ERROR = "S" Then
                Response.Write "<script type='text/javascript'>alert('단체 등록이 잘 되었습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            ElseIf RTN_ERROR = "D" Then
                Response.Write "<script type='text/javascript'>alert('이미 등록된 단체입니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            Else
                Response.Write "<script type='text/javascript'>alert('단체 등록에 오류가 있습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            End If
        Case "M"
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "SP_ADM_TBLTEAMINFO_UPDATE"

                .Parameters.Append .CreateParameter("@PTeamIDX", adBigInt, adParamInput, 20, PTeamIDX)
                .Parameters.Append .CreateParameter("@sido",adVarChar, adParamInput, 10, sido)
                .Parameters.Append .CreateParameter("@ZipCode",adVarChar, adParamInput, 10, ZipCode)
                .Parameters.Append .CreateParameter("@Address",adVarChar, adParamInput, 200, Address)
                .Parameters.Append .CreateParameter("@AddrDtl",adVarChar, adParamInput, 200, AddrDtl)
                .Parameters.Append .CreateParameter("@TeamTel",adVarChar, adParamInput, 20, TeamTel)
                .Parameters.Append .CreateParameter("@TeamFax",adVarChar, adParamInput, 20, TeamFax)
                .Parameters.Append .CreateParameter("@RTN_ERROR", adChar, adParamOutput, 1, "")

                .Execute, ,adExecuteNoRecords

                RTN_ERROR = .Parameters("@RTN_ERROR")

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With
            Call DbClose()

            If RTN_ERROR = "S" Then
                Response.Write "<html><head><script type=""text/javascript"" src=""/dev/dist/Common_Js.js"" ></script><body>"
                Response.Write "<script type='text/javascript'>alert('단체 수정이 잘 되었습니다.');"
                Response.Write "post_to_url('"& ViewPage &"', {idx: '"& crypt.EncryptStringENC(PTeamIDX) &"', 'pType': 'M', 'NowPage': '"& NowPage &"', 'KeyField1': '"& KeyField1 &"', 'KeyField2': '"& KeyField2 &"', 'KeyField3': '"& KeyField3 &"', 'KeyField4': '"& KeyField4 &"', 'KeyField5': '"& KeyField5 &"', 'KeyWord': '"& KeyWord &"'});"
                Response.Write "</script></body></html>"
                Response.End
            Else
                Response.Write "<html><head><script type=""text/javascript"" src=""/dev/dist/Common_Js.js"" ></script><body>"
                Response.Write "<script type='text/javascript'>alert('단체 수정에 오류가 있습니다.');"
                Response.Write "post_to_url('"& ViewPage &"', {idx: '"& crypt.EncryptStringENC(PTeamIDX) &"', 'pType': 'M', 'NowPage': '"& NowPage &"', 'KeyField1': '"& KeyField1 &"', 'KeyField2': '"& KeyField2 &"', 'KeyField3': '"& KeyField3 &"', 'KeyField4': '"& KeyField4 &"', 'KeyField5': '"& KeyField5 &"', 'KeyWord': '"& KeyWord &"'});"
                Response.Write "</script></body></html>"
                Response.End
            End If
        Case "D"
            With objCmd
                .ActiveConnection = DBCon
                .CommandType  = adCmdStoredProc

                .CommandText  = "SP_ADM_TBLTEAMINFO_DELETE"

                .Parameters.Append .CreateParameter("@PTeamIDX", adBigInt, adParamInput, 20, PTeamIDX)
                .Parameters.Append .CreateParameter("@RTN_ERROR", adChar, adParamOutput, 1, "")

                .Execute, ,adExecuteNoRecords

                RTN_ERROR = .Parameters("@RTN_ERROR")

                For ry = .Parameters.Count - 1 to 0 Step -1
                    .Parameters.Delete(ry)
                Next
            End With
            Call DbClose()

            If RTN_ERROR = "S" Then
                Response.Write "<script type='text/javascript'>alert('단체 삭제가 잘 되었습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            Else
                Response.Write "<script type='text/javascript'>alert('단체 삭제시 오류가 있습니다.');location.replace('"& ListPage &"');</script>"
                Response.End
            End If
    End Select
    Call DbClose()
%>