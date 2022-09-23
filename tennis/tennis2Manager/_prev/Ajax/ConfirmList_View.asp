<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	GameTitleIDX   = fInject(Request("GameTitleIDX"))
	Search_TeamNm  = fInject(Request("Search_TeamNm"))
	If GameTitleIDX = "" Then 
		Response.Write "null"
		Response.End
	End If 

	LSQL = "SELECT distinct(Team),Case When Sex ='Man' Then '남성' When Sex = 'WoMan' Then '여성' End AS Sex ,Principal,Sportsdiary.dbo.FN_TeamNM('judo',TeamGb,Team) AS TeamNm "
	LSQL = LSQL&" FROM Sportsdiary.dbo.tblGameRequest "
	LSQL = LSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" AND ( "
	LSQL = LSQL&" TeamGb='11001' OR TeamGb='11002' "
	LSQL = LSQL&" OR TeamGb='21001' OR TeamGb='21002' "
	LSQL = LSQL&" OR TeamGb='31001' OR TeamGb='31002' "
	LSQL = LSQL&" )"
	If Search_TeamNm <> "" Then 
		LSQL = LSQL&" Sportsdiary.dbo.FN_TeamNM('judo',TeamGb,Team) "
	End If 
	LSQL = LSQL&" AND ISNULL(Principal,'') <>''"

	LSQL = LSQL&" ORDER BY Sportsdiary.dbo.FN_TeamNM('judo',TeamGb,Team) ASC "
	

	'Response.Write LSQL
	'Response.End
	Set LRs = Dbcon.Execute(LSQL)
	
	CSQL = "SELECT Count(distinct(Team)) AS Cnt"
	CSQL = CSQL&" FROM Sportsdiary.dbo.tblGameRequest "
	CSQL = CSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
	CSQL = CSQL&" AND DelYN='N'"
	CSQL = CSQL&" AND ( "
	CSQL = CSQL&" TeamGb='11001' OR TeamGb='11002' "
	CSQL = CSQL&" OR TeamGb='21001' OR TeamGb='21002' "
	CSQL = CSQL&" OR TeamGb='31001' OR TeamGb='31002' "
	CSQL = CSQL&" )"
	If Search_TeamNm <> "" Then 
		CSQL = CSQL&" Sportsdiary.dbo.FN_TeamNM('judo',TeamGb,Team) "
	End If 
'	Response.Write LSQL
	Set CRs = Dbcon.Execute(CSQL)
	Cnt = CRs("Cnt")
	If Cnt = 0 Then 
		Cnt = "null"
	End If 

	Response.Write Cnt&"ㅹ"
	
	If Not(LRs.Eof Or LRs.Bof) Then 
		i = 1
		Do Until LRs.Eof 
%>
		<tr>
			<th scope="col"><%=i%></th>
			<th scope="col"><%=LRs("TeamNm")%></th>
			<th scope="col"><%=LRs("Sex")%></th>
			<th scope="col"><%If LRs("Principal") <>"" Then %>첨부<%Else%>미첨부<%End If%></th>
			<th scope="col"><a href="javascript:down_data('<%=LRs("Principal")%>')"><%=LRs("Principal")%></a></th>
		</tr>
<%			
			i = i + 1
			LRs.MoveNext
		Loop 
	Else
		Response.Write "null"
		
	End If 

	 LRs.Close
   Set LRs = Nothing
   
   CRs.Close
   Set CRs = Nothing

	Dbclose()
%>