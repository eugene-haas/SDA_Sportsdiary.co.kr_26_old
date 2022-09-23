<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->




<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수

'############################################
	If request("test") = "t" Then
		' REQ =  "{""CMD"":40004,""IDX"":168,""TitleIDX"":24,""Title"":""예선 업로드"",""TeamNM"":""오픈부"",""AreaNM"":""파주"",""ONEMORE"":""notok"",""roundSel"":""0"",""RESET"":""notok"",""COURTAREA"":0,""T_M1IDX"":42017,""T_M2IDX"":42045,""T_SORTNO"":34,""T_RD"":1,""S3KEY"":""20105001"",""RIDX"":0,""NOWCTNO"":0,""WINIDX"":42045,""SCOREA"":""4"",""SCOREB"":""5""}"
    REQ = "{""CMD"":40005,""IDX"":168,""TitleIDX"":24,""Title"":""예선 업로드"",""TeamNM"":""오픈부"",""AreaNM"":""파주"",""ONEMORE"":""notok"",""RESET"":""notok"",""COURTAREA"":0}"

	ElseIf request("test") = "z" Then
		REQ ="{""CMD"":30017,""IDX"":52,""RESET"":""notok"",""TitleIDX"":13,""Title"":""송근호배"",""TeamNM"":""오픈부"",""AreaNM"":""목동"",""MEMBERIDX"":""2269"",""STR"":""2"",""RNDNO"":""2""}"
	else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
	Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if


	'define CMD
	CMD_TOURN = 30008 '본선진행창
	CMD_TOURNWAITCOURT = 40002  '본선진행 예정코트 설정
	CMD_TOURNCOURT = 40003  '본선진행 코트 설정
	CMD_TOURNWIN = 40004 '승처리
	CMD_TOURNEND = 40005 '종료된 목록


	'define  0 예선 1 예선대진표완료 2본선진출 3 본선대진표완료 4본선대진완료 (sd_TennisMember gubun)
	LEAGUESET = 0
	LEAGUESTART = 1
	TOURNSET = 2
	TOURNSTART = 3
	RESULTHIDE = 4
	RESULTSHOW = 5
	STARTROUND = 1 '시작라운드


	Select Case CDbl(CMD)

	Case CMD_TOURN
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.Tourn_ing.asp" --><%
	Response.End

	Case CMD_TOURNEND
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.Tourn_ingend.asp" --><%
	Response.end


	Case CMD_TOURNWAITCOURT
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.tourn_waitcourt.asp" --><%
	Response.End
	Case CMD_TOURNCOURT
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.tourn_court.asp" --><%
	Response.End
	Case CMD_TOURNWIN
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.tourn_win.asp" --><%
	Response.End
	End Select
%>
