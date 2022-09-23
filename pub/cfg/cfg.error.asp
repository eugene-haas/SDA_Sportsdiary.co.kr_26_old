<%
	'##DB 설정
	Dim DB_IP,DB_NAME,DB_ID,DB_PW,ConStr
	DB_IP	= "49.247.9.88\SQLExpress,1433"
	DB_NAME = "LOG_INFO"
	DB_ID	= "splog_ekS1dlP9djT0fl" 
	DB_PW	= "slogp_#f(6+!2!j+g04*alN9kO3"

	'공통 (관리자 로그인, 메뉴관리등)
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"

%>
