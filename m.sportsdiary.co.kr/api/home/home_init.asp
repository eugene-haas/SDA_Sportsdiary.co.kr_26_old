<!--#include virtual="/app/api/_func/encoding.asp"-->
<!--#include virtual="/app/api/_conn/DBCon.asp"-->
<!--#include virtual="/app/api/_func/Utill.asp"-->
<!--#include virtual="/app/api/_Func/json2.asp"-->

<!--#include virtual="/app/api/_Func/utx_config.asp"-->
<% 	
	'=================================================================================
	'  Purpose  : 	유도 App Home Init
	'  Author   : 															By Aramdry
	'================================================================================= 	
%>

<% 	
	'=================================================================================
	'  유도 App Home Init
	'================================================================================= 
%>

<%
' http://sdmain.sportsdiary.co.kr/app/api/home/home_init.asp
%>


<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

	'=================================================================================
	'  Home page Init 
	'=================================================================================  
	Function getSqlManager(manager_id)
		Dim strSql, err_no
		
		If(manager_id = "") Then err_no = 1 End If 

		If( err_no <> 1 ) Then 
			strSql = strSql & " Select MANAGER_SEQ From TB_MANAGER  "
			strSql = strSql & sprintf(" 	Where DelKey = 0 And dbo.FN_DEC_VAL(MANAGER_ID)  = '{0}'", Array(manager_id))
 		End If  

		getSqlManager = strSql 
	End Function

%>

<%
	'=================================================================================
	'  Sub Function 
	'================================================================================= 

%>

<%
DBOpen()
	Dim JsonStr, JsonObj, strSql  	
	Dim RS_DATA, strData, dataCnt, err_no, user_id, client_ip
   Dim id, name, cMajor, major, cSports, sports, cPos, pos, manager_seq
	Dim cGroup 

	Set JsonObj 		  	= JSON.Parse(JsonData)

   client_ip   = clientIP
	'user_id     = Session("user_id")
   user_id     = "test_admin"
	err_no = 0

	strLog = sprintf("home_init.asp = {0} ", Array("123"))
	Call utxLog(DEV_LOG1, strLog)

	'Response.Clear
	'Response.Write JsonStr  

	Set JsonObj = Nothing
DBClose()
%>

