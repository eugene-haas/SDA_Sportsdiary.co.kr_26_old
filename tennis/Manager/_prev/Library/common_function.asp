<%
'=========================================================================================================================================================
'============================================================* 한자리수 숫자 0붙이기  ====================================================================
'=========================================================================================================================================================

Function AddZero(Str)
 IF len(Str)=1 Then
  AddZero="0"&Str
 Else
  AddZero=Str
 End IF
End Function
'=========================================================================================================================================================
'============================================================* 한자리수 숫자 0붙이기  ====================================================================
'=========================================================================================================================================================
'=========================================================================================================================================================
'============================================================* 참여인원에 따른 강수 구하기================================================================
'=========================================================================================================================================================
	Function chk_TotRound(PlayerCnt)
		If PlayerCnt <=2 Then 
			chk_TotRound = 2
		ElseIf PlayerCnt > 2 And PlayerCnt <=4 Then 
			chk_TotRound = 4
		ElseIf PlayerCnt > 4 And PlayerCnt <=8 Then 
			chk_TotRound = 8
		ElseIf PlayerCnt > 8 And PlayerCnt <=16 Then 
			chk_TotRound = 16
		ElseIf PlayerCnt > 16 And PlayerCnt <=32 Then 
			chk_TotRound = 32
		ElseIf PlayerCnt > 32 And PlayerCnt <=64 Then 
			chk_TotRound = 64
		ElseIf PlayerCnt > 64 And PlayerCnt <=128 Then 
			chk_TotRound = 128
		End If 
	End Function 
'=========================================================================================================================================================
'============================================================* 참여인원에 따른 강수 구하기================================================================
'=========================================================================================================================================================
Function Medal_Score(Medal_Type)
	If Medal_Type = "sd034001" Then 
		Medal_Score = "1"
	ElseIf Medal_Type = "sd034002" Then 
		Medal_Score = "2"
	ElseIf Medal_Type = "sd034003" Then 
		Medal_Score = "3"
	End If 
End Function 



	
	Function random_str()
  Dim str, strlen, r, i, ds, serialCode '사용되는 변수를 선언


  str = "1234" '랜덤으로 사용될 문자 또는 숫자

   strlen = 1 '랜덤으로 출력될 값의 자릿수 ex)해당 구문에서 10자리의 랜덤 값 출력

   Randomize '랜덤 초기화
   For i = 1 To strlen '위에 선언된 strlen만큼 랜덤 코드 생성
    r = Int((4 - 1 + 1) * Rnd + 1)  ' 4은 str의 문자갯수
    serialCode = serialCode + Mid(str,r,1)

   Next
   random_str = serialCode
 End Function



%>