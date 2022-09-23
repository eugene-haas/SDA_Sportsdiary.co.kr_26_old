<!--#include file="../Library/ajax_config.asp"-->
<%
	'Check_Login()  
  Dim GameTitleIDX
  GameTitleIDX = request("GameTitleIDX")
  sitegubun = request("sitegubun")

  If sitegubun = "S" Then
  CSQL =  "   exec SD_RookieTennis.dbo.Stadium_Sketch_cnt_view @GameTitleIDX ='"&GameTitleIDX&"'"
  else
  CSQL =  "   exec SD_tennis.dbo.Stadium_Sketch_cnt_view @GameTitleIDX ='"&GameTitleIDX&"'"
  End if

  Set CRs = DBcon4.Execute(CSQL)

  Response.write CRs(0)

  CRs.close

  Dbclose()

%>