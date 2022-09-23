<!--#include file="../dev/dist/config.asp"-->
<%  
    response.write "<meta http-equiv='Content-Type' content='text/html;charset=utf-8'>"
   
	dim fnd_SportsGb	: fnd_SportsGb		= fInject(Request("fnd_SportsGb"))
	dim fnd_SEX   		: fnd_SEX 			= fInject(Request("fnd_SEX"))	
    dim fnd_EnterType  	: fnd_EnterType 	= fInject(Request("fnd_EnterType"))
	dim fnd_PlayerReln	: fnd_PlayerReln	= fInject(Request("fnd_PlayerReln"))   
    dim txt_Title	    : txt_Title	        = fInject(Request("txt_Title"))
    dim txt_Msg 	    : txt_Msg	        = fInject(Request("txt_Msg"))
    dim txt_Image	    : txt_Image	        = fInject(Request("txt_Image"))
    dim txt_Weblink	    : txt_Weblink	    = fInject(Request("txt_Weblink"))
    dim CHK_PushGb      : CHK_PushGb        = "Y"               'Default Value 푸시수신동의 한 경우
                                                                 
    IF txt_Title = "" Then txt_Title = " - "   
    IF txt_Image = "" Then txt_Image = " - "   
    IF txt_Weblink = "" Then txt_Weblink = " - "   
   
    dim numcols, numrows, i
    dim txtData
    dim FileName
	dim CSearch, CSearch2, FndSQL, FndSQL2
	dim CSQL, CRs
    dim txt_SportsGb         
    
                                                         
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

    CSQL = " 		SELECT COUNT(*) "
    CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "    
	CSQL = CSQL & " WHERE DelYN = 'N' "
    CSQL = CSQL & "     AND PushYN = '"&CHK_PushGb&"'"&CSearch&CSearch2

	SET CRs = DBCon8.Execute(CSQL)	
		TotalCount = CRs(0)
        CRs.Close

    FileName = txt_SportsGb&" 회원("&TotalCount&"명)_"&replace(date(),"-","")&".xls"  '확장자도 지정할것..
    Response.ContentType = "application/vnd.ms-excel" 
    Response.AddHeader "Content-Disposition","attachment;filename=" & Server.URLPathEncode(FileName)

        
    response.Write "<table border='1'>"
    response.Write "	<tr>"
    response.Write "		<td>식별자</td>"
    response.Write "		<td>메시지</td>"
    response.Write "		<td>이미지</td>"
    response.Write "		<td>웹링크</td>"
    response.Write "		<td>타이틀</td>"
    response.Write "	</tr>"
        
	
    CSQL = "	    SELECT UserID "    
    CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "
	CSQL = CSQL & " WHERE DelYN = 'N' "
    CSQL = CSQL & "     AND PushYN = '"&CHK_PushGb&"'"&CSearch&CSearch2
    CSQL = CSQL & " ORDER BY UserID "    

    SET CRs = DBCon8.Execute(CSQL)	
    IF NOT(CRs.Eof or CRs.Bof) Then 

        txtData = CRs.getRows

        numcols = ubound(txtData, 1)	'행
        numrows = ubound(txtData, 2)	'열

        FOR i = 0 to numrows

            response.Write "<tr>"
            response.Write "	<td style='mso-number-format:\@'>"&txtData(0, i)&"</td>"	
            response.Write "	<td>"&txt_Msg&"</td>"	
            response.Write "	<td>"&txt_Image&"</td>"	
            response.Write "	<td>"&txt_Weblink&"</td>"	
            response.Write "	<td>"&txt_Title&"</td>"
            response.Write "</tr>"	
                    
        NEXT

    End IF
        CRs.Close
    SET CRs = Nothing

    response.Write "</table>"

    DBClose8()
%>

