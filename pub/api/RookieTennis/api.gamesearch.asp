<%
  'request
  gameidx = oJSONoutput.IDX '게임인덱스
  strs1 = oJSONoutput.S1 '경기구분
  strs2 = oJSONoutput.S2 '경기유형
  strs3 = oJSONoutput.S3 '종목선택
  tabletype = oJSONoutput.TT '예선 본선 구분 (대진표 구분)
  subidx = oJSONoutput.SIDX '조별 인덱스

  If strs2 = "" Then
	strs2 = Left(strs3,3)
  End If

  If strs2 = "200" Then
	joinstr = " left "
    singlegame =  true
  Else
	joinstr = " inner "
	singlegame = false
  End If  


  Set db = new clsDBHelper

	SQL = "select stateNo from sd_TennisTitle where GameTitleIDX = " & gameidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'게임상태 0표시전,  3 예선발표 , 4 예선마감, 5 본선발표 , 6 본선마감 , 7 결과발표
	If Not eof then
		gamestate = rs("stateNo")
		Select Case gamestate
		Case "1" : statestr = "참가신청 중 입니다."
		Case "2" : statestr = "예선 추첨 중 입니다."
		End Select
	Else
		Response.end	
	End if


	Select Case tabletype
	Case "0" ,"10","20"
		
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "

		If tabletype = "10" Then
			strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3 & " and a.tryoutgroupno > 0 and a.gubun = 1 and a.DelYN='N'   " 'a.tryoutgroupno 부전승 허수 맴버 gubun 1예선 2 예선 종료
			strsort = " order by a.tryoutgroupno asc, a.t_rank asc" '결과순
		else
			strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3 & " and a.tryoutgroupno > 0 and a.gubun =1 and a.DelYN='N' " 'a.tryoutgroupno 부전승 허수 맴버
			strsort = " order by a.tryoutgroupno asc, a.tryoutsortno asc" '게임순
		End if
		strAfield = " a. gamememberIDX, a.userName as aname , a.tryoutgroupno, a.tryoutsortno, a.teamAna as aATN, a.teamBNa as aBTN, a.tryoutstateno, a.t_rank,a.key3name ,isnull(a.Courtno,0) Courtno "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamANa as bATN , b.teamBNa as bBTN, b.positionNo "
		strfield = strAfield &  ", " & strBfield 
        
        ''추가 필드
        strfield = strfield & " , a.t_win,a.t_tie,a.t_lose  ,isnull(a.place,'') place "

		SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount
		ReDim JSONarr(rscnt-1)
		
		datalen_round = 0

		i = 0
		Do Until rs.eof
			key3name = rs("key3name") '참가부명

		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			rsarr("GNO") = rs("tryoutgroupno")
			rsarr("SNO") = rs("tryoutsortno")
			rsarr("ATANM") = rs("aATN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 
			rsarr("STNO") = rs("tryoutstateno") '예선 진행 상태  0
			rsarr("RT1") = rs("t_rank") '예선 결과 순위 1 또는 2라면 통과
			rsarr("RTW") = rs("t_win") ' 승
			rsarr("RTT") = rs("t_tie") ' 무
			rsarr("RTL") = rs("t_lose") ' 패
            
			'rsarr("stateno") = rs("stateno") ' stateno
			'rsarr("gubun") = rs("gubun") ' gubun
			rsarr("courtno") = rs("courtno") ' courtno
			rsarr("place") = rs("place") ' courtno

            

			maxgno = rs("tryoutgroupno")
			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop
		datalen = Ubound(JSONarr) - 1


	Case "1", "11", "21" '본선 토너먼트#############################

	  Round_s = oJSONoutput.Round_s '조별 인덱스
		 
	  if Round_s ="" then 
		Round_s_n = 0
	  else
		Round_s_n = Cdbl(Round_s)+1
	  end if 

		checkgubun = 3

'중복부전제거
strwhere = " GameTitleIDX = " & gameidx & " and  gamekey3 = " & strs3  & " and gubun = "&checkgubun&" and DelYN='N'"
SQL = "select gamememberIDX,round,sortno from sd_TennisMember where " & strwhere & " and username = '부전' and round = 1  order by round, sortno "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

i = 1
Do Until rs.eof
  b_sortno = rs("sortno")
  
  If b_sortno = presortno Then
		If i = 1 Then
			delmidx = rs("gamememberIDX")
		Else
			delmidx = delmidx & "," & rs("gamememberIDX")
		End if
		i = i + 1
  End if
  presortno = b_sortno


rs.movenext
Loop
If delmidx <> "" then
SQL = "delete from sd_TennisMember where gameMemberIDX in ("&delmidx&")"
Call db.execSQLRs(SQL , null, ConStr)

End if  


'중복 제거 빈값 - 부전

if gameidx <> "" and strs3 <>"" then

'SQl=" delete sd_TennisMember  " & _ 
'	"		from sd_TennisMember a  " & _ 
'	"		inner join ( select Round ,SortNo,COUNT(*) cc from sd_TennisMember where GameTitleIDX='"&gameidx&"' and gamekey3='"&strs3&"'  and Round =1 group by Round,SortNo having COUNT(*)>=2 ) b " & _ 
'	"			on a.Round = b.Round and a.SortNo = b.SortNo " & _ 
'	"		where GameTitleIDX='"&gameidx&"'  " & _ 
'	"		and gamekey3='"&strs3&"'  " & _ 
'	"		and a.Round =1 " & _ 
'	"		and (a.PlayerIDX <=0  or userName ='부전'or userName ='--') "
'Call db.execSQLRs(SQL , null, ConStr)

end if  
		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		strwhere = " a.GameTitleIDX = " & gameidx & " and  a.gamekey3 = " & strs3  & " and gubun in ( 2,3) and a.DelYN='N'" 'gubun  0예선 1예선종료 2 본선대기 3 본선입력완료 4 본선종료 ...
		strsort = " order by a.Round asc,a.SortNo asc"
		
		strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aNTN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW  "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo,a.playerIDX "
		strfield = strAfield &  ", " & strBfield

		SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & " and sortno > 0  " 
		SQL = SQL & " and a.Round = 1 "
		SQL = SQL & strsort

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount

SQL1 = SQL
		'Response.write sql
		'Call rsDrow(rs)
		'rs.movefirst
		ReDim JSONarr(rscnt-1)

		i = 0
		Do Until rs.eof
		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			'rsarr("GNO") = rs("groupno")

			rsarr("CO") = rs("COL") '라운드

			If rs("ROW") = "" Or isNull(rs("ROW")) = True Or rs("ROW") = "0" Then
				rsarr("RO") = i +1
			Else
				rsarr("RO") = rs("ROW")
			End if


			rsarr("ATANM") = rs("aNTN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 
			rsarr("PIDXA") = rs("playerIDX")

			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop

		datalen = Ubound(JSONarr)

		'2라운드 이후에 정보
		strsort = " order by Round asc,SortNo asc"
		strfield = " gamememberIDX,Round,SortNo,PlayerIDX,userName  "'userName
		strwhere = " GameTitleIDX = " & gameidx & " and  gamekey3 = " & strs3  & " and gubun in (2,3) and Round > 1 and DelYN='N'" 'gubun  0예선 1예선종료 2 본선대기 3 본선대진표완료 4 본선종료 ...
		SQL = "select "& strfield &" from  " & strtable & "where " & strwhere & " and sortno > 0  " 
		
		if Round_s <> "" then 
			SQL = SQL & "  and Round between " & Round_s & " and " & Round_s_n  
			SQL = SQL & strsort
		else
			SQL = SQL & "  and Round > 1  " 
			SQL = SQL & strsort
		end if 

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

SQL2 = SQL

		If Not rs.EOF Then 
			arrRS2 = rs.GetRows()
		End if

		'스코어 입력 정보 가져오기######################################

		'각결과 및 결과입력 상태값 
			strtable = " sd_TennisMember "  '
			strresulttable = " sd_TennisResult "
			strwhere = " a.GameTitleIDX = " & gameidx & " and a.gamekey3 = " & strs3  & " and a.gubun in ( 2,3) and a.DelYN='N' and b.DelYN='N' " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료

			strsort = " order by  a.Round asc, a.SortNo asc , b.stateno desc"
			strAfield = " a.Round as row, a.SortNo as col, a. gamememberIDX as MIDX1 " '열 인덱스(기준)
			strBfield = " b.gameMemberIDX2 as MIDX2, b.resultIDX as IDX, b.stateno as GSTATE,winResult  " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
			strfield = strAfield &  ", " & strBfield &" ,c.MediaLinkIDX,c.MLink,c.Subject,c.Contents,c.ILink,c.STime,c.ETime ,c.ViewCnt "

			SQL = "select "& strfield & _
                  "  from  " & strtable & " as a " & _ 
                  "   INNER JOIN " & strresulttable & " as b  " & _ 
                  "     ON a.gameMemberIDX = b.gameMemberIDX1 " & _    
                  "   left join tblMediaLink c " & _
                  "     on b.resultIDX = c.ResultIDX and c.DelYN='N' and c.ViewYN ='Y' " & _
                  "   where " & strwhere  
			
			if Round_s <> "" then 
				SQL = SQL & "  and a.Round between " & Round_s & " and " & Round_s_n  
				SQL = SQL & strsort
			else
				SQL = SQL & "  and Round >= 1  " 
				SQL = SQL & strsort
			end if 

SQL3 = SQL
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



			If Not rs.EOF Then 
				arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
			End if

		'Response.write SQL
		'스코어 입력 정보 가져오기######################################


	Case "2", "12" ,"22" '예선 스코어 입력창
		If strs2 = "200" Then
			joinstr = " left "
			singlegame =  true
		Else
			joinstr = " inner "
			singlegame = false
		End if

		strtable = " sd_TennisMember "
		strtablesub =" sd_TennisMember_partner "
		'strwhere = " GameTitleIDX = " & gameidx & " and a.gamekey1 = '" & strs1 & "' and a.gamekey2 = " & strs2 & " and  a.gamekey3 = " & strs3  & " and tryoutgroupno = " & subidx
		strwhere = " GameTitleIDX = " & gameidx & " and a.gamekey3 = " & strs3  & " and tryoutgroupno = " & subidx & " and gubun = 1 "

		strsort = " order by a.tryoutsortno asc"
		strAfield = " a. gamememberIDX, a.userName as aname , a.tryoutgroupno, a.tryoutsortno, a.teamAna as aATN, a.teamBNa as aBTN, a.tryoutstateno, a.t_win,t_tie,t_lose,t_rank "
		strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo "
		strfield = strAfield &  ", " & strBfield 

		SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		rscnt =  rs.RecordCount

		ReDim JSONarr(rscnt-1)

		i = 0
		Do Until rs.eof
		Set rsarr = jsObject() 
			rsarr("AID") = rs("gamememberIDX")
			rsarr("ANM") = rs("aname")
			rsarr("GNO") = rs("tryoutgroupno")
			rsarr("SNO") = rs("tryoutsortno")
			rsarr("ATANM") = rs("aATN")
			rsarr("ATBNM") = rs("aBTN")
			rsarr("BID") = rs("partnerIDX")
			rsarr("BNM") = rs("bname")
			rsarr("BTANM") = rs("bATN")
			rsarr("BTBNM") = rs("bBTN")
			rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 
			rsarr("STNO") = rs("tryoutstateno") '예선 진행 상태  0
			'rsarr("RT1") = rs("tryoutresult") '예선 결과

			rsarr("TWIN") = rs("t_win") 
			rsarr("TTIE") = rs("t_tie") 
			rsarr("TLOSE") = rs("t_lose")
			rsarr("TRANK") = rs("t_rank")
			Set JSONarr(i) = rsarr
		i = i + 1
		rs.movenext
		Loop
		datalen = Ubound(JSONarr) - 1


		'스코어 입력 정보 가져오기######################################

		'각결과 및 결과입력 상태값 
			strtable = " sd_TennisMember "
			strresulttable = " sd_TennisResult "
			'strwhere = " a.GameTitleIDX = " & gameidx & " and a.gamekey1 = '" & strs1 & "' and a.gamekey2 = " & strs2 & " and  a.gamekey3 = " & strs3  & " and b.gubun = 0  and a.tryoutgroupno = " & subidx 'gubun 0 예선
			strwhere = " a.GameTitleIDX = " & gameidx & " and a.gamekey3 = " & strs3  & " and b.gubun = 0  and a.tryoutgroupno = " & subidx 'gubun 0 예선

			strsort = " order by a.tryoutsortno asc"
			strAfield = " a. gamememberIDX as RIDX " '열 인덱스(기준)
			strBfield = " b.resultIDX as IDX, b.gameMemberIDX2 as CIDX, b.stateno as GSTATE,leftetc " '인덱스 , 행 인덱스(대상) ,게임상태 ( 1, 진행 , 2, 종료 여부)
			strfield = strAfield &  ", " & strBfield 
            

			SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1 or a.gameMemberIDX = b.gameMemberIDX2   where " & strwhere & strsort
			
            Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then 
				arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
			End if


		'Response.write sql
		'스코어 입력 정보 가져오기######################################
	End Select

	'스코어 입력 정보 가져오기
	jsonstr = toJSON(JSONarr)
	Set ojson = JSON.Parse(jsonstr)
%>


<%
''=======================
'	Response.write SQL & "<br>"
'	Response.write "CMD > " & cmd & "<br>"
'	Response.write "게임인덱스 > " & gameidx & "<br>"
'	Response.write "경기구분 > " & strs1 & "<br>"
'	Response.write "경기유형 > " & strs2 & "<br>"
'	Response.write "종목선택 > " & strs3 & "<br>"
'	Response.write "예선본선구분 > " & tabletype & "<br>"
'	Response.write "조번호 > " & subidx & "<br>"

	'tabletype 
	'0 ,10  예선 , 결과예선
	'1 ,11  본선 , 결과 본선
'2  예선입력 
'=======================

    if CMD ="20003" then 

    end if 

    Select Case tabletype
    Case "0" ,"10","20" '예선목록%>
    <!-- #include virtual = "/pub/api/inc/api.search0.asp" -->

    <%Case "1", "11", "21" '본선대진표%>
			<% if CDbl(CMD) =CMD_GAMESEARCH_Result_Home then %>
					<!-- #include virtual = "/pub/api/inc/api.searchResult.asp" -->
			<%else%>
					<%  ' Round_s 값이 있으면 라운드 별 조회 
					  if Round_s ="" then %>
						<!-- #include virtual = "/pub/api/inc/api.search1.asp" -->
					<%else%>
						<!-- #include virtual = "/pub/api/inc/api.search_round.asp" -->
					<%end if%>
			<%end if %>		
    <%Case "2", "12" ,"22" '예선대진표%>
    <!-- #include virtual = "/pub/api/inc/api.search2.asp" -->
    <%End Select

  db.Dispose
  Set db = Nothing
%>




