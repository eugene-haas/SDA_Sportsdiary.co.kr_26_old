<%
  tidx = oJSONoutput.TitleIDX 
  gamekey3 =  oJSONoutput.S3KEY
  levelkey = gamekey3
  levelno = levelkey
  gamekey3 = Left(gamekey3,5)
  chkjoono =  oJSONoutput.JONO
  
  Set db = new clsDBHelper

  '전체 예선 참가자 =============================================s
    SQL = "select gubun,place from  sd_TennisMember where  GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and tryoutgroupno > 0  and gubun in ( 0, 1) and DelYN = 'N' " 
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then 
		arrRSALL = rs.getrows()
    End If
    Set rs = Nothing

	'조편성 상태 확인하기
	showordersell = True '전체 편성상태
    placestate = True '장소가 모두 입력되었음
	If IsArray(arrRSALL) Then
    For ar = LBound(arrRSALL, 2) To UBound(arrRSALL, 2) 
      chk_gn = arrRSALL(0,ar)
	  chk_place = arrRSALL(1,ar)

	  If chk_place = "" Then
		placestate = false
	  End if

	  If chk_gn = 0 Then
		showordersell = False 
		'Exit For
	  End if
	Next
	End If 
  '전체 예선 참가자 =============================================e
   
  
  
  SQL = " Select a.tryoutgroupno, a.tryoutsortno, a. gamememberIDX, a.userName as aname , a.teamAna as aATN, a.teamBNa as aBTN,a.rankpoint , b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN,b.rankpoint, a.rankpoint + b.rankpoint as totalPointWithPartner, a.AttFlag, a.GiftFlag, a.gameMemberIDX, a.PlayerIDX as PlayerIDX, b.PlayerIDX as PatnerPlayerIDX, a.gubun,t_rank, a.areaChanging, A.SeedFlag, A.rndno1, A.rndno2, A.place "
  SQL = SQL & " from sd_TennisMember as a "
  SQL = SQL & " LEFT JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX  "
  SQL = SQL & " where a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelkey  &" and a.tryoutgroupno > 0 and a.gubun in ( 0, 1) and tryoutgroupno = " & chkjoono & " and a.DelYN = 'N'  "
  SQL = SQL & " order by  a.tryoutsortno asc "

  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)   
  If Not rs.EOF Then 
    arrRS = rs.getrows()
  End If

  SQL = " Select EntryCnt,attmembercnt,courtcnt,level,bigo,fee,fund from   tblRGameLevel  where DelYN = 'N' and  GameTitleIDX = " & tidx & " AND Level = " & levelno
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
    entrycnt = rs("entrycnt") '참가제한인원수
    attmembercnt = rs("attmembercnt") '참가신청자수
    courtcnt = rs("courtcnt") '코트수
    levelno = rs("level")

	fee = rs("fee") '참가비
	fund = rs("fund") '기금
	acctotal = CDbl(fee) + CDbl(fund) '참가금액
  End if

  SQL = " select courtno,stateno ,courtkind,tryoutgroupno  " & _
      " ,case ynChek1 when 1 then 1 else case ynChek2 when 1 then 1 else 0 end  end  ynChek " & _
      " from ( " & _
          " Select courtno,stateno ,courtkind,tryoutgroupno " & _
          " ,isnull((select 1 from sd_TennisMember where (gameMemberIDX = a.gameMemberIDX1) and DelYN='N' ),0) ynChek1 " & _
          " ,isnull((select 1 from sd_TennisMember where (gameMemberIDX = a.gameMemberIDX2) and DelYN='N' ),0) ynChek2 " & _
          " from sd_TennisResult a where delYN = 'N' and GameTitleIDX = " & tidx & " and Level = '"& levelno &"'  " & _ 
      " ) a  " & _ 
      " group by  courtno,stateno ,courtkind,tryoutgroupno  " & _ 
      " , case ynChek1 when 1 then 1 else case ynChek2 when 1 then 1 else 0 end  end "
  
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
    useCourtRS = rs.GetRows()
  End If
%>

<%
  '타입 석어서 보내기
  Call oJSONoutput.Set("result", "0" )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<%
  If IsArray(arrRS) Then
    tdcnt = 0

%>
<td>
  <%=chkjoono%>
</td>
<%
   For j = 1 To 3
    chkdata = "N"
    For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
        gno =     arrRS(0,ar)
        sortno =    arrRS(1,ar)
        p1idx =     arrRS(2,ar)
        p1name =    arrRS(3,ar)
        p2name =    arrRS(8,ar)
        rpointsum = arrRS(12,ar)
        rAttFlag = arrRS(13,ar)
        rGiftFlag = arrRS(14,ar)
        rGameMemberIDX = arrRS(15,ar)
        rPlayerIDX = arrRS(16,ar)
        rPlayerIDXSUB = arrRS(17,ar)
        gubun = arrRS(18,ar)
        t_rank = arrRS(19,ar)
        rareaChanging = arrRS(20,ar)
        rSeedFlag = arrRS(21,ar)
        rRndNo1 = arrRS(22,ar)
        rRndNo2 = arrRS(23,ar)
        rPlace = arrRS(24,ar)

		tnm1 = arrRS(4,ar)
		tnm2 = arrRS(5,ar)
		tnm3 = arrRS(9,ar)
		tnm4 = arrRS(10,ar)
        
        If CDbl(sortno) = CDbl(j) And CDbl(gno) = CDbl(chkjoono) Then
          chkdata = "Y"
          tdcnt = CDbl(tdcnt) + 1
          chkgubun = gubun
          if ISNULL(rRndNo1) Then
            rRndNo1 = ""
          End If
          if isnull(rRndNo2)  Then
            rRndNo2 = ""
          End If
        %>

       
		<%If showordersell = True Then '모든조가 편성되었다면%>	   
		   <%If j = 1 and CDbl(tdcnt) = 1 Then%>
			  <%If placestate = True then%>
				  <td>
					<input type="number" min="1" step="1" name="rndno1[]" id="rndno1_<%=chkjoono%>" onblur='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","1",this);' value="<%=rRndNo1%>"
					<%If CDbl(chkgubun) = 0 then%>
						disabled="disabled"
					<%End If%>
					<%If CDbl(chkgubun) = 1  and Cstr(rRndNo1) = "0" then%>
					  style="border-color:red;" 
					<%else%>

					<%End If%>
					>
				  </td>
				  <td>
				  <input type="number" min="1" step="1" name="rndno2[]" id="rndno2_<%=chkjoono%>" onblur='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","2",this);' value="<%=rRndNo2%>"
				  <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
				  <%If CDbl(chkgubun) = 1 and Cstr(rRndNo2) = "0" then%>
					style="border-color:red;" 
				  <%else%>

				  <%End If%>
				  >
				  </td>
			  <%End if%>


			<%End If%>
		<%End if%>

	   <%If j = 1 and CDbl(tdcnt) = 1 Then%>
			  <td>
				<input id="place_<%=chkjoono%>"type="text" style="width:80px"  value="<%=rPlace%>">
			  </td>
	   <%End if%>


 <td class="<%If CDbl(chkgubun) = 1 then%>make_comp chk_col<%else%>making_group chk_col<%end if%>">
          <div        
        <%If CDbl(chkgubun) = 0 then%>
            <% IF rareaChanging = "Y" then %>
              style='border: 1px solid #73AD21; width:100%; background-color: #f7dbdc;'
            <% Else %>
                style='border: 1px solid #73AD21; width:100%; height: 100%;'
            <% END IF %>
            onClick='mx.changeSelectArea(<%=rGameMemberIDX%>,this,<%=chkjoono%>,<%=j%>,<%=strjson%>)'
        <%else%>
            
        <%End if%>
            id='drag_<%=gno%>_<%=sortno%>'>
		<%if chkgubun = "0" then%><a href='javascript:mx.delTeam(<%=strjson%>)' class=" btn_del">X</a><%End if%>


		<%'if chkgubun = "0" then%> 		  
		    <%'If CDbl(ADGRADE) <= 500 then%>
			  <div class="chk_state">
				<%
				  oJSONoutput.GAMEMEMBERIDX = rGameMemberIDX
				  oJSONoutput.PLAYERIDX = rPlayerIDX
				  oJSONoutput.PLAYERIDXSUB = rPlayerIDXSUB
				  strjson = JSON.stringify(oJSONoutput)   

				  SQL =  "SELECT top 1 a.PaymentType,p.VACCT_NO FROM tblGameRequest as a left join SD_RookieTennis.dbo.TB_RVAS_LIST as p ON '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar) = p.CUST_CD WHERE  a.P1_PlayerIDX ="&rPlayerIDX&" and a.P2_PlayerIDX ="&rPlayerIDXSUB&" and a.DelYN = 'N' and a.GameTitleIDX = "&tidx&" and a.Level =" & levelkey 				  
				  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				  If Not rs.EOF Then 
					rPaymentFlag = rs("PaymentType")
					rVacctno = rs("VACCT_NO")
				  End If
				%>
			      <span >출석</span>
				  <label class="switch" title="출석">
					<input type="checkbox"  name="attCheckBox" class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"att",this);' <% if( rAttFlag = "Y") Then%> checked <%END IF%> ><span class="slider round"></span>
				  </label>
			      <span >사은품</span>
				  <label class="switch"  title="사은품">
					<input type="checkbox"  name="giftCheckBox"  class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"gift",this);' <% if( rGiftFlag = "Y") Then%> checked <%END IF%>><span class="slider round"></span>
				  </label>
				  <%If CDbl(acctotal) = 0 then%>
				  <span >입금</span>
				  <label class="switch"  title="입금">
					<input type="checkbox"  name="paymentCheckBox" class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"payment",this);'  <% if( rPaymentFlag = "Y") Then%> checked  disabled<%END IF%>><span class="slider round"></span>
				  </label>
				  <%else%>
						<%If rVacctno = "" Or isNull(rVacctno) = True Or rVacctno = "1" Then%>
							  <span >입금</span>
							  <label class="switch"  title="입금">
								<input type="checkbox"  name="paymentCheckBox" class="checkboxFlag" onClick='mx.flagChange(<%=strjson%>,"payment",this);'  <% if( rPaymentFlag = "Y") Then%> checked  disabled<%END IF%>><span class="slider round"></span>
							  </label>
						<%Else%>
							<span style="color:red;">입금완료</span>
						<%End If%>
				  <%End if%>

			  </div>
		    <%'End if%>
		<%'End if%>		      


          <!-- S: chk_state -->
          <div class="chk_state">
            
            <%If CDbl(chkgubun) = 1 then%>
				<%
				  oJSONoutput.P1 = p1idx
				  oJSONoutput.POS = "rankL_" & chkjoono & "_"& tdcnt
				  oJSONoutput.JONO = gno
				  strjson = JSON.stringify(oJSONoutput)
				%>
			    <%'If showordersell = True And placestate = True Then '모든조가 편성되었다면%>
					<select id="rankL_<%=chkjoono%>_<%=tdcnt%>"  onchange='javascript:mx.SetGameLeagueRanking(<%=strjson%>)'
						<%if Cdbl(t_rank) >= 1 and Cdbl(t_rank) < 3 Then%>
						  style="background-color:#3e7c00;color:<%if Cdbl(t_rank) = 1  then%>red<%else%>#fff<%End if%>;" 
						<%else%>

						<%END IF%>>
					  <option value="0"  <%If t_rank = "0" then%>selected<%End if%>>순위</option>
					  <option value="1"  <%If t_rank = "1" then%>selected<%End if%>>1위</option>
					  <option value="2"  <%If t_rank = "2" then%>selected<%End if%>>2위</option>
					<%If Right(levelno,3) = "007" then%>
					<option value="3"  <%If t_rank = "3" then%>selected<%End if%>>3위</option>
					<%End if%>
					</select>
			    <%'End if%>
            <%End if%>
            <a href='javascript:mx.updateMember(<%=strjson%>)' role="button" 
			<%If CDbl(chkgubun) = 1 then%>style="border:1px solid #DEBA29;"<%else%>class="btn_a btn_updateMember"  <%End if%>
			><%=p1name%>&nbsp;<%=p2name%></a>

			<%If CDbl(ADGRADE) > 500 then%>
			<input type="text" style="width:50px;" onblur='mx.update_rpoint(<%=strjson%>,<%=p1idx%>,this.value);' value="<%=rpointsum%>" title="포인트합: 수정후 포커스가 이동되면 수정됩니다."> 
			<%End if%>
			<br><br><%=tnm1%>&nbsp;<%=tnm2%> : <%=tnm3%>&nbsp;<%=tnm4%>	
          </td>
      <%
      END IF
    Next

     If chkdata = "N" Then
		  tdcnt = CDbl(tdcnt) + 1

		  If j = 1 and CDbl(tdcnt) = 1 Then
			SQL = " select Top 1 A.gubun, A.rndno1, A.rndno2, A.place  "
			SQL = SQL & " from sd_TennisMember as a LEFT JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX"
			SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.gamekey3 = "& levelno & " and a.tryoutgroupno = " & chkjoono & " and a.gubun in ( 0, 1) and a.DelYN = 'N' "
			Set gubunRS = db.ExecSQLReturnRS(SQL , null, ConStr)

			Do Until gubunRS.EOF 
			  chkgubun = gubunRS("gubun")
			  rRndNo1 = gubunRS("rndno1")
			  rRndNo2 = gubunRS("rndno2")
			  rPlace = gubunRS("place")
			  Call oJSONoutput.Set("GUBUN", chkgubun )
			  gubunRS.movenext
			Loop

		   if ISNULL(rRndNo1)  Then
			rRndNo1 = 0
			End If
			if isnull(rRndNo2)Then
			  rRndNo2 = 0
			End If
	    %>
       </div>
          <!-- E: chk_state -->
	  <%If placestate = True then%>
	  <td>
        <input type="text"  name="rndno1[]" id="rndno1_<%=chkjoono%>" onblur='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","1",this);' value="<%=rRndNo1%>"
        <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
        <%If CDbl(chkgubun) = 1 and CDbl(rRndNo1) = 0 then%>
          style="border-color:red;" 
        <%End If%>
		>
      </td>

      <td>
        <input type="text"  name="rndno2[]" id="rndno2_<%=chkjoono%>" onblur='mx.update_rndno(<%=strjson%>,"<%=rGameMemberIDX%>","2",this);' value="<%=rRndNo2%>"
        <%If CDbl(chkgubun) = 0 then%>disabled="disabled"<%End If%>
        <%If CDbl(chkgubun) = 1 and CDbl(rRndNo2) = 0 then%>
        style="border-color:red;" 
        <%End If%>
		>
      </td>
	  <%End if%>

      <td>
        <input id="place_<%=chkjoono%>"type="text" style="width:80px"  value="<%=rPlace%>">
      </td>

     <%End If%>

      <%If CDbl(chkgubun) = 0 then%>
        <td class="<%If CDbl(chkgubun) = 1 then%>make_comp chk_col<%else%>making_group chk_col<%end if%>">
        <div style='border: 0px solid #73AD21; width:100%; height: 100%;padding: 2px 0px;' 
          onClick='mx.changeSelectArea(0,this,<%=chkjoono%>,<%=j%>,<%=strjson%>)'
          id='drag_<%=chkjoono%>_<%=j%>'>
		  <!-- 빈칸_<%=chkjoono%>_<%=j%><br> -->
		  <%
		  oJSONoutput.GAMEMEMBERIDX = 0
          oJSONoutput.POS = "rankL_" & chkjoono & "_"& tdcnt
          strjson = JSON.stringify(oJSONoutput)
		  %>
		  <a <%If CDbl(chkgubun) = 0 then%>href='javascript:mx.updateMember(<%=strjson%>)'<%End if%> role="button" class="btn_a btn_updateMember" style="height:100%;width:100%;font-size:20px;padding: 30px 0px;">
			<%If CDbl(chkgubun) = 0 then%>팀등록<%else%>BYE<%End if%>		  
		  </a>
		  </div>
		  </td>
      <%ELSE%>
        <td class="<%If CDbl(chkgubun) = 1 then%>make_comp chk_col<%else%>making_group chk_col<%end if%>">
          <div style='border: 0px solid #73AD21; width:100%; height: 100%;padding: 2px 0px;' id='drag_<%=chkjoono%>_<%=j%>'>
		  <!-- 빈칸_<%=chkjoono%>_<%=j%><br> -->
		  <%
		  oJSONoutput.GAMEMEMBERIDX = 0
          oJSONoutput.POS = "rankL_" & chkjoono & "_"& tdcnt
          strjson = JSON.stringify(oJSONoutput)
		  %>
		  <a <%If CDbl(chkgubun) = 0 then%>href='javascript:mx.updateMember(<%=strjson%>)'<%End if%> role="button" class="btn_a btn_updateMember" style="height:100%;width:100%;font-size:20px;padding: 30px 0px;">
			<%If CDbl(chkgubun) = 0 then%>팀등록<%else%>BYE<%End if%>		  
		  </a>
		  
		  </div></td>
      <%END IF%>
      
    <%
	End If


    If tdcnt = 3 Then 
      Call oJSONoutput.Set("GUBUN", chkgubun )
      strjson = JSON.stringify(oJSONoutput)   
      %>
     <td>
      <div style='border: 0px width:100%;' >    
	<%If CDbl(chkgubun) = 0 then%>
      <a href='javascript:mx.SetJoo(<%=strjson%>)' class="btn_a"  style="height:100%;width:100%;font-size:20px;padding: 30px 0px;">경기대기</a>&nbsp;
    <%Else%>
      <a href='javascript:if (confirm("경기가 진행 중 입니다. 정말 해제 하시겠습니까?") == true) {mx.SetJoo(<%=strjson%>)}' class="btn_a"  style="color:red;">터치금지</a>&nbsp;
    <%End if%>
      </div>
    </td><%
    End if
  Next
%>    

<%
  End if
  db.Dispose
  Set db = Nothing
%>


