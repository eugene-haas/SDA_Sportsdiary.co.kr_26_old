<%
'#############################################

'#############################################

'request
idx = oJSONoutput.IDX
midx = oJSONoutput.PIDX

Set db = new clsDBHelper

SQL = "update tblGameRequest Set delYN = 'Y' where RequestIDX = " & idx
Call db.execSQLRs(SQL , null, ConStr)

SQL = "delete sd_TennisMember where gameMemberIDX = " & midx
Call db.execSQLRs(SQL , null, ConStr)
SQL = "delete from sd_TennisMember_partner where gameMemberIDX = " & midx
Call db.execSQLRs(SQL , null, ConStr)



If idx <> "" And isnull(idx) = False then
'발급받은 가상계좌정보 사용막음
SQL = "UPDATE TB_RVAS_MAST Set STAT_CD = '0' where CUST_CD = '" & idx & "' "
Call db.execSQLRs(SQL , null, ConStr)
End if


'가상계좌정보 초기화 해야겠군.============
'SQL = "Update TB_RVAS_MAST Set STAT_CD= '1' ,ENTRY_IDNO = null , CUST_CD = null,IN_GB = '1',PAY_AMT = 0,PAY_FROM_DATE='00000000',PAY_TO_DATE='99999999',CUST_NM = null,ENTRY_DATE = null  where  CUST_CD = '" & idx & "' "
'Call db.execSQLRs(SQL , null, ConStr)

'1년정보씩 일괄 정리하자
'가상계좌정보 초기화 해야겠군.============


'#############################################



gamemember = "<a href='javascript:mx.setPlayer("& idx &")' class='btn_a'>예선 참가</a>"


db.Dispose
Set db = Nothing
%>

<%=gamemember%>

