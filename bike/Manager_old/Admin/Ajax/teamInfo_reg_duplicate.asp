<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /ajax/teamInfo_reg_duplicate.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 팀등록 중복체크
    '===================================================================================================================================

    Dim gRow, sRow, gSql, i, ry, intNum, Buff, Cnt 
    Dim ProcType
    Dim TeamNm, Sex, EnterType
    Dim TeamCnt, RTN_ERROR

    ' 로그인 체크
    Check_AdminLogin()

    ProcType    = fInject(Trim(Request.Form("pType")))
    TeamNm      = fInject(Trim(Request.Form("TeamNm")))
    Sex         = fInject(Trim(Request.Form("TeamSex")))
	EnterType	= fInject(Trim(Request.Form("tEType")))

    if TeamNm = "" or Sex = "" Or EnterType = "" Or ProcType = "" then
        Call DbClose()
        Response.Write "E"
        Response.End
    end if 

	'Response.Write "ProcType: "& ProcType &", EnterType: "& EnterType &", Sex: "& Sex &", TeamNm: "& TeamNm
	'Response.End

    gSql = "SELECT COUNT(*) "
    gSql = gSql &"from tblTeamInfo WITH(NOLOCK) "
    gSql = gSql &"WHERE DelYN = 'N' AND EnterType = ? AND Sex=? "
    gSql = gSql &"AND Replace(Replace(Replace(TeamNm, CHAR(13),''), CHAR(10),''), ' ', '') = ?"

    With objCmd
        .ActiveConnection = DBCon
        .CommandType  = adCmdText

        .CommandText  = gSql
		
		.Parameters.Append .CreateParameter("@EnterType",adVarChar, adParamInput, 1, EnterType)
        .Parameters.Append .CreateParameter("@Sex",adVarWChar, adParamInput, 20, Sex)
        .Parameters.Append .CreateParameter("@TeamNm",adVarChar, adParamInput, 100, TeamNm)

        Set gRow = .Execute

        For ry = .Parameters.Count - 1 to 0 Step -1
            .Parameters.Delete(ry)
        Next
    End With

    If gRow.eof Or gRow.bof Then
        RTN_ERROR = "E"
    Else
        TeamCnt = Cint(gRow(0))

        IF ProcType = "M" THEN TeamCnt = TeamCnt - 1

        if TeamCnt = 0 then
            RTN_ERROR = "Y"
        else
            RTN_ERROR = "N"
        end if 
    End if

    Call DbClose()
    Response.Write RTN_ERROR
%>