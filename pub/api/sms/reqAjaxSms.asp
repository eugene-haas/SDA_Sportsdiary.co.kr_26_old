<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<script language="Javascript" runat="server">
    function hasown(obj, prop) {
        if (obj.hasOwnProperty(prop) == true) {
            return "ok";
        }
        else {
            return "notok";
        }
    }
</script>
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수

'############################################
	If request("test") = "t" Then
		REQ = "{""CMD"":2,""SMS_title"":""test2"",""SMS_Contents"":""두번째"",""SMS_Send_No"":""0222496130"",""Level"":""20105012"",""SMS_dtStart"":"""",""SMS_dtStartTime"":"""",""SMS_Recive_No"":""01047093650|01036499693|""}"
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


%>