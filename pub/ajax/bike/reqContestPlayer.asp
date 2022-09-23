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
		'REQ = "{""CMD"":20200,""attmidx"":21983,""LVLIDX"":117,""tidx"":23, ""p_phone"":""010-2242-7718"" }"
		'REQ = "{""GROUPNO"":0,""IDX"":17,""CMD"":20003}"
        REQ = "{""IDX"":172,""CHK"":""N"",""CMD"":20001}"
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
	CMD_PAYSTATE = 20001 '결제상태 변경
    CMD_VIEWREFUNDINFO = 20002 '환불정보 확인
	CMD_VIEWLEVELINFO = 20003 '신청한 대회정보 확인
	CMD_PLMS = 20200 '개인 보모동의 lms

	Select Case CDbl(CMD)

	Case CMD_PAYSTATE
		%><!-- #include virtual = "/pub/api/bike/contestplayer/api.paystate.asp" --><%
	Response.End

    Case CMD_VIEWREFUNDINFO
		%><!-- #include virtual = "/pub/api/bike/contestplayer/api.viewrefundinfo.asp" --><%
	Response.End

	Case CMD_VIEWLEVELINFO
		%><!-- #include virtual = "/pub/api/bike/contestplayer/api.viewlevelinfo.asp" --><%
	Response.End

	Case CMD_PLMS
		%><!-- #include virtual = "/pub/api/bike/contestplayer/api.pLMS.asp" --><%
	Response.End


	End select
%>
