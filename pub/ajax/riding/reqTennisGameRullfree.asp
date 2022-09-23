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
		REQ = "{""CMD"":40000,""FSTR"":""24"",""FSTR2"":""20104002,신인부"",""ATTCNT"":""64"",""SEED"":""8"",""JONO"":""21"",""BOXORDER"":0}" 
 

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
	CMD_Delete = 46010 '삭제



	Select Case CDbl(CMD)
	Case CMD_FIND1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameRullFind1free.asp" --><%
	Response.end	

	Case CMD_FIND2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameRullFind2free.asp" --><%
	Response.end

	Case CMD_SETGAME '폼을 부르고 내용을 부른다...
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.makerullform.asp" --><%
	Response.end	

	Case CMD_SAVETrJoono
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.makeRullupdate.asp" --><%
	Response.end
	
	Case CMD_SAVEGAME
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameRullSave.asp" --><%
	Response.end	

	Case CMD_Delete
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameRulldelete.asp" --><%
	Response.end	

	End Select
%>