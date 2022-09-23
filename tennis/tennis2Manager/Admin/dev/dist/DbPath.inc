<% 
	'스포츠다이어리
	strConnect = strConnect&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	'strConnect = strConnect&"Data Source=115.68.112.26;"  
	strConnect = strConnect&"Data Source=db.itemcenter.co.kr;"  
	strConnect = strConnect&"User ID=sportsdiary;"             
	strConnect = strConnect&"Password=dnlemfkdls715)@*@;"             
	strConnect = strConnect&"Initial Catalog=sportsdiary;"   
	
	'아이템센터
	strConnect2 = strConnect2&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect2 = strConnect2&"Data Source=db.itemcenter.co.kr;"  
	strConnect2 = strConnect2&"User ID=widsql;"             
	strConnect2 = strConnect2&"Password=ic%^&1058!@#;" 
	strConnect2 = strConnect2&"Initial Catalog=ITEMCENTER;"
	
	
	strConnect3 = strConnect3&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect3 = strConnect3&"Data Source=jininjun.com;"  
	strConnect3 = strConnect3&"User ID=sa;"             
	strConnect3 = strConnect3&"Password=clock&&watch;"             
	strConnect3 = strConnect3&"Initial Catalog=CSH;"
	
	'대한유도회 홈페이지
	strConnect4 = strConnect4&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect4 = strConnect4&"Data Source=115.68.7.145;"  
	strConnect4 = strConnect4&"User ID=devsql;"             
	strConnect4 = strConnect4&"Password=ic)(*123;"             
	strConnect4 = strConnect4&"Initial Catalog=JudoKorea;"  


	'스포츠다이어리-테니스
	strConnect5 = strConnect5&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect5 = strConnect5&"Data Source=115.68.112.26;"  
	'strConnect5 = strConnect5&"Data Source=db.SD_Tennis;"  
	strConnect5 = strConnect5&"User ID=sportsdiary;"             
	strConnect5 = strConnect5&"Password=dnlemfkdls715)@*@;"             
	strConnect5 = strConnect5&"Initial Catalog=SD_Tennis;"


	'광고관리 - 전체
	strConnect6 = strConnect6&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect6 = strConnect6&"Data Source=115.68.112.26;"  
	'strConnect6 = strConnect6&"Data Source=db.SD_Tennis;"  
	strConnect6 = strConnect6&"User ID=sportsdiary;"             
	strConnect6 = strConnect6&"Password=dnlemfkdls715)@*@;"             
	strConnect6 = strConnect6&"Initial Catalog=SD_AD;"


	'스포츠다이어리-테니스_SD
	strConnect7 = strConnect7&"Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect7 = strConnect7&"Data Source=115.68.112.26;"  
	'strConnect7 = strConnect7&"Data Source=db.SD_Tennis;"  
	strConnect7 = strConnect7&"User ID=sportsdiary;"             
	strConnect7 = strConnect7&"Password=dnlemfkdls715)@*@;"             
	strConnect7 = strConnect7&"Initial Catalog=SD_RookieTennis;"

%>