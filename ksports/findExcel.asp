<!-- #include virtual = "/pub/header.ksports.asp" -->
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
Response.Buffer = True     
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-disposition","attachment;filename=대회정보검색_"&date()& ".xls"


  'request 처리##############
	REQ = chkReqMethod("p", "POST")

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
				strWhere = strWhere & " and GameTitle like '"&title&"%' "
			End if


		strSort = "  order by GIDX desc"
		strFieldName = "ROW_NUMBER() OVER(ORDER BY GIDX DESC) AS ROWNUM,GIDX,SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
		strFieldName = strFieldName & ",VOD1,VOD2,VOD3,VOD4,VOD5,VOD6,m_videoDate,h_videoDate     ,e_videoDate,c_videoDate,d_videoDate,x_videoDate "

		If trim(strWhere) =" DelYN='N'" Then
			'SQL = "Select top 2000 "&strFieldName&" from K_gameinfo where "&strWhere&" order by GIDX desc"
			SQL = "Select top 2000 "&strFieldName&" from K_gameinfo where "&strWhere&" order by GameS ,SportsGb, SportsGbSub"
		Else
			'SQL = "Select "&strFieldName&" from K_gameinfo where "&strWhere&" order by GIDX desc"
			SQL = "Select "&strFieldName&" from K_gameinfo where "&strWhere&" order by  GameS ,SportsGb, SportsGbSub"
		End if
		'Response.write sql		
		'response.write strWhere 

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	Else
		Response.end
	End If
	


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



'##############################################
' 소스 뷰 경계
'##############################################
%>
<!DOCTYPE html>
<html>
<head>
<title>검색항목출력</title>
</head>
<body >
<%
	'Call rsDrow(rs)
%>
		<div>
			검색조건 
<%
			Response.write "<br>기간 : " '############
			If dateall = "N" Then
				If sdate <> "" then
					If edate = "" Then
						Response.write sdate  
					else
						Response.write  sdate & " ~ " & edate 
					End if
				Else
					If edate <> "" then
						Response.write  edate
					End if
				End If
			Else
					Response.write "전체 " 
			End If

			Response.write "<br>지역 : " '############
			If s_sidonm <> "" Then
				Response.write s_sidonm
			End If
			If s_gugun <> "" Then
				Response.write " " & s_gugun
			End If

			If stadium <> "" Then
				Response.write " " & stadium 
			End If
			Response.write "<br>종목 : " '############
			If sgb <> "" Then
				Response.write " " & sgb
			End If
			If sgbsub <> "" Then
				Response.write " " & sgbsub 
			End if			

			Response.write "<br>영상유무 : " '############
			If vodall = "N" Then
				If vodyn = "Y" then
					Response.write "  있음"
				Else
					Response.write "  없음"
				End If
			Else
					Response.write "전체 " 
			End If

			Response.write "<br>대회명 : " '############
			If title <> "" Then
				Response.write " " & title 
			End if
%>

		</div>

		<div class="table_list contest">
		<table border="1">
			<tr>
				<th>번호</th><th>기간</th><th>지역</th><th>주소</th><th>체육관명</th><th>대분류</th><th>종목</th><th>대회명</th><th>대회일수</th><th>종별</th><th>촬영일수</th>
			</tr>
				<tbody>
				<%
				i = 1
				k_shotcnt = 0
				Do Until rs.eof
					k_idx = i 'rs("GIDX")
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

'					If k_mvod <> "" Then
'						kmvdd = Split(k_mvod,",")
'						k_shotcnt = CDbl(ubound(Split(k_mvod,","))) + 1
'					End If
'					If k_hvod <> "" Then
'						If isArray(kmvdd) Then
'							'동일날짜는 빼자
'							For v = 0 To ubound(kmvdd)
'								k_hvod = Replace(k_hvod,kmvdd(v),"")
'							Next
'
'							khvdd = Split(k_hvod,",")
'							For v = 0 To ubound(khvdd)
'								If khvdd(v) <> "" then
'									k_shotcnt = k_shotcnt + 1
'								End if
'							next
'						else
'							k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_hvod,","))) + 1
'						End If
'					End if	


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

					%><!-- #include virtual = "/pub/html/ksports/excel.onelinelist.asp" --><%
				  i = i + 1
				  k_shotcnt = 0
				  rs.movenext
				  Loop
				  Set rs = Nothing
				%>
				</tbody>
		</table>
		</div>

<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
