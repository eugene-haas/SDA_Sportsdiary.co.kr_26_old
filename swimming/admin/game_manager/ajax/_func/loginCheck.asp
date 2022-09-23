<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<%

Call oJSONoutput.Set("result", "0" ) '서버에서 메시지 생성 전달
Call oJSONoutput.Set("user_info", JSON.Parse(Cookies_adminDecode) ) '서버에서 메시지 생성 전달

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.end
'#################################
%>
