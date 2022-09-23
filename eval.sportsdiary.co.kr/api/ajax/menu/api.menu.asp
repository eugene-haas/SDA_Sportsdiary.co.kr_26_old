<!-- #include virtual = "/admin/inc/header.eval.asp" -->
<%
	'###################################
	'사용자 사용메뉴 리스트 
	'###################################

	uidx = oJSONoutput.Get("UIDX")

	Set db = new clsDBHelper


	fieldstr = " RoleDetailGroup1,RoleDetailGroup1Nm,Authority "
	fieldstr = fieldstr & " , (select ImgLink from tblAdminMenuList where delyn= 'N' and sitecode='EVAL2' and RoleDepth = 1 and RoleDetailGroup1 = a.RoleDetailGroup1) as ImgLink "
	wherestr = " DelYN = 'N' and useYN = 'Y' and sitecode = '"&sitecode&"' and RoleDetail in ( select RoleDetail from tblAdminMenuRole where delyn= 'N' and sitecode='EVAL2' and adminMemberidx = "&uidx&" group by RoleDetail )"
	orderstr = " group by RoleDetailGroup1,RoleDetailGroup1Nm,Authority order by RoleDetailGroup1 "	
	SQL = "Select "&fieldstr&" from tblAdminMenuList as a where " & wherestr & orderstr
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	if not rs.eof then
		rsobj_1 =  jsonTors_arr(rs)
	end if

	fieldstr = " RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,Authority "
	wherestr = " DelYN = 'N' and useYN = 'Y' and sitecode = '"&sitecode&"' and RoleDetail in ( select RoleDetail from tblAdminMenuRole where delyn= 'N' and sitecode='EVAL2' and adminMemberidx = "&uidx&" group by RoleDetail )"
	orderstr = " group by RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,Authority order by RoleDetailGroup1 "	
	SQL = "Select "&fieldstr&" from tblAdminMenuList where " & wherestr & orderstr
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	if not rs.eof then
		rsobj_2 =  jsonTors_arr(rs)
	end if

	
	fieldstr = " RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,RoleDetail,RoleDetailNm,Link,ImgLink,PopupYN,Authority,DisplayOrder3 "
	wherestr = " DelYN = 'N' and useYN = 'Y' and sitecode = '"&sitecode&"' and RoleDetail in ( select RoleDetail from tblAdminMenuRole where delyn= 'N' and sitecode='EVAL2' and adminMemberidx = "&uidx&" group by RoleDetail )"
	orderstr = " order by RoleDetailGroup1,RoleDetailGroup2, DisplayOrder3 "	
	SQL = "Select "&fieldstr&" from tblAdminMenuList where " & wherestr & orderstr
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)



	If Not rs.EOF Then
		'배열로 화면 확인
		'arrR = rs.GetRows()
		'Call oJSONoutput.Set("list", arrR ) '배열
		'cdbnm = rs("CDBNM")

		rsobj_3 =  jsonTors_arr(rs)
		objstr = "{""list1"": "&rsobj_1&",""list2"": "&rsobj_2&",""list3"": "&rsobj_3&",""errorcode"":""SUCCESS""}"

		Set oJSONoutput = JSON.Parse( join(array(objstr)) )
		'Call oJSONoutput.Set("cdbnm", cdbnm ) 
		'Call oJSONoutput.Set("cdc", cdc ) 

		'Call oJSONoutput.Set("sql", sql ) 
		'Call oJSONoutput.Set("jno", jno ) '배열		

		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

	Else
		Call oJSONoutput.Set("list", array() ) '정상
		Call oJSONoutput.Set("errorcode", "SUCCESS" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	End If

	db.Dispose
	Set db = Nothing
%>