<!-- #include virtual = "/pub/header.pub.asp" -->
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>Using iframe - Launch App with page loading</title>
	 <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>
</head>
<body>


<%
'Set errdic = CreateObject("Scripting.Dictionary")
'errdic.add "e","A"
'Response.write errdic("e")
'Response.end

'###################
'*******************************************************************************************
' getRows table형식으로 출력
'*******************************************************************************************
'2차원 배열 소팅  사용예) productEvList = arraySort (arrNo, 4, "Text", "asc" ) 
'==============================================
function arraySort( arToSort, sortBy, compareType, direction )
'==============================================
	Dim c, d, e, smallestValue, smallestIndex, tempValue
	For c = 0 To uBound( arToSort, 2 ) - 1
	 smallestValue = arToSort( sortBy, c )
	 smallestIndex = c
	 For d = c + 1 To uBound( arToSort, 2 )
	  if compareType = "Text" Then
	   If direction = "desc" Then 
		if strComp( CStr(arToSort( sortBy, d )), CStr(smallestValue) ) = -1 Then
		 smallestValue = arToSort( sortBy, d )
		 smallestIndex = d
		End if
	   Else 
		if strComp( CStr(arToSort( sortBy, d )), CStr(smallestValue) ) = 1 Then
		 smallestValue = arToSort( sortBy, d )
		 smallestIndex = d
		End if
	  End If 
	  elseif compareType = "Date" then
	   if not isDate( smallestValue ) then
		arraySort = arraySort( arToSort, sortBy, false)
	   exit function
	  else
	   if dateDiff( "d", arToSort( sortBy, d ), smallestValue ) > 0 Then
		smallestValue = arToSort( sortBy, d )
		smallestIndex = d
	   End if
	  end if
	  elseif compareType = "Number" Then
	   if clng( arToSort( sortBy, d ) ) > clng(smallestValue) Then
		smallestValue = arToSort( sortBy, d )
		smallestIndex = d
	   End if
	  end if
	 Next
	 if smallestIndex <> c Then 'swap
	  For e = 0 To uBound( arToSort, 1 )
	   tempValue = arToSort( e, smallestIndex )
	   arToSort( e, smallestIndex ) = arToSort( e, c )
	   arToSort( e, c ) = tempValue
	  Next
	 End if
	Next
	arraySort = arToSort 
end function


'올림함수
Function Ceil(ByVal intParam)  
 'Ceil = -(Int(-(intParam)))  
 Ceil = Round((intParam) + 0.49)
End Function  
'###################
'Response.Write Ceil(4.3)    ' 5  
'Response.Write Ceil(9.999)  ' 10  
'Response.Write Ceil(-3.14)  ' -3  
'Response.end




	Set db = new clsDBHelper
	
	'복식임
	COLS = 8 '행수
	CHKCOLNO = 0
	CHKCOLNO2 = 1

	rowsidx = " (ROW_NUMBER() OVER (ORDER BY F.GameRequestGroupIDX)) " '라인인덱스
	'rowsgroupno = " (ROW_NUMBER() OVER (PARTITION BY F.GameRequestGroupIDX ORDER BY G.sidogugun)), " '팀중순서 1,2
	'tno = "  ((ROW_NUMBER() OVER (ORDER BY F.GameRequestGroupIDX)) -(ROW_NUMBER() OVER (PARTITION BY F.GameRequestGroupIDX ORDER BY G.sidogugun))) / 2 ,    " '페이번호
	'tempsole = " (H.GuGunNm + D.TeamName) as comptemp, "


	'(0) As fUse, D.MemberIDX, D.Team, ,  IsNull(G.sidogugun, 'N Data')
	', IsNull(H.GuGunNm, 'N Data') , A.Sex, A.GroupGameGb, B.TotRound, A.GameLevelIDX, A.GameTitleIDX, A.TeamGb, B.GameLevelDtlidx, A.[Level], B.LevelDtlName
	',         F.GameRequestGroupIDX, MemberName  
	SQL = "Select  " & rowsidx & ", "& rowsgroupno &"  "&tno&"                "&tempsolo&"    H.GuGunNm, D.TeamName         From tblgamelevel A With (NoLock) INNER JOIN tblgameleveldtl B With (NoLock)  ON B.GameLevelIDX = A.GameLevelIDX INNER JOIN tblGameRequestTouney C With (NoLock)  ON  C.GameLevelDtlIDX = B.GameLevelDtlIDX INNER JOIN tblGameRequestGroup F With (NoLock)  ON C.RequestIDX = F.GameRequestGroupIDX INNER JOIN tblGameRequestPlayer D With (NoLock)  ON D.GameRequestGroupIDX = F.GameRequestGroupIDX LEFT JOIN tblTeamInfo G With (NoLock)  ON G.Team = D.Team LEFT JOIN tblGugunInfo H With (NoLock)  ON H.GuGun = G.sidogugun AND H.DELYN = 'N' Where A.DelYN = 'N' AND B.DElYN = 'N' AND F.DElYN = 'N' AND C.DelYN = 'N' AND G.DelYN= 'N'  AND B.GameLevelDtlIDX = '11977' AND A.GameTitleIDX = '1321'  ORDER BY F.GameRequestGroupIDX"
	Set rs = db.ExecSQLReturnRS(SQL , null, BM_ConStr)





	If Not rs.EOF Then
		rscnt = rs.RecordCount
		rs.sort = " H.GugunNm desc"
		arrRS = rs.GetRows()
	End If
	rs.close	

Call getRowsDrow(arrRS)
Response.end

'파트너와 한줄로 만든다. (짝수이고 파트너는 무조건 있어야한다 아니면 그룹번호로 비교해서 만들것)
Redim teamRS(UBound(arrRS,1 ) * 2 + 1 ,  UBound(arrRS, 2) / 2 ) '새로 만들어질 DB
m = 0
If IsArray(arrRS)  Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
		If ar Mod 2 = 0 then
			For x = 0 To UBound(arrRS,1 ) 
				teamRS(x, m) = arrRS(x, ar)
			Next 
			For y = 0 To UBound(arrRS,1 ) 
				'Response.write x + y & "<br>"
				teamRS(x + y, m) = arrRS(y, ar + 1)
			Next 
			m = m + 1 '줄바꿈
		End if
	Next
End If

'##################################
'0번필드에 시도더한걸 만든다. 1번필드에다가 팀더한걸 만들고
Redim sumRS(UBound(teamRS,1 ) + 2    ,  UBound(teamRS, 2)  ) '새로 만들어질 DB
'Function fieldStringSum(teamRS,1, 4)
m = 0
If IsArray(sumRS)  Then
	For ar = LBound(sumRS, 2) To UBound(sumRS, 2)

			For x = 0 To UBound(sumRS,1 ) - 2
				If x = 0 then
					sumRS(x, m) = teamRS(1, ar) &","& teamRS(4, ar)  '맨압에 더한문자열을 넣는다.
				End If

				If x = 1 then
					sumRS(x, m) = teamRS(0, ar) &","& teamRS(1, ar) &","& teamRS(4, ar) &","& teamRS(2, ar) &","& teamRS(5, ar)  '맨압에 더한문자열을 넣는다.
				End If				
				sumRS(x+2, m) = teamRS(x, ar)
			Next 
			m = m + 1 '줄바꿈

	Next
End If


arr = arraySort (sumRS, 0, "Text", "desc" ) '최종 비교할 배열
'Call getrowsdrow(arr)


Redim arrC (1, 0) ' 2,2
cnt = 0
m = 0
If IsArray(arr)  Then
	For ar = LBound(arr, 2) To UBound(arr, 2)
		sortnm = arr(0,ar)
		If ar > 0 then
			If sortnm = presortnm Then
				cnt = cnt + 1
			Else
				'저장
				cnt = cnt + 1
				ReDim Preserve arrC(1, m)	
				arrC(0, m) = presortnm
				arrC(1, m) = cnt
				cnt = 0
				m = m + 1
			End If
		End if

		presortnm = sortnm
	Next
End if

'그룹별 카운트 배열 생성 높은순으로
arrK = arraySort (arrC, 1, "Number", "desc" )

	resultrows =  Ceil(UBound(arr, 2)  /  COLS) '집어넣을 줄수
	Redim arrResult (COLS-1 , resultrows -1) '결과값 담을 array
	compcol = CHKCOLNO '시도문자열 더한거
	compcol2 = CHKCOLNO2 '전체더한거...instr로
	colidx  = 1

	'###############################################################################
	Sub makesort(ByVal  arrRS , ByRef arrK , ByVal resultrows, ByVal compcol, ByVal comcol2, ByVal colidx,  ByVal col, ByVal  row ,ByVal  loopcnt) '데이터 , 중복순서값 , 줄수, 배열시작 col, row
	Dim arrTemp,m,k,chkakind,kindcnt,putincnt,idx,nm,akind,y,ar			,c											 'resultrows,col,row

	Redim arrTemp (UBound(arrRS,1 ), 0) '아닌것들 모아서..

	Dim cols
	cols = 8

	Dim initcol, chkteam
	initcol = col


	Dim akind3 
	loopcnt = loopcnt + 1
	 

	'종류별로
	m =0
	If IsArray(arrK)  Then
		For k = LBound(arrK, 2) To UBound(arrK, 2)
			chkakind = arrK(0, k) '중복비교값
			kindcnt = arrK(1, k) '중복갯수

				putincnt = 0 '열에 넣은갯수

				If k = 0 And loopcnt > 1 Then
					putincnt = row -1
				End If 


				If IsArray(arrRS)  Then
					For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
						'idx = arrRS(0, ar)
						nm = arrRS(colidx, ar) 
						akind = arrRS(compcol, ar) '데이터 중복비교값
						
						akind2 = arrRS(4,ar)   '두번째 비교값
						akind3 = arrRS(7,ar) '새번째 비교값

						'@@@@@@@@@@@@
						'순서대로 담자.

						If chkakind = akind Then '그룹비교값과 줄교값

							If  CDbl(resultrows) < CDbl(kindcnt) And CDbl(resultrows) <= CDbl(putincnt)  Then '종류갯수보다 많고 넣은게 많으면

								'Response.write putincnt & "<br>"
								Response.write loopcnt &" " &  resultrows &" " & putincnt &"<br>"
								ReDim Preserve arrTemp(UBound(arrRs,1 ), m)
								For y = 0 To UBound(arrRS,1 ) 
									arrTemp(y, m) = arrRS(y, ar)
								Next 
								m = m + 1

							else

								'줄수가 초과되어서 왔다면
								If CDbl(loopcnt) > 1 and  CDbl(loopcnt) < 3 Then
										chkteam = false
										'같은 열(loopcnt)에 시도가 같은애가 있다...  팀명칭을 비교한다. 같다면 ....
										'Response.write arrResult(col, row) &   akind2 & "--<br>"
										

										For c = 0 To cols -1
											If InStr(arrResult(c, row), akind) > 0 And InStr(arrResult(c, row), akind2) > 0  And InStr(arrResult(c, row), akind3) > 0 Then '전체에서 시도같은애를 찾은다음에 팀명칭같은지 비교
													chkteam = true
													ReDim Preserve arrTemp(UBound(arrRs,1 ), m)
													
													Response.write loopcnt & "--M:" & m & "<br>"
													If loopcnt = 2 then
													For y = 0 To UBound(arrRS,1 ) 
														arrTemp(y, m) = arrRS(y, ar)
													Next 
													End If
													'If loopcnt = 3 then
													'For y = 0 To UBound(arrRS,1 ) 
													'	If m < 3 Then

													'	arrTemp(y, m) = arrRS(y, ar)
													'End if
													'Next 
													'End If

													Call getrowsdrow(arrtemp)
													m = m + 1
											End if
										Next 

										If chkteam = False Then
											putincnt = putincnt + 1
											arrResult(col, row) = nm & loopcnt

											If row = resultrows -1 then
												row = 0
												col = col + 1
											Else
												row = row + 1
											End If
										End if

								else

									arrResult(col, row) = nm 
									putincnt = putincnt + 1	'넣은갯수
									If row = resultrows -1 then
										row = 0
										col = col + 1
									Else
										row = row + 1
									End If


								End if

							End If
						End If
						'@@@@@@@@@@@@
						
					Next
				End If 
		Next

		'남은게 없을때까지 재귀호출

		If arrTemp(0,0) <> "" Then
			Call makesort(arrTemp ,arrK, resultrows, compcol, comcol2, colidx, col, row  ,loopcnt)
		End if

	End If
	End Sub 

'Call makesort(arrRs,arrK, resultrows, compcol, 0 , 0)
loopcnt = 0
Call makesort(arr,arrK, resultrows, compcol, comcol2, colidx, 0 , 0, loopcnt)
Call getRowsDrow(arrResult)

'입력된 인덱스 값으로 row 다시 생성해보자.
'arr 로


'한줄씩 소팅해서 시도중복값을 


If IsArray(arr)  Then
	For ar = LBound(arr, 2) To UBound(arr, 2)

	Next
End if


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