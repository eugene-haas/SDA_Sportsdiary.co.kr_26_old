<%
	If F1 <> "" Then
		Select Case F1
		Case "DB00" : 	ConStr = B_ConStr '공통
		Case "DB01" : 	ConStr = T_ConStr '멤버
		Case "DB02" : 	ConStr = I_ConStr '아이템센터
		Case "DB03" : 	ConStr = BM_ConStr '베드민턴
		Case "DB04" : 	ConStr = KATA_ConStr '테니스
		Case "DB05" : 	ConStr = RT_ConStr 'SD테니스
		Case "DB06" : 	ConStr = SW_ConStr '수영
		Case "DB07" : 	ConStr = R_ConStr '승마
		Case "DB08" : 	ConStr = BK_ConStr '자전거
		Case "DB09" : 	ConStr = UD_ConStr '유도
		Case "DB10" : 	ConStr = WK_ConStr 'json
		Case "DB11" : 	ConStr = K_ConStr '대회실적

		Case "DB12" : 	ConStr = SP_ConStr '스포츠Player
		Case "DB13" : 	ConStr = SD_ConStr '스포츠Diary
		Case "DB14" : 	ConStr = KN_ConStr '한체대 game
		End Select
	End If
%>
