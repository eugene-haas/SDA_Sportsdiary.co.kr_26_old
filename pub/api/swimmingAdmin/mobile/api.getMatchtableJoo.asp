<%
'#############################################
'팀 참가신청 목록 (대상이 경영만이다...)
'#############################################
	Set db = new clsDBHelper

	tidx = fInject(oJSONoutput.get("TIDX"))
	levelno = fInject(oJSONoutput.get("LNO"))
	lidx = fInject(oJSONoutput.get("LIDX"))
	joo = fInject(oJSONoutput.get("JOONO"))

	If hasown(oJSONoutput, "TABNO") = "ok" Then '예선 결승 1,3
		tabno = fInject(oJSONoutput.TABNO)
	End if	

	If tabno = "4" Then
		tabno = "1"
		drowtype = 2
		orgtabno = "4"
	End If
	If tabno = "6" Then
		tabno = "3"
		drowtype = 2
		orgtabno = "6"
	End If
	
		


	'Response.write levelno & "<br>"
'		starttypeq = "(select top 1 starttype from sd_gameMember where delyn = 'N' and gametitleidx = a.gametitleidx and levelno = a.levelno ) "
'		fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2, b.cd_booNm_short, b.orderby,resultopenAMYN,resultopenPMYN,gameno,gameno2, " &starttypeq
'		strWhere = " a.RGameLevelidx = "&lidx&" and b.cd_type = 2 and a.delyn= 'N' "
'
'		SQL = "Select top 1 " & fld & " from tblRGameLevel as a inner join tblTeamGbInfo as b on a.cdb = b.cd_boo and b.delyn = 'N' where " & strWhere



		starttypeq = "(select top 1 starttype from sd_gameMember where delyn = 'N' and gametitleidx = a.gametitleidx and levelno = a.levelno ) "
		fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2,resultopenAMYN,resultopenPMYN,gameno,gameno2, " &starttypeq
		strWhere = " a.RGameLevelidx = "&lidx&"  and a.delyn= 'N' "

		SQL = "Select top 1 " & fld & " from tblRGameLevel as a  where " & strWhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




		If Not rs.EOF Then
			fr = rs.GetRows()

			If IsArray(fr) Then 		'오전경기에서 예선찾기
					CDA = fr(5,0)
					gubunam = fr(12,0)
					gubunpm = fr(13,0)
					'starttype = fr(22,0)
					starttype = fr(20,0)
					CDCNM =  fr(10,0)
					'CDBNMS = fr(16,0)
					CDBNMS = fr(10,0)

					If tabno = "1" Then '오전경기
						fldtype = "tryout"

						joono = fr(14,ari)
						openRC = fr(16, 0)
						gameno = fr(18,0)
						joocnt = fr(14,0)
						ampm = "am"


						If gubunam = "3"  And starttype = "1" Then
							tabstr = "결승"
							joono = fr(15,0)
							openRC = fr(17, 0)
							gameno = fr(19,0)
							joocnt = fr(15,0)
						Else
							tabstr = "예선"
						End If


				%><!--:<%=starttype%>:--><%		

					Else '오후경기

						
						If starttype = "3" Then
						fldtype = "tryout"
						Else
						fldtype = "final"
						End if

						joono = fr(14,ari)
						openRC = fr(16, 0)
						gameno = fr(18,0)
						joocnt = fr(14,0)
						ampm = "pm"

						If gubunpm = "3" Then
							tabstr = "결승"
							joono = fr(15,0)
							openRC = fr(17, 0)
							gameno = fr(19,0)
							joocnt = fr(15,0)
						Else
							tabstr = "예선"

						End If


					End if


			End if			
		End If

		If fldtype = "tryout" Then
			'tblRGameLevel.resultopenAMYN '오픈여부
			fldnm = " (case when itgubun = 'I' then userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm "
			fld = " tryoutsortno,"&fldnm&",sidonm,teamnm,userClass,tryoutorder,tryoutresult,tryouttotalorder ,gameMemberIDX , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '00' end) as birthday "
			SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and tryoutgroupno = '"&joo&"' and tryoutsortno > 0 order by tryoutsortno asc"
		Else
			'tblRGameLevel.resultopenPMYN
			fldnm = " (case when itgubun = 'I' then userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm "
			fld = " sortno,"&fldnm&",sidonm,teamnm,userClass,gameorder,gameresult,gametotalorder  ,gameMemberIDX , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '00' end) as birthday "
			SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and roundno = '"&joo&"' and sortno > 0  order by sortno asc"
		End if
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)





		If rs.eof Then
			Call oJSONoutput.Set("result", 1 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.end		
		Else
			arr = rs.GetRows()
		End if			


	selectval = lidx &"_"& levelno


	Set rs = Nothing
	db.Dispose
	Set db = Nothing	
'################################################
%>

<%'참고 여긴 경영만 들어온다. 다른것들은 조가 없다....%>
<%If drowtype = 2 then%>


	  <div class="match-info__list-box">
        <ul class="match-info__list-group clear">
          <!-- s_on = button 파란색으로 -->


	
		<%For i = 1 To joono%>
			<li <%If i  = CDbl(joo) then%>class="s_on"<%End if%>><button class="match-info__list-group__btns" type="button" name="button" onclick="mx.getMachTab('<%=tidx%>','<%=selectval%>',<%=i%>,<%=orgtabno%>)" style="margin-bottom:5px;"><%=i%>조</button></li>
		<%next%>         


        </ul>
      </div>

      <div class="match-info-con"  id="'sw_searchboo">
        <div class="match-info-con__tab-box">
          <h3 class="hide">선수보기 표</h3>
          <table class="match-info-con__tab-box__con">
            <thead class="match-info-con__tab-box__con__thead">
              <tr>
                <th>레인</th>
                <th>선수명/출생년도</th>
                <th>시도</th>
                <th>소속</th>
                <th>기록</th>
                <th>순위</th>
				<%if CDA = "D2" then%><th>구간기록</th><%end if%>
				<!--<th>총 순위</th> -->
              </tr>
            </thead>
            <tbody class="match-info-con__tab-box__con__tbody">
              <!-- s_highlight = 1,2위 꾸며줌 -->
              <!-- s_yellow = 이름 노란색으로 -->
				<%
						If IsArray(arr) Then 
							For ari = LBound(arr, 2) To UBound(arr, 2)

								l_rane = arr(0, ari) 'idx
								l_nm = arr(1, ari)
								l_sidonm= arr(2, ari)
								l_teamnm= arr(3, ari)
								l_class = arr(4, ari)
								
								l_order= arr(5, ari)
								l_rc = arr(6, ari)
								l_totalorder = arr(7,ari)

								l_midx = arr(8,ari)
								'중복자 체크를 위해 출생년도 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$
								a_birth = Left(arr(9,ari),2)
								If a_birth = "--" Then
									'계영제외
									a_birth = ""
								else
									If CDbl(a_birth) > 30 Then
										a_birth = " (19" & a_birth & ")"
									Else
										a_birth = " (20" & a_birth & ")"
									End If
								End If
								
								'중복자 체크를 위해 출생년도 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$
								%>
							  <tr>
								<td>﻿<%=l_rane%></td>
								<td><span><%=l_nm%> <%=a_birth%></span></td>
								<td><%=l_sidonm%></td>
								<td><%=shortNm(l_teamnm)%></td>
								<td><%If openRC = "Y" then%><%Call SetRC(l_rc)%><%else%>-<%End if%></td>
								<td><%If openRC = "Y" then%><%=l_totalorder%><%else%>-<%End if%></td>
								<%if CDA = "D2" then%><td><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getSectionInfo(<%=l_midx%>,'<%=ampm%>','<%=l_rc%>','<%=l_order%>','<%=l_rane%>')" >조회</button></td><%end if%>
<!-- 								<td><span>-</span></td> -->
							  </tr>
								<%
							Next 
						End if
				%>
            </tbody>
          </table>
        </div>
      </div>




<%else%>

		  <!-- s_on = li 파란색으로 -->
		<ul class="drow-con__list" >         
		  <li class="drow-con__list-li<%If tabno = "1" then%> s_on<%End if%>">
            

			<%If CDA = "D2" And starttype = "1" then%>
			<a class="drow-con__list__link" href="javascript:mx.getMachTab('<%=tidx%>','<%=selectval%>',1,1)">예선</a>
			<%else%>
			<a class="drow-con__list__link" >예선</a>
			<%End if%>


            <%If CDbl(joono) > 1 then%>
			<div class="drow-con__list__box-group">
              <!-- jquery로 가로사이즈 설정 -->
              <ul class="drow-con__list__box-group__btns clear">
                <!-- s_on = button 파란색으로 -->
				<%For i = 1 To joono%>
				<li <%If i  = CDbl(joo) then%>class="s_on"<%End if%>><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getMachTab('<%=tidx%>','<%=selectval%>',<%=i %>,1)" style="margin-bottom:5px;"><%=i%>조</button></li>
				<%next%>
              </ul>
            </div>
			<%End if%>
		  </li>

          <li class="drow-con__list-li<%If tabno = "3" then%> s_on<%End if%>">
            <a class="drow-con__list__link" href="javascript:mx.getMachTab('<%=tidx%>','<%=selectval%>',1,3)">결승</a>

            <%If CDbl(joono) > 1 then%>
			<div class="drow-con__list__box-group">
              <!-- jquery로 가로사이즈 설정 -->
              <ul class="drow-con__list__box-group__btns clear">
                <!-- s_on = button 파란색으로 -->
				<%For i = 1 To joono%>
				<li <%If i  = CDbl(joo) then%>class="s_on"<%End if%>><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getMachTab('<%=tidx%>','<%=selectval%>',<%=i %>,3)" style="margin-bottom:5px;"><%=i%>조</button></li>
				<%next%>
              </ul>
            </div>
			<%End if%>
		  </li>
        </ul>


        <div class="drow-con__table" id = "sw_joolist">
          <h3 class="drow-con__table-header clear">
			<span class="drow-con__table-header__span"><%=CDBNMS%></span>
            <span class="drow-con__table-header__span"><%=CDCNM%></span>
            <span class="drow-con__table-header__span"><%=joo%>조</span>
          </h3>
          <table class="drow-con__table-con">
            <thead class="drow-con__table-con__thead">
              <tr>
                <th scope="col">레인:<%=joono%>:</th>
                <th scope="col">선수명/출생년도</th>
                <th scope="col">시도</th>
                <th scope="col">소속</th>
                <th scope="col">학년</th>
                <th scope="col">순위</th>
                <th scope="col">기록</th>
				<%if CDA = "D2" then%><th>구간기록</th><%end if%>
              </tr>
            </thead>
            <tbody class="drow-con__table-con__tbody">
				<%
						If IsArray(arr) Then 
							For ari = LBound(arr, 2) To UBound(arr, 2)

								l_rane = arr(0, ari) 'idx
								l_nm = arr(1, ari)
								l_sidonm= arr(2, ari)
								l_teamnm= arr(3, ari)
								l_class = arr(4, ari)
								
								l_order= arr(5, ari)
								l_rc = arr(6, ari)
								l_totalorder = arr(7,ari)

								l_midx = arr(8,ari)
								'중복자 체크를 위해 출생년도 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$
								a_birth = Left(arr(9,ari),2)
								If a_birth = "--" Then
									'계영제외
									a_birth = ""
								else
									If CDbl(a_birth) > 30 Then
										a_birth = " (19" & a_birth & ")"
									Else
										a_birth = " (20" & a_birth & ")"
									End If
								End If
								
								'중복자 체크를 위해 출생년도 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$
								%>
								  <tr>
									<td scope="row"><%=l_rane%></td>
									<td><%=l_nm%> <%=a_birth%></td>
									<td><%=l_sidonm%></td>
									<td><%=shortNm(l_teamnm)%></td>
									<td><%=l_class%></td>
									<td><%If openRC = "Y" then%><%=l_totalorder%><%End if%></td>
									<td><%If openRC = "Y" then%><%Call SetRC(l_rc)%><%End if%></td>
									<%if CDA = "D2" then%><td><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getSectionInfo(<%=l_midx%>,'<%=ampm%>','<%=l_rc%>','<%=l_order%>','<%=l_rane%>')" >조회</button></td><%end if%>
								  </tr>								
								<%
							Next 
						End if
				%>

            </tbody>
          </table>
        </div>
<%End if%>