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
'게임결과 정보
Function findResult(ByVal m1idx, ByVal m2idx ,ByVal rrs)
	Dim gresult(4),ar,m1_idx,m2_idx,r_idx,g_state,c_no,win_idx
	'결과및 코트
	If IsArray(rrs) Then
		For ar = LBound(rrs, 2) To UBound(rrs, 2)
		  m1_idx = rrs(2,ar)
		  m2_idx = rrs(3,ar) '게임상대
		  r_idx = rrs(4,ar) '결과인덱스
		  g_state = rrs(5,ar) '게임상태
		  c_no  = rrs(7,ar)
		  win_idx = rrs(9,ar)

		  If CDbl(m1_idx) = CDbl(m1idx) And CDbl(m2_idx) = CDbl(m2idx) Then
			gresult(1) = r_idx
			gresult(2) = g_state
			gresult(3) = c_no
			gresult(4) = win_idx
			findResult = gresult
			Exit for
		  End if
		Next
	Else
		gresult(1) = 0
		gresult(2) = 0 '게임상태 ( 2, 진행 , 1, 종료)
		gresult(3) = 0
		gresult(4) = 0
		findResult = gresult
	End If

	If gresult(1) = "" Then
		gresult(1) = 0
		gresult(2) = 0 '게임상태 ( 2, 진행 , 1, 종료)
		gresult(3) = 0
		gresult(4) = 0
		findResult = gresult
	End if
End function


Dim intTotalCnt, intTotalPage '총갯수, 총페이지수

'############################################
	If request("test") = "t" Then
		REQ =  "{""CMD"":30009,""IDX"":547,""TitleIDX"":119,""Title"":""루키"",""TeamNM"":""남자부★"",""AreaNM"":""수원"",""StateNo"":""7"",""S3KEY"":""20104009"",""P1"":0,""POS"":0,""JONO"":0,""GAMEMEMBERIDX"":0,""PLAYERIDX"":0,""PLAYERIDXSub"":0}" 

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
	CMD_LEAGUEJOO = 30009 '예선진행
	CMD_LEAGUEWIN = 40000 '승처리
	CMD_LEAGUECOURT = 40001 '코트 지정한후 셀다시 그리기

	'define  0 예선 1 예선대진표완료 2본선진출 3 본선대진표완료 4본선대진완료 (sd_TennisMember gubun)
	LEAGUESET = 0
	LEAGUESTART = 1
	TOURNSET = 2
	TOURNSTART = 3
	RESULTHIDE = 4
	RESULTSHOW = 5
	STARTROUND = 1 '시작라운드

	Select Case CDbl(CMD)

	Case CMD_LEAGUEJOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.league_ing.asp" --><%
	Response.End
	Case CMD_LEAGUEWIN
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.league_win.asp" --><%
	Response.End
	Case CMD_LEAGUECOURT
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.league_court.asp" --><%
	Response.End
	End Select
%>