<!--#include file="../Library/ajax_config.asp"-->
<%
	'=====================================================================================
	'대회참가신청 목록 조회페이지
	'=====================================================================================
	dim BlockPage     	: BlockPage     = 10  '페이지
	dim B_PSize       	: B_PSize       = 15  '페이지내 보여지는 목록카운트
	
	dim currPage        : currPage      = fInject(Request("currPage"))
	dim Fnd_GameTitle   : Fnd_GameTitle = fInject(Request("Fnd_GameTitle"))
	dim Fnd_TeamGb      : Fnd_TeamGb    = fInject(Request("Fnd_TeamGb"))
	dim Fnd_KeyWord     : Fnd_KeyWord   = fInject(Request("Fnd_KeyWord"))
	dim SportsGb      	: SportsGb      = "tennis"
	
	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3
	dim FndData     '참가신청 조회 데이터
	dim CStrPG      '페이지
	dim cnt         '카운트      
	
	
	
	IF Len(currPage) = 0 Then currPage = 1
	
	IF Fnd_GameTitle <> "" Then CSearch = " AND R.GameTitleIDX = '"&Fnd_GameTitle&"' "  '대회명 조회
	IF Fnd_TeamGb <> "" Then  CSearch2 = " AND R.Level = '"&Fnd_TeamGb&"' "   '대회참가종목 조회
	IF Fnd_KeyWord <> "" Then CSearch3 = " AND (R.UserName like '%"&Fnd_KeyWord&"%' OR R.P1_Username like '%"&Fnd_KeyWord&"%' OR R.P2_Username like '%"&Fnd_KeyWord&"%') "  '신청자, 참가자1,2 이름 조회
	
	
	CSQL =        " SELECT COUNT(*) "
	CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] R  "
	CSQL = CSQL & "   left join [SD_Tennis].[dbo].[sd_TennisTitle] G on R.GameTitleIDX = G.GameTitleIDX AND G.DelYN = 'N' AND G.SportsGb = '"&SportsGb&"' AND G.ViewYN = 'Y' " 
	CSQL = CSQL & "   left join [SD_Tennis].[dbo].[tblLevelInfo] L on R.Level = L.Level AND L.DelYN = 'N' AND L.SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "   left join [SD_Tennis].[dbo].[tblTeamGbInfo] T on L.TeamGb = T.TeamGb AND T.DelYN = 'N' AND  T.SportsGb = '"&SportsGb&"' " 
	CSQL = CSQL & " WHERE R.DelYN = 'N' " 
	CSQL = CSQL & "     AND R.SportsGb = '"&SportsGb&"' "&CSearch&CSearch2&CSearch3
	
	' response.Write "CSQL="&CSQL&"<br>"
	
	SET CRs = DBcon.Execute(CSQL) 
		TotalCount = CRs(0)
		TotalPage = CRs(1)
	
	
	CSQL =        " SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "     G.GameTitleName GameTitleName"  
	CSQL = CSQL & "     ,L.LevelNm LevelNm" 
	CSQL = CSQL & "     ,R.RequestIDX" 
	CSQL = CSQL & "     ,R.P1_UserName" 
	CSQL = CSQL & "     ,R.P1_TeamNm" 
	CSQL = CSQL & "     ,R.P1_TeamNm2"
	CSQL = CSQL & "     ,R.P2_UserName"   
	CSQL = CSQL & "     ,R.P2_TeamNm"   
	CSQL = CSQL & "     ,R.P2_TeamNm2"  
	CSQL = CSQL & "     ,T.TeamGbNm TeamGbNm"   
	CSQL = CSQL & "     ,P.PubName PubName"   
	CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] R " 
	CSQL = CSQL & "   left join [SD_Tennis].[dbo].[sd_TennisTitle] G on R.GameTitleIDX = G.GameTitleIDX AND G.DelYN = 'N' AND G.SportsGb = '"&SportsGb&"' AND G.ViewYN = 'Y' " 
	CSQL = CSQL & "   left join [SD_Tennis].[dbo].[tblLevelInfo] L on R.Level = L.Level AND L.DelYN = 'N' AND L.SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "   left join [SD_Tennis].[dbo].[tblTeamGbInfo] T on L.TeamGb = T.TeamGb AND T.DelYN = 'N' AND  T.SportsGb = '"&SportsGb&"' "  
	CSQL = CSQL & "   left join [SD_Tennis].[dbo].[tblPubCode] P on G.GameTitleLevel = P.PubCode AND P.DelYN = 'N' AND  P.SportsGb = '"&SportsGb&"' "  
	CSQL = CSQL & " WHERE R.DelYN = 'N' " 
	CSQL = CSQL & "     AND R.SportsGb = '"&SportsGb&"' "&CSearch&CSearch2&CSearch3  
	CSQL = CSQL & " ORDER BY R.WriteDate DESC"    
	
	' response.Write "CSQL="&CSQL&"<br>"
	
	SET CRs = DBcon.Execute(CSQL)
	IF Not(CRs.Eof Or CRs.Bof) Then 
		CRs.Move (currPage - 1) * B_PSize
		
		Do Until CRs.eof
			cnt = cnt + 1
			
			FndData = FndData & "<tr>"
			FndData = FndData & "  <td><a href='.conf_pw' data-toggle='modal' data-title='"&encode(CRs("RequestIDX"), 0)&"' class='cut_ellip'>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</a></td>"
			FndData = FndData & "  <td><a href='.conf_pw' data-toggle='modal' data-title='"&encode(CRs("RequestIDX"), 0)&"' class='cut_ellip'>["&CRs("PubName")&"] "&CRs("GameTitleName")&"</a></td>"
			FndData = FndData & "  <td><a href='.conf_pw' data-toggle='modal' data-title='"&encode(CRs("RequestIDX"), 0)&"' class='cut_ellip'>"&CRs("TeamGbNm")&"("&CRs("LevelNm")&")</a></td>"
			FndData = FndData & "  <td><a href='.conf_pw' data-toggle='modal' data-title='"&encode(CRs("RequestIDX"), 0)&"' class='cut_ellip'>"&CRs("P1_UserName")&"</a></td>"
			FndData = FndData & "  <td><a href='.conf_pw' data-toggle='modal' data-title='"&encode(CRs("RequestIDX"), 0)&"' class='cut_ellip'>"&CRs("P1_TeamNm")
			
			IF CRs("P1_TeamNm2") <> "" Then FndData = FndData &" / " & CRs("P1_TeamNm2")
			
			FndData = FndData & " </a></td>"
			FndData = FndData & "  <td><a href='.conf_pw' data-toggle='modal' data-title='"&encode(CRs("RequestIDX"), 0)&"' class='cut_ellip'>"&CRs("P2_UserName")&"</a></td>"
			FndData = FndData & "  <td><a href='.conf_pw' data-toggle='modal' data-title='"&encode(CRs("RequestIDX"), 0)&"' class='cut_ellip'>"&CRs("P2_TeamNm")
			
			IF CRs("P2_TeamNm2") <> "" Then FndData = FndData &" / " & CRs("P2_TeamNm2")
			
			FndData = FndData & " </a></td>"
			FndData = FndData & "</tr>"
			
			CRs.movenext
		Loop  
	Else  
	
		FndData = FndData & " <tr>" 
		FndData = FndData & "   <td colspan='7'>참가신청 정보가 없습니다</td>"
		FndData = FndData & " </tr>"
	
	End IF  
	
		CRs.Close
	SET CRs = Nothing 
	
	
	dim intTemp
	
	
	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	
	IF intTemp = 1 Then
		CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','',1);""><i class='fa fa-backward' aria-hidden='true'></i></a></li>"
		CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','',"&currPage-1&");""><i class='fa fa-caret-left' aria-hidden='true'></i></a></li>"
	Else 
		CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','',1);""><i class='fa fa-backward' aria-hidden='true'></i></a></li>"
		CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','','"&currPage-1&"');""><i class='fa fa-caret-left' aria-hidden='true'></i></a></li>"
	End If  
	
	dim intLoop : intLoop = 1
	
	Do Until intLoop > BlockPage Or intTemp > TotalPage
	
		If intTemp = CInt(currPage) Then
			CStrPG = CStrPG & "<li><a href='#' class='on'>"&intTemp&"</a></li>" 
		Else
			CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','','"&intTemp&"');"">"&intTemp&"</a></li>"
		End If
		
		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop
	
	IF intTemp > TotalPage Then
		
		IF cint(TotalPage) > cint(currPage) Then
		
			CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','','"&currPage+1&"');""><i class='fa fa-caret-right' aria-hidden='true'></i></a></li>"
		Else
			CStrPG = CStrPG & "<li><a href=""#""><i class='fa fa-caret-right' aria-hidden='true'></i></a></li>"
		End IF
			
		CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','','"&TotalPage&"');""><i class='fa fa-forward' aria-hidden='true'></i></a></li>"
	Else
		
		CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','','"&currPage+1&"');"" ><i class='fa fa-caret-right' aria-hidden='true'></i></a></li>"
		CStrPG = CStrPG & "<li><a href=""javascript:CHK_OnSubmit('LIST','','"&TotalPage&"');""><i class='fa fa-forward' aria-hidden='true'></i></a></li>"
	End IF  
	
	
	
	response.Write FndData&"|"&CStrPG
	
	DBClose()

%>