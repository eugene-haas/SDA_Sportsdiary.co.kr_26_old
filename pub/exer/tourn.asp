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
  <body>

    <h3>tournament tree default</h3>
    <div class="tournament"></div>

	
	

	
	
	
	
	
	
	
	
	
	
	<script>
//      var tournament = new Tournament();
//      tournament.setOption({
//    		el:document.querySelector('.tournament') // element must have id
//    	});
//      tournament.setStyle();
//      tournament.draw({
//        roundOf:8,
//      });
//
//      window.addEventListener("resize", function(evt){
//        // Announce the new orientation number
//        tournament.draw();
//      }, false);
    </script>



<%
Function vsMerge(arrRS)
Dim teamRS,m,ar, x, y

'파트너와 한줄로 만든다. (짝수이고 파트너는 무조건 있어야한다 아니면 그룹번호로 비교해서 만들것)
Redim teamRS(UBound(arrRS,1 ) * 2 + 1 ,  UBound(arrRS, 2) / 2 ) '새로 만들어질 DB (마지막 1명)
m = 0
If IsArray(arrRS)  Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

			If ar Mod 2 = 0 then
				For x = 0 To UBound(arrRS,1 ) 
					teamRS(x, m) = arrRS(x, ar)
				Next 
				For y = 0 To UBound(arrRS,1 ) 
					If ar + 1 < UBound(arrRS, 2) then
					teamRS(x + y, m) = arrRS(y, ar + 1)
					End if
				Next 
				m = m + 1 '줄바꿈
			End If
	Next
End If

vsMerge = teamRS
End Function 




Function setTournJson_arr(rs, rndcnt)
rndcnt = 128
	Dim rsObj,subObj, fieldarr, i, arr, mainObj ,c,ar
	Dim t_round, rdcnt,pre_tround,arrRS


	Set mainObj = jsObject()
	mainObj( "TotalRound" ) = 256

'	ReDim rsObj(rs.RecordCount - 1)
'	ReDim fieldarr( (Rs.Fields.Count * 2) - 1 )
'	For i = 0 To Rs.Fields.Count - 1
'		fieldarr(i) = Rs.Fields(i).name
'	Next

	'fieldarr = array("midx","rows","cols","Lplayer" ,"widx","wresult"      ,"Rmidx","Rrows","Rcols","Rplayer" ,"Rwidx","Rwresult")
	fieldarr = array("Lmidx","Lrows","Lcols","Lplayer", "Lwidx"     ,"Rmidx","Rrows","Rcols","Rplayer" , "Rwidx" )

	If Not rs.EOF Then
		arrRS = rs.GetRows()
		arr = vsMerge(arrRS)

		'Call getrowsdrow(arr)
		'Response.end


		If IsArray(arr) Then
			For ar = LBound(arr, 2) To UBound(arr, 2)
				t_round = arr(1, ar)  '라운드번호

				If ar = 0 Then
					rdcnt = 0
					ReDim rsObj(rdcnt)
				End If

				Set subObj = jsObject()
				For c = LBound(arr, 1) To UBound(arr, 1)
					subObj(fieldarr(c)) = arr(c, ar)
				Next

				ReDim Preserve rsObj(rdcnt)
				Set rsObj(rdcnt) = subObj				
				rdcnt = rdcnt + 1


'If t_round > 7 Then
'Response.write FIX(rndcnt / 2^(t_round-1)) &"******"& CDbl(rdcnt)					&"<br>"
'End if

				If ar > 0 And FIX(rndcnt / 2^(t_round-1)) = CDbl(rdcnt)  Then '256/1 = 넣은갯수
					mainObj( "round_"&t_round ) = rsObj
					rdcnt = 0
					ReDim rsObj(rdcnt) '배열초기화
				End if			

			Next
		End if

		setTournJson_arr = toJSON(mainObj)
	Else
		setTournJson_arr = rsObj
	End if
End Function


'결과에 중복값 제거



		Set db = new clsDBHelper
		ConStr = KATA_ConStr
		gameidx = 148
		key3 = 20101001

		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
'		strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & key3  & " and gubun in ( 2,3) and a.DelYN='N'" 'gubun  0예선 1예선종료 2 본선대기 3 본선입력완료 4 본선종료 ...
		strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & key3  & " and a.round > 0 and a.DelYN='N'" 'gubun  0예선 1예선종료 2 본선대기 3 본선입력완료 4 본선종료 ...
		strsort = " order by a.Round asc,a.SortNo asc"
		
		'결과쿼리
		resultSQL = " (select top 1 winidx from sd_TennisResult where gameMemberIDX1 = a.gameMemberIDX  )  as widx " 


'		strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aNTN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW  "
'		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo,a.playerIDX "
'		strAfield = " DISTINCT c.gamememberidx1, a.Round as rows, a.SortNo as cols, case when a.userName = '부전' then 'BYE' else ( a.userName + '<br>' +  b.userName) end   ,c.winidx,c.winresult "  
		strAfield = " DISTINCT a.gamememberidx as midx, a.Round as rows, a.SortNo as cols, case when a.userName = '부전' then 'BYE' else ( a.userName + '<br>' +  b.userName) end   , "&resultSQL&" "  
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo,a.playerIDX "
		strfield = strAfield '&  ", " & strBfield
		SQL = "select "& strfield &" from  sd_TennisMember as a "
		SQL = SQL & " left JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX  "
'		SQL = SQL & " left JOIN sd_TennisResult as c ON  a.gameMemberIDX = c.gameMemberIDX1 "
		SQL = SQL & " where " & strwhere & " and sortno > 0  " 
'		SQL = SQL & " and a.Round = 1 "
		SQL = SQL & strsort


'Response.write sql 
'Response.end

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount

		'Response.write sql
		'Call rsDrow(rs)
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'Response.end
		'rs.movefirst

		jsonstr = setTournJson_arr(rs ,256)
		'Response.write Replace(Replace(jsonstr,"[","<br>["),"round","<br>round")
		jsondata =  jsonstr
%>





    <h3>tournament tree set data</h3>
    <div id="tournament2"></div>
    <script>
      var tournament2 = new Tournament();


	  
	  
	  tournament2.setOption({
        blockBoardWidth: 220, // integer board 너비
        blockBranchWidth: 40, // integer 트리 너비
        blockHeight : 180, // integer 블럭 높이(board 간 간격 조절)
        branchWidth : 2, // integer 트리 두께
        branchColor : '#a9afbf', // string 트리 컬러
        roundOf_textSize : 60, // integer 배경 라운드 텍스트 크기
        scale : 'auto', // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
        board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    		el:document.getElementById('tournament2') // element must have id
    	});
      tournament2.setStyle('#tournament2');
      tournament2.boardInner = function(data){
		var Lwincolor = "";
		var Rwincolor = "";	

		if (data.Lmidx == data.Lwidx){
			Lwincolor = "style='background:orange;'";
		}
		if ( data.Rmidx == data.Rwidx    ||   data.Rmidx == data.Lwidx  ){
			Rwincolor = "style='background:green;'";
		}

        var html = [
          '<p class="ttMatch ttMatch_first">',
            '<span class="ttMatch__playerWrap" '+Lwincolor+'>',
              '<span class="ttMatch__playerInner"  title='+data.Lmidx + '--' + data.Lwidx+'>',
                '<span class="ttMatch__player">'+data.Lplayer+'</span>',
                '<span class="ttMatch__belong">'+data.Lteam+'</span>',
              '</span>',
            '</span>',
            '<span class="ttMatch__score">'+data.Ljumsu+'</span>',
          '</p>',
          '<p class="ttMatch ttMatch_second">',
            '<span class="ttMatch__playerWrap" '+Rwincolor+'>',
              '<span class="ttMatch__playerInner"   title='+data.Rmidx + '--' + data.Rwidx+'>',
                '<span class="ttMatch__player">'+data.Rplayer+'</span>',
                '<span class="ttMatch__belong">'+data.Rteam+'</span>',
              '</span>',
            '</span>',
            '<span class="ttMatch__score">'+data.Rjumsu+'</span>',
          '</p>'
        ].join('');

    		return html;
    	}

      tournament2.draw({
        roundOf:256,
		data : <%=jsondata%>

//		data: {
//          "TotalRound":"8",
//          "GameLevelDtlIDX":"C771DB1A5DD270FF63EFD08617B932E2",
//
//
//          "round_1":[
//            {"GameOrder":"1","GameIdx":5825,"Lplayer":"\uC774\uC7AC\uBD09,\uC774\uB0A8\uC218","Lteam":"\uC9C4\uC911,\uC6B4\uD558","Ljumsu":"","Rjumsu":"","Lresult":"true","Rresult":"false","Rplayer":"BYE","Rteam":""},
//            {"GameOrder":"2","GameIdx":5825,"Lplayer":"\uD64D\uB3D9\uC9C4,\uC2EC\uD76C\uB77D","Lteam":"\uC218\uC6D4,\uC218\uC591","Ljumsu":"1","Rjumsu":"0","Lresult":"true","Rresult":"false","Rplayer":"\uBB38\uC900\uD638,\uC5C4\uD638\uC6A9","Rteam":"\uC0AC\uCC9C,\uC2E0\uC5B4"},
//            {"GameOrder":"3","GameIdx":5825,"Lplayer":"\uAC15\uC815\uD6C8,\uAE40\uC218\uD658","Lteam":"\uD64D\uC758,\uD64D\uC758","Ljumsu":"0","Rjumsu":"1","Lresult":"false","Rresult":"true","Rplayer":"\uBC15\uAC15\uD0DC,\uAE40\uB3D9\uD658","Rteam":"\uB9AC\uB354,\uBD81\uBD80"},
//            {"GameOrder":"4","GameIdx":5825,"Lplayer":"\uAE40\uC131\uB839,\uAE40\uC601\uC900","Lteam":"\uB514\uC5D0\uC2A4\uC5E0\uC774,\uC5F0\uCD08","Ljumsu":"0","Rjumsu":"1","Lresult":"false","Rresult":"true","Rplayer":"\uC1A1\uCC3D\uD604,\uB958\uC9C0\uD760","Rteam":"\uC9C4\uC911,\uC9C4\uC911"}
//          ],
//
//          "round_2":[
//            {"GameOrder":"5","GameIdx":5825,"Lplayer":"\uC774\uC7AC\uBD09,\uC774\uB0A8\uC218","Lteam":"\uC9C4\uC911,\uC6B4\uD558","Ljumsu":"1","Rjumsu":"0","Lresult":"true","Rresult":"false","Rplayer":"\uD64D\uB3D9\uC9C4,\uC2EC\uD76C\uB77D","Rteam":"\uC218\uC6D4,\uC218\uC591"},
//            {"GameOrder":"6","GameIdx":5825,"Lplayer":"\uBC15\uAC15\uD0DC,\uAE40\uB3D9\uD658","Lteam":"\uB9AC\uB354,\uBD81\uBD80","Ljumsu":"0","Rjumsu":"1","Lresult":"false","Rresult":"true","Rplayer":"\uC1A1\uCC3D\uD604,\uB958\uC9C0\uD760","Rteam":"\uC9C4\uC911,\uC9C4\uC911"}
//          ],
//
//          "round_3":[
//            {"GameOrder":"7","GameIdx":5825,"Lplayer":"\uC774\uC7AC\uBD09,\uC774\uB0A8\uC218","Lteam":"\uC9C4\uC911,\uC6B4\uD558","Ljumsu":"1","Rjumsu":"0","Lresult":"true","Rresult":"false","Rplayer":"\uC1A1\uCC3D\uD604,\uB958\uC9C0\uD760","Rteam":"\uC9C4\uC911,\uC9C4\uC911"}
//          ]
//        }
      });

//      window.addEventListener("resize", function(evt){
//        // Announce the new orientation number
//        tournament2.draw();
//      }, false);

    </script>

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