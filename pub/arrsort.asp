<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
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