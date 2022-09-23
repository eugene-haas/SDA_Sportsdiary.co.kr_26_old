<% 
	'유도
	strConnect = strConnect&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect = strConnect&"Data Source=49.247.9.88;"  
	strConnect = strConnect&"User ID=splog_ekS1dlP9djT0fl;"             
	strConnect = strConnect&"Password=slogp_#f(6+!2!j+g04*alN9kO3;"             
	strConnect = strConnect&"Initial Catalog=sportsdiary;"   
	
	
	'아이템센터(SMS발송 관련)
	strConnect2 = strConnect2&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect2 = strConnect2&"Data Source=db.itemcenter.co.kr;"  
	strConnect2 = strConnect2&"User ID=widsql;"             
	strConnect2 = strConnect2&"Password=ic%^&1058!@#;" 
	strConnect2 = strConnect2&"Initial Catalog=ITEMCENTER;"   


	'통합회원DB
	strConnect3 = strConnect3 & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect3 = strConnect3 & "Data Source=49.247.9.88;"  
	strConnect3 = strConnect3 & "User ID=splog_ekS1dlP9djT0fl;"             
	strConnect3 = strConnect3 & "Password=slogp_#f(6+!2!j+g04*alN9kO3;"             
	strConnect3 = strConnect3 & "Initial Catalog=SD_Member;"    
	
	
	'테니스
	strConnect4 = strConnect4 & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect4 = strConnect4 & "Data Source=49.247.9.88;"  
	strConnect4 = strConnect4 & "User ID=splog_ekS1dlP9djT0fl;"             
	strConnect4 = strConnect4 & "Password=slogp_#f(6+!2!j+g04*alN9kO3;"
	strConnect4 = strConnect4 & "Initial Catalog=SD_tennis;"


	'광고관리 - 전체
	strConnect6 = strConnect6&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect6 = strConnect6&"Data Source=49.247.9.88;"  
	strConnect6 = strConnect6&"User ID=splog_ekS1dlP9djT0fl;"             
	strConnect6 = strConnect6&"Password=slogp_#f(6+!2!j+g04*alN9kO3;"             
	strConnect6 = strConnect6&"Initial Catalog=SD_AD;"


	'문자
	strConnectsms = strConnectsms & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnectsms = strConnectsms & "Data Source=49.247.9.88;"  
	strConnectsms = strConnectsms & "User ID=sms_Ek27fh4gk;"             
	strConnectsms = strConnectsms & "Password=sms_VW&e@)&Py$5a^458bP*#e;"
	strConnectsms = strConnectsms & "Initial Catalog=SD_Tennis;"    
%>