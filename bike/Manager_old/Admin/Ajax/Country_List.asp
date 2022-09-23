<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'리스트 조회
	'====================================================================================
	Check_AdminLogin()

	dim BlockPage   	: BlockPage     = 10  	'페이지
	dim B_PSize     	: B_PSize       = 10   	'페이지내 보여지는 목록카운트  
	dim cnt       		: cnt         	= 0   	'카운트  

	dim currPage      	: currPage      = fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
	dim fnd_CountryGb	: fnd_CountryGb = fInject(Request("fnd_CountryGb"))


	dim valType
	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3
	dim FndData, CStrPG, CStrTP
	dim i

	dim CSQL, CRs

	IF Len(currPage) = 0 Then currPage = 1
	IF fnd_KeyWord <> "" OR fnd_CountryGb <> "" Then valType = "FND"
	
	IF fnd_CountryGb <> "" Then CSearch = " AND CountryGb = '"&fnd_CountryGb&"'"
	
	'키워드 검색 [한글국가명, 영문전체, 영문축약]
	dim search(2)

	search(0) = "CountryNm"
	search(1) = "CountryEnNm"
	search(2) = "CountryEnNmShort"
	
	IF fnd_KeyWord <> "" Then
		For i = 0 To 2
			CSearch2 = CSearch2 & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
		Next
	
		CSearch2 = " AND ("&mid(CSearch2, 5)&")"
	End IF
	

	CSQL = "    	SELECT ISNULL(COUNT(*),0) Cnt "
	CSQL = CSQL & "   	,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblCountryInfo] " 
	CSQL = CSQL & " WHERE DelYN = 'N'"&CSearch&CSearch2

	' response.Write CSQL

	SET CRs = DBCon.Execute(CSQL) 
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
  
  
	'카운트/페이지
	CStrTP = "<div class=""total_count""><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"

	'리스트 조회  
	CSQL = "    SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "   CountryIDX"
	CSQL = CSQL & "   ,CountryGb"
	CSQL = CSQL & "   ,CountryNm"
	CSQL = CSQL & "   ,CountryEnNm"
	CSQL = CSQL & "   ,CountryEnNmShort"
	CSQL = CSQL & "   ,CountryFlag"
	CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblCountryInfo] "
	CSQL = CSQL & " WHERE DelYN = 'N' "&CSearch&CSearch2
	CSQL = CSQL & " ORDER BY CountryEnNm, CountryNm"

	'response.Write CSQL
        
  	SET CRs = DBCon.Execute(CSQL)
  
	FndData = "      <table class='table-list'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>국기</th>"		
	FndData = FndData & "     <th>소속대륙</th>"  
	FndData = FndData & "     <th>국가명</th>"
	FndData = FndData & "     <th>영문축약</th>"	
	FndData = FndData & "     <th>영문</th>"
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"

  	IF Not(CRs.Eof Or CRs.Bof) Then 

    	CRs.Move (currPage - 1) * B_PSize
    
    	Do Until CRs.eof

      		cnt = cnt + 1
      
			FndData = FndData & "<tr onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("CountryIDX"))&"','"&currPage&"');"">"
			FndData = FndData & " <td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
			IF CRs("CountryFlag") <> "" Then
				FndData = FndData & " <td><img src='/FileDown/country_flag/"&CRs("CountryFlag")&"' alt=''></td>"
			Else
				FndData = FndData & " <td></td>"
			End IF
			FndData = FndData & " <td>"&CRs("CountryGb")&"</td>"
			FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("CountryNm"))&"</td>"
			FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("CountryEnNmShort"))&"</td>"
			FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("CountryEnNm"))&"</td>"
			FndData = FndData & "</tr>"
      
     		CRs.movenext
    	Loop  
 	ELSE
    	FndData = FndData & "<tr class=""no-data""><td colspan=6>등록된 정보가 없습니다.</td></tr>"
  	End IF  
  		CRs.Close
	SET CRs = Nothing
		
	FndData = FndData & " </tbody>"
	FndData = FndData & "</table>"

	'페이징
	dim intTemp

	CStrPG = CStrPG & " <div class='page_index'>"
	CStrPG = CStrPG & " <ul class='pagination'>"

	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1

	If intTemp = 1 Then
		CStrPG = CStrPG & "<li class='prev'><a href='javascript:;' class='fa fa-angle-left'></a></li>"
	Else 
		CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp - BlockPage&"');"" class='fa fa-angle-left'></a></li> "
	End If  

	dim intLoop : intLoop = 1

	Do Until intLoop > BlockPage Or intTemp > TotalPage

		If CInt(intTemp) = CInt(currPage) Then
			CStrPG = CStrPG & "<li class='active'><a href='#' >"&intTemp&"</a> </li>" 
		Else
			CStrPG = CStrPG & "<li><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"">"&intTemp&"</a> </li>"
		End If

		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop

	IF intTemp > TotalPage Then
		CStrPG = CStrPG & "<li class='next'><a href='javascript:;' class='fa fa-angle-right'></a></li>"
	Else
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"" class='fa fa-angle-right'></a></li>"
	End IF  

	CStrPG = CStrPG & "</ul>"
	CStrPG = CStrPG & "</div>"
  
  
  	'출력  
  	response.Write CStrTP '카운트/페이지
 	response.Write FndData  '회원목록 테이블
    
  	IF TotalCount > 0 Then response.Write CStrPG  '페이징
  
  
  	DBClose()
  
%>