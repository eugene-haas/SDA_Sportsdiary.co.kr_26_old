<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
 'Controller ################################################################################################
  'request 처리##############
	REQ = chkReqMethod("p", "POST")

'	Set oJSONoutput = JSON.Parse(REQ)
'Response.write oJSONoutput.pg
'Response.end

	If REQ <> "" then
	Set oJSONoutput = JSON.Parse(REQ)
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)

		If hasown(oJSONoutput, "SDATE") = "ok" Then
			sdate = chkLength(chkStrRpl(oJSONoutput.SDATE, ""), 20) 
		End if
		If hasown(oJSONoutput, "EDATE") = "ok" then
			edate = oJSONoutput.EDATE
		End If
		If hasown(oJSONoutput, "DATEALL") = "ok" then
			dateall = oJSONoutput.DATEALL
		End If
		If hasown(oJSONoutput, "SIDO") = "ok" then
			s_sidonm = oJSONoutput.SIDO
		End If
		If hasown(oJSONoutput, "GUGUN") = "ok" then
			s_gugun = oJSONoutput.GUGUN
		End If
		If hasown(oJSONoutput, "STADIUM") = "ok" then
			stadium = oJSONoutput.STADIUM
		End If
		If hasown(oJSONoutput, "SGB") = "ok" then
			sgb = oJSONoutput.SGB
		End If
		If hasown(oJSONoutput, "SGBSUB") = "ok" then
			sgbsub = oJSONoutput.SGBSUB
		End If
		If hasown(oJSONoutput, "VODYN") = "ok" then
			vodyn = oJSONoutput.VODYN
		End If
		If hasown(oJSONoutput, "VODALL") = "ok" then
			vodall = oJSONoutput.VODALL
		End If
		If hasown(oJSONoutput, "TITLE") = "ok" then
			title = oJSONoutput.TITLE
		End If
	
	Else
		'findmode 전체검색
		page = chkInt(chkReqMethod("page", "GET"), 1)
	End if
  'request 처리##############

  Set db = new clsDBHelper

	'select box 
		SQL = "Select sido,sidonm from tblSidoInfo where delYN = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrSD = rs.GetRows()
		End If

		If s_sidonm <> "" then
			SQL = "Select GuGunNm from tblGugunInfo where delYN = 'N' and Sido = (select top 1 sido from tblSidoInfo where SidoNm = '"&s_sidonm&"' )" 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then 
				arrGG = rs.GetRows()
			End If
		End if


		SQL = "Select title from K_titleList where delYN = 'N' group by title order by title "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrRS = rs.GetRows()
		End If

		If sgb <> "" then
			SQL = "Select tidx,subtitle from K_titleList where delYN = 'N' and title = '"&sgb&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then 
				arrSub = rs.GetRows()
			End If
		End If
		Set rs = nothing
	'select box 

	If REQ <> "" Then
		strWhere = " DelYN='N' "
			If dateall = "N" Then
				If sdate <> "" then
					If edate = "" Then
						strWhere = strWhere & " and GameS >= '"&sdate&"' and GameS < '"&CDate(sdate) + 1&"' " 
					else
						strWhere = strWhere & " and GameS >= '"&sdate&"' and GameE <= '"&edate&"' " 
					End if
				Else
					If edate <> "" then
						strWhere = strWhere & " and GameE > '"&CDate(edate)-1&"' and GameE <= '"&edate&"' "	
					End if
				End If
			End If
			If s_sidonm <> "" Then
				strWhere = strWhere & " and Sido ='"&s_sidonm&"' "
			End If
			If s_gugun <> "" Then
				strWhere = strWhere & " and addr like '%"&s_gugun&"%' "			
			End If
			If stadium <> "" Then
				strWhere = strWhere & " and stadium like '"&stadium&"%' "			
			End If
			If sgb <> "" Then
				strWhere = strWhere & " and SportsGb = '"&sgb&"' "			
			End If
			If sgbsub <> "" Then
				strWhere = strWhere & " and SportsGbSub = '"&sgbsub&"' "			
			End if			

			If vodall = "N" Then
				If vodyn = "Y" then
					strWhere = strWhere & " and ( e_videoDate > '' or m_videoDate > '' or h_videoDate > ''  or c_videoDate > '' or d_videoDate > '' or x_videoDate > '' ) " 
				Else
					strWhere = strWhere & " and ( e_videoDate = '' or m_videoDate = '' or h_videoDate = ''  or c_videoDate = '' or d_videoDate = '' or x_videoDate = '' ) " 
				End If
			End If

			If title <> "" Then
				strWhere = strWhere & " and GameTitle like '%"&title&"%' "
			End if


		strSort = "  order by GIDX desc"
		strFieldName = "GIDX,SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
		strFieldName = strFieldName & ",VOD1,VOD2,VOD3,VOD4,VOD5,VOD6,m_videoDate,h_videoDate,ip    ,e_videoDate,c_videoDate,d_videoDate,x_videoDate "

		If trim(strWhere) =" DelYN='N'" Then
			SQL = "Select top 2000 "&strFieldName&" from K_gameinfo where "&strWhere&" order by GIDX desc"
		Else
			SQL = "Select "&strFieldName&" from K_gameinfo where "&strWhere&" order by GIDX desc"
		End if
		'Response.write sql		
		'response.write strWhere 

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if

%>
<%'View ####################################################################################################%>
<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="dnlayer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>

<%
'배열내 중복값 제거
Function FnDistinctData(ByVal aData)
 	   Dim dicObj, items, returnValue

 	   Set dicObj = CreateObject("Scripting.dictionary")
 	   dicObj.removeall
 	   dicObj.CompareMode = 0

'loop를 돌면서 기존 배열에 있는지 검사 후 Add
 	   For Each items In aData
 	   	   If not dicObj.Exists(items) Then dicObj.Add items, items
 	   Next

 	   returnValue = dicObj.keys
 	   Set dicObj = Nothing
 	   FnDistinctData = returnValue
End Function
%>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회정보검색</h1></div>


			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
				  <!-- #include virtual = "/pub/html/ksports/searchform.asp" -->
				</div>
			<!-- e: 정보 검색 -->



			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tr>
							<th>번호</th><th>기간</th><th>지역</th><th>체육관명</th><th>대분류</th><th>종목</th><th>대회명</th><th>대회일수</th><th>종별</th><th>촬영일수</th>
						</tr>
						<%If REQ <> "" Then%>
							<tbody id="contest">
							<%
							If rs.eof Then
								%><td colspan="10">검색결과가 없습니다.</td><%
							End If

							k_shotcnt = 0
							Do Until rs.eof
								k_idx = rs("GIDX")
								k_sgb = rs("SportsGb")
								k_sgbsub = rs("SportsGbSub")
								k_title = rs("GameTitle")
								k_gametype = rs("GameType")
								k_sido = rs("Sido")
								k_zipcode = rs("zipcode")
								k_addr = rs("addr")
								k_Stadium = rs("Stadium")
								k_GameYear = rs("GameYear")

								k_GameS = Replace(Left(rs("GameS"),10),"-",".")
								k_GameE = Replace(Left(rs("GameE"),10),"-",".")
								k_Gamedatecnt = rs("Gamedatecnt")
								k_GameHost = rs("GameHost")
								k_GameOrganize = rs("GameOrganize")
								k_VOD1 = rs("VOD1")
								k_VOD2 = rs("VOD2")
								k_VOD3 = rs("VOD3")
								k_VOD4 = rs("VOD4")
								k_VOD5 = rs("VOD5")
								k_VOD6 = rs("VOD6")
								k_mvod = rs("m_videoDate")
								k_hvod = rs("h_videoDate")

								k_evod = rs("e_videoDate")
								k_cvod = rs("c_videoDate")
								k_dvod = rs("d_videoDate")
								k_xvod = rs("x_videoDate")

								k_ip = rs("ip")


								
'								If k_mvod <> "" Then
'									kmvdd = Split(k_mvod,",")
'									k_shotcnt = CDbl(ubound(Split(k_mvod,","))) + 1
'								End If
'
'								If k_hvod <> "" Then
'									If isArray(kmvdd) Then
'										'동일날짜는 빼자
'										For v = 0 To ubound(kmvdd)
'											k_hvod = Replace(k_hvod,kmvdd(v),"")
'										Next
'
'										khvdd = Split(k_hvod,",")
'										For v = 0 To ubound(khvdd)
'											If khvdd(v) <> "" then
'												k_shotcnt = k_shotcnt + 1
'											End if
'										next
'									else
'										k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_hvod,","))) + 1
'									End If
'								End if	


'2018-05-01,2018-05-08,2018-05-01,2018-05-17								
If k_evod <> "" Then
	vodallstr = k_evod
End if
If k_mvod <> "" Then
	If vodallstr = "" then
		vodallstr = k_mvod
	Else
		vodallstr = vodallstr & "," & k_mvod
	End if
End If
If k_hvod <> "" Then
	If vodallstr = "" then
		vodallstr = k_hvod
	Else
		vodallstr = vodallstr & "," & k_hvod
	End if
End if
If k_cvod <> "" Then
	If vodallstr = "" then
		vodallstr = k_cvod
	Else
		vodallstr = vodallstr & "," & k_cvod
	End if
End if
If k_dvod <> "" Then
	If vodallstr = "" then
		vodallstr = k_dvod
	Else
		vodallstr = vodallstr & "," & k_dvod
	End if
End if
If k_xvod <> "" Then
	If vodallstr = "" then
		vodallstr = k_xvod
	Else
		vodallstr = vodallstr & "," & k_xvod
	End if
End if

If vodallstr = "" Then
	k_shotcnt = 0
else
	arrData = Split(vodallstr,",")
	arrTmp = FnDistinctData(arrData)
	k_shotcnt = Ubound(arrTmp) + 1
End if







								k_VOD = k_VOD1& k_VOD2 & k_VOD3 & k_VOD4 & k_VOD5 & k_VOD6

								%><!-- #include virtual = "/pub/html/ksports/s.onelinelist.asp" --><%
							  k_shotcnt = 0
							  rs.movenext
							  Loop
							  Set rs = Nothing
							%>
							</tbody>
						<%End if%>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->


			<!-- s: 더보기 버튼 -->
			<div class="pagination">
				<%
					'Call userPaginglink (intTotalPage, 10, page, "mx.searchPlayer" )
				%>		
				<!-- <a href="javascript:mx.contestMore()">더보기</a> -->
			</div>
			<!-- e: 더보기 버튼 -->
		</div>
		<!-- s: 콘텐츠 끝 -->