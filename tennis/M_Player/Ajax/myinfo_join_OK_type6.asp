<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================================
	'국가대표 회원가입 
	'EnterType = K, PlayerReln = R	
	'==============================================================================================
	Check_Login()
	
	dim MemberIDX		: MemberIDX		= fInject(Request("MemberIDX"))
	dim PlayerIDX		: PlayerIDX		= fInject(Request("PlayerIDX"))		
	dim Team 			: Team			= fInject(Request("Team"))
	dim SportsType 	 	: SportsType 	= fInject(Request("SportsType"))
	dim UserID  		: UserID 		= fInject(Request("UserID"))
	dim UserPass  		: UserPass 		= fInject(Request("UserPass"))
	dim TeamCode_K		: TeamCode_K 	= fInject(Request("TeamCode_K"))
				
	
	dim ErrorNum, FndData
	dim LSQL, LRs, CSQL, CRs, JRs, JSQL

	
	IF MemberIDX = "" OR PlayerIDX = "" OR Team = "" OR SportsType = "" Then 	
		FndData = "FALSE|200"		
	Else 
		
		'국가대표 계정등록 유무 체크
		CSQL =  " 		SELECT COUNT(*) "
		CSQL = CSQL & " FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & " 	AND SportsType = '"&SportsType&"' "
		CSQL = CSQL & " 	AND EnterType = 'K' "
		CSQL = CSQL & " 	AND PlayerIDXNow = '"&PlayerIDX&"' "
		CSQL = CSQL & " 	AND TeamNow = '"&Team&"' "

'		response.Write CSQL

		SET CRs = DBcon.Execute(CSQL)
		IF CRs(0) > 0 Then 
			FndData = "FALSE|99"
		
		'국가대표 계정 미등록이면 			
		ELSE      
		  	
			On Error Resume Next
			
			Dbcon.BeginTrans()
			
			'국가대표 계정등록을 위한 현재 계정 정보 조회			
			LSQL =  " 		SELECT P.PersonCode "
			LSQL = LSQL & " 	,M.* "
			LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
			LSQL = LSQL & " 	left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX" 
			LSQL = LSQL & " 	AND	P.DelYN = 'N' "
			LSQL = LSQL & " 	AND P.SportsGb = '"&SportsType&"' "
			LSQL = LSQL & " WHERE M.DelYN = 'N' "
			LSQL = LSQL & " 	AND M.SportsType = '"&SportsType&"' "
			LSQL = LSQL & " 	AND M.EnterType = 'E' "
			LSQL = LSQL & " 	AND M.MemberIDX = '"&MemberIDX&"' "
			
			SET LRs = DBcon.Execute(LSQL)
			IF Not(LRs.Eof OR LRs.Bof) Then
				
				'==================================================================================
				'국가대표 선수 tblPlayer 테이블에 신규등록처리
				'EntyerType = K, NowRegYN = Y
				'==================================================================================
				JSQL =  "		INSERT INTO [SportsDiary].[dbo].[tblPlayer] (" 
				JSQL = JSQL & "		SportsGb"
				JSQL = JSQL & "		,PlayerGb"
				JSQL = JSQL & "		,UserName"
				JSQL = JSQL & "		,UserPhone"
				JSQL = JSQL & "		,Birthday"
				JSQL = JSQL & "		,Sex"
				JSQL = JSQL & "		,DelYN"
				JSQL = JSQL & "		,WriteDate"				
				JSQL = JSQL & "		,PersonCode"
				JSQL = JSQL & "		,PlayerType"
				JSQL = JSQL & "		,EnterType"
				JSQL = JSQL & "		,Member_YN"
				JSQL = JSQL & "		,Auth_YN"
				JSQL = JSQL & "		,RegTp"
				JSQL = JSQL & "		,Team"
				JSQL = JSQL & "		,NowRegYN"
				JSQL = JSQL & "	) VALUES( "
				JSQL = JSQL & "		'" & SportsType & "'"
				JSQL = JSQL & "		,'sd039001'"
				JSQL = JSQL & "		,'" & LRs("UserName") & "'"
				JSQL = JSQL & "		,'" & replace(LRs("UserPhone"),"-","") & "'"
				JSQL = JSQL & "		,'" & LRs("Birthday") & "'"
				JSQL = JSQL & "		,'" & LRs("SEX") & "'"
				JSQL = JSQL & "		,'N'"
				JSQL = JSQL & "		,GETDATE()"
				JSQL = JSQL & "		,'"& LRs("PersonCode") & "'"
				JSQL = JSQL & "		,'sd045001'"
				JSQL = JSQL & "		,'K'"
				JSQL = JSQL & "		,'N'"
				JSQL = JSQL & "		,'N'"
				JSQL = JSQL & "		,'A'"
				JSQL = JSQL & "		,'" & TeamCode_K & "'"
				JSQL = JSQL & "		,'Y'"
				JSQL = JSQL & "	)"
				
				DBcon.Execute(JSQL)	
				ErrorNum = ErrorNum + DBcon.Errors.Count	
				
				'===============================================================================================
				'선수테이블 등록 후 최종 PlayerIDX 값 조회
				'===============================================================================================
				JSQL = "		SELECT MAX(PlayerIDX) "
				JSQL = JSQL & " FROM [SportsDiary].[dbo].[tblPlayer]"
				
	'				response.Write "JSQL=" & JSQL&"<br>"
										
				SET JRs = DBCon.Execute(JSQL)	
					PlayerIDX_K = JRs(0)
				'===============================================================================================
				'미성년자 여부 체크
				'===============================================================================================
				IF LRs("Birthday") <> "" Then
					IF 19 > (Year(Date()) - left(LRs("Birthday"), 4)) Then
						UserMinorYn = "Y"
					Else
						UserMinorYn = "N"
					End IF			
				End IF	
					
				JSQL =  "		INSERT INTO [SportsDiary].[dbo].[tblMember] (" 
				JSQL = JSQL & "		SportsType "
				JSQL = JSQL & "		,UserID "  
				JSQL = JSQL & "		,UserPass " 
				JSQL = JSQL & "		,UserName " 										
				JSQL = JSQL & "		,UserEnName " 
				JSQL = JSQL & "		,UserPhone " 
				JSQL = JSQL & "		,Birthday "  
				JSQL = JSQL & "		,Email " 
				JSQL = JSQL & "		,Address " 
				JSQL = JSQL & "		,AddressDtl " 
				JSQL = JSQL & "		,Sex " 
				JSQL = JSQL & "		,BloodType " 
				JSQL = JSQL & "		,ZipCode " 
				JSQL = JSQL & "		,PlayerIDX " 
				JSQL = JSQL & "		,PlayerLevel " 
				JSQL = JSQL & "		,PlayerType " 						
				JSQL = JSQL & "		,PlayerStartYear " 
				JSQL = JSQL & "		,PlayerReln " 
				JSQL = JSQL & "		,ViewManage " 
				JSQL = JSQL & "		,EnterType "  					
				JSQL = JSQL & "		,Tall " 
				JSQL = JSQL & "		,Weight " 
				JSQL = JSQL & "		,Team "  
				JSQL = JSQL & "		,UserMinorYn " 
				JSQL = JSQL & "		,SrtDate "  
				JSQL = JSQL & "		,WriteDate "  					
				JSQL = JSQL & "		,ViewManageDate "  					
				JSQL = JSQL & "		,Auth_YN "  
				JSQL = JSQL & "		,InfoYN "  					
				JSQL = JSQL & "		,EmailYn "  					
				JSQL = JSQL & "		,EmailYnDt "  					
				JSQL = JSQL & "		,SmsYn "  					
				JSQL = JSQL & "		,SmsYnDt "  					
				JSQL = JSQL & "		,DelYN "  					
				JSQL = JSQL & "		,EdSvcReqTp "  
				JSQL = JSQL & "		,PlayerIDXNow "  	'현재소속팀 선수IDX
				JSQL = JSQL & "		,TeamNow "  		'현재소속팀 EnterType=E, PlayerReln=R
				JSQL = JSQL & ") VALUES( " 
				JSQL = JSQL & "		 '" & SportsType & "'" 
				JSQL = JSQL & "		,'" & UserID &"'" 
				JSQL = JSQL & "		,'" & UserPass & "'" 
				JSQL = JSQL & "		,'" & LRs("UserName") & "'" 
				JSQL = JSQL & "		,'" & LRs("UserEnName") & "'" 
				JSQL = JSQL & "		,'" & LRs("UserPhone") & "'" 
				JSQL = JSQL & "		,'" & LRs("Birthday") & "'" 
				JSQL = JSQL & "		,'" & LRs("Email") & "'" 
				JSQL = JSQL & "		,'" & LRs("Address") & "'" 
				JSQL = JSQL & "		,'" & LRs("AddressDtl") & "'" 
				JSQL = JSQL & "		,'" & LRs("SEX") & "'" 
				JSQL = JSQL & "		,'" & LRs("BloodType") & "'" 
				JSQL = JSQL & "		,'" & LRs("ZipCode") & "'" 
				JSQL = JSQL & "		,'" & PlayerIDX_K & "'" 
				JSQL = JSQL & "		,'" & LRs("PlayerLevel") & "'" 
				JSQL = JSQL & "		,'sd045001'" 
				JSQL = JSQL & "		,'" & LRs("PlayerStartYear") & "'" 
				JSQL = JSQL & "		,'" & LRs("PlayerReln") & "'" 
				JSQL = JSQL & "		,'N'" 
				JSQL = JSQL & "		,'K'" 
				JSQL = JSQL & "		,'" & LRs("Tall") & "'" 
				JSQL = JSQL & "		,'" & LRs("Weight") & "'" 
				JSQL = JSQL & "		,'" & TeamCode_K & "'" 
				JSQL = JSQL & "		,'" & UserMinorYn & "'" 
				JSQL = JSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				JSQL = JSQL & "		,GETDATE()" 
				JSQL = JSQL & "		,GETDATE()" 
				JSQL = JSQL & "		,'Y'" 
				JSQL = JSQL & "		,'Y'" 
				JSQL = JSQL & "		,'" & LRs("EmailYn") & "'" 
				JSQL = JSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				JSQL = JSQL & "		,'" & LRs("SmsYn") & "'" 
				JSQL = JSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				JSQL = JSQL & "		,'N'"
				JSQL = JSQL & " 	,'A'"
				JSQL = JSQL & "		,'" & PlayerIDX & "'"
				JSQL = JSQL & "		,'" & Team & "')"				
				
				DBcon.Execute(JSQL)	
				ErrorNum = ErrorNum + DBcon.Errors.Count
				
				
				IF ErrorNum > 0 Then
					DBcon.RollbackTrans()
					
					FndData = "FALSE|33"
					
				Else	
					
					DBcon.CommitTrans()
					
					FndData = "TRUE|"
				End IF
			
			Else
			
				FndData = "FALSE|66"
				
			End IF
				LRs.Close
			SET LRs = Nothing
			
		End IF 
			
			CRs.Close
		SET CRs = Nothing
			
		DBClose()
		
	End If 
	
	response.Write FndData
%>