<!-- #include virtual = "/pub/header.ridingadmin.asp" -->
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1">
    <title>Tournament Tree</title>
    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>
  </head>

<script type="text/javascript">
//    var newName, n=0;
//
//    //팝업 창 제목 만들기 함수(다중 팝업을 위한..)    
//    function newWindow(value)
//    {
//       n = n + 1;
//       newName = value + n;     
//    }

 

//    function MyOpenWindow()
//    {
//		var newName = "MyWindow";
//	   for (var i = 1;i < 3 ; i++)
//       {
//		//newWindow("MyWindow");
//		newName = newName + i;
//        window.open("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMT52wlDPfezwcNumdO0pOpdnpIjUhNc1N0G5r3cR9xAwK_F13", newName);
//
//	   }
//
//    }


	function ggg(){
		   for (var i = 1;i < 3 ; i++)
		   {
				document.a.action="http://www.naver.com";
				document.a.target='_blank'; 
				document.a.submit();
   
		   
		   }
	}



$("#paypal_form").submit(function() {
    var newWin = window.open("/pub/blank.asp", "aa", ""); // SPecify your window attributes here, but no URL
    // do an XMLHTPPRequest and document.write the result to the new window:
    var winDoc = doAJAXAndReturnOtherPagesSource();
    newWin.document.write(winDoc);
});
</script>  


  <form target="post" name="a" action="" target="_blank"> </form>
  
  <body>

    <h3>test</h3>
	<a href="javascript:ggg()">열기</a>

	
<div>	

</div>



  </body>
</html>




























<%Response.end%>











<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>Using iframe - Launch App with page loading</title>
</head>
<body>



<script type="text/javascript">
<!--

sumvalue = 100;
off1 = 0;
maxpt = 200;

		sumvalue = sumvalue - Number(off1) - (maxpt * (0/100) );	

		console.log(sumvalue)
//-->
</script>


<%
Response.end
a = "a,b,c,d"
arrTmp = Split(a,",")
Response.write Ubound(arrTmp)


Response.end

	Set db = new clsDBHelper

	tblnm = " SD_tennisMember as a Inner join sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gameMemberIDX,a.playeridx,b.playeridx,a.username,b.username,a.tryoutresult ,a.gubun, a.tryoutsortno     ,ctbl.c " 
	SQL = "Select "&fldnm&" from "&tblnm
	
	SQL = SQL & " left join (select playeridx, count(*)  as c  from sd_tennisMember where gametitleidx = 17 and delyn= 'N' and gamekey3 = '183' and gubun < 100 and round = 1 group by playeridx ) as ctbl On a.PlayerIDX = ctbl.PlayerIDX "

	SQL = SQL & " where a.gametitleidx = 17 and a.delYN = 'N' and a.gamekey3 = '183' and a.gubun < 100 and a.round=1   order by ctbl.c desc, a.username, b.username asc "	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	Call rsdrow(rs)

	If Not rs.EOF Then
		arrNo = rs.GetRows()
	End If
	rs.close	



function sortArray(arrShort)

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

end Function





%>

</body>
</html>