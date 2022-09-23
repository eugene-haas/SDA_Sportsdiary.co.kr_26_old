<% 
	'유도
	strConnect = strConnect&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect = strConnect&"Data Source=db.itemcenter.co.kr;"  
	strConnect = strConnect&"User ID=sportsdiary;"             
	strConnect = strConnect&"Password=dnlemfkdls715)@*@;"             
	strConnect = strConnect&"Initial Catalog=sportsdiary;"   
	
	
	'아이템센터(SMS발송 관련)
	strConnect2 = strConnect2&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect2 = strConnect2&"Data Source=db.itemcenter.co.kr;"  
	strConnect2 = strConnect2&"User ID=widsql;"             
	strConnect2 = strConnect2&"Password=ic%^&1058!@#;" 
	strConnect2 = strConnect2&"Initial Catalog=ITEMCENTER;"   


	'통합회원DB
	strConnect3 = strConnect3 & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect3 = strConnect3 & "Data Source=115.68.112.26;"  
	strConnect3 = strConnect3 & "User ID=sportsdiary;"             
	strConnect3 = strConnect3 & "Password=dnlemfkdls715)@*@;"             
	strConnect3 = strConnect3 & "Initial Catalog=SD_Member;"    
	
	
	'테니스
	strConnect4 = strConnect4 & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect4 = strConnect4 & "Data Source=115.68.112.26;"  
	strConnect4 = strConnect4 & "User ID=sportsdiary;"             
	strConnect4 = strConnect4 & "Password=dnlemfkdls715)@*@;"             
	strConnect4 = strConnect4 & "Initial Catalog=SD_tennis;"


	'광고관리 - 전체
	strConnect6 = strConnect6&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect6 = strConnect6&"Data Source=115.68.112.26;"  
	'strConnect6 = strConnect6&"Data Source=db.SD_Tennis;"  
	strConnect6 = strConnect6&"User ID=sportsdiary;"             
	strConnect6 = strConnect6&"Password=dnlemfkdls715)@*@;"             
	strConnect6 = strConnect6&"Initial Catalog=SD_AD;"



	'SD테니스
	strCnnRT = strCnnRT & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strCnnRT = strCnnRT & "Data Source=115.68.112.26;"  
	strCnnRT = strCnnRT & "User ID=sportsdiary;"             
	strCnnRT = strCnnRT & "Password=dnlemfkdls715)@*@;"             
	strCnnRT = strCnnRT & "Initial Catalog=SD_RookieTennis;"
%>