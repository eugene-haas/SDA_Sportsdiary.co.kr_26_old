<%
'#############################################
'예선 랭킹순으로 다시 정렬 (예선에서 버튼클릭시)
'#############################################

  idx = oJSONoutput.IDX
  tidx = oJSONoutput.TitleIDX
  title = oJSONoutput.Title
  teamnm = oJSONoutput.TeamNM
  areanm = oJSONoutput.AreaNM

  Set db = new clsDBHelper
  SQL = " Select courtcnt,level,joocnt from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
    courtcnt = rs("courtcnt") '코트수
    levelno = rs("level")
	joocnt = rs("joocnt") '생성될 조수
  End if
  
  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  
  strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and  a.gubun in ( 0, 1) "
  strsort = " order by totalRankpoint desc" '조별
  strfield = " tryoutgroupno, tryoutsortno, a.gamememberIDX, (a.rankpoint + b.rankpoint) as totalRankpoint,a.TeamANa,a.TeamBNa,b.TeamANa,b.TeamBNa "

  SQL = "select " & strfield & " from  " & strtable & " as a " 
  SQL = SQL & " LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  "
  SQL = SQL & "where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then 
    arrRS = rs.getrows()
  End If

  t1no = 1
  t2no = joocnt
  t3no = joocnt

  If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
      rgamememberIDX = arrRS(2,ar)
      tnm1 = arrRS(4,ar)
      tnm2 = arrRS(5,ar)
      tnm3 = arrRS(6,ar)
      tnm4 = arrRS(7,ar)

		If ar < joocnt then
				'1팀자리 tryoutgroupno = t1no , tryoutsortno = 1
				'Response.write CDbl(ar)+1 & " " &  t1no & "<br>"
				SQL = " UPDATE sd_TennisMember SET tryoutsortNo = 1, tryoutgroupno = " & t1no & ", gubun = '0' WHERE gameMemberIDX = " &  rgamememberIDX
				'Response.write sql & "<br>"
				Call db.execSQLRs(SQL , null, ConStr)
				t1no = t1no + 1				
		End If
		
		If ar >= joocnt And ar < joocnt*2  Then
				'2팀자리 tryoutgroupno = t2no , tryoutsortno = 2		
				'Response.write CDbl(ar)+1 & " " &  t2no  & "------<br>"
				SQL = " UPDATE sd_TennisMember SET tryoutsortNo = 2, tryoutgroupno = " & t2no & ", gubun = '0' WHERE gameMemberIDX = " &  rgamememberIDX
				'Response.write sql & "<br>"
				Call db.execSQLRs(SQL , null, ConStr)
				t2no = t2no -1
		End If

		If ar >= joocnt*2 And ar < CDbl(UBound(arrRS, 2) + 1)  Then
				'2팀자리 tryoutgroupno = t3no , tryoutsortno = 3	
				'Response.write CDbl(ar)+1 & " " &  t3no  & "#####<br>"
				SQL = " UPDATE sd_TennisMember SET tryoutsortNo = 3, tryoutgroupno = " & t3no & ", gubun = '0' WHERE gameMemberIDX = " &  rgamememberIDX
				'Response.write sql & "<br>"
				Call db.execSQLRs(SQL , null, ConStr)
				t3no = t3no -1
		End If
		
    Next  
  END IF



 	Call oJSONoutput.Set("resout", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>