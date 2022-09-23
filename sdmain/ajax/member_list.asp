<!--#include file="../Library/ajax_config.asp"-->
<%
	'회원리스트 조회
		
	dim BlockPage   : BlockPage 	= 10	'페이지
	dim B_PSize   	: B_PSize 		= 20	'페이지내 보여지는 목록카운트

	dim TotCount, TotPage
	dim CSearch, CSearch2, FndSQL, FndSQL2
	dim FndData, CStrPG, CStrTP
	dim CSQL, CRs 
    dim txt_SportsGb                                            
                                             
	dim currPage   		: currPage  		= fInject(Request("currPage"))
	dim fnd_EnterType  	: fnd_EnterType 	= fInject(Request("fnd_EnterType"))
	dim fnd_SEX   		: fnd_SEX 			= fInject(Request("fnd_SEX"))	
	dim fnd_PlayerReln	: fnd_PlayerReln	= fInject(Request("fnd_PlayerReln"))
	dim fnd_SportsGb	: fnd_SportsGb		= fInject(Request("fnd_SportsGb"))

	dim cnt			    : cnt               = 0			'카운트			
    dim CHK_PushGb      : CHK_PushGb        = "Y"               'Default Value 푸시수신동의 한 경우
	

	IF Len(currPage) = 0 Then currPage = 1
    IF fnd_SportsGb = "" Then fnd_SportsGb = "SD"
    IF fnd_SEX <> "" Then CSearch = " AND SEX = '"&fnd_SEX&"'"

    IF fnd_SportsGb <> "SD" Then
        IF fnd_EnterType <> "" Then FndSQL = " AND EnterType = '"&fnd_EnterType&"'"	

        '회원구분 조회
        IF fnd_PlayerReln <> "" Then	
            SELECT CASE fnd_PlayerReln
                CASE "P"
                    FndSQL2 = " AND PlayerReln IN('A','B','Z')"
                CASE "R"
                    FndSQL2 = " AND PlayerReln IN('R','K','S')"	
                CASE ELSE
                    FndSQL2 = " AND PlayerReln IN('"&fnd_PlayerReln&"')"	
            END SELECT		
        End IF	
    End IF


    SELECT CASE fnd_SportsGb
        CASE "SD"            
            txt_SportsGb = "통합회원"
        CASE "judo"
            txt_SportsGb = "유도"

            CSearch2 = CSearch2 & " AND UserID IN ("
            CSearch2 = CSearch2 & "     SELECT SD_UserID"
            CSearch2 = CSearch2 & "     FROM [SD_JUDO].[Sportsdiary].[dbo].[tblMember]"
            CSearch2 = CSearch2 & "     WHERE DelYN = 'N'"&FndSQL&FndSQL2
            CSearch2 = CSearch2 & "     GROUP BY SD_UserID"
            CSearch2 = CSearch2 & " ) "
                
        CASE "tennis"
            txt_SportsGb = "테니스"

            CSearch2 = CSearch2 & " AND UserID IN ("
            CSearch2 = CSearch2 & "     SELECT SD_UserID"
            CSearch2 = CSearch2 & "     FROM [SD_Tennis].[dbo].[tblMember]"
            CSearch2 = CSearch2 & "     WHERE DelYN = 'N'"&FndSQL&FndSQL2
            CSearch2 = CSearch2 & "     GROUP BY SD_UserID"
            CSearch2 = CSearch2 & " ) "

        CASE "bike"
            txt_SportsGb = "자전거"

            CSearch2 = CSearch2 & " AND UserID IN ("
            CSearch2 = CSearch2 & "     SELECT SD_UserID"
            CSearch2 = CSearch2 & "     FROM [SD_Bike].[dbo].[tblMember]"
            CSearch2 = CSearch2 & "     WHERE DelYN = 'N'"&FndSQL&FndSQL2
            CSearch2 = CSearch2 & "     GROUP BY SD_UserID"
            CSearch2 = CSearch2 & " ) "
    END SELECT

    
    FndData = "			 <table class='table-list member-info'>"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>번호</th>"
	FndData = FndData & "			<th>구분</th>"
	FndData = FndData & "			<th>아이디</th>"
	FndData = FndData & "			<th>이름</th>"
    FndData = FndData & "			<th>성별</th>"    
	FndData = FndData & "			<th>SMS수신</th>"
	FndData = FndData & "			<th>이메일수신</th>"
	FndData = FndData & "			<th>푸시수신</th>"
	FndData = FndData & "		</tr>"
	FndData = FndData & "	</thead>"
	FndData = FndData & "	<tbody>"
	
	
	CSQL = " 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
    CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "    
	CSQL = CSQL & " WHERE DelYN = 'N' "
    CSQL = CSQL & "     AND PushYN = '"&CHK_PushGb&"'"&CSearch&CSearch2

	SET CRs = DBCon3.Execute(CSQL)	
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
	
	CStrTP = "<div><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
	
	response.Write CStrTP
	
	CSQL = "        SELECT X.*"
    CSQL = CSQL & " FROM ("
	CSQL = CSQL & "	    SELECT (ROW_NUMBER() OVER(ORDER BY UserID, UserName)) num"   
    CSQL = CSQL & "	    	,UserID "    
	CSQL = CSQL & "	    	,UserName "
    CSQL = CSQL & "	    	,CASE Sex WHEN 'Man' THEN '남' WHEN 'WoMan' THEN '여' END SexNm "    
	CSQL = CSQL & "	    	,SmsYn "
	CSQL = CSQL & "	    	,EmailYn "
    CSQL = CSQL & "         ,CASE "
    CSQL = CSQL & "        		WHEN PushYN IS NULL OR PushYN = '' THEN '미설정' "
    CSQL = CSQL & "        		ELSE PushYN "
    CSQL = CSQL & "        		END PushYNNm "
    CSQL = CSQL & "     FROM [SD_Member].[dbo].[tblMember] "
	CSQL = CSQL & "     WHERE DelYN = 'N' "
    CSQL = CSQL & "         AND PushYN = '"&CHK_PushGb&"'"&CSearch&CSearch2
    CSQL = CSQL & " ) X"
    CSQL = CSQL & " WHERE X.num BETWEEN "&((currPage-1)*B_PSize + 1)&" AND "&currPage * B_PSize
	CSQL = CSQL & "	ORDER BY X.num"	
    
	SET CRs = DBCon3.Execute(CSQL)	
	If Not(CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.eof

			cnt = cnt + 1
			
			FndData = FndData & "<tr>"
			FndData = FndData & "	<td>"&formatnumber((totalcount - (currPage - 1) * B_Psize - cnt+1), 0)&"</td>"
			FndData = FndData & "	<td>"&txt_SportsGb&"</td>"
			FndData = FndData & "	<td>"&CRs("UserID")&"</td>"
			FndData = FndData & "	<td>"&CRs("UserName")&"</td>"
			FndData = FndData & "	<td>"&CRs("SexNm")&"</td>"					
			FndData = FndData & "	<td>"&CRs("SmsYn")&"</td>"
			FndData = FndData & "	<td>"&CRs("EmailYn")&"</td>"
			FndData = FndData & "	<td>"&CRs("PushYNNm")&"</td>"
			FndData = FndData & "</tr>"

			CRs.movenext
		Loop	
	ELSE
		FndData = FndData & "<tr>"
		FndData = FndData & "	<td colspan=8>등록된 정보가 없습니다.</td>"	
		FndData = FndData & "</tr>"
	End IF	
	
	FndData = FndData & "	</tbody>"
	FndData = FndData & "</table>"
	
		CRs.Close
	SET CRs = Nothing
		
	response.Write FndData
	
	
	dim intTemp

	CStrPG = CStrPG & " <div class='bullet-wrap'>"
	CStrPG = CStrPG & " <div class='board-bullet pagination'>"
	
	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	
	If intTemp = 1 Then
		
	Else 
		CStrPG = CStrPG & "<li class='prev'> <a href=""javascript:chk_Submit('"&intTemp - BlockPage&"');"" class='prev fa fa-angle-left'></a></li> "
	End If	
	
	dim intLoop : intLoop = 1
	
	Do Until intLoop > BlockPage Or intTemp > TotalPage
	
		If CInt(intTemp) = CInt(currPage) Then
			CStrPG = CStrPG & "<li> <a href='#' class=""on"">"&intTemp&"</a> </li>" 
		Else
			CStrPG = CStrPG & "<li> <a href=""javascript:chk_Submit('"&intTemp&"');"">"&intTemp&"</a> </li>"
		End If
		
		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop
	
	IF intTemp > TotalPage Then

	Else
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&intTemp&"');"" class='next fa fa-angle-right'></a></li>"
	End IF	
  
    CStrPG = CStrPG & "</div>"
    CStrPG = CStrPG & "</div>"
	
	response.Write CStrPG

	
	DBClose3()
  
%>