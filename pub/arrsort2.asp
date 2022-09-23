<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>Using iframe - Launch App with page loading</title>
</head>
<body>


<%
	Set db = new clsDBHelper

	tblnm = " SD_tennisMember as a Inner join sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gameMemberIDX,a.playeridx,b.playeridx,a.username,b.username,a.tryoutresult ,a.gubun, a.tryoutsortno     ,ctbl.c ,htbl.hc , (ctbl.c + htbl.hc) as csum" 
	SQL = "Select "&fldnm&" from "&tblnm
	
	SQL = SQL & " left join (select playeridx, count(*)  as c  from sd_tennisMember where gametitleidx = 17 and delyn= 'N' and gamekey3 = '183' and gubun < 100 and round = 1 group by playeridx ) as ctbl On a.PlayerIDX = ctbl.PlayerIDX "

	SQL = SQL & " left join (select tmp.playeridx as hidx, count(*)  as hc  from sd_tennisMember as tm Inner join sd_tennisMember_partner as tmp ON tm.gamememberidx = tmp.gamememberidx  where tm.gametitleidx = 17 and tm.delyn= 'N' and tm.gamekey3 = '183' and tm.gubun < 100 and tm.round = 1 group by tmp.playeridx ) as htbl On b.PlayerIDX = htbl.hidx "

	SQL = SQL & " where a.gametitleidx = 17 and a.delYN = 'N' and a.gamekey3 = '183' and a.gubun < 100 and a.round=1   order by csum desc, ctbl.c desc, a.username ,htbl.hc desc,  b.username desc "	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	Call rsdrow(rs)

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrNo = rs.GetRows()
	End If
	rs.close	



' 3개짜리들을 모두 1개씩 넣는다. (말정보 횡으로 만든다.)
'2개짜리들을 모두 1개씩 넣는다.(말정보를 횡으로 만든다.)
'if 3개짜리가 있다면
	'1개짜리를 반만 넣는다.
	'3짜리 두번째 값들을 넣는다.
	'1개짜리 반을 마져 넣는다.
	'3개짜리 3번째 것들을 넣는다.
	'2개짜리 두번째 것을 넣는다.
'else
	'1개짜리를 모두 넣는다.
	'두개짜리 두번째 것들을 넣는다.

' productEvList = arraySort (productEvList, orderbyNum, "Text", "asc" ) 

'productEvList = arraySort (arrNo, 10, "Text", "asc" ) 
'Call GetRowsdrow(productEvList)


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
End function



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