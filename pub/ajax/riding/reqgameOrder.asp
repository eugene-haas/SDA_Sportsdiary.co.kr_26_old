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



' http://tennis.sportsdiary.co.kr/pub/ajax/riding/reqboocontrol.asp?test=t
'############################################
	If request("test") = "t" Then
	REQ = "{""IDX"":""30"",""NOIDX"":""49"",""SNO"":""9999"",""PARR"":["""",""U"",""오전 4:01"",""오전 4:01"",""공지사항 운동좀하세요......""],""CMD"":302}"
	'REQ = "{""PARR"":[""693""],""CMD"":12000}"
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
	CMD_GAMEINPUT2 = 15001	'공지사항저장2
	CMD_GAMEINPUTEDITOK = 302	'수정
	CMD_GAMEINPUTDEL = 303	'삭제
	CMD_SETORDERNO = 400	'출전순서 변경
	CMD_GAMEINPUTEDIT2  = 15004	'공지사항 내용 불러오기


	Select Case CDbl(CMD)

	case CMD_SETORDERNO '순서변경
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setOrderNo.asp" --><% 
	Response.End
	
	case CMD_GAMEINPUT2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scSavenotice2.asp" --><% 
	Response.End

	case CMD_GAMEINPUTEDIT2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scLoadNotice2.asp" --><% 
	Response.End

	case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.orderNoticeEditOk.asp" --><% 
	Response.End

	case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.orderNoticeDel.asp" --><% 
	Response.End



	End Select
%>
