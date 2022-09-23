<!--#include file="../dev/dist/config.asp"-->
<%
	'통합 회원리스트 조회
		
	dim BlockPage       : BlockPage 	    = 10	'페이지
	dim B_PSize   	    : B_PSize 		    = 20	'페이지내 보여지는 목록카운트	
    dim cnt			    : cnt               = 0	    '카운트			
	dim currPage   		: currPage  		= fInject(Request("currPage"))
	dim fnd_SEX   		: fnd_SEX 			= fInject(Request("fnd_SEX"))	
    dim fnd_SMS   		: fnd_SMS 			= fInject(Request("fnd_SMS"))	                                 
    dim fnd_Email   	: fnd_Email 		= fInject(Request("fnd_Email"))	                                                                  
    dim fnd_Push   		: fnd_Push 			= fInject(Request("fnd_Push"))	                                               
	dim fnd_KeyWord		: fnd_KeyWord 		= fInject(Request("fnd_KeyWord"))
	dim SDate			: SDate				= fInject(Request("SDate"))
	dim EDate			: EDate				= fInject(Request("EDate"))
	
   
	IF SDate <> "" Then SDate = replace(SDate, "/","")
	IF EDate <> "" Then EDate = replace(EDate, "/","")
	
	
	dim CSQL, CRs
    dim CSearch, CSearch2, CSearch3, CSearch4, CSearch5, CSearch6, CSearch7
    dim FndData '목록
    dim CStrPG  '페이징
    dim CStrTP  '페이지 정보
   
	IF Len(currPage) = 0 Then currPage = 1
	IF fnd_SEX <> "" Then CSearch2 = " AND A.SEX = '"&fnd_SEX&"'"

    '키워드 검색 [아이디, 이름, 생년월일, 전화번호, 이메일, 주소]
    dim search(6), i

    search(0) = "A.UserID"
    search(1) = "A.UserName"
    search(2) = "A.Birthday" 
    search(3) = "A.UserPhone" 
    search(4) = "A.Email" 
    search(5) = "A.Address" 
    search(6) = "A.AddressDtl" 

    IF fnd_KeyWord <> "" Then
        FOR i = 0 To 6
            CSearch3 = CSearch3 & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
        Next

        CSearch3 = " AND ("&mid(CSearch3, 5)&")"
    End IF
	
	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearch4 = " AND DateDiff(d, '"&SDate&"', A.WriteDate) >= 0 AND DateDiff(d, A.WriteDate, '"&EDate&"') >= 0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch4 = " AND DateDiff(d, A.WriteDate, '"&SDate&"') = 0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch4 = " AND DateDiff(d, '"&EDate&"', A.WriteDate) = 0 "
	Else
	End IF

    IF fnd_SMS <> "" Then CSearch5 = " AND A.SmsYN = '"&fnd_SMS&"'"
    IF fnd_Email <> "" Then CSearch6 = " AND A.EmailYN = '"&fnd_Email&"'"
    IF fnd_Push <> "" Then 
        IF fnd_Push = "0" Then
            CSearch7 = " AND A.PushYN = ''"    '미설정
        Else
            CSearch7 = " AND A.PushYN = '"&fnd_Push&"'"
        End IF
    End IF

    FndData = "			 <table cellspacing=""0"" cellpadding=""0"">"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>번호</th>"
	FndData = FndData & "			<th>아이디</th>"
	FndData = FndData & "			<th>이름</th>"
	FndData = FndData & "			<th>생년월일</th>"
	FndData = FndData & "			<th>성별</th>"	
	FndData = FndData & "			<th>Phone</th>"
	FndData = FndData & "			<th>이메일</th>"
    'FndData = FndData & "			<th>주소</th>"    
    FndData = FndData & "			<th>SMS수신</th>"    
	FndData = FndData & "			<th>이메일수신</th>"
    FndData = FndData & "			<th>앱알림수신</th>"        	
    FndData = FndData & "			<th>계정종목가입</th>"        	        
	FndData = FndData & "			<th>가입일</th>"
	FndData = FndData & "		</tr>"
	FndData = FndData & "	</thead>"
	FndData = FndData & "	<tbody>"
	
	dim TotCount, TotPage
        
	CSQL = " 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] A"    
	CSQL = CSQL & "	WHERE DelYN = 'N' "&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6&CSearch7

	SET CRs = DBCon8.Execute(CSQL)	
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
	    CRs.Close
        
	CStrTP = "<div class='table-page-number'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
	
    '페이지 정보 출력
	response.Write CStrTP
    
    dim MemberIDX, UserID, UserPhone, Birthday, SexNm, UserName        
    dim Email, EmailYN, SMSYN, PushStateGb, RegDate    
    dim ZipCode, Address, AddressDtl
    dim SSQL, UserJudo, UserTennis, UserBike, txt_UserType
        
    SSQL = SSQL & " ,STUFF(( "
    
	SSQL = SSQL & "        SELECT ',' + "
    SSQL = SSQL & "                CASE "
    SSQL = SSQL & "                WHEN PlayerReln IN('A','B','Z') THEN '보호자'"
    SSQL = SSQL & "                WHEN PlayerReln IN('R','K','S') THEN '선수'"
    SSQL = SSQL & "                WHEN PlayerReln IN('T') THEN '지도자'"
    SSQL = SSQL & "                WHEN PlayerReln IN('D') THEN '일반'"    
    SSQL = SSQL & "                END "
    SSQL = SSQL & "        FROM [SD_JUDO].[Sportsdiary].[dbo].[tblMember] "
    SSQL = SSQL & "        WHERE DelYN = 'N' AND A.UserID = SD_UserID "
    SSQL = SSQL & "    FOR XML PATH('')),1,1,'') UserJudo "

    SSQL = SSQL & " ,STUFF(( "
    SSQL = SSQL & "         SELECT ',' + "
    SSQL = SSQL & "                CASE "
    SSQL = SSQL & "                WHEN PlayerReln IN('A','B','Z') THEN '보호자'"
    SSQL = SSQL & "                WHEN PlayerReln IN('R') THEN '선수'"
    SSQL = SSQL & "                WHEN PlayerReln IN('T') THEN '지도자'"
    SSQL = SSQL & "                WHEN PlayerReln IN('D') THEN '일반'"        
    SSQL = SSQL & "                END "
    SSQL = SSQL & "        FROM [SD_Tennis].[dbo].[tblMember] "
    SSQL = SSQL & "        WHERE DelYN = 'N' AND A.UserID = SD_UserID "
    SSQL = SSQL & "    FOR XML PATH('')),1,1,'') UserTennis "

	SSQL = SSQL & " ,STUFF(( "
    SSQL = SSQL & "        SELECT ',' + "
    SSQL = SSQL & "                CASE "
    SSQL = SSQL & "                WHEN PlayerReln IN('A','B','Z') THEN '보호자'"
    SSQL = SSQL & "                WHEN PlayerReln IN('R') THEN '선수'"
    SSQL = SSQL & "                WHEN PlayerReln IN('T') THEN '지도자'"
    SSQL = SSQL & "                WHEN PlayerReln IN('D') THEN '일반'"        
    SSQL = SSQL & "                END "
    SSQL = SSQL & "        FROM [SD_Bike].[dbo].[tblMember] "
    SSQL = SSQL & "        WHERE DelYN = 'N' AND A.UserID = SD_UserID "
    SSQL = SSQL & "    FOR XML PATH('')),1,1,'') UserBike "
        
        
	CSQL = "        SELECT X.* "
    CSQL = CSQL & " FROM ("
    CSQL = CSQL & "	        SELECT (ROW_NUMBER() OVER(ORDER BY A.WriteDate DESC, A.UserName)) num"      
	CSQL = CSQL & "         ,A.MemberIDX "
    CSQL = CSQL & "	    	,A.UserID "
	CSQL = CSQL & "	    	,A.UserName "
	CSQL = CSQL & "	    	,A.UserPhone "
	CSQL = CSQL & "	    	,CONVERT(CHAR, CONVERT(DATE, A.Birthday), 102) Birthday "
	CSQL = CSQL & "	    	,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm "
	CSQL = CSQL & "	    	,A.Email "
    CSQL = CSQL & "	    	,A.ZipCode "    
	CSQL = CSQL & "	    	,A.Address "
	CSQL = CSQL & "	    	,A.AddressDtl "
	CSQL = CSQL & "	    	,A.EmailYN "
	CSQL = CSQL & "	    	,SMSYN "
    CSQL = CSQL & "	    	,CASE WHEN A.PushYN IS NULL OR A.PushYN = '' THEN '미설정' ELSE A.PushYN END PushStateGb "    
	CSQL = CSQL & "	    	,CONVERT(CHAR, A.WriteDate, 102) RegDate"	
'    CSQL = CSQL & SSQL    
	CSQL = CSQL & "	    FROM [SD_Member].[dbo].[tblMember] A"
	CSQL = CSQL & "	    WHERE A.DelYN = 'N' "&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6&CSearch7
    CSQL = CSQL & " ) X"
    CSQL = CSQL & " WHERE X.num BETWEEN "&((currPage-1)*B_PSize + 1)&" AND "&currPage * B_PSize
	CSQL = CSQL & "	ORDER BY X.num"	
				
'	response.Write CSQL
				
	SET CRs = DBCon8.Execute(CSQL)	
	If Not(CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.eof

			cnt = cnt + 1            
            
            MemberIDX = CRs("MemberIDX")    
            UserID = CRs("UserID")
            UserPhone = CRs("UserPhone")
            Birthday = CRs("Birthday")
            SexNm = CRs("SexNm")
            Email = CRs("Email")
            ZipCode = CRs("ZipCode")            
            EmailYN = CRs("EmailYN")
            SMSYN = CRs("SMSYN")
            PushStateGb = CRs("PushStateGb")
            RegDate = CRs("RegDate")
'            UserBike = CRs("UserBike")
'            UserTennis = CRs("UserTennis")
'            UserJudo = CRs("UserJudo")
        
            UserName = ReHtmlSpecialChars(CRs("UserName"))
            Address = ReHtmlSpecialChars(CRs("Address"))
            AddressDtl = ReHtmlSpecialChars(CRs("AddressDtl")) 

            '키워드 검색 [아이디, 이름, 생년월일, 전화번호, 이메일, 주소]        
            IF fnd_KeyWord <> "" Then
                UserID = replace(UserID, fnd_KeyWord, "<span style='color: #FF0000;'>"&fnd_KeyWord&"</span>")
                UserName = replace(UserName, fnd_KeyWord, "<span style='color: #FF0000'>"&fnd_KeyWord&"</span>")
                Birthday = replace(Birthday, fnd_KeyWord, "<span style='color: #FF0000'>"&fnd_KeyWord&"</span>")
                UserPhone = replace(UserPhone, fnd_KeyWord, "<span style='color: #FF0000'>"&fnd_KeyWord&"</span>")
                Email = replace(Email, fnd_KeyWord, "<span style='color: #FF0000'>"&fnd_KeyWord&"</span>")
                Address = replace(Address, fnd_KeyWord, "<span style='color: #FF0000'>"&fnd_KeyWord&"</span>")    
                AddressDtl = replace(AddressDtl, fnd_KeyWord, "<span style='color: #FF0000'>"&fnd_KeyWord&"</span>")    
            End IF
			
            IF UserJudo <> "" Then txt_UserType = txt_UserType & "유도["&UserJudo&"] "
            IF UserTennis <> "" Then txt_UserType = txt_UserType & "테니스["&UserTennis&"] "
            IF UserBike <> "" Then txt_UserType = txt_UserType & "자전거["&UserBike&"] "
        
        
			FndData = FndData & "<tr style=""cursor: pointer;"" onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("MemberIDX"))&"','"&currPage&"');"">"
			FndData = FndData & "	<td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
			FndData = FndData & "	<td class='left-txt'>"&UserID&"</td>"
			FndData = FndData & "	<td>"&UserName&"</td>"
			FndData = FndData & "	<td>"&Birthday&"</td>"
			FndData = FndData & "	<td>"&SexNm&"</td>"        
			FndData = FndData & "	<td>"&UserPhone&"</td>"					
			FndData = FndData & "	<td class='left-txt'>"&Email&"</td>"
            
'            IF CRs("ZipCode")<>"" Then
'                FndData = FndData & "	<td class='left-txt'>("&ZipCode&") "&Address&" "&AddressDtl&"</td>"
'            Else        
'                FndData = FndData & "	<td class='left-txt'>"&Address&" "&AddressDtl&"</td>"
'            End IF
        
			FndData = FndData & "	<td>"&SMSYN&"</td>"
			FndData = FndData & "	<td>"&EmailYN&"</td>"
			FndData = FndData & "	<td>"&PushStateGb&"</td>"
            FndData = FndData & "	<td class='left-txt'>"&txt_UserType&"</td>"
			FndData = FndData & "	<td>"&RegDate&"</td>"
			FndData = FndData & "</tr>"
        
            txt_UserType = ""
        
			CRs.movenext
		Loop	
	ELSE
		FndData = FndData & "<tr>"
		FndData = FndData & "	<td colspan=12>등록된 정보가 없습니다.</td>"	
		FndData = FndData & "</tr>"
	End IF	
	
	FndData = FndData & "	</tbody>"
	FndData = FndData & "</table>"
	
		CRs.Close
	SET CRs = Nothing
		
    '목록 출력
	response.Write FndData
	
	
    '페이징
	dim intTemp


	CStrPG = CStrPG & " <div class='paging'>"
	
	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	
	If intTemp = 1 Then
		IF currPage = 1 Then
          CStrPG = CStrPG & "<a href=""#"" class=""icon-btn""><i class=""fas fa-angle-double-left""></i></a>"
          CStrPG = CStrPG & "<a href=""#"" class=""icon-btn""><i class=""fas fa-angle-left""></i></a>"
        Else
          CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','',1);""><i class=""fas fa-angle-double-left""></i></a>"
          CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','','"&currPage-1&"');"" class=""icon-btn""><i class=""fas fa-angle-left""></i></a>"
        End IF
	Else 
        CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','',1);"" class=""icon-btn""><i class=""fas fa-angle-double-left""></i></a>"
        CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','','"&intTemp - BlockPage&"');"" class=""icon-btn""><i class=""fas fa-angle-left""></i></a>"
	End If	
	
	dim intLoop : intLoop = 1
	
	Do Until intLoop > BlockPage Or intTemp > TotalPage
	
		If CInt(intTemp) = CInt(currPage) Then
			CStrPG = CStrPG & "<a href=""#"" class=""active""><span>"&intTemp&"</span></a>" 
		Else
			CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','','"&intTemp&"');""><span>"&intTemp&"</span></a>"
		End If
		
		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop
	
	IF intTemp > TotalPage Then
        IF cint(currPage) < cint(TotalPage) Then
          CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','','"&currPage+1&"');"" class=""icon-btn""><i class=""fas fa-angle-right""></i></a>"
          CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','','"&TotalPage&"');"" class=""icon-btn""><i class=""fas fa-angle-double-right""></i></a>"
        Else
          CStrPG = CStrPG & "<a href=""#"" class=""icon-btn""><i class=""fas fa-angle-right""></i></a>"
          CStrPG = CStrPG & "<a href=""#"" class=""icon-btn""><i class=""fas fa-angle-double-right""></i></a>"
        End IF
	Else
        CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','','"&intTemp&"');"" class=""icon-btn""><i class=""fas fa-angle-right""></i></a>"
        CStrPG = CStrPG & "<a href=""javascript:chk_Submit('FND','','"&intTemp&"');"" class=""icon-btn""><i class=""fas fa-angle-double-right""></i></a>"
	End IF	
  
    CStrPG = CStrPG & "</div>"
	
	IF cnt > 0 Then 
	    response.write CStrPG
    End IF

	
	DBClose8()

	
%>