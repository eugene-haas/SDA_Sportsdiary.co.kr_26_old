<%
'request
tidx = oJSONoutput.Get("TIDX")
f1 = oJSONoutput.Get("F1")
f2 = oJSONoutput.Get("F2")
linecnt = oJSONoutput.get("LINECNT")
if linecnt = "" then
  linecnt = "1" 'default
end if
mkeys = oJSONoutput.get("MKEYS")
gubun = oJSONoutput.get("GUBUN") '1개인 2단체 상장


' leaderinfo = request.Cookies("leaderinfo")
' If leaderinfo <> "" And session("chkrndno") = "" Then

' 	Set leader = JSON.Parse( join(array(leaderinfo)) )

' 	s_team =  leader.Get("a")
' 	s_username =  leader.Get("b")
' 	s_birthday = leader.Get("c")
' 	s_userphone =  leader.Get("d")
' 	s_tidx = leader.Get("e")
' 	s_idx = leader.Get("f")

' End if

' tidx = 137
' f1 = "D2"
' f2 = "X"

	If Left(mkeys,1) = "," Then
		mkeys = Mid(mkeys,2)
	End if

 	Set db = new clsDBHelper

  if gubun  = "2" then '단체상장

         SQL = ""
         SQL = SQL & " Select a.*,      b.first_key,b.second_num,b.make_key,b.make_num ,(make_key + '-' + FORMAT( make_num,'0000')) as crape_makecode,b.gameorder from " ' 6~

         SQL = SQL & " (select top 4 cdbnm, teamnm, sum(teamscore) as totalscore, (RANK() OVER (Order By sum(teamscore)  desc  )) as tc ,max(gamememberidx) as gidx "

		 SQL = SQL & "  , max(cdcnm) as cdcnm " '5번

		 SQL = SQL & " ,(SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = max(a.gamememberidx) group by username for XML path('') ),1,1, '' ))  as nm, max(tryoutresult)  as tryoutresult"

         SQL = SQL & " from sd_gameMember as a where gametitleidx = "&tidx&" and cda= '"&F1&"' and cdb = '"&F2&"' and delyn = 'N' and recordorder > 0 group by cdb,cdbnm,team,teamnm order by sum(teamscore) desc) as a   inner join sd_gameMember_crape_history as b on a.gidx = b.gamememberidx "
         SQL = SQL & " where a.gidx in ("&mkeys&")  order by b.gameorder "
         Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Response.write sql

         if not rs.eof then
               arr = rs.GetRows()
               'Call getrowsdrow(arr)
         end if


  else
         SQL = ""
         SQL = SQL & "select * from ("

         SQL = SQL & "select "
         SQL = SQL & " (case when itgubun = 'I' then a.userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm, "
         SQL = SQL & " a.team,a.teamnm,starttype, "
         SQL = SQL & " (case when starttype = 3 then tryoutresult else gameResult end ) as gresult,"
         SQL = SQL & " (case when starttype = 3 then tryouttotalorder else gametotalorder end ) as gorder, "
         SQL = SQL & " ITgubun,a.CDA,CDANM,a.CDB,CDBNM,a.CDC,CDCNM,levelno,    "
         SQL = SQL & " a.gamememberidx , first_key , second_num , (first_key + '-' + FORMAT( second_num,'0000000000')) as crape_code , rcok2id, G1korsin, G2korsin, g1gamesin, g2gamesin,  "
         SQL = SQL & " (make_key + '-' + FORMAT( make_num,'0000')) as crape_makecode "
         SQL = SQL & " from sd_gameMember as a "
         SQL = SQL & " left join sd_gameMember_crape_history as c on a.gameMemberIDX = c.gamememberidx "
         SQL = SQL & " where a.gametitleidx ="&tidx&" and a.cda= '"&F1&"' and a.cdb = '"&F2&"' and a.delyn = 'N' and a.gameMemberidx in ("&mkeys&") )  as A where gorder < 4 order by cdc, gorder  "
         Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

         if not rs.eof then
               arr = rs.GetRows()
               'Call getrowsdrow(arr)
         end if
   end if
  db.Dispose
  Set db = Nothing
%>




<div class="l_print">
<%
If IsArray(arr) Then
  For ari = startno To UBound(arr, 2)

		if gubun = "1" then
         l_usernm= arr(0, ari)
         if instr(l_usernm, ",")	> 0 then

         l_nm = split(l_usernm , ",")
         for x = 0 to ubound(l_nm)

            if x = 0 then
               l_usernm = l_nm(x)
            else
               if x = 2 then
               l_usernm = l_usernm & "<br>" & l_nm(x)
               else
               l_usernm = l_usernm & "," & l_nm(x)
               end if
            end if
         next

         end if
            l_team= arr(1, ari)
            l_teamnm= arr(2, ari)
            l_starttype= arr(3, ari)

            l_gameresult= arr(4, ari)
            l_gameorder= arr(5, ari)

            l_ITgubun= arr(6, ari)
            l_CDA= arr(7, ari)
            l_CDANM= arr(8, ari)
            l_CDB= arr(9, ari)
            l_CDBNM= arr(10, ari)
            l_CDC= arr(11, ari)
            l_CDCNM= arr(12, ari)
            l_levelno= arr(13, ari)
            l_idx = arr(14,ari)

            l_key = arr(15,ari)
            l_incno = arr(16,ari)
            l_code = arr(17,ari)
            l_makecode = arr(23, ari)
      else

            l_cdbnm= arr(0, ari)
            l_teamnm= arr(1, ari)
            l_totalscore= arr(2, ari)
            l_rank= arr(3, ari)
            l_idx= arr(4, ari)
            l_CDCNM= arr(5, ari)
			l_usernm = arr(6,ari)
			l_gameresult = arr(7,ari)
			'아래



            l_first_key= arr(8, ari)
            l_second_num= arr(9, ari)
            l_make_key= arr(10, ari)
            l_make_num   = arr(11, ari)

			l_makecode = arr(12,ari)
            l_gameorder = arr(13,ari)




      end if
%>

      <ol>
         <li class="l_print__page">

            <P CLASS=HStyle0><SPAN class="HStyle0__title"><BR></SPAN></P>

            <P CLASS=HStyle0><SPAN class="HStyle0__title"><BR></SPAN></P>

            <P CLASS=HStyle0><SPAN class="HStyle0__title"><!--제 --><%=l_makecode%><!-- 호--></SPAN></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0><BR></P>

            <P CLASS=HStyle0>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <TABLE border="1" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
               <TR>
                  <TD colspan="2" width="50%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0 STYLE='text-align:center;'><SPAN class="HStyle0__text"><%=l_CDBNM%></SPAN></P>
                  </TD>
                  <TD width="15%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0 STYLE='text-align:center;'><SPAN class="HStyle0__text"><%if gubun="1" then%>기&nbsp;&nbsp; 록<%else%>기&nbsp;&nbsp;록<%end if%></SPAN></P>
                  </TD>
                  <TD width="35%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0><SPAN class="HStyle0__text">: 
					 
					 <%'경영일때 이런거 같음%>
					 <%Select Case F1%>
					 <%Case "D2"%>

					 <%if gubun="1" then%><%Call SetRC(l_gameresult)%><%else%><%Call SetRC(l_gameresult)%><%'=l_totalscore%><%end if%>
					 <%Case "E2"%>
								<%
								If isNumeric(l_tryoutresult) = True Then
										Response.write = FormatNumber(l_tryoutresult / 100 ,2)
								Else
										Response.write = ""
								End If
								%>
					 <%Case "F2"%>
								 <%
					 			If isNumeric(l_tryoutresult) = True Then
										Response.write  FormatNumber(l_tryoutresult / 10000 ,4)
								Else
										Response.write = ""
								End If

								%>
					 <%End Select %>
					 
					 </SPAN></P>


                  </TD>
               </TR>
               <TR>
                  <TD width="15%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0 STYLE='text-align:center;'><SPAN class="HStyle0__text">종&nbsp;&nbsp;목</SPAN></P>
                  </TD>
                  <TD width="35%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0><SPAN class="HStyle0__text">: <%=l_CDCNM%></SPAN></P>
                  </TD>
                  <TD width="15%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0 STYLE='text-align:center;'><SPAN class="HStyle0__text">소&nbsp;&nbsp;속</SPAN></P>
                  </TD>
                  <TD width="35%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0><SPAN class="HStyle0__text">: <%=l_teamnm%></SPAN></P>
                  </TD>
               </TR>
               
			   <TR>
                  <TD colspan="2" width="50%" height="54" valign="middle" class="HStyle0_wrap" align="center">
                     <SPAN class="HStyle0__text"><%=l_gameorder%>&nbsp;&nbsp;&nbsp; 위</SPAN>
                  </TD>

                  <TD width="15%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0 STYLE='text-align:center;'><SPAN class="HStyle0__text">성&nbsp;&nbsp;명</SPAN></P>
                  </TD>
                  <TD width="35%" height="54" valign="middle" class="HStyle0_wrap">
                     <P CLASS=HStyle0>
					 
					 <SPAN class="HStyle0__text">: 

						  <%
						  If InStr(l_usernm,",") > 0 then
							
							l_umarr=Split(l_usernm,",")
							For i = 0 To ubound(l_umarr)
								Select Case CDbl(Len(l_umarr(i)))

								Case 2
									nm = Left(l_umarr(i),1) & "&nbsp;" & right(l_umarr(i),1)
									If i = 1 Then
										nmstr = nmstr & nm & "<br>&nbsp;&nbsp;"
									Else
										If i < ubound(l_umarr) then
											nmstr = nmstr & nm & ","
										Else
											nmstr = nmstr & nm
										End if
									End if

								Case 3,4
									nm = l_umarr(i)
									If i = 1 Then
										nmstr = nmstr & nm & "<br>&nbsp;&nbsp;"
									Else
										If i < ubound(l_umarr) then
											nmstr = nmstr & nm & ","
										Else
											nmstr = nmstr & nm					
										End if
									End If
									
								Case Else
									nmstr = nmstr & l_umarr(i) & "<br>&nbsp;&nbsp;"
								End Select 

							next
							Response.write nmstr

						  else
							  Response.write l_usernm
						  End If
						  %>
					 

					 </SPAN>
					 </P>
                  </TD>

               </TR>
            </TABLE>
            </P>



         </li>
      </ol>
<%
  next
end if
%>
</div>
