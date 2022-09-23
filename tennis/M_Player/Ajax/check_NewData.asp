<!--#include file="../Library/ajax_config.asp"-->
<%
	'=========================================================================================
	'신규데이터 체크 
	'New 아이콘 출력체크
	'=========================================================================================	
	Check_Login()

	dim MemberIDX 	: MemberIDX 	= decode(request.Cookies("MemberIDX"),0)
	dim Team	 	: Team 			= decode(request.Cookies("Team"),0)
	dim TypeMenu	: TypeMenu		= request("TypeMenu")		
	dim TypeMenuSub	: TypeMenuSub	= request("TypeMenuSub")
	
	dim CSQL, CRs
	dim CHK_VALUE
	
'	TEAM = "JU02840"
	
	FUNCTION CHK_NEWDATA(TypeMenu)
		
		
		SELECT CASE TypeMenu
			
			'팀공지사항[선수:BR02], 같은소속
			CASE "TNOTICE"		
	
				CSQL = " 		SELECT COUNT(*) "
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcNotice] "
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
				CSQL = CSQL & "		AND BRPubCode = 'BR02' "
				CSQL = CSQL & "		AND Team = '"&Team&"' "
				CSQL = CSQL & "		AND ViewTp = 'T' "
				CSQL = CSQL & "		AND NtcIDX IN( "
				CSQL = CSQL & "			SELECT NtcIDX "
				CSQL = CSQL & "			FROM [Sportsdiary].[dbo].[tblSvcNoticeSub] " 
				CSQL = CSQL & "			WHERE DelYN = 'N' "
				CSQL = CSQL & "				AND MemberIDX = '"&MemberIDX&"' "
				CSQL = CSQL & "			)" 
				CSQL = CSQL & "		AND DateDiff(HH, WriteDate, GetDate()) < 24 "
				
				SET CRs = Dbcon.Execute(CSQL)
				If CRs(0) > 0 Then 
					CHK_VALUE = "TRUE"
				Else
					CHK_VALUE = "FALSE"
				End If 
					
					CRs.Close
				SET CRs = Nothing
				
				CHK_NEWDATA = CHK_VALUE		
			
			'커뮤니티[공지사항:BR01]
			CASE "NOTICE"		
	
				CSQL = " 		SELECT COUNT(*) "
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcNotice] "
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
				CSQL = CSQL & "		AND BRPubCode = 'BR01' "
				CSQL = CSQL & "		AND ViewTp = 'A' "
				CSQL = CSQL & "		AND DateDiff(HH, WriteDate, GetDate()) < 24 "
				
				SET CRs = Dbcon.Execute(CSQL)
				If CRs(0) > 0 Then 
					CHK_VALUE = "TRUE"
				Else
					CHK_VALUE = "FALSE"
				End If 
					
					CRs.Close
				SET CRs = Nothing
				
				CHK_NEWDATA = CHK_VALUE	
									
			'훈련일지
			CASE "TRAIN"
				CSQL = " 		SELECT COUNT(*) "
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcTrRerd]	"
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & " 	AND SportsGb = '"&SportsGb&"' "
				CSQL = CSQL & " 	AND MemberIDX = '"&MemberIDX&"' "
				CSQL = CSQL & " 	AND DateDiff(HH, WriteDate, GetDate()) < 24 "
			
				SET CRs = Dbcon.Execute(CSQL)
				If CRs(0) > 0 Then 
					CHK_VALUE = "TRUE"
				Else
					CHK_VALUE = "FALSE"
				End If 
					
					CRs.Close
				SET CRs = Nothing
				
				CHK_NEWDATA = CHK_VALUE				
			
			'대회일지
			CASE "GAME"
				CSQL = " 		SELECT COUNT(distinct GameTitleIDX) "
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcGameRerd] "
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & " 	AND SportsGb = '"&SportsGb&"' "
				CSQL = CSQL & " 	AND MemberIDX = '"&MemberIDX&"' "
				CSQL = CSQL & " 	AND DateDiff(HH, WriteDate, GetDate()) < 24 "
			
				SET CRs = Dbcon.Execute(CSQL)
				If CRs(0) > 0 Then 
					CHK_VALUE = "TRUE"
				Else
					CHK_VALUE = "FALSE"
				End If 
					
					CRs.Close
				SET CRs = Nothing
				
				CHK_NEWDATA = CHK_VALUE				
			
			'메모리[지도자상담]
			CASE "COUNCEL"	
				
				SELECT CASE TypeMenuSub
					'훈련일지
					CASE "TRAIN" 
						CSQL = " 		SELECT COUNT(*) "
						CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcTrRerd]	L "
						CSQL = CSQL & " 	inner join [Sportsdiary].[dbo].[tblMember] M on L.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 		AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " WHERE L.DelYN = 'N' "
						CSQL = CSQL & " 	AND L.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 	AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 	AND DateDiff(HH, L.WriteDate, GetDate()) < 24 "
					
					'대회일지	
					CASE "GAME"
						CSQL = " 		SELECT COUNT(distinct L.GameTitleIDX) "
						CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcGameRerd] L	 "
						CSQL = CSQL & " 	inner join [Sportsdiary].[dbo].[tblMember] M on L.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 		AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " WHERE L.DelYN = 'N' "
						CSQL = CSQL & " 	AND L.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 	AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 	AND DateDiff(HH, L.WriteDate, GetDate()) < 24 "
						
					CASE ELSE
						CSQL = " 		SELECT SUM(A.Cnt) Cnt "
						CSQL = CSQL & " FROM ( "
						CSQL = CSQL & " 	SELECT COUNT(*) Cnt "
						CSQL = CSQL & " 	FROM [Sportsdiary].[dbo].[tblSvcTrRerd]	L "
						CSQL = CSQL & " 		inner join [Sportsdiary].[dbo].[tblMember] M on L.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 			AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " 	WHERE L.DelYN = 'N' "
						CSQL = CSQL & " 		AND L.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 		AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 		AND DateDiff(HH, L.WriteDate, GetDate()) < 24 "
						CSQL = CSQL & " 	UNION ALL "
						CSQL = CSQL & " 	SELECT COUNT(distinct G.GameTitleIDX) Cnt "
						CSQL = CSQL & " 	FROM [Sportsdiary].[dbo].[tblSvcGameRerd] G	 "
						CSQL = CSQL & " 		inner join [Sportsdiary].[dbo].[tblMember] M on G.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 			AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " 	WHERE G.DelYN = 'N' "
						CSQL = CSQL & " 		AND G.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 		AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 		AND DateDiff(HH, G.WriteDate, GetDate()) < 24 "
						CSQL = CSQL & " ) A "
				END SELECT
				
				SET CRs = Dbcon.Execute(CSQL)
				If CRs(0) > 0 Then 
					CHK_VALUE = "TRUE"
				Else
					CHK_VALUE = "FALSE"
				End If 
					
					CRs.Close
				SET CRs = Nothing
				
				CHK_NEWDATA = CHK_VALUE		
			
			'지도자 상담 답변체크	
			CASE "COUNCELRE"	
				
				SELECT CASE TypeMenuSub
					'훈련일지
					CASE "TRAIN" 
						CSQL = " 		SELECT COUNT(*) "
						CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcTrRerd]	L "
						CSQL = CSQL & " 	inner join [Sportsdiary].[dbo].[tblMember] M on L.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 		AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " WHERE L.DelYN = 'N' "
						CSQL = CSQL & " 	AND L.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 	AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 	AND DateDiff(HH, L.AdtReWriteDt, GetDate()) < 24 "
					
					'대회일지	
					CASE "GAME"
						CSQL = " 		SELECT COUNT(distinct L.GameTitleIDX) "
						CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcGameRerd] L	 "
						CSQL = CSQL & " 	inner join [Sportsdiary].[dbo].[tblMember] M on L.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 		AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " WHERE L.DelYN = 'N' "
						CSQL = CSQL & " 	AND L.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 	AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 	AND DateDiff(HH, L.AdtReWriteDt, GetDate()) < 24 "
						
					CASE ELSE
						CSQL = " 		SELECT SUM(A.Cnt) Cnt "
						CSQL = CSQL & " FROM ( "
						CSQL = CSQL & " 	SELECT COUNT(*) Cnt "
						CSQL = CSQL & " 	FROM [Sportsdiary].[dbo].[tblSvcTrRerd]	L "
						CSQL = CSQL & " 		inner join [Sportsdiary].[dbo].[tblMember] M on L.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 			AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " 	WHERE L.DelYN = 'N' "
						CSQL = CSQL & " 		AND L.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 		AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 		AND DateDiff(HH, L.AdtReWriteDt, GetDate()) < 24 "
						CSQL = CSQL & " 	UNION ALL "
						CSQL = CSQL & " 	SELECT COUNT(distinct G.GameTitleIDX) Cnt "
						CSQL = CSQL & " 	FROM [Sportsdiary].[dbo].[tblSvcGameRerd] G	 "
						CSQL = CSQL & " 		inner join [Sportsdiary].[dbo].[tblMember] M on G.MemberIDX = M.MemberIDX "
						CSQL = CSQL & " 			AND M.MemberIDX = '"&MemberIDX&"' "
						CSQL = CSQL & " 	WHERE G.DelYN = 'N' "
						CSQL = CSQL & " 		AND G.SportsGb = '"&SportsGb&"' "
						CSQL = CSQL & " 		AND NOT(AdtAdvice IS NULL OR AdtAdvice = '') "
						CSQL = CSQL & " 		AND DateDiff(HH, G.AdtReWriteDt, GetDate()) < 24 "
						CSQL = CSQL & " ) A "
				END SELECT
				
				SET CRs = Dbcon.Execute(CSQL)
				If CRs(0) > 0 Then 
					CHK_VALUE = "TRUE"
				Else
					CHK_VALUE = "FALSE"
				End If 
					
					CRs.Close
				SET CRs = Nothing
				
				CHK_NEWDATA = CHK_VALUE	
					
			'체력측정
			CASE "STRENGTH"	
				
				CSQL = " 		SELECT COUNT(*) "
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcStimRerd] "
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
				CSQL = CSQL & " 	AND MemberIDX = '"&MemberIDX&"' "
				CSQL = CSQL & " 	AND DateDiff(HH, WriteDate, GetDate()) < 24 "
				
				SET CRs = Dbcon.Execute(CSQL)
				If CRs(0) > 0 Then 
					CHK_VALUE = "TRUE"
				Else
					CHK_VALUE = "FALSE"
				End If 
					
					CRs.Close
				SET CRs = Nothing
				
				CHK_NEWDATA = CHK_VALUE				
				
				
			CASE ELSE
				response.Write "FALSE"
				
		END SELECT
				 
		
		DBClose()
				
	END FUNCTION	
		
	IF TypeMenu = "" THEN
		response.Write "FALSE"
	ELSE	
		response.Write CHK_NEWDATA(TypeMenu)		
	END IF	

%>