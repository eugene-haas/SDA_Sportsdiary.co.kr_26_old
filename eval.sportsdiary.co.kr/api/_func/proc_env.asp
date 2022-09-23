<!--#include virtual="/api/_func/lib/encoding.asp"-->
<!--#include virtual="/api/_func/lib/json2.asp"-->
<!--#include virtual="/api/_func/conn_info.asp"-->
<!--#include virtual="/api/_func/utx_sys.asp"-->

<!--#include virtual="/api/_func/utx.asp"-->
<!--#include virtual="/api/_func/utx_env.asp"-->
<!--#include virtual="/api/_func/utx_log.asp"-->
<!--#include virtual="/api/_func/res/define_state.asp"-->

<!--#include virtual="/api/_func/sys_log/report_env_client.asp"-->


<% 	
	'=================================================================================
	'  Purpose  : 	개발 관련 공통 환경파일 
	'  Date     : 	2021.02.25
	'  Author   : 															By Aramdry
	'================================================================================= 
%>


<%

	' ---------------------------------------------
	'Request로 부터 Json 객체를 얻는다. 
	JsonData = RequestJsonObject(Request)

	' ---------------------------------------------
	'System log를 찍는다. 	
'	Call TraceSysInfo(JsonData, Request)


%>