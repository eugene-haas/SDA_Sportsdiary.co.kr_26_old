<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================================
	'국가대표 회원가입 
	'EnterType = K, PlayerReln = R	
	'==============================================================================================
	dim UserID 			: UserID 			= fInject(trim(Request("UserID")))
	dim UserPass 		: UserPass 			= fInject(trim(Request("UserPass")))		
	dim UserName 		: UserName 			= fInject(trim(Request("UserName")))
	dim UserBirth 		: UserBirth 		= fInject(trim(Request("UserBirth")))
	dim UserEnName 		: UserEnName   		= fInject(trim(Request("UserEnName")))
	dim UserPhone 		: UserPhone 		= fInject(trim(Request("UserPhone")))
	dim UserEmail 		: UserEmail 		= ReplaceTagText(fInject(trim(Request("UserEmail"))))
	dim UserAddr 		: UserAddr 			= ReplaceTagText(fInject(trim(Request("UserAddr"))))
	dim UserAddrDtl 	: UserAddrDtl 		= ReplaceTagText(fInject(trim(Request("UserAddrDtl"))))
	dim SEX 			: SEX 				= fInject(Request("SEX"))	
	dim BloodType 		: BloodType 		= fInject(Request("BloodType"))
	dim ZipCode 		: ZipCode 			= fInject(Request("ZipCode"))	
	dim PlayerIDXNow 	: PlayerIDXNow 		= fInject(Request("PlayerIDXNow"))	
	dim PlayerStartYear : PlayerStartYear 	= fInject(Request("PlayerStartYear"))
	dim PlayerTall	 	: PlayerTall 		= fInject(Request("PlayerTall"))
	dim PlayerWeight 	: PlayerWeight 		= fInject(Request("PlayerWeight"))
	dim ViewManage 		: ViewManage 		= fInject(Request("ViewManage"))		'팀매니저 비등록선수 관리여부[Y:관리 | N:비관리]
	dim PlayerReln 		: PlayerReln 		= fInject(Request("PlayerReln"))		'회원구분[A,B,Z:선수보호자 | T:팀매니저 | D:일반회원 | K:비등록선수 | S:예비후보선수]	
	dim TeamCode 		: TeamCode			= fInject(Request("TeamCode"))			'현 소속팀
	dim TeamCode_K 		: TeamCode_K		= fInject(Request("TeamCode_K"))		'국가대표 소속팀
	dim SmsYn 			: SmsYn 			= fInject(Request("SmsYn"))				'휴대폰 수신동의
	dim EmailYn 		: EmailYn 			= fInject(Request("EmailYn"))			'이메일 수신동의
	dim PlayerLevel 	: PlayerLevel 		= fInject(Request("PlayerLevel"))		'체급
	dim AthleteNum 		: AthleteNum 		= fInject(Request("AthleteNum"))		'체육인번호
	dim AthleteYN 		: AthleteYN 		= fInject(Request("AthleteYN"))			'협회소속구분
	dim TeamGb 			: TeamGb 			= fInject(Request("TeamGb"))			'소속구분
	dim AreaGb		 	: AreaGb 			= fInject(Request("AreaGb"))			'지역	
	dim SportsType	 	: SportsType 		= fInject(Request("SportsType"))		'종목구분
	dim EnterType	 	: EnterType 		= fInject(Request("EnterType"))			'회원구분[E:엘리트 | A:아마추어 | K:국가대표]
	
'	PlayerType 		= fInject(Request("PlayerType"))
	'PubCode  ex)sd039001[PlayerGb:선수], sd045001[PlayerType:내국인]
	
	dim ErrorNum
	
	dim PlayerIDX		'선수[tblPlayer] PlayerIDX
	
	dim LSQL, CSQL, CRs
	
	'미성년자 여부 체크
	IF UserBirth<>"" Then
		IF 19 > (Year(Date()) - left(UserBirth, 4)) Then
			UserMinorYn = "Y"
		Else
			UserMinorYn = "N"
		End IF			
	End IF
	
	If UserID = "" OR UserPass = "" Then 	
		Response.Write "FALSE"
		Response.End
	Else 
		'tblMember 가입내역 조회		
		CSQL =  	  " SELECT a.userID "
		CSQL = CSQL & " 	,a.PlayerIDX " 
		CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblMember] a "
		CSQL = CSQL & "		inner join [Sportsdiary].[dbo].[tblPlayer] b on a.PlayerIDX = b.PlayerIDX " 
		CSQL = CSQL & "			AND b.DelYN = 'N' "
		CSQL = CSQL & "			AND b.SportsGb = '" & SportsType & "' "
		CSQL = CSQL & " WHERE a.DelYN = 'N' "
		CSQL = CSQL & "		AND a.SportsType = '" & SportsType & "' "
		CSQL = CSQL & "		AND a.Team = '" & TeamCode_K & "' "  
		CSQL = CSQL & "		AND a.UserName = '" & UserName & "' "  	
		CSQL = CSQL & "		AND a.Birthday = '" & UserBirth & "' " 
		CSQL = CSQL & "		AND a.PlayerReln = '" & PlayerReln & "' " 
						
		SET CRs = DBcon.Execute(CSQL)	
		IF Not(CRs.eof or CRs.bof) Then
			response.Write "FALSE"
			response.End()
		Else
			
			On Error Resume Next
			
			DBcon.BeginTrans()
				
				'==================================================================================
				'국가대표 선수 tblPlayer 테이블에 신규등록처리
				'EntyerType = K, NowRegYN = Y
				'==================================================================================
				LSQL =  "		INSERT INTO [SportsDiary].[dbo].[tblPlayer] (" 
				LSQL = LSQL & "		SportsGb"
				LSQL = LSQL & "		,PlayerGb"
				LSQL = LSQL & "		,UserName"
				LSQL = LSQL & "		,UserPhone"
				LSQL = LSQL & "		,Birthday"
				LSQL = LSQL & "		,Sex"
				LSQL = LSQL & "		,DelYN"
				LSQL = LSQL & "		,WriteDate"				
				LSQL = LSQL & "		,PersonCode"
				LSQL = LSQL & "		,PlayerType"
				LSQL = LSQL & "		,EnterType"
				LSQL = LSQL & "		,Member_YN"
				LSQL = LSQL & "		,Auth_YN"
				LSQL = LSQL & "		,RegTp"
				LSQL = LSQL & "		,Team"
				LSQL = LSQL & "		,NowRegYN"
				LSQL = LSQL & "	) VALUES('" & SportsType & "'"
				LSQL = LSQL & "		,'sd039001'"
				LSQL = LSQL & "		,'" & UserName 		& "'"
				LSQL = LSQL & "		,'" & replace(UserPhone,"-","") & "'"
				LSQL = LSQL & "		,'" & UserBirth 	& "'"
				LSQL = LSQL & "		,'" & SEX 			& "'"
				LSQL = LSQL & "		,'N'"
				LSQL = LSQL & "		,GETDATE()"
				LSQL = LSQL & "		,'"& AthleteNum 	& "'"
				LSQL = LSQL & "		,'sd045001'"
				LSQL = LSQL & "		,'K'"
				LSQL = LSQL & "		,'N'"
				LSQL = LSQL & "		,'N'"
				LSQL = LSQL & "		,'A'"
				LSQL = LSQL & "		,'" & TeamCode_K 	& "'"
				LSQL = LSQL & "		,'Y'"
				LSQL = LSQL & "	)"
				
				DBcon.Execute(LSQL)	
				ErrorNum = ErrorNum + DBcon.Errors.Count	
				
				'===============================================================================================
				'선수테이블 등록 후 최종 PlayerIDX 값 조회
				'===============================================================================================
				LSQL = "		SELECT MAX(PlayerIDX) "
				LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblPlayer]"
				
'				response.Write "LSQL=" & LSQL&"<br>"
										
				SET LRs = DBcon.Execute(LSQL)	
					PlayerIDX = LRs(0)
				'===============================================================================================
					
					
				LSQL =  "		INSERT INTO [SportsDiary].[dbo].[tblMember] (" 
				LSQL = LSQL & "		SportsType "
				LSQL = LSQL & "		,UserID "  
				LSQL = LSQL & "		,UserPass " 
				LSQL = LSQL & "		,UserName " 										
				LSQL = LSQL & "		,UserEnName " 
				LSQL = LSQL & "		,UserPhone " 
				LSQL = LSQL & "		,Birthday "  
				LSQL = LSQL & "		,Email " 
				LSQL = LSQL & "		,Address " 
				LSQL = LSQL & "		,AddressDtl " 
				LSQL = LSQL & "		,Sex " 
				LSQL = LSQL & "		,BloodType " 
				LSQL = LSQL & "		,ZipCode " 
				LSQL = LSQL & "		,PlayerIDX " 
				LSQL = LSQL & "		,PlayerLevel " 
				LSQL = LSQL & "		,PlayerType " 						
				LSQL = LSQL & "		,PlayerStartYear " 
				LSQL = LSQL & "		,PlayerReln " 
				LSQL = LSQL & "		,ViewManage " 
				LSQL = LSQL & "		,EnterType "  					
				LSQL = LSQL & "		,Tall " 
				LSQL = LSQL & "		,Weight " 
				LSQL = LSQL & "		,Team "  
				LSQL = LSQL & "		,UserMinorYn " 
				LSQL = LSQL & "		,SrtDate "  
				LSQL = LSQL & "		,WriteDate "  					
				LSQL = LSQL & "		,ViewManageDate "  					
				LSQL = LSQL & "		,Auth_YN "  
				LSQL = LSQL & "		,InfoYN "  					
				LSQL = LSQL & "		,EmailYn "  					
				LSQL = LSQL & "		,EmailYnDt "  					
				LSQL = LSQL & "		,SmsYn "  					
				LSQL = LSQL & "		,SmsYnDt "  					
				LSQL = LSQL & "		,DelYN "  					
				LSQL = LSQL & "		,EdSvcReqTp "  
				LSQL = LSQL & "		,PlayerIDXNow "  
				LSQL = LSQL & "		,TeamNow "  
				LSQL = LSQL & ") VALUES('" & SportsType 	& "'" 
				LSQL = LSQL & "		,'" & UserID 			&"'" 
				LSQL = LSQL & "		,'" & UserPass 			& "'" 
				LSQL = LSQL & "		,'" & UserName 			& "'" 
				LSQL = LSQL & "		,'" & UserEnName 		& "'" 
				LSQL = LSQL & "		,'" & UserPhone 		& "'" 
				LSQL = LSQL & "		,'" & UserBirth 		& "'" 
				LSQL = LSQL & "		,'" & UserEmail 		& "'" 
				LSQL = LSQL & "		,'" & UserAddr 			& "'" 
				LSQL = LSQL & "		,'" & UserAddrDtl	 	& "'" 
				LSQL = LSQL & "		,'" & SEX 				& "'" 
				LSQL = LSQL & "		,'" & BloodType 		& "'" 
				LSQL = LSQL & "		,'" & ZipCode 			& "'" 
				LSQL = LSQL & "		,'" & PlayerIDX 		& "'" 
				LSQL = LSQL & "		,'" & PlayerLevel 		& "'" 
				LSQL = LSQL & "		,'sd045001'" 
				LSQL = LSQL & "		,'" & PlayerStartYear 	& "'" 
				LSQL = LSQL & "		,'" & PlayerReln 		& "'" 
				LSQL = LSQL & "		,'" & ViewManage 		& "'" 
				LSQL = LSQL & "		,'" & EnterType 		& "'" 
				LSQL = LSQL & "		,'" & PlayerTall 		& "'" 
				LSQL = LSQL & "		,'" & PlayerWeight 		& "'" 
				LSQL = LSQL & "		,'" & TeamCode_K 		& "'" 
				LSQL = LSQL & "		,'" & UserMinorYn 		& "'" 
				LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,'Y'" 
				LSQL = LSQL & "		,'Y'" 
				LSQL = LSQL & "		,'" & EmailYn 			& "'" 
				LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				LSQL = LSQL & "		,'" & SmsYn 			& "'" 
				LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				LSQL = LSQL & "		,'N'"
				LSQL = LSQL & " 	,'A'"
				LSQL = LSQL & "		,'" & PlayerIDXNow 		& "'"
				LSQL = LSQL & "		,'" & TeamCode 			& "'"				
				LSQL = LSQL & "	)"
					
				DBcon.Execute(LSQL)	
				ErrorNum = ErrorNum + DBcon.Errors.Count
				
			
			IF ErrorNum > 0 Then
				DBcon.RollbackTrans()
				
				Response.Write "FALSE"
				
			Else	
				
				DBcon.CommitTrans()
				
				Response.Write "TRUE"
			End IF
			
			
		End IF
		
			CRs.Close
		SET CRs = Nothing
		
		DBClose()
		
	End If 

%>