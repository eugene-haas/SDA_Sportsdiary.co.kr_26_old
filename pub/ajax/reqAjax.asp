<!-- #include virtual = "/pub/header.admin.asp" -->
<!-- #include virtual = "/pub/class/jsonObejct.class.asp" -->
<%
'참조 : https://github.com/rcdmk/aspJSON

	Response.LCID = 1042
	Set JSON = new JSONobject
	'Set JSONarr = new jsonArray
	JSON.debug = false


	REQ = request("REQ")
	'REQ = "{""CMD"":""10002"",""NM"":""IC_T_TMP_CUST_INFO"",""DN"":""ITEMCENTER""}"
	'REQ = "{""CMD"":""1"",""NM"":""IC_T_GDS_KDB_CUSTOMER"",""DN"":""ALPHA"",""CMT"":""a"",""MD"":""2""}"
	'REQ = "{""CMD"":""3"",""ID"":""widline"",""PWD"":""1111""}"
	'REQ = "{""CMD"":""20001""}"
	'REQ = "{""CMD"":""500"",""TITLE"":""fjdklsjfdsl"",""CND"":""<p>jkhjkhjk</p>""}"
	'REQ = "{""CMD"":""20003"",""SEQ"":""4"",""TID"":"""",""FT"":"""",""SSTR"":"""",""PG"":""1""}"




	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.value("CMD")

	'define CMD
	CMD_TABLELIST = 10001
	CMD_TABLECLUMN = 10002
	CMD_IISINFO = 10003
	CMD_TARGETSITE = 10004
	CMD_DBBASIC = 20005


	'게시판
	CMD_BOARD = 20001
	CMD_BOARDWRITE = 20002
	CMD_BOARDVIEW = 20003
	CMD_BOARDEDIT = 20004


	CMD_TABLECMT = 1
	CMD_COLUMNCMT = 2
	CMD_LOGIN = 3


	'게시판
	CMD_BOARDWRITEOK = 500


	Select Case CDbl(CMD)
	Case CMD_TABLELIST
		%><!-- #include virtual = "/pub/api/api.tablelist.asp" --><%
		Response.End
	Case CMD_TABLECLUMN
		%><!-- #include virtual = "/pub/api/api.tableclumn.asp" --><%
		Response.end	
	Case CMD_IISINFO
		%><!-- #include virtual = "/pub/api/api.iis.asp" --><%
		Response.end	
	Case CMD_TARGETSITE
		%><!-- #include virtual = "/pub/api/api.site.asp" --><%
		Response.end	
	Case CMD_DBBASIC
		%><!-- #include virtual = "/pub/api/api.dbbasic.asp" --><%
		Response.end	



	Case CMD_BOARD
		%><!-- #include virtual = "/pub/api/api.boardlist.asp" --><%
		Response.end	
	Case CMD_BOARDWRITE
		%><!-- #include virtual = "/pub/api/api.boardwrite.asp" --><%
		Response.end	
	Case CMD_BOARDWRITEOK
		%><!-- #include virtual = "/pub/api/api.boardwriteok.asp" --><%
		Response.end	
	Case CMD_BOARDVIEW
		%><!-- #include virtual = "/pub/api/api.boardview.asp" --><%
		Response.end	
	Case CMD_BOARDEDIT
		%><!-- #include virtual = "/pub/api/api.boardedit.asp" --><%
		Response.end	


	Case CMD_TABLECMT
		%><!-- #include virtual = "/pub/api/api.tablecmt.asp" --><%
		Response.end		
	Case CMD_COLUMNCMT
		%><!-- #include virtual = "/pub/api/api.columncmt.asp" --><%
		Response.end		
	Case CMD_LOGIN
		%><!-- #include virtual = "/pub/api/api.login.asp" --><%
		Response.end	
	End select
%>