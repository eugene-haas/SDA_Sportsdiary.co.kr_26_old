<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	Set db = new clsDBHelper

	tidx = request("tidx")
	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		tidx = oJSONoutput.Get("TIDX")

		cda = oJSONoutput.Get("CDA")
		If cda = "" then
			cda = "D2"
		End if
		If hasown(oJSONoutput, "CDB") = "ok" then
			cdb = oJSONoutput.CDB
		Else
			CDB = "S"
		End if
		If hasown(oJSONoutput, "CDC") = "ok" then
			cdc = oJSONoutput.CDC
		End if
	Else
		cda = "D2"
		CDB = "S"
	End if

	'생성된 종목만 보이게 (경영, 아티스틱,,)
	SQL = "select cda,cdanm from tblRGameLevel where gametitleidx = "&tidx&" and delyn='N' group by CDA ,cdanm"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		arrMn = rs.GetRows()
		CDA = arrMn(0,0)
	End if

	If isnumeric(tidx) Then
			'대회
			SQL = "select gametitlename , gameS,gameE,gamearea from sd_gameTitle where gametitleidx = '"&tidx&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				title = rs(0)
				gameS = rs(1)
				gameE = rs(2)
				gamearea = rs(3)

			End if

			'참가 부별 종목리스트
			fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno "
			strSort = "  ORDER BY itgubun,cdc,sexno"
			strWhere = " a.GameTitleIDX = "&tidx&" and  a.CDA = '"&CDA&"' and a.DelYN = 'N' "

			SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
			Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rss.EOF Then
				fr = rss.GetRows()
				CDB = fr(7,0)
				CDC = fr(9,0)
				CDBNM = fr(8,0)
				CDCNM = fr(10,0)
				itgubun = fr(4,0)
				levelno = fr(11,0)
			End If


			'종목 (참가자)

			If itgubun = "T" then	'계영이라면 (단체 수구, 기타)
				fld = " a.CDA,a.CDC, a.CDCNM,a.CDB,a.CDBNM,b.UserName,P1_TEAMNM,sidonm, (select top 1 birthday from tblplayer where playeridx = b.playeridx) as birthday "
				SQL = "select "&fld&" from tblGameRequest as a inner join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where  a.GameTitleIDX = "&tidx&"  and a.DelYN = 'N' and a.levelno = '"&levelno&"'  order by a.sido,p1_teamnm"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			else

				fld = " CDA,CDC, CDCNM,CDB,CDBNM,P1_UserName,P1_TEAMNM,sidonm,p1_birthday "
				SQL = "select "&fld&" from tblGameRequest where GameTitleIDX = "&tidx&" and CDA = '"&CDA&"' and  cdc = '"&CDC&"' and cdb='"&CDB&"' and delyn = 'N' order by  sido,p1_teamnm"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			end if


'Response.write sql
' call rsdrow(rs)
' response.end

			If Not rs.eof Then
				arr = rs.GetRows()
			End if
	End if


	weekarr = array("-", "일","월","화","수","목","금","토")




%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
</head>
<body <%=CONST_BODY%>>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
<input type="hidden" id = "tidx" value="<%=tidx%>">



<div id="app" class="l contestInfo" >

  <!-- #include file = "../include/gnbapp.asp" -->
	<div class="l_header">
    <div class="m_header s_sub">
	  <a href="/Result/institute-search.asp?reqdate=<%=gameS%>" class="m_header__backBtn">이전</a>
  		<h1 class="m_header__tit">참가신청현황</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

	<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">





    <div class="l_participation">
      <h2 class="m_resultTit">
        <span><%=title%></span><%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) | <%=gamearea%>
      </h2>

	  <ul class="l_parti_division">
        <!-- s_show = 분류 활성화 -->
        <li class="li_div s_show" id="partiEvent">
          <button id="eventHeader" class="part_header" type="button" name="button">
            종목별
          </button>

          <div class="event_con" id="s_cda">
            <span class="event_con_search clear" >
              <div class="box_selc">
					<%
							If IsArray(fr) Then
								For ari = LBound(fr, 2) To UBound(fr, 2)
									l_CDA= fr(5, ari)
									If l_CDA= "D2" Then
										CDAD2 = "ok"
									End If
									If l_CDA= "E2" Then
										CDAE2 = "ok"
									End If
									If l_CDA= "F2" Then
										CDAF2 = "ok"
									End if
								Next
							End if
					%>
					<input type="hidden" id="showtype" value="att">

					<select id="CDA"  onchange="mx.getMachList('<%=tidx%>',$(this).val())">
					<%
							If IsArray(arrMn) Then
								For ari = LBound(arrMn, 2) To UBound(arrMn, 2)
									m_CDA= arrMn(0, ari)
									m_CDANM = arrMn(1,ari)
									%>
									<option value="<%=m_CDA%>" <%If CDA = m_CDA then%>selected<%End if%>><%=m_CDANM%></option>
									<%
								Next
							End if
					%>
					</select>
              </div>

              <div class="box_selc"  id="s_cdbc">
					<select id="cdbc"  onchange="mx.getAttMember('<%=tidx%>',$(this).val())">
					<%
							If IsArray(fr) Then
								For ari = LBound(fr, 2) To UBound(fr, 2)

									l_idx = fr(0, ari) 'idx
									l_tidx = fr(1, ari)
									l_gbidx= fr(2, ari)
									l_ITgubun= fr(4, ari)
									l_CDA= fr(5, ari)
									l_CDANM= fr(6, ari)
									l_CDB= fr(7, ari)
									l_CDBNM= fr(8, ari)
									l_CDC= fr(9, ari)
									l_CDCNM= fr(10, ari)
									l_levelno= fr(11, ari)

									%><option value="<%=l_ITgubun%>_<%=l_levelno%>" ><%=l_CDBNM&" " & l_CDCNM%></option><%
								Next
							End if
					%>
					</select>
              </div>

              <div class="input_box clear">
				<input type="text"  placeholder="선수명을 검색하세요" id="player_nm" class="form-control ui-autocomplete-input" autocomplete="off" value="">
                <span onclick="" id="btnSearchParti" type="button" name="button" disabled><strong class="hide">선수 검색</strong></span>
              </div>
            </span>



			<div class="tab_box" id="sw_gametable">
			  <h3 class="tab_header">
                <span id="TabGenderCon"><%=CDBNM%></span><span id="TabDistanceCon"><%=CDCNM%></span>
              </h3>
              <table>
                <caption>※ 이름(출생년도) | 소속</caption>
				<%
					If IsArray(arr) Then
						For ari = LBound(arr, 2) To UBound(arr, 2)
							a_CDA = arr(0, ari)
							a_CDC = arr(1, ari)
							a_CDCNM = arr(2, ari)
							a_CDB = arr(3,ari)
							a_CDBNM = arr(4,ari)
							a_UNM1 = arr(5, ari)
							a_TEAMNM = arr(6, ari)
							a_sidonm = arr(7,ari)

							a_birth = Left(arr(8,ari),2)
							If CDbl(a_birth) > 30 Then
								a_birth = "19" & a_birth
							Else
								a_birth = "20" & a_birth
							End if

							%>
							<tr>
							  <td><%=a_UNM1%>  (<%=a_birth%>) | <%=a_TEAMNM%>(<%=a_sidonm%>)</td>
							</tr>
							<%
						Next
					End if
				%>
              </table>
            </div>


          </div>
        </li>





		<li class="li_div" id="partiGroup">
          <button id="groupHeader" class="part_header" type="button" name="button" onclick="javascript:px.goSubmit( {'TIDX':<%=tidx%>,'CDA':$('#CDA').val(),'CDB':$('#CDB').val(),'CDC':'<%=a_CDC%>'} ,'attgrpinfo.asp?tidx=<%=tidx%>')">
            단체별
          </button>


        </li>
      </ul>
    </div>






  </div>
  <!-- E: main -->

	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>




</body>
</html>

<%
  set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
