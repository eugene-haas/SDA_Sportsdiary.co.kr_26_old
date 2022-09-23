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
		REQ =  "{""CMD"":82001,""IDX"":81,""TitleIDX"":25,""Title"":""입력테스트"",""TeamNM"":""신인부"",""AreaNM"":""부천"",""ONEMORE"":""notok"",""roundSel"":""0"",""RESET"":""notok"",""COURTAREA"":0,""T_M1IDX"":14662,""T_M2IDX"":14652,""T_SORTNO"":6,""T_RD"":1,""S3KEY"":""20104001"",""RIDX"":22232,""NOWCTNO"":2234}" 

	ElseIf request("test") = "z" Then
		REQ ="{""CMD"":30017,""IDX"":52,""RESET"":""notok"",""TitleIDX"":13,""Title"":""송근호배"",""TeamNM"":""오픈부"",""AreaNM"":""목동"",""MEMBERIDX"":""2269"",""STR"":""2"",""RNDNO"":""2""}"
	else
		REQ = request("REQ")
	End If


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
	CMD_HTML01 = 80000 'textarea 글쓰기 화면
	CMD_HTML01OK = 80001 'textarea 글쓰기 화면

	CMD_INITCOURT = 81000'코트 화면 불러옴
	CMD_INITCOURTMAKE = 81001'코트 생성
	CMD_INITCOURTEDIT = 81002'코트 수정
	CMD_INITCOURTDEL = 81003'코트 삭제

	CMD_INITLAKET = 82001 '라켓정보
	
	Select Case CDbl(CMD)
	
	
	Case CMD_INITLAKET
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.laket.asp" --><%
	Response.End


	Case CMD_INITCOURT
		%><!-- #include virtual = "/pub/api/RidingAdmin/bbs/api.makecourt.asp" --><%
	Response.End

	Case CMD_HTML01
		%><!-- #include virtual = "/pub/api/RidingAdmin/bbs/api.textarea.asp" --><%
	Response.End

	Case CMD_HTML01OK
		%><!-- #include virtual = "/pub/api/RidingAdmin/bbs/api.textareaOK.asp" --><%
	Response.End
	End Select
%>