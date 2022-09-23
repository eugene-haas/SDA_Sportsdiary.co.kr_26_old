<%
'#############################################

' 대회 정보 코드 생성용 조회

'#############################################
	'request
	tidx = oJSONoutput.FSTR
	fstr2 = oJSONoutput.FSTR2

	fstr2_str= CStr(Split(fstr2,",")(0))
    fstr2_str1= CStr(Split(fstr2,",")(1))

	Set db = new clsDBHelper

    '생성 여부 확인하고 찍어준다.
    SQL = "select * from sd_TennisKATARullMake where mxjoono = '" & CStr(tidx) & CStr(fstr2_str) & "'"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
		
	If Not rs.eof Then 
		Do Until rs.eof

		p_attcnt		= rs("attcnt")
		p_seedcnt		= rs("seedcnt")
		p_jonocnt		= rs("jonocnt")
		p_boxorder		= rs("boxorder")

		rs.movenext
		Loop
 
	end if 

	if p_jonocnt ="" then 
	 SQLasd = "select JooCnt from tblRGameLevel where GameTitleIDX= '" & CStr(tidx)& "' and DelYN='N' and Level='"& CStr(fstr2_str) & "' group by JooCnt"
	 Set rs = db.ExecSQLReturnRS(SQLasd , null, ConStr)		
	 p_jonocnt = rs(0)
		 if p_jonocnt > 4 and p_jonocnt<=8 then 
			p_seedcnt =4
			p_attcnt =16
		 elseif  p_jonocnt > 8 and p_jonocnt<=16 then 
			p_seedcnt =4
			p_attcnt =32
		 elseif  p_jonocnt > 16 and p_jonocnt<=32 then 
			p_seedcnt =8
			p_attcnt =64
		 elseif  p_jonocnt > 32 and p_jonocnt<=64 then 
			p_seedcnt =8
			p_attcnt =128
		 elseif  p_jonocnt > 64 and p_jonocnt<=128 then 
			p_seedcnt =8
			p_attcnt =256
		 elseif  p_jonocnt > 128 and p_jonocnt<=256 then 
			p_seedcnt =16
			p_attcnt =512
		 else
			p_jonocnt = 4
			p_seedcnt =4
			p_attcnt =8
		 end if
	end if 
 

	'타입 석어서 보내기
	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("attcnt", p_attcnt )
	Call oJSONoutput.Set("seedcnt", p_seedcnt )
	Call oJSONoutput.Set("jonocnt", p_jonocnt )
	Call oJSONoutput.Set("boxorder", p_boxorder )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"
     
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
   
    If rs.eof Then
	    Response.write "<div id='rullmsg' style='width:100%;height:30px;color:red;text-align:center;'>대진표 생성 정보가 없습니다. 대진표를 생성 하십시오.</div>"

	else
		
		sql = "select top 1 *  " 
		sql = sql & " from  sd_TennisMember "  
		sql = sql & " where delyn='N' and GameTitleIDX='"&tidx&"'  and  gamekey3 ='"&fstr2_str&"' and ISNULL(round,'')='' "  
		Set srs = db.ExecSQLReturnRS(sql , null, ConStr)	

			gameMemberIDX="N"

		If Not srs.eof Then
			gameMemberIDX ="Y"
		end if 

		if gameMemberIDX="Y" then 

			sql = "select a.tryoutgroupno,a.t_rank,a.rndno1,a.rndno2,a.userName a_userName,a.TeamANa a_TeamANa,a.TeamBNa a_TeamBNa,b.userName b_userName,b.TeamANa b_TeamANa,b.TeamBNa b_TeamBNa ,isnull(a.place,'')place " 
			sql = sql & " from  sd_TennisMember a "  
			sql = sql & " inner join sd_TennisMember_partner b on a.gameMemberIDX = b.gameMemberIDX "  
			sql = sql & " where a.delyn='N' and  a.GameTitleIDX='"&tidx&"'  and  a.gamekey3 ='"&fstr2_str&"' and ISNULL(a.round,'')='' "  

			Set srs = db.ExecSQLReturnRS(sql , null, ConStr)	

			If Not srs.EOF Then 
				arrRS = srs.GetRows()
			End if
		end if 
    end if
%> 
<table class='table-list' border='1'>
<thead id="headtest">
<th>본선대진 ID</th>
<th>순번</th>
<th>예선순위</th>
<th>추첨번호</th>
<th style="background-color:orange;width:10px;"></th>
<th>시드</th>
<th>추첨번호 변경</th>
<th style="background-color:orange;width:10px;"></th>
<th>예선 배정정보 <%=gameMemberIDX%></th>
</thead>
<tbody>
<%
	i=1
	If Not rs.eof Then 
		Do Until rs.eof

		p_idx	= rs("idx")
		p_mxjoono	= rs("mxjoono")
		p_joono		= rs("joono")
		p_orderno	= rs("orderno")
		p_sortno	= rs("sortno")	
		p_gang		= rs("gang")
		p_round		= rs("round")
		p_seed		= rs("seed")
		
		p_attcnt		= rs("attcnt")
		p_seedcnt		= rs("seedcnt")
		p_jonocnt		= rs("jonocnt")
		p_boxorder		= rs("boxorder")
 
%>
		<%if  cdbl(p_seed) =0 and p_orderno = "1" then %> 
		<tr class="gametitle"   style="background-color:#cfdfff;">

		<%elseif  p_orderno = "0" then %> 
		<tr class="gametitle"   style="background-color:#888;">

		<%elseif cdbl(p_seed) >0 and p_orderno = "1" then %> 
		<tr class="gametitle"   style="background-color:#fda;">

		<%else %>
		<tr class="gametitle"   style="background-color:#dff;">

		<%end if %>
			<td><%=p_mxjoono%></td>
			<td><%=p_sortno%></td>
			<%if  p_orderno = "1" then %>
				<td style="color:red;width:50px;"><%=p_orderno%></td>
			<%elseif  p_orderno = "0" then %>
				<td style="color:blue;width:50px;">B</td>
			<%else %>
				<td style="width:50px;"><%=p_orderno%></td>
			<%end if %>

			<td id="c_<%=p_orderno%>_<%=p_joono%>"><%if p_joono <> 0 then %><%=p_joono%><%else %>B<%end if %></td>
			<td style="background-color:orange;width:10px;"></td>
			<%if cdbl(p_seed) >0 and p_orderno <> "0" then %>
				<td style="background-color:#454;color:#fff;width:30px;"><%=p_joono%></td>
			<%else %>
				<td ></td>
			<%end if %>
			<td style="width:60px;">
				<%if p_joono <> 0 then %>
				<input type="number" id="b_<%=p_orderno%>_<%=p_joono%>" value="<%=p_joono%>"  onfocus="this.select();" onchange="mx.trjoonoSave(this);"/>
				<input type="hidden" id="i_<%=p_orderno%>_<%=p_joono%>" value="<%=p_idx%>" />
				<%else %>
					bye
				<%end if %>
			</td>
			<td style="background-color:orange;width:10px;"></td>
			<td  style="width:560px;">
				<%
					If IsArray(arrRS) Then
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
							tryoutgroupno	=arrRS(0, ar) 
							t_rank			=arrRS(1, ar) 
							rndno1			=arrRS(2, ar)
							rndno2			=arrRS(3, ar) 
							a_userName		=arrRS(4, ar) 
							a_TeamANa		=arrRS(5, ar) 
							a_TeamBNa		=arrRS(6, ar) 
							b_userName		=arrRS(7, ar) 
							b_TeamANa		=arrRS(8, ar) 
							b_TeamBNa		=arrRS(9, ar) 
							t_place			=arrRS(10, ar) 


							if  p_orderno =1 and  t_rank  = 1 then 
								if  p_joono =rndno1 then
									Response.write "["&t_place&"]"&tryoutgroupno&"조 - "&t_rank&"위 [  선수1 : "&a_userName&" ] [ 선수2 : "&b_userName &"]"
								end if 
							elseif   p_orderno =2 and  t_rank  = 2 then 
								if  p_joono = rndno2 then
									Response.write "["&t_place&"]"&tryoutgroupno&"조 - "&t_rank&"위 [  선수1 : "&a_userName&" ] [ 선수2 : "&b_userName&"]"
								end if 
							end if

						Next
					end if
 
				%>
			</td>
		</tr>
<%

		if i mod 2 <> 1 then 
			%>
				<tr style="height:5px;"> 
					<td colspan="9" style="background-color:black;height:5px;"> </td>
				</tr>
			<%
		end if

		i = i + 1
		rs.movenext
		Loop
	End If

%>
</tbody>
</table>
</br>
</br>
<%
db.Dispose
Set db = Nothing
%>