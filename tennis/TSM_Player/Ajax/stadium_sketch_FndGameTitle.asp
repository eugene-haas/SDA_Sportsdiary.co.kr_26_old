<!--#include file="../Library/ajax_config.asp"-->
<%
	'Check_Login()

  dim GameTitleIDX 		: GameTitleIDX   	= fInject(trim(Request("GameTitleIDX")))
  dim SiteGubun : SiteGubun = fInject(request("SiteGubun")) 'SD랭킹테니스인지 구분

	dim LSQL, LRs


	If GameTitleIDX = "" Then
		Response.Write "FALSE|200"
		Response.End
	Else

		LSQL = "        SELECT GameTitleName"
		If SiteGubun = "S" then
		LSQL = LSQL & " FROM SD_RookieTennis.dbo.sd_TennisTitle"
		Else
		LSQL = LSQL & " FROM sd_TennisTitle"
		End if
		LSQL = LSQL & " WHERE DelYN = 'N'"
		LSQL = LSQL & "   AND GameTitleIDX = '" & GameTitleIDX & "'"
		SET LRs = DBCon4.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then
		    Response.Write "TRUE|"&LRs("GameTitleName")&""
		Else
			Response.Write "FALSE|99"
		End IF
			LRs.Close
		SET LRs = Nothing

    DBClose4()
	End If

%>
