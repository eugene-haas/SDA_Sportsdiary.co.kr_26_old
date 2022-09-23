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
		'REQ = "{""CMD"":40003,""ADD"":""Y""}"
    REQ = "{""CMD"":40001,""GY"":""2018"",""GTITLE"":""23"",""LEVELNO"":""118"",""BTITLE"":""test1"",""URLS"":[""djV11Xbc914"",""ZEdZqZy9Yr0""]}"
    'REQ = "{""CMD"":40000,""MODE"":""write""}"
    'REQ = "{""CMD"":40005,""SEQ"":64,""CIDX"":99}"
    ' REQ = "{""CMD"":40002,""GY"":""2018"",""GTITLE"":""23"",""LEVELNO"":""126"",""BTITLE"":""sadsadsa"",""SEQ"":64}"
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

    CMD_FINDYEAR = 21000 '년도검색
	  CMD_FINDLEVELNO = 21001 '레벨검색

    CMD_OPENEDITOR = 40000
    CMD_WVIDEO = 40001 '비디오 게시물 등록
    CMD_EVIDEO = 40002 '비디오 게시물 수정
    CMD_ADDURL = 40003
    CMD_ADDVIDEO = 40004 '수정모드에서 비디오 추가
    CMD_DELVIDEO = 40005 '수정모드에서 비디오 삭제

	Select Case CDbl(CMD)

    Case CMD_FINDYEAR
		%><!-- #include virtual = "/pub/api/bbs/api.findYear.asp" --><%
		Response.end
	  Case CMD_FINDLEVELNO
		%><!-- #include virtual = "/pub/api/bbs/api.findLevelno.asp" --><%
		Response.end
	  Case CMD_OPENEDITOR
		%><!-- #include virtual = "/pub/api/bike/board/video/api.videoEditor.asp" --><%
		Response.end
    Case CMD_WVIDEO
		%><!-- #include virtual = "/pub/api/bike/board/video/api.writeVideo.asp" --><%
    Response.end
    Case CMD_EVIDEO
		%><!-- #include virtual = "/pub/api/bike/board/video/api.editVideo.asp" --><%
		Response.end
    Case CMD_ADDURL
		%><!-- #include virtual = "/pub/api/bike/board/video/api.urlform.asp" --><%
		Response.end
    Case CMD_ADDVIDEO
		%><!-- #include virtual = "/pub/api/bike/board/video/api.addVideo.asp" --><%
		Response.end
    Case CMD_DELVIDEO
		%><!-- #include virtual = "/pub/api/bike/board/video/api.delVideo.asp" --><%
		Response.end



	End select
%>
