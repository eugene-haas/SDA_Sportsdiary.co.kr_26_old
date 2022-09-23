<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
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
		REQ = "{""PN"":1,""CMD"":300,""SEQ"":0,""returnurl"":""/bbs.asp"",""HIDEARR"":""39,40"",""PUBARR"":""31,32,33,34,35,36,37,38""}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") > 0 then
	Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	tid = 1

	CMD_W = 20000 '편집모드
	CMD_WIMG = 20001 '편집모드

	CMD_FINDYEAR = 21000 '년도검색
	CMD_FINDLEVELNO = 21001  '레벨검색

	CMD_DELIMG = 200 '이미지삭제
	CMD_PUBSHOW = 300 '앱노출여부
	CMD_DELBBS = 400 '게시물 삭제

	Select Case CDbl(CMD)
	Case CMD_W
		%><!-- #include virtual = "/pub/api/bbs/api.editor.asp" --><%
		Response.end		
	Case CMD_WIMG
		%><!-- #include virtual = "/pub/api/bbs/api.editor.imgupload.asp" --><%
		Response.End

	Case CMD_FINDYEAR
		%><!-- #include virtual = "/pub/api/bbs/api.findYear.asp" --><%
		Response.end		
	Case CMD_FINDLEVELNO
		%><!-- #include virtual = "/pub/api/bbs/api.findLevelno.asp" --><%
		Response.End

	Case CMD_DELIMG
		%><!-- #include virtual = "/pub/api/bbs/api.delimg.asp" --><%
		Response.end		

	Case CMD_DELIMG
		%><!-- #include virtual = "/pub/api/bbs/api.delBBS.asp" --><%
		Response.end		


	Case CMD_PUBSHOW
		%><!-- #include virtual = "/pub/api/bbs/api.pubshow.asp" --><%
		Response.end		


	End select
%>