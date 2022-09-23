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
		REQ = "{""CMD"":45020,""FSTR"":""28"",""FSTR2"":""20105001,오픈부"",""FSTR_idx"":""9454"",""order"":""1"",""joono"":""0""}" '세이브
		'REQ = "{""CMD"":40000,""FSTR"":""24"",""FSTR2"":""20101001,개나리부"",""ATTCNT"":""80"",""SEED"":""5"",""JONO"":""32"",""BOXORDER"":""1,5,2,4,3""}"
       ' REQ = "{""CMD"":40000,""FSTR"":""33"",""FSTR2"":""20101011,개나리부"",""ATTCNT"":""128"",""SEED"":""8"",""JONO"":""48"",""BOXORDER"":0}"
 

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
	CMD_FIND1 = 30005
	CMD_FIND2 = 30006
	CMD_SETGAME = 40000
	CMD_SAVEGAME = 45000 '저장
	CMD_SAVETrJoono = 45010 '부분 저장
    CMD_RullUpdate = 45020 '부분 수정
	CMD_Delete = 46010 '삭제
     

	Select Case CDbl(CMD)
	Case CMD_FIND1
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameRullFind1.asp" --><%
	Response.end	

	Case CMD_FIND2
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameRullFind2.asp" --><%
	Response.end

	Case CMD_SETGAME
		%><!-- #include virtual = "/pub/api/tennisadmin/api.makerull.asp" --><%
	Response.end	
      	

	Case CMD_SAVETrJoono
		%><!-- #include virtual = "/pub/api/tennisadmin/api.makeRullupdate.asp" --><%
	Response.end
	
	Case CMD_SAVEGAME
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameRullSave.asp" --><%
	Response.end	

	Case CMD_Delete
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameRulldelete.asp" --><%
	Response.end	

	Case CMD_RullUpdate
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameRullupdate.asp" --><%
	Response.end	
    
	End Select
%>