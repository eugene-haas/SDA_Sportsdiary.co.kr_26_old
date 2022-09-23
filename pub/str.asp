<script type="text/javascript">
<!--
var canvas = document.createElement('canvas');
var img = document.createElement('img');
img.onload = function(e) {
    canvas.width = img.width;
    canvas.height = img.height;
    var context = canvas.getContext('2d');
    context.drawImage( img, 0, 0, img.width, img.height);
    window.navigator.msSaveBlob(canvas.msToBlob(),'image.jpg');
}
img.src = 'img.jpg;	
//-->
</script>


<%



sUserAgent = Request.ServerVariables("HTTP_USER_AGENT")
if instr(sUserAgent, "IPAD") or instr(sUserAgent, "IPHONE") Then

End if

Response.end

Response.write dateAdd("yyyy", -2, Date())




Response.end

startrnkdate = "2018-03-01"


			sy = year(startrnkdate)
			sm = month(startrnkdate)

Response.write sy & sm


Response.end

lms_birthday ="19990601"

myage = Cint(year(date)) - CInt(Left(lms_birthday,4))
'if CDbl(mid(Replace(date,"-",""),5))  >  CDbl(Mid(lms_birthday, 5)) Then
'	myage = myage - 1 
'End if
myageST = "Y"
If CDbl(myage) < 19 Then
	myageST = "N"
End if

Response.write myage

Response.write myageST

Response.End



teamadult = "aaa,N^bbb,Y^"


						ta = Split(teamAdult,"^")
Response.write ubound(ta)
						For m = 0 To ubound(ta) -1
							
							Response.write ta(m) & "<br>"

'taa = Split(ta(m),",")



							'If CDbl(memberIDX) = CDbl(Split(ta(m),",")(0)) Then
								Response.write Split(ta(m),",")(1)
								
							'End If
						next


Response.End







	'## 접속 사용자 아이피
	USER_IP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	If Len(USER_IP) = 0 Then USER_IP = Request.ServerVariables("REMOTE_ADDR")

	If USER_IP = "115.68.112.26" Then
		Response.Write "서버IP" & request("asd")
	Else
		Response.Write "서버IP아님" & USER_IP & request("asd")
	End If
%>

<span id="aa"></span>
<script type="text/javascript">
<!--
	//시간지연후 실행테스트
function empty(){
 document.getElementById('aa').innerHTML =a.a + b;
}


var a;
var b;
function delayf(){
	var obj = {"a":1};
	var str = "cc";
	a = obj;
	a = {'a':"dfdfdfdfdf",'bb':2312};
	b = str;

	 document.getElementById('aa').innerHTML ="start";
  	  setTimeout("empty()",3000);
		
}

delayf()
//-->
</script>
