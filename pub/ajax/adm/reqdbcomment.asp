<!-- #include virtual = "/pub/header.adm.asp" -->


<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%

If sitecode  = "ADN99" Then
	ConStr = B_ConStr
	'dbnmarr = array("공통","멤버","아이템센터","베드민턴","테니스","SD테니스","수영","승마","자전거","유도") cfg에 정의
	
	F1 = request.Cookies("DBNO")
	
	If F1 <> "" Then
		%><!-- #include virtual = "/pub/inc/inc.dbNick.asp" --><%
	End If

End If
	


Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	If request("test") = "t" Then
		REQ = "{""CMD"":10004,""TN"":""sd_bikeAttMember"",""IDXFIELDNM"":""attmidx""}"
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


	CMD_TABLECMT = 1
	CMD_COLUMNCMT = 2 '코멘트 인서트, 업데이트
	CMD_TABLECLUMN = 10002
	CMD_TABLELIST = 10004
	CMD_A6 = 6 '테이블 복사

	Select Case CDbl(CMD)
	Case CMD_TABLECMT
		%><!-- #include virtual = "/pub/api/system/api.tablecmt.asp" --><%
		Response.end		
	Case CMD_COLUMNCMT
		%><!-- #include virtual = "/pub/api/system/api.columncmt.asp" --><%
		Response.end	

	Case CMD_TABLECLUMN
		%><!-- #include virtual = "/pub/api/system/api.tableclumn.asp" --><%
		Response.end	

	Case CMD_TABLELIST
		%><!-- #include virtual = "/pub/api/system/api.tableList.asp" --><%
		Response.end	

	Case CMD_A6
		%><!-- #include virtual = "/pub/api/system/api.copytable.asp" --><%
		Response.end	




	End select
%>