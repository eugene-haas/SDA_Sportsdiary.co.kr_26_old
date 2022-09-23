<%
'#######################
'예선 선수 위치를 바꾼다.
'#######################

  SelectObject_IDX = oJSONoutput.SELECTOBJECT.IDX
  SelectObject_GroupNo = oJSONoutput.SELECTOBJECT.GROUPNO
  SelectObject_SortNo = oJSONoutput.SELECTOBJECT.SORTNO

  ChangeObject_IDX = oJSONoutput.CHANGEOBJECT.IDX
  ChangeObject_GroupNo = oJSONoutput.CHANGEOBJECT.GROUPNO
  ChangeObject_SortNo = oJSONoutput.CHANGEOBJECT.SORTNO

  Set db = new clsDBHelper

	SQL = "SELECT top 1 place,tryoutgroupno,tryoutsortNo from sd_TennisMember where  gameMemberIDX = " &  ChangeObject_IDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If not rs.EOF Then 
	    place1 = rs("place")
		change_gno = rs("tryoutgroupno")
		change_sno = rs("tryoutsortNo")
	end if

	SQL = "SELECT top 1 place,tryoutgroupno,tryoutsortNo from sd_TennisMember where  gameMemberIDX = " &  SelectObject_IDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If not rs.EOF Then 
	    place2 = rs("place")
		select_gno = rs("tryoutgroupno")
		select_sno = rs("tryoutsortNo")
    end If
    

  
  IF CDbl(SelectObject_IDX) <> 0  THEN
	strSql = " UPDATE sd_TennisMember "
	strSql = strSql & " SET tryoutgroupno = '" & ChangeObject_GroupNo & "',"
	strSql = strSql & "     tryoutsortNo = '" & ChangeObject_SortNo & "',"
	strSql = strSql & "     areaChanging = 'Y', "
	strSql = strSql & "     place = '"&place1&"' "
	strSql = strSql & " WHERE gameMemberIDX = '" &  SelectObject_IDX & "'"
	Call db.execSQLRs(strSql , null, ConStr)
  END IF
  

  IF CDbl(ChangeObject_IDX) <> 0  THEN


	strSql = " UPDATE sd_TennisMember "
	strSql = strSql & " SET tryoutgroupno = '" & SelectObject_GroupNo & "',"
	strSql = strSql & "     tryoutsortNo = '" & SelectObject_SortNo & "',"
	strSql = strSql & "     areaChanging = 'N' , "
	strSql = strSql & "     place = '"&place2&"' "
	strSql = strSql & " WHERE gameMemberIDX = '" &  ChangeObject_IDX & "'"
	Call db.execSQLRs(strSql , null, ConStr)
  END IF
  

  Call oJSONoutput.Set("resout", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

db.Dispose
Set db = Nothing
%>
