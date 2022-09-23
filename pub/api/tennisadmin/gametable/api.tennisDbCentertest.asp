<%
Response.end


	'request 처리##############
	'seq = oJSONoutput.value("SEQ") 
	'request 처리##############
	Set db = new clsDBHelper
	Select Case CDbl(CMD)
	Case CMD_A1 '경기기록 삭제
		tblname = "sd_TennisResult"
		SQL = "select * into "&tblname&"_"&Replace(date,"-","")&"_"&Replace(Split(time," ")(1),":","") & " from "&tblname
		Call db.execSQLRs(SQL , null, ConStr)
		tblname = "sd_TennisResult_record"
		SQL = "select * into "&tblname&"_"&Replace(date,"-","")&"_"&Replace(Split(time," ")(1),":","") & " from "&tblname
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "delete from sd_TennisResult "
		'Call db.execSQLRs(SQL , null, ConStr)
		SQL = "delete from sd_TennisResult_record "
		'Call db.execSQLRs(SQL , null, ConStr)

	Case CMD_A2 '참가신청 삭제
		tblname = "tblGameRequest"
		SQL = "select * into "&tblname&"_"&Replace(date,"-","")&"_"&Replace(Split(time," ")(1),":","") & " from "&tblname
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "delete from tblGameRequest"
		'Call db.execSQLRs(SQL , null, ConStr)
		SQL = "update tblRGameLevel set attmembercnt = 0 "
		'Call db.execSQLRs(SQL , null, ConStr)
	
	Case CMD_A3 '대진표 참가자 삭제
		tblname = "sd_TennisMember"
		SQL = "select * into "&tblname&"_"&Replace(date,"-","")&"_"&Replace(Split(time," ")(1),":","") & " from "&tblname
		Call db.execSQLRs(SQL , null, ConStr)
		tblname = "sd_TennisMember_partner"
		SQL = "select * into "&tblname&"_"&Replace(date,"-","")&"_"&Replace(Split(time," ")(1),":","") & " from "&tblname
		Call db.execSQLRs(SQL , null, ConStr)
		
		SQL = "delete from sd_TennisMember "
		'Call db.execSQLRs(SQL , null, ConStr)
		SQL = "delete from sd_TennisMember_partner"
		'Call db.execSQLRs(SQL , null, ConStr)

	Case CMD_A4 '참여부 삭제



'		SQL = "delete from  tblPlayer "
'		Call db.execSQLRs(SQL , null, ConStr)
'		SQL = "delete from  tblRGameLevel "
'		Call db.execSQLRs(SQL , null, ConStr)
'		SQL = "delete from  tblTeamInfo "
'		Call db.execSQLRs(SQL , null, ConStr)
'
		SQL = "delete from  tblGameRequest "
		'Call db.execSQLRs(SQL , null, ConStr)
'
'		SQL = "delete from  sd_TennisTitle "
'		Call db.execSQLRs(SQL , null, ConStr)



		
	Case CMD_A5 '예선 참가자와 총 포인트 삭제
		SQL = "delete from sd_TennisRPoint "
		'Call db.execSQLRs(SQL , null, ConStr)

	
	








	
	Case CMD_A6 '테이블 복사 
		



		tableName =	oJSONoutput.TABLENAME&"_sample"
		'copyTableName = tableName & "_Temp"
		copyTableName = oJSONoutput.TABLENAME
		IsExitTable = 0
		IsExitCopyTable = 0

	





		SQL = "select * into "&copyTableName &"_"& Replace(date,"-","")&Mid(Replace(time,":",""),4)  &" from "&copyTableName
		Call db.execSQLRs(SQL , null, ConStr)		
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		db.Dispose
		Set db = Nothing
		Response.End
		




		'원본 테이블 체크
		SQL = "SELECT 1 as Cnt FROM sysobjects  WHERE name  = '" & tableName & "'"
		'Response.write "테이블 존재 여부 : " & SQL & "</br>"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			IsExitTable = rs("Cnt")
		END IF

		'카피 테이블 체크
		SQL = "SELECT 1 as Cnt FROM sysobjects  WHERE name  = '" & copyTableName & "'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			IsExitCopyTable = rs("Cnt")
		END IF

		'Response.write "백업 테이블 존재 여부 :" & IsExitTable  & "</br>"
		IF(IsExitCopyTable = "1" and IsExitTable = "1") Then
			'복사전 sample테이블에 실제 없는 필드가 존재할수 있다 . temp 테이블에 모든 필드를 null허용으로 해둔후 복사한다.
			SQL = "select * from syscolumns where id =  object_id('"&tableName&"')"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'Response.write " 테이블 필드 가져오기: " & SQL & "</br>"
			'Response.End
			If Not rs.EOF Then 
				arrRS = rs.getrows()
			End If

			'작업용 구조만 복사
			'백업용 복사 테이블만들기
			SQL = "select * into " & copyTableName & " from " & tableName &" Where 1=2"
			'Response.write " 백업용 복사 테이블만들기: " & SQL & "</br>"
			'Call db.execSQLRs(SQL , null, ConStr)




				If IsArray(arrRS) Then
					'Response.write "배열~"  & "</br>"
					For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

						If CDbl(ar) = 0 Then
							'인덱스
						ElseIf CDbl(ar) = 1 Then
							copyfiled = arrRS(0, ar)
							'Response.write copyfiled & "<br>"
						ELSE
							copyfiled = copyfiled & "," & arrRS(0, ar)
							'Response.write copyfiled & "<br>"
						End if

					Next
				End If

				SQL = "insert into " &  copyTableName & " ("&copyfiled&") select "&copyfiled&" from " & tableName
				'Response.write " 데이터복사: " & SQL & "</br>"
				Call db.execSQLRs(SQL , null, ConStr)		
				'Response.write "테이블 생성 완료</br>"
			ELSE
				'Response.write "이미 테이블이 있습니다.</br>"
			END IF
			'Response.write copyfiled
















	
	
	Case CMD_A7 '테이블 삭제

		
		Response.end

		tableName =	oJSONoutput.TABLENAME
		copyTableName = tableName & "_" & Hour(time) & Minute(time) & Second(time)
		'Response.Write "tableName : " & tableName & "</br>"
		'Response.Write "copyTableName : " & copyTableName & "</br>"

		IsExitTable = 0
		IsExitCopyTable = 0

		'원본 테이블 체크
		SQL = "SELECT 1 as Cnt FROM sysobjects  WHERE name  = '" & tableName & "'"
		'Response.write "테이블 존재 여부 : " & SQL & "</br>"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			IsExitTable = rs("Cnt")
		END IF

		'카피 테이블 체크
		SQL = "SELECT 1 as Cnt FROM sysobjects  WHERE name  = '" & copyTableName & "'"
		'Response.write "테이블 존재 여부 : " & SQL & "</br>"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			IsExitCopyTable = rs("Cnt")
		END IF

		IF(IsExitTable = 1 and IsExitCopyTable = 0 ) Then
			'Response.write "원본 테이블이 있으면서 Copy 테이블은 없음!" & "</br>"
			'복사전 sample테이블에 실제 없는 필드가 존재할수 있다 . temp 테이블에 모든 필드를 null허용으로 해둔후 복사한다.
			SQL = "select * from syscolumns where id =  object_id('"&tableName&"')"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'Response.write " 테이블 필드 가져오기: " & SQL & "</br>"
			'Response.End
			If Not rs.EOF Then 
				arrRS = rs.getrows()
			End If

			If IsArray(arrRS) Then
				'작업용 구조만 복사
				'백업용 복사 테이블만들기
				SQL = "select * into " & copyTableName & " from " & tableName &" Where 1=2"
				'Response.write " 백업용 복사 테이블만들기: " & SQL & "</br>"
				Call db.execSQLRs(SQL , null, ConStr)
				'Response.write "배열~"  & "</br>"
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
					If CDbl(ar) = 0 Then
						'인덱스
					ElseIf CDbl(ar) = 1 Then
						copyfiled = arrRS(0, ar)
						'Response.write copyfiled & "<br>"
					ELSE
						copyfiled = copyfiled & "," & arrRS(0, ar)
						'Response.write copyfiled & "<br>"
					End if
				Next

				SQL = "insert into " &  copyTableName & " ("&copyfiled&") select "&copyfiled&" from " & tableName
				'Response.write " 데이터복사: " & SQL & "</br>"
				Call db.execSQLRs(SQL , null, ConStr)		
				'Response.write "테이블 생성 완료</br>"


				'카피 테이블 체크
				SQL = "SELECT 1 as Cnt FROM sysobjects  WHERE name  = '" & copyTableName & "'"
				'Response.write "테이블 존재 여부 : " & SQL & "</br>"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof Then
					IsExitCopyTable = rs("Cnt")
				END IF

				IF IsExitCopyTable = 1 Then
					'response.write "Copy Table이 만들어졌습니다. 원본테이블을 지웁니다."
					SQL = "drop table " & tableName 
					'Call db.execSQLRs(SQL , null, ConStr)		
					'response.write SQL & "</br/>"
				ENd if

			End If

		End if

	End select

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>