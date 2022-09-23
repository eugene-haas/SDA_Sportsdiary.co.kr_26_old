<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

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
		REQ = "{""CMD"":10003,""F1"":361,""GB"":20104,""YY"":2019}"
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



	CMD_SEARCHRC        = 10001	'검색
	CMD_SEARCHPLAYER  = 10002	'선수검색
	CMD_PLAYERINFO		  = 10003	'상세정보

	Select Case CDbl(CMD)
	Case CMD_SEARCHRC
		%><!-- #include virtual = "/pub/api/RookieTennis/mobile/api.searchRecord.asp" --><%
		Response.end		

	Case CMD_SEARCHPLAYER
		%><!-- #include virtual = "/pub/api/RookieTennis/mobile/api.searchPlayerlist.rookie.asp" --><%
		Response.End
		
	Case CMD_PLAYERINFO
		%><!-- #include virtual = "/pub/api/RookieTennis/mobile/api.playerDetail.asp" --><%
		Response.end

	End select
%>