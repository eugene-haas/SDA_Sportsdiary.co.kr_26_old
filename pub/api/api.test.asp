<%
Response.end
	
	
	'request 처리##############
	'seq = oJSONoutput.value("SEQ") 
	'request 처리##############


	Set db = new clsDBHelper

	Select Case CDbl(CMD)
	Case CMD_A1 '경기기록 삭제


		SQL = "select * from syscolumns where id = object_id('tblPlayer')"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
		arr = rs.getrows()
		End If

		
		'복사전 sample테이블에 실제 없는 필드가 존재할수 있다 . temp 테이블에 모든 필드를 null허용으로 해둔후 복사한다.
		SQL = "select * from syscolumns where id = object_id('tblPlayer_Sample')"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
		arrRS = rs.getrows()
		End If

		If IsArray(arrRS) Then
			For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
				'Response.write arrRS(0, ar) & "<br>"
				If CDbl(ar) = 0 Then
					'인덱스
				ElseIf CDbl(ar) = 1 Then
					copyfiled = arrRS(0, ar)
				else

					For n = LBound(arr, 2) To UBound(arr, 2) 
						If arrRS(0, ar) = arr(0, n) Then
							copyfiled = copyfiled & "," & arrRS(0, ar)
							Exit for
						End if
					next


				End if
			Next
		End If

Response.write copyfiled
Response.end

		'데이터복사
		SQL = "insert into tblPlayer_Temp ("&copyfiled&") select "&copyfiled&" from tblPlayer_Sample"
		Call db.execSQLRs(SQL , null, ConStr)		
		
		
		'1작업용 구조만 복사
		'백업용 복사 테이블만들기
		SQL = "select * into tblPlayer_Temp from tblPlayer Where 1=2"
		'Call db.execSQLRs(SQL , null, ConStr)




		
		SQL = "select * into tblPlayer_"&Replace(date,"-","")&"_"&Replace(Split(time," ")(1),":","") & " from tblPlayer"
		'Call db.execSQLRs(SQL , null, ConStr)
	

		'SQL = "delete from sd_TennisResult "
		'Call db.execSQLRs(SQL , null, ConStr)
		'SQL = "delete from sd_TennisResult_record "
		'Call db.execSQLRs(SQL , null, ConStr)

	Case CMD_A2 '참가신청 삭제
		SQL = "delete from tblGameRequest"
		'Call db.execSQLRs(SQL , null, ConStr)
		SQL = "update tblRGameLevel set attmembercnt = 0 "
		'Call db.execSQLRs(SQL , null, ConStr)
	
	Case CMD_A3 '대진표 참가자 삭제
		SQL = "delete from sd_TennisMember "
		'Call db.execSQLRs(SQL , null, ConStr)
		SQL = "delete from sd_TennisMember_partner"
		'Call db.execSQLRs(SQL , null, ConStr)

	Case CMD_A4 '참여부 삭제
		SQL = "delete from  tblRGameLevel "
		'Call db.execSQLRs(SQL , null, ConStr)
	Case CMD_A5
		'SQL = "delete from sd_TennisMember "
		'Call db.execSQLRs(SQL , null, ConStr)
		'SQL = "delete from sd_TennisRPoint "
		'Call db.execSQLRs(SQL , null, ConStr)
	End select


	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>