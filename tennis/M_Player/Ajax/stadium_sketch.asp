<!--#include file="../Library/ajax_config.asp"-->
<%
	'Check_Login()
	    
  
  Dim iUserName, iBirthday, iTeamNm, iTall, iLevelName, iBloodType, iPhotoPath, iUserEnName,GameTitleIDX,r_TeamGbIDX,top_index
  GameTitleIDX = request("GameTitleIDX")
  r_TeamGbIDX	 = request("r_TeamGbIDX")
  top_index		 = request("top_index")
  	' Response.write top_index

  If Top_index = "undefined" Then
	Top_index = 3
  End If
  'Response.write Top_index&"<br>"
  'Response.End 
  'iSportsGb = "judo"
  'Response.write top_index&"<br>"
   CSQL =  "   exec SD_tennis.dbo.Stadium_Sketch_list @GameTitleIDX ='"&GameTitleIDX&"',@TeamGbIDX='"&r_TeamGbIDX&"',@Top_index='"&top_index&"'	"
	
 ' LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&CSQL&"<br>"
	'response.End
	'Response.write CSQL
	'Response.End 
  Set CRs = DBCon4.Execute(CSQL)

  FormData = FormData & "<ul id='DP_ImgList'>"

  If Not (CRs.Eof Or CRs.Bof) Then
		Do Until CRs.Eof
			 idx			= CRs("idx")
			 Sketch_idx		= CRs("Sketch_idx")
			 photo			= CRs("photo")
			
			 FormData = FormData & "<li>"
			' FormData = FormData & "<a href='javascript:sketch_download("""&photo&""","""&"/tennis/m_player/upload/sketch"&""");'>"
			 FormData = FormData & "<img src='http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/"&photo&"' id='img_code_"&idx&"' >"
			' FormData = FormData & "</a>"

			 FormData = FormData & "</li><BR>"
		'Response.write idx&"<br>"
		'Response.write Sketch_idx&"<br>"
		'Response.write photo&"<br>"
		CRs.MoveNext
		Loop
  else
    
  End If
	
  FormData = FormData & "</ul>"

  CRs.close

  DBClose4()
	
  response.Write FormData
%>