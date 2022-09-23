<%
'#############################################
'수정(ajax api)
'#############################################
'db 호출
Set db = new clsDBHelper


'request
idx = oJSONoutput.IDX

tablename = " K_gameVideoInfo a LEFT JOIN k_gameFileName b ON a.GameVideo = b.GameVideo "
strfield = "EventYear, ClassCode, GameName, GameCode, GameSDate, GameEDate, GameAgeDistinct, GameGroupType, GameMatchType, GameMemberGender, GameOrder, GameMember, a.GameVideo, GameDetailTypeIDX, b.FileName AS GameFileName "
SQL = "SELECT " &strfield& " FROM "&tablename&" WHERE GameVideoIDX = " & idx

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.eof Then
	rsEventYear = rs("EventYear")
	rsClassCD = rs("ClassCode")
	rsGameName = rs("GameName")
	rsGameCode = rs("GameCode")
	rsGameSDate = rs("GameSDate")
	rsGameEDate = rs("GameEDate")
	rsGameAgeDistinct = rs("GameAgeDistinct")
	rsGameGroupType = rs("GameGroupType")
	rsGameMatchType = rs("GameMatchType")
	rsGameMemberGender = rs("GameMemberGender")
	rsGameOrder = rs("GameOrder")
	rsGameMember = rs("GameMember")
	rsGameVideo = rs("GameVideo")
	rsDetailType = rs("GameDetailTypeIDX")
  rsGameFileName = rs("GameFileName")
End If



'세부종별 불러오기
SQL = " SELECT idx, DetailType FROM k_detailTypeList WHERE ClassCode = '"&rsClassCD&"' AND delYN = 'N' "
Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

If Not rs.eof then
    arrDT = rs.getrows()
End If

'종목선택 불러오기
SQL = "Select classIDX, classCode, className from tblClassList order by className ASC"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
	arrClass = rs.GetRows()
End If

'성별선택 불러오기
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameMemberGender'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
	arrGender = rs.GetRows()
End If

'학군선택 불러오기
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameAgeDistinct'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
	arrAge = rs.GetRows()
End If

'경기방식선택 불러오기
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameMatchType'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
	arrMatch = rs.GetRows()
End If

'종별선택불러오기
SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameGroupType'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
	arrGroup = rs.GetRows()
End If


db.Dispose
Set db = Nothing


Dim mode
If rsGameCode = "t99999999" Then
	mode = "t"
	totalCount = 0
Else
	mode = "e"
End If

Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("idx", idx )

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
%>
<!-- #include virtual = "/pub/html/ksports/gameinputform.asp" -->
