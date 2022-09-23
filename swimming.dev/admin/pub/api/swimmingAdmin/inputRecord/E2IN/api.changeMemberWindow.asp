<%
'#############################################
' 심판수정 모달창
'#############################################
	'request
	 midx = oJSONoutput.Get("MIDX")
	 pidx = oJSONoutput.Get("PIDX")
	 CDA = "E2" '다이빙

	 Set db = new clsDBHelper


  


	   fld = " b.username as '이름',b.teamnm as '소속',b.team as '팀코드',gbidx,gametitleidx "
	   SQL = " Select "&fld&" from sd_gamemember as a inner join sd_gamemember_partner as b on a.gamememberidx = b.gamememberidx "
     SQL = SQL & " where a.gamememberidx = " & midx & " and b.playeridx = " & pidx 
	   Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
     teamcode = rss(2)
     gbidx = rss(3)
     tidx = rss(4)
   

    pidxSQL = " Select b.playeridx from sd_gamemember as a inner join sd_gamemember_partner as b on a.gamememberidx = b.gamememberidx "
    pidxSQL = pidxSQL & " where gametitleidx = "&tidx&" and itgubun = 'T' and a.DelYN = 'N' and gbidx = " & gbidx

    '현재부서에 참가한 사람은 빼야지 중복안되겠지
    SQL = "select playeridx , kskey ,username, birthday,sex,sidocode,sido,team,teamnm,entertype,userclass,cdbnm from tblplayer "
    SQL = SQL & " where delyn='N' and entertype = 'E' and team =  '"&teamcode&"' and playeridx not in ("&pidxSQL&")"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then
      arrR = rs.GetRows()
    end if


%>


<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">출전 선수 변경</button></h4>
    </div>

<%
'call rsdrow(rss)
%>


    <div class="modal-body">
      <div id="Modaltestbody">

          <div class="row">
            <div class="col-xs-12">
              <div class="box">
                <input type="text" id="fid" class="form-control" style="width:200px;float:left;">
                <a href="javascript:mx.findMember($('#fid').val(),<%=midx%>,<%=pidx%>)" class="btn btn-default">검색</a>
                <div class="box-body" id="findmemberarea">


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




                </div>
              </div>
            </div>
          </div>

      </div>
    </div>


  </div>
</div>
<%
	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
