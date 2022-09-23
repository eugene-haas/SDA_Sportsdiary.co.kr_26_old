<%
	Function rndno(seed, lenno)
		Dim tempAuth
		'랜덤값 만들기
		Randomize   ' 난수 발생기 초기화
		For i = 1 To lenno
			tempAuth = tempAuth &  Int((seed * Rnd) + 0) ' 1에서 seed까지 무작위 값 발생
		Next
		rndno = tempAuth
	End Function
	
	tempAuth =  rndno(10, 4)


Response.write tempAuth
Response.end

'전체값 X 퍼센트 ÷ 100
'예제) 300의 35퍼센트는 얼마?
'답) 105

'bbb = 100 * 70 / 100
bbb = 54 * 70 / 100 'Round(54 * 70 / 100)
bbb = Round(54 * 70 / 100)

Response.write bbb & "<br>"


aaa = "a:b:c"

bbb = Split(aaa,":")

Response.write ubound(bbb) 
Response.end


gs = "2017-05-01"
ge = "2018-05-20"

gamecnt = CDate(ge) - CDate(gs)

vod = "ABCED"
Response.write  Mid(vod,2,1)


Response.write gamecnt
'Response.write time
'Replace(time, "오후" , "PM")
%>