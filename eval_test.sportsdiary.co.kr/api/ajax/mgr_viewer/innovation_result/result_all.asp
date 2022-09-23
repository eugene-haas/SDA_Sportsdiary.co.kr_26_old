<!--#include virtual="/api/_func/proc_env.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	숙소배정 Page Init
	'  Date     : 	2021.04-28
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	
	'=================================================================================
	' 	
	'================================================================================= 
%>

<%
' http://eval.sportsdiary.co.kr/api/ajax/mgr_viewer/innovation_result/result_all.asp
%>

<%
	'=================================================================================
	'  Sql Query Function 
	'=================================================================================

   '=================================================================================
	'  선수촌 전체 Room 정보를 가져온다. 
	'=================================================================================  
	Function getSqlFacilityInfo()
		Dim strSql, err_no
		
		strSql = strSql & " Select ROW_NUMBER() Over(Partition By FLOOR_TITLE Order By Number) As Idx,  "
      strSql = strSql & "    FLOOR_TITLE, NUMBER, FIXED From TB_FACILITY "
      strSql = strSql & "    Where DelKey = 0 And FACILITY_TYPE_CODE = 'FT0001' "
      strSql = strSql & "    Order By NUMBER "

		getSqlFacilityInfo = strSql 
	End Function
	

   
%>

<%
	'=================================================================================
	'  Sub Function 
	'================================================================================= 
%>

<%
DBOpen()
   strLog = sprintf("result_all.asp = {0} ", Array("start"))
   ' ' Call utxLog(DEV_LOG1, strLog)

	Response.Clear
	Response.Write JsonStr
	
	Set JsonObj = Nothing
DBClose()
%>

