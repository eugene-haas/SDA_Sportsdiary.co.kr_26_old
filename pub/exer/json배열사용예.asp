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

req = "{""RESULT_CD"":""0000"",""RESULT_MSG"":""성공"",""CAMP_ID"":""M1808915"",""TR_ID"":""WIDLINE_20195241838494"",""ORD_INFO"":[{""ORD_NO"":""O0519225217255"",""RCVR_MDN"":""01029468454"",""CPNO_INFO"":[{""CPNO"":""999367970925"",""CPNO_SEQ"":""1"",""EXCH_FR_DY"":""20190524"",""EXCH_TO_DY"":""20200523""}]}],""ordResult"":false}"

Set obj = JSON.Parse( join(array(REQ)) )

Set sList = obj.ORD_INFO

Response.write sList.length
Set this = sList.Get(0)

Response.write this.ORD_NO

Response.end


For intloop = 0 To obj.sList.length-1
	   
	   Set this = sList.Get(intloop)

	   Response.Write this.[id] & "<br/>"  ' 이경우엔 둘다 id가 있으니 에러없이 잘 표시됩니다.

	   Response.Write this.[Type] & "<br/>"  
	   ' 이경우엔 첫번째는 있어서 에러가 안나는데 2번째엔 type이 없어서 
'	    Microsoft VBScript 런타임 오류 오류 '800a01b6'
'	   개체가 이 속성 또는 메서드를 지원하지 않습니다.: 'Type'

'	   이렇게 에러가 납니다.

	   Response.Write this.[stnm] & "<br/>"  '값이 있다면 [object,object] 이런식으로 표현이 되겠죠.

	   ' 이 경우에도 첫번째에 stnm이 없기 때문에 
'	    Microsoft VBScript 런타임 오류 오류 '800a01b6'
'	   개체가 이 속성 또는 메서드를 지원하지 않습니다.: 'stnm'

'	   이렇게 에러가 납니다.

'	    IsEmpty, IsNull, Len, isobject 다 체크를 해봐도 위와 같이 에러가 납니다. 
	    
next

Response.end

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


Function chkName(ByRef arr, ByVal pnm)
	Dim fnresult, ar
	fnresult = true
	If IsArray(arr)  Then
		For ar = LBound(arr, 2) To UBound(arr, 2)
			If pnm = arr(3, ar)  Then
				fnresult = false
				Exit For 
			End if
		Next
	End If

	chkName = fnresult
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
		arrK = rs.GetRows()
	End If

	makerows =  Ceil(rscnt / 4) '집어넣을 줄수

'	Redim arrMake (UBound(arrRS,1 ), UBound(arrRS, 2)) '많은것부터 나오도록 소팅해서 넣을 배열
'	If IsArray(arrRS)  Then
'		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
'			idx = arrRS(0, ar)
'			nm = arrRS(1, ar) 
'			akind = arrRS(2, ar)
'	
'				If IsArray(arrK)  Then
'					For k = LBound(arrK, 2) To UBound(arrK, 2)
'						chkakind = arrK(0, k )
'						If (akind = chkakind) Then
'								For x = 0 To UBound(arrK,1 ) 
'									arrMake(x, n) = arrK(x, k)
'								Next
'						End if
'					Next
'				End If
'			Next
'		Next
'	End If 

'arrSort1 = arraySort (arrRS, 2, "Text", "desc" ) '종류별로 나오도록 소팅해서 넣어둠

'Response.write UBound(arrRS, 2)
'Call getRowsDrow(arrSort1)


	Redim arrResult (3 , makerows -1) '결과값 담을 array
	Redim arrM3 (UBound(arrRs,1 ), 1) '아닌것들 모아서..

	'종류별로
	col = 0
	row = 0
'	rowsetcnt = 0
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
							arrResult(col, row) = nm
							cnkcnt = chkcnt + 1
							If row = makerows -1 then
								row = 0
								col = col + 1
							Else
								row = row + 1
							End If
						End If

					Next
				End If 		
		
		
		Next
	End If


Call getRowsDrow(arrResult)
Response.end

'
'	If IsArray(arrRS)  Then
'		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
'			idx = arrRS(0, ar)
'			nm = arrRS(1, ar) 
'			akind = arrRS(2, ar)
'	
'			'순서대로 담자.
'				If IsArray(arrK)  Then
'
'					For k = LBound(arrK, 2) To UBound(arrK, 2)
'						chkakind = arr(0, k)
'						arrMake(x, n) = arrK(x, k)						
'					Next
'				End If
'			Next
'
'		Next
'	End If 



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