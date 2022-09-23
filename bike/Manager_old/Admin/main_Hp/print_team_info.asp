<!--#include file="../dev/dist/config.asp"-->
<!--METADATA TYPE="typelib"  NAME="ADODB Type Library" UUID= "00000205-0000-0010-8000-00AA006D2EA4" -->
<object runat="Server" PROGID="ADODB.Command" Id="objCmd" VIEWASTEXT></object>
<%
    '===================================================================================================================================
    'PAGE : /Main_HP/print_team_info.asp
    'DATE : 2018년 04월 18일
    'DESC : [관리자] 등록팀 주소 인쇄 목록
    '===================================================================================================================================
    Dim PTeamIDX, PTeamGb, TeamNm, ZipCode, Address, AddrDtl
    Dim ListPage, ViewPage

    ' 로그인 체크
    Check_AdminLogin()

    ListPage    = "/Main_HP/print_team_search.asp"
    ViewPage    = "/Main_HP/print_team_info.asp"

    PTeamGb     = fInject(Trim(Request.Form("PTeamGb")))

    if PTeamGb = "" then
        DBClose()
        Response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.replace('"& ListPage &"');</script>"
        Response.end
    end if 
    'Response.Write "PTeamGb: "& PTeamGb &"<br />"

    With objCmd
		.ActiveConnection = DBCon
		.CommandType  = adCmdStoredProc

		.CommandText  = "SP_ADM_TBLTEAMINFO_PRINT"

        .Parameters.Append .CreateParameter("@KEYWORD", adVarChar, adParamInput, 50, PTeamGb)

		Set gRow = .Execute

		For ry = .Parameters.Count - 1 to 0 Step -1
            .Parameters.Delete(ry)
        Next
	End With

    If gRow.eof Or gRow.bof Then
		Buff	= Null
		Cnt		= 0
	Else
		Buff	= gRow.getrows
		Cnt		= UBound(Buff,2)
	End If
    Set gRow = Nothing
    DBClose()

    jjj = 1
	iii = 1
%>

<!DOCTYPE HTML>
<html lang="ko-KR">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>배드민턴 관리자</title>
</head>
<body>
    <%
    if isnull(Buff) = true then
        Response.Write "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""500"">"
		Response.Write "    <tr><td align=""center"">등록된 팀이 없습니다.</td></tr>"
		Response.Write "</table>"
    else
        for i=0 to Cnt
            PTeamIDX        = cdbl(Buff(0, i))
            PTeamGb         = trim(Buff(1, i))
            TeamNm          = trim(Buff(2, i))
            ZipCode         = trim(Buff(3, i))
            Address         = trim(Buff(4, i))
            AddrDtl         = trim(Buff(5, i))

            if iii mod 2 =1 then
    %>
    <table border=0 cellpadding=10 cellspacing=0 class=menu_sub width=100% bgcolor=FFFFFF>
	    <tr bgcolor=FFFFFF>
            <%end if %>
            <td <%if iii mod 2 =1 then%>width=50%<%else%>width=49%<%end if%> height=128>
                <font color=black>
                    <font style="font-family:바탕체;font-size:19px;line-height:23px;letter-spacing:-1;"><%=Address &"&nbsp;"& AddrDtl%><br><%=TeamNm%></font><br>
                    <div align=right>
                        <font style="font-family:바탕체;font-size:17px;line-height:20px;letter-spacing:-3;">(배드민턴부 귀중)</font>
                    </div>
                    <font style="font-family:바탕체;font-size:16px;line-height:19px;letter-spacing:2;"><b><%=ZipCode%></b></font>
                </font>
            </td>
            <%if iii mod 2 =1 then%>
			<td width=1%>&nbsp;</td> <!--원본 50% 만들고.. 이 라인 없어야 함...-->
            <%end if %>
            <%if iii mod 2 =1 and jjj=Cnt+1 then%>
            <td width=49% height=128>
            <% 
                iii = iii + 1
            end if
            
            if iii mod 2 =0 then%>
                </tr>
			</table>
            <%
            end if

            if iii = 16 then
                response.write "<H6></H6>"
                iii = 0
            end if
            iii = iii + 1
            jjj = jjj + 1
        next
    end if 
    %>
</body>
</html>