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
		REQ ="{""CMD"":50003,""IDX"":""19"",""HK"":""MKF"",""F1_0"":""2"",""F1_1"":""2018"",""PARR"":[""장애물"",""5"",""UP"",""1"",""and"",""10"",""Y"",""마장마술"",""0""]}"
	Else
		REQ = request("REQ")
	End if
	'REQ ="{""CMD"":30002,""IDX"":49}"

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

	CMD_WRITE = 50001 '등록
	CMD_EDIT = 50002 '내용불러오기
	CMD_EDITOK = 50003 '수정
	CMD_DEL = 50004 '삭제


	Select Case CDbl(CMD)

	Case CMD_WRITE
		%><!-- #include virtual = "/pub/api/RidingAdmin/limit/api.limitWrite.asp" --><%
	Response.End
	Case CMD_EDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/limit/api.limitEdit.asp" --><%
	Response.End
	Case CMD_EDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/limit/api.limitEditOk.asp" --><%
	Response.End
	Case CMD_DEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/limit/api.limitDel.asp" --><%
	Response.end	

	End select
%>
