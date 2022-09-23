<!--#include file="../Library/ajax_config.asp"-->
<%
	'Check_Login()
  
  Dim GameTitleIDX

	GameTitleIDX = request("GameTitleIDX")
	r_TeamGbIDX	 = request("r_TeamGbIDX")
    dim SiteGubun : SiteGubun = fInject(request("SiteGubun")) 'SD랭킹테니스인지 구분

	If SiteGubun = "S" then
	CSQL =  "   exec SD_RookieTennis.dbo.Stadium_Sketch_select_list @GameTitleIDX = '"&GameTitleIDX&"'"
	Else
	CSQL =  "   exec Stadium_Sketch_select_list @GameTitleIDX = '"&GameTitleIDX&"'"
	End if
  SET CRs = DBCon4.Execute(CSQL)

  'FormData = FormData & "<select id='TeamGb' onchange='change_teamgb(this);'>"
  'FormData = FormData & "<option value=''>선택해주시기 바랍니다.</option>	"

  FormData = FormData & ""

  If Not (CRs.Eof Or CRs.Bof) Then
		Do Until CRs.Eof
			 TeamGbIDX			= CRs("TeamGbIDX")
			 TeamGbNm			= CRs("TeamGbNm")
				
				If Cstr(r_TeamGbIDX) = Cstr(TeamGbIDX) Then 
					FormData = FormData & "<option value='"&TeamGbIDX&"' selected >"& TeamGbNm &"</option>	"
				Else
					FormData = FormData & "<option value='"&TeamGbIDX&"'  >"& TeamGbNm &"</option>	"
				End If 
		CRs.MoveNext
		Loop
  'FormData = FormData & "</select>"
  
  else
    
  End If

  CRs.close

  DBClose4()


  response.Write FormData

%>