<%
'#############################################
' 변경선수 검색
'#############################################
	'request
	pidx = oJSONoutput.Get("PIDX")
	midx = oJSONoutput.Get("MIDX")
	pnm =  oJSONoutput.Get("UNM")
	cda = "E2"

	Set db = new clsDBHelper



  if Cdbl(len(pnm)) < 2 then
      Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
      Call oJSONoutput.Set("servermsg", "두글자 이상으로 검색해주세요"& len(pnm) ) '서버에서 메시지 생성 전달
      strjson = JSON.stringify(oJSONoutput)
      Response.Write strjson
      Response.End    
  end if

	   fld = " b.username as '이름',b.teamnm as '소속',b.team as '팀코드',gbidx,gametitleidx "
	   SQL = " Select "&fld&" from sd_gamemember as a inner join sd_gamemember_partner as b on a.gamememberidx = b.gamememberidx "
     SQL = SQL & " where a.gamememberidx = " & midx & " and b.playeridx = " & pidx 
	   Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
     teamcode = rss(2)
     gbidx = rss(3)
     tidx = rss(4)
   

    pidxSQL = " Select b.playeridx from sd_gamemember as a inner join sd_gamemember_partner as b on a.gamememberidx = b.gamememberidx "
    pidxSQL = pidxSQL & " where gametitleidx = "&tidx&" and itgubun = 'T' and a.DelYN = 'N' and gbidx = " & gbidx

    '같은부서인지 자기 부서인지는 체크해야해
    SQL = "select top 20 playeridx , kskey ,username, birthday,sex,sidocode,sido,team,teamnm,entertype,userclass,cdbnm from tblplayer "
    SQL = SQL & " where delyn='N' and entertype = 'E' and username like '"&pnm&"%'  and playeridx not in ("&pidxSQL&") order by len(username)"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    'call rsdrow(rs)
    If Not rs.EOF Then
      arrR = rs.GetRows()
    end if
%>


      <table id="settable" class="table table-bordered" >
          <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>선수명</th>
								<th>생년</th>                
                <th>소속</th>
								<th>선수변경</th>

						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
              <%
              If IsArray(arrR) Then 
                For ari = LBound(arrR, 2) To UBound(arrR, 2)
                    newpidx = arrR(0,ari)  
                    kskey = arrR(1,ari)  
                    username = arrR(2,ari)  
                    birthday = arrR(3,ari)  
                    sex = arrR(4,ari)  
                    if sex = "1" or sex = "3" then
                    sexstr = "남"
                    else
                    sexstr = "여"
                    end if
                    sidocode = arrR(5,ari)  
                    sido = arrR(6,ari)  
                    team = arrR(7,ari)  
                    teamnm = arrR(8,ari)  
                    entertype  = arrR(9,ari)
                    userclass =  arrR(10,ari)
                    cdbnm = arrR(11,ari)

                    %>
                    <tr style="text-align:center;">
                      <td><%=username%> (<%=sexstr%>) </td>
                      <td><%=birthday%></td>
                      <td><%=teamnm%>[<%=cdbnm%>]</td>                                            
                      <td><a href="javascript:mx.changeMember(<%=midx%>,<%=pidx%>,<%=newpidx%>)" class="btn btn-danger" >변경</a></td>
                      </tr>
                    <%

                    
                Next
              end if
              %>					  
					</tbody>
			</table>










<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
