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

	

	<%
judgeCnt = 5


				Select Case CDbl(judgeCnt)
				Case 5,7 '개인

					'배열갯수로 다시 잘세어서 넣어두고 소팅하자.
					For i = 0 To judgeCnt -1
						'arr(i) = jumsuarr(i+1)
					next
					'소팅 최저점, 최고점검색을 위해서.
					'sortjumsu1 = sortArray(arr)  'fn_util.asp

				Case 9 '단체 / 팀 (4:5)로 나누고 각각 2명씩제거 4명
					ReDim arr(4)

					For i = 0 To 3
						'arr(i) = jumsuarr(i+1)
					Next
					For i = 4 To 8
						'arr2(i) = jumsuarr(i+1)
					next					

					'소팅 최저점, 최고점검색을 위해서.
					'sortjumsu1 = sortArray(arr)  
					'sortjumsu2 = sortArray(arr2)

				Case 11'단체 / 팀 (3:3:3)로 나누고 각각 2명씩제거 6명

					ReDim arr(3)
					ReDim arr2(3)

					For i = 0 To 3
						'arr(i) = jumsuarr(i+1)
					Next
					For i = 4 To 6
						'arr2(i) = jumsuarr(i+1)
					Next
					For i = 7 To 11
						'arr2(i) = jumsuarr(i+1)
					next								

					'소팅 최저점, 최고점검색을 위해서.
					'sortjumsu1 = sortArray(arr)  
					'sortjumsu2 = sortArray(arr2)

				End Select				
	
	%>
	

	
	
    </script>

  </body>
</html>


