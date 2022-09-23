<!doctype html>

<html lang="ko">

<head>

<title>[앱연결]</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="format-detection" content="telephone=no" />
</head>
<body>


<%
arr = array(100,30,10)

arrtotal = 0
For i = 0 To ubound(arr)
	arrtotal = arrtotal + arr(i) 
Next


function median(a, b, c)
    If (a > b) Then
        If (b > c)       then 
		median =  b
        elseif (a > c)  then 
		median = c
        else               
		median =  a
		End if
    Else
        if (a > c)   then   
		median =  a
        elseif (b > c)  then 
		median =  c
        else            
		median =  b
		End if
	End if
End Function


arrv = array(1,4,3,2,5)
function sortArray(arrShort)
	Dim i , temp, j 

    for i = UBound(arrShort) - 1 To 0 Step -1
        for j= 0 to i
            if arrShort(j)>arrShort(j+1) then
                temp=arrShort(j+1)
                arrShort(j+1)=arrShort(j)
                arrShort(j)=temp
            end if
        next
    next
    sortArray = arrShort

end function


arrnew = sortArray(arrv)

For i = 0 To ubound(arrnew)
Response.write arrnew(i)
Next 

Response.write Request.ServerVariables("HTTP_HOST")

Response.end

'while(true){
'    cin >> number; // 두 번째 이후의 입력.
'    if(number < smaller.top()){
'        // 기준보다 작은 경우 smaller에 넣는다.
'        smaller.push(number);
'    }
'    else{
'        // 기준보다 큰 경우 bigger에 넣는다.
'        bigger.push(number);
'    }
'
'    // smaller의 크기와 bigger의 크기가 같거나, smaller의 크기가 하나 더 크게 유지되도록 데이터를 옮긴다. 
'    if(smaller.size() < bigger.size()){
'        smaller.push(bigger.top());
'        bigger.pop();
'    }
'    else if(smaller.size() > bigger.size() + 1){
'        bigger.push(smaller.top());
'        smaller.pop();
'    }
'
'    // smaller와 bigger의 크기가 같다면 총 개수는 짝수이다.
'    if(smaller.size() == bigger.size()){
'        cout << ((float)smaller.top() + (float)bigger.top()) * 0.5f << endl;
'    }
'    else{
'        cout << smaller.top() << endl;
'    }
'}
'











Response.write median(10,43,30) & "<br>"

Response.write Round(arrtotal / (ubound(arr) + 1))
%>

</body>
</html>

