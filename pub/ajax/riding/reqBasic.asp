<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->

<!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%>
<%

if left(CMD,1) = "9" Then
	select case CMD
	case "900" : CMD = "attend_player"
	case "90000" : CMD = "find_player" '모달 (선수검색창)
	case "91000" : CMD = "findplayerlist"	'찾은 선수목록
	end select
end if


'If  Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" then
'	Response.write "/pub/api/"&sitecode&"/api."&SENDPRE&CMD&".asp"
'else
	Server.Execute ("/pub/api/"&sitecode&"/api."&SENDPRE&CMD&".asp")
'end if
%>
