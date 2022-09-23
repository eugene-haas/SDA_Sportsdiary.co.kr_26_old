<%
'#############################################
'대진표 리그 화면 준비 

'group by로 선수 목록정보를 확인한다. > 0 예선준비 1 예선시작 2본선준비 3 본선시작 4 본선완료 

'리그이므로
' if gubun > 0 then
	'	조별 예선 대진표를 보여준다. ( 승패결정과, 출석 체크할수 있는 기능이 있다) 코트지정 ( tennisMember에 사전에 사용할 코트를 지정할수 있어야 하나?)
'else
	'	예선 대진표를 추첨할수 있는 화면을 보여준다.
	'	대회 참가 선수 목록을 가져온다. (gubun = 0)
	'	선수가 부족한 만큼 부전승자를 만든다. ( 이건 토너먼트에서) 부족한 경우 mod 3 =0 이아닌경우 어떻게 ?? 부족합니다 어쩌구 저쩌구....
	'	mode 3 = 0 으로 만들었다 소팅순서 업데이트 해주자. 
'end if

'#############################################
'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM

poptitle = title & " " & teamnm & " (" & areanm & ")  예선 대진표"

Set db = new clsDBHelper

SQL = " Select EntryCnt,attmembercnt,courtcnt,level from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.eof then
	entrycnt = rs("entrycnt") '참가제한인원수
	attmembercnt = rs("attmembercnt") '참가신청자수
	courtcnt = rs("courtcnt") '코트수
	levelno = rs("level")
	poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"
End if


'SQL = "select max(gubun) as gubun from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno
SQL = "select COUNT(*) as gubun from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If isNull(rs(0)) = True  Then
	'Response.write "없슴@@@@@@@@@@@@@"	'없슴
Else

	SQL = "SELECT gameMemberIDX , userName "
	SQL = SQL & " FROM sd_TennisMember "
	SQL = SQL & " WHERE GameTitleIDX = "& tidx &" "
	SQL = SQL & " AND gamekey3 = "& levelno 
	SQL = SQL & " AND DelYN = 'N'"
  SQL = SQL & " ORDER BY gameMemberIDX ASC"

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	int_tryoutgroupno = 1
	int_tryoutsortNo = 1

	If Not rs.EOF Then 
		'arrRS = rs.GetRows()

			Do Until rs.EOF 

				tablename = " sd_TennisMember "

				strSql = "UPDATE " & tablename & " SET"
				strSql = strSql & " tryoutgroupno = '" & int_tryoutgroupno & "',"
				strSql = strSql & " tryoutsortNo = '" & int_tryoutsortNo & "'"
				strSql = strSql & " WHERE gameMemberIDX = " & rs("gameMemberIDX")



				If int_tryoutsortNo MOD 3 = 0 Then
					int_tryoutsortNo = 1
					int_tryoutgroupno = int_tryoutgroupno + 1
				Else
					int_tryoutsortNo = int_tryoutsortNo + 1
				End If

				Call db.execSQLRs(strSql , null, ConStr)

				rs.movenext

			Loop


	End If
	
	rs.Close
End if




'#############################################



%>

<% 
'Response.write sql
	'Set oClsDBHelper = new clsDBHelper
		Response.write "<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button><h3 id='myModalLabel'>"&poptitle&"</h3></div>"
		Response.write "<div class='modal-body'>"
		Response.write "<table border=""1"" width=""100%"" class=""table-list"" id=""gametable"">"
		Response.write "<thead>"
		Response.write "<th>조</th>"
		Response.write "<th>1</th>"
		Response.write "<th>2</th>"
		Response.write "<th>3</th>"
		Response.write "</thead>"

'If IsArray(arrRS) Then
'	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
'		Response.write "<tr><td>" & arrRS(0,ar) & "</td>" 
'	Next
'End If

		strSql = "SELECT tryoutgroupno"
		strSql = strSql & " FROM sd_TennisMember"
		strSql = strSql & " WHERE GameTitleIDX = " & tidx 
		strSql = strSql & " AND gamekey3 = " & levelno
		strSql = strSql & " AND DelYN = 'N' "
		strSql = strSql & " GROUP BY tryoutgroupno "

		Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)

		If Not rs.EOF Then 

			arrRS = rs.getrows()

		End If




		If IsArray(arrRS) Then
			For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

					Response.write "<tr>" 

					strSql1 = "SELECT tryoutgroupno, tryoutsortno, A.UserName AS UserName_1, B.UserName AS UserName_2, A.TeamANa AS TeamANa_1 ,"
					strSql1 = strSql1 & " A.TeamBNa AS TeamBNa_1, B.TeamANa AS TeamANa_2, B.TeamBNa AS TeamBNa_2"
					strSql1 = strSql1 & " FROM sd_TennisMember A"
					strSql1 = strSql1 & " INNER JOIN sd_TennisMember_partner B ON A.gameMemberIDX = B.gameMemberIDX"
					strSql1 = strSql1 & " WHERE  GameTitleIDX ='" & tidx & "' AND gamekey3 = '" & levelno & "'"
					strSql1 = strSql1 & " AND A.DelYN = 'N'"
					strSql1 = strSql1 & " AND tryoutgroupno = " & arrRS(0,ar)



					Set rs1 = db.ExecSQLReturnRS(strSql1 , null, ConStr)
					


					If Not rs1.EOF Then 


						Response.Write "<td style='border: 1px solid #000;'>" &  arrRS(0,ar) & "</td>"



						tdcnt = 0

						Do Until rs1.EOF 

							Response.Write "<td style='border: 1px solid #000;'><div style='border: 1px solid #73AD21; width:100%;'  ondrop='mx.drop(event)' ondragover='mx.allowDrop(event)' ondragend='mx.dragEnd(event)' draggable='true' ondragstart='mx.drag(event)'  id='drag_" & rs1("tryoutgroupno") & "_" & rs1("tryoutsortno") & "'>" & rs1("UserName_1") & "(" & rs1("TeamANa_1") & "/" & rs1("TeamBNa_1") & ")," & rs1("UserName_2") & "(" & rs1("TeamANa_2") & "/" & rs1("TeamBNa_2") & ")</td>"
							rs1.movenext

							tdcnt = tdcnt + 1


						Loop

						If 3 - tdcnt <> 0 Then

							For i = 1 To 	3 - tdcnt
								Response.Write "<td style='border: 1px solid #000;'></td>"
							Next
						End If

						ReDim JSONarr(tdcnt)

					End If

					Response.write "</tr>" 

			Next
		End If

		Response.write "</tr>"
		Response.write "</table>"
		Response.write "</div>"
%><!-- #include virtual = "/pub/api/tennisAdmin/gametable/inc.leaguebtn.asp" --><%

				

				



db.Dispose
Set db = Nothing
%>

