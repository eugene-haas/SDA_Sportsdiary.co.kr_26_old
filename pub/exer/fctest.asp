<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<%
				Function ConvertDateFormat(ByVal strDate)
					Dim tmpDate1, tmpDate2
					Dim returnDate
					tmpDate1 = Split(strDate, " ")
					tmpDate2 = Split(tmpDate1(2), ":")
					
					'오후라면 12시간을 더해준다
					If tmpDate1(1) = "오후" Then 
						'오후 12시는 정오를 가르키기 때문에 제외
						If CDbl(tmpDate2(0)) < 12 Then 
							tmpDate2(0) = CDbl(tmpDate2(0)) + 12
						End If 
					End If 
					
					returnDate = Replace(tmpDate1(0),"-","") & CheckFormat(tmpDate2(0),2) & CheckFormat(tmpDate2(1),2) & CheckFormat(tmpDate2(2),2)
					ConvertDateFormat = returnDate
				End Function 

				'자릿수를 맞추기 위한 함수
				Function CheckFormat(ByVal num, ByVal splitpos)
					Dim tmpNum : tmpNum = 10000000
					tmpNum = tmpNum + CDbl(num)
					CheckFormat = Right(tmpNum, splitpos)
				End Function 



'Response.write ConvertDateFormat("2021-11-05 00:00:42.103")
'Response.write ConvertDateFormat(now())
Response.write ConvertDateFormat("2021-11-05 오후 00:00:42.103")
%>