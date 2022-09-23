<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	dim Chk_Month(2)
	dim aa

'대회시작일 및 진행중정보 체크			
			IF DateDiff("d", NDate, DateValue(Chk_Month(1))) >= 0 OR DateDiff("d", DateValue(Chk_Month(2)), NDate) >=0 Then Chk_Game = TRUE			
							
			'========================================================================================		
			'대회해당월 체크
			'========================================================================================
			'시작일=종료일
			IF cint(mid(Chk_Month(1), 6, 2)) = cint(mid(Chk_Month(2), 6, 2)) Then
				IF cint(mid(Chk_Month(1), 6, 2)) = cint(Month(NDate)) Then
					aa = left(Chk_Month(1), 7)
				Else
					aa = left(Chk_Month(2), 7)
				End IF

			'시작일<>종료일
			Else									
				FOR Chk_Num=1 to 2						
					IF cint(mid(Chk_Month(Chk_Num), 6, 2)) = cint(Month(NDate)) Then 
						aa = left(Chk_Month(Chk_Num), 7)
					End IF			
				NEXT
			End IF
			
			response.Write aa
%>