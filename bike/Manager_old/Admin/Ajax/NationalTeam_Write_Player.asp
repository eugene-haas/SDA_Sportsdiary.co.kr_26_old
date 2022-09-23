<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'리스트 조회 : 선수
	'====================================================================================
	Check_AdminLogin()

	dim fnd_Year      	: fnd_Year      = fInject(Request("fnd_Year"))
	dim fnd_UserName   	: fnd_UserName  = fInject(Request("fnd_UserName")) 
     
	dim LSQL, LRs   
   	dim FSO
   	
   	SET FSO = CreateObject("Scripting.FileSystemObject") 
	 
	IF fnd_Year	= "" Then fnd_Year = Year(Date())
	 
    '목록조회
    LSQL = "      	SELECT A.MemberIDX"
	LSQL = LSQL & "   	,A.UserName"
	LSQL = LSQL & "   	,A.UserEnName"
	LSQL = LSQL & "   	,A.PersonCode"
	LSQL = LSQL & "   	,A.Sex"
   	LSQL = LSQL & "		,A.EnterType "	
   	LSQL = LSQL & "   	,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SEXNm "
	LSQL = LSQL & "   	,A.Birthday"
   	LSQL = LSQL & "   	,CASE WHEN A.Birthday<>'' THEN SUBSTRING(replace(A.Birthday,'-',''), 1, 4)+'.'+SUBSTRING(replace(A.Birthday,'-',''), 5, 2)+'.'+SUBSTRING(replace(A.Birthday,'-',''), 7, 2) END UserBirth"
	LSQL = LSQL & "   	,A.Team"	
	LSQL = LSQL & "   	,A.Photo"	
	LSQL = LSQL & "   	,B.TeamNm"	
	LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblMemberHistory] A"
	LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] B on A.Team = B.Team AND B.DelYN = 'N' AND B.RegYear = '"&fnd_Year&"'"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
   	LSQL = LSQL & " 	AND A.EnterType = 'E'"
	LSQL = LSQL & " 	AND A.RegYear = '"&fnd_Year&"'"
   	LSQL = LSQL & " 	AND A.UserName like '%"&fnd_UserName&"%'"
	LSQL = LSQL & " ORDER BY A.UserName, A.Birthday, A.Sex"
        
  	'response.Write LSQL
        
    SET LRs = DBCon.Execute(LSQL)
  
	FndData = "       <table class='table-list popup-table'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>이미지</th>"
	FndData = FndData & "     <th>이름</th>"
	FndData = FndData & "     <th>영문이름</th>"
	FndData = FndData & "     <th>생년월일</th>"
	FndData = FndData & "     <th>성별</th>"
	FndData = FndData & "     <th>체육인번호</th>"
	FndData = FndData & "     <th>소속팀</th>"
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"

  	IF Not(LRs.Eof Or LRs.Bof) Then 
    	Do Until LRs.eof

      		cnt = cnt + 1
      
			FndData = FndData & "<tr onClick=""INPUT_PLAYERINFO('"&LRs("MemberIDX")&"','"&LRs("UserName")&"','"&LRs("UserEnName")&"','"&LRs("Birthday")&"','"&LRs("Photo")&"');"">"
			FndData = FndData & " <td>"&cnt&"</td>"
			
			IF LRs("Photo")<>"" Then
				'실제경로에 이미지파일 있는지 체크
			''	IF FSO.FileExists(global_filepath&"Player\"&LRs("EnterType")&"\"&LRs("Photo")) Then 
			''		FndData = FndData & "<td><img src='"&global_filepathUrl&"Player/"&LRs("EnterType")&"/"&LRs("Photo")&"' width='50' alt=''></td>"
			''	Else
					FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
			''	End IF	
			Else
				FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
			End IF
			
   
			FndData = FndData & " <td>"&LRs("UserName")&"</td>"
			FndData = FndData & " <td>"&LRs("UserEnName")&"</td>"
			FndData = FndData & " <td>"&LRs("UserBirth")&"</td>"
			FndData = FndData & " <td>"&LRs("SEXNm")&"</td>"
			FndData = FndData & " <td>"&LRs("PersonCode")&"</td>"
			FndData = FndData & " <td>"&LRs("TeamNm")&"</td>"
			FndData = FndData & "</tr>"

      		LRs.movenext
   	 	Loop  
    ELSE
      	FndData = FndData & "<tr><td colspan=8>일치하는 정보가 없습니다.</td></tr>"
    End IF  
      	LRs.Close
    SET LRs = Nothing
    
	FndData = FndData & " </tbody>"
	FndData = FndData & "</table>"

														   
    response.Write FndData  '목록 테이블
    
    DBClose()
  
%>