<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
  'request 처리##############
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then '대상
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" Then '대상
		gbidx = oJSONoutput.GBIDX
	End if

	If hasown(oJSONoutput, "CDC") = "ok" Then '종목코드
		cdc = oJSONoutput.CDC
	End if

	If hasown(oJSONoutput, "CHKLIDX") = "ok" Then '선택된 것들.
		Set tidxs = oJSONoutput.CHKLIDX

		For i = 0 To oJSONoutput.CHKLIDX.length-1
				If i = 0 Then
					chk_tidx = tidxs.Get(i)
				Else
					chk_tidx = chk_tidx & "," & tidxs.Get(i)
				End if
		Next

		If chk_tidx <> "" Then
			tidxwhere = " and gametitleidx in ( "&chk_tidx&" ) "
		Else
			'Call oJSONoutput.Set("result", 0 )
			'strjson = JSON.stringify(oJSONoutput)
			'Response.Write strjson
			'Response.end
		End if
	End if


'Response.write tidxwhere
'Response.end



	Set db = new clsDBHelper

	'계영이라면 다르게
	SQL = "select top 1 gubun from tblRecord where delyn = 'N' and  CDC ='"&cdc&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	ITgubun = rs(0)


	'sex,rctype,gubun

	If ITGUBUN = "I" then
	'자유형50m 남여 구분해서 최고기록 불러서 엑셀출력...
	fld = "cdcnm as '기준종목' ,cdbnm as '부별',username as '성명',sido as '시도',teamnm as '팀명',userclass as '학년',gameorder as '순위', ( left(gameresult,2)+':'+substring(gameresult,3,2)+'.'+right(gameresult,2)) as '기록', (roundstr + ' ' + gameorder) as 달성라운드, titlename as '달성대회',kskey as '선수ID' "
	Else
	fld = "cdcnm as '기준종목' ,cdbnm as '부별',(username+','+username2+','+username3+','+username4) as '성명',sido as '시도',teamnm as '팀명',userclass as '학년',gameorder as '순위', ( left(gameresult,2)+':'+substring(gameresult,3,2)+'.'+right(gameresult,2)) as '기록', (roundstr + ' ' + gameorder) as 달성라운드, titlename as '달성대회',(kskey+','+kskey2+','+kskey3+','+kskey4) as '선수ID' "
	End if



	SQL = "Select "&fld&" from tblRecord where delYN = 'N' and cda = 'D2' and cdc = '"&cdc&"'  " & tidxwhere
	SQL = SQL & " and (cast(playerIDX as varchar) + gameresult) in ( select (cast(playerIDX as varchar) + max(gameresult)) from tblRecord where  delyn = 'N' and  CDC ='"&cdc&"' and gameResult  > 0 and gameResult < 'a' and sex = 2 " & tidxwhere & " group by playerIDX  )		order by gameresult asc "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	boonm = rs(0)


'Response.write sql
'Response.end
'Response.end


	'엑셀출력################
	Response.Buffer = True
	'Response.ContentType = "application/octet-stream"
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-disposition","attachment;filename="&boonm & "("&Replace(Date(),"-","")&")_여" & ".xls"
	'엑셀출력################


%>
<html lang="ko">
  <head>

    <meta charset="utf-8">
    <title>종합랭킹</title>
<%
'		<style type="text/css">
'		@page
'
'			{
'			margin:.5in .5in .5in .5in;
'			mso-header-margin:.1in;
'			mso-footer-margin:.1in;} /*excel 페이지 여백설정*/
'			tr{mso-height-source:userset;height:10pt} /*excel 셀 기본높이 설정*/
'
'			br{mso-data-placement:same-cell;} /*excel 셀병합문제 해결*/
'			/*아래 2개의 코드는 넓이, 높이를 사용자가 설정한 값으로 엑셀 크기를 준다는 뜻*/
'			mso-height-source:userset;
'			mso-width-source:userset;
'			}
'		</style>
%>
  </head>
  <body>



<%
		response.write "<table class='table' border='1'>"
		Response.write "<thead id=""headtest"">"
		For i = 0 To Rs.Fields.Count - 1
			response.write "<th>"& Rs.Fields(i).name &"</th>"
		Next
		Response.write "</thead>"

		ReDim rsdata(Rs.Fields.Count) '필드값저장

		x = 1
		Do Until rs.eof
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			%>
				<tr class="gametitle">
					<%
						For i = 0 To Rs.Fields.Count - 1
							If Rs.Fields(i).name = "선수ID"  Or Rs.Fields(i).name = "기록" Then
								%><td style="mso-number-format:'\@'"><%=rsdata(i)%></td><%
							ElseIf Rs.Fields(i).name = "순위" Then
								%><td><%=x%></td><%
							else
								Response.write "<td>" & rsdata(i)   & "</td>"
							End if
						Next
					%>
				</tr>
			<%
		x = x + 1
		rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End if
		Response.write "</tbody>"
		Response.write "</table>"
%>






  </body>
</html>



<%
	Call db.Dispose
	Set db = Nothing
%>
