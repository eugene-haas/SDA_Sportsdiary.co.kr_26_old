<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq        = fInject(request("seq"))		
	
	LSQL = "SELECT "
	LSQL = LSQL&" GameGb"
	LSQL = LSQL&" ,SportsGb"
	LSQL = LSQL&" ,GameYear "
	LSQL = LSQL&" ,GameTitleName "
	LSQL = LSQL&" ,Sido "
	LSQL = LSQL&" ,isnull(SidoDtl,'') AS SidoDtl"
	LSQL = LSQL&" ,Left(GameS,4)  AS GameS_Year"
	LSQL = LSQL&" ,SubString(GameS,6,2)  AS GameS_Month"
	LSQL = LSQL&" ,SubString(GameS,9,2)  AS GameS_Day"
	LSQL = LSQL&" ,Left(GameE,4)  AS GameE_Year"
	LSQL = LSQL&" ,SubString(GameE,6,2)  AS GameE_Month"
	LSQL = LSQL&" ,SubString(GameE,9,2)  AS GameE_Day"
	LSQL = LSQL&" ,GameArea "	
	LSQL = LSQL&" ,Left(GameRcvDateS,4)  AS GameRcv_SYear"
	LSQL = LSQL&" ,SubString(GameRcvDateS,6,2)  AS GameRcv_SMonth"
	LSQL = LSQL&" ,SubString(GameRcvDateS,9,2)  AS GameRcv_SDay"
	LSQL = LSQL&" ,Left(GameRcvDateE,4)  AS GameRcv_EYear"
	LSQL = LSQL&" ,SubString(GameRcvDateE,6,2)  AS GameRcv_EMonth"
	LSQL = LSQL&" ,SubString(GameRcvDateE,9,2)  AS GameRcv_EDay"
	LSQL = LSQL&" ,EnterType"
	LSQL = LSQL&" ,HostCode"
	LSQL = LSQL&" ,ViewYN"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblGameTitle "
	LSQL = LSQL&" WHERE GameTitleIDX='"&seq&"'"
	
'	Response.Write LSQL
'	Response.End
	
  DBOpen()
	Set LRs =  DBCon.execute(LSQL)	
	DBClose()
%>

<%If LRs.bof and LRs.eof Then %>
		null
<%Else%>		
<%	Do until LRs.EOF	%>		
   <%=LRs("GameGb")%>|><%=LRs("SportsGb")%>|><%=LRs("GameYear")%>|><%=LRs("GameTitleName")%>|><%=LRs("Sido")%>|><%=LRs("SidoDtl")%>|><%=LRs("GameS_Year")%>|><%=LRs("GameS_Month")%>|><%=LRs("GameS_Day")%>|><%=LRs("GameE_Year")%>|><%=LRs("GameE_Month")%>|><%=LRs("GameE_Day")%>|><%=LRs("GameArea")%>|><%=LRs("GameRcv_SYear")%>|><%=LRs("GameRcv_SMonth")%>|><%=LRs("GameRcv_SDay")%>|><%=LRs("GameRcv_EYear")%>|><%=LRs("GameRcv_EMonth")%>|><%=LRs("GameRcv_EDay")%>|><%=LRs("EnterType")%>|><%=LRs("HostCode")%>|><%=LRs("ViewYN")%>
	
	 <%
			'Response.End
			LRs.MoveNext
		Loop
	end if
%>
	
<% LRs.Close
   Set LRs = Nothing  
%>
