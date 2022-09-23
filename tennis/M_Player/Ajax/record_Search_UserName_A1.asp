<!--#include file="../Library/ajax_config.asp"-->
<%
	Dim Search_NewTeamGbName, fnd_KeyWord 
	'iLoginID = Request.Cookies("UserID")
	'iLoginID = decode(iLoginID,0)
	Search_NewTeamGbName = Request("Search_NewTeamGbName")
	fnd_KeyWord 	= Request("fnd_KeyWord")
    LSQL ="Search_TennisRPing_log_RankingList_02 '2','"&Search_NewTeamGbName&"','"&fnd_KeyWord&"'" 
	Set LRs = DBCon4.Execute(LSQL)
	If Not(LRs.Eof or LRs.Bof) then 
	Do until LRs.Eof 
%> 
		 <button class="m_searchPopup__listname">
		   <%=LRs("playerIDX")%>:<%= LRs("username")%> (<%=LRs("TeamNm")%>,<%=LRs("Team2Nm")%>)  
		 </button>
 <%
		  LRs.MoveNext 
		Loop
	 End if 
	 LRs.close()
	 DBClose4()
 %>