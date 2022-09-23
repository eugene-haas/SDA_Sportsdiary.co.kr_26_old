<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->
<%'<!-- #include virtual = "/pub/class/jsonObejct.class.asp" -->%>

<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<%
'참조1 : https://github.com/rcdmk/aspJSON
'참조 2: http://widecloud.tistory.com/143

	'Response.LCID = 1042
	'Set JSON = new JSONobject
	'Set JSONarr = new jsonArray
	'JSON.debug = false


	REQ = request("REQ")
	'REQ = "{""CMD"":""10002"",""NM"":""IC_T_TMP_CUST_INFO"",""DN"":""ITEMCENTER""}"
	'REQ = "{""CMD"":""1"",""NM"":""IC_T_GDS_KDB_CUSTOMER"",""DN"":""ALPHA"",""CMT"":""a"",""MD"":""2""}"
	'REQ = "{""CMD"":""3"",""ID"":""widline"",""PWD"":""1111""}"
	'REQ = "{""CMD"":""20001""}"
	'REQ = "{""CMD"":""20002"",""SEQ"":""2"",""PG"":""1""}"
	'REQ = "{""CMD"":""500"",""TITLE"":""fjdklsjfdsl"",""CND"":""<p>jkhjkhjk</p>""}"
	'REQ = "{""CMD"":""20003"",""SEQ"":""4"",""TID"":"""",""FT"":"""",""SSTR"":"""",""PG"":""1""}"




	If REQ = "" Then
		Response.End
	End if

	'Set oJSONoutput = JSON.Parse(REQ)
	'CMD = oJSONoutput.value("CMD")
	Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD

	'define CMD
	CMD_TABLELIST = 10001
	CMD_TABLECLUMN = 10002
	CMD_IISINFO = 10003
	CMD_TARGETSITE = 10004
	CMD_DBBASIC = 20005


	'대회정보리스트
	CMD_GAMETITLE = 20001
	CMD_GAMETABLE = 20002

	CMD_BOARDVIEW = 20003
	CMD_BOARDEDIT = 20004


	CMD_TABLECMT = 1
	CMD_COLUMNCMT = 2
	CMD_LOGIN = 3


	'게시판
	CMD_BOARDWRITEOK = 500


	Select Case CDbl(CMD)
	Case CMD_GAMETITLE
		%><!-- #include virtual = "/tennisAdmin/api/api.gametitle.asp" --><%
		Response.end	
	Case CMD_GAMETABLE
		%><!-- #include virtual = "/tennisAdmin/api/api.gametable.asp" --><%
		Response.end	
	End select
%>