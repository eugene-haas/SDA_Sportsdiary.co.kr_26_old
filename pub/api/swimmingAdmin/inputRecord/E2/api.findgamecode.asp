<%
'#############################################
' 심판수정 모달창
'#############################################
	'request
	midx = oJSONoutput.Get("MIDX")
  CDC =  oJSONoutput.Get("CDC")
  gameroundno = oJSONoutput.Get("GAMERNDNO")
  FINDSTR = oJSONoutput.Get("FINDSTR")
	CDA = "E2" '다이빙

	Set db = new clsDBHelper


		'라운드 + 설정된 난이율정보
		fld = "a.idx,tidx, lidx"
		SQL = "select "&fld&" from sd_gameMember_roundRecord as a left join tblGameCode as b on a.gamecodeseq = b.seq where    midx =  " & midx & " and a.gameround = " & gameroundno
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			j_idx = rs(0)
      tidx = rs(1)
      lidx = rs(2)
		End If

		'난의율 코드 정보
		strSql = "SELECT SEQ,CDA,CDC,title,CODE1,CODE2,CODE3,CODE4,codename   FROM tblGameCode  WHERE delyn = 'N' and CDA = 'E2'  and CDC = '"&cdc&"' and CODE1 like '"&FINDSTR&"%'  order by CODE1"
		Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
		If Not rs.EOF Then
			arrC = rs.GetRows()
		End If

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>

<table  class="table table-bordered table-hover" style="margin:0px;">  
  <tbody  class="gametitle">
      <%
        If IsArray(arrC) Then 

                If IsArray(arrC) Then 
                  For c = LBound(arrC, 2) To UBound(arrC, 2)
                    r_idx = arrC(0, c)
                    r_cda = arrC(1, c)
                    r_cdc = arrC(2, c)
                    r_title = arrC(3, c)
                    r_code1 = arrC(4, c) '다이브번호
                    r_code2 = arrC(5, c) '다이브높이
                    r_code3 = arrC(6, c) '자세
                    r_code4 = arrC(7, c) '난이율
                    r_codename = arrC(8,c)
                    %>
                    <tr>
                    <td  style="text-align:left;padding-left:5px;">
                    [ 번호:<%=r_code1%> ]&nbsp;자세:<%=r_code3%>&nbsp;높이 &nbsp;<%=r_code2%>(<%=r_codename%>)&nbsp;난이율:<%=r_code4%>
                    </td>
                    <td><a href="javascript:mx.setGamePer(<%=j_idx%>, <%=r_idx%>  ,<%=tidx%>,<%=lidx%>,<%=midx%>)" class="btn">등록</a>
                    </td>
                    </tr>
                    <%
                  Next
                End If
        End if		
      %>

  </tbody>
</table>



