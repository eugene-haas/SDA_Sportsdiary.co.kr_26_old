<!--#include file="../dev/dist/config.asp"-->
<%
	dim valIDX       : valIDX     = crypt.DecryptStringENC(fInject(request("valIDX")))
	dim valType      : valType    = fInject(request("valType"))

	dim CSQL, CRs
   
	IF valIDX = "" OR valType = "" Then
		response.Write "FALSE|200"
		response.End()
	Else
   		SELECT CASE valType
   			CASE "EP"
   
				CSQL = "    SELECT TOP 1 A.UserName "
				CSQL = CSQL & "   ,A.UserEnName "
				CSQL = CSQL & "   ,A.UserCnName "
				CSQL = CSQL & "   ,A.EnterType "
				CSQL = CSQL & "   ,CASE A.EnterType WHEN 'E' THEN '엘리트' ELSE '체육동호인' END EnterTypeNm"
				CSQL = CSQL & "	  ,A.PlayerType"
				CSQL = CSQL & "   ,D.PubName KoreaTeamNm"
				CSQL = CSQL & "	  ,F.PubName PlayerTypeNm"
				CSQL = CSQL & "   ,C.SubstituteYN"   
				CSQL = CSQL & "   ,CASE WHEN A.UserPhone <> '' THEN replace(A.UserPhone, '-', '') END UserPhone "
				CSQL = CSQL & "   ,CONVERT(CHAR(10), CONVERT(DATE, A.Birthday), 102) Birthday"
				CSQL = CSQL & "   ,A.Email "
				CSQL = CSQL & "   ,A.Sex "
				CSQL = CSQL & "   ,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
				CSQL = CSQL & "   ,A.WriteDate "
				CSQL = CSQL & "   ,A.EditDate "
				CSQL = CSQL & "   ,A.PersonCode "
				CSQL = CSQL & "   ,A.AthleteCode "
				CSQL = CSQL & "   ,A.Team"
				CSQL = CSQL & "   ,B.TeamNm"
				CSQL = CSQL & "   ,A.photo"
				CSQL = CSQL & "   ,A.RegYear" 
				CSQL = CSQL & "   ,A.MemberIDX" 
				CSQL = CSQL & "   ,A.BWFCode"  
				CSQL = CSQL & "   ,A.Nationality" 
   				CSQL = CSQL & "   ,G.CountryNm NationalityNm" 
				CSQL = CSQL & "   ,A.ZipCode" 
				CSQL = CSQL & "   ,A.Address" 
				CSQL = CSQL & "   ,A.AddressDtl"
				CSQL = CSQL & "   ,ISNULL(T.Paddress, '') AS Paddress"
				CSQL = CSQL & "   ,ISNULL(T.OfficeTel, '') AS OfficeTel"
				CSQL = CSQL & "   ,ISNULL(T.BloodType, '') AS BloodType"
				CSQL = CSQL & "   ,ISNULL(T.Mheight, '') AS Mheight"
				CSQL = CSQL & "   ,ISNULL(T.Mweight, '') AS Mweight"
				CSQL = CSQL & "   ,ISNULL(T.Leyesight, '') AS Leyesight"
				CSQL = CSQL & "   ,ISNULL(T.Reyesight, '') AS Reyesight"
				CSQL = CSQL & "   ,ISNULL(T.Specialty, '') AS Specialty"
				CSQL = CSQL & "   ,ISNULL(T.Mnote, '') AS Mnote"
				CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblMemberHistory] A"
				CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] B on A.Team = B.Team AND B.DelYN = 'N'"
				CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblMemberKorea] C on A.MemberIDX = C.MemberIDX AND C.DelYN = 'N'"
				CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblPubCode] D on C.TeamGb = D.PubCode AND D.DelYN = 'N' AND D.PPubCode = 'KOREATEAM'"
				CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblPubCode] F on A.PlayerType = F.PubCode AND F.DelYN = 'N' AND F.PPubCode = 'B008'"
   				CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblCountryInfo] G on A.Nationality = G.ct_serial AND G.DelYN = 'N'"
				CSQL = CSQL & "   LEFT OUTER JOIN [KoreaBadminton].[dbo].[tblMemberDtl] T on A.MemberIDX = T.MemberIDX"
				CSQL = CSQL & " WHERE A.DelYN = 'N'"
				CSQL = CSQL & "   AND A.MemberIDX = '"&valIDX&"'"
   				CSQL = CSQL & " ORDER BY A.MemberHistoryIDX DESC"
   
				SET CRs = DBCon.Execute(CSQL)
				IF NOT(CRs.Bof OR CRs.Eof) THEN
					MemberIDX = CRs("MemberIDX")
					PlayerType = CRs("PlayerType")
   					PlayerTypeNm = CRs("PlayerTypeNm")
					KoreaTeamNm = CRs("KoreaTeamNm")
					SubstituteYN = CRs("SubstituteYN")
					PersonCode = CRs("PersonCode")  
					AthleteCode = CRs("AthleteCode")
					BWFCode = CRs("BWFCode")
					UserName = CRs("UserName")
					EnterType = CRs("EnterType")
					EnterTypeNm = CRs("EnterTypeNm")
					UserEnName = ReHtmlSpecialChars(CRs("UserEnName"))
					UserPhone = CRs("UserPhone")      
					Email = CRs("Email")
					SEX = CRs("SEX")
					SexNm = CRs("SexNm")
					Birthday = CRs("Birthday")
					Team = CRs("Team")
					TeamNm = CRs("TeamNm")
					Nationality = CRs("Nationality")
   					NationalityNm = CRs("NationalityNm")
					ZipCode = CRs("ZipCode")
					Address   = ReHtmlSpecialChars(CRs("Address"))
					AddressDtl = ReHtmlSpecialChars(CRs("AddressDtl"))
					photo = CRs("photo")
					RegYear = CRs("RegYear")
					WriteDate = CRs("WriteDate")
					EditDate = CRs("EditDate")

					UserCnName  = ReHtmlSpecialChars(CRs("UserCnName"))
					Paddress    = TRIM(CRs("Paddress"))
					OfficeTel   = TRIM(CRs("OfficeTel"))
					BloodType   = TRIM(CRs("BloodType"))
					Mheight     = TRIM(CRs("Mheight"))
					Mweight     = TRIM(CRs("Mweight"))
					Leyesight   = TRIM(CRs("Leyesight"))
					Reyesight   = TRIM(CRs("Reyesight"))
					Specialty   = TRIM(CRs("Specialty"))
					Mnote       = TRIM(CRs("Mnote"))

					IF UserPhone <> "" Then
						'strUserPhone = split(UserPhone, "-")

						SELECT CASE len(UserPhone) 
							CASE 10 : 
								UserPhone1 = left(UserPhone, 3)
								UserPhone2 = mid(UserPhone, 4, 3)
								UserPhone3 = right(UserPhone, 4)
							CASE 11 : 
								UserPhone1 = left(UserPhone, 3)
								UserPhone2 = mid(UserPhone, 4, 4)
								UserPhone3 = right(UserPhone, 4)
						END SELECT

						'UserPhone1 = strUserPhone(0)
						'UserPhone2 = strUserPhone(1)
						'UserPhone3 = strUserPhone(2)
					End IF

					IF Email <> "" Then
						strEmail = split(Email, "@")
						Email1 = strEmail(0)
						Email2 = strEmail(1)
					End IF

					IF OfficeTel = "" OR OfficeTel = "--" THEN
						OfficeTel1 = ""
						OfficeTel2 = ""
						OfficeTel3 = ""
					ELSE
						OfficeTel1 = split(OfficeTel, "-")(0)
						OfficeTel2 = split(OfficeTel, "-")(1)
						OfficeTel3 = split(OfficeTel, "-")(2)
					END IF 
				
			
		%>

<table class="user_detail left-head view-table">
  <tr>
    <th rowspan="16" valign="top"> <%
						IF Photo <> "" Then
							response.write "<img src='"&global_filepathUrl&"Player/"&EnterType&"/"&Photo&"' width='80' alt=''>"
						Else
							response.write "<img src='../images/profile@3x.png' width='80' alt=''>"
						End IF
						%>
    </th>
    <th>국적</th>
    <td><%=NationalityNm%></td>
    <th>내외국인 구분</th>
    <td><%=PlayerTypeNm%></td>
  </tr>
  <tr>
    <th>등록년도</th>
    <td><%=RegYear%></td>
    <th>선수구분</th>
    <td><%=EnterTypeNm%></td>
  </tr>

  <tr>
    <th>대표팀구분</th>
    <td><%=KoreaTeamNm%>
    <%IF SubstituteYN = "Y" Then response.write "후보팀" End IF%></td>
    <th>BWF Code</th>
    <td><%=BWFCode%></td>
  </tr>

  <tr>
    <th>소속팀</th>
    <td><%=TeamNm%> [ <%=Team%> ] </td>
    <th>체육인번호</th>
    <td><%=AthleteCode%></td>
  </tr>
	
  <tr>
    <th>이름</th>
    <td><%=UserName%></td>
    <th>영문이름</th>
    <td><%=UserEnName%></td>
  </tr>
  <tr>
    <th>한문이름</th>
    <td><%=UserCnName%></td>
    <th>성별</th>
    <td><%=SexNm%></td>
  </tr>
  <tr>
    <th>생년월일</th>
    <td><%=Birthday%></td>
    <th>휴대폰</th>
    <td><%=UserPhone1%> <span>-</span> <%=UserPhone2%> <span>-</span> <%=UserPhone3%></td>
  </tr>

  <tr>
    <th>이메일</th>
    <td><%=Email1%> <span>@</span> <%=Email2%></td>
	<th>본적</th>
    <td><%=Paddress%></td>	
  </tr>
  <tr>
    <th>주소</th>
    <td colspan="3"><div class="stair"> <%=ZipCode%> </div>
    <div class="stair under-line"> <%=Address%> <%=AddressDtl%> </div></th>
  </tr>
  <tr>
    <th>전화번호(사무실)</th>
    <td><%=OfficeTel1%> <span>-</span> <%=OfficeTel2%> <span>-</span> <%=OfficeTel3%></td>
    <th>키</th>
    <td><%=Mheight%></td>
  </tr>

  <tr>
    <th>시력</th>
    <td>[좌] <%=Leyesight%>&nbsp;&nbsp;
    [우] <%=Reyesight%></td>
    <th>혈액형</th>
    <td><%=BloodType%></td>
  </tr>

  <tr>
    <th>몸무게</th>
    <td><%=Mweight%></td>
    <th>특기,장기</th>
    <td><%=Specialty%></td>
  </tr>

  <tr>
    <th>특이사항</th>
    <td colspan="3"><%=Mnote%></td>
  </tr>

</table>
<%	
   		Else
   			response.write "<div>일치하는 정보가 없습니다.</div>"	
   		End IF      
					CRs.Close
				SET CRs = Nothing
   
		   CASE "EL"
		   	
		   	CSQL = "    	SELECT TOP 1 A.UserName "
			CSQL = CSQL & "   ,A.UserEnName "
			CSQL = CSQL & "   ,replace(A.UserPhone,'-','') UserPhone "
			CSQL = CSQL & "   ,A.UserTel "
			CSQL = CSQL & "   ,A.Birthday"
			CSQL = CSQL & "   ,A.Email "
			CSQL = CSQL & "   ,A.Sex "
			CSQL = CSQL & "   ,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
			CSQL = CSQL & "   ,A.WriteDate "
			CSQL = CSQL & "   ,A.ModDate "
			CSQL = CSQL & "   ,A.PersonNum "
			CSQL = CSQL & "   ,A.AthleteNum "
			CSQL = CSQL & "   ,A.Team"
			CSQL = CSQL & "   ,C.TeamNm"
			CSQL = CSQL & "   ,A.ZipCode"
			CSQL = CSQL & "   ,A.Address"
			CSQL = CSQL & "   ,A.AddressDtl"
			CSQL = CSQL & "   ,A.LeaderType"
			CSQL = CSQL & "   ,A.LeaderTypeNm"
			CSQL = CSQL & "   ,A.LeaderTypeSub"
			CSQL = CSQL & "   ,B.PubName LeaderTypeSubNm"
			CSQL = CSQL & "   ,A.photo"
			CSQL = CSQL & "   ,A.RegistYear"  
			CSQL = CSQL & "   ,A.LeaderIDX" 
			CSQL = CSQL & "   ,ISNULL(T.UserCnName, '') AS UserCnName"
			CSQL = CSQL & "   ,ISNULL(T.BWFCode, '') AS BWFCode"
			CSQL = CSQL & "   ,ISNULL(T.Paddress, '') AS Paddress"
			CSQL = CSQL & "   ,ISNULL(T.OfficeTel, '') AS OfficeTel"
			CSQL = CSQL & "   ,ISNULL(T.BloodType, '') AS BloodType"
			CSQL = CSQL & "   ,ISNULL(T.Mheight, '') AS Mheight"
			CSQL = CSQL & "   ,ISNULL(T.Mweight, '') AS Mweight"
			CSQL = CSQL & "   ,ISNULL(T.Leyesight, '') AS Leyesight"
			CSQL = CSQL & "   ,ISNULL(T.Reyesight, '') AS Reyesight"
			CSQL = CSQL & "   ,ISNULL(T.Specialty, '') AS Specialty"
			CSQL = CSQL & "   ,ISNULL(T.Mnote, '') AS Mnote"
			CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory] A"
			CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblPubCode] B on A.LeaderTypeSub = B.PubCode AND B.DelYN = 'N' AND B.PPubCode = 'COACH'"
			CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] C on A.Team = C.Team AND C.DelYN = 'N'"
			CSQL = CSQL & "   LEFT OUTER JOIN [KoreaBadminton].[dbo].[tblLeaderInfoDtl] T on A.LeaderIDX = T.LeaderIDX"
			CSQL = CSQL & " WHERE A.DelYN = 'N'"
			CSQL = CSQL & "   AND A.LeaderIDX = '"&valIDX&"'"
   			CSQL = CSQL & " ORDER BY A.LeaderHistoryIDX DESC"
			
   
			SET CRs = DBCon.Execute(CSQL)
			IF NOT(CRs.Bof OR CRs.Eof) THEN
				
				PersonNum = CRs("PersonNum")
				AthleteNum = CRs("AthleteNum")
				UserName = CRs("UserName")
				UserEnName = ReHtmlSpecialChars(CRs("UserEnName"))
				UserPhone = CRs("UserPhone")
				UserTel = CRs("UserTel")
				Email = CRs("Email")
				SEX = CRs("SEX")
				SexNm = CRs("SexNm")
				Birthday = CRs("Birthday")
				Team = CRs("Team")
				TeamNm = CRs("TeamNm")
				ZipCode = CRs("ZipCode")
				Address   = ReHtmlSpecialChars(CRs("Address"))
				AddressDtl = ReHtmlSpecialChars(CRs("AddressDtl"))
				LeaderType = CRs("LeaderType")
				LeaderTypeNm = CRs("LeaderTypeNm")
				LeaderTypeSub = CRs("LeaderTypeSub")      
				photo = CRs("photo")
				RegistYear = CRs("RegistYear")
				WriteDate = CRs("WriteDate")
				ModDate = CRs("ModDate")

				UserCnName  = ReHtmlSpecialChars(CRs("UserCnName"))
				BWFCode     = TRIM(CRs("BWFCode"))
				Paddress    = TRIM(CRs("Paddress"))
				OfficeTel   = TRIM(CRs("OfficeTel"))
				BloodType   = TRIM(CRs("BloodType"))
				Mheight     = TRIM(CRs("Mheight"))
				Mweight     = TRIM(CRs("Mweight"))
				Leyesight   = TRIM(CRs("Leyesight"))
				Reyesight   = TRIM(CRs("Reyesight"))
				Specialty   = TRIM(CRs("Specialty"))
				Mnote       = TRIM(CRs("Mnote"))

				SELECT CASE len(UserPhone) 
					CASE 10 : 
						UserPhone1 = left(UserPhone, 3)
						UserPhone2 = mid(UserPhone, 4, 3)
						UserPhone3 = right(UserPhone, 4)
					CASE 11 : 
						UserPhone1 = left(UserPhone, 3)
						UserPhone2 = mid(UserPhone, 4, 4)
						UserPhone3 = right(UserPhone, 4)
				END SELECT
				IF UserTel <> "" Then
					strUserTel = split(UserTel, "-")
					UserTel1 = strUserTel(0)
					UserTel2 = strUserTel(1)
					UserTel3 = strUserTel(2)
				End IF

				IF Email <> "" Then
					strEmail = split(Email, "@")
					Email1 = strEmail(0)
					Email2 = strEmail(1)
				End IF

				IF OfficeTel = "" OR OfficeTel = "--" THEN
					OfficeTel1 = ""
					OfficeTel2 = ""
					OfficeTel3 = ""
				ELSE
					OfficeTel1 = split(OfficeTel, "-")(0)
					OfficeTel2 = split(OfficeTel, "-")(1)
					OfficeTel3 = split(OfficeTel, "-")(2)
				END IF

			
		   %>
			<table class="user_detail left-head view-table">
            <tr>
                <th rowspan="16" valign="top">
                <%
                IF Photo <> "" Then
                    response.write "<img src='"&global_filepathUrl&"Leader/"&Photo&"' width='80' alt=''>"
                Else
                    response.write "<img src='../images/profile@3x.png' width='80' alt=''>"
                End IF
                %></th>
                <th>구분</th>
                <td><%=LeaderTypeNm%></td>
                <th>등록년도</th>
                <td>
                    <%=RegistYear%> 

                </td>
            </tr>
            <tr>
              <th>코치구분</th>
              <td><%=LeaderTypeSubNm%></td>
                <th>소속팀</th>
                <td><%=TeamNm%> [ <%=Team%> ]</td>
            </tr>
            <tr>
              <th>체육인번호</th>
              <td><%=AthleteNum%></td>
                <th>BWF Code</th>
                <td><%=BWFCode%></td>
            </tr>

           
            <tr>
              <th>이름</th>
              <td><%=UserName%></td>
                <th>영문이름</th>
                <td><%=UserEnName%></td>
            </tr>
            <tr>
              <th>성별</th>
              <td><%=SexNm%></td>
                <th>한문이름</th>
                <td><%=UserCnName%></td>
            </tr>
            <tr>
              <th>생년월일</th>
              <td><%=Birthday%></td>
                <th>휴대폰</th>
                <td><%=UserPhone1%> <span>-</span> <%=UserPhone2%> <span>-</span> <%=UserPhone3%></td>
            </tr>
            <tr>
              <th>이메일</th>
              <td><%=Email1%> <span>@</span> <%=Email2%> </td>
                <th>본적</th>
                <td><%=Paddress%></td>
            </tr>
            <tr>
              <th>주소</th>
              <td colspan="3"><div class="stair"><%=ZipCode%> </div>
              <div class="stair under-line"> <%=Address%> <%=AddressDtl%> </div></td>
              </tr>            

           
            <tr>
              <th>전화번호(사무실)</th>
              <td><%=OfficeTel1%> <span>-</span> <%=OfficeTel2%> <span>-</span> <%=OfficeTel3%> </td>
                <th>혈액형</th>
                <td><%=BloodType %></td>
            </tr>
           
            <tr>
              <th>몸무게</th>
              <td><%=Mweight%></td>
                <th>키</th>
                <td>
                    <%=Mheight%>
                </td>
            </tr>
            <tr>
              <th>시력</th>
              <td>[좌] <%=Leyesight%> [우] <%=Reyesight%></td>
                <th>특기,장기</th>
                <td><%=Specialty%></td>
            </tr>
            <tr>
              <th>특이사항</th>
              <td colspan="3"><%=Mnote%></td>
              </tr>

         
        </table>
			<%
			Else
			   response.write "<div>일치하는 정보가 없습니다.</div>"	
			End IF      
				CRs.Close
			SET CRs = Nothing    
		End SELECT
	End IF
			   
	DBClose()
			   
	%>
