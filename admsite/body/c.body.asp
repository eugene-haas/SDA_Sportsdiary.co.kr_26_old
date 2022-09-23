<article>
<a name="contenttop"></a>

<!-- <h2>title</h2> -->


<!-- 모달 -->
<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>

<a id='LocationAnchor' name=''></a>

<div id="axcontents" style="padding-left:20px;text-algin:center;">



<%
	Set db = new clsDBHelper

'===============================================================================
	' 랜덤 PW를 얻는다. 
	'===============================================================================
	Function GetRandomPasswd(keyLen)
		Dim arySrc(6), aryLen(6), max, r1, r2, i, j, ul, len1, IsUpper, add_char
		arySrc(0) = "abcdefghijklmnopqrstuvwxyz"
		arySrc(1) = "0123456789"
		arySrc(2) = "~!@#$%^&*()_+"
		arySrc(3) = "0123456789~!@#$%^&*()_+"
		arySrc(4) = "0123456789~!@#$%^&*()_+abcdefghijklmnopqrstuvwxyz"
		arySrc(5) = "@#$%^&*()_+abcdefghijklmnopqrstuvwxyz"

		ul = UBound(arySrc)
		serialCode = ""
		For i = 0 To ul
			len1 = Len(arySrc(i))
			aryLen(i) = len1
		Next
		
		For j = 0 To keyLen
			r1 = GetRandomNum(ul) -1
			r2 = GetRandomNum(aryLen(r1))
			IsUpper = GetRandomNum(10) Mod 2
			add_char = Mid(arySrc(r1),r2,1)         

			if(IsUpper = 1 And (add_char >= "a" And add_char <= "z")) Then 
				add_char = UCase(add_char)
			End If 			
			serialCode = serialCode + add_char
		Next
		
		GetRandomPasswd = serialCode
	End Function

'===============================================================================
	' 랜덤 숫자를 얻는다. 
	'===============================================================================
	Function GetRandomNum(nRange)
		Randomize
		GetRandomNum = (Int(nRange * Rnd) + 1)
	End Function


%>
<p style="text-align:center;margin-left:0px;margin-top:300px;">
  <img src="/res/riding03.png" style="opacity: 0.1">

<div style="padding:10px;text-align:left;">
=========================================================</br>
  배드민턴</br>
  어드민폴더 : badminton.soportsdiary.co.kr/badminton/</br>
  홈페이지 폴더 : HP/koreabadminton.org</br>
  홈페이지 DEV : HP/dev.koreabadminton.org</br>
=========================================================</br>
</div>


<div style="background:#eeeeaa;padding:30px;">
		<img src="http://www.widline.co.kr/pc/front/imgs/logo.png">
		<div class="visual_txt">
		<p class="first"><h4>새로운 감동을 만들어 나가는 위드라인 입니다.</h4>고객의 감동이 없는 혁신은 아무것도 아닙니다.</p>
		<p>We are company making an impression</p>
		<p>Innovation is nothing without impressing the customer</p>
		</div>

</div>
<br><br>
랜덤패스워드 

<%
rpwd = GetRandomPasswd(20)
response.write  rpwd
%>


</p>
</div>




</article>
