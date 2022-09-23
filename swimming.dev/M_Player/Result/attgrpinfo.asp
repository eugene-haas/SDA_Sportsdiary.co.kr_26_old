<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	Set db = new clsDBHelper

	tidx = request("tidx")
	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		If hasown(oJSONoutput, "TIDX") = "ok" then
			tidx = oJSONoutput.TIDX
		End If
		If hasown(oJSONoutput, "CDA") = "ok" then
			cda = oJSONoutput.CDA
		Else
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


			'시도
			fld = " sido,MAX(sidonm),COUNT(*) "
			SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' group by a.sido order by a.sido"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				arrK = rs.GetRows()
					If sido = "" then
					sido = arrK(0, 0)
					End if
			End if



			fld = " p1_team,max(p1_teamnm),COUNT(*) "
			'SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N'  where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and a.sido = '"&sido&"'  group by a.P1_team order by a.P1_team"
			SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N'  where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' group by a.P1_team order by a.P1_team"			
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

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

<div id="app" class="l contestInfo">

  <!-- #include file = "../include/gnbapp.asp" -->
	<div class="l_header">
    <div class="m_header s_sub">
	  <a href="/Result/result.asp?tidx=<%=tidx%>" class="m_header__backBtn">이전</a>
  		<h1 class="m_header__tit">참가신청현황</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

	<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">



		<div class="l_parti">
		  <h2 class="m_resultTit">
			<span><%=title%></span><%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) | <%=gamearea%>
		  </h2>

		  <ul class="l_parti_division">

			<!-- s_show = 분류 활성화 -->
			<li class="li_div" id="partiEvent">
			  <button id="eventHeader" class="part_header" type="button" name="button" onclick="javascript:px.goSubmit( {'TIDX':<%=tidx%>,'CDA':$('#CDA').val(),'CDB':$('#CDB').val(),'CDC':'<%=a_CDC%>'} ,'result.asp?tidx=<%=tidx%>')">
				종목별
			  </button>
			</li>



<applet code="" width="" height="">
</applet>
			<li class="li_div s_show" id="partiGroup">
			  <button id="groupHeader" class="part_header" type="button" name="button">
				단체별
			  </button>

			  <div class="group_con">
				<span class="group_con_search clear">
				  <div class="box_selc">
						<select id="SIDO"  onchange="mx.getTeamList('<%=tidx%>', $(this).val(),'')">
							<%
							If IsArray(arrK) Then
								For ari = LBound(arrK, 2) To UBound(arrK, 2)
									a_SIDO = arrK(0, ari)
									a_SIDONM = arrK(1, ari)
									a_count = arrK(2,ari)
									If isNull(a_sido)  Then
										a_sido = ""
										a_SIDONM = "없음"
									End If
									%>
									<option value="<%=a_SIDO%>" <%If a_SIDO = sido then%>selected<%End if%>><%=a_SIDONM%> [<%=a_count%>]</option>
									<%
								Next
							End if
							%>
						</select>
				  </div>

				  <div class="input_box">
					<input type="text"  placeholder="단체명으로 검색해주세요." class="form-control ui-autocomplete-input" id="team_nm"  autocomplete="off" value="">
					<span onclick="" id="btnSearchGru" type="submit" name="button"><strong class="hide">단체 검색</strong></span>
				  </div>
				</span>



				<span id="teamlist">
				<ul class="list_box">
					<%
					If IsArray(arr) Then
						For ari = LBound(arr, 2) To UBound(arr, 2)
							a_P1_TEAM = arr(0, ari)
							a_P1_TEAMNM = arr(1, ari)
							a_tm_count = arr(2,ari)
							%>
							  <li class="list">
								<a href="javascript:mx.getAttList('<%=TIDX%>','<%=a_P1_TEAM%>', this)" class="sl_list"><%=a_P1_TEAMNM%>  <span id="ul_total">Total : <%=a_tm_count%>명</span></a>
								<p id="<%=a_P1_TEAM%>" style="display:none;"></p>
							  </li>
							<%
						Next
					End if
					%>
				</ul>
				</span>



			  </div>

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
