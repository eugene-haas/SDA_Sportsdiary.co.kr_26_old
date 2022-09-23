<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

'참가신청정보

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	OIDX = oJSONoutput.Get("OIDX")

	Set db = new clsDBHelper

	'SQL = "UPDATE tblSwwimingOrderTable Set  Oorderstate= case when Oorderstate = '88' then '89' else '88' end where OrderIDX =  '"&OIDX&"' "
	'Call db.execSQLRs(SQL , null, ConStr)
	'###################

	'Call oJSONoutput.Set("result", "0" ) '메시지없이 종료
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson



	SQL = "select gametitleidx,team , (select top 1 teamnm from tblteaminfo where team = a.team ) as teamnm,leaderidx,leadername,(select top 1 userphone from tblReader where idx = a.leaderidx ) as leaderphone  from  tblSwwimingOrderTable as a  where OrderIDX =  '"&OIDX&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		tidx = rs(0)
		teamcd = rs(1)
		teamnm = rs(2)
		leaderkey = rs(3)
		leadername = rs(4)
		leaderphone = rs(5)

		'선수들
		'order by  isnull(gameorder,'9999')  asc"
		fldboo = " ,(SELECT  STUFF(( select ','+ CDCNM from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM for XML path('') ),1,1, '' )) as '참가종목' "
		fld = " a.playeridx as 'key' ,a.username as '이름',a.birthday as '생년',  (case when   a.sex = 1 then '남'  else '여' end) as '성별'          "
		fld = fld & " , ( case when  a.CDBNM = '초등부' and  a.userclass < 5 then '유년부' else a.CDBNM end)   as '참여부'  "
		fld = fld & "  ,a.userclass  as '학년' " & fldboo
		SQL = "Select "&fld&" from tblGameRequest_imsi as a  where a.team = '"&teamcd&"' and a.tidx = '"&tidx&"' and delyn = 'N' and a.leaderidx = '"&leaderkey&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	  'If Not rs.EOF Then
	  '	arrP = rs.GetRows()
		'Call getrowsdrow(arrp)
	  'End If
  End if	

	
	
	db.Dispose
	Set db = Nothing
%> 


<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">대회참가신청내역 (지도자 : <%=leadername%>, Tel : <%=leaderphone%> , 소속 : <%=teamnm%>)</button></h4>
    </div>

		<div class="modal-body">
		<div id="Modaltestbody">

			<div class="row">
				<div class="box-body">
				<%Call rsdrow(rs)%>
				</div>
			</div>

		</div>
		</div>
  
  </div>
</div>

