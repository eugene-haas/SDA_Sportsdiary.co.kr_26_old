<!--#include file="../Library/ajax_config.asp"-->
<%		
	'==============================================================================================
	'회원가입[팀매니저]		
	'==============================================================================================	
	
	dim UserID 		: UserID 		= fInject(trim(Request("UserID")))
	dim UserPass 	: UserPass 		= fInject(trim(Request("UserPass")))		
	dim UserName 	: UserName 		= fInject(trim(Request("UserName")))
	dim UserBirth 	: UserBirth 	= fInject(trim(Request("UserBirth")))
	dim UserEnName 	: UserEnName 	= fInject(trim(Request("UserEnName")))
	dim UserPhone 	: UserPhone 	= fInject(trim(Request("UserPhone")))
	dim UserEmail 	: UserEmail 	= ReplaceTagText(fInject(trim(Request("UserEmail"))))
	dim UserAddr 	: UserAddr 		= ReplaceTagText(fInject(trim(Request("UserAddr"))))
	dim UserAddrDtl : UserAddrDtl 	= ReplaceTagText(fInject(trim(Request("UserAddrDtl"))))
	dim SEX 		: SEX 			= fInject(Request("SEX"))	
	dim ZipCode 	: ZipCode 		= fInject(Request("ZipCode"))	
	dim LeaderIDX 	: LeaderIDX 	= fInject(Request("LeaderIDX"))	
	dim TeamCode 	: TeamCode 		= fInject(Request("TeamCode"))		'소속팀
	dim SmsYn 		: SmsYn 		= fInject(Request("SmsYn"))			'휴대폰 수신동의
	dim EmailYn 	: EmailYn 		= fInject(Request("EmailYn"))		'이메일 수신동의
	dim AthleteNum 	: AthleteNum 	= fInject(Request("AthleteNum"))	'체육인번호
	dim LeaderType 	: LeaderType 	= fInject(Request("LeaderType"))	'지도자구분[2:감독 | 3:코치]
	dim SportsType 	: SportsType 	= fInject(Request("SportsType"))	'스포츠종목구분
	dim EnterType 	: EnterType 	= fInject(Request("EnterType"))		'회원구분[E:엘리트 | A:생활체육 | K:국가대표]
	
	
	dim CRs, CSQL, LRs, LSQL, TSQL
	dim valSvcDtStart	'팀매니지 최초가입일
	
	dim UserMinorYn
	
	'미성년자 여부 체크
	IF UserBirth<>"" Then
		IF 19 > (Year(Date()) - left(UserBirth, 4)) Then
			UserMinorYn = "Y"
		Else
			UserMinorYn = "N"
		End IF			
	End IF
	
'	response.Write "EnterType=" & EnterType & "<br>"
	
	IF UserID = "" OR UserPass = "" OR UserBirth="" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		
		
		'=====================================================================================================
		'tblMember 가입내역 조회		
		'=====================================================================================================
		CSQL =  " 		SELECT * "
		CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & " 	AND SportsType = '" & SportsType & "' "
		CSQL = CSQL & " 	AND EnterType = '" & EnterType & "' "
		CSQL = CSQL & " 	AND Team = '" & TeamCode & "' "
		CSQL = CSQL & "		AND UserName = '" & UserName & "' "  	
		CSQL = CSQL & "		AND Birthday = '" & UserBirth & "' " 		
		CSQL = CSQL & "		AND PlayerReln = 'T' " 	
		'response.Write CSQL
									
		SET CRs = DBcon.Execute(CSQL)	
		IF Not(CRs.Eof or CRs.Bof) Then
			response.Write "FALSE|99"
			response.End()
		Else
			
			On Error Resume Next
			
			DBcon.BeginTrans()
			
			
			'=====================================================================================================
			'소속팀 서비스 시작일 세팅
			'가입회원[팀매니저] 카운트 조회
			'=====================================================================================================

			LSQL = " 		SELECT COUNT(*) "
			LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblMember] "
			LSQL = LSQL & " WHERE DelYN = 'N' "
			LSQL = LSQL & " 	AND SportsType = '" & SportsType & "' "
			LSQL = LSQL & "		AND Team = '" & TeamCode & "' "
			LSQL = LSQL & "		AND PlayerReln = 'T' "
			
			SET LRs = DBcon.Execute(LSQL)	
			IF LRs(0) > 0 Then
			Else
				'팀매니저 최초가입시 소속팀 서비스 시작일 세팅
				TSQL = "		UPDATE [Sportsdiary].[dbo].[tblTeamInfo]"
				TSQL = TSQL & " SET SvcStartDt = '" &  replace(left(now(),10),"-","") & "' "
				TSQL = TSQL & " WHERE DelYN = 'N' "
				TSQL = TSQL & "		AND SportsGb = '" & SportsType & "' " 
				TSQL = TSQL & "		AND Team = '" & TeamCode & "' " 
				
				DBcon.Execute(TSQL)	
				ErrorNum = ErrorNum + DBcon.Errors.Count
				
			End IF
				LRs.Close
			
			'=====================================================================================================	
			'회원정보 저장
			'=====================================================================================================
			LSQL =  "		INSERT INTO [SportsDiary].[dbo].[tblMember] (" 
			LSQL = LSQL & "	 	UserID"  
			LSQL = LSQL & "		,UserPass" 
			LSQL = LSQL & "		,UserName" 	
			LSQL = LSQL & "		,SportsType"									
			LSQL = LSQL & "		,EnterType"									
			LSQL = LSQL & "		,UserEnName" 
			LSQL = LSQL & "		,UserPhone" 
			LSQL = LSQL & "		,Birthday"  
			LSQL = LSQL & "		,Email" 
			LSQL = LSQL & "		,Address" 
			LSQL = LSQL & "		,AddressDtl" 
			LSQL = LSQL & "		,Sex" 
			LSQL = LSQL & "		,ZipCode" 
			LSQL = LSQL & "		,LeaderIDX" 
			LSQL = LSQL & "		,LeaderType" 						
			LSQL = LSQL & "		,Team"  
			LSQL = LSQL & "		,ViewManage" 
			LSQL = LSQL & "		,UserMinorYn" 
			LSQL = LSQL & "		,SrtDate"  
			LSQL = LSQL & "		,WriteDate"  					
			LSQL = LSQL & "		,ViewManageDate"  					
			LSQL = LSQL & "		,Auth_YN"  
			LSQL = LSQL & "		,InfoYN"  					
			LSQL = LSQL & "		,EmailYn"  					
			LSQL = LSQL & "		,EmailYnDt"  					
			LSQL = LSQL & "		,SmsYn"  					
			LSQL = LSQL & "		,SmsYnDt"  	
			LSQL = LSQL & "		,SrtSvcDate "
			LSQL = LSQL & "		,PlayerReln "				
			LSQL = LSQL & "		,DelYN "  					
			LSQL = LSQL & "		,EdSvcReqTp "  					
			LSQL = LSQL & "	) VALUES('" & UserID 	& "'" 
			LSQL = LSQL & "		,'" & UserPass 		& "'" 
			LSQL = LSQL & "		,'" & UserName 		& "'" 
			LSQL = LSQL & "		,'" & SportsType 	& "'" 
			LSQL = LSQL & "		,'" & EnterType 	& "'" 
			LSQL = LSQL & "		,'" & UserEnName 	& "'" 
			LSQL = LSQL & "		,'" & UserPhone 	& "'" 
			LSQL = LSQL & "		,'" & UserBirth 	& "'" 
			LSQL = LSQL & "		,'" & UserEmail 	& "'" 
			LSQL = LSQL & "		,'" & UserAddr 		& "'" 
			LSQL = LSQL & "		,'" & UserAddrDtl 	& "'" 
			LSQL = LSQL & "		,'" & SEX 			& "'" 
			LSQL = LSQL & "		,'" & ZipCode 		& "'" 
			LSQL = LSQL & "		,'" & LeaderIDX 	& "'" 
			LSQL = LSQL & "		,'" & LeaderType 	& "'" 
			LSQL = LSQL & "		,'" & TeamCode 		& "'" 
			LSQL = LSQL & "		,'N'" 	'등록선수의 경우만 [Y] 그 외 회원구분은 [N]
			LSQL = LSQL & "		,'" & UserMinorYn & "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,'Y'" 
			LSQL = LSQL & "		,'Y'" 
			LSQL = LSQL & "		,'" & EmailYn 		& "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,'" & SmsYn 		& "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,'T'"
			LSQL = LSQL & "		,'N'"
			LSQL = LSQL & "		,'A'"	
			LSQL = LSQL & "	)"	
			
			DBcon.Execute(LSQL)	
			ErrorNum = ErrorNum + DBcon.Errors.Count
			
			
'			RESPONSE.Write" ErrorNum=" & ErrorNum
			
			IF ErrorNum > 0 Then
				DBcon.RollbackTrans()
				
				Response.Write "FALSE|66"
				
			Else	
				
				DBcon.CommitTrans()
				
				Response.Write "TRUE|"
			End IF


		End IF
			CRs.Close
		SET CRs = Nothing
		
		DBClose()
		
	End If 

%>