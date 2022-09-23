<%
	'request
	idx = oJSONoutput.IDX
	levelno  = oJSONoutput.LevelNo
	ridx  = oJSONoutput.ridx
	ChekMode  = oJSONoutput.ChekMode

	Set db = new clsDBHelper
	'대회에 참여가 결정된 맴버 아이디목록 추출
	SQL ="select userName,gameMemberIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gamekey3 = " & levelno & "  and  delYN='N'  order by gameMemberIDX asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrM = rs.GetRows()
	End if
    
   SQL=""
   SQL = SQL&"  select RequestIDX,SportsGb,GameTitleIDX,Level,EnterType,UserPass,UserName,isnull(UserPhone,'')UserPhone,txtMemo,PaymentDt,PaymentNm "
   SQL = SQL&" ,P1_PlayerIDX,P1_UserName,P1_Team,P1_TeamNm,P1_Team2,P1_TeamNm2,isnull(P1_UserPhone,'')P1_UserPhone ,P2_PlayerIDX,P2_UserName,P2_Team,P2_TeamNm,P2_Team2,P2_TeamNm2,isnull(P2_UserPhone,'')P2_UserPhone " 
   SQL = SQL&"  from tblGameRequest as a " 
   SQL = SQL&"  where GameTitleIDX = "&idx&"  and level = '"&levelno&"' and RequestIDX='"&ridx&"'  and DelYN = 'N' " 
 
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.EOF Then 
	Do Until rs.eof
        UserName =rs("UserName") 
        UserPhone =rs("UserPhone") 
        txtMemo =rs("txtMemo") 
        PaymentDt =rs("PaymentDt") 
        PaymentNm =rs("PaymentNm") 
        UserPhone =rs("UserPhone") 
        UserPass =rs("UserPass") 
	rs.movenext
	Loop
End if

UserPhone = replace(UserPhone,"-","") 
UserPhone1 = left(UserPhone,3)
if len(UserPhone)>=11 then 
    UserPhone2 = mid(UserPhone,4,4)
    UserPhone3 = right(UserPhone,4)
else
    UserPhone2 = mid(UserPhone,4,3)
    UserPhone3 = right(UserPhone,4)
end if 


Call oJSONoutput.Set("UserName", UserName)
Call oJSONoutput.Set("UserPhone", UserPhone)
Call oJSONoutput.Set("UserPhone1", UserPhone1 )
Call oJSONoutput.Set("UserPhone2", UserPhone2 )
Call oJSONoutput.Set("UserPhone3", UserPhone3 )
Call oJSONoutput.Set("txtMemo",txtMemo )
Call oJSONoutput.Set("PaymentDt", PaymentDt)
Call oJSONoutput.Set("PaymentNm", PaymentNm)
Call oJSONoutput.Set("UserPass", UserPass)

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("sql_se", SQL )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


If Not rs.EOF Then 
	i = 0
	Do Until rs.eof
	    %>

			<!-- s: 참가자정보 -->
			<dd>
				<p class="c_title">참가자 정보</p>
				<div class="info_list">
					<ul> 
						<li>
							<span class="l_name">이 름</span>
							<span class="r_con">
                                <input  type="hidden"  name="p1idx" id="p1idx" value="<%=rs("P1_PlayerIDX") %>"/> 
								<input type="text" class="ipt input_1" id="p1name" name="p1name" autocomplete="off" placeholder=":: 이름을 입력하세요 ::"    value="<%=rs("P1_UserName") %>" />
                                <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user" ></ul>
							</span> 
						</li> 
						<li>
							<span class="l_name">기본클럽</span>
							<span class="r_con">
                                <input  type="hidden"  name="p1team1" id="p1team1" value="<%=rs("P1_Team") %>"/> 
								<input type="text" class="ipt input_1" id="p1team1txt" name="p1team1txt"  placeholder=":: 대표소속명을 입력하세요 ::" autocomplete="off" value="<%=rs("P1_TeamNm") %>" disabled/>
                                <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-team" ></ul>
							</span>
						</li>
                        <li>
							<span class="l_name">기타클럽</span>
							<span class="r_con">
                                <input  type="hidden"  name="p1team2" id="p1team2" value="<%=rs("P1_Team2") %>"/> 
								<input type="text" class="ipt input_1" id="p1team2txt" name="p1team2txt"  placeholder=":: 추가소속명을 입력하세요 ::" autocomplete="off" value="<%=rs("P1_TeamNm2") %>" disabled/> 
							</span>
                        </li>
						<li>
							<span class="l_name">휴대폰번호</span>
							<span class="r_con"> 
                                <input  type="hidden"  name="p1phone" id="p1phone" value="<%=rs("P1_UserPhone") %>"/> 
                                <% 
                                    P1_UserPhone = replace(rs("P1_UserPhone"),"-","") 
                                    P1_UserPhone1 = left(P1_UserPhone,3)
                                    
                                    if len(P1_UserPhone)>=11 then 
                                        P1_UserPhone2 = mid(P1_UserPhone,3,4)
                                        P1_UserPhone3 = right(P1_UserPhone,4)
                                    else
                                        P1_UserPhone2 = mid(P1_UserPhone,3,3)
                                        P1_UserPhone3 = right(P1_UserPhone,4)
                                    end if 
                                 %>
					            <select class="ipt col_1" id="p1phone1" name="p1phone1"  disabled>
						            <option value="010" <%if P1_UserPhone1 ="010" then %> selected<%end if %> >010</option> 
						            <option value="011" <%if P1_UserPhone1 ="011" then %> selected<%end if %> >011</option>
						            <option value="016" <%if P1_UserPhone1 ="016" then %> selected<%end if %> >016</option>
						            <option value="017" <%if P1_UserPhone1 ="017" then %> selected<%end if %> >017</option>
						            <option value="018" <%if P1_UserPhone1 ="018" then %> selected<%end if %> >018</option>
						            <option value="019" <%if P1_UserPhone1 ="019" then %> selected<%end if %> >019</option>
					            </select>
								<span class="divn">-</span>
								<input type="password" class="ipt col_1" id="p1phone2" name="p1phone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);"onfocus="this.select()" autocomplete="off" value="<%'P1_UserPhone2 %>" disabled/>
								<span class="divn">-</span>
								<input type="number" class="ipt col_1" id="p1phone3" name="p1phone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off" value="<%=P1_UserPhone3 %>" disabled/>
							</span>
						</li>
					</ul>
				</div>
			</dd>
			<!-- e: 참가자정보 -->
			<!-- s: 파트너정보 -->
			<dd>
				<p class="c_title">파트너 정보</p>
				<div class="info_list">
					<ul>
						<li>
							<span class="l_name">이 름</span> 
							<span class="r_con">
                                <input  type="hidden"  name="p2idx" id="p2idx" value="<%=rs("P2_PlayerIDX") %>"/> 
								<input type="text" class="ipt input_1" id="p2name" name="p2name" autocomplete="off" placeholder=":: 이름을 입력하세요 ::"    value="<%=rs("P2_UserName") %>"/>
							</span>
						</li> 
						<li>
							<span class="l_name">기본클럽</span>
							<span class="r_con">
                                <input  type="hidden"  name="p2team1" id="p2team1" value="<%=rs("P2_Team") %>"/> 
								<input type="text" class="ipt input_1" id="p2team1txt" name="p2team1txt"  placeholder=":: 대표소속명을 입력하세요 ::" autocomplete="off"  value="<%=rs("P2_TeamNm") %>" disabled/>
							</span>
						</li>
                        <li>
							<span class="l_name">기타클럽</span>
							<span class="r_con">
                                <input  type="hidden"  name="p2team2" id="p2team2" value="<%=rs("P2_Team2") %>"/> 
								<input type="text" class="ipt input_1" id="p2team2txt" name="p2team2txt"  placeholder=":: 추가소속명을 입력하세요 ::" autocomplete="off"  value="<%=rs("P2_TeamNm2") %>" disabled/> 
							</span>
                        </li> 
						<li>
							<span class="l_name">휴대폰번호</span>
							<span class="r_con"> 
                                <input  type="hidden"  name="p2phone" id="p2phone" value="<%=rs("P2_UserPhone") %>"/> 
                              <% 
                                    P2_UserPhone = replace(rs("P2_UserPhone"),"-","") 
                                    P2_UserPhone1 = left(P2_UserPhone,3)
                                    
                                    if len(P2_UserPhone)>=11 then 
                                        P2_UserPhone2 = mid(P2_UserPhone,3,4)
                                        P2_UserPhone3 = right(P2_UserPhone,4)
                                    else
                                        P2_UserPhone2 = mid(P2_UserPhone,3,3)
                                        P2_UserPhone3 = right(P2_UserPhone,4)
                                    end if 
                                 %>
					            <select class="ipt col_1" id="p2phone1" name="p2phone1" disabled/>
						            <option value="010" <%if P2_UserPhone1 ="010" then %> selected<%end if %> >010</option> 
						            <option value="011" <%if P2_UserPhone1 ="011" then %> selected<%end if %> >011</option>
						            <option value="016" <%if P2_UserPhone1 ="016" then %> selected<%end if %> >016</option>
						            <option value="017" <%if P2_UserPhone1 ="017" then %> selected<%end if %> >017</option>
						            <option value="018" <%if P2_UserPhone1 ="018" then %> selected<%end if %> >018</option>
						            <option value="019" <%if P2_UserPhone1 ="019" then %> selected<%end if %> >019</option>
					            </select>
								<span class="divn">-</span>
								<input type="password" class="ipt col_1" id="p2phone2" name="p2phone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off"value="<%'P2_UserPhone2 %>" disabled/>
								<span class="divn">-</span>
								<input type="number" class="ipt col_1" id="p2phone3" name="p2phone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off"value="<%=P2_UserPhone3 %>" disabled/>
							</span>
						</li>
					</ul>
				</div>
			</dd>
			<!-- e: 파트너정보 -->

	    <%
	i = i + 1
	rs.movenext
	Loop
End if
 

db.Dispose
Set db = Nothing
%>