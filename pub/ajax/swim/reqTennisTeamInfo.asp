<!-- #include virtual = "/pub/header.swimAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	If request("t") = "t" Then
		REQ = "{""CMD"":30001,""Team"":"""",""TeamNm"":""테스트"",""sido"":""01"",""ZipCode"":"""",""Address"":"""",""AddrDtl"":"""",""TeamTel"":"""",""TeamLoginPwd"":""""}"
	Else
		REQ = request("REQ")
	End if


   ' REQ ="{""CMD"":30008,""findTYPE"":""s_team"",""findSido"":"""",""fndSTR"":""대구"",""PAGENO"":""1""}"

	'REQ ="{""CMD"":30008,""AutoNo"":""1""}"

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
	Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if
   
	CMD_GAMEGRADEPERSONAPPEND = 30000
	CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004
	CMD_GAMEAUTO = 30007
	CMD_FINDPLAYER = 30008

	Select Case CDbl(CMD)
	    Case CMD_FINDPLAYER
		    %><!-- #include virtual = "/pub/api/swimadmin/api.TeamInfomore.asp" --><%
	    Response.End

	    Case CMD_GAMEGRADEPERSONAPPEND
		    %><!-- #include virtual = "/pub/api/swimadmin/api.TeamInfomore.asp" --><%
	    Response.End

	    Case CMD_GAMEINPUT
		    %><!-- #include virtual = "/pub/api/swimadmin/api.TeamInfoinput.asp" --><%
	    Response.end	

	    Case CMD_GAMEINPUTEDIT
		    %><!-- #include virtual = "/pub/api/swimadmin/api.TeamInfoinputedit.asp" --><%
	    Response.end	

	    Case CMD_GAMEINPUTEDITOK
		    %><!-- #include virtual = "/pub/api/swimadmin/api.TeamInfoinputeditok.asp" --><%
	    Response.end	

	    Case CMD_GAMEINPUTDEL
		    %><!-- #include virtual = "/pub/api/swimadmin/api.TeamInfoinputdel.asp" --><%
	    Response.end	

	    Case CMD_GAMEAUTO
            %><!-- #include virtual = "/pub/api/swimadmin/api.TeamInfoInputAuto.asp" --><% 
	    Response.end
        	
	End select  
%>

