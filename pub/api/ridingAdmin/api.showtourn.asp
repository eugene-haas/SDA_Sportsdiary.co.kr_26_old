<%
'#############################################
'대진표 리그/토너먼트 화면 준비
'#############################################


'request
If hasown(oJSONoutput, "TIDX") = "ok" then
	tidx= oJSONoutput.TIDX 
End If
If hasown(oJSONoutput, "GBIDX") = "ok" then
	gbidx= oJSONoutput.GBIDX
End If
If hasown(oJSONoutput, "GMYEAR") = "ok" then
	gmyear= oJSONoutput.GMYEAR
End If


Function vsMerge(arrRS)
	Dim teamRS,m,ar, x, y

	'파트너와 한줄로 만든다. (짝수이고 파트너는 무조건 있어야한다 아니면 그룹번호로 비교해서 만들것)
	Redim teamRS(UBound(arrRS,1 ) * 2 + 1 ,  Fix(UBound(arrRS, 2) / 2)  ) '새로 만들어질 DB (마지막 1명)
	m = 0

	'Call getrowsdrow(arrRS)

	If IsArray(arrRS)  Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

				If ar Mod 2 = 0 Then
					'Response.write ar & "<br>"			
					For x = 0 To UBound(arrRS,1 ) 
						teamRS(x, m) = arrRS(x, ar)
					Next 
					For y = 0 To UBound(arrRS,1 ) 
						'If ar + 1 < UBound(arrRS, 2) then '1개 남았을때 인데 최종 올라갔을때 까지 표시할때 (테니스인경우) 여긴 2강까지만 그리면 되므로...안넣는다.
						teamRS(x + y, m) = arrRS(y, ar + 1)
						'End if
					Next 
					m = m + 1 '줄바꿈
				End If
		Next
	End If

	vsMerge = teamRS
End Function 

Function setTournJson_arr(rs, rndcnt ,fieldarr)
	'rndcnt = 128
	Dim rsObj,subObj, i, arr, mainObj ,c,ar 'fieldarr
	Dim t_round, rdcnt,pre_tround,arrRS


	Set mainObj = jsObject()
	mainObj( "TotalRound" ) = rndcnt '256

	'	ReDim rsObj(rs.RecordCount - 1)
	'	ReDim fieldarr( (Rs.Fields.Count * 2) - 1 )
	'	For i = 0 To Rs.Fields.Count - 1
	'		fieldarr(i) = Rs.Fields(i).name
	'	Next

	If Not rs.EOF Then
		arrRS = rs.GetRows()
		arr = vsMerge(arrRS)

		'Call getrowsdrow(arr)
		'Response.end


		If IsArray(arr) Then
			For ar = LBound(arr, 2) To UBound(arr, 2)
				t_round = arr(0, ar)  '라운드번호 (필드맨앞에 두자)

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



				If ar > 0 And FIX(rndcnt / 2^(t_round-1))/2 = CDbl(rdcnt)  Then '256/1 = 넣은갯수
					mainObj( "round_"&t_round ) = rsObj
					rdcnt = 0
					ReDim rsObj(rdcnt) '배열초기화
				End if			

			Next
		End if

		'빈라운드 생성
'		mainObj( "round_2" ) = rsObj
'		mainObj( "round_3" ) = rsObj
'		mainObj( "round_4" ) = rsObj
'		mainObj( "round_5" ) = rsObj
		'빈라운드 생성


		setTournJson_arr = toJSON(mainObj)
	Else
		setTournJson_arr = rsObj
	End if
End Function





Set db = new clsDBHelper

'체크
SQL = "Select top 1 round from sd_tennisMember where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '"&gbidx&"' and round > 1 and gubun < 100 "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If rs.eof then
	''타입 석어서 보내기
	Call oJSONoutput.Set("result", "91" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"
	Response.End
End if


'1라운드 갯수 카운트 하고
SQL = "Select max(tryoutsortno) from sd_tennisMember where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '"&gbidx&"' and round = 1 and gubun < 100 "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

tmround = rs(0)

sortstr = " a.round, a.tryoutsortno "
'sortstr = " a.tryoutsortno,a.tryoutgroupno, a.username, b.username asc "
tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
fldnm = "a.round, a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx as hpidx ,b.username as hnm ,winloseWL as WL "
SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' and round >= 1 and gubun < 100 order by " & sortstr
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'arrRS = rs.GetRows()
'Call getrowsdrow(arrRS)
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Response.end
'fieldarr = array("Lmidx","Lrows","Lcols","Lplayer", "Lwidx"     ,"Rmidx","Rrows","Rcols","Rplayer" , "Rwidx" )


'########################################
'필드값생성
'########################################
ReDim fieldarr(Rs.Fields.Count * 2)  '필드값저장(홀짝으로 필드를 더할꺼임
n = 0 
For i = 0 To Rs.Fields.Count - 1
	fieldarr(n) = "L" & Rs.Fields(i).name 
	n = n + 1
Next
For i = 0 To Rs.Fields.Count - 1
	fieldarr(n) = "R" & Rs.Fields(i).name 
	n = n + 1
Next
'########################################


If Not rs.eof Then
rscnt =  rs.RecordCount
jsonstr = setTournJson_arr(rs ,tmround , fieldarr) '강수를 알아야하네요
jsondata =  jsonstr
End if


''타입 석어서 보내기
Response.Write jsondata
Response.write "`##`"

%>
<div class="modal-dialog modal-xl">
  <div class="modal-content">


    <div class='modal-header'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 id='myModalLabel'>대진표</h4>
    </div>
  <!-- 헤더 코트e -->

			<!-- 여기버튼 -->

<%
			If  CDbl(tmround) =8 Then
				tnround = 8 '4, 3, 2, 1
				byecnt = 0
				emptyroundcnt  = 3 
			elseIf  CDbl(tmround) >8 And CDbl(rscnt) <= 16 Then
				tnround = 16
				emptyroundcnt  = 4
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >16 And CDbl(rscnt) <= 32 Then
				tnround = 32
				emptyroundcnt  = 5
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >32 And CDbl(rscnt) <= 64 Then
				tnround = 64
				emptyroundcnt  = 6
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >64 And CDbl(rscnt) <= 128 Then
				tnround = 128
				emptyroundcnt  = 7
				byecnt = tnround - CDbl(rscnt)
			ElseIf CDbl(rscnt) >128 And CDbl(rscnt) <= 258 Then
				tnround = 256
				emptyroundcnt  = 8
				byecnt = tnround - CDbl(rscnt)
			End If
			
			Select Case CDbl(tmround)
			Case 8
			%>
			
			<%
			Case 16
			%>
			<div style="background:black;width:100%;">
			<a href="javascript:mx.drowLimitTourn(0,0)">전체</a>
			<a href="javascript:mx.drowLimitTourn(16,8)">16강</a>
			<a href="javascript:mx.drowLimitTourn(8,4)">8강</a>
			<a href="javascript:mx.drowLimitTourn(4,2)">4강</a>
			</div>
			<%
			Case 32
			%>
			
			<%
			Case 64
			%>
			
			<%
			Case 128
			%>
			
			<%
			Case 256
			%>
			
			<%
			End Select 

%>
			<div class="modal-body" style="overflow-y:scroll;  height:700px;">

				<div  id="tournament2" style="width:50%;"></div>

			</div>
</div>


    <div id="rtbtnarea" class="modal-footer">
      <button type="button" data-dismiss='modal' aria-hidden='true' class="btn btn-default">닫기</button>
  	  <!-- <a href="javascript:mx.editOK(<%=r_tidx%>,'<%=title%>')" class='btn btn-primary'>대회운영 요강 등록</a> -->
    </div>



  </div>
</div>








<%If aaa = "ddd" then%>
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


      tournament2.draw({
        roundOf:packet.TotalRound,
		data: <%=jsondata%>
      });


	  tournament2.boardInner = function(data){
		var Lwincolor = "";
		var Rwincolor = "";	



        var html = [
          '<p class="ttMatch ttMatch_first">',
            '<span class="ttMatch__playerWrap" '+Lwincolor+'>',
              '<span class="ttMatch__playerInner"  title=ㅇㅇㅇ>',
                '<span class="ttMatch__player">'+data.Lusername+'</span>',
                '<span class="ttMatch__belong">'+data.LteamAna+'</span>',
              '</span>',
            '</span>',
            '<span class="ttMatch__score">'+data.Ltryoutsortno+'</span>',
          '</p>',
          '<p class="ttMatch ttMatch_second">',
            '<span class="ttMatch__playerWrap" '+Rwincolor+'>',
              '<span class="ttMatch__playerInner"   title=ㅌㅌㅌ>',
                '<span class="ttMatch__player">'+data.Lusername+'</span>',
                '<span class="ttMatch__belong">'+data.Rteam+'</span>',
              '</span>',
            '</span>',
            '<span class="ttMatch__score">'+data.RteamAna+'</span>',
          '</p>'
        ].join('');

    		return html;
    	}
</script>
<%End if%>

<%
db.Dispose
Set db = Nothing
%>
