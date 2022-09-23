<!doctype html>
<html lang="en">
 <head>
  <meta charset="UTF-8">
  <meta name="Generator" content="EditPlus®">
  <meta name="Author" content="">
  <meta name="Keywords" content="">
  <meta name="Description" content="">
  <title>Document</title>
 </head>
 <body>



<%

' 금일 날짜 표현방법
'Response.write Right("0000"&Year(date),4) &"-"& Right("00"&Month(date),2) &"-"&Right("00"&Day(date),2)

' 1년전 날짜 구하기
Tdate = DateAdd("m", -12,date)
Response.write Tdate &"<br>"
response.end

' ' 7일후 날짜 구하기
' Tdate = DateAdd("d", 7 DateValue(now))
' ' or
' Tdate = dateadd("d", 7, Now())
' Response.write Tdate &"<br>"
'
'
' '순수히 날짜만 구할려면 MID 함수 사용
' Response.write MID(Tdate,1,10)
'
'
' '"-" 문자열을 제거할려면 replace 함수를 사용하면 됩니다.
' Response.write replace("문자열", "-", "")
' response.end
%>





<%'	ul li {background:#eeeeee;}	%>
<style type="text/css">

	ul > li {background:#eeeeee;}
	p > div{color:red;}
</style>



<span id="teamlist">
				<ul class="list_box">
							  <li class="list">
								<ol><li>ddddddddddddd</li></ol>
								<a href="javascript:mx.getAttList('78','SW00100', this)" class="sl_list">서울서교초등학교  <span id="ul_total">A</span></a>
								<p id="SW00100"><div>권한준 | 자유형400M</div></p>
							  </li>

							  <li class="list">
								<a href="javascript:mx.getAttList('78','SW00124', this)" class="sl_list">서울아주초등학교  <span id="ul_total">A</span></a>
								<p id="SW00124" style="display:none;"></p>
							  </li>

							  <li class="list">
								<a href="javascript:mx.getAttList('78','SW00136', this)" class="sl_list">서울잠전초등학교  <span id="ul_total">A</span></a>
								<p id="SW00136" style="display:none;"></p>
							  </li>

							  <li class="list">
								<a href="javascript:mx.getAttList('78','SW00156', this)" class="sl_list">대청중학교  <span id="ul_total">A</span></a>
								<p id="SW00156" style="display:none;"></p>
							  </li>
				</ul>
				</span>

 </body>
</html>
