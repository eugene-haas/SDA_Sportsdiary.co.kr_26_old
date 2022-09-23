<!--#include virtual="/api/_func/encoding.asp"-->
<!--#include virtual="/api/_conn/DBCon.asp"-->
<!--#include virtual="/api/_func/Utill.asp"-->
<!--#include virtual="/api/_Func/json2.asp"-->

<!--#include virtual="/api/_Func/utx.asp"-->
<!--#include virtual="/api/_Func/utx_env.asp"-->
<!--#include virtual="/api/_Func/utx_log.asp"-->

<!--#include virtual="/api/_Func/res/define_state.asp"-->
<!--#include virtual="/api/_func/report_env_client.asp"-->
<!--#include virtual="/api/log_mgr/log_mgr.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	개발 관련 공통 환경파일 
	'  Date     : 	2021.02.25
	'  Author   : 															By Aramdry
	'================================================================================= 
%>

<% 	
	'=================================================================================
	'  공통적인 file Include
	'  System Log 
	'  로그인 체크 
	'================================================================================= 
%>

<%
Dim TEST_DEBUG

TEST_DEBUG = 0
'파일 로그
JsonData = RequestJsonObject2(Request)
Call TraceSysInfo(JsonData, Request)
'로그인체크

If(TEST_DEBUG <> 1) Then 
	Call IsLoginSessionCheck()   
Else  
   userid = "test_admin"         ' test시 사용
End If 
%>