<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'대회목록페이지
	'===============================================================================================
	dim currPage        : currPage      = fInject(Request("currPage"))
	dim Fnd_KeyWord     : Fnd_KeyWord   = fInject(Request("Fnd_KeyWord"))
	
	
	dim BlockPage     : BlockPage     = 10  '페이지
	dim B_PSize       : B_PSize       = 15  '페이지내 보여지는 목록카운트
	dim SportsGb      : SportsGb      = "tennis"    '테니스
	dim EnterType     : EnterType     = "A"     '생활체육
	
	dim TotCount, TotPage
	dim CSearch     '검색조건
	dim FndData     '대회목록
	dim CStrPG      '페이징
	dim cnt           '카운트      
	
	IF Len(currPage) = 0 Then currPage = 1
	
	IF Fnd_KeyWord <> "" Then CSearch = " AND GameTitleName like '%"&Fnd_KeyWord&"%' "  
	
	
	CSQL =    "   	SELECT COUNT(*) "
	CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [SD_Tennis].[dbo].[sd_TennisTitle] " 
	CSQL = CSQL & " WHERE DelYN = 'N' " 
	CSQL = CSQL & "   AND ViewYN = 'Y' "
	CSQL = CSQL & "   AND EnterType = '"&EnterType&"' "&CSearch
	
	' response.Write "CSQL="&CSQL&"<br>"
	
	SET CRs = Dbcon.Execute(CSQL) 
		TotalCount = CRs(0)
		TotalPage = CRs(1)
	
	
	CSQL =      " 	SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "   	G.GameTitleIDX "  
	CSQL = CSQL & "   	,G.GameTitleName "  
	CSQL = CSQL & "   	,G.GameS " 
	CSQL = CSQL & "   	,G.GameE " 
	CSQL = CSQL & "   	,G.GameArea " 
' 	CSQL = CSQL & "   	,G.Sido " 
	CSQL = CSQL & "   	,G.GameRcvDateS " 
	CSQL = CSQL & "   	,G.GameRcvDateE " 
	CSQL = CSQL & "   	,P.PubName PubName"
	CSQL = CSQL & "		,CASE "
	CSQL = CSQL & "			WHEN DATEDIFF(d, CONVERT(DATE, G.GameRcvDateS), GETDATE())>=0 and DATEDIFF(d, GETDATE(), CONVERT(DATE, G.GameRcvDateE))>=0 THEN '참가신청' "
	CSQL = CSQL & "			WHEN DATEDIFF(d, CONVERT(DATE, G.GameRcvDateS), GETDATE())<0 THEN '-' "
	CSQL = CSQL & "			WHEN DATEDIFF(d, GETDATE(), CONVERT(DATE, G.GameRcvDateE))<0 THEN '신청마감'"
	CSQL = CSQL & "		 END reqStateText "
	CSQL = CSQL & "		,CASE WHEN DATEDIFF(d, CONVERT(DATE, G.GameRcvDateS), GETDATE())>=0 and DATEDIFF(d, GETDATE(), CONVERT(DATE, G.GameRcvDateE))>=0 THEN '0' Else '1' END reqState "
	CSQL = CSQL & "		,DATEDIFF(d, CONVERT(DATE, G.GameS), GETDATE()) reqStateValue  "
	CSQL = CSQL & "		,DATEDIFF(d, CONVERT(DATE, G.GameRcvDateS), GETDATE()) reqStateValueOn  "
	CSQL = CSQL & " FROM [SD_Tennis].[dbo].[sd_TennisTitle] G " 
	CSQL = CSQL & "   	left join [SD_Tennis].[dbo].[tblPubCode] P on G.GameTitleLevel = P.PubCode "
	CSQL = CSQL & "     	AND P.DelYN = 'N' "
' 	CSQL = CSQL & "     	AND P.SportsGb = '"&SportsGb&"' "  
	CSQL = CSQL & " WHERE G.DelYN = 'N' " 
 	CSQL = CSQL & "   	AND G.ViewYN = 'Y' "
	CSQL = CSQL & "   	AND G.EnterType = '"&EnterType&"' "&CSearch
	CSQL = CSQL & " ORDER BY reqState, reqStateValueOn, reqStateValue, G.GameRcvDateS"
	' response.Write "ChkSQL="&CSQL&"<br>"
	
	SET CRs = Dbcon.Execute(CSQL)
	IF Not(CRs.Eof Or CRs.Bof) Then 
		CRs.Move (currPage - 1) * B_PSize
	
		Do Until CRs.eof
			cnt = cnt + 1
			
			FndData = FndData & "<tr>"
			FndData = FndData & "  <td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
			FndData = FndData & "  <td>["&CRs("PubName")&"] "&CRs("GameTitleName")&"</td>"
			FndData = FndData & "  <td>"&CRs("GameRcvDateS")&"~"&CRs("GameRcvDateE")&"</td>"
			
			IF CRs("reqState") = "0" Then
				FndData = FndData & " <td><a href=""javascript:CHK_OnSubmit('WR','"&CRs("GameTitleIDX")&"','"&currPage&"');"" class='btn btn_green'>참가신청</a></td>"   
			Else
				FndData = FndData & " <td>"&CRs("reqStateText")&"</td>"   
			End IF
			
			FndData = FndData & "</tr>"
			
			CRs.movenext
		Loop  
	Else  
		FndData = FndData & " <tr>" 
		FndData = FndData & "   <td colspan='4'>대회정보가 없습니다</td>"
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