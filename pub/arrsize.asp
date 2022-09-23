<!doctype html>

<html lang="ko">

<head>

<title>[앱연결]</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="format-detection" content="telephone=no" />
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">


var arr = [1.23,2.123,3.321,4.333,5.1];
var tper = arr.reduce(function (preValue, currentValue){return preValue + currentValue; }, 0);
//var tper = arr.reduce(s,e)=>s+e, 0);

tper = Math.floor(tper * 1000)/1000;

document.write (tper + "<br>");
//document.write (tper.toFixed(2) + "<br>");
//document.write (tper.toPrecision(2));
</script>

</head>
<body>
<%

Dim arr(3)
arr("key1") = "v1"


Response.end






'소수점 이하버림
Function Ceil(ByVal intParam, ByVal jumno)  
	Dim sousooarr
	If InStr(intParam, ".") > 0 then
	sousooarr = Split(intParam,".")
	Ceil = sousooarr(0) & "." & Left(sousooarr(1),jumno)
	Else
	Ceil = intParam & ".0"
	End if
End Function  


'sousoo = 1.75
sousoo = 1
Response.write Ceil(sousoo,1 ) & "<br>"

Dim rsObj
rdcnt = 0
ReDim rsObj(rdcnt)

rsObj(0) = "1234"

Response.write rsObj(0)
'Response.write rsObj(0)

%>
</body>
</html>






