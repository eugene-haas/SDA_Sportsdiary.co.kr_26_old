<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
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
    REQ = "{""CMD"":18,""IDX"":567,""TitleIDX"":142,""Title"":""김정연테스트대회"",""TeamNM"":""개나리부"",""AreaNM"":""구리"",""StateNo"":""0"",""S3KEY"":""20101002"",""P1"":414311,""POS"":""rankL_1_1"",""JONO"":1,""GAMEMEMBERIDX"":414311,""PLAYERIDX"":16494,""PLAYERIDXSub"":7087,""EndGroup"":10,""GUBUN"":1,""GN"":0,""RANKNO"":""1""}"

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


	CMD_SETLEAGUERANKING = 18

	Select Case CDbl(CMD)

	CASE CMD_SETLEAGUERANKING
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setRanking_새로작업.asp" --><%
	Response.End

	End Select
%>
