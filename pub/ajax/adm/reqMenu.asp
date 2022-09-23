<!-- #include virtual = "/pub/header.adm.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	If request("test") = "t" Then
		REQ = "{""CMD"":50002,""DEPNO"":1,""DPTYPE"":""insert"",""DEP1"":""insert"",""DEP2"":"""",""DEP3"":"""",""ACLASS"":"""",""DEPNM"":""자전거""}"
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


	'메뉴관리
	CMD_MENU_WFORM = 50000
	CMD_MENU_WOK = 50001
	CMD_INSERTDEP1 = 50002 '대분류선택
	CMD_SHOPMEMBER = 51000

	CMD_ADMIN_WOK = 230 '관리자등록
	CMD_ADMIN_EOK = 240 '관리자수정
	CMD_BTNST = 210	'버튼상태변경
	CMD_CNGTXT = 220	'텍스트 변경
	CMD_DELMENU = 250	'삭제

	'/RidingAdmin/menu/
	Select Case CDbl(CMD)
	Case CMD_SHOPMEMBER
		%><!-- #include virtual = "/pub/api/adm/api.shopmember.asp" --><% 
		Response.End
	
	Case CMD_MENU_WFORM
		%><!-- #include virtual = "/pub/api/adm/api.menuWrite.asp" --><%
		Response.End

	Case CMD_INSERTDEP1
		%><!-- #include virtual = "/pub/api/adm/api.menuSelect.asp" --><%
		Response.end		
		
	Case CMD_MENU_WOK
		%><!-- #include virtual = "/pub/api/adm/api.menuWriteOK.asp" --><%
		Response.end		

	Case 	CMD_ADMIN_WOK
		%><!-- #include virtual = "/pub/api/adm/api.adminWriteOK.asp" --><%
		Response.end		

	Case CMD_ADMIN_EOK
		%><!-- #include virtual = "/pub/api/adm/api.AdminEditOK.asp" --><%
		Response.end		

	Case CMD_BTNST
		%><!-- #include virtual = "/pub/api/adm/api.btnstate.asp" --><%
		Response.end	
		
	Case CMD_DELMENU
		%><!-- #include virtual = "/pub/api/adm/api.delLine.asp" --><%
		Response.end


	Case CMD_CNGTXT
		%><!-- #include virtual = "/pub/api/adm/api.cngValue.asp" --><%
		Response.end	


	End select
%>