<!--#include file="../../dev/dist/config.asp"-->
<%
    '==============================================================================
	'참가신청 상세보기 조회
	'==============================================================================
	
   	dim valType 		: valType 			= fInject(Request("valType"))   									'구분자[개인전:B0030001 | 단체전:B0030002 | 신청자정보:INFO]
   	dim GameTitleIDX	: GameTitleIDX      = crypt.DecryptStringENC(fInject(Request("GameTitleIDX")))     		'대회정보 IDX
	dim PayGroupNum		: PayGroupNum       = crypt.DecryptStringENC(fInject(Request("PayGroupNum")))      		'결제그룹번호	
   	dim ReceptionistIDX : ReceptionistIDX 	= crypt.DecryptStringENC(fInject(Request("ReceptionistIDX")))    	'신청자 MemberIDX
	dim EnterType     	: EnterType       	= crypt.DecryptStringENC(fInject(Request("EnterType")))
																												 
	dim LSQL, LRs
	dim RE_DATA

  	IF valType = "" OR GameTitleIDX = ""  OR ReceptionistIDX = "" OR PayGroupNum = "" OR EnterType = "" Then
   		Response.Write "FALSE|200|"    
   	Else
   		'신청자 정보
		IF valType = "INFO" THEN
   			LSQL = "		SELECT A.GameEnterInfoIDX"	
			LSQL = LSQL & "		,A.UserName"
			LSQL = LSQL & "		,A.MobilePhone"
			LSQL = LSQL & "		,A.Email" 	
			LSQL = LSQL & "		,CASE WHEN A.GEIType IS NOT NULL OR A.GEIType<>'' THEN B.PubName + ' 이름' END SUBTITLE"
			LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblGameEnterInfo] A"
			LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubcode] B on A.GEIType = B.PubCode"
			LSQL = LSQL & "			AND B.DelYN = 'N'"
			LSQL = LSQL & "			AND B.PPubCode = 'RQGEIType'"
			LSQL = LSQL & "	WHERE A.DelYN = 'N'"
			LSQL = LSQL & "		AND A.EnterType = '"&EnterType&"'"		
			LSQL = LSQL & "		AND A.GameTitleIDX = '"&GameTitleIDX&"'" 	
			LSQL = LSQL & "		AND A.ReceptionistIDX = '"&ReceptionistIDX&"'"
			LSQL = LSQL & "	ORDER BY B.OrderBy, A.UserName"
			
   			SET LRs = DBCon.Execute(LSQL) 
			IF Not(LRs.Eof Or LRs.Bof) Then 
				Do Until LRs.eof
																			 
					RE_DATA = RE_DATA & "<tr>"
					RE_DATA = RE_DATA & "	<th>"&LRs("SUBTITLE")&"</th>"
					RE_DATA = RE_DATA & "	<td>"&LRs("UserName")&"</td>"
					RE_DATA = RE_DATA & "	<th>휴대폰 번호</th>"
					RE_DATA = RE_DATA & "	<td>"&LRs("MobilePhone")&"</td>"
					RE_DATA = RE_DATA & "	<th>E-mail</th>"
					RE_DATA = RE_DATA & "	<td>"&LRs("Email")&"</td>"
					RE_DATA = RE_DATA & "</tr>"

   					LRs.Movenext
   				Loop
   			End IF
   				LRs.Close
  			SET LRs = Nothing
																			 
			Response.Write "TRUE|"&RE_DATA&"|"	
																			 
																			 
																			 
   		
		'개인전/단체전 참가정보																			 
   		ELSE
   
			SELECT CASE EnterType

				CASE "A"   				

					LSQL = "		SELECT A.GameEnterIDX"
					LSQL = LSQL & "		,[KoreaBadminton].[dbo].[FN_SidoName](H.Sido) SidoNm"   	
					LSQL = LSQL & "		,[KoreaBadminton].[dbo].[FN_SidoGuGunName](H.Sido, H.SidoGuGun) SidoGuGunNm"   	
					LSQL = LSQL & "		,D.PubName GameType"   	
					LSQL = LSQL & "		,C.TeamGbNm TeamGbNm"   	
					LSQL = LSQL & "		,CASE A.Sex WHEN 'Man' THEN '남자' WHEN 'WoMan' THEN '여자' ELSE '혼합' END PlayTypeTeamGb"   	
					LSQL = LSQL & "		,E.PubName PlayTypeNm"   	
					LSQL = LSQL & "		,G.LevelNm LevelNm "
					LSQL = LSQL & "		,CASE A.GroupGameGb WHEN 'B0030001' THEN CASE WHEN F.PubName <> '' THEN F.PubName END ELSE CASE WHEN A.GroupGubun <> '' THEN A.GroupGubun + '조' END END GameGroupNm"   	
					LSQL = LSQL & "		,A.UserName"
					LSQL = LSQL & "		,A.UserTeamNm"
					LSQL = LSQL & "		,A.UserTeam"
					LSQL = LSQL & "		,B.UserPhone UserPhone"
					LSQL = LSQL & "		,B.AthleteCode"
					LSQL = LSQL & "		,CASE B.Sex WHEN 'Man' THEN '남' ELSE '여' END SEX"	
					LSQL = LSQL & "		,A.PartnerName"
					LSQL = LSQL & "		,A.PartnerTeamNm"
					LSQL = LSQL & "		,J.UserPhone PartnerPhone" 	
					LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblGameEnter] A"   	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblMember] B on A.MemberIDX = B.MemberIDX AND B.DelYN = 'N' AND B.EnterType = '"&EnterType&"'"   	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblMember] J on A.PartnerIDX = J.MemberIDX AND J.DelYN = 'N' AND J.EnterType = '"&EnterType&"'"   	
					LSQL = LSQL & "		inner join [KoreaBadminton].[dbo].[tblLevelInfo] G on A.Level = G.Level AND G.DelYN = 'N' AND G.EnterType = '"&EnterType&"'"   	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblTeamInfo] H on A.UserTeam = H.Team AND H.DelYN = 'N' AND H.EnterType = '"&EnterType&"'"   	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblTeamGbInfo] C on A.TeamGb = C.TeamGb AND C.DelYN = 'N'"   	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] D on A.GroupGameGb = D.PubCode AND D.DelYN = 'N'"   	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] E on A.PlayType = E.PubCode AND E.DelYN = 'N'"   	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] F on A.LevelJooName = F.PubCode AND F.DelYN = 'N'"    	
					LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] I on A.Status = I.PubCode AND I.DelYN = 'N'"  
					LSQL = LSQL & "	WHERE A.DelYN = 'N'"   	
					LSQL = LSQL & "		AND A.TeamDefaultYN = 'Y'"   	
					LSQL = LSQL & "		AND A.EnterType = '"&EnterType&"'"   	
					LSQL = LSQL & "		AND A.GameTitleIDX = '"&GameTitleIDX&"'" 
					LSQL = LSQL & "		AND A.ReceptionistIDX = '"&ReceptionistIDX&"'"
					LSQL = LSQL & "		AND A.GroupGameGb = '"&valType&"'"	
					LSQL = LSQL & "		AND A.PayGroupNum = '"&PayGroupNum&"'"
					LSQL = LSQL & "	ORDER BY A.GroupGameGb, A.TeamGb, A.Sex, E.OrderBy, G.Orderby, H.Sido, H.SidoGuGun, D.OrderBy, A.LevelJooName, A.GroupGubun, A.UserName, A.InsDate"

	'			   	response.write LSQL

					SET LRs = DBCon.Execute(LSQL) 
					IF Not(LRs.Eof Or LRs.Bof) Then 
						Do Until LRs.eof

							
							IF valType = "B0030001" Then	'개인전
   								cnt = cnt + 1				'개인전 참가팀 카운트

								RE_DATA = RE_DATA & "<tr>"
								RE_DATA = RE_DATA & "	<td>["&LRs("TeamGbNm")&"] "&LRs("PlayTypeTeamGb")&" "&LRs("PlayTypeNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("LevelNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("GameGroupNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("SidoNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("SidoGuGunNm")&"</td>"
								RE_DATA = RE_DATA & "	<td class='club_name'><span>"&LRs("UserName")&"("&LRs("UserTeamNm")&")</span></td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("UserPhone")&"</td>"
								RE_DATA = RE_DATA & "	<td class='club_name'><span>"&LRs("PartnerName")&"("&LRs("PartnerTeamNm")&")</span></td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("PartnerPhone")&"</td>"
								RE_DATA = RE_DATA & "</tr>"

							Else '단체전
								
   								'단체전 그룹 카운트 로직 개발필요
								 
								RE_DATA = RE_DATA & "<tr>"
								RE_DATA = RE_DATA & "	<td>["&LRs("TeamGbNm")&"] "&LRs("PlayTypeTeamGb")&" "&LRs("PlayTypeNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("LevelNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("GameGroupNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("SidoNm")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("SidoGuGunNm")&"</td>"
								RE_DATA = RE_DATA & "	<td class='club_name'><span>"&LRs("UserTeamNm")&"</span></td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("UserTeam")&"</td>"								
								RE_DATA = RE_DATA & "	<td>"&LRs("UserName")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("AthleteCode")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("SEX")&"</td>"
								RE_DATA = RE_DATA & "	<td>"&LRs("UserPhone")&"</td>"
								RE_DATA = RE_DATA & "</tr>"

							End IF

							LRs.Movenext
						Loop
					Else
						IF valType = "B0030001" Then	'개인전
							RE_DATA = RE_DATA & "<tr><td colspan='9'>등록된 개인전 참가신청 정보가 없습니다.</td></tr>"
						Else
							RE_DATA = RE_DATA & "<tr><td colspan='11'>등록된 단체전 참가신청 정보가 없습니다.</td></tr>"									   
						End IF															   
					End IF
						LRs.Close
					SET LRs = Nothing

					Response.Write "TRUE|"&RE_DATA&"|"&cnt


				CASE "E"																	 	
			END SELECT
		END IF   
  	END IF

  	DBClose()
  
%>