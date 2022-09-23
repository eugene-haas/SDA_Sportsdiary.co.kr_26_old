<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

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
		REQ = "{""CMD"":40003,""IDX"":""25"",""SGB"":""양양군수배"",""TITLE"":""test"",""GTYPE"":""E"",""SIDO"":""경기"",""ZIPCODE"":""13494"",""ADDR"":""경기 성남시 분당구 판교역로 235 (삼평동, 에이치스퀘어 엔동)"",""STADIUM"":""test대회"",""GameS"":""2018-07-01"",""GameE"":""2018-07-02"",""GameAS"":""2018-07-01"",""GameAE"":""2018-07-05"",""HOST"":""위드라인""}"
'		REQ = "{""CMD"":40002,""IDX"":25}"
	Else
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
	CMD_INSERTGB = 30023 '대분류생성
	CMD_W = 40001	'등록
	

	CMD_SELECTGB = 30022 '대분류검색
	CMD_INSERTSUBGB = 30024 '종목생성
	CMD_GAMEHOST = 30036 '주최생성




	CMD_E = 40002	'수정불러오기
	CMD_EOK = 40003 '수정완료
	CMD_D = 40004	'삭제
	CMD_EDITOR = 40005 '대회요강

	CMD_SELECTSIDO = 50001	'시도로 구군검색	
	CMD_SELECTGB2 = 50002	'대분류검색

	Select Case CDbl(CMD)

	Case CMD_INSERTGB,CMD_SELECTGB
		%><!-- #include virtual = "/pub/api/bike/contest/api.insertGb.asp" --><%
	Response.End
	Case CMD_W
		%><!-- #include virtual = "/pub/api/bike/contest/api.write.asp" --><%
	Response.End	
	Case CMD_GAMEHOST
		%><!-- #include virtual = "/pub/api/bike/contest/api.insertSelect.asp" --><%
	Response.End
	
	

	
	Case CMD_D
		%><!-- #include virtual = "/pub/api/bike/contest/api.del.asp" --><%
	Response.End	

	Case CMD_EOK
		%><!-- #include virtual = "/pub/api/bike/contest/api.editok.asp" --><%
	Response.End	

	Case CMD_E
		%><!-- #include virtual = "/pub/api/bike/contest/api.edit.asp" --><%
	Response.End	








	Case CMD_SELECTSIDO
		%><!-- #include virtual = "/pub/api/ksports/api.SidoGb.asp" --><%
	Response.End


	End select
%>