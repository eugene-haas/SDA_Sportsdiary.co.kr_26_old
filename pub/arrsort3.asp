<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>Using iframe - Launch App with page loading</title>
<%
'	  <link href="http://img.sportsdiary.co.kr/lib/jquery/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
'	  <link href="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap.min.css" rel="stylesheet" media="screen">
'	  <link href="http://img.sportsdiary.co.kr/Manager/import_ri.css" rel="stylesheet">
%>
	 <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>


</head>
<body>


<%
'###################
'*******************************************************************************************
' getRows table형식으로 출력
'*******************************************************************************************

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



'올림함수
Function Ceil(ByVal intParam)  
 Ceil = -(Int(-(intParam)))  
End Function  
'###################

	Set db = new clsDBHelper

	SQL = "Select idx,nm,akind from sd_arrTest"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		rscnt = rs.RecordCount
		arrRS = rs.GetRows()

	End If
	rs.close	

	SQL = "Select akind, count(akind) as cnt from sd_arrTest group by akind order by cnt desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		rs_cnt = rs("cnt")
		arrK = rs.GetRows()
	End If

Response.write rs_cnt & " " &   UBound(arrK,1 ) & "<br>"
Response.write UBound(arrK, 2) & "<br>"

	Call getrowsdrow(arrK)


	makerows =  Ceil(rscnt / 4) '집어넣을 줄수
	Redim arrResult (3 , makerows -1) '결과값 담을 array


	Sub makesort(ByVal  arrRS , ByRef arrK , ByVal makerows, ByVal col, ByVal  row) '데이터 , 중복순서값 , 줄수, 배열시작 col, row
	Dim arrTemp,m,k,chkakind,kindcnt,chkcnt,idx,nm,akind,y,ar														 'makerows,col,row

	Redim arrTemp (UBound(arrRS,1 ), 1) '아닌것들 모아서..

	'종류별로
	m = 0
	If IsArray(arrK)  Then
		For k = LBound(arrK, 2) To UBound(arrK, 2)
			chkakind = arrK(0, k)
			kindcnt = arrK(1, k)

				chkcnt = 1
				If IsArray(arrRS)  Then
					For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
						idx = arrRS(0, ar)
						nm = arrRS(1, ar) 
						akind = arrRS(2, ar)
				
						'순서대로 담자.
						If chkakind = akind Then
							If CDbl(kindcnt) > CDbl(makerows) And CDbl(makerows) < chkcnt Then '종류갯수가 줄수보다 크고 
								'Response.write kindcnt &" " &  makerows &" " & chkcnt &"<br>"
								'Response.write "줄수 초과 " & "<br>"
								ReDim Preserve arrTemp(UBound(arrRs,1 ), m)
								For y = 0 To UBound(arrRS,1 ) 
									arrTemp(y, m) = arrRS(y, ar)
								Next 
								m = m + 1
							else
								arrResult(col, row) = nm
								chkcnt = chkcnt + 1
								If row = makerows -1 then
									row = 0
									col = col + 1
								Else
									row = row + 1
								End If
							End if
						End If

					Next
				End If 
		Next

		'남은게 없을때까지 재귀호출
		If arrTemp(0,0) <> "" Then
			Call makesort(arrTemp ,arrK, makerows, col, row)
		End if

	End If
	End Sub 

Call makesort(arrRs,arrK, makerows, 0 , 0)
Call getRowsDrow(arrResult)

'Response.write col & " " & row
'Call getRowsDrow(arrResult)
'Call getRowsDrow(arrTemp)
Response.end






'Response.write "총 :" & rscnt & "<br>"
'Call getRowsDrow(arrRS)
Call getRowsDrow(arrK)
'Response.write makerows

Response.end


Redim arrMake (UBound(arrNo,1 ), UBound(arrNo, 2)) '새로 만들어질 DB
Redim arrM3 (UBound(arrNo,1 ), 1) '3명이상의 중복인 친구들

	n = 0
	m = 0
	onepcnt = 0 '중복안된 사람 명수
	maxsamep = False '3명이상중복자 여부
	If IsArray(arrNo)  Then
		For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
			
			pnm = arrNo(3, ar) 
			hnm = arrNo(4, ar)
			no = arrNo(8,ar)
			sumno = arrNo(10,ar)

			If no >2 Then
				maxsamep = True 
			End If

			If no = 1 Then
				onepcnt = onepcnt + 1
			End if
				

			If  chkName(arrMake, pnm) = True And sumno > 2 then
				If pre_hnm <> hnm then
					'넣었는데 이름 중복된거 있나 다시 확인
					For x = 0 To UBound(arrNo,1 ) 
						arrMake(x, n) = arrNo(x, ar)
					Next 
					pre_pnm = pnm
					pre_hnm = hnm
					n = n + 1
				else
					ReDim Preserve arrM3(UBound(arrNo,1 ), m)
					For y = 0 To UBound(arrNo,1 ) 
					arrM3(y, m) = arrNo(y, ar)
					Next 
					m = m + 1
				End if
			Else
				ReDim Preserve arrM3(UBound(arrNo,1 ), m)
				For y = 0 To UBound(arrNo,1 ) 
				arrM3(y, m) = arrNo(y, ar)
				Next 
				m = m + 1
			End if
		Next
	End if

	If maxsamep = True Then
		onepcnt = Fix(onepcnt/2)
	End If 


	'순서뒤집어서 한명 맴버 찍기####################
	arrOne = arraySort (arrM3, 8, "Text", "desc" ) 
	
	m = 0
	If IsArray(arrOne)  Then
		For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
			
			pnm = arrOne(3, ar) 
			hnm = arrOne(4, ar)
			no = arrOne(8,ar)
			sumno = arrOne(10,ar)
			If no = 1 And ar <  onepcnt Then '1명짜리들 찍을 갯수만큼
					For x = 0 To UBound(arrOne,1 ) 
						arrMake(x, n) = arrOne(x, ar)
					Next 
					n = n + 1
			Else '넣은애들 빼고 다시 배열 생성
				ReDim Preserve arrM3(UBound(arrOne,1 ), m)
				For y = 0 To UBound(arrOne,1 ) 
				arrM3(y, m) = arrOne(y, ar)
				Next 
				m = m + 1
			End If
		Next
	End if


	'3명이상 친구들 두번째 아이들 그리기###################
	pre_pnm = ""
	pre_hnm = ""
	If maxsamep = True Then

		arrOne = arraySort (arrM3, 3, "Text", "desc" ) 

		m = 0
		If IsArray(arrOne)  Then
			For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
				
				pnm = arrOne(3, ar) 
				hnm = arrOne(4, ar)
				no = arrOne(8,ar)
				sumno = arrOne(10,ar)

				If no > 2 And  pre_pnm = pnm Then '3명이상일경우만
						If pre_hnm <> hnm then
							For x = 0 To UBound(arrOne,1 ) 
								arrMake(x, n) = arrOne(x, ar)
							Next 
							pre_hnm = hnm
							n = n + 1
						Else
							ReDim Preserve arrM3(UBound(arrOne,1 ), m)
							For y = 0 To UBound(arrOne,1 ) 
							arrM3(y, m) = arrOne(y, ar)
							Next 
							m = m + 1
						End if
				Else '넣은애들 빼고 다시 배열 생성
					ReDim Preserve arrM3(UBound(arrOne,1 ), m)
					For y = 0 To UBound(arrOne,1 ) 
					arrM3(y, m) = arrOne(y, ar)
					Next 
					m = m + 1
				End If

			pre_pnm = pnm
			Next
		End if



		'순서뒤집어서 한명 맴버 찍기####################
		arrOne = arraySort (arrM3, 8, "Text", "desc" ) 
		
		m = 0
		If IsArray(arrOne)  Then
			For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
				
				pnm = arrOne(3, ar) 
				hnm = arrOne(4, ar)
				no = arrOne(8,ar)
				sumno = arrOne(10,ar)
				If no = 1 Then '1명짜리들 남은것들 찍기
						For x = 0 To UBound(arrOne,1 ) 
							arrMake(x, n) = arrOne(x, ar)
						Next 
						n = n + 1
				Else '넣은애들 빼고 다시 배열 생성
					ReDim Preserve arrM3(UBound(arrOne,1 ), m)
					For y = 0 To UBound(arrOne,1 ) 
					arrM3(y, m) = arrOne(y, ar)
					Next 
					m = m + 1
				End If
			Next
		End if

	End If
	

	'그리고 남은애들 다찍으면 되지 않을까 
		arrOne = arraySort (arrM3, 8, "Text", "desc" ) 
		m = 0
		If IsArray(arrOne)  Then
			For ar = LBound(arrOne, 2) To UBound(arrOne, 2)
				
				pnm = arrOne(3, ar) 
				hnm = arrOne(4, ar)
				no = arrOne(8,ar)
				sumno = arrOne(10,ar)

						For x = 0 To UBound(arrOne,1 ) 
							arrMake(x, n) = arrOne(x, ar)
						Next 
						n = n + 1

			Next
		End if





'Call GetRowsdrow(arrOne)
Call GetRowsdrow(arrMake)
'Call GetRowsdrow(arrM3)

%>

</body>
</html>