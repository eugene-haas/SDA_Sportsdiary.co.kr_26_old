<!--#include virtual="/app/api/_Func/utx.asp"-->
<!--#include virtual="/app/api/_Func/utx_env.asp"-->
<!--#include virtual="/app/api/_Func/utx_log.asp"-->
<!--#include virtual="/app/api/_Func/utx_sys.asp"-->

<!--#include virtual="/app/api/_Func/res/define.asp"-->
<!--#include virtual="/app/api/_Func/res/session_info.asp"-->
<!--#include virtual="/app/api/_func/report_env_client.asp"-->

<% 	
	'=================================================================================
	'  Purpose  : 	한체대 관련 공통 환경파일 - Debug시 로그인 체크 제거 
	'  Date     : 	2020.02.10
	'  Author   : 															By Aramdry 
	'================================================================================= 
%>

<% 	
	'=================================================================================
	'  공통 환경파일 
	'  공통적인 file Include
	'  System Log 
	'  로그인 체크 
	'================================================================================= 
%>

<%
Dim TEST_DEBUG

TEST_DEBUG = 0
clientIP   = Request.ServerVariables("REMOTE_ADDR")

'파일 로그
JsonData = RequestJsonObject2(Request)
'Call TraceSysInfo(JsonData, Request)

%>