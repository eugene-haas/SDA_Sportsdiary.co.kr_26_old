<%
	'###### S: DB Connection String ######

	strConnect = strConnect & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConnect = strConnect & "Data Source=49.247.9.88;"
	strConnect = strConnect & "User ID=Korbm;"
	strConnect = strConnect & "Password=qoemalsxjs;"
	strConnect = strConnect & "Initial Catalog=KoreaBadminton;"

	strConBK = strConBK & "Provider=SQLOLEDB.1;Persist Security Info=True;"
	strConBK = strConBK & "Data Source=49.247.9.88;"
	strConBK = strConBK & "User ID=KorBadmin;"
	strConBK = strConBK & "Password=dkzniuqjza831!$;"
	strConBK = strConBK & "Initial Catalog=Bad_Korea_BAK;"

  strConTEST = strConTEST & "Provider=SQLOLEDB.1;Persist Security Info=True;"
  strConTEST = strConTEST & "Data Source=49.247.9.88;"
  strConTEST = strConTEST & "User ID=KorbadtestUser;"
  strConTEST = strConTEST & "Password=TestUser!@#KorBadminton;"
  strConTEST = strConTEST & "Initial Catalog=koreaTEST1;" 

	'###### E: DB Connection String ######
%>
