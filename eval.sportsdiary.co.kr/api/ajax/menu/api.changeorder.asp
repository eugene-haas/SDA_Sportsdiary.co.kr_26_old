<%
  '--------------------------------
  '메뉴위치순서변경
  '--------------------------------

	idx = oJSONoutput.Get("IDX")
	orderno = oJSONoutput.Get("ORDERNO")
	changeorderno = oJSONoutput.Get("CHANGEORDERNO")
	
	Set db = new clsDBHelper

	'#################################
		'중복체크
		fld = " AdminMenuListIDX,RoleDepth,RoleDetail,RoleDetailNm,RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,"
	  fld = fld &" RoleDetailGroup2Nm,Link,PopupYN,UseYN,DelYN,WriteDate,WriteID,ModDate,ModID,Authority,displayorder1,displayorder2,displayorder3 "
		strWhere = " AdminMenuListIDX = " & idx
    
    SQL = "Select "&fld&"  from tbladminmenulist where " & strWhere
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


    '여러사이트 등록###################
    session_scode = session("scode")
    if session_scode <> "" then
      sitecode = session_scode
    end if
    '여러사이트 등록###################



    RoleDepth = rs("RoleDepth")
    RoleDetailGroup1 = rs("RoleDetailGroup1") '1
    RoleDetailGroup2 = rs("RoleDetailGroup2") '2
    RoleDepth  = rs("RoleDepth") '3
    select case RoleDepth 
    case "1"

    case "2"

    case "3"     
      '변경할번호
      SQL = "Select AdminMenuListIDX from tbladminmenulist where delyn = 'N' and sitecode = '"&sitecode&"' and RoleDetailGroup1 = '"&RoleDetailGroup1&"' and RoleDetailGroup2 = '"&RoleDetailGroup2&"'"
      SQL = SQL & "  and displayorder3 = " & changeorderno 
      Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
      
      if rs.eof then
        SQL = "update tbladminmenulist set displayorder3 = '"&changeorderno&"' where  AdminMenuListIDX = " & idx
        Call db.execSQLRs(SQL , null, B_ConStr)
      else
        targetidx = rs(0)
        SQL = "update tbladminmenulist set displayorder3 = '"&orderno&"' where  AdminMenuListIDX = " & targetidx
        Call db.execSQLRs(SQL , null, B_ConStr)        

        SQL = "update tbladminmenulist set displayorder3 = '"&changeorderno&"' where  AdminMenuListIDX = " & idx
        Call db.execSQLRs(SQL , null, B_ConStr)
      end if
    end select 


		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


	db.Dispose
	Set db = Nothing
%>


